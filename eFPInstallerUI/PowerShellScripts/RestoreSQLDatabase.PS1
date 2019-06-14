 param([string] $ServerName,[string] $DbName,[string] $UserName,[string]$Password, [string]$FileName ,[string]$BackUpPath, [string] $DataFileLocation,[string] $TransactionLogFileLocation)

 # Load assemblies
        [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
        [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
        [Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
        [Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null
		
		$server = New-Object ("Microsoft.SqlServer.Management.Smo.Server") "$ServerName"

		#Setting Connection Credentials
		$server.ConnectionContext.LoginSecure = $false
		$server.ConnectionContext.set_Login($UserName)
		$server.ConnectionContext.set_Password($Password)

		# Create restore object and specify its settings
        $smoRestore = new-object("Microsoft.SqlServer.Management.Smo.Restore")
        $smoRestore.Database = $DbName
        $smoRestore.NoRecovery = $false;
        $smoRestore.ReplaceDatabase = $true;
        $smoRestore.Action = "Database"
		
		Copy-Item -Path $BackUpPath -Destination "\\$ServerName\D$\SQL\MSSQL13.MSSQLSERVER\MSSQL\Backup\"

		$BackUpFile = $BackUpPath + "\" + $FileName
		# Create location to restore from
        $backupDevice = New-Object("Microsoft.SqlServer.Management.Smo.BackupDeviceItem") ($BackUpFile, "File")
        $smoRestore.Devices.Add($backupDevice)

		$fl = $smoRestore.ReadFileList($server)
        $logname = @($fl).logicalname
		write-host $logname

		# Specify new data file (mdf)
        $smoRestoreDataFile = New-Object("Microsoft.SqlServer.Management.Smo.RelocateFile")
		$smoRestoreDataFile.LogicalFileName = $logname[0]
        $smoRestoreDataFile.PhysicalFileName = $DataFileLocation + "\" + $DbName +"_Data.mdf"

        # Specify new log file (ldf)
        $smoRestoreLogFile = New-Object("Microsoft.SqlServer.Management.Smo.RelocateFile")
		$smoRestoreLogFile.LogicalFileName = $logname[1]
        $smoRestoreLogFile.PhysicalFileName =  $TransactionLogFileLocation + "\" + $DbName +"_Log.ldf"

		# Add the new data and log files to relocate to
        $smoRestore.RelocateFiles.Add($smoRestoreDataFile)
        $smoRestore.RelocateFiles.Add($smoRestoreLogFile)

		# Restore the database
        $smoRestore.SqlRestore($server)

        "Database restore completed successfully"