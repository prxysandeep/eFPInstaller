 #This function will return URLRewrite version of client machine
<# .SYNOPSIS
 Get Installed Version of DotNethosting  software via the registry.
.Description :Checks to see if the software is installed or not.
.Notes:The Wow6432 registry entry indicates that you're running a 64-bit version of Windows.
#>
$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
import-module "$CurrentPath\Logger.ps1"
function Checkdotnethostingversion
 {
   if ((Test-Path -Path "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v2.2\2.2.2"))
    {
    #Check dotnethosting Version For 64 bit application 
       $dotnethostfound=(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\ASP.NET Core\Shared Framework\v2.2\2.2.2").Version
       switch($dotnethostfound )
           {
              {$_ -eq "2.2.2.0"}
              { 
              Write-Log -ProgramName "CheckDotnetHostingVersion" -Message ".NET Hosting for IIS is installed on this machine is:$dotnethostfound"
               return 1
              }
              default {
              Write-Log -ProgramName "CheckDotnetHostingVersion" -Message ".NET Hosting for IIS is not installed on this machine"
               return 0
              }  
          }
    }
    #Check dotnethosting version For 32 bit operating system and 64 bit operating system
   elseif((Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\ASP.NET Core\Shared Framework\v2.2\2.2.2") )
    {
      $dotnethostfound=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\ASP.NET Core\Shared Framework\v2.2\2.2.2").Version
      switch($dotnethostfound )
               {
                {$_ -eq "2.2.2.0"}{Write-Log -ProgramName "CheckDotnetHostingVersion" -Message ".NET Hosting for IIS  is installed on this machine is:$dotnethostfound "
                return 1}
                default {Write-Log -ProgramName "CheckDotnetHostingVersion" -Message ".NET Hosting for IIS is not installed on this machine"
                 return 0}
               }
    }  
    #Check dotnethosting version for 32 bit 
   else
    {
    Write-Log -ProgramName "CheckDotnetHostingVersion" -Message ".NET Hosting for IIS is not installed on this machine"
    return 0     
    }
 }  
#declaring the function
 Checkdotnethostingversion
