using System;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;

namespace FreightEasy.DataManager
{
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
            string strServer = System.Web.HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToLower();
            string strPort = System.Web.HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToLower();
            string conStr = getLocalCon(strServer, strPort);
            return conStr;
        }

        protected string getLocalCon(string cServerName, string cServerPort)
        {
return "server=.;database=CORNERSTONE;user id=sa; password=njy*8824";
            switch (cServerName)
            {
                case "elt":
                    if (cServerPort == "80")
                    {
                        return "server=.;database=CORNERSTONE;user id=sa; password=";
                    }
                    else
                    {
                        return "server=.;database=DEVDB;user id=sa; password=";
                    }

                case "www.freighteasy.net":
                    if (cServerPort == "80")
                    {
                        return "server=.;database=PRDDB;user id=sa; password=dpV8XXVK";
                    }
                    else
                    {
                        return "server=.;database=TSTDB;user id=sa; password=dpV8XXVK";
                    }
                case "freighteasy.net":
                    if (cServerPort == "80")
                    {
                        return "server=.;database=PRDDB;user id=sa; password=dpV8XXVK";
                    }
                    else
                    {
                        return "server=.;database=TSTDB;user id=sa; password=dpV8XXVK";
                    }

                case "www.e-logitech.net":
                    if (cServerPort == "80")
                    {
                        return "server=.;database=PRDDB;user id=sa; password=dpV8XXVK";
                    }
                    else
                    {
                        return "server=.;database=TSTDB;user id=sa; password=dpV8XXVK";
                    }

                case "e-logitech.net":
                    if (cServerPort == "80")
                    {
                        return "server=.;database=PRDDB;user id=sa; password=dpV8XXVK";
                    }
                    else
                    {
                        return "server=.;database=TSTDB;user id=sa; password=dpV8XXVK";
                    }
                // KAS AMERICA
                case "210.245.110.69":
                    return "server=NN1994;database=PRDDB;user id=sa; password=dpV8XXVK";
                case "192.168.0.100":
                    return "server=NN1994;database=PRDDB;user id=sa; password=dpV8XXVK";
                case "192.168.1.114":
                    return "server=NN1994;database=PRDDB;user id=sa; password=dpV8XXVK";
                case "s-app01":
                    return "server=NN1994;database=PRDDB;user id=sa; password=dpV8XXVK";
                case "www.kasamerica.vn":
                    return "server=NN1994;database=PRDDB;user id=sa; password=dpV8XXVK";
                case "kasamerica.vn":
                    return "server=NN1994;database=PRDDB;user id=sa; password=dpV8XXVK";
                case "www.elogisticstechnology.com":
                    if (cServerPort == "80")
                    {
                        return "server=.;database=PRDDB;user id=sa; password=dpV8XXVK";
                    }
                    else
                    {
                        return "server=.;database=TSTDB;user id=sa; password=dpV8XXVK";
                    }

                case "elogisticstechnology.com":
                    if (cServerPort == "80")
                    {
                        return "server=.;database=PRDDB;user id=sa; password=dpV8XXVK";
                    }
                    else
                    {
                        return "server=.;database=TSTDB;user id=sa; password=dpV8XXVK";
                    }

                case "w-dev-jp01":
                    if (cServerPort == "8070" || cServerPort == "8080")
                    {
                        return "server=NN1994;database=TSTDB;user id=sa; password=dpV8XXVK";
                    }
                    else
                    {
                        return "server=.;database=DevDb;user id=sa; password=";
                    }

                default:
                    return "server=.;database=DEVDB; user id=sa; password=";
            }
        }
    }
}