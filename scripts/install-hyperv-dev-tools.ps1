# install-hyperv-dev-tools.ps1
Write-Output "Installing development tools for Hyper-V..."

# Core development tools
choco install -y git
#choco install -y nodejs --version 18.17.0
#choco install -y nodejs-lts
choco install -y python3
choco install -y vscode
#choco install -y docker-desktop
choco install -y notepadplusplus
choco install -y 7zip
choco install -y googlechrome
choco install -y firefox

# Cloud and DevOps tools
choco install -y terraform
choco install -y kubernetes-cli
choco install -y helm
choco install -y awscli

# Database tools
#choco install -y sql-server-management-studio

# Hyper-V specific tools
#choco install -y powershell-core
#choco install -y hyper-v-powershell

# Enable Hyper-V features
#Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
#Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -All -NoRestart
#Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart

#Write-Output "Hyper-V development tools installed"
