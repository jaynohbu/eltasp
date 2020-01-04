using ELT.CDT;
using ELT.COMMON;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
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
    public class CodeListDA: DABase
    {
        public List<TextValuePair> GetCarrierList(int elt_account_number)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.Text, CommandText = string.Format(SQLConstants.SELECT_LIST_CARRIERS, elt_account_number.ToString()) };
            List<TextValuePair> list = new List<TextValuePair>();
            try
            {
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        TextValuePair item = new TextValuePair() { Text = Convert.ToString(reader["carrier_name"]), Value = Convert.ToString(reader["org_account_number"]) };
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
        public List<TextValuePair> GetPortList(int elt_account_number)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.Text, CommandText = string.Format(SQLConstants.SELECT_LIST_PORT, elt_account_number.ToString()) };
            List<TextValuePair> list = new List<TextValuePair>();
            try
            {
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        TextValuePair item = new TextValuePair() { Text = Convert.ToString(reader["port_name"]), Value = Convert.ToString(reader["port_code"]) };
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
