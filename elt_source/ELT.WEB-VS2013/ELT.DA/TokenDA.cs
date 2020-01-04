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
    public class TokenDA : DABase
    {
        public void CreateToken(ref string Token, TokenType TokenType, string RecipientEmail, bool NoStart, int Period)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[COMM].[AccessCommunicationToken]" };
            List<ELTFileSystemItem> list = new List<ELTFileSystemItem>();
      
            try
            {
                string Command = "Create";
                if (NoStart) Command = "CreateNoStart";
                DateTime TimeStart=DateTime.Now;
                DateTime CreatedDate = DateTime.Now;
                DateTime TimeEnd = DateTime.Now;
                bool Expired = false;
          
               
                cmd.Parameters.Add(new SqlParameter("@Command", Command));
                cmd.Parameters.Add(new SqlParameter("@Token", Token));
                cmd.Parameters.Add(new SqlParameter("@TokenType", TokenType));
                cmd.Parameters.Add(new SqlParameter("@TimeStart", TimeStart));
                cmd.Parameters.Add(new SqlParameter("@TimeEnd", TimeEnd));
                cmd.Parameters.Add(new SqlParameter("@Period", Period));
                cmd.Parameters.Add(new SqlParameter("@Expired", Expired));
                cmd.Parameters.Add(new SqlParameter("@RecipientEmail", RecipientEmail));
                cmd.Parameters.Add(new SqlParameter("@CreatedDate", CreatedDate));

                cmd.Parameters["@Token"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@Token"].Size = 1000;

                cmd.Parameters["@TokenType"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@TokenType"].Size = 100;

                cmd.Parameters["@TimeStart"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@TimeStart"].Size = 100;

                cmd.Parameters["@TimeEnd"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@TimeEnd"].Size = 100;

                cmd.Parameters["@Period"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@Period"].Size = 100;

                cmd.Parameters["@Expired"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@Expired"].Size = 100;

                cmd.Parameters["@RecipientEmail"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@RecipientEmail"].Size = 100;

                cmd.Parameters["@CreatedDate"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@CreatedDate"].Size = 100;


                conn.Open();
                cmd.ExecuteNonQuery();
                Token = Convert.ToString(cmd.Parameters["@Token"].Value);
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

      
        public ELTToken GetToken(string Token)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[COMM].[AccessCommunicationToken]" };
            List<ELTFileSystemItem> list = new List<ELTFileSystemItem>();
        
            ELTToken token = new ELTToken();
            try
            {
                string Command = "Get";
                
                DateTime TimeStart = DateTime.Now;
                DateTime CreatedDate = DateTime.Now;
                DateTime TimeEnd = DateTime.Now;
                bool Expired = false;
                int TokenType=0;
                string RecipientEmail = string.Empty;
                int Period = 0;
                cmd.Parameters.Add(new SqlParameter("@Command", Command));
                cmd.Parameters.Add(new SqlParameter("@Period", Period));
                cmd.Parameters.Add(new SqlParameter("@Token", Token));
                cmd.Parameters.Add(new SqlParameter("@TokenType", TokenType));
                cmd.Parameters.Add(new SqlParameter("@TimeStart", TimeStart));
                cmd.Parameters.Add(new SqlParameter("@TimeEnd", TimeEnd));
                cmd.Parameters.Add(new SqlParameter("@Expired", Expired));        
                cmd.Parameters.Add(new SqlParameter("@RecipientEmail", RecipientEmail));
                cmd.Parameters.Add(new SqlParameter("@CreatedDate", CreatedDate));

                cmd.Parameters["@Token"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@Token"].Size = 1000;

                cmd.Parameters["@TokenType"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@TokenType"].Size = 100;

                cmd.Parameters["@TimeStart"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@TimeStart"].Size = 100;

                cmd.Parameters["@TimeEnd"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@TimeEnd"].Size = 100;

                cmd.Parameters["@Expired"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@Expired"].Size = 100;

                cmd.Parameters["@Expired"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@Expired"].Size = 100;

                cmd.Parameters["@RecipientEmail"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@RecipientEmail"].Size = 100;

                cmd.Parameters["@CreatedDate"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@CreatedDate"].Size = 100;
                conn.Open();
                cmd.ExecuteNonQuery();

                token.Token = Convert.ToString(cmd.Parameters["@Token"].Value);
                token.RecipientEmail = Convert.ToString(cmd.Parameters["@RecipientEmail"].Value);
                token.TokenType = (TokenType)Convert.ToInt32(cmd.Parameters["@TokenType"].Value);
                token.Expired =  Convert.ToBoolean(cmd.Parameters["@Expired"].Value);
                token.TimeStart = cmd.Parameters["@TimeStart"].Value.GetType() 
                    == typeof(System.DBNull) ? new DateTime(): Convert.ToDateTime(cmd.Parameters["@TimeStart"].Value);
                token.TimeEnd = cmd.Parameters["@TimeEnd"].Value.GetType()
                    == typeof(System.DBNull) ? new DateTime() : Convert.ToDateTime(cmd.Parameters["@TimeEnd"].Value);
                token.CreatedDate = Convert.ToDateTime(cmd.Parameters["@CreatedDate"].Value);
                token.Period = Convert.ToInt32(cmd.Parameters["@Period"].Value);

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


            return token;
        }
       
       
    }





}


