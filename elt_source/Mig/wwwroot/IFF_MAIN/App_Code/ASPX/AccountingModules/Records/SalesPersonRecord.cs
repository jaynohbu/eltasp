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
/// Summary description for SalesPersonRecord
/// </summary>
public class SalesPersonRecord
{
    public string person;
    public string Person
    {
        get { return person; }
        set { person = value; }
    }
    public string description;

    public string Description
    {
        get { return description; }
        set { description = value; }
    }
	public SalesPersonRecord()
	{
		//
		// TODO: Add constructor logic here
		//
	}
}
