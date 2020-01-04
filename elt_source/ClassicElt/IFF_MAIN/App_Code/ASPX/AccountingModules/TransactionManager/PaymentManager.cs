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
/// Summary description for customerPaymentManager
/// </summary>
public class PaymentManager:Manager
{
    private PaymentDetailManager pdMgr;
    private AllAccountsJournalManager AAJMgr;
    private InvoiceManager ivMgr;
    private CustomerCreditManager ccMgr;

    public bool CancelPayment(PaymentRecord pRec, string tran_type,string is_credit_back)
    {
        Decimal totalPayment = 0;
        bool return_val = false;
        int payment_no = pRec.payment_no;
        ArrayList pdList = pdMgr.getPaymentDetailList(payment_no);
        //Get invoice list from payment detail 

        ArrayList IRecList = new ArrayList();
        for (int i = 0; i < pdList.Count; i++)
        {
            int invoice_no = ((PaymentDetailRecord)pdList[i]).invoice_no;
            InvoiceRecord IRec = ivMgr.getInvoiceRecord(invoice_no);
            IRec.amount_paid -= ((PaymentDetailRecord)pdList[i]).payment;
            
            totalPayment += ((PaymentDetailRecord)pdList[i]).payment;
            
            IRec.balance += ((PaymentDetailRecord)pdList[i]).payment;

            if (IRec.amount_charged == IRec.balance)
            {
                IRec.lock_ar = "N";
            }
            //ivRec.pmt_method meaningless            
            IRec.pay_status = "A";
            IRecList.Add(IRec);
        }

        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;

        try
        {
            //UPDATE INVOICE LIST 

            for (int i = 0; i < IRecList.Count; i++)
            {
                InvoiceRecord ivRec = (InvoiceRecord)IRecList[i];
                SQL = "update invoice set ";
                SQL += "amount_paid= '" + ivRec.amount_paid + "'  ,";
                SQL += "balance= '" + ivRec.balance + "'  ,";
                SQL += "deposit_to= '" + ivRec.deposit_to + "'  ,";

                if (ivRec.amount_paid == 0)//WHEN NOTHING PAID
                {
                    SQL += "lock_ar= 'N'  ,";
                    SQL += "pay_status= 'A'  ,";
                }
                else if (ivRec.amount_paid == ivRec.amount_charged)//WHEN EVERYTHING'S PAID 
                {
                    SQL += "lock_ar= 'Y'  ,";
                    SQL += "pay_status= 'p'  ,";
                }
                else//WHEN PARTIALLY PAID 
                {
                    SQL += "lock_ar= 'Y'  ,";
                    SQL += "pay_status= 'A'  ,";
                }
                SQL += "pmt_method= '" + ivRec.pmt_method + "'";
                SQL += " WHERE elt_account_number = " + elt_account_number + " and invoice_no=" + ivRec.Invoice_no;

                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();
            }
            //DELETE PAYMENT DETAIL LIST 
            SQL = "DELETE FROM customer_payment_detail WHERE elt_account_number =";
            SQL += elt_account_number + " and payment_no="
                    + payment_no;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            //DELETE AAJ ENTRIES 
            SQL = "Delete  FROM all_accounts_journal WHERE elt_account_number = "
               + elt_account_number + " AND tran_num = " + payment_no + " AND tran_type = '" + tran_type + "'";
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            //DELETE PAYMENT 
            SQL = "delete  from customer_payment where elt_account_number = " + elt_account_number + " and payment_no=" + payment_no;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            
            if (is_credit_back == "Y")
            {
                SQL = "INSERT INTO [customer_credit_info] ";
                SQL += "(elt_account_number, ";
                SQL += "customer_no,";
                SQL += "tran_date,";
                SQL += "memo,";
                SQL += "credit)";
                SQL += "VALUES";
                SQL += "('" + elt_account_number;
                SQL += "','" + pRec.customer_number;
                SQL += "','" + DateTime.Today.ToShortDateString();
                SQL += "','" + "Refund From Customer Payment";
                SQL += "','" + totalPayment;
                SQL += "')";
                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();
                
            }

            trans.Commit();

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

    public bool insertPaymentRecord(ref PaymentRecord pRec, string tran_type)
    {
        bool return_val = false;

        pRec.replaceQuote();
        int payment_no = getNewpaymentNumber();

       

        ArrayList AAJEntryList = pRec.AllAccountsJournalList;
        ArrayList pdList = pRec.PaymentDetailList;
        ArrayList IVList = pRec.InvoiceList;

        setTranNoForAllAccountsJournalEntries(pRec.AllAccountsJournalList, payment_no);

        for (int i = 0; i < AAJEntryList.Count; i++)
        {
            AAJMgr.checkInitial_Acct_Record((AllAccountsJournalRecord)AAJEntryList[i]);
        }
        int tran_seq_no = AAJMgr.getNextTranSeqNumber();

        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;

        try
        {
            //-------------------------UPDATE PAYMENT DETAILS-------------------------
            //1) DELETE PAYMENT DETAIL LIST 
            SQL = "DELETE FROM customer_payment_detail WHERE elt_account_number =";
            SQL += elt_account_number + " and payment_no="
                     + payment_no;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
            //2) INSERT PAYMENT DETAIL LIST
            for (int i = 0; i < pdList.Count; i++)
            {
                PaymentDetailRecord pdRec = (PaymentDetailRecord)pdList[i];
                pdRec.payment_no = payment_no;
                SQL = "INSERT INTO [customer_payment_detail] ";
                SQL += "( elt_account_number, ";
                SQL += "amt_due,";
                SQL += "item_id,";
                SQL += "invoice_date,";
                SQL += "invoice_no,";
                SQL += "orig_amt,";
                SQL += "payment,";
                SQL += "type,";
                SQL += "payment_no)";
                SQL += "VALUES";
                SQL += "('" + elt_account_number;
                SQL += "','" + pdRec.amt_due;
                SQL += "','" + i;
                SQL += "','" + pdRec.invoice_date;
                SQL += "','" + pdRec.invoice_no;
                SQL += "','" + pdRec.orig_amt;
                SQL += "','" + pdRec.payment;
                SQL += "','" + pdRec.type;
                SQL += "','" + pdRec.payment_no;
                SQL += "')";

                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();
            }
            //----------------UPDATE LIST OF INVOICE RECORD            

            for (int i = 0; i < IVList.Count; i++)
            {
                InvoiceRecord ivRec = (InvoiceRecord)IVList[i];
                SQL = "update invoice set ";
                SQL += "amount_paid= '" + ivRec.amount_paid + "'  ,";
                SQL += "balance= '" + ivRec.balance + "'  ,";
                SQL += "deposit_to= '" + ivRec.deposit_to + "'  ,";
                SQL += "lock_ar= 'Y'  ,";
                if (ivRec.balance == 0)
                {
                    SQL += "pay_status= 'P'  ,";
                }
                else
                {
                    SQL += "pay_status= 'A'  ,";
                }
                SQL += "pmt_method= '" + ivRec.pmt_method + "'";
                SQL += " WHERE elt_account_number = " + elt_account_number + " and invoice_no=" + ivRec.Invoice_no;

                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();
            }
            //----------UPDATE ALL ACCOUNT JOURNAL ENTRIES 

            //1) DELETE AAJ ENTRIES WITH THE SAME PAYMNET NO
            SQL = "Delete  FROM all_accounts_journal WHERE elt_account_number = "
                + elt_account_number + " AND tran_num = " + payment_no + " AND tran_type = '" + tran_type + "'";

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();

            //2)INSERT AAJ ENTRIES 

            for (int i = 0; i < AAJEntryList.Count; i++)
            {
                ((AllAccountsJournalRecord)AAJEntryList[i]).replaceQuote();
                ((AllAccountsJournalRecord)AAJEntryList[i]).tran_num = payment_no;

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
                SQL += "','" + tran_seq_no++;
                SQL += "','" + "PMT";
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
            //INSERT PAYMNET RECORD 
            SQL = "INSERT INTO [customer_payment] ";
            SQL += "(elt_account_number,";
            SQL += "payment_no,";
            SQL += "accounts_receivable,";
            SQL += "added_amt,";
            SQL += "balance,";
            SQL += "branch,";
            SQL += "customer_name,";
            SQL += "customer_number,";
            SQL += "deposit_to,";
            SQL += "existing_credits,";
            SQL += "payment_date,";
            SQL += "pmt_method,";
            SQL += "received_amt,";
            SQL += "ref_no,";
            SQL += "unapplied_amt)";
            SQL += "VALUES";
            SQL += "('" + elt_account_number;
            SQL += "','" + payment_no;
            SQL += "','" + pRec.accounts_receivable;
            SQL += "','" + pRec.added_amt;
            SQL += "','" + pRec.balance;
            SQL += "','" + pRec.branch;
            SQL += "','" + pRec.customer_name;
            SQL += "','" + pRec.customer_number;
            SQL += "','" + pRec.deposit_to;
            SQL += "','" + pRec.existing_credits;
            SQL += "','" + pRec.payment_date;
            SQL += "','" + pRec.pmt_method;
            SQL += "','" + pRec.received_amt;
            SQL += "','" + pRec.ref_no;
            SQL += "','" + pRec.unapplied_amt;
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
        pRec.payment_no = payment_no;
        return return_val;
    }

    //public bool deletePayment(int payment_no)
    //{
    //    SQL = "delete  from customer_payment where elt_account_number = " + elt_account_number + " and payment_no=" + payment_no;
    //    Cmd = new SqlCommand(SQL, Con);
    //    int rowCount = 0;
    //    try
    //    {
    //        Con.Open();
    //        rowCount = Int32.Parse(Cmd.ExecuteNonQuery().ToString());
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //    finally
    //    {
    //        Con.Close();
    //    }
    //    if (rowCount == 1)
    //    {
    //        return true;
    //    }
    //    else
    //    {
    //        return false;
    //    }
    //}
  
    


    public PaymentManager(string elt_acct): base(elt_acct)
    {
        pdMgr=new PaymentDetailManager(elt_account_number);
        AAJMgr=new AllAccountsJournalManager(elt_account_number);
        ivMgr=new InvoiceManager(elt_account_number);
        ccMgr = new CustomerCreditManager(elt_account_number);
	}

    public PaymentRecord getcustomerPaymentRecord(int payment_no)
    {
        SQL = "select * from customer_payment where elt_account_number = " + elt_account_number + " and payment_no=" + payment_no;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        PaymentRecord PRec = new PaymentRecord();
        PRec.payment_no = 0;
        GeneralUtility gUtil=new GeneralUtility();
        PaymentDetailManager pdMger = new PaymentDetailManager(elt_account_number);
        ad.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            try
            {
                gUtil.removeNull(ref dt);
                PRec.accounts_receivable = Decimal.Parse(dt.Rows[0]["accounts_receivable"].ToString());
                PRec.added_amt = Decimal.Parse(dt.Rows[0]["added_amt"].ToString());
                PRec.balance = Decimal.Parse(dt.Rows[0]["balance"].ToString());
                PRec.branch = dt.Rows[0]["branch"].ToString();
                PRec.customer_name = dt.Rows[0]["customer_name"].ToString();
                PRec.customer_number = Int32.Parse((dt.Rows[0]["customer_number"].ToString()));
                PRec.deposit_to = Int32.Parse(dt.Rows[0]["deposit_to"].ToString());
                PRec.existing_credits = Decimal.Parse(dt.Rows[0]["existing_credits"].ToString());
                PRec.is_org_merged = dt.Rows[0]["is_org_merged"].ToString();
                PRec.payment_date = dt.Rows[0]["payment_date"].ToString();
                PRec.payment_no = Int32.Parse((dt.Rows[0]["payment_no"].ToString()));
                PRec.pmt_method = dt.Rows[0]["pmt_method"].ToString();
                PRec.received_amt = Decimal.Parse(dt.Rows[0]["received_amt"].ToString());
                //PRec.PAY
                PRec.ref_no = dt.Rows[0]["ref_no"].ToString();
                PRec.unapplied_amt = Decimal.Parse(dt.Rows[0]["unapplied_amt"].ToString());
                PRec.PaymentDetailList= pdMger.getPaymentDetailList(payment_no);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        return PRec;
    }

    public PaymentRecord getcustomerPaymentRecordByRefCheck(string ref_check)
    {
        SQL = "select * from customer_payment where elt_account_number = " + elt_account_number + " and ref_no='" + ref_check+"'";
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        PaymentRecord PRec = new PaymentRecord();
        PRec.payment_no = 0;
        GeneralUtility gUtil = new GeneralUtility();
        PaymentDetailManager pdMger = new PaymentDetailManager(elt_account_number);
        ad.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            try
            {
                gUtil.removeNull(ref dt);
                PRec.accounts_receivable = Decimal.Parse(dt.Rows[0]["accounts_receivable"].ToString());
                PRec.added_amt = Decimal.Parse(dt.Rows[0]["added_amt"].ToString());
                PRec.balance = Decimal.Parse(dt.Rows[0]["balance"].ToString());
                PRec.branch = dt.Rows[0]["branch"].ToString();
                PRec.customer_name = dt.Rows[0]["customer_name"].ToString();
                PRec.customer_number = Int32.Parse((dt.Rows[0]["customer_number"].ToString()));
                PRec.deposit_to = Int32.Parse(dt.Rows[0]["deposit_to"].ToString());
                PRec.existing_credits = Decimal.Parse(dt.Rows[0]["existing_credits"].ToString());
                PRec.is_org_merged = dt.Rows[0]["is_org_merged"].ToString();
                PRec.payment_date = dt.Rows[0]["payment_date"].ToString();
                PRec.payment_no = Int32.Parse((dt.Rows[0]["payment_no"].ToString()));
                PRec.pmt_method = dt.Rows[0]["pmt_method"].ToString();
                PRec.received_amt = Decimal.Parse(dt.Rows[0]["received_amt"].ToString());
                //PRec.PAY
                PRec.ref_no = dt.Rows[0]["ref_no"].ToString();
                PRec.unapplied_amt = Decimal.Parse(dt.Rows[0]["unapplied_amt"].ToString());
                PRec.PaymentDetailList = pdMger.getPaymentDetailList(PRec.payment_no);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        return PRec;
    }
    public DataTable getPaymentDTwithinPeriod(string start, string end, int customer_number, string refNo, int bank_acct, string method, Decimal amount)
    {
        DataTable dt = new DataTable();
        SQL = "select sum(b.payment) as payment, convert( NVARCHAR(10), DATEPART(month, a.payment_date)) +'/'+ convert( varchar(10),DATEPART(day, a.payment_date))+'/'+convert( varchar(10),DATEPART(year, a.payment_date)) as payment_date,a.payment_no, a.customer_name,a.customer_number,a.ref_no, 0 as is_selected, 'Receiv_pay.aspx?view=yes&PaymentNo='+convert( varchar(10),a.payment_no) as url  from customer_payment a left outer join customer_payment_detail b on a.elt_account_number = b.elt_account_number and a.payment_no=b.payment_no where a.elt_account_number = " + elt_account_number + " AND payment_date >='"
            + start + "'and payment_date <= '" + end+"'";
        if (customer_number != 0)
        {

            SQL += " AND customer_number = " + customer_number;
        }
       
        if (refNo != "")
        {

            SQL += " AND memo = '" + refNo + "'";
        }

        if (bank_acct != 0)
        {

            SQL += " AND a.deposit_to = " + bank_acct;
        }
        if (method != "")
        {

            SQL += " AND a.pmt_method = '" + method + "'";
        }
        if (amount != 0)
        {

            SQL += " AND a.received_amt = " + amount;
        }


        SQL += " Group by a.payment_no, a.customer_name,a.customer_number,a.ref_no,a.payment_date, b.payment";

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
    private int getNewpaymentNumber()
    {
        SQL = "select isnull(max(payment_no),0) as payment_no from customer_payment where elt_account_number = " + elt_account_number;
        int payment_no;
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

        if (dt.Rows.Count == 1)
        {
            payment_no = Int32.Parse(dt.Rows[0]["payment_no"].ToString()) + 1;
        }
        else
        {
            payment_no = 1;
        }

        return payment_no;
    }
   

    private void setTranNoForAllAccountsJournalEntries(ArrayList aajlist, int payment_no)
    {
        for (int i = 0; i < aajlist.Count; i++)
        {
            ((AllAccountsJournalRecord)aajlist[i]).tran_num = payment_no;
        }
    }

    

    public bool checkIfExistPayment(PaymentRecord pRec)
    {
        SQL = "select count(payment_no) from customer_payment where elt_account_number = " + elt_account_number + " and payment_no=" + pRec.payment_no;
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
        if (rowCount == 1)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

   

}