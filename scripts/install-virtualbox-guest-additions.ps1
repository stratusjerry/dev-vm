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
