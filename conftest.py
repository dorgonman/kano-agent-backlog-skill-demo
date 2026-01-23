from __future__ import annotations


def pytest_configure(config) -> None:
    """Redirect Hypothesis' local database under `_kano/backlog/_tmp_tests/`.

    This repo is a demo workspace; we keep derived test artifacts out of repo root.
    """

    try:
        from pathlib import Path

        from hypothesis import settings
        from hypothesis.database import DirectoryBasedExampleDatabase
    except Exception:
        return

    db_dir = Path("_kano/backlog/_tmp_tests/hypothesis")
    db_dir.mkdir(parents=True, exist_ok=True)

    settings.register_profile(
        "kano-demo",
        database=DirectoryBasedExampleDatabase(db_dir),
    )
    settings.load_profile("kano-demo")

