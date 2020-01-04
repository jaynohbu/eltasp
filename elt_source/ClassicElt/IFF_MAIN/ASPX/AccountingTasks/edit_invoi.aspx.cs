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
using CrystalDecisions.Shared;

public partial class ASPX_edit_invoi : System.Web.UI.Page
{
    #region variables
    protected DataSet ds = null;
    public string printPDF_CMD = "";
    public string vPrintPort;
    public string invoicePort;
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
    protected int invoice_no;
    protected int hShipper_ID;
    protected int hConsignee_ID;
    protected InvoiceRecord IVRecord;
    protected InvoiceManager IVMnager;
    protected AllAccountsJournalManager AAJMgr;
    protected GeneralUtility gUtil;
    protected int customer_org_acct;
    protected ELTUserProfileManager eltUserMgr;
    protected ArrayList listSelected;
    protected GLManager glMgr;
    protected string command;
    public bool ARLock;
    public bool APLock;
    private string arrival_dept;
    protected DataSet dsPDF;
    protected DataTable dtInvoiceHeaders;
    protected DataTable dtIVHeaderDetails;
    protected ReportSourceManager rsm = null;
    private OrganizationManager orgMgr;

    #endregion


    protected void Presave()
    {
        IVMnager.PreSaveInvoice(invoice_no);
        btnSaveClick();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        invoice_no = 0;
        string edit = "";
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        this.hELT_ACCT.Value = elt_account_number;
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());
        txttest.Visible = false;
        this.ChargeItemControl1.setParentControl(this.txtSalesTax);
        this.ChargeItemControl1.setParentControl(this.txtTotal);
        this.ChargeItemControl1.setParentControl(this.txtAgentProfit);
        IVMnager = new InvoiceManager(elt_account_number);
        OCItemsManager = new OperationSideChargeItemsManager(elt_account_number);
        eltUserMgr = new ELTUserProfileManager(elt_account_number);
        gUtil = new GeneralUtility();
        IVRecord = (InvoiceRecord)Session["IVRecord"];
        if (IVRecord == null)
        {
            IVRecord = new InvoiceRecord();
        }
        else
        {
            IVRecord = (InvoiceRecord)Session["IVRecord"];
        }

        ChargeItemControl1.initaializeGridViewChargeItem();
        glMgr = new GLManager(elt_account_number);

        ArrayList ARaccountList = glMgr.getGLAcctList(Account.ACCOUNT_RECEIVABLE);
        this.ddlARAcct.DataSource = ARaccountList;
        this.ddlARAcct.DataTextField = "Gl_account_desc";
        this.ddlARAcct.DataValueField = "Gl_account_number";
        this.ddlARAcct.DataBind();

        ARLock = false;
        AAJMgr = new AllAccountsJournalManager(elt_account_number);
        this.btnSaveDown.Attributes.Add("onclick", "btnSaveClick()");
        this.btnSaveUp.Attributes.Add("onclick", "btnSaveClick()");
        this.btnSaveNew.Attributes.Add("onclick", "btnSaveNewClick()");
        this.btnDelete.Attributes.Add("onclick", "btnDeleteClick()");
        this.txtSearchIVNO.Attributes.Add("onfocus", "clearSearch(this)");
        this.btnSearchIV.Attributes.Add("onclick", "btnSearchClick()");

        if (this.dInvoice.Text == "")
        {
            this.dInvoice.Text = DateTime.Today.ToShortDateString();
        }
        try
        {
            command = hCommand.Value;
            string inv = Request.QueryString["invoice_no"];
            edit = Request.QueryString["edit"];
            invoice_no = Int32.Parse(inv);
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
        if (invoice_no != 0)
        {
            ARLock = arSMgr.FindIfPaymentProcessed(invoice_no);
        }
        enableControls();
        listSelected = (ArrayList)Session["QlistSelected"];

        if (!IsPostBack)
        {
            if (invoice_no != 0)
            {
                if (edit == "yes")
                {
                    ARLock = arSMgr.FindIfPaymentProcessed(invoice_no);
                    loadInvoiceFromDB(invoice_no);
                }
            }
            else
            {
                ChargeItemControl1.bindEmpty();
                CostItemControl1.bindEmpty();
            }
        }
        else
        {
            string from_queue = (string)Session["from_queue"];
            if (from_queue == "Y")//from queue 
            {
                if (Session["QlistSelected"] != null)
                {
                    listSelected = (ArrayList)Session["QlistSelected"];
                    dsOperationCharge = OCItemsManager.getChargeItemsFromWaybill(listSelected);
                    bindPageDefaultValuesFromOperationQ(listSelected);
                    Session["dsOperationCharge"] = dsOperationCharge;

                    this.ChargeItemControl1.reBind_ChargeChangesToGrid(dsOperationCharge, ARLock);
                    this.txtAgentProfit.Text = "0";
                    this.txtTotal.Text = (ChargeItemControl1.Total_Amount - (Decimal.Parse(txtAgentProfit.Text) + Decimal.Parse(txtSalesTax.Text))).ToString();
                    this.CostItemControl1.bindEmpty();
                    Session["from_queue"] = "N";
                }
            }
            else
            {
                if (invoice_no == 0 && command != "SAVE" && command != "SAVENEW" && command != "DELETEIV")
                {
                    if (!ChargeItemControl1.isFilled())
                    {
                        ChargeItemControl1.bindEmpty();
                    }
                    if (!CostItemControl1.isFilled())
                    {
                        CostItemControl1.bindEmpty();
                    }
                }
            }
            if (command == "CHANGECUSTOMER")
            {
                customerchange(0);
            }

            if (command == "PRINT")
            {
                btnSaveClick();
                this.PDFPrint();
            }
            else if (command == "SEARCH")
            {
                btnSearchIV_Click();
            }
            else if (command == "SAVE")
            {
                btnSaveClick();

            }
            else if (command == "SAVENEW")
            {
                btnSaveAsNewClick();
            }
            else if (command == "DELETEIV")
            {
                APStatusManager APSMgr = new APStatusManager(elt_account_number);
                APLock = APSMgr.FindIfAPProcessed(invoice_no);
                if (!APLock && !ARLock)
                {
                    btnDeleteClick();
                    bindEmptyPage();
                }
            }
        }
        hCommand.Value = "";
    }

    public void customerchange(int customer_no)
    {
        if (customer_no == 0)
        {
            customer_no = Int32.Parse(this.hCustomerAcct.Value);
        }
        OrganizationManager orgMgr = new OrganizationManager(elt_account_number);
        string dba = "";
        string mail_info = "";
        int term = 0;
        orgMgr.getOrgInfo(customer_no, ref dba, ref mail_info, ref term);
        this.txtCustomerInfo.Text = mail_info;
        this.txtCustomerNo.Text = customer_no.ToString();
        this.txtTerm.Text = term.ToString();
        this.lstCustomerName.Text = dba;

        this.dDueDate.Text = DateTime.Parse(dInvoice.Text).AddDays(term).ToShortDateString();
    }

    protected void bindPageDefaultValuesFromOperationQ(ArrayList listSelected)
    {
        string defIVDate = eltUserMgr.getDefaultInvoiceDate();
        if (defIVDate.Equals("Today"))
        {
            this.dInvoice.Text = DateTime.Today.ToShortDateString();
        }
        orgMgr = new OrganizationManager(elt_account_number);
        customer_org_acct = ((IVQRecord)listSelected[0]).Bill_to_org_acct;
        this.hCustomerAcct.Value = customer_org_acct.ToString();
        customerchange(customer_org_acct);

        int count = listSelected.Count;

        if (count == 1)
        {
            IVQRecord rec = (IVQRecord)listSelected[0];
            this.lstShipperName.Text = rec.Shipper;
            this.lstConsigneeName.Text = rec.Consignee;
            this.txtFileNo.Text = rec.FileNo;
            this.txtMasterBillNo.Text = rec.Mawb_num;
            this.txtHoutBillNo.Text = rec.Hawb_num;
            this.txtDestination.Text = rec.destination;
            this.txtOrigin.Text = rec.origin;
            this.txtAirlineSteamShip.Text = rec.carrier;
            this.dArrival.Text = rec.ETA;
            this.dDeparture.Text = rec.ETD;
            this.arrival_dept = rec.ETA + "--" + rec.ETD;
        }

        int totalPieces = 0;
        Decimal totalGrossWeight = 0;
        Decimal totalChargeableWeight = 0;

        for (int i = 0; i < listSelected.Count; i++)
        {
            totalPieces += ((IVQRecord)listSelected[i]).Pieces;
            totalGrossWeight += ((IVQRecord)listSelected[i]).Gross_weight;
            totalChargeableWeight += ((IVQRecord)listSelected[i]).Chargeable_weight;
        }

        this.txtGrossWeight.Text = totalGrossWeight.ToString();
        this.txtChargeWeight.Text = totalChargeableWeight.ToString();
        this.txtPieces.Text = totalPieces.ToString();
    }

    protected void btnSaveAsNewClick()
    {
        this.txtInvoice_no.Text = "";
        btnSaveClick();
    }

    protected void btnDeleteClick()
    {

        IVMnager.deleteInvoiceRecord(invoice_no);
        bindEmptyPage();
    }




    protected void btnSaveClick()
    {

        this.getGeneralInfoFromScreen();


        IVRecord = (InvoiceRecord)Session["IVRecord"];
        try
        {
            IVRecord.amount_charged = this.ChargeItemControl1.Total_Amount;
        }
        catch
        {
            IVRecord.amount_charged = 0;
        }
        try
        {
            IVRecord.subtotal = this.ChargeItemControl1.Total_Amount - (Decimal.Parse(this.txtAgentProfit.Text) + Decimal.Parse(this.txtSalesTax.Text));
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

                ArrayList chList = ChargeItemControl1.getChargeItemList();
                ArrayList costList = CostItemControl1.getCostItemList();

                IVRecord.setChargeItemListWithChargeItemArrayList(chList);
                IVRecord.setCostItemListWithCostItemArrayList(costList);
                IVRecord.setBillDetailWithCostItemArrayList(costList);
                //----beginning payment/balance
                IVRecord.amount_paid = 0;
                IVRecord.balance = IVRecord.amount_charged;
                //----AR account for this invoice
                IVRecord.accounts_receivable = Int32.Parse(ddlARAcct.SelectedValue);
                IVRecord.pay_status = "A";
                IVRecord.AllAccountsJournalList = createAllAccountsJournalEntry(chList, "INV");

                prepareHeaders();

                
                if (IVMnager.insertInvoiceRecord(ref IVRecord, "INV"))
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
                }
                try
                {
                    loadInvoiceFromDB(IVRecord.Invoice_no);
                    this.bindPage();
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
            }
        }
        else//Case update 
        {
             try
           {
            ArrayList chList = ChargeItemControl1.getChargeItemList();
            ArrayList costList = CostItemControl1.getCostItemList();
            IVRecord.setChargeItemListWithChargeItemArrayList(chList);
            string s = IVRecord.pay_status;
            IVRecord.setCostItemListWithCostItemArrayList(costList);
            IVRecord.setBillDetailWithCostItemArrayList(costList);
            IVRecord.AllAccountsJournalList = createAllAccountsJournalEntry(chList, "INV");

            prepareHeaders();
            if (this.IVMnager.updateInvoiceRecord(ref IVRecord, "INV"))
            {
                //------------Update payment/balance
                PaymentDetailManager cpDMgr = new PaymentDetailManager(elt_account_number);
                IVRecord.amount_paid = cpDMgr.getcustomerPaymentDetailSumForInvoice(invoice_no);
                IVRecord.balance = IVRecord.amount_charged - IVRecord.amount_paid;
            }
            loadInvoiceFromDB(IVRecord.Invoice_no);
            this.bindPage();
             }
             catch (Exception ex)
               {
                    throw ex;
                }
        }
        this.hCommand.Value = "";

    }


    protected bool checkCostVendorValid()
    {
        if (this.CostItemControl1.IsVendorValid)
        {
            return true;
        }
        else
        {
            string script = "<script language='javascript'>";
            script += "alert('Please choose vendor from list');";
            script += "</script>";
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", script);
            this.CostItemControl1.setFocusOnVendor(this.CostItemControl1.InvalidVendorListID);
            return false;
        }

    }


    protected string AcctIDFind(string AcctName)
    {
        string AccountNo = "";
        string sqlText = "select top 1 org_account_number from Organization where dba_name ='" + AcctName + "' and elt_account_number=" + elt_account_number;
        txttest.Text = AcctName.ToString();
        DataTable dt = new DataTable("Acct_table");
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
            AccountNo = dt.Rows[i]["org_account_number"].ToString();
        }

        return AccountNo;
    }




    private void PrepReportDS()
    {
        dsPDF = new DataSet("dSIVPDF");
        DataTable dt = IVMnager.getPrintIVDt(this.invoice_no);
        dt.TableName = "Invoice";
        dsPDF.Tables.Add(dt);
        dsPDF.Tables.Add(this.dtInvoiceHeaders);
        dsPDF.Tables.Add(this.dtIVHeaderDetails);
        dsPDF.Relations.Add(this.dtInvoiceHeaders.Columns["id"], dtIVHeaderDetails.Columns["pid"]);
    }

    public void PDFPrint()
    {
        PrepReportDS();
        try
        {
            rsm = new ReportSourceManager();
            rsm.LoadDataSet(dsPDF);
            rsm.LoadCompanyInfo(elt_account_number, Server.MapPath("../../ClientLogos/" + elt_account_number + ".jpg"));
            rsm.WriteXSD(Server.MapPath("../../CrystalReportResources/xsd/INVOICE.xsd"));
            rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/INVOICE.rpt"));
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Type", "application/pdf");
            Response.AddHeader("Content-disposition", "attachment;filename=invoice.pdf");
            MemoryStream oStream; // using System.IO
            oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.PortableDocFormat);
            Response.BinaryWrite(oStream.ToArray());
        }
        catch { }
        finally
        {
            rsm.CloseReportDocumnet();
            Response.Flush();
            Response.End();
        }
    }
    public ArrayList createAllAccountsJournalEntry(ArrayList chList, string tran_type)
    {
        ArrayList list = new ArrayList();
        //CREATEING AR ENTRY
        Decimal amount = 0;
        for (int i = 0; i < chList.Count; i++)
        {
            amount += ((ChargeItemRecord)chList[i]).Amount;
        }

        Decimal salesTax = Decimal.Parse(this.txtSalesTax.Text);
        Decimal agentProfit = Decimal.Parse(this.txtAgentProfit.Text);
        amount = amount - (salesTax + agentProfit);
        AllAccountsJournalRecord rec = new AllAccountsJournalRecord();
        rec.elt_account_number = Int32.Parse(elt_account_number);
        rec.gl_account_number = Int32.Parse(this.ddlARAcct.SelectedValue);
        rec.gl_account_name = this.ddlARAcct.SelectedItem.Text;
        rec.tran_num = invoice_no;
        rec.tran_type = tran_type;
        rec.tran_date = this.dInvoice.Text;
        rec.customer_number = Int32.Parse(this.hCustomerAcct.Value);
        rec.customer_name = this.lstCustomerName.Text;
        rec.memo = this.txtDescription.Text;
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
            rec.tran_type = tran_type;
            rec.tran_date = this.dInvoice.Text;
            rec.customer_number = Int32.Parse(this.hCustomerAcct.Value);
            rec.customer_name = this.lstCustomerName.Text;
            rec.memo = this.txtDescription.Text;
            rec.debit_amount = 0;
            rec.credit_amount = -((ChargeItemRecord)chList[i]).Amount;
            list.Add(rec);
        }
        //CREATING COST OF GOOD SOLD ENTRIES 
        amount = 0;
        if (Decimal.Parse(this.txtSalesTax.Text) != 0)
        {
            rec = new AllAccountsJournalRecord();
            rec.elt_account_number = Int32.Parse(elt_account_number);
            rec.gl_account_number = this.eltUserMgr.getDefaultCostOfGoodSold();
            rec.gl_account_name = glMgr.getGLDescription(rec.gl_account_number);
            rec.tran_num = invoice_no;
            rec.tran_type = tran_type;
            rec.tran_date = this.dInvoice.Text;
            rec.customer_number = this.customer_org_acct;
            rec.customer_name = this.lstCustomerName.Text;
            rec.memo = "SALES TAX";
            rec.debit_amount = Decimal.Parse(this.txtSalesTax.Text);
            rec.credit_amount = 0;
            list.Add(rec);
        }
        if (Decimal.Parse(this.txtAgentProfit.Text) != 0)
        {
            rec = new AllAccountsJournalRecord();
            rec.elt_account_number = Int32.Parse(elt_account_number);
            rec.gl_account_number = this.eltUserMgr.getDefaultCostOfGoodSold();
            rec.gl_account_name = glMgr.getGLDescription(rec.gl_account_number);
            rec.tran_num = invoice_no;
            rec.tran_type = tran_type;
            rec.tran_date = this.dInvoice.Text;
            rec.customer_number = this.customer_org_acct;
            rec.customer_name = this.lstCustomerName.Text;
            rec.memo = "AGENT PROFIT";
            rec.debit_amount = Decimal.Parse(this.txtAgentProfit.Text);
            rec.credit_amount = 0;
            list.Add(rec);
        }

        return list;
    }

    protected void btnSearchIV_Click()
    {
        string arriveNo = "";
        string arriv = "";
        arriveNo = txtSearchIVNO.Text.ToString();
        if (this.txtSearchIVNO.Text != "")
        {
            IVMnager.PreLoadInvoice(invoice_no);
            if (ddlNOlist.SelectedIndex == 0)
            {
                try{
                    invoice_no = Int32.Parse(txtSearchIVNO.Text);
                    loadInvoiceFromDB(invoice_no);
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
                    loadInvoiceFromDB(invoice_no);
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
                    loadInvoiceFromDB(invoice_no);
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

    }
    protected void loadInvoiceFromDB(int invoice_no)
    {
        if (invoice_no != 0)
        {
            string IV_TYPE = IVMnager.getInvoiceSource(invoice_no);
            //if (IV_TYPE == "INV")
            //{
            InvoiceRecord PrevIV = IVRecord;
            ARStatusManager arSMgr = new ARStatusManager(elt_account_number);
            ARLock = arSMgr.FindIfPaymentProcessed(invoice_no);
            IVRecord = IVMnager.getInvoiceRecord(invoice_no);

            hCustomerAcct.Value = IVRecord.Customer_Number.ToString();
            try
            {
                hConsigneeAcct.Value = AcctIDFind(IVRecord.consignee.ToString()).ToString();
                hShipperAcct.Value = AcctIDFind(IVRecord.shipper.ToString()).ToString();
            }
            catch
            {
            }
            customer_org_acct = IVRecord.Customer_Number;
            DataTable dt = IVMnager.getInvoiceChargesDs(invoice_no);
            DataTable dt2 = IVMnager.getInvoiceCostDs(invoice_no);
            if (dt.Rows.Count > 0)
            {
                ChargeItemControl1.bindFromIVChargeItemDataTable(dt, ARLock);
            }
            else
            {
                ChargeItemControl1.bindEmpty();
            }
            if (dt2.Rows.Count > 0)
            {
                CostItemControl1.bindFromIVCostItemDataTable(dt2);
            }
            else
            {
                CostItemControl1.bindEmpty();
            }
            if (IVRecord.Invoice_no != 0)
            {
                Session["IVRecord"] = IVRecord;
                bindPage();

                if (IVRecord.is_deleted)
                {
                    disableControls();
                }
            }
            else
            {
                IVRecord = PrevIV;
                string script = "<script language='javascript'>";
                script += "alert('No such invoice exists');";
                script += "</script>";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", script);
            }

        }
        Session["IVRecord"] = IVRecord;
        this.txtSearchIVNO.Text = "";
    }

//added by stanley on 12/13/2007

    string findINVNoBYMAWB(string searchNo)
    {
        string Search_no = "";
        string sqlText = " SELECT top 1 invoice_no from invoice where elt_account_number="
             + elt_account_number + " and isnull(air_ocean,'') = '' and mawb_num='" + searchNo + "'";
        DataTable dt = new DataTable("INV_MAWB_title");
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


    string findINVNoBYHAWB(string searchNo)
    {
        string Search_no = "";
        string sqlText = " SELECT top 1 invoice_no from invoice where elt_account_number="
            + elt_account_number + " and isnull(air_ocean,'') = '' and hawb_num='" + searchNo + "'";
        DataTable dt = new DataTable("INV_HAWB_title");
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




    protected void disableControls()
    {
        this.txtAirlineSteamShip.Enabled = false;
        this.txtChargeWeight.Enabled = false;
        this.txtCustomerInfo.Enabled = false;
        this.txtCustomerNo.Enabled = false;
        this.txtDescription.Enabled = false;
        this.txtDestination.Enabled = false;
        this.dEntry.Enabled = false;
        this.txtEntryNo.Enabled = false;
        this.txtFileNo.Enabled = false;
        this.txtGrossWeight.Enabled = false;
        this.txtHoutBillNo.Enabled = false;
        this.dInvoice.Enabled = false;
        this.txtInvoice_no.Enabled = false;
        this.txtMasterBillNo.Enabled = false;
        this.txtOrigin.Enabled = false;
        this.txtPieces.Enabled = false;
        this.txtRefNo.Enabled = false;
        this.txtTerm.Enabled = false;
        this.txtAgentProfit.Enabled = false;
        // this.txtTotalCharge.Enabled = false;
        this.txtTotal.Enabled = false;
        this.txtSalesTax.Enabled = false;
        this.lstConsigneeName.Enabled = false;
        this.lstCustomerName.Enabled = false;
        this.lstShipperName.Enabled = false;
        this.ddlARAcct.Enabled = false;
        this.btnSaveUp.Visible = false;
        this.btnDelete.Visible = false;
        this.btnSaveNew.Visible = false;
        this.btnSaveDown.Visible = false;
        ChargeItemControl1.Enabled = false;
        CostItemControl1.Enabled = false;
    }
    protected void enableControls()
    {
        this.txtAirlineSteamShip.Enabled = true;
        this.txtChargeWeight.Enabled = true;
        this.txtCustomerInfo.Enabled = true;
        this.txtCustomerNo.Enabled = true;
        this.txtDescription.Enabled = true;
        this.txtDestination.Enabled = true;
        this.dEntry.Enabled = true;
        this.txtEntryNo.Enabled = true;
        this.txtFileNo.Enabled = true;
        this.txtGrossWeight.Enabled = true;
        this.txtHoutBillNo.Enabled = true;
        this.dInvoice.Enabled = true;
        this.txtInvoice_no.Enabled = true;
        this.txtMasterBillNo.Enabled = true;
        this.txtOrigin.Enabled = true;
        this.txtPieces.Enabled = true;
        this.txtRefNo.Enabled = true;
        this.txtTerm.Enabled = true;
        this.txtAgentProfit.Enabled = true;
        this.txtTotal.Enabled = true;
        this.txtSalesTax.Enabled = true;
        this.lstConsigneeName.Enabled = true;
        this.lstCustomerName.Enabled = true;
        this.lstShipperName.Enabled = true;
        this.ddlARAcct.Enabled = true;
        this.btnSaveUp.Visible = true;
        this.btnDelete.Visible = true;
        this.btnSaveNew.Visible = true;
        this.btnSaveDown.Visible = true;
        ChargeItemControl1.Enabled = true;
        CostItemControl1.Enabled = true;
    }
    #region Bind Page variables from IVRecord

    protected void bindPage()
    {
        IVRecord = (InvoiceRecord)Session["IVRecord"];
        this.txtAirlineSteamShip.Text = IVRecord.Carrier;
        string[] tmp;
        IVRecord.Arrival_Dept.Replace("--", "-");
        tmp = IVRecord.Arrival_Dept.Split('-');
        try
        {
            this.dArrival.Text = tmp[0];
            this.dDeparture.Text = tmp[2];
        }
        catch { }
        this.dDueDate.Text = DateTime.Parse(IVRecord.invoice_date).AddDays(IVRecord.term_curr).ToShortDateString();

        this.txtChargeWeight.Text = IVRecord.Total_Charge_Weight.ToString();
        this.txtCustomerInfo.Text = IVRecord.Customer_info;
        this.txtCustomerNo.Text = IVRecord.Customer_Number.ToString();
        this.txtDescription.Text = IVRecord.Description;
        this.txtDestination.Text = IVRecord.dest;

        if (IVRecord.entry_date != "" || IVRecord.entry_date != null)
        {
            this.dEntry.Text = String.Format("{0:dd/MM/yyyy}", IVRecord.entry_date);
        }

        this.txtEntryNo.Text = IVRecord.entry_no;
        this.txtFileNo.Text = IVRecord.ref_no_Our;
        this.txtGrossWeight.Text = IVRecord.Total_Gross_Weight.ToString();
        this.txtHoutBillNo.Text = IVRecord.hawb_num;
        this.dInvoice.Text = String.Format("{0:dd/MM/yyyy}", IVRecord.invoice_date);
        this.txtInvoice_no.Text = IVRecord.Invoice_no.ToString();
        this.txtMasterBillNo.Text = IVRecord.mawb_num;
        this.txtOrigin.Text = IVRecord.origin;
        this.txtPieces.Text = IVRecord.Total_Pieces.ToString();
        this.txtRefNo.Text = IVRecord.ref_no;
        this.txtTerm.Text = IVRecord.term_curr.ToString();
        this.txtAgentProfit.Text = IVRecord.agent_profit.ToString();
        this.txtTotal.Text = IVRecord.subtotal.ToString();
        this.txtSalesTax.Text = IVRecord.sale_tax.ToString();
        this.lstConsigneeName.Text = IVRecord.consignee;
        this.lstCustomerName.Text = IVRecord.Customer_Name;
        this.lstShipperName.Text = IVRecord.shipper;
        this.ddlARAcct.SelectedValue = IVRecord.accounts_receivable.ToString();
        this.txtInternalMemo.Text = IVRecord.in_memo;
        this.txtRemarks.Text = IVRecord.remarks;

        if (ARLock)
        {
            this.lblARLock.Visible = true;

        }
        else
        {
            this.lblARLock.Visible = false;
        }

    }

    protected void bindEmptyPage()
    {
        this.txtAirlineSteamShip.Text = "";
        this.dDeparture.Text = "";
        this.dArrival.Text = "";
        this.txtChargeWeight.Text = "";
        this.txtCustomerInfo.Text = "";
        this.txtCustomerNo.Text = "";
        this.txtDescription.Text = "";
        this.txtDestination.Text = "";
        this.dEntry.Text = "";
        this.txtEntryNo.Text = "";
        this.txtFileNo.Text = "";
        this.txtGrossWeight.Text = "";
        this.txtHoutBillNo.Text = "";
        this.dInvoice.Text = "";
        this.txtInvoice_no.Text = "";
        this.txtMasterBillNo.Text = "";
        this.txtOrigin.Text = "";
        this.txtPieces.Text = "";
        this.txtRefNo.Text = "";
        this.txtTerm.Text = "";
        this.txtAgentProfit.Text = "0.00";
        //this.txtTotalCharge.Text = "0.00";
        this.txtTotal.Text = "0.00";
        this.txtSalesTax.Text = "0.00";
        this.lstConsigneeName.Text = "";
        this.lstCustomerName.Text = "";
        this.lstShipperName.Text = "";
        this.ddlARAcct.SelectedIndex = 0;
        this.lstCustomerName.Text = "";
        this.txtCustomerInfo.Text = "";
        this.txtRemarks.Text = "";
        this.txtInternalMemo.Text = "";

        ChargeItemControl1.bindEmpty();
        CostItemControl1.bindEmpty();

    }

    #endregion



    #region Get general info from screen and bind to the IVRecord

    protected void getGeneralInfoFromScreen()
    {
        IVRecord = (InvoiceRecord)Session["IVRecord"];
        if (IVRecord == null)
        {
            IVRecord = new InvoiceRecord();
        }


        IVRecord.agent_profit = Decimal.Parse(this.txtAgentProfit.Text);
        IVRecord.Carrier = this.txtAirlineSteamShip.Text;
        IVRecord.Arrival_Dept = this.dArrival.Text + "--" + this.dDeparture.Text;
        IVRecord.Customer_info = this.txtCustomerInfo.Text;
        IVRecord.Customer_Number = Int32.Parse(this.hCustomerAcct.Value);
        IVRecord.Description = this.txtDescription.Text;
        IVRecord.dest = this.txtDestination.Text;

        IVRecord.entry_date = this.dEntry.Text;
        if (IVRecord.entry_date == "")
        {
            IVRecord.entry_date = null;
        }
        IVRecord.entry_no = this.txtEntryNo.Text;
        IVRecord.ref_no_Our = this.txtFileNo.Text;
        IVRecord.hawb_num = this.txtHoutBillNo.Text;
        IVRecord.accounts_receivable = Int32.Parse(this.ddlARAcct.SelectedValue);

        if (this.dInvoice.Text == "")
        {
            this.dInvoice.Text = DateTime.Today.ToShortDateString();
        }
        IVRecord.invoice_date = String.Format("{0:dd/MM/yyyy}", this.dInvoice.Text);

        try
        {
            IVRecord.Total_Charge_Weight = this.txtChargeWeight.Text;
        }
        catch
        {
            IVRecord.Total_Charge_Weight = "0";
        }

        try
        {
            IVRecord.Total_Gross_Weight = this.txtGrossWeight.Text;
        }
        catch
        {
            IVRecord.Total_Gross_Weight = "0";
        }

        try
        {
            IVRecord.Invoice_no = Int32.Parse(this.txtInvoice_no.Text);
        }
        catch
        {
            IVRecord.Invoice_no = 0;
        }
        IVRecord.mawb_num = this.txtMasterBillNo.Text;
        IVRecord.origin = this.txtOrigin.Text;

        try
        {
            IVRecord.Total_Pieces = this.txtPieces.Text;
        }
        catch
        {
            IVRecord.Total_Pieces = "0";
        }
        IVRecord.ref_no = this.txtRefNo.Text;
        try
        {
            if (IVRecord.term_curr == 0)
            {
                TimeSpan span;
                DateTime start = DateTime.Parse(dInvoice.Text);
                DateTime end = DateTime.Parse(dDueDate.Text);
                span = end.Subtract(start);
                IVRecord.term_curr = span.Days;
            }
        }
        catch { }

        if (IVRecord.term_curr == 0)
        {
            try
            {
                IVRecord.term_curr = Int32.Parse(this.txtTerm.Text);
            }
            catch
            {
                IVRecord.term_curr = 0;
            }
        }
        try
        {
            IVRecord.sale_tax = Decimal.Parse(this.txtSalesTax.Text);
        }
        catch
        {
            IVRecord.sale_tax = 0;
        }
        IVRecord.consignee = (this.lstConsigneeName.Text);
        IVRecord.Customer_Name = this.lstCustomerName.Text;
        IVRecord.shipper = this.lstShipperName.Text;
        IVRecord.invoice_type = "I";
        IVRecord.remarks = this.txtRemarks.Text;
        IVRecord.in_memo = this.txtInternalMemo.Text;

        Session["IVRecord"] = IVRecord;
    }

    protected DataTable createInvoiceHeaderDt()
    {
        DataTable dt = new DataTable();
        dt.TableName = "IVHeaders";
        dt.Columns.Add(new DataColumn("id", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("auto_id", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("elt_account_number", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("invoice_no", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("mawb", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("hawb", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("ETA", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("ETD", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("Consignee", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("Shipper", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("FILE_NO", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("GrossWeight", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("ChargeableWeight", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("Pieces", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("unit", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("Origin", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("Destination", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("Carrier", System.Type.GetType("System.String")));
        return dt;
    }


    protected DataTable createInvoiceHeaderDetailDt()
    {
        DataTable dt = new DataTable();
        dt.TableName = "IVHeaderDetails";
        dt.Columns.Add(new DataColumn("pid", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("item_no", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("description", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("amount", System.Type.GetType("System.String")));
        return dt;
    }

    protected void prepareHeaders()
    {
        getInvoiceHeaders();

        ArrayList list = new ArrayList();
        dtIVHeaderDetails = createInvoiceHeaderDetailDt();
        DataTable newTable = dtInvoiceHeaders.Copy();
        newTable.Clear();
        newTable.TableName = "IVHeaders";

        try
        {
            if (dtInvoiceHeaders.Rows.Count > 0)
            {
                if (dtInvoiceHeaders.Rows[0]["hawb"] != "CONSOLIDATION")
                {
                    createSingleHeader(ref newTable, ref list, ref dtIVHeaderDetails);
                }
                else
                {
                    for (int k = 0; k < dtInvoiceHeaders.Rows.Count; k++)
                    {

                        //----------parent table for printing------------
                        DataRow dr_parent = newTable.NewRow();

                        dr_parent["id"] = k;
                        dr_parent["mawb"] = dtInvoiceHeaders.Rows[k]["mawb"];
                        dr_parent["hawb"] = dtInvoiceHeaders.Rows[k]["hawb"];
                        dr_parent["eta"] = dtInvoiceHeaders.Rows[k]["eta"];
                        dr_parent["etd"] = dtInvoiceHeaders.Rows[k]["etd"];
                        dr_parent["consignee"] = dtInvoiceHeaders.Rows[k]["consignee"];
                        dr_parent["shipper"] = dtInvoiceHeaders.Rows[k]["shipper"];
                        dr_parent["file_no"] = dtInvoiceHeaders.Rows[k]["file_no"];
                        dr_parent["grossweight"] = dtInvoiceHeaders.Rows[k]["grossweight"];
                        dr_parent["chargeableweight"] = dtInvoiceHeaders.Rows[k]["chargeableweight"];
                        dr_parent["pieces"] = dtInvoiceHeaders.Rows[k]["pieces"];
                        dr_parent["unit"] = dtInvoiceHeaders.Rows[k]["unit"];
                        dr_parent["origin"] = dtInvoiceHeaders.Rows[k]["origin"];
                        dr_parent["destination"] = dtInvoiceHeaders.Rows[k]["destination"];
                        dr_parent["carrier"] = dtInvoiceHeaders.Rows[k]["carrier"];
                        newTable.Rows.Add(dr_parent);

                        IVHeaderRecord IVH = new IVHeaderRecord();
                        try
                        {
                            IVH.invoice_no = this.txtInvoice_no.Text;
                            IVH.mawb = dtInvoiceHeaders.Rows[k]["mawb"].ToString();
                            IVH.hawb = dtInvoiceHeaders.Rows[k]["hawb"].ToString();
                            IVH.ETA = dtInvoiceHeaders.Rows[k]["ETA"].ToString();
                            IVH.ETD = dtInvoiceHeaders.Rows[k]["ETD"].ToString();
                            IVH.Consignee = dtInvoiceHeaders.Rows[k]["Consignee"].ToString();
                            IVH.Shipper = dtInvoiceHeaders.Rows[k]["Shipper"].ToString();
                            IVH.FILE = dtInvoiceHeaders.Rows[k]["FILE_NO"].ToString();
                            IVH.GrossWeight = dtInvoiceHeaders.Rows[k]["GrossWeight"].ToString();
                            IVH.ChargeableWeight = dtInvoiceHeaders.Rows[k]["ChargeableWeight"].ToString();
                            IVH.Pieces = dtInvoiceHeaders.Rows[k]["Pieces"].ToString();
                            IVH.Shipper = dtInvoiceHeaders.Rows[k]["unit"].ToString();
                            IVH.Origin = dtInvoiceHeaders.Rows[k]["Origin"].ToString();
                            IVH.Destination = dtInvoiceHeaders.Rows[k]["Destination"].ToString();
                            IVH.Carrier = dtInvoiceHeaders.Rows[k]["Carrier"].ToString();
                        }
                        catch (Exception ex) { throw ex; }

                        list.Add(IVH);//list is for DB store and Dt is for printing 

                    }

                    for (int i = 0; i < IVRecord.ChargeItemList.Count; i++)
                    {
                        for (int k = 0; k < this.dtInvoiceHeaders.Rows.Count; k++)
                        {
                            if (((IVChargeItemRecord)IVRecord.ChargeItemList[i]).Mb_no == dtInvoiceHeaders.Rows[k]["mawb"].ToString()
                                && ((IVChargeItemRecord)IVRecord.ChargeItemList[i]).Hb_no == dtInvoiceHeaders.Rows[k]["hawb"].ToString())
                            {
                                //----------Child Table For Printing------------- 
                                DataRow dr = dtIVHeaderDetails.NewRow();
                                dr["pid"] = k;
                                dr["item_no"] = ((IVChargeItemRecord)IVRecord.ChargeItemList[i]).Item_no;
                                dr["description"] = ((IVChargeItemRecord)IVRecord.ChargeItemList[i]).Item_desc;
                                dr["amount"] = ((IVChargeItemRecord)IVRecord.ChargeItemList[i]).Charge_amount;
                                dtIVHeaderDetails.Rows.Add(dr);
                            }
                        }
                    }
                }
            }
            else
            {
                createSingleHeader(ref newTable, ref list, ref dtIVHeaderDetails);
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        this.dtInvoiceHeaders = newTable;
        IVRecord.InvoiceHeaders = list;
    }

    protected void createSingleHeader(ref DataTable newTable, ref ArrayList list, ref DataTable dtIVHeaderDetails)
    {
        DataRow dr_parent = newTable.NewRow();

        dr_parent["id"] = 0;
        dr_parent["mawb"] = this.txtMasterBillNo.Text;
        dr_parent["hawb"] = this.txtHoutBillNo.Text;
        dr_parent["eta"] = this.dArrival.Text;
        dr_parent["etd"] = this.dDeparture.Text;
        dr_parent["consignee"] = this.lstConsigneeName.Text;
        dr_parent["shipper"] = this.lstShipperName.Text;
        dr_parent["file_no"] = this.txtFileNo.Text;
        dr_parent["grossweight"] = this.txtGrossWeight.Text;
        dr_parent["chargeableweight"] = this.txtChargeWeight.Text;
        dr_parent["pieces"] = this.txtPieces.Text;
        dr_parent["unit"] = "";
        dr_parent["origin"] = this.txtOrigin.Text;
        dr_parent["destination"] = this.txtDestination.Text;
        dr_parent["carrier"] = txtAirlineSteamShip.Text;
        newTable.Rows.Add(dr_parent);

        IVHeaderRecord IVH = new IVHeaderRecord();

        try
        {

            IVH.invoice_no = this.txtInvoice_no.Text;
            IVH.mawb = newTable.Rows[0]["mawb"].ToString();
            IVH.hawb = newTable.Rows[0]["hawb"].ToString();
            IVH.ETA = newTable.Rows[0]["ETA"].ToString();
            IVH.ETD = newTable.Rows[0]["ETD"].ToString();
            IVH.Consignee = newTable.Rows[0]["Consignee"].ToString();
            IVH.Shipper = newTable.Rows[0]["Shipper"].ToString();
            IVH.FILE = newTable.Rows[0]["FILE_NO"].ToString();
            IVH.GrossWeight = newTable.Rows[0]["GrossWeight"].ToString();
            IVH.ChargeableWeight = newTable.Rows[0]["ChargeableWeight"].ToString();
            IVH.Pieces = newTable.Rows[0]["Pieces"].ToString();
            IVH.Shipper = newTable.Rows[0]["unit"].ToString();
            IVH.Origin = newTable.Rows[0]["Origin"].ToString();
            IVH.Destination = newTable.Rows[0]["Destination"].ToString();
            IVH.Carrier = newTable.Rows[0]["Carrier"].ToString();
        }
        catch (Exception ex) { throw ex; }
        list.Add(IVH);//list is for DB store and Dt is for printing

        for (int i = 0; i < IVRecord.ChargeItemList.Count; i++)
        {

            //----------Child Table For Printing------------- 
            DataRow dr = dtIVHeaderDetails.NewRow();
            dr["pid"] = 0;
            dr["item_no"] = ((IVChargeItemRecord)IVRecord.ChargeItemList[i]).Item_no;
            dr["description"] = ((IVChargeItemRecord)IVRecord.ChargeItemList[i]).Item_desc;
            dr["amount"] = ((IVChargeItemRecord)IVRecord.ChargeItemList[i]).Charge_amount;
            dtIVHeaderDetails.Rows.Add(dr);

        }

    }

    protected void getInvoiceHeaders()
    {
        DataTable dt;
        if (listSelected != null)
        {
            dt = createInvoiceHeaderDt();
            if (listSelected != null)
            {
                for (int i = 0; i < listSelected.Count; i++)
                {
                    dt.Rows.Add(dt.NewRow());
                    try
                    {
                        dt.Rows[i]["invoice_no"] = this.invoice_no;
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                    dt.Rows[i]["id"] = i;
                    dt.Rows[i]["mawb"] = ((IVQRecord)listSelected[i]).Mawb_num;
                    dt.Rows[i]["hawb"] = ((IVQRecord)listSelected[i]).Hawb_num;
                    dt.Rows[i]["ETA"] = ((IVQRecord)listSelected[i]).ETA;
                    dt.Rows[i]["ETD"] = ((IVQRecord)listSelected[i]).ETD;
                    dt.Rows[i]["Consignee"] = ((IVQRecord)listSelected[i]).Consignee;
                    dt.Rows[i]["Shipper"] = ((IVQRecord)listSelected[i]).Shipper;
                    dt.Rows[i]["FILE_NO"] = ((IVQRecord)listSelected[i]).FileNo;
                    dt.Rows[i]["GrossWeight"] = ((IVQRecord)listSelected[i]).Gross_weight.ToString();
                    dt.Rows[i]["ChargeableWeight"] = ((IVQRecord)listSelected[i]).Chargeable_weight.ToString();
                    dt.Rows[i]["Pieces"] = ((IVQRecord)listSelected[i]).Pieces.ToString();
                    dt.Rows[i]["unit"] = ((IVQRecord)listSelected[i]).Pieces.ToString();
                    dt.Rows[i]["Origin"] = ((IVQRecord)listSelected[i]).origin;
                    dt.Rows[i]["Destination"] = ((IVQRecord)listSelected[i]).destination;
                    dt.Rows[i]["Carrier"] = ((IVQRecord)listSelected[i]).carrier;
                }
            }
        }
        else
        {
            dt = IVMnager.getInvoiceHeadersDT(this.invoice_no);
        }
        gUtil.removeNull(ref dt);
        this.dtInvoiceHeaders = dt;
        dtInvoiceHeaders.TableName = "IVHeaders";
    }



    #endregion


}
