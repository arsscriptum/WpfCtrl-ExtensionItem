#╔════════════════════════════════════════════════════════════════════════════════╗
#║                                                                                ║
#║   import-module.ps1                                                            ║
#║   Test functions for my WPF control                                            ║
#║                                                                                ║
#╟────────────────────────────────────────────────────────────────────────────────╢
#║   Guillaume Plante <codegp@icloud.com>                                         ║
#║   Code licensed under the GNU GPL v3.0. See the LICENSE file for details.      ║
#╚════════════════════════════════════════════════════════════════════════════════╝




. "C:\Dev\PsBuild\Include.ps1"
. "C:\Dev\PsBuild\BuildQueue.ps1"
. "C:\Dev\PsBuild\BuildRequest.ps1"


$ProjectPath = "C:\Dev\WpfCtrl-ExtensionItem"
$TmpPath = Join-Path $ProjectPath "tmp"
$BuildPath = Join-Path $ProjectPath "src"
$BinPath = Join-Path $BuildPath "bin"
$ArtifactsPath = Join-Path $BuildPath "artifacts"
$Target = "Release"

$DllPath = Join-Path $TmpPath $Target
$DllPath = Join-Path $DllPath "WebExtensionPack.Controls.dll"

if (-not (Test-Path $DllPath)) {
    Write-Host "Cannot Import `"$DllPath`"" -f Red
}else{
    $mod = Import-Module -Name "$DllPath" -PassThru -Force
    $mn = $mod.Name
    $mv = $mod.Version
    $mt = $mod.ModuleType
    $log = "{0} module `"{1}`" v{2} was imported successfully" -f $mnt,$mn,$mv
    Write-Host "$log" -f Magenta
}


Get-ProcessUsingModule "WebExtensionPack.Controls.dll"