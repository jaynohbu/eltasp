using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class ASPX_AccountingTasks_gj_entry : System.Web.UI.Page
{
    protected string elt_account_number;
    protected string user_id, login_name, user_right;
    protected string ConnectStr;
    protected OrganizationManager orgMgr;
    protected GLManager glMgr;
    protected GeneralJournalManager gjeMgr;
    protected int entry_no;


    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            entry_no = Int32.Parse(Request[this.hEntryNo.UniqueID]);            
        }
        catch
        {
            entry_no = 0;
        }
        if (entry_no == 0)
        {
            try
            {
                entry_no = Int32.Parse(Request.QueryString["EntryNo"]);

            }
            catch
            {
                entry_no = 0;
            }
        }
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        orgMgr = new OrganizationManager(elt_account_number);
        glMgr = new GLManager(elt_account_number);
        gjeMgr = new GeneralJournalManager(elt_account_number);
        this.btnSaveUpper.Attributes.Add("onclick", "SaveClick()");
        this.btnSaveDown.Attributes.Add("onclick", "SaveClick()");
        this.btnSearch.Attributes.Add("onclick", "command('SEARCH')");
        this.btnDelete.Attributes.Add("onclick", "DeleteClick()");
        this.txtSearch.Attributes.Add("onfocus", "clearSearch(this)");
        this.btnDelete.Visible = false;        
      
        if (!IsPostBack)
        {
            this.dDate.Text = DateTime.Now.ToShortDateString();          
        }
        else
        {
            if (Session["entry_no"] != null)
            {
                this.hEntryNo.Value = Session["entry_no"].ToString();
                this.btnDelete.Visible = true;
            }
            if (this.hCommand.Value == "DELETE")
            {
                entry_no = Int32.Parse(this.hEntryNo.Value);
                Session["entry_no"] = null;
                this.gjeMgr.delete_Entries(entry_no);
            }
            if (this.hCommand.Value == "ADDNEW")
            {              

            }
            if (this.hCommand.Value == "SEARCH")
            {                
                try
                {
                  entry_no = Int32.Parse(this.txtSearch.Text);
                  this.txtSearch.Text = "";
                }
                catch 
                {
                    entry_no = 0;
                }
                if (entry_no > 0)
                {
                    ArrayList gjeList = gjeMgr.get_Entries(entry_no);
                    if (gjeList.Count != 0)
                    {
                        bindPageFromGJEList(gjeList);
                        Session["entry_no"] = entry_no.ToString();
                        this.hEntryNo.Value = entry_no.ToString();
                        this.btnDelete.Visible = true;
                    }
                    else
                    {
                        
                    }
                }
                else
                {
                    GJEItemControl1.bindEmpty(2);
                }
            }
            if (this.hCommand.Value == "SAVE" || this.hCommand.Value == "UPDATE")
            {
                DataTable dt = GJEItemControl1.getDataTable();
               
                ArrayList gjeList=new ArrayList();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    AllAccountsJournalRecord aaj = new AllAccountsJournalRecord();
                    aaj.elt_account_number = Int32.Parse(elt_account_number);
                    aaj.gl_account_number = Int32.Parse(dt.Rows[i]["gl_account_number"].ToString());
                    aaj.gl_account_name = glMgr.getGLDescription(aaj.gl_account_number);
                    aaj.tran_date = this.dDate.Text;

                    aaj.tran_type = "GJE";
                    aaj.memo = dt.Rows[i]["memo"].ToString();
                    aaj.debit_amount = Decimal.Parse(dt.Rows[i]["debit"].ToString());
                    aaj.credit_amount =-Decimal.Parse(dt.Rows[i]["credit"].ToString());
                    aaj.customer_number = Int32.Parse(dt.Rows[i]["org_acct"].ToString());
                    aaj.customer_name = orgMgr.getOrgName(aaj.customer_number);
                    
                    GeneralJournalRecord gje = new GeneralJournalRecord();
                    gje.credit = Decimal.Parse(dt.Rows[i]["credit"].ToString());
                    gje.debit = Decimal.Parse(dt.Rows[i]["debit"].ToString());
                    gje.dt = this.dDate.Text;
                    gje.elt_account_number = elt_account_number;
                    
                    gje.gl_account_number =Int32.Parse( dt.Rows[i]["gl_account_number"].ToString());
                    gje.item_no =Int32.Parse(dt.Rows[i]["item_no"].ToString());
                    gje.memo = dt.Rows[i]["memo"].ToString();
                    gje.org_acct = Int32.Parse(dt.Rows[i]["org_acct"].ToString());
                    gje.All_Accounts_Journal_Entry = aaj;    
                    gjeList.Add(gje);
                }
                int tran_no= gjeMgr.getNextEntryNumber();
                if (this.hCommand.Value == "SAVE")
                {
                    gjeMgr.insert_Entries(gjeList, tran_no);
                }
                else
                {
                    if (Session["gjeList"] != null)
                    {
                        ArrayList prevGjeList = (ArrayList)Session["gjeList"];
                        tran_no = ((GeneralJournalRecord)prevGjeList[0]).entry_no;                        
                    //    gjeMgr.update_Entries(gjeList, tran_no);
                        Session["gjeList"] = null;
                    }
                    else
                    {
                        Exception ex = new Exception("Session value lost");
                      
                        throw ex;
                    }
                    
                }
                this.GJEItemControl1.bindEmpty(2);
                this.dDate.Text= DateTime.Today.ToShortDateString();
                this.txtSearch.Text = "";
                this.hEntryNo.Value = "";
            }
            this.hCommand.Value = "";
            
        }
    }

    
    protected void bindPageFromGJEList(ArrayList gjeList)
    {
        this.GJEItemControl1.bindEmpty(gjeList.Count);
        DataTable dt = ((DataTable)Session["dtGJEEntries"]);
        
        for (int i = 0; i < gjeList.Count; i++)
        {
            GeneralJournalRecord gje=(GeneralJournalRecord )gjeList[i];
            dt.Rows[i]["credit"]= gje.credit;
            dt.Rows[i]["debit"]= gje.debit;
            this.dDate.Text= DateTime.Parse(gje.dt).ToShortDateString();        
            dt.Rows[i]["gl_account_number"]=gje.gl_account_number ;            
            dt.Rows[i]["item_no"]= gje.item_no;
            dt.Rows[i]["memo"]=gje.memo ;
            dt.Rows[i]["org_acct"]=gje.org_acct ;

            Session["gjeList"] = gjeList;           
        }
        this.GJEItemControl1.reBind_GJEChangesToGrid(dt);
        this.btnSaveDown.Visible = false;
        this.btnSaveUpper.Visible = false;
        this.hCommand.Value = "";
    }

  

}
