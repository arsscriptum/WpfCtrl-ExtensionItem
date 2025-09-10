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


. "C:\Dev\WpfCtrl-ExtensionItem\scripts\BuildQueue.ps1"
. "C:\Dev\WpfCtrl-ExtensionItem\scripts\BuildRequest.ps1"
. "C:\Dev\WpfCtrl-ExtensionItem\scripts\Common.ps1"
. "C:\Dev\WpfCtrl-ExtensionItem\scripts\Get-WpfExtensionCtrl.ps1"
. "C:\Dev\WpfCtrl-ExtensionItem\scripts\Include.ps1"
. "C:\Dev\WpfCtrl-ExtensionItem\scripts\Read-ProjectSettings.ps1"
. "C:\Dev\WpfCtrl-ExtensionItem\scripts\Register-Control.ps1"
. "C:\Dev\WpfCtrl-ExtensionItem\scripts\Show-TestDialog.ps1"
}catch{
    Show-ExceptionDetails  ($_) -ShowStack
}
New-Alias -Name incdeps -Value Register-ScriptDependencies -Option AllScope -Force -ErrorAction Ignore

