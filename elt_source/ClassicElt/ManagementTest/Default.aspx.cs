using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Management;

public partial class _Default : System.Web.UI.Page 
{
    protected string sDomain = "";
    protected string sUserName = "";
    protected string sPwd = "";
    protected string RemoteHost = "";
 
    protected void Page_Load(object sender, EventArgs e)
    {
        /*
        ManagementObjectSearcher query1;
        ManagementObjectCollection queryCollection1;
        ManagementScope RemoteConn;


        ObjectQuery oQuery = new ObjectQuery("Select MacAddress,IPAddress from Win32_NetworkAdapterConfiguration where IPEnabled=TRUE");
        ConnectionOptions options = new ConnectionOptions();
        options.Username = sDomain + "\\" + sUserName; //could be in domain\user format 
        options.Password = sPwd;

        try
        {
            RemoteConn = new ManagementScope("\\\\" + RemoteHost + "\\root\\cimv2", options);
            query1 = new ManagementObjectSearcher(RemoteConn, oQuery);
            queryCollection1 = query1.Get();

            foreach (ManagementObject mo in queryCollection1)
            {
                int nrIP = ((System.Array)(mo["IPAddress"])).Length;
                for (int c = 0; c < nrIP; c++)
                {
                    Response.Write(RemoteHost + " Mac Address: " + mo["MacAddress"].ToString() + "<br/>");
                    Response.Write(RemoteHost + " " + c + " IP Address: " + ((System.Array)(mo["IPAddress"])).GetValue(c) + "<br/>");

                }
            }
        }
        catch (Exception eex)
        {
            Response.Write("Failed to connect to: " + RemoteHost + "\n Error Message: " + eex.Message);
        }
        finally
        {
            Response.End();
        }
        */
        /*
        ManagementObjectSearcher query = null;
        ManagementObjectCollection queryCollection = null;

        try
        {
            query = new ManagementObjectSearcher("SELECT * FROM Win32_NetworkAdapterConfiguration");

            queryCollection = query.Get();

            foreach (ManagementObject mo in queryCollection)
            {
                if (mo["MacAddress"] != null)
                {
                    Response.Write(mo["MacAddress"].ToString() + "<br/>");
                }
            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.Source);
            Response.Write(ex.Message);
        } 
        */

        Response.Write(identifier("Win32_NetworkAdapterConfiguration","MACAddress", "IPEnabled"));
    }

    private string identifier(string wmiClass, string wmiProperty, string wmiMustBeTrue)
    //Return a hardware identifier
    {
        string result = "";
        System.Management.ManagementClass mc = new System.Management.ManagementClass(wmiClass);
        System.Management.ManagementObjectCollection moc = mc.GetInstances();
        foreach (System.Management.ManagementObject mo in moc)
        {
            if (mo[wmiMustBeTrue].ToString() == "True")
            {

                //Only get the first one
                if (result == "")
                {
                    try
                    {
                        result = mo[wmiProperty].ToString();
                        break;
                    }
                    catch
                    {
                    }
                }

            }
        }
        return result;
    }
}
