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
/// Summary description for glRecord
/// </summary>
public class GLRecord
{  
    private string elt_account_number;
    private int gl_account_number;
    public int Gl_account_number
    {
        get { return gl_account_number; }
        set { gl_account_number = value; }
    }
    private string gl_account_desc;
    public string Gl_account_desc
    {
        get { return gl_account_desc; }
        set { gl_account_desc = value; }
    }
    private string gl_master_type;
    public string Gl_master_type
    {
        get { return gl_master_type; }
        set { gl_master_type = value; }
    }
    private string gl_account_type;
    public string Gl_account_type
    {
        get { return gl_account_type; }
        set { gl_account_type = value; }
    }
    private Decimal gl_account_balance;
    public Decimal Gl_account_balance
    {
        get { return gl_account_balance; }
        set { gl_account_balance = value; }
    }
    private Decimal gl_begin_balance;
    public Decimal Gl_begin_balance
    {
        get { return gl_begin_balance; }
        set { gl_begin_balance = value; }
    }
    private string gl_account_status;
    public string Gl_account_status
    {
        get { return gl_account_status; }
        set { gl_account_status = value; }
    }
    private string gl_account_cdate;
    public string Gl_account_cdate
    {
        get { return gl_account_cdate; }
        set { gl_account_cdate = value; }
    }
    private string control_no;
    public string Control_no
    {
        get { return control_no; }
        set { control_no = value; }
    }
    private string gl_last_modified;
    public string Gl_last_modified
    {
        get { return gl_last_modified; }
        set { gl_last_modified = value; }
    }
    private string gl_default;
    public string Gl_default
    {
        get { return gl_default; }
        set { gl_default = value; }
    }
    public void replaceQuote()
    {
        GeneralUtility gUtil = new GeneralUtility();
        gl_account_desc = gUtil.replaceQuote(gl_account_desc);
    }
   
}
