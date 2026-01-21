#!/usr/bin/env bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd -P)"

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

usage() {
    cat <<EOF
Usage:
  $(basename "$0") [install|check] [--no-opencode] [--no-oh-my-opencode] [--no-kano-skill]

Notes:
  - Can be run from any directory; it will 'cd' to repo root automatically.
  - OpenCode UI may require Bun. If you saw:
      {"name":"BunInstallFailedError",...}
    run:
      $(basename "$0") install
EOF
}

have_cmd() { command -v "$1" >/dev/null 2>&1; }

add_path_dir() {
    local dir="${1:-}"
    [ -n "$dir" ] || return 0

    case ":$PATH:" in
        *":$dir:"*) return 0 ;;
        *) export PATH="$dir:$PATH" ;;
    esac
}

to_unix_path() {
    local p="${1:-}"
    [ -n "$p" ] || return 1

    if have_cmd cygpath; then
        cygpath -u "$p"
        return 0
    fi

    # Best-effort fallback (covers C:\ -> /c/ for Git Bash/MSYS).
    printf "%s\n" "$p" | sed -E 's#^([A-Za-z]):#/\L\\1#; s#\\\\#/#g'
}

resolve_bun_cmd() {
    if have_cmd bun; then
        echo "bun"
        return 0
    fi

    # Common bun locations (Git Bash / MSYS)
    if [ -n "${HOME:-}" ]; then
        [ -x "${HOME}/.bun/bin/bun" ] && { echo "${HOME}/.bun/bin/bun"; return 0; }
        [ -x "${HOME}/.bun/bin/bun.exe" ] && { echo "${HOME}/.bun/bin/bun.exe"; return 0; }
    fi

    if [ -n "${USERPROFILE:-}" ]; then
        local win_bun="${USERPROFILE}\\.bun\\bin\\bun.exe"
        if [ -f "$win_bun" ]; then
            local unix_bun
            unix_bun="$(to_unix_path "$win_bun")"
            [ -x "$unix_bun" ] && { echo "$unix_bun"; return 0; }
        fi
    fi

    return 1
}

append_line_if_missing() {
    local file="$1"
    local line="$2"
    [ -n "$file" ] || return 0
    [ -n "$line" ] || return 0

    if [ -f "$file" ] && { (command -v rg >/dev/null 2>&1 && rg -nF -- "$line" "$file" >/dev/null 2>&1) || (command -v grep >/dev/null 2>&1 && grep -F -- "$line" "$file" >/dev/null 2>&1); }; then
        return 0
    fi

    mkdir -p "$(dirname "$file")" 2>/dev/null || true
    {
        echo ""
        echo "# Added by kano-agent-backlog-skill-demo scripts/prerequisite.sh"
        echo "$line"
    } >> "$file"
}

ensure_user_bin_shims() {
    local bun_cmd=""
    bun_cmd="$(resolve_bun_cmd || true)"
    [ -n "$bun_cmd" ] || return 0

    local user_bin="${HOME:-}/bin"
    [ -n "$user_bin" ] || return 0
    mkdir -p "$user_bin" 2>/dev/null || true

    # If bun is not directly on PATH, create a shim in ~/bin so shells can find it.
    if ! have_cmd bun; then
        local bun_target="$bun_cmd"
        local bun_link="${user_bin}/bun"

        if ln -sf "$bun_target" "$bun_link" 2>/dev/null; then
            :
        else
            cat > "$bun_link" <<EOF
#!/usr/bin/env bash
exec "$bun_target" "\$@"
EOF
            chmod +x "$bun_link" 2>/dev/null || true
        fi
    fi

    # Make sure current shell can find ~/bin.
    add_path_dir "$user_bin"

    # Persist for bash/zsh if possible (best-effort).
    if [ -n "${BASH_VERSION:-}" ]; then
        append_line_if_missing "${HOME}/.bashrc" 'export PATH="$HOME/bin:$PATH"'
        append_line_if_missing "${HOME}/.bashrc" 'export BUN_INSTALL="$HOME/.bun"'
        append_line_if_missing "${HOME}/.bashrc" 'export PATH="$BUN_INSTALL/bin:$PATH"'
    fi

    if [ -n "${ZSH_VERSION:-}" ]; then
        append_line_if_missing "${HOME}/.zshrc" 'export PATH="$HOME/bin:$PATH"'
        append_line_if_missing "${HOME}/.zshrc" 'export BUN_INSTALL="$HOME/.bun"'
        append_line_if_missing "${HOME}/.zshrc" 'export PATH="$BUN_INSTALL/bin:$PATH"'
    fi

    # Fish users will need manual setup; we do not modify fish config.
    if [ -n "${SHELL:-}" ] && echo "$SHELL" | rg -q "fish"; then
        print_warning "Fish shell detected; add ~/.bun/bin to PATH manually."
    fi
}

detect_python() {
    if [ -f ".venv/Scripts/python.exe" ]; then
        echo ".venv/Scripts/python.exe"
    elif [ -f ".venv/bin/python" ]; then
        echo ".venv/bin/python"
    elif command -v python3 &> /dev/null; then
        echo "python3"
    elif command -v python &> /dev/null; then
        echo "python"
    else
        echo ""
    fi
}

check_python() {
    print_info "Checking Python installation..."
    
    local python_cmd=$(detect_python)
    
    if [ -z "$python_cmd" ]; then
        print_error "Python is not installed. Please install Python 3.10+ first."
        print_info "Visit: https://www.python.org/downloads/"
        return 1
    fi
    
    local python_version=$($python_cmd --version | sed 's/Python //')
    print_success "Python is installed (version: $python_version)"
    
    local major=$(echo $python_version | cut -d. -f1)
    local minor=$(echo $python_version | cut -d. -f2)
    
    if [ "$major" -eq 3 ] && [ "$minor" -ge 10 ]; then
        print_success "Python version meets requirement (>= 3.10)"
        return 0
    else
        print_error "Python version $python_version is too old (requires >= 3.10)"
        print_info "Visit: https://www.python.org/downloads/"
        return 1
    fi
}

check_pip() {
    print_info "Checking pip installation..."
    
    local python_cmd=$(detect_python)
    
    if $python_cmd -m pip --version &> /dev/null; then
        local pip_version=$($python_cmd -m pip --version)
        print_success "pip is available ($pip_version)"
        return 0
    else
        print_error "pip is not available. Please install pip first."
        return 1
    fi
}

install_kano_skill() {
    print_info "Installing kano-agent-backlog-skill..."
    
    local skill_path="skills/kano-agent-backlog-skill"
    local python_cmd=$(detect_python)
    
    if [ ! -d "$skill_path" ]; then
        print_error "Skill directory not found: $skill_path"
        print_info "Make sure you're in the repository root and submodules are initialized."
        return 1
    fi
    
    $python_cmd -m pip install -e "$skill_path"
    print_success "kano-agent-backlog-skill installed"
    
    print_info "Verifying installation..."
    if command -v kano-backlog &> /dev/null || $python_cmd -m kano_backlog_cli --help &> /dev/null; then
        print_success "kano-backlog CLI is available"
    else
        print_warning "kano-backlog CLI may not be in PATH. Try: $python_cmd -m kano_backlog_cli --help"
    fi
}

check_npm() {
    print_info "Checking npm installation..."

    if command -v npm &> /dev/null; then
        local npm_version=$(npm --version)
        print_success "npm is installed (version: $npm_version)"
        return 0
    else
        print_error "npm is not installed. Please install Node.js and npm first."
        print_info "Visit: https://nodejs.org/"
        return 1
    fi
}

check_bun() {
    print_info "Checking Bun installation..."

    local bun_cmd=""
    bun_cmd="$(resolve_bun_cmd || true)"

    if [ -n "$bun_cmd" ]; then
        local bun_version
        bun_version="$("$bun_cmd" --version 2>/dev/null || true)"
        print_success "bun is installed (version: ${bun_version:-unknown})"
        return 0
    fi

    print_warning "bun is not installed (required for OpenCode UI on some setups)."
    print_info "We can install it for you (install mode) or follow docs:"
    print_info "  - https://bun.sh/docs/installation"
    return 1
}

install_bun() {
    print_info "Installing Bun..."

    # Windows (Git Bash / MSYS) best effort: use winget if available.
    if command -v winget &> /dev/null; then
        print_info "Using winget..."
        winget install --id Oven-sh.Bun -e || true
    elif command -v brew &> /dev/null; then
        print_info "Using brew..."
        brew install bun || true
    else
        # Official install script (macOS/Linux). Requires network.
        print_info "Using bun official installer (requires network)..."
        if command -v curl &> /dev/null; then
            curl -fsSL https://bun.sh/install | bash || true
        elif command -v wget &> /dev/null; then
            wget -qO- https://bun.sh/install | bash || true
        else
            print_error "Neither winget/brew/curl/wget found; cannot auto-install bun."
            return 1
        fi
    fi

    local bun_cmd=""
    bun_cmd="$(resolve_bun_cmd || true)"

    if [ -n "$bun_cmd" ]; then
        local bun_version
        bun_version="$("$bun_cmd" --version 2>/dev/null || true)"
        print_success "bun installed (version: ${bun_version:-unknown})"

        # Ensure current shell can find bun if installed outside PATH.
        if [ "$bun_cmd" != "bun" ]; then
            add_path_dir "$(dirname "$bun_cmd")"
        fi
        return 0
    fi

    print_warning "bun install command ran, but 'bun' is still not in PATH for this shell."
    print_info "Open a new terminal and re-run this script."
    return 1
}

check_opencode() {
    print_info "Checking OpenCode (opencode) installation..."

    if command -v opencode &> /dev/null; then
        local v
        v="$(opencode --version 2>/dev/null || true)"
        print_success "opencode is installed (${v:-version unknown})"
        return 0
    fi

    print_warning "opencode is not installed."
    return 1
}

install_opencode() {
    print_info "Installing OpenCode (opencode) via bun..."

    local bun_cmd=""
    bun_cmd="$(resolve_bun_cmd || true)"

    if [ -z "$bun_cmd" ]; then
        print_error "bun is required to install opencode (bun global install)."
        print_info "Run: $(basename "$0") install (it will attempt to install bun)"
        return 1
    fi

    # The OpenCode CLI is distributed as the npm package 'opencode-ai'.
    "$bun_cmd" add -g opencode-ai@latest

    if command -v opencode &> /dev/null; then
        local v
        v="$(opencode --version 2>/dev/null || true)"
        print_success "opencode installed (${v:-version unknown})"
        return 0
    fi

    print_warning "opencode install finished, but command is not in PATH for this shell."
    print_info "Try opening a new terminal, then run: opencode --help"
    return 1
}

install_oh_my_opencode() {
    print_info "Checking oh-my-opencode installation..."

    local bun_cmd=""
    bun_cmd="$(resolve_bun_cmd || true)"

    if [ -z "$bun_cmd" ]; then
        print_error "bun is required to install oh-my-opencode (official install flow)."
        print_info "Install Bun first, then re-run: $(basename "$0") install"
        return 1
    fi

    if command -v oh-my-opencode &> /dev/null; then
        print_info "oh-my-opencode is already available in PATH."
        print_info "Updating to latest version via bun..."
    else
        print_info "Installing oh-my-opencode via bun..."
    fi

    "$bun_cmd" add -g oh-my-opencode@latest

    if command -v oh-my-opencode &> /dev/null; then
        print_success "oh-my-opencode is installed and available in PATH."
    else
        print_warning "oh-my-opencode install finished, but command is not in PATH for this shell."
        print_info "Try opening a new terminal, then run: oh-my-opencode --help"
    fi
}

check_vscode_extension() {
    print_info "Checking VS Code opencode extension..."

    if command -v code &> /dev/null; then
        local extension=$(code --list-extensions 2>&1 | grep -i opencode || true)

        if [ -n "$extension" ]; then
            print_success "VS Code opencode extension is installed: $extension"
        else
            print_warning "VS Code opencode extension is not installed."
            print_info "To install, run: code --install-extension sst-dev.opencode"
        fi
    else
        print_warning "VS Code command 'code' not found. Skipping extension check."
    fi
}

main() {
    local action="install"
    local do_oh_my_opencode=1
    local do_opencode=1
    local do_kano_skill=1

    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help) usage; exit 0;;
            install|check) action="$1"; shift;;
            --no-opencode) do_opencode=0; shift;;
            --no-oh-my-opencode|--no-node) do_oh_my_opencode=0; shift;;
            --no-kano-skill) do_kano_skill=0; shift;;
            *) print_error "Unknown arg: $1"; usage; exit 2;;
        esac
    done

    cd "$REPO_ROOT"

    print_info "========================================"
    print_info "Prerequisites Setup"
    print_info "========================================"
    echo ""

    if ! check_python; then
        exit 1
    fi
    echo ""

    if ! check_pip; then
        exit 1
    fi
    echo ""

    if [ "$action" = "install" ] && [ "$do_kano_skill" -eq 1 ]; then
        install_kano_skill
        echo ""
    fi

    if [ "$action" = "install" ]; then
        if ! check_bun; then
            install_bun || true
        fi
        ensure_user_bin_shims || true
    else
        check_bun || true
    fi
    echo ""

    if [ "$do_opencode" -eq 1 ] && [ "$action" = "install" ]; then
        if ! check_opencode; then
            install_opencode || true
        fi
        echo ""
    fi

    if [ "$do_oh_my_opencode" -eq 1 ] && [ "$action" = "install" ]; then
        install_oh_my_opencode || true
        echo ""
        check_vscode_extension
        echo ""
    fi

    print_info "========================================"
    print_success "Prerequisites setup completed!"
    print_info "========================================"
    echo ""
    print_info "Next steps:"
    print_info "1. Initialize submodules: git submodule update --init --recursive"
    print_info "2. Verify installation: kano-backlog --help"
    print_info "3. Initialize backlog: kano-backlog backlog init --product <name> --agent <id>"
}

main "$@"
