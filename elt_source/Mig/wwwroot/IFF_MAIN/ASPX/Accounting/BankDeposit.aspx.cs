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

public partial class ASPX_Accounting_BankDeposit : System.Web.UI.Page
{
    protected string user_id, login_name, user_right, elt_account_number, entry_no;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;

        if (!IsPostBack)
        {
            LoadGeneralJournalEntry();
        }
    }

    protected void LoadGeneralJournalEntry()
    {
        entry_no = "";
        if(Request.Params["EntryNo"] != null){
            entry_no = Request.Params["EntryNo"].ToString();
            hEntryNo.Value = entry_no;
            btnDeleteTop.Visible = true;
            btnDeleteBot.Visible = true;
            FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
            feData.AddToDataSet("EntryInfo", "SELECT a.*,b.dba_name FROM general_journal_entry a LEFT OUTER JOIN organization b ON (a.elt_account_number=b.elt_account_number AND a.org_acct=b.org_account_number) WHERE a.elt_account_number=" + elt_account_number + " AND  a.entry_no=" + entry_no + " ORDER BY credit" );
            if (feData.Tables["EntryInfo"].Rows.Count == 2)
            {
                DataRow drTmp = feData.Tables["EntryInfo"].Rows[0];

                lstVendorName.Text = drTmp["dba_name"].ToString();
                hVendorAcct.Value = drTmp["org_acct"].ToString();
                lstBanks.SelectedValue = drTmp["gl_account_number"].ToString();
                lstRevenues.SelectedValue = feData.Tables["EntryInfo"].Rows[1]["gl_account_number"].ToString();
                txtAmount.Text = drTmp["debit"].ToString();
                txtMemo.Text = drTmp["memo"].ToString();
            }
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];

        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("Banks", "SELECT * FROM gl WHERE elt_account_number=" + elt_account_number + " AND gl_account_type='Cash in Bank'");
        lstBanks.DataSource = feData.Tables["Banks"];
        lstBanks.DataTextField = "gl_account_desc";
        lstBanks.DataValueField = "gl_account_number";
        lstBanks.DataBind();

        feData.AddToDataSet("Revenues", "SELECT * FROM gl WHERE elt_account_number=" + elt_account_number + " AND gl_account_type='Other Revenue'");
        lstRevenues.DataSource = feData.Tables["Revenues"];
        lstRevenues.DataTextField = "gl_account_desc";
        lstRevenues.DataValueField = "gl_account_number";
        lstRevenues.DataBind();
    }
    protected void btnSaveTop_Click(object sender, ImageClickEventArgs e)
    {
        if (hEntryNo.Value == "")
        {
            InsertGeneralJournalEntry();
        }
        else
        {
            DeleteGeneralJournalEntry();
            InsertGeneralJournalEntry();
        }
    }

    protected void btnSaveBot_Click(object sender, ImageClickEventArgs e)
    {
        if (hEntryNo.Value == "")
        {
            InsertGeneralJournalEntry();
        }
        else
        {
            DeleteGeneralJournalEntry();
            InsertGeneralJournalEntry();
        }
    }

    protected void InsertGeneralJournalEntry()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string tranStr = "";

        tranStr = "DECLARE @new_entry_number DECIMAL\n";
        tranStr += "DECLARE @new_seq_number DECIMAL\n";
        tranStr += "SET @new_entry_number=(SELECT ISNULL(MAX(entry_no),0)+1 FROM general_journal_entry WHERE elt_account_number=" + elt_account_number + ")\n";
        tranStr += "SET @new_seq_number=(SELECT ISNULL(MAX(tran_seq_num),0)+1 FROM all_accounts_journal WHERE elt_account_number=" + elt_account_number + ")\n";
        tranStr += "INSERT INTO general_journal_entry(elt_account_number,entry_no,item_no,gl_account_number,credit,debit,memo,org_acct,dt)\n";
        tranStr += "VALUES(" + elt_account_number + ",@new_entry_number,1," + lstBanks.SelectedValue + ",0," + txtAmount.Text + ",N'" + txtMemo.Text + "'," + hVendorAcct.Value + ",GETDATE())\n";
        tranStr += "INSERT INTO general_journal_entry(elt_account_number,entry_no,item_no,gl_account_number,credit,debit,memo,org_acct,dt)\n";
        tranStr += "VALUES(" + elt_account_number + ",@new_entry_number,1," + lstRevenues.SelectedValue + "," + txtAmount.Text + ",0,N'" + txtMemo.Text + "'," + hVendorAcct.Value + ",GETDATE())\n";
        tranStr += "INSERT INTO all_accounts_journal(elt_account_number,tran_seq_num,gl_account_number,gl_account_name,tran_type,tran_num,tran_date,customer_name,customer_number,split,memo,debit_amount,credit_amount)\n";
        tranStr += "VALUES(" + elt_account_number + ",@new_seq_number," + lstBanks.SelectedValue + ",N'" + lstBanks.Items[lstBanks.SelectedIndex].Text + "','DEPOSIT',@new_entry_number,GETDATE(),N'" + lstVendorName.Text + "'," + hVendorAcct.Value + ",'',N'" + txtMemo.Text + "'," + txtAmount.Text + ",0)\n";
        tranStr += "INSERT INTO all_accounts_journal(elt_account_number,tran_seq_num,gl_account_number,gl_account_name,tran_type,tran_num,tran_date,customer_name,customer_number,split,memo,debit_amount,credit_amount)\n";
        tranStr += "VALUES(" + elt_account_number + ",@new_seq_number+1," + lstRevenues.SelectedValue + ",N'" + lstBanks.Items[lstRevenues.SelectedIndex].Text + "','DEPOSIT',@new_entry_number,GETDATE(),N'" + lstVendorName.Text + "'," + hVendorAcct.Value + ",'',N'" + txtMemo.Text + "',0," + txtAmount.Text + ")\n";

        if (!feData.DataTransaction(tranStr))
        {
            string errorStr = feData.GetLastTransactionError();
            string errorMsg = "Unexpected error occurred. " + errorStr;

            txtResultBox.Text = errorMsg;
            txtResultBox.Visible = true;
        }
    }

    protected void DeleteGeneralJournalEntry()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string tranStr = "";

        tranStr = "DELETE FROM general_journal_entry WHERE elt_account_number=" + elt_account_number + " AND entry_no=" + hEntryNo.Value + "\n";
        tranStr += "DELETE FROM all_accounts_journal WHERE elt_account_number=" + elt_account_number + " AND tran_num=" + hEntryNo.Value + " AND tran_type='DEPOSIT'";
        

        if (!feData.DataTransaction(tranStr))
        {
            string errorStr = feData.GetLastTransactionError();
            string errorMsg = "Unexpected error occurred. " + errorStr;

            txtResultBox.Text = tranStr;
            txtResultBox.Visible = true;
        }
    }

    protected void btnDeleteBot_Click(object sender, ImageClickEventArgs e)
    {
        DeleteGeneralJournalEntry();
        Response.Redirect("./BankDeposit.aspx");
    }

    protected void btnDeleteTop_Click(object sender, ImageClickEventArgs e)
    {
        DeleteGeneralJournalEntry();
        Response.Redirect("./BankDeposit.aspx");
    }
}
