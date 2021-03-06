# PowerGIL.ps1 Build 217 Date 2016-05-08T18:07:17 Copyright Gilgamech Technologies
#http://www.madwithpowershell.com/2013/11/using-excel-Functions-in-powershell.html
#To run this, put these in your profile, and set them correctly: 
# 
# $ProgramsPath = "C:\Program Files (x86)" #Program files root folder.
# $DocsPath = "C:\User\MyNameHere\Documents" #Documents root folder.
# $UtilPath = "C:\utilities" #Where you keep your utilities.
# $modulesFolder = $ProgramsPath + "\Projects\Powershell" #Powershell Modules
# $PowerGIL = $modulesFolder + "\PowerGIL.ps1" #PowerGIL location, usually in the Modules folder.
# $VIMPATH = $UtilPath + "\vim74\vim.exe" #Assumes you have Vim for Win64.
# $NppPath = $ProgramsPath + "\N++\notepad++.exe" #Assumes you have Notepad++
# $LynxW32Path = $UtilPath + "\lynx_w32\lynx.exe" #Assumes you have LYNX
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


#region Init/Misc2/System3
#Set TLS 1.2:
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

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
[int]$PowerGILBuildVersion = ([int](gc $PowerGIL)[0].split(" ")[3])
#If you could get the web version, dig out its build number. Else return 0.
if ($PowerGILWebPS1 -eq 0){
$PowerGILWebVersion = 0
} else {
[int]$PowerGILWebVersion = ($PowerGILWebPS1.Content.split(" ")[3])
} #end if

#Need this for the ASCII art converter lower down.
[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | out-null

#need to rewrite as a Case (FLAG) 
Function Get-PowerGILVersion
{
<#
.SYNOPSIS
    Returns PowerGIL version number, notes, and Function list.
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
Write-Host -foregroundcolor "Green" "PowerGIL Build:" $PowerGILBuildVersion
}else{
if ($PowerGILWebVersion -gt  $PowerGILBuildVersion  ){
Write-Host -foregroundcolor "Yellow" "Installed PowerGIL Build: " -nonewline; Write-Host -f "Red" $PowerGILBuildVersion 
Write-Host -foregroundcolor "Yellow" "Website PowerGIL Build: " -nonewline; Write-Host -f "Green" $PowerGILWebVersion 
Write-Host "You should run " -nonewline; Write-Host -f "Red" "Update-PowerGIL " ;

}else{
Write-Host -foregroundcolor "Green" "PowerGIL Build:" $PowerGILBuildVersion
} #end inner if 
}#end outer if

if ($notes){
Write-Host -foregroundcolor "Yellow" "
Build : Change notes.
212 : Found Query-Google online.
213 : Enhancement to Query-Google.
214 : Depreciation of Query-Google with the shutdown of the Google API. Numerous bugfixes and small enhancements.
215 : New-Function created
216 : Added Find-Function and improved New-Function. 
217 : Rename New-Function to New-Module, added New-Function.
" 
} #end if

if ($Functions){
Write-Host "Functions available:" -f "Yellow"
(cat $PowerGIL | Select-String "Function ") #| select -skip 2
} #end if

} #end Get-PowerGILVersion


Function Get-PSVersion
{
if ($PSVersionTable.psversion.major -ge 4) {
Write-Host "PowerShell Version: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Build).$($PSVersionTable.PSVersion.Revision)" -ForegroundColor Yellow 
} else {
Write-Host "PowerShell Version: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)" -ForegroundColor Yellow 
} #end if
} #end Get-PSVersion


#$DontShowPSVersionOnStartup = $false # to turn off Powershell Version display.
if (($ShowPSVersionOnStartup)){
Get-PSVersion
}


#$DontShowPoweGILVersionOnStartup = $false # to turn off PowerGIL Build display.
if (!($DontShowPoweGILVersionOnStartup)){
Get-PowerGILVersion
}

#Hate VIM
if ($VIMPATH) {
Set-Alias vi   $VIMPATH
Set-Alias vim  $VIMPATH
} else {
Write-Host -f red "VIM not found, disabling alias." 
} #end if VI

#Love Notepad++i
if ($NppPATH) {
Set-Alias note  $NppPATH
} else {
Write-Host -f red "Notepad++ not found, disabling alias."
} #end if N++

#Fight with LYNX
if ($LynxW32Path) {
Set-Alias LYNX  $LynxW32Path
} else {
Write-Host -f red "LYNX not found, disabling alias."
} #end if LYNX
#endregion

#region System2
#Open here in Explorer.
Function Open-Explorer($Location)
{
if ($Location){
explorer.exe $Location
} else {
explorer.exe (Get-Location)
} #end if else
} #end Open-Explorer


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

#endregion


#region Misc/System
#Github
Function Get-GithubStatus
{
$r = Invoke-RestMethod -Uri "https://status.github.com/api/status.json?callback=apiStatus"
$s = ConvertFrom-Json $r.substring(10,($r.Length - 11))
$s.last_updated = get-date ($s.last_updated)
$s
} #end Get-GithubStatus


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



Function Get-Clipboard
#https://www.bgreco.net/powershell/get-clipboard/
{
Param(
    [switch]$JSON,
	[switch]$raw
) 
	Add-Type -Assembly PresentationCore
	if($raw) {
		$cmd = {
			[Windows.Clipboard]::GetText()
		}
	} else {
		$cmd = {
			[Windows.Clipboard]::GetText() -replace "`r", '' -split "`n"
		}
	} #end if
	
	if ($JSON) {
		$cmd = $cmd | ConvertFrom-JSON
	}
	
	if([threading.thread]::CurrentThread.GetApartmentState() -eq 'MTA') {
		& powershell -Sta -Command $cmd
	} else {
		& $cmd
	} #end if
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


Function Set-PSWindowSize
#from http://www.powershellserver.com/support/articles/powershell-server-changing-terminal-width/
{
[CmdletBinding()]
Param(
   [int]$Rows = 0,
   [int]$Columns = 0 #,
#   [switch]$Quiet
)
$pshost = Get-Host              # Get the PowerShell Host.
$pswindow = $pshost.UI.RawUI    # Get the PowerShell Host's UI.

$maxWindowSize = $pswindow.MaxPhysicalWindowSize # Get the max window size. 
$newBufferSize = $pswindow.BufferSize # Get the UI's current Buffer Size.
$newWindowSize = $pswindow.windowsize # Get the UI's current Window Size.

if ($Rows -gt $maxWindowSize.height) {
#if (!($Quiet)) { Write-Host -f y "Max height $($maxWindowSize.height) rows tall." }
write-verbose "Max height $($maxWindowSize.height) rows tall."
$Rows = $maxWindowSize.height
} #end if rows check 

if ($Columns -gt $maxWindowSize.width) {
#if (!($Quiet)) { Write-Host -f y "Max width $($maxWindowSize.width) columns wide." }
write-verbose "Max width $($maxWindowSize.width) columns wide."
$Columns = $maxWindowSize.width
} #end if columns check


$oldBufferSize = $newBufferSize             # Save the oldsize.
$oldWindowSize = $newWindowSize

if ($Rows -gt 0 ) {
#$rows #It keeps jumping to the "if these are equal" section at the bottom.

$newWindowSize.height = $Rows

} if ($oldWindowSize.height -eq $Rows) {
#$rows
#if (!($Quiet)) { Write-Host -f yellow "Window is already $($newWindowSize.height) rows tall." }
write-verbose "Window is already $($newWindowSize.height) rows tall."
} else {

$pswindow.windowsize = $newWindowSize # Set the new Window Size as active.

} #end if Rows exists.



if ($Columns -gt 0) {
$newWindowSize.width = $Columns            # Set the new buffer's width to 150 columns.
$newBufferSize.width = $Columns

if ($newWindowSize.width -gt $oldWindowSize.width) {

$pswindow.buffersize = $newBufferSize # Set the new Buffer Size as active.
$pswindow.windowsize = $newWindowSize # Set the new Window Size as active.

} elseif ($oldWindowSize.width -gt $newWindowSize.width) { #Order is important, buffer must always be wider.

$pswindow.windowsize = $newWindowSize # Set the new Window Size as active.
$pswindow.buffersize = $newBufferSize # Set the new Buffer Size as active.

} elseif ($oldWindowSize.width -eq $newWindowSize.width) {
#if (!($Quiet) { Write-Host -f yellow "Window is already $($newWindowSize.width) columns wide." }

write-verbose "Window is already $($newWindowSize.width) columns wide."
} #end if -gt
} #end if WindowWidth exists.



} #end Function
New-Alias -name spsz -value Set-PSWindowSize
#Should I add a setting to my profile to set buffer to 3000, maybe set other settings like bg color? (FLAG)


Function Set-PSWindowStyle {
param(
    [Parameter()]
    [ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE',
                 'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED',
                 'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
    $Style = 'MINIMIZE',

    [Parameter()]
    $MainWindowHandle = (Get-Process -id $pid).MainWindowHandle
)
    $WindowStates = @{
        'FORCEMINIMIZE'   = 11
        'HIDE'            = 0
        'MAXIMIZE'        = 3
        'MINIMIZE'        = 6
        'RESTORE'         = 9
        'SHOW'            = 5
        'SHOWDEFAULT'     = 10
        'SHOWMAXIMIZED'   = 3
        'SHOWMINIMIZED'   = 2
        'SHOWMINNOACTIVE' = 7
        'SHOWNA'          = 8
        'SHOWNOACTIVATE'  = 4
        'SHOWNORMAL'      = 1
    }

$memberDefintion = @"
    [DllImport("user32.dll")]
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
"@

    $Win32ShowWindowAsync = Add-Type -memberDefinition $memberDefintion -name "Win32ShowWindowAsync" -namespace Win32Functions -passThru

    $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[$Style]) | Out-Null
    Write-Verbose ("Set Window Style '{1} on '{0}'" -f $MainWindowHandle, $Style)

} #end Function
New-Alias -name spsy -value Set-PSWindowStyle


#System WMI stuffs
Function Invoke-WMIInstaller
{

Param(
[String]$Uninstall
)

$IsElevated = (whoami /all | select-string S-1-16-12288) -ne $null

#It takes a long time to run, so I'll just repeat myself down there. That way I can check if this is in admin without making the user wait for the list to load.
#$app = Get-WmiObject -Class Win32_Product
Write-Host "This may take a minute or two..."
if ($Uninstall) {
if ($IsElevated) {
$app = Get-WmiObject -Class Win32_Product
$uninstallapp = $app | Where-Object { $_.Name -match $Uninstall }
$uninstallapp.uninstall()
} else {

Write-Host -f red "Please run in Administrator Powershell"
break
} #end if iselevated

} else { #if not uninstall, display a list of stuff to uninstall.

$app = Get-WmiObject -Class Win32_Product
$app.name | sort
Write-Host -f yellow "Please copy one of the items in the list above, and re-run with -Uninstall option."


} #end if uninstall

} #end Function




Function Get-WMIDisk 
{
Param(
[String]$Drive,
[Switch]$Raw
)


if ($drive.length -eq 1) {

$Filter = ("DeviceID='" + $Drive + ":'")
$GWD = Get-WmiObject Win32_LogicalDisk -Filter $Filter

} else {

[object]$GWD = Get-WmiObject Win32_LogicalDisk

} #end if Drive


if ($Raw) {

$GWD

} else {

foreach ($drive in $GWD) {

$drive = [object]$drive
$drive
$drive.DeviceID
$drive.size
if ($drive.size -gt 0) {
[math]::Round((($drive.FreeSpace / $drive.Size) * 100)).tostring() + "% free in drive" + $drive.DeviceID
#$drive.DeviceID + "has" + [math]::Round((($drive.FreeSpace / $drive.Size) * 100)).tostring() + "% free."


} #end if drivesize gt 0
} #end foreach drive

} #end if Raw


} #end Get-WMIDisk 



Function Get-UsGovWeather
#https://blogs.technet.microsoft.com/heyscriptingguy/2010/11/07/use-powershell-to-retrieve-a-weather-forecast/
{
 Param([string]$zip = 98104,
       [int]$numberDays = 4,
      [switch]$Fahrenheit
	   )
$URI = "http://www.weather.gov/forecasts/xml/DWMLgen/wsdl/ndfdXML.wsdl"
$Proxy = New-WebServiceProxy -uri $URI -namespace WebServiceProxy
[xml]$latlon=$proxy.LatLonListZipCode($zip)
foreach($l in $latlon)
{
 $a = $l.dwml.latlonlist -split ",";
 $lat = $a[0]
 $lon = $a[1]
 $sDate = get-date -UFormat %Y-%m-%d
 $format = "Item24hourly"
if ($Fahrenheit) { $unit = "e" }else { $unit = "m" } 
 [xml]$weather = $Proxy.NDFDgenByDay($lat,$lon,$sDate,$numberDays,$unit,$format)
 For($i = 0 ; $i -le $numberDays -1 ; $i ++)
 {
  New-Object psObject -Property @{
  "Date" = ((Get-Date).addDays($i)).tostring("MM/dd/yyyy") ;
  "maxTemp" = $weather.dwml.data.parameters.temperature[0].value[$i] ;
  "minTemp" = $weather.dwml.data.parameters.temperature[1].value[$i] ;
  "Summary" = $weather.dwml.data.parameters.weather."weather-conditions"[$i]."Weather-summary"}
 }
}
} #end Function Get-UsGovWeather



Function Export-PuTTY
{
Write-Host "Exports your PuTTY profiles to $home\Desktop\putty.reg"
reg export HKCU\Software\SimonTatham $home\Desktop\putty.reg
} #end Export-PuTTY


Function Test-PortConnection {
[CmdletBinding()]
Param(
    [Parameter(Position=1)]
    [IPAddress]$IPAddress = "127.0.0.1",
    [Parameter(Position=2)]
    [int]$Port = 443
)
try {
(new-object Net.Sockets.TcpClient).Connect("$($IPAddress.IPAddressToString)", $Port)
} catch {
return $false
write-verbose -Message "Connection failed.";
break
} 
return $true
write-verbose -Message "Connection succeeded.";

} #end Test-PortConnection

#endregion

#region PowerGIL stuffs
Function Backup-PowerGIL
{
if (!(test-path $PowerGILBackupPath)){md $PowerGILBackupPath}

#Set up page to increment versions
if ($PowerGILMaster -eq 1) {
$PowerGILBuildVersion++
} #end if

$PowerGILVer = "# PowerGIL.ps1 Build "  + ($PowerGILBuildVersion) + " Date " + (get-date -f s) + " Copyright Gilgamech Technologies"
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
Write-Host "$latestPowerGIL created. Build incremented to " -foregroundcolor "Yellow" -nonewline; Write-Host -f "Green"
($PowerGILBuildVersion)
 } else {
Copy-Item $PowerGIL "$PowerGILBackupPath\PowerGIL.bak"
$latestPowerGIL = (ls | sort LastWriteTime -Descending)[0].name
#$latestPowerGIL = (ls $PowerGILBackupPath)[-1].name
#Write-Host "PowerGIL version $PowerGILBuildVersion written to backup. " -foregroundcolor "Green"

} #end if
#Used to Reload-PowerGIL but that doesn't actually reset everything. Need a full restart for some raisin.
Restart-Powershell
} #end Backup-PowerGIL



Function Reload-PowerGIL
{
Write-Host "Reloading PowerGIL..." -foregroundcolor "Yellow" 
Import-Module $PowerGIL -force
} #end Reload-PowerGIL
Function Reload-Profile
{
Import-Module $Profile -force
} #end Reload-Profile



Function Update-PowerGIL
{
Copy-Item $PowerGIL "$PowerGIL.bak"
Write-Host "$PowerGIL.bak created." -foregroundcolor "Yellow"

#If it starts with the header's leading hash
if ((-join $PowerGILWebPS1.Content[0]) -eq "#") {
#Write PowerGILWebPS1 to PowerGIL.
(-join $PowerGILWebPS1.content) > $PowerGIL
} else {
#Else snip 3-letter UTF8 BOM off the front because I can't figure out how to write without that.
(-join $PowerGILWebPS1.content).Substring(3,$PowerGILWebPS1.Content.Length-3) > $PowerGIL
}
Write-Host -f yellow"Restarting Powershell..." #Reload message.
Restart-Powershell
} #end Function

#Should add in a Function param (FLAG)
Function Restore-PowerGIL
{
#$latestPowerGIL = (ls $PowerGILBackupPath)[-1].name
$PowerGILRestoreVersion = $PowerGILBuildVersion - 1
$latestPowerGIL = (ls $PowerGILBackupPath)[-1].name
Copy-Item $latestPowerGIL $PowerGIL
Reload-PowerGIL
Write-Host "PowerGIL restored from backup." -foregroundcolor "Green" 
} #Restore-PowerGIL

#endregion


#region Profile things
Function Backup-Profile
{
if (!(test-path $PowerGILBackupPath)){md $PowerGILBackupPath}
Copy-Item $Profile "$PowerGILBackupPath\Microsoft.Powershell_profile.ps1"
Write-Host "Profile $Profile copied to backup $PowerGILBackupPath\Microsoft.Powershell_profile.ps1" -foregroundcolor "Green" 
} #Backup-Profile


Function Restore-Profile
{
Copy-Item "$PowerGILBackupPath\Microsoft.Powershell_profile.ps1" $Profile
Reload-Profile
Write-Host "Profile restored from backup." -foregroundcolor "Green" 
} #Restore-Profile

#endregion


#region PowerShiri
Function Start-PowerShiri 
#Need to make like "PowerShiriAdmin" module that runs as admin and beats up the other functions (FLAG)
{
Import-Module "C:\Dropbox\PowerShiri\PowerShiri.ps1" -Force
}; #end Start-PowerShiri
#Speech

Function Read-Webpage ($URL) {
$ycom = iwr $URL
$yih = ($ycom.ParsedHtml.getElementsByTagName("p") | select innerhtml ).innerhtml
return $yih
} #end Read-Webpage


Function Say-This
#Rename to Out-Speech?
{
Param(
   [string]$saythis = "Type something for me to say"
)
Add-Type -AssemblyName System.Speech
$synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$synthesizer.Speak($saythis)
}
#endregion

#region Time
Function Convert-Time
{
	#Todo: 
	#1 Make "totime" default PST
	#2 Make "fromtimepartialname" & "totimepartialname"
	#3 Make a way to list time zones
	#4 Make a way to display your time zone
	#5 Make "-shortlist" for common US/EU zones
	param(
		[Parameter(Mandatory=$true,Position=1)]
		[string]$time = (get-date),
		[Parameter(Mandatory=$true,Position=2)]
		[string]$fromTimeZone, # = [System.TimeZone]::CurrentTimeZone.StandardName, 
		[Parameter(Mandatory=$False,Position=3)]
		[string]$toTimeZone = [System.TimeZone]::CurrentTimeZone.StandardName,
		[switch]$UTCtoo,
		[string]$fromTimeZonePartName,
		[string]$toTimeZonePartName,
		[string]$FromTZShortName,
		[validateset("AST","BST","CST","CUT","DST","EST","FST","GST","HST","IST","JST","KST","LST","MST","NST","PST","RST","SST","TST","UST","VST",)]
		[string]$ToTZShortName
		[validateset("AST","BST","CST","CUT","DST","EST","FST","GST","HST","IST","JST","KST","LST","MST","NST","PST","RST","SST","TST","UST","VST",)]
	)
	  $oFromTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($fromTimeZone)
	  $oToTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($toTimeZone)
	  $utc = [System.TimeZoneInfo]::ConvertTimeToUtc($time, $oFromTimeZone)
	  $newTime = [System.TimeZoneInfo]::ConvertTime($utc, $oToTimeZone)

	  foreach ($tz in [System.TimeZoneInfo]::GetSystemTimeZones() |  where {$_.ID -like "*$fromTimeZonePartName*"}) {
	  
	  ($tz.id) + ": " + (convert-time -fromTimeZone $tz.id -time (get-date))
	  
	  } #end foreach
	  
	  
	  $newtime

	if ($UTCtoo){
	   $utc
	} #end if 
} #end Function

#$r = foreach ($name in (([System.TimeZoneInfo]::GetSystemTimeZones()).standardname)) {-join (($name).split(" ") | foreach {$_[0]})} ; $r | select -Unique | where {$_.length -eq 3} | sort

#if ( [System.TimeZone]::CurrentTimeZone.IsDaylightSavingTime( (get-date) ) ) { Write-Host "Daylight Savings Time!" }
#[System.TimeZoneInfo]::GetSystemTimeZones() |  where {$_.ID -like "*pacific*"}

#endregion


#region Music!
Add-Type -AssemblyName presentationCore
$wmplayer = New-Object System.Windows.Media.MediaPlayer
#http://www.adminarsenal.com/admin-arsenal-blog/powershell-music-remotely/
Function Start-Music
{
param(
   [Parameter(Mandatory=$True,Position=1)]
   [uri]$Filename
)
#Add-Type -AssemblyName presentationCore
#$Filename = [uri] "C:\temp\Futurama - Christmas Elves song.mp3"
#$wmplayer = New-Object System.Windows.Media.MediaPlayer
$wmplayer.Open($Filename)
Start-Sleep 2 # This allows the $wmplayer time to load the audio file
#$duration = $wmplayer.NaturalDuration.TimeSpan.TotalSeconds
$wmplayer.Play()
}

Function Stop-Music
{
$wmplayer.Stop()
$wmplayer.Close()
}

#endregion

#region Conversions
Filter Flip-TextToBinary
{
[System.Text.Encoding]::UTF8.GetBytes($_) | %{ 
[System.Convert]::ToString($_,2).PadLeft(8,'0')
}
#[System.Text.Encoding]::UTF8.GetBytes([System.Convert]::ToString($_,2).PadLeft(8,'0'))
}

Filter Flip-BinaryToText
{
Param(
   [switch]$ASCII
)
if ($ASCII) {
#[System.Text.Encoding]::ASCII.GetBytes($_)
%{ 
[System.Text.Encoding]::ASCII.GetString([System.Convert]::ToInt32($_,2)) 
} #end foreach
} else {
%{ 
[System.Text.Encoding]::UTF8.GetString([System.Convert]::ToInt32($_,2)) 
} #end foreach
} #end if
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
} #end if
} #end Filter

<# Filter Flip-TextToHex
{
Param(
   [switch]$ASCII
)
if ($ASCII) {
$ab = [System.Text.Encoding]::ASCII.GetBytes($_);
} else {
$ab = [System.Text.Encoding]::UTF8.GetBytes($_);
} #end if
$ac = [System.BitConverter]::ToString($ab);
$ac.split("-")
} #end Filter
 #>


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

#endregion


#region Encryption
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

#endregion

#region Images
Function Invoke-PowerGilImage
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


# Loosely based on http://www.vistax64.com/powershell/202216-display-image-powershell.html
Function Display-Image 
{
Param(
   [Parameter(Mandatory=$True,Position=1)]
   [string]$Filename
)
[void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")

$file = (get-item $Filename)
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


Function ConvertImage-ToASCIIArt
{
#------------------------------------------------------------------------------ 
# Copyright 2006 Adrian Milliner (ps1 at soapyfrog dot com) 
# http://ps1.soapyfrog.com 
# 
# This work is licenced under the Creative Commons  
# Attribution-NonCommercial-ShareAlike 2.5 License.  
# To view a copy of this licence, visit  
# http://creativecommons.org/licenses/by-nc-sa/2.5/  
# or send a letter to  
# Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA. 
#------------------------------------------------------------------------------ 
 
#------------------------------------------------------------------------------ 
# This script loads the specified image and outputs an ascii version to the 
# pipe, line by line. 
# 
param( 
  [Parameter(Mandatory=$True,Position=1)]
  [string]$path, #= $(throw "Supply an image path"), 
  [int]$maxwidth,            # default is width of console 
  [string]$palette="ascii",  # choose a palette, "ascii" or "shade" 
  [float]$ratio = 1.5        # 1.5 means char height is 1.5 x width 
  ) 
 
 
#------------------------------------------------------------------------------ 
# here we go 
 
$palettes = @{ 
  "ascii" = " .,:;=|iI+hHOE#`$" 
  "shade" = " " + [char]0x2591 + [char]0x2592 + [char]0x2593 + [char]0x2588 
  "bw"    = " " + [char]0x2588 
} 
$c = $palettes[$palette] 
if (-not $c) { 
  write-warning "palette should be one of:  $($palettes.keys.GetEnumerator())" 
  write-warning "defaulting to ascii" 
  $c = $palettes.ascii 
} 
[char[]]$charpalette = $c.ToCharArray() 
 
# We load the drawing assembly at the top of PowerGIL

if ($path.Substring(1,1) -notmatch ":") {
#This checks if it's the full path (checks for the colon in c:\file.txt) cuz otherwise it gets stuck in the folder where Powershell was opened.
$path = ( (Get-Location).path + "\" + $path )
} #end if 

# load the image
$image = [Drawing.Image]::FromFile($path)  
if ($maxwidth -le 0) { [int]$maxwidth = $host.ui.rawui.WindowSize.Width - 1} 
[int]$imgwidth = $image.Width 
[int]$maxheight = $image.Height / ($imgwidth / $maxwidth) / $ratio 
$bitmap = new-object Drawing.Bitmap ($image,$maxwidth,$maxheight) 
[int]$bwidth = $bitmap.Width; [int]$bheight = $bitmap.Height 
# draw it! 
$cplen = $charpalette.count 
for ([int]$y=0; $y -lt $bheight; $y++) { 
  $line = "" 
  for ([int]$x=0; $x -lt $bwidth; $x++) { 
    $colour = $bitmap.GetPixel($x,$y) 
    $bright = $colour.GetBrightness() 
    [int]$offset = [Math]::Floor($bright*$cplen) 
    $ch = $charpalette[$offset] 
    if (-not $ch) { $ch = $charpalette[-1] } #overflow 
    $line += $ch 
  } 
  $line 
} 

} #end Function
new-alias -name ciai -value ConvertImage-ToASCIIArt



#endregion

#region +++ UDP Playground +++
#http://powershell.com/cs/blogs/tips/archive/2012/05/09/communicating-between-multiple-powershells-via-udp.aspx
Function Send-UDPText 
{
	Param(
		[Parameter(Mandatory=$True,Position=1)]
		[ipaddress]$serveraddr,
		[Parameter(Mandatory=$True,Position=2)]
		[int]$serverport,
		[Parameter(Mandatory=$True,Position=3)]
		[object]$Message,
		[switch]$JSON,
		[switch]$Secure
	)

	#Basic protection, at least it's not plaintext. Doesn't work with JSON IIRC.
	if ($Secure) {
		Write-Host "Converting to SecureString..." -f "Yellow"
		$Message = ConvertTo-SecureString -AsPlainText $Message.ToString() -Force
		Write-Host "Conversion complete, sending." -f "Green"
	} #end if
	
	#Send Objects with JSON flag set on both sender and listener, otherwise they'll just be the useless output strings.
	if ($JSON) {
		$Message = ConvertTo-JSON $Message
	} #end if
		
		#Create endpoint & UDP client
		$endpoint = New-Object System.Net.IPEndPoint ($serveraddr,$serverport)
		$udpclient= New-Object System.Net.Sockets.UdpClient
		
		#Swaps the message from ASCII to bytes. Should change for like Flip-TextToBytes (FLAG)
		$bytes=[Text.Encoding]::ASCII.GetBytes($Message)
		$bytesSent=$udpclient.Send($bytes,$bytes.length,$endpoint)
		$udpclient.Close()
} #end Send-Text 


Function Start-UDPListen 
#http://powershell.com/cs/blogs/tips/archive/2012/05/09/communicating-between-multiple-powershells-via-udp.aspx
{
	Param(
		[Parameter(Mandatory=$True,Position=1)]
		[int]$ServerPort,
		[Parameter(Position=2)]
		[switch]$Continuous,
		[Parameter(Position=3)]
		[switch]$JSON,
		[switch]$Secure
	) #end Param
	#If there's no endpoint, create one - this tries to avoid errors that the endpoint already exists.
	#Swap [IPAddress]::Any for an address (or range?) to limit who can send to this.
	if ($endpoint.port -eq $null) {
		$endpoint = New-Object System.Net.IPEndPoint ([IPAddress]::Any,$serverport)
	} #end if

	Write-Host "Now listening on port" $serverport -f "Green"
	if (($Continuous)) {
		Write-Host "Continuous mode" -f "Red"
	} #end if
	
	#Create the socket
	$udpclient = New-Object System.Net.Sockets.UdpClient $serverport

	#Quick and dirty way to loop when iterate is set to true. 
	$iterate = $true
	while ($iterate) {
		#Open socket, store 
		$content = $udpclient.Receive([ref]$endpoint)
		#Swaps the message from bytes to ASCII. Should change for like Flip-BytesToText (FLAG)
		$content = [Text.Encoding]::ASCII.GetString($content)

		#If you're receiving Objects, expect them to be sent as JSON strings, so convert them back to Objects.
		if ($JSON) {
			$content = ConvertFrom-JSON $content
		} else {	} #end if - Not sure what was going there.
		if ($Secure) {
			$content = ConvertFrom-SecureToPlain $content
		} #end if

		#If Continuous flag wasn't set, dump us from the loop.
		if (!($Continuous)) {
			$iterate = $false
		} #end if
		
		#Unsure of output format, this way just works. 
		$content

	} # end while

} #end Start-Listen

# endregion




#region Devstuffs
Function Out-DevBuild {
	Param(
		[Parameter(Mandatory=$True,Position=1)]
		[string]$Filename,
		[string]$Copyright =" Copyright Gilgamech Technologies", #This is only for passthru if new file.
		[string]$dtstamp = (get-date -f s)
	)
	#1. Parse the top line of the file. Format: 
	# $Filename Build $build : $Datestamp $Copyright
	if (test-path $Filename) {
		#If file exists:

		$filecontents = gc $Filename
		$filesplit = $filecontents[0].split(" ") | select -Unique
		# "#" = $filesplit[0]
		#$Filename = $filesplit[1]
		#"Build" = $filesplit[2]
		[int]$build = $filesplit[3]
		#$dtstamp = $filesplit[4]
		[string]$Copyright =  $filesplit[5] + " " + $filesplit[6] + " " + $filesplit[7] + " " + $filesplit[8] + " " + $filesplit[9] + " " + $filesplit[10]

		#2. Increment the build number and update the datestamp.
		$build += 1
		Write-Host -f green "$Filename build incremented to $build."

		#3. Write a new top line.
	$filecontents[0] = "# $Filename Build: $build $dtstamp $Copyright"

	$filecontents > $Filename

	#4. Copy to builds folder with build number appended as extension.
	if (!(test-path .\builds)) {md .\Builds}
	copy $Filename .\builds\$Filename.$build

	} else {
		New-Module -Filename $Filename -Copyright $Copyright
	} #end if 


	} #end Out-DevBuild


Function New-Module {
#Have it take a line number as input (FLAG)
	Param(
		[string]$Filename = "New-Module.ps1",
		[string]$Copyright =" Copyright Gilgamech Technologies", #Default to GT ;)
		[int]$build = 0,
		[string]$dtstamp = (get-date -f s)
	)
	$filecontents = "# $Filename Build: $build $dtstamp $Copyright
	
	"
	New-Function
	<#
	$filecontents2 = Find-Function -FunctionName New-Function
	#Swap out the top line.
	
	#Write file
	$filecontents > $Filename
	$filecontents2 >> $Filename
	#>
	Write-Host -f green "$Filename build $build created."

	#Copy to builds folder with build number appended as extension.
	#Replace with Out-DevBuild (FLAG)
	if (!(test-path .\builds)) {md .\Builds}
	copy $Filename .\builds\$Filename.$build

} #end New-Module


#Copies this function into a file at the specified line number.
#Add in copyright and build for each function (FLAG)
		
Function New-Function {
<#
.SYNOPSIS
    Writes a new function to a file.
.DESCRIPTION
    Author   : Gilgamech
    Last edit: 5/8/2016
.EXAMPLE
    New-Function .\PowerShiriAdmin.ps1 289 -nos
#>
	[CmdletBinding()]
	Param(
		[Parameter(Position=1)]
		[string]$Filename = "New-Module.ps1",
		[Parameter(Position=2)]
		[int]$LineNumber = 1,
		[string]$FunctionName = "New-Function",
		[string]$SourceModule = $PowerGIL,
		[switch]$NoSpace
		[string]$Parameters
		[string]$Operators
#		[string]$Copyright =" Copyright Gilgamech Technologies", #Default to GT ;)
#		[int]$build = 1,
#		[string]$dtstamp = (get-date -f s)
	) #end Param
	
	#1 set up
	$Spacing = "
	"
	$paramsvar = @{}
	[int]$varnum = 0
	
	#Handle the file not found better than Powershell does - test-path chokes HARD. 
	if (test-path $Filename) {
		$Filecontents = gc $Filename
	} else {
	Write-Verbose "File not found."
	Return 0
	Break
	}# end test-path Filename

	#2 build function

	<#
	foreach ($parameterset in $Parameters) {
	$varnum++
	$paramsvar += ("`[$parameterset`]`$Variable" + $varnum)
	
	} #end foreach
	#>
	<#
	foreach ($operatorset in $Operators) {
	$varnum++
	$paramsvar += ("`[$parameterset`]`$Variable" + $varnum)
	
	} #end foreach
	#>


	#3 rewrite function

	#	$functioncontents = "# $Filename Build: $build $dtstamp $Copyright
#	
#	"
	$functioncontents2 = Find-Function -FunctionName $FunctionName	
	
	#4 write function
	$filecontents[0.. ($LineNumber -2)] > $Filename
	if (!($NoSpace)){
		$Spacing >> $Filename
	} #end if 
	$functioncontents2 >> $Filename
	if (!($NoSpace)){
		$Spacing >> $Filename
	} #end if 
	$filecontents[($LineNumber -1 ) ..($Filecontents.length)] >> $Filename

	
} #end New-Function

Function New-IfStatement {
<#
.SYNOPSIS
    Writes a new IfStatement to a file.
.DESCRIPTION
    Author   : Gilgamech
    Last edit: 5/8/2016
.EXAMPLE
    New-IfStatement .\PowerShiriAdmin.ps1 289 -nos
#>
	[CmdletBinding()]
	Param(
		[Parameter(Position=1)]
		[string]$Filename = "New-Module.ps1",
		[Parameter(Position=2)]
		[int]$LineNumber = 1,
		[string]$FunctionName = "New-IfStatement",
		[string]$SourceModule = $PowerGIL,
		[switch]$NoSpace
		[string]$Parameters
		[string]$Operators
#		[string]$Copyright =" Copyright Gilgamech Technologies", #Default to GT ;)
#		[int]$build = 1,
#		[string]$dtstamp = (get-date -f s)
	) #end Param
	
	#1 set up
	$Spacing = "
	"
	$paramsvar = @{}
	[int]$varnum = 0
	
	#Handle the file not found better than Powershell does - test-path chokes HARD. 
	if (test-path $Filename) {
		$Filecontents = gc $Filename
	} else {
	Write-Verbose "File not found."
	Return 0
	Break
	}# end test-path Filename

	#2 build function

#Insert-Function - Inserts the named function from the specified source module to the target module at the listed line number.

	<#
	foreach ($parameterset in $Parameters) {
	$varnum++
	$paramsvar += ("`[$parameterset`]`$Variable" + $varnum)
	
	} #end foreach
	#>
	<#
	foreach ($operatorset in $Operators) {
	$varnum++
	$paramsvar += ("`[$parameterset`]`$Variable" + $varnum)
	
	} #end foreach
	#>


	#3 rewrite function

	#	$functioncontents = "# $Filename Build: $build $dtstamp $Copyright
#	
#	"
	$functioncontents2 = Find-Function -FunctionName $FunctionName	
	
	#4 write function
	$filecontents[0.. ($LineNumber -2)] > $Filename
	if (!($NoSpace)){
		$Spacing >> $Filename
	} #end if 
	$functioncontents2 >> $Filename
	if (!($NoSpace)){
		$Spacing >> $Filename
	} #end if 
	$filecontents[($LineNumber -1 ) ..($Filecontents.length)] >> $Filename

	
} #end New-IfStatement




Function Find-Function {
	Param(
		[string]$FunctionName = "Find-Function",
		[string]$Filename = $PowerGIL,
		[switch]$LineNumbers
#		[switch]$Import
		) #end Param
	$pg = gc $Filename
	#How to handle if string not found?
	$startline = ((($pg | select-string "Function $FunctionName").LineNumber) - 1)
	$endline = ((($pg | select-string "} #end $FunctionName").LineNumber) - 1)
    $pgse = $pg[($startline)..($endline)]

	if	($LineNumbers) {
		$startline
		$endline
	} else {
		return $pgse
	} #end if
} #end Find-Function

<#
	if ($import) { #Doesn't work
		$jqqhgpgse = "$home\jqqhgpgse.ps1"
		$pgse > $jqqhgpgse
		ipmo $jqqhgpgse -force
#		rm $jqqhgpgse
	} #end if import
#>


# Make something that grabs the last thing in your Powershell buffer and clips it. (FLAG)

Function Get-DevFlags {
foreach ($file in (ls -file)) {
Write-Host $file ; 
Write-Host "has changes:"; 
gc $file | select-string "(FLAG)" 

} #end foreach
} #end Get-DevFlags


Function Compare-DevBuilds { 
Param(
	[string]$Filename,
	[int]$FirstBuild,
	[int]$SecondBuild
); 
diff (gc .\Builds\$Filename.$FirstBuild) (gc .\Builds\$Filename.$SecondBuild);
}; #end Compare-DevBuilds


#endregion 


#region Enables the [Audio] stuffs. 
#https://stackoverflow.com/questions/255419/how-can-i-mute-unmute-my-sound-from-powershell
Add-Type -TypeDefinition @'
using System.Runtime.InteropServices;

[Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IAudioEndpointVolume {
  // f(), g(), ... are unused COM method slots. Define these if you care
  int f(); int g(); int h(); int i();
  int SetMasterVolumeLevelScalar(float fLevel, System.Guid pguidEventContext);
  int j();
  int GetMasterVolumeLevelScalar(out float pfLevel);
  int k(); int l(); int m(); int n();
  int SetMute([MarshalAs(UnmanagedType.Bool)] bool bMute, System.Guid pguidEventContext);
  int GetMute(out bool pbMute);
}
[Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDevice {
  int Activate(ref System.Guid id, int clsCtx, int activationParams, out IAudioEndpointVolume aev);
}
[Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDeviceEnumerator {
  int f(); // Unused
  int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
}
[ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorComObject { }

public class Audio {
  static IAudioEndpointVolume Vol() {
    var enumerator = new MMDeviceEnumeratorComObject() as IMMDeviceEnumerator;
    IMMDevice dev = null;
    Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint(/*eRender*/ 0, /*eMultimedia*/ 1, out dev));
    IAudioEndpointVolume epv = null;
    var epvid = typeof(IAudioEndpointVolume).GUID;
    Marshal.ThrowExceptionForHR(dev.Activate(ref epvid, /*CLSCTX_ALL*/ 23, 0, out epv));
    return epv;
  }
  public static float Volume {
    get {float v = -1; Marshal.ThrowExceptionForHR(Vol().GetMasterVolumeLevelScalar(out v)); return v;}
    set {Marshal.ThrowExceptionForHR(Vol().SetMasterVolumeLevelScalar(value, System.Guid.Empty));}
  }
  public static bool Mute {
    get { bool mute; Marshal.ThrowExceptionForHR(Vol().GetMute(out mute)); return mute; }
    set { Marshal.ThrowExceptionForHR(Vol().SetMute(value, System.Guid.Empty)); }
  }
}
'@


#endregion 


#Don't leave empty lines at the bottom. Update-PowerGIL is a line eater. 
#Don't leave empty lines at the bottom. Update-PowerGIL is a line eater. 
#Don't leave empty lines at the bottom. Update-PowerGIL is a line eater. 
#Don't leave empty lines at the bottom. Update-PowerGIL is a line eater. 
#Don't leave empty lines at the bottom. Update-PowerGIL is a line eater. 
#Don't leave empty lines at the bottom. Update-PowerGIL is a line eater. 

