$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
import-module "$CurrentPath\Logger.ps1"
Function CheckAdminRights
    {
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole] "Administrator")
		  if($isAdmin -eq "Administrator")
			{
			   Write-Log -ProgramName "CheckAdminRights" -Message "User had Admin Rights"
               return 1;
            }
          else
            {   
				Write-Log -ProgramName "CheckAdminRights" -Message "User doesn't have Admin Rights"
                return 0;
			}
    }
#declaring function
CheckAdminRights

    