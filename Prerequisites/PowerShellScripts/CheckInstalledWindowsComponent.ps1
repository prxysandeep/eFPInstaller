<#
  .SYNOPSIS
      Checks Installed Windows component.
#>
param( [Parameter(Mandatory=$true)][string]$Softwarename,[Parameter(Mandatory=$true)][string]$Version)
#getting current file path
$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
#invoking the log functionality
import-module "$CurrentPath\Logger.ps1"
Function CheckInstalledWindowsComponent
 {
  #Checking for Internet Explorer
    if ($Softwarename -match "IE")
     {
       invoke-expression "$CurrentPath\CheckIEVersion.ps1 -Version $Version "
     }
#Checking for DotNet
    if ($Softwarename -match "DotNet")
     {
      invoke-expression "$CurrentPath\CheckNetVersion.ps1 -Version $Version "
     }
#Checking for ODBCDriver
   if ($Softwarename -match "ODBCDriver" )
     {
      invoke-expression "$CurrentPath\IdentifyDriverInformation.ps1 -Version  $Version "
     }
#Checking for SQLNativeDriver   
   if ($Softwarename -match "SQLNativeDriver")
     {
      invoke-expression "$CurrentPath\IdentifyDriverInformation.ps1  -Version  $Version "
     }
#Checking for VCRedist(2010,2015,2017)
   if ($Softwarename -match "VCRedist" -and $Version -match "10.0.40219" )
     {
      invoke-expression "$CurrentPath\CheckVCRedistVersion2010.ps1  -Version  $Version "  
     }
   if ($Softwarename -match "VCRedist" -and $Version -match "14.0.24212.00" )
     {
      invoke-expression "$CurrentPath\CheckVCRedistVersion2015.ps1  -Version  $Version "
     }
   if ($Softwarename -match "VCRedist" -and $Version -match "14.16.27024.01" )
    {
      invoke-expression "$CurrentPath\CheckVCRedistVersion2017.ps1  -Version  $Version "
     }
 }
#Declaring Function
CheckInstalledWindowsComponent