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

public partial class ASPX_AccountingTasks_RefundFrom : System.Web.UI.Page
{
    //once saved there is no update for the bill and bill detail!!!!

    private string elt_account_number;
    public string user_id, login_name, user_right;
    protected string ConnectStr;
    private int vendorAcct;
    private BillDetailManager bdMgr;
    DataTable dtBillDetail;
    string cmd;
    string mainCommand;
    private BillRecord bRec;
    private BillManager bMgr;
    private ArrayList APaccountList;
    private GLManager glMgr;
    private APStatusManager APSMgr;
    private int bill_number;

    protected void Page_Load(object sender, EventArgs e)
    {    
       
        Session.LCID = 1033;
       
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());             
        bdMgr = new BillDetailManager(elt_account_number);
        bMgr = new BillManager(elt_account_number);
        glMgr = new GLManager(elt_account_number);
        APaccountList = glMgr.getGLAcctList(Account.ACCOUNT_PAYABLE);       
        this.lstAP.DataSource = APaccountList;
        this.lstAP.DataTextField = "gl_account_desc";
        this.lstAP.DataValueField = "gl_account_number"; 
        this.lstAP.DataBind();
        PayableQueueControl1.setParentControl(this.txtAmount);
        cmd=((HiddenField)this.PayableQueueControl1.FindControl("hCommand")).Value;
        mainCommand = this.hMainCommand.Value;
      
    
       

        if (Request.QueryString["view"] == "yes" || Request.QueryString["ViewBill"] == "yes")
        {
            mainCommand="VIEW";
        }     
       
        
        if (!IsPostBack)
        {
            bRec = new BillRecord();

            if (mainCommand == "VIEW")
            {
                Session["dtBillDetail"] = null;
                try
                {
                    bill_number = Int32.Parse(Request.QueryString["bill_number"]);
                }
                catch { bill_number = 0; }
                if (bill_number == 0)
                {
                    try
                    {
                        bill_number = Int32.Parse(Request.QueryString["BillNo"]);
                    }
                    catch { bill_number = 0; }
                }

                SearchBill(bill_number);
                this.hMainCommand.Value = "";

            }
            else
            {
                //if (Session["dtBillDetail"] == null)
                //{
               
                    this.PayableQueueControl1.bindEmpty();
               // }

            }
        }
        else
        {
            if ((BillRecord)Session["bRec"]!=null)
            {
                bRec = (BillRecord)Session["bRec"];
            }
            else
            {
                bRec = new BillRecord(); 
            }
           
            try
            {
                vendorAcct = Int32.Parse(this.hVendorAcct.Value);
            }
            catch
            {
                vendorAcct = 0;
            }
            if (vendorAcct !=0&&mainCommand.Equals("SEARCH"))
            {
                Session["dtBillDetail"] = null;
                Session["bRec"] = null;
                bRec = new BillRecord();                
                this.PayableQueueControl1.bindEmpty();                
                this.hMainCommand.Value = "";
            }
            else
            {          
                if (mainCommand == "SAVE")
                {
                    getFromScreen();
                   
                    Session["Bill_number"] = null;
                    if (bRec.Bill_number == 0)
                    {
                        this.bMgr.insertBillRecord(ref bRec,"BILL");
                    }
                    else
                    {
                       
                        this.bMgr.updateBillRecord(ref bRec,"BILL");
                    }
                    Session["bRec"] = null;
                    Session["dtBillDetail"] = null;
                    dtBillDetail = bdMgr.getUnbilledListForVendor(vendorAcct);
                    this.PayableQueueControl1.reSetPageIndex();
                    if (dtBillDetail.Rows.Count > 0)
                    {
                        this.PayableQueueControl1.reBind_BillDetailChangesToGrid(dtBillDetail);
                    }
                    else
                    {
                        this.PayableQueueControl1.bindEmpty();
                    }
                    this.hMainCommand.Value = "";
                    this.hBillNumber.Value = "";
                }
                else if (mainCommand == "DELETE")
                {
                    bill_number = Int32.Parse(this.hBillNumber.Value);
                    bMgr.deleteBillRecord(bill_number,"BILL");
                    reset();
                    this.enableCotrols();
                    this.hMainCommand.Value = "";
                    this.hBillNumber.Value = "";
                    
                }
                else if (mainCommand == "VIEW")
                {
                  
                    if (Request.QueryString["view"] == "yes")
                    {
                        bill_number = Int32.Parse(Request.QueryString["bill_number"]);
                    }

                    Session["dtBillDetail"] = null;
                    Session["bRec"] = null;
                    SearchBill(bill_number);
                
                    this.hMainCommand.Value = "";
                                  
                }
                else
                {

                }
            }
        }
    }

    protected void reset()
    {
        this.lstVendorName.Text = "";
        this.txtAmount.Text = "0.00";
        this.dDate.Text = "";       
        this.txtRefNo.Text = "";     
        this.PayableQueueControl1.bindEmpty();
    }

   
   
    protected void getFromScreen()
    {
        Decimal amount = Decimal.Parse(Request[this.txtAmount.UniqueID]);
        //CREDIT OR DEBIT
        if (this.rdioDorC.SelectedValue=="C")
        {
            amount=-amount;
        }

        bRec.Bill_amt = amount;
        bRec.Bill_amt_due = bRec.Bill_amt;
        bRec.Bill_amt_paid=0;
        bRec.Bill_ap=Int32.Parse(lstAP.SelectedValue);
        bRec.Bill_date = dDate.Text;
       
        //bRec.Bill_expense_acct= some expense acct from the items; Check to see if it is any good 
      
        bRec.Bill_status="A";
        bRec.Bill_type=this.rdioDorC.SelectedValue;
        bRec.Lock="Y";//AP Lock at the dequeued position --> AR Lock is done when receive ?
        bRec.Ref_no=this.txtRefNo.Text;
        bRec.Vendor_name=this.lstVendorName.Text;      
        bRec.Vendor_number=vendorAcct;
        bRec.BillDetailList = this.PayableQueueControl1.getBillDetailItemList();       
       
        for (int i = 0; i < bRec.BillDetailList.Count; i++)
        {
            if (this.rdioDorC.SelectedValue == "C")
            {
                ((BillDetailRecord)bRec.BillDetailList[i]).item_amt = -((BillDetailRecord)bRec.BillDetailList[i]).item_amt;
            }
            ((BillDetailRecord)bRec.BillDetailList[i]).item_ap = Int32.Parse(this.lstAP.SelectedValue);
            ((BillDetailRecord)bRec.BillDetailList[i]).vendor_number = vendorAcct;
        }
        bRec.All_accounts_journal_list=createAllAccountsJournalEntry(bRec.BillDetailList, "BILL");
    }

    public ArrayList createAllAccountsJournalEntry(ArrayList bdList, string tran_type)
    {
        ArrayList list = new ArrayList();
        try
        {  
            //CREATEING AP ENTRY
            Decimal amount = 0;
            for (int i = 0; i < bdList.Count; i++)
            {
                if (((BillDetailRecord)bdList[i]).Is_checked)//only accept selected!
                {
                    amount += ((BillDetailRecord)bdList[i]).item_amt;
                }
            }
            if (this.rdioDorC.SelectedValue == "C")
            {
                amount = -amount;
            }

            AllAccountsJournalRecord rec = new AllAccountsJournalRecord();
            rec.elt_account_number = Int32.Parse(elt_account_number);
            rec.gl_account_number = Int32.Parse(this.lstAP.SelectedValue);
            rec.gl_account_name = this.lstAP.SelectedItem.Text;
            // rec.tran_num = invoice_no;
            rec.tran_type = tran_type;
            rec.tran_date = this.dDate.Text;
            rec.customer_number = vendorAcct;
            rec.customer_name = this.lstVendorName.Text;
            rec.memo = this.txtRefNo.Text;
            rec.debit_amount = 0;
            rec.credit_amount = -amount;
            list.Add(rec);

            //CREATING EXPENSE ENTRIES 
            CostItemKindManager costKindMgr = new CostItemKindManager(elt_account_number);
            for (int i = 0; i < bdList.Count; i++)
            {
                if (((BillDetailRecord)bdList[i]).Is_checked)
                {
                    rec = new AllAccountsJournalRecord();
                    rec.elt_account_number = Int32.Parse(elt_account_number);
                    rec.gl_account_number = ((BillDetailRecord)bdList[i]).item_expense_acct;
                    rec.gl_account_name = glMgr.getGLDescription(rec.gl_account_number);
                    // rec.tran_num = invoice_no;
                    rec.tran_type = tran_type;
                    rec.tran_date = this.dDate.Text;
                    rec.customer_number = vendorAcct;
                    rec.customer_name = this.lstVendorName.Text;
                    rec.memo = this.txtRefNo.Text;
                    rec.debit_amount = ((BillDetailRecord)bdList[i]).item_amt;
                    rec.credit_amount = 0;
                    list.Add(rec);
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return list;
    }
   
    protected void SearchBill(int bill_number)
    {
        
        this.bRec = this.bMgr.getBill(bill_number);
        Session["bRec"] = bRec;
        if (bRec.Bill_number != 0)
        {
           
            Session["Bill_number"] = bRec.Bill_number.ToString();
         
            APSMgr = new APStatusManager(elt_account_number);
            if (APSMgr.FindIfPaymentProcessed(bRec.Bill_number))
            {
                bindFromRecord(true);
            }
            else
            {
                bindFromRecord(false);
            }
        }
    }
    protected void disableCotrols()
    {
      
        this.btnSaveUp.Style["visibility"] = "hidden";
        this.btnSaveDown.Style["visibility"] = "hidden";
        this.txtAmount.Enabled = false;
        this.dDate.Enabled = false;       
        this.txtRefNo.Enabled = false;
        this.lstVendorName.Enabled = false;
      
        ((GridView)this.PayableQueueControl1.FindControl("GridViewBillDetailItem")).Enabled=false;
        ((Image)this.PayableQueueControl1.FindControl("btnAdd")).Visible = false;
        this.hIsDisabled.Value = "true";
    }

    

    protected void enableCotrols()
    {
        
        this.btnSaveUp.Style["visibility"] = "visible";
        this.btnSaveDown.Style["visibility"] = "visible";
        this.lstVendorName.Enabled = true;
        this.txtAmount.Enabled = true;
        this.dDate.Enabled = true;      
        this.txtRefNo.Enabled = true;
        ((GridView)this.PayableQueueControl1.FindControl("GridViewBillDetailItem")).Enabled = true;
        ((Image)this.PayableQueueControl1.FindControl("btnAdd")).Visible = true;
        this.hIsDisabled.Value = "false";
    }


    protected void bindFromRecord(bool disable)
    {
        enableCotrols();

        if (bRec.Bill_number != 0)
        {
            this.txtAmount.Text = bRec.Bill_amt.ToString();
            if (bRec.Bill_type == "C")
            {
                bRec.Bill_amt = -bRec.Bill_amt;
            }
            for (int i = 0; i < lstAP.Items.Count; i++)
            {
                lstAP.Items[i].Value = bRec.Bill_ap.ToString();
                lstAP.SelectedIndex = i;
            }
            dDate.Text = bRec.Bill_date;      
            this.vendorAcct = bRec.Vendor_number;
            this.hVendorAcct.Value= bRec.Vendor_number.ToString();
          
            for (int i = 0; i < this.rdioDorC.Items.Count; i++)
            {
                if (this.rdioDorC.Items[i].Value == bRec.Bill_type)
                {
                    this.rdioDorC.SelectedIndex = i;
                }
            }
            //bRec.BillDetailList
            this.txtRefNo.Text = bRec.Ref_no;
            this.lstVendorName.Text = bRec.Vendor_name;
            DataTable dt = this.bdMgr.getBillDetailsDt(bRec.Bill_number);
            if (bRec.Bill_type == "C")
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dt.Rows[i]["item_amt"] = -Decimal.Parse(dt.Rows[i]["item_amt"].ToString());
                }

            }
            this.PayableQueueControl1.reBind_BillDetailChangesToGrid(dt);
            hBillNumber.Value = bRec.Bill_number.ToString();
           
            if (disable)
            {
                disableCotrols();
            }
        }
        else
        {
            reset();
        }
    }
}
