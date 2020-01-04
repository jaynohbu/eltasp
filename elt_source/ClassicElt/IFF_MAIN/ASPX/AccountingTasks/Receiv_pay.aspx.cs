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

public partial class ASPX_AccountingTasks_Receiv_pay : System.Web.UI.Page
{

    private string elt_account_number;
    public string user_id, login_name, user_right;
    protected string ConnectStr;
    private PaymentRecord pRec;
    private ArrayList BankAccountList;
 
    private GLManager glMgr;
    private InvoiceManager IVMgr;
    private CustomerCreditManager ccMgr;
    private PaymentManager pMgr;
    private PaymentDetailManager pdMger;
    private DataTable dtPaymentDetailList;
    private int payment_no;
    string cmd;
    private int vendor_acct;
    private Decimal credit_used;
    private Decimal credit_added;

    protected void Page_Load(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        pdMger = new PaymentDetailManager(elt_account_number);
        pMgr = new PaymentManager(elt_account_number);
        IVMgr = new InvoiceManager(elt_account_number);
        ccMgr = new CustomerCreditManager(elt_account_number);
        btnSearch.Attributes.Add("onclick", "SearchClick()");
        btnSaveUpper.Attributes.Add("onclick", "SaveClick()");
        btnSaveDown.Attributes.Add("onclick", "SaveClick()");
        btnCancel.Attributes.Add("onclick", "CancelClick()");
        btnCancel.Visible = false;
        cmd = hMainCommand.Value;
        if (this.dDate.Text == "")
        {
            this.dDate.Text = DateTime.Today.ToShortDateString();
        }
        try
        {
            this.payment_no = Int32.Parse(Request.QueryString["PaymentNo"]);
            if (cmd != "CANCEL")
            {
                cmd = "SEARCH";
            }
            //this.txtSearch.Text = payment_no.ToString();
            this.hPaymentNo.Value = payment_no.ToString();
        }
        catch
        {
            payment_no = 0;
        }
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());
        glMgr = new GLManager(elt_account_number);
        BankAccountList = glMgr.getGLAcctList(Account.BANK);        
        ARControl1.setParentControl(txtAcctBalance);
        ARControl1.setParentControl(txtAmtReceiving);
        ARControl1.setParentControl(dDate);
        ARControl1.setParentControl(ddlBankAcct);
        ARControl1.setParentControl(ddlPaymethod);
        cApplyCredit.Attributes.Add("onclick", "applyCredit(this)");
        this.txtSearch.Attributes.Add("onfocus", "clearSearch(this)");
        this.txtAmtReceiving.Attributes.Add("onblur", "formatNumber(this)");
        ((GridView)this.ARControl1.FindControl("GridViewARItem")).Enabled = true;

        this.btnSaveDown.Visible = true;
        this.btnSaveUpper.Visible = true;
        this.sToBePrint.Visible = true;
        this.cApplyCredit.Visible = true;

        for (int i = 0; i < BankAccountList.Count; i++)
        {
            hBankBalance.Value += ((GLRecord)BankAccountList[i]).Gl_account_balance + "^^";
        }
        txtAmtReceiving.Attributes.Add("onchange", "amountReceivingChange()");
        ddlBankAcct.Attributes.Add("onchange", "bankChange(this)");
        if (!IsPostBack)
        {
            ddlBankAcct.DataSource = BankAccountList;
            ddlBankAcct.DataTextField = "Gl_account_desc";
            ddlBankAcct.DataValueField = "Gl_account_number";
            ddlBankAcct.DataBind();
            txtAcctBalance.Text = ((GLRecord)BankAccountList[0]).Gl_account_balance.ToString();
            Page.DataBind();
            if (cmd == "SEARCH")
            {
                SearchClick();
            }
        }
        else
        {
            if (Request["postfromInside"] == "yes")
            {
                ddlBankAcct.DataSource = BankAccountList;
                ddlBankAcct.DataTextField = "Gl_account_desc";
                ddlBankAcct.DataValueField = "Gl_account_number";
                ddlBankAcct.DataBind();
                txtAcctBalance.Text = ((GLRecord)BankAccountList[0]).Gl_account_balance.ToString();
            }
            txtAmtToPayNow.Text = Request[txtAmtToPayNow.UniqueID];
            txtAmtAnapplied.Text = Request[txtAmtAnapplied.UniqueID];
            if (cmd == "SAVE")
            {
                if (Decimal.Parse(this.txtAmtToPayNow.Text) != 0)
                {
                    SaveClick();
                }
            }
            if (cmd == "VENDOR_CHANGE")
            {
                vendor_acct = Int32.Parse(hVendorAcct.Value);
                getARListForVendor();
            }
            if (cmd == "CANCEL")
            {
                CancelClick();
            }
            if (cmd == "SEARCH")
            {
                SearchClick();
            }
        }
        hMainCommand.Value = "";
    }
    protected void getARListForVendor()
    {
        if (vendor_acct != 0)
        {
            DataTable dt = IVMgr.getInvoiceListForCustomer(vendor_acct);
            lstVendorName.Text = Request[lstVendorName.UniqueID];
            hVendorAcct.Value = vendor_acct.ToString();
            txtCreditRemain.Text = ccMgr.getcustomerCredit(vendor_acct).ToString();
            hCreditRemainedOriginal.Value = txtCreditRemain.Text;
            ARControl1.reBind_BillChangesToGrid(dt);
        }
        else
        {
            try
            {
                vendor_acct = Int32.Parse(Session["vendor_acct"].ToString());
                DataTable dt = IVMgr.getInvoiceListForCustomer(vendor_acct);
                lstVendorName.Text = Request[lstVendorName.UniqueID];
                hVendorAcct.Value = vendor_acct.ToString();
                txtCreditRemain.Text = ccMgr.getcustomerCredit(vendor_acct).ToString();
                ARControl1.reBind_BillChangesToGrid(dt);
            }
            catch
            {
                vendor_acct = 0;
            }

        }
    }

    protected ArrayList createAllAccountsJournalEntry(ArrayList pdList)
    {
        ArrayList list = new ArrayList();
        GLRecord glRec = glMgr.getDefaultARAccount();
        if (pdList.Count > 0)
        {
            try
            {
                //CREATEING AR ENTRY----------> AR decreases 
                Decimal amount = 0;
                for (int i = 0; i < pdList.Count; i++)
                {
                    amount += ((PaymentDetailRecord)pdList[i]).payment;
                }
                AllAccountsJournalRecord rec = new AllAccountsJournalRecord();
                rec.elt_account_number = Int32.Parse(elt_account_number);
                rec.gl_account_number = glRec.Gl_account_number;
                rec.gl_account_name = glRec.Gl_account_desc;

                // rec.tran_num = payment_no;
                rec.tran_type = "PMT";
                rec.tran_date = dDate.Text;
                rec.customer_number = Int32.Parse(hVendorAcct.Value);
                rec.customer_name = lstVendorName.Text;
                rec.memo = txtRefCheck.Text;
                rec.debit_amount = 0;
                rec.credit_amount = -amount;
                list.Add(rec);

                //CREATEING BANK DEPOSIT ENTRY------->BANK DEPOSIT increases as much it receives (even if it is 0)
                AllAccountsJournalRecord rec2 = new AllAccountsJournalRecord();
                rec2.elt_account_number = Int32.Parse(elt_account_number);
                rec2.gl_account_number = Int32.Parse(ddlBankAcct.SelectedValue);
                rec2.gl_account_name = ddlBankAcct.SelectedItem.Text;
                // rec.tran_num = payment_no;
                rec2.tran_type = "PMT";
                rec2.tran_date = dDate.Text;
                rec2.customer_number = Int32.Parse(hVendorAcct.Value);
                rec2.customer_name = lstVendorName.Text;
                rec2.memo = txtRefCheck.Text;
                rec2.debit_amount = Decimal.Parse(txtAmtReceiving.Text);
                rec2.credit_amount = 0;
                list.Add(rec2);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        return list;
    }
 
    protected void SearchClick()
    {

        if (payment_no != 0)
        {
            pRec = pMgr.getcustomerPaymentRecord(payment_no);
        }
        else
        {
            pRec = pMgr.getcustomerPaymentRecordByRefCheck(this.txtSearch.Text);
        }
        if (pRec.payment_no != 0)
        {
            dtPaymentDetailList = pdMger.getPaymentDetailListDt(payment_no);

            bindPage();
        }
        else
        {
        }
    }

    protected void resetPage()
    {
        dDate.Text = DateTime.Today.ToShortDateString();
        cApplyCredit.Checked = false;
        txtAmtToPayNow.Text = "0.00";
        txtAmtReceiving.Text = "0.00";
        lstVendorName.Text = "";
        hVendorAcct.Value = "";
        txtAmtAnapplied.Text = "0.00";
        btnCancel.Visible = false;
        lblCreditRemaining.Visible = true;
        lblUnappliedAmount.Visible = true;
        txtAmtAnapplied.Visible = true;
        txtCreditRemain.Visible = true;
        lblAmountReceiving.Text = "Amount receiving";
        lblAmountToPayNow.Text = "Amount to pay now";
        ((GridView)ARControl1.FindControl("GridViewARItem")).Enabled = true;
        ARControl1.Clear();
        hPaymentNo.Value = "0";
        this.txtSearch.Text = "";
    }
   
    protected void SaveClick()
    {

        GLRecord glRec3 = glMgr.getDefaultCustomerCreditAcct();
        GLRecord glRec2 = glMgr.getDefaultRetainedEarningAcct();

        if (dDate.Text == "" || dDate.Text == null)
        {
            dDate.Text = DateTime.Today.ToShortDateString();
        }
        ARControl1.getValuesFromGrid();
        pRec = new PaymentRecord();
        pRec.InvoiceList = ARControl1.InvoiceList;
        pRec.PaymentDetailList = ARControl1.PaymentDetailList;
        pRec.AllAccountsJournalList = createAllAccountsJournalEntry(pRec.PaymentDetailList);
        pRec.payment_date = dDate.Text;
        string checkit = txtAmtToPayNow.Text;
        pRec.pmt_method = ddlPaymethod.SelectedValue;
        pRec.received_amt = Decimal.Parse(txtAmtReceiving.Text);
        pRec.customer_name = lstVendorName.Text;
        pRec.customer_number = Int32.Parse(hVendorAcct.Value.ToString());

        pRec.existing_credits = Decimal.Parse(txtCreditRemain.Text);//CUSTOMER CREDIT 에서 감소 WHEN cApplyCredit.Checked

        pRec.payment_date = dDate.Text;
        pRec.unapplied_amt = Decimal.Parse(txtAmtAnapplied.Text);////CUSTOMER CREDIT 에 증가       
        pRec.accounts_receivable = glMgr.getDefaultARAccount().Gl_account_number;
        pRec.balance = pRec.balance - Decimal.Parse(txtAmtToPayNow.Text);
        //added amonut  
        if (cApplyCredit.Checked)
        {
            pRec.added_amt = Decimal.Parse(txtAmtAnapplied.Text) - Decimal.Parse(txtCreditRemain.Text);
            // if (pRec.added_amt < 0) pRec.added_amt = 0;
        }
        else
        {
            pRec.added_amt = Decimal.Parse(txtAmtAnapplied.Text);
        }

        pRec.deposit_to = Int32.Parse(ddlBankAcct.SelectedValue);
        string tran_type = "PMT";
        if (pMgr.insertPaymentRecord(ref pRec, tran_type))
        {
            //CUSTOMER CREDIT CALCULATEION 
            CustomerCreditManager ccMgr = new CustomerCreditManager(elt_account_number);
            if (cApplyCredit.Checked)
            {
                //remove current credit
                customerCreditRecord ccRec = new customerCreditRecord();
                ccRec.credit = -Decimal.Parse(txtCreditRemain.Text);
                ccRec.customer_no = Int32.Parse(hVendorAcct.Value);
                ccRec.memo = "credit used amount from receive payment," + pRec.payment_no.ToString() + "";
                ccRec.tran_date = dDate.Text;

                //CREATEING Liability Entity for -> Customer Credit decreases when credit is used  

                Decimal decAmt = Decimal.Parse(this.txtCreditRemain.Text);
                ArrayList list2 = new ArrayList();

                AllAccountsJournalRecord rec4 = new AllAccountsJournalRecord();
                rec4.elt_account_number = Int32.Parse(elt_account_number);
                rec4.gl_account_number = glRec3.Gl_account_number;
                rec4.gl_account_name = glRec3.Gl_account_desc;

                rec4.tran_num = pRec.payment_no;
                rec4.tran_type = "PMT";
                rec4.tran_date = dDate.Text;
                rec4.customer_number = Int32.Parse(hVendorAcct.Value);
                rec4.customer_name = this.lstVendorName.Text;
                rec4.debit_amount = decAmt;
                rec4.credit_amount = 0;
                list2.Add(rec4);

                ccRec.all_accounts_journal_list = list2;
                ccMgr.insert_customer_credit(ccRec);
            }
            //customer credit reset
            customerCreditRecord ccRec2 = new customerCreditRecord();
            ccRec2.credit = Decimal.Parse(txtAmtAnapplied.Text);
            ccRec2.customer_no = Int32.Parse(hVendorAcct.Value);
            ccRec2.memo = "credit added amount from receive payment," + pRec.payment_no.ToString() + "";
            ccRec2.tran_date = dDate.Text;

            ArrayList list = new ArrayList();


            if (Decimal.Parse(this.txtAmtAnapplied.Text) > 0)
            {
                //CREATEING Liability Entity -> Customer Credit increases when there is a left over 
                Decimal incAmt = Decimal.Parse(this.txtAmtAnapplied.Text);
                AllAccountsJournalRecord rec3 = new AllAccountsJournalRecord();
                rec3.elt_account_number = Int32.Parse(elt_account_number);
                rec3.gl_account_number = glRec3.Gl_account_number;
                rec3.gl_account_name = glRec3.Gl_account_desc;

                rec3.tran_num = pRec.payment_no;
                rec3.tran_type = "PMT";
                rec3.tran_date = dDate.Text;
                rec3.customer_number = Int32.Parse(hVendorAcct.Value);
                rec3.customer_name = this.lstVendorName.Text;
                rec3.memo = "EXCESS PAYMENT";
                rec3.debit_amount = 0;
                rec3.credit_amount = -incAmt;
                list.Add(rec3);

            }
            ccRec2.all_accounts_journal_list = list;
            ccMgr.insert_customer_credit(ccRec2);
            Session["vendor_acct"] = hVendorAcct.Value;
            resetPage();
            getARListForVendor();
        }
        else
        {
            ARControl1.reBind_BillChangesToGrid(((DataTable)Session["dtPaymentDetailList"]));
        }
        // Session["pRec"] = pRec;
        reload();

    }

    protected void reload()
    {
        hMainCommand.Value = "";
        string script2 = "<script language='javascript'>";
        script2 += "form1.method='Post';";
        script2 += "form1.action='Receiv_pay.aspx?postfromInside=yes';";
        script2 += "form1.__VIEWSTATE.name = 'NOVIEWSTATE';";
        script2 += "form1.submit();";
        script2 += "</script>";
        this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script2);
    }
 
    protected void CancelClick()
    {
        pRec = (PaymentRecord)Session["pRec"];
        if (pRec != null)
        {
            pMgr.CancelPayment(pRec, "PMT", this.hCreditBack.Value);
            Session["pRec"] = null;
            resetPage();
        }

        reload();
    }

 /************************************************************************************
  * Method:
  * Purpose:
  * 
  * *********************************************************************************/
    protected void bindPage()
    {
        Session["pRec"] = null;
        credit_used = 0;
        credit_added = 0;
        dDate.Text = pRec.payment_date;
        Decimal paid = 0;
        for (int i = 0; i < pRec.PaymentDetailList.Count; i++)
        {

            PaymentDetailRecord pdRec = (PaymentDetailRecord)pRec.PaymentDetailList[i];
            paid += pdRec.payment;
        }
        // Decimal paid = (pRec.received_amt + pRec.existing_credits - pRec.unapplied_amt);       
        if (paid > pRec.received_amt)
        {
            credit_used = (paid - pRec.received_amt);//ADD IT LATER
            cApplyCredit.Checked = false;
        }
        credit_added = pRec.added_amt;//SUBTRACT IT LATER 
        // WHEN THERE NEEDS ACCREDITING WITH AMOUNT PAID WE NEED TO ADD CREDIT USED/ AMOUNT RECEIVED TO THE CLIENT !

        txtAmtToPayNow.Text = paid.ToString();//<--------PAID IS CALCULATED ABOVE NOT SAVED IN DB.

        ddlPaymethod.SelectedValue = pRec.pmt_method;
        txtAmtReceiving.Text = pRec.received_amt.ToString();
        lstVendorName.Text = pRec.customer_name;
        hVendorAcct.Value = pRec.customer_number.ToString();
        dDate.Text = DateTime.Parse(pRec.payment_date).ToShortDateString();
        txtAmtAnapplied.Text = pRec.unapplied_amt.ToString();
        ddlBankAcct.SelectedValue = pRec.deposit_to.ToString();
        ARControl1.bindFromPaymentDetailTable(dtPaymentDetailList);
        btnCancel.Visible = false;
        lblCreditRemaining.Visible = false;
        lblUnappliedAmount.Visible = false;
        txtAmtAnapplied.Visible = false;
        txtCreditRemain.Visible = false;
        this.btnSaveDown.Visible = false;
        this.btnSaveUpper.Visible = false;
        this.sToBePrint.Visible = false;
        this.cApplyCredit.Visible = false;
        lblAmountReceiving.Text = "Amount received then";
        lblAmountToPayNow.Text = "Amount cleared then";
        //((GridView)this.ARControl1.FindControl("GridViewARItem")).Enabled = false;
        hPaymentNo.Value = pRec.payment_no.ToString();
        Session["pRec"] = pRec;
    }

}
