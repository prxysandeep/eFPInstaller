param([string] $JobName,[string] $ServerName,[string] $UserName,[string] $Password)

# Load assemblies
        [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
        [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
        [Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
        [Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null
		
		$Server= [Microsoft.SqlServer.Management.Smo.Server]($ServerName)

		$Server.ConnectionContext.LoginSecure = $false
		$Server.ConnectionContext.set_Login($UserName)
		$Server.ConnectionContext.set_Password($Password)
		$job = $Server.jobserver.jobs["$JobName"] 

		if($job)
		{
			$job.Drop();
		}

		$SQLJob = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Agent.Job -argumentlist $Server.JobServer, $JobName
		$SQLJob.Description = "Update Community transaction dates and clear out old processes"
		$SQLJob.OwnerLoginName = "sa"
		$SQLJob.isEnabled = $true
		$SQLJob.EventLogLevel = [Microsoft.SqlServer.Management.Smo.Agent.CompletionAction]::Always
		$SQLJob.Create()
		
		$SQLJobStep = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Agent.JobStep -argumentlist $SQLJob, "Step1"
		$SQLJobStep.DatabaseName = "master"
		$SQLJobStep.Command = "Use master
		GO

		DECLARE @dbname nvarchar(100)
		DECLARE @tabprefix nvarchar(100)
		DECLARE @BatchDate VARCHAR(6) = REPLACE(CONVERT(VARCHAR, getDate(), 1),'/','')


		DECLARE upd_cursor CURSOR
		  FOR SELECT name FROM sysdatabases
			  WHERE name LIKE '%complus%'
			  AND name NOT LIKE '%attach%'

		OPEN upd_cursor
		FETCH NEXT FROM upd_cursor INTO @dbname

		WHILE (@@FETCH_STATUS = 0)

		BEGIN
   
		   SET @tabprefix = '[' + @dbname + '].dbo.'

			 EXECUTE ('UPDATE ' + @tabprefix + 'crmprofile '
					+ 'SET trans_date = getdate()')

			 EXECUTE ('UPDATE ' + @tabprefix + 'libuser_register '
					+ 'SET batchno = batch_prefix + ''' + @BatchDate + '''')
              
			 EXECUTE ('DELETE FROM ' + @tabprefix + 'menutb_lock')
     
			 EXECUTE ('DELETE FROM ' + @tabprefix + 'menutb_activity '
					+ ' WHERE stampdate < getdate()')


		  FETCH NEXT FROM upd_cursor INTO @dbname

		END

		CLOSE upd_cursor
		DEALLOCATE upd_cursor
		"
		$SQLJobStep.OnSuccessAction = "QuitWithSuccess"
		$SQLJobStep.OnFailAction = "QuitWithFailure"
		$SQLJobStep.Create()

		$SQLJobSchedule =  New-Object -TypeName Microsoft.SqlServer.Management.SMO.Agent.JobSchedule -argumentlist $SQLJob, $JobName
		$SQLJobSchedule.FrequencyTypes =  [Microsoft.SqlServer.Management.SMO.Agent.FrequencyTypes]::Daily
		$SQLJobSchedule.FrequencyInterval = 1
		$SQLJobSchedule.IsEnabled = $true
		#$SQLJobSchedule
		
		#Need to tell SQL when during the day we want to acutally run it. This is a timespan base on 00:00:00 as the start,
		#Here we're saying to run it at 13:30. You could combine these lines, but I've left them seperate to make it easier to read.
		$TimeSpan1 = New-TimeSpan -hours 04 -minutes 00
		$SQLJobSchedule.ActiveStartTimeofDay = $TimeSpan1
		$SQLJobSchedule.ActiveStartDate = get-date
		$SQLJobSchedule.create()