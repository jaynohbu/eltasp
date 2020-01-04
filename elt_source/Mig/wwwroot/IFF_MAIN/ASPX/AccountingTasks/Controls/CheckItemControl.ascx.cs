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

public partial class ASPX_AccountingTasks_Controls_CheckItemControl:System.Web.UI.UserControl
{
    private string elt_account_number;
    private string user_id, login_name, user_right;
    private string ConnectStr;  
    private ArrayList CostItemKindList;
    private DataTable dtBillDetail;
    private ArrayList billDetailList;
    private Decimal total_amount;
    private GeneralUtility gUtil = new GeneralUtility();

    public Decimal Total_Amount
    {
        get { return total_amount; }
    }

    private Hashtable parentObject;
    public void setParentControl(Object control)
    {
        if (parentObject == null)
        {
            parentObject = new Hashtable();
        }
        parentObject.Add(((WebControl)control).ID, control);
    }
   
    protected void Page_Load(object sender, EventArgs e)
    {
        init();
    }

    protected void setCostItemsToClient()
    {
        this.hCostItemsItemNoArray.Value = "";     
        this.hCostItemsDefaultAmtArray.Value = "";
        for (int i = 0; i < CostItemKindList.Count; i++)
        {
            this.hCostItemsItemNoArray.Value += ((CostItemKindRecord)CostItemKindList[i]).Item_no.ToString() + "__";
            this.hCostItemsDefaultAmtArray.Value += ((CostItemKindRecord)CostItemKindList[i]).Unit_price.ToString() + "__";
        }
    }

    private void init()
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());      
        CostItemKindManager CostItemKindMger = new CostItemKindManager(elt_account_number);
        CostItemKindList = CostItemKindMger.getCostItemKindList();
        OrganizationManager orgManger = new OrganizationManager(elt_account_number);
        setCostItemsToClient();
      
    }


    protected DataTable setEmptyBillDetailItems()
    {
        if (elt_account_number == null)
        {
            init();
        }       
        dtBillDetail = createBillDetailItemsDataTable();
        DataRow[] drs = createBillDetailItemsDataRow(4, dtBillDetail);
        for (int i = 0; i < drs.Length; i++)
        {
            dtBillDetail.Rows.Add(drs[i]);
        }
        this.GridViewBillDetailItem.DataSource = dtBillDetail.DefaultView;
        this.GridViewBillDetailItem.DataBind();
        initaializeGridViewBillDetailItem();
        setCostItemsToClient();
        return dtBillDetail;  
    }

    public void bindEmpty()
    {
        dtBillDetail = setEmptyBillDetailItems();        
        reBind_BillDetailChangesToGrid(dtBillDetail);
    }

    protected DataTable createBillDetailItemsDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add(new DataColumn("item_id", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("item_no", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("bill_number", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("item_ap", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("item_expense_acct", System.Type.GetType("System.Int32")));        
        dt.Columns.Add(new DataColumn("invoice_no", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("ref_link", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("vendor_number", System.Type.GetType("System.Int32")));      
        dt.Columns.Add(new DataColumn("agent_debit_no", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("tran_date", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("is_checked", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("ref_no", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("url", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("mb_no", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("vendor_name", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("iType", System.Type.GetType("System.String")));        
        dt.Columns.Add(new DataColumn("item_amt", System.Type.GetType("System.Decimal")));
        return dt;
    }

    public void reBind_BillDetailChangesToGrid(DataTable dtBillDetail)
    {
        Session["dtBillDetail"] = dtBillDetail;
        total_amount = 0;
        if (elt_account_number == null)
        {
            init();
        }
        if (dtBillDetail == null)
        {
            setEmptyBillDetailItems();
        }
        if (dtBillDetail.Rows.Count == 0)
        {
            setEmptyBillDetailItems();
        }
        this.GridViewBillDetailItem.DataSource = dtBillDetail.DefaultView;
        this.GridViewBillDetailItem.DataBind();
        hCheckBoxIDs.Value = "";
        hAmtIDs.Value = "";
        for (int i = 0; i < this.GridViewBillDetailItem.Rows.Count; i++)
        {
            ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems")).DataSource = this.CostItemKindList;
            ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems")).DataBind();
            DropDownList ddl = ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems"));
            ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtAmount")).Text = Decimal.Parse(dtBillDetail.Rows[i]["item_amt"].ToString()).ToString("N2");
            ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtRefNo")).Text = dtBillDetail.Rows[i]["ref_no"].ToString();
            ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtDate")).Text = dtBillDetail.Rows[i]["tran_date"].ToString();
            if (((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtDate")).Text == "")
            {
                ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtDate")).Text = DateTime.Today.ToShortDateString();
            }
            else
            {
                ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtDate")).Text = DateTime.Parse(dtBillDetail.Rows[i]["tran_date"].ToString()).ToShortDateString();
            }

            if (dtBillDetail.Rows[i]["ref_link"].ToString() != "")
            {
                ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems")).Enabled = false;
                ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtDate")).Enabled = false;
                ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtAmount")).Enabled = false;
            }
                   
            total_amount += Decimal.Parse(dtBillDetail.Rows[i]["item_amt"].ToString());
            string amtClientId = ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtAmount")).ClientID;
            string itemClientID = ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems")).ClientID;
            hAmtIDs.Value += amtClientId + "^^";
            hCheckBoxIDs.Value += itemClientID + "^^";
            ddl.Attributes.Add("onChange", "ddlCostItemsChange(this," + amtClientId + ")" );

            ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtAmount")).Attributes.Add("onblur", "changeTotalAmount()");
            
            for (int j = 0; j < ddl.Items.Count; j++)
            {
                string val = ddl.Items[j].Value;
                string item_no = val.Substring(0, val.IndexOf(":"));
                if (dtBillDetail.Rows[i]["item_no"].ToString() == item_no)
                {
                     ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems")).SelectedIndex = j;
                    if (dtBillDetail.Rows[i]["ref_link"].ToString()!="")
                    {
                        ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems")).Enabled = false;
                    }
                }               
            }           
        }

        //CheckItemControl1.setParentControl(this.txtAcctBalance);
        //CheckItemControl1.setParentControl(this.txtMoneyEnglish);
        //CheckItemControl1.setParentControl(this.txtAmount);
        //CheckItemControl1.setParentControl(this.txt_print_check_as);
        //CheckItemControl1.setParentControl(this.txtAddress);
        //CheckItemControl1.setParentControl(this.txtCheckNo);
        //CheckItemControl1.setParentControl(this.dDate);
        //CheckItemControl1.setParentControl(this.ddlAPAcct);
        //CheckItemControl1.setParentControl(this.ddlBankAcct);
        setCostItemsToClient();
        Session["dtBillDetail"] = dtBillDetail;
    }


    protected void initaializeGridViewBillDetailItem()
    {
        for (int i = 0; i < this.GridViewBillDetailItem.Rows.Count; i++)
        {
          ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtDate")).Text=DateTime.Today.ToShortDateString();
        }
    } 

    public ArrayList getBillDetailItemList()
    {
        billDetailList = new ArrayList();
        try
        {
            getValuesFromGrid();
            dtBillDetail = (DataTable)Session["dtBillDetail"];
            gUtil.removeNull(ref dtBillDetail);
            for (int i = 0; i < dtBillDetail.Rows.Count; i++)
            {
                BillDetailRecord bdItm = new BillDetailRecord();
                bdItm.item_id = Int32.Parse(dtBillDetail.Rows[i]["item_id"].ToString());
                bdItm.item_no = Int32.Parse(dtBillDetail.Rows[i]["item_no"].ToString());
                bdItm.bill_number = Int32.Parse(dtBillDetail.Rows[i]["bill_number"].ToString());
                bdItm.invoice_no = Int32.Parse(dtBillDetail.Rows[i]["invoice_no"].ToString());
                bdItm.item_ap = Int32.Parse(dtBillDetail.Rows[i]["item_ap"].ToString());
                bdItm.item_expense_acct = Int32.Parse(dtBillDetail.Rows[i]["item_expense_acct"].ToString());
                bdItm.vendor_number = Int32.Parse(dtBillDetail.Rows[i]["vendor_number"].ToString());
                bdItm.item_amt = Decimal.Parse(dtBillDetail.Rows[i]["item_amt"].ToString());
                bdItm.agent_debit_no = dtBillDetail.Rows[i]["agent_debit_no"].ToString();
                bdItm.tran_date = dtBillDetail.Rows[i]["tran_date"].ToString();
                bdItm.ref_no = dtBillDetail.Rows[i]["ref_no"].ToString();
                bdItm.mb_no = dtBillDetail.Rows[i]["mb_no"].ToString();
                bdItm.iType = dtBillDetail.Rows[i]["iType"].ToString();
                billDetailList.Add(bdItm);
            }
        }
        catch (Exception ex)
        {
            string msg = ex.Message;
        }
        return billDetailList;
    }

    private void getValuesFromGrid()
    {
        dtBillDetail = (DataTable)Session["dtBillDetail"];       
        int ITEM_ID = 1;
        for (int i = 0; i < this.GridViewBillDetailItem.Rows.Count; i++)
        {
            if (Decimal.Parse(((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtAmount")).Text) != 0)
            {
                try
                {
                    string val = ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems")).SelectedValue;                   
                    string item_no = val.Substring(0, val.IndexOf(":"));
                    int acctExpense = Int32.Parse(val.Substring(val.IndexOf(":")+1));
                    dtBillDetail.Rows[i]["item_id"] = ITEM_ID++;                   
                    dtBillDetail.Rows[i]["item_no"] = Int32.Parse(item_no);
                    dtBillDetail.Rows[i]["item_expense_acct"] = acctExpense;                  
                    dtBillDetail.Rows[i]["tran_date"] = DateTime.Parse(((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtDate")).Text);
                    dtBillDetail.Rows[i]["item_amt"] = Decimal.Parse(((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtAmount")).Text);
                    dtBillDetail.Rows[i]["ref_no"] = ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtRefNo")).Text;     
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;
                    throw ex;
                }
            }
        }

      

        Session["dtBillDetail"] = dtBillDetail;
    }


  
    protected DataRow[] createBillDetailItemsDataRow(int Cnt, DataTable dt)
    {
        DataRow[] drs = new DataRow[Cnt];
        DataTable dtBillDetail = dt;
        for (int i = 0; i < Cnt; i++)
        {
            drs[i] = dtBillDetail.NewRow();
            drs[i]["item_id"] = -1;
            drs[i]["item_no"] = -1;
            drs[i]["bill_number"] = -1;
            drs[i]["item_ap"] = -1;    
            drs[i]["item_expense_acct"] = -1;
            drs[i]["vendor_number"] = -1;
            drs[i]["item_amt"] = 0;
            drs[i]["agent_debit_no"] = "";           
            drs[i]["ref_no"] = "";
            drs[i]["mb_no"] = "";
            drs[i]["ref_no"] = "";
            drs[i]["mb_no"] = "";
        }
        return drs;
    }
    
    
    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        getValuesFromGrid();
        dtBillDetail = (DataTable)Session["dtBillDetail"];
        if (dtBillDetail== null)
        {
            dtBillDetail=this.createBillDetailItemsDataTable();
        }
        DataRow[] drs = createBillDetailItemsDataRow(1, dtBillDetail);
        dtBillDetail.Rows.Add(drs[0]);
        reBind_BillDetailChangesToGrid(dtBillDetail);
    }

    protected void btnDelete_Command(object sender, CommandEventArgs e)
    {
        dtBillDetail = (DataTable)Session["dtBillDetail"];
        dtBillDetail.Rows.RemoveAt(Int32.Parse(e.CommandArgument.ToString()));    
        reBind_BillDetailChangesToGrid(dtBillDetail); 
    }

   
}
