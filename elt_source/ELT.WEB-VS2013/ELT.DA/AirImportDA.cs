using System;
using System.Web;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Reflection;
using ELT.COMMON;
using ELT.CDT;
using System.Globalization;
namespace ELT.DA
{ 
    public class AirImportDA:DABase
    {  
     public List<AirImportDocument> GetAirImportDocumentList(int ELT_ACCOUNT_NUMBER, string BillNum, string BillType)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.[GetImportDocumentList]" };
            List<AirImportDocument> list = new List<AirImportDocument>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@ELT_ACCOUNT_NUMBER", ELT_ACCOUNT_NUMBER));
                cmd.Parameters.Add(new SqlParameter("@BillType", BillType));
                cmd.Parameters.Add(new SqlParameter("@BillNum", BillNum));
                cmd.Parameters.Add(new SqlParameter("@iType", "A"));
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        AirImportDocument item = new AirImportDocument()
                        {
                            sec = Convert.ToString(reader["sec"]),
                            pieces = Convert.ToString(reader["pieces"]),
                            gross_wt = Convert.ToString(reader["gross_wt"]),
                            col_amt = Convert.ToString(reader["col_amt"]),
                            pickup_date = Convert.ToString(reader["pickup_date"]),
                            hawb_num = Convert.ToString(reader["hawb_num"]),
                            mawb_num = Convert.ToString(reader["mawb_num"]),
                            agent_no = Convert.ToString(reader["agent_no"]),
                            agent_name = Convert.ToString(reader["agent_name"]),
                           
                            invoice_no = Convert.ToString(reader["invoice_no"]),
                            agent_email = Convert.ToString(reader["owner_email"])                                           
                        };

                        list.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return list;
        }   
    }
    
}
