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
using System.IO;
using System.Data.SqlClient;

public partial class ASPX_AccountingTasks_Controls_ARNChargeItemControl : System.Web.UI.UserControl
{
    private string elt_account_number;
    private string user_id, login_name, user_right;
    private string ConnectStr;
    
    private OperationSideChargeItemsManager OCItemsManager;   
    private ArrayList ChargeItemKindList;
    private DataSet dsOperationCharge;
    private Decimal total_other_charge;
    private Decimal total_charge;
    public Decimal Total_other_charge
    {
        get
        {
            reCalcTotal();
            return total_other_charge; 
        }

    }
    public Decimal Total_Amount
    {
        get
        {
            reCalcTotal();
            return total_charge;
        }

    }
    public bool Enabled
    {
        set
        {
            this.GridViewChargeItem.Enabled = value;            
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;

        init(); 
    }
    private void init()
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());
        OCItemsManager = new OperationSideChargeItemsManager(elt_account_number);
        ChargeItemKindManager chKindManager = new ChargeItemKindManager(elt_account_number);
        ChargeItemKindList = chKindManager.getChargeItemKindList();
        Session["ChargeItemKindList"] = ChargeItemKindList;
        setChItemsToClient();

    }
    private DataSet setEmptyChrageItems()
    {
        if (elt_account_number == null)
        {
            init();
        }
        dsOperationCharge = new DataSet();
        dsOperationCharge.Tables.Add(createChItemsDataTable());
        DataRow[] drs = createChItemsDataRow(4, dsOperationCharge);
        for (int i = 0; i < drs.Length; i++)
        {
            dsOperationCharge.Tables[0].Rows.Add(drs[i]);
        }
        this.GridViewChargeItem.DataSource = dsOperationCharge.Tables[0].DefaultView;
        this.GridViewChargeItem.DataBind();
        initaializeGridViewChargeItem();
        return dsOperationCharge;
    }
    public void bindEmpty()
    {       
        reBind_ChargeChangesToGrid(setEmptyChrageItems(),false);
    }
    public DataTable createChItemsDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add(new DataColumn("row_id", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("url", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("hb", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("mb", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("item_id", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("item_no", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("description", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("waybill_type", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("amount", System.Type.GetType("System.Decimal")));
        dt.Columns.Add(new DataColumn("import_export", System.Type.GetType("System.String"))); 
        return dt;
    }

    public void setChItemsToClient()
    {
        ChargeItemKindList = (ArrayList)Session["ChargeItemKindList"];
        for (int i = 0; i < ChargeItemKindList.Count; i++)
        {
            this.hChItemsItemNoArray.Value += ((ChargeItemKindRecord)ChargeItemKindList[i]).Item_no.ToString() + "__";
            this.hChItemsDefaultDscArray.Value += ((ChargeItemKindRecord)ChargeItemKindList[i]).Item_desc + "__";
            this.hChItemsDefaultAmtArray.Value += ((ChargeItemKindRecord)ChargeItemKindList[i]).Unit_price.ToString() + "__";
        }

    }

    public bool isFilled()
    {
        dsOperationCharge = (DataSet)Session["dsOperationCharge"];
        if (dsOperationCharge != null)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    public void reCalcTotal()
    {
     dsOperationCharge = (DataSet)Session["dsOperationCharge"];
     elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
     ELTUserProfileManager eltUMgr = new ELTUserProfileManager(elt_account_number);
     int defaultAF = 0;
     string desc = "";
     eltUMgr.getDefaultAirFreightCharge(ref defaultAF, ref desc);
        
        total_other_charge = 0;
        total_charge=0;

        for (int i = 0; i < this.GridViewChargeItem.Rows.Count; i++)
        {
            if (dsOperationCharge.Tables[0].Rows[i]["item_id"].ToString() != defaultAF.ToString())
            {
                total_other_charge += Decimal.Parse(((TextBox)this.GridViewChargeItem.Rows[i].FindControl("txtChAmount")).Text);
            }
            total_charge += Decimal.Parse(((TextBox)this.GridViewChargeItem.Rows[i].FindControl("txtChAmount")).Text);
        }       
    }

   

    public void reBind_ChargeChangesToGrid(DataSet ds, bool ARLock)
    {
       
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        ELTUserProfileManager eltUMgr = new ELTUserProfileManager(elt_account_number);

        ChargeItemKindManager chKindManager = new ChargeItemKindManager(elt_account_number);
        ChargeItemKindList = chKindManager.getChargeItemKindList();

        int defaultAF=0;
       
        string defaultAFDesc = "";
        eltUMgr.getDefaultAirFreightCharge(ref defaultAF, ref defaultAFDesc);
        
        this.hIsFCExist.Value = "N";
        total_other_charge = 0;
        if (elt_account_number == null)
        {
            init();
        }
        dsOperationCharge = ds;
        if (ds.Tables[0].Rows.Count == 0)
        {
            setEmptyChrageItems();
        }
       
        this.GridViewChargeItem.DataSource = dsOperationCharge.Tables[0].DefaultView;
        this.GridViewChargeItem.DataBind();
         hAmtIds.Value="";
        DataTable dt = dsOperationCharge.Tables[0];
        int last_index = 0;
        for (int i = 0; i < this.GridViewChargeItem.Rows.Count; i++)
        {
            last_index = i;
            
            ((DropDownList)this.GridViewChargeItem.Rows[i].FindControl("ddlChItems")).DataSource = this.ChargeItemKindList;
            ((DropDownList)this.GridViewChargeItem.Rows[i].FindControl("ddlChItems")).DataBind();
           
            
            string dscClientId = ((TextBox)this.GridViewChargeItem.Rows[i].FindControl("txtChDescription")).ClientID;
            string amtClientId = ((TextBox)this.GridViewChargeItem.Rows[i].FindControl("txtChAmount")).ClientID;

            if (defaultAF.ToString() == dt.Rows[i]["item_no"].ToString())
            {
                this.hIsFCExist.Value = "Y";
                this.hFCAmountFieldID.Value = amtClientId;
            }
            
            string ChAmtTotalId = ((TextBox)this.GridViewChargeItem.FooterRow.FindControl("txtChAmtTotal")).ClientID;

            string hAmtIDsClientID = this.hAmtIds.ClientID;
            ((TextBox)this.GridViewChargeItem.Rows[i].FindControl("txtChAmount")).Attributes.Add("onblur", "changeAmount(" + ChAmtTotalId + "," + hAmtIDsClientID + ")");
            
            this.hAmtIds.Value += amtClientId + "^^";            
            DropDownList ddl = ((DropDownList)this.GridViewChargeItem.Rows[i].FindControl("ddlChItems"));           
            ddl.Attributes.Add("onChange", "ddlChItemsChange(this," + dscClientId + "," + amtClientId + ")"+";"+"changeAmount(" + ChAmtTotalId + "," + hAmtIDsClientID + ")");
            ((TextBox)this.GridViewChargeItem.Rows[i].FindControl("txtChDescription")).Text = dt.Rows[i]["description"].ToString();
            Decimal chamt = Decimal.Parse(dt.Rows[i]["amount"].ToString());
            ((TextBox)this.GridViewChargeItem.Rows[i].FindControl("txtChAmount")).Text = chamt.ToString("N2");
           
            if (ARLock)
            {
                ((DropDownList)this.GridViewChargeItem.Rows[i].FindControl("ddlChItems")).Enabled = false;

                ((ImageButton)this.GridViewChargeItem.Rows[i].FindControl("btnDeleteCharge")).Visible = false;
                ((ImageButton)this.GridViewChargeItem.FooterRow.FindControl("btnAddCharge")).Visible = false;
                ((Label)this.GridViewChargeItem.FooterRow.FindControl("lblARLock")).Visible = true;
                ((TextBox)this.GridViewChargeItem.Rows[i].FindControl("txtChAmount")).ReadOnly = true;
               // this.GridViewChargeItem.Enabled = false;
             
            }
            else
            {
                this.GridViewChargeItem.Enabled = true;
                ((Label)this.GridViewChargeItem.FooterRow.FindControl("lblARLock")).Visible = false;
                ((ImageButton)this.GridViewChargeItem.Rows[i].FindControl("btnDeleteCharge")).Attributes.Add("onClick", "CommandChange('DeleteCharge')");
                ((ImageButton)this.GridViewChargeItem.FooterRow.FindControl("btnAddCharge")).Attributes.Add("onClick", "CommandChange('AddCharge')");
            }

            total_other_charge+= Decimal.Parse(dt.Rows[i]["amount"].ToString());

            for (int j = 0; j < ddl.Items.Count; j++)
            {
                string val = ddl.Items[j].Value;
                string item_no = val.Substring(0, val.IndexOf(":"));
                if (dt.Rows[i]["item_no"].ToString() == item_no)
                {
                    ((DropDownList)this.GridViewChargeItem.Rows[i].FindControl("ddlChItems")).SelectedIndex = j;
                }
            }
        }
        Session["ARNCotrol_Last_ID"] = ((TextBox)this.GridViewChargeItem.Rows[last_index].FindControl("txtChAmount")).ClientID;

        ((TextBox)this.GridViewChargeItem.FooterRow.FindControl("txtChAmtTotal")).Text = total_other_charge.ToString("N2");

        Session["dsOperationCharge"] = dsOperationCharge;
    }

    public void initaializeGridViewChargeItem()
    {
        for (int i = 0; i < this.GridViewChargeItem.Rows.Count; i++)
        {
            string dscClientId = ((TextBox)this.GridViewChargeItem.Rows[i].FindControl("txtChDescription")).ClientID;
            string amtClientId = ((TextBox)this.GridViewChargeItem.Rows[i].FindControl("txtChAmount")).ClientID;
            DropDownList ddl = ((DropDownList)this.GridViewChargeItem.Rows[i].FindControl("ddlChItems"));
            ddl.Attributes.Add("onChange", "ddlChItemsChange(this," + dscClientId + "," + amtClientId + ")");
            ((ImageButton)this.GridViewChargeItem.Rows[i].FindControl("btnDeleteCharge")).Attributes.Add("onClick", "CommandChange('DeleteCharge')");
            ((ImageButton)this.GridViewChargeItem.FooterRow.FindControl("btnAddCharge")).Attributes.Add("onClick", "CommandChange('AddCharge')");

        }
    }

    
    public ArrayList getChargeItemList()
    {
        getValuesFromGrid();
        dsOperationCharge = (DataSet)Session["dsOperationCharge"];
        ArrayList chList=new ArrayList();
        try
        {
            for (int i = 0; i < dsOperationCharge.Tables[0].Rows.Count; i++)
            {
                Decimal money = 0;
                try
                {
                    money = Decimal.Parse(dsOperationCharge.Tables[0].Rows[i]["amount"].ToString());
                }
                catch
                {
                    money = 0;
                }
                if (money != 0)
                {
                    ChargeItemRecord chItm = new ChargeItemRecord();
                    chItm.ItemId = Int32.Parse(dsOperationCharge.Tables[0].Rows[i]["item_id"].ToString());
                    chItm.ItemNo = Int32.Parse(dsOperationCharge.Tables[0].Rows[i]["item_no"].ToString());
                    chItm.Hb = dsOperationCharge.Tables[0].Rows[i]["hb"].ToString();
                    chItm.Description = dsOperationCharge.Tables[0].Rows[i]["description"].ToString();
                    chItm.Url = dsOperationCharge.Tables[0].Rows[i]["url"].ToString();
                    chItm.Mb = dsOperationCharge.Tables[0].Rows[i]["mb"].ToString();
                    chItm.Waybill_type = dsOperationCharge.Tables[0].Rows[i]["waybill_type"].ToString();
                    chItm.Amount = Decimal.Parse(dsOperationCharge.Tables[0].Rows[i]["amount"].ToString());
                    chItm.Import_export = dsOperationCharge.Tables[0].Rows[i]["import_export"].ToString();
                    chList.Add(chItm);
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;

        }
      return chList;
    }

    private void getValuesFromGrid()
    {
        dsOperationCharge =(DataSet)Session["dsOperationCharge"];
        if (dsOperationCharge==null)
        {
            dsOperationCharge = new DataSet();
            dsOperationCharge.Tables.Add(createChItemsDataTable());
        }

        //dsOperationCharge.Tables[0].Clear();
        int ITEM_ID = 1;
        int ITEM_INDEX = 0;
        for (int i = 0; i < this.GridViewChargeItem.Rows.Count; i++)
        {
            if (Decimal.Parse(((TextBox)this.GridViewChargeItem.Rows[i].FindControl("txtChAmount")).Text) != 0)
            {
                total_other_charge = 0;
                try
                {
                    if (dsOperationCharge.Tables[0].Rows.Count < i)
                    {
                        dsOperationCharge.Tables[0].Rows.Add(dsOperationCharge.Tables[0].NewRow());
                    }
                    string val = ((DropDownList)this.GridViewChargeItem.Rows[i].FindControl("ddlChItems")).SelectedValue;
                    string item_no = val.Substring(0, val.IndexOf(":"));
                    dsOperationCharge.Tables[0].Rows[ITEM_INDEX]["item_id"] = ITEM_ID++;
                    dsOperationCharge.Tables[0].Rows[ITEM_INDEX]["item_no"] = Int32.Parse(item_no);
                    dsOperationCharge.Tables[0].Rows[ITEM_INDEX]["description"] = ((TextBox)this.GridViewChargeItem.Rows[i].FindControl("txtChDescription")).Text;
       
                    dsOperationCharge.Tables[0].Rows[ITEM_INDEX]["amount"] = Request[((TextBox)this.GridViewChargeItem.Rows[i].FindControl("txtChAmount")).UniqueID];
                    total_other_charge += Decimal.Parse(dsOperationCharge.Tables[0].Rows[ITEM_INDEX]["amount"].ToString());
                    ITEM_INDEX++;
                }
                catch (Exception ex)
                {
                    string msg = ex.Message;
                }
            }
        }
        Session["dsOperationCharge"] = dsOperationCharge;
    }



    //if (!this.ARNChargeItemControl1.CheckIfDefaultFCExist())
    //{
    //    ARNChargeItemControl1.AddDefaultFC(amount);
    //}else{

    //ARNChargeItemControl1.UpdateDefaultFC(amount);
    ///}


    public void addDefaultFC()
    {
        init();
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        ELTUserProfileManager eltUMgr = new ELTUserProfileManager(elt_account_number);
        int defaultAF=0;
        string desc="";
        eltUMgr.getDefaultAirFreightCharge(ref defaultAF, ref desc);
        
        Decimal amount = 0;
        try
        {
           amount = Decimal.Parse(this.hFCAmount.Value);
        }
        catch
        {
            hFCAmount.Value = "0";
        }
        this.getValuesFromGrid();
        dsOperationCharge = (DataSet)Session["dsOperationCharge"];
        DataRow dr=dsOperationCharge.Tables[0].NewRow();
        dr= dsOperationCharge.Tables[0].NewRow();
        dr["row_id"] = new Guid().ToString();               
        dr["url"] = "#";
        dr["hb"] = "";
        dr["item_no"] = defaultAF;
        dr["item_id"] =1;
        dr["description"] = desc;
        dr["mb"] = "";
        dr["waybill_type"] = "";
        dr["amount"] = amount;
        dsOperationCharge.Tables[0].Rows.InsertAt(dr, 0);
        int ITEM_ID=1;
        for (int i = 0; i < dsOperationCharge.Tables[0].Rows.Count; i++)
        {
            dsOperationCharge.Tables[0].Rows[i]["item_id"] = ITEM_ID++;
        }
        Session["dsOperationCharge"]=dsOperationCharge;
        reBind_ChargeChangesToGrid(dsOperationCharge, false);
      
    }

    

    public bool bindFromIVChargeItemDataTable(DataTable dt, bool ARLock)
    {
        int Cnt = dt.Rows.Count;
        GeneralUtility gUtil = new GeneralUtility();
        gUtil.removeNull(ref dt);
        dsOperationCharge = new DataSet();
        dsOperationCharge.Tables.Add(createChItemsDataTable());  
        DataRow[] drs = new DataRow[Cnt];
        total_other_charge = 0;
        try
        {
            for (int i = 0; i < Cnt; i++)
            {
                drs[i] = dsOperationCharge.Tables[0].NewRow();
                drs[i]["row_id"] = new Guid().ToString();               
                drs[i]["url"] = "#";
                drs[i]["hb"] = dt.Rows[i]["hb_no"].ToString();
                drs[i]["item_no"] = Int32.Parse(dt.Rows[i]["item_no"].ToString());
                drs[i]["item_id"] = Int32.Parse(dt.Rows[i]["item_id"].ToString());
                drs[i]["description"] = dt.Rows[i]["item_desc"].ToString();
                drs[i]["mb"] = dt.Rows[i]["mb_no"].ToString();
                if (dt.Rows[i]["iType"].ToString() == "A")
                {
                    drs[i]["waybill_type"] = "HAWB";
                }
                else
                {
                    drs[i]["waybill_type"] = "HBOL";
                }
                drs[i]["amount"] = Decimal.Parse(dt.Rows[i]["charge_amount"].ToString());

                total_other_charge += Decimal.Parse(dt.Rows[i]["charge_amount"].ToString());
            }                   
            for (int i = 0; i < drs.Length; i++)
            {
                dsOperationCharge.Tables[0].Rows.Add(drs[i]);
            }
            reBind_ChargeChangesToGrid(dsOperationCharge, ARLock);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return true;
    }

    public DataRow[] createChItemsDataRow(int Cnt, DataSet ds)
    {
        DataRow[] drs = new DataRow[Cnt];
        DataSet dsOperationCharge = ds;
        for (int i = 0; i < Cnt; i++)
        {
            drs[i] = dsOperationCharge.Tables[0].NewRow();
            drs[i]["row_id"] = new Guid().ToString();          
            drs[i]["url"] = "#";
            drs[i]["hb"] = "";
            drs[i]["item_id"] = -1;
            drs[i]["item_no"] = -1;
            drs[i]["description"] = "";
            drs[i]["mb"] = "";
            drs[i]["waybill_type"] = "";
            drs[i]["amount"] = 0;
        }
        return drs;
    }


    
    protected void GridViewChargeItem_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {   
        dsOperationCharge = (DataSet)Session["dsOperationCharge"];
        dsOperationCharge.Tables[0].Rows.RemoveAt(e.RowIndex);
        reBind_ChargeChangesToGrid(dsOperationCharge,false);
     
    }
    protected void btnAddCharge_Click(object sender, ImageClickEventArgs e)
    {
        getValuesFromGrid();
        DataRow[] drs = createChItemsDataRow(1, dsOperationCharge);
        dsOperationCharge.Tables[0].Rows.Add(drs[0]);
        reBind_ChargeChangesToGrid(dsOperationCharge,false);
       
    }

    
}
