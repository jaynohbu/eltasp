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
    public class OceanExportDA:DABase
    {  
        public List<ManifestAgentInfo> GetAgentsInMBOL(int ELT_ACCOUNT_NUMBER, string MBOL)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.[GetAgentsInMBOL]" };
            List<ManifestAgentInfo> list = new List<ManifestAgentInfo>();
            try
            {
                cmd.Parameters.Add(new SqlParameter("@ELT_ACCOUNT_NUMBER", ELT_ACCOUNT_NUMBER));
                cmd.Parameters.Add(new SqlParameter("@MBOL", MBOL));               
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ManifestAgentInfo item = new ManifestAgentInfo() { agent_name = Convert.ToString(reader["agent_name"]), agent_no = Convert.ToString(reader["agent_no"]), Consignee_acct_num = Convert.ToString(reader["Consignee_acct_num"]) };

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

        public List<OceanExportDocument> GetOceanExportDocumentList(int ELT_ACCOUNT_NUMBER, string BillNum, string BillType)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.[GetOceanExportDocumentList]" };
            List<OceanExportDocument> list = new List<OceanExportDocument>();
            try
            {
                cmd.Parameters.Add(new SqlParameter("@ELT_ACCOUNT_NUMBER", ELT_ACCOUNT_NUMBER));
                cmd.Parameters.Add(new SqlParameter("@BillType", BillType));
                cmd.Parameters.Add(new SqlParameter("@BillNum", BillNum));
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        OceanExportDocument item = new OceanExportDocument()
                        {
                            hbol_num = Convert.ToString(reader["hbol_num"]),
                            mbol_num = Convert.ToString(reader["mbol_num"]),
                            booking_num = Convert.ToString(reader["booking_num"]),
                            agent_no = Convert.ToString(reader["agent_no"]),
                            isDirect = Convert.ToString(reader["isDirect"]),
                            agent_name = Convert.ToString(reader["agent_name"]),
                            shipper_account_number = Convert.ToString(reader["shipper_acct_num"]),
                            shipper_name = Convert.ToString(reader["shipper_name"]),
                            invoice_no = Convert.ToString(reader["invoice_no"]),
                            agent_email = Convert.ToString(reader["agent_email"]),
                            shipper_email = Convert.ToString(reader["shipper_email"]),
                            edt = Convert.ToString(reader["edt"]),
                            agent_elt_acct = Convert.ToString(reader["agent_elt_acct"]),
                            MsgTxt = Convert.ToString(reader["MsgTxt"]),
                            master_agent = Convert.ToString(reader["master_agent"])
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
