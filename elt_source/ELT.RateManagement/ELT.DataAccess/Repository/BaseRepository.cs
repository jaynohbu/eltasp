using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI.WebControls;
using ELT.Shared.Model;
using ELT.Shared.Util;
using Microsoft.SqlServer.Server;
using Microsoft.Web.Infrastructure;

namespace ELT.DataAccess.Repository
{
    public class BaseRepository 
    {
        public ELTUser GetEltUser(int eltAccountNumber, string loginName)
        {
            
            SqlConnection Con = new SqlConnection(HttpUtil.GetConnectionString("PRDConnection"));
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Cmd.CommandText = " SELECT Users.*, agent.dba_name, agent.board_name from USERS left outer join agent on agent.elt_account_number = users.elt_account_number where users.elt_account_number='" + eltAccountNumber + "' AND login_name='" + loginName + "'";
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

                if (loginName == "system")
                {
                    User.elt_account_number = eltAccountNumber.ToString();
                    
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
   

        public ELTUser GetEltUser(string sessionId)
        {
            SqlConnection Con = new SqlConnection(HttpUtil.GetConnectionString("PRDConnection"));
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Cmd.CommandText = " SELECT elt_account_number, login_name from UserSession Where alive= 1 AND session_id='" + sessionId + "'";
            ELTUser User = new ELTUser();
            int eltAccountNumber=0;
            string loginName=string.Empty;
            
            try
            {
                Con.Open();
                SqlDataReader reader = Cmd.ExecuteReader();
                if (reader.Read())
                {
                    eltAccountNumber = Convert.ToInt32(reader["elt_account_number"]);
                    loginName = Convert.ToString(reader["login_name"]);
                   
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
            var user= GetEltUser(eltAccountNumber, loginName);
        
            return user;
        }
        
    }
}
