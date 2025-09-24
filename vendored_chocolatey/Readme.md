Contents
===

## [./chocolatey.2.5.1.nupkg](./chocolatey.2.5.1.nupkg) 
Downloaded from https://community.chocolatey.org/api/v2/package/chocolatey

Install Pre-Reqs may include
```powershell
Install-Package -Name "chocolatey.2.5.1.nupkg" -Force
```

## [./install.ps1](./install.ps1) 
Downloaded from https://community.chocolatey.org/install.ps1

Install Pre-Reqs may include
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
