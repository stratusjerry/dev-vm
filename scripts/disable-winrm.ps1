# disable-winrm.ps1
Write-Output "==> Disabling WinRM after Packer build..."

# Remove firewall rules
Write-Output "Removing WinRM firewall rules..."
netsh advfirewall firewall delete rule name="WinRM-HTTP"
netsh advfirewall firewall delete rule name="WinRM-HTTPS"
netsh advfirewall firewall set rule group="remote administration" new enable=no

# Disable WinRM
Write-Output "Disabling WinRM service..."
Disable-PSRemoting -Force

# Stop and disable the WinRM service
Write-Output "Stopping WinRM service..."
Stop-Service winrm -Force
Set-Service winrm -StartupType "Disabled"

# Remove WinRM listeners
Write-Output "Removing WinRM listeners..."
winrm delete winrm/config/Listener?Address=*+Transport=HTTP

Write-Output "WinRM has been disabled and secured"
