# This script verifies that a CEK (column encryption key) exists with the provided $columnKeyName
# if it does not, and a certificate with a subject of "Always Encrypted*" exists, it will utilize the
# existing certificate to generate a new CMK (column master key) and CEK Otherwise it will generate a 
# new certificate and then create the CMK and CEK
param(
	[string] $userid,
	[string] $password,
	[string] $serverName,
	[string] $columnKeyName,
	[string] $masterKeyName,
	[string] $database
)

$debug = "DEBUG"
$warn = "WARN"
$fatal = "FATAL"
$operation = "Encryption"
# Make sure we're not persisting any errors
$Error.Clear()
	
# Include logging capability
."$PSScriptRoot\Logging.ps1"

[bool] $allParameters = $True
$usage = "Usage: CertAndEncryptionKeys.ps1 -userid <userid> -password <password> -serverName <databaseServerName> -database database -columnKeyName <columnKeyName> -masterKeyName <masterKeyName>"

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
if([string]::IsNullOrWhiteSpace($masterKeyName)){
	Write-Log "column master key name must be passed to the script" $fatal
	$allParameters = $False
}
if([string]::IsNullOrWhiteSpace($database)){
	Write-Log "must pass at least one database" $fatal
	$allParameters = $False
}

if(-not $allParameters){
	Write-Log $usage $fatal
	return -1
}

Import-Module SqlServer

Write-Log "User ID: $userid Server Name: $serverName Database: $database Encryption Key: $columnKeyName" $debug

Write-Log "Establishing connection to $serverName\$database" $debug
$sqlConnectionString = "Data Source= $serverName;Initial Catalog=$database;User ID=$userid;Password=$password;MultipleActiveResultSets=False;Connect Timeout=30;Encrypt=False;TrustServerCertificate=False;Packet Size=4096;Application Name=`"Microsoft SQL Server Management Studio`""
$smoDatabase = Get-SqlDatabase -ConnectionString $sqlConnectionString
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = $sqlConnectionString
$SqlConnection.Open()
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.Connection = $sqlConnection
$SqlCmd.CommandText = "select name from sys.column_encryption_keys where name = '$columnKeyName'"
$encryptionKeyExists = $SqlCmd.ExecuteScalar()
$SqlCmd.CommandText = "select name from sys.column_master_keys where name = '$masterKeyName'"
$masterKeyExists = $SqlCmd.ExecuteScalar()
if(-not $encryptionKeyExists -and -not $masterKeyExists){
# Get local machine certificates and search for one like Always Encrypted*
	$cert = Get-ChildItem -Path cert:\LocalMachine\My\ | ? { $_.subject -like "cn=Always Encrypted*" }
	if (-not $cert){
		# Create the certificate if it wasn't found
		$cert = New-SelfSignedCertificate -Subject "Always Encrypted Certificate" -CertStoreLocation Cert:LocalMachine\My -KeyExportPolicy Exportable -Type DocumentEncryptionCert -KeyUsage DataEncipherment -KeySpec KeyExchange -NotAfter (Get-Date).AddYears(1)
		Write-Log "Certificate created" $debug
	}
	$today = Get-Date -Format G #MM/DD/YYYY HH:MM:SS A/PM
	Export-PfxCertificate -FilePath C:\Cert\AlwaysEncrypted$today.pfx -Password $password
	Write-Log "Certificate exported to C:\Cert\AlwaysEncrypted.pfx (if it did not already exist)" $debug
	# Create a SqlColumnMasterKeySettings object for the column master key from the found/created cert
	$cmkSettings = New-SqlCertificateStoreColumnMasterKeySettings -CertificateStoreLocation "LocalMachine" -Thumbprint $cert.Thumbprint
	# Create column master key metadata in the database.
	New-SqlColumnMasterKey -Name $masterKeyName -InputObject $smoDatabase -ColumnMasterKeySettings $cmkSettings
	# Generate a column encryption key, encrypt it with the column master key and create column encryption key metadata in the database. 
	New-SqlColumnEncryptionKey -Name $columnKeyName  -InputObject $smoDatabase -ColumnMasterKey $masterKeyName
} else {
	Write-Log "CMK and CEK exist in $database" $debug
}
$SqlConnection.Close()
return 0