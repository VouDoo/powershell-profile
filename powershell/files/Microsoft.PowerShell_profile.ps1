#region     Set my environment
Set-Variable -Name MyEnv -Scope Script -Option ReadOnly -Value (Import-PowerShellDataFile -Path "$PSScriptRoot\myenv.psd1")
#endregion  Set my environment

#region     Define helper functions
function Test-Winget {
    # Test if Windows Package Manager CLI (aka. winget) is installed
    if (Get-Command -Name "winget" -ErrorAction SilentlyContinue) { $true } else { $false }
}
function Install-PSCore {
    # Install the latest version of PowerShell Core
    if (Test-Winget) { & winget install --id Microsoft.Powershell --source winget }
    else {
        # Fall back on the old fashion way to install PowerShell
        $ScriptUri = "https://aka.ms/install-powershell.ps1"
        Invoke-Expression -Command "& { $(Invoke-RestMethod -Uri $ScriptUri) } -UseMSI"
    }
}
function Install-Chocolatey {
    # Install the latest version of Chocolatey
    # Note that this function can be interpreted as a threat for some anti-virus programs (e.g. McAfee)
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    (New-Object -TypeName System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1") | Invoke-Expression
}
function Install-OhMyPosh {
    # Install latest version of Oh My Posh
    if (Test-Winget) { & winget install --id JanDeDobbeleer.OhMyPosh }
    else {
        Write-Error -Message "Windows Package Manager CLI (aka. winget) must be installed to install Oh My Posh."
    }
}
function Set-OhMyPoshtheme {
    # Set Oh My Posh theme for the current PowerShell session
    $Config = "{0}\{1}.omp.json" -f $env:POSH_THEMES_PATH, $MyEnv.OhMyPoshTheme
    & oh-my-posh init pwsh --config "$Config" | Invoke-Expression
}
function Install-MyModules {
    # Install modules from the requirements.psd1 file
    if (-not (Get-Module -Name PSDepend -ListAvailable)) {
        Install-Module -Name PSDepend -Repository PSGallery
    }
    Import-Module -Name PSDepend
    Invoke-PSDepend -Path "$PSScriptRoot\requirements.psd1" -Install -Import -Force
}
function Update-EnvPath {
    # Refresh PATH environment variable
    $Separator = [System.IO.Path]::PathSeparator
    $Paths = "Machine", "User" | ForEach-Object -Process {
        [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::"$_") -split $Separator | Where-Object { $_ } | Select-Object -Unique
    }
    $env:Path = $Paths -join $Separator
}
function Test-Interactive {
    # Test if the session is interactive
    [Environment]::GetCommandLineArgs() -notcontains "-NonInteractive"
}
function Out-Grep {
    # grep like in *nix systems
    $input | Out-String -Stream | Select-String $args
}
function Use-Workspace {
    # Set location to my workspace
    Set-Location -Path $MyEnv.Workspace
}
function Get-Signature {
    # Get my signature
    "{0} {1} - Email: {2} - GitHub: https://github.com/{3}" -f (
        $MyEnv.FirstName, $MyEnv.LastName, $MyEnv.Email, $MyEnv.GitHub
    )
}
#endregion  Define helper functions

#region     Set Aliases for helper functions
New-Alias -Name grep -Value Out-Grep  -Description "grep like in *nix!" -Option ReadOnly
New-Alias -Name ws -Value Use-Workspace -Description "Change directory to my workspace" -Option ReadOnly
New-Alias -Name signature -Value Get-Signature -Description "Get my signature" -Option ReadOnly
#endregion  Set Aliases for helper functions

#region     Import Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path -Path $ChocolateyProfile) {
    Import-Module -Name "$ChocolateyProfile"
}
#endregion  Import Chocolatey profile

#region     Run in user interactive session
if (Test-Interactive -and -not $env:ProfileInstallation) {
    #region     Set aliases for my text editor
    ("edit", "notepad", "vi", "vim", "nano") | ForEach-Object {
        New-Alias -Name $_ -Value $MyEnv.TextEditor -Description "Open my text editor" -Option ReadOnly
    }
    #endregion  Set aliases for my text editor

    #region     Set PSReadLine
    # Import module
    Import-Module -Name PSReadLine
    # Set options
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin -BellStyle Visual
    #endregion  Set PSReadLine

    #region     Set MyRemoteManager module
    # Import module
    Import-Module -Name MyRemoteManager
    # Create aliases
    New-Alias -Name co -Value Invoke-MyRMConnection -Description "Invoke MyRemoteManager connection" -Option ReadOnly
    New-Alias -Name coTest -Value Test-MyRMConnection -Description "Test MyRemoteManager connection" -Option ReadOnly
    New-Alias -Name coGet -Value Get-MyRMConnection -Description "Get MyRemoteManager connections" -Option ReadOnly
    New-Alias -Name coAdd -Value Add-MyRMConnection -Description "Add MyRemoteManager connection" -Option ReadOnly
    New-Alias -Name coRm -Value Remove-MyRMConnection -Description "Remove MyRemoteManager connection" -Option ReadOnly
    #endregion  Set MyRemoteManager module

    #region     Set Posh modules
    # Import modules
    Import-Module -Name posh-git
    # Set Oh My Posh theme
    Set-OhMyPoshtheme
    #endregion  Set Posh modules

    #region     Import other modules
    Import-Module -Name Terminal-Icons
    Import-Module -Name MyJavaManager
    Import-Module -Name PomoShell
    #endregion  Import other modules

    #region     Print greeting message
    $GreetingMessage = "Greetings, Professor {0}. Shall we play a game?`n" -f $MyEnv.FirstName
    Write-Host $GreetingMessage -ForegroundColor Yellow
    #endregion  Print greeting message
}
#endregion  Run in user interactive session
