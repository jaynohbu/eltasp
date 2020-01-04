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
/// Summary description for OrganizationRecord
/// </summary>
public class OrganizationRecord
{
    private int org_account_number;

    public int Org_account_number
    {
        get { return org_account_number; }
        set { org_account_number = value; }
    }
    private string dba_name;
   
    public string Dba_name
    {
        get { return dba_name; }
        set { dba_name = value; }
    }
    private string class_code;
    public string Class_code
    {
        get { return class_code; }
        set { class_code = value; }
    }
	public OrganizationRecord()
	{
		
	}


    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        dba_name = gUtil.replaceQuote(dba_name);
    }
}
