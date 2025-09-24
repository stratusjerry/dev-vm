REM Claude File To be broken out
echo Don't run this yet
exit

REM build-hyperv.bat
@echo off
echo Building Windows 11 Development Environment for Hyper-V...
echo.

REM Check if Packer is installed
packer version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Packer is not installed or not in PATH
    echo Please install Packer from: https://www.packer.io/downloads
    pause
    exit /b 1
)

REM Check if ISO path is set
if not defined WINDOWS_ISO_PATH (
    echo ERROR: Please set WINDOWS_ISO_PATH environment variable
    echo Example: set WINDOWS_ISO_PATH=C:\ISOs\windows-11.iso
    pause
    exit /b 1
)

if not defined WINDOWS_ISO_CHECKSUM (
    echo ERROR: Please set WINDOWS_ISO_CHECKSUM environment variable
    echo Example: set WINDOWS_ISO_CHECKSUM=sha256:your-checksum-here
    pause
    exit /b 1
)

echo Using ISO: %WINDOWS_ISO_PATH%
echo Checksum: %WINDOWS_ISO_CHECKSUM%
echo.

REM Create output directory
if not exist "output-hyperv" mkdir "output-hyperv"

REM Build the image
echo Starting Packer build for Hyper-V...
packer build hyperv-template.json

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo BUILD COMPLETED SUCCESSFULLY!
    echo ========================================
    echo.
    echo Your Windows 11 Hyper-V VM is ready at: output-hyperv\
    echo.
    echo To use the VM:
    echo 1. Import the VM into Hyper-V Manager
    echo 2. Start the VM
    echo 3. Login with: Administrator / packer
    echo.
) else (
    echo.
    echo ========================================
    echo BUILD FAILED!
    echo ========================================
    echo Check the logs above for errors.
)

pause

REM build-virtualbox.bat
@echo off
echo Building Windows 11 Development Environment for VirtualBox...
echo.

REM Check if Packer is installed
packer version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Packer is not installed or not in PATH
    echo Please install Packer from: https://www.packer.io/downloads
    pause
    exit /b 1
)

REM Check if VirtualBox is installed
vboxmanage --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: VirtualBox is not installed or not in PATH
    echo Please install VirtualBox from: https://www.virtualbox.org/
    pause
    exit /b 1
)

REM Check if ISO path is set
if not defined WINDOWS_ISO_PATH (
    echo ERROR: Please set WINDOWS_ISO_PATH environment variable
    echo Example: set WINDOWS_ISO_PATH=C:\ISOs\windows-11.iso
    pause
    exit /b 1
)

if not defined WINDOWS_ISO_CHECKSUM (
    echo ERROR: Please set WINDOWS_ISO_CHECKSUM environment variable
    echo Example: set WINDOWS_ISO_CHECKSUM=sha256:your-checksum-here
    pause
    exit /b 1
)

echo Using ISO: %WINDOWS_ISO_PATH%
echo Checksum: %WINDOWS_ISO_CHECKSUM%
echo.

REM Create output directory
if not exist "output-virtualbox" mkdir "output-virtualbox"

REM Build the image
echo Starting Packer build for VirtualBox...
packer build virtualbox-template.json

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo BUILD COMPLETED SUCCESSFULLY!
    echo ========================================
    echo.
    echo Your Windows 11 VirtualBox VM is ready!
    echo.
    echo VM Files: output-virtualbox\
    echo Vagrant Box: output-virtualbox\windows-11-dev-virtualbox.box
    echo.
    echo To use with Vagrant:
    echo   vagrant box add windows11-dev output-virtualbox\windows-11-dev-virtualbox.box
    echo   vagrant init windows11-dev
    echo   vagrant up
    echo.
    echo To use VM directly:
    echo   Import the OVA file into VirtualBox
    echo   Login with: Administrator / packer
    echo.
) else (
    echo.
    echo ========================================
    echo BUILD FAILED!
    echo ========================================
    echo Check the logs above for errors.
)

pause

REM setup-environment.bat
@echo off
echo Setting up Packer Build Environment...
echo.

REM Create directory structure
echo Creating directory structure...
if not exist "scripts" mkdir "scripts"
if not exist "templates" mkdir "templates"
if not exist "output-hyperv" mkdir "output-hyperv"
if not exist "output-virtualbox" mkdir "output-virtualbox"
if not exist "tmp" mkdir "tmp"

echo Directories created:
echo   - scripts\       (PowerShell scripts)
echo   - templates\     (Vagrant templates)
echo   - output-hyperv\ (Hyper-V build output)
echo   - output-virtualbox\ (VirtualBox build output)
echo   - tmp\           (Temporary files)
echo.

REM Check prerequisites
echo Checking prerequisites...

REM Check Packer
packer version >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Packer is installed
    packer version
) else (
    echo [MISSING] Packer - Download from: https://www.packer.io/downloads
)

REM Check VirtualBox
vboxmanage --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] VirtualBox is installed
    vboxmanage --version
) else (
    echo [MISSING] VirtualBox - Download from: https://www.virtualbox.org/
)

REM Check Hyper-V (Windows only)
powershell -Command "Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V" | findstr "Enabled" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Hyper-V is enabled
) else (
    echo [INFO] Hyper-V is not enabled - Enable it in Windows Features if needed
)

echo.
echo Environment setup complete!
echo.
echo Next steps:
echo 1. Set environment variables:
echo    set WINDOWS_ISO_PATH=C:\path\to\windows-11.iso
echo    set WINDOWS_ISO_CHECKSUM=sha256:your-checksum
echo.
echo 2. Place all the script files in the scripts\ directory
echo.
echo 3. Run the build:
echo    build-hyperv.bat     (for Hyper-V)
echo    build-virtualbox.bat (for VirtualBox)
echo.

pause

REM get-iso-checksum.bat
@echo off
echo Windows ISO Checksum Calculator
echo.

if "%1"=="" (
    echo Usage: get-iso-checksum.bat path\to\windows-11.iso
    echo.
    echo This script calculates the SHA256 checksum of your Windows ISO
    echo for use in Packer templates.
    pause
    exit /b 1
)

if not exist "%1" (
    echo ERROR: File "%1" not found!
    pause
    exit /b 1
)

echo Calculating SHA256 checksum for: %1
echo This may take a few minutes...
echo.

powershell -Command "Get-FileHash -Path '%1' -Algorithm SHA256 | Select-Object Hash"

echo.
echo Copy the hash value and set it in your environment:
echo set WINDOWS_ISO_CHECKSUM=sha256:PASTE_HASH_HERE
echo.
pause
