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
/// Summary description for DocTrack
/// </summary>
public class DocTrack
{
    protected string elt_account_number;
    protected string ConnectStr;
  
	public DocTrack(string elt_account_number, string ConnectStr)
	{
        this.elt_account_number = elt_account_number;
        this.ConnectStr = ConnectStr;
	}

  
}
