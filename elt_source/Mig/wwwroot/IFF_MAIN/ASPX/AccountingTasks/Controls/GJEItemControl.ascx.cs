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

public partial class ASPX_AccountingTasks_Controls_GJEItemControl : System.Web.UI.UserControl
{
    private string elt_account_number;
    private string user_id, login_name, user_right;
    private string ConnectStr;   

    private DataTable dtGJEEntries;
    private GLManager glMgr;
    private OrganizationManager orgManger;
    private ArrayList orgList;
    private ArrayList glAcctList;
   

    protected void Page_Load(object sender, EventArgs e)
    {     
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());
        AllAccountsJournalManager aajManager = new AllAccountsJournalManager(elt_account_number);
        orgManger = new OrganizationManager(elt_account_number);
        glMgr = new GLManager(elt_account_number);
        orgList = orgManger.getAllOrgization();
        glAcctList = glMgr.getAllGLAcctList();        
        if (!IsPostBack)
        {
            bindEmpty(2);
        }
           
    }

   
    protected DataTable setEmptyGJEItems(int count)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        orgManger = new OrganizationManager(elt_account_number);
        glMgr = new GLManager(elt_account_number);
        orgList = orgManger.getAllOrgization();
        glAcctList = glMgr.getAllGLAcctList();        
        dtGJEEntries = new DataTable();
        dtGJEEntries=createGJEItemsDataTable();
        DataRow[] drs = createGJEItemsDataRow(count, dtGJEEntries);

        for (int i = 0; i < drs.Length; i++)
        {
            dtGJEEntries.Rows.Add(drs[i]);
        }
        this.GridViewGJEItem.DataSource = dtGJEEntries.DefaultView;
        this.GridViewGJEItem.DataBind();
        initaializeGridViewGJEItem();
        return dtGJEEntries;
    }

    public void bindEmpty(int count)
    {
        reBind_GJEChangesToGrid(setEmptyGJEItems(count));
    }
    protected DataTable createGJEItemsDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add(new DataColumn("entry_no", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("item_no", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("gl_account_number", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("credit", System.Type.GetType("System.Decimal")));
        dt.Columns.Add(new DataColumn("debit", System.Type.GetType("System.Decimal")));
        dt.Columns.Add(new DataColumn("memo", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("org_acct", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("dt", System.Type.GetType("System.String")));     
        return dt;
    }
   
    public void reBind_GJEChangesToGrid(DataTable dt)
    {         
        DataTable dtGJEEntries = dt;
        dtGJEEntries = dt;
        if (dt.Rows.Count == 0)
        {
            setEmptyGJEItems(2);
        }
        this.GridViewGJEItem.DataSource = dtGJEEntries.DefaultView;
        this.GridViewGJEItem.DataBind();

        this.hDebits.Value = "";
        this.hCredits.Value = "";
        for (int i = 0; i < this.GridViewGJEItem.Rows.Count; i++)
        {
             DropDownList ddl = ((DropDownList)this.GridViewGJEItem.Rows[i].FindControl("ddlGLAccounts"));
             DropDownList ddl2 = ((DropDownList)this.GridViewGJEItem.Rows[i].FindControl("ddlName"));
         
             ddl.DataSource = this.glAcctList;
             ddl.DataBind();
             ddl2.DataSource = this.orgList;
             ddl2.DataBind();        

            try
            {
                for (int j = 0; j < ddl.Items.Count; j++)
                {
                    string Glacct = ddl.Items[j].Value;
                    if (dt.Rows[i]["gl_account_number"].ToString() == Glacct)
                    {
                        ddl.SelectedIndex = j;
                    }
                }

                for (int j = 0; j < ddl2.Items.Count; j++)
                {
                    int org_acct = Int32.Parse(ddl2.Items[j].Value);
                    if (Int32.Parse(dt.Rows[i]["org_acct"].ToString()) == org_acct)
                    {
                        ddl2.SelectedIndex = j;
                    }
                }
            }
            catch (Exception ex)
            {
                string msg = ex.Message;
            }
            TextBox txtDebit = ((TextBox)this.GridViewGJEItem.Rows[i].FindControl("txtDebit"));
            TextBox txtCredit= ((TextBox)this.GridViewGJEItem.Rows[i].FindControl("txtCredit"));


            this.hDebits.Value += txtDebit.ClientID + "^^";
            this.hCredits.Value += txtCredit.ClientID + "^^";

            //if((i+1)%2==0){
            //    TextBox txtDebitPrev = ((TextBox)this.GridViewGJEItem.Rows[i-1].FindControl("txtDebit"));
            //    TextBox txtCreditPrev = ((TextBox)this.GridViewGJEItem.Rows[i-1].FindControl("txtCredit"));

            //    txtDebit.Attributes.Add("onblur", "changeCounterPart(this," + txtCredit.ClientID + "," + txtCreditPrev.ClientID + "," + txtDebitPrev.ClientID + ")");
            //    txtCredit.Attributes.Add("onblur", "changeCounterPart(this," + txtDebit.ClientID + "," + txtDebitPrev.ClientID + "," + txtCreditPrev.ClientID + ")");

            //    txtDebitPrev.Attributes.Add("onblur", "changeCounterPart(this," + txtCreditPrev.ClientID + "," + txtCredit.ClientID + "," + txtDebit.ClientID + ")");
            //    txtCreditPrev.Attributes.Add("onblur", "changeCounterPart(this," + txtDebitPrev.ClientID + "," + txtDebit.ClientID + "," + txtCredit.ClientID + ")");
            //}           
            txtDebit.Text = Decimal.Parse(dt.Rows[i]["debit"].ToString()).ToString("N2");
            txtCredit.Text = Decimal.Parse(dt.Rows[i]["credit"].ToString()).ToString("N2");
           ((TextBox)this.GridViewGJEItem.Rows[i].FindControl("txtMemo")).Text = dt.Rows[i]["memo"].ToString();
           
        }

        //btnAddGJE
        ((ImageButton)GridViewGJEItem.FooterRow.FindControl("btnAddGJE")).Attributes.Add("onclick", "command('ADDNEW')");
        Session["dtGJEEntries"] = dtGJEEntries;
    }

    protected void initaializeGridViewGJEItem()
    {
      
        for (int i = 0; i < this.GridViewGJEItem.Rows.Count; i++)
        {
        }
       
    } 
    
    private void getValuesFromGrid()
    {
        dtGJEEntries = (DataTable)Session["dtGJEEntries"];
        if (dtGJEEntries==null)
        {
            dtGJEEntries = new DataTable();
            dtGJEEntries=createGJEItemsDataTable();
        }
             
        int ITEM_ID = 1;
        int ITEM_INDEX = 0;
        for (int i = 0; i < this.GridViewGJEItem.Rows.Count; i++)
        {
            if (Decimal.Parse(((TextBox)this.GridViewGJEItem.Rows[i].FindControl("txtDebit")).Text) !=0 ||Decimal.Parse(((TextBox)this.GridViewGJEItem.Rows[i].FindControl("txtCredit")).Text) != 0)
            {
                try
                {
                    if (this.dtGJEEntries.Rows.Count < i )
                    {
                        dtGJEEntries.Rows.Add(dtGJEEntries.NewRow());
                    }
                    string accountNo = ((DropDownList)this.GridViewGJEItem.Rows[i].FindControl("ddlGLAccounts")).SelectedValue;
                    string orgAcct = ((DropDownList)this.GridViewGJEItem.Rows[i].FindControl("ddlName")).SelectedValue;

                    dtGJEEntries.Rows[ITEM_INDEX]["item_no"] = ITEM_ID++;
                    dtGJEEntries.Rows[ITEM_INDEX]["gl_account_number"] = Int32.Parse(accountNo);
                    dtGJEEntries.Rows[ITEM_INDEX]["org_acct"] = Int32.Parse(orgAcct);
                    dtGJEEntries.Rows[ITEM_INDEX]["debit"] = Decimal.Parse(((TextBox)this.GridViewGJEItem.Rows[i].FindControl("txtDebit")).Text);
                    dtGJEEntries.Rows[ITEM_INDEX]["credit"] = Decimal.Parse(((TextBox)this.GridViewGJEItem.Rows[i].FindControl("txtCredit")).Text);
                    dtGJEEntries.Rows[ITEM_INDEX]["memo"] = ((TextBox)this.GridViewGJEItem.Rows[i].FindControl("txtMemo")).Text;
                    ITEM_INDEX++;
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;
                    throw ex;
                }
            }
        }
        Session["dtGJEEntries"] = dtGJEEntries;
    }
    
    protected void btnAddGJEItem_Click(object sender, ImageClickEventArgs e)
    {
        
        getValuesFromGrid();
        dtGJEEntries = (DataTable)Session["dtGJEEntries"];
        DataRow[] drs = createGJEItemsDataRow(2, dtGJEEntries);
        dtGJEEntries.Rows.Add(drs[0]);
       // dtGJEEntries.Rows.Add(drs[1]);
        Session["dtGJEEntries"] = dtGJEEntries;
        reBind_GJEChangesToGrid(dtGJEEntries);       
    }

    public DataTable getDataTable()
    {
        getValuesFromGrid();
        DataTable dt = ((DataTable)Session["dtGJEEntries"]);
        return dt;
    }

    protected DataRow[] createGJEItemsDataRow(int Cnt, DataTable dt)
    {
        DataRow[] drs = new DataRow[Cnt];
        DataTable dtGJEEntries = dt;
        for (int i = 0; i < Cnt; i++)
        {
            drs[i] = dtGJEEntries.NewRow();
            drs[i]["entry_no"] = -1;
            drs[i]["item_no"] = -1;
            drs[i]["gl_account_number"] = 0;
            drs[i]["credit"] = 0;
            drs[i]["debit"] = 0;
            drs[i]["memo"] = "";
            drs[i]["org_acct"] = 0;           
        }
        return drs;
    }
}
