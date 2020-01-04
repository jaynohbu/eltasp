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

public partial class ASPX_AccountingTasks_Write_Check : System.Web.UI.Page
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
    public string today;
    private int Vendor_acct;


    protected void Page_Load(object sender, EventArgs e)
    {
        Vendor_acct = 0;
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());
        glMgr = new GLManager(elt_account_number);
        BankAccountList = glMgr.getGLAcctList(Account.BANK);
        APAccountList = glMgr.getGLAcctList(Account.ACCOUNT_PAYABLE);
        billMgr = new BillManager(elt_account_number);
        cdMgr = new CheckDetailManager(elt_account_number);
        aajMgr = new AllAccountsJournalManager(elt_account_number);
        checkQMgr = new CheckQueueManager(elt_account_number);
        mainCmd = this.hMainCommand.Value;
        cmd = ((HiddenField)this.CheckItemControl1.FindControl("hCommand")).Value;
        this.btnSaveDown.Attributes.Add("onclick", "SaveClick()");
        this.btnSaveUp.Attributes.Add("onclick", "SaveClick()");
        if (this.dDate.Text == "")
        {
            this.dDate.Text = DateTime.Today.ToShortDateString();

        }
        if (txtDate.Text == "")
        {
            this.txtDate.Text = DateTime.Today.ToShortDateString();
        }

        if (!IsPostBack || Request["postFromInside"] == "yes")
        {
            this.TblCheck.Attributes.Add("background", "../../Images/checkback.gif");
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
           // this.ddlBankAcct.Attributes.Add("onchange", "checkNoChange(this)");

            this.ddlBankAcct.Attributes.Add("onchange", "bankChange(this," + this.ddlPaymethod.ClientID + ")");
            this.ddlPaymethod.Attributes.Add("onchange", "methodChange(this," + this.ddlBankAcct.ClientID + ")");

            this.txtAcctBalance.Text = ((GLRecord)BankAccountList[0]).Gl_account_balance.ToString();
            //this.txtCheckNo.Text = ((GLRecord)BankAccountList[0]).Control_no.ToString();

            this.CheckItemControl1.bindEmpty();

            if (Request.QueryString["FromRefundTo"] == "yes")
            {
                Vendor_acct = Int32.Parse(Request.QueryString["Vendor_acct"]);
                this.hVendorAcct.Value = Vendor_acct.ToString();
                OrganizationManager orgMgr = new OrganizationManager(elt_account_number);
                this.lstVendorName.Text = orgMgr.getOrgName(Vendor_acct);
                this.txt_print_check_as.Text = this.lstVendorName.Text;
                this.txtMemo.Value = "Refund";
            }
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
                this.hMainCommand.Value = "";
            }
            else if (mainCmd == "printNow" || mainCmd == "printLater")
            {
                Vendor_acct = Int32.Parse(this.hVendorAcct.Value);
                if (Vendor_acct == 0)
                {
                    string script = "<script language='javascript'>";
                    script += "alert('Please choose Vendor from list');";
                    script += "</script>";
                    this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", script);
                }
                else
                {
                    CheckQueueRecord Cr = prepareCheck();
                    string pMethod = this.ddlPaymethod.SelectedValue.ToString();
                    int print_id = 0;
                   
                    try
                    {
                        print_id = Int32.Parse(this.hPrint_id.Value);
                    }
                    catch { }

                    if (pMethod == "Check")
                    {
                        if (print_id == 0)
                        {
                            this.checkQMgr.enqueueCheck(Cr, "CHK");
                        }
                        else
                        {
                            this.checkQMgr.updateCheck(Cr, "CHK");
                        }
                    }
                    else
                    {
                        if (print_id == 0)
                        {
                            this.checkQMgr.enqueueCheck(Cr, pMethod);
                        }
                        else
                        {
                            this.checkQMgr.updateCheck(Cr, "CHK");
                        }
                    }
                    this.hMainCommand.Value = "";
                    ((HiddenField)CheckItemControl1.FindControl("hCommand")).Value = "";
                    clearScreen();
                    if (mainCmd == "printNow")
                    {
                        if (mainCmd == "printNow" && pMethod == "Check")
                        {
                            //string script2 = "<script language='javascript'>";
                            //script2 += "form1.method='Post';";
                            //script2 += "form1.action='../../ASP/acct_tasks/print_chk.asp?sent=Y&print_id=" + Cr.print_id.ToString() + "&RequestedBank=" + Cr.bank.ToString() + "';";
                            //script2 += "form1.__VIEWSTATE.name = 'NOVIEWSTATE';";
                            //script2 += "form1.submit();";
                            //script2 += "</script>";
                            //this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script2);
                            //// Response.Redirect("../../ASP/acct_tasks/print_chk.asp?sent=Y&print_id=" + Cr.print_id.ToString() + "&RequestedBank=" + Cr.bank.ToString());
                        }
                        else
                        {
                            string script2 = "<script language='javascript'>";
                            script2 += "form1.method='Post';";
                            script2 += "form1.action='Write_Check.aspx?postFromInside=yes";
                            script2 += "form1.__VIEWSTATE.name = 'NOVIEWSTATE';";
                            script2 += "form1.submit();";
                            script2 += "</script>";
                            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script2);
                        }
                    }
                }

            }
            else
            {
                this.hMainCommand.Value = "";
                ((HiddenField)CheckItemControl1.FindControl("hCommand")).Value = "";
            }

        }
    }

    protected void bindPage()
    {
        clearScreen();

        hPrint_id.Value = chkRec.print_id.ToString();

        this.txt_print_check_as.Text = chkRec.print_check_as;
        this.txtAddress.Text = chkRec.vendor_info;
        this.txtAmount.Text = chkRec.check_amt.ToString();
        this.txtCheckNo.Text = chkRec.check_no.ToString();
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
        this.txtMoneyEnglish.Text = n2e.changeNumericToWords(chkRec.check_amt);
        this.Vendor_acct = 0;
        this.hVendorAcct.Value = chkRec.vendor_number.ToString();
        this.lstVendorName.Text = chkRec.vendor_name;
        BillManager bMgr = new BillManager(elt_account_number);
        BillRecord bRec = bMgr.getBillFromWirteCheck(chkRec.print_id);
        

        BillDetailManager bdMgr = new BillDetailManager(elt_account_number);
        DataTable dt = bdMgr.getBillDetailsDt(bRec.Bill_number);

        //DataTable dt = cdMgr.getcheckDetailForPrintIdDt(chkRec.print_id);
   
        if (chkRec.chk_void)
        {
            this.TblCheck.Attributes.Add("background", "../../Images/checkback_void.gif");
           
        }
        this.CheckItemControl1.reBind_BillDetailChangesToGrid(dt);
        

        if (chkRec.check_no != 0)
        {
            this.btnSaveDown.Visible = false;
            this.btnSaveUp.Visible = false;          
        }
      
      
       
    }
    protected void clearScreen()
    {
        this.txt_print_check_as.Text = "";
        this.txtAddress.Text = "";
        this.txtAmount.Text = "";
        this.txtCheckNo.Text = "";
        this.txtMemo.Value = "";
        this.txtMoneyEnglish.Text = "";
        this.lstVendorName.Text = "";
        this.CheckItemControl1.bindEmpty();
    }

    protected ArrayList getCheckDetailList(ArrayList bill_detail_item_list)
    {
        ArrayList checkDetails = new ArrayList();
        for (int i = 0; i < bill_detail_item_list.Count; i++)
        {
            if (((BillDetailRecord)bill_detail_item_list[i]).item_amt != 0)
            {
                CheckDetailRecord cdRec = new CheckDetailRecord();
                cdRec.amt_due = ((BillDetailRecord)bill_detail_item_list[i]).item_amt;
                cdRec.amt_paid = ((BillDetailRecord)bill_detail_item_list[i]).item_amt;
                cdRec.bill_amt = ((BillDetailRecord)bill_detail_item_list[i]).item_amt;
                // cdRec.bill_number = ((BillDetailRecord)bill_detail_item_list[i])
                cdRec.due_date = this.dDate.Text;
                cdRec.memo = ((BillDetailRecord)bill_detail_item_list[i]).ref_no;
                cdRec.pmt_method = this.ddlPaymethod.SelectedValue;
                //cdRec.print_id = ((BillDetailRecord)bill_detail_item_list[i]).item_amt;
                cdRec.tran_id = i;
                checkDetails.Add(cdRec);
            }
        }
        return checkDetails;
    }

  
    protected BillRecord createBill(ArrayList bill_detail_item_list)
    {
        ArrayList billList = new ArrayList();
        BillRecord bRec = new BillRecord();
        bRec.Vendor_name = this.lstVendorName.Text; ;
        bRec.Vendor_number = Int32.Parse(this.hVendorAcct.Value);
        bRec.Ref_no = this.txtMemo.Value;
        bRec.Bill_expense_acct = ((BillDetailRecord)bill_detail_item_list[0]).item_expense_acct;
        bRec.Bill_date = this.dDate.Text;
        bRec.Bill_due_date = this.dDate.Text;
        bRec.Bill_type = "D";

        bRec.Pmt_method = this.ddlPaymethod.SelectedValue;
        bRec.Bill_ap = Int32.Parse(this.ddlAPAcct.SelectedValue);  
        bRec.Bill_status = "A";
        ArrayList bdList = new ArrayList();
        for (int i = 0; i < bill_detail_item_list.Count; i++)
        {
            if (((BillDetailRecord)bill_detail_item_list[i]).item_amt != 0)
            {
                bRec.Bill_amt += ((BillDetailRecord)bill_detail_item_list[i]).item_amt;
                bRec.Bill_amt_due = 0;
                bRec.Bill_amt_paid += ((BillDetailRecord)bill_detail_item_list[i]).item_amt; 
                ((BillDetailRecord)bill_detail_item_list[i]).item_ap = bRec.Bill_ap;
                ((BillDetailRecord)bill_detail_item_list[i]).item_id = -1;
                bdList.Add(((BillDetailRecord)bill_detail_item_list[i]));
            }
            
        }
        bRec.BillDetailList = bdList;
        bRec.Lock = "Y";
        return bRec;
    }
    protected CheckQueueRecord prepareCheck()
    {
        try
        {
            chkRec = new CheckQueueRecord();
            if (this.ddlPaymethod.SelectedValue == "Check")
            {

                try
                {
                    chkRec.check_no = Int32.Parse(Request[this.txtCheckNo.UniqueID]);
                }
                catch { }
            }
            int bank_acct = Int32.Parse(this.ddlBankAcct.SelectedValue.ToString());
            int ap_acct = Int32.Parse(this.ddlAPAcct.SelectedValue.ToString());
            chkRec.check_amt = Decimal.Parse(this.txtAmount.Text);
            chkRec.vendor_name = this.lstVendorName.Text;
            chkRec.vendor_number = Int32.Parse(this.hVendorAcct.Value);
            chkRec.bank = Int32.Parse(this.ddlBankAcct.SelectedValue.ToString());
            chkRec.bill_due_date = this.dDate.Text;
            chkRec.bill_date = this.dDate.Text;
            chkRec.ap = ap_acct;
            chkRec.bank = bank_acct;
            chkRec.print_check_as = this.txt_print_check_as.Text;
            chkRec.print_date = this.dDate.Text;

            string pMethod = this.ddlPaymethod.SelectedValue.ToString();
            chkRec.pmt_method = pMethod;
            chkRec.print_status = "A";
            chkRec.check_type = "C";
            chkRec.memo = this.txtMemo.Value;
            ArrayList bill_detail_item_list = this.CheckItemControl1.getBillDetailItemList();
            ArrayList bill_list = new ArrayList();
            bill_list.Add(createBill(bill_detail_item_list));
            chkRec.BillList = bill_list;
            chkRec.CheckDetailList = getCheckDetailList(bill_detail_item_list);
            chkRec.All_accounts_journal_entry_list = createAllAccountsJournalEntry(bill_detail_item_list);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return chkRec;
    }
    protected ArrayList createAllAccountsJournalEntry(ArrayList bdList)
    {
        ArrayList list = new ArrayList();
        Decimal amount = 0;
        try
        {
            for (int i = 0; i < bdList.Count; i++)
            {
                AllAccountsJournalRecord rec = new AllAccountsJournalRecord();
                rec.elt_account_number = Int32.Parse(elt_account_number);
                rec.gl_account_number = ((BillDetailRecord)bdList[i]).item_expense_acct;
                rec.gl_account_name = glMgr.getGLDescription(rec.gl_account_number);
                // rec.tran_num = invoice_no;
                if (ddlPaymethod.SelectedValue == "Check")
                {
                    rec.tran_type = "CHK";
                }
                else
                {
                    rec.tran_type = ddlPaymethod.SelectedValue;
                }
                rec.tran_date = this.dDate.Text;
                rec.customer_number = Int32.Parse(this.hVendorAcct.Value);
                rec.customer_name = this.lstVendorName.Text;
                rec.memo = ((BillDetailRecord)bdList[i]).ref_no;
                rec.debit_amount = ((BillDetailRecord)bdList[i]).item_amt;
                amount += ((BillDetailRecord)bdList[i]).item_amt;
                rec.credit_amount = 0;
                list.Add(rec);
            }

            //CREATEING BANK WITHRAWL ENTRY
            AllAccountsJournalRecord rec2 = new AllAccountsJournalRecord();
            rec2.elt_account_number = Int32.Parse(elt_account_number);
            rec2.gl_account_number = Int32.Parse(this.ddlBankAcct.SelectedValue);
            rec2.gl_account_name = this.ddlBankAcct.SelectedItem.Text;
            // rec.tran_num = invoice_no;            
            if (ddlPaymethod.SelectedValue == "Check")
            {
                rec2.tran_type = "CHK";
            }
            else
            {
                rec2.tran_type = ddlPaymethod.SelectedValue;
            }
            rec2.tran_date = this.dDate.Text;
            rec2.customer_number = Int32.Parse(this.hVendorAcct.Value);
            rec2.customer_name = this.lstVendorName.Text;
            rec2.print_check_as = this.txt_print_check_as.Text;
            rec2.memo = this.txtMemo.Value;
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
