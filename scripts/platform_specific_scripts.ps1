# install-hyperv-dev-tools.ps1
Write-Output "Installing development tools for Hyper-V..."

# Core development tools
choco install -y git
choco install -y nodejs --version 18.17.0
choco install -y python3
choco install -y vscode
choco install -y docker-desktop
choco install -y notepadplusplus
choco install -y 7zip
choco install -y googlechrome
choco install -y firefox
choco install -y postman

# Cloud and DevOps tools
choco install -y azure-cli
choco install -y terraform
choco install -y kubernetes-cli
choco install -y helm
choco install -y awscli

# Database tools
choco install -y sql-server-management-studio
choco install -y dbeaver

# Hyper-V specific tools
choco install -y powershell-core
choco install -y hyper-v-powershell

# Enable Hyper-V features
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart

Write-Output "Hyper-V development tools installed"

# install-virtualbox-guest-additions.ps1
Write-Output "Installing VirtualBox Guest Additions..."
$GuestAdditionsISO = "C:\Users\Administrator\VBoxGuestAdditions.iso"

# Mount the Guest Additions ISO if it exists
if (Test-Path $GuestAdditionsISO) {
    Mount-DiskImage -ImagePath $GuestAdditionsISO
    $DriveLetter = (Get-DiskImage -ImagePath $GuestAdditionsISO | Get-Volume).DriveLetter
    & "${DriveLetter}:\VBoxWindowsAdditions.exe" /S
    Start-Sleep -Seconds 60
    Dismount-DiskImage -ImagePath $GuestAdditionsISO
    Write-Output "VirtualBox Guest Additions installed"
} else {
    Write-Output "Guest Additions ISO not found, installing via Chocolatey..."
    choco install -y virtualbox-guest-additions-guest.install
}

# install-virtualbox-dev-tools.ps1
Write-Output "Installing development tools for VirtualBox..."

# Core development tools
choco install -y git
choco install -y nodejs --version 18.17.0
choco install -y python3
choco install -y vscode
choco install -y notepadplusplus
choco install -y 7zip
choco install -y googlechrome
choco install -y firefox
choco install -y postman

# VirtualBox doesn't support nested virtualization well, skip Docker Desktop
Write-Output "Skipping Docker Desktop for VirtualBox - use Docker Toolbox or remote Docker instead"

# Cloud and DevOps tools
choco install -y azure-cli
choco install -y terraform
choco install -y kubernetes-cli
choco install -y helm
choco install -y awscli

# Database tools
choco install -y sql-server-management-studio
choco install -y dbeaver

# VirtualBox-specific tools
choco install -y powershell-core

Write-Output "VirtualBox development tools installed"

# configure-hyperv-windows.ps1
Write-Output "Configuring Windows for Hyper-V environment..."

# Standard Windows configuration
Set-MpPreference -DisableRealtimeMonitoring $true
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0

# Hyper-V specific optimizations
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\IntcDAud" -Name "Start" -Value 4 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableVirtualization" -Value 1

# Enable nested virtualization support
bcdedit /set hypervisorlaunchtype auto
bcdedit /set nx OptIn

# Configure power settings for VM
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0

Write-Output "Hyper-V Windows configuration completed"

# configure-virtualbox-windows.ps1
Write-Output "Configuring Windows for VirtualBox environment..."

# Standard Windows configuration
Set-MpPreference -DisableRealtimeMonitoring $true
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0

# VirtualBox specific optimizations
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\VBoxGuest" -Name "Start" -Value 2 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\VBoxSF" -Name "Start" -Value 2 -ErrorAction SilentlyContinue

# Optimize for VirtualBox performance
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "DisablePagingExecutive" -Value 1

# Configure display settings for VirtualBox
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothing" -Value "2"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothingType" -Value 2

Write-Output "VirtualBox Windows configuration completed"

# install-wsl-hyperv.ps1
Write-Output "Installing WSL for Hyper-V..."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Download and install WSL2 kernel update
$wslUpdateUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
$wslUpdatePath = "$env:TEMP\wsl_update_x64.msi"
Invoke-WebRequest -Uri $wslUpdateUrl -OutFile $wslUpdatePath
Start-Process msiexec.exe -ArgumentList "/i $wslUpdatePath /quiet" -Wait
Remove-Item $wslUpdatePath

Write-Output "WSL installed for Hyper-V"

# install-wsl-virtualbox.ps1  
Write-Output "Installing WSL for VirtualBox..."
# Note: WSL2 may not work well in VirtualBox, install WSL1 instead
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Set WSL default version to 1 for VirtualBox compatibility
wsl --set-default-version 1

Write-Output "WSL1 installed for VirtualBox compatibility"

# hyperv-cleanup.ps1
Write-Output "Running Hyper-V specific cleanup..."

# Standard cleanup
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:WINDIR\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clear Hyper-V logs
wevtutil cl "Microsoft-Windows-Hyper-V-Hypervisor/Operational"
wevtutil cl "Microsoft-Windows-Hyper-V-VmSwitch/Operational" 

# Optimize for Hyper-V
Optimize-Volume -DriveLetter C -Defrag -Verbose
sfc /scannow

Write-Output "Hyper-V cleanup completed"

# virtualbox-cleanup.ps1
Write-Output "Running VirtualBox specific cleanup..."

# Standard cleanup
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue  
Remove-Item -Path "$env:WINDIR\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# VirtualBox specific cleanup
Remove-Item -Path "C:\Users\Administrator\VBoxGuestAdditions.iso" -Force -ErrorAction SilentlyContinue

# Optimize disk for export
Optimize-Volume -DriveLetter C -Defrag -Verbose

# Zero out free space to reduce image size
Write-Output "Zeroing free space to reduce image size..."
fsutil file createnew C:\zero.tmp 104857600
sdelete -z c: -accepteula
Remove-Item -Path "C:\zero.tmp" -Force -ErrorAction SilentlyContinue

Write-Output "VirtualBox cleanup completed"