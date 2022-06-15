<#
.SYNOPSIS
    Install PowerShell profile
.DESCRIPTION
    Download and prepare your PowerShell console to use the profile from https://github.com/VouDoo/profiles
.EXAMPLE
    install.ps1
#>

$ProfileDirectoryPath = "$HOME\Documents\PowerShell"
$GitHubBaseUri = "https://raw.githubusercontent.com/VouDoo/profiles/main/powershell/files"

# Create profile directory if not exists
if (-not (Test-Path -Path $ProfileDirectoryPath -PathType Container)) {
    New-Item -Path $ProfileDirectoryPath -ItemType Directory
}

# Download profile files
Invoke-WebRequest -Uri "$GitHubBaseUri/Microsoft.PowerShell_profile.ps1" -OutFile "$ProfileDirectoryPath\Microsoft.PowerShell_profile.ps1"
Invoke-WebRequest -Uri "$GitHubBaseUri/requirements.psd1" -OutFile "$ProfileDirectoryPath\requirements.psd1"
Invoke-WebRequest -Uri "$GitHubBaseUri/myenv.psd1" -OutFile "$ProfileDirectoryPath\myenv.psd1"

# Refresh profile
$env:ProfileInstallation = $true
& $PROFILE

Install-OhMyPosh
Install-MyModules

Write-Host "Profile installation complete.`nClose this console and re-open a new one :)" -ForegroundColor Green
