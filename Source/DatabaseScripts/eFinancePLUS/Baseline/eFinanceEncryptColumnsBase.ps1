# Get the userid and password... The param statement must be the first line in the script
# The script can now be passed the database server and database name(s) to allow it to be run by the installer
# Passing nothing after the database(s) will cause the script to encrypt the provided databases (default)
# Passing -decrypt will cause the script to decrypt the data in the provided databases
param(
    [string]$userid,
    [string]$password,
    [string]$serverName,
    [string]$columnKeyName,
    [string[]] $databases,
    [switch]$decrypt = $false
)
$debug = "DEBUG"
$warn = "WARN"
$fatal = "FATAL"
$operation = "Encryption"
# Make sure we're not persisting any errors
$Error.Clear()


# Include logging capability
."$PSScriptRoot\Logging.ps1"

#region finplusColumns
$finplusColumns = "dbo.AMApplicantDefinition.SSN", "dbo.AMGallupHistory.SSN", "dbo.aca_cov_ind.empl_ssn", "dbo.aca_cov_ind.ssn",  "dbo.aca_employee.ssn",  "dbo.alt_vend_addr.fed_id", "dbo.applicant.ssn",
        "dbo.b_applicant.ssn", "dbo.bbenefici.b_ssn", "dbo.bbenefici.d_ssn", "dbo.bbenefits.d_ssn", "dbo.bdemo.ssn", "dbo.bdependent.d_ssn", "dbo.ben_benefici.b_ssn", "dbo.ben_benefits.ssn",
        "dbo.ben_dependent.d_ssn", "dbo.ben_dependent.real_ssn", "dbo.benefici.b_ssn", "dbo.benefici.d_ssn", "dbo.beneficiorg.b_ssn", "dbo.beneficiorg.d_ssn", "dbo.benefits.d_ssn", "dbo.benefitsorg.d_ssn",
        "dbo.bk_pay2file.ssn", "dbo.bondinfo.ssn", "dbo.cob_act.d_ssn", "dbo.cob_his.d_ssn", "dbo.cobra.d_ssn", "dbo.dependent.d_ssn", "dbo.dependentorg.d_ssn", "dbo.dvendor.fed_id", "dbo.eac_deplink.d_ssn",
        "dbo.employee.ssn", "dbo.hemployee.ssn", "dbo.otherins.d_ssn", "dbo.ovendor.fed_id", "dbo.pay2file.ssn", "dbo.pd_inst_part_mstr.ssn", "dbo.pers_history.ssn", "dbo.t_applicant.ssn", "dbo.vac_vendor.fed_id",
        "dbo.vendor.fed_id", "dbo.vnd_ssn.ssn", "dbo.w2cemp.ssn", "dbo.w2cemployee.empl_ssn", "dbo.w2cemployee.empl_ssn_bad", "dbo.w2employee.ssn", "dbo.wrk1099g.fed_id", "dbo.wrk1099i.fed_id", "dbo.wrk1099m.fed_id",
        "dbo.wrk1099r.ssn", "dbo.wrkemployee.ssn"
#endregion finplusColumns
#region complusColumns
$complusColumns = "dbo.ceninspector.ssn", "dbo.cenoldinspector.ssn", "dbo.cenoldowner.o_ssn", "dbo.cenowner.o_ssn", "dbo.cpmoldclic.ssn", "dbo.cpmoldcont.ssn", "dbo.ctrowner.ssn",
        "dbo.cubarcaccount.ssn", "dbo.cuboldaccount.ssn", "dbo.cuboldpend_acct.ssn", "dbo.cuboldtap.ssn", "dbo.cblbusiness.fed_tax", "dbo.cbloldbusiness.fed_tax", "dbo.cblrise.tax_id", "dbo.cblrise_ca.tax_id",
        "dbo.cmrcustomer.fin", "dbo.cmroldcustomer.fin"
#endregion complusColumns

$usage = "Usage: eFinanceEncryptColumnsBase.ps1 -userid <userid> -password <password> -serverName <databaseServerName> -columnKeyName <columnKeyName> -databases <database1,database2,...> -decrypt"

[bool] $allParameters = $True
if([string]::IsNullOrWhitespace($userid)) {
    Write-Log "userid must be passed to the script" $fatal
    $allParameters = $False
}
if([string]::IsNullOrWhitespace($password)) {
    Write-Log "password must be passed to the script" $fatal
    $allParameters = $False
}
if([string]::IsNullOrWhitespace($serverName)) {
    Write-Log "server name must be passed to the script" $fatal
    $allParameters = $False
}
if([string]::IsNullOrWhiteSpace($columnKeyName)){
    Write-Log "column encryption key name must be passed to the script" $fatal
    $allParameters = $False
}
if($databases.Count -eq 0){
    Write-Log "must pass at least one database" $fatal
    $allParameters = $False
}

if( -not $allParameters){
    Write-Log $usage $fatal
    return -1
}

Write-Log "User ID: $userid Server Name: $serverName Column Encryption Key: $columnKeyName Database: $databases Decrypt: $decrypt" $debug

# Ensure prerequisites for the script are present and load them
Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue
if($Error)
{
    $Error.Clear()
    Write-Log "The NuGet package provider is not installed, installing it..." $debug
    Install-PackageProvider -Name NuGet -Force -ErrorAction SilentlyContinue
    if($Error)
    {
        Write-Log "Installation of the NuGet package provider failed." $fatal
        return -1
    }
    else
    {
        Write-Log "Installation of the NuGet package provider succeeded." $debug
    }
}
Write-Log "Importing the NuGet package provider module..." $debug
Import-PackageProvider -Name NuGet -ErrorAction SilentlyContinue
if($Error)
{
    Write-Log "Importing the NuGet package provider failed." $fatal
    return -1
}
else
{
    Write-Log "Importing the NuGet package provider succeeded." $debug
}
Get-InstalledModule -Name SqlServer -RequiredVersion 21.0.17262 -ErrorAction SilentlyContinue
if($Error)
{
    $Error.Clear()
    Write-Log "The required version(21.0.17262) of the SqlServer module is not installed, installing it..." $debug
    Install-Module -Name SqlServer -RequiredVersion 21.0.17262 -Force -ErrorAction SilentlyContinue
    if($Error)
    {
        Write-Log "Installation of the SqlServer module failed." $fatal
        return -1
    }
    else
    {
        Write-Log "Installation of the SqlServer module succeeded." $debug
    }
}
Write-Log "Importing the SqlServer module..." $debug
Import-Module -Name SqlServer -RequiredVersion 21.0.17262 -ErrorAction SilentlyContinue
if($Error)
{
    Write-Log "Importing the SqlServer module failed." $fatal
    return -1
}
else
{
    Write-Log "Importing the SqlServer module succeeded." $debug
}

$isFinplus = 0

# Set up connection and database SMO objects
# Only change the connection information as needed
# Data Source = SQL Server name
# Initial Catalog = Database Name

try
{
    foreach ($databaseName in $databases)
    {
        #region Connect and determine database type
        Write-Log "Establishing connection to $serverName\$databaseName" $debug
        $sqlConnectionString = "Data Source= $serverName;Initial Catalog=$databaseName;User ID=$userid;Password=$password;MultipleActiveResultSets=False;Connect Timeout=30;Encrypt=False;TrustServerCertificate=False;Packet Size=4096;Application Name=`"Microsoft SQL Server Management Studio`""
        $smoDatabase = Get-SqlDatabase -ConnectionString $sqlConnectionString
        # Verify we connected to the database
        if(-not $smoDatabase){
            Write-Log "Unable to connect to $serverName\$databaseName" $fatal
            return -1
        }
        $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
        $SqlConnection.ConnectionString = $sqlConnectionString
        $SqlConnection.Open()
        # Verify the connection is open
        if(-not $SqlConnection.State -eq 1){
            Write-Log "Connection to $serverName\$databaseName is not opened" $fatal
            return -1
        }
        $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
        $SqlCmd.Connection = $SqlConnection
        # Determine Database type (finplus, complus)
        Write-Log "Checking for site_info or cpsprofile table" $debug
        $SqlCmd.CommandText = "select 1 from systb_tables where tabname = 'site_info'"
        $siteInfo = $SqlCmd.ExecuteScalar()
        $SqlCmd.CommandText = "select 1 from systb_tables where tabname = 'cpsprofile'"
        $cpsprofile = $SqlCmd.ExecuteScalar()
        if ($siteInfo -eq 1){
            Write-Log "Database recognized as finplus" $debug
            $isFinplus = 1
        }elseif ($cpsprofile -eq 1){
            Write-Log "Database recognized as complus" $debug
            $isFinplus = 0
        } else {
            Write-Log "Database type not recognized" $fatal
            $SqlConnection.Close()
            return -1
        }
        #endregion Connect and determine database type

        # Verify the key exists in the database, otherwise the script would just give a null reference exception
        Write-Log "Verifying encryption key exists in $databaseName" $debug
        $SqlCmd.CommandText = "select name from sys.column_encryption_keys where name = '$columnKeyName'"
        $encryptionKeyExists = $SqlCmd.ExecuteScalar()
        if (-not $encryptionKeyExists){
            Write-Log "Encryption Key does not exist in Database $databaseName." $warn
            Write-Log "Please follow the instructions in the Copying Keys and Certificates to a New Database section of the encryption setup document and try again." $warn
            $SqlConnection.Close()
            continue
        }else{
            Write-Log "Encryption Key $columnKeyName exists for $serverName\$databaseName" $debug
        }

        $encryptionChanges = @()
        $columnsToProcess = @()
        $stateColumns = @()
        $stateId
        # Build the collection of columns to process
        if ($isFinplus){
            Write-Log "Getting State ID from site_info for finplus database $databaseName" $debug
            # Get the state id from site_info
            $SqlCmd.CommandText = "select state_id from site_info"
            $state_id = $SqlCmd.ExecuteScalar()
            $columnsToProcess = $finplusColumns
            switch($state_id)
            {   
                'MD'{
                        $columnsToProcess += "dbo.mdqtrwage.ssn","dbo.mdretire.ssn","dbo.mdstaff.ssn","dbo.mdqtrwork.ssn"
                    }
                'MO'{
                        $columnsToProcess += "dbo.moretir.ssn","dbo.mo_oasis.ssn","dbo.mo_mosis_core.ssn","dbo.mo_mosis_position.ssn"
                    }
                'MN'{
                        $columnsToProcess += "dbo.mn_qtrwage.ssn","dbo.mn_pera_dem.ssn","dbo.mn_pera_dem.orig_ssn","dbo.mn_tra_dem.ssn","dbo.mn_tra_dem.orig_ssn","dbo.mn_pera_ex.ssn"
                    }
                'PA'{
                        # $columnsToProcess += "dbo.aca_cov_ind.empl_ssn","dbo.aca_cov_ind.ssn"
                    }
                'TX'{
                        # $columnsToProcess += "dbo.aca_cov_ind.empl_ssn", "dbo.aca_cov_ind.ssn "
                    }
                'XX'{
                        Write-Log "No State Code Found" $debug
                    }
            } #end state switch


            Write-Log "Getting Site from site_info for finplus database $databaseName" $debug
            # Get the site_code from site_info
            $SqlCmd.CommandText = "select site_code from site_info"
            $site_code = $SqlCmd.ExecuteScalar()
            switch($site_code)
            {   
                'CLV'{
                        $columnsToProcess += "dbo.physinfo.ssn","dbo.bphysinfo.ssn"
                     }
            } #end site switch

        }else{
            $columnsToProcess = $complusColumns
        }
    
        # Build the collection of column encryption changes to be applied
        $columnsToSkip = @()
        foreach($column in $columnsToProcess){
            $columnParts = $column -split "\."
            $tableName = $columnParts[0] + "." + $columnParts[1]
            $columnName = $columnParts[2]
            $SqlCmd.CommandText = "select count(*) from sys.columns where name = N'$columnName' and object_id = object_id(N'$tableName')"
            $columnCount = $SqlCmd.ExecuteScalar()
            if($columnCount -eq 0)
            {
                Write-Log "The column $column does not exist in the $database database" $debug
                $columnsToSkip += ,$column
            }
            else
            {
                if(-not $decrypt)
                {
                    $encryptionChanges += New-SqlColumnEncryptionSettings -ColumnName $column -EncryptionType Deterministic -EncryptionKey $columnKeyName
                }
                else
                {
                    $operation = "Decryption"
                    $encryptionChanges += New-SqlColumnEncryptionSettings -ColumnName $column -EncryptionType Plaintext
                }
            }
        }
    
        Write-Log "$operation beginning" $debug
        # Excute the commands
        # DO NOT CHANGE NEXT LINE
        Set-SqlColumnEncryption -ColumnEncryptionSettings $encryptionChanges -InputObject $smoDatabase
        # Get currently encrypted columns
        $SqlCmd.CommandText = "SELECT concat('dbo.',t.name,'.',c.name) as name
            FROM sys.columns c
            INNER JOIN sys.column_encryption_keys k ON c.column_encryption_key_id = k.column_encryption_key_id
            INNER JOIN sys.tables t ON c.object_id = t.object_id
            WHERE encryption_type IS NOT NULL
            and k.name = '$columnKeyName'"
        $encryptedColumnsOutput = $SqlCmd.ExecuteReader()
        $encryptedColumns = @()
        if($encryptedColumnsOutput.HasRows){
            while($encryptedColumnsOutput.Read()){
                $encryptedColumns += ($encryptedColumnsOutput.GetString(0))
            }
        }
        $SqlConnection.Close()
        # Verify the operation affected all columns it should have
        if (-not $decrypt)
        {
            $columnsNotEncrypted = ($columnsToProcess | Where-Object {$_ -notin $columnsToSkip}) | Where-Object {$_ -notin $encryptedColumns}
            if ($columnsNotEncrypted.Count -ne 0)
            {
                Write-Log "Not all columns were successfully encrypted" $debug
                foreach ($columnNotEncrypted in $columnsNotEncrypted)
                {
                    Write-Log $columnNotEncrypted $debug
                }
                return -1
            }
        } 
        else
        {
            $columnsNotDecrypted = ($columnsToProcess | Where-Object {$_ -notin $columnsToSkip}) | Where-Object {$_ -in $encryptedColumns}
            if ($columnsNotDecrypted.Count -ne 0)
            {
                Write-Log "Not all columns were successfully decrypted" $debug
                foreach ($encryptedColumn in $columnsNotDecrypted)
                {
                    Write-Log $encryptedColumn $debug
                }
                return -1
            }
        }

        # Check if there have been any non terminating errors during execution
        if($Error){
            Write-Log "$operation on $databaseName failed due to error(s):" $fatal
            foreach($msg in $Error){
                Write-Log $msg.Exception.Message $fatal
            }
            return -1
        }

        Write-Log "$operation completed on $databaseName" $debug
    } #end foreach
}
catch
{
    Write-Log "$operation failed due to error(s):" $fatal
    Write-Log ($_ | format-list -Force | Out-String) $fatal
    if($SqlConnection)
    {
        $SqlConnection.Close()
    }
    return -1
}

return 0