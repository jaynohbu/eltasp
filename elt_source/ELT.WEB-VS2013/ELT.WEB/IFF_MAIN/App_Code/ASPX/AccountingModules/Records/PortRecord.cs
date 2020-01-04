using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// Summary description for PortRecord
/// </summary>
public class PortRecord
{
    public string port_code;
    public string Port_code
    {
        get { return port_code; }
        set { port_code = value; }
    }
    public string port_desc;
    public string Port_desc
    {
        get { return port_desc; }
        set { port_desc = value; }
    }
    public string port_id;
    public string port_city; 
    public string port_state;
    public string port_country;
    public string port_country_code;
	public PortRecord()
	{
		
	}
}
