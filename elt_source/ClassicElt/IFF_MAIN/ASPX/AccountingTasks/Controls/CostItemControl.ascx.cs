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

public partial class ASPX_AccountingTasks_Controls_CostItemControl : System.Web.UI.UserControl
{
    private string elt_account_number;
    private string user_id, login_name, user_right;
    private string ConnectStr;   
    private OperationSideChargeItemsManager OCItemsManager;   
    private ArrayList CostItemKindList;
    private DataSet dsNonOprCost;
    private ArrayList vendorList;
    private Decimal total_amount;
    private bool vendorValid;
    private string vendorIDs;

    public bool Enabled
    {
        set
        {
            this.GridViewCostItem.Enabled = value;
        }
    } 
    public string VendorIDs
    {
        get { return vendorIDs; }
    }
    public bool IsVendorValid
    {
        get {
            for (int i = 0; i < this.GridViewCostItem.Rows.Count; i++)
            {
                DropDownList ddl2 = ((DropDownList)this.GridViewCostItem.Rows[i].FindControl("ddlVendor"));
                Decimal money=Decimal.Parse(((TextBox)this.GridViewCostItem.Rows[i].FindControl("txtCostAmount")).Text);
                for (int j = 0; j < ddl2.Items.Count; j++)
                {
                    if (money != 0 && ddl2.SelectedItem.Text == "Select" && invalidVendorListID == "")
                    {
                        this.vendorValid = false;
                        invalidVendorListID = ddl2.ClientID;
                    }
                }
            }
            return vendorValid; 
        }       
    }

    public void setFocusOnVendor(string id){

        for (int i = 0; i < this.GridViewCostItem.Rows.Count; i++)
        {
            DropDownList ddl2 = ((DropDownList)this.GridViewCostItem.Rows[i].FindControl("ddlVendor"));
            if (ddl2.ClientID == id)
            {
                ddl2.Focus();
            }
        }
    }
    private string invalidVendorListID;

    public string InvalidVendorListID
    {
        get { return invalidVendorListID; }
    }

    public Decimal Total_Amount
    {
       
        get {
            reCalcTotal(); 
            return total_amount;
        }

    }

    public void reCalcTotal()
    {

        total_amount = 0;
        for (int i = 0; i < this.GridViewCostItem.Rows.Count; i++)
        {
            total_amount += Decimal.Parse(((TextBox)this.GridViewCostItem.Rows[i].FindControl("txtCostAmount")).Text);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        invalidVendorListID = "";
        vendorValid = true;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());
        OCItemsManager = new OperationSideChargeItemsManager(elt_account_number);
        CostItemKindManager costKindManager = new CostItemKindManager(elt_account_number);
        CostItemKindList = costKindManager.getCostItemKindList();      
        OrganizationManager orgManger = new OrganizationManager(elt_account_number);
        vendorList = orgManger.getVendorList();     
        setCostItemsToClient();
        setVendorListToClient();        
    }

    private void init()
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());
        OCItemsManager = new OperationSideChargeItemsManager(elt_account_number);
        CostItemKindManager costKindManager = new CostItemKindManager(elt_account_number);
        CostItemKindList = costKindManager.getCostItemKindList();
        OrganizationManager orgManger = new OrganizationManager(elt_account_number);
        vendorList = orgManger.getVendorList();      
        setCostItemsToClient();
        setVendorListToClient();     
    }

    protected DataSet setEmptyCostItems()
    {
        if (elt_account_number == null)
        {
            init();
        }
        dsNonOprCost = new DataSet();
        dsNonOprCost.Tables.Add(createCostItemsDataTable());

        DataRow[] drs = createCostItemsDataRow(4, dsNonOprCost);
        for (int i = 0; i < drs.Length; i++)
        {
            dsNonOprCost.Tables[0].Rows.Add(drs[i]);
        }

        this.GridViewCostItem.DataSource = dsNonOprCost.Tables[0].DefaultView;
        this.GridViewCostItem.DataBind();

        initaializeGridViewCostItem();
        return dsNonOprCost;
    }

    public bool isFilled()
    {
        dsNonOprCost = (DataSet)Session["dsNonOprCost"];
        if (dsNonOprCost != null)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public void bindEmpty()
    {        
        reBind_CostChangesToGrid(setEmptyCostItems());
    }
    protected DataTable createCostItemsDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add(new DataColumn("row_id", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("bill_number", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("vendor_no", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("item_no", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("item_id", System.Type.GetType("System.Int32")));    
        dt.Columns.Add(new DataColumn("description", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("ref_no", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("mb", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("hb", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("waybill_type", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("amount", System.Type.GetType("System.Decimal")));
        dt.Columns.Add(new DataColumn("import_export", System.Type.GetType("System.String"))); 
        return dt;
    }

    protected void setCostItemsToClient()
    {
        for (int i = 0; i < CostItemKindList.Count; i++)
        {
            this.hCostItemsItemNoArray.Value += ((CostItemKindRecord)CostItemKindList[i]).Item_no.ToString() + "__";
            this.hCostItemsDefaultDscArray.Value += ((CostItemKindRecord)CostItemKindList[i]).Item_desc + "__";
            this.hCostItemsDefaultAmtArray.Value += ((CostItemKindRecord)CostItemKindList[i]).Unit_price.ToString() + "__";
        }
    }

    public void reBind_CostChangesToGrid(DataSet ds)
    {
        hVendorIDs.Value = "";
        total_amount = 0;
        if (elt_account_number == null)
        {
            init();
        }
        this.hAmtIDs.Value = "";
        this.hItemIDs.Value = ""; 
        DataSet dsNonOprCost = ds;
        dsNonOprCost = ds;
        if (ds.Tables[0].Rows.Count == 0)
        {
            setEmptyCostItems();
        }
        this.GridViewCostItem.DataSource = dsNonOprCost.Tables[0].DefaultView;
        this.GridViewCostItem.DataBind();
        DataTable dt = dsNonOprCost.Tables[0];
        string CostAmtTotalId ="";
        string hAmtIDsClientID = "";
        string hItemsClientID = "";

         for (int i = 0; i < this.GridViewCostItem.Rows.Count; i++)
         {
             ((ImageButton)this.GridViewCostItem.Rows[i].FindControl("btnDeleteCost")).Visible = true;
             DropDownList ddl = ((DropDownList)this.GridViewCostItem.Rows[i].FindControl("ddlCostItems"));
             DropDownList ddl2 = ((DropDownList)this.GridViewCostItem.Rows[i].FindControl("ddlVendor"));
             TextBox txtCostDescription = ((TextBox)this.GridViewCostItem.Rows[i].FindControl("txtCostDescription"));
             TextBox txtCostAmount = ((TextBox)this.GridViewCostItem.Rows[i].FindControl("txtCostAmount"));

             ddl.DataSource = this.CostItemKindList;
             ddl.DataBind();

             ddl2.DataSource = this.vendorList;
             ddl2.DataBind();

             string dscClientId = txtCostDescription.ClientID;
             string amtClientId = txtCostAmount.ClientID;
  

             CostAmtTotalId = ((TextBox)this.GridViewCostItem.FooterRow.FindControl("txtTotalCostAmt")).ClientID;

             hAmtIDsClientID = this.hAmtIDs.ClientID;
             hItemsClientID = this.hItemIDs.ClientID;
             txtCostAmount.Attributes.Add("onblur", "changeCostAmount(" + CostAmtTotalId + "," + hAmtIDsClientID + "," + hItemsClientID + ")");
             ((ImageButton)this.GridViewCostItem.Rows[i].FindControl("btnDeleteCost")).Attributes.Add("onblur", "changeCostAmount(" + CostAmtTotalId + "," + hAmtIDsClientID + "," + hItemsClientID + ")");

             this.hAmtIDs.Value += amtClientId + "^^";
             this.hItemIDs.Value += ddl.ClientID + "^^";
             ddl.Attributes.Add("onChange", "ddlCostItemsChange(this," + dscClientId + "," + amtClientId + ")" + ";" + "changeCostAmount(" + CostAmtTotalId + "," + hAmtIDsClientID + "," + hItemsClientID + ")");
             
             hVendorIDs.Value += ddl2.ClientID + "^^";
             txtCostDescription.Text = dt.Rows[i]["description"].ToString();
             txtCostAmount.Text = Decimal.Parse(dt.Rows[i]["amount"].ToString()).ToString();

             ((TextBox)this.GridViewCostItem.Rows[i].FindControl("txtRefNo")).Text = dt.Rows[i]["ref_no"].ToString();

            
             string bill_no = dt.Rows[i]["bill_number"].ToString();
             if (bill_no== "") bill_no = "0";
             HyperLink APLock = ((HyperLink)GridViewCostItem.Rows[i].FindControl("hlAPLock"));
           
             if (Int32.Parse(bill_no) != 0)
             {
                 APLock.NavigateUrl = "../enter_bill.aspx?view=yes&bill_number=" + dt.Rows[i]["bill_number"].ToString();
                 APLock.Text = "A/P Posted";
                 ddl.Enabled = false;
                 ddl2.Enabled = false;
                 txtCostAmount.ReadOnly = true;
                 ((ImageButton)this.GridViewCostItem.Rows[i].FindControl("btnDeleteCost")).Visible = false;

             }
             else
             {
                 APLock.Text = "";

             }


             total_amount += Decimal.Parse(dt.Rows[i]["amount"].ToString());

             for (int j = 0; j < ddl.Items.Count; j++)
             {
                 string val = ddl.Items[j].Value;
                 string item_no = val.Substring(0, val.IndexOf(":"));
                 if (dt.Rows[i]["item_no"].ToString() == item_no)
                 {
                     ddl.SelectedIndex = j;
                 }
             }
             try
             {
                 for (int j = 0; j < ddl2.Items.Count; j++)
                 {
                     int vendor_no = Int32.Parse(ddl2.Items[j].Value);
                     if (Int32.Parse(dt.Rows[i]["vendor_no"].ToString()) == vendor_no)
                     {
                         ddl2.SelectedIndex = j;
                     }
                 }
             }
             catch (Exception ex)
             {
                 string msg = ex.Message;
             }
         }
       
        ((TextBox)this.GridViewCostItem.FooterRow.FindControl("txtTotalCostAmt")).Text = total_amount.ToString();
     
        Session["dsNonOprCost"] = dsNonOprCost;
    }
    protected void initaializeGridViewCostItem()
    {
        this.vendorIDs = "";
        for (int i = 0; i < this.GridViewCostItem.Rows.Count; i++)
        {
            this.vendorIDs += ((DropDownList)this.GridViewCostItem.Rows[i].FindControl("ddlVendor")).ClientID+"^^";
            string dscClientId = ((TextBox)this.GridViewCostItem.Rows[i].FindControl("txtCostDescription")).ClientID;
            string amtClientId = ((TextBox)this.GridViewCostItem.Rows[i].FindControl("txtCostAmount")).ClientID;
            string VidClientId = ((DropDownList)this.GridViewCostItem.Rows[i].FindControl("ddlVendor")).ClientID;
            DropDownList ddl = ((DropDownList)this.GridViewCostItem.Rows[i].FindControl("ddlCostItems"));
            ddl.Attributes.Add("onChange", "ddlCostItemsChange(this," + dscClientId + "," + amtClientId + "," + VidClientId + ")");
        }
       
    } 

    public ArrayList getCostItemList()
    {
        ArrayList cstList = new ArrayList();
        try
        {
            getValuesFromGrid();

            dsNonOprCost = (DataSet)Session["dsNonOprCost"];

            DropDownList ddl = ((DropDownList)this.GridViewCostItem.Rows[0].FindControl("ddlVendor"));

            for (int i = 0; i < dsNonOprCost.Tables[0].Rows.Count; i++)
            {
                Decimal money = 0;
                try
                {
                    money = Decimal.Parse(dsNonOprCost.Tables[0].Rows[i]["amount"].ToString());
                }
                catch
                {
                    money = 0;
                }
                if (money >= 0)
                {
                    CostItemRecord cstItm = new CostItemRecord();
                    HyperLink APLock = ((HyperLink)GridViewCostItem.Rows[i].FindControl("hlAPLock"));
                    if (APLock.Text == "A/P Posted")
                    {
                        cstItm.ap_lock = true;
                    }
                    cstItm.ItemId = Int32.Parse(dsNonOprCost.Tables[0].Rows[i]["item_id"].ToString());
                    cstItm.ItemNo = Int32.Parse(dsNonOprCost.Tables[0].Rows[i]["item_no"].ToString());
                    cstItm.Vendor_no = Int32.Parse(dsNonOprCost.Tables[0].Rows[i]["vendor_no"].ToString());
                    for (int k = 0; k < ddl.Items.Count; k++)
                    {
                        if (Int32.Parse(ddl.Items[k].Value) == cstItm.Vendor_no)
                        {
                            cstItm.Vendor_name = ddl.Items[k].Text;
                        }
                    }
                    cstItm.Amount = Decimal.Parse(dsNonOprCost.Tables[0].Rows[i]["amount"].ToString());
                    cstItm.Ref_no = dsNonOprCost.Tables[0].Rows[i]["ref_no"].ToString();
                    cstItm.Description = dsNonOprCost.Tables[0].Rows[i]["description"].ToString();
                    cstItm.Import_export = dsNonOprCost.Tables[0].Rows[i]["import_export"].ToString();
                    cstList.Add(cstItm);
                }
            }
        }
        catch
        {
        }
       
       //catch (Exception ex)
        //{
        //   string msg = ex.Message;
        //    throw ex;
      // }
        return cstList;
    }

    private void getValuesFromGrid()
    {
        dsNonOprCost = (DataSet)Session["dsNonOprCost"];
        if (dsNonOprCost==null)
        {
            dsNonOprCost = new DataSet();
            dsNonOprCost.Tables.Add(createCostItemsDataTable());
        }
        //dsNonOprCost.Tables[0].Clear();
        
        int ITEM_ID = 1;
        int ITEM_INDEX = 0;
        string VS;
        for (int i = 0; i < this.GridViewCostItem.Rows.Count; i++)
        {
           /* if (Decimal.Parse(((TextBox)this.GridViewCostItem.Rows[i].FindControl("txtCostAmount")).Text) != 0)
            {*/
                try
                {
                    if (dsNonOprCost.Tables[0].Rows.Count < i || dsNonOprCost.Tables[0].Rows.Count==0)
                    {
                        dsNonOprCost.Tables[0].Rows.Add(dsNonOprCost.Tables[0].NewRow());
                    }
   
                    string val = ((DropDownList)this.GridViewCostItem.Rows[i].FindControl("ddlCostItems")).SelectedValue;
                    string va2 = ((DropDownList)this.GridViewCostItem.Rows[i].FindControl("ddlVendor")).SelectedValue;
                    if (Decimal.Parse(((TextBox)this.GridViewCostItem.Rows[i].FindControl("txtCostAmount")).Text) == 0)
                    {
                        VS = "0";
                    }
                    else
                    {
                        VS = va2;
                    }
                    string item_no = val.Substring(0, val.IndexOf(":"));
                    dsNonOprCost.Tables[0].Rows[ITEM_INDEX]["item_id"] = ITEM_ID++;
                    
                    dsNonOprCost.Tables[0].Rows[ITEM_INDEX]["vendor_no"] = Int32.Parse(VS);
                    dsNonOprCost.Tables[0].Rows[ITEM_INDEX]["item_no"] = Int32.Parse(item_no);
                    dsNonOprCost.Tables[0].Rows[ITEM_INDEX]["description"] = ((TextBox)this.GridViewCostItem.Rows[i].FindControl("txtCostDescription")).Text;
                    //dsNonOprCost.Tables[0].Rows[i]["amount"] = Decimal.Parse(((TextBox)this.GridViewCostItem.Rows[i].FindControl("txtCostAmount")).Text);
                    dsNonOprCost.Tables[0].Rows[ITEM_INDEX]["amount"] = Request[((TextBox)this.GridViewCostItem.Rows[i].FindControl("txtCostAmount")).UniqueID];

                    dsNonOprCost.Tables[0].Rows[ITEM_INDEX]["ref_no"] = ((TextBox)this.GridViewCostItem.Rows[i].FindControl("txtRefNo")).Text;
                    //vendor name 
                    ITEM_INDEX++;
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;
                    throw ex;
                }
          //  }
        }
        Session["dsNonOprCost"] = dsNonOprCost;
    }


    public bool bindFromIVCostItemDataTable(DataTable dt)
    {
        int Cnt = dt.Rows.Count;
        GeneralUtility gUtil = new GeneralUtility();
        gUtil.removeNull(ref dt);

        dsNonOprCost = new DataSet();
        dsNonOprCost.Tables.Add(createCostItemsDataTable());
        DataRow[] drs = new DataRow[Cnt];
        try
        {
            for (int i = 0; i < Cnt; i++)
            {
                drs[i] = dsNonOprCost.Tables[0].NewRow();
                drs[i]["row_id"] = new Guid().ToString();              
                drs[i]["hb"] = dt.Rows[i]["hb_no"].ToString();
                drs[i]["item_no"] = Int32.Parse(dt.Rows[i]["item_no"].ToString());
                drs[i]["item_id"] = Int32.Parse(dt.Rows[i]["item_id"].ToString());
                drs[i]["vendor_no"] = Int32.Parse(dt.Rows[i]["vendor_no"].ToString());
            
                drs[i]["description"] = dt.Rows[i]["item_desc"].ToString();
                drs[i]["ref_no"] = dt.Rows[i]["ref_no"].ToString();
                drs[i]["mb"] = dt.Rows[i]["mb_no"].ToString();
                drs[i]["waybill_type"] = dt.Rows[i]["iType"].ToString();
                drs[i]["amount"] = Decimal.Parse(dt.Rows[i]["cost_amount"].ToString());
                drs[i]["bill_number"] = Int32.Parse(dt.Rows[i]["bill_number"].ToString());
            }

            for (int i = 0; i < drs.Length; i++)
            {
                dsNonOprCost.Tables[0].Rows.Add(drs[i]);
            }
            reBind_CostChangesToGrid(dsNonOprCost);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return true;
    }

    protected void btnAddCostItem_Click(object sender, ImageClickEventArgs e)
    {
        getValuesFromGrid();
        dsNonOprCost = (DataSet)Session["dsNonOprCost"];
        DataRow[] drs = createCostItemsDataRow(1, dsNonOprCost);
        dsNonOprCost.Tables[0].Rows.Add(drs[0]);
        reBind_CostChangesToGrid(dsNonOprCost);
       
    }

    protected DataRow[] createCostItemsDataRow(int Cnt, DataSet ds)
    {
        DataRow[] drs = new DataRow[Cnt];
        DataSet dsNonOprCost = ds;
        for (int i = 0; i < Cnt; i++)
        {
            drs[i] = dsNonOprCost.Tables[0].NewRow();
            drs[i]["row_id"] = new Guid().ToString();
            drs[i]["vendor_no"] = -1;
            drs[i]["item_no"] = -1;
            drs[i]["item_id"] = -1;
            drs[i]["description"] = "";
            drs[i]["ref_no"] = "";
            drs[i]["hb"] = "";
            drs[i]["mb"] ="";
            drs[i]["waybill_type"] = "";
            drs[i]["amount"] = 0;
            drs[i]["bill_number"] = 0;
            //vendor name 
        }
        return drs;
    }

    protected void setVendorListToClient()
    {
        for (int i = 0; i < this.vendorList.Count; i++)
        {
            this.hVendorDBA.Value += ((OrganizationRecord)vendorList[i]).Dba_name + "__";
            this.hVendorAcct.Value += ((OrganizationRecord)vendorList[i]).Org_account_number.ToString() + "__";
            this.hVendorClass.Value += ((OrganizationRecord)vendorList[i]).Class_code + "__";
        }
    }

    protected void GridViewCostItem_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        dsNonOprCost = (DataSet)Session["dsNonOprCost"];
        dsNonOprCost.Tables[0].Rows.RemoveAt(e.RowIndex);
        reBind_CostChangesToGrid(dsNonOprCost);
    }
}
