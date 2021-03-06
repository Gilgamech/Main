# midi.ps1 Build: 0 2016-05-14T09:55:19  Copyright http://www.leeholmes.com/blog/2009/04/20/powershell-audio-sequencer/

param($path, $bpm)
$scriptPath = & { Split-Path $myInvocation.ScriptName }

$trackEntries = @{}

function Update-Track { 
    $trackEntries.Clear() 
    $instrument = $null

    foreach($line in Get-Content $path) 
    { 
        if($line -match “.*Instrument (.+)([\s]*)$”) 
        { 
            $instrument = $matches[1] 
            if(-not $trackEntries[$instrument]) { $trackEntries[$instrument] = @{} } 
        } 
        elseif($line -notmatch “#|(^[\s]*$)”) 
        { 
            $note,$measures = -split $line 
            for($measure = 0; $measure -lt $measures.Length; $measure++) 
            { 
                if($measures[$measure] -ne “-“) 
                { 
                    $trackEntries[$instrument][$measure] = @($trackEntries[$instrument][$measure] + $note) 
                } 
                $trackEntries[$instrument][“Length”] = [Math]::Max($trackEntries[$instrument][“Length”], $measure) 
            } 
        } 
    } 
}

$fsw = New-Object System.IO.FileSystemWatcher (Split-Path (Resolve-Path $path).ProviderPath),$path 
Register-ObjectEvent $fsw Changed -SourceIdentifier TrackUpdated

Update-Track

Add-Type -Path (Join-Path $scriptPath “Toub.Sound.Midi.dll”) 
[Toub.Sound.Midi.MidiPlayer]::OpenMidi()

try 
{ 
    $sleep = 250 
    if($bpm) { $sleep = 1000 * 120 / (8 * $bpm) }

    $currentMeasures = @{} 
    while($true) 
    { 
        $activeNotes = @() 
    
        foreach($instrument in $trackEntries.Keys) 
        { 
            if(-not $currentMeasures[$instrument]) { $currentMeasures[$instrument] = 0 } 
            $mappedInstrument = [Toub.Sound.Midi.GeneralMidiInstruments]::$instrument

            [Toub.Sound.Midi.MidiPlayer]::Play( 
                (New-Object Toub.Sound.Midi.ProgramChange 0,0,$mappedInstrument) ) 
    
            foreach($note in $trackEntries[$instrument][$currentMeasures[$instrument]]) 
            { 
                [Toub.Sound.Midi.MidiPlayer]::Play( (New-Object Toub.Sound.Midi.NoteOn 0,0,$note,127) ) 
                $activeNotes += New-Object Toub.Sound.Midi.NoteOff 0,0,$note,127 
            }

            $currentMeasures[$instrument] = 
                ($currentMeasures[$instrument] + 1) % (1 + $trackEntries[$instrument][“Length”]) 
                
        }

        Start-Sleep -m $sleep 
        $activeNotes | % { [Toub.Sound.Midi.MidiPlayer]::Play($_) }

        if(Get-Event *TrackUpdated*) 
        { 
            Remove-Event TrackUpdated 

            Update-Track 
        } 
    } 
} 
finally 
{ 
    [Toub.Sound.Midi.MidiPlayer]::CloseMidi() 
    Unregister-Event TrackUpdated 
    Remove-Event *TrackUpdated* 
}
