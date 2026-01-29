#!/usr/bin/env bash

have_cmd() { command -v "$1" >/dev/null 2>&1; }

ensure_kano_opencode_quickstart() {
  local repo_root="$1"
  local target="${repo_root}/../kano-opencode-quickstart"
  local url="https://github.com/dorgonman/kano-opencode-quickstart.git"

  if ! have_cmd git; then
    echo "ERROR: 'git' not found in PATH; cannot clone/update kano-opencode-quickstart." >&2
    exit 2
  fi

  if [[ -d "${target}/.git" ]]; then
    git -C "$target" fetch --prune origin 1>&2

    local branch=""
    branch="$(git -C "$target" symbolic-ref --short -q HEAD 2>/dev/null || true)"
    if [[ -z "$branch" ]]; then
      git -C "$target" checkout -q main 1>&2
    fi

    git -C "$target" pull --ff-only 1>&2
    printf "%s\n" "$target"
    return 0
  fi

  if [[ -e "$target" ]]; then
    echo "ERROR: path exists but is not a git repo: $target" >&2
    exit 2
  fi

  git clone "$url" "$target" 1>&2
  printf "%s\n" "$target"
}
