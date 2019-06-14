 #.SYNOPSIS: Get Installed Version of DotNetFrameWork via the registry.   

$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
import-module "$CurrentPath\Logger.ps1"
Function CheckNetVersion
{
if ($DetectOSBit -eq "64-bit" -or "32-bit")
              {
#Checking for NetFramework 4.5.2
           if ((Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).version -ige  "$Version")
               {
                   $DotNet =1
                  Write-Log -ProgramName "CheckDotNetVersion" -Message ".NET Framework is installed on this machine"
                 }
                 elseif ((Get-ItemProperty -Path "HKLM:SOFTWARE\WOW6432Node\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).version -ige "$Version")
                 {
                   $DotNet =1
               }
           else
              {
                $dotNet =0
                 Write-Log -ProgramName "CheckDotNetVersion" -Message ".NET Framework is not installed on this machine"
                }
                return $dotNet
              }
  }
CheckNetVersion