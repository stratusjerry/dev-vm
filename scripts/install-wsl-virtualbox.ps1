# install-wsl-virtualbox.ps1  
Write-Output "Installing WSL for VirtualBox..."
# Note: WSL2 may not work well in VirtualBox, install WSL1 instead
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Set WSL default version to 1 for VirtualBox compatibility
wsl --set-default-version 1

Write-Output "WSL1 installed for VirtualBox compatibility"
