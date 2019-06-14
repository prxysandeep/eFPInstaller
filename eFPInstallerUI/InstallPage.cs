using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Runtime.Serialization;
using System.Management.Automation;
using System.Management;
using System.Security;
using System.Collections;
using System.Reflection;
using eFPInstallerUI.Helpers;
using System.Data.SqlClient;
using System.Drawing.Text;
using System.Windows;

namespace eFPInstallerUI
{
    public partial class InstallPage : Form
    {
        private System.Windows.Forms.Timer timer;

        public enum InstallationStep
        {
            ValidateDB,
            CheckDBServer,
            CheckAppServer
        }

        #region Properties

        #endregion

        /// <summary>
        /// Constructor
        /// </summary>
        public InstallPage()
        {
            //string NewRegistryPath = @"HKCU:\software";
           
            InitializeComponent();
            LoadGridData();
            imgPictureBox.Visible = true;
            timer = new System.Windows.Forms.Timer();
            timer.Tick += timerTick;
            RegisterKey.UpdateRegistryPropertyValue(NewRegistryPath + @"\eFPInstaller", "InstallStep", "").ToString();
            var progress = RegisterKey.GetRegistryPropertyValue(NewRegistryPath + @"\eFPInstaller", "InstallStep");
            if (progress == null | progress == string.Empty)
            {
                RegisterKey.SetRegistry("eFPInstaller", "InstallerStep", NewRegistryPath);
                RegisterKey.SetRegistryProperty(NewRegistryPath + @"\eFPInstaller", "InstallStep", string.Empty, "String");
            }
        }

        #region Private Variables

        #region Progress bar 
        private int ProgressMinimum = 0;
        private int ProgressMaximum = 100;
        private int ProgressValue = 0;
        private Dictionary<string, string> dicExceptionAtSteps = new Dictionary<string, string>();
        private bool isExceptonOccured = false; 
        #endregion

        #region Installer 
        //Prompt dialog;
        string NewRegistryPath = @"HKCU:\software";
        InstallRun obj = new InstallRun();
        bool checkIsItDBServer = false;
        bool checkIsAppServer = false;
        bool checkIsWFServer = false;
        #endregion

        #endregion
        
        private void BtnInstall_Click(object sender, EventArgs e)
        {
            this.btnCancel.Enabled = false;
            this.btnResume.Enabled = false;
            if (this.dicExceptionAtSteps.Any())
            {
                this.dicExceptionAtSteps.Clear();
            }

            ProgressValue = 0;
            picProgress.Show();
            this.Installation();
        }
        private void timerTick(object sender, EventArgs e)
        {
            if (this.isExceptonOccured)
            {
                this.timer.Stop();
                this.btnInstall.Enabled = false;
                this.btnCancel.Enabled = true;
            }
            else
            {
                this.SetValue(1);
            }
        }
        private void SetValue(int value)
        {
            ProgressValue += value;
            if (ProgressValue > ProgressMaximum)
            {
                timer.Stop();
                if (System.Windows.MessageBox.Show("Installation completed successfully.", "Installation confirmation", MessageBoxButton.OK, MessageBoxImage.Information) == MessageBoxResult.OK)
                {
                    ProgressValue = 0;
                    ProcessingText.Text = "";
                }
            }

            picProgress.Refresh();
        }        
        private void picProgress_Paint(object sender, PaintEventArgs e)
        {
            // Clear the background.
            e.Graphics.Clear(picProgress.BackColor);

            // Draw the progress bar.
            float fraction =
                (float)(ProgressValue - ProgressMinimum) /
                (ProgressMaximum - ProgressMinimum);

            int wid = (int)(fraction * picProgress.ClientSize.Width);

            e.Graphics.FillRectangle(
                Brushes.LightGreen, 0, 0, wid,
                picProgress.ClientSize.Height);

            // Draw the text.
            e.Graphics.TextRenderingHint =
                TextRenderingHint.AntiAliasGridFit;
            using (StringFormat sf = new StringFormat())
            {
                sf.Alignment = StringAlignment.Center;
                sf.LineAlignment = StringAlignment.Center;
                int percent = (int)(fraction * 100);
                e.Graphics.DrawString(
                    percent.ToString() + "%",
                    this.Font, Brushes.Black,
                    picProgress.ClientRectangle, sf);
            }

        }

        /// <summary>
        /// Starting piont of installation
        /// </summary>
        private void Installation()
        {
            DataSet dsConfig = null;
            string outPut = string.Empty;
            bool isErrorOccured = false;
            try
            {
                this.isExceptonOccured = false;
                timer.Start();
                if (!this.btnResume.Enabled)
                {
                    LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + "DATE: " + DateTime.Now.ToString("MM/dd/yyyy") + Constants.CARRIAGERETURNEWLINE);
                    //LogFile.Instance.LogMessage("\r\n " + DateTime.Now.ToString("MM/dd/yyyy") + " \r\n");
                   outPut = obj.RunScript("get-content env:computername").Trim().ToString();
                    LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + Constants.NEWLINE + DateTime.Now.ToString("HH:mm:ss") + " Installation Process Started on " + outPut + Constants.CARRIAGERETURNEWLINE);

                    LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + Constants.NEWLINE + " VALIDATING SERVERS:  \r\n");
                    this.btnResume.Enabled = false;
                }
                //GetSqlConnectionCmdlet objs = new GetSqlConnectionCmdlet();
                dsConfig = ReadConfigXML();
                var progress = RegisterKey.GetRegistryPropertyValue(NewRegistryPath + @"\eFPInstaller", "InstallStep");
                //installing step 1
                this.ProcessingText.Text = "Reading XML File..";
                this.ProcessingText.Text = "Validate DB Started...";
                this.ValidateDB(dsConfig, outPut, progress);
                //this.ProcessingText.Text = string.Empty;
                //installing step 2
                this.ProcessingText.Text = "Validate DB Completed...";
                this.checkForDBServer(dsConfig);
                //this.ProcessingText.Text = string.Empty;
                //installing step 3
                this.ProcessingText.Text = "Check for DB Server completed...";
                this.ProcessingText.Text = "Check for App/WF Server Started...";

                if (dicExceptionAtSteps.Count == 0 || dicExceptionAtSteps["Step3"] == "Processing")
                {
                    this.StepThree();
                }
                this.ProcessingText.Text = "Check for App/WF Server Completed...";
                //this.ProcessingText.Text = string.Empty;

                LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " - Install process completed successfully");
            }
            catch (Exception ex)
            {
                string error = ex.InnerException != null ? ex.InnerException.Message : ex.ToString();
                System.Windows.MessageBox.Show(error, "Exception Info", MessageBoxButton.OK);
                //LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + "Error in script:" + error.Message + Constants.CARRIAGERETURNEWLINE + "StackTrace : " + error.StackTrace + Constants.CARRIAGERETURNEWLINE + "InnerException:" + error.InnerException, LogFileType.ExceptionLog);
                LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " Error in script:" + ex.Message + Constants.CARRIAGERETURNEWLINE + "StackTrace : " + ex.StackTrace + Constants.CARRIAGERETURNEWLINE + "InnerException:" + error, LogFileType.ExceptionLog);
                isErrorOccured = true;
                throw new TerminateInstallationException(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " Error in script:" + ex.Message + Constants.CARRIAGERETURNEWLINE + "StackTrace : " + ex.StackTrace + Constants.CARRIAGERETURNEWLINE + "InnerException:" + ex.InnerException, ex);
                
            }

            if(isErrorOccured)
            {
                this.isExceptonOccured = true;
               // this.timer.Stop();
               //  this.btnInstall.Text = "Start Over";
            }
        }

        /// <summary>
        /// validateDB
        /// </summary>
        /// <param name="dsConfig"></param>
        /// <param name="outPut"></param>
        /// <param name="progress"></param>
        private void ValidateDB(DataSet dsConfig, string outPut, string progress)
        {
            if (progress.ToLower() == "")
            {
                RegisterKey.UpdateRegistryPropertyValue(NewRegistryPath + @"\eFPInstaller", "InstallStep", "validateDB").ToString();
            }
            DataSet dsPreReqConfig = ReadPreReqConfigXML();

            Validation.dsConfig = dsConfig;
            Validation.dsPreReqConfig = dsPreReqConfig;
            Validation.systemName = outPut;
            Validation.validateDB();
        }
        /// <summary>
        /// checkDBServer
        /// </summary>
      private void checkForDBServer(DataSet dsConfig)
        {
            try
            {

                string progress = RegisterKey.GetRegistryPropertyValue(NewRegistryPath + @"\eFPInstaller", "InstallStep");
                if (progress.ToLower() == "validatedb")
                {
                    RegisterKey.UpdateRegistryPropertyValue(NewRegistryPath + @"\eFPInstaller", "InstallStep", "checkForDBServer").ToString();
                }
                checkIsItDBServer = Validation.checkIsItDBServer;
                checkIsAppServer = Validation.checkIsAppServer;
                checkIsWFServer = Validation.checkIsWFServer;

                LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + Constants.NEWLINE + " INSTALLING DATABASE SERVER:" + Constants.CARRIAGERETURNEWLINE);
                if (checkIsItDBServer == true)
                {
                    LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + Constants.NEWLINE + " The current machine is a database server: " + Constants.CARRIAGERETURNEWLINE);
                    string SuccessPath = string.Empty;
                    bool validatePreRequisiteStatus = false;
                    foreach (DataGridViewRow row in StatusGrid.Rows)
                    {
                        SuccessPath = System.AppDomain.CurrentDomain.BaseDirectory + "/Images/Success.png";
                        Image img = System.Drawing.Image.FromFile(SuccessPath);
                        if (row.Index == 0)
                        {
                            LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + Constants.NEWLINE + " VALIDATING PREREQUISITES: " + Constants.CARRIAGERETURNEWLINE);

                            validatePreRequisiteStatus = Validation.validatePreRequisites();
                            if (validatePreRequisiteStatus == true)
                            {
                                row.Cells[0].Value = img;
                            }
                            else
                            {

                            }

                        }

                        if (row.Index == 1)
                        {
                            LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + Constants.NEWLINE + " CONFIGURING DATABASE SERVER: " + Constants.CARRIAGERETURNEWLINE);

                            validatePreRequisiteStatus = Validation.RestoreDB();
                            DBConnections.SaveDBConnections(dsConfig);
                            if (validatePreRequisiteStatus == true)
                            {
                                row.Cells[0].Value = img;

                            }

                        }
                      
                        if (row.Index == 2)
                        {
                           // LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + Constants.NEWLINE + " Create SQLServer Job: " + Constants.CARRIAGERETURNEWLINE);

                            validatePreRequisiteStatus = Validation.CreateSQLServerJob(); ;
                            if (validatePreRequisiteStatus == true)
                            {
                                row.Cells[0].Value = img;
                            }

                        }

                    }

                    

                    //Save the DB Connections





                }
                else
                {
                    LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " The current machine is not a database server " + Constants.CARRIAGERETURNEWLINE);
                }

            }
            catch (Exception ex)
            {

            }

        }

        /// <summary>
        /// Step 3
        /// </summary>
        private void StepThree()
        {
            try
            {
                this.dicExceptionAtSteps["Step1"] = "Processing";
                string progress = RegisterKey.GetRegistryPropertyValue(NewRegistryPath + @"\eFPInstaller", "InstallStep");
                if (progress.ToLower() == "checkfordbserver")
                {
                    RegisterKey.UpdateRegistryPropertyValue(NewRegistryPath + @"\eFPInstaller", "InstallStep", "checkforApp").ToString();
                }

                LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + Constants.NEWLINE + " INSTALLING APPLICATION SERVER: " + Constants.CARRIAGERETURNEWLINE);
                if (checkIsItDBServer == false && checkIsAppServer == true)
                {
                    LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " The current machine is a Application server " + Constants.CARRIAGERETURNEWLINE);
                }
                else
                {
                    LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " The current machine is not a Application server " + Constants.CARRIAGERETURNEWLINE);
                }

                LogFile.Instance.LogMessage("\r\n\n INSTALLING WORKFLOW SERVER: \r\n");
                if (checkIsItDBServer == false && checkIsWFServer == true)
                {
                    LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " The current machine is a Workflow server " + Constants.CARRIAGERETURNEWLINE);
                }
                else
                {
                    LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " The current machine is not a Workflow server " + Constants.CARRIAGERETURNEWLINE);
                }

                throw new Exception("Exception occured in Step 3.");
            }
            catch (Exception ex)
            {
               // isExceptonOccured = true;
                UpdateProgressBarValueIfExceptionOccurs(ex, 3);
            }

            this.dicExceptionAtSteps["Step3"] = "Processed";
        }

        private void RestoreDBData(DataTable dtDBServer, DataTable dtDBdata)
        {
            try
            {
                foreach (DataRow drData in dtDBServer.Rows)
                {
                    foreach (DataRow dbdrData in dtDBdata.Rows)
                    {

                        if (drData["DBServer_id"].ToString() == dbdrData["DBServer_id"].ToString())
                        {

                            IDictionary<string, object> parameters = new Dictionary<String, object>();
                            string ServerInstance = drData["ServerName"].ToString();
                            if (drData["InstanceName"].ToString() != null && drData["InstanceName"].ToString() != "")
                            {
                                ServerInstance = drData["ServerName"].ToString() + "/" + drData["InstanceName"].ToString();
                            }

                            parameters.Add("ServerInstance", ServerInstance);
                            parameters.Add("Name", dbdrData["Name"].ToString());

                            var Cnt = Common.PowerShellInvoker("Get-SqlDatabase", parameters);
                            if (Cnt.Count > 0)
                            {
                                LogFile.Instance.LogMessage(DateTime.Now.ToString("HH:mm:ss") + " - " + dbdrData["Name"].ToString() + " Database is avaliable for retoring");
                                parameters.Clear();
                                parameters.Add("ServerInstance", ServerInstance);
                                parameters.Add("Database", dbdrData["Name"].ToString());
                                string filepath = drData["RestoreFilePath"].ToString() + "\\" + dbdrData["FileName"].ToString();
                                parameters.Add("BackupFile", filepath);
                                try
                                {
                                    Common.PowerShellInvoker("Restore-SqlDatabase", parameters);
                                    LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " - " + dbdrData["FileName"].ToString() + " Successfully data is Restored");

                                }
                                catch (Exception ex)
                                {
                                    LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " - " + drData["FileName"].ToString() + " Failed while data is Restoring");
                                }


                            }
                            else
                            {
                                LogFile.Instance.LogMessage(DateTime.Now.ToString("HH:mm:ss") + " - " + dbdrData["Name"].ToString() + " Database is not avaliable for retoring");
                                LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " - " + dbdrData["Name"].ToString() + "Database is not avaliable for retoring");
                            }
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                //LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + "RestoreDBData::Error in script:" + ex.Message + "\r\n" + "StackTrace : " + ex.StackTrace + "\r\nInnerException:" + ex.InnerException);
                throw new TerminateInstallationException(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " RestoreDBData::Error in script:" + ex.Message + Constants.CARRIAGERETURNEWLINE + "StackTrace : " + ex.StackTrace + Constants.CARRIAGERETURNEWLINE + "InnerException:" + ex.InnerException, ex);
            }
        }

        /// <summary>
        /// Method to track prgress bar value if exceptions occurs in Installation process.
        /// </summary>
        /// <param name="ex">The exception object.</param>
        /// <param name="step">The step where error occurs.</param>
        private void UpdateProgressBarValueIfExceptionOccurs(Exception ex, int step)
        {
            // clsRegistryKey.UpdateRegistryPropertyValue(NewRegistryPath + @"\efInstaller", "ProgressValue", ProgressValue.ToString()).ToString();
            string message = String.Format("Exception occur in Step : {0} and the exception : {1}", step, ex.StackTrace);
            throw new InstallerErrorException(message, ex);
        }

        #region Read Config Files
        private DataSet ReadConfigXML()
        {
            //string path = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), @"InstallSettings.xml");
            Assembly asm = Assembly.GetExecutingAssembly();
            string asmPath = System.IO.Path.GetDirectoryName(asm.Location);
            string[] s = { "\\bin" };
            string path = Path.Combine(asmPath.Split(s, StringSplitOptions.None)[0], @"InstallSettings.xml");
            DataSet dsConfig = new DataSet();
            try
            {
                dsConfig.ReadXml(path);
            }
            catch (Exception ex)
            {
                LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " - XML file not found" + Constants.CARRIAGERETURNEWLINE);
                //LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + " readConfigXML::Error in script:" + ex.Message + Constants.CARRIAGERETURNEWLINE + "StackTrace : " + ex.StackTrace + "\r\nInnerException:" + ex.InnerException, LogFileType.ExceptionLog);
                throw new TerminateInstallationException(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " readConfigXML::Error in script:" + ex.Message + Constants.CARRIAGERETURNEWLINE + "StackTrace : " + ex.StackTrace + Constants.CARRIAGERETURNEWLINE + "InnerException:" + ex.InnerException, ex);

            }
            return dsConfig;
        }
        private DataSet ReadPreReqConfigXML()
        {
            //string path = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), @"InstallSettings.xml");
            Assembly asm = Assembly.GetExecutingAssembly();
            string asmPath = System.IO.Path.GetDirectoryName(asm.Location);
            string[] s = { "\\bin" };
            string path = Path.Combine(asmPath.Split(s, StringSplitOptions.None)[0], @"PrerequisitesConfig.xml");
            DataSet dsPreReqConfig = new DataSet();
            try
            {
                dsPreReqConfig.ReadXml(path);
            }
            catch (Exception ex)
            {
                LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + DateTime.Now.ToString("HH:mm:ss") + " - XML file not fonud " + Constants.CARRIAGERETURNEWLINE);
                LogFile.Instance.LogMessage(Constants.CARRIAGERETURNEWLINE + " ReadPreReqConfigXML::Error in script:" + ex.Message + Constants.CARRIAGERETURNEWLINE + "StackTrace : " + ex.StackTrace + Constants.CARRIAGERETURNEWLINE + " InnerException:" + ex.InnerException, LogFileType.ExceptionLog);
            }
            return dsPreReqConfig;
        }
        #endregion

        #region Status Grid
         public class BattleShipRow
        {
            public Image Status { get; set; }

            public string Process { get; set; }

        }

        private List<BattleShipRow> battleShipGrid;

        private void LoadGridData()
        {
            string ErrorPath = string.Empty;
            string path = System.AppDomain.CurrentDomain.BaseDirectory + "/Images/Error.png";
            Image img = System.Drawing.Image.FromFile(path);
           

            string MethodNames = string.Empty;
            if (ConfigurationManager.AppSettings["MethodNames"] != null)
            {
                MethodNames = ConfigurationManager.AppSettings["MethodNames"].ToString();
            }

            battleShipGrid = new List<BattleShipRow>();

           foreach (var item in MethodNames.Split('|'))
            {
                StatusGrid.AutoGenerateColumns = false;
                StatusGrid.Columns[0].Name = "Status";
                StatusGrid.Columns[0].HeaderText = "";
                StatusGrid.Columns[0].DataPropertyName = "Status";

                StatusGrid.Columns[1].HeaderText = "Process";
                StatusGrid.Columns[1].Name = "Process";
                StatusGrid.Columns[1].DataPropertyName = "Process";
                BattleShipRow btleshipRow = new BattleShipRow();
                btleshipRow.Process = item;
                btleshipRow.Status = img;
                battleShipGrid.Add(btleshipRow);
            }


            StatusGrid.DataSource = battleShipGrid.ToList();
        }
        #endregion

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.btnResume.Enabled = true;
            this.btnInstall.Text = "Start Over";
            this.btnInstall.Enabled = true;
            this.btnCancel.Enabled = false;
        }

        private void btnResume_Click(object sender, EventArgs e)
        {
            this.Installation();
            this.btnResume.Enabled = false;
        }
    }
}
