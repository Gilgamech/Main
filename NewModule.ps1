# .\NewModule.ps1 Build: 118 2016-06-19T22:08:49  Copyright Gilgamech Technologies 
# Update Path: C:\Dropbox\NewModule.ps1
# Build : LineNo : Update Notes
# 114 : 71 : #a 10
# 115 : 71 : #a 10
# 116 : 72 : #a 10
# 117 : 72 : #a 10
# 118 : 72 : #a 10
$NewModule = 'C:\Dropbox\NewModule.ps1'

Function New-Fart {
	Param(
		[ValidateSet("SilentButDeadly", "Moist", "BeanMasher")]
		[string]$FartCondition
	); #end Param
	$FartCondition
}; #end New-Fart

#New-Function
Function test-function {
	Param(
		[string]$f
		= "Labrador",
		[ValidateSet($true, "bog", "log")]
		[string]$Variable1,
		#[Parameter(Mandatory=$True)]
		[array]$Function = $Variable1
	); #end Param
	
	if ($Variable1) {
		$Variable1
	}; #end if Variable1
	$function
	
}; #end test-function
Write-Host -f green "C:\Dropbox\NewModule.ps1 build: $((gc $NewModule)[0].split(' ')[3] )"

#		[string]$Dog = "Labrador"

Function Test-Func2 {
	Param(
		[ValidateSet("Corgi", "Poodle", "Labrador")]
		[string]$dogs,
		$Variable1
	); #end Param
	if ($dogs) {
		$dogs
	}; #end if dogs
	
	
	
}; #end Test-Func2



#a 10
#a 10
#a 10
