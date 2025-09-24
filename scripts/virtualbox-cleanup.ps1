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