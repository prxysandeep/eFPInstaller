<#
.SYNOPSIS:
Installing Roles and Features.
.DESCRIPTION:
Checks for operating system type(Workstation or server).If detects as workstation,will install all windows optional features and will install all windows features if operating system type is server.
#>
param([string]$feature)
#getting current file path
$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
  #invoking the log functionality
  import-module "$CurrentPath\Logger.ps1"
Function InstallWindowsfeatures
{
    $OSType = (Get-CimInstance -ClassName Win32_OperatingSystem).ProductType
    #To Verify windows OS
           if($OSType -eq "1")
                   {
                      # for workstation we need to enable the windows optional features
                      Write-Log -ProgramName "InstallRolesandFeatures" -Message "Enabling Windows Optional Feature"
                      $featurestatus=(Enable-WindowsOptionalFeature -Online -FeatureName $feature -all -NoRestart ) 
                      $fstate=(Get-WindowsOptionalFeature -Online -FeatureName $feature).State
                      Write-Log -ProgramName "InstallRolesandFeatures" -Message "Enabled Windows Optional Feature is:$feature,$fstate"
                      return $fstate;
                   }
             else
                   {
                      # for server we need to install windows features
                      Write-Log -ProgramName "InstallRolesandFeatures" -Message "Installing Windows Feature "
                      $featurestatus=(Install-WindowsFeature -Name $feature).Success
                      Write-Log -ProgramName "InstallRolesandFeatures" -Message "Installed Windows Feature is:$feature,$featurestatus"
                      return $featurestatus
                    }
}
 #declaring the function  
 InstallWindowsfeatures
 


