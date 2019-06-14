<#
.Synopsis
   Write-Log writes a message to a specified log file with the current time stamp.
.DESCRIPTION
   The Write-Log function is designed to add logging capability to other scripts.
   In addition to writing output and/or verbose you can write to a log file for
   later debugging.
.PARAMETER Message
   Message is the content that you wish to add to the log file. 
.PARAMETER Path
   The path to the log file to which you would like to write. By default the function will 
   create the path and file if it does not exist. 
.PARAMETER Level
   Specify the criticality of the log information being written to the log (i.e. Error, Warning, Informational)
.PARAMETER NoClobber
   Use NoClobber if you do not wish to overwrite an existing file.
#>
function Write-Log
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("LogProgram")]
        [string]$ProgramName="Pages",

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("LogContent")]
        [string]$Message="Pages",

        [Parameter(Mandatory=$false)]
        [Alias('LogPath')]
        [string]$Path="$env:temp\BPInstallerLog.txt",
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("Error","Exception","Info")]
        [string]$Level="Info",
        
        [Parameter(Mandatory=$false)]
        [switch]$NoClobber
    )

    Begin
    {
        # Set VerbosePreference to Continue so that verbose messages are displayed.
        $VerbosePreference = 'Continue'
    }
    Process
    {
        
        # If the file already exists and NoClobber was specified, do not write to the log.
        if ((Test-Path $Path) -AND $NoClobber) {
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name."
            Return
            }

        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path.
        elseif (!(Test-Path $Path)) {
            Write-Verbose "Creating $Path."
            $NewLogFile = New-Item $Path -Force -ItemType File
            }

        else {
            # Nothing to see here yet.
            }

        # Format Date for our Log File
        $FormattedDate = Get-Date -Format "dd-MM-yyyy HH:mm:ss"

        # Write message to error, warning, or verbose pipeline and specify $LevelText
        switch ($Level) {
            'Error' {
                Write-Error $Message
                $LevelText = 'ERROR'
                }
            'Exception' {
                Write-Warning $Message
                $LevelText = 'Exception'
                }
            'Info' {
                Write-Verbose $Message
                $LevelText = 'Info'
                }
            }
        
        # Write log entry to $Path
        "$FormattedDate | $ProgramName | $LevelText | $Message " | Out-File -FilePath $Path -Append -Encoding ascii
    }
    End
    {
    }
}
