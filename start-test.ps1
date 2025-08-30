



. "C:\Dev\PsBuild\Include.ps1"
. "C:\Dev\PsBuild\BuildQueue.ps1"
. "C:\Dev\PsBuild\BuildRequest.ps1"

. "C:\Dev\WpfCtrl-ExtensionItem\scripts\Register-Dependencies.ps1"
<#
. "C:\Dev\WpfCtrl-ExtensionItem\scripts\Get-WpfExtensionCtrl.ps1"
. "C:\Dev\WpfCtrl-ExtensionItem\scripts\Import-Module.ps1"
. "C:\Dev\WpfCtrl-ExtensionItem\scripts\Read-ProjectSettings.ps1"
. "C:\Dev\WpfCtrl-ExtensionItem\scripts\Register-Control.ps1"
. "C:\Dev\WpfCtrl-ExtensionItem\scripts\Show-TestDialog.ps1"

#>

$ProjectPath = "C:\Dev\WpfCtrl-ExtensionItem"
$TmpPath = Join-Path $ProjectPath "tmp"
$BuildPath = Join-Path $ProjectPath "src"
$BinPath = Join-Path $BuildPath "bin"
$ArtifactsPath = Join-Path $BuildPath "artifacts"
$Target = "Release"

$DllPath = Join-Path $TmpPath $Target
$DllPath = Join-Path $DllPath "WebExtensionPack.Controls.dll"

Register-ExtensionControlDll Release

Get-ProcessUsingModule "WebExtensionPack.Controls.dll"