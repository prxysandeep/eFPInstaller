using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;

namespace eFPInstallerUI.Helpers
{
    public static class clsRegistryKey
    {
       /// New-Item -Path HKCU:\Software -Name test –Force
       /// 
       public static void SetRegistry(string key,object value,string path)
        {
            IDictionary<string, object> objinParams = new Dictionary<string, object>();
            objinParams.Add("Path", path);
            objinParams.Add("Name", key);
            objinParams.Add("Value", value);            
            Common.PowerShellInvoker("New-Item", objinParams);
        }

        public static void SetRegistryProperty(string path,string paramkey,string value,string propertytype)
        {
            IDictionary<string, object> objinParams = new Dictionary<string, object>();
            objinParams.Add("Path", path);
            objinParams.Add("Name", paramkey);
            objinParams.Add("Value", value);
            objinParams.Add("PropertyType", "String");
            Common.PowerShellInvoker("New-ItemProperty", objinParams);              
        }

        public static string GetRegistryPropertyValue(string path,string propertyname)
        {
            try
            {
                IDictionary<string, object> objinParams = new Dictionary<string, object>();
                objinParams.Add("Path", path);
                objinParams.Add("Name", propertyname);
                var res = Common.PowerShellInvoker("Get-ItemPropertyValue", objinParams);
                if (res.Count > 0)
                {
                    return res[0].ToString();
                }

            }
            catch(Exception ex)
            {
                return string.Empty;
            }
            return string.Empty;
        }

        public static bool UpdateRegistryPropertyValue(string path,string propertyname,string propertyvalue)
        {
            try {
                IDictionary<string, object> objinParams = new Dictionary<string, object>();
                objinParams.Add("Path", path);
                objinParams.Add("Name", propertyname);
                objinParams.Add("Value", propertyvalue);
                Common.PowerShellInvoker("Set-ItemProperty", objinParams);
                return true;
            }
            catch(Exception ex){
                return false;
            }                        
        }
        public static bool DeleteRegistryEntry(string path, string propertyname)
        {

            try
            {
                IDictionary<string, object> objinParams = new Dictionary<string, object>();
                objinParams.Add("Path", path);
                objinParams.Add("Name", propertyname);
                Common.PowerShellInvoker("Remove-ItemProperty", objinParams);
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

       
    }
}
