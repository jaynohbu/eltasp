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
/// Summary description for Client
/// </summary>
public class Client
{
   
    private string ConnectStr;
    private SqlConnection Con;
    private SqlCommand Cmd;

    public Client()
    {
         ConnectStr = (new igFunctions.DB().getConStr());
         Con = new SqlConnection(ConnectStr);
         Cmd = new SqlCommand();
         Cmd.Connection = Con;
         
	}

    public string getNextClientID(string elt_account_number)
    {
        int i = 0; 

        string err = "";

        try
        {
            Con.Open();
            Cmd.CommandText = "select max(org_account_number) as org_account_number from organization where elt_account_number = " + elt_account_number;
            
            SqlDataReader reader = Cmd.ExecuteReader();

            if (reader.Read())
            {
                string strI = reader["org_account_number"].ToString();
                if (strI != "")
                {
                    i = int.Parse(strI);
                }
            }
            else
            {
                err = "Error was occured - ( Account Number Creation Error )";
            }

            reader.Close();
        }
        catch (Exception ex)
        {
            //Response.Write("<script language='javascript'> alert('" + ex.Message + "') </script>");
        }
        finally
        {
            Con.Close();
            i++;
        }
        Con.Close();
        return i.ToString();
      
    }



    /*************************************************************************
     * 
     * 
     * ***********************************************************************/

    public string checkExisitingClients(string acct, string dba)
    {
        ArrayList alist = new ArrayList();

        string a = "";

        try
        {
            Con.Open();
            Cmd.CommandText = "select *  from organization where elt_account_number ='" + acct + "' AND dba_name like '" + dba + "' ";
            SqlDataReader reader = Cmd.ExecuteReader();

            if (reader.HasRows)
            {
                reader.Read();
                a = reader["dba_name"].ToString();
                if (a.Equals(dba))
                    a = reader["org_account_number"].ToString();
                    Con.Close();
                    return a;
            }            

        }
        catch (Exception ex)
        {
           
        }

        Con.Close();
        return a;
    }

    /*************************************************************************
     * 
     * 
     * ***********************************************************************/

    public string insertClient(string acct, string dba)
    {
        string nextAccount = getNextClientID(acct); 
        try
        {
            Con.Open();

            Cmd.CommandText = "insert into organization ( elt_account_number, dba_name, org_account_number ) VALUES ( " + acct + ", '" + dba + "', " + nextAccount+ ")";

            if (Cmd.ExecuteNonQuery()!= 0)
            {
                return nextAccount;
            }      
             
        }
        catch (Exception ex)
        {
                   
        }
        finally
        {
            Con.Close();
        }         
        return "";
    }


    /*************************************************************************
     * 
     * 
     * ***********************************************************************/

    public string insertClient(string cAcct, string cName, string cAddress, string cCity,string cState, string cZip, string cCountry,string cCountry_code, string cPhone )
    {
       
        string nextAccount = getNextClientID(cAcct);
        try
        {
            Con.Open();

            Cmd.CommandText = "insert into organization ( elt_account_number, dba_name, org_account_number, business_address, business_city, business_state, business_zip, business_country, b_country_code, business_phone, account_status, date_opened, last_update) VALUES ( " + cAcct + ", '" + cName + "', " + nextAccount + ",'" + cAddress + "','" + cCity + "','" + cState + "','" + cZip + "','" + cCountry + "','" + cCountry_code + "','" + cPhone + "', " + "'A','" + DateTime.Now.ToString() + "','" + DateTime.Now.ToString() + "')";

            if (Cmd.ExecuteNonQuery() != 0)
            {
                return nextAccount;
            }

        }
        catch (Exception ex)
        {
            nextAccount = ex.ToString();//for debug
        }
        finally
        {
            Con.Close();
        }
        return "";
    }


/*************************************************************************
 * 
 * 
 * ***********************************************************************/

    public string  updateJobType(string eltAcct, string orgAcct,  string jobtype)
    {
        //Types of Jobs can be [is_shipper],[is_consignee],
        //[is_agent],[is_vendor],[is_colodee],[z_is_trucker],[z_is_broker],[z_is_warehousing],[z_is_cfs],[z_is_govt]
        // for a Carrier it should not be updated here.  
        string a="";
        try
        {
            Con.Open();
            Cmd.CommandText = "UPDATE [organization]" +
            "SET "+ jobtype + "= 'Y'" +
            "WHERE elt_account_number = " + eltAcct +
            "AND org_account_number =" + orgAcct;
           
            if (Cmd.ExecuteNonQuery() == 1)
            {
               a = orgAcct;
               return a;              
            }
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }
        finally
        {
            Con.Close();
        }

        Con.Close();

        return a;
    }
}
