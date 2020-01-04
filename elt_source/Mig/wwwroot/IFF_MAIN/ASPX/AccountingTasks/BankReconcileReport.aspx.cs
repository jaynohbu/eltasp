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
using CrystalDecisions.Shared;
public partial class ASPX_AccountingTasks_BankReconcileReport : System.Web.UI.Page
{

    private string elt_account_number;
    public string user_id, login_name, user_right;
    protected string ConnectStr;
    static public string windowName;
    public bool bReadOnly = false;
    protected string Default_Start_Date;
    protected string Default_End_Date;
    private ArrayList BankAccountList;
    private GLManager glMgr;
    private ReconcileManager rcMgr;
    private DataSet dsPDF;
    private ReconcileRecord rcRec;
    private int recon_id;
    protected void Page_Load(object sender, System.EventArgs e)
    {
        Session.LCID = 1033;

        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        windowName = Request.QueryString["WindowName"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        ConnectStr = (new igFunctions.DB().getConStr());

        bReadOnly = new igFunctions.DB().AUTH_CHECK(elt_account_number, user_id, ConnectStr, Request.ServerVariables["URL"].ToLower(), "");

        glMgr = new GLManager(elt_account_number);

        BankAccountList = glMgr.getGLAcctList(Account.BANK);
        GLRecord glRec = new GLRecord();
        glRec.Gl_account_desc = "SELECT ONE";
        glRec.Gl_account_number = -1;

        BankAccountList.Insert(0, glRec);
        rcMgr = new ReconcileManager(elt_account_number);

        if (!IsPostBack)
        {
            this.ddlBankAcct.DataSource = BankAccountList;
            this.ddlBankAcct.DataTextField = "Gl_account_desc";
            this.ddlBankAcct.DataValueField = "Gl_account_number";
            this.ddlBankAcct.DataBind();

            try
            {
                recon_id = Int32.Parse(Request.QueryString["recon_id"]);
                rcRec = rcMgr.get_Entry(recon_id);
                bindReconcile(rcRec);
            }
            catch
            {

            }
        }
        else
        {

        }

    }

    protected void searchAndBindData()
    {
        try
        {
            int ACCT = Int32.Parse(ddlBankAcct.SelectedValue);
            ArrayList ReconList = rcMgr.getAllReconcileRecordList(ACCT);
            Session["ReconList"] = ReconList;
            this.ddlSTED.DataSource = ReconList;
            this.ddlSTED.DataTextField = "Statement_ending_date";
            this.ddlSTED.DataBind();
        }
        catch { }
    }

    protected void ddlBankAcct_SelectedIndexChanged(object sender, EventArgs e)
    {
        searchAndBindData();
    }

    #region Web Form 디자이너에서 생성한 코드
    override protected void OnInit(EventArgs e)
    {
        InitializeComponent();
        base.OnInit(e);
    }
    private void InitializeComponent()
    {

    }
    #endregion

    private void bindReconcile(ReconcileRecord rcRec)
    {
        this.txtClearedTransactions.Text = rcRec.total_cleared.ToString();
        this.txtEndingBalance.Text = rcRec.statement_ending_balance.ToString();
        this.txtOpeningBalance.Text = rcRec.opening_balance.ToString();
        this.txtReconDate.Text = rcRec.reconcile_date;
        this.txtRegisterBalanceAsOfReconDT.Text = rcRec.system_balance_asof_recon_date.ToString();
        this.txtRegisterBalanceAsOfSTD.Text = rcRec.system_balance_asof_statement.ToString();
        this.txtSTEndDate.Text = rcRec.Statement_ending_date;
        this.txtUnclearedTransactionsAfterST.Text = rcRec.total_unclear_after_statement.ToString();
        this.txtUnclearedTransactionsAsOfSTED.Text = rcRec.total_uncleared.ToString();
        DataTable dtAll = this.rcMgr.getAllClearedDT(rcRec.recon_id);
        Session["dtAll"] = dtAll;
        this.GridView1.DataSource = dtAll.DefaultView;
        this.GridView1.DataBind();
        Session["selectedRcRec"] = rcRec;
    }


    protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
    {
        ArrayList ReconList = (ArrayList)Session["ReconList"];
        int index = this.ddlSTED.SelectedIndex;
        rcRec = (ReconcileRecord)ReconList[index];
        bindReconcile(rcRec);
    }


    protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
    {
        PDFPrint();
    }

    public void PDFPrint()
    {
        PrepReportDS();
        ReportSourceManager rsm;
        rsm = new ReportSourceManager();
        try
        {           
            rsm.LoadDataSet(dsPDF);
            rsm.LoadCompanyInfo(elt_account_number, Server.MapPath("../../ClientLogos/" + elt_account_number + ".jpg"));
            rsm.WriteXSD(Server.MapPath("../../CrystalReportResources/xsd/RECONCILE.xsd"));
            rsm.BindNow(Server.MapPath("../../CrystalReportResources/rpt/RECONCILE.rpt"));
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


    protected DataTable createGeneralDT()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add(new DataColumn("recon_id", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("bank_account_number", System.Type.GetType("System.Int32")));
        dt.Columns.Add(new DataColumn("bank_name", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("modified_date", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("created_date", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("statement_ending_date", System.Type.GetType("System.String")));
        dt.Columns.Add(new DataColumn("opening_balance", System.Type.GetType("System.Decimal")));
        dt.Columns.Add(new DataColumn("statement_ending_balance", System.Type.GetType("System.Decimal")));
        dt.Columns.Add(new DataColumn("total_cleared", System.Type.GetType("System.Decimal")));
        dt.Columns.Add(new DataColumn("total_uncleared", System.Type.GetType("System.Decimal")));
        dt.Columns.Add(new DataColumn("system_balance_asof_statement", System.Type.GetType("System.Decimal")));
        dt.Columns.Add(new DataColumn("system_balance_asof_recon_date", System.Type.GetType("System.Decimal")));
        dt.Columns.Add(new DataColumn("total_unclear_after_statement", System.Type.GetType("System.Decimal")));
        dt.Columns.Add(new DataColumn("service_charge", System.Type.GetType("System.Decimal")));
        dt.Columns.Add(new DataColumn("interest_earned", System.Type.GetType("System.Decimal")));
        return dt;
    }



    private void PrepReportDS()
    {
        rcRec = (ReconcileRecord)Session["selectedRcRec"];
        DataTable dtAll = (DataTable)Session["dtAll"];
        DataTable dtGeneral = createGeneralDT();
        DataRow dr = dtGeneral.NewRow();
        dr["recon_id"] = rcRec.recon_id;
        dr["bank_name"] = this.ddlBankAcct.SelectedItem.Text;
        dr["bank_account_number"] = rcRec.bank_account_number;
        dr["modified_date"] = rcRec.modified_date;
        dr["created_date"] = rcRec.created_date;
        dr["statement_ending_date"] = rcRec.Statement_ending_date;
        dr["opening_balance"] = rcRec.opening_balance;
        dr["statement_ending_balance"] = rcRec.statement_ending_balance;
        dr["total_cleared"] = rcRec.total_cleared;
        dr["total_uncleared"] = rcRec.total_uncleared;
        dr["system_balance_asof_statement"] = rcRec.system_balance_asof_statement;
        dr["system_balance_asof_recon_date"] = rcRec.system_balance_asof_recon_date;
        dr["total_unclear_after_statement"] = rcRec.total_unclear_after_statement;
        dtGeneral.Rows.Add(dr);
        dsPDF = new DataSet("dSReconcile");
        dsPDF.Tables.Add(dtGeneral);
        dsPDF.Tables.Add(dtAll);

    }
}
