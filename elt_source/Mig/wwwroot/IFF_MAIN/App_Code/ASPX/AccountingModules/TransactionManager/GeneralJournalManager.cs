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

/// </summary>
public class GeneralJournalManager : Manager
{
    private AllAccountsJournalManager aajMgr;
    public GeneralJournalManager(string elt_acct)
        : base(elt_acct)
    {
        aajMgr = new AllAccountsJournalManager(elt_account_number);
    }

    public int getNextEntryNumber()
    {
        SQL = "select max(entry_no) from general_journal_entry where elt_account_number = "
               + elt_account_number;
        Cmd = new SqlCommand(SQL, Con);
        int entry_no = 0;
        try
        {
            Con.Open();
            string id_str = Cmd.ExecuteScalar().ToString();
            if (id_str != "")
            {
                entry_no = Int32.Parse(id_str) + 1;
            }
            else
            {
                entry_no = 1;
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
        return entry_no;
    }

    public bool insert_Entries(ArrayList gjeList, int tran_no)
    {
        bool return_val = false;
        for (int i = 0; i < gjeList.Count; i++)
        {
            AllAccountsJournalRecord AAJEntry = ((GeneralJournalRecord)gjeList[i]).All_Accounts_Journal_Entry;
            aajMgr.checkInitial_Acct_Record(AAJEntry);
        }
        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;

        try
        {

            int next_tran_seq_no = aajMgr.getNextTranSeqNumber();
           
           
            for (int i = 0; i < gjeList.Count; i++)
            {
                AllAccountsJournalRecord AAJEntry = ((GeneralJournalRecord)gjeList[i]).All_Accounts_Journal_Entry;
                ((GeneralJournalRecord)gjeList[i]).entry_no = tran_no;
                ((GeneralJournalRecord)gjeList[i]).replaceQuote();               
                AAJEntry.replaceQuote();
                AAJEntry.tran_type = "GJE";
                AAJEntry.tran_num = tran_no;

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
                SQL += "','" + AAJEntry.tran_num;
                SQL += "','" + AAJEntry.gl_account_number;
                SQL += "','" + AAJEntry.gl_account_name;
                SQL += "','" + next_tran_seq_no++;
                SQL += "','" + AAJEntry.tran_type;
                SQL += "','" + AAJEntry.tran_date;
                SQL += "','" + AAJEntry.customer_number;
                SQL += "','" + AAJEntry.customer_name;
                SQL += "','" + AAJEntry.debit_amount;
                SQL += "','" + AAJEntry.credit_amount;
                SQL += "','" + AAJEntry.balance;
                SQL += "','" + AAJEntry.previous_balance;
                SQL += "','" + AAJEntry.gl_balance;
                SQL += "','" + AAJEntry.gl_previous_balance;
                SQL += "')";

                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();

                SQL = "INSERT INTO [general_journal_entry] ";
                SQL += "(credit, ";
                SQL += "debit,";
                SQL += "dt,";
                SQL += "elt_account_number,";
                SQL += "entry_no,";
                SQL += "gl_account_number,";
                SQL += "item_no,";
                SQL += "memo,";
                SQL += "org_acct)";
                SQL += "VALUES";
                SQL += "('" + ((GeneralJournalRecord)gjeList[i]).credit;
                SQL += "','" + ((GeneralJournalRecord)gjeList[i]).debit;
                SQL += "','" + ((GeneralJournalRecord)gjeList[i]).dt;
                SQL += "','" + ((GeneralJournalRecord)gjeList[i]).elt_account_number;
                SQL += "','" + ((GeneralJournalRecord)gjeList[i]).entry_no;
                SQL += "','" + ((GeneralJournalRecord)gjeList[i]).gl_account_number;
                SQL += "','" + ((GeneralJournalRecord)gjeList[i]).item_no;
                SQL += "','" + ((GeneralJournalRecord)gjeList[i]).memo;
                SQL += "'," + ((GeneralJournalRecord)gjeList[i]).org_acct;
                SQL += ")";
                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();

            }

            trans.Commit();
            return_val = true;
        }
        catch (Exception ex)
        {
            trans.Rollback();
            throw ex;
        }
        finally
        {
            Con.Close();
        }
        return return_val;
    }



    public bool checkIfExist(int entry_no)
    {
        SQL = "select count(entry_no) from general_journal_entry where elt_account_number = "
           + elt_account_number + " and entry_no="
           + entry_no;
        Cmd = new SqlCommand(SQL, Con);
        int rowCount;

        try
        {
            Con.Open();
            rowCount = Int32.Parse(Cmd.ExecuteScalar().ToString());
        }
        catch (Exception ex)
        {
            Con.Close();
            string msg = ex.Message;
            throw ex;
        }
        Con.Close();
        if (rowCount == 1)
        {
            return false;
        }
        else if (rowCount >= 1)
        {
            throw new Exception();
        }
        return true;
    }

    

    public ArrayList get_Entries(int tran_no)
    {
        DataTable dt = new DataTable();
        SQL = "select * from general_journal_entry where elt_account_number = " + elt_account_number + " AND entry_no = " + tran_no +" order by item_no";
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);
        GeneralUtility util = new GeneralUtility();
        util.removeNull(ref dt);
        ArrayList oldList = new ArrayList();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            GeneralJournalRecord gje = new GeneralJournalRecord();
            gje.credit = Decimal.Parse(dt.Rows[i]["credit"].ToString());
            gje.debit = Decimal.Parse(dt.Rows[i]["debit"].ToString());
            gje.dt = dt.Rows[i]["dt"].ToString();
            gje.elt_account_number = dt.Rows[i]["elt_account_number"].ToString();
            gje.entry_no = Int32.Parse(dt.Rows[i]["entry_no"].ToString());
            gje.gl_account_number = Int32.Parse(dt.Rows[i]["gl_account_number"].ToString());
            gje.item_no = Int32.Parse(dt.Rows[i]["item_no"].ToString());
            gje.memo = dt.Rows[i]["memo"].ToString();
            gje.org_acct = Int32.Parse(dt.Rows[i]["org_acct"].ToString());
            int item_no = Int32.Parse(dt.Rows[i]["item_no"].ToString());
            gje.All_Accounts_Journal_Entry = aajMgr.get_OneEntryFromGJE(gje.entry_no,item_no,"GJE");
            oldList.Add(gje);
        }
        return oldList;
    }



    public void delete_Entries(int tran_no)
    {
        aajMgr.delete_Entries(tran_no, "GJE");

        SQL = "delete  from general_journal_entry where elt_account_number = "
            + elt_account_number + " AND entry_no = " + tran_no;

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

    public bool checkCreditDebitBalance(ArrayList gjeList)
    {
        return true;
    }

}
