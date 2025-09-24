# enable-winrm.ps1
Write-Output "==> Enabling WinRM for Packer communication..."

# Configure network profile to private (required for WinRM)
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

# Enable WinRM service
Write-Output "Enabling WinRM service..."
Enable-PSRemoting -SkipNetworkProfileCheck -Force

# Configure WinRM settings
Write-Output "Configuring WinRM settings..."
winrm quickconfig -q
winrm quickconfig -transport:http

# Set WinRM configuration
Write-Output "Setting WinRM configuration..."
winrm set "winrm/config" '@{MaxTimeoutms="1800000"}'
winrm set "winrm/config/winrs" '@{MaxMemoryPerShellMB="1024"}'
winrm set "winrm/config/service" '@{AllowUnencrypted="true"}'
winrm set "winrm/config/client" '@{AllowUnencrypted="true"}'
winrm set "winrm/config/service/auth" '@{Basic="true"}'
winrm set "winrm/config/client/auth" '@{Basic="true"}'
winrm set "winrm/config/service/auth" '@{CredSSP="true"}'
winrm set "winrm/config/listener?Address=*+Transport=HTTP" '@{Port="5985"}'

# Configure firewall rules
Write-Output "Configuring firewall rules..."
netsh advfirewall firewall set rule group="remote administration" new enable=yes
netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
netsh advfirewall firewall add rule name="WinRM-HTTPS" dir=in localport=5986 protocol=TCP action=allow

# Set service startup type and restart
Write-Output "Starting WinRM service..."
Set-Service winrm -StartupType "Automatic"
Restart-Service winrm

# Verify WinRM is working
Write-Output "Testing WinRM configuration..."
$winrmTest = Test-WSMan -ComputerName localhost -ErrorAction SilentlyContinue
if ($winrmTest) {
    Write-Output "WinRM is configured and working!"
} else {
    Write-Output "WARNING: WinRM test failed"
}

Write-Output "WinRM setup completed"
