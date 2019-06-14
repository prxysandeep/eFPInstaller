<#.SYNOPSIS:
Identify the  Driver Information.
.DESCRIPTION:
This script will identifies the installed  Driver information.
#> 
#getting current file path
$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
#invoking the log functionality
import-module "$CurrentPath\Logger.ps1"
Function DriverInformation
 {
   if ((Get-OdbcDriver ).Name -match "$Version")
	{
      write-log -ProgramName "IdentifyDriverInformation" -Message "$Version is installed on this machine"
      return 1
    }
     else
    {
     write-log -ProgramName "IdentifyDriverInformation" -Message "$Version is not installed on this machine"
     return 0
    }
}
#Declaring function
DriverInformation