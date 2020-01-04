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
/// Summary description for OrganizationManager
/// </summary>
public class OrganizationManager:Manager
{

    public OrganizationManager(string elt_acct)
        : base(elt_acct)
	{
          
	}
    public ArrayList getVendorList()
    {        
        SQL = "SELECT org_account_number,ISNULL(dba_name,'') as dba_name," 
            + "RTRIM(ISNULL(class_code,'')) as class_code FROM organization " 
            + "WHERE elt_account_number = "+ elt_account_number 
			+ " and isnull(dba_name,'') <> '' and (is_vendor = 'Y' or z_is_trucker = 'Y' or z_is_govt = 'Y' or z_is_special = 'Y' or z_is_broker='Y' or z_is_warehousing='Y') order by dba_name";

        DataSet ds= new DataSet();
        ArrayList lst = new ArrayList();
        try
        {            
            SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
            ad.Fill(ds);

            GeneralUtility util = new GeneralUtility();
            util.removeNull(ref ds,0);

            OrganizationRecord org1 = new OrganizationRecord();
            org1.Dba_name = "Select";
            org1.Org_account_number = -1;           
            lst.Add(org1);
           
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                OrganizationRecord org = new OrganizationRecord();
                org.Org_account_number = Int32.Parse(ds.Tables[0].Rows[i]["org_account_number"].ToString());
                org.Dba_name = ds.Tables[0].Rows[i]["dba_name"].ToString();
                org.Class_code = ds.Tables[0].Rows[i]["class_code"].ToString();
                lst.Add(org);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return lst;
    }

    public ArrayList getAllOrgization()
    {
        SQL = "SELECT org_account_number,ISNULL(dba_name,'') as dba_name,"
            + "RTRIM(ISNULL(class_code,'')) as class_code FROM organization "
            + "WHERE elt_account_number = " + elt_account_number
            + " and isnull(dba_name,'') <> '' order by dba_name";

        DataSet ds = new DataSet();
        ArrayList lst = new ArrayList();
        try
        {
            SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
            ad.Fill(ds);

            GeneralUtility util = new GeneralUtility();
            util.removeNull(ref ds, 0);

            OrganizationRecord org1 = new OrganizationRecord();
            org1.Dba_name = "Select";
            org1.Org_account_number = -1;
            lst.Add(org1);

            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                OrganizationRecord org = new OrganizationRecord();
                org.Org_account_number = Int32.Parse(ds.Tables[0].Rows[i]["org_account_number"].ToString());
                org.Dba_name = ds.Tables[0].Rows[i]["dba_name"].ToString();
                org.Class_code = ds.Tables[0].Rows[i]["class_code"].ToString();
                lst.Add(org);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return lst;
    }


     public void getOrgNameInfo(int orgAcct, ref string orgName,ref string orgInfo, ref int term){

         SQL = "SELECT * from organization WHERE elt_account_number = " + elt_account_number + " and org_account_number = " + orgAcct;

         DataTable dt = new DataTable();
      
        try
        {            
            SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
            ad.Fill(dt);

            GeneralUtility util = new GeneralUtility();
            util.removeNull(ref dt);
            if (dt.Rows.Count > 0)
            {
                orgName = dt.Rows[0]["dba_name"].ToString();
                orgInfo = dt.Rows[0]["dba_name"].ToString() + "\n" + dt.Rows[0]["business_address"].ToString() + ",";
                orgInfo = orgInfo + dt.Rows[0]["business_city"].ToString() + "," + dt.Rows[0]["business_zip"].ToString();
                orgInfo = orgInfo + "\n Tel:" + dt.Rows[0]["business_phone"].ToString();
                orgInfo = orgInfo + "\n Fax:" + dt.Rows[0]["business_fax"].ToString();
                term = Int32.Parse(dt.Rows[0]["bill_term"].ToString());
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
       
     }
    public void getOrgInfo(int orgAcct, ref string orgName, ref string orgInfo, ref int term)
    {
           
        SQL = "SELECT * from organization WHERE elt_account_number = " + elt_account_number + " and org_account_number = " + orgAcct;

        DataTable dt = new DataTable();

        try
        {
            SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
            ad.Fill(dt);

            GeneralUtility util = new GeneralUtility();
            util.removeNull(ref dt);
            if (dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["owner_mail_address"].ToString() != "")
                {
                    orgName = dt.Rows[0]["dba_name"].ToString();
                    orgInfo = dt.Rows[0]["dba_name"].ToString() + "\n" + dt.Rows[0]["owner_mail_address"].ToString() + dt.Rows[0]["owner_mail_address2"].ToString() +dt.Rows[0]["owner_mail_address3"].ToString() +  ",";
                    orgInfo = orgInfo + dt.Rows[0]["owner_mail_city"].ToString() + ",";
                    orgInfo = orgInfo + dt.Rows[0]["owner_mail_state"].ToString() + dt.Rows[0]["owner_mail_zip"].ToString();
                    orgInfo = orgInfo + "\n Tel:" + dt.Rows[0]["business_phone"].ToString();
                    orgInfo = orgInfo + "\n Fax:" + dt.Rows[0]["business_fax"].ToString();
                    term = Int32.Parse(dt.Rows[0]["bill_term"].ToString());
                }
                else
                {
                    getOrgNameInfo(orgAcct, ref orgName, ref  orgInfo,ref  term);
                }
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }    

    }

    public string getOrgName(int orgAcct)
    {
        string orgName = "";
        SQL = "SELECT dba_name from organization WHERE elt_account_number = " + elt_account_number + " and org_account_number = " + orgAcct;

        DataTable dt = new DataTable();

        try
        {
            SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
            ad.Fill(dt);

            GeneralUtility util = new GeneralUtility();
            util.removeNull(ref dt);
            if (dt.Rows.Count > 0)
            {
                orgName = dt.Rows[0]["dba_name"].ToString();
            }
            
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return orgName;

    }

    public string get_default_sales_person(int org_acct_number)
    {

        SQL = "select SalesPerson from organization where elt_account_number = " + elt_account_number + " and org_account_number = " + org_acct_number;        
        string sales_person = "";
        DataTable dt = new DataTable();
        try
        {
            SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
            ad.Fill(dt);
            GeneralUtility util = new GeneralUtility();
            util.removeNull(ref dt);
            if (dt.Rows.Count > 0)
            {
                sales_person = dt.Rows[0]["SalesPerson"].ToString();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return sales_person;
    }


    public string get_default_broker(int org_acct_number)
    {

        SQL = "select isnull(defaultbroker,0) as defaultbroker from organization where elt_account_number = " + elt_account_number + " and org_account_number = " + org_acct_number;
       
        DataTable dt = new DataTable();
        string defaultbroker = "";
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        try
        {
            
            ad.Fill(dt);
            GeneralUtility util = new GeneralUtility();
            if (dt.Rows.Count > 0)
            {
                util.removeNull(ref dt);
                defaultbroker = dt.Rows[0]["defaultbroker"].ToString();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }


        SQL = "select isnull(dba_name,'') as dba_name from organization where elt_account_number = " + elt_account_number + " and org_account_number = " + defaultbroker;
      
       
        try
        {
            dt.Clear();
            SqlDataAdapter ad2 = new SqlDataAdapter(SQL, Con);
            ad2.Fill(dt);
            if (dt.Rows.Count > 0)
            {
                GeneralUtility util = new GeneralUtility();
                util.removeNull(ref dt);
                defaultbroker = defaultbroker + "^^" + dt.Rows[0]["dba_name"].ToString();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return defaultbroker;
    }
}
