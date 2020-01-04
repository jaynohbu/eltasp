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

/// <summary>
/// Summary description for ELTUserProfileManager
/// </summary>
public class ELTUserProfileManager:Manager
{
    public ELTUserProfileManager(string elt_acct)
        : base(elt_acct)
	{		
        
	}
    public void getDefaultOceanFreightCharge(ref int default_ocean_freight_item_no, ref string default_OF_description)
    {
        DataTable dt = new DataTable();
        int account = -1;       
        SQL = "select isnull(default_ocean_charge_item,-1 ) as FC from user_profile where elt_account_number = " + elt_account_number;
        try
        {

            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            try
            {
                account = Int32.Parse(cmd.ExecuteScalar().ToString());
            }
            catch { }

        }
        catch (Exception ex)
        {

            throw ex;
        }
        finally
        {
            Con.Close();
        }
        
        default_ocean_freight_item_no= account;

        SQL = "select isnull(item_desc,'' ) as description from item_charge where elt_account_number = " + elt_account_number + " and item_no=" + default_ocean_freight_item_no;
        
        try
        {
            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            try
            {
            default_OF_description = cmd.ExecuteScalar().ToString();
           }
            catch { }
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

    public void getDefaultAirFreightCharge(ref int default_air_freight_item_no, ref string default_AF_description)
    {     
        int account = -1;
        SQL = "select isnull(default_air_charge_item,-1 ) as FC from user_profile where elt_account_number = " + elt_account_number;
       
       try
        {    
           
            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
           try
            {
            account = Int32.Parse(cmd.ExecuteScalar().ToString());
           }
            catch { }
        }
        catch (Exception ex)
        {
           
            throw ex;
        }
        finally
        {
            Con.Close();
        }
       
        default_air_freight_item_no= account;
        SQL = "select isnull(item_desc,'' ) as description from item_charge where elt_account_number = " + elt_account_number + " and item_no=" + default_air_freight_item_no;
        try
        {

            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            try
            {
                default_AF_description = cmd.ExecuteScalar().ToString();
            }
            catch { }
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


    public void getDefaultDomesticFreightCharge(ref int default_Domestic_freight_item_no, ref string default_DF_description)
    {
        int account = -1;
        SQL = "select isnull(default_domestic_charge_item,-1 ) as FC from user_profile where elt_account_number = " + elt_account_number;

        try
        {

            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            try
            {
                account = Int32.Parse(cmd.ExecuteScalar().ToString());
            }
            catch { }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            Con.Close();
        }

        default_Domestic_freight_item_no = account;
        SQL = "select isnull(item_desc,'' ) as description from item_charge where elt_account_number = " + elt_account_number + " and item_no=" + default_Domestic_freight_item_no;
        try
        {

            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            try
            {
                default_DF_description = cmd.ExecuteScalar().ToString();
            }
            catch { }
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


    public  int  getDefaultCostOfGoodSold()
    {
        int account = -1;
        SQL = "select isnull(default_cgs,-1 ) as default_cgs from user_profile where elt_account_number = " + elt_account_number;

        try
        {

            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            try
            {
                account = Int32.Parse(cmd.ExecuteScalar().ToString());
           }
            catch { }
        }
        catch (Exception ex)
        {
           
            throw ex;
        }
        finally
        {
            Con.Close();
        }
        return account;
            
    }


    public string  getDefaultInvoiceDate()
    {       
        SQL = "select default_invoice_date  from user_profile where elt_account_number = " + elt_account_number;
        string default_invoice_date="";
        try
        {
            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            try
            {
            default_invoice_date = cmd.ExecuteScalar().ToString();
           }
            catch { }
        }
        catch (Exception ex)
        {
           
            throw ex;
        }
        finally
        {
            Con.Close();
        }
        return default_invoice_date;
    }

    public ArrayList getSalesPersonList()
    {
        ArrayList lstSalesPerson = new ArrayList();
        SQL = "select code as person, description from all_code where elt_account_number = " + elt_account_number + " and type=22 order by code";
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        customerCreditRecord cCRec = new customerCreditRecord();
        GeneralUtility gUtil = new GeneralUtility();
        SalesPersonRecord spRec; 

        spRec = new SalesPersonRecord();
            spRec.person = "";
            spRec.description = "Select One";
            lstSalesPerson.Add(spRec);
        try
        {
            ad.Fill(dt);

            for (int i=0; i<dt.Rows.Count;i++)
            {
                spRec = new SalesPersonRecord();
                spRec.person = dt.Rows[0]["person"].ToString();
                spRec.description = dt.Rows[0]["description"].ToString();
                lstSalesPerson.Add(spRec);
            }

        }
        catch (Exception ex)
        {
                throw ex;
        }

        return lstSalesPerson;
    }

   
    
       

}
