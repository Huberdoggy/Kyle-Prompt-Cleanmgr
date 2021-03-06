<#
.SYNOPSIS
Kyle-Prompt-Cleanmgr runs the 'Cleanmgr' executable with /VERYLOWDISK
parameters.

.DESCRIPTION
Kyle-Prompt-Cleanmgr runs the 'Cleanmgr' executable with /VERYLOWDISK
at the specified time in Scheduled Tasks. If the user gives the affirmative prompt, these actions are executed followed by
a system reboot to complete cleaning. Else, the user is instructed to run the script again when desired.
#>

$curr_user = $env:USERNAME
Write-Host "`nWelcome $curr_user" -fore Green

function Should_Run_Cleaner()
{
      $cleanup = $false
      $get_input = Read-Host -Prompt "Would you like to run your weekly Cleanmgr settings at this time (y/n)? "
      if ($get_input -like "y") {
           Write-Host "Success!" -fore Green
           Start-Sleep -Seconds 3
           Start-Process -FilePath "$env:windir\System32\cleanmgr.exe" -ArgumentList "/d C /VERYLOWDISK" -Wait
           if ($?) {
           $cleanup = $true
           return $cleanup
           }
      }
      else
      {
           Write-Host "Okay. Please run this script again when desired." -fore Cyan
           Start-Sleep -Seconds 3
      }
}

$outcome = Should_Run_Cleaner

if ($outcome) {
    Write-Host "Status of cleaning command execution: $outcome" -fore Green
    Write-Host "[+] System will prompt for reboot to finish cleaning in 5 seconds..." -fore Cyan
    Start-Sleep -Seconds 5
    Read-Host "Press any key to restart the system now" # set this to delay execution, Task is set with -NoExit so window will stay open
    # until closed manually by shutdown process. '/f' flag is implied when '/t' is specified. 
    shutdown /r /t 5
}
else {
    Write-Host "`n[!] Either you quit the program or an error occured.`nPlease manually run Disk Cleanup." -fore Red
    Start-Sleep -Seconds 3
}


