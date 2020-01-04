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

public partial class ASPX_AccountingTasks_Controls_PayableQueueControl : System.Web.UI.UserControl
{
    private string elt_account_number;
    private string user_id, login_name, user_right;
    private string ConnectStr;
    private ArrayList CostItemKindList;
    private DataTable dtBillDetail;
    private ArrayList billDetailList;
    private BillDetailManager bdMgr;
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

        bdMgr = new BillDetailManager(elt_account_number);
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
        Session["dtBillDetail"] = null;
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
        int index = this.GridViewBillDetailItem.PageIndex * 10;

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
        hddlIDs.Value = "";

        for (int i = 0; i < this.GridViewBillDetailItem.Rows.Count; i++)
        {
            ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems")).DataSource = this.CostItemKindList;
            ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems")).DataBind();
            DropDownList ddl = ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems"));
            this.hddlIDs.Value += ddl.ClientID + "^^";
            ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtAmount")).Text = Decimal.Parse(dtBillDetail.Rows[index]["item_amt"].ToString()).ToString("N2");
            ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtRefNo")).Text = dtBillDetail.Rows[index]["ref_no"].ToString();
            ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtDate")).Text = dtBillDetail.Rows[index]["tran_date"].ToString();
            if (((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtDate")).Text == "")
            {
                ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtDate")).Text = DateTime.Today.ToShortDateString();
            }
            else
            {
                ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtDate")).Text = DateTime.Parse(dtBillDetail.Rows[index]["tran_date"].ToString()).ToShortDateString();
            }
            if (dtBillDetail.Rows[index]["ref_link"].ToString() != "")
            {
                ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems")).Enabled = false;
                ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtDate")).ReadOnly = true;
                // ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtAmount")).ReadOnly = true;
            }
            // ddlCostItemsChange(checkbox,ddl,amt,hCheckClicked)
            Image checkBox = (Image)this.GridViewBillDetailItem.Rows[i].FindControl("btnCheck");
            HiddenField hCheckClicked = (HiddenField)this.GridViewBillDetailItem.Rows[i].FindControl("hCheckClicked");
            TextBox amountBox = ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtAmount"));
            checkBox.Attributes.Add("onclick", "changeCostAmount(this," + amountBox.ClientID + "," + hCheckClicked.ClientID + ")");

            if (dtBillDetail.Rows[index]["is_checked"].ToString() == "true")
            {
                checkBox.ImageUrl = "~/ASPX/AccountingTasks/images/mark_x.gif";
                ((HiddenField)this.GridViewBillDetailItem.Rows[i].FindControl("hCheckClicked")).Value = "Y";
            }
            else
            {
                ((HiddenField)this.GridViewBillDetailItem.Rows[i].FindControl("hCheckClicked")).Value = "N";
                checkBox.ImageUrl = "~/ASPX/AccountingTasks/images/mark_o.gif";
            }
            hCheckBoxIDs.Value += checkBox.ClientID + "^^";
            string amtClientId = ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtAmount")).ClientID;
            hAmtIDs.Value += amtClientId + "^^";
            ddl.Attributes.Add("onChange", "ddlCostItemsChange(" + checkBox.ClientID + ",this," + amtClientId + "," + hCheckClicked.ClientID + ")");
            amountBox.Attributes.Add("onfocus", "holdAmount(" + checkBox.ClientID + "," + amountBox.ClientID + "," + hCheckClicked.ClientID + ")");


            string invoice_no= dtBillDetail.Rows[index]["invoice_no"].ToString();
            if (invoice_no == "")
            {
                invoice_no = "0";
            }
            string item_id= dtBillDetail.Rows[index]["item_id"].ToString() ; 
            string item_no2= dtBillDetail.Rows[index]["item_no"].ToString() ;
            amountBox.Attributes.Add("onblur", "replaceAmount(" + checkBox.ClientID + "," + amountBox.ClientID + "," + hCheckClicked.ClientID + "," + invoice_no + "," + item_id + "," + item_no2 + ",this)");
            for (int j = 0; j < ddl.Items.Count; j++)
            {
                string val = ddl.Items[j].Value;
                string item_no = val.Substring(0, val.IndexOf(":"));
                if (dtBillDetail.Rows[index]["item_no"].ToString() == item_no)
                {
                    ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems")).SelectedIndex = j;
                    if (dtBillDetail.Rows[index]["ref_link"].ToString() != "")
                    {
                        ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems")).Enabled = false;
                    }
                }
            }
            index++;
        }
        TextBox TotalAmount = (TextBox)this.parentObject["txtAmount"];
        if (dtBillDetail != null)
        {
            for (int i = 0; i < dtBillDetail.Rows.Count; i++)
            {
                if (dtBillDetail.Rows[i]["is_checked"].ToString() == "true")
                {
                    total_amount += Decimal.Parse(dtBillDetail.Rows[i]["item_amt"].ToString());
                }
            }
        }
        TotalAmount.Text = total_amount.ToString();
        hTotalAmount.Value = total_amount.ToString();
        setCostItemsToClient();
        Session["dtBillDetail"] = dtBillDetail;
    }


    protected void initaializeGridViewBillDetailItem()
    {
        for (int i = 0; i < this.GridViewBillDetailItem.Rows.Count; i++)
        {
            ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtDate")).Text = DateTime.Today.ToShortDateString();
        }
    }
    public ArrayList getBillDetailItemList()
    {
        billDetailList = new ArrayList();
        try
        {
            getValuesFromGrid();
            dtBillDetail = (DataTable)Session["dtBillDetail"];
            // dtBillDetail = (DataTable)Session["dtBillDetail"];
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
                if (dtBillDetail.Rows[i]["is_checked"].ToString() == "true")
                {
                    bdItm.Is_checked = true;
                }
                else
                {
                    bdItm.Is_checked = false;
                }
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
        init();
        dtBillDetail = (DataTable)Session["dtBillDetail"];
        if (dtBillDetail == null)
        {
            this.bindEmpty();
        }
        total_amount = 0;
        int invoice_no = 0;
        try
        {
            invoice_no = Int32.Parse(dtBillDetail.Rows[0]["invoice_no"].ToString());
        }
        catch (Exception ex)
        {
            // throw ex;

        }

        int index = this.GridViewBillDetailItem.PageIndex * 10;

        for (int i = 0; i < this.GridViewBillDetailItem.Rows.Count; i++)
        {
            if (Decimal.Parse(((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtAmount")).Text) != 0)
            {
                try
                {
                    string check = ((HiddenField)this.GridViewBillDetailItem.Rows[i].FindControl("hCheckClicked")).Value;
                    if (check == "Y")
                    {
                        dtBillDetail.Rows[index]["is_checked"] = "true";
                        total_amount += Decimal.Parse(Request[((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtAmount")).UniqueID]);

                    }
                    else
                    {
                        dtBillDetail.Rows[index]["is_checked"] = "false";
                    }

                    string val = ((DropDownList)this.GridViewBillDetailItem.Rows[i].FindControl("ddlCostItems")).SelectedValue;
                    string item_no = val.Substring(0, val.IndexOf(":"));
                    int acctExpense = Int32.Parse(val.Substring(val.IndexOf(":") + 1));

                    //ITEM ID WILL BE SET UP WHEN ENTERED INTO DB 
                    dtBillDetail.Rows[index]["item_no"] = Int32.Parse(item_no);
                    dtBillDetail.Rows[index]["item_expense_acct"] = acctExpense;
                    dtBillDetail.Rows[index]["tran_date"] = Request[((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtDate")).UniqueID];
                    dtBillDetail.Rows[index]["item_amt"] = Decimal.Parse(Request[((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtAmount")).UniqueID]);
                    dtBillDetail.Rows[index]["ref_no"] = ((TextBox)this.GridViewBillDetailItem.Rows[i].FindControl("txtRefNo")).Text;
                    index++;
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;
                    throw ex;
                }
            }
        }
        TextBox TotalAmount = (TextBox)this.parentObject["txtAmount"];
        TotalAmount.Text = total_amount.ToString();
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
        if (dtBillDetail == null)
        {
            dtBillDetail = this.createBillDetailItemsDataTable();
        }
        DataRow[] drs = createBillDetailItemsDataRow(1, dtBillDetail);

        dtBillDetail.Rows.Add(drs[0]);
        reBind_BillDetailChangesToGrid(dtBillDetail);

    }

    protected void btnDelete_Command(object sender, CommandEventArgs e)
    {
        dtBillDetail = (DataTable)Session["dtBillDetail"];
        int index=Int32.Parse(e.CommandArgument.ToString());

        int invoice_no = Int32.Parse(dtBillDetail.Rows[index]["invoice_no"].ToString());
        int item_id = Int32.Parse(dtBillDetail.Rows[index]["item_id"].ToString());

        bdMgr.deleteBillDetailItem(invoice_no, item_id);
        dtBillDetail.Rows.RemoveAt(Int32.Parse(e.CommandArgument.ToString()));
        reBind_BillDetailChangesToGrid(dtBillDetail);
    }


    protected void GridViewBillDetailItem_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        getValuesFromGrid();
        this.GridViewBillDetailItem.PageIndex = e.NewPageIndex;
        reBind_BillDetailChangesToGrid(dtBillDetail);
    }

    public void reSetPageIndex()
    {
        this.GridViewBillDetailItem.PageIndex = 0;
    }
}
