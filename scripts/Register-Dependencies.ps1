#╔════════════════════════════════════════════════════════════════════════════════╗
#║                                                                                ║
#║   Register-Dependencies.ps1                                                    ║
#║   Test functions for my WPF control                                            ║
#║                                                                                ║
#╟────────────────────────────────────────────────────────────────────────────────╢
#║   Guillaume Plante <codegp@icloud.com>                                         ║
#║   Code licensed under the GNU GPL v3.0. See the LICENSE file for details.      ║
#╚════════════════════════════════════════════════════════════════════════════════╝


[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false, HelpMessage = "targets")]
    [switch]$ErrorDetails,
    [Parameter(Mandatory = $false, HelpMessage = "ShowStack")]
    [switch]$ShowStack
)

try{


. "C:\Dev\BinaryDepot-DownloadTool\externals\ExtensionItemCtrl\scripts\BuildQueue.ps1"
. "C:\Dev\BinaryDepot-DownloadTool\externals\ExtensionItemCtrl\scripts\BuildRequest.ps1"
. "C:\Dev\BinaryDepot-DownloadTool\externals\ExtensionItemCtrl\scripts\Common.ps1"
. "C:\Dev\BinaryDepot-DownloadTool\externals\ExtensionItemCtrl\scripts\Get-WpfExtensionCtrl.ps1"
. "C:\Dev\BinaryDepot-DownloadTool\externals\ExtensionItemCtrl\scripts\Include.ps1"
. "C:\Dev\BinaryDepot-DownloadTool\externals\ExtensionItemCtrl\scripts\Read-ProjectSettings.ps1"
. "C:\Dev\BinaryDepot-DownloadTool\externals\ExtensionItemCtrl\scripts\Register-Control.ps1"
. "C:\Dev\BinaryDepot-DownloadTool\externals\ExtensionItemCtrl\scripts\Show-TestDialog.ps1"
}catch{
    Show-ExceptionDetails  ($_) -ShowStack
}
New-Alias -Name incdeps -Value Register-ScriptDependencies -Option AllScope -Force -ErrorAction Ignore

