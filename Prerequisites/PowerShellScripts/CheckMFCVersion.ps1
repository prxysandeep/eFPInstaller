<#.SYNOPSIS:
Checking whether the Microfocus Cobol is installed or not using registry key.
.DESCRIPTION:
This script will checks  Microfocus Cobol is installed or not and return the version, if it installed .
#>
$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
 import-module "$CurrentPath\Logger.ps1"
Function CheckMFCVersion  
  { 
                #checking that OSBit  
                $DetectOSBit=(gwmi win32_operatingsystem | select osarchitecture).osarchitecture
                Write-Log -ProgramName "CheckMFCVersion" -Message "Detecting OSBit is:'$DetectOSBit"
		        if ($DetectOSBit -eq "64-bit")
                  {
                      #checking for whether the Microfocus cobol is installed or not using regkey
                      #Returning the Microfocus Cobol version
                                If(-not(Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Micro Focus\Visual COBOL"))
                                    {
                                       Write-Log -ProgramName "CheckMFCVersion" -Message "Microfocus Cobol is not installed on this machine"
                                       return 0;
                                    }
                                 else
                                    {   
                                        Write-Log -ProgramName "CheckMFCVersion" -Message "Microfocus Cobol is installed on this machine"
                                        $MfcVersion=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Micro Focus\Visual COBOL").DefaultVersion
                                        Write-Log -ProgramName "CheckMFCVersion" -Message "Microfocus Cobol installed version on this machine is:$MfcVersion"
                                        return 1, "Microfocus Cobol installed version is:$MfcVersion";
									}
				  }
                   else
                   {
                                #for 32-bit
                                If(-not(Test-Path -Path "HKLM:\SOFTWARE\Micro Focus\Visual COBOL"))
                                    {  
                                       Write-Log -ProgramName "CheckMFCVersion" -Message "Microfocus Cobol is not installed on this machine"
                                       return 0;
                                    }
                                 else
                                    {   
                                        Write-Log -ProgramName "CheckMFCVersion" -Message "Microfocus Cobol is installed on this machine"
                                        $MfcVersion=(Get-ItemProperty "HKLM:\SOFTWARE\Micro Focus\Visual COBOL").DefaultVersion
                                        Write-Log -ProgramName "CheckMFCVersion" -Message "Microfocus Cobol installed version on this machine is:$MfcVersion"
                                        return 1,"Microfocus Cobol installed version is:$MfcVersion";
										
                                    }
                   }
}
#declaring the function
CheckMFCVersion


