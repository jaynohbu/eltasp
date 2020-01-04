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
/// Summary description for MBCostItemManager
/// </summary>
public class MBCostItemsManager:Manager
{
    private GeneralUtility gUtil;


    public MBCostItemsManager(string elt_acct):base(elt_acct)
    {
        gUtil = new GeneralUtility();
    }

    public bool checkIfAPLock(string mb_no, int item_id)
    {
        SQL = "select lock_ap from mb_cost_item where elt_account_number =";
        SQL += elt_account_number + " and mb_no="
                + mb_no + " and item_id="
          + item_id;
        SqlDataAdapter adp = new SqlDataAdapter(SQL, Con);
        DataTable dt = new DataTable();
        adp.Fill(dt);
        if (dt.Rows[0]["lock_ap"].ToString() == "Y")
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public void resetAPLock(string mb_no, int item_id, string is_lock)
    {
        SQL = "update mb_cost_item set lock_ap='" + is_lock + "'WHERE elt_account_number =";
        SQL += elt_account_number + " and mb_no='"
            + mb_no + "' and item_id="
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

    public void resetBillNo(string mb_no, int item_id, int bill_number)
    {
        SQL = "update mb_cost_item set bill_number='" + bill_number + "'WHERE elt_account_number =";
        SQL += elt_account_number + " and mb_no='"
            + mb_no + "' and item_id="
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

  
}
