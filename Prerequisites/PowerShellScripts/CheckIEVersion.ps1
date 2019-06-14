#.SYNOPSIS: Get Installed Version of IE  software via the registry.

$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
import-module "$CurrentPath\Logger.ps1"
function CheckIEVersion
{
#Checking 32bit Node
  if ((Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer"))
   {

      $IEVersionString= (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Internet Explorer').svcVersion.substring(0,2)

      if ($IEVersionString -eq $Version)
         {
         Write-Log -ProgramName "CheckIEVersion" -Message "Internet Explorer is installed on this machine" 
           return 1
         }
      else 
        {
         Write-Log -ProgramName "CheckIEVersion" -Message "Internet Explorer is not installed on this machine"
         return 0
        }
   }

 else
 {
 #Checking 64bit Node
   if ((Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer"))
    {

     $IEVersionString= (Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer').svcVersion.substring(0,2)
     if ($IEVersionString -eq $Version)
       {
        Write-Log -ProgramName "CheckIEVersion" -Message "Internet Explorer is installed on this machine"
         return 1
       }
    else 
      {
       Write-Log -ProgramName "CheckIEVersion" -Message "Internet Explorer is not installed on this machine"
        return 0
      }
    }

 }
}
CheckIEVersion