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
/// <summary>
/// Summary description for IVsTrack
/// </summary>
public class IVsTrack : DocTrack
{
    public IVsTrack(string elt_account_number, string ConnectStr)
        : base(elt_account_number, ConnectStr)
    {

    }

    public DataTable getIVsByHB(string refno)
    {
        string Qry = "";
        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        DataTable dt = new DataTable();

        if (refno != "0")
        {
            try
            {
                Qry =
                   @"select distinct 
                  '' as [Primary],
                  '' as [Foreign], 
                  a.import_export as [IE],
                  a.mawb_num as [MAWB#],                 
                  isnull(a.hawb_num,'') as [HAWB#], 
                  a.invoice_no as [IV#],
                  a.invoice_date as [Date Issued] 
                  from  invoice_hawb a
                  where a.elt_account_number ="
                      + elt_account_number + " and a.hawb_num = '"
                      + refno + "'" + "  ORDER BY [Date Issued] DESC";

                // Response.Write(Qry);
                // Response.End();

                SqlCommand cmd = new SqlCommand(Qry);
                cmd.Connection = Con;
                SqlDataAdapter Adap = new SqlDataAdapter();

                Con.Open();
                Adap.SelectCommand = cmd;

                Adap.Fill(dt);
                Con.Close();
            }
            catch (Exception ex)
            {
                ex.Message.Insert(ex.Message.Length, Qry);
            }
        }
        if (dt.Rows.Count == 0)
        {
            // Response.Write("<script language= 'javascript'> alert(' No data was found during the period!')</script>");

        }
      // return Qry;

      return dt;
    }

    public DataTable getIVsByHB_Ocean(string refno)
    {
        string Qry = "";
        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        DataTable dt = new DataTable();

        if (refno != "0")
        {
            try
            {
                Qry =
                   @"select distinct
                  '' as [Primary],
                  '' as [Foreign], 
                  a.import_export as [IE],
                  a.mawb_num as [MBOL#], 
                  isnull(b.hawb_num,'') as [HBOL#], 
                  a.invoice_no as [IV#],
                  a.invoice_date as [Date Issued] 
                  from invoice a 
                  left outer join invoice_hawb b
                  on a.elt_account_number = b.elt_account_number
                  and a.invoice_no = b.invoice_no
              
                  where a.elt_account_number ="
                      + elt_account_number + " And b.hawb_num = '"
                      + refno + "'" + " or a.hawb_num = '"
                      + refno + "'" + " and a.mawb_num <>'0' ORDER BY [Date Issued] DESC";

                // Response.Write(Qry);
                // Response.End();

                SqlCommand cmd = new SqlCommand(Qry);
                cmd.Connection = Con;
                SqlDataAdapter Adap = new SqlDataAdapter();

                Con.Open();
                Adap.SelectCommand = cmd;

                Adap.Fill(dt);
                string hawb = refno;
                if (dt.Rows.Count > 0)
                {
                    int verify = dt.Rows.Count;
                   
                }
                Con.Close();
            }
            catch (Exception ex)
            {
                ex.Message.Insert(ex.Message.Length, Qry);
            }
        }
        if (dt.Rows.Count == 0)
        {
            // Response.Write("<script language= 'javascript'> alert(' No data was found during the period!')</script>");

        }
        // return Qry;

        return dt;
    }


    public DataTable getIVsByMB(string refno){

        string Qry = "";
        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        DataTable dt = new DataTable();
        if (refno != "0")
        {
            try
            {
                Qry =
                       @"select   distinct  
                    '' as [Primary],
                    '' as [Foreign], 
                    import_export as [IE],          
                    mawb_num as [MAWB#],  
                    isnull(hawb_num,'') as [HAWB#], 
                    invoice_no as [IV#],     
                    invoice_date as [Date Issued]                              
                    from invoice  where elt_account_number = " + elt_account_number
                                                                           + " And mawb_num = '" + refno
                                                                           +
                        "'  ORDER BY [Date Issued] DESC";

                // Response.Write(Qry);
                // Response.End();
                SqlCommand cmd = new SqlCommand(Qry);
                cmd.Connection = Con;
                SqlDataAdapter Adap = new SqlDataAdapter();

                Con.Open();
                Adap.SelectCommand = cmd;

                Adap.Fill(dt);
                Con.Close();
            }
            catch (Exception ex)
            {
                ex.Message.Insert(ex.Message.Length, Qry);
            }
        }
        if (dt.Rows.Count == 0)
        {
            // Response.Write("<script language= 'javascript'> alert(' No data was found during the period!')</script>");

        }
        //return Qry;

        return dt;   
    }
    public DataTable getIVsByMB_Ocean(string refno)
    {
        string Qry = "";
        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        DataTable dt = new DataTable();
        if (refno != "0")
        {
            try
            {
                Qry =
                    @"select   distinct 
                    '' as [Primary],
                    '' as [Foreign],  
                    import_export as [IE],          
                    mawb_num as [MBOL#],  
                    isnull(hawb_num,'') as [HBOL#], 
                    invoice_no as [IV#],     
                    invoice_date as [Date Issued]                              
                    from invoice  where elt_account_number = " + elt_account_number
                                                                           + " And mawb_num = '" + refno
                                                                           +
                        "'  ORDER BY [Date Issued] DESC";

                // Response.Write(Qry);
                // Response.End();
                SqlCommand cmd = new SqlCommand(Qry);
                cmd.Connection = Con;
                SqlDataAdapter Adap = new SqlDataAdapter();

                Con.Open();
                Adap.SelectCommand = cmd;

                Adap.Fill(dt);
                Con.Close();
            }
            catch (Exception ex)
            {
                ex.Message.Insert(ex.Message.Length, Qry);
            }
        }
        if (dt.Rows.Count == 0)
        {
            // Response.Write("<script language= 'javascript'> alert(' No data was found during the period!')</script>");

        }
        //return Qry;

        return dt;
    }


}
