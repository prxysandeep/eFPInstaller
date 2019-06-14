param([string] $DBName,[string] $ServerName,[string] $UserName,[string] $Password,[string] $FilePath, [string] $Type)

# Load assemblies
        [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
        [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
        [Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
        [Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null


		$Server=[Microsoft.SqlServer.Management.Smo.Server]($ServerName)

		$Server.ConnectionContext.LoginSecure = $false
		$Server.ConnectionContext.set_Login($UserName)
		$Server.ConnectionContext.set_Password($Password)

		$exists = $false
		foreach($db in $Server.databases)
		{  
		if ($db.name -eq $DBName) 
			{
			$exists = $TRUE
			}
		}

		if( !$exists)
		{		
			$DB=[Microsoft.SqlServer.Management.Smo.Database]::new($Server,$DBName)

			if($Type -eq "EFP" -Or $Type -eq "ECP")
			{
				$DB.CompatibilityLevel=120
				$DB.RecoveryModel=[Microsoft.SqlServer.Management.Smo.RecoveryModel]::Full

				$FileGroup=[Microsoft.SqlServer.Management.Smo.FileGroup]::new($DB,"PRIMARY")
				$DB.FileGroups.Add($FileGroup)

				$DataFile=[Microsoft.SqlServer.Management.Smo.DataFile]::new($FileGroup,$DBName)
				$FileGroup.Files.Add($DataFile)

				$DataFile.FileName=  $FilePath + "\" + $DBName + ".mdf"
				$DataFile.Size=512000
				$DataFile.Growth=128000
				$DataFile.GrowthType=[Microsoft.SqlServer.Management.Smo.FileGrowthType]::KB
				$DataFile.IsPrimaryFile=$true

				$LogFile=[Microsoft.SqlServer.Management.Smo.LogFile]::new($DB,$DBName + "_log",$FilePath + "\" +$DBName +"_log.ldf")
				$LogFile.Size=256000
				$LogFile.Growth=64000
				$LogFile.GrowthType=[Microsoft.SqlServer.Management.Smo.FileGrowthType]::KB
				$DB.LogFiles.Add($LogFile)
			}
			
			if($Type -eq "AUTH")
			{
				$DB.CompatibilityLevel=120
				$DB.RecoveryModel=[Microsoft.SqlServer.Management.Smo.RecoveryModel]::Full

				$FileGroup=[Microsoft.SqlServer.Management.Smo.FileGroup]::new($DB,"PRIMARY")
				$DB.FileGroups.Add($FileGroup)

				$DataFile=[Microsoft.SqlServer.Management.Smo.DataFile]::new($FileGroup,$DBName)
				$FileGroup.Files.Add($DataFile)

				$DataFile.FileName=  $FilePath + "\" + $DBName + ".mdf"
				$DataFile.Size=14000
				$DataFile.Growth=1000
				$DataFile.GrowthType=[Microsoft.SqlServer.Management.Smo.FileGrowthType]::KB
				$DataFile.IsPrimaryFile=$true

				$LogFile=[Microsoft.SqlServer.Management.Smo.LogFile]::new($DB,$DBName + "_log",$FilePath + "\" +$DBName +"_log.ldf")
				$LogFile.Size=195000
				$LogFile.Growth=2097152000
				$LogFile.GrowthType=[Microsoft.SqlServer.Management.Smo.FileGrowthType]::KB
				$DB.LogFiles.Add($LogFile)
			}
			#CREATE DATABASE [TemporaryDB]
			$DB.Create()

			"Database Created Successfully"
		}