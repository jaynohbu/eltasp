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
/// Summary description for CheckDetailManager
/// </summary>
public class CheckDetailManager:Manager
{       
       
    public CheckDetailManager(string elt_acct): base(elt_acct)
	{       
        
	}
    
    public ArrayList getcheckDetailForInvoice(int invoice_no)
    {
        SQL = "select '../enter_bill.aspx?view=yes&bill_number='+convert( NVARCHAR(10),bill_number) as url,  print_id, tran_id, bill_number, due_date,  bill_amt, amt_due, amt_paid, memo, pmt_method, check_no, isnull(invoice_no,'0') as invoice_no from check_detail where elt_account_number = " + elt_account_number + " and invoice_no=" + invoice_no;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        CheckDetailRecord cDRec = new CheckDetailRecord();
        GeneralUtility gUtil = new GeneralUtility();
        ArrayList list = new ArrayList();
        try
        {            
            gUtil.removeNull(ref dt);            
            cDRec.amt_due=Decimal.Parse(dt.Rows[0]["amt_due"].ToString());
            cDRec.amt_paid=Decimal.Parse(dt.Rows[0]["amt_paid"].ToString());
            cDRec.bill_amt=Decimal.Parse(dt.Rows[0]["bill_amt"].ToString());
            cDRec.bill_number=Int32.Parse((dt.Rows[0]["bill_number"].ToString()));
            cDRec.due_date=DateTime.Parse(dt.Rows[0]["due_date"].ToString()).ToShortDateString();
            if (dt.Rows[0]["invoice_no"].ToString() == "")
            {
                dt.Rows[0]["invoice_no"] = "0";
            }
            cDRec.invoice_no=Int32.Parse(dt.Rows[0]["invoice_no"].ToString());
            cDRec.memo=dt.Rows[0]["memo"].ToString();
            cDRec.pmt_method=dt.Rows[0]["pmt_method"].ToString();
            cDRec.print_id=Int32.Parse((dt.Rows[0]["print_id"].ToString()));
            cDRec.tran_id=Int32.Parse((dt.Rows[0]["tran_id"].ToString()));
            list.Add(cDRec);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return list;
    }

    public ArrayList getcheckDetailListForPrintId(int print_id)
    {
        ArrayList list = new ArrayList();
        SQL = "select '../enter_bill.aspx?view=yes&bill_number='+convert( NVARCHAR(10),bill_number) as url,   print_id, tran_id, bill_number, due_date,  bill_amt, amt_due, amt_paid, memo, pmt_method,  isnull(invoice_no,'0') as invoice_no from check_detail where elt_account_number = " + elt_account_number + " and print_id=" + print_id;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        
        GeneralUtility gUtil = new GeneralUtility();
        ad.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                CheckDetailRecord cDRec = new CheckDetailRecord();
                try
                {

                    gUtil.removeNull(ref dt);
                    cDRec.amt_due = Decimal.Parse(dt.Rows[i]["amt_due"].ToString());
                    cDRec.amt_paid = Decimal.Parse(dt.Rows[i]["amt_paid"].ToString());
                    cDRec.bill_amt = Decimal.Parse(dt.Rows[i]["bill_amt"].ToString());
                    cDRec.bill_number = Int32.Parse((dt.Rows[i]["bill_number"].ToString()));
                    cDRec.due_date = DateTime.Parse(dt.Rows[i]["due_date"].ToString()).ToShortDateString();
                    if (dt.Rows[i]["invoice_no"].ToString() == "")
                    {
                        dt.Rows[i]["invoice_no"] = "0";
                    }
                    cDRec.invoice_no = Int32.Parse(dt.Rows[i]["invoice_no"].ToString());
                    cDRec.memo = dt.Rows[i]["memo"].ToString();
                    cDRec.pmt_method = dt.Rows[i]["pmt_method"].ToString();
                    cDRec.print_id = Int32.Parse((dt.Rows[i]["print_id"].ToString()));
                    cDRec.tran_id = Int32.Parse((dt.Rows[i]["tran_id"].ToString()));
                    list.Add(cDRec);
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }              
            
        }
       
        return list;
    }

    public DataTable getcheckDetailForPrintIdDt(int print_id)
    {
        SQL = "select '../enter_bill.aspx?view=yes&bill_number='+convert( NVARCHAR(10),bill_number) as url,   print_id, tran_id, bill_number, due_date,  bill_amt, amt_due, amt_paid, memo, pmt_method,  isnull(invoice_no,'0') as invoice_no from check_detail where elt_account_number = " + elt_account_number + " and print_id=" + print_id;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        CheckDetailRecord cDRec = new CheckDetailRecord();
        GeneralUtility gUtil = new GeneralUtility();
        ad.Fill(dt);
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[0]["invoice_no"].ToString() == "")
            {
                dt.Rows[0]["invoice_no"] = "0";
            }
        }
        return dt;
    }

    public bool deleteCheckDetailList( int printID)
    {
        bool return_val = false;
        try
        {
            SQL = "delete from check_detail where elt_account_number = " + elt_account_number + " and print_id=" + printID;
            Cmd = new SqlCommand(SQL, Con);
            Con.Open();
            Cmd.ExecuteNonQuery();
            return_val = true;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            Con.Close();
        }

        return return_val;
    }



    public bool insertCheckDetailList(ArrayList chkList,int printID)
    {
        bool return_val = false;
        for (int i = 0; i < chkList.Count; i++)
        {
            try
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
                Cmd = new SqlCommand(SQL, Con);
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
            return_val = true;
        } 
        return return_val;
    }
    public bool checkExistCheckDetail(CheckDetailRecord cdRec, ref SqlCommand Cmd)
    {
        SQL = "select tran_id from check_detail where elt_account_number =";
        SQL += elt_account_number + " and tran_id="
            + cdRec.tran_id + " and print_id="
            + cdRec.print_id;
        Cmd.CommandText = SQL;
        int rowCount = 0;

        try
        {
            rowCount = Cmd.ExecuteNonQuery();            
        }
        catch (Exception ex)
        {  
            throw ex;
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

    public bool checkIfPaymentReceivedForBill(string bill_number, ref ArrayList print_id)
    {
        bool return_val = false;
        SQL = "select print_id from check_detail where elt_account_number =";
        SQL += elt_account_number + " and bill_number="
            + bill_number;

        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        CheckDetailRecord cDRec = new CheckDetailRecord();
        GeneralUtility gUtil = new GeneralUtility();
        ad.Fill(dt);
      
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            try
            {
                print_id.Add(Int32.Parse(dt.Rows[i][""].ToString()));
                return_val = true;               
            }
            catch (Exception ex)
            {
                throw ex;
            }           
        }
        return return_val;   
    }
}













