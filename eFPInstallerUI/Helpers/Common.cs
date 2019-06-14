using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace eFPInstallerUI.Helpers
{
    static class Constants
    {
        public static string CARRIAGERETURNEWLINE = "\r\n";
        public static string NEWLINE = "\n";
        public static string TAB = "\t";
    }

    static class Common
    {
        public static IList<PSObject> PowerShellInvoker(string command, IDictionary<string, object> parameters)
        {
            PowerShell ps = PowerShell.Create();
            ps.AddCommand(command);
            if (parameters.Count > 0)
            {
                ps.AddParameters((IDictionary)parameters);
            }
            var res = ps.Invoke();
            return res;
        }

        public static List<PSObject> PowerShellScriptInvoker(string script)
        {
            PowerShell ps = PowerShell.Create();
            ps.Commands.AddScript(script, true);
            var res = ps.Invoke().ToList();
            return res;
        }

        public static List<PSObject> PowerShellScriptInvokerWithParam(string scriptName, IDictionary<string, object> parameters)
        {
            var scriptFile = Application.StartupPath.Replace(@"bin\Debug", "") + @"PowerShellScripts\" + scriptName + ".ps1";

            // Validate parameters
            if (string.IsNullOrEmpty(scriptFile)) { throw new ArgumentNullException("scriptFile"); }
            if (parameters == null) { throw new ArgumentNullException("parameters"); }

            RunspaceConfiguration runspaceConfiguration = RunspaceConfiguration.Create();
            using (Runspace runspace = RunspaceFactory.CreateRunspace(runspaceConfiguration))
            {
                runspace.Open();
                RunspaceInvoke scriptInvoker = new RunspaceInvoke(runspace);
                //scriptInvoker.Invoke("Set-ExecutionPolicy Unrestricted");
                Pipeline pipeline = runspace.CreatePipeline();
                Command scriptCommand = new Command(scriptFile);
                Collection<CommandParameter> commandParameters = new Collection<CommandParameter>();
                foreach (string scriptParameter in parameters.Keys)
                {
                    CommandParameter commandParm = new CommandParameter(scriptParameter, parameters[scriptParameter]);
                    commandParameters.Add(commandParm);
                    scriptCommand.Parameters.Add(commandParm);
                }
                pipeline.Commands.Add(scriptCommand);
                pipeline.Commands.Add("Out-String");
                List<PSObject> psObjects;

                psObjects = pipeline.Invoke().ToList();
                return psObjects;
            }
        }
    }

    public class TerminateInstallationException : Exception
    {

        public TerminateInstallationException(string message) : base(message)
        {
            LogFile.Instance.LogMessage(message, LogFileType.ExceptionLog);
            TerminateInstallation();
        }

        public TerminateInstallationException(string message, Exception innerException) : base(message, innerException)
        {
            LogFile.Instance.LogMessage(message + Constants.CARRIAGERETURNEWLINE + innerException.StackTrace + Constants.CARRIAGERETURNEWLINE, LogFileType.ExceptionLog);
            TerminateInstallation();
        }

        private void TerminateInstallation()
        {
            LogFile.Instance.LogMessage("Terminating Installation... Please check the Exception Log for more Info", LogFileType.ExceptionLog);
            Common.PowerShellScriptInvoker("[System.Diagnostics.Process]::GetCurrentProcess() | Stop-Process");
        }
    }





}