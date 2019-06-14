#.SYNOPSIS: Get Installed Version of VC++ Redist<2015>software via the registry.
#.Description:Checks to see if the software is installed or not.
#.getting current file path:
$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
import-module "$CurrentPath\Logger.ps1"

function CheckVCRedistVersion2015
{
   if(Test-Path -Path "HKLM:\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x86")
     {   
       $VCCHECK15=(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x86").Version.substring(0,13)
       if ($VCCHECK15 -eq  $Version)
                        {
                          $VCCHECK2015 =  "1" ;Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2015 installed on this machine is: $VCCHECK15"
                        }
                        else
                        {
                          $VCCHECK2015=  "0"; Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2015 is not installed on this machine"
                        } 
                 return "$VCCHECK2015"

     }
   elseif  ((Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\14.0\VC\Runtimes\x86")) # registry location for installed software   
     {
                       $VCCHECK15=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\14.0\VC\Runtimes\x86").Version.substring(1,13)
                       
                      if ($VCCHECK15 -eq  $Version)
                        {
                          $VCCHECK2015=  "1" ;Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2015 installed on this machine is: $VCCHECK15"
                        }
                      else
                        {
                          $VCCHECK2015=  "0"; Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2015 is not installed on this machine"
                        } 
                 return "$VCCHECK2015"
      }
 else
      {
        Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2015 is not installed on this machine";return  "0"
      }

 }
 #Declaring Function
 CheckVCRedistVersion2015
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
   
                  