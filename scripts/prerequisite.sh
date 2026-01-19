#!/usr/bin/env bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

install_oh_my_opencode() {
    print_info "Checking oh-my-opencode installation..."

    if command -v oh-my-opencode &> /dev/null; then
        local current_version=$(npm list -g oh-my-opencode 2>&1 | grep oh-my-opencode | sed 's/.*oh-my-opencode@//')
        print_info "oh-my-opencode is already installed (version: $current_version)"
        print_info "Updating to latest version..."

        npm install -g oh-my-opencode@latest

        local new_version=$(npm list -g oh-my-opencode 2>&1 | grep oh-my-opencode | sed 's/.*oh-my-opencode@//')
        print_success "oh-my-opencode updated to version: $new_version"
    else
        print_info "Installing oh-my-opencode..."
        npm install -g oh-my-opencode@latest
        local version=$(npm list -g oh-my-opencode 2>&1 | grep oh-my-opencode | sed 's/.*oh-my-opencode@//')
        print_success "oh-my-opencode installed (version: $version)"
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

    install_kano_skill
    echo ""

    if ! check_npm; then
        exit 1
    fi
    echo ""

    install_oh_my_opencode
    echo ""

    check_vscode_extension
    echo ""

    print_info "========================================"
    print_success "Prerequisites setup completed!"
    print_info "========================================"
    echo ""
    print_info "Next steps:"
    print_info "1. Initialize submodules: git submodule update --init --recursive"
    print_info "2. Verify installation: kano-backlog --help"
    print_info "3. Initialize backlog: kano-backlog backlog init --product <name> --agent <id>"
}

main
