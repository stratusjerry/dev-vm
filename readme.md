Work In Progress documentation on
How to automate the build/config of a Development environment Virtual Machine

Assumes Host OS is Windows 11 x86_64

From https://developer.hashicorp.com/packer/install download `packer_1.14.2_windows_amd64.zip` and extract the `packer.exe`
```powershell
$zipFile = "packer_1.14.2_windows_amd64.zip"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest "https://releases.hashicorp.com/packer/1.14.2/${zipFile}" -OutFile "$zipFile"
Expand-Archive ".\${zipFile}" .\

```

## Development VMs

### Windows 11 x86_64
From https://www.microsoft.com/en-us/software-download/windows11 download `Win11_24H2_English_x64.iso` and verify the checksum is `B56B911BF18A2CEAEB3904D87E7C770BDF92D3099599D61AC2497B91BF190B11`

```powershell
Get-FileHash C:\Users\Jerry\Downloads\Win11_24H2_English_x64.iso -Algorithm SHA256
```

TODO: Run `packer build`
```powershell
.\packer plugins install github.com/hashicorp/hyperv
mkdir tmp
.\packer build hyperv_packer.json
```
