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
    public class DomesticFreightDA:DABase
    {
        public List<ManifestAgentInfo> GetAgentsInDmMAWB(int ELT_ACCOUNT_NUMBER, string mawb)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.[GetAgentsInMAWB]" };
            List<ManifestAgentInfo> list = new List<ManifestAgentInfo>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@ELT_ACCOUNT_NUMBER", ELT_ACCOUNT_NUMBER));
                cmd.Parameters.Add(new SqlParameter("@MAWB", mawb));               
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

        public List<DomesticFreightDocument> GetDomesticFreightDocumentList(int ELT_ACCOUNT_NUMBER, string BillNum, string BillType)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.[GetDomesticFreightDocumentList]" };
            List<DomesticFreightDocument> list = new List<DomesticFreightDocument>();

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

                        DomesticFreightDocument item = new DomesticFreightDocument()
                        {
                            hawb_num = Convert.ToString(reader["hawb_num"]),
                            mawb_num = Convert.ToString(reader["mawb_num"]),
                            agent_no = Convert.ToString(reader["agent_no"]),
                            isDirect = Convert.ToString(reader["isDirect"]),
                            agent_name = Convert.ToString(reader["agent_name"]),
                            invoice_no = Convert.ToString(reader["invoice_no"]),
                            shipper_account_number = Convert.ToString(reader["shipper_account_number"]),
                            shipper_name = Convert.ToString(reader["shipper_name"]),
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
