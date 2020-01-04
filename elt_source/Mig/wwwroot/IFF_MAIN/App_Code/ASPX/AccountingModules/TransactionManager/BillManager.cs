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
/// Summary description for BillManager
/// </summary>
public class BillManager:Manager
{
    private BillDetailManager bdMgr;   
    private AllAccountsJournalManager AAJMgr;   
    private GLManager glMgr;

    public BillManager(string elt_acct)
        : base(elt_acct)
	{        
        bdMgr = new BillDetailManager(elt_account_number);
        AAJMgr = new AllAccountsJournalManager(elt_account_number);
        glMgr = new GLManager(elt_account_number);
       
	}

    private int getNewbillNumber()
    {
        SQL = "select max(bill_number) as bill_number from bill where elt_account_number = " + elt_account_number;
        int bill_number;
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

        string id_str = dt.Rows[0]["bill_number"].ToString();

        if (id_str != "")
        {
            bill_number = Int32.Parse(id_str) + 1;
        }
        else
        {
            bill_number = 1;
        }
        return bill_number;
    }
    
    public BillRecord getBill(int bill_number)
    {
        SQL = "select * from bill where elt_account_number = " + elt_account_number + " and bill_number=" + bill_number;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        BillRecord bRec = new BillRecord();
        GeneralUtility gUtil=new GeneralUtility();
        ad.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            try
            {              
                gUtil.removeNull(ref dt);
                bRec.Lock = dt.Rows[0]["lock"].ToString();
                bRec.Bill_amt = Decimal.Parse(dt.Rows[0]["bill_amt"].ToString());
                bRec.Bill_amt_due = Decimal.Parse(dt.Rows[0]["bill_amt_due"].ToString());
                bRec.Bill_amt_paid = Decimal.Parse(dt.Rows[0]["bill_amt_paid"].ToString());
                bRec.Bill_ap = Int32.Parse((dt.Rows[0]["bill_ap"].ToString()));
                bRec.Bill_date = DateTime.Parse(dt.Rows[0]["bill_date"].ToString()).ToShortDateString();
                bRec.Bill_due_date = DateTime.Parse(dt.Rows[0]["bill_due_date"].ToString()).ToShortDateString();
                bRec.Bill_expense_acct = Int32.Parse((dt.Rows[0]["bill_expense_acct"].ToString()));
                bRec.Bill_number = Int32.Parse((dt.Rows[0]["bill_number"].ToString()));
                bRec.Bill_status = dt.Rows[0]["bill_status"].ToString();
                bRec.Bill_type = dt.Rows[0]["bill_type"].ToString();
                bRec.Is_org_merged = dt.Rows[0]["is_org_merged"].ToString();
                bRec.Pmt_method = dt.Rows[0]["pmt_method"].ToString();
                bRec.Print_id = Int32.Parse((dt.Rows[0]["print_id"].ToString()));
                bRec.Ref_no = dt.Rows[0]["ref_no"].ToString();
                bRec.Vendor_name = dt.Rows[0]["vendor_name"].ToString();
                bRec.Vendor_number = Int32.Parse((dt.Rows[0]["vendor_number"].ToString()));
                bRec.BillDetailList = bdMgr.getBillDetailList(bill_number);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        return bRec;
    }



    public BillRecord getBillFromWirteCheck(int print_id)
    {
        SQL = "select * from bill where elt_account_number = " + elt_account_number + " and print_id=" + print_id;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        BillRecord bRec = new BillRecord();
        GeneralUtility gUtil = new GeneralUtility();
        ad.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            try
            {
                gUtil.removeNull(ref dt);
                bRec.Lock = dt.Rows[0]["lock"].ToString();
                bRec.Bill_amt = Decimal.Parse(dt.Rows[0]["bill_amt"].ToString());
                bRec.Bill_amt_due = Decimal.Parse(dt.Rows[0]["bill_amt_due"].ToString());
                bRec.Bill_amt_paid = Decimal.Parse(dt.Rows[0]["bill_amt_paid"].ToString());
                bRec.Bill_ap = Int32.Parse((dt.Rows[0]["bill_ap"].ToString()));
                bRec.Bill_date = DateTime.Parse(dt.Rows[0]["bill_date"].ToString()).ToShortDateString();
                bRec.Bill_due_date = DateTime.Parse(dt.Rows[0]["bill_due_date"].ToString()).ToShortDateString();
                bRec.Bill_expense_acct = Int32.Parse((dt.Rows[0]["bill_expense_acct"].ToString()));
                bRec.Bill_number = Int32.Parse((dt.Rows[0]["bill_number"].ToString()));
                bRec.Bill_status = dt.Rows[0]["bill_status"].ToString();
                bRec.Bill_type = dt.Rows[0]["bill_type"].ToString();
                bRec.Is_org_merged = dt.Rows[0]["is_org_merged"].ToString();
                bRec.Pmt_method = dt.Rows[0]["pmt_method"].ToString();
                bRec.Print_id = Int32.Parse((dt.Rows[0]["print_id"].ToString()));
                bRec.Ref_no = dt.Rows[0]["ref_no"].ToString();
                bRec.Vendor_name = dt.Rows[0]["vendor_name"].ToString();
                bRec.Vendor_number = Int32.Parse((dt.Rows[0]["vendor_number"].ToString()));
                bRec.BillDetailList = bdMgr.getBillDetailList(bRec.Bill_number);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        return bRec;
    }
    
    

    public DataTable getNotYetPaidBillListDt(int vendor_number)
    {
        SQL = "select *, '' as tran_id, ''as memo,'false' as is_checked, '' as bill_amt_clear, '' as invoices,'../enter_bill.aspx?view=yes&bill_number='+convert( NVARCHAR(10),bill_number) as url from bill where  bill_amt_paid <=  case when bill_amt > 0  then (bill_amt ) else  -bill_amt end  and bill_amt_due <> 0 and elt_account_number = " + elt_account_number + " and vendor_number=" + vendor_number;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        BillRecord bRec = new BillRecord();
        GeneralUtility gUtil = new GeneralUtility();
        try
        {
            ad.Fill(dt);
            gUtil.removeNull(ref dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return dt;
    }


    public DataTable getBillListDt(int print_id)
    {
        SQL = "select *, '' as tran_id, ''as memo,'false' as is_checked, '' as bill_amt_clear, '' as invoices,'../enter_bill.aspx?view=yes&bill_number='+convert( NVARCHAR(10),bill_number) as url from bill where bill_amt_due <> 0 and elt_account_number = " + elt_account_number + " and print_id=" + print_id;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        BillRecord bRec = new BillRecord();
        GeneralUtility gUtil = new GeneralUtility();
        try
        {
            ad.Fill(dt);
            gUtil.removeNull(ref dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return dt;
    }

   
    private void setTranNoForAllAccountsJournalEntries(ArrayList aajlist,int bill_number){
        if (aajlist != null)
        {
            for (int i = 0; i < aajlist.Count; i++)
            {
                ((AllAccountsJournalRecord)aajlist[i]).tran_num = bill_number;
            }
        }
    }

    public bool insertBillRecord(ref BillRecord bRec,string tran_type)
    {
        bRec.replaceQuote();
        bool return_val = false;
        int bill_number = getNewbillNumber();
        bRec.Bill_number = bill_number;

        int next_item_id =bdMgr.getNextItemIDForBill(bill_number);

        if (bRec.All_accounts_journal_list != null)
        {
            setTranNoForAllAccountsJournalEntries(bRec.All_accounts_journal_list, bill_number);
        }

        for (int i = 0; i < bRec.BillDetailList.Count; i++)
        {
            ((BillDetailRecord)bRec.BillDetailList[i]).bill_number = bill_number;
        }
        ArrayList bdList = bRec.BillDetailList;

        ArrayList AAJEntryList = bRec.All_accounts_journal_list;
        if (bRec.All_accounts_journal_list != null)
        {
            for (int i = 0; i < AAJEntryList.Count; i++)
            {
                AAJMgr.checkInitial_Acct_Record((AllAccountsJournalRecord)AAJEntryList[i]);
            }
        }
        int next_tran_seq_no = AAJMgr.getNextTranSeqNumber();

        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;

        try
        {
            //Keept the ID from OPERATION/UPDATE BILL DETAILS SINCE BILL_DETAIL CAN BE ALREAY EXISTING/ generated From MB/
            for (int i = 0; i < bdList.Count; i++)
            {
                BillDetailRecord bDRec = (BillDetailRecord)bdList[i];
                bDRec.bill_number = bill_number;

                if (bDRec.item_id != -1 && bDRec.item_id != 0)
                {
                    SQL = "UPDATE [bill_detail] ";
                    SQL += "set elt_account_number= '" + elt_account_number + "',";
                    SQL += "item_ap= '" + bDRec.item_ap + "',";
                    SQL += "item_id= '" + bDRec.item_id + "',";
                    SQL += "item_no= '" + bDRec.item_no + "',";
                    SQL += "item_amt= '" + bDRec.item_amt + "',";
                    SQL += "is_manual= '" + bDRec.is_manual + "',";
                    SQL += "item_expense_acct= '" + bDRec.item_expense_acct + "',";
                    SQL += "tran_date= '" + bDRec.tran_date + "',";
                    //--------------here is where update can be effective for the bill_detail at AP Queue
                    if (bDRec.Is_checked)
                    {
                        SQL += "bill_number= '" + bDRec.bill_number + "',";

                    }
                    else
                    {
                        SQL += "bill_number= 0,";
                        bDRec.bill_number = 0;
                    }
                    //--------------
                    SQL += "invoice_no= '" + bDRec.invoice_no + "',";
                    SQL += "agent_debit_no= '" + bDRec.agent_debit_no + "',";
                    SQL += "mb_no= '" + bDRec.mb_no + "',";
                    SQL += "ref= '" + bDRec.ref_no + "',";
                    SQL += "iType= '" + bDRec.iType + "',";
                    SQL += "vendor_number= '" + bDRec.vendor_number + "'";
                    SQL += "WHERE elt_account_number = " + elt_account_number;
                    SQL += " AND invoice_no = " + bDRec.invoice_no;
                    SQL += " AND item_id=" + bDRec.item_id;
                   
                    Cmd.CommandText = SQL;
                    Cmd.ExecuteNonQuery();
                }
                else
                {
                    bDRec.item_id = next_item_id++;
                    SQL = "INSERT INTO [bill_detail] ";
                    SQL += "( elt_account_number, ";
                    SQL += "item_ap,";
                    SQL += "item_id,";
                    SQL += "item_no,";
                    SQL += "item_amt,";
                    SQL += "is_manual,";
                    SQL += "item_expense_acct,";
                    SQL += "tran_date,";
                    SQL += "bill_number,";
                    SQL += "invoice_no,";
                    SQL += "agent_debit_no,";
                    SQL += "mb_no,";
                    SQL += "ref,";
                    SQL += "iType,";
                    SQL += "vendor_number)";
                    SQL += "VALUES";
                    SQL += "('" + elt_account_number;
                    SQL += "','" + bDRec.item_ap;
                    SQL += "','" + bDRec.item_id;
                    SQL += "','" + bDRec.item_no;
                    SQL += "','" + bDRec.item_amt;
                    SQL += "','" + bDRec.is_manual;
                    SQL += "','" + bDRec.item_expense_acct;
                    SQL += "','" + bDRec.tran_date;
                    SQL += "','" + bDRec.bill_number;
                    SQL += "','" + bDRec.invoice_no;
                    SQL += "','" + bDRec.agent_debit_no;
                    SQL += "','" + bDRec.mb_no;
                    SQL += "','" + bDRec.ref_no;
                    SQL += "','" + bDRec.iType;
                    SQL += "','" + bDRec.vendor_number;
                    SQL += "')";

                    Cmd.CommandText = SQL;
                    Cmd.ExecuteNonQuery();
                }
            }
            if (bRec.All_accounts_journal_list != null)
            {
                for (int i = 0; i < AAJEntryList.Count; i++)
                {
                    ((AllAccountsJournalRecord)AAJEntryList[i]).replaceQuote();
                    ((AllAccountsJournalRecord)AAJEntryList[i]).tran_num = bill_number;

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


            SQL = "INSERT INTO [bill] ";
            SQL += "(elt_account_number,";
            SQL += "bill_number,";
            SQL += "bill_type,";
            SQL += "vendor_number,";
            SQL += "vendor_name,";
            SQL += "bill_date,";
            SQL += "bill_due_date,";
            SQL += "bill_amt,";
            SQL += "bill_amt_paid,";
            SQL += "bill_amt_due,";
            SQL += "ref_no,";
            SQL += "bill_expense_acct,";
            SQL += "bill_ap,";
            SQL += "bill_status,";
            SQL += "print_id,";
            SQL += "lock,";
            SQL += "pmt_method,";
            SQL += "is_org_merged)";
            SQL += "VALUES";
            SQL += "('" + elt_account_number;
            SQL += "','" + bRec.Bill_number;
            SQL += "','" + bRec.Bill_type;
            SQL += "','" + bRec.Vendor_number;
            SQL += "','" + bRec.Vendor_name;
            SQL += "','" + bRec.Bill_date;
            SQL += "','" + bRec.Bill_due_date;
            SQL += "','" + bRec.Bill_amt;
            SQL += "','" + bRec.Bill_amt_paid;
            SQL += "','" + bRec.Bill_amt_due;
            SQL += "','" + bRec.Ref_no;
            SQL += "','" + bRec.Bill_expense_acct;
            SQL += "','" + bRec.Bill_ap;
            SQL += "','" + bRec.Bill_status;
            SQL += "','" + bRec.Print_id;
            SQL += "','" + bRec.Lock;
            SQL += "','" + bRec.Pmt_method;
            SQL += "','" + bRec.Is_org_merged;
            SQL += "')";

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();


            SQL = "Delete  FROM bill_detail WHERE elt_account_number = "
               + elt_account_number + " AND bill_number = " + bill_number + " AND item_amt = " + 0;
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
        MBCostItemsManager MBCostItemMgr = new MBCostItemsManager(elt_account_number);
        IVCostItemsManager IVCostItemMgr = new IVCostItemsManager(elt_account_number);
        int invoice_no = 0;
        string mb_no="";
        int item_id=0;
        for (int i = 0; i < bdList.Count; i++)
        {
            if (((BillDetailRecord)bdList[i]).bill_number == 0)
            {
                if(((BillDetailRecord)bdList[i]).mb_no!="")
                {
                    mb_no=((BillDetailRecord)bdList[i]).mb_no;
                    item_id=((BillDetailRecord)bdList[i]).item_id;
                    MBCostItemMgr.resetAPLock(mb_no, item_id, "N");
                }                
                if(((BillDetailRecord)bdList[i]).invoice_no!=0)
                {
                    invoice_no = ((BillDetailRecord)bdList[i]).invoice_no;
                    item_id = ((BillDetailRecord)bdList[i]).item_id;
                    IVCostItemMgr.resetAPLock(invoice_no, item_id, "N");
                }

            }
            else
            {

                if (((BillDetailRecord)bdList[i]).mb_no != "")
                {
                    mb_no = ((BillDetailRecord)bdList[i]).mb_no;
                    item_id = ((BillDetailRecord)bdList[i]).item_id;
                    MBCostItemMgr.resetAPLock(mb_no, item_id, "Y");

                }
                if (((BillDetailRecord)bdList[i]).invoice_no != 0)
                {
                    invoice_no = ((BillDetailRecord)bdList[i]).invoice_no;
                    item_id = ((BillDetailRecord)bdList[i]).item_id;
                    IVCostItemMgr.resetAPLock(invoice_no, item_id, "Y");
                }

            }
        }

        return return_val;
    }


    public bool deleteBillRecord(int bill_number,string tran_type)
    {
        bool return_val = false;
        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;

        try
        {
            //reset all the bill detail that has this bill_number to be 0
            SQL = "update  bill_detail set bill_number = 0 WHERE elt_account_number =";
            SQL += elt_account_number + " and bill_number ="
                    + bill_number;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();

            //delete all teh AAJ entries 
            SQL = "Delete  FROM all_accounts_journal WHERE elt_account_number = "
                + elt_account_number + " AND tran_num = " + bill_number + " AND tran_type = '" + tran_type + "'";
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();

            // delete the bill 
            SQL = "delete  from bill where elt_account_number = " + elt_account_number + " and bill_number=" + bill_number;
            return_val = true;
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

    public bool updateBillRecord(ref BillRecord bRec, string tran_type)
    {
        bool return_val = false;
        int bill_number = bRec.Bill_number;
        int next_item_id = bdMgr.getNextItemIDForBill(bill_number);
      

        setTranNoForAllAccountsJournalEntries(bRec.All_accounts_journal_list, bill_number);
        //UPDATE BILL DETAILS 
        ArrayList bdList = bRec.BillDetailList;
        ArrayList AAJEntryList = bRec.All_accounts_journal_list;
        Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;
        string delete_list_condition = "";
        try
        {
            for (int i = 0; i < bdList.Count; i++)
            {
                BillDetailRecord bDRec = (BillDetailRecord)bdList[i];
                bDRec.bill_number = bill_number;

                if (bDRec.item_id != -1 && bDRec.item_id != 0)
                {
                    SQL = "UPDATE [bill_detail] ";
                    SQL += "set elt_account_number= '" + elt_account_number + "',";
                    SQL += "item_ap= '" + bDRec.item_ap + "',";
                    SQL += "item_id= '" + bDRec.item_id + "',";
                    SQL += "item_no= '" + bDRec.item_no + "',";
                    SQL += "item_amt= '" + bDRec.item_amt + "',";
                    SQL += "is_manual= '" + bDRec.is_manual + "',";
                    SQL += "item_expense_acct= '" + bDRec.item_expense_acct + "',";
                    SQL += "tran_date= '" + bDRec.tran_date + "',";
                    //--------------here is where update can be effective for the bill_detail at AP Queue
                    if (bDRec.Is_checked)
                    {
                        SQL += "bill_number= '" + bDRec.bill_number + "',";

                    }
                    else
                    {
                        SQL += "bill_number= 0,";
                    }
                    //--------------
                    SQL += "invoice_no= '" + bDRec.invoice_no + "',";
                    SQL += "agent_debit_no= '" + bDRec.agent_debit_no + "',";
                    SQL += "mb_no= '" + bDRec.mb_no + "',";
                    SQL += "ref= '" + bDRec.ref_no + "',";
                    SQL += "iType= '" + bDRec.iType + "',";
                    SQL += "vendor_number= '" + bDRec.vendor_number + "'";
                    SQL += "WHERE elt_account_number = " + elt_account_number;
                    SQL += " AND invoice_no = " + bDRec.invoice_no;
                    SQL += " AND bill_number = " + bDRec.bill_number;
                    SQL += " AND item_id=" + bDRec.item_id;

                    Cmd.CommandText = SQL;
                    Cmd.ExecuteNonQuery();
                }
                else
                {
                    bDRec.item_id = next_item_id++;
                    SQL = "INSERT INTO [bill_detail] ";
                    SQL += "( elt_account_number, ";
                    SQL += "item_ap,";
                    SQL += "item_id,";
                    SQL += "item_no,";
                    SQL += "item_amt,";
                    SQL += "is_manual,";
                    SQL += "item_expense_acct,";
                    SQL += "tran_date,";
                    SQL += "bill_number,";
                    SQL += "invoice_no,";
                    SQL += "agent_debit_no,";
                    SQL += "mb_no,";
                    SQL += "ref,";
                    SQL += "iType,";
                    SQL += "vendor_number)";
                    SQL += "VALUES";
                    SQL += "('" + elt_account_number;
                    SQL += "','" + bDRec.item_ap;
                    SQL += "','" + bDRec.item_id;
                    SQL += "','" + bDRec.item_no;
                    SQL += "','" + bDRec.item_amt;
                    SQL += "','" + bDRec.is_manual;
                    SQL += "','" + bDRec.item_expense_acct;
                    SQL += "','" + bDRec.tran_date;
                    SQL += "','" + bDRec.bill_number;
                    SQL += "','" + bDRec.invoice_no;
                    SQL += "','" + bDRec.agent_debit_no;
                    SQL += "','" + bDRec.mb_no;
                    SQL += "','" + bDRec.ref_no;
                    SQL += "','" + bDRec.iType;
                    SQL += "','" + bDRec.vendor_number;
                    SQL += "')";

                    Cmd.CommandText = SQL;
                    Cmd.ExecuteNonQuery();
                }

                delete_list_condition += " and item_id<>" + bDRec.item_id + " ";
            }

             /**************************************
             * delete unselected bill detail
             * **************************************/
            SQL = "Delete  FROM bill_detail WHERE elt_account_number = "
               + elt_account_number + " AND bill_number = " + bill_number + delete_list_condition;
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();

            //UPDATE AAJ ENTRIES 
            //1) DELETE PREVIOUS 
            SQL = "Delete  FROM all_accounts_journal WHERE elt_account_number = "
                + elt_account_number + " AND tran_num = " + bill_number + " AND tran_type = '" + tran_type + "'";
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();

            int next_tran_seq_no = 0;

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

            next_tran_seq_no= current + 1;

            //2) INSERT NEW 
            if (AAJEntryList != null)
            {
                for (int i = 0; i < AAJEntryList.Count; i++)
                {
                    ((AllAccountsJournalRecord)AAJEntryList[i]).replaceQuote();
                    ((AllAccountsJournalRecord)AAJEntryList[i]).tran_num = bill_number;

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
            //UPDATE THE BILL
            SQL = "update [bill] set ";
            SQL += "elt_account_number='" + elt_account_number + "',";
            SQL += "bill_number='" + bRec.Bill_number + "',";
            SQL += "bill_type='" + bRec.Bill_type + "',";
            SQL += "vendor_number='" + bRec.Vendor_number + "',";
            SQL += "vendor_name='" + bRec.Vendor_name + "',";
            SQL += "bill_date='" + bRec.Bill_date + "',";
            SQL += "bill_due_date='" + bRec.Bill_due_date + "',";
            SQL += "bill_amt='" + bRec.Bill_amt + "',";
            SQL += "bill_amt_paid='" + bRec.Bill_amt_paid + "',";
            SQL += "bill_amt_due='" + bRec.Bill_amt_due + "',";
            SQL += "ref_no='" + bRec.Ref_no + "',";
            SQL += "bill_expense_acct='" + bRec.Bill_expense_acct + "',";
            SQL += "bill_ap='" + bRec.Bill_ap + "',";
            SQL += "bill_status='" + bRec.Bill_status + "',";
            SQL += "print_id='" + bRec.Print_id + "',";
            SQL += "lock='" + bRec.Lock + "',";
            SQL += "pmt_method='" + bRec.Pmt_method + "',";
            SQL += "is_org_merged='" + bRec.Is_org_merged + "'";
            SQL += " where elt_account_number='" + elt_account_number + "' and bill_number=" + bRec.Bill_number;
           
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


    public bool checkIfExistBill(int  bill_number)
    {
        SQL = "select count(bill_number) from bill where elt_account_number = " + elt_account_number + " and bill_number=" + bill_number;
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
        if (rowCount >= 1)
        {
            return true;
        }
        else
        {
            return false;
        }
    }



}
