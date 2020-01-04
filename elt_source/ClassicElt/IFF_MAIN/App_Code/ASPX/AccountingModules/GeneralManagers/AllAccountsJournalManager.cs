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
/// Summary description for AllAccountJournalManager
/// </summary>
public class AllAccountsJournalManager:Manager
{    
  
    private int vOrgAcct;

	public AllAccountsJournalManager(string elt_acct):base(elt_acct)
	{	
	    
	}

    public bool checkInitial_Acct_Record(AllAccountsJournalRecord rec)
    {
        rec.replaceQuote();

        SQL = "select count(tran_type) from all_accounts_journal where elt_account_number = "
            + elt_account_number + " and gl_account_number="
            + rec.gl_account_number + " and tran_type='INIT' and customer_number=" + rec.customer_number;

        Cmd = new SqlCommand(SQL, Con);
        int rowCount;
        try
        {
            Con.Open();
            rowCount = Int32.Parse(Cmd.ExecuteScalar().ToString());
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            Con.Close();
        }
        if (rowCount == 1)
        {
            return true;
        }
        else if (rowCount >= 0)
        {
            SQL = "INSERT INTO [all_accounts_journal] ";
            SQL += "( elt_account_number, ";
            SQL += "memo,";
            SQL += "gl_account_number,";
            SQL += "air_ocean,";
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
            SQL += "','" + rec.memo;
            SQL += "','" + rec.gl_account_number;
            SQL += "','" + rec.air_ocean;
            SQL += "','" + rec.gl_account_name;
            SQL += "','" + getNextTranSeqNumber();
            SQL += "','" + "INIT";
            SQL += "','" + DateTime.Today.ToShortDateString();
            SQL += "','" + rec.customer_number;
            SQL += "','" + rec.customer_name;
            SQL += "','" + 0;
            SQL += "','" + 0;
            SQL += "','" + 0;
            SQL += "','" + 0;
            SQL += "','" + 0;
            SQL += "','" + 0;
            SQL += "')";
            Cmd = new SqlCommand(SQL, Con);
            try
            {
                Con.Open();
                Cmd.ExecuteNonQuery();
                return true;
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                Con.Close();
            }

        }
        else
        {
            
        }

        return false;
    }
    
    public int getNextTranSeqNumber()
    {
        SQL = "select max(tran_seq_num) from all_accounts_journal where elt_account_number = "
               + elt_account_number;
        Cmd = new SqlCommand(SQL, Con);
        int current = 0;
        try
        {
            Con.Open();
            string id_str = Cmd.ExecuteScalar().ToString();
            if (id_str != "")
            {
                current = Int32.Parse(id_str);
            }
            else
            {
                current = 0;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            Con.Close();
        }
        return current + 1;
    }       
    
    public ArrayList get_Entries(int tran_no, string tran_type)
    {
        DataTable dt = new DataTable();
        SQL = "select * FROM all_accounts_journal WHERE elt_account_number = " + elt_account_number + " AND tran_num = " + tran_no + " AND tran_type = '" + tran_type + "' order by tran_seq_num";
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);
        GeneralUtility util = new GeneralUtility();
        util.removeNull(ref dt);
        ArrayList oldList = new ArrayList();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            AllAccountsJournalRecord aaj = new AllAccountsJournalRecord();
            aaj.elt_account_number = Int32.Parse(dt.Rows[i]["elt_account_number"].ToString());
            aaj.gl_account_number = Int32.Parse(dt.Rows[i]["gl_account_number"].ToString());
            aaj.gl_account_name = dt.Rows[i]["gl_account_name"].ToString();
            aaj.tran_seq_num = Int32.Parse(dt.Rows[i]["tran_seq_num"].ToString());
            aaj.tran_type = dt.Rows[i]["tran_type"].ToString();
            aaj.tran_date = dt.Rows[i]["tran_date"].ToString();
            aaj.customer_number = Int32.Parse(dt.Rows[i]["Customer_Number"].ToString());
            aaj.customer_name = dt.Rows[i]["Customer_Name"].ToString();
            aaj.debit_amount = Decimal.Parse(dt.Rows[i]["debit_amount"].ToString());
            aaj.credit_amount = Decimal.Parse(dt.Rows[i]["credit_amount"].ToString());
            aaj.balance = Decimal.Parse(dt.Rows[i]["balance"].ToString());
            aaj.previous_balance = Decimal.Parse(dt.Rows[i]["previous_balance"].ToString());
            aaj.gl_balance = Decimal.Parse(dt.Rows[i]["gl_balance"].ToString());
            aaj.gl_previous_balance = Decimal.Parse(dt.Rows[i]["gl_previous_balance"].ToString());
            oldList.Add(aaj);
        }
        return oldList;
    }

    public AllAccountsJournalRecord get_OneEntryFromGJE(int tran_no, int item_no, string tran_type)
    {
        DataTable dt = new DataTable();
        SQL = "select * FROM all_accounts_journal WHERE elt_account_number = " + elt_account_number + " AND tran_num = " + tran_no + " AND tran_type = '" + tran_type + "'  order by tran_seq_num";
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);
        GeneralUtility util = new GeneralUtility();
        util.removeNull(ref dt);
        AllAccountsJournalRecord aaj = new AllAccountsJournalRecord();
        aaj.elt_account_number = Int32.Parse(dt.Rows[item_no-1]["elt_account_number"].ToString());
        aaj.gl_account_number = Int32.Parse(dt.Rows[item_no-1]["gl_account_number"].ToString());
        aaj.gl_account_name = dt.Rows[item_no - 1]["gl_account_name"].ToString();
        aaj.tran_seq_num = Int32.Parse(dt.Rows[item_no - 1]["tran_seq_num"].ToString());
        aaj.tran_type = dt.Rows[item_no - 1]["tran_type"].ToString();
        aaj.tran_date = dt.Rows[item_no - 1]["tran_date"].ToString();
        aaj.customer_number = Int32.Parse(dt.Rows[item_no - 1]["Customer_Number"].ToString());
        aaj.customer_name = dt.Rows[item_no - 1]["Customer_Name"].ToString();
        aaj.debit_amount = Decimal.Parse(dt.Rows[item_no - 1]["debit_amount"].ToString());
        aaj.credit_amount = Decimal.Parse(dt.Rows[item_no - 1]["credit_amount"].ToString());
        aaj.balance = Decimal.Parse(dt.Rows[item_no - 1]["balance"].ToString());
        aaj.previous_balance = Decimal.Parse(dt.Rows[item_no - 1]["previous_balance"].ToString());
        aaj.gl_balance = Decimal.Parse(dt.Rows[item_no - 1]["gl_balance"].ToString());
        aaj.gl_previous_balance = Decimal.Parse(dt.Rows[item_no - 1]["gl_previous_balance"].ToString());
        return aaj;
    }

    public void delete_Entries(int tran_no,string tran_type)
    {
        SQL = "Delete  FROM all_accounts_journal WHERE elt_account_number = "
            + elt_account_number + " AND tran_num = " + tran_no + " AND tran_type = '" + tran_type+"'";
        Cmd = new SqlCommand(SQL, Con);
        try
        {
            Con.Open();
            Cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {                 
            throw ex;
        }
        finally
        {
            Con.Close();
        }
    }

    public bool voidCheck(int print_id,string check_type)
    {
        SQL = "update all_accounts_journal set chk_void='Y', debit_amount=0, credit_amount=0 where elt_account_number = " + elt_account_number + " and tran_num = " + print_id+ " and tran_type='"+check_type+"'";

        Cmd = new SqlCommand(SQL, Con);
        int rowCount = 0;
        try
        {
            Con.Open();
            rowCount = Int32.Parse(Cmd.ExecuteNonQuery().ToString());
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            Con.Close();
        }
        if (rowCount > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }    

}
