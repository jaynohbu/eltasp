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


public partial class ASPX_air_arrival_notice : System.Web.UI.Page
{
    #region variables
    public string vPrintPort;
    public string invoicePort;
    public string mawb_num;
    public string invoiceQueue;
    public string elt_account_number;
    public string vAO;
    public string user_id, login_name, user_right;
    protected string ConnectStr;
    protected string from_queue;
    protected OperationSideChargeItemsManager OCItemsManager;
    protected ArrayList OCostItemList;
    protected ArrayList CostItemKindList;
    protected DataSet dsNonOprCost;
    protected DataSet dsOperationCharge;
    public int invoice_no;
    private InvoiceRecord IVRecord;
    private InvoiceManager IVMnager;
    private AllAccountsJournalManager AAJMgr;
    private GeneralUtility gUtil;
    private int customer_org_acct;
    private ELTUserProfileManager eltUserMgr;
    private ArrayList listSelected;
    private GLManager glMgr;
    private string command;
    public bool ARLock;
    public bool APLock;
    private ARNRecord ARNRec;
    private ARNManager ARNMgr;
    private PortManager portMgr;
    protected DataSet ds = null;
    #endregion

    /************************************************************************************
     * Method:
     * Purpose:
     * 
     * *********************************************************************************/
    protected void Page_Load(object sender, EventArgs e)
    {

        hDoNotValidate.Value = "false";
        invoice_no = 0;
        string edit = "";
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        this.hELT_ACCT.Value = elt_account_number;
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());
        IVMnager = new InvoiceManager(elt_account_number);
        OCItemsManager = new OperationSideChargeItemsManager(elt_account_number);
        eltUserMgr = new ELTUserProfileManager(elt_account_number);
        gUtil = new GeneralUtility();
        IVRecord = new InvoiceRecord();
        AIR_ARNChargeItemControl1.initaializeGridViewChargeItem();
        glMgr = new GLManager(elt_account_number);
        ARNRec = new ARNRecord();
        ARLock = false;
        AAJMgr = new AllAccountsJournalManager(elt_account_number);
        this.btnSaveDown.Attributes.Add("onclick", "btnSaveClick()");
        this.btnSaveUp.Attributes.Add("onclick", "btnSaveClick()");
        this.btnSaveNew.Attributes.Add("onclick", "btnSaveNewClick()");
        this.btnDelete.Attributes.Add("onclick", "btnDeleteClick()");
        this.imgFetch.Attributes.Add("onClick", "getCustomerSellingRate()");
        this.imgCalc.Attributes.Add("onClick", "calculateTotalFc()");
        this.txtRate.Attributes.Add("onBlur", "catchRatingInfo()");
        this.txtChWT.Attributes.Add("onblur", "ChWTchange(this)");
        this.txtGrossWT.Attributes.Add("onblur", "GrWTchange(this)");
        this.txtRate.Attributes.Add("onblur", "Ratechange(this)");
        this.ddlScale.Attributes.Add("onchange", "scaleChange(this)");
        this.txtFC.Attributes.Add("onblur", "add_or_updateFC(this)");
        this.txtSearchIVNO.Attributes.Add("onfocus", "clearSearch(this)");
        ARNMgr = new ARNManager(elt_account_number);

        try
        {
            command = hCommand.Value;
            string inv = Request.QueryString["invoice_no"];
            edit = Request.QueryString["edit"];
            invoice_no = Int32.Parse(inv);
            gUtil.removeNull(ref invoice_no);
            gUtil.removeNull(ref edit);
        }
        catch (Exception ex)
        {
            string msg = ex.Message;
        }
        if (invoice_no == 0)
        {
            string invoice_number = this.txtInvoice_no.Text;
            if (invoice_number != "")
            {
                invoice_no = Int32.Parse(invoice_number);
            }
        }
        ARStatusManager arSMgr = new ARStatusManager(elt_account_number);
        enableControls();
        if (!IsPostBack)
        {

            portMgr = new PortManager(elt_account_number);
            ArrayList PortList = portMgr.getPortList(elt_account_number);
            this.ddlPortOfDischarge.DataSource = PortList;
            this.ddlPortOfLoading.DataSource = PortList;
            this.ddlPortOfDischarge.DataBind();
            this.ddlPortOfLoading.DataBind();
            this.ddlSalesPerson.DataSource = eltUserMgr.getSalesPersonList();
            this.ddlSalesPerson.DataBind();
            ArrayList ARaccountList = glMgr.getGLAcctList(Account.ACCOUNT_RECEIVABLE);
            this.ddlARAcct.DataSource = ARaccountList;
            this.ddlARAcct.DataTextField = "Gl_account_desc";
            this.ddlARAcct.DataValueField = "Gl_account_number";
            this.ddlARAcct.DataBind();
            listSelected = (ArrayList)Session["QlistSelected"];
            if (listSelected != null)//from queue 
            {
                dsOperationCharge = OCItemsManager.getChargeItemsFromWaybill(listSelected);
                Session["dsOperationCharge"] = dsOperationCharge;
                this.AIR_ARNChargeItemControl1.reBind_ChargeChangesToGrid(dsOperationCharge, ARLock);
                this.AIR_ARNCostItemControl1.bindEmpty();
            }
            else
            {
                if (invoice_no != 0)
                {
                    if (edit == "yes")
                    {
                        ARLock = arSMgr.FindIfPaymentProcessed(invoice_no);
                        loadARNFromDB(invoice_no);
                    }
                }
                else
                {
                    AIR_ARNChargeItemControl1.bindEmpty();
                    AIR_ARNCostItemControl1.bindEmpty();
                }
            }
        }
        else
        {
            if (invoice_no != 0)
            {
                ARLock = arSMgr.FindIfPaymentProcessed(invoice_no);
            }

            if (command == "SAVE")
            {
                btnSaveClick();
            }
            else if (command == "SAVENEW")
            {
                btnSaveAsNewClick();
            }
            else if (command == "SEARCH")
            {
                SearchINV();
            }
            else if (command == "DELETEIV")
            {
                btnDeleteClick();
            }
            else if (command == "LOADMAWB")
            {
                this.getARNInfoFromScreen();
                this.getMAWBInfoForARN();
                bindPage();
            }
            else if (command == "ADDFC")
            {
                if (!this.ARLock)
                {
                    AIR_ARNChargeItemControl1.addDefaultFC();
                }
            }
        }
        hCommand.Value = "";
    }
    /************************************************************************************
     * Method:
     * Purpose:
     * 
     * *********************************************************************************/
    protected void btnSaveAsNewClick()
    {
        this.txtInvoice_no.Text = "";
        btnSaveClick();
    }

    protected void btnDeleteClick()
    {
        APStatusManager APSMgr = new APStatusManager(elt_account_number);
        APLock = APSMgr.FindIfAPProcessed(invoice_no);
        if (!APLock && !ARLock)
        {
            ARNMgr.deleteARNRecord(invoice_no);

            bindEmptyPage();
        }

    }
    /************************************************************************************
     * Method:
     * Purpose:
     * 
     * *********************************************************************************/
    protected void btnSaveClick()
    {
        this.getARNInfoFromScreen();
        this.getIVInfoFromScreen();

        try
        {
            IVRecord.amount_charged = this.AIR_ARNChargeItemControl1.Total_Amount;
        }
        catch
        {
            IVRecord.amount_charged = 0;
        }
        try
        {
            IVRecord.subtotal = this.AIR_ARNChargeItemControl1.Total_Amount;// -Decimal.Parse(this.txtAgentProfit.Text) - Decimal.Parse(this.txtAgentProfit.Text);
        }
        catch
        {
            IVRecord.subtotal = 0;
        }
        //Case Saving New
        if (this.txtInvoice_no.Text.Trim() == "" || this.txtInvoice_no.Text.Trim() == "0")
        {
            try
          {
                ArrayList chList = AIR_ARNChargeItemControl1.getChargeItemList();
                ArrayList costList = AIR_ARNCostItemControl1.getCostItemList();
                for (int i = 0; i < chList.Count; i++)
                {
                    ((ChargeItemRecord)chList[i]).Hb = this.txtHAWB.Text;
                    ((ChargeItemRecord)chList[i]).Import_export = "I";
                    ((ChargeItemRecord)chList[i]).Mb = this.lstMAWB.Text;
                    ((ChargeItemRecord)chList[i]).Waybill_type = "MAWB";
                }

                for (int i = 0; i < costList.Count; i++)
                {
                    ((CostItemRecord)costList[i]).Hb = this.txtHAWB.Text;
                    ((CostItemRecord)costList[i]).Import_export = "I";
                    ((CostItemRecord)costList[i]).Mb = this.lstMAWB.Text;
                    ((CostItemRecord)costList[i]).Waybill_type = "MAWB";
                }

                IVRecord.setChargeItemListWithChargeItemArrayList(chList);
                IVRecord.setCostItemListWithCostItemArrayList(costList);
                IVRecord.setBillDetailWithCostItemArrayList(costList);
                //----beginning payment/balance
                IVRecord.amount_paid = 0;
                IVRecord.balance = IVRecord.amount_charged;
                //----AR account for this invoice
                IVRecord.accounts_receivable = Int32.Parse(ddlARAcct.SelectedValue);
                IVRecord.pay_status = "A";
                IVRecord.AllAccountsJournalList = createAllAccountsJournalEntry(chList, "ARN");
                IVRecord.air_ocean = "A";
                //added by stanley on 12/14
                if (rdPrepaidCollect.SelectedValue == "Prepaid")
                {
                    IVRecord.inland_type = "P";
                }
                else if (rdPrepaidCollect.SelectedValue == "Collect")
                {
                    IVRecord.inland_type = "C";
                }
                else
                {
                    IVRecord.inland_type = "";
                }
                IVRecord.import_export = "I";

                if (IVMnager.insertInvoiceRecord(ref IVRecord, "ARN"))
                {
                    listSelected = (ArrayList)Session["QlistSelected"];
                    if (listSelected != null)
                    {
                        IVQManager qMngr = new IVQManager(elt_account_number);
                        for (int i = 0; i < listSelected.Count; i++)
                        {
                            IVQRecord IVQ = (IVQRecord)listSelected[i];
                            IVQ.Invoiced = "Y";
                            qMngr.updateIVQRecord(IVQ);
                        }
                        Session["QlistSelected"] = null;
                    }
                    ARNRec.invoice_no = IVRecord.Invoice_no;
                    ARNRec.CreatedBy = this.txtPrePraredBy.Text;
                    if (ARNRec.prepared_by.Trim() == "")
                    {
                        ARNRec.CreatedBy = login_name;
                    }
                    ARNRec.prepared_by = this.txtPrePraredBy.Text;
                    if (ARNRec.prepared_by.Trim() == "")
                    {
                        ARNRec.prepared_by = login_name;
                    }
                    ARNRec.CreatedDate = DateTime.Today.ToShortDateString();
                    ARNRec.iType = "A";
                    this.ARNMgr.insertARNRecord(this.ARNRec);
                }
                try
                {
                    loadARNFromDB(IVRecord.Invoice_no);
                    //this.bindPage();
                }
                catch (Exception ex1)
                {
                    throw ex1;
                }
                //create link to invoice_hawb for an invoice from each hawb                                  
            }
            catch (Exception ex)
           {
                string msg = ex.Message;
                throw ex;
           }
        }
        else//Case update 
        {
            try
            {
                ArrayList chList = AIR_ARNChargeItemControl1.getChargeItemList();
                ArrayList costList = AIR_ARNCostItemControl1.getCostItemList();

                for (int i = 0; i < chList.Count; i++)
                {
                    ((ChargeItemRecord)chList[i]).Hb = this.txtHAWB.Text;
                    ((ChargeItemRecord)chList[i]).Import_export = "I";
                    ((ChargeItemRecord)chList[i]).Mb = this.lstMAWB.Text;
                    ((ChargeItemRecord)chList[i]).Waybill_type = "MAWB";

                }

                for (int i = 0; i < costList.Count; i++)
                {
                    ((CostItemRecord)costList[i]).Hb = this.txtHAWB.Text;
                    ((CostItemRecord)costList[i]).Import_export = "I";
                    ((CostItemRecord)costList[i]).Mb = this.lstMAWB.Text;
                    ((CostItemRecord)costList[i]).Waybill_type = "MAWB";

                }
                IVRecord.setChargeItemListWithChargeItemArrayList(chList);
                IVRecord.setCostItemListWithCostItemArrayList(costList);
                IVRecord.setBillDetailWithCostItemArrayList(costList);
                IVRecord.AllAccountsJournalList = createAllAccountsJournalEntry(chList, "ARN");
                IVRecord.air_ocean = "A";
                //added by stanley on 12/14
                if (rdPrepaidCollect.SelectedValue == "Prepaid")
                {
                    IVRecord.inland_type = "P";
                }
                else if (rdPrepaidCollect.SelectedValue == "Collect")
                {
                    IVRecord.inland_type = "C";
                }
                else
                {
                    IVRecord.inland_type = "";
                }
                IVRecord.import_export = "I";
                if (this.IVMnager.updateInvoiceRecord(ref IVRecord, "ARN"))
                {
                    ARNRec.invoice_no = IVRecord.Invoice_no;
                    this.ARNMgr.updateARNRecord(ref this.ARNRec);
                    //------------Update payment/balance
                    PaymentDetailManager cpDMgr = new PaymentDetailManager(elt_account_number);
                    IVRecord.amount_paid = cpDMgr.getcustomerPaymentDetailSumForInvoice(invoice_no);
                    IVRecord.balance = IVRecord.amount_charged - IVRecord.amount_paid;
                    this.bindPage();
                }
            }
            catch (Exception ex)
            {            
                throw ex;
            }
        }

    }

    /************************************************************************************
     * Method:
     * Purpose:
     * 
     * *********************************************************************************/
    protected bool checkCostVendorValid()
    {
        if (this.AIR_ARNCostItemControl1.IsVendorValid)
        {
            return true;
        }
        else
        {
            string script = "<script language='javascript'>";
            script += "alert('Please choose vendor from list');";
            script += "</script>";
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", script);
            this.AIR_ARNCostItemControl1.setFocusOnVendor(this.AIR_ARNCostItemControl1.InvalidVendorListID);
            return false;
        }

    }

    /************************************************************************************
     * Method:
     * Purpose:
     * 
     * *********************************************************************************/
    public ArrayList createAllAccountsJournalEntry(ArrayList chList, string tran_type)
    {
        ArrayList list = new ArrayList();
        //CREATEING AR ENTRY
        Decimal amount = 0;
        for (int i = 0; i < chList.Count; i++)
        {
            amount += ((ChargeItemRecord)chList[i]).Amount;
        }
        AllAccountsJournalRecord rec = new AllAccountsJournalRecord();
        rec.elt_account_number = Int32.Parse(elt_account_number);
        rec.gl_account_number = Int32.Parse(this.ddlARAcct.SelectedValue);
        rec.gl_account_name = this.ddlARAcct.SelectedItem.Text;
        rec.tran_num = invoice_no;
        rec.air_ocean = "A";
        //added by stanley on 12/14
        if (rdPrepaidCollect.SelectedValue == "Prepaid")
        {
            rec.inland_type = "P";
        }
        else if (rdPrepaidCollect.SelectedValue == "Collect")
        {
            rec.inland_type = "C";
        }
        else
        {
            rec.inland_type = "";
        }
        rec.tran_type = tran_type;
        rec.tran_date = this.dInvoice.Text;
        rec.customer_number = Int32.Parse(this.hCustomerAcct.Value);
        rec.customer_name = this.lstCustomerName.Text;
        rec.memo = this.txtDescOfPackagesAndGoods.Text;
        rec.debit_amount = amount;
        rec.credit_amount = 0;
        list.Add(rec);


        //CREATING REVENUE ENTRIES 
        ChargeItemKindManager chKindMgr = new ChargeItemKindManager(elt_account_number);
        for (int i = 0; i < chList.Count; i++)
        {
            rec = new AllAccountsJournalRecord();
            rec.elt_account_number = Int32.Parse(elt_account_number);
            rec.gl_account_number = chKindMgr.getChargeItemRevenueAcct(((ChargeItemRecord)chList[i]).ItemNo);
            rec.gl_account_name = glMgr.getGLDescription(rec.gl_account_number);
            rec.tran_num = invoice_no;
            rec.air_ocean = "A";
            //added by stanley on 12/14
            if (rdPrepaidCollect.SelectedValue == "Prepaid")
            {
                IVRecord.inland_type = "P";
            }
            else if (rdPrepaidCollect.SelectedValue == "Collect")
            {
                IVRecord.inland_type = "C";
            }
            else
            {
                IVRecord.inland_type = "";
            }
            rec.tran_type = tran_type;
            rec.tran_date = this.dInvoice.Text;
            rec.customer_number = Int32.Parse(this.hCustomerAcct.Value);
            rec.customer_name = this.lstCustomerName.Text;
            rec.memo = this.txtDescOfPackagesAndGoods.Text;
            rec.debit_amount = 0;
            rec.credit_amount = -((ChargeItemRecord)chList[i]).Amount;
            list.Add(rec);
        }

        return list;
    }

    /************************************************************************************
     * Method:
     * Purpose:
     * 
     * *********************************************************************************/
    protected void btnSearchIV_Click(object sender, ImageClickEventArgs e)
    {
        SearchINV();
    }
    protected void SearchINV()
    {
        string arriveNo = "";
        string arriv="";
        arriveNo=txtSearchIVNO.Text.ToString();
        if (this.txtSearchIVNO.Text != "" && this.txtSearchIVNO.Text != "Search Here")
        {
            IVMnager.PreLoadInvoice(invoice_no);
            if (ddlNOlist.SelectedIndex == 0)
            {
                try
                {
                    invoice_no = Int32.Parse(txtSearchIVNO.Text);
                    loadARNFromDB(invoice_no);
                }
                catch
                {
                    string script = "<script language='javascript'>";
                    script += "alert('No such invoice exists');";
                    script += "</script>";
                    this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", script);
                }
            }
            else if (ddlNOlist.SelectedIndex == 1)
            {

                arriv = findINVNoBYHAWB(arriveNo).ToString();
                if (arriv != "")
                {
                    invoice_no = Int32.Parse(arriv);
                    loadARNFromDB(invoice_no);
                }
                else
                {
                    string script = "<script language='javascript'>";
                    script += "alert('No such House AWB exists');";
                    script += "</script>";
                    this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", script);
                }
            }
            else
            {

                arriv = findINVNoBYMAWB(arriveNo).ToString();
                if (arriv != "")
                {
                    invoice_no = Int32.Parse(arriv);
                    loadARNFromDB(invoice_no);
                }
                else
                {
                    string script = "<script language='javascript'>";
                    script += "alert('No such Master AWB exists');";
                    script += "</script>";
                    this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", script);
                }


            }
        }
        else
        {
            string script = "<script language='javascript'>";
            script += "alert('Please Select Search No.');";
            script += "</script>";
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", script);
        }

        
    }

    string findINVNoBYMAWB(string searchNo)
    {
        string Search_no = "";
        string sqlText = " SELECT top 1 invoice_no from invoice where elt_account_number="
             + elt_account_number + " and air_ocean='A' and mawb_num='" + searchNo + "'";
        DataTable dt = new DataTable("MAWB_title");
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;

        if (sqlText != null && sqlText.Trim() != "")
        {
            try
            {
                ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                Adap = new SqlDataAdapter();
                ds = new DataSet();

                Con.Open();
                SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
                Adap.SelectCommand = cmd;
                Adap.Fill(dt);
            }
            catch
            {
            }
            finally
            {
                if (Adap != null)
                {
                    Adap.Dispose();
                }
                if (Con != null)
                {
                    Con.Close();
                }
            }
        }
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            Search_no=dt.Rows[i]["invoice_no"].ToString();

        }
       
        return Search_no;
    }


    string findINVNoBYHAWB(string searchNo)
    {
        string Search_no = "";
        string sqlText = " SELECT top 1 invoice_no from invoice where elt_account_number="
            + elt_account_number + " and air_ocean='A' and hawb_num='" + searchNo +"'";
        DataTable dt = new DataTable("HAWB_title");
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;

        if (sqlText != null && sqlText.Trim() != "")
        {
            try
            {
                ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                Adap = new SqlDataAdapter();
                ds = new DataSet();

                Con.Open();
                SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
                Adap.SelectCommand = cmd;
                Adap.Fill(dt);
            }
            catch
            {
            }
            finally
            {
                if (Adap != null)
                {
                    Adap.Dispose();
                }
                if (Con != null)
                {
                    Con.Close();
                }
            }
        }
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            Search_no = dt.Rows[i]["invoice_no"].ToString();

        }
        
        return Search_no;
    }

    /************************************************************************************
     * Method:
     * Purpose:
     * 
     * *********************************************************************************/

    protected void loadARNFromDB(int invoice_no)
    {
        if (invoice_no != 0)
        {
            InvoiceRecord PrevIV = IVRecord;
            ARNRecord PrevARN = ARNRec;

            ARStatusManager arSMgr = new ARStatusManager(elt_account_number);
            if (invoice_no != 0)
            {
                ARLock = arSMgr.FindIfPaymentProcessed(invoice_no);
            }
            IVRecord = IVMnager.getInvoiceRecord(invoice_no);
            ARNRec = ARNMgr.getARNRecord(invoice_no, "A");

            hCustomerAcct.Value = IVRecord.Customer_Number.ToString();
            customer_org_acct = IVRecord.Customer_Number;
            DataTable dt = IVMnager.getInvoiceChargesDs(invoice_no);
            DataTable dt2 = IVMnager.getInvoiceCostDs(invoice_no);
            if (dt.Rows.Count > 0)
            {
                AIR_ARNChargeItemControl1.bindFromIVChargeItemDataTable(dt, ARLock);
            }
            else
            {
                AIR_ARNChargeItemControl1.bindEmpty();
            }
            if (dt2.Rows.Count > 0)
            {
                AIR_ARNCostItemControl1.bindFromIVCostItemDataTable(dt2);
            }
            else
            {
                AIR_ARNCostItemControl1.bindEmpty();
            }
            if (ARNRec.invoice_no != 0)
            {
                bindPage();

                if (IVRecord.is_deleted)
                {
                    disableControls();
                }
            }
            else
            {
                IVRecord = PrevIV;
                ARNRec = PrevARN;

                string script = "<script language='javascript'>";
                script += "alert('No such invoice exists');";
                script += "</script>";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", script);
            }
        }

        this.txtSearchIVNO.Text = "";
    }

    /************************************************************************************
     * Method:
     * Purpose:
     * 
     * *********************************************************************************/
    protected void disableControls()
    {

        this.dInvoice.Enabled = false;
        this.txtInvoice_no.Enabled = false;
        this.txtRefNo.Enabled = false;
        this.lstConsigneeName.Enabled = false;
        this.lstConsigneeName.Enabled = false;
        this.lstShipperName.Enabled = false;
        this.ddlARAcct.Enabled = false;
        this.btnSaveUp.Visible = false;
        this.btnDelete.Visible = false;
        this.btnSaveNew.Visible = false;
        this.btnSaveDown.Visible = false;
        AIR_ARNChargeItemControl1.Enabled = false;
        AIR_ARNCostItemControl1.Enabled = false;
    }

    protected void enableControls()
    {

        this.txtFileNo.Enabled = true;
        this.dInvoice.Enabled = true;
        this.txtInvoice_no.Enabled = true;
        this.txtRefNo.Enabled = true;
        this.lstConsigneeName.Enabled = true;
        this.lstConsigneeName.Enabled = true;
        this.lstShipperName.Enabled = true;
        this.ddlARAcct.Enabled = true;
        this.btnSaveUp.Visible = true;
        this.btnDelete.Visible = true;
        this.btnSaveNew.Visible = true;
        this.btnSaveDown.Visible = true;
        AIR_ARNChargeItemControl1.Enabled = true;
        AIR_ARNCostItemControl1.Enabled = true;
    }
    #region Bind Page variables from IVRecord


    protected void bindPage()
    {
        try
        {
            //------Setting values from ARN Record ------------------------------------------            
            this.lstMAWB.Text = ARNRec.mawb_num;
            this.txtHAWB.Text = ARNRec.hawb_num;
            this.txtChWT.Text = ARNRec.chg_wt.ToString();
            this.txtContainerReturnLoc.Text = ARNRec.container_location;
            this.txtDescOfPackagesAndGoods.Text = ARNRec.desc3;
            this.dETA.Text = ARNRec.eta;
            this.dETA2.Text = ARNRec.eta2;
            this.dETD.Text = ARNRec.etd;
            this.dETD2.Text = ARNRec.etd2;
            this.dITDate.Text = ARNRec.it_date;
            this.dGoDate.Text = ARNRec.go_date;
            this.dInvoice.Text = ARNRec.tran_dt;
            this.dLastFree.Text = ARNRec.free_date;
            this.dPickup.Text = ARNRec.pickup_date;
            this.txtFC.Text = ARNRec.fc_charge.ToString();
            this.txtFileNo.Text = ARNRec.ref_no_our;
            this.txtFinalDest.Text = ARNRec.destination;
            this.txtFlightNo.Text = ARNRec.flt_no;
            this.txtFreightLocation.Text = ARNRec.cargo_location;
            this.txtGrossWT.Text = ARNRec.gross_wt.ToString();
            this.txtITEntryPort.Text = ARNRec.it_entry_port;
            this.txtITNo.Text = ARNRec.it_number;
            this.txtMarksNumbers.Text = ARNRec.desc1;            
            //this.txtFileNo.Text = ARNRec.ref_no_our;
            this.txtNoCtn.Text = ARNRec.pieces.ToString();
            this.txtPlaceOfDelivery.Text = ARNRec.delivery_place;
            this.txtRate.Text = ARNRec.fc_rate.ToString();
            this.txtRefNo.Text = ARNRec.customer_ref;
            this.txtRemarks.Text = ARNRec.remarks;
            this.lstNotifyName.Text = ARNRec.notify_name;
            this.txtNotifyInfo.Text = ARNRec.notify_info;
            this.lstConsigneeName.Text = ARNRec.consignee_name;
            this.txtConsigneeInfo.Text = ARNRec.consignee_info;
            this.lstShipperName.Text = ARNRec.shipper_name;
            this.txtShipperInfo.Text = ARNRec.shipper_info;
            this.txtSubAWB.Text = ARNRec.igSub_HAWB;
            this.txtPrePraredBy.Text = ARNRec.prepared_by;
            this.hBrokerAcct.Value = ARNRec.broker_acct.ToString();
            this.hConsigneeAcct.Value = ARNRec.consignee_acct.ToString();
            this.hNotifyAcct.Value = ARNRec.notify_acct.ToString();
            this.hShipperAcct.Value = ARNRec.shipper_acct.ToString();
            this.txtCustomerInfo.Text = IVRecord.Customer_info;
            this.lstCustomerName.Text = IVRecord.Customer_Name;
            this.hCustomerAcct.Value = IVRecord.Customer_Number.ToString();
            //added by stanley on 12/14
            if (IVRecord.inland_type == "C")
            {
                this.rdPrepaidCollect.SelectedValue = "Collect";
            }
            else if (IVRecord.inland_type == "P")
            {
                this.rdPrepaidCollect.SelectedValue = "Prepaid";
            }
  
            if (ARNRec.arr_code != "")
            {
                this.ddlPortOfDischarge.SelectedValue = ARNRec.arr_code.Trim();
            }
            else
            {
                this.ddlPortOfDischarge.SelectedIndex = 0;
                for (int i = 0; i < ddlPortOfDischarge.Items.Count; i++)
                {
                    if (ARNRec.arr_port == ddlPortOfDischarge.Items[i].Text)
                    {
                        this.ddlPortOfDischarge.SelectedIndex = i;
                    }

                }
            }
            if (ARNRec.dep_code != "")
            {
                this.ddlPortOfLoading.SelectedValue = ARNRec.dep_code.Trim();
            }
            else
            {
                this.ddlPortOfLoading.SelectedIndex = 0;
                for (int i = 0; i < ddlPortOfLoading.Items.Count; i++)
                {
                    if (ARNRec.dep_port == ddlPortOfLoading.Items[i].Text)
                    {
                        this.ddlPortOfLoading.SelectedIndex = i;
                    }
                }
            }
            this.ddlSalesPerson.SelectedValue = ARNRec.SalesPerson;
            this.ddlScale.SelectedValue = ARNRec.scale1.Trim();
            this.ddlCTNUnit.SelectedValue = ARNRec.uom.Trim();
            this.hCarrierCode.Value = ARNRec.carrier_code;
            //------Setting values from Invoice Record----------------------------------------
            //------Changed by stanley on 12/17/2007 ----------------------------------------
            try
            {
                this.txtFileNo.Text = ARNRec.ref_no_our.Length.ToString();
                this.txtFileNo.Text = ARNRec.ref_no_our;
            }
            catch
            {
                this.txtFileNo.Text = IVRecord.ref_no_Our;
            }
            try
            {
                this.txtFileNo.Text = IVRecord.ref_no_Our.Length.ToString();
                this.txtFileNo.Text = IVRecord.ref_no_Our;
            }
            catch
            {
                this.txtFileNo.Text = ARNRec.ref_no_our;
            }

            if (IVRecord.invoice_date != "" && IVRecord.invoice_date != null)
            {
                this.dInvoice.Text = String.Format("{0:dd/MM/yyyy}", IVRecord.invoice_date);
            }
            this.txtInvoice_no.Text = IVRecord.Invoice_no.ToString();

            if (IVRecord.accounts_receivable.ToString() != "0")
            {
                this.ddlARAcct.SelectedValue = IVRecord.accounts_receivable.ToString().Trim();
            }

            if (ARLock)
            {
                this.lblARLock.Visible = true;
            }
            else
            {
                this.lblARLock.Visible = false;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

    }

 
    protected void bindEmptyPage()
    {
        try
        {
            //------Setting values from ARN Record ------------------------------------------            
            this.lstMAWB.Text = "";
            this.txtChWT.Text = "";
            this.txtContainerReturnLoc.Text = "";
            this.txtDescOfPackagesAndGoods.Text = "";
            this.dETA.Text = "";
            this.dETA2.Text = "";
            this.dETD.Text = "";
            this.dETD2.Text = "";
            this.txtFC.Text = "0.00";
            this.txtFileNo.Text = "";
            this.txtFinalDest.Text = "";
            this.txtFlightNo.Text = "";
            this.txtFreightLocation.Text = "";
            this.dGoDate.Text = "";
            this.txtGrossWT.Text = "";
            this.dITDate.Text = "";
            this.txtITEntryPort.Text = "";
            this.txtITNo.Text = "";
            this.dInvoice.Text = "";
            this.dLastFree.Text = "";
            this.txtMarksNumbers.Text = "";
            this.txtNoCtn.Text = "";
            this.txtCustomerInfo.Text = "";
            this.lstCustomerName.Text = "";
            this.dPickup.Text = "";
            this.txtPlaceOfDelivery.Text = "";
            this.txtRate.Text = "";
            this.txtRefNo.Text = "";
            this.txtRemarks.Text = "";
            this.lstNotifyName.Text = "";
            this.txtNotifyInfo.Text = "";          
            this.lstConsigneeName.Text = "";
            this.txtConsigneeInfo.Text = "";
            this.lstShipperName.Text = "";
            this.txtShipperInfo.Text = "";
            this.txtSubAWB.Text = "";
            this.txtPrePraredBy.Text = "";
            this.hBrokerAcct.Value = "";
            this.hConsigneeAcct.Value = "";
            this.hNotifyAcct.Value = "";
            this.hShipperAcct.Value = "";
            this.ddlPortOfDischarge.SelectedIndex = 0;
            this.ddlPortOfLoading.SelectedIndex = 0;
            this.ddlSalesPerson.SelectedIndex = 0;
            this.ddlScale.SelectedIndex = 0;
            this.ddlCTNUnit.SelectedIndex = 0;
            this.hCarrierCode.Value = "";
            //------Setting values from Invoice Record----------------------------------------
            this.txtFileNo.Text = "";
            this.dInvoice.Text = "";
            this.txtInvoice_no.Text = "";
            this.ddlARAcct.SelectedIndex = 0;
            this.customer_org_acct = 0;
            this.hBrokerAcct.Value = "0";
            this.hCarrierCode.Value = "0";
            this.hCommand.Value = "";
            this.hConsigneeAcct.Value = "0";
            this.hCustomerAcct.Value = "0";
            this.hNotifyAcct.Value = "0";
            this.hShipperAcct.Value = "0";
            this.hVendorIDs.Value = "";
            AIR_ARNChargeItemControl1.bindEmpty();
            AIR_ARNCostItemControl1.bindEmpty();
        }
        catch (Exception ex)
        {
            throw ex;
        }

    }

    #endregion

    #region Get general info from screen and bind to the IVRecord


    protected void getIVInfoFromScreen()
    {
        IVRecord.Carrier = this.txtFlightNo.Text;
        IVRecord.Arrival_Dept = this.dETA.Text + "--" + this.dETD.Text;
        IVRecord.Customer_info = this.txtCustomerInfo.Text;
        IVRecord.Description = this.txtDescOfPackagesAndGoods.Text;
        IVRecord.dest = this.ddlPortOfDischarge.SelectedItem.Text;
        IVRecord.ref_no_Our = this.txtFileNo.Text;
        IVRecord.hawb_num = this.txtHAWB.Text;
        IVRecord.accounts_receivable = Int32.Parse(this.ddlARAcct.SelectedValue.Trim());
        IVRecord.mawb_num = this.lstMAWB.Text;
        IVRecord.origin = this.ddlPortOfLoading.Text;
        IVRecord.ref_no = this.txtRefNo.Text;
        IVRecord.consignee = (this.lstConsigneeName.Text);
        IVRecord.Customer_Name = this.lstCustomerName.Text;
        IVRecord.shipper = this.lstShipperName.Text;
        IVRecord.invoice_type = "I";
        if (this.dInvoice.Text == "")
        {
            this.dInvoice.Text = DateTime.Today.ToShortDateString();
        }
        IVRecord.invoice_date = String.Format("{0:dd/MM/yyyy}", this.dInvoice.Text);

        try
        {
            IVRecord.Invoice_no = Int32.Parse(this.txtInvoice_no.Text);
        }
        catch
        {
            IVRecord.Invoice_no = 0;
        }

        try
        {
            IVRecord.Total_Pieces = this.txtNoCtn.Text;
        }
        catch
        {
            IVRecord.Total_Pieces = "0";
        }

        try
        {
            IVRecord.Total_Charge_Weight = this.txtChWT.Text;
        }
        catch
        {
            IVRecord.Total_Charge_Weight = "0";
        }
        try
        {
            IVRecord.Customer_Number = Int32.Parse(this.hCustomerAcct.Value);
        }
        catch
        {
            IVRecord.Customer_Number = 0;
        }

        try
        {
            IVRecord.Total_Gross_Weight = this.txtGrossWT.Text;
        }
        catch
        {
            IVRecord.Total_Gross_Weight = "0";
        }
    }

   
    public void getMAWBInfoForARN()
    {
        ImportMAWBManager iMasterMgr = new ImportMAWBManager(elt_account_number);
        ImportMAWBRecord iRec = iMasterMgr.getMAWB(this.lstMAWB.Text);
        this.ARNRec.arr_code = iRec.arr_code;
        this.ARNRec.arr_port = iRec.arr_port;
        this.ARNRec.cargo_location = iRec.cargo_location;
        this.ARNRec.dep_code = iRec.dep_code;
        this.ARNRec.dep_port = iRec.dep_port;
        this.ARNRec.eta = iRec.eta;
        this.ARNRec.etd = iRec.etd;
        this.ARNRec.ref_no_our = iRec.file_no;
        this.ARNRec.flt_no = iRec.flt_no;
        this.ARNRec.it_date = iRec.it_date;
        this.ARNRec.it_entry_port = iRec.it_entry_port;
        this.ARNRec.it_number = iRec.it_number;
        this.ARNRec.free_date = iRec.last_free_date;
        this.ARNRec.delivery_place = iRec.place_of_delivery;
        this.ARNRec.process_dt = DateTime.Parse(iRec.process_dt).ToShortDateString();
        this.ARNRec.sub_mawb1 = iRec.sub_mawb;
        this.ARNRec.carrier_code = iRec.carrier_code;
    }
   

    protected void getARNInfoFromScreen()
    {
        mawb_num = this.txtHAWB.Text;
        ARNRec.carrier_code = this.hCarrierCode.Value;
        ARNRec.mawb_num = this.lstMAWB.Text;
        ARNRec.hawb_num = this.txtHAWB.Text;
        try
        {
            ARNRec.chg_wt = Decimal.Parse(this.txtChWT.Text);
        }
        catch { ARNRec.chg_wt = 0; }

        ARNRec.container_location = this.txtContainerReturnLoc.Text;
        ARNRec.desc3 = this.txtDescOfPackagesAndGoods.Text;

        if (this.dETA.Text != "")
        {
            ARNRec.eta = this.dETA.Text;
        }

        if (this.dETA2.Text != "")
        {
            ARNRec.eta2 = this.dETA2.Text;
        }

        if (this.dETD.Text != "")
        {
            ARNRec.etd = this.dETD.Text;
        }
        if (this.dETD2.Text != "")
        {
            ARNRec.etd2 = this.dETD2.Text;
        }
        if (this.dGoDate.Text != "")
        {
            ARNRec.go_date = this.dGoDate.Text;
        }
        if (this.dInvoice.Text != "")
        {
            ARNRec.tran_dt = this.dInvoice.Text;
        }
        if (this.dLastFree.Text != "")
        {
            ARNRec.free_date = this.dLastFree.Text;
        }
        if (this.dPickup.Text != "")
        {
            ARNRec.pickup_date = this.dPickup.Text;
        }
        if (this.dITDate.Text != "")
        {
            ARNRec.it_date = this.dITDate.Text;
            ARNRec.process_dt = this.dInvoice.Text;
        }
        try
        {
            ARNRec.fc_charge = Decimal.Parse(this.txtFC.Text);


            if (rdPrepaidCollect.SelectedValue == "Collect")
            {
                ARNRec.prepaid_collect = "Y";
                ARNRec.freight_collect = Decimal.Parse(this.txtFC.Text);
                ARNRec.oc_collect = AIR_ARNChargeItemControl1.Total_other_charge;
            }
            else
            {
                ARNRec.prepaid_collect = "N";
                ARNRec.freight_collect = 0;
            }
        }
        catch { ARNRec.fc_charge = 0; }
        try
        {
            ARNRec.total_other_charge = AIR_ARNChargeItemControl1.Total_other_charge;
        }
        catch { ARNRec.total_other_charge = 0; }

        ARNRec.ref_no_our = this.txtFileNo.Text;
        ARNRec.destination = this.txtFinalDest.Text;
        ARNRec.flt_no = this.txtFlightNo.Text;
        ARNRec.cargo_location = this.txtFreightLocation.Text;
        try
        {
            ARNRec.gross_wt = Decimal.Parse(this.txtGrossWT.Text);
        }
        catch { ARNRec.gross_wt = 0; }

        ARNRec.it_entry_port = this.txtITEntryPort.Text;
        ARNRec.it_number = this.txtITNo.Text;
        ARNRec.desc1 = this.txtMarksNumbers.Text;
        try
        {
            ARNRec.pieces = Int32.Parse(this.txtNoCtn.Text);
        }
        catch { ARNRec.pieces = 0; }
        ARNRec.notify_info = this.txtNotifyInfo.Text;
        ARNRec.delivery_place = this.txtPlaceOfDelivery.Text;
        try
        {
            ARNRec.fc_rate = Decimal.Parse(this.txtRate.Text);
        }
        catch { ARNRec.fc_rate = 0; }
        ARNRec.customer_ref = this.txtRefNo.Text;
        ARNRec.remarks = this.txtRemarks.Text;
        ARNRec.shipper_info = this.txtShipperInfo.Text;
        ARNRec.igSub_HAWB = this.txtSubAWB.Text;
        ARNRec.consignee_name = this.lstConsigneeName.Text;
        ARNRec.consignee_info = this.txtConsigneeInfo.Text;
        ARNRec.notify_name = this.lstNotifyName.Text;
        ARNRec.notify_info = this.txtNotifyInfo.Text;
        ARNRec.shipper_name = this.lstShipperName.Text;
        ARNRec.shipper_info = this.txtShipperInfo.Text;

        try
        {
            ARNRec.broker_acct = Int32.Parse(this.hBrokerAcct.Value);
        }
        catch { ARNRec.broker_acct = 0; }
        try
        {
            ARNRec.consignee_acct = Int32.Parse(this.hConsigneeAcct.Value);
        }
        catch { ARNRec.consignee_acct = 0; }
        try
        {
            ARNRec.notify_acct = Int32.Parse(this.hNotifyAcct.Value);
        }
        catch { ARNRec.notify_acct = 0; }
        try
        {
            ARNRec.shipper_acct = Int32.Parse(this.hShipperAcct.Value);
        }
        catch { ARNRec.shipper_acct = 0; }

        ARNRec.uom = this.ddlCTNUnit.SelectedValue;
        ARNRec.arr_code = this.ddlPortOfDischarge.SelectedItem.Value;
        ARNRec.dep_code = this.ddlPortOfLoading.SelectedItem.Value;
        ARNRec.dep_port = this.ddlPortOfDischarge.SelectedItem.Text;
        ARNRec.arr_port = this.ddlPortOfDischarge.SelectedItem.Text;
        ARNRec.scale1 = this.ddlScale.SelectedItem.Value;
        ARNRec.iType = "A";
        ARNRec.SalesPerson = this.ddlSalesPerson.SelectedItem.Value;
        ARNRec.prepared_by = this.txtPrePraredBy.Text;
        if (ARNRec.prepared_by.Trim() == "")
        {
            ARNRec.prepared_by = login_name;
        }

        ARNRec.ModifiedBy = login_name;
        ARNRec.ModifiedDate = DateTime.Today.ToShortDateString();
    }

    #endregion

    protected void AIR_ARNCostItemControl1_Load(object sender, EventArgs e)
    {

    }
}
