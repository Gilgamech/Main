# FizzBuzz.ps1 Build: 0 2016-07-05T07:55:40 Filter Filter-FizzBuzz {
# Update Path: C:\Dropbox\FizzBuzz.ps1
# Build : LineNo : Update Notes
# 
# 
# 
# 
# 0 : 0 : # FizzBuzz.ps1 Build: 0 2016-07-05T07:55:40 Filter Filter-FizzBuzz {
	
	If (!($_ % 15)) {
		return "FizzBuzz"
	} ElseIf (!($_ % 5)) {
	 	return "Fizz"
	 } ElseIf (!($_ % 3)) {
	  	return "Buzz"
	  } else {
	  	return $_
	  
	 
	}; #end If _
	

}; #end Filter-FizzBuzz # Update Path: FizzBuzz.ps1 # Build : LineNo : Update Notes
$FizzBuzz = 'C:\Dropbox\FizzBuzz.ps1'
Write-Host -f green "C:\Dropbox\FizzBuzz.ps1 build: $((gc $FizzBuzz)[0].split(' ')[3] )"

