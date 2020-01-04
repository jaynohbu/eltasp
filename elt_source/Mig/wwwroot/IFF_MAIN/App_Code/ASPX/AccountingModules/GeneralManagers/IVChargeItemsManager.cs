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
/// Summary description for IVChargeItemManager
/// </summary>
public class IVChargeItemsManager:Manager
{
    public IVChargeItemsManager(string elt_acct)
        : base(elt_acct)
	{ 	}

    public DataTable getIVChargeItems(int invoice_no)
    { 
        SQL = "SELECT * FROM invoice_charge_item";
        SQL += " WHERE elt_account_number="+elt_account_number+" and invoice_no="+invoice_no+" order by item_id";
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
        return dt;
    }

    public bool checkIfItemExist(IVChargeItemRecord IVChR)
    {
        SQL = "select invoice_no from invoice_charge_item where elt_account_number = "
           + elt_account_number + " and item_id="
           + IVChR.Item_id + " and invoice_no=" + IVChR.Invoice_no;
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);             
        try
        {          
            ad.Fill(dt);
            if (dt.Rows.Count > 0)
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

    public ArrayList getIVChargeItemsList(int invoice_no)
    {        
        SQL = "SELECT * FROM invoice_charge_item";
        SQL += " WHERE elt_account_number=" + elt_account_number + " and invoice_no=" + invoice_no + " order by item_id";
        ArrayList returnlist = new ArrayList();
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        try
        {
            ad.Fill(dt);

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                IVChargeItemRecord IVChR = new IVChargeItemRecord();              
                IVChR.Invoice_no = invoice_no;
                IVChR.Item_desc = dt.Rows[i]["item_desc"].ToString();
                IVChR.Item_id = Int32.Parse(dt.Rows[i]["item_id"].ToString());
                IVChR.Item_no = Int32.Parse(dt.Rows[i]["item_no"].ToString());
                IVChR.IType = dt.Rows[i]["iType"].ToString();
                IVChR.Hb_no = dt.Rows[i]["hb_no"].ToString();
                IVChR.Mb_no = dt.Rows[i]["mb_no"].ToString();
                IVChR.Charge_amount = Decimal.Parse(dt.Rows[i]["charge_amount"].ToString());
                IVChR.Import_export = dt.Rows[i]["import_export"].ToString();
                returnlist.Add(IVChR);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return returnlist;
    }

    public bool insertIVChargeItems(ArrayList chList, int invoice_no)
    {
        bool return_val = false;
        
        for (int i = 0; i < chList.Count; i++)
        {
            IVChargeItemRecord IVChR = (IVChargeItemRecord)chList[i];
            IVChR.replaceQuote();

            IVChR.Invoice_no = invoice_no;
            if (!checkIfItemExist(IVChR))
            {
                SQL = "INSERT INTO [invoice_charge_item] ";
                SQL += "( elt_account_number, ";
                SQL += "invoice_no,";
                SQL += "item_id,";
                SQL += "item_no,";
                SQL += "item_desc,";
                SQL += "qty,";
                SQL += "charge_amount,";
                SQL += "import_export,";
                SQL += "mb_no,";
                SQL += "hb_no,";
                SQL += "iType)";
                SQL += "VALUES";
                SQL += "('" + elt_account_number;
                SQL += "','" + IVChR.Invoice_no;
                SQL += "','" + IVChR.Item_id;
                SQL += "','" + IVChR.Item_no;
                SQL += "','" + IVChR.Item_desc;
                SQL += "','" + IVChR.Qty;
                SQL += "','" + IVChR.Charge_amount;
                SQL += "','" + IVChR.Import_export;
                SQL += "','" + IVChR.Mb_no;
                SQL += "','" + IVChR.Hb_no;
                SQL += "','" + IVChR.IType;
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
        }       
        return return_val;
    }

   

    public bool deleteIVChargeItems(int invoice_no)
    {
        bool return_val = false;
        SQL = "DELETE FROM invoice_charge_item WHERE elt_account_number =";
        SQL += elt_account_number + " and invoice_no="
                + invoice_no;
        Cmd = new SqlCommand(SQL, Con);
        try
        {
            Con.Open();
            Cmd.ExecuteNonQuery();           
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
    public bool deleteEmptyIVChargeItems(int invoice_no)
    {
        bool return_val = false;
        SQL = "DELETE FROM invoice_charge_item WHERE elt_account_number =";
        SQL += elt_account_number + " and invoice_no="
                + invoice_no + " and charge_amount <= 0";
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
