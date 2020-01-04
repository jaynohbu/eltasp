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
public class ReconcileManager : Manager
{
    private AllAccountsJournalManager AAJMgr;

    public ReconcileManager(string elt_acct)
        : base(elt_acct)
    {
        AAJMgr = new AllAccountsJournalManager(elt_account_number);
    }
    public int getNewReconID()
    {
        SQL = "select max(recon_id) as recon_id from reconcile where elt_account_number = " + elt_account_number;
        int recon_id;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        try
        {
            ad.Fill(dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        string id_str = dt.Rows[0]["recon_id"].ToString();

        if (id_str != "")
        {
            recon_id = Int32.Parse(id_str) + 1;
        }
        else
        {
            recon_id = 1;
        }
        return recon_id;
    }


    public bool deleteReconcile(ReconcileRecord rcRec)
    {
        
        bool return_val = false;

        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;

        try
        {
            if (rcRec.receivementDetailList!= null)
            {
                for (int i = 0; i < rcRec.receivementDetailList.Count; i++)
                {
                    ReconcileReceivementDetailRecord rrd = (ReconcileReceivementDetailRecord)rcRec.receivementDetailList[i];
                    SQL = "update  [all_accounts_journal] set is_recon_cleared='N' where elt_account_number = " + elt_account_number + " and tran_seq_num=" + rrd.tran_seq_num;
                    Cmd.CommandText = SQL;
                    Cmd.ExecuteNonQuery();
                }
            }
            if (rcRec.paymentDetailList != null)
            {
                for (int i = 0; i < rcRec.paymentDetailList.Count; i++)
                {
                    ReconcilePaymentDetailRecord rpd = (ReconcilePaymentDetailRecord)rcRec.paymentDetailList[i];
                    SQL = "update  [all_accounts_journal] set is_recon_cleared='N' where elt_account_number = " + elt_account_number + " and tran_seq_num=" + rpd.tran_seq_num;
                    Cmd.CommandText = SQL;
                    Cmd.ExecuteNonQuery();
                }
            }


            //DELETE PREVIOUS RECEIVEMENT DETAILS            
            SQL = "DELETE  FROM reconcile_receivement_detail WHERE elt_account_number = "
                + elt_account_number + " AND recon_id = " + rcRec.recon_id;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            //DELETE PREVIOUS PAYMENT DETAILS
            SQL = "DELETE  FROM reconcile_payment_detail WHERE elt_account_number = "
                + elt_account_number + " AND recon_id = " + rcRec.recon_id;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();

            SQL = "DELETE  FROM reconcile WHERE elt_account_number = "
               + elt_account_number + " AND recon_id = " + rcRec.recon_id;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();


            SQL = "DELETE  FROM all_accounts_journal WHERE elt_account_number = "
               + elt_account_number + " AND tran_type='REC' AND tran_num = " + rcRec.recon_id;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();

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

    public bool insert_Entry( ref ReconcileRecord rcRec)
    {
        bool return_val = false;
        ArrayList AAJEntryList = rcRec.AAJEntryList;

        for (int i = 0; i < AAJEntryList.Count; i++)
        {
            AAJMgr.checkInitial_Acct_Record((AllAccountsJournalRecord)AAJEntryList[i]);
        }
        

        //GET NEXT RECON ID

        int reconcile_id = this.getNewReconID();
        rcRec.recon_id = reconcile_id;

        int tran_seq_no = AAJMgr.getNextTranSeqNumber();

        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;

        
        try
        {
            //DELETE PREVIOUS RECEIVEMENT DETAILS            
            SQL = "DELETE  FROM reconcile_receivement_detail WHERE elt_account_number = "
                + elt_account_number + " AND recon_id = " + reconcile_id;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            //DELETE PREVIOUS PAYMENT DETAILS
            SQL = "DELETE  FROM reconcile_payment_detail WHERE elt_account_number = "
                + elt_account_number + " AND recon_id = " + reconcile_id;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();


            //INSERT RECEIVEMENT DETAILS
            if (rcRec.receivementDetailList != null)
            {
                for (int i = 0; i < rcRec.receivementDetailList.Count; i++)
                {
                    ReconcileReceivementDetailRecord RRD = (ReconcileReceivementDetailRecord)rcRec.receivementDetailList[i];
                    RRD.replaceQuote();
                    SQL = "INSERT INTO [reconcile_receivement_detail] ";
                    SQL += "( elt_account_number, ";
                    SQL += "recon_id,";
                    SQL += "customer_name,";
                    SQL += "customer_number,";
                    SQL += "debit_amount,";
                    SQL += "gl_account_name,";
                    SQL += "gl_account_number,";
                    SQL += "tran_date,";
                    SQL += "tran_num,";
                    SQL += "tran_seq_num,";
                    SQL += "is_recon_cleared,";
                    SQL += "memo,";
                    SQL += "tran_type)";
                    SQL += "VALUES";
                    SQL += "('" + elt_account_number;
                    SQL += "','" + reconcile_id;
                    SQL += "','" + RRD.customer_name;
                    SQL += "','" + RRD.customer_number;
                    SQL += "','" + RRD.debit_amount;
                    SQL += "','" + RRD.gl_account_name;
                    SQL += "','" + RRD.gl_account_number;
                    SQL += "','" + RRD.tran_date;
                    SQL += "','" + RRD.tran_num;
                    SQL += "','" + RRD.tran_seq_num;
                    SQL += "','" + RRD.is_recon_cleared;
                    SQL += "','" + RRD.memo;
                    SQL += "','" + RRD.tran_type;
                    SQL += "')";


                    Cmd.CommandText = SQL;
                    Cmd.ExecuteNonQuery();

                    SQL = "UPDATE  [all_accounts_journal] SET is_recon_cleared='"
                        + RRD.is_recon_cleared + "' WHERE elt_account_number = " + elt_account_number + " and tran_seq_num=" + RRD.tran_seq_num;

                    Cmd.CommandText = SQL;
                    Cmd.ExecuteNonQuery();


                }
            }
            //INSERT PAYMENT DETAILS
            if (rcRec.paymentDetailList != null)
            {
                for (int i = 0; i < rcRec.paymentDetailList.Count; i++)
                {
                    ReconcilePaymentDetailRecord RPD = (ReconcilePaymentDetailRecord)rcRec.paymentDetailList[i];
                    RPD.replaceQuote();

                    SQL = "INSERT INTO [reconcile_payment_detail] ";
                    SQL += "( elt_account_number, ";
                    SQL += "recon_id,";
                    SQL += "customer_name,";
                    SQL += "customer_number,";
                    SQL += "credit_amount,";
                    SQL += "gl_account_name,";
                    SQL += "gl_account_number,";
                    SQL += "tran_date,";
                    SQL += "tran_num,";
                    SQL += "tran_seq_num,";
                    SQL += "is_recon_cleared,";
                    SQL += "memo,";
                    SQL += "tran_type)";
                    SQL += "VALUES";
                    SQL += "('" + elt_account_number;
                    SQL += "','" + reconcile_id;
                    SQL += "','" + RPD.customer_name;
                    SQL += "','" + RPD.customer_number;
                    SQL += "','" + RPD.credit_amount;
                    SQL += "','" + RPD.gl_account_name;
                    SQL += "','" + RPD.gl_account_number;
                    SQL += "','" + RPD.tran_date;
                    SQL += "','" + RPD.tran_num;
                    SQL += "','" + RPD.tran_seq_num;
                    SQL += "','" + RPD.is_recon_cleared;
                    SQL += "','" + RPD.memo;
                    SQL += "','" + RPD.tran_type;
                    SQL += "')";

                    Cmd.CommandText = SQL;
                    Cmd.ExecuteNonQuery();


                    SQL = "UPDATE  [all_accounts_journal] SET is_recon_cleared='"
                        + RPD.is_recon_cleared + "' WHERE elt_account_number = " + elt_account_number + " and tran_seq_num=" + RPD.tran_seq_num;

                    Cmd.CommandText = SQL;
                    Cmd.ExecuteNonQuery();
                }
            }

            SQL = "INSERT INTO [reconcile] ";
            SQL += "( elt_account_number, ";
            SQL += "recon_id,";
            SQL += "recon_state,";
            SQL += "system_balance_asof_recon_date,";

            if(rcRec.interested_earned_date!="")
            {
                SQL += "interested_earned_date,";
            }
            if (rcRec.modified_date != "")
            {
                SQL += "modified_date,";
            }

            if(rcRec.service_charge_date!="")
            {
                 SQL += "service_charge_date,";
            }
            
                
           
            if (rcRec.statement_ending_date != "")
            {
                SQL += "statement_ending_date,";
            }
            if (rcRec.created_date != "")
            {
                SQL += "created_date,";
            }

            SQL += "bank_account_number,";
            SQL += "statement_ending_balance,";
            SQL += "interest_earned,";
            SQL += "opening_balance,";
            SQL += "system_balance_asof_statement,";
            SQL += "total_cleared,";
            SQL += "total_unclear_after_statement,";
            SQL += "total_uncleared,";
            SQL += "gj_entry_no,";            
            SQL += "service_charge)";
            SQL += "VALUES";
            SQL += "('" + elt_account_number;
            SQL += "','" + reconcile_id;
            SQL += "','" + rcRec.recon_state;
            SQL += "','" + rcRec.system_balance_asof_recon_date;

            if (rcRec.interested_earned_date != "")
            {
                SQL += "','" + rcRec.interested_earned_date;
            }
            if (rcRec.modified_date != "")
            {
                SQL += "','" + rcRec.modified_date;
            }
            if (rcRec.service_charge_date != "")
            {
                SQL += "','" + rcRec.service_charge_date;
            }
           
            if (rcRec.statement_ending_date != "")
            {
                SQL += "','" + rcRec.statement_ending_date;
            }
            if (rcRec.created_date != "")
            {
                SQL += "','" + rcRec.created_date;
            }


            SQL += "','" + rcRec.bank_account_number;
            SQL += "','" + rcRec.statement_ending_balance;
            SQL += "','" + rcRec.interest_earned;
            SQL += "','" + rcRec.opening_balance;
            SQL += "','" + rcRec.system_balance_asof_statement;
            SQL += "','" + rcRec.total_cleared;
            SQL += "','" + rcRec.total_unclear_after_statement;
            SQL += "','" + rcRec.total_uncleared;
            SQL += "','" + rcRec.gj_entry_no; 
            SQL += "','" + rcRec.service_charge;
            
            SQL += "')";

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            //INSERT ALL_ACCOUNT_JOURNAL ENTRY

           

            for (int i = 0; i < AAJEntryList.Count; i++)
            {
                ((AllAccountsJournalRecord)AAJEntryList[i]).replaceQuote();
                ((AllAccountsJournalRecord)AAJEntryList[i]).tran_num = reconcile_id;

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
                SQL += "memo,";
                SQL += "is_recon_cleared,";
                SQL += "gl_previous_balance)";
                SQL += "VALUES";
                SQL += "('" + elt_account_number;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).tran_num;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).gl_account_number;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).gl_account_name;
                SQL += "','" + tran_seq_no++;
                SQL += "','" + "REC";
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).tran_date;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).customer_number;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).customer_name;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).debit_amount;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).credit_amount;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).balance;
                
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).previous_balance;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).gl_balance;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).memo;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).is_recon_cleared;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).gl_previous_balance;
                SQL += "')";

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


    public bool update_Entry(ReconcileRecord rcRec)
    {
        bool return_val = false;
        int tran_seq_no = AAJMgr.getNextTranSeqNumber();
        int reconcile_id = rcRec.recon_id;
        ArrayList AAJEntryList = rcRec.AAJEntryList;
        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;
        try
        {
            //DELETE PREVIOUS RECEIVEMENT DETAILS            
            SQL = "DELETE  FROM reconcile_receivement_detail WHERE elt_account_number = "
                + elt_account_number + " AND recon_id = " + rcRec.recon_id;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            //DELETE PREVIOUS PAYMENT DETAILS
            SQL = "DELETE  FROM reconcile_payment_detail WHERE elt_account_number = "
                + elt_account_number + " AND recon_id = " + rcRec.recon_id;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();

            //INSERT RECEIVEMENT DETAILS
            for (int i = 0; i < rcRec.receivementDetailList.Count; i++)
            {
                ReconcileReceivementDetailRecord RRD = (ReconcileReceivementDetailRecord)rcRec.receivementDetailList[i];
                RRD.replaceQuote();
                SQL = "INSERT INTO [reconcile_receivement_detail] ";
                SQL += "( elt_account_number, ";
                SQL += "recon_id,";
                SQL += "customer_name,";
                SQL += "customer_number,";
                SQL += "debit_amount,";
                SQL += "gl_account_name,";
                SQL += "gl_account_number,";
                SQL += "tran_date,";
                SQL += "tran_num,";
                SQL += "tran_seq_num,";
                SQL += "is_recon_cleared,";
                SQL += "memo,";
                SQL += "tran_type)";
                SQL += "VALUES";
                SQL += "('" + elt_account_number;
                SQL += "','" + reconcile_id;
                SQL += "','" + RRD.customer_name;
                SQL += "','" + RRD.customer_number;
                SQL += "','" + RRD.debit_amount;
                SQL += "','" + RRD.gl_account_name;
                SQL += "','" + RRD.gl_account_number;
                SQL += "','" + RRD.tran_date;
                SQL += "','" + RRD.tran_num;
                SQL += "','" + RRD.tran_seq_num;
                SQL += "','" + RRD.is_recon_cleared;
                SQL += "','" + RRD.memo;
                SQL += "','" + RRD.tran_type;
                SQL += "')";


                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();

                SQL = "UPDATE  [all_accounts_journal] SET is_recon_cleared='"
                    + RRD.is_recon_cleared + "' WHERE elt_account_number = " + elt_account_number + " and tran_seq_num=" + RRD.tran_seq_num;

                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();
            }
            //INSERT PAYMENT DETAILS
            for (int i = 0; i < rcRec.paymentDetailList.Count; i++)
            {
                ReconcilePaymentDetailRecord RPD = (ReconcilePaymentDetailRecord)rcRec.paymentDetailList[i];
                RPD.replaceQuote();
                SQL = "INSERT INTO [reconcile_payment_detail] ";
                SQL += "( elt_account_number, ";
                SQL += "recon_id,";
                SQL += "customer_name,";
                SQL += "customer_number,";
                SQL += "credit_amount,";
                SQL += "gl_account_name,";
                SQL += "gl_account_number,";
                SQL += "tran_date,";
                SQL += "tran_num,";
                SQL += "tran_seq_num,";
                SQL += "is_recon_cleared,";
                SQL += "memo,";
                SQL += "tran_type)";
                SQL += "VALUES";
                SQL += "('" + elt_account_number;
                SQL += "','" + reconcile_id;
                SQL += "','" + RPD.customer_name ;
                SQL += "','" + RPD.customer_number;
                SQL += "','" + RPD.credit_amount;
                SQL += "','" + RPD.gl_account_name;
                SQL += "','" + RPD.gl_account_number ;
                SQL += "','" + RPD.tran_date ;
                SQL += "','" + RPD.tran_num ;
                SQL += "','" + RPD.tran_seq_num;
                SQL += "','" + RPD.is_recon_cleared;
                SQL += "','" + RPD.memo;
                SQL += "','" + RPD.tran_type ;
                SQL += "')";
                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();

                SQL = "UPDATE  [all_accounts_journal] SET is_recon_cleared='"
                    + RPD.is_recon_cleared + "' WHERE elt_account_number = " + elt_account_number + " and tran_seq_num=" + RPD.tran_seq_num;

                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();

            }

            SQL = "UPDATE [reconcile] SET";
            SQL += " elt_account_number=" + elt_account_number + ",";           
            SQL += "modified_date ='"+rcRec.modified_date+ "',";
            SQL += "recon_state='" + rcRec.recon_state + "',";
            if (rcRec.service_charge_date != "")
            {
                SQL += "service_charge_date='" + rcRec.service_charge_date + "',";
            }
            SQL += "system_balance_asof_recon_date=" + rcRec.system_balance_asof_recon_date + ",";
            SQL += "statement_ending_balance=" + rcRec.statement_ending_balance + ",";
            SQL += "interest_earned=" + rcRec.interest_earned + ",";
            if (rcRec.interested_earned_date != "")
            {
                SQL += "interested_earned_date='" + rcRec.interested_earned_date + "',";
            }
            SQL += "opening_balance=" + rcRec.opening_balance + ",";
            SQL += "system_balance_asof_statement=" + rcRec.system_balance_asof_statement + ",";
            SQL += "total_cleared=" + rcRec.total_cleared + ",";
            SQL += "total_unclear_after_statement=" + rcRec.total_unclear_after_statement + ",";
            SQL += "total_uncleared=" + rcRec.total_uncleared + ",";
            SQL += "service_charge=" + rcRec.service_charge + ",";
            SQL += "gj_entry_no=" + rcRec.gj_entry_no + "";
            SQL += " where elt_account_number =" + elt_account_number + " and recon_id=" + rcRec.recon_id;

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();          

            //DELETE AAJ ENTRIES 
            SQL = "Delete  FROM all_accounts_journal WHERE elt_account_number = "
               + elt_account_number + " AND tran_num = " + rcRec.recon_id + " AND tran_type = 'REC'";

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();

            for (int i = 0; i < AAJEntryList.Count; i++)
            {
                ((AllAccountsJournalRecord)AAJEntryList[i]).replaceQuote();
                ((AllAccountsJournalRecord)AAJEntryList[i]).tran_num = rcRec.recon_id;

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
                SQL += "memo,";
                SQL += "is_recon_cleared,";
                SQL += "gl_previous_balance)";
                SQL += "VALUES";
                SQL += "('" + elt_account_number;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).tran_num;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).gl_account_number;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).gl_account_name;
                SQL += "','" + tran_seq_no++;
                SQL += "','" + "REC";
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).tran_date;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).customer_number;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).customer_name;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).debit_amount;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).credit_amount;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).balance;
                
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).previous_balance;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).gl_balance;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).memo;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).is_recon_cleared;
                SQL += "','" + ((AllAccountsJournalRecord)AAJEntryList[i]).gl_previous_balance;
                SQL += "')";

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

    public ReconcileRecord get_LastEntryForBank(int bank_number)
    {
        DataTable dt = new DataTable();
        SQL = "select top 1 * from reconcile where recon_state='I' AND  elt_account_number = " + elt_account_number + " AND bank_account_number = " + bank_number + " order by recon_id desc";
        
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);
        GeneralUtility util = new GeneralUtility();
        util.removeNull(ref dt);
        ReconcileRecord rcRec=new ReconcileRecord();


        if (dt.Rows.Count > 0)
        {
            rcRec.interested_earned_date = dt.Rows[0]["interested_earned_date"].ToString();
            rcRec.modified_date = dt.Rows[0]["modified_date"].ToString();
            rcRec.recon_state = dt.Rows[0]["recon_state"].ToString();
            rcRec.service_charge_date = dt.Rows[0]["service_charge_date"].ToString();
            rcRec.system_balance_asof_recon_date = Decimal.Parse(dt.Rows[0]["system_balance_asof_recon_date"].ToString());
            rcRec.statement_ending_date = dt.Rows[0]["statement_ending_date"].ToString();
            rcRec.created_date = dt.Rows[0]["created_date"].ToString();

            rcRec.elt_account_number = dt.Rows[0]["elt_account_number"].ToString();
            rcRec.bank_account_number = Int32.Parse(dt.Rows[0]["bank_account_number"].ToString());
            rcRec.recon_id = Int32.Parse(dt.Rows[0]["recon_id"].ToString());
            rcRec.statement_ending_balance = Decimal.Parse(dt.Rows[0]["statement_ending_balance"].ToString());
            rcRec.interest_earned = Decimal.Parse(dt.Rows[0]["interest_earned"].ToString());
            rcRec.opening_balance = Decimal.Parse(dt.Rows[0]["opening_balance"].ToString());
            rcRec.service_charge = Decimal.Parse(dt.Rows[0]["service_charge"].ToString());
            rcRec.system_balance_asof_statement = Decimal.Parse(dt.Rows[0]["system_balance_asof_statement"].ToString());

            rcRec.total_cleared = Decimal.Parse(dt.Rows[0]["total_cleared"].ToString());
            rcRec.total_unclear_after_statement = Decimal.Parse(dt.Rows[0]["total_unclear_after_statement"].ToString());
            rcRec.total_uncleared = Decimal.Parse(dt.Rows[0]["total_uncleared"].ToString());
            DataTable dtPayment = getAllPaymentDT(rcRec);
            DataTable dtReceivement = getAllReceivementDT(rcRec);
            if (dtPayment.Rows.Count > 0)
            {
                rcRec.dtPayment = dtPayment;
            }
            if (dtReceivement.Rows.Count > 0)
            {
                rcRec.dtReceivement = dtReceivement;
            }
            if (dtPayment.Rows.Count == 0 && dtReceivement.Rows.Count == 0)
            {
                this.deleteReconcile(rcRec);
                return null;
            }
        }
        else
        {
            return null;
        }
        return rcRec;
    }



    public ReconcileRecord get_Entry(int recon_id)
    {
        DataTable dt = new DataTable();
        SQL = "select top 1 * from reconcile where recon_state='C' AND  elt_account_number = " + elt_account_number + " AND recon_id = " + recon_id + " ";

        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);
        GeneralUtility util = new GeneralUtility();
        util.removeNull(ref dt);
        ReconcileRecord rcRec = new ReconcileRecord();


        if (dt.Rows.Count > 0)
        {
            rcRec.interested_earned_date = dt.Rows[0]["interested_earned_date"].ToString();
            rcRec.modified_date = dt.Rows[0]["modified_date"].ToString();
            rcRec.recon_state = dt.Rows[0]["recon_state"].ToString();
            rcRec.service_charge_date = dt.Rows[0]["service_charge_date"].ToString();
            rcRec.system_balance_asof_recon_date = Decimal.Parse(dt.Rows[0]["system_balance_asof_recon_date"].ToString());
            rcRec.statement_ending_date = dt.Rows[0]["statement_ending_date"].ToString();
            rcRec.created_date = dt.Rows[0]["created_date"].ToString();

            rcRec.elt_account_number = dt.Rows[0]["elt_account_number"].ToString();
            rcRec.bank_account_number = Int32.Parse(dt.Rows[0]["bank_account_number"].ToString());
            rcRec.recon_id = Int32.Parse(dt.Rows[0]["recon_id"].ToString());
            rcRec.statement_ending_balance = Decimal.Parse(dt.Rows[0]["statement_ending_balance"].ToString());
            rcRec.interest_earned = Decimal.Parse(dt.Rows[0]["interest_earned"].ToString());
            rcRec.opening_balance = Decimal.Parse(dt.Rows[0]["opening_balance"].ToString());
            rcRec.service_charge = Decimal.Parse(dt.Rows[0]["service_charge"].ToString());
            rcRec.system_balance_asof_statement = Decimal.Parse(dt.Rows[0]["system_balance_asof_statement"].ToString());

            rcRec.total_cleared = Decimal.Parse(dt.Rows[0]["total_cleared"].ToString());
            rcRec.total_unclear_after_statement = Decimal.Parse(dt.Rows[0]["total_unclear_after_statement"].ToString());
            rcRec.total_uncleared = Decimal.Parse(dt.Rows[0]["total_uncleared"].ToString());
            DataTable dtPayment = getAllPaymentDT(rcRec);
            DataTable dtReceivement = getAllReceivementDT(rcRec);
            if (dtPayment.Rows.Count > 0)
            {
                rcRec.dtPayment = dtPayment;
            }
            if (dtReceivement.Rows.Count > 0)
            {
                rcRec.dtReceivement = dtReceivement;
            }
            if (dtPayment.Rows.Count == 0 && dtReceivement.Rows.Count == 0)
            {
                this.deleteReconcile(rcRec);
                return null;
            }
        }
        return rcRec;
    }

    public DataTable getAllReceivementDT(ReconcileRecord rcRec)
    {
        SQL = "select is_recon_cleared as is_checked, * from reconcile_receivement_detail where elt_account_number =" + elt_account_number;
        SQL += " and recon_id =" + rcRec.recon_id;
        SQL += " order by tran_date";

        DataTable dt = new DataTable();
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);
        return dt;
    }

    public DataTable getAllPaymentDT(ReconcileRecord rcRec)
    {
        SQL = "select is_recon_cleared as is_checked, * from reconcile_payment_detail where elt_account_number =" + elt_account_number;
        SQL += " and recon_id =" + rcRec.recon_id;
        SQL += " order by tran_date";
        DataTable dt = new DataTable();
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);
        return dt;
    }


    public DataTable getAllClearedDT(int  recon_id)
    {
        SQL = "select credit_amount as amount, is_recon_cleared as is_checked, * from reconcile_payment_detail where elt_account_number =" + elt_account_number;
        SQL += " and is_recon_cleared = 'Y' and recon_id =" + recon_id;
        SQL += " union select debit_amount as amount, is_recon_cleared as is_checked, * from reconcile_receivement_detail where elt_account_number =" + elt_account_number;
        SQL += " and is_recon_cleared = 'Y' and recon_id =" + recon_id;
        SQL += " order by tran_date";
        DataTable dt = new DataTable();
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);
        return dt;
    }

    public DataTable getAllReconcileDT(int bankacct)
    {
        SQL = "select * from reconcile  where elt_account_number =" + elt_account_number;  
        SQL += " and bank_account_number =" + bankacct;
        SQL += " order by statement_ending_date";
        DataTable dt = new DataTable();
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);
        return dt;
    }

    public ArrayList getAllReconcileRecordList(int bankacct)
    {
        ArrayList list = new ArrayList();
        SQL = "select * from reconcile  where elt_account_number =" + elt_account_number;
        SQL += " and bank_account_number =" + bankacct;
        SQL += " order by statement_ending_date";
        DataTable dt = new DataTable();
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);
        
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            ReconcileRecord rcRec = new ReconcileRecord();
            rcRec.interested_earned_date = dt.Rows[i]["interested_earned_date"].ToString();
            rcRec.modified_date = dt.Rows[i]["modified_date"].ToString();
            rcRec.recon_state = dt.Rows[i]["recon_state"].ToString();
            rcRec.service_charge_date = dt.Rows[i]["service_charge_date"].ToString();
            rcRec.system_balance_asof_recon_date = Decimal.Parse(dt.Rows[i]["system_balance_asof_recon_date"].ToString());
            rcRec.statement_ending_date = DateTime.Parse(dt.Rows[i]["statement_ending_date"].ToString()).ToShortDateString();
            rcRec.created_date = dt.Rows[i]["created_date"].ToString();

            rcRec.elt_account_number = dt.Rows[i]["elt_account_number"].ToString();
            rcRec.bank_account_number = Int32.Parse(dt.Rows[i]["bank_account_number"].ToString());
            rcRec.recon_id = Int32.Parse(dt.Rows[i]["recon_id"].ToString());
            rcRec.statement_ending_balance = Decimal.Parse(dt.Rows[i]["statement_ending_balance"].ToString());
            rcRec.interest_earned = Decimal.Parse(dt.Rows[i]["interest_earned"].ToString());
            rcRec.opening_balance = Decimal.Parse(dt.Rows[i]["opening_balance"].ToString());
            rcRec.service_charge = Decimal.Parse(dt.Rows[i]["service_charge"].ToString());
            rcRec.system_balance_asof_statement = Decimal.Parse(dt.Rows[i]["system_balance_asof_statement"].ToString());

            rcRec.total_cleared = Decimal.Parse(dt.Rows[i]["total_cleared"].ToString());
            rcRec.total_unclear_after_statement = Decimal.Parse(dt.Rows[i]["total_unclear_after_statement"].ToString());
            rcRec.total_uncleared = Decimal.Parse(dt.Rows[i]["total_uncleared"].ToString());
            
            list.Add(rcRec);
            
        }
        return list;
    }

    public DataTable getAllReceivementDT_All_Accounts_Journal(ReconcileRecord rcRec)
    {
        SQL = "select isnull(is_recon_cleared,'N') as is_checked, * from all_accounts_journal where isnull(is_recon_cleared,'N') <> 'Y' and elt_account_number =" + elt_account_number;
        SQL+=" and tran_date <='"+rcRec.statement_ending_date+"'";

        SQL += " and credit_amount = 0";
        SQL += " and debit_amount <> 0";
        SQL += " and gl_account_number ='" + rcRec.bank_account_number + "'";
        SQL += " order by tran_date" ;

        DataTable dt = new DataTable();        
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);
        return dt;
    }


    public DataTable getAllPaymentDT_All_Accounts_Journal(ReconcileRecord rcRec)
    {
        SQL = "select isnull(is_recon_cleared,'N') as is_checked, * from all_accounts_journal where isnull(is_recon_cleared,'N') <> 'Y' and elt_account_number =" + elt_account_number;
        SQL += " and tran_date <='" + rcRec.statement_ending_date + "'";
        
        SQL += " and credit_amount <> 0";
        SQL += " and debit_amount = 0";
        SQL += " and gl_account_number ='" + rcRec.bank_account_number + "'";
        SQL += " order by tran_date";
        DataTable dt = new DataTable();
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);
        return dt;
    }

    public ReconcilePaymentDetailRecord getServiceChargeForReconcile_All_Accounts_Journal(ReconcileRecord rcRec)
    { 
        SQL = "select isnull(is_recon_cleared,'N') as is_checked, * from all_accounts_journal where isnull(is_recon_cleared,'N') <> 'Y' and elt_account_number =" + elt_account_number;
    
        SQL += " and tran_num=" + rcRec.recon_id;
        SQL += " and tran_type ='REC'";
        SQL += " and memo ='Reconcile -- Bank Service Charge'"; 
        SQL += " and gl_account_number ='" + rcRec.bank_account_number + "'";
       
        DataTable dt = new DataTable();
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);
        ReconcilePaymentDetailRecord RPDRec = new ReconcilePaymentDetailRecord();
        if (dt.Rows.Count == 1)
        {

            RPDRec.customer_name = dt.Rows[0]["customer_name"].ToString();
            RPDRec.customer_number = Int32.Parse(dt.Rows[0]["customer_number"].ToString());
            RPDRec.credit_amount = Decimal.Parse(dt.Rows[0]["credit_amount"].ToString());
            RPDRec.elt_account_number = Int32.Parse(dt.Rows[0]["elt_account_number"].ToString());
            RPDRec.gl_account_name = dt.Rows[0]["gl_account_name"].ToString();
            RPDRec.gl_account_number = Int32.Parse(dt.Rows[0]["gl_account_number"].ToString());
            RPDRec.tran_date = dt.Rows[0]["tran_date"].ToString();

            RPDRec.tran_num = Int32.Parse(dt.Rows[0]["tran_num"].ToString());
            RPDRec.tran_seq_num = Int32.Parse(dt.Rows[0]["tran_seq_num"].ToString());
            RPDRec.tran_type = dt.Rows[0]["tran_type"].ToString();
            RPDRec.memo = dt.Rows[0]["memo"].ToString();
            RPDRec.is_recon_cleared = "N";
        }
        return RPDRec;
    }

    public ReconcileReceivementDetailRecord getInterestEernedForReconcile_All_Accounts_Journal(ReconcileRecord rcRec)
    {
        SQL = "select isnull(is_recon_cleared,'N') as is_checked, * from all_accounts_journal where isnull(is_recon_cleared,'N') <> 'Y' and elt_account_number =" + elt_account_number;

        SQL += " and tran_num=" + rcRec.recon_id;
        SQL += " and tran_type ='REC'";
        SQL += " and memo ='Reconcile -- Interest Income'";
        SQL += " and gl_account_number ='" + rcRec.bank_account_number + "'";
        DataTable dt = new DataTable();
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);
        ReconcileReceivementDetailRecord RRDRec = new ReconcileReceivementDetailRecord();
        if (dt.Rows.Count == 1)
        {

            RRDRec.customer_name = dt.Rows[0]["customer_name"].ToString();
            RRDRec.customer_number = Int32.Parse(dt.Rows[0]["customer_number"].ToString());
            RRDRec.debit_amount = Decimal.Parse(dt.Rows[0]["debit_amount"].ToString());
            RRDRec.elt_account_number = Int32.Parse(dt.Rows[0]["elt_account_number"].ToString());
            RRDRec.gl_account_name = dt.Rows[0]["gl_account_name"].ToString();
            RRDRec.gl_account_number = Int32.Parse(dt.Rows[0]["gl_account_number"].ToString());
            RRDRec.tran_date = dt.Rows[0]["tran_date"].ToString();

            RRDRec.tran_num = Int32.Parse(dt.Rows[0]["tran_num"].ToString());
            RRDRec.tran_seq_num = Int32.Parse(dt.Rows[0]["tran_seq_num"].ToString());
            RRDRec.tran_type = dt.Rows[0]["tran_type"].ToString();
            RRDRec.memo = dt.Rows[0]["memo"].ToString();
            RRDRec.is_recon_cleared = "N";
        }
            return RRDRec;
    }

    public Decimal getAllUnclearedTransationAmountWithinPeriod(string start, string end, int bank_account_number)
    {
        Decimal balance = 0;
        SQL = "select sum(isnull(credit_amount,0))+sum(isnull(debit_amount,0)) as balance  from all_accounts_journal where isnull(is_recon_cleared,'N') <> 'Y' and elt_account_number =" + elt_account_number;
        SQL += " and tran_date >='" + start + "'";
        SQL += " and tran_date <='" + end + "'";        
        SQL += " and gl_account_number ='" + bank_account_number + "'";
        
        DataTable dt = new DataTable();
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        adp.Fill(dt);

        try
        {
            balance = Decimal.Parse(dt.Rows[0]["balance"].ToString());

        }catch(Exception ex)
        {


        }

        return balance;
    }


}
