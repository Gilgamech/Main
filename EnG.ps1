# C:\Dropbox\Public\html5\PS1\EnGuard.ps1 Build: 17 2016-06-26T09:54:43  Copyright Gilgamech Technologies 
# Update Path: http:``Gilgamech.com`PS1`EnGuard.ps1
# Build : LineNo : Update Notes
# 13 : 65 : __Get_RunningProcess | where _$_.name _like "*powershell*"_ _.privatememorysize64 | sort _Descending_[0] _gt 1gb
# 14 : 71 :  if _$job_ _   _nfs while job 'sleep 60'_  _; #end if job
# 15 : 64 :  Param_    $Variable1   _; #end Param
# 16 : 65 :   [switch]$job,
# 17 : 74 :  if _$job_ _   _nfs while job 'sleep 60'_  _; #end if job



Function Get-Error {
	[CmdletBinding()]
	Param(
		[switch]$Resolve
	); #end Param
	
	if ($Error[0].InvocationInfo -ne $null) {
		$Error
		$EnGuard
		$Text = $Error[0]
		$File = (gc $Text.InvocationInfo.ScriptName)
		$Line = $Text.InvocationInfo.ScriptLineNumber
		
		$Text.Exception
		$Text.InvocationInfo
		
		$ResolveText += $File[0..($Line -2)]
		
		if ($Text.Exception -like '*Missing ''`)'' in function parameter list.*') {
			$ResolveText += $File[$Line - 1] + ","
			Write-Verbose "Proposed change: $($ResolveText[-1])"
		}; #end if Text.Message
		
		if ($Text.Exception -like '*Missing function body in function declaration.*') {
			$ResolveText += $File[$Line - 1] + "`{"
			Write-Verbose "Proposed change: $($ResolveText[-1])"
		}; #end if Text.Message
		
		$ResolveText += $File[($Line)..$File.Length]
		
		#Need to make it so Resolve only works on stuff we know how to fix.
		if ($Resolve) {
			if ($Text.Exception -like '*Missing ''`)'' in function parameter list.*') {
				"Adding a comma to fix a parameter."
				Insert-TextIntoFile -FileContents $ResolveText -FileName $Text.InvocationInfo.ScriptName
				Restart-Powershell
			} elseif ($Text.Exception -like '*Missing function body in function declaration.*') {
				"Adding an opening bracket to fix a function."
				Insert-TextIntoFile -FileContents $ResolveText -FileName $Text.InvocationInfo.ScriptName
				Restart-Powershell
			} else {
				"EnGuard doesn't know how to fix that."
				break
			}; #end if Text.Exception
		}; #end if Resolve
	} else {
		"EnGuard found no errors."
	}; #end if Error
	
}; #end Get-Error


#Check-System to monitor memory use and restart Powershell when it's too high.
#Diff running processes for new processes
Function Check-System {
	#New-Parameter Job
	Param(
		[switch]$Job
	); #end Param
	[string]$dtstamp = (get-date -f s)
	if ($Job) {
		Send-UDPText  -message ("Check-System Job mode - startup time: " + (get-date -f s))
	}; #end if
	$iterate = $true
	while ($iterate) {
		$Procc = ( Get-RunningProcess | where {$_.name -like "*powershell*"} | sort PrivateMemorySize64 -Descending)[0]
		if ($Procc.privatememorysize64  -gt 1gb ) {
			Stop-Process -ID ($Procc.ID)
		Send-UDPText  -message ("EnGuard ended process: $($Procc.Description) with CPU use: $($Procc.CPUPercent) % and Memory size: $($Procc.PrivateMemorySize64) bytes at timestamp: $dtstamp ")
		
		}; #end if Procc
		
		#Check for new processes
		$c = diff $a $b -ErrorAction SilentlyContinue
		$b = $a
		$a = Get-Process
		if ($c) {
			Send-UDPText $c
			#sleep 10
		} else {
			#If Job flag wasn't set, dump us from the loop.
			#$iterate = $false
		}; #end if job
		
		if ($Job) {
			sleep 10
		} else {
			#If Job flag wasn't set, dump us from the loop.
			$iterate = $false
		}; #end if job
	} # end while
}; #end Check-System
#Diff the registry to find recent updates. 


#If this is running on the main module, it will load EnGuard. Otherwise the variable won't be there. 
if ($EnGuard) {
	
	#Error check and status output
	$EnGuardStatus = Get-Error -Resolve
	$StatusText = "$EnGuardStatus Build: $((gc $EnGuard)[0].split(' ')[3] )"
	Write-Host -f green $StatusText
	Send-UDPText  -message $StatusText
	Send-UDPText (get-date -f s) #>> C:\Dropbox\EnGuardLog.txt; 
	
	#System monitor
	Send-UDPText (Start-Job -ScriptBlock { 
		$DontShowPoweGILVersionOnStartup = $True
		ipmo C:\Dropbox\Public\html5\PS1\PowerGIL.ps1;
		ipmo C:\Dropbox\Public\html5\PS1\EnGuard.ps1; 
		Check-System -job; 
	}) #>> C:\Dropbox\EnGuardLog.txt; 
} else {
}; #end if EnGuard




