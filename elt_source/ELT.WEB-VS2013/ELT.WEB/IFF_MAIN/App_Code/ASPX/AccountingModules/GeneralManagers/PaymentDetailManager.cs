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
/// Summary description for customerPaymentDetailManager
/// </summary>
public class PaymentDetailManager:Manager
{
    public PaymentDetailManager(string elt_acct)
        : base(elt_acct)
	{
      
	}

   public DataTable getPaymentDetailListDt(int payment_no)
    {
        SQL = "select * from customer_payment_detail where elt_account_number = " + elt_account_number + " and payment_no=" + payment_no;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        PaymentDetailRecord pdRec = new PaymentDetailRecord();
        GeneralUtility gUtil=new GeneralUtility();
        try
        {
            ad.Fill(dt);
            gUtil.removeNull(ref dt);
        }
        catch(Exception ex)
        {
            throw ex;
        }
        return dt;
    }
   

    public ArrayList getPaymentDetailList(int payment_no)
    {
        SQL = "select * from customer_payment_detail where elt_account_number = " + elt_account_number + " and payment_no=" + payment_no;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);

        GeneralUtility gUtil = new GeneralUtility();
        ArrayList resultList = new ArrayList();
        try
        {
            ad.Fill(dt);
            gUtil.removeNull(ref dt);
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                PaymentDetailRecord pdRec = new PaymentDetailRecord();
                pdRec.amt_due = Decimal.Parse(dt.Rows[0]["amt_due"].ToString());
                pdRec.invoice_date = dt.Rows[0]["invoice_date"].ToString();
                pdRec.invoice_no = Int32.Parse((dt.Rows[0]["invoice_no"].ToString()));
                pdRec.item_id = Int32.Parse(dt.Rows[0]["item_id"].ToString());
                pdRec.orig_amt = Decimal.Parse(dt.Rows[0]["orig_amt"].ToString());
                pdRec.payment = Decimal.Parse(dt.Rows[0]["payment"].ToString());
                pdRec.payment_no = Int32.Parse((dt.Rows[0]["payment_no"].ToString()));
                pdRec.type = dt.Rows[0]["type"].ToString();
                resultList.Add(pdRec);
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        return resultList;
    }

    public Decimal getcustomerPaymentDetailSumForInvoice(int invoice_no)
    {
        Decimal total_pay = 0;
        SQL = "select isnull(sum(isnull(payment,0)),0) as totalpay from customer_payment_detail where elt_account_number = " +elt_account_number +
            " and invoice_no=" + invoice_no + " group by elt_account_number,invoice_no";
        try
        {
            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            if (cmd.ExecuteNonQuery() == 1)
            {
                total_pay = Decimal.Parse(cmd.ExecuteScalar().ToString());
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
        return total_pay;
    }

    public bool checkIfExistPaymentDetail(PaymentDetailRecord pdRec)
    {
        try
        {
            SQL = "select item_id from customer_payment_detail where elt_account_number = "
              + elt_account_number + " and payment_no="
              + pdRec.payment_no + " and item_id="
              + pdRec.item_id;

            SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
            DataTable dt = new DataTable();
            adp.Fill(dt);
            if (dt.Rows.Count >= 1)
            {
                return true;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return false;
    }

    //public bool updatePaymentDetails(ArrayList pdList, int payment_no)
    //{
    //    bool return_val = false;
    //    ArrayList previous = getPaymentDetailList(payment_no);
    //    try
    //    {
    //        if (deletePaymentDetailList(payment_no))
    //        {
    //            if (deletePaymentDetailList(payment_no))
    //            {
    //                return_val = insertPaymentDetailList(pdList, payment_no);
    //            }
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        rollback_Entries_with_payment_no(previous, payment_no);
    //        return_val = false;
    //    }
    //    return return_val;
    //}

    //public void rollback_Entries_with_payment_no(ArrayList previous, int payment_no)
    //{
    //    try
    //    {
    //        deletePaymentDetailList(payment_no);
    //        insertPaymentDetailList(previous, payment_no);
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //}

    //public bool insertPaymentDetailList(ArrayList pdList, int payment_no)
    //{
    //    for (int i = 0; i < pdList.Count; i++)
    //    {
    //        PaymentDetailRecord pdRec = (PaymentDetailRecord)pdList[i];
    //        pdRec.payment_no = payment_no;
    //        try
    //        {
    //            if (!checkIfExistPaymentDetail(pdRec))
    //            {
    //                SQL = "INSERT INTO [customer_payment_detail] ";
    //                SQL += "( EmailItemID, ";
    //                SQL += "amt_due,";
    //                SQL += "item_id,";
    //                SQL += "invoice_date,";
    //                SQL += "invoice_no,";
    //                SQL += "orig_amt,";
    //                SQL += "payment,";
    //                SQL += "type,";
    //                SQL += "payment_no)";
    //                SQL += "VALUES";
    //                SQL += "('" + EmailItemID;
    //                SQL += "','" + pdRec.amt_due;
    //                SQL += "','" + i;
    //                SQL += "','" + pdRec.invoice_date;
    //                SQL += "','" + pdRec.invoice_no;
    //                SQL += "','" + pdRec.orig_amt;
    //                SQL += "','" + pdRec.payment;
    //                SQL += "','" + pdRec.type;
    //                SQL += "','" + pdRec.payment_no;
    //                SQL += "')";
    //                Cmd = new SqlCommand(SQL, Con);
    //                Con.Open();
    //                Cmd.ExecuteNonQuery();                   
    //            }
    //            else
    //            {
    //                return false;
    //            }
    //        }
    //        catch (Exception ex)
    //        {
              
    //            return false;
    //        }
    //        finally
    //        {
    //            Con.Close();
    //        }
    //    }
    //    return true;
    //}

    //public bool deletePaymentDetailList(int payment_no)
    //{
    //    int count = 0;
    //    SQL = "DELETE FROM customer_payment_detail WHERE EmailItemID =";
    //    SQL += EmailItemID + " and payment_no="
    //            + payment_no;
    //    Cmd = new SqlCommand(SQL, Con);
    //    try
    //    {
    //        Con.Open();
    //        count = Cmd.ExecuteNonQuery();            
    //        return true;
    //    }
    //    catch (Exception ex)
    //    {
    //        return false;
    //    }
    //    finally
    //    {
    //        Con.Close();
    //    }
    //    return false;
    //}

}