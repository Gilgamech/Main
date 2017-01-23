function Out-CountingSheep
{
Param(
[Parameter(Mandatory=$true,Position=1)]
$T
)

#[int]$answer = 45
#[int]$answer = $null
$answer = ((1234567890).tostring()).ToCharArray()

#output file
[array]$objection = @{} ; 


for ($i=1; $i -le $T ;$i++){
[int]$n = Read-Host -prompt "N$i"


#$x = ($n.tostring()).ToCharArray()
$4 += [char][byte](80 + $x)

if (!(diff $answer $4)) {

$thisN =  100


}else {
$thisN =  100
}
#Given a number N, name N, 2 × N, 3 × N, and so on. 
#Record every digit in that number. 
#Keep track of which digits (0, 1, 2, 3, 4, 5, 6, 7, 8, and 9) have been seen at least once so far as part of any number named. 
#Once each of the ten digits occurs at least once, output.

#Start with N and name (i + 1) × N directly after i × N. 


$objection += "" | select Case, SheepN #, Type ; 
#Math out the index of the new line
$arrayspot = ( $objection.length -1 )
#Populate Name
$objection[ $arrayspot ].Case = $i 
$objection[ $arrayspot ].SheepN = $thisN


#$x



#$j = $x

#If different,
#if (!(diff $answer $x)) {100}
#Go output stuff

} #end for
#output
for ($i=1; $i -le $T ;$i++){
Write-Host "Case #$($objection[ $i ].case): $($objection[ $i ].SheepN)"
} #end for
} #end Out-OtherThing



function Out-OtherThing
{
Param(
[Parameter(Mandatory=$true,Position=1)]
$T
)

[int]$answer = 45

#output file
[array]$objection = @{} ; 


for ($i=1; $i -le $T ;$i++){
[int]$n = Read-Host -prompt "N$i"



#pass data
$objection += "" | select Case, SheepN #, Type ; 
#Math out the index of the new line
$arrayspot = ( $objection.length -1 )
#Populate Name
$objection[ $arrayspot ].Case = $i 
$objection[ $arrayspot ].SheepN = $n


#Do other stuff

$j = $x


} #end for

#output
for ($i=1; $i -le $T ;$i++){
Write-Host "Case #$($objection[ $i ].case): $($objection[ $i ].SheepN)"
} #end for
} #end Out-OtherThing


<#
function Out-CountingSheep
{
Param(
[Parameter(Mandatory=$true,Position=1)]
$T
)

#[int]$answer = 45
#[int]$answer = $null
$answer = ((1234567890).tostring()).ToCharArray()

#output file
[array]$objection = @{} ; 
$objection += "" | select Case, SheepN
$objection[0].Case=0
$objection[0].SheepN=0

for ($i=1; $i -le $T ;$i++){
#Given a number N, name N, 2 × N, 3 × N, and so on. 
[int]$n = Read-Host -prompt "N$i"

#Start with N and name (i + 1) × N directly after i × N. 
while (!(diff $answer $x)) {#100

#Keep track of which digits (0, 1, 2, 3, 4, 5, 6, 7, 8, and 9) have been seen at least once so far. 
$x+= ($n.tostring()).ToCharArray()





$objection += "" | select Case, SheepN #, Type ; 
#Math out the index of the new line
$arrayspot = ( $objection.length -1 )

#Populate Name
$objection[ $arrayspot ].Case = $i 
$objection[ $arrayspot ].SheepN = $n

#Once each of the ten digits occurs at least once, output.
}#end while
$objection
} #end for

for ($i=1; $i -le $T ;$i++){



Write-Host "Case #$i"$objection
} #end for
$objection
} #end function


function Import-ArkdataINI
{
Param (
[Parameter(Mandatory=$True,Position=1)]
[string]$Filename
) #end param
$filecontents = gc $Filename 

#init objection object array
[array]$objection = @{} ; 

$fileline = $filecontents.Split([System.Environment]::NewLine) | where { $_.length -gt 4} | select -Unique
#parse each line and populate internal Case and IP
foreach ($line in  $fileline) {
$linesplit = ($line.split(" /") | where { $_.length -gt 4} | select -Unique)

[string]$Case = ($linesplit[1])
[ipaddress]$SheepN = ($linesplit[0])

#Add a line to the array, create columns for Name, Value, Type
#$objection += "" ; 
$objection += "" | select Case, SheepN #, Type ; 
#Math out the index of the new line
$arrayspot = ( $objection.length -1 )
#Populate Name
$objection[ $arrayspot ].Case = $Case 
$objection[ $arrayspot ].SheepN = $SheepN 

} #end foreach
#return
$objection
} #end Import-ArkDataINI 



#-join(-split$s|%{[char][convert]::toint32($_,2)})

#'0x{0:X}' -f 123456
#'0x{0:X}' -f -1


function Out-OtherThing
{
Param(
[Parameter(Mandatory=$true,Position=1)]
$T
)

$O = @{}

for ($i=1; $i -le $T ;$i++){
$n = Read-Host -prompt "Input for case #$i"

$j = $n
Write-Host "Case #$i" $j

} #end for

} #end function
#>