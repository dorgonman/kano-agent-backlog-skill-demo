#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime
import shutil
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Move a file to a trash bin, then optionally delete it."
    )
    parser.add_argument("--path", required=True, help="File path to trash.")
    parser.add_argument(
        "--trash-root",
        default="_kano/backlog/_trash",
        help="Trash root (default: _kano/backlog/_trash).",
    )
    parser.add_argument(
        "--keep",
        action="store_true",
        help="Keep the trashed copy (skip delete attempt).",
    )
    parser.add_argument("--dry-run", action="store_true", help="Print actions only.")
    return parser.parse_args()


def resolve_path(value: str, repo_root: Path) -> Path:
    path = Path(value)
    if not path.is_absolute():
        path = (repo_root / path).resolve()
    return path


def main() -> int:
    args = parse_args()
    script_dir = Path(__file__).resolve().parent
    repo_root = script_dir.parents[2]

    src = resolve_path(args.path, repo_root)
    if not src.exists():
        raise SystemExit(f"Path not found: {src}")
    if not src.is_file():
        raise SystemExit(f"Only files are supported: {src}")

    try:
        rel = src.relative_to(repo_root)
    except ValueError:
        raise SystemExit("Path must be inside the repo root.")

    trash_root = resolve_path(args.trash_root, repo_root)
    stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    dest = trash_root / stamp / rel

    if args.dry_run:
        print(f"[DRY] move {src} -> {dest}")
        print("[DRY] delete trashed copy (unless --keep)")
        return 0

    dest.parent.mkdir(parents=True, exist_ok=True)

    try:
        shutil.move(str(src), str(dest))
        print(f"Moved to trash: {dest}")
    except Exception as exc:
        raise SystemExit(f"Move failed: {exc}")

    if args.keep:
        return 0

    try:
        dest.unlink()
        print(f"Deleted trashed copy: {dest}")
    except Exception as exc:
        print(f"Delete failed (trash copy): {dest} ({exc})")
        print("Manual delete required for the trashed copy.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
