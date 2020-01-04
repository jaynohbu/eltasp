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
using System.Data.Linq;
using System.Data.SqlTypes;
namespace ELT.DA
{
    public class FileSystemDA : DABase
    {
        public int GetRootFileItemID(string UserEmail)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.GetRootFileItemID" };
            List<ELTFileSystemItem> list = new List<ELTFileSystemItem>();
            int ID = 0;
            try
            {
                cmd.Parameters.Add(new SqlParameter("@UserEmail", UserEmail));            
                cmd.Parameters.Add(new SqlParameter("@ID", ID));
               
                cmd.Parameters["@ID"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@ID"].Size = 100;
                conn.Open();
                cmd.ExecuteNonQuery();
                ID = Convert.ToInt32(cmd.Parameters["@ID"].Value);
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
            return ID;

        }
        public void InsertFile(ELTFileSystemItem newFile){
        
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.CreateFile" };
            List<ELTFileSystemItem> list = new List<ELTFileSystemItem>();

            try
            {

                cmd.Parameters.Add(new SqlParameter("@Name", newFile.Name));
                cmd.Parameters.Add(new SqlParameter("@ParentID", newFile.ParentID));
                if (!newFile.IsFolder)
                {
                    cmd.Parameters.Add(new SqlParameter("@Data", (SqlBinary)newFile.Data.ToArray()));
                }
                cmd.Parameters.Add(new SqlParameter("@IsFolder", newFile.IsFolder));
                cmd.Parameters.Add(new SqlParameter("@CreatorEmail", newFile.Owner_Email));
                cmd.Parameters.Add(new SqlParameter("@ID", newFile.ID));
                cmd.Parameters["@ID"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@ID"].Size = 100;                
                conn.Open();
                cmd.ExecuteNonQuery();
                newFile.ID = Convert.ToInt32(cmd.Parameters["@ID"].Value);
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
        public ELTFileSystemItem CopyFile(ELTFileSystemItem oldFile, int ParentID)
        {
            
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.CreateFile" };
            List<ELTFileSystemItem> list = new List<ELTFileSystemItem>();
            ELTFileSystemItem newFile = new ELTFileSystemItem() { IsFolder = oldFile.IsFolder, Data = oldFile.Data, LastWriteTime = oldFile.LastWriteTime, Name = oldFile.Name , ParentID = ParentID };

            try
            {

                cmd.Parameters.Add(new SqlParameter("@Name", oldFile.Name));
                cmd.Parameters.Add(new SqlParameter("@ParentID", ParentID));
                cmd.Parameters.Add(new SqlParameter("@IsFolder", oldFile.IsFolder));
                cmd.Parameters.Add(new SqlParameter("@CreatorEmail", oldFile.Owner_Email));
                cmd.Parameters.Add(new SqlParameter("@FromID", oldFile.ID));
                cmd.Parameters.Add(new SqlParameter("@ID", 0));
                cmd.Parameters["@ID"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@ID"].Size = 100;
                conn.Open();
                cmd.ExecuteNonQuery();
                newFile.ID = Convert.ToInt32(cmd.Parameters["@ID"].Value);
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
            return newFile;
        }
        public List<ELTFileSystemItem> GetFiles(string OwnerEmail)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.GetFiles" };
            List<ELTFileSystemItem> list = new List<ELTFileSystemItem>();

            try
            {

                cmd.Parameters.Add(new SqlParameter("@OwnerEmail", OwnerEmail));
            
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        ELTFileSystemItem item = new ELTFileSystemItem()
                        {

                            ID = Convert.ToInt32(reader["ID"]),
                        
                            Data = reader["Data"].GetType() == typeof(System.DBNull) ? null : new System.Data.Linq.Binary((System.Byte[])reader["Data"]),
                            IsFolder = Convert.ToBoolean(reader["IsFolder"]),
                            LastWriteTime = Convert.ToDateTime(reader["LastWriteTime"]),
                            Name = Convert.ToString(reader["Name"]),
                            ParentID = Convert.ToInt32(reader["ParentID"])
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

        public ELTFileSystemItem GetFileByID(int FileID)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.GetFileByID" };
            List<ELTFileSystemItem> list = new List<ELTFileSystemItem>();

            try
            {

                cmd.Parameters.Add(new SqlParameter("@FileID", FileID));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        ELTFileSystemItem item = new ELTFileSystemItem()
                        {

                            ID = Convert.ToInt32(reader["ID"]),

                            Data = reader["Data"].GetType() == typeof(System.DBNull) ? null : new System.Data.Linq.Binary((System.Byte[])reader["Data"]),
                            IsFolder = Convert.ToBoolean(reader["IsFolder"]),
                            LastWriteTime = Convert.ToDateTime(reader["LastWriteTime"]),
                            Name = Convert.ToString(reader["Name"]),
                            ParentID = Convert.ToInt32(reader["ParentID"])
                        };
                        return item;
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
            return null;
        }

        public int GetFileIDforParentID(string OwnerEmail, int ParentID)
        {
            int FileID = 0;
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.GetFileIDforParentID" };
            List<ELTFileSystemItem> list = new List<ELTFileSystemItem>();

            try
            {

                cmd.Parameters.Add(new SqlParameter("@OwnerEmail", OwnerEmail));
                cmd.Parameters.Add(new SqlParameter("@ParentID", ParentID));

                cmd.Parameters.Add(new SqlParameter("@ID", FileID));
                cmd.Parameters["@ID"].Direction = ParameterDirection.InputOutput;
                cmd.Parameters["@ID"].Size = 100;
                conn.Open();
                cmd.ExecuteNonQuery();
                FileID = Convert.ToInt32(cmd.Parameters["@ID"].Value);
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
            return FileID;
        }
    
    }


}


