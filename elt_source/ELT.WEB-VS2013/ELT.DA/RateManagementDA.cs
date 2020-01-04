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

namespace ELT.DA
{
   public  class RateManagementDA:DABase
    {
     
       public List<FlattenRateItem> GetAllRate(int elt_account_number, int customer_org_num, int rate_type)
       {
           SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
           SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.[GetAllRate]" };
           List<FlattenRateItem> list = new List<FlattenRateItem>();

           try
           {
               cmd.Parameters.Add(new SqlParameter("@elt_account_number", elt_account_number));
               cmd.Parameters.Add(new SqlParameter("@org_account_number", customer_org_num));
               cmd.Parameters.Add(new SqlParameter("@rate_type", rate_type));
               conn.Open();

               using (SqlDataReader reader = cmd.ExecuteReader())
               {
                   while (reader.Read())
                   {
                       var item = new FlattenRateItem()
                       {
                            id = Convert.ToInt32(reader["id"]),
                            elt_account_number = Convert.ToInt32(reader["elt_account_number"]),
                            item_no = Convert.ToInt32(reader["item_no"]),
                            rate_type = Convert.ToInt32(reader["rate_type"]),
                            agent_no = reader["agent_no"].GetType()== typeof(System.DBNull) ?0: Convert.ToInt32(reader["agent_no"]),
                            customer_no = reader["customer_no"].GetType() == typeof(System.DBNull) ? 0 : Convert.ToInt32(reader["customer_no"]),
                            carrier = Convert.ToInt32(reader["airline"]),
                            origin_port = Convert.ToString(reader["origin_port"]),
                            dest_port = Convert.ToString(reader["dest_port"]),
                            weight_break = Convert.ToString(reader["weight_break"]),
                            rate = Convert.ToDecimal(reader["rate"]),
                            kg_lb = Convert.ToString(reader["kg_lb"]),
                            share = Convert.ToInt32(reader["share"]),
                            is_org_merged = Convert.ToString(reader["is_org_merged"]),
                            fl_rate = Convert.ToString(reader["fl_rate"]),
                            sec_rate = Convert.ToString(reader["sec_rate"]),
                            include_fl_rate = Convert.ToString(reader["include_fl_rate"]),
                            include_sec_rate = Convert.ToString(reader["include_sec_rate"]),
                            dba_name = Convert.ToString(reader["dba_name"])
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

       public void SaveRate(int elt_account_number, int customer_org_num, int rate_type, List<FlattenRateItem> list)
       {
			string strInsert=SQLConstants.RATE_MANAGEMENT_INSERT_RATE;

			SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
			SqlCommand		Cmd = new SqlCommand();
			Cmd.Connection = Con;
			Con.Open();		
			SqlTransaction trans = Con.BeginTransaction();
			Cmd.Transaction = trans;
			try
            {
                Cmd.CommandText = "DELETE all_rate_table  WHERE  elt_account_number=" + elt_account_number;
                switch (rate_type)
                {
                    #region // delete
                    case 4: // Customer Selling Rate	
                        Cmd.CommandText = Cmd.CommandText +
                            " AND rate_type=4 ";
                        if (customer_org_num != 0)
                        {
                            Cmd.CommandText = Cmd.CommandText + " AND customer_no=" + customer_org_num;
                        }
                        break;
                    case 3: // Airline Buying Rate			: '3' in Oiginal table
                        Cmd.CommandText = Cmd.CommandText +
                            " AND rate_type=3 AND agent_no=0 AND customer_no=0";
                        break;
                    case 1: // Agent Buying Rate			: '1' in Oiginal table
                        Cmd.CommandText = Cmd.CommandText +
                            " AND rate_type=1 ";
                        if (customer_org_num != 0)
                        {
                            Cmd.CommandText = Cmd.CommandText + " AND agent_no=" + customer_org_num;
                        }
                        break;
                    case 5: // IATA Rate						: '5' in Oiginal table
                        Cmd.CommandText = Cmd.CommandText +
                            " AND rate_type=5 AND agent_no=0 AND customer_no=0";
                        break;
                    default:
                        break;
                    #endregion
                }

                Cmd.ExecuteNonQuery();               
                  

                for (int i = 0; i < list.Count; i++)
                {
					Cmd.CommandText = strInsert;
					Cmd.Parameters.Clear();
                    Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal, 9).Value = elt_account_number;                  
                    Cmd.Parameters.Add("@item_no", SqlDbType.Decimal, 9).Value = list[i].item_no;
                    Cmd.Parameters.Add("@rate_type", SqlDbType.Decimal, 9).Value = list[i].rate_type;
                    Cmd.Parameters.Add("@agent_no", SqlDbType.Decimal, 4).Value = list[i].agent_no;
                    Cmd.Parameters.Add("@customer_no", SqlDbType.Decimal, 4).Value = list[i].customer_no;
                    Cmd.Parameters.Add("@airline", SqlDbType.Decimal, 8).Value = list[i].carrier;
                    Cmd.Parameters.Add("@origin_port", SqlDbType.NVarChar, 8).Value = list[i].origin_port;
                    Cmd.Parameters.Add("@dest_port", SqlDbType.NVarChar, 8).Value = list[i].dest_port;                         
                    Cmd.Parameters.Add("@weight_break", SqlDbType.Decimal, 9).Value = double.Parse(list[i].weight_break);
                    Cmd.Parameters.Add("@rate", SqlDbType.Decimal, 9).Value = list[i].rate;
                    Cmd.Parameters.Add("@kg_lb", SqlDbType.NChar, 1).Value = list[i].kg_lb;
                    Cmd.Parameters.Add("@share", SqlDbType.Decimal, 9).Value =list[i].share;

					Cmd.ExecuteNonQuery();
                 
				}

				trans.Commit();

			}
			catch(Exception ex)
			{
				trans.Rollback();
                throw ex;
			}
			finally
			{
                Con.Close();
				Con.Dispose();
			}
			
		}       
    }
}
