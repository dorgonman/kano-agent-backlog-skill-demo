#!/usr/bin/env python3
from __future__ import annotations

import runpy
from pathlib import Path


def main() -> int:
    script_dir = Path(__file__).resolve().parent
    repo_root = script_dir.parents[3]
    target = repo_root / "skills/kano-agent-backlog-skill/scripts/fs/rm_file.py"
    if not target.exists():
        raise SystemExit(f"Script not found: {target}")
    runpy.run_path(str(target), run_name="__main__")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
