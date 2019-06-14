<#
    .SYNOPSIS
       Get the list of all installed Windows roles and features and exporting the list to Temp folder.
    .Description
       Checks to see the list of Windows roles and features based on Operating system type(Workstation or Server).
#>

    $CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
    import-module "$CurrentPath\Logger.ps1"

Function WindowsFeaturesList
{
    $OSType = (Get-CimInstance -ClassName Win32_OperatingSystem).ProductType
         
           #To Verify whether the windows OS Type is Workstation or Server
             
              if($OSType -eq "1")
                    { 
                      Write-Log -ProgramName "CreateEnabledFeaturesList" -Message "Operating System Type : Workstation"
                      Write-Log -ProgramName "CreateEnabledFeaturesList" -Message "Fetching Windows optional features....."
                      Get-WindowsOptionalFeature -Online |
                      where State -Like Enabled*  |
                      Sort-Object FeatureName  |
                      Select FeatureName  |
                      ForEach-Object { $_.FeatureName}  |
                      Export-Clixml  $env:TEMP\WindowsFeaturesList.xml
                      Write-Log -ProgramName "CreateEnabledFeaturesList" -Message "Fetching Windows optional features completed."
                     
                     }
              else 
			         {
                       Write-Log -ProgramName "CreateEnabledFeaturesList" -Message "Operating System Type : Server"
                       Write-Log -ProgramName "CreateEnabledFeaturesList" -Message "Fetching list of enabled Windows features...."
                       Get-WindowsFeature | 
                       where InstallState -Like Installed*  | 
                       Sort-Object Name | 
                       Select Name | 
                       ForEach-Object { $_.Name } | 
                       Export-Clixml  $env:TEMP\WindowsFeaturesList.xml 
                       Write-Log -ProgramName "CreateEnabledFeaturesList" -Message "Fetching list of enabled Windows features completed."
                     }

                    
     #declaring function
 }   WindowsFeaturesList

