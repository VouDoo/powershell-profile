# PowerShell profile

Content:

- [PowerShell profile](#powershell-profile)
  - [Instructions](#instructions)
    - [Install PowerShell Core](#install-powershell-core)
    - [Install winget](#install-winget)
    - [Apply PowerShell profile](#apply-powershell-profile)
    - [Edit `myenv`](#edit-myenv)
    - [Terminal emulator](#terminal-emulator)

## Instructions

_These instructions are for Windows base systems._
_Please, adapt them if you are using another operating system._

### Install PowerShell Core

If PowerShell Core is not present on your system, please read this documentation:
[Installing PowerShell on Windows](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows).

### Install winget

Windows Package Manager winget command-line tool is bundled with modern versions of Windows.

If you are unsure, please read this documentation:
[Install winget](https://docs.microsoft.com/en-us/windows/package-manager/winget/#install-winget).

### Apply PowerShell profile

_This profile uses Oh My Posh._
_We recommend to use a terminal that supports modern fonts (e.g. [Windows Terminal](https://github.com/microsoft/terminal))._

Open a PowerShell Core console (`pwsh.exe`) and execute this one-liner:

  ```ps1
  iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/VouDoo/powershell-profile/main/install.ps1"))
  ```

### Edit `myenv`

By default, `myenv` file contains my (VouDoo) details.

Feel free to edit `~/Documents/PowerShell/myenv.psd1` with your own personnal details 😊

### Terminal emulator

I recommend to use Windows Terminal with this profile (installed by default on Windows 11).

The configuration I use is available here: [see GitHub gist](https://gist.github.com/VouDoo/23b9a5c70caa771071053ae9e469b0d4).
