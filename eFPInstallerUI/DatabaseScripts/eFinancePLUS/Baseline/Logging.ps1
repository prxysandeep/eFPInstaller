# all logging settings are here on top
$logFile = "$PSScriptRoot\log-$(gc env:computername).log"
# This is the default logging level, anything passed to the script
# that is less than this level will not be logged
# EX. Fatal default, debug passed would not be logged
$logLevel = "DEBUG" # ("DEBUG","WARN","FATAL")
# end of settings

function Write-Log-Line ($line) {
	Add-Content $logFile -Value $Line
	# Comment out this line to write only to the log
	# Write-Host $Line
}

# http://stackoverflow.com/a/38738942
Function Write-Log {
	[CmdletBinding()]
	Param(
	[Parameter(Mandatory=$True)]
	[string]
	$Message,
	
	[Parameter(Mandatory=$False)]
	[String]
	$Level = "DEBUG"
	)

	$levels = ("DEBUG","WARN","FATAL")
	$logLevelPos = [array]::IndexOf($levels, $logLevel)
	$levelPos = [array]::IndexOf($levels, $Level)
	$Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss:fff")

	if ($logLevelPos -lt 0){
		Write-Log-Line "$Stamp ERROR Wrong log level configuration [$logLevel]"
	}
	
	if ($levelPos -lt 0){
		Write-Log-Line "$Stamp ERROR Wrong log level parameter [$Level]"
	}

	# if parameter < config level and parameter > 0 and config level > 0 don't log
	if ($levelPos -lt $logLevelPos -and $levelPos -ge 0 -and $logLevelPos -ge 0){
		return
	}

	$Line = "$Stamp $Level $Message"
	Write-Log-Line $Line
}