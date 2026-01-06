#!/usr/bin/env python3
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

target = Path(__file__).resolve().parent / "view_generate_demo.py"
raise SystemExit(subprocess.call([sys.executable, str(target), *sys.argv[1:]]))
