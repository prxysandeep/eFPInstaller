using System;
namespace eFPInstallerUI.Helpers
{
    /// <summary>
    /// Cutome exception class to hold when isntaller failed.
    /// </summary>
    [Serializable]
    public class InstallerErrorException : Exception
    {
        /// <summary>
        /// 
        /// </summary>
        public InstallerErrorException()
        {

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="name"></param>
        public InstallerErrorException(string message, Exception innerException) : base(message, innerException)
        {

        }

    }
}