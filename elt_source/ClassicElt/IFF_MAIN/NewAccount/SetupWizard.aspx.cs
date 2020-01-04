
using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;

public partial class Setup_SetupWizard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Session.SessionID.Equals(Request.Cookies["CurrentUserInfo"]["Session_ID"]))
            {
                if (!IsPostBack)
                {
                    if (!Get_Setup_Stage())
                    {
                        Handle_Invalid_Access();
                    }
                    else
                    {
                        string eltNum = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
                        if (eltNum != "")
                        {
                            //Login_Admin_Setup(int.Parse(eltNum));
                            //PerformCreateLoginInfo();
                        }
                    }
                }
                else
                {
                    if (hIsNextPage.Value == "F")
                    {
                        Update_Setup_Session();
                        hIsNextPage.Value = "";
                        if (!Get_Setup_Stage())
                        {
                            Handle_Invalid_Access();
                        }
                    }
                    else if (hIsNextPage.Value == "B")
                    {
                        Update_Setup_Session_Back();
                        hIsNextPage.Value = "";
                        if (!Get_Setup_Stage())
                        {
                            Handle_Invalid_Access();
                        }
                    }
                }
            }
        }
        catch(Exception ex) { 
            Handle_Invalid_Access(); 
        }
    }

    protected void Update_Setup_Session_Back()
    {
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;

        try
        {
            string session_id = Request.Cookies["CurrentUserInfo"]["Free_Session_ID"];
            string elt_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            string page_id = hPageID.Value;

            Con.Open();
            Cmd.CommandText = "IF EXISTS (select * from setup_master where seq_id<(select seq_id from setup_master where page_id="
                + page_id + ")) UPDATE setup_session SET page_id=(select top 1 page_id from setup_master where seq_id<(select seq_id from setup_master "
                + "where page_id=" + page_id + ") order by seq_id desc),updated_date=getdate(),elt_account_number=" + elt_number + " where sid='" + session_id + "'";

            Cmd.ExecuteNonQuery();
            Con.Close();
        }
        catch
        {
            Response.Write(Cmd.CommandText);
        }
    }

    protected void Update_Setup_Session()
    {
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        
        try
        {
            string session_id = Request.Cookies["CurrentUserInfo"]["Free_Session_ID"];
            string elt_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            string page_id = hPageID.Value;

            Con.Open();
            Cmd.CommandText = "IF EXISTS (select * from setup_master where seq_id>(select seq_id from setup_master where page_id="
                + page_id + ")) UPDATE setup_session SET page_id=(select top 1 page_id from setup_master where seq_id>(select seq_id from setup_master "
                + "where page_id=" + page_id + ")),updated_date=getdate(),elt_account_number=" + elt_number + " where sid='" + session_id
                + "' ELSE BEGIN DELETE FROM setup_session WHERE sid='" + session_id
                + "' UPDATE agent SET account_statue='F' WHERE elt_account_number=" + elt_number 
                + " DELETE FROM view_login WHERE elt_account_number=" + elt_number + "  END";

            Cmd.ExecuteNonQuery();
            Con.Close();
        }
        catch {
            Response.Write(Cmd.CommandText);
        }
    }

    protected void Handle_Invalid_Access()
    {
        Response.Write("<script> window.top.location.replace('/IFF_MAIN/Authentication/login.aspx');</script>");
        Response.End();
    }

    protected bool Get_Setup_Stage()
    {
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        bool resVal = false;

        Cmd.CommandText = "SELECT * from setup_session a left outer join setup_master b on a.page_id=b.page_id where sid='"
            + Request.Cookies["CurrentUserInfo"]["Free_Session_ID"].ToString() + "'";

        try
        {
            Con.Open();
            SqlDataReader reader = Cmd.ExecuteReader();
            if (reader.Read())
            {
                labelInstruction.Text = reader["remark"].ToString();
                labelTitle.Text = "Step " + reader["seq_id"].ToString() + " - " + reader["title"].ToString();
                hPageID.Value = reader["page_id"].ToString();
                hSetupType.Value = reader["setup_type"].ToString();
                hPageURL.Value = reader["setup_url"].ToString();
                hValidateURL.Value = reader["valid_url"].ToString();
                
                resVal = true;
            }
            reader.Close();
        }
        catch { }
        return resVal;
    }

    protected void Login_Admin_Setup(int eltNum)
    {
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();

        Cmd.Connection = Con;
        Cmd.CommandText = " SELECT * from USERS where elt_account_number=" + eltNum + " AND userid=1000";

        try
        {
            Con.Open();
            SqlDataReader reader = Cmd.ExecuteReader();

            if (reader.Read())
            {
                Response.Cookies["CurrentUserInfo"]["ActiveCookieExpiration"] = "NO";
                Response.Cookies["CurrentUserInfo"]["elt_account_number"] = reader["elt_account_number"].ToString();
                Response.Cookies["CurrentUserInfo"]["user_id"] = reader["userid"].ToString();
                Response.Cookies["CurrentUserInfo"]["user_type"] = reader["user_type"].ToString();
                string u_right = reader["user_right"].ToString();
                if (u_right == null || u_right == "") u_right = "3";
                Response.Cookies["CurrentUserInfo"]["user_right"] = u_right;
                Response.Cookies["CurrentUserInfo"]["login_name"] = reader["login_name"].ToString();
                Response.Cookies["CurrentUserInfo"]["ClientOS"] = Request.Browser.Platform;
                string strLname = reader["user_lname"].ToString() + "," + reader["user_fname"].ToString();
                if (strLname == ",") strLname = "";
                Response.Cookies["CurrentUserInfo"]["lname"] = strLname;
                Response.Cookies["CurrentUserInfo"]["user_email"] = reader["user_email"].ToString();
                Response.Cookies["CurrentUserInfo"]["recent_work"] = reader["ig_recent_work"].ToString();
                Response.Cookies["CurrentUserInfo"]["temp_path"] = Server.MapPath("../TEMP");
                Response.Cookies["CurrentUserInfo"]["IP"] = "setup";
                Response.Cookies["CurrentUserInfo"]["intIP"] = "setup";
                Response.Cookies["CurrentUserInfo"]["Server_Name"] = "setup";
                Response.Cookies["CurrentUserInfo"]["Session_ID"] = Session.SessionID.ToString();
                Response.Cookies["CurrentUserInfo"]["Free_Session_ID"] = Request.Cookies["CurrentUserInfo"]["Free_Session_ID"];
                string redPage = "/IFF_MAIN/Authentication/login.aspx?sid=" + Request.Cookies["CurrentUserInfo"]["Free_Session_ID"];
                Response.Cookies["CurrentUserInfo"]["ORIGINPAGE"] = redPage;

                // Default Page
                string strDefaultPage = "";
                if (reader["page_id"] != null)
                {
                    strDefaultPage = reader["page_id"].ToString();
                    Session["DefaultPage"] = "";
                }
                reader.Close();

                Cmd.CommandText = " SELECT * from agent where elt_account_number=" + eltNum + "";
                reader = Cmd.ExecuteReader(CommandBehavior.CloseConnection);

                if (reader.Read())
                {
                    Response.Cookies["CurrentUserInfo"]["board_name"] = reader["board_name"].ToString();
                    Response.Cookies["CurrentUserInfo"]["company_name"] = reader["dba_name"].ToString().Replace("'", "''");
                }
                reader.Close();
            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.ToString());
        }
        finally
        {
            if (Con != null) { Con.Close(); }
            Cmd = null;
            Con = null;
        }
    }

    private bool PerformCreateLoginInfo()
    {
        string session_id = Response.Cookies["CurrentUserInfo"]["Session_ID"];
        string eltNum = Response.Cookies["CurrentUserInfo"]["elt_account_number"];
        string user_id = Response.Cookies["CurrentUserInfo"]["user_id"];
        string user_name = Response.Cookies["CurrentUserInfo"]["login_name"];
        string ip = Response.Cookies["CurrentUserInfo"]["IP"];
        string server_name = Response.Cookies["CurrentUserInfo"]["Server_Name"];
        string login_time = DateTime.Now.ToString();
        string session_intIp = Response.Cookies["CurrentUserInfo"]["intIP"];
        string uniq_id = eltNum + user_id;
        string SQL = "";

        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();

        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;

        try
        {
            // Delete login information fromo view_login table
            SQL = "DELETE FROM view_login where elt_account_number=" + eltNum + " AND user_id='" + uniq_id + "'";
            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();

            // Create login information to view_login table
            SQL = "INSERT INTO view_login (session_id,elt_account_number,user_id,user_name,ip,server_name,";
            SQL = SQL + "login_time,u_time,logout,requested_page,alive,intIP,user_type,user_right,login_name,password,";
            SQL = SQL + "org_acct,user_lname,user_fname,user_title,user_address,user_city,user_state,user_zip,user_country,user_phone,user_email,last_login_date,default_warehouse,";
            SQL = SQL + "awb_port,bol_port,sed_port,invoice_port,check_port,shipping_label_port,awb_queue,bol_queue,sed_queue,invoice_queue,check_queue,shipping_label_queue,";
            SQL = SQL + "awb_prn_name,bol_prn_name,sed_prn_name,invoice_prn_name,check_prn_name,shipping_label_prn_name,";
            SQL = SQL + "ig_user_ssn,ig_user_dob,ig_user_cell,ig_recent_work) ";
            SQL = SQL + "SELECT ";
            SQL = SQL + "'" + session_id + "'";
            SQL = SQL + ",'" + eltNum + "'";
            SQL = SQL + ",'" + uniq_id + "'";
            SQL = SQL + ",'" + user_name + "'";
            SQL = SQL + ",'" + ip + "'";
            SQL = SQL + ",'" + server_name + "'";
            SQL = SQL + ",'" + login_time + "'";
            SQL = SQL + ",'" + login_time + "'";
            SQL = SQL + ",0,'Init_joint',1,'" + session_intIp + "',";
            SQL = SQL + "user_type,user_right,login_name,password,org_acct,user_lname,user_fname,user_title,user_address,user_city,user_state,user_zip,user_country,user_phone,user_email,last_login_date,default_warehouse,awb_port,bol_port,sed_port,invoice_port,check_port,shipping_label_port,awb_queue,bol_queue,sed_queue,invoice_queue,check_queue,shipping_label_queue,awb_prn_name,bol_prn_name,sed_prn_name,invoice_prn_name,check_prn_name,shipping_label_prn_name,ig_user_ssn,ig_user_dob,ig_user_cell,ig_recent_work from users where elt_account_number=" + eltNum + " AND userid='" + user_id + "'";


            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();

            trans.Commit();

        }
        catch (Exception ex)
        {
            Response.Write(ex.Message + ": " + SQL);
            trans.Rollback();
            return false;
        }
        finally
        {
            Con.Close();
        }

        PerformSaveLog();

        return true;
    }

    private void PerformSaveLog()
    {
        string SQL = "";

        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();

        SQL = "INSERT INTO statistic (s_date,s_week,s_user_agent,s_referer) VALUES ";
        SQL = SQL + "(getdate()";
        SQL = SQL + ",'" + System.DateTime.Now.DayOfWeek + "'";
        SQL = SQL + ",'" + Request.ServerVariables["HTTP_USER_AGENT"] + "'";
        SQL = SQL + ",'" + Request.ServerVariables["HTTP_REFERER"] + "')";

        Cmd.CommandText = SQL;
        Cmd.ExecuteNonQuery();

        Con.Close();
    }

}