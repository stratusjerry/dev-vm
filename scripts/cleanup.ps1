# cleanup.ps1
Write-Output "==> Running system cleanup..."

# Clear temporary files
Write-Output "Clearing temporary files..."
$TempDirs = @(
    "$env:TEMP",
    "$env:WINDIR\Temp",
    "$env:WINDIR\Prefetch",
    "$env:LOCALAPPDATA\Temp"
)

foreach ($TempDir in $TempDirs) {
    if (Test-Path $TempDir) {
        Write-Output "Cleaning: $TempDir"
        Remove-Item -Path "$TempDir\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Clear Windows Update cache
Write-Output "Clearing Windows Update cache..."
Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:WINDIR\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv -ErrorAction SilentlyContinue

# Clear event logs
Write-Output "Clearing event logs..."
$LogNames = @('Application', 'Security', 'System', 'Setup')
foreach ($LogName in $LogNames) {
    wevtutil cl $LogName 2>$null
}

# Clear browser caches (if browsers are installed)
Write-Output "Clearing browser caches..."
$ChromeCache = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
$FirefoxProfiles = "$env:APPDATA\Mozilla\Firefox\Profiles"

if (Test-Path $ChromeCache) {
    Remove-Item -Path "$ChromeCache\*" -Recurse -Force -ErrorAction SilentlyContinue
}

if (Test-Path $FirefoxProfiles) {
    Get-ChildItem $FirefoxProfiles | ForEach-Object {
        $CachePath = Join-Path $_.FullName "cache2"
        if (Test-Path $CachePath) {
            Remove-Item -Path "$CachePath\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# Clear package manager caches
Write-Output "Clearing package manager caches..."
if (Get-Command choco -ErrorAction SilentlyContinue) {
    choco cleancache
}

if (Get-Command npm -ErrorAction SilentlyContinue) {
    npm cache clean --force
}

# Defragment and optimize drives
Write-Output "Optimizing drives..."
Get-Volume -DriveLetter C | Optimize-Volume -Defrag -Verbose

# Clean up Windows component store
Write-Output "Cleaning Windows component store..."
Dism /online /Cleanup-Image /StartComponentCleanup /ResetBase

# Run system file checker
Write-Output "Running system file checker..."
sfc /scannow

Write-Output "System cleanup completed!"
