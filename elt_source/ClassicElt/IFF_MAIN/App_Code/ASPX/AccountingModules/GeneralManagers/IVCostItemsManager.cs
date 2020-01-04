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
/// Summary description for IVCostItemManager
/// </summary>
public class IVCostItemsManager:Manager
{
    private GeneralUtility gUtil;
    public IVCostItemsManager(string elt_acct):base(elt_acct)
    {
        gUtil = new GeneralUtility();
    }

    public DataTable getIVCostItems(int invoice_no)
    {
        SQL = "SELECT * FROM invoice_cost_item";
        SQL += " WHERE elt_account_number=" + elt_account_number + " and invoice_no=" + invoice_no +" order by item_id";
        
        DataTable dt = new DataTable();
        //dt.Columns.Add(new DataColumn("ap_lock", System.Type.GetType("System.Boolean")));
        dt.Columns.Add(new DataColumn("bill_number", System.Type.GetType("System.Int32")));
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        gUtil.removeNull(ref dt);
        try
        {
            ad.Fill(dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        BillDetailManager bdMgr = new BillDetailManager(elt_account_number);
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            int bill_number = 0;
            dt.Rows[i]["ap_lock"] = bdMgr.checkIfAPposted(Int32.Parse(dt.Rows[i]["invoice_no"].ToString()), Int32.Parse(dt.Rows[i]["item_no"].ToString()), Int32.Parse(dt.Rows[i]["item_id"].ToString()), Decimal.Parse(dt.Rows[i]["cost_amount"].ToString()), ref bill_number);
            if (Boolean.Parse(dt.Rows[i]["ap_lock"].ToString()))
            {
                dt.Rows[i]["bill_number"] = bill_number;
            }
        }
        return dt;
    }
    public void resetAPLock(int  invoice_no, int item_id, string is_lock)
    {
        SQL = "update invoice_cost_item set ap_lock='" + is_lock + "'WHERE elt_account_number =";
        SQL += elt_account_number + " and invoice_no="
            + invoice_no + " and item_id="
            + item_id;
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

    public bool changeIVCostItemAmt(string invoice_no, string item_id, string item_no, string cost_amount)
   {

       SQL = "update invoice_cost_item set cost_amount='" + cost_amount + "'WHERE elt_account_number =";
       SQL += elt_account_number + " and invoice_no="
           + invoice_no 
           + " and item_id="
           + item_id + " and item_no="
           + item_no;

       Cmd = new SqlCommand(SQL, Con);
       int count = 0;
       try
       {
           Con.Open();
           count=Cmd.ExecuteNonQuery();
       }
       catch (Exception ex)
       {
           throw ex;
       }
       finally
       {
           Con.Close();
       }
       if (count > 0)
       {
           return true;
       }
       else
       {
           return false;
       }
   }


    public ArrayList getIVCostItemsList(int invoice_no)
    {
        SQL = "SELECT * FROM invoice_cost_item";
        SQL += " WHERE elt_account_number=" + elt_account_number + " and invoice_no=" + invoice_no + " order by item_id";
        ArrayList returnlist = new ArrayList();
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        try
        {
            ad.Fill(dt);
            gUtil.removeNull(ref dt);
            BillDetailManager bdMgr = new BillDetailManager(elt_account_number);
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                IVCostItemRecord IVCoR = new IVCostItemRecord();
              
                IVCoR.Invoice_no = invoice_no;
                IVCoR.Item_desc = dt.Rows[i]["item_desc"].ToString();
                IVCoR.Item_id = Int32.Parse(dt.Rows[i]["item_id"].ToString());
                IVCoR.Item_no = Int32.Parse(dt.Rows[i]["item_no"].ToString());
                IVCoR.Cost_amount = Decimal.Parse(dt.Rows[i]["cost_amount"].ToString());
                IVCoR.Vendor_no = Int32.Parse(dt.Rows[i]["vendor_no"].ToString());
                IVCoR.Ref_no = dt.Rows[i]["ref_no"].ToString();
                IVCoR.IType = dt.Rows[i]["iType"].ToString();
                IVCoR.Hb_no = dt.Rows[i]["hb_no"].ToString();
                IVCoR.Mb_no = dt.Rows[i]["mb_no"].ToString();
                IVCoR.Import_export = dt.Rows[i]["import_export"].ToString();
                int bill_number = 0;
                IVCoR.AP_Posted = bdMgr.checkIfAPposted(IVCoR.Invoice_no, IVCoR.Item_no, IVCoR.Item_id, IVCoR.Cost_amount, ref bill_number);
                IVCoR.Bill_number = bill_number;
                returnlist.Add(IVCoR);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return returnlist;
    }



    public bool insertIVCostItems(ArrayList cstList, int invoice_no)
    {
        bool return_val = false;
        for (int i = 0; i < cstList.Count; i++)
        {
            IVCostItemRecord IVCostR = (IVCostItemRecord)cstList[i];
            IVCostR.replaceQuote();

              SQL = "INSERT INTO [invoice_Cost_item] ";
                SQL += "( elt_account_number, ";
                SQL += "invoice_no,";
                SQL += "item_id,";
                SQL += "item_no,";
                SQL += "item_desc,";
                SQL += "qty,";
                SQL += "ref_no,";
                SQL += "vendor_no,";
                SQL += "Cost_amount,";
                SQL += "import_export,";
                SQL += "operation_mb_no,";
                SQL += "operation_hb_no,";
                SQL += "operation_bill_type)";
                SQL += "VALUES";
                SQL += "('" + elt_account_number;
                SQL += "','" + invoice_no;
                SQL += "','" + IVCostR.Item_id;
                SQL += "','" + IVCostR.Item_no;
                SQL += "','" + IVCostR.Item_desc;
                SQL += "','" + IVCostR.Qty;
                SQL += "','" + IVCostR.Ref_no;
                SQL += "','" + IVCostR.Vendor_no;
                SQL += "','" + IVCostR.Cost_amount;
                SQL += "','" + IVCostR.Import_export;
                SQL += "','" + IVCostR.Mb_no;
                SQL += "','" + IVCostR.Hb_no;
                SQL += "','" + IVCostR.IType;
                SQL += "')";
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
            }
       
        return return_val;
          
    }

    public bool updateIVCostItems(ArrayList cstList, int invoice_no)
    {
        bool return_val = false;
        ArrayList previous = getIVCostItemsList(invoice_no);
        try
        {
            if(deleteIVCostItems(invoice_no)){
                return_val=insertIVCostItems(cstList, invoice_no);
            }         
        }
        catch (Exception ex)
        {
            rollback_Entries(previous, invoice_no);
            throw ex;
        }
        return return_val;        
    }

    public bool checkExistIVCostItem(IVCostItemRecord IVCostR)
    {
        SQL = "select * from invoice_cost_item where elt_account_number =";
        SQL += elt_account_number + " and invoice_no="
                + IVCostR.Invoice_no + " and item_id="
          + IVCostR.Item_id;
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

    public bool deleteIVCostItem(IVCostItemRecord IVCostR)
    {
        bool return_val = false;
        SQL = "DELETE FROM invoice_cost_item WHERE elt_account_number =";
        SQL += elt_account_number + " and invoice_no="
            + IVCostR.Invoice_no + " and item_id="
            + IVCostR.Item_id;
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
        return return_val;
    }

    public void rollback_Entries(ArrayList previous, int invoice_no)
    {
        try
        {
            deleteIVCostItems(invoice_no);
            insertIVCostItems(previous, invoice_no);
        }
        catch (Exception ex)
        {
            throw ex;
        }        
    }

    public bool deleteIVCostItems(int invoice_no)
    {
        bool return_val = false;
        int count = 0;
        SQL = "DELETE FROM invoice_cost_item WHERE elt_account_number =";
        SQL += elt_account_number + " and invoice_no="
                + invoice_no;
        Cmd = new SqlCommand(SQL, Con);
        try
        {
            Con.Open();
            count = Cmd.ExecuteNonQuery();
            Con.Close();
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
    public bool deleteEmptyIVCostItems(int invoice_no)
    {
        bool return_val = false;
        int count = 0;
        SQL = "DELETE FROM invoice_cost_item WHERE elt_account_number =";
        SQL += elt_account_number + " and invoice_no="
                + invoice_no + " and cost_amount <= 0";
        Cmd = new SqlCommand(SQL, Con);
        try
        {
            Con.Open();
            count = Cmd.ExecuteNonQuery();
            Con.Close();
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
