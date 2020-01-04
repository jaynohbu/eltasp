using System;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;

namespace FreightEasy.DataManager
{
    [Serializable]

    public class ConnectELT
    {
        protected string ConnectStr;
        protected SqlConnection Con;

        public ConnectELT()
        {
        }

        public SqlConnection OpenConnection()
        {
            try
            {
                ConnectStr = getConStr();
                Con = new SqlConnection(ConnectStr);
            }
            catch
            {
                Con = null;
            }
            return Con;
        }

        public bool CloseConnection()
        {
            try
            {
                Con.Close();
                Con = null;
            }
            catch
            {
                return false;
            }
            return true;
        }

        protected string getConStr()
        {          
            string conStr = ConfigurationManager.ConnectionStrings["EltDbConnection"].ConnectionString;
            return conStr;
        }

      
    }
}