<#
        .SYNOPSIS
         This function query some basic Operating System and Hardware Information from
   a local or remote machine.
        .Description
         This function query some basic Operating System and Hardware Information from
   a local or remote machine.
          The properties returned are the Computer Name (ComputerName),the Operating 
          System Name (OSName), Operating System Version (OSVersion),Operating System Type (OSType)
       .Example
         Run the GetOSVersion Script to retrieve the information.
#>

$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
import-module "$CurrentPath\Logger.ps1"
Function GetOSVersion
{
        $OSVersion=(Get-CimInstance Win32_OperatingSystem).version   # To verify the Operating System version.

               Write-Log -ProgramName "CheckOSversion" -Message "Operating System Version : $OSVersion"

        $OSType = (Get-CimInstance -ClassName Win32_OperatingSystem).ProductType
         
             #To Verify whether the windows OS Type is Workstation or Server
             
                    if($OSType -eq "1")
                    {
                       Write-Log -ProgramName "CheckOSversion" -Message "Operating System Type : Workstation"
                       $var="Workstation"
                    }
                    else 
                   {  
                       Write-Log -ProgramName "CheckOSversion" -Message "Operating System Type : Server"
                       $var="Server"
                    }
         $OSBit=(gwmi win32_operatingsystem | select osarchitecture).osarchitecture  #To Verify if its 64-Bit or 32-Bit

                       Write-Log -ProgramName "CheckOSversion" -Message "Operating System Bit : $OSBit"

        $OSName=((Get-WmiObject Win32_OperatingSystem).Caption)  #To Verify Windows Name

                       Write-Log -ProgramName "CheckOSversion" -Message "Operating System Name : $OSName"

        Return $OSVersion,$var,$OSBit,$OSName
}
GetOSVersion