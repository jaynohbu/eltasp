using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Collections;
using System.Text;

/// <summary>
/// Summary description for Manager
/// </summary>
public class Manager
{
    protected string ConnectStr;
    protected SqlConnection Con;
    protected SqlCommand Cmd;
    protected string elt_account_number;
    protected string SQL;

    public Manager(string elt_acct)
	{
        elt_account_number = elt_acct;
        ConnectStr = (new igFunctions.DB().getConStr());
        Con = new SqlConnection(ConnectStr);
       
        SQL = "";
	}
}
