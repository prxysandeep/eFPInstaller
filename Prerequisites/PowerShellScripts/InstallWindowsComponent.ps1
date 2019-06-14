#.SYNOPSIS: This function will install all required WindowsComponents
 
param ([Parameter(Mandatory=$true)]
[string] $Filename ,
[Parameter(Mandatory=$true)]
[string] $Path
)
#getting current file path
$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
#invoking the log functionality
import-module "$CurrentPath\Logger.ps1"
function InstallWindowsComponent
{
$InstallPath = "$Path"+"\$Filename"

if ($Filename -match "sqlncli-2k12x64sp3" -or "sqlncli-2k12x86sp3" )
{
 msiexec /i $InstallPath  /qn IACCEPTSQLNCLILICENSETERMS=YES 
}
if ($Filename -match "msodbcsql-v11x64.msi" -or "msodbcsql-v11x86")
{
msiexec /i $InstallPath  /qn IACCEPTMSODBCSQLLICENSETERMS=YES
}
else
  {
     $str = $InstallPath.replace('\','\\') 
    Start-Process -FilePath "$str" -ArgumentList "/q /r:n" 
  }
  }
  #Declaring Function
  InstallWindowsComponent





  
