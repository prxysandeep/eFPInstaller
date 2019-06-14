param([string] $DBName,[string] $ServerName,[string] $UserName,[string] $Password,[string] $FilePath)

# Load assemblies
        [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
        [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
        [Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
        [Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null
		
		$Server=[Microsoft.SqlServer.Management.Smo.Server]($ServerName)

		$Server.ConnectionContext.LoginSecure = $false
		$Server.ConnectionContext.set_Login($UserName)
		$Server.ConnectionContext.set_Password($Password)

		$script_contents = Get-Content -Path $FilePath -Raw
		$tsql_to_run = $script_contents -split '\bGO\b'
		$Batch = New-Object -TypeName:Collections.Specialized.StringCollection 
        $Batch.AddRange($tsql_to_run) 

		$SmoDatabase = $Server.Databases.Item($DBName) 
	    $results  = $SmoDatabase.ExecuteWithResults($Batch)


		if($results.Tables -eq $null)
		{
			"0"
		}
		else
		{
			"1"
		}

		$results.Tables