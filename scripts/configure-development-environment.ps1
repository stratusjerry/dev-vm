# configure-development-environment.ps1
Write-Output "==> Configuring development environment..."

# Install Windows Terminal
Write-Output "Installing Windows Terminal..."
choco install -y microsoft-windows-terminal

# Install additional development utilities
Write-Output "Installing additional development tools..."
choco install -y fiddler
choco install -y wireshark
choco install -y redis-desktop-manager
choco install -y robo3t
choco install -y dbeaver
choco install -y filezilla
choco install -y putty
choco install -y winscp
choco install -y sysinternals

# Install PowerShell modules
Write-Output "Installing PowerShell modules..."
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

$PowerShellModules = @(
    'Az',
    'ImportExcel',
    'PSReadLine',
    'Posh-Git',
    'PowerShellGet',
    'PackageManagement'
)

foreach ($Module in $PowerShellModules) {
    Write-Output "Installing PowerShell module: $Module"
    Install-Module -Name $Module -AllowClobber -Scope AllUsers -Force -ErrorAction SilentlyContinue
}

# Configure Git (global settings)
Write-Output "Configuring Git..."
git config --global user.name "Developer"
git config --global user.email "developer@company.com"
git config --global init.defaultBranch main
git config --global core.autocrlf true
git config --global core.editor "code --wait"
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'

# Configure npm global packages
Write-Output "Installing global npm packages..."
$NpmPackages = @(
    '@angular/cli@latest',
    'create-react-app@latest',
    'typescript@latest',
    'eslint@latest',
    'prettier@latest',
    'nodemon@latest',
    'pm2@latest',
    'http-server@latest',
    'live-server@latest',
    'json-server@latest'
)

foreach ($Package in $NpmPackages) {
    Write-Output "Installing npm package: $Package"
    npm install -g $Package
}

# Configure Python packages
Write-Output "Installing Python packages..."
python -m pip install --upgrade pip

$PythonPackages = @(
    'virtualenv',
    'pipenv',
    'jupyter',
    'pandas',
    'numpy',
    'matplotlib',
    'requests',
    'flask',
    'django',
    'fastapi',
    'pytest',
    'black',
    'flake8'
)

foreach ($Package in $PythonPackages) {
    Write-Output "Installing Python package: $Package"
    pip install $Package
}

# Create development directory structure
Write-Output "Creating development directory structure..."
$DevDirs = @(
    "C:\Development",
    "C:\Development\Projects",
    "C:\Development\Tools",
    "C:\Development\Scripts",
    "C:\Development\Workspace",
    "C:\Development\Repositories"
)

foreach ($Dir in $DevDirs) {
    New-Item -ItemType Directory -Path $Dir -Force
    Write-Output "Created directory: $Dir"
}

# Set environment variables
Write-Output "Setting environment variables..."
[System.Environment]::SetEnvironmentVariable("DEVELOPMENT_ROOT", "C:\Development", "Machine")
[System.Environment]::SetEnvironmentVariable("NODE_ENV", "development", "Machine")
[System.Environment]::SetEnvironmentVariable("PYTHONPATH", "C:\Development\Scripts", "Machine")

# Create a development PowerShell profile
Write-Output "Creating PowerShell development profile..."
$ProfileContent = @"
# Development PowerShell Profile
Write-Host "Development Environment Loaded!" -ForegroundColor Green

# Import modules
Import-Module Posh-Git -ErrorAction SilentlyContinue

# Set aliases
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name grep -Value Select-String
Set-Alias -Name which -Value Get-Command

# Functions
function dev { Set-Location C:\Development }
function projects { Set-Location C:\Development\Projects }
function repos { Set-Location C:\Development\Repositories }

# Display environment info
function devinfo {
    Write-Host "Development Environment Information:" -ForegroundColor Yellow
    Write-Host "Node.js version: " -NoNewline; node --version
    Write-Host "Python version: " -NoNewline; python --version
    Write-Host "Git version: " -NoNewline; git --version
    Write-Host "Development root: $env:DEVELOPMENT_ROOT"
}

# Quick project starter
function newproject([string]$name, [string]$type = "basic") {
    $projectPath = "C:\Development\Projects\$name"
    New-Item -ItemType Directory -Path $projectPath -Force
    Set-Location $projectPath
    
    switch ($type) {
        "react" { npx create-react-app . }
        "angular" { ng new . --skip-install }
        "node" { npm init -y }
        "python" { python -m venv venv; New-Item -ItemType File -Path "requirements.txt" }
        default { 
            New-Item -ItemType File -Path "README.md"
            Add-Content -Path "README.md" -Value "# $name`n`nProject created on $(Get-Date)"
        }
    }
    
    Write-Host "Project '$name' created at $projectPath" -ForegroundColor Green
}

Write-Host "Type 'devinfo' for environment information" -ForegroundColor Cyan
"@

$ProfilePath = "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
New-Item -ItemType Directory -Path (Split-Path $ProfilePath) -Force
Set-Content -Path $ProfilePath -Value $ProfileContent

# Configure Windows Terminal settings (if installed)
$TerminalSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path (Split-Path $TerminalSettingsPath)) {
    Write-Output "Configuring Windows Terminal..."
    
    $TerminalConfig = @{
        'defaultProfile' = '{574e775e-4f2a-5b96-ac1e-a2962a402336}'
        'profiles' = @{
            'defaults' = @{
                'fontFace' = 'Cascadia Code'
                'fontSize' = 11
                'colorScheme' = 'Campbell Powershell'
            }
        }
        'schemes' = @()
    }
    
    $TerminalConfig | ConvertTo-Json -Depth 10 | Set-Content -Path $TerminalSettingsPath -Force
}

Write-Output "Development environment configuration completed!"
Write-Output ""
Write-Output "==> Installed Tools Summary:"
Write-Output "  - Git with VS Code integration"
Write-Output "  - Node.js with popular global packages"
Write-Output "  - Python with development packages"
Write-Output "  - PowerShell with development profile"
Write-Output "  - Windows Terminal (if available)"
Write-Output ""
Write-Output "==> Development Shortcuts:"
Write-Output "  - Type 'dev' to go to C:\Development"
Write-Output "  - Type 'devinfo' for environment info"
Write-Output "  - Type 'newproject myapp react' to create a React project"
