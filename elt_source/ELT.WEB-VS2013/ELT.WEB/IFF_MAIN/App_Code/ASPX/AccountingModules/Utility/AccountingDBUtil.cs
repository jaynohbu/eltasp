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
/// Summary description for AccountingDBUtil
/// </summary>
public class AccountingDBUtil
{
     protected string ConnectStr;
    protected SqlConnection Con;
    protected SqlCommand Cmd;
    protected string elt_account_number;
    protected string SQL;
    
	public AccountingDBUtil(string elt_acct)
	{
        elt_account_number = elt_acct;
        ConnectStr = (new igFunctions.DB().getConStr());
        Con = new SqlConnection(ConnectStr);
        SQL = "";
	}

    public DataTable getHBOLDataSet()
    {
        SQL = "SELECT isnull(hawb_num,'')as hawb_num, isnull(mawb_num,'') as mawb_num, isnull(invoice_no,0) as invoice_no, elt_account_number FROM invoice WHERE air_ocean='O' and import_export='I' and isnull(hawb_num,'')<>''";

        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
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

    public DataTable getMBOLDataSet()
    {
        SQL = "SELECT isnull(hawb_num,'')as hawb_num, isnull(mawb_num,'') as mawb_num, isnull(invoice_no,0) as invoice_no,elt_account_number FROM invoice WHERE air_ocean='O' and import_export='I' and isnull(mawb_num,'')<>''and isnull(hawb_num,'')=''";

        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        gUtil.removeNull(ref dt);
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

    public DataTable getHAWBDataSet()
    {
        SQL = "SELECT isnull(hawb_num,'')as hawb_num, isnull(mawb_num,'') as mawb_num, isnull(invoice_no,0) as invoice_no, elt_account_number FROM invoice WHERE air_ocean='A' and import_export='I' and isnull(hawb_num,'')<>''";

        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
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
    public DataTable getMAWBDataSet()
    {
        SQL = "SELECT isnull(hawb_num,'')as hawb_num, isnull(mawb_num,'') as mawb_num, isnull(invoice_no,0) as invoice_no, elt_account_number FROM invoice WHERE air_ocean='A' and import_export='I' and isnull(mawb_num,'')<>'' and isnull(hawb_num,'')=''";

        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        gUtil.removeNull(ref dt);
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

    public void reSetOperationWayBillForIVCostItems()
    {
        DataTable dt;
        dt = this.getMAWBDataSet();
        this.updateOperationWayBill(ref dt, "MAWB");
        dt = null;

        dt = this.getHAWBDataSet();       
        this.updateOperationWayBill(ref dt,"HAWB");
        dt = null;

        dt = this.getMBOLDataSet();
        this.updateOperationWayBill(ref dt, "MBOL");
        dt = null;

        dt = this.getHBOLDataSet();
        this.updateOperationWayBill(ref dt, "HBOL");
        dt = null;

        
    }

    public bool updateOperationWayBill(ref DataTable dt, string type)
    {
        bool return_val = false;
        SqlCommand cmd = new SqlCommand(SQL, Con);

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            return_val = false;
            string invoice_no = dt.Rows[i]["invoice_no"].ToString();
            string hawb_num = dt.Rows[i]["hawb_num"].ToString();
            string mawb_num = dt.Rows[i]["mawb_num"].ToString();

            string elt_act_no = dt.Rows[i]["elt_account_number"].ToString();
            SQL = "update invoice_cost_item set operation_bill_type='" + type + "',operation_mb_no='" + mawb_num + "' WHERE elt_account_number=" + elt_act_no + " and invoice_no=" + invoice_no;

            if (type == "HAWB" || type == "HBOL")
            {
                SQL = "update invoice_cost_item set operation_hb_no='" + hawb_num + "'," + "operation_bill_type='" + type + "',operation_mb_no='" + mawb_num + "' WHERE elt_account_number=" + elt_act_no + " and invoice_no=" + invoice_no + " and (ref_no like '%" + hawb_num + "%' or (item_desc like'%HBOL%' or item_desc like '%HAWB%'))";
            }
            
            try
            {
               
                Con.Open();
                cmd.ExecuteNonQuery();
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

    //private void getDefaultInvoiceDate()
    //{
    //    SQL = "select default_invoice_date  from user_profile where EmailItemID = " + EmailItemID;
    //    try
    //    {
    //        SqlCommand cmd = new SqlCommand(SQL, Con);
    //        Con.Open();
    //        default_invoice_date = cmd.ExecuteScalar().ToString();
    //        Con.Close();
    //    }
    //    catch (Exception ex)
    //    {
    //        Con.Close();
    //        throw ex;
    //    }

    //}

    //public ArrayList getBillDetailListForInvoice(int invoice_no)
    //{
    //    SQL = "select * from bill_detail where EmailItemID = " + EmailItemID + " and invoice_no=" + invoice_no;
    //    DataTable dt = new DataTable();
    //    SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);

    //    GeneralUtility gUtil = new GeneralUtility();
    //    ArrayList resultList = new ArrayList();
    //    try
    //    {
    //        ad.Fill(dt);
    //        gUtil.removeNull(ref dt);
    //        for (int i = 0; i < dt.Rows.Count; i++)
    //        {
    //            BillDetailRecord bDRec = new BillDetailRecord();
    //            bDRec.item_ap = Int32.Parse(dt.Rows[i]["item_ap"].ToString());
    //            bDRec.item_id = Int32.Parse(dt.Rows[i]["item_id"].ToString());
    //            bDRec.item_no = Int32.Parse(dt.Rows[i]["item_no"].ToString());
    //            bDRec.item_amt = double.Parse(dt.Rows[i]["item_amt"].ToString());
    //            bDRec.item_expense_acct = Int32.Parse(dt.Rows[i]["item_expense_acct"].ToString());
    //            bDRec.ref_no = dt.Rows[i]["ref"].ToString();
    //            bDRec.tran_date = dt.Rows[i]["tran_date"].ToString();
    //            bDRec.invoice_no = Int32.Parse(dt.Rows[i]["invoice_no"].ToString());
    //            bDRec.agent_debit_no = dt.Rows[i]["agent_debit_no"].ToString();
    //            bDRec.mb_no = dt.Rows[i]["mb_no"].ToString();
    //            bDRec.ref_no = dt.Rows[i]["ref"].ToString();
    //            bDRec.iType = dt.Rows[i]["iType"].ToString();
    //            bDRec.vendor_number = Int32.Parse(dt.Rows[i]["vendor_number"].ToString());
    //            resultList.Add(bDRec);
    //        }

    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //    return resultList;
    //}

}
