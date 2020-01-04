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
    public class MessagesDA : DABase
    {
      
        public int CreateFileAttachmentGroup( string OriginatorEmail, string ReferenceNo, int ReferenceType)
        {

            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[COMM].[CreateFileAttachmentGroup]" };
            List<ELTFileSystemItem> list = new List<ELTFileSystemItem>();
            int GID = 0;
            try
            {

                cmd.Parameters.Add(new SqlParameter("@GID", GID));     
                cmd.Parameters.Add(new SqlParameter("@OriginatorEmail", OriginatorEmail));
                cmd.Parameters.Add(new SqlParameter("@ReferenceNo", ReferenceNo));
                cmd.Parameters.Add(new SqlParameter("@ReferenceType", ReferenceType));
                cmd.Parameters["@GID"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@GID"].Size = 100;
                conn.Open();
                cmd.ExecuteNonQuery();
                GID = Convert.ToInt32(cmd.Parameters["@GID"].Value);
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

            return GID;
        }

        public List<AttachmentLog> GetAttachmentLog(int GID)
        {
            List<AttachmentLog> ListAttachmentLog = new List<AttachmentLog>();
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "COMM.[GetFileAttachmentLog]" };
           
            try
            {
                cmd.Parameters.Add(new SqlParameter("@GID", GID));
                
                
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ListAttachmentLog.Add(new AttachmentLog() { ID = Convert.ToInt32(reader["ID"]), FileID = Convert.ToInt32(reader["FileID"]), GID = Convert.ToInt32(reader["GID"]), RecipientEmail = Convert.ToString(reader["RecipientEmail"]), IsDelivered = Convert.ToBoolean(reader["IsDelivered"]), SenderEmail = Convert.ToString(reader["SenderEmail"]), ReferenceNo = Convert.ToString(reader["ReferenceNo"]) });
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
            return ListAttachmentLog;     

        }

        public int LogFileAttachment(string Name, int FileID, int GID,  string RecipientEmail)
        {

            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[COMM].[LogFileAttachment]" };
            List<ELTFileSystemItem> list = new List<ELTFileSystemItem>();
          
            try
            {      
                cmd.Parameters.Add(new SqlParameter("@GID", GID));
                cmd.Parameters.Add(new SqlParameter("@Name", Name));
                cmd.Parameters.Add(new SqlParameter("@RecipientEmail", RecipientEmail));
                cmd.Parameters.Add(new SqlParameter("@FileID", FileID));             
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

            return GID;
        }

        public void CopyAttachment(int GID, string RecipientEmail, int ParentID)
        {

            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "[COMM].[CopyAttachments]" };
            List<ELTFileSystemItem> list = new List<ELTFileSystemItem>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@GID", GID));               
                cmd.Parameters.Add(new SqlParameter("@RecipientEmail", RecipientEmail));
                cmd.Parameters.Add(new SqlParameter("@ParentID", ParentID));
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

        public List<string> GetAllMailNodes(string account_email)
        {

            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "COMM.[GetAllMailNodes]" };
            List<string> list = new List<string>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@account_email", account_email));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                   
                        list.Add(Convert.ToString(reader["Folder"]));
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
        public List<Message> UnreadMessages(string account_email)
        {

            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "COMM.[GetUnreadMessages]" };
            List<Message> list = new List<Message>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@account_email", account_email));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        Message item = new Message()
                        {

                            ID = Convert.ToInt32(reader["ID"]),
                            Date = Convert.ToDateTime(reader["Date"]),
                            Subject = Convert.ToString(reader["Subject"]),
                            From = Convert.ToString(reader["From"]),
                            To = Convert.ToString(reader["To"]),
                            Text = Convert.ToString(reader["Text"]),
                            Folder = Convert.ToString(reader["Folder"]),
                            Unread = Convert.ToBoolean(reader["Unread"]),
                            HasAttachment = Convert.ToBoolean(reader["HasAttachment"]),
                            IsReply = Convert.ToBoolean(reader["IsReply"]),

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
        public List<Message> GetAllMessages(string account_email)
        {

            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "COMM.[GetAllMessages]" };
            List<Message> list = new List<Message>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@account_email", account_email));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
     
                        Message item = new Message()
                        {

                            ID = Convert.ToInt32(reader["ID"]),
                            Date = Convert.ToDateTime(reader["Date"]),
                            Subject = Convert.ToString(reader["Subject"]),
                            From = Convert.ToString(reader["From"]),
                            To = Convert.ToString(reader["To"]),
                            Text = Convert.ToString(reader["Text"]),
                            Folder = Convert.ToString(reader["Folder"]),
                            Unread = Convert.ToBoolean(reader["Unread"]),
                            HasAttachment = Convert.ToBoolean(reader["HasAttachment"]),
                            IsReply = Convert.ToBoolean(reader["IsReply"]),

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
        public  void AddMessage(string subject, string from, string to, string text, string folder, bool isReply) {

            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "COMM.AddMessage" };

            try
            {
                cmd.Parameters.Add(new SqlParameter("@subject", subject));
                cmd.Parameters.Add(new SqlParameter("@from", from));
                cmd.Parameters.Add(new SqlParameter("@to", to));
                cmd.Parameters.Add(new SqlParameter("@text", text));
                cmd.Parameters.Add(new SqlParameter("@folder", folder));
                cmd.Parameters.Add(new SqlParameter("@isReply", isReply));  
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
        public  void UpdateMessage(int id, string subject, string to, string text, string folder) {
        
         SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "COMM.UpdateMessage" };

            try
            {
                cmd.Parameters.Add(new SqlParameter("@id", subject));
                cmd.Parameters.Add(new SqlParameter("@subject", subject));
                cmd.Parameters.Add(new SqlParameter("@to", to));
                cmd.Parameters.Add(new SqlParameter("@text", text));
                cmd.Parameters.Add(new SqlParameter("@folder", folder));

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
            }
               
        
        }
        public  void MarkMessagesAs(bool read, IEnumerable<int> ids)
        {

            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "COMM.MarkMessagesAs" };

            conn.Open();
            try
            {
                foreach (int id in ids)
                {
                    cmd.Parameters.Add(new SqlParameter("@id", id));
                    cmd.Parameters.Add(new SqlParameter("@unread", !read));
                    cmd.ExecuteNonQuery();                    
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
        
        }
        public  void DeleteMessages(IEnumerable<int> ids)
        {

            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "COMM.DeleteMessage" };
            try
            {
                conn.Open();
                foreach (int id in ids)
                {

                    cmd.Parameters.Add(new SqlParameter("@id", id));                  
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {

                conn.Close(); conn.Dispose();
            }
                  
               

        }
       
    }





}


