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
/// Summary description for checkQueueManager
/// </summary>
public class CheckQueueManager:Manager
{
    private CheckDetailManager cdMgr;
    private BillManager bMgr;
    private AllAccountsJournalManager aajMgr;

    public CheckQueueManager(string elt_acct): base(elt_acct)
    {
        aajMgr = new AllAccountsJournalManager(elt_account_number);
        cdMgr = new CheckDetailManager(elt_account_number);   
        bMgr = new BillManager(elt_account_number);
    }
    public CheckQueueRecord getcheckQueue(int print_id)
    {
        SQL = "select isnull(chk_void,'N') as chk_void, isnull(chk_complete,'N') as chk_complete, * from check_queue where elt_account_number = " + elt_account_number + " and print_id=" + print_id;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        CheckQueueRecord cQRec = new CheckQueueRecord();
        GeneralUtility gUtil = new GeneralUtility();

        ad.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            try
            {
                gUtil.removeNull(ref dt);
                cQRec.ap = Int32.Parse(dt.Rows[0]["ap"].ToString());
                cQRec.bank = Int32.Parse(dt.Rows[0]["bank"].ToString());
                cQRec.bill_date = dt.Rows[0]["bill_date"].ToString();
                cQRec.bill_due_date = dt.Rows[0]["bill_due_date"].ToString();
                cQRec.check_amt = Decimal.Parse(dt.Rows[0]["check_amt"].ToString());
                cQRec.check_no = Int32.Parse(dt.Rows[0]["Check_no"].ToString());
                cQRec.check_type = dt.Rows[0]["Check_type"].ToString();
                cQRec.is_org_merged = dt.Rows[0]["is_org_merged"].ToString();
                cQRec.memo = dt.Rows[0]["memo"].ToString();
                cQRec.pmt_method = dt.Rows[0]["pmt_method"].ToString();
                cQRec.print_check_as = dt.Rows[0]["print_check_as"].ToString();
                cQRec.print_date = dt.Rows[0]["print_date"].ToString();
                cQRec.print_id = Int32.Parse((dt.Rows[0]["print_id"].ToString()));
                cQRec.print_status = dt.Rows[0]["print_status"].ToString();
                cQRec.vendor_info = dt.Rows[0]["vendor_info"].ToString();
                cQRec.vendor_name = dt.Rows[0]["vendor_name"].ToString();
                cQRec.vendor_number = Int32.Parse((dt.Rows[0]["vendor_number"].ToString()));
                cQRec.chk_void = (dt.Rows[0]["chk_void"].ToString() == "Y" ? true : false);
                cQRec.chk_complete = (dt.Rows[0]["chk_complete"].ToString() == "Y" ? true : false);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        return cQRec;
    }

    public DataTable getCheckQueueDTwithinPeriod(string start, string end, int vendor_id,string checkNo, string refNo, int bank_acct,  string method,Decimal amount)
    {
        DataTable dt = new DataTable();
        SQL = "select convert( varchar(10), DATEPART(month, a.print_date)) +'/'+ convert( NVARCHAR(10),DATEPART(day, a.print_date))+'/'+convert( varchar(10),DATEPART(year, a.print_date)) as print_date,a.*, 0 as is_selected, case when check_type='BP' then 'pay_bills.aspx?view=yes&CheckQueueID='+convert( varchar(10),a.print_id)  else  'write_check.aspx?view=yes&CheckQueueID='+convert( varchar(10),a.print_id)  end as url"+
            " from check_queue a where isnull(a.chk_void,'N') <>'Y' and a.elt_account_number = "
            + elt_account_number + " AND a.print_date >='" + start + "'and a.print_date <= '" + end + "'";
        if (vendor_id != 0)
        {

            SQL += " AND vendor_number = " + vendor_id;
        }
        if (checkNo != "")
        {

            SQL += " AND check_no = '" + checkNo + "'";
        }
        if (refNo != "")
        {

            SQL += " AND memo = '" + refNo + "'";
        }

        if (bank_acct != 0)
        {

            SQL += " AND bank = " + bank_acct;
        }
        if (method != "")
        {

            SQL += " AND pmt_method = '" + method + "'";
        }
        if (amount != 0)
        {

            SQL += " AND check_amt = " + amount;
        }
        try
        {           
            SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
            CheckQueueRecord cQRec = new CheckQueueRecord();
            GeneralUtility gUtil = new GeneralUtility();
            ad.Fill(dt);
        }
        catch(Exception ex)
        {
            throw ex;
        }
        return dt;
    }

    public CheckQueueRecord getcheckQueueWithCheckNumber(int check_no)
    {
        SQL = "select  * from check_queue where elt_account_number = " + elt_account_number + " and check_no=" + check_no;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        CheckQueueRecord cQRec = new CheckQueueRecord();
        GeneralUtility gUtil = new GeneralUtility();
        ad.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            try
            {
                gUtil.removeNull(ref dt);
                cQRec.ap = Int32.Parse(dt.Rows[0]["ap"].ToString());
                cQRec.bank = Int32.Parse(dt.Rows[0]["bank"].ToString());
                cQRec.bill_date = dt.Rows[0]["bill_date"].ToString();
                cQRec.bill_due_date = dt.Rows[0]["bill_due_date"].ToString();
                cQRec.check_amt = Decimal.Parse(dt.Rows[0]["check_amt"].ToString());
                cQRec.check_no = Int32.Parse(dt.Rows[0]["Check_no"].ToString());
                cQRec.check_type = dt.Rows[0]["Check_type"].ToString();
                cQRec.is_org_merged = dt.Rows[0]["is_org_merged"].ToString();
                cQRec.memo = dt.Rows[0]["memo"].ToString();
                cQRec.pmt_method = dt.Rows[0]["pmt_method"].ToString();
                cQRec.print_check_as = dt.Rows[0]["print_check_as"].ToString();
                cQRec.print_date = dt.Rows[0]["print_date"].ToString();
                cQRec.print_id = Int32.Parse((dt.Rows[0]["print_id"].ToString()));
                cQRec.print_status = dt.Rows[0]["print_status"].ToString();
                cQRec.vendor_info = dt.Rows[0]["vendor_info"].ToString();
                cQRec.vendor_name = dt.Rows[0]["vendor_name"].ToString();
                cQRec.vendor_number = Int32.Parse((dt.Rows[0]["vendor_number"].ToString()));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        return cQRec;
    }


    public  bool searchPayment(int id, string type, ref CheckQueueRecord Check)
    {
        int print_id = 0;
        string tran_type = "BP-CHK";
        
        if (type == "Check")
        {
            Check= getcheckQueueWithCheckNumber(id);          
        }
        else
        {
            Check = getcheckQueue(id);           
        }
        print_id = Check.print_id;

        if (print_id != 0)
        {           
            Check.CheckDetailList = cdMgr.getcheckDetailListForPrintId(print_id);
            if (Check.pmt_method != "Check")
            {
                tran_type = "PMT";
            }
            Check.All_accounts_journal_entry_list = aajMgr.get_Entries(print_id, tran_type);
        }
        else
        {
            return false;
        }
        return true;
    }


    public bool enqueueCheck(CheckQueueRecord Check, string tran_type)
    {
        bool return_val = false;
        Check.replaceQuote();
        BillManager bMgr=new BillManager(elt_account_number);

        ArrayList AAJEntryList = Check.All_accounts_journal_entry_list;
        int printID = getNextPrintID();
       
        Check.print_id = printID;

        BillRecord bRec = (BillRecord)Check.BillList[0];
        bRec.Print_id = printID;
        if (bMgr.insertBillRecord(ref bRec,"CHK"))
        {

            for (int i = 0; i < AAJEntryList.Count; i++)
            {
                if (((AllAccountsJournalRecord)AAJEntryList[i]).gl_account_number != -1 && ((AllAccountsJournalRecord)AAJEntryList[i]).gl_account_number != 0)
                {
                    this.aajMgr.checkInitial_Acct_Record((AllAccountsJournalRecord)AAJEntryList[i]);
                }
            }

            int tran_seq_id = this.aajMgr.getNextTranSeqNumber();

            //INSERT CHECK_DETAL LIST 
            Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Con.Open();
            SqlTransaction trans = Con.BeginTransaction();
            Cmd.Transaction = trans;

            try
            {
                ArrayList chkList = Check.CheckDetailList;
                for (int i = 0; i < chkList.Count; i++)
                {
                    CheckDetailRecord cdRec = (CheckDetailRecord)chkList[i];
                    cdRec.replaceQuote();
                    cdRec.print_id = printID;
                    SQL = "INSERT INTO [check_detail] ";
                    SQL += "( elt_account_number, ";
                    SQL += "amt_due,";
                    SQL += "amt_paid,";
                    SQL += "bill_amt,";
                    SQL += "bill_number,";
                    SQL += "due_date,";
                    SQL += "invoice_no,";
                    SQL += "memo,";
                    SQL += "pmt_method,";
                    SQL += "print_id,";
                    SQL += "tran_id)";
                    SQL += "VALUES";
                    SQL += "('" + elt_account_number;
                    SQL += "','" + cdRec.amt_due;
                    SQL += "','" + cdRec.amt_paid;
                    SQL += "','" + cdRec.bill_amt;
                    SQL += "','" + cdRec.bill_number;
                    SQL += "','" + cdRec.due_date;

                    SQL += "','" + cdRec.invoice_no;
                    SQL += "','" + cdRec.memo;
                    SQL += "','" + cdRec.pmt_method;
                    SQL += "','" + printID;
                    SQL += "','" + cdRec.tran_id;
                    SQL += "')";
                    Cmd.CommandText = SQL;
                    Cmd.ExecuteNonQuery();
                }
                //INSERT AAJ ENTRIES 
                for (int i = 0; i < AAJEntryList.Count; i++)
                {
                    if (((AllAccountsJournalRecord)AAJEntryList[i]).gl_account_number != -1 && ((AllAccountsJournalRecord)AAJEntryList[i]).gl_account_number != 0)
                    {
                        ((AllAccountsJournalRecord)AAJEntryList[i]).replaceQuote();
                        ((AllAccountsJournalRecord)AAJEntryList[i]).tran_num = printID;
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
                        SQL += "','" + tran_seq_id++;
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
                //INSERT A CHECK 

                string check_type = "";
                if (tran_type == "CHK" || tran_type == "CSH" || tran_type == "CRC" || tran_type == "BTB")
                {
                    check_type = "C";
                }
                else
                {
                    check_type = "BP";
                }

                SQL = "INSERT INTO [check_queue] ";
                SQL += "(elt_account_number,";
                SQL += "ap,";
                SQL += "bank,";
                SQL += "bill_date,";
                SQL += "bill_due_date,";
                SQL += "check_amt,";
                SQL += "check_type,";
                SQL += "memo,";
                SQL += "pmt_method,";
                SQL += "print_check_as,";
                SQL += "print_date,";
                SQL += "print_id,";
                SQL += "print_status,";
                SQL += "vendor_info,";
                SQL += "vendor_name,";
               if (Check.check_no != 0)
                {
                    SQL += "check_no,";
                }
                SQL += "vendor_number)";
                SQL += "VALUES";
                SQL += "('" + elt_account_number;
                SQL += "','" + Check.ap;
                SQL += "','" + Check.bank;
                SQL += "','" + Check.bill_date;
                SQL += "','" + Check.bill_due_date;
                SQL += "','" + Check.check_amt;
                SQL += "','" + check_type;
                SQL += "','" + Check.memo;
                SQL += "','" + Check.pmt_method;
                SQL += "','" + Check.print_check_as;
                SQL += "','" + Check.print_date;
                SQL += "','" + Check.print_id;
                SQL += "','" + Check.print_status;
                SQL += "','" + Check.vendor_info;
                SQL += "','" + Check.vendor_name;
               if (Check.check_no != 0)
                {
                    SQL += "','" + Check.check_no;
                }
                SQL += "','" + Check.vendor_number;
                SQL += "')";
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
        }
        if (Check.check_no != 0)
        {
            GLManager glmgr = new GLManager(elt_account_number);
            try
            {
                glmgr.updateNextCheckNumber(Check.bank,Check.check_no);
            }
            catch (Exception ex2)
            {
                throw ex2;
            }
        }
        return return_val;
    }

    public bool updateCheck(CheckQueueRecord Check, string tran_type)
    {
        bool return_val = false;
        Check.replaceQuote();
        BillManager bMgr = new BillManager(elt_account_number);

        ArrayList AAJEntryList = Check.All_accounts_journal_entry_list;
        int printID = Check.print_id;
      

        BillRecord bRec = (BillRecord)Check.BillList[0];
        
        if (bMgr.updateBillRecord(ref bRec, "CHK"))
        {

            for (int i = 0; i < AAJEntryList.Count; i++)
            {
                if (((AllAccountsJournalRecord)AAJEntryList[i]).gl_account_number != -1 && ((AllAccountsJournalRecord)AAJEntryList[i]).gl_account_number != 0)
                {
                    this.aajMgr.checkInitial_Acct_Record((AllAccountsJournalRecord)AAJEntryList[i]);
                }
            }

            int tran_seq_id = this.aajMgr.getNextTranSeqNumber();

            
            Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Con.Open();
            SqlTransaction trans = Con.BeginTransaction();
            Cmd.Transaction = trans;

            try
            {
                //DELETE PREVIOUS CHECK_DETAIL LIST

                SQL = "DELETE FROM check_detail where elt_account_number ="+elt_account_number+" and print_id=" + printID;
                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();

                //DELETE ALL_ACCOUNTS_JOURNAL ENTRY

                SQL = "DELETE FROM all_accounts_journal where elt_account_number =" + elt_account_number + " and tran_num=" + printID + " and tran_type='" + tran_type + "'";
                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();

                //INSERT CHECK_DETAL LIST 
                ArrayList chkList = Check.CheckDetailList;
                for (int i = 0; i < chkList.Count; i++)
                {
                    CheckDetailRecord cdRec = (CheckDetailRecord)chkList[i];
                    cdRec.replaceQuote();
                    cdRec.print_id = printID;
                    SQL = "INSERT INTO [check_detail] ";
                    SQL += "( elt_account_number, ";
                    SQL += "amt_due,";
                    SQL += "amt_paid,";
                    SQL += "bill_amt,";
                    SQL += "bill_number,";
                    SQL += "due_date,";
                    SQL += "invoice_no,";
                    SQL += "memo,";
                    SQL += "pmt_method,";
                    SQL += "print_id,";
                    SQL += "tran_id)";
                    SQL += "VALUES";
                    SQL += "('" + elt_account_number;
                    SQL += "','" + cdRec.amt_due;
                    SQL += "','" + cdRec.amt_paid;
                    SQL += "','" + cdRec.bill_amt;
                    SQL += "','" + cdRec.bill_number;
                    SQL += "','" + cdRec.due_date;

                    SQL += "','" + cdRec.invoice_no;
                    SQL += "','" + cdRec.memo;
                    SQL += "','" + cdRec.pmt_method;
                    SQL += "','" + printID;
                    SQL += "','" + cdRec.tran_id;
                    SQL += "')";
                    Cmd.CommandText = SQL;
                    Cmd.ExecuteNonQuery();
                }
                //INSERT AAJ ENTRIES 
                for (int i = 0; i < AAJEntryList.Count; i++)
                {
                    if (((AllAccountsJournalRecord)AAJEntryList[i]).gl_account_number != -1 && ((AllAccountsJournalRecord)AAJEntryList[i]).gl_account_number != 0)
                    {
                        ((AllAccountsJournalRecord)AAJEntryList[i]).replaceQuote();
                        ((AllAccountsJournalRecord)AAJEntryList[i]).tran_num = printID;
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
                        SQL += "','" + tran_seq_id++;
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
                //UPDATE THE CHECK 

                string check_type = "";
                if (tran_type == "CHK" || tran_type == "CSH" || tran_type == "CRC" || tran_type == "BTB")
                {
                    check_type = "C";
                }
                else
                {
                    check_type = "BP";
                }

                SQL = "UPDATE [check_queue] ";
                SQL += "Set elt_account_number='"+elt_account_number+"',";
                SQL += "ap='"+Check.ap+"',";
                SQL += "bank='" + Check.bank + "',";
                SQL += "bill_date='" + Check.bill_date + "',";
                SQL += "bill_due_date='" + Check.bill_due_date + "',";
                SQL += "check_amt='" + Check.check_amt + "',";
                SQL += "check_type='" + check_type + "',";
                SQL += "memo='" + Check.memo + "',";
                SQL += "pmt_method='" + Check.pmt_method + "',";
                SQL += "print_check_as='" + Check.print_check_as + "',";
                SQL += "print_date='" + Check.print_date + "',";
                SQL += "print_id='" + Check.print_id + "',";
                SQL += "print_status='" + Check.print_status + "',";
                SQL += "vendor_info='" + Check.vendor_info + "',";
                SQL += "vendor_name='" + Check.vendor_name + "',";
                SQL += "vendor_number='" + Check.vendor_number + "'";
                SQL += "where elt_account_number =" + elt_account_number 
                    + " and print_id=" + printID;
               
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
        }
        return return_val;
    }


    public bool enqueuePayment(CheckQueueRecord Check,string tran_type)
    {
        Check.replaceQuote();
        bool return_val = false;
        ArrayList AAJEntryList = Check.All_accounts_journal_entry_list;
        int printID = getNextPrintID();
       
        Check.print_id = printID;
        for (int i = 0; i < AAJEntryList.Count; i++)
        {
            this.aajMgr.checkInitial_Acct_Record((AllAccountsJournalRecord)AAJEntryList[i]);
        }
       
        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;

        try
        {
            //UPDATE LIST OF BILLS TO SET THE CHANGES MADE BY PAYMENT 
            ArrayList bRecList = Check.BillList;
            for (int i = 0; i < bRecList.Count; i++)
            {
                BillRecord bRec = (BillRecord)bRecList[i];
                SQL = "update [bill] set ";
                SQL += "elt_account_number='" + elt_account_number + "'";
                SQL += ",bill_number='" + bRec.Bill_number + "'";
                SQL += ",bill_type='" + bRec.Bill_type + "'";
                SQL += ",vendor_number='" + bRec.Vendor_number + "'";
                SQL += ",vendor_name='" + bRec.Vendor_name + "'";
                SQL += ",bill_date='" + bRec.Bill_date + "'";
                SQL += ",bill_due_date='" + bRec.Bill_due_date + "'";
                SQL += ",bill_amt='" + bRec.Bill_amt + "'";
                SQL += ",bill_amt_paid='" + bRec.Bill_amt_paid + "'";
                SQL += ",bill_amt_due='" + bRec.Bill_amt_due + "'";
                SQL += ",ref_no='" + bRec.Bill_amt_paid + "'";
                SQL += ",bill_expense_acct='" + bRec.Bill_expense_acct + "'";
                SQL += ",bill_ap='" + bRec.Bill_ap + "'";
                SQL += ",bill_status='" + bRec.Bill_status + "'";
                SQL += ",print_id='" + printID + "'";
                SQL += ",lock='" + bRec.Lock + "'";
                SQL += ",pmt_method='" + bRec.Pmt_method + "'";
                SQL += " WHERE elt_account_number = " + elt_account_number + " and bill_number=" + bRec.Bill_number;
                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();
            }
            //INSERT CHECK DETAIL LIST 
            ArrayList chkList = Check.CheckDetailList;

            for (int i = 0; i < chkList.Count; i++)
            {
                CheckDetailRecord cdRec = (CheckDetailRecord)chkList[i];
                cdRec.replaceQuote();
                cdRec.print_id = printID;
                SQL = "INSERT INTO [check_detail] ";
                SQL += "( elt_account_number, ";
                SQL += "amt_due,";
                SQL += "amt_paid,";
                SQL += "bill_amt,";
                SQL += "bill_number,";
                SQL += "due_date,";
                SQL += "invoice_no,";
                SQL += "memo,";
                SQL += "pmt_method,";
                SQL += "print_id,";
                SQL += "tran_id)";
                SQL += "VALUES";
                SQL += "('" + elt_account_number;
                SQL += "','" + cdRec.amt_due;
                SQL += "','" + cdRec.amt_paid;
                SQL += "','" + cdRec.bill_amt;
                SQL += "','" + cdRec.bill_number;
                SQL += "','" + cdRec.due_date;
                SQL += "','" + cdRec.invoice_no;
                SQL += "','" + cdRec.memo;
                SQL += "','" + cdRec.pmt_method;
                SQL += "','" + printID;
                SQL += "','" + cdRec.tran_id;
                SQL += "')";
                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();
            }
            //INSERT AAJ ENTRIES 

            int tran_seq_id = 0;

            SQL = "select max(tran_seq_num) from all_accounts_journal where elt_account_number = "
               + elt_account_number;
            Cmd.CommandText = SQL;
            int current = 0;

            string id_str = Cmd.ExecuteScalar().ToString();
            if (id_str != "")
            {
                current = Int32.Parse(id_str);
            }
            else
            {
                current = 0;
            }

            tran_seq_id = current + 1;

            for (int i = 0; i < AAJEntryList.Count; i++)
            {
                ((AllAccountsJournalRecord)AAJEntryList[i]).replaceQuote();
                ((AllAccountsJournalRecord)AAJEntryList[i]).tran_num = printID;
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
                SQL += "','" + tran_seq_id++;
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
            string check_type = "";
            if (tran_type == "BP-CHK")//ONLY AT BILL PAY 
            {
                check_type = "C";
            }
            else
            {
                check_type = "BP";
            }

            SQL = "INSERT INTO [check_queue] ";
            SQL += "(elt_account_number,";
            SQL += "ap,";
            SQL += "bank,";
            SQL += "bill_date,";
            SQL += "bill_due_date,";
            SQL += "check_amt,";
            SQL += "check_type,";
            SQL += "memo,";
            SQL += "pmt_method,";
            SQL += "print_check_as,";
            SQL += "print_date,";
            SQL += "print_id,";
            SQL += "print_status,";
            SQL += "vendor_info,";
            SQL += "vendor_name,";
           if (Check.check_no != 0)
            {
                SQL += "check_no,";
            }
            SQL += "vendor_number)";
            SQL += "VALUES";
            SQL += "('" + elt_account_number;
            SQL += "','" + Check.ap;
            SQL += "','" + Check.bank;
            SQL += "','" + Check.bill_date;
            SQL += "','" + Check.bill_due_date;
            SQL += "','" + Check.check_amt;
            SQL += "','" + check_type;
            SQL += "','" + Check.memo;
            SQL += "','" + Check.pmt_method;
            SQL += "','" + Check.print_check_as;
            SQL += "','" + Check.print_date;
            SQL += "','" + Check.print_id;
            SQL += "','" + Check.print_status;
            SQL += "','" + Check.vendor_info;
            SQL += "','" + Check.vendor_name;
           if (Check.check_no != 0)
            {
                SQL += "','" + Check.check_no;
            }
            SQL += "','" + Check.vendor_number;
            SQL += "')";
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
        if (Check.check_no != 0)
        {
            GLManager glmgr = new GLManager(elt_account_number);
            try
            {
                glmgr.updateNextCheckNumber(Check.bank,Check.check_no);
            }
            catch (Exception ex2)
            {
                throw ex2;
            }
        }
        return return_val;
    }

    private int  getNextPrintID()
    {
        SQL = "select max(print_id) from check_queue where elt_account_number = " + elt_account_number ;
        int id = 0;
        Cmd = new SqlCommand(SQL, Con);
        try
        {
            Con.Open();
            string id_str = Cmd.ExecuteScalar().ToString();
            if (id_str != "")
            {
                id = Int32.Parse(id_str);
                id = id + 1;
            }
            else
            {
                id = 1;
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
        return id;
    }
    
    public bool checkIfExistCheck(CheckQueueRecord cRec)
    {
        SQL = "select count(print_id) from check_queue where elt_account_number = " + elt_account_number + " and print_id=" + cRec.print_id;
        Cmd = new SqlCommand(SQL, Con);
        int rowCount = 0;
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
        if (rowCount >0 )
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    public bool voidCheck(int print_id)
    {
        SQL = "update check_queue set chk_void='Y' where elt_account_number = " + elt_account_number + " and print_id = " + print_id;
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

    public bool CancelPayment(int print_id,string tran_type)
    {
        bool return_val = false;
        int check_no = Int32.Parse(getCheckNo(print_id));
        ArrayList cdList = cdMgr.getcheckDetailListForPrintId(print_id);
        ArrayList bRecList = new ArrayList();
        for (int i = 0; i < cdList.Count; i++)
        {
            int bill_number = ((CheckDetailRecord)cdList[i]).bill_number;
            BillRecord bRec = bMgr.getBill(bill_number);
            bRec.Bill_amt_due += ((CheckDetailRecord)cdList[i]).amt_paid;
            bRec.Bill_amt_paid -= ((CheckDetailRecord)cdList[i]).amt_paid;
            if (bRec.Bill_amt_paid == 0)
            {
                bRec.Lock = "N";
            }
            bRec.Bill_status = "A";
            bRecList.Add(bRec);
        }
        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;
        try
        {
            //UPDATE BILL RECORD
            for (int i = 0; i < bRecList.Count; i++)
            {
                BillRecord bRec = (BillRecord)bRecList[i];
                int bill_number = bRec.Bill_number;
                SQL = "update [bill] set ";
                SQL += "elt_account_number='" + elt_account_number + "'";
                SQL += ",bill_number='" + bRec.Bill_number + "'";
                SQL += ",bill_type='" + bRec.Bill_type + "'";
                SQL += ",vendor_number='" + bRec.Vendor_number + "'";
                SQL += ",vendor_name='" + bRec.Vendor_name + "'";
                SQL += ",bill_date='" + bRec.Bill_date + "'";
                SQL += ",bill_due_date='" + bRec.Bill_due_date + "'";
                SQL += ",bill_amt='" + bRec.Bill_amt + "'";
                SQL += ",bill_amt_paid='" + bRec.Bill_amt_paid + "'";
                SQL += ",bill_amt_due='" + bRec.Bill_amt_due + "'";
                SQL += ",ref_no='" + bRec.Bill_amt_paid + "'";
                SQL += ",bill_expense_acct='" + bRec.Bill_expense_acct + "'";
                SQL += ",bill_ap='" + bRec.Bill_ap + "'";
                SQL += ",bill_status='" + bRec.Bill_status + "'";
                SQL += ",print_id='" + print_id + "'";
                SQL += ",lock='" + bRec.Lock + "'";
                SQL += ",pmt_method='" + bRec.Pmt_method + "'";
                SQL += " WHERE elt_account_number = " + elt_account_number + " and bill_number=" + bRec.Bill_number;

                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();

            }
            //DELETE ALL THE CHECK DETAIL( ALL PAYMNET HAS ITS CHECK DETAIL!!) 
            SQL = "delete from check_detail where elt_account_number = " + elt_account_number + " and print_id=" + print_id;

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            if (tran_type == "BP-CHK" || tran_type == "CHK")
            {
                //VOID CHECK INSIDE CHECK_QUEUE
                SQL = "update check_queue set chk_void='Y' where elt_account_number = " + elt_account_number + " and print_id = " + print_id;

                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();
                //VOID CHECK IN AAJ 
                SQL = "update all_accounts_journal set chk_void='Y', debit_amount=0, credit_amount=0 where elt_account_number = " + elt_account_number + " and tran_num = " + print_id + " and tran_type='" + tran_type + "'";

                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();

                if (check_no == 0)
                {
                    SQL = "delete from  check_queue  where elt_account_number = " + elt_account_number + " and print_id = " + print_id;

                    Cmd.CommandText = SQL;
                    Cmd.ExecuteNonQuery();
                }

            }
            else
            {
                //DELETE ALL AAJ ENTRIES 
                SQL = "Delete  FROM all_accounts_journal WHERE elt_account_number = "
                    + elt_account_number + " AND tran_num = " + print_id + " AND tran_type = '" + tran_type + "'";

                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();

                //DELETE CHECK QUEUE ENTRIES 
                SQL = "delete from  check_queue  where elt_account_number = " + elt_account_number + " and print_id = " + print_id;

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

    public string getCheckType(int print_id)
    {
        string type = "";
        SQL = "select check_type from  check_queue  where elt_account_number = " + elt_account_number + " and print_id = " + print_id;
        Cmd = new SqlCommand(SQL, Con);       
        try
        {
            Con.Open();
            type = Cmd.ExecuteScalar().ToString();
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            Con.Close();
        }
        return type;
    }

    public string getCheckNo(int print_id)
    {
        string check_no = "";
        SQL = "select check_no from  check_queue  where elt_account_number = " + elt_account_number + " and print_id = " + print_id;
        Cmd = new SqlCommand(SQL, Con);
        try
        {
            Con.Open();
            check_no = Cmd.ExecuteScalar().ToString();
            if (check_no == "")
            {
                check_no = "0";
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
        return check_no;
    }

}