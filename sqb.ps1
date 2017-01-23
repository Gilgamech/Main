function sap-pie
{
$pl = Get-SteamServerPlayers 63.251.107.29 27019 
$payload = $pl[0].time

$payload = for ($i = 0 ; $i -le $payload.Length ; $i++) {
$n = $payload[$i]
$n1 = $payload[($i + 1)]
$n2 = $payload[($i + 2)]
$n3 = $payload[($i + 3)]
$n4 = $payload[($i + 4)]
$n5 = $payload[($i + 5)]
$n6 = $payload[($i + 6)]
$p1 = $payload[($i - 1)]


if (  ( $n -eq 0  ) -and ( $n1 -eq 0 ) -and ( $n2 -eq 0  ) -and ( $n3 -eq 0 )  -and ( $n4 -eq 0  ) -and ( $n5 -eq 0 ) ) {  
0
20  #Next 6 are 0, meaning the Player is null cuz they aren't connected yet.
0

} else {
$n   
#} #end inner if 

} #end if 
} #end payload conversion
	
$m 
#Flip-BytesToText $m -a
} #end sap-pie

#$n7 = $payload[($i + 7)]
#$n8 = $payload[($i + 8)]
#$n9 = $payload[($i + 9)]
#$n10= $payload[($i +10)]

#ipmo .\SteamQuery.ps1 -fo
#$pl = Get-SteamServerPlayers 63.251.107.29 27017
#$payload = $pl[0].time

#Time spent connecting is 6-10 bits from here.
#need to split or mark here somehow, to skip to next section.

<# $obj[ $arrayspot ].ID = 0 #ID is always 0 in ARK. Will fix later.
$obj[ $arrayspot ].Player = ""
$obj[ $arrayspot ].Score = 0 #Score is always 0 in ARK. Will fix later.
$obj[ $arrayspot ].Time = $n6, $n7, $n8,$n9
 #>
 
 
#Else...
#Player is ((0..16)+3) len string 
#Time spent connecting is 6-10 bits from here.
#need to split or mark here somehow, to skip to next section.
<# $obj[ $arrayspot ].ID = 0 #ID is always 0 in ARK. Will fix later.
$obj[ $arrayspot ].Player = $payload[(($i)..([array]::indexof($payload[$i..($+10)],0)))]
$obj[ $arrayspot ].Score = 0 #Score is always 0 in ARK. Will fix later.
$obj[ $arrayspot ].Time = $n6, $n7, $n8,$n9
 #>
 
 
 
 
 
 
 
 
 
 