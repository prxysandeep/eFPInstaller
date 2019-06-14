using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eFPInstallerUI.Helpers
{
    public enum LogFileType
    {
        ValidationLog,
        ExceptionLog,
        MainLog
    }
    public sealed class LogFile
    {

        private static string LogfilePath = string.Empty;
        private static string LogFileName = string.Empty;
        private static string Message = string.Empty;
        private static readonly LogFile instance = new LogFile();
        // Explicit static constructor to tell C# compiler  
        // not to mark type as beforefieldinit  
        static LogFile()
        {

        }
        private LogFile()
        {
            LogfilePath = string.Empty;
            InstallRun obj = new InstallRun();
            string SystemName = obj.RunScript("get-content env:computername").Trim().ToString();

            string Date = DateTime.Now.ToString("ddMMyyyy");
            string Time = DateTime.Now.ToString("HHmmss");
            LogFileName = SystemName + "_" + Date + "_" + Time + "Log.txt";
            if (ConfigurationManager.AppSettings["LogFilePath"] != null)
            {
                LogfilePath = ConfigurationManager.AppSettings["LogFilePath"].ToString();
            }

            if (!Directory.Exists(Path.GetPathRoot(LogfilePath)))
                ////{ }

                if (!Directory.Exists(LogfilePath))
                {
                    Directory.CreateDirectory(LogfilePath);
                }

            LogfilePath = LogfilePath + "\\" + DateTime.Now.ToString("yyyyMMdd");
            if (!Directory.Exists(LogfilePath))
            {
                Directory.CreateDirectory(LogfilePath);
            }
        }

        private void WriteLog(string strMessage, LogFileType logfiletype)
        {
            try
            {
                switch (logfiletype)
                {
                    case LogFileType.ExceptionLog:
                        File.AppendAllText(LogfilePath + "/" + LogFileName.Split('.')[0] + "_Exception.log", strMessage);
                        break;

                    case LogFileType.MainLog:
                        File.AppendAllText(LogfilePath + "/" + LogFileName.Split('.')[0] + "_Main.log", strMessage);
                        break;

                    case LogFileType.ValidationLog:
                        File.AppendAllText(LogfilePath + "/" + LogFileName.Split('.')[0] + "_Main.log", strMessage);
                        //File.AppendAllText(LogfilePath + "/" + LogFileName.Split('.')[0] + "_Validation.log", strMessage);
                        break;
                }

            }
            catch (Exception ex)
            {

            }
        }


        public static LogFile Instance
        {
            get
            {
                return instance;
            }
        }

        public void LogMessage(string Message, LogFileType logFileType = LogFileType.MainLog)
        {
            WriteLog(Message, logFileType);
        }

    }
}
