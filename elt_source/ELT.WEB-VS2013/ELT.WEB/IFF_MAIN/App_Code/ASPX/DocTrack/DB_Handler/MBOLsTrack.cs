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
/// Summary description for MBOLsTrack
/// </summary>
public class MBOLsTrack : DocTrack
{
    private DataTable dt;

    public MBOLsTrack(string elt_account_number, string ConnectStr)
        : base(elt_account_number, ConnectStr)
    {
        dt = new DataTable();
    }



    public DataTable getMBOLsDuring(string start, string end)
    {
        string Qry = "";
        string Qry2 = "";
        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);

        try
        {
            Qry =
               @"select   
                         
                    '' as [Primary],
                     
                    'E' as [IE],        
                    isnull(MBOL_num,'') as [MBOL#],       
                    CreatedDate as [Date Issued]                             
                    from MBOL_master  where elt_account_number = " + elt_account_number +
                " and ( CreatedDate >= '" + start +
                 "' and CreatedDate < DATEADD(day, 1,'" + end +
                "'))";

            Qry2 =
              @"select 
                    '' as [Primary],
                    'I' as [IE],              
                            
                    mawb_num as [MBOL#],       
                    CreatedDate as [Date Issued]                      
                    from import_mawb  where iType = 'O' and elt_account_number = " + elt_account_number +
               " and ( CreatedDate >= '" + start +
                "' and CreatedDate < DATEADD(day, 1,'" + end +
               "')) ORDER BY [Date Issued] DESC";
            Qry = Qry + " UNION " + Qry2;


            SqlCommand cmd = new SqlCommand(Qry);
            cmd.Connection = Con;
            SqlDataAdapter Adap = new SqlDataAdapter();

            Con.Open();
            Adap.SelectCommand = cmd;
            Adap.Fill(dt);
            Con.Close();

            if (dt.Rows.Count == 0)
            {
                // Response.Write(dt.Rows.Count);
                //  Response.End();

                // Response.Write("<script language= 'javascript'> alert(' No data was found during the period!')</script>");
            }
        }
        catch (Exception ex)
        {
            // Response.Write(ex.ToString());
            // Response.End();
        }
        return dt;
        //return Qry;
    }




    public DataTable getMBOL(string MBOL_no)
    {
        string Qry = "";
        string Qry2 = "";

        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        DataTable dt = new DataTable();

        try
        {
            Qry =
               @"select        
                    '' as [Primary],
                    
                     'E' as [IE],    
                    MBOL_num as [MBOL#],       
                    CreatedDate as [Date Issued]                               
                    from MBOL_master  where elt_account_number = " + elt_account_number +
                " and MBOL_num ='" + MBOL_no + "'";
          
            Qry2 = @"select     
                    '' as [Primary],
                  
                    'I' as [IE],           
                    mawb_num as [MBOL#],       
                     CreatedDate as [Date Issued]                                 
                    from import_Mawb where iType = 'O' and elt_account_number = " + elt_account_number +
                   " and mawb_num ='" + MBOL_no + "'" +
                " ORDER BY [Date Issued] DESC";


            Qry = Qry + " UNION " + Qry2;
            SqlCommand cmd = new SqlCommand(Qry);
            cmd.Connection = Con;
            SqlDataAdapter Adap = new SqlDataAdapter();

            Con.Open();
            Adap.SelectCommand = cmd;

            Adap.Fill(dt);
            Con.Close();
            if (dt.Rows.Count == 0)
            {
                //Response.Write("<script language= 'javascript'> alert(' No data was found during the period!')</script>");

            }
        }
        catch (Exception ex)
        {
            // Response.Write(ex.ToString());
            // Response.End();
        }
        return dt;
        // return Qry;
    }

}
