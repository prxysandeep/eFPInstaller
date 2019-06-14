<#SYNOPSIS:
    This will check Nodejs version on client machine
#>
$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
import-module "$CurrentPath\Logger.ps1"
function CheckNodejsver
 {
   if ((Test-Path -Path "HKLM:\SOFTWARE\Node.js"))
    {
#Check NodeJs Version For 64 bit os and 64 bit Application
       $NodejsFound=(Get-ItemProperty "HKLM:\SOFTWARE\Node.js").Version
       switch($NodejsFound )
           {
              {$_ -eq "6.11.4"}{ Write-Log -ProgramName "CheckNodejsversion" -Message "Node.js installed on this machine is:$NodejsFound"
               return 1}
              default {Write-Log -ProgramName "CheckNodejsversion" -Message "Node.js is not installed on this machine" 
               return 0}
           }
    }
#Check NodeJs Version For 32 bit Application and 64 bit OS
   elseif ((Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Node.js") )
   {
    $NodejsFound=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Node.js").Version
        switch($NodejsFound )
               {
                {$_ -eq  "6.11.4"}
                    {
                        Write-Log -ProgramName "CheckNodejsversion" -Message "Node.js installed on this machine is:$NodejsFound"
                        return 1
                    }
                
                default 
                    {
                        Write-Log -ProgramName "CheckNodejsversion" -Message "Node.js is not installed on this machine";
                       return 0
                    }
               }
    }  
                else 
                       {
                        Write-Log -ProgramName "CheckNodejsversion" -Message "Node.js is not installed on this machine"
                        return 0
                        }
 }
#declaring the function
  CheckNodejsver
