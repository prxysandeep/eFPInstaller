#.SYNOPSIS: Get Installed Version of VC++ Redist <2017>software via the registry.
#.Description:Checks to see if the software is installed or not.
#getting current file path:
  $CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
  import-module "$CurrentPath\Logger.ps1"

function CheckVCRedistVersion2017
{

if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x86")    
     {   
        $VCCHECK17=(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x86").Version.substring(1,14)
       if ($VCCHECK15 -eq  $Version)
                        {
                          $VCCHECK2017 =  "1" ;Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2017 installed on this machine is: $VCCHECK15"
                        }
                        else
                        {
                          $VCCHECK2017=  "0"; Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2017 is not installed on this machine"
                        } 
                 return "$VCCHECK2017"

     }
 elseif  ((Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\14.0\VC\Runtimes\x86")) # registry location for installed software   
     {
                        $VCCHECK17=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\14.0\VC\Runtimes\x86").Version.substring(1,14)
                       
                      if ($VCCHECK17 -eq  $Version)
                        {
                          $VCCHECK2017=  "1" ;Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2017 installed on this machine is: $VCCHECK17"
                        }
                      else
                        {
                         $VCCHECK2017=  "0" ;Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2017 is not installed on this machine"
                        } 
                 return "$VCCHECK2017"
      }
 else
      {
        Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2017 is not installed on this machine";return  "0"
      }
}
#Declaring function
CheckVCRedistVersion2017
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
   
                  