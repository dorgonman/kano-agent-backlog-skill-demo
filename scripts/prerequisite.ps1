$ErrorActionPreference = "Stop"

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Get-PythonCommand {
    $venvPython = ".venv/Scripts/python.exe"

    if (Test-Path $venvPython) {
        return $venvPython
    }

    $pythonPath = Get-Command python -ErrorAction SilentlyContinue

    if ($pythonPath) {
        return "python"
    }

    return $null
}

function Test-PythonInstalled {
    Write-Info "Checking Python installation..."

    $pythonCmd = Get-PythonCommand

    if (-not $pythonCmd) {
        Write-Error "Python is not installed. Please install Python 3.10+ first."
        Write-Info "Visit: https://www.python.org/downloads/"
        return $false
    }

    try {
        $pythonVersion = & $pythonCmd --version 2>&1
        Write-Success "Python is installed ($pythonVersion)"

        $versionMatch = $pythonVersion -match "Python (\d+)\.(\d+)"
        if ($versionMatch) {
            $major = [int]$matches[1]
            $minor = [int]$matches[2]

            if ($major -eq 3 -and $minor -ge 10) {
                Write-Success "Python version meets requirement (>= 3.10)"
                return $true
            }
            else {
                Write-Error "Python version $pythonVersion is too old (requires >= 3.10)"
                Write-Info "Visit: https://www.python.org/downloads/"
                return $false
            }
        }
        else {
            Write-Error "Failed to parse Python version"
            return $false
        }
    }
    catch {
        Write-Error "Failed to get Python version."
        return $false
    }
}

function Test-PipAvailable {
    Write-Info "Checking pip installation..."

    $pythonCmd = Get-PythonCommand

    try {
        $pipVersion = & $pythonCmd -m pip --version 2>&1
        Write-Success "pip is available ($pipVersion)"
        return $true
    }
    catch {
        Write-Error "pip is not available. Please install pip first."
        return $false
    }
}

function Install-KanoSkill {
    Write-Info "Installing kano-agent-backlog-skill..."

    $skillPath = "skills/kano-agent-backlog-skill"
    $pythonCmd = Get-PythonCommand

    if (-not (Test-Path $skillPath)) {
        Write-Error "Skill directory not found: $skillPath"
        Write-Info "Make sure you're in the repository root and submodules are initialized."
        return $false
    }

    try {
        & $pythonCmd -m pip install -e $skillPath
        Write-Success "kano-agent-backlog-skill installed"

        Write-Info "Verifying installation..."
        $kanoCommand = Get-Command kano-backlog -ErrorAction SilentlyContinue
        if ($kanoCommand) {
            Write-Success "kano-backlog CLI is available"
        }
        else {
            Write-Warning "kano-backlog CLI may not be in PATH. Try: $pythonCmd -m kano_backlog_cli --help"
        }
    }
    catch {
        Write-Error "Failed to install kano-agent-backlog-skill: $_"
        return $false
    }
}

function Test-NpmInstalled {
    Write-Info "Checking npm installation..."

    $npmPath = Get-Command npm -ErrorAction SilentlyContinue

    if ($npmPath) {
        try {
            $npmVersion = & $npmPath --version 2>&1
            Write-Success "npm is installed (version: $npmVersion)"
            return $true
        }
        catch {
            Write-Error "Failed to get npm version."
            return $false
        }
    }
    else {
        Write-Error "npm is not installed. Please install Node.js and npm first."
        Write-Info "Visit: https://nodejs.org/"
        return $false
    }
}

function Install-OhMyOpencode {
    Write-Info "Checking oh-my-opencode installation..."

    try {
        $currentVersion = & npm list -g oh-my-opencode 2>&1 | Select-String "oh-my-opencode@" | ForEach-Object {
            $_.ToString() -replace ".*oh-my-opencode@", ""
        }

        if ($currentVersion) {
            Write-Info "oh-my-opencode is already installed (version: $currentVersion)"
            Write-Info "Updating to latest version..."
            & npm install -g oh-my-opencode@latest

            $newVersion = & npm list -g oh-my-opencode 2>&1 | Select-String "oh-my-opencode@" | ForEach-Object {
                $_.ToString() -replace ".*oh-my-opencode@", ""
            }
            Write-Success "oh-my-opencode updated to version: $newVersion"
        }
        else {
            throw "Not installed"
        }
    }
    catch {
        Write-Info "Installing oh-my-opencode..."
        & npm install -g oh-my-opencode@latest

        $version = & npm list -g oh-my-opencode 2>&1 | Select-String "oh-my-opencode@" | ForEach-Object {
            $_.ToString() -replace ".*oh-my-opencode@", ""
        }
        Write-Success "oh-my-opencode installed (version: $version)"
    }
}

function Test-VSCodeExtension {
    Write-Info "Checking VS Code opencode extension..."

    try {
        $extensions = & code --list-extensions 2>&1 | Select-String -Pattern "opencode" -CaseSensitive:$false

        if ($extensions) {
            Write-Success "VS Code opencode extension is installed: $extensions"
        }
        else {
            Write-Warning "VS Code opencode extension is not installed."
            Write-Info "To install, run: code --install-extension sst-dev.opencode"
        }
    }
    catch {
        Write-Warning "VS Code command 'code' not found. Skipping extension check."
    }
}

function Main {
    Write-Info "========================================"
    Write-Info "Prerequisites Setup"
    Write-Info "========================================"
    Write-Host ""

    if (-not (Test-PythonInstalled)) {
        exit 1
    }
    Write-Host ""

    if (-not (Test-PipAvailable)) {
        exit 1
    }
    Write-Host ""

    Install-KanoSkill
    Write-Host ""

    if (-not (Test-NpmInstalled)) {
        exit 1
    }
    Write-Host ""

    Install-OhMyOpencode
    Write-Host ""

    Test-VSCodeExtension
    Write-Host ""

    Write-Info "========================================"
    Write-Success "Prerequisites setup completed!"
    Write-Info "========================================"
    Write-Host ""
    Write-Info "Next steps:"
    Write-Info "1. Initialize submodules: git submodule update --init --recursive"
    Write-Info "2. Verify installation: kano-backlog --help"
    Write-Info "3. Initialize backlog: kano-backlog backlog init --product <name> --agent <id>"
}

Main
