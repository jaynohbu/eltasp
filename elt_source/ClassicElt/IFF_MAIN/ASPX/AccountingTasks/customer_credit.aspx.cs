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
public partial class ASPX_AccountingTasks_customer_credit : System.Web.UI.Page
{
    protected int customer_acct;
    public string elt_account_number;
    public string vAO;
    public string user_id, login_name, user_right;
    protected string ConnectStr;
    protected CustomerCreditManager ccMgr;
    protected GLManager glMgr;

   
    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];      
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());

        glMgr = new GLManager(elt_account_number);
        ccMgr = new CustomerCreditManager(elt_account_number);
        if (!IsPostBack)
        {
          
            if (Request.QueryString["FromRefundTo"] == "yes")
            {
                customer_acct = Int32.Parse(Request.QueryString["customer_acct"]);
                OrganizationManager orgMgr = new OrganizationManager(elt_account_number);
                this.lstCustomerName.Text=orgMgr.getOrgName(customer_acct);
                this.hCustomerAcct.Value = customer_acct.ToString();
                this.txtDescription.Text = "Refund";
                if (customer_acct != 0)
                {
                    this.txtCurrentCredit.Text = ccMgr.getcustomerCredit(customer_acct).ToString("N2");
                }
            }
        }
        else
        {
            try
            {
                customer_acct = Int32.Parse(this.hCustomerAcct.Value);
            }
            catch {
                customer_acct = 0; 
            }
            if (customer_acct != 0)
            {
               this.txtCurrentCredit.Text=ccMgr.getcustomerCredit(customer_acct).ToString("N2");
            }

        }
    }
   
    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        
        Decimal amount=0;
        try
        {
            amount=Decimal.Parse(this.txtNewCredit.Text);
        }catch{}

        if (amount!=0)
        {
            try
            {

                customerCreditRecord ccRec = new customerCreditRecord();
                ccRec.customer_no = this.customer_acct;
                ccRec.elt_account_number = elt_account_number;
                ccRec.customer_name = this.lstCustomerName.Text;

                ccRec.credit = Decimal.Parse(this.txtNewCredit.Text);
                ccRec.memo = this.txtDescription.Text;
                ccRec.tran_date = DateTime.Today.ToString();
                ccRec.all_accounts_journal_list = createAllAccountsJournalEntry();
                ccRec.ref_no = this.txtRefNo.Text;
                try
                {
                    ccRec.invoice_no = Int32.Parse(this.txtInvoiceNo.Text);
                }
                catch { }
                ccRec.is_refund = "N";
                if (this.rCreditRefund.SelectedValue == "Credit")
                {
                    ccRec.is_refund = "Y";
                }
                this.ccMgr.insert_customer_credit(ccRec);
                this.txtNewCredit.Text = "0.00";
                this.txtCurrentCredit.Text = ccMgr.getcustomerCredit(customer_acct).ToString("N2");
            }
            catch (Exception ex)
            {
                Response.Write(ex.ToString());

            }
        }
    }
   
    protected ArrayList createAllAccountsJournalEntry()
    {
        ArrayList list = new ArrayList();
        GLRecord glRec = glMgr.getDefaultCustomerCreditAcct();
        GLRecord glRec2 = glMgr.getDefaultRetainedEarningAcct();

        try
        {
            //CREATEING Liability Entity -> Customer Credit 
            Decimal amount = Decimal.Parse(this.txtNewCredit.Text);
           
            AllAccountsJournalRecord rec = new AllAccountsJournalRecord();
            rec.elt_account_number = Int32.Parse(elt_account_number);
            rec.gl_account_number = glRec.Gl_account_number;
            rec.gl_account_name = glRec.Gl_account_desc;

            // rec.tran_num = payment_no;
            rec.tran_type = "CCR";
            rec.tran_date = DateTime.Today.ToShortDateString();
            rec.customer_number = this.customer_acct;
            rec.customer_name = this.lstCustomerName.Text;
            rec.memo = this.txtDescription.Text;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
            rec.debit_amount = 0;
            rec.credit_amount = -amount;//decrease 
            list.Add(rec);


            //CREATE RETAINED EARNING ENTRY

            AllAccountsJournalRecord rec2 = new AllAccountsJournalRecord();
            rec2.elt_account_number = Int32.Parse(elt_account_number);
            rec2.gl_account_number = glRec2.Gl_account_number;
            rec2.gl_account_name = glRec2.Gl_account_desc;

            // rec.tran_num = payment_no;
            rec2.tran_type = "CCR";
            rec2.tran_date = DateTime.Today.ToShortDateString();
            rec2.customer_number = this.customer_acct;
            rec2.customer_name = this.lstCustomerName.Text;
            rec2.memo = this.txtDescription.Text;

            rec2.debit_amount = amount;//decrease
            rec2.credit_amount = 0;
            list.Add(rec2);           
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return list;
    }
    
}
