using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Collections;
using System.Text;

/// <summary>
/// Summary description for customerCreditManager
/// </summary>
public class CustomerCreditManager:Manager
{
    private AllAccountsJournalManager AAJMgr;

    public CustomerCreditManager(string elt_acct)
        : base(elt_acct)	
    {
        AAJMgr = new AllAccountsJournalManager(elt_account_number);
    }
    public Decimal getcustomerCredit(int customer_acct)
    {
        Decimal credit = 0;
        Decimal debit = 0;
        SQL = "select sum(isnull(credit_amount, 0)) as credit,sum(isnull(debit_amount, 0)) as debit"
            +" from all_accounts_journal where (tran_type='CCR'OR tran_type='PMT') AND gl_account_name='Customer Credit' and  elt_account_number = "
            + elt_account_number + " and customer_number=" + customer_acct;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        customerCreditRecord cCRec = new customerCreditRecord();
        GeneralUtility gUtil = new GeneralUtility();       

        try
        {
            ad.Fill(dt);
            gUtil.removeNull(ref dt);
            if (dt.Rows.Count == 1)
            {
                credit = Decimal.Parse(dt.Rows[0]["credit"].ToString());
                debit = Decimal.Parse(dt.Rows[0]["debit"].ToString());
            }
            else
            {
                credit = 0;
                debit = 0;
            }
                    
        }
        catch (Exception ex2)
        {
            throw ex2;
        }
        return -(credit+debit);
    }

    


    public int getNextEntryNo(int customer_acct)
    {
        int next_entry = 0;
        SQL = "select max(entry_no) as entry_no from customer_credit_info where elt_account_number = " + elt_account_number + " and customer_no=" + customer_acct;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        customerCreditRecord cCRec = new customerCreditRecord();
        GeneralUtility gUtil = new GeneralUtility();
        if (dt.Rows.Count > 0)
        {
            try
            {
                ad.Fill(dt);
                next_entry = Int32.Parse(dt.Rows[0]["entry_no"].ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        return next_entry+1;
    }

    private bool checkExistCustomerCredit(int cus_acct){
        SQL = "select * from customer_credits where elt_account_number =";
        SQL += elt_account_number + " and customer_no=" + cus_acct;
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        DataTable dt = new DataTable();
        adp.Fill(dt);
        if (dt.Rows.Count >= 1)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public DataTable getCreditRecordDTwithinPeriod(string start, string end, int cId, string ref_no, string invoice_no, bool refund_only)
    {
        DataTable dt = new DataTable();
        SQL = "select  convert( NVARCHAR(10), DATEPART(month, tran_date)) +'/'+ convert( varchar(10),DATEPART(day, tran_date))+'/'+convert( varchar(10),DATEPART(year, tran_date)) as tran_date, 'edit_invoi.aspx?edit=yes&invoice_no='+convert( varchar(10), invoice_no) as url_invoice, 'Write_Check.aspx?ref_no='+ref_no+'&memo='+memo+'&customer='+convert(varchar(10),customer_no) +'refund=yes&amount='+convert( varchar(10),credit) as url,* from customer_credit_info  where elt_account_number = " + elt_account_number + " AND tran_date >='"
            + start + "'and tran_date <= '" + end + "'";
        if (cId != 0)
        {

            SQL += " AND customer_no = " + cId;
        }

        if (ref_no != "")
        {
            SQL += " AND ref_no = '" + ref_no + "'";
        }

        if (invoice_no != "")
        {
            SQL += " AND invoice_no = '" + invoice_no + "'";
        }
        if (refund_only)
        {
            SQL += " AND is_refund = 'Y'";
        }       

        SQL += " Order by tran_date";

        try
        {

            SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);

            ad.Fill(dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return dt;


    }

    


    public bool insert_customer_credit(customerCreditRecord ccRec)//农贰调老 版快/Refund 老 版快
    {
        int return_val;
        ccRec.replaceQuote();

        ArrayList AAJEntryList = ccRec.all_accounts_journal_list;
        if (AAJEntryList == null) AAJEntryList = new ArrayList();
        for (int i = 0; i < AAJEntryList.Count; i++)
        {
            AAJMgr.checkInitial_Acct_Record((AllAccountsJournalRecord)AAJEntryList[i]);
        }
        int next_tran_seq_no = AAJMgr.getNextTranSeqNumber();
        
        int entry_no = getNextEntryNo(ccRec.customer_no);

        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();

        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;
        if (AAJEntryList.Count > 0)
        {
            for (int i = 0; i < AAJEntryList.Count; i++)
            {
                ((AllAccountsJournalRecord)AAJEntryList[i]).replaceQuote();

                if (((AllAccountsJournalRecord)AAJEntryList[i]).tran_num == null || ((AllAccountsJournalRecord)AAJEntryList[i]).tran_num == 0)//Only when there is no entry
                {
                    ((AllAccountsJournalRecord)AAJEntryList[i]).tran_num = entry_no;
                }

                SQL = "INSERT INTO [all_accounts_journal] ";
                SQL += "( elt_account_number, ";
                SQL += "tran_num,";
                SQL += "gl_account_number,";
                SQL += "gl_account_name,";
                SQL += "tran_seq_num,";
                SQL += "tran_type,";
                SQL += "tran_date,";
                SQL += "Customer_Number,";
                SQL += "Customer_Name,";
                SQL += "debit_amount,";
                SQL += "credit_amount,";
                SQL += "balance,";
                SQL += "previous_balance,";
                SQL += "gl_balance,";
                SQL += "gl_previous_balance)";
                SQL += "VALUES";
                SQL += "('" + elt_account_number;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).tran_num;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).gl_account_number;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).gl_account_name;
                SQL += "','" + next_tran_seq_no++;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).tran_type;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).tran_date;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).customer_number;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).customer_name;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).debit_amount;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).credit_amount;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).balance;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).previous_balance;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).gl_balance;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).gl_previous_balance;
                SQL += "')";

                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();
            }
        }

        SQL = "INSERT INTO [customer_credit_info] ";
        SQL += "(elt_account_number, ";
        SQL += "customer_no,";
        SQL += "customer_name,";
        SQL += "tran_date,";
        SQL += "memo,";
        SQL += "entry_no,";
        SQL += "ref_no,";
        SQL += "invoice_no,";
        SQL += "credit)";
        SQL += "VALUES";
        SQL += "('" + elt_account_number;
        SQL += "','" + ccRec.customer_no;
        SQL += "','" + ccRec.customer_name;
        SQL += "','" + ccRec.tran_date;
        SQL += "','" + ccRec.memo;
        SQL += "','" + entry_no;
        SQL += "','" + ccRec.ref_no;
        SQL += "','" + ccRec.invoice_no;
        SQL += "','" + ccRec.credit;
        SQL += "')";


        Cmd.CommandText = SQL;
        return_val=Cmd.ExecuteNonQuery();
     
        try
        {          
            trans.Commit();           
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            Con.Close();
        }

        if (return_val == 1)
        {
            return true;
        }
        else
        {
            return false;
        }
          
    }


}