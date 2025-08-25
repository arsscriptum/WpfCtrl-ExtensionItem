
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

        $SaveStrCmd = Get-Command -Name "New-RegListItem" -ErrorAction Ignore
        if ($SaveStrCmd) {
            $ProcessIdStr = "$pid"
            New-RegListItem -Identifier "RegisteredExtensionControlProcessId" -String "$ProcessIdStr"
        }

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

    $TmpPathsList = Get-RegListItemList -Identifier "TmpPaths"
    $RemoveSavedStrCmd = Get-Command -Name "Remove-RegListItemString" -ErrorAction Ignore
    $GetSavedStrCmd = Get-Command -Name "Get-RegListItemList" -ErrorAction Ignore
    if ($GetSavedStrCmd) {
        Write-Verbose "Get-RegListItemList RegisteredExtensionControlProcessId"
        [string[]]$ProcessIdList = Get-RegListItemList -Identifier "RegisteredExtensionControlProcessId"
        $ProcessIdListCount = $ProcessIdList.Count
        Write-Verbose "$ProcessIdListCount Registration Entries"
        if ($ProcessIdListCount -gt 0) {
            foreach ($strProcessId in $ProcessIdList) {
                try {
                    $ProcessPtr = Get-Process -Id $Id -ErrorAction Stop
                    [int]$Id = $strProcessId -as [int]
                    $Status = if ($Process.Responding) { "active and responding" } else { "process crashed, hanged" }
                    $StrLog = "ExtensionControlDll registered by Process Id {0} [{1}.exe] ({2})" -f $Id, $Process.Name, $Status
                    Write-Verbose "$StrLog"
                    try {
                        if ($RemoveSavedStrCmd) {
                            Write-Verbose "Remove-RegListItemString $strProcessId"
                            Remove-RegListItemString -Identifier "RegisteredExtensionControlProcessId" -String "$strProcessId"
                        }
                        $ProcessPtr | Stop-Process -ErrorAction Stop -Confirm:$False
                    } catch {
                        Write-Verbose "Cannot Stop Process PID $Id"
                    }
                } catch {
                    Write-Verbose "Cannot Retrieve Process Info for PID $Id"
                }
            }
        }else{
            Write-Verbose "No Control Registration Found!"
        }
    }

    if (!(Test-ExtensionControlLoaded)) {
        Write-Verbose "[Register-ExtensionControlDll] not registered..."
        return;
    }else{
        $ConfirmationNeeded = $True
        if($Force){
            $ConfirmationNeeded = $False
        }
        [string]$sep = [string]::new('=',80)
        $msg = "Custom WPF Control Registered in this PowerShell Process!!!"
        $msgLen = $msg.Length 
        $spCount = (80/2) - ($msgLen/2)
        $padded = "{0}{1}" -f $spCount, $msg
        Write-Host "$sep" -f DarkYellow
        Write-Host "$msg" -f DarkRed
        Write-Host "$sep`n" -f DarkYellow
        Write-Host "Please confirm that we close this Powershell process [y/N] " -n -f DarkYellow
        $a = Read-Host "?"
        if($a -ne 'y'){
            return
        }
        Write-Host "Custom WPF Control Registered in this PowerShell Process!!!"
        [Environment]::Exit(0)

    }
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


