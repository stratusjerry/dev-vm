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
