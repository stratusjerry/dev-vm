# install-virtualbox-dev-tools.ps1
Write-Output "Installing development tools for VirtualBox..."

# Core development tools
choco install -y git
#choco install -y nodejs-lts
choco install -y python3
choco install -y vscode
choco install -y notepadplusplus
choco install -y 7zip
choco install -y googlechrome
choco install -y firefox

# VirtualBox doesn't support nested virtualization well, skip Docker Desktop
Write-Output "Skipping Docker Desktop for VirtualBox - use Docker Toolbox or remote Docker instead"

# Cloud and DevOps tools
choco install -y terraform
choco install -y kubernetes-cli
choco install -y helm
choco install -y awscli

# Database tools
#choco install -y sql-server-management-studio

# VirtualBox-specific tools
choco install -y powershell-core

Write-Output "VirtualBox development tools installed"
