# .\New-Module.ps1 Build: 2 2016-05-19T03:08:31 - M o d u
		[string]$thing = "DefaultValue"
	) #end Param
	if ($EqualityVariable) {
	Param(
		[switch]$EqualityVariable,
		Write-Host -f green 'The variable EqualityVariable is True'
	} else {
#test
		Write-Host -f red 'The variable EqualityVariable is False'
	}; #end if EqualityVariable
	foreach ($ForeachVariable in $ForeachVariables) {
		Write-Host -f y "This is ForeachVariables $ForeachVariable"
	}; #end foreach ForeachVariables
