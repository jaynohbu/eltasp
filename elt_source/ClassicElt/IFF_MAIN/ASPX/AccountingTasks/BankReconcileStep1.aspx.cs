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

public partial class ASPX_AccountingTasks_BankReconcileStep1 : System.Web.UI.Page
{
    private GLManager glMgr;
    private ArrayList BankAccountList;
    private string elt_account_number;
    public string user_id, login_name, user_right;
    private string ConnectStr;
    private ReconcileManager rcMgr;
    private ReconcileRecord rcRec;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());
       
        if(this.dStEnding.Text=="")
        {
            this.dStEnding.Text = DateTime.Today.ToShortDateString();
        }
        if (this.dInterestEarned.Text == "")
        {
           this.dInterestEarned.Text = DateTime.Today.ToShortDateString();
        }    
        if(this.dServiceCharge.Text == "")
        {
             this.dServiceCharge.Text = DateTime.Today.ToShortDateString();
        }

        glMgr = new GLManager(elt_account_number);
       
        rcMgr = new ReconcileManager(elt_account_number);
      
        this.txtOpeningBalance.ReadOnly = true;
        this.txtOpeningBalance.BackColor = System.Drawing.Color.Silver;

        GLRecord gRec = new GLRecord();
        gRec.Gl_account_desc = "SELECT ONE";
        gRec.Gl_account_number = -1;
        
        BankAccountList = glMgr.getGLAcctList(Account.BANK);
        BankAccountList.Insert(0, gRec);
        bool FromSecond = false;
        try
        {
            if (Session["FROM_2ND"].ToString() == "Y")
            {
                FromSecond = true;
                Session["FROM_2ND"] = null;
            }
        }
        catch { }

        if (!IsPostBack||FromSecond)
        {
            rcRec = (ReconcileRecord)Session["rcRec"]; 
            this.ddlBankAcct.DataSource = BankAccountList;
            this.ddlBankAcct.DataTextField = "Gl_account_desc";
            this.ddlBankAcct.DataValueField = "Gl_account_number";
            this.ddlBankAcct.DataBind();

            if (FromSecond)
            {
                
                for (int i = 0; i < ddlBankAcct.Items.Count; i++)
                {
                    if (ddlBankAcct.Items[i].Value == rcRec.bank_account_number.ToString())
                    {
                        ddlBankAcct.SelectedIndex = i;
                    }
                }
                this.txtInterestEarned.Text = rcRec.interest_earned.ToString();
                this.txtOpeningBalance.Text = rcRec.opening_balance.ToString();
                this.txtServiceCharge.Text = rcRec.service_charge.ToString();
                this.dServiceCharge.Text = rcRec.service_charge_date;
                this.dStEnding.Text = rcRec.statement_ending_date;
                this.txtEndingBalance.Text = rcRec.statement_ending_balance.ToString();

            }
        }
        else
        {
            rcRec = (ReconcileRecord)Session["rcRec"];           
           
            if (rcRec == null)
            {
                rcRec = new ReconcileRecord();
                Session["rcRec"] = rcRec;
            }
           // setRecord();
        }
        Session["rcRec"] = rcRec;
    }


    protected void ddlBankAcct_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlBankAcct.SelectedIndex != 0)
        {
            if(!searchMostRecent(Int32.Parse(ddlBankAcct.SelectedValue)))
            {

                this.txtOpeningBalance.ReadOnly = false;
                this.txtOpeningBalance.BackColor = System.Drawing.Color.White;
            }
        }
       
    }

    public bool searchMostRecent(int bank_acct)
    {
        bool return_val = false;
          ReconcileRecord rcRecTmp = rcMgr.get_LastEntryForBank(bank_acct);
          if (rcRecTmp != null)
          {
              return_val = true;

              if (rcRecTmp.recon_id != 0)
              {
                  if (rcRecTmp.recon_state == "I")// If there is somthing incomplete 
                  {
                      rcRec = rcRecTmp;

                      string script2 = "<script language='javascript'>";
                      script2 += "form1.method='Post';";
                      script2 += "form1.action='BankReconcileStep2.aspx?PostFromFirst=Y&bank_acct=" + rcRec.bank_account_number + "';";
                      script2 += "form1.__VIEWSTATE.name = 'NOVIEWSTATE';";
                      script2 += "form1.submit();";
                      script2 += "</script>";
                      this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script2);
                  }
                  else//set the beginning date, opening balance from the last one 
                  {
                      rcRec = (ReconcileRecord)Session["rcRec"];
                      rcRec.recon_beginning_date = rcRecTmp.statement_ending_date;
                      rcRec.opening_balance = rcRecTmp.statement_ending_balance;
                      rcRec.recon_state = "I";
                      this.txtOpeningBalance.Text = rcRecTmp.statement_ending_balance.ToString();
                      rcRec.bank_account_number = Int32.Parse(ddlBankAcct.SelectedValue);
                  }

              }
          }
        Session["rcRec"] = rcRec;
        return return_val;
    }


    protected void btnCancel_Click(object sender, EventArgs e)
    {
        this.txtOpeningBalance.Text = "0.00";
        this.ddlBankAcct.SelectedIndex = 0;
        this.txtInterestEarned.Text = "0.00";
        this.txtServiceCharge.Text = "0.00";
        this.txtEndingBalance.Text = "0.00";
        Session["rcRec"] = null;
    }

    protected ArrayList createAllAccountsJournalEntry()
    {
        ArrayList list = new ArrayList();
        rcRec = (ReconcileRecord)Session["rcRec"];
        try
        {
            if (rcRec.interest_earned != 0)
            {
                //CREATEING INTEREST INCOME ENTRY----------> AR decreases 
                GLRecord glRec = glMgr.getDefaultInterestIncomeAcct();

                AllAccountsJournalRecord rec = new AllAccountsJournalRecord();
                rec.elt_account_number = Int32.Parse(elt_account_number);
                rec.gl_account_number = glRec.Gl_account_number;
                rec.gl_account_name = glRec.Gl_account_desc;
                rec.tran_num = rcRec.recon_id;
                rec.tran_type = "REC";
                rec.tran_date = dInterestEarned.Text;

                // rec.customer_number = 
                rec.customer_name = glMgr.getGLDescription(rcRec.bank_account_number);
                rec.memo = "Reconcile -- Interest Income";
                rec.debit_amount = 0;
                rec.credit_amount = -rcRec.interest_earned;
                list.Add(rec);

                //CREATEING BANK DEPOSIT ENTRY FOR INTEREST INCOME
                AllAccountsJournalRecord rec2 = new AllAccountsJournalRecord();
                rec2.elt_account_number = Int32.Parse(elt_account_number);
                rec2.gl_account_number = rcRec.bank_account_number;
                rec2.gl_account_name = glMgr.getGLDescription(rcRec.bank_account_number);
                rec2.tran_num = rcRec.recon_id;
                rec2.tran_type = "REC";
                rec2.tran_date = rcRec.interested_earned_date;

                rec2.customer_name = glMgr.getGLDescription(rcRec.bank_account_number);
                rec2.memo = "Reconcile -- Interest Income";
                rec2.debit_amount = rcRec.interest_earned;
                rec2.credit_amount = 0;
                list.Add(rec2);
            }

            if (rcRec.service_charge != 0)
            {              

                //CREATEING SERVICE CHARGE EXPENSE ENTRY
                GLRecord glRec2 = glMgr.getDefaultBankServiceChargeAcct();
                AllAccountsJournalRecord rec3 = new AllAccountsJournalRecord();
                rec3.elt_account_number = Int32.Parse(elt_account_number);
                rec3.gl_account_number = glRec2.Gl_account_number;
                rec3.gl_account_name = glRec2.Gl_account_desc;
                rec3.tran_num = rcRec.recon_id;
                rec3.tran_type = "REC";
                rec3.tran_date = rcRec.service_charge_date;

                //rec3.customer_number = I
                rec3.customer_name = glMgr.getGLDescription(rcRec.bank_account_number);
                rec3.memo = "Reconcile -- Bank Service Charge";//이것을 바꿀때는 rcMgr.getServiceChargeForReconcile_All_Accounts_Journal 도 바꾸기
                rec3.debit_amount = rcRec.service_charge;
                rec3.credit_amount = 0;               
                list.Add(rec3);

                //CREATEING BANK DEPOSIT ENTRY
                AllAccountsJournalRecord rec4 = new AllAccountsJournalRecord();
                rec4.elt_account_number = Int32.Parse(elt_account_number);
                rec4.gl_account_number = rcRec.bank_account_number;
                rec4.gl_account_name = glMgr.getGLDescription(rcRec.bank_account_number);
                rec4.tran_num = rcRec.recon_id;             

                rec4.tran_type = "REC";
                rec4.tran_date = rcRec.service_charge_date;
                //rec4.customer_number 
                rec4.customer_name = glMgr.getGLDescription(rcRec.bank_account_number);
                rec4.memo = "Reconcile -- Bank Service Charge";
                rec4.debit_amount = 0;
                rec4.credit_amount = -rcRec.service_charge;               
                list.Add(rec4);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return list;
    }

    protected void btnOK_Click(object sender, EventArgs e)
    {

        if (this.ddlBankAcct.SelectedIndex != 0)
        {
            bool service_charge_exist = false;
            bool interest_earned_exist = false;

            setRecord();
            rcRec = (ReconcileRecord)Session["rcRec"];
            int prevId = rcRec.recon_id;

            if (prevId != 0)
            {
                for (int i = 0; i < rcRec.dtPayment.Rows.Count; i++)
                {
                    if (rcRec.dtPayment.Rows[i]["memo"].ToString() == "Reconcile -- Bank Service Charge")
                    {
                        if (rcRec.service_charge != 0)
                        {
                            rcRec.dtPayment.Rows[i]["credit_amount"] = -rcRec.service_charge;
                            service_charge_exist = true;
                        }
                        else
                        {
                            rcRec.dtPayment.Rows.RemoveAt(i);
                        }
                    }
                }


                for (int i = 0; i < rcRec.dtReceivement.Rows.Count; i++)
                {
                    if (rcRec.dtReceivement.Rows[i]["memo"].ToString() == "Reconcile -- Interest Income")
                    {
                        if (rcRec.interest_earned != 0)
                        {
                            rcRec.dtReceivement.Rows[i]["debit_amount"] = rcRec.interest_earned;
                            interest_earned_exist = true;
                        }
                        else
                        {
                            rcRec.dtReceivement.Rows.RemoveAt(i);
                        }
                    }
                }
                rcMgr.deleteReconcile(rcRec);
                rcMgr.insert_Entry(ref rcRec);

                Session["service_charge_exist"] = service_charge_exist;
                Session["interest_earned_exist"] = interest_earned_exist;

            }
            else
            {
                rcMgr.insert_Entry(ref rcRec);
            }

            Session["rcRec"] = rcRec;
            string script2 = "<script language='javascript'>";
            script2 += "form1.method='Post';";
            script2 += "form1.action='BankReconcileStep2.aspx?bank_acct=" + rcRec.bank_account_number + "';";
            script2 += "form1.__VIEWSTATE.name = 'NOVIEWSTATE';";
            script2 += "form1.submit();";
            script2 += "</script>";
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script2);
        }

    }

    public void setRecord()
    {
        rcRec = (ReconcileRecord)Session["rcRec"];

        rcRec.opening_balance = Decimal.Parse(this.txtOpeningBalance.Text);
        rcRec.interest_earned = Decimal.Parse(this.txtInterestEarned.Text);
        rcRec.service_charge = Decimal.Parse(this.txtServiceCharge.Text);
        rcRec.service_charge_date = dServiceCharge.Text;
        rcRec.interested_earned_date = dInterestEarned.Text;
        rcRec.statement_ending_balance = Decimal.Parse(this.txtEndingBalance.Text);
        rcRec.interested_earned_date = this.dInterestEarned.Text;
        rcRec.service_charge_date = this.dServiceCharge.Text;
        rcRec.statement_ending_date = this.dStEnding.Text;
        rcRec.modified_date = DateTime.Today.ToShortDateString();
        rcRec.created_date = DateTime.Today.ToShortDateString();
        rcRec.bank_account_number = Int32.Parse(this.ddlBankAcct.SelectedValue);
       

        rcRec.AAJEntryList = createAllAccountsJournalEntry();
        rcRec.recon_state = "I";

        rcRec.interest_earned = Math.Round(rcRec.interest_earned, 2);
        rcRec.opening_balance = Math.Round(rcRec.opening_balance, 2);
        rcRec.service_charge = Math.Round(rcRec.service_charge, 2);
        rcRec.system_balance_asof_recon_date = Math.Round(rcRec.system_balance_asof_recon_date, 2);
        rcRec.system_balance_asof_statement = Math.Round(rcRec.system_balance_asof_statement, 2);

        Session["rcRec"] = rcRec;
    }
}
