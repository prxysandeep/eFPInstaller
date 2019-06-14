 <#
    .SYNOPSIS
     Get Installed Version of 3rd Party software via the registry.
    .Description
     Checks to see if the software is installed or not.
    .Notes
     The Wow6432 registry entry indicates that you're running a 64-bit version of Windows.
#>
  $CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
  import-module "$CurrentPath\Logger.ps1"
  Function CheckWebPlatformInstaller
     {     
       # Detecting OSBit
      $DetectOSBit=(gwmi win32_operatingsystem | select osarchitecture).osarchitecture
         Write-Log -ProgramName "CheckWebPlatformInstaller" -Message "Detected OSBit : $DetectOSBit"
      if ($DetectOSBit -eq "64-bit")
      {
          if(-not (Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\WebPlatformInstaller\5")) # registry location for installed software
      {  
          Write-Log -ProgramName "CheckWebPlatformInstaller" -Message "WebPlatformInstaller is not installed on this machine"
          return 0;
       }
      else
       {
          $IsWebPlatformInstaller=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\WebPlatformInstaller\5").Version
          Write-Log -ProgramName "CheckWebPlatformInstaller" -Message "WebPlatformInstaller is installed on this machine and the version is :$IsWebPlatformInstaller"
          return $IsWebPlatformInstaller
       }
      }
#For 32-bit OS:

     if(-not(Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WebPlatformInstaller\5"))# registry location for installed software
        {
           Write-Log -ProgramName "CheckWebPlatformInstaller" -Message "WebPlatformInstaller is not installed on this machine"
           return 0;
        }
      else
        {
           Write-Log -ProgramName "CheckWebPlatformInstaller" -Message "WebPlatformInstaller is installed on this machine"

           $WebPlatformInstallerVersion=(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WebPlatformInstaller\5").Version
           Write-Log -ProgramName "CheckWebPlatformInstaller" -Message "WebInstallerPlatform is installed on this machine and the version is:$WebPlatformInstallerVersion"
           return "WebPlatformInstaller is installed on this machine and the version is:"+$WebPlatformInstallerVersion;
        }  
      }
 #declaring the function

 CheckWebPlatformInstaller