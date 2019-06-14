<#
  .SYNOPSIS
      Checks remote registry for SQL Server Edition and Version.
  .PARAMETER InstanceName
     The instance name of SQL Server to return database backup information for.
     The default is the default SQL Server instance.
  .Example
    Get-SQLSerVer
   Returns the installed SQL Server instance of SQL on local machine.
#>

$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
import-module "$CurrentPath\Logger.ps1"

Function Get-SQLSerVer
{
$inst = (get-itemproperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances
# parse each value in the reg_multi InstalledInstances
  foreach ($i in $inst)
   {
   # Define SQL instance registry keys
   # set key path for reg data
   $p = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL').$i
   # sub in instance name
   $SQLEdtn=(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$p\Setup").Edition # read Ed value

   $SQLVer=(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$p\Setup").Version #read Ver value
      if ("$SQLVer" -ne "")
       {
           Write-log -ProgramName "GetSQLServerVersion" -Message "Installed SQLServer versions on this machine are :$SQLVer"
           return 1,$SQLVer;# return an object, useful for many things
       }
      else
       {
          return 0;
       }
   }
}
#declaring the function
Get-SQLSerVer