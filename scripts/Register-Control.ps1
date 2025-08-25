

function Get-DeployedAssembliesPath {
    [CmdletBinding(SupportsShouldProcess)]
    param()
    process {
        $DeployPath = Read-WpfCtrlSettings | Select -ExpandProperty 'deploy_assemblies_path'
        return $DeployPath
    }
}


function Get-TempObjectsPath {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    $BinariesPath = Join-Path (Get-SourcesPath) "obj"
    return $BinariesPath
}


function Get-DeployedRootPath {
    [CmdletBinding(SupportsShouldProcess)]
    param()
    process {
        $DeployedRootPath = Read-WpfCtrlSettings | Select -ExpandProperty 'deployed_root_path'
        return $DeployedRootPath
    }
}
function Register-ExtensionControlDll {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "targets")]
        [ValidateSet("Debug", "Release", "Any")]
        [string]$Target = "Any"
    )

    if (Test-ExtensionControlLoaded) {
        Write-Verbose "[Register-ExtensionControlDll] already loaded"
        return;
    }

    $DllPath = Get-ExtensionControlDllPath $Target
    if (($DllPath) -and (Test-Path $DllPath)) {
        Write-Verbose "[Register-ExtensionControlDll] Add-Type -Path `"$DllPath`""
        Add-Type -Path "$DllPath"
        Add-WpfCtrlProcessId $pid
    } else {
        throw "No Assemblies Found"
    }
}



function Unregister-ExtensionControlDll {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $false, HelpMessage = "targets")]
        [switch]$Force
    )


    [System.Collections.ArrayList]$ProcessesFlagged = [System.Collections.ArrayList]::new()
    [System.Collections.ArrayList]$ProcessesRemaining = [System.Collections.ArrayList]::new()
    [System.Collections.ArrayList]$KilledProcessIds = [System.Collections.ArrayList]::new()
    Write-Verbose "Get-RegListItemList RegisteredExtensionControlProcessId"

    ((Read-WpfCtrlSettings | Select -ExpandProperty 'processes_using') -as [string[]]) | Select -Unique | sort | % { [void]$ProcessesRemaining.Add("$_") }
    $ProcessesRemainingCount = $ProcessesFlagged.Count
    $TotalKilledProcesses = 0
    Write-Verbose "$ProcessIdListCount Registration Entries"

    if ($ProcessIdListCount -gt 0) {
        foreach ($strProcessId in $ProcessesFlagged) {

            if ("$pid" -eq "$strProcessId") {
                $StrErr = " ⚠️ skipping ourselved for now"
                $Log = " {0,-30}" -f $StrErr
                Write-Host "$Log`t" -n
                Write-Host "$pname" -f DarkGreen

            } else {

                [int]$Id = $strProcessId -as [int]
                $ProcessPtr = Get-Process -Id $Id -ErrorAction Ignore
                if ($ProcessPtr) {
                    $Status = if ($Process.Responding) { "active and responding" } else { "process crashed, hanged" }
                    $pname = "Process Id {0} [{1}.exe]" -f $Id, $Process.Name
                    $StrLog = "ExtensionControlDll {0} ({1})" -f $pname, $Status
                    Write-Verbose "$StrLog"
                    try {
                        $PtrId = $ProcessPtr.Id
                        $ProcessPtr | Stop-Process -ErrorAction Stop -Confirm:$False
                        $TotalKilledProcesses++
                        [void]$KilledProcessIds.Add($PtrId)
                        [void]$ProcessesRemaining.Remove($PtrId)

                        $StrErr = " ✔️ successfully killed"
                        $Log = " {0,-30}" -f $StrErr
                        Write-Host "$Log`t" -n
                        Write-Host "$pname" -f DarkGreen
                    } catch {
                        $StrErr = " ❌ Found Error"
                        $Log = " {0,-30}" -f $StrErr
                        Write-Host "$Log`t" -n
                        Write-Host "$pname" -f DarkYellow
                        Write-Verbose "Cannot Stop Process PID $Id"
                    }
                }

            }

        }
    } else {
        Write-Verbose "No Control Registration Found!"
    }
}

Write-Verbose "Killed $ProcessIdListCount processes out of a total of $ProcessIdListCount flagged pids. $notKilledCount not killed"

$notKilledCount = $ProcessIdListCount - $TotalKilledProcesses
$ProcessesRemaining | % {
    if ($_ -eq $pid) {
        Write-Host "process id $_ not killed --> this session"
    } else {
        Write-Host "process id $_ not killed --> error"
    }
}
Write-Verbose "Killed $ProcessIdListCount processes out of a total of $ProcessIdListCount flagged pids"

if (!(Test-ExtensionControlLoaded)) {
    Write-Verbose "[Register-ExtensionControlDll] not registered..."
    return;
} else {
    & "C:\Programs\PowerShell\Shims\7\pwsh_c_dev.exe"
}



function Test-ExtensionControlLoaded {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    try {
        $Obj = [WebExtensionPack.Controls.ExtensionStatus] -as [type]
        return $True
    } catch {
        return $False
    }
}


