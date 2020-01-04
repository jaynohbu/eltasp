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
/// Summary description for BilldetailManager
/// </summary>
public class BillDetailManager:Manager
{

    public BillDetailManager(string elt_acct)
        : base(elt_acct)
    {
           
    }
     public DataTable getBillDetailsDtForInvoice(int invoice_no)
     {
         SQL = "select *, 'false' as is_checked, ref as ref_no, '../edit_invoi.aspx?edit=yes&invoice_no='+CONVERT(NVARCHAR,invoice_no) as url from bill_detail where elt_account_number = " + elt_account_number + " and invoice_no=" + invoice_no + " order by item_id";
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        BillDetailRecord bDRec = new BillDetailRecord();
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

    
    public DataTable getUnbilledListForVendor(int vendor_no)
    {
        DataTable dt = new DataTable();
        SQL = "select *, 'false' as is_checked, ref as ref_no,case when isnull(invoice_no,0)<>0 then CONVERT(NVARCHAR,invoice_no)  else mb_no  end as ref_link, case when isnull(invoice_no,0) <> 0 ";
        SQL += "then '../edit_invoi.aspx?edit=yes&invoice_no='+CONVERT(NVARCHAR,invoice_no)";
        SQL += " when iType='A' and import_export='I' then '../../../ASP/air_import/air_import2.asp?iType=A&Edit=yes&MAWB='+CONVERT(NVARCHAR,mb_no)";
        SQL += " when iType='O' and import_export='I' then  '../../../ASP/ocean_import/ocean_import2.asp?iType=O&Edit=yes&MBOL='+CONVERT(NVARCHAR,mb_no)";
        SQL += " when iType='A' and import_export='E' then  '../../../ASP/air_export/new_edit_mawb.asp?iType=O&Edit=yes&MAWB='+CONVERT(NVARCHAR,mb_no)";
        SQL += " when iType='O' and import_export='E' then  '../../../ASP/ocean_export/new_edit_mbol.asp?iType=O&Edit=yes&BookingNum='+CONVERT(NVARCHAR,mb_no)end as url";
        SQL += " from bill_detail where isnull(bill_number,0)=0 and  elt_account_number =" + elt_account_number + " and vendor_number=" + vendor_no+" order by item_id";

        
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        BillDetailRecord bDRec = new BillDetailRecord();
        GeneralUtility gUtil = new GeneralUtility();
        try
        {
            ad.Fill(dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return dt;
    }

    public void clearUnbilled(BillDetailRecord bDRec)
    {
        SQL = "delete  from bill_detail where elt_account_number = "
          + elt_account_number + " and isnull(bill_number,0)="
          + 0 + " and invoice_no=" + bDRec.invoice_no + " and item_id=" + bDRec.item_id;

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

    public bool checkIfExistBillDetail(BillDetailRecord bDRec)
    {
        try
        {
            SQL = "select item_id from bill_detail where elt_account_number = "
              + elt_account_number + " and bill_number="
              + bDRec.bill_number + " and item_id="
              + bDRec.item_id;

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

    public bool checkIfAPposted(int invoice_no, int item_no, int item_id, Decimal amount,ref int bill_number)
    {
        try
        {
            SQL = "select item_id, bill_number from bill_detail where isnull(bill_number,0)<> 0 and elt_account_number = "
              + elt_account_number + " and invoice_no="
              + invoice_no + " and item_id="
              + item_id + "  and item_amt=" + amount + " and item_no=" + item_no;

            SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
            DataTable dt = new DataTable();
            adp.Fill(dt);
            if (dt.Rows.Count >= 1)
            {
                bill_number=Int32.Parse(dt.Rows[0]["bill_number"].ToString());
                return true;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return false;
    }

    public ArrayList getBillDetailListForInvoice(int invoice_no)
    {
        SQL = "select * from bill_detail where elt_account_number = " + elt_account_number + " and invoice_no=" + invoice_no;
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
                BillDetailRecord bDRec = new BillDetailRecord();
                bDRec.item_ap = Int32.Parse(dt.Rows[i]["item_ap"].ToString());
                bDRec.item_id = Int32.Parse(dt.Rows[i]["item_id"].ToString());
                bDRec.item_no = Int32.Parse(dt.Rows[i]["item_no"].ToString());
                bDRec.item_amt = Decimal.Parse(dt.Rows[i]["item_amt"].ToString());
                bDRec.item_expense_acct = Int32.Parse(dt.Rows[i]["item_expense_acct"].ToString());
                bDRec.ref_no = dt.Rows[i]["ref"].ToString();
                bDRec.tran_date = dt.Rows[i]["tran_date"].ToString();
                bDRec.invoice_no = Int32.Parse(dt.Rows[i]["invoice_no"].ToString());
                bDRec.agent_debit_no = dt.Rows[i]["agent_debit_no"].ToString();
                bDRec.mb_no = dt.Rows[i]["mb_no"].ToString();
                bDRec.hb_no = dt.Rows[i]["hb_no"].ToString();
                bDRec.ref_no = dt.Rows[i]["ref"].ToString();
                bDRec.iType = dt.Rows[i]["iType"].ToString();           
                bDRec.vendor_number = Int32.Parse(dt.Rows[i]["vendor_number"].ToString());
                resultList.Add(bDRec);
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        return resultList;
    }

    public DataTable getBillDetailsDt(int bill_number)
    {
        SQL = "select *, 'true' as is_checked, ref as ref_no,case when isnull(invoice_no,0)<>0 then CONVERT(NVARCHAR,invoice_no) else mb_no  end as ref_link, case when isnull(invoice_no,0) <> 0 ";
        SQL += "then '../edit_invoi.aspx?edit=yes&invoice_no='+CONVERT(NVARCHAR,invoice_no)";
        SQL += "else case when iType='A' then '../../../ASP/air_import/air_import2.asp?iType=A&Edit=yes&MAWB='+mb_no else '../../../ASP/ocean_import/ocean_import2.asp?iType=O&Edit=yes&MBOL='+mb_no end  end as url";
        SQL += " from bill_detail where elt_account_number =" + elt_account_number + " and bill_number=" + bill_number + " order by item_id";
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        BillDetailRecord bDRec = new BillDetailRecord();
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


    public ArrayList getBillDetailList(int bill_number)
    {
        SQL = "select *,'true' as is_checked from bill_detail where elt_account_number = " + elt_account_number + " and bill_number=" + bill_number + " order by item_id";
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
                BillDetailRecord bDRec = new BillDetailRecord();
                bDRec.item_ap = Int32.Parse(dt.Rows[i]["item_ap"].ToString());
                bDRec.item_id = Int32.Parse(dt.Rows[i]["item_id"].ToString());
                bDRec.item_no = Int32.Parse(dt.Rows[i]["item_no"].ToString());
                bDRec.item_amt = Decimal.Parse(dt.Rows[i]["item_amt"].ToString());
                bDRec.item_expense_acct = Int32.Parse(dt.Rows[i]["item_expense_acct"].ToString());
                bDRec.ref_no = dt.Rows[i]["ref"].ToString();
                bDRec.tran_date = dt.Rows[i]["tran_date"].ToString();
                bDRec.invoice_no = Int32.Parse(dt.Rows[i]["invoice_no"].ToString());
                bDRec.bill_number = bill_number;
                bDRec.agent_debit_no = dt.Rows[i]["agent_debit_no"].ToString();
                bDRec.mb_no = dt.Rows[i]["mb_no"].ToString();
                bDRec.hb_no = dt.Rows[i]["hb_no"].ToString();
                bDRec.ref_no = dt.Rows[i]["ref"].ToString();
                bDRec.iType = dt.Rows[i]["iType"].ToString();
                bDRec.vendor_number = Int32.Parse(dt.Rows[i]["vendor_number"].ToString());
               
                resultList.Add(bDRec);
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        return resultList;
    }

    
   

    public bool checkExistBillDetailForInvoice(BillDetailRecord bDRec,int invoice_no)
    {
        SQL = "select item_id from bill_detail where elt_account_number =";
        SQL += elt_account_number + " and invoice_no="
            + invoice_no + " and item_id="
            + bDRec.item_id;
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

    public bool deleteBillDetailListForInvoice(int invoice_no)
    {
        bool return_val = false;
        int count = 0;
        SQL = "DELETE FROM bill_detail WHERE elt_account_number =";
        SQL += elt_account_number + " and invoice_no="
                + invoice_no;
        Cmd = new SqlCommand(SQL, Con);
        try
        {
            Con.Open();
            count = Cmd.ExecuteNonQuery();
            return_val= true;
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
    
    public int getNextItemIDForBill(int bill_number)
    {
        int item_id;
        SQL = "select max(item_id) as item_id from bill_detail where elt_account_number =";
        SQL += elt_account_number + " and bill_number ="
        + bill_number;

        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        DataTable dt = new DataTable();
        adp.Fill(dt);


        string item_id_str = dt.Rows[0]["item_id"].ToString();
        if (item_id_str != "")
        {
             item_id = Int32.Parse(item_id_str)+1;
        }
        else
        {
            item_id = 1;
        }
        return item_id;
    }


    public bool checkExistBillDetail(BillDetailRecord bDRec)
    {
        SQL = "select item_id from bill_detail where elt_account_number =";
        SQL += elt_account_number + " and bill_number="
            + bDRec.bill_number + " and item_id="
            + bDRec.item_id;
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

    public bool deleteBillDetailList(int bill_number)
    {
        bool return_val = false;
        int count = 0;
        SQL = "DELETE FROM bill_detail WHERE elt_account_number =";
        SQL += elt_account_number + " and bill_number="
                + bill_number;
        Cmd = new SqlCommand(SQL, Con);
        try
        {
            Con.Open();
            count = Cmd.ExecuteNonQuery();           
            return_val= true;
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

    public bool deleteBillDetailItem(int invoice_no, int item_id)
    {       
        bool return_val = false;
        if (invoice_no != 0)
        {
            int count = 0;
            SQL = "DELETE FROM bill_detail WHERE elt_account_number =";
            SQL += elt_account_number + " and invoice_no="
                    + invoice_no;
            SQL += " and item_id="
                  + item_id;
            Cmd = new SqlCommand(SQL, Con);
            try
            {
                Con.Open();
                count = Cmd.ExecuteNonQuery();
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
        }
        return return_val;
    }

    public bool  resetBillDetailList(int bill_number)
    {
        bool return_val = false;
        SQL = "update  bill_detail set bill_number = 0 WHERE elt_account_number =";
        SQL += elt_account_number + " and bill_number ="
                + bill_number;
        Cmd = new SqlCommand(SQL, Con);
        try
        {
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

   

}






