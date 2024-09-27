
# THIS WILL COPY THE FILES NEEDED TO EXECUTE INTO AN APPDATA DIRECTORY TO BE THEN EXECUTED VIA SCHEDULED TASKS FOR REBOOTS FROM THE REGISTRY RUN KEY
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$workingDir = "$($env:APPDATA)\custom\LIMITER"
if (!(Test-Path($workingDir))) {
   New-Item -Path $env:APPDATA -ItemType Directory -Name "\custom\LIMITER"
   Copy-Item -Path "$($scriptPath)\ChildSafetyScreenTimeLimiter.cmd", "$($scriptPath)\ChildSafetyScreenTimeLimiter.ps1", "$($scriptPath)\WAKEUP-MESSAGE.txt" -Destination $workingDir
   Write-Host "would be creating folder location and copying the scripts to that safe location to be executed"
}

<# 
    CUSTOM VARIABLES START HERE 
#>
[int]$lengthBreakTimeDefault = 2
[int]$lengthTimeTillNextBreakStarts = 4
[int]$lengthBreakTimeOvernite = 8
$runthis = "$($workingDir)\ChildSafetyScreenTimeLimiter.cmd"
$wakeUpMessageFileLocation = "$($workingDir)\WAKEUP-MESSAGE.txt"
# GET CURRENT TIME TO CALCULATE WHEN TO WAKE PC FROM SUSPEND STATE
[datetime]$timeNow = Get-Date
[datetime]$actualWakeTime = $timeNow.AddHours($lengthBreakTimeDefault)
[datetime]$wakeTime = $timeNow.AddHours($lengthBreakTimeDefault)
[datetime]$breakTimeWarning = $timeNow.AddHours($lengthTimeTillNextBreakStarts.AddHours(1 - 1.25))
[datetime]$breakTimeStarts = $timeNow.AddHours($lengthTimeTillNextBreakStarts)

<# 
    CUSTOM VARIABLES END HERE 
#>

# IF SCHEDULED TASKS ALREADY EXIST DELETE THEM BECAUSE WE NEED TO UPDATE THE TIME TO RUN
if ($null -ne (Get-ScheduledTask -TaskName "WakeUpTask" -ErrorAction SilentlyContinue)) {
    Write-Host "unregister scheduled task WakeUpTask so can create a new one"
    Unregister-ScheduledTask -TaskName "WakeUpTask" -Confirm:$false -ErrorAction SilentlyContinue
}

if ($null -ne (Get-ScheduledTask -TaskName "breaktimestartstask" -ErrorAction SilentlyContinue)) {
    Write-Host "unregister scheduled task breaktimestartstask so can create a new one"
    Unregister-ScheduledTask -TaskName "breaktimestartstask" -Confirm:$false -ErrorAction SilentlyContinue
}

if ($null -ne (Get-ScheduledTask -TaskName "breakTimeWarningtask" -ErrorAction SilentlyContinue)) {
    Write-Host "unregister scheduled task breakTimeWarningtask so can create a new one"
    Unregister-ScheduledTask -TaskName "breakTimeWarningtask" -Confirm:$false -ErrorAction SilentlyContinue
}

# GET THE CURRENT TIME TO DETERMINE IF THIS IS A LATE TIME OF DAY AND SHOULD SLEEP UNTIL MORNING OR NOT
if (($timeNow -gt "22:00:00") -or ($wakeTime -gt "22:30:00")) {
    $actualWakeTime = $timeNow.AddHours($lengthBreakTimeOvernite)
} else {
    $actualWakeTime = $timeNow.AddHours($lengthBreakTimeDefault)
}

# CREATE SCHEDULED TASK TO OPEN TEXT FILE AS A MESSAGE USING THAT BASICALLY AS THE EXCUSE TO USE THE SCHEDULED TASK TO WAKE THE PC FROM SUSPEND STATE
$action = new-scheduledtaskaction -execute 'notepad.exe' -argument $wakeupmessagefilelocation
$triggerWakeTime = new-scheduledtasktrigger -at $actualwaketime
$principal = new-scheduledtaskprincipal -userid "nt authority\system" -logontype serviceaccount -runlevel highest
$settings = new-scheduledtasksettingsset -waketorun
register-scheduledtask -taskname "wakeuptask" -action $action -trigger $triggerWakeTime -settings $settings -principal $principal    

$tasktriggerBreakWarning = new-scheduledtasktrigger -at $breakTimeWarning
$taskaction = new-scheduledtaskaction -execute $runthis -Argument "-breakTimeWarning" -workingdirectory $workingdir
register-scheduledtask 'breakTimeWarningtask' -action $taskaction -trigger $tasktriggerBreakWarning

$tasktriggerBreakStart = new-scheduledtasktrigger -at $breaktimestarts
$taskaction = new-scheduledtaskaction -execute $runthis -Argument "-breakTimeStart" -workingdirectory $workingdir
register-scheduledtask 'breaktimestartstask' -action $taskaction -trigger $tasktriggerBreakStart
