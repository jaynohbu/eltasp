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
/// Summary description for BillManager
/// </summary>
public class ImportMAWBManager:Manager
{
    public ImportMAWBManager(string elt_acct)
        : base(elt_acct)
	{        
              
	}


    public ImportMAWBRecord getMAWB(string mawb_num)
    {
        SQL = "select * from import_mawb where elt_account_number = " + elt_account_number + " and mawb_num='" + mawb_num+"'";
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        ImportMAWBRecord IMAWBRec = new ImportMAWBRecord();

        GeneralUtility gUtil=new GeneralUtility();
        ad.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            try
            {              
                gUtil.removeNull(ref dt);
                IMAWBRec.arr_code = dt.Rows[0]["arr_code"].ToString();
                IMAWBRec.arr_port = dt.Rows[0]["arr_port"].ToString(); 
                IMAWBRec.cargo_location = dt.Rows[0]["cargo_location"].ToString();
                IMAWBRec.carrier_code = dt.Rows[0]["carrier_code"].ToString();
                IMAWBRec.dep_code = dt.Rows[0]["dep_code"].ToString();
                IMAWBRec.dep_port = dt.Rows[0]["dep_port"].ToString();
                IMAWBRec.eta = dt.Rows[0]["eta"].ToString();
                IMAWBRec.etd = dt.Rows[0]["etd"].ToString();
                IMAWBRec.file_no = dt.Rows[0]["file_no"].ToString();
                IMAWBRec.flt_no = dt.Rows[0]["flt_no"].ToString();
                IMAWBRec.it_date = dt.Rows[0]["it_date"].ToString();
                IMAWBRec.it_entry_port = dt.Rows[0]["it_entry_port"].ToString();
                IMAWBRec.it_number = dt.Rows[0]["it_number"].ToString();
                IMAWBRec.last_free_date = dt.Rows[0]["last_free_date"].ToString();
                IMAWBRec.place_of_delivery = dt.Rows[0]["place_of_delivery"].ToString();
                IMAWBRec.process_dt = dt.Rows[0]["process_dt"].ToString();
                IMAWBRec.sub_mawb = dt.Rows[0]["sub_mawb"].ToString();             
                

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        return IMAWBRec;
    }
}
