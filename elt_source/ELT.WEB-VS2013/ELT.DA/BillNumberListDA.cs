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
    public class BillNumberListDA : DABase
    {
        public List<TextValuePair> GetHAWBNos(string ELT_account_number, string PortDirection)
        {         
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "DataList.GetHAWBNos" };
            List<TextValuePair> list = new List<TextValuePair>();
            try
            {
                cmd.Parameters.Add(new SqlParameter("@ELT_account_number", ELT_account_number));
                cmd.Parameters.Add(new SqlParameter("@PortDirection", PortDirection));
                conn.Open();              
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        TextValuePair item = new TextValuePair() { Text= Convert.ToString(reader["HAWB_NUM"]), Value=Convert.ToString(reader["HAWB_NUM"]) };
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
        public List<TextValuePair> GetMAWBNos(string ELT_account_number,string PortDirection)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "DataList.GetMAWBNos" };
            List<TextValuePair> list = new List<TextValuePair>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@ELT_account_number", ELT_account_number));
                cmd.Parameters.Add(new SqlParameter("@PortDirection", PortDirection));
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        TextValuePair item = new TextValuePair() { Text = Convert.ToString(reader["MAWB_NUM"]), Value = Convert.ToString(reader["MAWB_NUM"]) };
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
        public List<TextValuePair> GetHBOLNos(string ELT_account_number, string PortDirection)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "DataList.GetHBOLNos" };
            List<TextValuePair> list = new List<TextValuePair>();
            try
            {
                cmd.Parameters.Add(new SqlParameter("@ELT_account_number", ELT_account_number));
                cmd.Parameters.Add(new SqlParameter("@PortDirection", PortDirection));
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        TextValuePair item = new TextValuePair() { Text = Convert.ToString(reader["HBOL_NUM"]), Value = Convert.ToString(reader["HBOL_NUM"]) };
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
        public List<TextValuePair> GetMBOLNos(string ELT_account_number, string PortDirection)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "DataList.GetMBOLNos" };
            List<TextValuePair> list = new List<TextValuePair>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@ELT_account_number", ELT_account_number));
                cmd.Parameters.Add(new SqlParameter("@PortDirection", PortDirection));
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        TextValuePair item = new TextValuePair() { Text = Convert.ToString(reader["MBOL_NUM"]), Value = Convert.ToString(reader["MBOL_NUM"]) };
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
        public List<TextValuePair> GetOceanExportFileNumbers(string ELT_account_number)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "DataList.GetOceanExportFileNumbers" };
            List<TextValuePair> list = new List<TextValuePair>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@ELT_account_number", ELT_account_number));

                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        TextValuePair item = new TextValuePair() { Text = Convert.ToString(reader["file_no"]), Value = Convert.ToString(reader["file_no"]) };


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
        public List<TextValuePair> GetAirExportFileNumbers(string ELT_account_number)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "DataList.GetAirExportFileNumbers" };
            List<TextValuePair> list = new List<TextValuePair>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@ELT_account_number", ELT_account_number));
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        TextValuePair item = new TextValuePair() { Text = Convert.ToString(reader["FILE#"]), Value = Convert.ToString(reader["FILE#"]) };

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
        public List<TextValuePair> GetImportFileNumbers(string ELT_account_number, string iType)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "DataList.GetAirImportFileNumbers" };
            List<TextValuePair> list = new List<TextValuePair>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@ELT_account_number", ELT_account_number));
                cmd.Parameters.Add(new SqlParameter("@iType", iType));
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        TextValuePair item = new TextValuePair() { Text = Convert.ToString(reader["file_no"]), Value = Convert.ToString(reader["FILE#"]) };

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
