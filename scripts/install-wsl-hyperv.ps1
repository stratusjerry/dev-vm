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
