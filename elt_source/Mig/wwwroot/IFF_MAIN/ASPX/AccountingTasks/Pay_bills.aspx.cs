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

public partial class ASPX_AccountingTasks_Pay_bills : System.Web.UI.Page
{

    private string elt_account_number;
    public string user_id, login_name, user_right;
    protected string ConnectStr;  
    private ArrayList BankAccountList;
    private ArrayList APAccountList;
    private GLManager glMgr;
    private BillManager billMgr;
    private CheckDetailManager cdMgr;
    private AllAccountsJournalManager aajMgr;
    private CheckQueueManager checkQMgr;
    private CheckQueueRecord chkRec;  
   
    string cmd;
    string mainCmd;
    private int vendor_acct;
    public string today;

    protected void Page_Load(object sender, EventArgs e)
    {
        this.imgCancel.Visible = false;
        this.btnSaveDown.Visible = true;
        this.btnSaveUpper.Visible = true;
        btnSearch.Attributes.Add("onclick", "searchPayment()");
       
        this.TblCheck.Attributes.Add("background", "../../Images/checkback.gif");


        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];


        this.btnSaveUpper.Attributes.Add("onclick", "SaveClick()");
        this.btnSaveDown.Attributes.Add("onclick", "SaveClick()");

        this.imgCancel.Attributes.Add("onclick", "Command('CANCEL','hMainCommand')");   
    
        ConnectStr = (new igFunctions.DB().getConStr());
        glMgr = new GLManager(elt_account_number);
        BankAccountList = glMgr.getGLAcctList(Account.BANK);
        APAccountList = glMgr.getGLAcctList(Account.ACCOUNT_PAYABLE);
        billMgr = new BillManager(elt_account_number);
        cdMgr = new CheckDetailManager(elt_account_number);
        aajMgr = new AllAccountsJournalManager(elt_account_number);
        checkQMgr = new CheckQueueManager(elt_account_number);
        mainCmd = this.hMainCommand.Value;
        cmd = ((HiddenField)BillListControl1.FindControl("hCommand")).Value;
        this.txtSearch.Attributes.Add("onfocus", "clearSearch(this)");

        BillListControl1.setParentControl(this.txtAcctBalance);
        BillListControl1.setParentControl(this.txtMoneyEnglish);
        BillListControl1.setParentControl(this.txtAmount);      
        BillListControl1.setParentControl(this.txt_print_check_as);
        BillListControl1.setParentControl(this.txtAddress);
        BillListControl1.setParentControl(this.txtChekNo);
        BillListControl1.setParentControl(this.dDate);
        BillListControl1.setParentControl(this.ddlAPAcct);
        BillListControl1.setParentControl(this.ddlBankAcct);
        BillListControl1.setParentControl(this.ddlPaymethod);

        if (!IsPostBack||Request["postFromInside"]=="yes")
        {
            today = DateTime.Today.ToShortDateString();
            this.dDate.Text = today;
            this.ddlBankAcct.DataSource = BankAccountList;
            this.ddlBankAcct.DataTextField = "Gl_account_desc";
            this.ddlBankAcct.DataValueField = "Gl_account_number";
            this.ddlBankAcct.DataBind();
            this.ddlAPAcct.DataSource = APAccountList;
            this.ddlAPAcct.DataTextField = "Gl_account_desc";
            this.ddlAPAcct.DataValueField = "Gl_account_number";
            this.ddlAPAcct.DataBind();

            for (int i = 0; i < BankAccountList.Count; i++)
            {
                this.hCheckNo.Value += ((GLRecord)BankAccountList[i]).Control_no + "^^";
                this.hBankBalance.Value += ((GLRecord)BankAccountList[i]).Gl_account_balance + "^^";
            }

            this.txtAcctBalance.Text = ((GLRecord)BankAccountList[0]).Gl_account_balance.ToString();
           // this.txtChekNo.Text = ((GLRecord)BankAccountList[0]).Control_no.ToString();

            this.ddlBankAcct.Attributes.Add("onchange", "bankChange(this,"+this.ddlPaymethod.ClientID+")");
            this.ddlPaymethod.Attributes.Add("onchange", "methodChange(this," + this.ddlBankAcct.ClientID + ")");

            if (Request.QueryString["EditCheck"] == "yes" || Request.QueryString["view"] == "yes")
            {
                int id = 0;
                string type = "";
                try
                {
                    id = Int32.Parse(Request.QueryString["CheckQueueID"]);
                    type = "Payment ID";
                }
                catch { id = 0; }

                if (checkQMgr.searchPayment(id, type, ref chkRec))
                {
                    bindPage();
                }
                else
                {
                    clearScreen();
                }
            } 
        }
        else
        {
            if (mainCmd == "Load")
            {
                this.txtAmount.Text = "0.00";
                this.txtChekNo.Text = "";
                this.txtMemo.Value = "";
                this.txtMoneyEnglish.Text = "";
                this.txtSearch.Text = "";
                vendor_acct = Int32.Parse(this.hVendorAcct.Value);
               
                if (vendor_acct != 0)
                {
                    DataTable dt = billMgr.getNotYetPaidBillListDt(vendor_acct);               
                    this.BillListControl1.reBind_BillChangesToGrid(dt,false);
                }
                this.hMainCommand.Value="";
                ((HiddenField)BillListControl1.FindControl("hCommand")).Value="";
            }
            else if (mainCmd == "printNow" || mainCmd == "printLater")
            {
                if (Decimal.Parse(this.txtAmount.Text) != 0)
                {
                    vendor_acct = Int32.Parse(this.hVendorAcct.Value);
                    if (vendor_acct == 0)
                    {
                        string script = "<script language='javascript'>";
                        script += "alert('Please choose vendor from list');";
                        script += "</script>";
                        this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", script);

                    }
                    else
                    {
                        string pMethod = this.ddlPaymethod.SelectedValue.ToString();
                        if (pMethod != "Check")
                        {
                            this.checkQMgr.enqueuePayment(preparePayment(), pMethod);
                            vendor_acct = Int32.Parse(this.hVendorAcct.Value);
                            if (vendor_acct != 0)
                            {
                                DataTable dt = billMgr.getNotYetPaidBillListDt(vendor_acct);
                                this.BillListControl1.reBind_BillChangesToGrid(dt, false);

                               
                            }
                        }
                        else
                        {
                            CheckQueueRecord Cr = preparePayment();
                            this.checkQMgr.enqueuePayment(Cr, "BP-CHK");

                           
                        }

                        this.hMainCommand.Value = "";
                        hPrint_id.Value = "0";
                        ((HiddenField)BillListControl1.FindControl("hCommand")).Value = "";                       
                        this.hMainCommand.Value = "";
                        ((HiddenField)BillListControl1.FindControl("hCommand")).Value = "";
                        this.hVendorAcct.Value = "0";

                        string script2 = "<script language='javascript'>";
                        script2 += "form1.method='post';";
                        script2 += "form1.action='pay_bills.aspx?postfrominside=yes';";                      
                        script2 += "form1.submit();";
                        script2 += "</script>";

                        this.ClientScript.RegisterClientScriptBlock(this.GetType(), "preload", script2);
                        clearScreen();
                    }
                }
            }
            else if (mainCmd == "SEARCH")
            {
                int id = 0;
                string type="Check";
                chkRec=new CheckQueueRecord();               
                try
                {
                    id = Int32.Parse(this.txtSearch.Text);
                    
                }
                catch(Exception ex)
                {
                    throw ex;
                }

                if (checkQMgr.searchPayment(id, type, ref chkRec))
                {
                  
                    bindPage();
                }
                else
                {
                    clearScreen();
                }
            }
            else if(mainCmd=="CANCEL")
            {
                int print_id = Int32.Parse(hPrint_id.Value);
                string tran_type = (ddlPaymethod.SelectedValue == "Check" ? "BP-CHK" : ddlPaymethod.SelectedValue);
                // if it is from write check tran_type = "CHK";
                string t=checkQMgr.getCheckType(print_id);
                if (t == "CHK")
                {
                    tran_type =t;
                }
                checkQMgr.CancelPayment(print_id, tran_type);
                clearScreen();
                
            }   
        }
    }
  
    protected void clearScreen()
    {
        hPrint_id.Value = "0";
        this.txtSearch.Text = "";
        this.txt_print_check_as.Text = "";
        this.txtAddress.Text = "";
        this.txtAmount.Text = "";
        this.txtChekNo.Text = "";
        this.txtMemo.Value = "";
        this.txtMoneyEnglish.Text = "";
        this.vendor_acct = 0;
        lstVendorName.Text= "";
        this.hVendorAcct.Value = "0";
        this.imgCancel.Visible = false;
        this.btnSaveDown.Visible = true;
        this.btnSaveUpper.Visible = true;
        BillListControl1.Clear();
    }
 
    protected void bindPage()
    {
        clearScreen();
       
        hPrint_id.Value = chkRec.print_id.ToString();

        this.txt_print_check_as.Text = chkRec.print_check_as;
        this.txtAddress.Text = chkRec.vendor_info;
        this.txtAmount.Text = chkRec.check_amt.ToString();
        this.txtChekNo.Text = chkRec.check_no.ToString();
        this.txtMemo.Value = chkRec.memo;
        this.dDate.Text = chkRec.print_date;
        this.txtDate.Text = chkRec.print_date;
        NumberToEnglish n2e = new NumberToEnglish();
        if (chkRec.ap != 0)//It looks like everything is 0 for now.
        {
            ddlAPAcct.SelectedValue = chkRec.ap.ToString();
        }
        ddlBankAcct.SelectedValue = chkRec.bank.ToString();
        this.txtAcctBalance.Text = glMgr.getBankBalance(chkRec.bank).ToString();
        ddlPaymethod.SelectedValue = chkRec.pmt_method;
        this.txtMoneyEnglish.Text = n2e.changeCurrencyToWords(chkRec.check_amt);
        this.vendor_acct = 0;
        this.hVendorAcct.Value = chkRec.vendor_number.ToString();
        this.lstVendorName.Text = chkRec.vendor_name;
        DataTable dt=cdMgr.getcheckDetailForPrintIdDt(chkRec.print_id);
        this.imgCancel.Visible = false;
        this.btnSaveDown.Visible = false;
        this.btnSaveUpper.Visible = false;
        if (chkRec.chk_void)
        {
            this.TblCheck.Attributes.Add("background", "../../Images/checkback_void.gif");
            this.imgCancel.Visible = false;
        }
        BillListControl1.bindFromCheckDetailTable(dt);       
    }

    protected CheckQueueRecord preparePayment()
    {
        if (dDate.Text == "" || dDate.Text == null)
        {
            dDate.Text = DateTime.Today.ToShortDateString();
        }
        try
        {
            chkRec = new CheckQueueRecord();
            if (this.ddlPaymethod.SelectedValue == "Check")
            {
                try
                {
                    chkRec.check_no = Int32.Parse(Request[this.txtChekNo.UniqueID]);
                }
                catch { }
            }
            chkRec.BillList = BillListControl1.BillList;
            chkRec.CheckDetailList = BillListControl1.CheckDetailList;
            string pMethod = this.ddlPaymethod.SelectedValue.ToString();
            int bank_acct = Int32.Parse(this.ddlBankAcct.SelectedValue.ToString());
            int ap_acct = Int32.Parse(this.ddlAPAcct.SelectedValue.ToString());

           
            for (int i = 0; i < chkRec.BillList.Count; i++)
            {
                ((BillRecord)chkRec.BillList[i]).Pmt_method = pMethod;
                ((BillRecord)chkRec.BillList[i]).Vendor_name = this.lstVendorName.Text;
                ((BillRecord)chkRec.BillList[i]).Vendor_number = Int32.Parse(this.hVendorAcct.Value);
                ((CheckDetailRecord)chkRec.CheckDetailList[i]).pmt_method = pMethod;
                ((CheckDetailRecord)chkRec.CheckDetailList[i]).tran_id = i;
            }
            chkRec.All_accounts_journal_entry_list = createAllAccountsJournalEntry(chkRec.BillList);
            chkRec.check_amt = Decimal.Parse(this.txtAmount.Text);
            chkRec.vendor_name = this.lstVendorName.Text;
            chkRec.vendor_number = Int32.Parse(this.hVendorAcct.Value);
            chkRec.bank = Int32.Parse(this.ddlBankAcct.SelectedValue.ToString());
            chkRec.bill_due_date = this.dDate.Text;
           
            chkRec.print_date = DateTime.Today.ToShortDateString();
            chkRec.ap = ap_acct;
            chkRec.bank = bank_acct;
            chkRec.print_check_as = this.txt_print_check_as.Text;
            chkRec.pmt_method = pMethod;
            chkRec.print_status = "A";
            chkRec.check_type = "BP";
            chkRec.memo = this.txtMemo.Value;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return chkRec;
    }

    protected ArrayList createAllAccountsJournalEntry(ArrayList bList)
    {
        ArrayList list = new ArrayList();
        try
        {
            //CREATEING AP ENTRY
            Decimal amount = 0;
            for (int i = 0; i < bList.Count; i++)
            {
                amount += ((BillRecord)bList[i]).Bill_amt_paid;
            }
            AllAccountsJournalRecord rec = new AllAccountsJournalRecord();
            rec.elt_account_number = Int32.Parse(elt_account_number);
            rec.gl_account_number = Int32.Parse(this.ddlAPAcct.SelectedValue);
            rec.gl_account_name = this.ddlAPAcct.SelectedItem.Text;
            // rec.tran_num = invoice_no;
            if (this.ddlPaymethod.SelectedValue.ToString() == "Check")
            {
                rec.tran_type = "BP-CHK";
            }
            else
            {
                rec.tran_type = ddlPaymethod.SelectedValue;
            }
            rec.tran_date = this.dDate.Text;
            rec.customer_number = Int32.Parse(this.hVendorAcct.Value);
            rec.customer_name = this.lstVendorName.Text;
            rec.print_check_as = this.txt_print_check_as.Text;

            rec.memo = this.txtMemo.Value;
            rec.debit_amount = amount;
            rec.credit_amount = 0;
            list.Add(rec);

            //CREATEING BANK WITHRAWL ENTRY
            AllAccountsJournalRecord rec2 = new AllAccountsJournalRecord();
            rec2.elt_account_number = Int32.Parse(elt_account_number);
            rec2.gl_account_number = Int32.Parse(this.ddlBankAcct.SelectedValue);
            rec2.gl_account_name = this.ddlBankAcct.SelectedItem.Text;
            // rec.tran_num = invoice_no;
            if (this.ddlPaymethod.SelectedValue.ToString() == "Check")
            {
                rec2.tran_type = "BP-CHK";
            }
            else
            {
                rec.tran_type = ddlPaymethod.SelectedValue;
            }
            rec2.tran_date = this.dDate.Text;
            rec2.customer_number = Int32.Parse(this.hVendorAcct.Value);
            rec2.customer_name = this.lstVendorName.Text;
            rec2.print_check_as = this.txt_print_check_as.Text;
            rec2.memo = rec.memo = this.txtMemo.Value;
            rec2.debit_amount = 0;
            rec2.credit_amount = -amount;
            list.Add(rec2);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return list;
    }   
    
}
