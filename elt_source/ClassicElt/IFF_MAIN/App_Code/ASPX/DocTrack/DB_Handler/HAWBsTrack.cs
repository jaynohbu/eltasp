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
/// Summary description for HAWBsTrack
/// </summary>
public class HAWBsTrack : DocTrack
{

    public HAWBsTrack(string elt_account_number, string ConnectStr)
        : base(elt_account_number, ConnectStr)
    {

    }

    public DataTable getHAWBsDuring(string start, string end)
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
                     '' as [Foreign], 
                     'E' as [IE],  
                    isnull(mawb_num,'') as [MAWB#],            
                    isnull(HAWB_num,'') as [HAWB#],       
                    CreatedDate as [Date Issued]                             
                    from HAWB_master  where elt_account_number = " + elt_account_number +
                " and ( CreatedDate >= '" + start +
                 "' and CreatedDate < DATEADD(day, 1,'" + end +
                "'))";      


            Qry2 =
              @"select   
                    '' as [Primary],
                     '' as [Foreign], 
                     'I' as [IE],  
                    isnull(mawb_num,'') as [MAWB#] ,
                    isnull(HAWB_num,'') as [HAWB#],             
                      
                    CreatedDate as [Date Issued]                            
                    from import_HAWB where iType = 'A' and elt_account_number = " + elt_account_number +
               " and ( CreatedDate >= '" + start +
                "' and CreatedDate < DATEADD(day, 1,'" + end +
               "'))" ;

            Qry = Qry + " UNION "+ Qry2;

            Qry += "ORDER BY [Date Issued] DESC";

          
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
            //Response.Write(ex.ToString());
           // Response.End();
        }
        return dt;
    }


    public DataTable  getHAWBsByMAWB(string refno) {
    
     string Qry = "";
     string Qry2 = "";
        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        DataTable dt = new DataTable();

        try
        {
            Qry =
                   @"select   
                    distinct 
                        '' as [Primary],
                     '' as [Foreign], 
                    'E' as [IE],  
                    mawb_num as [MAWB#],            
                    HAWB_num as [HAWB#],       
                    CreatedDate as [Date Issued]                                
                    from HAWB_master  where  elt_account_number = " + elt_account_number
                                                                       + " And mawb_num = '" + refno
                                                                       +
                    "'";

            Qry2 =
                  @"select   distinct 
                        '' as [Primary],
                     '' as [Foreign], 
                    'I' as [IE],  
                    mawb_num as [MAWB#],            
                    HAWB_num as [HAWB#],       
                    CreatedDate as [Date Issued]                                
                    from import_HAWB  where  iType = 'A' and elt_account_number = " + elt_account_number
                                                                      + " And mawb_num = '" + refno
                                                                      +
                   "' ORDER BY [Date Issued] DESC";
            Qry=Qry+" UNION "+ Qry2;

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
        if (dt.Rows.Count == 0)
        {
            // Response.Write("<script language= 'javascript'> alert(' No data was found during the period!')</script>");

        }
        return dt;    
    }

    public DataTable getHAWB(string refno)
    {

        string Qry = "";
        string Qry2 = "";
        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        DataTable dt = new DataTable();

        try
        {
            Qry =
                   @"select   distinct 
                       '' as [Primary],
                     '' as [Foreign], 
                     'E' as [IE],  
                    mawb_num as [MAWB#],            
                    HAWB_num as [HAWB#],       
                    CreatedDate as [Date Issued]                                
                    from HAWB_master  where  elt_account_number = " + elt_account_number
                                                                       + " And hawb_num = '" + refno
                                                                       +
                    "'";

            Qry2 =
                  @"select   distinct 
                     '' as [Primary],
                     '' as [Foreign], 
                     'I' as [IE],  
                    mawb_num as [MAWB#],            
                    HAWB_num as [HAWB#],       
                    CreatedDate as [Date Issued]                                
                    from import_HAWB  where  iType = 'A' and elt_account_number = " + elt_account_number
                                                                      + " And hawb_num = '" + refno
                                                                      +
                   "' ORDER BY [Date Issued] DESC";
            Qry = Qry + " UNION " + Qry2;

            
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
        if (dt.Rows.Count == 0)
        {
            // Response.Write("<script language= 'javascript'> alert(' No data was found during the period!')</script>");

        }
        return dt;
    }
}
