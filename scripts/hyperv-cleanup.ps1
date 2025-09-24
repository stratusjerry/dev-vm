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
