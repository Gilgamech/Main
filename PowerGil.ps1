#Build: 193 : Date: 2016-04-11T03:16:13 Copyright Gilgamech Technologies

#To run this, put these in your profile, and set them correctly: 
# 
# $ProgramsPath = "C:\Program Files (x86)" #Program files root folder.
# $DocsPath = "C:\User\MyNameHere\Documents" #Documents root folder.
# $UtilPath = "C:\utilities" #Where you keep your utilities.
# $modulesFolder = $ProgramsPath + "\Projects\Powershell" #Powershell Modules
# $PowerGIL = $modulesFolder + "\PowerGIL.ps1" #PowerGIL location, usually in the Modules folder.
# $VIMPATH = $UtilPath + "\vim74\vim.exe" #Assumes you have Vim for Win64.
# $NppPath = $ProgramsPath + "\N++\notepad++.exe" #Assumes you have Notepad++
# $PowerGILBackupPath = $ProgramsPath + "\PowerGILVersion"
#
# Import-Module $PowerGIL
# 
#$DontShowPSVersionOnStartup = $true # to turn off Powershell Version display.
# 
# 
#++++ DON'T TOUCH ANYTHING DOWN HERE OR YOU MIGHT BREAK IT +++ 
#++++ DON'T TOUCH ANYTHING DOWN HERE OR YOU MIGHT BREAK IT +++ 
#++++ DON'T TOUCH ANYTHING DOWN HERE OR YOU MIGHT BREAK IT +++ 
#++++ DON'T TOUCH ANYTHING DOWN HERE OR YOU MIGHT BREAK IT +++ 
#++++ DON'T TOUCH ANYTHING DOWN HERE OR YOU MIGHT BREAK IT +++ 


#Download the current one to get the web version.
$PowerGILWebAddr = "http://Gilgamech.com/PS1/PowerGIL.ps1" 
[ipaddress]$localhost = "127.0.0.1"
$ProfileFolder = (split-path $PROFILE)
$PowerGILWebPS1 = try {
Invoke-WebRequest $PowerGILWebAddr
}catch{
0
} #end try

#Get the build version from the header of your $PowerGIL
[int]$PowerGILBuildVersion = ([int](gc $PowerGIL)[0].split(":")[1])
#If you could get the web version, dig out its build number. Else return 0.
if ($PowerGILWebPS1 -eq 0){
$PowerGILWebVersion = 0
} else {
[int]$PowerGILWebVersion = ($PowerGILWebPS1.Content.split(":")[1])
} #end if


#need to rewrite as a Case (FLAG) 
Function Get-PowerGILVersion
{
<#
.SYNOPSIS
    Returns PowerGIL version number, notes, and function list.
.DESCRIPTION
    Author   : Stephen Gillie
    Last edit: 4/10/2016
.EXAMPLE
    Get-PowerGILVersion - Notes
#>
Param(
   [switch]$notes,
   [switch]$Functions
)
if  ($PowerGILWebVersion -eq $PowerGILBuildVersion) {
write-host -foregroundcolor "Green" "PowerGIL Build:" $PowerGILBuildVersion
}else{
if ($PowerGILWebVersion -gt  $PowerGILBuildVersion  ){
write-host -foregroundcolor "Yellow" "Installed PowerGIL Build: " -nonewline; Write-Host -f "Red" $PowerGILBuildVersion 
write-host -foregroundcolor "Yellow" "Website PowerGIL Build: " -nonewline; Write-Host -f "Green" $PowerGILWebVersion 
Write-Host "You should run " -nonewline; Write-Host -f "Red" "Update-PowerGIL " ;

}else{
write-host -foregroundcolor "Green" "PowerGIL Build:" $PowerGILBuildVersion
} #end inner if 
}#end outer if

if ($notes){
Write-host -foregroundcolor "Yellow" "
Build : Change notes.
188 : Get-Encrypted and Get-Decrypted added. Change notes format change.
189 : Update to Backup-PowerGIL.
190 : Update to Backup-PowerGIL.
191 : Update to Backup-PowerGIL.
192 : Some Flip filter commands to change datatypes.
193 : More Flip filters.
" 
} #end if

if ($Functions){
write-host "Functions available:" -f "Yellow"
(cat $PowerGIL | Select-String "function ") #| select -skip 2
} #end if

} #end Get-PowerGILVersion


function Get-PSVersion
{
if ($PSVersionTable.psversion.major -ge 4) {
Write-Host "PowerShell Version: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Build).$($PSVersionTable.PSVersion.Revision)" -ForegroundColor Yellow 
} else {
Write-Host "PowerShell Version: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)" -ForegroundColor Yellow 
} #end if
} #end Get-PSVersion


#$DontShowPSVersionOnStartup = $false # to turn off Powershell Version display.
if (!($DontShowPSVersionOnStartup)){
Get-PSVersion
}


#$DontShowPoweGILVersionOnStartup = $false # to turn off PowerGIL Build display.
if (!($DontShowPoweGILVersionOnStartup)){
Get-PowerGILVersion
}

#Aliases for VI
Set-Alias vi   $VIMPATH
Set-Alias vim  $VIMPATH
#Alias for N++
Set-Alias note  $NppPath

#Hate VIM
Function Vim-Vimrc
{
    vim $home\_vimrc
}
Function Vim-PowerGIL
{
    vim $PowerGIL
}
Function Vim-Profile
{
    vim $Profile
}


#Love Notepad++
Set-Alias note  $NppPATH
Function Note-Profile
{
    note $profile
}
Function Note-PowerGIL
{
    note $PowerGIL
}

#Open here in Explorer.
Function Open-Explorer
{
explorer.exe (Get-Location)
}

Function New-Powershell([switch] $Elevated)
{
if ($Elevated) {
start-process powershell -verb runas
} else {
Start-Process powershell 
} #end if
} #end New-Powershell


Function Restart-Powershell([switch] $Elevated)
{
if ($Elevated) {
start-process powershell -verb runas
} else {
Start-Process powershell 
} #end if
exit
} #end Restart-Powershell


Function Reload-PowerGIL
{
Write-host "Reloading PowerGIL..." -foregroundcolor "Yellow" 
Import-Module $PowerGIL -force
} #end Reload-PowerGIL
Function Reload-Profile
{
Import-Module $Profile -force
} #end Reload-Profile



Function Update-PowerGIL
{
Write-host "" #Blank line
Copy-Item $PowerGIL "$PowerGIL.bak"
Write-host "$PowerGIL.bak created." -foregroundcolor "Yellow"
$diffpct = 0.25 #How much larger of update should we accept? 
#Get PowerGIL from web
#get web Build length, math it out
$PowerGILWebPS1.content > $home\.webgil2.txt
$gcon = gc $home\.webgil2.txt | select -Skip 1 
#Get web version and write to temp file
$PowerGILVer = "#Build: "  + $PowerGILWebVersion + " : Copyright 2016 Gilgamech Technologies"
#Have to fix this so it's like Backup-PowerGIL (FLAG)
$PowerGILVer > $home\.webgil2.txt
#Write content to temp file, snip blank lines from the end.
$gcon[0..($gcon.Length - 6)] >> $home\.webgil2.txt
$gcon[-5..-1] | where { $_ -ne "" } >> $home\.webgil2.txt
#Pull from the temp file, delete, get length.
$webfinal = gc -raw $home\.webgil2.txt
remove-item $home\.webgil2.txt
$weblen = $webfinal.Length
write-host "Length of $PowerGILWebAddr is" $weblen "bytes and has Build" $PowerGILWebVersion

#get local Build length
$loclen = (cat -raw $PowerGIL).Length
write-host "Length of $PowerGIL is" $loclen "bytes and has Build" $PowerGILBuildVersion

#If the new one is within 25% of the file size of the new one, update.
$diffouput = ( $diffpct *  100  )  

if ((($weblen / $loclen) -gt $diffpct) -and (($loclen / $weblen) -gt $diffpct)){
write-host "File lengths are within $diffouput`%, procesing update. :D" -foregroundcolor "Green"
$webfinal   | Out-File -Encoding "UTF8" $PowerGIL
#$Firstline | Out-File -Encoding "UTF8" $PowerGIL
#$PowerGILWebPS1.Content | select -skip 1 | Out-File -Encoding "UTF8" -Append $PowerGIL
} else {
write-host "File length differences are greater than $diffouput`%, aborting update. D:" -foregroundcolor "Red"
} #end if
Write-host "" #Blank line
#Write-host "Reloading PowerGIL..." #Reload message.
Restart-Powershell
} #end Update-PowerGIL

function Backup-PowerGIL
{
if (!(test-path $PowerGILBackupPath)){md $PowerGILBackupPath}

#Set up page to increment versions
if ($PowerGILMaster -eq 1) {
$PowerGILBuildVersion++
#$PowerGILVer = "#Build: "  + ($PowerGILBuildVersion) + " : Copyright 2016 Gilgamech Technologies"
#} else {
} #end if
#$PowerGILVer = "#Build: "  + ($PowerGILBuildVersion) + " : Copyright 2016 Gilgamech Technologies"
$PowerGILVer = "#Build: "  + ($PowerGILBuildVersion) + " : Date: " + (get-date -f s) + " Copyright Gilgamech Technologies"
$PowerGILContent = (gc $PowerGIL | select -Skip 1 )

#write pages to a temp file.
$PowerGILVer > $home\.webgil3.txt
#$PowerGILContent >> $home\.webgil3.txt
$PowerGILContent[0..($PowerGILContent.Length - 6)] >> $home\.webgil3.txt
$PowerGILContent[-5..-1] | where { $_ -ne "" } >> $home\.webgil3.txt
#Read the temp file and output UTF8 to $PowerGIL
$webfinal = gc -raw $home\.webgil3.txt
$webfinal   | Out-File -Encoding "UTF8" $PowerGIL
remove-item $home\.webgil3.txt

#Copy the backup file.
if ($PowerGILMaster -eq 1) {
Copy-Item $PowerGIL "$PowerGILBackupPath\PowerGIL.bak.$PowerGILBuildVersion"
$latestPowerGIL = (ls | sort LastWriteTime -Descending)[0].name
#$latestPowerGIL = (ls $PowerGILBackupPath)[-1].name
Write-host "$latestPowerGIL created. Build incremented to " -foregroundcolor "Yellow" -nonewline; Write-Host -f "Green" ($PowerGILBuildVersion)
 } else {
Copy-Item $PowerGIL "$PowerGILBackupPath\PowerGIL.bak"
$latestPowerGIL = (ls | sort LastWriteTime -Descending)[0].name
#$latestPowerGIL = (ls $PowerGILBackupPath)[-1].name
#Write-host "PowerGIL version $PowerGILBuildVersion written to backup. " -foregroundcolor "Green"
} #end if
#Used to Reload-PowerGIL but that doesn't actually reset everything. Need a full restart for some raisin.
Restart-Powershell
} #end Backup-PowerGIL


Function Backup-Profile
{
if (!(test-path $PowerGILBackupPath)){md $PowerGILBackupPath}
Copy-Item $Profile "$PowerGILBackupPath\Microsoft.Powershell_profile.ps1"
Write-host "Profile $Profile copied to backup $PowerGILBackupPath\Microsoft.Powershell_profile.ps1" -foregroundcolor "Green" 
} #Backup-Profile


Function Restore-Profile
{
Copy-Item "$PowerGILBackupPath\Microsoft.Powershell_profile.ps1" $Profile
Reload-Profile
Write-host "Profile restored from backup." -foregroundcolor "Green" 
} #Restore-Profile


#Should add in a function param (FLAG)
Function Restore-PowerGIL
{
#$latestPowerGIL = (ls $PowerGILBackupPath)[-1].name
$PowerGILRestoreVersion = $PowerGILBuildVersion - 1
$latestPowerGIL = (ls $PowerGILBackupPath)[-1].name
Copy-Item $latestPowerGIL $PowerGIL
Reload-PowerGIL
Write-host "PowerGIL restored from backup." -foregroundcolor "Green" 
} #Restore-PowerGIL


#Github
function Get-GithubStatus
{
$r = Invoke-RestMethod -Uri "https://status.github.com/api/status.json?callback=apiStatus"
$s = ConvertFrom-Json $r.substring(10,($r.Length - 11))
$s
} #end Get-GithubStatus



#Conversions
Filter Flip-TextToBinary
{
[System.Text.Encoding]::UTF8.GetBytes($_) | %{ 
[System.Convert]::ToString($_,2).PadLeft(8,'0')
}
#[System.Text.Encoding]::UTF8.GetBytes([System.Convert]::ToString($_,2).PadLeft(8,'0'))
}

Filter Flip-BinaryToText
{
%{ 
[System.Text.Encoding]::UTF8.GetString([System.Convert]::ToInt32($_,2)) 
} #end foreach
} #end Filter

Filter Flip-TextToBytes 
{
Param(
   [switch]$ASCII
)
if ($ASCII) {
[System.Text.Encoding]::ASCII.GetBytes($_)
} else {
[System.Text.Encoding]::Unicode.GetBytes($_)
}
} #end Filter

Function Flip-BytesToText
{
Param(
   [Parameter(Mandatory=$True,Position=3)]
   [object]$B,
   [switch]$ASCII
)
if ($ASCII) {
[System.Text.Encoding]::ASCII.GetString($B)
} else {
[System.Text.Encoding]::Unicode.GetString($B)
}
} #end Function

Filter Flip-TextToBase64
{
#$Text = ‘This is a secret and should be hidden’
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($_)
$EncodedText =[Convert]::ToBase64String($Bytes)
$EncodedText
} #end Filter

Filter Flip-Base64ToText
{
$DecodedText = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($_))
$DecodedText
} #end Filter

Filter Flip-HexToText
{
$_.Split(" ") | FOREACH {
 [CHAR][BYTE]([CONVERT]::toint16($_,16))
} #end foreach
} #end Flip-HexToText

Filter Flip-TextToHex
{
$_.ToCharArray() | FOREACH {
 ([CONVERT]::tostring([BYTE][CHAR]$_,16))
} #end foreach
} #end Flip-HexToText

Filter Flip-HexToBinary
{
$_.Split(" ") | FOREACH {
 ([CONVERT]::toint16($_,16))
} #end foreach
} #end Flip-HexToText



#Encryption
#Run in Elevated: New-SelfSignedCertificate -CertStoreLocation cert:\LocalMachine\My -DnsName "gilgamech.com"

Function Get-Encrypted 
#Got from here: http://powershell.org/wp/2014/02/01/revisited-powershell-and-encryption/
{
Param(
   [Parameter(Mandatory=$True,Position=1)]
   [object]$Message,
   [Parameter(Mandatory=$True,Position=2)]
   [string]$file
)
Write-Host "Encrypting to $file..." -f "Yellow"
try
{
  Write-Host "Encrypting input..." -f "Yellow"
  $secureString = $Message | ConvertTo-SecureString -AsPlainText -Force
#    $secureString = 'This is my password.  There are many like it, but this one is mine.' | 
#                    ConvertTo-SecureString -AsPlainText -Force

# Generate our new 32-byte AES key.  I don't recommend using Get-Random for this; the System.Security.Cryptography namespace offers a much more secure random number generator.

    $key = New-Object byte[](32)
    $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::Create()
Write-Host "Creating key..." -f "Yellow"
    $rng.GetBytes($key)

Write-Host "Encrypting input..." -f "Yellow"
    $encryptedString = ConvertFrom-SecureString -SecureString $secureString -Key $key
Write-Host "Input encrypted." -f "Green"

    # This is the thumbprint of a certificate on my test system where I have the private key installed.

    $thumbprint = (ls  -Path Cert:\CurrentUser\My\).Thumbprint
    $cert = Get-Item -Path Cert:\CurrentUser\My\$thumbprint -ErrorAction Stop

    $encryptedKey = $cert.PublicKey.Key.Encrypt($key, $true)
Write-Host "Key encrypted." -f "Green"

    $object = New-Object psobject -Property @{
        Key = $encryptedKey
        Payload = $encryptedString
    }

Write-Host "Encryption complete, writing $file." -f "Green"
    $object | Export-Clixml $file

}
finally
{
    if ($null -ne $key) { [array]::Clear($key, 0, $key.Length) }
Write-Host "Key cleared." -f "Green"
#    if ($null -ne $secureString) { [array]::Clear($secureString, 0, $secureString.Length) }
#    if ($null -ne $rng) { [array]::Clear($rng, 0, $rng.Length) }
#    if ($null -ne $encryptedString) { [array]::Clear($encryptedString, 0, $encryptedString.Length) }
#    if ($null -ne $thumbprint) { [array]::Clear($thumbprint, 0, $thumbprint.Length) }
#    if ($null -ne $cert) { [array]::Clear($cert, 0, $cert.Length) }
#    if ($null -ne $encryptedKey) { [array]::Clear($encryptedKey, 0, $encryptedKey.Length) }
#    if ($null -ne $object) { [array]::Clear($object, 0, $object.Length) }

}
} #end Get-Encrypted 



Function Get-Decrypted
#Got from here: http://powershell.org/wp/2014/02/01/revisited-powershell-and-encryption/
{
Param(
   [Parameter(Mandatory=$True,Position=1)]
   [string]$file
)
Write-Host "Decrypting $file..." -f "Yellow"
try
{
Write-Host "Reading file $file" -f "Green"
    $object = Import-Clixml -Path $file
Write-Host "Removing $file" -f "Yellow"
	rm $file

    $thumbprint = (ls  -Path Cert:\CurrentUser\My\).Thumbprint
    $cert = Get-Item -Path Cert:\CurrentUser\My\$thumbprint -ErrorAction Stop

    $key = $cert.PrivateKey.Decrypt($object.Key, $true)
Write-Host "Key decrypted." -f "Green"
Write-Host "Decrypting payload, this may take a while..." -f "Yellow"
    #$secureString = $object.Payload | ConvertTo-SecureString -Key $key
	$secureString = $object.Payload | ConvertTo-SecureString -Key $key
Write-Host "Input decrypted." -f "Green"
	ConvertFrom-SecureToPlain $secureString
Write-Host "Decryption complete. Hope you wrote this to a variable!" -f "Green"
}
finally
{
    if ($null -ne $key) { [array]::Clear($key, 0, $key.Length) }
Write-Host "Key cleared." -f "Green"
} 
} #end Get-Decrypted



#Images
function Invoke-PowerGilImage
{
# load the appropriate assemblies 
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")

# create chart object 
$Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart 
$Chart.Width = 500 
$Chart.Height = 400 
$Chart.Left = 40 
$Chart.Top = 30

# create a chartarea to draw on and add to chart 
$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea 
$Chart.ChartAreas.Add($ChartArea)

# add data to chart 
$Cities = @{London=7556900; Berlin=3429900; Madrid=3213271; Rome=2726539; 
            Paris=2188500} 
[void]$Chart.Series.Add("Data") 
$Chart.Series["Data"].Points.DataBindXY($Cities.Keys, $Cities.Values)

# display the chart on a form 
$Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor 
                [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left 
$Form = New-Object Windows.Forms.Form 
$Form.Text = "PowerShell Chart" 
$Form.Width = 600 
$Form.Height = 600 
$Form.controls.add($Chart) 
$Form.Add_Shown({$Form.Activate()}) 
$Form.ShowDialog()
} #end Invoke-PowerGilImage





#+++ UDP Playground +++
#Got from here: http://powershell.com/cs/blogs/tips/archive/2012/05/09/communicating-between-multiple-powershells-via-udp.aspx
function Send-Text 
{
Param(
   [Parameter(Mandatory=$True,Position=1)]
   [ipaddress]$serveraddr,
   [Parameter(Mandatory=$True,Position=2)]
   [int]$serverport,
   [Parameter(Mandatory=$True,Position=3)]
   [object]$Message,
   [switch]$PSObject,
   [switch]$Secure
)
if ($Secure) {
Write-Host "Converting to SecureString..." -f "Yellow"
$Message = ConvertTo-SecureString -AsPlainText $Message.ToString() -Force
Write-Host "Conversion complete, sending." -f "Green"
} #end if
if ($PSObject) {
$Message = ConvertTo-JSON $Message
} #end if

    $endpoint = New-Object System.Net.IPEndPoint ($serveraddr,$serverport)
    $udpclient= New-Object System.Net.Sockets.UdpClient
    $bytes=[Text.Encoding]::ASCII.GetBytes($Message)
    $bytesSent=$udpclient.Send($bytes,$bytes.length,$endpoint)
    $udpclient.Close()
} #end Send-Text 

#Got from here: http://powershell.com/cs/blogs/tips/archive/2012/05/09/communicating-between-multiple-powershells-via-udp.aspx
function Start-Listen 
{
Param(
#   [Parameter(Mandatory=$True,Position=1)]
#   [ipaddress]$serveraddr,
   [Parameter(Mandatory=$True,Position=1)]
   [int]$serverport,
   [Parameter(Position=2)]
   [switch]$Continuous,
   [Parameter(Position=3)]
   [switch]$PSObject,
   [switch]$Secure
)
if ($endpoint.port -eq $null) {
    $endpoint = New-Object System.Net.IPEndPoint ([IPAddress]::Any,$serverport)
} #end if
#write-host "Reusing port $endpoint.port" -f "Green"
#} else {
write-host "Now listening on port" $serverport -f "Green"
if (($Continuous)) {
write-host "Continuous mode" -f "Red"
} #end if
$udpclient= New-Object System.Net.Sockets.UdpClient $serverport
$iterate = $true
while ($iterate) {
$content=$udpclient.Receive([ref]$endpoint)
$content = [Text.Encoding]::ASCII.GetString($content)
if ($PSObject) {
$content = ConvertFrom-JSON $content
} else {
} #end if
if ($Secure) {
#$content = ConvertFrom-SecureString $content
$content = ConvertFrom-SecureToPlain $content
} #end if
if (!($Continuous)) {
$iterate = $false
} #end if
$content
} #end while
} #end Start-Listen




# Loosely based on http://www.vistax64.com/powershell/202216-display-image-powershell.html
function Display-Image 
{
Param(
   [Parameter(Mandatory=$True,Position=1)]
   [string]$filename
)
[void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")

$file = (get-item $filename)
#$file = (get-item "c:\image.jpg")

$img = [System.Drawing.Image]::Fromfile($file);

# This tip from http://stackoverflow.com/questions/3358372/windows-forms-look-different-in-powershell-and-powershell-ise-why/3359274#3359274
[System.Windows.Forms.Application]::EnableVisualStyles();
$form = new-object Windows.Forms.Form
$form.Text = "Image Viewer"
$form.Width = $img.Size.Width;
$form.Height =  $img.Size.Height;
$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.Width =  $img.Size.Width;
$pictureBox.Height =  $img.Size.Height;

$pictureBox.Image = $img;
$form.controls.add($pictureBox)
$form.Add_Shown( { $form.Activate() } )
$form.ShowDialog()
#$form.Show();
} #end Display-Image



Function Output-DevNewBuild
{
Param(
   [Parameter(Mandatory=$True,Position=1)]
   [ipaddress]$filename
)
$filename = (get-date -format MM-dd-HH-mm)
md .\Builds\$filename
ls -File | foreach {Copy-Item $_ .\Builds\$filename }
} #end Output-DevNewBuild



Function Get-DevFlags
{
foreach ($file in (ls -file)) {
write-host $file ; 
write-host "has changes:"; 
gc $file | select-string "(FLAG)" 

} #end foreach
} #end Get-DevFlags



Function Leet-H4x0r
{
$leet = @'
............................................________ 
....................................,.-'"...................``~., 
.............................,.-"..................................."-., 
.........................,/...............................................":, 
.....................,?......................................................, 
.................../...........................................................,} 
................./......................................................,:`^`..} 
.............../...................................................,:"........./ 
..............?.....__.........................................:`.........../ 
............./__.(....."~-,_..............................,:`........../ 
.........../(_...."~,_........"~,_....................,:`........_/ 
..........{.._$;_......"=,_......."-,_.......,.-~-,},.~";/....} 
...........((.....*~_......."=-._......";,,./`..../"............../ 
...,,,___.`~,......"~.,....................`.....}............../ 
............(....`=-,,.......`........................(......;_,,-" 
............/.`~,......`-...................................../ 
.............`~.*-,.....................................|,./.....,__ 
,,_..........}.>-._...................................|..............`=~-, 
.....`=~-,__......`,................................. 
...................`=~-,,.,............................... 
................................`:,,...........................`..............__ 
.....................................`=-,...................,%`>--==`` 
........................................_..........._,-%.......` 
..................................., 
'@
$leet
} #Leet-H4x0r



Function Test-PingJob
{
start-job { 
ping -t 8.8.8.8 
} ; 
$pingjob = (get-job).id[-1] ; 
while ((get-job $pingjob ).hasmoredata) {
receive-job $pingjob 
} #end while 
} #end Test-PingJob



Function Get-Clipboard([switch] $raw) {
#https://www.bgreco.net/powershell/get-clipboard/
	if($raw) {
		$cmd = {
			Add-Type -Assembly PresentationCore
			[Windows.Clipboard]::GetText()
		}
	} else {
		$cmd = {
			Add-Type -Assembly PresentationCore
			[Windows.Clipboard]::GetText() -replace "`r", '' -split "`n"
		}
	}
	if([threading.thread]::CurrentThread.GetApartmentState() -eq 'MTA') {
		& powershell -Sta -Command $cmd
	} else {
		& $cmd
	}
} #end Get-Clipboard


Function Stop-Explorer
{
get-process explorer | foreach { stop-process $_.id }
} #end Stop-Explorer


Function Receive-AllJobs
{
foreach ($job in (get-job).id ) { 
while ((get-job $job ).hasmoredata) { 
receive-job $job
} #end while
} #end foreach
} #end Receive-AllJobs



Function Stop-AllJobs
{
foreach ($job in (get-job).id ) {
stop-job $job
} #end foreach
} #end Stop-AllJobs


Function Watch-Clipboard
{
$cbclip = "test"
while (Get-Clipboard -ne "") { 
if ( (diff (Get-Clipboard -raw) $cbclip ) -ne $null) { 
$cbclip = Get-Clipboard -raw
$cbclip 
sleep .5
} #end if 
} #end while
} #end Watch-Clipboard


Function Send-Clipboard
{
Param(
   [Parameter(Mandatory=$True,Position=1)]
   [ipaddress]$serveraddr,
   [Parameter(Mandatory=$True,Position=2)]
   [int]$serverport,
#   [switch]$PSObject,
   [switch]$echo
)
$cbclip = "test"
while (Get-Clipboard -ne "") { 
if ( (diff (Get-Clipboard -raw) $cbclip ) -ne $null) { 
$cbclip = Get-Clipboard -raw
Send-Text -serveraddr $serveraddr -serverport $serverport -message $cbclip #-PSObject $PSObject
if ($echo){
$cbclip 
} #end if 
sleep .2
} #end if 
} #end while
} #end Send-Clipboard


Function Get-WMIDisk ([string]$Drive) {
if ($drive.length -eq 1) {
$Filter = ("DeviceID='" + $Drive + ":'")
Get-WmiObject Win32_LogicalDisk -Filter $Filter
} else {
Get-WmiObject Win32_LogicalDisk
} #end if 
} #end Get-WMIDisk 

Function Export-PuTTY
{
write-host "Exports your PuTTY profiles to $home\Desktop\putty.reg"
reg export HKCU\Software\SimonTatham $home\Desktop\putty.reg
} #end Export-PuTTY


#Function Test-NetRange ([ipaddress] )
#{
#$network = "10.250.49."
#$range = 231..249
#foreach ($i in $range) { $testout = test-connection ( $network + $i ) -quiet -count 1 ; write-host ($network + $i) $tes tout}
#foreach ($i in $range) { $testout = test-connection ( $network + $i ) -quiet -count 1 ; write-host ($network + $i) $tes tout}



#}


#Don't leave empty lines at the bottom. Update-PowerGIL is a line eater. 
#Don't leave empty lines at the bottom. Update-PowerGIL is a line eater. 
#Don't leave empty lines at the bottom. Update-PowerGIL is a line eater. 
#Don't leave empty lines at the bottom. Update-PowerGIL is a line eater. 
#Don't leave empty lines at the bottom. Update-PowerGIL is a line eater. 
#Don't leave empty lines at the bottom. Update-PowerGIL is a line eater. 

