using System;
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
    public class AdminToolDA : DABase
    {      

        public List<ELTUser> GetAllELTUsers()
       {
            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Cmd.CommandText = " SELECT * from USERS";
           List<ELTUser> Users=new List<ELTUser>();
            try
            {
                Con.Open();
                SqlDataReader reader = Cmd.ExecuteReader();
                while (reader.Read())
                {
                    ELTUser User=new ELTUser();
                     User.add_to_label=Convert.ToString(reader["add_to_label"]);
                     User.awb_port =Convert.ToString(reader["awb_port"]);
                     User.awb_prn_name=Convert.ToString(reader["awb_prn_name"]);
                     User.awb_queue=Convert.ToString(reader["awb_queue"]);
                     User.bol_port=Convert.ToString(reader["bol_port"]);
                     User.bol_prn_name=Convert.ToString(reader["bol_prn_name"]);
                     User.bol_queue=Convert.ToString(reader["bol_queue"]);
                     User.check_port=Convert.ToString(reader["check_port"]);
                     User.check_prn_name=Convert.ToString(reader["check_prn_name"]);
                     User.check_queue=Convert.ToString(reader["check_queue"]);
                     User.create_date=Convert.ToString(reader["create_date"]);
                     User.default_warehouse=Convert.ToString(reader["default_warehouse"]);
                     User.elt_account_number=Convert.ToString(reader["elt_account_number"]); 
                     User.ig_recent_work=Convert.ToString(reader["ig_recent_work"]);
                     User.ig_user_cell=Convert.ToString(reader["ig_user_cell"]);
                     User.ig_user_dob=Convert.ToString(reader["ig_user_dob"]);
                     User.ig_user_ssn=Convert.ToString(reader["ig_user_ssn"]);
                     User.invoice_port=Convert.ToString(reader["invoice_port"]);
                     User.invoice_prn_name=Convert.ToString(reader["invoice_prn_name"]);
                     User.invoice_queue=Convert.ToString(reader["invoice_queue"]);
                     User.is_org_merged=Convert.ToString(reader["is_org_merged"]);
                     User.label_type=Convert.ToString(reader["label_type"]);
                     User.last_login_date=Convert.ToString(reader["last_login_date"]);
                     User.last_modified=Convert.ToString(reader["last_modified"]);
                     User.login_name=Convert.ToString(reader["login_name"]);
                     User.org_acct=Convert.ToString(reader["org_acct"]);
                     User.page_id=Convert.ToString(reader["page_id"]);
                     User.page_tab_id=Convert.ToString(reader["page_tab_id"]);
                     User.password=Convert.ToString(reader["password"]);
                     User.pw_change_date=Convert.ToString(reader["pw_change_date"]);
                     User.sed_port=Convert.ToString(reader["sed_port"]);
                     User.sed_prn_name=Convert.ToString(reader["sed_prn_name"]);
                     User.sed_queue=Convert.ToString(reader["sed_queue"]);
                     User.shipping_label_port=Convert.ToString(reader["shipping_label_port"]);
                     User.shipping_label_prn_name=Convert.ToString(reader["shipping_label_prn_name"]);
                     User.shipping_label_queue=Convert.ToString(reader["shipping_label_queue"]);
                     User.user_address=Convert.ToString(reader["user_address"]);
                     User.user_city=Convert.ToString(reader["user_city"]);
                     User.user_country=Convert.ToString(reader["user_country"]);
                     User.user_email=Convert.ToString(reader["user_email"]); 
                     User.user_fname=Convert.ToString(reader["user_fname"]);
                     User.user_lname=Convert.ToString(reader["user_lname"]);
                     User.user_phone=Convert.ToString(reader["user_phone"]);
                     User.user_right=Convert.ToString(reader["user_right"]);
                     User.user_state=Convert.ToString(reader["user_state"]);
                     User.user_title=Convert.ToString(reader["user_title"]); 
                     User.user_type=Convert.ToString(reader["user_type"]);
                     User.user_zip=Convert.ToString(reader["user_zip"]);
                     User.userid=Convert.ToString(reader["userid"]);
                    Users.Add(User);
                }
            }catch(Exception ex){
                throw ex;
            }
            finally
            {
                Con.Close();
                Con.Dispose();

            }
            return Users;
       }
        public void UpdateLoginName(int elt_account_number, int userid, string email)
        {
            SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Cmd.CommandText = " Update  USERS set login_name= '" + email + "' where elt_account_number = " + elt_account_number + " and userid=" + userid;
            List<ELTUser> Users = new List<ELTUser>();
            try
            {
                Con.Open();
                Cmd.ExecuteNonQuery();
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
          
        }
    }
}
