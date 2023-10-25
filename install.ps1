<#
    .SYNOPSIS
    Install PowerShell profile.

    .DESCRIPTION
    Download and prepare your PowerShell environment to use the profile from https://github.com/VouDoo/profiles

    .EXAMPLE
    PS> .\install.ps1

    Install all the bit and pieces to prepare the PowerShell profile.
#>

$ProfileDirectoryPath = "$HOME\Documents\PowerShell"
$GitHubBaseUri = "https://raw.githubusercontent.com/VouDoo/profiles/main/files"

# Create profile directory if not exists
if (-not (Test-Path -Path $ProfileDirectoryPath -PathType Container)) {
    New-Item -Path $ProfileDirectoryPath -ItemType Directory
}

# Download profile files
Invoke-WebRequest -Uri "$GitHubBaseUri/Microsoft.PowerShell_profile.ps1" -OutFile "$ProfileDirectoryPath\Microsoft.PowerShell_profile.ps1"
Invoke-WebRequest -Uri "$GitHubBaseUri/Microsoft.PowerShell_modules.psd1" -OutFile "$ProfileDirectoryPath\Microsoft.PowerShell_modules.psd1"
Invoke-WebRequest -Uri "$GitHubBaseUri/Microsoft.PowerShell_myenv.psd1" -OutFile "$ProfileDirectoryPath\Microsoft.PowerShell_myenv.psd1"

# Refresh profile
& $PROFILE -NonInteractive

try {
    Install-OhMyPosh -Method "winget"
}
catch {
    Install-OhMyPosh -Method "manual"
}
Install-MyModules

Write-Host "Profile installation complete.`nClose this console and re-open a new one :)" -ForegroundColor Green
