# .\Stoneface.ps1 Build: 1 2016-06-19T18:52:46  Copyright Gilgamech Technologies 
# Update Path: C:\Dropbox\Stoneface.ps1
# Build : LineNo : Update Notes
# 
# 
# 
# 0 : 0 : # Stoneface.ps1 Build: 0 2016-06-19T18:47:04  Copyright Gilgamech Technologies # Update Path: Stoneface.ps1 # Build : LineNo : Update Notes
# 1 : 9 : Function New_Function _     Param_     [string]$FileName = "$PowerGIL"    _; #end Param    _; #end New_Function
$Stoneface = 'C:\Dropbox\Stoneface.ps1'
Function New-Function {
	
		Param(
			[string]$FileName = "$PowerGIL"
		); #end Param
	

}; #end New-Function
Write-Host -f green "C:\Dropbox\Stoneface.ps1 build: $((gc $Stoneface)[0].split(' ')[3] )"


