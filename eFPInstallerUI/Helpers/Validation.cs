using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eFPInstallerUI.Helpers
{
    static class Validation
    {
        static DataSet _dsConfig = null;
        static DataSet _dsPreReqConfig = null;
        static string _systemName = null;
        static bool _checkIsItDBServer = false;
        static bool _checkIsAppServer = false;
        static bool _checkIsWFServer = false;
        public static DataSet dsConfig
        {
            get
            {
                return _dsConfig;
            }
            set
            {
                _dsConfig = value;
            }
        }

        public static DataSet dsPreReqConfig
        {
            get
            {
                return _dsPreReqConfig;
            }
            set
            {
                _dsPreReqConfig = value;
            }
        }
        public static string systemName
        {
            get
            {
                return _systemName;
            }
            set
            {
                _systemName = value;
            }
        }
        public static bool checkIsItDBServer
        {
            get
            {
                return _checkIsItDBServer;
            }
            set
            {
                _checkIsItDBServer = value;
            }
        }
        public static bool checkIsAppServer
        {
            get
            {
                return _checkIsAppServer;
            }
            set
            {
                _checkIsAppServer = value;
            }
        }
        public static bool checkIsWFServer
        {
            get
            {
                return _checkIsWFServer;
            }
            set
            {
                _checkIsWFServer = value;
            }
        }

        public static void validateDB()
        {
            if (checkOneDBServerExists())
            {
                //checkOneDBServerExists();
                checkDBServers();
                checkServer("AppServer");
                checkServer("WFServer");
            }


        }
        public static bool validatePreRequisites()
        {
            bool status = true;
            bool status1 = true;
            bool status2 = true;
            try
            {
                status = getSSMSVersions();
                if (status == false)
                {
                    return false;
                }
                status1 = getSqlInstanceVersion();
                if (status1 == false)
                {
                    return false;
                }
                status2 = getMSVisualStudioVersions();
                if (status2 == false)
                {
                    return false;
                }
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }

        }
        public static bool RestoreDB()
        {
            return ValidateAndRestoreDBData();
        }
        static bool checkOneDBServerExists()
        {
            if (_dsConfig.Tables.Count < 0)
            {
                LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " No configuration is found in XML file.");
                return false;
            }

            if (_dsConfig.Tables["DBServers"] == null)
            {
                LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " No Database configuration is found in XML file.");
                return false;
            }


            if (_dsConfig.Tables["DBServer"] == null)
            {
                LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " No Database server configuration is found in XML file.");
                return false;
            }

            DataTable dtDBServer = _dsConfig.Tables["DBServer"];
            DataTable dtDBCredentials = _dsConfig.Tables["DBServers"];

            foreach (DataRow drData in dtDBServer.Rows)
            {
                string ipAddress;
                string hostName;
                ipAddress = getIPAddress(drData["ServerName"].ToString());
                hostName = getHostName(ipAddress);
                var res = (from row in dtDBServer
                          .AsEnumerable()
                           where row.Field<string>("ServerName") == ipAddress || row.Field<string>("ServerName") == hostName || row.Field<string>("ServerName") == drData["ServerName"].ToString()
                           select row);

                if (res.Count() > 1)
                {
                    LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " One or more with same Database server configuration is found in XML file.");
                    return false;
                }
            }

            return true;
        }
        static bool pingServer(string serverName)
        {
            bool pingStatus = false;

            try
            {
                Dictionary<string, object> parameters = new Dictionary<String, object>();
                parameters.Add("ComputerName", serverName);
                var res = Common.PowerShellInvoker("Test-Connection", parameters);
                if (res.Count > 0)
                {
                    pingStatus = true;
                }
                else
                {
                    pingStatus = false;
                }
            }
            catch (Exception ex)
            {

            }
            return pingStatus;
        }
        public static bool checkDBConnection(string serverName, string userName, string password, string databaseName = null)
        {
            bool connStatus = false;

            try
            {
                IDictionary<string, object> parameters = new Dictionary<String, object>();
                parameters.Add("TypeName", "System.Data.SqlClient.SqlConnection");
                var conn = Common.PowerShellInvoker("New-Object", parameters);
                if (conn.Count > 0)
                {
                    string conStr;

                    if (!string.IsNullOrEmpty(databaseName))
                    {
                        conStr = "Server=" + serverName + ";database=" + databaseName + ";Integrated Security=false;User Id = " + userName + " ;Password=" + password;
                    }
                    else
                    {
                        conStr = "Server=" + serverName + "; Integrated Security=false;User Id = " + userName + " ;Password=" + password;
                    }

                    conn[0].Members["connectionstring"].Value = conStr;
                    try
                    {
                        conn[0].Methods["Open"].Invoke();
                        connStatus = true;

                    }
                    catch (Exception ex)
                    {
                    }

                }

                return connStatus;
            }
            catch (Exception ex)
            {

            }
            return connStatus;
        }
        static void checkDBServers()
        {
            DataTable dtDBServer;
            DataTable dtDBCredentials;
            try
            {
                dtDBServer = _dsConfig.Tables["DBServer"];
                dtDBCredentials = _dsConfig.Tables["DBServers"];

                foreach (DataRow drData in dtDBServer.Rows)
                {
                    bool checkDBConn = false;

                    checkDBConn = checkDBConnection(drData["ServerName"].ToString(), dtDBCredentials.Rows[0]["UserName"].ToString(),
                                    dtDBCredentials.Rows[0]["Password"].ToString());
                    if (checkDBConn)
                    {
                        if (!checkIsItDBServer)
                        {
                            //string outPut = obj.RunScript("get-content env:computername").Trim().ToString();
                            if (drData["ServerName"].ToString().Length > 0)
                            {
                                checkIsItDBServer = true;
                            }
                        }
                        LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " Database Server " + drData["ServerName"].ToString() + " found on network");
                    }
                    else
                    {
                        LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " Database Server " + drData["ServerName"].ToString() + " not found on network");
                    }

                }
            }
            catch (Exception ex)
            {
                LogFile.Instance.LogMessage("\r\n checkDBServers::Error in script:" + ex.Message + "\r\n" + "StackTrace : " + ex.StackTrace + "\r\nInnerException:" + ex.InnerException);
            }
        }
        static void checkServer(string mode)
        {
            DataTable dtServer;
            dtServer = _dsConfig.Tables[mode];
            foreach (DataRow drData in dtServer.Rows)
            {

                bool serverStatus;
                try
                {
                    serverStatus = pingServer(drData["ServerName"].ToString());

                    if (serverStatus)
                    {
                        if (checkIsAppServer == false)
                        {
                            //string outPut = obj.RunScript("get-content env:computername").Trim().ToString();
                            if (string.Compare(_systemName, drData["ServerName"].ToString(), true) == 0)
                            {
                                if (mode == "AppServer")
                                {
                                    checkIsAppServer = true;
                                }
                                else
                                {
                                    checkIsWFServer = true;
                                }
                            }
                        }
                        LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " " + mode + " " + drData["ServerName"].ToString() + " found on network");
                    }
                    else
                    {
                        LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " " + mode + " " + drData["ServerName"].ToString() + " not found on network");
                    }
                }
                catch (Exception ex)
                {
                    //LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " - " + drData["ServerName"].ToString() + " Network is not available for " + mode, LogFileType.ExceptionLog);
                    throw new TerminateInstallationException(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " - " + drData["ServerName"].ToString() + " Network is not available for " + mode, ex);

                }

            }
        }
        static string getHostName(string ipAddress)
        {
            string hostName = string.Empty;

            var res = Common.PowerShellScriptInvoker("[System.Net.Dns]::GetHostByAddress(\"" + ipAddress + "\") | Select-Object -Property HostName");
            if (res.Count > 0)
            {
                hostName = res[0].Members["HostName"].Value.ToString();
            }
            return hostName;
        }
        static string getIPAddress(string sysName)
        {
            string hostName = string.Empty;

            var res = Common.PowerShellScriptInvoker("[System.Net.Dns]::GetHostByName(\"" + sysName + "\") | Select-Object -Property AddressList");
            if (res.Count > 0)
            {
                hostName = ((System.Net.IPAddress[])res[0].Members["AddressList"].Value)[0].ToString();
            }
            return hostName;
        }

        static bool ValidateAndRestoreDBData()
        {
            try
            {
                LogFile.Instance.LogMessage(Constants.NEWLINE);
                DataTable dtServers = _dsConfig.Tables["DBServers"];
                DataTable dtDBServer = _dsConfig.Tables["DBServer"];
                DataTable dtDataBase = _dsConfig.Tables["Database"];

                string sourceFilePath = _dsConfig.Tables["SourceFileLocation"].Rows[0]["FilePath"].ToString();

                string userName = "", password = "";
                foreach (DataRow dr in dtServers.Rows)
                {
                    userName = dr["UserName"].ToString();
                    password = dr["Password"].ToString();

                    //if (string.IsNullOrEmpty(userName) || string.IsNullOrEmpty(password))
                    //{
                    //    LogFile.Instance.LogMessage("\r\n  " + DateTime.Now.ToString("HH:mm:ss") + " Database UserName or Password are not available");
                    //   // Form.ActiveForm.Close();
                    //}

                    string ServerName = "";
                    string InstanceName = "";
                    string TransactionLogFileLocation = "";
                    string RestoreFilePath = ""; string DataFileLocation = "";
                    int dbServerId;
                    List<Tuple<string, string>> ServerDetails = new List<Tuple<string, string>>();

                    foreach (DataRow dbServerRow in dtDBServer.Rows)
                    {
                        dbServerId = Convert.ToInt32(dbServerRow["DBServer_Id"]);
                        ServerName = dbServerRow["ServerName"].ToString();
                        InstanceName = dbServerRow["InstanceName"].ToString();
                        RestoreFilePath = dbServerRow["RestoreFilePath"].ToString();
                        DataFileLocation = dbServerRow["DataFileLocation"].ToString();
                        TransactionLogFileLocation = dbServerRow["TransactionLogFileLocation"].ToString();

                        if (!string.IsNullOrEmpty(InstanceName))
                        {
                            ServerName += "/" + InstanceName;
                        }

                        if (ServerDetails.Contains(new Tuple<string, string>(ServerName, InstanceName)))
                        {
                            LogFile.Instance.LogMessage("\r\n  " + DateTime.Now.ToString("HH:mm:ss") + " Database server and Instanse are repeated");
                            return false;
                        }
                        else
                        {

                            ServerDetails.Add(new Tuple<string, string>(ServerName, InstanceName));
                        }

                        if (string.IsNullOrEmpty(RestoreFilePath))
                        {
                            LogFile.Instance.LogMessage("\r\n  " + DateTime.Now.ToString("HH:mm:ss") + " Database " + RestoreFilePath + " not available " + ServerName);
                            return false;
                        }

                        if (string.IsNullOrEmpty(DataFileLocation))
                        {
                            LogFile.Instance.LogMessage("\r\n  " + DateTime.Now.ToString("HH:mm:ss") + " Database " + DataFileLocation + " not available " + ServerName);
                            return false;
                        }

                        if (string.IsNullOrEmpty(TransactionLogFileLocation))
                        {
                            LogFile.Instance.LogMessage("\r\n  " + DateTime.Now.ToString("HH:mm:ss") + " Database " + TransactionLogFileLocation + " not available " + ServerName);
                            return false;
                        }

                        bool chkSQLService = false;
                        IDictionary<string, object> parameters = new Dictionary<String, object>();
                        parameters.Add("ServerName", ServerName);
                        var res = Common.PowerShellScriptInvokerWithParam("CheckSQLServerServiceStatus", parameters);
                        List<string> chk = res[0].ToString().Split('\n').ToList();
                        foreach (string s in chk)
                        {
                            if (s.Contains("MSSQLSERVER") && s.Contains("Running"))
                            {
                                chkSQLService = true;
                                break;
                            }

                        }

                        if (!chkSQLService)
                        {
                            LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " SQL Server Instance Service is not up and Running on server " + ServerName + "\r\n", LogFileType.ExceptionLog);
                            return false;
                        }
                        else
                        {
                            LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " SQL Server Instance Service is up and running on server " + ServerName + "\r\n");
                        }

                        parameters.Clear();
                        parameters.Add("ServerName", ServerName);


                        parameters.Add("DatabaseName", "");
                        parameters.Add("UserName", userName);
                        parameters.Add("Password", password);
                        var Cnt = Common.PowerShellScriptInvokerWithParam("TestSqlConnection", parameters);
                        if (Cnt.Count == 1 && Cnt[0].ToString().Contains("True"))
                        {
                            LogFile.Instance.LogMessage(DateTime.Now.ToString("HH:mm:ss") + " Connected to database server " + ServerName);
                            parameters.Clear();
                            parameters.Add("ServerInstance", ServerName);
                            parameters.Add("Database", "Database");
                            parameters.Add("UserName", userName);
                            parameters.Add("Password", password);
                            parameters.Add("Query", "SELECT CONVERT (varchar, SERVERPROPERTY('collation')) AS 'Server Collation'");

                            string dbCollation = GetDatabaseCollation(ServerName, "", userName, password);
                            if (dbCollation != "Latin1_General_CS_AS")
                            {
                                LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Database Collation should be Latin1_General_CS_AS" + ServerName);
                                return false;
                            }
                            else
                            {
                                LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Database Collation set as Latin1_General_CS_AS for server :" + ServerName);
                            }

                            if (!Directory.Exists(RestoreFilePath))
                            {
                                LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " The " + RestoreFilePath + " does not exist on database server " + ServerName);
                                return false;
                            }
                            if (!Directory.Exists(DataFileLocation))
                            {
                                LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " The " + DataFileLocation + " does not exist on database server " + ServerName);
                                return false;
                            }
                            if (!Directory.Exists(TransactionLogFileLocation))
                            {
                                LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " The " + TransactionLogFileLocation + " does not exist on database server " + ServerName);
                                return false;
                            }

                            string dbName = "";
                            string type = "";
                            string fileName = "";
                            int dbId;
                            int dbListed = 0;
                            foreach (DataRow dbRow in dtDataBase.Rows)
                            {
                                dbId = Convert.ToInt32(dbRow["DBServer_Id"]);
                                if (dbId == dbServerId)
                                {
                                    dbListed++;
                                    dbName = dbRow["Name"].ToString();
                                    fileName = dbRow["FileName"].ToString();
                                    type = dbRow["Type"].ToString();

                                    if (string.IsNullOrEmpty(dbName))
                                    {
                                        LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Database Name not available " + dbName);
                                        return false;
                                    }

                                    if (string.IsNullOrEmpty(type))
                                    {
                                        LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Database Type not available for database :" + dbName);
                                        return false;
                                    }
                                    else
                                    {
                                        parameters.Clear();
                                        parameters.Add("ServerName", ServerName);
                                        parameters.Add("DbName", dbName);
                                        parameters.Add("UserName", userName);
                                        parameters.Add("Password", password);
                                        parameters.Add("FilePath", DataFileLocation);
                                        parameters.Add("Type", type.ToUpper());
                                        Cnt = Common.PowerShellScriptInvokerWithParam("CreateSQLDatabase", parameters);
                                        if (Cnt.Count >= 1 && Cnt[0].ToString().Contains("Created"))
                                        {
                                            LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Database Created successfully for database  : " + dbName);
                                            if (type.ToUpper() == "EFP" || type.ToUpper() == "ECP" || type.ToUpper() == "ASPNETDB" || (type.ToUpper() == "DO" && !string.IsNullOrEmpty(fileName)))
                                            {
                                                if (!string.IsNullOrEmpty(fileName))
                                                {
                                                    string Fname = Path.GetExtension(fileName);
                                                    if (Fname.ToUpper() != ".BAK")
                                                    {
                                                        LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Backup file is not a .bak file " + dbName);
                                                        return false;
                                                    }
                                                    else
                                                    {
                                                        string backUPPath = RestoreFilePath + "\\" + fileName;
                                                        if (!File.Exists(backUPPath))
                                                        {
                                                            LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " The " + RestoreFilePath + "\\" + dbName + ".bak backup file does not exist on database server " + ServerName);
                                                            return false;
                                                        }
                                                        else
                                                        {
                                                            parameters.Clear();
                                                            parameters.Add("ServerName", ServerName);
                                                            parameters.Add("DbName", dbName);
                                                            parameters.Add("UserName", userName);
                                                            parameters.Add("Password", password);
                                                            parameters.Add("FileName", fileName);
                                                            parameters.Add("BackUpPath", RestoreFilePath);
                                                            parameters.Add("DataFileLocation", DataFileLocation);
                                                            parameters.Add("TransactionLogFileLocation", TransactionLogFileLocation);
                                                            Cnt = Common.PowerShellScriptInvokerWithParam("RestoreSQLDatabase", parameters);
                                                            if (Cnt.Count >= 1)
                                                            {
                                                                LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Database Restored Successfully for database  : " + dbName);
                                                            }
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + "FileName is  not available for database " + dbName);
                                                    return false;
                                                }
                                            }
                                            else if (type.ToUpper() == "DO")
                                            {
                                                string doFilePath = sourceFilePath + @"\DatabaseScripts\DocumentsOnline\";

                                                parameters.Clear();
                                                parameters.Add("ServerName", ServerName);
                                                parameters.Add("DbName", dbName);
                                                parameters.Add("UserName", userName);
                                                parameters.Add("Password", password);
                                                parameters.Add("FilePath", doFilePath + "efpdoc.sql");
                                                Cnt = Common.PowerShellScriptInvokerWithParam("ExecuteSQLScript", parameters);
                                                if (Cnt.Count >= 1 && Cnt[0].ToString().Contains("1"))
                                                {
                                                    parameters["FilePath"] = doFilePath + "AttachDBUpdate.sql";
                                                    Cnt = Common.PowerShellScriptInvokerWithParam("ExecuteSQLScript", parameters);
                                                    if (Cnt.Count >= 1 && Cnt[0].ToString().Contains("1"))
                                                    {
                                                        parameters["FilePath"] = doFilePath + "sp_insert_do_im_attach_mstr.sql";
                                                        Cnt = Common.PowerShellScriptInvokerWithParam("ExecuteSQLScript", parameters);

                                                        if (Cnt.Count >= 1 && Cnt[0].ToString().Contains("1"))
                                                        {
                                                            parameters["FilePath"] = doFilePath + "sp_insert_do_im_index_mstr.sql";
                                                            Cnt = Common.PowerShellScriptInvokerWithParam("ExecuteSQLScript", parameters);

                                                            if (Cnt.Count >= 1 && Cnt[0].ToString().Contains("1"))
                                                            {
                                                                parameters["FilePath"] = doFilePath + "sp_insert_do_im_index_dtl.sql";
                                                                Cnt = Common.PowerShellScriptInvokerWithParam("ExecuteSQLScript", parameters);

                                                                if (Cnt.Count >= 1 && Cnt[0].ToString().Contains("1"))
                                                                {
                                                                    parameters["FilePath"] = doFilePath + "sp_insert_do_im_objects.sql";
                                                                    Cnt = Common.PowerShellScriptInvokerWithParam("ExecuteSQLScript", parameters);
                                                                    if (Cnt.Count >= 1 && Cnt[0].ToString().Contains("1"))
                                                                    {
                                                                        LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " SQL scripts exected successfully for database " + dbName);
                                                                    }
                                                                    else
                                                                    {
                                                                        LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Error Occured at SQL script sp_insert_do_im_objects.sql for database " + dbName, LogFileType.ExceptionLog);
                                                                        return false;
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Error Occured at SQL script sp_insert_do_im_index_dtl.sql for database " + dbName, LogFileType.ExceptionLog);
                                                                    return false;
                                                                }
                                                            }
                                                            else
                                                            {
                                                                LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Error Occured at SQL script sp_insert_do_im_index_mstr.sql for database " + dbName, LogFileType.ExceptionLog);
                                                                return false;
                                                            }
                                                        }
                                                        else
                                                        {
                                                            LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Error Occured at SQL script sp_insert_do_im_attach_mstr.sql for database " + dbName, LogFileType.ExceptionLog);
                                                            return false;
                                                        }
                                                    }
                                                    else
                                                    {
                                                        LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Error Occured at SQL script AttachDBUpdate.sql for database " + dbName, LogFileType.ExceptionLog);
                                                        return false;
                                                    }
                                                }
                                                else
                                                {
                                                     LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Error Occured at SQL script efpdoc.sql for database " + dbName, LogFileType.ExceptionLog);
                                                    return false;
                                                }

                                            }
                                            else if (type.ToUpper() == "CATALOG")
                                            {
                                                string doFilePath = sourceFilePath + @"\DatabaseScripts\Catalog\";
                                                parameters.Clear();
                                                parameters.Add("ServerName", ServerName);
                                                parameters.Add("DbName", dbName);
                                                parameters.Add("UserName", userName);
                                                parameters.Add("Password", password);
                                                parameters.Add("FilePath", doFilePath + "efpcatalog.sql");
                                                Cnt = Common.PowerShellScriptInvokerWithParam("ExecuteSQLScript", parameters);
                                                if (Cnt.Count >= 1 && Cnt[0].ToString().Contains("1"))
                                                {
                                                    parameters["FilePath"] = doFilePath + "catalogdata.sql";
                                                    Cnt = Common.PowerShellScriptInvokerWithParam("ExecuteSQLScript", parameters);
                                                    if (Cnt.Count >= 1 && Cnt[0].ToString().Contains("1"))
                                                    {
                                                        LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + "SQL scripts at SourceFileLocation executed successfully for database " + dbName);
                                                    }
                                                    else
                                                    {
                                                        LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Error Occured at SQL script catalogdata.sql for database " + dbName);
                                                        return false;
                                                    }
                                                }
                                                else
                                                {
                                                    LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Error Occured at SQL script efpcatalog.sql for database " + dbName, LogFileType.ExceptionLog);
                                                    return false;
                                                }
                                            }
                                            else if (type.ToUpper() == "COMPLIANCE")
                                            {
                                                string doFilePath = sourceFilePath + @"\DatabaseScripts\Compliance\";
                                                parameters.Clear();
                                                parameters.Add("ServerName", ServerName);
                                                parameters.Add("DbName", dbName);
                                                parameters.Add("UserName", userName);
                                                parameters.Add("Password", password);
                                                parameters.Add("FilePath", doFilePath + "compliance.sql");
                                                Cnt = Common.PowerShellScriptInvokerWithParam("ExecuteSQLScript", parameters);
                                                if (Cnt.Count >= 1 && Cnt[0].ToString().Contains("1"))
                                                {
                                                    LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " SQL scripts executed successfully for database " + dbName);
                                                }
                                                else
                                                {
                                                    LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Error Occured at SQL script compliance.sql for database " + dbName, LogFileType.ExceptionLog);
                                                    return false;
                                                }
                                            }
                                            else if (type.ToUpper() == "AUTH")
                                            {

                                            }
                                            else
                                            {
                                                LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Database Type " + type + " is not valid for database : " + dbName, LogFileType.ExceptionLog);
                                                return false;
                                            }
                                        }
                                        else
                                        {
                                            LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Database " + dbName + " already exists: Not Restored ");
                                        }
                                    }

                                }
                            }

                            if (dbListed == 0)
                            {
                                LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " No database is Listed " + ServerName);
                                return false;
                            }


                        }
                        else
                        {
                            LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Database cannot be connected Because of incorrect UserName or Password.");
                            return false;
                        }
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                LogFile.Instance.LogMessage("\r\n ValidateAndRestoreDBData::Error in Validation and Restoration Script:" + ex.Message + "\r\n" + "StackTrace : " + ex.StackTrace + "\r\nInnerException:" + ex.InnerException);
                return false;
            }

        }

        public static bool CreateSQLServerJob()
        {
            try
            {
                DataTable dtServers = _dsConfig.Tables["DBServers"];
                DataTable dtDBServer = _dsConfig.Tables["DBServer"];

                string userName = dtServers.Rows[0]["UserName"].ToString();
                string password = dtServers.Rows[0]["Password"].ToString();
                string serverName = "", instanseName = "";
                IDictionary<string, object> parameters = new Dictionary<String, object>();

                foreach (DataRow dbServerRow in dtDBServer.Rows)
                {
                    serverName = dbServerRow["ServerName"].ToString();
                    instanseName = dbServerRow["InstanceName"].ToString();

                    if (!string.IsNullOrEmpty(instanseName))
                    {
                        serverName += "/" + instanseName;
                    }

                    bool chkSQLAgentService = false;
                    parameters.Clear();
                    parameters.Add("ServerName", serverName);
                    var res = Common.PowerShellScriptInvokerWithParam("CheckSQLServerServiceStatus", parameters);
                    List<string> chk = res[0].ToString().Split('\n').ToList();
                    foreach (string s in chk)
                    {
                        if (s.Contains("SQLSERVERAGENT") && s.Contains("Running"))
                        {
                            chkSQLAgentService = true;
                            break;
                        }
                    }

                    if (!chkSQLAgentService)
                    {
                        LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " SQL Server Agent Service is not up and running on server " + serverName + "\r\n", LogFileType.ExceptionLog);
                        return false;
                    }
                    else
                    {
                        LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " SQL Server Agent Service is up and running on server " + serverName);
                    }

                    parameters.Clear();
                    parameters.Add("ServerName", serverName);

                    parameters.Add("DatabaseName", "");
                    parameters.Add("UserName", userName);
                    parameters.Add("Password", password);
                    var Cnt = Common.PowerShellScriptInvokerWithParam("TestSqlConnection", parameters);
                    if (Cnt.Count == 1 && Cnt[0].ToString().Contains("True"))
                    {
                        parameters.Clear();
                        parameters.Add("ServerName", serverName);
                        parameters.Add("JobName", "fpsCronJob");
                        parameters.Add("UserName", userName);
                        parameters.Add("Password", password);

                        Common.PowerShellScriptInvokerWithParam("CreateSQLServerJob", parameters);
                        LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Created fpsCronJob SQL Job on server : " + serverName);

                        parameters["JobName"] = "fpsClearCatalogArchives";
                        Common.PowerShellScriptInvokerWithParam("CatalogArchiveRecords", parameters);
                        LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Created fpsClearCatalogArchives SQL Job  on server : " + serverName);

                        parameters["JobName"] = "cpsCronJob";
                        Common.PowerShellScriptInvokerWithParam("UpdateTransactionDateANDCleanup", parameters);
                        LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " Created cpsCronJob SQL Job  on server : " + serverName);
                    }
                    else
                    {
                        LogFile.Instance.LogMessage("\r\n" + DateTime.Now.ToString("HH:mm:ss") + " SQL Jobs cannot be created on server : " + serverName + " as connection cannot be established." + LogFileType.ExceptionLog);
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                LogFile.Instance.LogMessage("\r\n CreateSQLServerJob::Error in Creating SQL Server Jobs :" + ex.Message + "\r\n" + "StackTrace : " + ex.StackTrace + "\r\nInnerException:" + ex.InnerException, LogFileType.ExceptionLog);
                return false;
            }

        }
        static string GetDatabaseCollation(string server, string DB, string user, string pwd)
        {
            using (SqlConnection sqlConnection = new SqlConnection(@"Data Source=" + server + ";Initial Catalog=" + DB + ";User Id=" + user + ";Password=" + pwd + ";"))
            {

                string dbCollation = "";

                try
                {
                    string query = "SELECT CONVERT (varchar, SERVERPROPERTY('collation')) AS 'Server Collation'";
                    SqlCommand sqlCommand = new SqlCommand(query, sqlConnection);
                    sqlConnection.Open();
                    dbCollation = sqlCommand.ExecuteScalar().ToString();
                    return dbCollation;
                }
                catch (Exception ex)
                {
                    return dbCollation;
                }
            }
        }
        static bool getSSMSVersions()
        {
            string currSSMS = string.Empty;
            double currVersion = 0.0D;
            double sqlMinVersion = 0.0D;
            double recentVersion = 0.0D;
            bool isValid = false;
            try
            {
                IDictionary<string, object> parameters = new Dictionary<string, object>();

                string sVersion = string.Empty;
                //parameters.Clear();

                //parameters.Add("Path", @"HKCU:\HKEY_CURRENT_USER\Software\Microsoft\SQL Server Management Studio");

                var res = Common.PowerShellScriptInvoker(@"Get-ChildItem -path 'HKCU:\SOFTWARE\Microsoft\SQL Server Management studio' | where {$_.Property -like '*ProductVersion*'} | Get-ItemPropertyValue -Name ProductVersion");
                if (res.Count > 0)
                {
                    DataTable SSMSVersion = _dsPreReqConfig.Tables["SSMSVersion"];

                    for (int i = 0; i < res.Count; i++)
                    {
                        foreach (DataRow drData in SSMSVersion.Rows)
                        {
                            currSSMS = res[i].ToString().Split('.')[0];
                            sVersion = drData["MinVersion"].ToString();

                            Double.TryParse(currSSMS, out currVersion);
                            Double.TryParse(sVersion, out sqlMinVersion);

                            if (currVersion >= sqlMinVersion)
                            {
                                isValid = true;
                                break;
                            }
                            else
                            {
                                recentVersion = currVersion;
                            }

                        }
                    }

                    if (isValid)
                    {
                        LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " SQL Server Management Studio version is " + currVersion);
                    }
                    else
                    {
                        LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + string.Format(" ERROR: SQL Server Management Studio version is {0}, but must be greater than or equal to {1}", recentVersion, sqlMinVersion));
                    }

                }
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }



        }
        static bool getMSVisualStudioVersions()
        {
            IDictionary<string, object> parameters = new Dictionary<string, object>();
            double currFramework = 0.0;
            string VName = string.Empty;
            bool isValid = false;

            try
            {
                var res = Common.PowerShellScriptInvoker(@"Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse | Get-ItemProperty -name Version | Where { $_.PSChildName -match '^(?!S)\p{L}'} | Select PSChildName, Version, Release");
                if (res.Count > 0)
                {
                    for (int i = 0; i < res.Count; i++)
                    {
                        string[] strArray = res[i].Members["Version"].Value.ToString().Split('.');
                        if (strArray.Length >= 2)
                        {
                            VName = strArray[0] + "." + strArray[1];
                        }
                        else
                        {
                            VName = res[i].Members["Version"].Value.ToString();
                        }
                        Double.TryParse(VName, out currFramework);

                        DataTable VisualStudioVersion = _dsPreReqConfig.Tables["VisualStudioVersion"];

                        double xyz = 0.0;
                        Double.TryParse(VisualStudioVersion.Rows[0]["MinVersion"].ToString(), out xyz);

                        if (currFramework == xyz)
                        {
                            isValid = true;
                            break;
                        }
                    }

                    if (isValid)
                    {
                        LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " DotNet Framework version 3.5 is installed");
                    }
                    else
                    {
                        LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " DotNet Framework version 3.5 is not installed" + " Version:" + currFramework);
                    }


                }
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }



        }
        static bool getSqlInstanceVersion()
        {
            string sVersion = string.Empty;
            string currSSMS = string.Empty;
            double currVersion = 0.0D;
            double sqlMinVersion = 0.0D;
            double recentVersion = 0.0D;
            bool isValid = false;
            try
            {
                var res = Common.PowerShellScriptInvoker(@"[reflection.assembly]::LoadWithPartialName('Microsoft.SqlServer.Smo') | out-null |New-Object 'Microsoft.SqlServer.Management.Smo.Server' '.'");

                if (res.Count > 0)
                {
                    for (int i = 0; i < res.Count; i++)
                    {
                        DataTable SQLVersion = _dsPreReqConfig.Tables["SQLVersion"];
                        foreach (DataRow drData
                            in SQLVersion.Rows)
                        {
                            currSSMS = res[i].Members["VersionString"].Value.ToString().Split('.')[0];
                            sVersion = drData["MinVersion"].ToString();

                            Double.TryParse(currSSMS, out currVersion);
                            Double.TryParse(sVersion, out sqlMinVersion);

                            if (currVersion >= sqlMinVersion)
                            {
                                isValid = true;
                                break;
                            }
                            else
                            {
                                recentVersion = currVersion;
                            }
                        }
                        if (SQLVersion.Rows.Count == 0)
                        {
                            LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " System SqlServer configuration entry is not found in the configuration file ");
                            break;
                        }
                    }

                    if (!isValid)
                    {
                        LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + string.Format(" ERROR: SQL Server version is {0}, but must be greater than or equal to {1}", recentVersion, sqlMinVersion));
                    }
                    else
                    {
                        LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " SQL Server version is " + currVersion);
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }

        }

    }
}

