<#.SYNOPSIS
      This function will return URLRewrite version on client machine
#>
$CurrentPath=[System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
import-module "$CurrentPath\Logger.ps1"
function CheckURLRewriteVersion
 {
   if ((Test-Path -Path "HKLM:\SOFTWARE\Microsoft\IIS Extensions\URL Rewrite"))
    {
    #Check URLRewrite Version For 64-bit os and 64-bit application 
       Write-Log -ProgramName "CheckURLRewriteVersion" -Message "checking 64-bit CheckURLRewrite"
       $URLREWRITEFOUND=(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\IIS Extensions\URL Rewrite").Version
       Write-Log -ProgramName "CheckURLRewriteVersion" -Message "URLRewrite version installed on this machine is:$URLREWRITEFOUND"
       return "$URLREWRITEFOUND"
    }
    #Check CheckURLRewrite Version For 32-bit Application and 64-bit os
   elseif((Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\IIS Extensions\URL Rewrite") )
    {
      $URLREWRITEFOUND=(Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\IIS Extensions\URL Rewrite").Version
      Write-Log -ProgramName "CheckURLRewriteVersion" -Message "URLRewrite version installed on this machine is:$URLREWRITEFOUND"
      return "$URLREWRITEFOUND"
    }  
   else
        {
        Write-Log -ProgramName "CheckURLRewriteVersion" -Message "No URLRewrite version found"
        return 0 
        }
 }
  #declaring the function
  CheckURLRewriteVersion
