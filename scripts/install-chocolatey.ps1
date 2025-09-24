# install-chocolatey.ps1
Write-Output "==> Installing Chocolatey package manager..."

# Set execution policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Set TLS version
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# Download and install Chocolatey
try {
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Write-Output "Chocolatey installed successfully"
    
    # Verify installation
    choco --version
    
    # Configure Chocolatey
    choco feature enable -n allowGlobalConfirmation
    choco feature enable -n logEnvironmentValues
    
    Write-Output "Chocolatey configuration completed"
} catch {
    Write-Error "Failed to install Chocolatey: $_"
    exit 1
}
