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

public partial class ASPX_AccountingTasks_BankReconcileStep2 : System.Web.UI.Page
{
    private ReconcileRecord rcRec;
    private ReconcileManager reconMgr;
    private string elt_account_number;
    public string user_id, login_name, user_right;
    private string ConnectStr;
    private DataTable dtReceivement;
    private DataTable dtPayment;
    private GLManager glMgr;
    private int bank_acct;
    private Decimal total_receive;
    private Decimal total_pay;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());
        reconMgr = new ReconcileManager(elt_account_number);
        glMgr=new GLManager(elt_account_number);
        bank_acct=0;
        try
        {
            bank_acct = Int32.Parse(Request.QueryString["bank_acct"]);           
        }
        catch { }       
        
        if (!IsPostBack)
        {                   
        }
        else
        {            
            rcRec = (ReconcileRecord)Session["rcRec"]; 
            if (rcRec == null)
            {
                string script2 = "<script language='javascript'>";
                script2 += "alert('You must start from step 1 !');";            
                script2 += "</script>";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script2);
                Session["FROM_2ND"] = "Y";
                Response.Redirect("BankReconcileStep1.aspx");                   
            }
            
            if (rcRec.dtPayment == null )
            { 
                rcRec.dtPayment = reconMgr.getAllPaymentDT_All_Accounts_Journal(rcRec);
            }
            else
            {
                //rcRec.dtPayment = reconMgr.getAllPaymentDT(rcRec);
            }

            if (rcRec.dtReceivement == null)
            {               
                rcRec.dtReceivement = reconMgr.getAllReceivementDT_All_Accounts_Journal(rcRec);
            }
            else
            {               
                //rcRec.dtReceivement = reconMgr.getAllReceivementDT(rcRec);
            }

            bool service_charge_exist = true;
            bool interest_earned_exist = true;

            decimal sc = 0;
            decimal ic = 0;
            try
            {
                 service_charge_exist = (bool)Session["service_charge_exist"];
                 interest_earned_exist = (bool)Session["interest_earned_exist"];

                sc = rcRec.service_charge;
                ic = rcRec.interest_earned;
            }
            catch { }
            if (!service_charge_exist && sc!=0)
            {
                ReconcilePaymentDetailRecord RPD =reconMgr.getServiceChargeForReconcile_All_Accounts_Journal(rcRec);
                if (RPD.credit_amount != 0)
                {
                    DataRow newrow = rcRec.dtPayment.NewRow();
                    newrow["customer_name"] = RPD.customer_name;
                    newrow["customer_number"] = RPD.customer_number;
                    newrow["credit_amount"] = RPD.credit_amount;
                    newrow["elt_account_number"] = RPD.elt_account_number;
                    newrow["gl_account_name"] = RPD.gl_account_name;
                    newrow["gl_account_number"] = RPD.gl_account_number;
                    newrow["tran_date"] = RPD.tran_date;
                    newrow["tran_num"] = RPD.tran_num;
                    newrow["tran_seq_num"] = RPD.tran_seq_num;
                    newrow["tran_type"] = RPD.tran_type;
                    newrow["memo"] = RPD.memo;
                    rcRec.dtPayment.Rows.Add(newrow);
                }

            }
            if (!interest_earned_exist && ic!=0)
            {
                ReconcileReceivementDetailRecord RRD = reconMgr.getInterestEernedForReconcile_All_Accounts_Journal(rcRec);

                if (RRD.debit_amount != 0)
                {
                    DataRow newrow = rcRec.dtReceivement.NewRow();
                    newrow["customer_name"] = RRD.customer_name;
                    newrow["customer_number"] = RRD.customer_number;
                    newrow["debit_amount"] = RRD.debit_amount;
                    newrow["elt_account_number"] = RRD.elt_account_number;
                    newrow["gl_account_name"] = RRD.gl_account_name;
                    newrow["gl_account_number"] = RRD.gl_account_number;
                    newrow["tran_date"] = RRD.tran_date;
                    newrow["tran_num"] = RRD.tran_num;
                    newrow["tran_seq_num"] = RRD.tran_seq_num;
                    newrow["tran_type"] = RRD.tran_type;
                    newrow["memo"] = RRD.memo;
                    rcRec.dtReceivement.Rows.Add(newrow);
                }
            }
            Session["service_charge_exist"] = null;
            Session["interest_earned_exist"] = null;

            dtReceivement = rcRec.dtReceivement;
            dtPayment = rcRec.dtPayment;

            Session["dtReceivement"] = rcRec.dtReceivement;
            Session["dtPayment"] = rcRec.dtPayment; 

            this.lblReconcileDate.Text = DateTime.Today.ToShortDateString();
            this.lblSTEndingDate.Text = rcRec.statement_ending_date;
            decimal onStatement = rcRec.statement_ending_balance - rcRec.opening_balance;
            txtOnStatement.Text = onStatement.ToString();
            this.lblBank.Text = glMgr.getGLDescription(this.rcRec.bank_account_number);
            
            Session["rcRec"] = rcRec;

            rebindGridViewPayment();
            rebindGridViewReceivement();
        }
    }

    protected void rebindGridViewPayment()
    {
        dtPayment = (DataTable)Session["dtPayment"];
        Decimal toTalAmount = 0;
        this.GridViewPayment.DataSource = dtPayment;       
        this.GridViewPayment.DataBind();
        int start_index = GridViewPayment.PageIndex * 10;
        for (int i = 0; i < GridViewPayment.Rows.Count; i++)
        {
            Image Check=((Image)GridViewPayment.Rows[i].FindControl("check"));
            HiddenField hCheck = ((HiddenField)GridViewPayment.Rows[i].FindControl("hCheck"));
            HiddenField hAmount = ((HiddenField)GridViewPayment.Rows[i].FindControl("hAmount"));
            hAmount.Value = dtPayment.Rows[start_index+i]["credit_amount"].ToString();
            Check.Attributes.Add("onclick", "checkPayment("+Check.ClientID+","+hAmount.ClientID+","+hCheck.ClientID+")");

            if (dtPayment.Rows[start_index+i]["is_checked"].ToString() == "Y")
            {
                Check.ImageUrl = "images/mark_x.gif";
                hCheck.Value = "Y";
               
            }
            else
            {
                Check.ImageUrl = "images/mark_o.gif";
                hCheck.Value = "N";
            }
        }

        for (int i = 0; i < dtPayment.Rows.Count; i++)
        {
            if (dtPayment.Rows[i]["is_checked"].ToString() == "Y")
            {

                toTalAmount += Decimal.Parse(dtPayment.Rows[i]["credit_amount"].ToString());
            }
        }
        this.txtTotalPayment.Text = toTalAmount.ToString();
        Decimal tmpamt=Decimal.Parse(this.txtTotalPayment.Text) + Decimal.Parse(this.txtTotalReceivement.Text);
        this.txtTotalCleared.Text = tmpamt.ToString();
    }

    protected void rebindGridViewReceivement()
    {
        dtReceivement = (DataTable)Session["dtReceivement"];      
        this.GridViewReceivement.DataSource = dtReceivement;
        this.GridViewReceivement.DataBind();
        Decimal toTalAmount = 0;
        int start_index = GridViewReceivement.PageIndex * 10;
        for (int i = 0; i < GridViewReceivement.Rows.Count; i++)
        {
            Image Check = ((Image)GridViewReceivement.Rows[i].FindControl("check"));
            HiddenField hCheck = ((HiddenField)GridViewReceivement.Rows[i].FindControl("hCheck"));
            HiddenField hAmount = ((HiddenField)GridViewReceivement.Rows[i].FindControl("hAmount"));
            hAmount.Value = dtReceivement.Rows[start_index + i]["debit_amount"].ToString();
            
            Check.Attributes.Add("onclick", "checkReceivement(" + Check.ClientID + "," + hAmount.ClientID + "," + hCheck.ClientID + ")");          

            if (dtReceivement.Rows[start_index+i]["is_checked"].ToString() == "Y")
            {
                Check.ImageUrl = "images/mark_x.gif";
                hCheck.Value = "Y";               
            }
            else
            {
                Check.ImageUrl = "images/mark_o.gif";
                hCheck.Value = "N";
            }
        }
        for (int i = 0; i < dtReceivement.Rows.Count; i++)
        {
            if (dtReceivement.Rows[i]["is_checked"].ToString() == "Y")
            {

                toTalAmount += Decimal.Parse(dtReceivement.Rows[i]["debit_amount"].ToString());
            }
        }

        this.txtTotalReceivement.Text = toTalAmount.ToString();
        Decimal tmpamt = Decimal.Parse(this.txtTotalPayment.Text) + Decimal.Parse(this.txtTotalReceivement.Text);
        this.txtTotalCleared.Text = tmpamt.ToString();
    }

    protected void getCheckedFromGridViewPayment()
    {
        dtPayment = (DataTable)Session["dtPayment"];
        int start_index = GridViewPayment.PageIndex * 10;
        for (int i = 0; i < GridViewPayment.Rows.Count; i++)
        {
            Image Check = ((Image)GridViewPayment.Rows[i].FindControl("check"));
            string hCheck = Request[((HiddenField)GridViewPayment.Rows[i].FindControl("hCheck")).UniqueID];
            if (hCheck == "Y")
            {
                dtPayment.Rows[start_index + i]["is_checked"] = "Y";               
            }
            else
            {
                dtPayment.Rows[start_index + i]["is_checked"] = "N";
            }
        }
        Session["dtPayment"] = dtPayment;
    }

    protected void getCheckedFromGridViewReceivement()
    {
        dtReceivement = (DataTable)Session["dtReceivement"];
        int start_index = GridViewReceivement.PageIndex * 10;
        for (int i = 0; i < GridViewReceivement.Rows.Count; i++)
        {
            Image Check = ((Image)GridViewReceivement.Rows[i].FindControl("check"));
            string hCheck = Request[((HiddenField)GridViewReceivement.Rows[i].FindControl("hCheck")).UniqueID];
            if (hCheck == "Y")
            {
                dtReceivement.Rows[start_index + i]["is_checked"] = "Y";
            }
            else
            {
                dtReceivement.Rows[start_index + i]["is_checked"] = "N";
            }
        }
        Session["dtReceivement"] = dtReceivement;
    }

   
    protected void rdSelectOrClearReceivement_SelectedIndexChanged(object sender, EventArgs e)
    {
        getCheckedFromGridViewReceivement();
        getCheckedFromGridViewPayment();
        dtReceivement = (DataTable)Session["dtReceivement"];
        Decimal toTalAmount=0;
        if (rdSelectOrClearReceivement.SelectedIndex == 0)
        {
            for (int i = 0; i < dtReceivement.Rows.Count; i++)
            {
                dtReceivement.Rows[i]["is_checked"] = "Y";
                toTalAmount += Decimal.Parse(dtReceivement.Rows[i]["debit_amount"].ToString());
            }
        }
        else
        {
            for (int i = 0; i < dtReceivement.Rows.Count; i++)
            {
                dtReceivement.Rows[i]["is_checked"] = "N";
            }
        }
        Session["dtReceivement"] = dtReceivement;
        rebindGridViewReceivement();
        rebindGridViewPayment();
        this.txtTotalReceivement.Text = toTalAmount.ToString();
    }


    protected void rdSelectOrClearPayment_SelectedIndexChanged(object sender, EventArgs e)
    {
        getCheckedFromGridViewReceivement();
        getCheckedFromGridViewPayment();
        dtPayment = (DataTable)Session["dtPayment"];
        Decimal toTalAmount = 0;
        if (rdSelectOrClearPayment.SelectedIndex == 0)
        {
            for (int i = 0; i < dtPayment.Rows.Count; i++)
            {
                dtPayment.Rows[i]["is_checked"] = "Y";
                toTalAmount += Decimal.Parse(dtPayment.Rows[i]["credit_amount"].ToString());
            }
        }
        else
        {
            for (int i = 0; i < dtPayment.Rows.Count; i++)
            {
                dtPayment.Rows[i]["is_checked"] = "N";
            }
        }
        Session["dtPayment"] = dtPayment;
        rebindGridViewReceivement();
        rebindGridViewPayment();
        this.txtTotalPayment.Text = toTalAmount.ToString(); 
    }


    protected void GridViewReceivement_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        getCheckedFromGridViewReceivement();
        getCheckedFromGridViewPayment();   
        this.GridViewReceivement.PageIndex = e.NewPageIndex;
        this.rebindGridViewReceivement();
    }


    protected void GridViewPayment_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        getCheckedFromGridViewReceivement();
        getCheckedFromGridViewPayment();        
        this.GridViewPayment.PageIndex = e.NewPageIndex;
        this.rebindGridViewPayment();
    }

   

    protected void goBacktoFirst()
    {
        string script2 = "<script language='javascript'>";
        script2 += "form1.method='Post';";
        script2 += "form1.action='BankReconcileStep1.aspx?FROM_2ND=Y';";
        script2 += "form1.__VIEWSTATE.name = 'NOVIEWSTATE';";
        script2 += "form1.submit();";
        script2 += "</script>";
        this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script2);
    }

   
    protected void btnReconcile_Click(object sender, EventArgs e)
    {
        rcRec = (ReconcileRecord)Session["rcRec"];
        getCheckedFromGridViewPayment();
        getCheckedFromGridViewReceivement();
        bool isReceiveChecked = false;
        bool isPayChecked = false;
        Decimal totalCleared = 0;
        dtPayment = (DataTable)Session["dtPayment"];
        dtReceivement = (DataTable)Session["dtReceivement"];
        rcRec.dtReceivement = this.dtReceivement;
        rcRec.recon_state = "C";
        rcRec.dtPayment = this.dtPayment;
        ArrayList receivementDetailList = new ArrayList();
        ArrayList paymentDetailList = new ArrayList();

        for (int i = 0; i < this.dtReceivement.Rows.Count; i++)
        {
            ReconcileReceivementDetailRecord RRDRec = new ReconcileReceivementDetailRecord();
            RRDRec.customer_name = rcRec.dtReceivement.Rows[i]["customer_name"].ToString();
            RRDRec.customer_number = Int32.Parse(rcRec.dtReceivement.Rows[i]["customer_number"].ToString());
            RRDRec.debit_amount = Decimal.Parse(rcRec.dtReceivement.Rows[i]["debit_amount"].ToString());

            RRDRec.elt_account_number = Int32.Parse(rcRec.dtReceivement.Rows[i]["elt_account_number"].ToString());
            RRDRec.gl_account_name = rcRec.dtReceivement.Rows[i]["gl_account_name"].ToString();
            RRDRec.gl_account_number = Int32.Parse(rcRec.dtReceivement.Rows[i]["gl_account_number"].ToString());
            RRDRec.tran_date = rcRec.dtReceivement.Rows[i]["tran_date"].ToString();
            RRDRec.tran_num = Int32.Parse(rcRec.dtReceivement.Rows[i]["tran_num"].ToString());
            RRDRec.tran_seq_num = Int32.Parse(rcRec.dtReceivement.Rows[i]["tran_seq_num"].ToString());
            RRDRec.tran_type = rcRec.dtReceivement.Rows[i]["tran_type"].ToString();
            RRDRec.memo = rcRec.dtReceivement.Rows[i]["memo"].ToString();

            if (rcRec.dtReceivement.Rows[i]["is_checked"].ToString() == "Y")
            {
                RRDRec.is_recon_cleared = "Y";
                totalCleared += RRDRec.debit_amount;
                isReceiveChecked = true;
            }
            else
            {
                RRDRec.is_recon_cleared = "N";
            }
            receivementDetailList.Add(RRDRec);
        }

        for (int i = 0; i < this.dtPayment.Rows.Count; i++)
        {
            ReconcilePaymentDetailRecord RPDRec = new ReconcilePaymentDetailRecord();
            RPDRec.customer_name = rcRec.dtPayment.Rows[i]["customer_name"].ToString();
            RPDRec.customer_number = Int32.Parse(rcRec.dtPayment.Rows[i]["customer_number"].ToString());
            RPDRec.credit_amount = Decimal.Parse(rcRec.dtPayment.Rows[i]["credit_amount"].ToString());
            RPDRec.elt_account_number = Int32.Parse(rcRec.dtPayment.Rows[i]["elt_account_number"].ToString());
            RPDRec.gl_account_name = rcRec.dtPayment.Rows[i]["gl_account_name"].ToString();
            RPDRec.gl_account_number = Int32.Parse(rcRec.dtPayment.Rows[i]["gl_account_number"].ToString());
            RPDRec.tran_date = rcRec.dtPayment.Rows[i]["tran_date"].ToString();
            RPDRec.tran_num = Int32.Parse(rcRec.dtPayment.Rows[i]["tran_num"].ToString());
            RPDRec.tran_seq_num = Int32.Parse(rcRec.dtPayment.Rows[i]["tran_seq_num"].ToString());
            RPDRec.tran_type = rcRec.dtPayment.Rows[i]["tran_type"].ToString();
            RPDRec.memo = rcRec.dtPayment.Rows[i]["memo"].ToString();

            if (rcRec.dtPayment.Rows[i]["is_checked"].ToString() == "Y")
            {
                RPDRec.is_recon_cleared = "Y";
                totalCleared += RPDRec.credit_amount;
                isPayChecked = true;
            }
            else
            {
                RPDRec.is_recon_cleared = "N";
            }
            paymentDetailList.Add(RPDRec);
        }
        rcRec.reconcile_date = DateTime.Today.ToShortDateString();
        rcRec.receivementDetailList = receivementDetailList;
        rcRec.paymentDetailList = paymentDetailList;
        rcRec.AAJEntryList = new ArrayList();// NO TRANSACTION ON RECON
        rcRec.system_balance_asof_statement = Math.Round(glMgr.getBankBalanceUptoADate(rcRec.bank_account_number, rcRec.statement_ending_date), 2);
        rcRec.system_balance_asof_recon_date = Math.Round(glMgr.getBankBalanceUptoADate(rcRec.bank_account_number, DateTime.Today.ToShortDateString()), 2);
        rcRec.total_cleared = Math.Round(totalCleared, 2);
        rcRec.total_uncleared = Math.Round((rcRec.statement_ending_balance - rcRec.opening_balance) - totalCleared, 2);
        rcRec.total_unclear_after_statement = Math.Round(this.reconMgr.getAllUnclearedTransationAmountWithinPeriod(rcRec.statement_ending_date, DateTime.Today.ToShortDateString(), rcRec.bank_account_number), 2);

        bool return_val = false;
        if (totalCleared == (rcRec.statement_ending_balance - rcRec.opening_balance) && isReceiveChecked && isPayChecked)
        {
            if (rcRec.recon_id == 0)
            {
                return_val = reconMgr.insert_Entry(ref rcRec);
            }
            else
            {
                return_val = reconMgr.update_Entry(rcRec);
            }
            if (return_val)
            {
                Response.Redirect("BankReconcileReport.aspx?recon_id=" + rcRec.recon_id.ToString());
                Session["rcRec"] = null;
            }
        }
        else
        {
            Session["rcRec"] = rcRec;
            string script2;
            if (!isPayChecked && !isReceiveChecked)
            {
                script2 = "<script language='javascript'>";
                script2 += "alert('Select at least one item!')";
                script2 += "</script>";
            }
            else
            {
                script2 = "<script language='javascript'>";
                script2 += "alert('total Cleared does not match with the statement!')";
                script2 += "</script>";
            }
            rebindGridViewPayment();
            rebindGridViewReceivement();
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script2);
        }        
    }

    public void prepareReconCile()
    {
        rcRec = (ReconcileRecord)Session["rcRec"];
        getCheckedFromGridViewPayment();
        getCheckedFromGridViewReceivement();
        dtPayment = (DataTable)Session["dtPayment"];
        dtReceivement = (DataTable)Session["dtReceivement"];
        rcRec.dtReceivement = this.dtReceivement;
        rcRec.recon_state = "I";
        rcRec.dtPayment = this.dtPayment;
        ArrayList receivementDetailList = new ArrayList();
        ArrayList paymentDetailList = new ArrayList();

        for (int i = 0; i < this.dtReceivement.Rows.Count; i++)
        {
            ReconcileReceivementDetailRecord RRDRec = new ReconcileReceivementDetailRecord();
            RRDRec.customer_name = rcRec.dtReceivement.Rows[i]["customer_name"].ToString();
            RRDRec.customer_number = Int32.Parse(rcRec.dtReceivement.Rows[i]["customer_number"].ToString());
            RRDRec.debit_amount = Decimal.Parse(rcRec.dtReceivement.Rows[i]["debit_amount"].ToString());
            RRDRec.elt_account_number = Int32.Parse(rcRec.dtReceivement.Rows[i]["elt_account_number"].ToString());
            RRDRec.gl_account_name = rcRec.dtReceivement.Rows[i]["gl_account_name"].ToString();
            RRDRec.gl_account_number = Int32.Parse(rcRec.dtReceivement.Rows[i]["gl_account_number"].ToString());
            RRDRec.tran_date = rcRec.dtReceivement.Rows[i]["tran_date"].ToString();
            RRDRec.tran_num = Int32.Parse(rcRec.dtReceivement.Rows[i]["tran_num"].ToString());
            RRDRec.tran_seq_num = Int32.Parse(rcRec.dtReceivement.Rows[i]["tran_seq_num"].ToString());
            RRDRec.tran_type = rcRec.dtReceivement.Rows[i]["tran_type"].ToString();
            RRDRec.memo = rcRec.dtReceivement.Rows[i]["memo"].ToString();
            if (rcRec.dtReceivement.Rows[i]["is_checked"].ToString() == "Y")
            {
                RRDRec.is_recon_cleared = "Y";
            }
            else
            {
                RRDRec.is_recon_cleared = "N";
            }
            receivementDetailList.Add(RRDRec);
        }
        for (int i = 0; i < this.dtPayment.Rows.Count; i++)
        {
            ReconcilePaymentDetailRecord RPDRec = new ReconcilePaymentDetailRecord();
            RPDRec.customer_name = rcRec.dtPayment.Rows[i]["customer_name"].ToString();
            RPDRec.customer_number = Int32.Parse(rcRec.dtPayment.Rows[i]["customer_number"].ToString());
            RPDRec.credit_amount = Decimal.Parse(rcRec.dtPayment.Rows[i]["credit_amount"].ToString());
            RPDRec.elt_account_number = Int32.Parse(rcRec.dtPayment.Rows[i]["elt_account_number"].ToString());
            RPDRec.gl_account_name = rcRec.dtPayment.Rows[i]["gl_account_name"].ToString();
            RPDRec.gl_account_number = Int32.Parse(rcRec.dtPayment.Rows[i]["gl_account_number"].ToString());
            RPDRec.tran_date = rcRec.dtPayment.Rows[i]["tran_date"].ToString();
            RPDRec.tran_num = Int32.Parse(rcRec.dtPayment.Rows[i]["tran_num"].ToString());
            RPDRec.tran_seq_num = Int32.Parse(rcRec.dtPayment.Rows[i]["tran_seq_num"].ToString());
            RPDRec.tran_type = rcRec.dtPayment.Rows[i]["tran_type"].ToString();
            RPDRec.memo = rcRec.dtPayment.Rows[i]["memo"].ToString();
            if (rcRec.dtPayment.Rows[i]["is_checked"].ToString() == "Y")
            {
                RPDRec.is_recon_cleared = "Y";
            }
            else
            {
                RPDRec.is_recon_cleared = "N";
            }
            paymentDetailList.Add(RPDRec);
        }
        rcRec.receivementDetailList = receivementDetailList;
        rcRec.paymentDetailList = paymentDetailList;
        rcRec.AAJEntryList = new ArrayList();// NO TRANSACTION ON RECON
        Session["rcRec"] = rcRec;

    }

    protected void btnReconcileLater_Click(object sender, EventArgs e)
    {
        prepareReconCile();
        rcRec = (ReconcileRecord)Session["rcRec"];
        bool return_val = false;
        if (rcRec.recon_id == 0)
        {
            return_val=reconMgr.insert_Entry(ref rcRec);
        }
        else
        {
            return_val=reconMgr.update_Entry(rcRec);
        }
        if (return_val)
        {
            Session["dtReceivement"] = null;
            Session["dtPayment"] = null;
            Session["rcRec"] = null;
            Session["FROM_2ND"] = null; 
            Response.Redirect("BankReconcileStep1.aspx");
        }       
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        rcRec = (ReconcileRecord)Session["rcRec"];
        if (reconMgr.deleteReconcile(rcRec))
        {
            Session["dtReceivement"] = null;
            Session["dtPayment"] = null;
            Session["rcRec"] = null;
            Session["FROM_2ND"] = null;
            Response.Redirect("BankReconcileStep1.aspx");
        }
    }

    protected void btnBack_Click(object sender, EventArgs e)
    {
       // if (reconMgr.deleteReconcile(rcRec))
        {
            prepareReconCile();
            Session["FROM_2ND"] = "Y";
            Response.Redirect("BankReconcileStep1.aspx");
        }
    }
}
