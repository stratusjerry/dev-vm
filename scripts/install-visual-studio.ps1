# install-visual-studio.ps1
Write-Output "==> Installing Visual Studio Community 2022..."

# Install Visual Studio Community with common workloads
choco install -y visualstudio2022community --package-parameters "--allWorkloads --includeRecommended --includeOptional --passive --locale en-US"

# Install specific workloads
Write-Output "Installing Visual Studio workloads..."
choco install -y visualstudio2022-workload-azure
choco install -y visualstudio2022-workload-manageddesktop  
choco install -y visualstudio2022-workload-netcoretools
choco install -y visualstudio2022-workload-node
choco install -y visualstudio2022-workload-python
choco install -y visualstudio2022-workload-data

# Install Visual Studio extensions
Write-Output "Installing Visual Studio extensions..."
choco install -y visualstudio2022-enterprise # If you have enterprise license
# choco install -y resharper-platform-vs2022  # If you want ReSharper

Write-Output "Visual Studio 2022 installation completed"
