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


function Get-ProjectRootPath {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    $ProjectRootPath = "C:\Dev\WpfCtrl-ExtensionItem"
    return $ProjectRootPath
}


function Get-SourcesPath {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    $SourcesPath = Join-Path (Get-ProjectRootPath) "src"
    return $SourcesPath
}


function Get-ScriptsPath {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    $ScriptsPath = Join-Path (Get-ProjectRootPath) "scripts"
    return $ScriptsPath
}


function Get-BinariesPath {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    $BinariesPath = Join-Path (Get-SourcesPath) "bin"
    return $BinariesPath
}


function Get-TempObjectsPath {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    $BinariesPath = Join-Path (Get-SourcesPath) "obj"
    return $BinariesPath
}


function Get-BinariesDebugPath {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    $DebugPath = Join-Path (Get-BinariesPath) "Debug"
    $DebugPath = Join-Path $DebugPath (Get-ProjectFrameworkVersion)
    return $DebugPath
}



function Get-BinariesReleasePath {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    $ReleasePath = Join-Path (Get-BinariesPath) "Release"
    $ReleasePath = Join-Path $ReleasePath (Get-ProjectFrameworkVersion)
    return $ReleasePath
}



[System.Collections.ArrayList]$ScriptErrors = [System.Collections.ArrayList]::new()
$ScriptPath = Get-ScriptsPath
$AllScripts = Get-ChildITem -Path "$ScriptPath" -File -Filter "*.ps1" | Select -ExpandProperty name | Where { $_ -notmatch "Register-Dependencies" }
foreach ($sname in $AllScripts) {
    $spath = Join-Path "$ScriptPath" "$sname"
    Write-Verbose "Sourcing `"$sname`""

    try {
        $ScriptData = Get-Content -Path "$spath" -Raw
        $NumBytes = $ScriptData.Lenght
        $code = @"


Write-Verbose 'SOURCING $sname which is $NumBytes bytes'

$ScriptData


"@
        #Write-Verbose "$code"
        $sb = [scriptblock]::Create($code)
        .$sb
        #Invoke-Expression -Command $sb
        Get-ExtensionControlDllPath

        $StrErr = " ✔️ successfully sourced"
        $Log = " {0,-30}" -f $StrErr
        Write-Host "$Log`t" -n
        Write-Host "$sname" -f DarkGreen
    } catch {
        $StrErr = " ❌ Found Error"
        $Log = " {0,-30}" -f $StrErr
        Write-Host "$Log`t" -n
        Write-Host "$sname" -f DarkYellow
        if ($ErrorDetails) {
            [System.Management.Automation.ErrorRecord]$e = $_
            [void]$ScriptErrors.Add($e)
        }
    }
}


$ScriptErrorsCount = $ScriptErrors.Count
if (($ErrorDetails) -and ($ScriptErrorsCount)) {
    Write-Host "[Error Details] " -f DarkRed -n
    Write-Host "Got $ScriptErrorsCount Errors" -f DarkYellow

    foreach ($Record in $ScriptErrors) {
        $formatstring = "{0}`n{1}"
        $fields = $Record.FullyQualifiedErrorId, $Record.Exception.ToString()
        $ExceptMsg = ($formatstring -f $fields)
        $Stack = $Record.ScriptStackTrace
        Write-Host "`n[ERROR] -> " -NoNewline -ForegroundColor DarkRed;
        Write-Host "$ExceptMsg`n`n" -ForegroundColor DarkYellow
        if ($ShowStack) {
            Write-Host "--stack begin--" -ForegroundColor DarkGreen
            Write-Host "$Stack" -ForegroundColor Gray
            Write-Host "--stack end--`n" -ForegroundColor DarkGreen
        }
        Read-Host "Press a key for next error"
    }
}

New-Alias -Name incdeps -Value Register-ScriptDependencies -Option AllScope -Force -ErrorAction Ignore

