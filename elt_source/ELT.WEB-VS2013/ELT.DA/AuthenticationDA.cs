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
   public  class AuthenticationDA:DABase
    {   
     
       public List<AuthorizedPage> GetAuthorizedPages(int elt_account_number, int user_id)
       {
           List<AuthorizedPage> result = new List<AuthorizedPage>();
           SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
           SqlCommand cmd = new SqlCommand();
           cmd.Connection = conn;
           cmd.CommandType = CommandType.StoredProcedure;
           cmd.CommandText = "dbo.GetAllUserAuthorizedPages";

           cmd.Parameters.Add(new SqlParameter("@elt_account_number", elt_account_number));
           cmd.Parameters.Add(new SqlParameter("@user_id", user_id));
           try
           {
               conn.Open();
               SqlDataReader reader = cmd.ExecuteReader();
               while (reader.Read())
               {
                   AuthorizedPage aPage = new AuthorizedPage();
                   aPage.is_accessible = !Convert.ToBoolean(reader["is_bloked"]);
                   aPage.page_id = Convert.ToInt32(reader["page_id"]);
                   aPage.page_label = Convert.ToString(reader["page_label"]);
                   aPage.sub_module = Convert.ToString(reader["sub_module"]);
                   aPage.top_module = Convert.ToString(reader["top_module"]);
                   aPage.user_id = user_id;
                   result.Add(aPage);
               }
           }
           catch
           {


           }
           finally
           {
               conn.Close();
               conn.Dispose();

           } 
           return result;
       }

       public void UpdateAuthorizePage(int elt_account_number, int user_id, List<AuthorizedPage> pages)
       {
         
           SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
         
           try
           {
               conn.Open();
               foreach (var page in pages)
               {
                   SqlCommand cmd = new SqlCommand();
                   cmd.Connection = conn;
                   cmd.CommandType = CommandType.StoredProcedure;
                   cmd.CommandText = "dbo.UpdateAuthorizePage";
                   cmd.Parameters.Add(new SqlParameter("@elt_account_number", elt_account_number));
                   cmd.Parameters.Add(new SqlParameter("@user_id", user_id));
                   cmd.Parameters.Add(new SqlParameter("@page_id", page.page_id));
                   cmd.Parameters.Add(new SqlParameter("@is_bloked", !page.is_accessible));
                   cmd.ExecuteNonQuery();
                   cmd.Dispose();
               }
           }
           catch
           {
              
               
           }
           finally
           {
               conn.Close();
               conn.Dispose();
           }  
       }
       public bool CheckLogin(int elt_account_number, string login_name, string password)
       {
           var con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
           var cmd = new SqlCommand
           {
               Connection = con,
               CommandText =
                   "SELECT count(*) as ct FROM [dbo].[users] WHERE  [elt_account_number] ={0} AND [login_name] = '{1}' AND [password] ='{2}'"
           };
           cmd.CommandText = string.Format(cmd.CommandText, elt_account_number, login_name, password);
           try
           {
               con.Open();
               var reader = cmd.ExecuteReader();
               if (reader.Read())
               {
                   var count = Convert.ToInt32(reader["ct"]);
                   if (count > 0) return true;

               }
           }
           catch (Exception ex)
           {
               throw;
           }
           finally
           {
               con.Close();
               con.Dispose();
           }
           return false;
       }

      

       public bool CheckProfileExist(int elt_account_number, string login_name)
       {
           var con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
           var cmd = new SqlCommand
           {
               Connection = con,
               CommandText =
                   "SELECT COUNT(*) as ct FROM [dbo].[UserProfile] WHERE  [elt_account_number]={0} and [UserName] ='{1}' "
           };
           cmd.CommandText = string.Format(cmd.CommandText, elt_account_number, login_name);
           try
           {
               con.Open();
               var reader = cmd.ExecuteReader();
               if (reader.Read())
               {
                   var count = Convert.ToInt32(reader["ct"]);
                   if (count > 0) return true;

               }
           }
           catch (Exception ex)
           {
               throw;
           }
           finally
           {
               con.Close();
               con.Dispose();
           }
           return false;
       }
       public bool InitAuthorizePage(int elt_account_number, int user_id, int user_type)
       {
           SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));

           try
           {
               conn.Open();

               SqlCommand cmd = new SqlCommand();
               cmd.Connection = conn;
               cmd.CommandType = CommandType.StoredProcedure;
               cmd.CommandText = "dbo.InitUserPageAccess";
               cmd.Parameters.Add(new SqlParameter("@elt_account_number", elt_account_number));
               cmd.Parameters.Add(new SqlParameter("@user_id", user_id));
               cmd.Parameters.Add(new SqlParameter("@user_type", user_type));
               cmd.ExecuteNonQuery();
               return true;
           }
           catch
           {


           }
           finally
           {
               conn.Close();
               conn.Dispose();
           }
           return false;
       }

       public void CopyUser(int elt_account_number,string FromAccount, string ToAccount)
       {
           SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));

           try
           {
               conn.Open();

               SqlCommand cmd = new SqlCommand();
               cmd.Connection = conn;
               cmd.CommandType = CommandType.StoredProcedure;
               cmd.CommandText = "dbo.CopyUser";
               cmd.Parameters.Add(new SqlParameter("@FromAccount", FromAccount));
               cmd.Parameters.Add(new SqlParameter("@ToAccount", ToAccount));
               cmd.Parameters.Add(new SqlParameter("@elt_account_number", elt_account_number));             
               cmd.ExecuteNonQuery();
             
           }
           catch
           {


           }
           finally
           {
               conn.Close();
               conn.Dispose();
           }
          
       }





       public string GetEltLoginName(int elt_account_number, int userid)
       {
           SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
           SqlCommand Cmd = new SqlCommand();
           Cmd.Connection = Con;
           Cmd.CommandText = " SELECT login_name from users where users.elt_account_number='" + elt_account_number + "' AND userid='" + userid + "'";
           string login_name = "";
           try
           {
               Con.Open();
               SqlDataReader reader = Cmd.ExecuteReader();
               if (reader.Read())
               {
                   login_name = Convert.ToString(reader["login_name"]);
                  
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
           finally
           {
               Con.Close();
               Con.Dispose();
           }
           return login_name;

       }
       public ELTUser GetELTUser(string elt_account_number, int user_id)
       {
           SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
           SqlCommand Cmd = new SqlCommand();
           Cmd.Connection = Con;
           Cmd.CommandText = " SELECT Users.*, agent.dba_name, agent.board_name from USERS left outer join agent on agent.elt_account_number = users.elt_account_number where users.elt_account_number='" + elt_account_number + "' AND userid='" + user_id + "'";
           ELTUser User = new ELTUser();
           try
           {
               Con.Open();
               SqlDataReader reader = Cmd.ExecuteReader();
               if (reader.Read())
               {
                   User.add_to_label = Convert.ToString(reader["add_to_label"]);
                   User.awb_port = Convert.ToString(reader["awb_port"]);
                   User.awb_prn_name = Convert.ToString(reader["awb_prn_name"]);
                   User.awb_queue = Convert.ToString(reader["awb_queue"]);
                   User.bol_port = Convert.ToString(reader["bol_port"]);
                   User.bol_prn_name = Convert.ToString(reader["bol_prn_name"]);
                   User.bol_queue = Convert.ToString(reader["bol_queue"]);
                   User.check_port = Convert.ToString(reader["check_port"]);
                   User.check_prn_name = Convert.ToString(reader["check_prn_name"]);
                   User.check_queue = Convert.ToString(reader["check_queue"]);
                   User.create_date = Convert.ToString(reader["create_date"]);
                   User.default_warehouse = Convert.ToString(reader["default_warehouse"]);
                   User.elt_account_number = Convert.ToString(reader["elt_account_number"]);
                   User.ig_recent_work = Convert.ToString(reader["ig_recent_work"]);
                   User.ig_user_cell = Convert.ToString(reader["ig_user_cell"]);
                   User.ig_user_dob = Convert.ToString(reader["ig_user_dob"]);
                   User.ig_user_ssn = Convert.ToString(reader["ig_user_ssn"]);
                   User.invoice_port = Convert.ToString(reader["invoice_port"]);
                   User.invoice_prn_name = Convert.ToString(reader["invoice_prn_name"]);
                   User.invoice_queue = Convert.ToString(reader["invoice_queue"]);
                   User.is_org_merged = Convert.ToString(reader["is_org_merged"]);
                   User.label_type = Convert.ToString(reader["label_type"]);
                   User.last_login_date = Convert.ToString(reader["last_login_date"]);
                   User.last_modified = Convert.ToString(reader["last_modified"]);
                   User.login_name = Convert.ToString(reader["login_name"]);
                   User.org_acct = Convert.ToString(reader["org_acct"]);
                   User.page_id = Convert.ToString(reader["page_id"]);
                   User.page_tab_id = Convert.ToString(reader["page_tab_id"]);
                   User.password = Convert.ToString(reader["password"]);
                   User.pw_change_date = Convert.ToString(reader["pw_change_date"]);
                   User.sed_port = Convert.ToString(reader["sed_port"]);
                   User.sed_prn_name = Convert.ToString(reader["sed_prn_name"]);
                   User.sed_queue = Convert.ToString(reader["sed_queue"]);
                   User.shipping_label_port = Convert.ToString(reader["shipping_label_port"]);
                   User.shipping_label_prn_name = Convert.ToString(reader["shipping_label_prn_name"]);
                   User.shipping_label_queue = Convert.ToString(reader["shipping_label_queue"]);
                   User.user_address = Convert.ToString(reader["user_address"]);
                   User.user_city = Convert.ToString(reader["user_city"]);
                   User.user_country = Convert.ToString(reader["user_country"]);
                   User.user_email = Convert.ToString(reader["user_email"]);
                   User.user_fname = Convert.ToString(reader["user_fname"]);
                   User.user_lname = Convert.ToString(reader["user_lname"]);
                   User.user_phone = Convert.ToString(reader["user_phone"]);
                   User.user_right = Convert.ToString(reader["user_right"]);
                   User.user_state = Convert.ToString(reader["user_state"]);
                   User.user_title = Convert.ToString(reader["user_title"]);
                   User.user_type = Convert.ToString(reader["user_type"]);
                   User.user_zip = Convert.ToString(reader["user_zip"]);
                   User.userid = Convert.ToString(reader["userid"]);
                   User.board_name = Convert.ToString(reader["board_name"]);
                   User.company_name = Convert.ToString(reader["dba_name"]);
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
           finally
           {
               Con.Close();
               Con.Dispose();
           }
           return User;
       }
       public ELTUser GetELTUser(string useremail)
       {
           ELTUser User = new ELTUser();
           if (useremail.ToLower() == "system")
           {
               User.elt_account_number = (string)HttpContext.Current.Session["elt_account_number_for"];
               User.user_type = "9";
               User.user_right = "9";              
               User.userid = "9999999";
                User.login_name = "system";
               return User;
           }

           SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
           SqlCommand Cmd = new SqlCommand();
           Cmd.Connection = Con;
           var elt_account_number = (string)HttpContext.Current.Session["elt_account_number"];
           Cmd.CommandText = " SELECT Users.*, agent.dba_name, agent.board_name from USERS left outer join agent on agent.elt_account_number = users.elt_account_number where  login_name='" + useremail + "' and users.elt_account_number=" + elt_account_number;
          
           try
           {
               Con.Open();
               SqlDataReader reader = Cmd.ExecuteReader();
               if (reader.Read())
               {
                   User.add_to_label = Convert.ToString(reader["add_to_label"]);
                   User.awb_port = Convert.ToString(reader["awb_port"]);
                   User.awb_prn_name = Convert.ToString(reader["awb_prn_name"]);
                   User.awb_queue = Convert.ToString(reader["awb_queue"]);
                   User.bol_port = Convert.ToString(reader["bol_port"]);
                   User.bol_prn_name = Convert.ToString(reader["bol_prn_name"]);
                   User.bol_queue = Convert.ToString(reader["bol_queue"]);
                   User.check_port = Convert.ToString(reader["check_port"]);
                   User.check_prn_name = Convert.ToString(reader["check_prn_name"]);
                   User.check_queue = Convert.ToString(reader["check_queue"]);
                   User.create_date = Convert.ToString(reader["create_date"]);
                   User.default_warehouse = Convert.ToString(reader["default_warehouse"]);
                   User.elt_account_number = Convert.ToString(reader["elt_account_number"]);
                   User.ig_recent_work = Convert.ToString(reader["ig_recent_work"]);
                   User.ig_user_cell = Convert.ToString(reader["ig_user_cell"]);
                   User.ig_user_dob = Convert.ToString(reader["ig_user_dob"]);
                   User.ig_user_ssn = Convert.ToString(reader["ig_user_ssn"]);
                   User.invoice_port = Convert.ToString(reader["invoice_port"]);
                   User.invoice_prn_name = Convert.ToString(reader["invoice_prn_name"]);
                   User.invoice_queue = Convert.ToString(reader["invoice_queue"]);
                   User.is_org_merged = Convert.ToString(reader["is_org_merged"]);
                   User.label_type = Convert.ToString(reader["label_type"]);
                   User.last_login_date = Convert.ToString(reader["last_login_date"]);
                   User.last_modified = Convert.ToString(reader["last_modified"]);
                   User.login_name = Convert.ToString(reader["login_name"]);
                   User.org_acct = Convert.ToString(reader["org_acct"]);
                   User.page_id = Convert.ToString(reader["page_id"]);
                   User.page_tab_id = Convert.ToString(reader["page_tab_id"]);
                   User.password = Convert.ToString(reader["password"]);
                   User.pw_change_date = Convert.ToString(reader["pw_change_date"]);
                   User.sed_port = Convert.ToString(reader["sed_port"]);
                   User.sed_prn_name = Convert.ToString(reader["sed_prn_name"]);
                   User.sed_queue = Convert.ToString(reader["sed_queue"]);
                   User.shipping_label_port = Convert.ToString(reader["shipping_label_port"]);
                   User.shipping_label_prn_name = Convert.ToString(reader["shipping_label_prn_name"]);
                   User.shipping_label_queue = Convert.ToString(reader["shipping_label_queue"]);
                   User.user_address = Convert.ToString(reader["user_address"]);
                   User.user_city = Convert.ToString(reader["user_city"]);
                   User.user_country = Convert.ToString(reader["user_country"]);
                   User.user_email = Convert.ToString(reader["user_email"]);
                   User.user_fname = Convert.ToString(reader["user_fname"]);
                   User.user_lname = Convert.ToString(reader["user_lname"]);
                   User.user_phone = Convert.ToString(reader["user_phone"]);
                   User.user_right = Convert.ToString(reader["user_right"]);
                   User.user_state = Convert.ToString(reader["user_state"]);
                   User.user_title = Convert.ToString(reader["user_title"]);
                   User.user_type = Convert.ToString(reader["user_type"]);
                   User.user_zip = Convert.ToString(reader["user_zip"]);
                   User.userid = Convert.ToString(reader["userid"]);
                   User.board_name = Convert.ToString(reader["board_name"]);
                   User.company_name = Convert.ToString(reader["dba_name"]);
               }

              
           }
           catch (Exception ex)
           {
               throw ex;
           }
           finally
           {
               Con.Close();
               Con.Dispose();
           }
           return User;
       }
        public string GetIP()
        {
            string clientIp = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (string.IsNullOrEmpty(clientIp))
            {
                clientIp = HttpContext.Current.Request.UserHostAddress;
            };
            clientIp = clientIp.Split(',')[0];
            return clientIp;
        }
            public bool PerformCreateLoginInfoForLegacyASPNET(ELTUser User, string CommonSessionID)
            {
            if (User == null) return false;
            string session_id = CommonSessionID;
            string elt_account_number = User.elt_account_number;
            string user_id = User.userid;
            string user_name = User.login_name;
            string ip = GetIP();
            string server_name =  HttpContext.Current.Server.MachineName;
            string login_time = DateTime.Now.ToString();
            string session_intIp = GetIP();
            string uniq_id = elt_account_number + user_id;
            string SQL = "";

            string ConnectStr = GetConnectionString(AppConstants.DB_CONN_PROD);
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Con.Open();

            SqlTransaction trans = Con.BeginTransaction();
            Cmd.Transaction = trans;

            try
            {
            // Delete login information fromo view_login table
            if (user_id != "0000")
            {
                SQL = "DELETE FROM view_login where elt_account_number=" + elt_account_number + " AND user_id='" + uniq_id + "'";
                Cmd.CommandText = SQL;
                Cmd.ExecuteNonQuery();
            }
            SQL = "DELETE FROM view_login where ip='" + ip + "'";
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();

            // Create login information to view_login table

            SQL = "INSERT INTO view_login (session_id,elt_account_number,user_id,user_name,ip,server_name,";
            SQL = SQL + "login_time,u_time,logout,requested_page,alive,intIP,user_type,user_right,login_name,password,";
            SQL = SQL + "org_acct,user_lname,user_fname,user_title,user_address,user_city,user_state,user_zip,user_country,user_phone,user_email,last_login_date,default_warehouse,";
            SQL = SQL + "awb_port,bol_port,sed_port,invoice_port,check_port,shipping_label_port,awb_queue,bol_queue,sed_queue,invoice_queue,check_queue,shipping_label_queue,";
            SQL = SQL + "awb_prn_name,bol_prn_name,sed_prn_name,invoice_prn_name,check_prn_name,shipping_label_prn_name,";
            SQL = SQL + "ig_user_ssn,ig_user_dob,ig_user_cell,ig_recent_work) ";
            SQL = SQL + "select ";
            SQL = SQL + "'" + session_id + "'";
            SQL = SQL + ",'" + elt_account_number + "'";
            SQL = SQL + ",'" + uniq_id + "'";
            SQL = SQL + ",'" + user_name + "'";
            SQL = SQL + ",'" + ip + "'";
            SQL = SQL + ",'" + server_name + "'";
            SQL = SQL + ",'" + login_time + "'";
            SQL = SQL + ",'" + login_time + "'";
            SQL = SQL + ",0,'Init_joint',1,'" + session_intIp + "',";
            if (user_id != "0000")
            {
                SQL = SQL + "user_type,user_right,'',password,org_acct,user_lname,user_fname,user_title,user_address,user_city,user_state,user_zip,user_country,user_phone,user_email,last_login_date,default_warehouse,awb_port,bol_port,sed_port,invoice_port,check_port,shipping_label_port,awb_queue,bol_queue,sed_queue,invoice_queue,check_queue,shipping_label_queue,awb_prn_name,bol_prn_name,sed_prn_name,invoice_prn_name,check_prn_name,shipping_label_prn_name,ig_user_ssn,ig_user_dob,ig_user_cell,ig_recent_work from users where elt_account_number=" + elt_account_number + " AND userid='" + user_id + "'";
            }
            else
            {
                SQL = SQL + "user_type,user_right,'',password,org_acct,user_lname,user_fname,user_title,user_address,user_city,user_state,user_zip,user_country,user_phone,user_email,last_login_date,default_warehouse,awb_port,bol_port,sed_port,invoice_port,check_port,shipping_label_port,awb_queue,bol_queue,sed_queue,invoice_queue,check_queue,shipping_label_queue,awb_prn_name,bol_prn_name,sed_prn_name,invoice_prn_name,check_prn_name,shipping_label_prn_name,ig_user_ssn,ig_user_dob,ig_user_cell,ig_recent_work from users where elt_account_number=80002000 AND userid='1000'";
            }
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();

            trans.Commit();

            }
            catch
            {
            trans.Rollback();
            return false;
            }
            finally
            {
            Con.Close();
            Cmd = null;
            Con = null;
            }       

            return true;
            }
            public void PerformDBLogOutFromLegacyASPNET()
            {
                HttpContext.Current.Session.Clear();
                HttpContext.Current.Session.Abandon();
                if (HttpContext.Current.Request.Cookies["CurrentUserInfo"] != null)
                {
                    string elt_user_id = HttpContext.Current.Request.Cookies["CurrentUserInfo"]["elt_account_number"].ToString() + HttpContext.Current.Request.Cookies["CurrentUserInfo"]["user_id"].ToString();
                    SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
                    SqlCommand Cmd = new SqlCommand();
                    Cmd.Connection = Con;
                   
                    try
                    {
                        Con.Open();
                        Cmd.CommandText = "Delete view_login where ip='" + GetIP() + "' and user_id='" + elt_user_id + "'";
                        Cmd.ExecuteNonQuery();
                     
                    }
                    catch (Exception)
                    {

                        throw;
                    }
                    finally
                    {
                        Con.Close();
                        Con.Dispose();
                    }
                    
                    HttpContext.Current.Session["MainTR"] = "";
                }
            }
            public bool CheckSession(int operation, string user_name, int elt_account_number, string reason,string sessionid,string url,out string Msg)
            {
                Msg = "";
                bool bresult = false;
                SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.CheckSession";
                Exception Except = new Exception();
                url = HttpUtility.UrlDecode(url);
                try
                {
                    cmd.Parameters.Add(new SqlParameter("@operation", operation));
                    cmd.Parameters.Add(new SqlParameter("@elt_account_number", elt_account_number));
                    cmd.Parameters.Add(new SqlParameter("@user_name", user_name));
                    cmd.Parameters.Add(new SqlParameter("@url", url));
                    cmd.Parameters.Add(new SqlParameter("@ip", GetIP()));
                    cmd.Parameters.Add(new SqlParameter("@sessionid", sessionid));
                    cmd.Parameters.Add(new SqlParameter("@reason", reason));
                    cmd.Parameters.Add(new SqlParameter("@Msg", Msg));
                    cmd.Parameters.Add(new SqlParameter("@Result", bresult));
                    cmd.Parameters["@Msg"].Direction = ParameterDirection.Output;
                    cmd.Parameters["@Result"].Direction = ParameterDirection.Output;                  
                    cmd.Parameters["@Msg"].Size = 8000;
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    Msg = Convert.ToString(cmd.Parameters["@Msg"].Value);
                    bresult = (bool)cmd.Parameters["@Result"].Value;
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
                return bresult;
            }

            public bool UpdateLoginId(string NewLogin, string OldLogin,  int elt_account_number, out string Msg)
            {
                Msg = "";
                bool bresult = false;
                SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.ChangeLogin";
                Exception Except = new Exception();

                try
                {
                    cmd.Parameters.Add(new SqlParameter("@NewLogin", NewLogin));
                    cmd.Parameters.Add(new SqlParameter("@OldLogin", OldLogin));                
                    cmd.Parameters.Add(new SqlParameter("@Result", bresult));
                    cmd.Parameters.Add(new SqlParameter("@elt_account_number", elt_account_number));
                    cmd.Parameters.Add(new SqlParameter("@Msg", Msg));             
                    cmd.Parameters["@Msg"].Direction = ParameterDirection.Output;
                    cmd.Parameters["@Result"].Direction = ParameterDirection.Output;
                    cmd.Parameters["@Msg"].Size = 8000;
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    Msg = Convert.ToString(cmd.Parameters["@Msg"].Value);
                    bresult = (bool)cmd.Parameters["@Result"].Value;
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
                return bresult;
            }

            public bool CheckAllowed(string url, string login_name, int elt_account_number)
            {
               
                bool bresult = false;
                SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "dbo.[CheckPageAccess]";
                try
                {
                    conn.Open();
                    cmd.Parameters.Add(new SqlParameter("@elt_account_number", elt_account_number));
                    cmd.Parameters.Add(new SqlParameter("@login_name", login_name));
                    cmd.Parameters.Add(new SqlParameter("@url", url));
                    cmd.Parameters.Add(new SqlParameter("@Result", bresult));
                    cmd.Parameters["@Result"].Direction = ParameterDirection.Output;
                    cmd.ExecuteNonQuery();

                    bresult = (bool)cmd.Parameters["@Result"].Value;
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
                return bresult;
            }

            public bool UpdateProfileEltAccount(int elt_account_number, string login_name)
       {
           var con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
           var cmd = new SqlCommand
           {
               Connection = con,
               CommandText =
                   "UPDATE  [dbo].[UserProfile] SET [elt_account_number]={0} WHERE  [UserName] ='{1}' "
           };
           cmd.CommandText = string.Format(cmd.CommandText, elt_account_number, login_name);
           try
           {
               con.Open();
               var result = cmd.ExecuteNonQuery();
               
           }
           catch (Exception ex)
           {
               throw;
           }
           finally
           {
               con.Close();
               con.Dispose();
           }
           return false;
       }
    }
}




       //public bool ProcessRegistration(SingleRegistrationInfo RegInfo)
       //{
       //    bool bresult = false;
       //    SqlConnection conn = new SqlConnection(GetConnectionString());
       //    SqlCommand cmd = new SqlCommand();
       //    cmd.Connection = conn;
       //    cmd.CommandType = CommandType.StoredProcedure;
       //    cmd.CommandText = "GEN2.spProcessRegistration";
       //    Exception Except = new Exception();
       //    try
       //    {
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_First_Name", RegInfo.Owner.FirstName));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Last_Name", RegInfo.Owner.LastName));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Login_Name", RegInfo.Owner.Login));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Login_Password", RegInfo.Owner.Password));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Address", RegInfo.Owner.Address.StreetAddress));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Address2", RegInfo.Owner.Address.StreetAddressLine2));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_City", RegInfo.Owner.Address.City));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_State", RegInfo.Owner.Address.State));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Zip", RegInfo.Owner.Address.Zip));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Zip4", RegInfo.Owner.Address.Zip4));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Birth_Month", RegInfo.Owner.BirthMonth));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Birth_Day", RegInfo.Owner.BirthDay));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Phone_Area", RegInfo.Owner.Phone.AreaCode));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Phone_Exchange", RegInfo.Owner.Phone.Exchange));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Phone_Number", RegInfo.Owner.Phone.Number));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Type", 0));
       //        cmd.Parameters.Add(new SqlParameter("@Deal_Dealer_ID", RegInfo.Owner.InternalDealerID));//should be revised, currently not used.
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Add_User", RegInfo.Owner.AddUser));
       //        cmd.Parameters.Add(new SqlParameter("@Ownr_Login_Password_Salt", RegInfo.Owner.PasswordSalt));
       //        cmd.Parameters.Add(new SqlParameter("@Deal_Dealer_Internal_ID", RegInfo.Owner.DealerID));
       //        cmd.Parameters.Add(new SqlParameter("@ConnectedCarEnabled", RegInfo.VehicleToAdd.ConnectedCarEnabled));
       //        cmd.Parameters.Add(new SqlParameter("@VIN", RegInfo.VehicleToAdd.VinNumber));
       //        cmd.Parameters.Add(new SqlParameter("@OwnerID", RegInfo.Owner.Id));
       //        cmd.Parameters.Add(new SqlParameter("@RegistrationID", RegInfo.VehicleToAdd.RegistrationID));
       //        cmd.Parameters.Add(new SqlParameter("@homephone", RegInfo.Owner.HomePhone));
       //        cmd.Parameters.Add(new SqlParameter("@cellphone", RegInfo.Owner.CellPhone));
       //        cmd.Parameters.Add(new SqlParameter("@workphone", RegInfo.Owner.WorkPhone));
       //        cmd.Parameters.Add(new SqlParameter("@AssistDealerCode", RegInfo.VehicleToAdd.AssistDealerCode));
       //        cmd.Parameters.Add(new SqlParameter("@AssistSalePersonName", RegInfo.VehicleToAdd.AssistSalePersonName));
       //        cmd.Parameters.Add(new SqlParameter("@MiddleInitial", RegInfo.Owner.MiddleInitial));
       //        cmd.Parameters.Add(new SqlParameter("@Prefix", RegInfo.Owner.Prefix));
       //        cmd.Parameters.Add(new SqlParameter("@Suffix", RegInfo.Owner.Suffix));
       //        cmd.Parameters.Add(new SqlParameter("@OwnerInd", RegInfo.Owner.OwnerInd));
       //        cmd.Parameters.Add(new SqlParameter("@IdmId", RegInfo.Owner.IDMID));
       //        cmd.Parameters.Add(new SqlParameter("@ModelID", RegInfo.VehicleToAdd.Model.Id));
       //        cmd.Parameters.Add(new SqlParameter("@CurrentMileage", RegInfo.VehicleToAdd.Mileage));
       //        cmd.Parameters.Add(new SqlParameter("@MileagePer_Month", RegInfo.VehicleToAdd.MileagePerMonth));
       //        cmd.Parameters.Add(new SqlParameter("@Satelite_Radio_Code", RegInfo.VehicleToAdd.SatelliteRadioCode));
       //        cmd.Parameters.Add(new SqlParameter("@Mileage_TimePeriod", RegInfo.VehicleToAdd.TimePeriod));
       //        cmd.Parameters.Add(new SqlParameter("@Mileage_Per_TimePeriod", RegInfo.VehicleToAdd.PeriodMileage));
       //        cmd.Parameters.Add(new SqlParameter("@DrivingTypeID", RegInfo.VehicleToAdd.DrivingType));
       //        cmd.Parameters.Add(new SqlParameter("@VehicleID", RegInfo.VehicleToAdd.Id));
       //        cmd.Parameters.Add(new SqlParameter("@ReceiveEmailMaintenanceReminders", RegInfo.ReceiveEmailMaintenanceReminders));
       //        cmd.Parameters.Add(new SqlParameter("@InterestedVehicleXML", RegInfo.InterestedVehicleXML));
       //        cmd.Parameters.Add(new SqlParameter("@DrivingHabitID", RegInfo.VehicleToAdd.DrivingHabitID));
       //        cmd.Parameters.Add(new SqlParameter("@DeleteResearchedVehicle", RegInfo.DeleteResearchedVehicle));
       //        cmd.Parameters.Add(new SqlParameter("@IsByo", RegInfo.IsByo));
       //        cmd.Parameters.Add(new SqlParameter("@ErrMsg", RegInfo.ErrorMessage));
       //        cmd.Parameters.Add(new SqlParameter("@ErrCode", RegInfo.ErrorCode));
       //        cmd.Parameters.Add(new SqlParameter("@IsSuccessful", false));

       //        cmd.Parameters["@ConnectedCarEnabled"].Direction = ParameterDirection.InputOutput;
       //        cmd.Parameters["@OwnerID"].Direction = ParameterDirection.InputOutput;
       //        cmd.Parameters["@RegistrationID"].Size = 100;
       //        cmd.Parameters["@RegistrationID"].Direction = ParameterDirection.InputOutput;
       //        cmd.Parameters["@ErrMsg"].Size = 8000;
       //        cmd.Parameters["@ErrMsg"].Direction = ParameterDirection.InputOutput;
       //        cmd.Parameters["@ErrCode"].Size = 10;
       //        cmd.Parameters["@ErrCode"].Direction = ParameterDirection.InputOutput;
       //        cmd.Parameters["@VehicleID"].Direction = ParameterDirection.InputOutput;
       //        cmd.Parameters["@IsSuccessful"].Direction = ParameterDirection.InputOutput;

       //        conn.Open();
       //        cmd.ExecuteNonQuery();

       //        RegInfo.VehicleToAdd.ConnectedCarEnabled = (bool)cmd.Parameters["@ConnectedCarEnabled"].Value;
       //        RegInfo.Owner.Id = (int)cmd.Parameters["@OwnerID"].Value;
       //        RegInfo.VehicleToAdd.Id = (int)cmd.Parameters["@VehicleID"].Value;
       //        RegInfo.VehicleToAdd.RegistrationID = (string)cmd.Parameters["@RegistrationID"].Value;
       //        RegInfo.ErrorMessage = (string)cmd.Parameters["@ErrMsg"].Value;
       //        RegInfo.ErrorCode = (string)cmd.Parameters["@ErrCode"].Value;
       //        RegInfo.IsSuccssful = (bool)cmd.Parameters["@IsSuccessful"].Value;
       //    }
       //    catch (Exception ex)
       //    {
       //        Except = ex;
       //        RegInfo.IsSuccssful = false;
       //        RegInfo.ErrorMessage += ex.Message;
       //    }
       //    finally
       //    {
       //        if (RegInfo.IsSuccssful)
       //        {
       //            bresult = true;
       //        }
       //        else
       //        {
       //            Except = new Exception(RegInfo.ErrorMessage);
       //        }
       //        conn.Close();
       //        int VehicleID = 0;
       //        string VIN = "";
       //        if (RegInfo.VehicleToAdd != null)
       //        {
       //            VehicleID = RegInfo.VehicleToAdd.Id;
       //            VIN = RegInfo.VehicleToAdd.VinNumber;
       //        }
       //    }
       //    if (!bresult)
       //    {
       //        int VehicleID = 0;
       //        string VIN = "";
       //        if (RegInfo.VehicleToAdd != null)
       //        {
       //            VehicleID = RegInfo.VehicleToAdd.Id;
       //            VIN = RegInfo.VehicleToAdd.VinNumber;
       //        }
       //        Common.WriteToDb(RegInfo.ErrorMessage, Common.LogType.Error_Registration, null, RegInfo.Owner.Id, VIN, VehicleID, RegInfo.Owner.Login, "ProcessRegistration");
       //        throw Except;
       //    }
       //    return bresult;
       //}
