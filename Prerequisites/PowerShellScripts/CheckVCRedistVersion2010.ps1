#.SYNOPSIS: Get Installed Version of VC++ Redist <2010>software via the registry.
#.Description:Checks to see if the software is installed or not.
#.#getting current file path:
$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
import-module "$CurrentPath\Logger.ps1"
function CheckVCRedistVersion2010
 {

    if  ((Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{F0C3E5D1-1ADE-321E-8167-68EF0DE699A5}")) # registry location for installed software
                    {
                      $VCCHECK10=(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{F0C3E5D1-1ADE-321E-8167-68EF0DE699A5}").DisplayVersion
                       
                       if ($VCCHECK10 -eq  $Version)
                        {
                          $VCCHECK2010=  "1" ;Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2010 installed on this machine is: $VCCHECK10"
                          
                        }
                        else
                        {
                        $VCCHECK2010=  "0"; Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2010  is not installed on this machine"
                        }
                        return "$VCCHECK2010"
                    }
                    

    elseif  ((Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{F0C3E5D1-1ADE-321E-8167-68EF0DE699A5}")) # registry location for installed software
                    {
                      $VCCHECK10=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{F0C3E5D1-1ADE-321E-8167-68EF0DE699A5}").DisplayVersion
                      if ($VCCHECK10 -eq   $Version)
                        {
                          $VCCHECK2010=  "1" ;Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2010 installed on this machine is: $VCCHECK10"
                        }
                        else
                        {
                        $VCCHECK2010=  "0"; Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2010  is not installed on this machine"
                        }
                        return "$VCCHECK2010"
                    }
                    

    else   
         {

          Write-Log -ProgramName "CheckVCRedistVersion" -Message "Visual C++ Redistributable 2010 is not installed on this machine";return 0 
         }

 }
 CheckVCRedistVersion2010               