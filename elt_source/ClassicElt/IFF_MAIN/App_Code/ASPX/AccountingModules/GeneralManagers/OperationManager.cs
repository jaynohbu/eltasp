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
/// Summary description for OperationManager
/// </summary>
public class OperationManager:Manager
{
   
    public OperationManager(string elt_acct)
        : base(elt_acct)
	{
       	
    }

    public string getETDFromOperation(string mb_no, string hb_no, string air_ocean)
    {
       
        string ETD="";

        if (air_ocean == "A")
        {
            SQL = "SELECT ETD_DATE1 FROM mawb_number WHERE elt_account_number = " + elt_account_number + " and mawb_no='" + mb_no + "'";

        }
        else 
        {
            SQL = "SELECT departure_date FROM ocean_booking_number WHERE elt_account_number = " + elt_account_number + " and booking_num='" + mb_no + "'";
        }

        try
        {
            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            ETD = cmd.ExecuteScalar().ToString();
        }
        catch (Exception ex)
        {
            throw ex;
          
        }
        Con.Close();
        return ETD;
    }

    public string getETAFromOperation(string mb_no, string hb_no,string air_ocean)
    {
        string ETA = "";;
      
        if (air_ocean == "A")
        {
            SQL = "SELECT ETD_DATE1 FROM mawb_number WHERE elt_account_number = " + elt_account_number + " and mawb_no='" + mb_no + "'";
           
        }
        else
        {
            SQL = "SELECT arrival_date FROM ocean_booking_number WHERE elt_account_number = " + elt_account_number + " and booking_num='" + mb_no + "'";
          
        }

        try
        {
            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            ETA = cmd.ExecuteScalar().ToString();
        }
        catch (Exception ex)
        {
            throw ex;
          
        }
        Con.Close();
        return ETA;
    }

    public string getFileNoFromOperation(string mb_no, string hb_no, string air_ocean)
    {
        string fileNo = "";
       
       
        if (air_ocean == "A")
        {
            SQL = "SELECT File# as file_no  FROM mawb_number WHERE elt_account_number = " + elt_account_number + " and mawb_no='" + mb_no + "'";

        }
        else
        {
            SQL = "SELECT file_no FROM ocean_booking_number WHERE elt_account_number = " + elt_account_number + " and booking_num='" + mb_no + "'";
         
        }
        try
        {
            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            fileNo = cmd.ExecuteScalar().ToString();
        }
        catch (Exception ex)
        {
            throw ex;
          
        }
        Con.Close();
        return fileNo;
    }

    public string getConsigneeFromOperation(string mb_no, string hb_no, string air_ocean)
    {
        mb_no = mb_no.Trim();
        hb_no = hb_no.Trim();

        string Consignee = "";
        if ((hb_no == String.Empty || hb_no == "CONSOLIDATION" )&& air_ocean == "A")
        {
            SQL = "SELECT Consignee_Name FROM mawb_master WHERE elt_account_number = " + elt_account_number + " and mawb_num='" + mb_no + "'"; ;

        }
        else if ((hb_no == String.Empty || hb_no == "CONSOLIDATION" )&& air_ocean == "O")
        {
            SQL = "SELECT  Consignee_Name FROM mbol_master WHERE elt_account_number = " + elt_account_number + " and booking_num='" + mb_no + "'"; ;

        }
        else if (hb_no != String.Empty && air_ocean == "A")
        {
            SQL = "SELECT  Consignee_Name FROM hawb_master WHERE elt_account_number = " + elt_account_number + " and mawb_num= '" + mb_no + "' and hawb_num='" + hb_no + "'";

        }
        else if (hb_no != String.Empty && air_ocean == "O")
        {
            SQL = "SELECT Consignee_Name FROM hbol_master WHERE elt_account_number = " + elt_account_number + " and booking_num='" + mb_no + "' and hbol_num='" + hb_no + "'"; ;
        }
        
        try
        {
            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            Consignee = cmd.ExecuteScalar().ToString();
        }
        catch (Exception ex)
        {           
           // throw ex;          
        }
        Con.Close();
        return Consignee;
    }

    public string getShipperFromOperation(string mb_no, string hb_no, string air_ocean)
    {
        string Shipper = "";
        mb_no = mb_no.Trim();
        hb_no = hb_no.Trim();

        if ((hb_no == String.Empty || hb_no == "CONSOLIDATION" )&& mb_no != "" && air_ocean == "A")
        {
            SQL = "SELECT Shipper_Name FROM mawb_master WHERE elt_account_number = " + elt_account_number + " and mawb_num='" + mb_no + "'"; ;

        }
        else if ((hb_no == String.Empty || hb_no == "CONSOLIDATION") && mb_no != String.Empty && air_ocean == "O")
        {
            SQL = "SELECT  Shipper_Name FROM mbol_master WHERE elt_account_number = " + elt_account_number + " and booking_num='" + mb_no + "'"; ;

        }
        else if (hb_no != String.Empty && air_ocean == "A")
        {
            SQL = "SELECT  Shipper_Name FROM hawb_master WHERE elt_account_number = " + elt_account_number + " and mawb_num= '" + mb_no + "' and hawb_num='" + hb_no + "'";

        }
        else if (hb_no != String.Empty && air_ocean == "O")
        {
            SQL = "SELECT Shipper_Name FROM hbol_master WHERE elt_account_number = " + elt_account_number + " and booking_num='" + mb_no + "' and hbol_num='" + hb_no + "'"; ;
        }

        
        try
        {
            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            Shipper  = cmd.ExecuteScalar().ToString();
        }
        catch (Exception ex)
        {
           // throw ex;         
        }
        Con.Close();
        return Shipper;
    }

    public string getOriginFromOperation(string mb_no, string hb_no, string air_ocean)
    {
        string Origin = "";
        mb_no = mb_no.Trim();
        hb_no = hb_no.Trim();

        if ((hb_no == String.Empty || hb_no == "CONSOLIDATION") && mb_no != "" && air_ocean == "A")
        {
            SQL = "SELECT DEP_AIRPORT_CODE FROM mawb_master WHERE elt_account_number = " + elt_account_number + " and mawb_num='" + mb_no + "'"; ;

        }
        else if ((hb_no == String.Empty || hb_no == "CONSOLIDATION") && mb_no != String.Empty && air_ocean == "O")
        {
            SQL = "SELECT  loading_port FROM mbol_master WHERE elt_account_number = " + elt_account_number + " and booking_num='" + mb_no + "'"; ;

        }
        else if (hb_no != String.Empty && air_ocean == "A")
        {
            SQL = "SELECT  DEP_AIRPORT_CODE FROM hawb_master WHERE elt_account_number = " + elt_account_number + " and mawb_num= '" + mb_no + "' and hawb_num='" + hb_no + "'";

        }
        else if (hb_no != String.Empty && air_ocean == "O")
        {
            SQL = "SELECT loading_port FROM hbol_master WHERE elt_account_number = " + elt_account_number + " and booking_num='" + mb_no + "' and hbol_num='" + hb_no + "'"; ;
        }

       

        try
        {
            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            Origin = cmd.ExecuteScalar().ToString();
        }
        catch (Exception ex)
        {
          //  throw ex;
        }
        Con.Close();
        return Origin;
    }

    public string getDestinationFromOperation(string mb_no, string hb_no, string air_ocean)
    {
        string Destination = "";
        mb_no = mb_no.Trim();
        hb_no = hb_no.Trim();

        if ((hb_no == String.Empty || hb_no == "CONSOLIDATION") && mb_no != "" && air_ocean == "A")
        {
            SQL = "SELECT to_1 FROM mawb_master WHERE elt_account_number = " + elt_account_number + " and mawb_num='" + mb_no + "'"; ;

        }
        else if ((hb_no == String.Empty || hb_no == "CONSOLIDATION") && mb_no != String.Empty && air_ocean == "O")
        {
            SQL = "SELECT  unloading_port FROM mbol_master WHERE elt_account_number = " + elt_account_number + " and booking_num='" + mb_no + "'"; ;

        }
        else if (hb_no != String.Empty && air_ocean == "A")
        {
            SQL = "SELECT  to_1 FROM hawb_master WHERE elt_account_number = " + elt_account_number + " and mawb_num= '" + mb_no + "' and hawb_num='" + hb_no + "'";

        }
        else if (hb_no != String.Empty && air_ocean == "O")
        {
            SQL = "SELECT unloading_port FROM hbol_master WHERE elt_account_number = " + elt_account_number + " and booking_num='" + mb_no + "' and hbol_num='" + hb_no + "'"; ;
        }

       


        try
        {
            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            Destination = cmd.ExecuteScalar().ToString();
        }
        catch (Exception ex)
        {
           // throw ex;
        }
        Con.Close();
        return Destination;
    }

    public string getCarrierFromOperation(string mb_no, string hb_no, string air_ocean)
    {
        string Destination = "";
        mb_no = mb_no.Trim();
        hb_no = hb_no.Trim();

        if (mb_no != String.Empty && air_ocean == "A")
        {
            SQL = "SELECT Flight#1 FROM mawb_number WHERE elt_account_number = " + elt_account_number + " and mawb_no='" + mb_no + "'"; ;

        }
        else if (mb_no != String.Empty && air_ocean == "O")
        {
            SQL = "SELECT  vsl_name FROM ocean_booking_number WHERE elt_account_number = " + elt_account_number + " and booking_num='" + mb_no + "'"; ;

        }
        
        try
        {
            SqlCommand cmd = new SqlCommand(SQL, Con);
            Con.Open();
            Destination = cmd.ExecuteScalar().ToString();
        }
        catch (Exception ex)
        {
           // throw ex;
        }
        Con.Close();
        return Destination;
    }



    public bool getWeightsAndPiecesFromOperation(ref  int pieces, ref Decimal grossweight, ref Decimal chargeableweight,  ref string unit, string mb_no, string hb_no, string air_ocean)
    {
        grossweight = 0;
        chargeableweight = 0;
        pieces = 0;

        mb_no = mb_no.Trim();
        hb_no = hb_no.Trim();
        ArrayList HBList = new ArrayList();
       

        if (hb_no == "CONSOLIDATION")
        {
            if (air_ocean == "A")
            {
                SQL = "SELECT   hawb_num as hb_no FROM hawb_master a WHERE  a.elt_account_number = " + elt_account_number + " and  a.mawb_num= '" + mb_no + "' and  a.COLL_1='Y'";

            }

            if (air_ocean == "O")
            {
                SQL = "SELECT  hbol_num as hb_no  FROM hbol_master a WHERE  a.elt_account_number = " + elt_account_number + " and  a.booking_num='" + mb_no + "' and  a.weight_cp='C'";
            }

            try
            {
                DataSet ds = new DataSet();
                SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
                ad.Fill(ds);

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    HBList.Add(ds.Tables[0].Rows[i]["hb_no"].ToString());
                }

            }
            catch (Exception ex)
            {
                //throw ex;
            }

            for (int i = 0; i < HBList.Count; i++)
            {
                if (air_ocean == "A")
                {
                    SQL = "SELECT   b.kg_lb as unit, a.Total_Gross_Weight as gross_weight,  a.Total_Chargeable_Weight as chargeable_weight,  a.Total_Pieces as pieces  FROM hawb_master a, hawb_weight_charge b WHERE  a.elt_account_number = " + elt_account_number + " and  a.mawb_num= '" + mb_no + "' and  a.hawb_num='" + HBList[i].ToString() + "'";
                }
                else
                {
                    SQL = "SELECT  'K' as unit, a.pieces,  a.gross_weight,  a.measurement as chargeable_weight FROM hbol_master a WHERE  a.elt_account_number = " + elt_account_number + " and  a.booking_num='" + mb_no + "' and  a.hbol_num='" + HBList[i].ToString() + "'"; ;
                }

                try
                {
                    DataSet ds = new DataSet();
                    SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
                    ad.Fill(ds);
                    GeneralUtility util = new GeneralUtility();
                    util.removeNull(ref ds, 0);
              
                    grossweight += Decimal.Parse(ds.Tables[0].Rows[0]["gross_weight"].ToString());
                    chargeableweight += Decimal.Parse(ds.Tables[0].Rows[0]["chargeable_weight"].ToString());
                    pieces += Int32.Parse(ds.Tables[0].Rows[0]["pieces"].ToString());
                    unit = ds.Tables[0].Rows[0]["unit"].ToString();
                   

                }
                catch (Exception ex)
                {
                    //throw ex;
                }
                finally
                {
                    Con.Close();
                }
            }
        }
        else
        {

            if (hb_no == String.Empty && air_ocean == "A" )
            {
                SQL = "SELECT b.kg_lb as unit, a.Total_Gross_Weight as gross_weight,  a.total_chargeable_weight as chargeable_weight,  a.Total_Pieces as pieces FROM mawb_master a, mawb_weight_charge b WHERE  a.elt_account_number = " + elt_account_number + " and  a.mawb_num='" + mb_no + "'";
            }
            else if (hb_no == String.Empty && air_ocean == "O" )
            {
                //ocean uses K by default!
                SQL = "SELECT  'K' as unit, a.gross_weight,  a.measurement as chargeable_weight,  a.pieces FROM mbol_master a WHERE  a.elt_account_number = " + elt_account_number + " and  a.booking_num='" + mb_no + "'";
            }
            else if (hb_no != String.Empty && air_ocean == "A" )
            {
                SQL = "SELECT   b.kg_lb as unit, a.Total_Gross_Weight as gross_weight,  a.Total_Chargeable_Weight as chargeable_weight,  a.Total_Pieces as pieces  FROM hawb_master a, hawb_weight_charge b WHERE  a.elt_account_number = " + elt_account_number + " and  a.mawb_num= '" + mb_no + "' and  a.hawb_num='" + hb_no + "'";
            }
            else if (hb_no != String.Empty && air_ocean == "O")
            {
                SQL = "SELECT  'K' as unit, a.pieces,  a.gross_weight,  a.measurement as chargeable_weight FROM hbol_master a WHERE  a.elt_account_number = " + elt_account_number + " and  a.booking_num='" + mb_no + "' and  a.hbol_num='" + hb_no + "'"; ;
            }
            
            try
            {
                DataSet ds = new DataSet();
                SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
                ad.Fill(ds);
                GeneralUtility util = new GeneralUtility();
                util.removeNull(ref ds, 0);

                grossweight += Decimal.Parse(ds.Tables[0].Rows[0]["gross_weight"].ToString());
                chargeableweight += Decimal.Parse(ds.Tables[0].Rows[0]["chargeable_weight"].ToString());
                pieces += Int32.Parse(ds.Tables[0].Rows[0]["pieces"].ToString());
                unit = ds.Tables[0].Rows[0]["unit"].ToString();                   

            }
            catch (Exception ex)
            {
                //throw ex;
            }
            finally
            {

                Con.Close();
            }


        }


       
        return true;
    }


   


    
}
