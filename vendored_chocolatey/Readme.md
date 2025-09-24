Contents
===

## [./chocolatey.2.5.1.nupkg](./chocolatey.2.5.1.nupkg) 
Downloaded from https://community.chocolatey.org/api/v2/package/chocolatey

Install Pre-Reqs may include
```powershell
Install-Package -Name ".\chocolatey.2.5.1.nupkg" -Force
# Debug for if above fails
Unblock-File .\chocolatey.2.5.1.nupkg
set-executionpolicy remotesigned
mv .\chocolatey.2.5.1.nupkg .\chocolatey.2.5.1.nupkg.zip
mkdir .\extract\
Expand-Archive -Path .\chocolatey.2.5.1.nupkg.zip -DestinationPath .\extract\
rm .\extract\*.nuspec
# Option 1 local install
cd .\extract\tools\
.\chocolateyInstall.ps1
# Option 2 Copy to Modules Folder
Copy-Item -Path .\extract\ -Destination "$env:USERPROFILE\Documents\WindowsPowerShell\Modules" -Recurse

```

## [./install.ps1](./install.ps1) 
Downloaded from https://community.chocolatey.org/install.ps1

Install Pre-Reqs may include
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
