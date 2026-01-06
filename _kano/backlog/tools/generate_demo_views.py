#!/usr/bin/env python3
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path
from typing import List

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
from config_loader import (  # noqa: E402
    allowed_roots_for_repo,
    resolve_allowed_root,
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Generate demo dashboards for DBIndex vs NoDBIndex modes under "
            "`<backlog-root>/views/_demo/`."
        )
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
        "--refresh-index",
        choices=["auto", "skip", "rebuild", "incremental"],
        default="auto",
        help="Whether to refresh the SQLite index before rendering DBIndex demos (default: auto).",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print commands without executing.",
    )
    return parser.parse_args()


def ensure_under_allowed(path: Path, allowed_roots: List[Path], label: str) -> Path:
    root = resolve_allowed_root(path, allowed_roots)
    if root is None:
        allowed = " or ".join(str(root) for root in allowed_roots)
        raise SystemExit(f"{label} must be under {allowed}: {path}")
    return root


def run_cmd(cmd: List[str], dry_run: bool) -> None:
    if dry_run:
        print("[DRY] " + " ".join(cmd))
        return
    result = subprocess.run(cmd, cwd=str(REPO_ROOT))
    if result.returncode != 0:
        raise SystemExit(f"Command failed: {' '.join(cmd)}")


def main() -> int:
    args = parse_args()
    agent = args.agent

    # This tool is intentionally just a convenience wrapper for the demo host repo.
    # The self-contained implementation lives in the skill:
    #   `skills/kano-agent-backlog-skill/scripts/backlog/generate_demo_views.py`

    allowed_roots = allowed_roots_for_repo(REPO_ROOT)

    backlog_root = Path(args.backlog_root)
    if not backlog_root.is_absolute():
        backlog_root = (REPO_ROOT / backlog_root).resolve()
    ensure_under_allowed(backlog_root, allowed_roots, "backlog-root")

    python = sys.executable
    generator = REPO_ROOT / "skills" / "kano-agent-backlog-skill" / "scripts" / "backlog" / "generate_demo_views.py"
    cmd = [
        python,
        str(generator),
        "--backlog-root",
        str(backlog_root),
        "--agent",
        agent,
        "--refresh-index",
        args.refresh_index,
    ]
    if args.config:
        cmd.extend(["--config", args.config])
    if args.dry_run:
        cmd.append("--dry-run")
    run_cmd(cmd, dry_run=False)

    return 0


if __name__ == "__main__":
    raise SystemExit(run_with_audit(main))
