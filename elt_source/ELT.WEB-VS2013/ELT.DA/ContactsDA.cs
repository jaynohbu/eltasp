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
    public class ContactsDA : DABase
    {
        public List<ContactCity> GetCities(string country)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "CRM.[GetCities]" };
            List<ContactCity> list = new List<ContactCity>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@country", country));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        ContactCity item = new ContactCity() { City = Convert.ToString(reader["City"]) };
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
        public List<Contact> GetAllContacts(string account_email)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "CRM.[GetAllContacts]" };
            List<Contact> list = new List<Contact>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@account_email", account_email));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        Contact item = new Contact()
                        {

                            ID = Convert.ToInt32(reader["ID"]),
                            Name = Convert.ToString(reader["Name"]),
                            Email = Convert.ToString(reader["Email"]),
                            Address = Convert.ToString(reader["Address"]),
                            Country = Convert.ToString(reader["Country"]),
                            City = Convert.ToString(reader["City"]),
                            Phone = Convert.ToString(reader["Phone"]),
                            PhotoUrl = Convert.ToString(reader["PhotoUrl"]),
                            Collected = Convert.ToBoolean(reader["Collected"])    
                        
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
        
        public void AddContact(string name, string email, string address, string country, string city, string phone, string photoUrl)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "CRM.AddContact" };

            try
            {
               
                cmd.Parameters.Add(new SqlParameter("@name", name));
                cmd.Parameters.Add(new SqlParameter("@email", email));
                cmd.Parameters.Add(new SqlParameter("@address", address));
                cmd.Parameters.Add(new SqlParameter("@country", country));
                cmd.Parameters.Add(new SqlParameter("@city", city));
                cmd.Parameters.Add(new SqlParameter("@phone", phone));
                cmd.Parameters.Add(new SqlParameter("@city", city));
                cmd.Parameters.Add(new SqlParameter("@photoUrl", photoUrl));

                conn.Open();

                cmd.ExecuteNonQuery();

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
        }
        public  void UpdateContact(int id, string name, string email, string address, string country, string city, string phone, string photoUrl)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "CRM.UpdateContact" };           

            try
            {
                cmd.Parameters.Add(new SqlParameter("@id", id));
                cmd.Parameters.Add(new SqlParameter("@name", name));
                cmd.Parameters.Add(new SqlParameter("@email", email));
                cmd.Parameters.Add(new SqlParameter("@address", address));
                cmd.Parameters.Add(new SqlParameter("@country", country));
                cmd.Parameters.Add(new SqlParameter("@city", city));
                cmd.Parameters.Add(new SqlParameter("@phone", phone));               
                cmd.Parameters.Add(new SqlParameter("@photoUrl", photoUrl));  

                conn.Open();

                cmd.ExecuteNonQuery();
               
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
           
       
        }
        public  void DeleteContact(int id)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "CRM.DeleteContact" };
            try
            {

                cmd.Parameters.Add(new SqlParameter("@id", id));
                conn.Open();
                cmd.ExecuteNonQuery();

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

        }       
        public List<ContactCountry> GetCountries()
        {
            List<ContactCountry> list = new List<ContactCountry>();
            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Cmd.CommandText = " SELECT * FROM [Countries]";
      
            try
            {
                Con.Open();
                SqlDataReader reader = Cmd.ExecuteReader();
                while (reader.Read())
                {
                    ContactCountry item = new ContactCountry() { Country = Convert.ToString(reader["Country"]), CountryId = Convert.ToInt32(reader["CountryId"]), CapitalId = Convert.ToInt32(reader["CapitalId"]) };
                    list.Add(item);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return list;
        }  
    }





}


