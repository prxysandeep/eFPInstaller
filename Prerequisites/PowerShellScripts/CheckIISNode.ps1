<#
    .SYNOPSIS

        Get Installed version of 3rd Party software via the registry key.

    .Description

        Checks to see if the software is installed or not.

    .Notes

        The Wow6432 registry entry indicates that you're running a 64-bit version of Windows.

#>
 $CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
 import-module "$CurrentPath\Logger.ps1"

  Function CheckIISNode
   {
        #checking OSBit
        $DetectOSBit=(gwmi win32_operatingsystem | select osarchitecture).osarchitecture
        Write-Log -ProgramName "CheckIISNode" -Message "Detecting OSBit:$DetectOSBit"
		if ($DetectOSBit -eq "64-bit")
        {
         #checking whether IISNode for IIS is installed or not using registry key
       if(-not (Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{93ED58D2-1180-40C2-8E96-B90D57AC3A11}"))
        {
          Write-Log -ProgramName "CheckIISNode" -Message "IISNode for IIS is not installed on this machine"
          return 0;
        }
        else
        {
          $IsIISNodeVersion=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{93ED58D2-1180-40C2-8E96-B90D57AC3A11}").DisplayVersion
          Write-Log -ProgramName "CheckIISNode" -Message "IISNode for IIS is installed on this machine and the version is :$IsIISNodeVersion"
          return $IsIISNodeVersion
        }
        }
       #For 32-bit OS:
       if(-not(Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{93ED58D2-1180-40C2-8E96-B90D57AC3A11}"))
        {
          Write-Log -ProgramName "CheckIISNode" -Message "IISNode for IIS is not installed on this machine"
          return 0;
        }
        else
        {
          Write-Log -ProgramName "CheckIISNode" -Message "IISNode for IIS is installed on this machine"
          $IsIISNodeVersion=(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{93ED58D2-1180-40C2-8E96-B90D57AC3A11}").DisplayVersion
          Write-Log -ProgramName "CheckIISNode" -Message "IISNode for IIS is installed on this machine and the version is:$IsIISNodeVersion"
          return "IISNode for IIS installed version is:"+$IsIISNodeVersion;
        }
  }

#declaring the function

   CheckIISNode