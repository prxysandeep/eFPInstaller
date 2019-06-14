#region Namespaces
using eFPInstallerUI.Helpers;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
#endregion

namespace eFPInstallerUI
{
    static class DBConnections
    {
        /// <summary>
        /// Function to save the DB Connections
        /// </summary>
        public static void SaveDBConnections(DataSet dsConfig)
        {
            DataTable dtDBServer;
            DataTable dtDBCredentials;
            DataTable dtDatabases;
            SqlConnection con = new SqlConnection();


            dtDBServer = dsConfig.Tables["DBServer"];
            dtDBCredentials = dsConfig.Tables["DBServers"];
            dtDatabases = dsConfig.Tables["Database"];

            try
            {

                foreach (DataRow drData in dtDBServer.Rows)
                {
                    // check if we are able to connect to the database server with given usernamed and password
                    bool checkDBConn = Validation.checkDBConnection(drData["ServerName"].ToString(), dtDBCredentials.Rows[0]["UserName"].ToString(),
                                        dtDBCredentials.Rows[0]["Password"].ToString());
                    if (checkDBConn)
                    {
                        ConnectionString connection;
                        Encrypter.Encrypter.Encrypter enc = new Encrypter.Encrypter.Encrypter();
                        string sqlExistsString = "SELECT * FROM database_info where db_name = @db_name";
                        string sqlUpdateString = "UPDATE database_info SET db_name = @db_name, sql_server_info = @sql_server_info, username = @username, password = @password, db_type = @db_type WHERE db_id = @db_id";
                        string sqlInsertString = "INSERT INTO database_info (db_id, db_name, sql_server_info, username, password, db_type) VALUES(@db_id, @db_name, @sql_server_info, @username, @password, @db_type)";

                        foreach (DataRow drDatabase in dtDatabases.Rows)
                        {
                            connection = new ConnectionString();
                            //Assign values
                            connection.DataSource = drData["ServerName"].ToString();
                            connection.UserId = dtDBCredentials.Rows[0]["UserName"].ToString();
                            connection.Password = dtDBCredentials.Rows[0]["Password"].ToString();
                            connection.Name = drDatabase["Name"].ToString();
                            connection.Type = drDatabase["Type"].ToString();

                            if (!(connection.Type.ToUpper() == "CATALOG"))
                            {                                
                                SqlCommand cmd;

                                if (!(con.State == ConnectionState.Open))
                                {
                                    con.ConnectionString = string.Format("Server={0};database={1};User Id={2};Password={3};Integrated Security=false",
                                                                       drData["ServerName"].ToString(), ConfigurationManager.AppSettings["DBName"], dtDBCredentials.Rows[0]["UserName"].ToString(),
                                                                       dtDBCredentials.Rows[0]["Password"].ToString());
                                    //Open the connection
                                    con.Open();
                                }

                                if (!string.IsNullOrEmpty(connection.Name))
                                {
                                    cmd = new SqlCommand(sqlExistsString, con);
                                    cmd.Parameters.AddWithValue("@db_name", connection.Name);
                                    var reader = cmd.ExecuteReader();

                                    while(reader.Read())
                                    {
                                        string server = enc.Decrypt(reader.GetString(2));
                                        
                                        // compare the server after decryption
                                        if (server.ToUpper() == connection.DataSource.ToUpper())
                                        {
                                            connection.Id = reader.GetValue(0).ToString();
                                        }
                                        
                                    }
                                    // close the datbase reader
                                    reader.Close();

                                    if (!string.IsNullOrEmpty(connection.Id))
                                    {
                                        
                                        cmd = new SqlCommand(sqlUpdateString, con);
                                        cmd.Parameters.AddWithValue("@db_id", connection.Id);
                                        cmd.Parameters.AddWithValue("@db_name", connection.Name);
                                        cmd.Parameters.AddWithValue("@sql_server_info", enc.Encrypt(connection.DataSource));
                                        cmd.Parameters.AddWithValue("@username", enc.Encrypt(connection.UserId));
                                        cmd.Parameters.AddWithValue("@password", enc.Encrypt(connection.Password));
                                        cmd.Parameters.AddWithValue("@db_type", connection.Type);

                                        int rowsUpdated = cmd.ExecuteNonQuery();

                                        if (rowsUpdated == 1)
                                        {
                                            LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " Updated the database name " + connection.Name + " with the database id " + connection.Id);

                                        }
                                        else
                                        {
                                            LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + "Failed to Update the database name " + connection.Name + " with the database id " + connection.Id);

                                        }
                                    }
                                    else
                                    {
                                        cmd = new SqlCommand(sqlInsertString, con);
                                        cmd.Parameters.AddWithValue("@db_id", Guid.NewGuid().ToString());
                                        cmd.Parameters.AddWithValue("@db_name", connection.Name);
                                        cmd.Parameters.AddWithValue("@sql_server_info", enc.Encrypt(connection.DataSource));
                                        cmd.Parameters.AddWithValue("@username", enc.Encrypt(connection.UserId));
                                        cmd.Parameters.AddWithValue("@password", enc.Encrypt(connection.Password));
                                        cmd.Parameters.AddWithValue("@db_type", connection.Type);

                                        int rowsInserted = cmd.ExecuteNonQuery();

                                        if (rowsInserted == 1)
                                        {
                                            LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " Inserted the database name " + connection.Name + " in the database");
                                        }
                                        else
                                        {
                                            LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + "Failed to insert the database name " + connection.Name + " in the database");
                                        }
                                    }
                                }
                                

                            }


                        }
                    }
                    else
                    {
                        LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + "Not able to connect to the Database Server " + drData["ServerName"].ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                LogFile.Instance.LogMessage("\r\n DBConnection::Unable to save the DB Connection." + ex.Message + "\r\n" + "StackTrace : " + ex.StackTrace + "\r\nInnerException:" + ex.InnerException);
            }
            finally
            {
                //Close and dispose the connection
                con.Close();
                con.Dispose();
            }


        }
    }

    class ConnectionString
    {
        /// <summary>
        /// Database ID
        /// </summary>
        public string Id { get; set; }

        /// <summary>
        /// Database Name to store in the database
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// DataSource
        /// </summary>
        public string DataSource { get; set; }

        /// <summary>
        /// Database Name to store the connection
        /// </summary>
        public string InitialCatalog { get; set; }

        /// <summary>
        /// UserID to connect to the database
        /// </summary>
        public string UserId { get; set; }

        /// <summary>
        /// Password to connect to the database
        /// </summary>
        public string Password { get; set; }

        /// <summary>
        /// Type
        /// </summary>
        public string Type { get; set; }
    }
}
