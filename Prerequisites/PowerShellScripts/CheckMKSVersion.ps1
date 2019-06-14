<#.SYNOPSIS:
Checking whether Mortice Kern Systems Toolkit is installed or not using registry key.
.DESCRIPTION:
This script will checks the Mortice Kern Systems Toolkit is installed or not ,if it is installed return the version.
#>
$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
import-module "$CurrentPath\Logger.ps1"
Function CheckMKSVersion
{
            #Checking OS-Bit  
            $DetectOSBit=(gwmi win32_operatingsystem | select osarchitecture).osarchitecture
            Write-Log -ProgramName "CheckMKSVersion" -Message "Detected OS-Bit is: $DetectOSBit"
            if ($DetectOSBit -eq "64-bit")
			{
                    #checking for whether the MKSVersion is installed or not using reistry key
                    if(-not(Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Mortice Kern Systems\Installed Products\Toolkit for InterOperability"))
                        {
                           Write-Log -ProgramName "CheckMKSVersion" -Message "Mortice Kern Systems Toolkit is not installed on this machine"
                           return 0;
                        }
                   else
                        {
                           $MksMajorVersion=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Mortice Kern Systems\Installed Products\Toolkit for InterOperability").MajorVersion
                           Write-Log -ProgramName "CheckMKSVersion" -Message "Major version of Mortice Kern Systems:$MksMajorVersion"
                           $MksMinorVersion=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Mortice Kern Systems\Installed Products\Toolkit for InterOperability").MinorVersion
                           Write-Log -ProgramName "CheckMKSVersion" -Message "Minor version of Mortice Kern Systems:$MksMinorVersion"
                           $MksPatchVersion=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Mortice Kern Systems\Installed Products\Toolkit for InterOperability").PatchLevel
                           Write-Log -ProgramName "CheckMKSVersion" -Message "Patch version of Mortice Kern Systems:$MksPatchVersion"
                           $MksVersion=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Mortice Kern Systems\Installed Products").MKSVersion
                           Write-Log -ProgramName "CheckMKSVersion" -Message "Installed version of MKS Toolkit is:$MksVersion"
                           return 1, $MksVersion
                        }
               }

             Else
               {
                    if(-not(Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Mortice Kern Systems\Installed Products\Toolkit for InterOperability"))
                       {
                           Write-Log -ProgramName "CheckMKSVersion" -Message "Mortice Kern Systems Toolkit is not installed on this machine"
                           return 0;
                        }
                     else
                        {
                           $MksMajorVersion=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Mortice Kern Systems\Installed Products\Toolkit for InterOperability").MajorVersion
                           Write-Log -ProgramName "CheckMKSVersion" -Message "Major version of Mortice Kern Systems:$MksMajorVersion"
                           $MksMinorVersion=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Mortice Kern Systems\Installed Products\Toolkit for InterOperability").MinorVersion
                           Write-Log -ProgramName "CheckMKSVersion" -Message "Minor version of Mortice Kern Systems:$MksMinorVersion"
                           $MksPatchVersion=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Mortice Kern Systems\Installed Products\Toolkit for InterOperability").PatchLevel
                           Write-Log -ProgramName "CheckMKSVersion" -Message "Patch version of Mortice Kern Systems:$MksPatchVersion"
                           $MksVersion=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Mortice Kern Systems\Installed Products").MKSVersion
                           Write-Log -ProgramName "CheckMKSVersion" -Message "Installed version of MKS Toolkit is:$MksVersion"
                           return 1, $MksVersion
                        }
	}
}
#declaring the function
 CheckMKSVersion