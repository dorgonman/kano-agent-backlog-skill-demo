#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime
import os
import sqlite3
import sys
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Tuple

sys.dont_write_bytecode = True


def repo_root_from_this_file() -> Path:
    # <repo>/_kano/backlog/tools/<this_file>
    return Path(__file__).resolve().parents[3]


REPO_ROOT = repo_root_from_this_file()

LOGGING_DIR = REPO_ROOT / "skills" / "kano-agent-backlog-skill" / "scripts" / "logging"
if str(LOGGING_DIR) not in sys.path:
    sys.path.insert(0, str(LOGGING_DIR))
from audit_runner import run_with_audit  # noqa: E402

COMMON_DIR = REPO_ROOT / "skills" / "kano-agent-backlog-skill" / "scripts" / "common"
if str(COMMON_DIR) not in sys.path:
    sys.path.insert(0, str(COMMON_DIR))
from config_loader import get_config_value, load_config_with_defaults, validate_config  # noqa: E402


STATE_GROUPS = {
    "Proposed": "New",
    "Planned": "New",
    "Ready": "New",
    "New": "New",
    "InProgress": "InProgress",
    "Review": "InProgress",
    "Blocked": "InProgress",
    "Done": "Done",
    "Dropped": "Done",
}


def allowed_roots_for_repo(repo_root: Path) -> List[Path]:
    return [
        (repo_root / "_kano" / "backlog").resolve(),
        (repo_root / "_kano" / "backlog_sandbox").resolve(),
    ]


def resolve_allowed_root(path: Path, allowed_roots: List[Path]) -> Optional[Path]:
    resolved = path.resolve()
    for root in allowed_roots:
        try:
            resolved.relative_to(root)
            return root
        except ValueError:
            continue
    return None


def ensure_under_allowed(path: Path, allowed_roots: List[Path], label: str) -> Path:
    root = resolve_allowed_root(path, allowed_roots)
    if root is None:
        allowed = " or ".join(str(root) for root in allowed_roots)
        raise SystemExit(f"{label} must be under {allowed}: {path}")
    return root


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate a project-specific focus view (e.g. last 2 weeks or iteration)."
    )
    parser.add_argument(
        "--backlog-root",
        default="_kano/backlog",
        help="Backlog root path (default: _kano/backlog).",
    )
    parser.add_argument(
        "--config",
        help=(
            "Optional config path override. When omitted, uses KANO_BACKLOG_CONFIG_PATH if set, "
            "otherwise `<backlog-root>/_config/config.json` when present."
        ),
    )
    parser.add_argument(
        "--agent",
        required=True,
        help="Agent identity running the script (required, used for auditability).",
    )
    parser.add_argument(
        "--source",
        choices=["auto", "files", "sqlite"],
        default="auto",
        help="Data source (default: auto).",
    )
    parser.add_argument(
        "--groups",
        default="New,InProgress",
        help="Comma-separated state groups to include (default: New,InProgress).",
    )
    parser.add_argument(
        "--days",
        type=int,
        default=14,
        help="Include items updated within the last N days (default: 14).",
    )
    parser.add_argument(
        "--iteration",
        help="Optional iteration filter (exact match against frontmatter `iteration`).",
    )
    parser.add_argument(
        "--output",
        help="Output markdown path (default: <backlog-root>/views/_demo/Dashboard_Demo_Focus.md).",
    )
    parser.add_argument(
        "--title",
        help="Optional title override.",
    )
    return parser.parse_args()


def resolve_config_for_backlog_root(backlog_root: Path, cli_config: Optional[str]) -> Optional[str]:
    if cli_config is not None:
        return cli_config
    if os.getenv("KANO_BACKLOG_CONFIG_PATH"):
        return None
    candidate = backlog_root / "_config" / "config.json"
    if candidate.exists():
        return str(candidate)
    return None


def resolve_db_path(repo_root: Path, backlog_root: Path, config: Dict[str, object]) -> Path:
    db_path_raw = get_config_value(config, "index.path")
    if not db_path_raw:
        db_path_raw = str((backlog_root / "_index" / "backlog.sqlite3").resolve())
    db_path = Path(str(db_path_raw))
    if not db_path.is_absolute():
        db_path = (repo_root / db_path).resolve()
    return db_path


def strip_quotes(value: str) -> str:
    value = value.strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in ("\"", "'"):
        return value[1:-1]
    return value


def parse_frontmatter(path: Path) -> Dict[str, str]:
    lines = path.read_text(encoding="utf-8").splitlines()
    if not lines or lines[0].strip() != "---":
        return {}
    data: Dict[str, str] = {}
    for line in lines[1:]:
        if line.strip() == "---":
            break
        if ":" not in line:
            continue
        key, raw = line.split(":", 1)
        data[key.strip()] = strip_quotes(raw)
    return data


def parse_date(value: str) -> Optional[datetime.date]:
    value = value.strip()
    if not value:
        return None
    try:
        return datetime.date.fromisoformat(value)
    except ValueError:
        return None


def open_readonly(db_path: Path) -> sqlite3.Connection:
    uri = f"file:{db_path.as_posix()}?mode=ro&immutable=1"
    try:
        conn = sqlite3.connect(uri, uri=True)
    except sqlite3.OperationalError:
        conn = sqlite3.connect(str(db_path))
    conn.execute("PRAGMA query_only = ON")
    return conn


def collect_from_files(
    items_root: Path,
    allowed_groups: List[str],
    since: datetime.date,
    iteration: Optional[str],
) -> List[Tuple[str, str, str, str, Path]]:
    out: List[Tuple[str, str, str, str, Path]] = []
    for path in items_root.rglob("*.md"):
        if path.name == "README.md" or path.name.endswith(".index.md"):
            continue
        data = parse_frontmatter(path)
        item_id = data.get("id", "").strip()
        item_type = data.get("type", "").strip()
        state = data.get("state", "").strip()
        title = data.get("title", "").strip()
        updated_raw = data.get("updated", "").strip()
        updated = parse_date(updated_raw) or parse_date(data.get("created", ""))
        if not item_id or not item_type or not state or not updated:
            continue
        group = STATE_GROUPS.get(state)
        if group not in allowed_groups:
            continue
        if updated < since:
            continue
        if iteration is not None and data.get("iteration", "").strip() != iteration:
            continue
        out.append((item_id, item_type, state, title, path))
    return out


def collect_from_sqlite(
    repo_root: Path,
    db_path: Path,
    allowed_groups: List[str],
    since: datetime.date,
    iteration: Optional[str],
) -> List[Tuple[str, str, str, str, Path]]:
    allowed_states = sorted([state for state, group in STATE_GROUPS.items() if group in allowed_groups])
    params: List[object] = [since.isoformat(), *allowed_states]

    where = ["updated >= ?", f"state IN ({','.join(['?'] * len(allowed_states))})"]
    if iteration is not None:
        where.append("iteration = ?")
        params.append(iteration)

    sql = (
        "SELECT id, type, state, title, source_path "
        "FROM items WHERE "
        + " AND ".join(where)
        + " ORDER BY updated DESC, id ASC"
    )

    out: List[Tuple[str, str, str, str, Path]] = []
    with open_readonly(db_path) as conn:
        rows = conn.execute(sql, params).fetchall()
    for item_id, item_type, state, title, source_path in rows:
        rel = Path(str(source_path or "").replace("\\", "/"))
        out.append((str(item_id), str(item_type), str(state), str(title or ""), (repo_root / rel).resolve()))
    return out


def main() -> int:
    args = parse_args()
    _ = args.agent  # required; recorded via audit log command args

    repo_root = REPO_ROOT
    allowed_roots = allowed_roots_for_repo(repo_root)

    backlog_root = Path(args.backlog_root)
    if not backlog_root.is_absolute():
        backlog_root = (repo_root / backlog_root).resolve()
    ensure_under_allowed(backlog_root, allowed_roots, "backlog-root")

    config_path = resolve_config_for_backlog_root(backlog_root, args.config)
    config = load_config_with_defaults(repo_root=repo_root, config_path=config_path)
    errors = validate_config(config)
    if errors:
        raise SystemExit("Invalid config:\n- " + "\n- ".join(errors))

    items_root = backlog_root / "items"
    ensure_under_allowed(items_root, allowed_roots, "items-root")

    output_path = Path(args.output) if args.output else (backlog_root / "views" / "_demo" / "Dashboard_Demo_Focus.md")
    if not output_path.is_absolute():
        output_path = (repo_root / output_path).resolve()
    ensure_under_allowed(output_path, allowed_roots, "output")
    output_path.parent.mkdir(parents=True, exist_ok=True)

    allowed_groups = [g.strip() for g in args.groups.split(",") if g.strip()]
    since = (datetime.date.today() - datetime.timedelta(days=max(args.days, 0)))

    db_path = resolve_db_path(repo_root, backlog_root, config)
    index_enabled = bool(get_config_value(config, "index.enabled", False))
    use_sqlite = False
    if args.source == "sqlite":
        use_sqlite = True
    elif args.source == "files":
        use_sqlite = False
    else:
        use_sqlite = index_enabled and db_path.exists()

    title = args.title
    if not title:
        parts = [f"Last {args.days} days"]
        if args.iteration:
            parts.append(f"Iteration: {args.iteration}")
        title = "Focus View (Demo) - " + " / ".join(parts)

    if use_sqlite and not db_path.exists():
        raise SystemExit(f"DB does not exist: {db_path}\nRun build_sqlite_index.py first or use --source files.")

    if use_sqlite:
        source_label = f"sqlite:{db_path.as_posix()}"
        rows = collect_from_sqlite(repo_root, db_path, allowed_groups, since, args.iteration)
    else:
        source_label = f"files:{items_root.as_posix()}"
        rows = collect_from_files(items_root, allowed_groups, since, args.iteration)

    lines: List[str] = []
    lines.append(f"# {title}")
    lines.append("")
    lines.append(f"Generated: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M')}")
    lines.append(f"Source: {source_label}")
    lines.append(f"Groups: {', '.join(allowed_groups)}")
    lines.append(f"Since: {since.isoformat()}")
    if args.iteration:
        lines.append(f"Iteration: {args.iteration}")
    lines.append("")

    if not rows:
        lines.append("_No items._")
        lines.append("")
    else:
        out_dir = output_path.parent
        for item_id, item_type, state, title_text, path in rows:
            text = f"{item_id} {title_text}".strip()
            rel = os.path.relpath(path, out_dir).replace("\\", "/")
            lines.append(f"- [{text}]({rel}) (type={item_type} state={state})")
        lines.append("")

    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(run_with_audit(main))
