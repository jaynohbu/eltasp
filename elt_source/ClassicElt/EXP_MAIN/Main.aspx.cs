using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.Security;

public partial class Main : System.Web.UI.Page
{
    public string elt_account_number;
    public string user_id, login_name, login_lname, user_type;
    public string board_name;
    protected DataSet ds;
    protected SqlDataAdapter Adap;
    public int allIndex = 0;
    protected string ConnectStr;
    public string logoUrl = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        
        try
        {
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            user_type = Request.Cookies["CurrentUserInfo"]["user_type"];
            login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
            login_lname = Request.Cookies["CurrentUserInfo"]["lname"];
        }
        catch
        {
            //string script = "<script language='javascript'>";
            //script += "alert('Your session was disconnected by system!\\n');";
            //script += "top.location.replace('/EXP_MAIN/Default.aspx');";
            //script += "</script>";
            //Response.Write(script);
            //Response.End();
        }

        if (!IsPostBack)
        {
            if (Request.QueryString["mode"] != null)
            {
                if (Request.QueryString["mode"] == "logout")
                {
                    PerformLogOut();
                }
            }
            checkView();
            if (Session["DefaultPage"] != null)
            {
                txtDefaultPage.Text = Session["DefaultPage"].ToString();
            }
            Session["DefaultPage"] = "";
        }
    }

    // Session manage
    private void checkView()
    {
        string strTr = "";
        string strTr2 = "";

        try
        {
            if (Session["MainInit"] != null)
            {
                if (Session["MainInit"].ToString() == "true")
                {
                    if (!PerformCreateLoginInfo())
                    {
                        string s = "<script language='javascript'> alert('Sorry system could not create your session please try again!'); }</script>";
                        Response.Write(s);
                    }
                    Session["MainInit"] = "";
                }
            }

            if (Session["MainTR"] != null)
            {
                strTr = Session["MainTR"].ToString();
            }

            if (strTr == "")
            {
                Session["MainTR"] = 0;
                strTr = "0";
            }

            if (Request.QueryString["T"] != null)
            {
                strTr2 = Request.QueryString["T"];
            }

            if (strTr2 == "")
            {
                strTr2 = "0";
            }

            if (strTr2 == strTr)
            {
                string alertHTML = "/EXP_MAIN/Alert.html";
                string script = "<script language='javascript'>";
                if (File.Exists(Server.MapPath(alertHTML)))
                {
                    script += "setTimeout(\"OpenWindow('" + alertHTML + "',650,450)\",3000);";
                }
                script += "</script>";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "AlertAnnounce", script);
                Session["MainTR"] = (int)Session["MainTR"] + 1;
            }

            if (elt_account_number == "" || elt_account_number == null)
            {
                string script = "<script language='javascript'>";
                script += "top.location.replace('/EXP_MAIN/Default.aspx');";
                script += "</script>";
                Response.Write(script);
            }
        }
        catch { }
    }

    private bool PerformCreateLoginInfo()
    {

        string session_id = Request.Cookies["CurrentUserInfo"]["Session_ID"];
        string elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        string user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        string user_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        string ip = Request.Cookies["CurrentUserInfo"]["IP"];
        string server_name = Request.Cookies["CurrentUserInfo"]["Server_Name"];
        string login_time = DateTime.Now.ToString();
        string session_intIp = Request.Cookies["CurrentUserInfo"]["intIP"];
        string uniq_id = elt_account_number + user_id;
        string SQL = "";

        ConnectStr = (new igFunctions.DB().getConStr());
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
            SQL = SQL + "awb_port,bol_port,invoice_port,check_port,shipping_label_port,awb_queue,bol_queue,invoice_queue,check_queue,shipping_label_queue,";
            SQL = SQL + "awb_prn_name,bol_prn_name,invoice_prn_name,check_prn_name,shipping_label_prn_name,";
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
                SQL = SQL + "user_type,user_right,login_name,password,org_acct,user_lname,user_fname,user_title,user_address,user_city,user_state,user_zip,user_country,user_phone,user_email,last_login_date,default_warehouse,awb_port,bol_port,invoice_port,check_port,shipping_label_port,awb_queue,bol_queue,invoice_queue,check_queue,shipping_label_queue,awb_prn_name,bol_prn_name,invoice_prn_name,check_prn_name,shipping_label_prn_name,ig_user_ssn,ig_user_dob,ig_user_cell,ig_recent_work from users where elt_account_number=" + elt_account_number + " AND userid='" + user_id + "'";
            }
            else
            {
                SQL = SQL + "user_type,user_right,login_name,password,org_acct,user_lname,user_fname,user_title,user_address,user_city,user_state,user_zip,user_country,user_phone,user_email,last_login_date,default_warehouse,awb_port,bol_port,invoice_port,check_port,shipping_label_port,awb_queue,bol_queue,invoice_queue,check_queue,shipping_label_queue,awb_prn_name,bol_prn_name,invoice_prn_name,check_prn_name,shipping_label_prn_name,ig_user_ssn,ig_user_dob,ig_user_cell,ig_recent_work from users where elt_account_number=80002000 AND userid='1000'";
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

        PerformSaveLog();

        return true;
    }

    private void PerformSaveLog()
    {
        string SQL = "";
        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        try
        {
            SQL = "INSERT INTO statistic (s_date,s_week,s_user_agent,s_referer) VALUES ";
            SQL = SQL + "(getdate()";
            SQL = SQL + ",'" + System.DateTime.Now.DayOfWeek + "'";
            SQL = SQL + ",'" + Request.ServerVariables["HTTP_USER_AGENT"] + "'";
            SQL = SQL + ",'" + Request.ServerVariables["HTTP_REFERER"] + "')";

            Cmd.CommandText = SQL;
            Cmd.ExecuteNonQuery();
        }
        catch { }
        finally
        {
            Con.Close();
            Cmd = null;
            Con = null;
        }
    }

    protected void btnOut_Click(object sender, System.EventArgs e)
    {
        PerformLogOut();
    }

    private void PerformLogOut()
    {
        if (Request.Cookies["CurrentUserInfo"]["elt_account_number"] != null)
        {
            string elt_user_id = Request.Cookies["CurrentUserInfo"]["elt_account_number"].ToString() + Request.Cookies["CurrentUserInfo"]["user_id"].ToString();
            ConnectStr = (new igFunctions.DB().getConStr());
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Con.Open();
            
            try
            {
                Cmd.CommandText = "Delete view_login where ip='" + Request.Cookies["CurrentUserInfo"]["IP"].ToString() + "' and user_id='" + elt_user_id + "'";
                Cmd.ExecuteNonQuery();
            }
            catch { }
            finally
            {
                Con.Close();
                Cmd = null;
                Con = null;
            }

            Session["MainTR"] = "";

            if (Request.Cookies["CurrentUserInfo"] != null)
            {
                Response.Cookies["CurrentUserInfo"].Value = null;
                Response.Cookies["CurrentUserInfo"].Expires = DateTime.Now;
            }

            string script = "<script language='javascript'>top.location.replace('/EXP_MAIN/Default.aspx');</script>";
            Response.Write(script);
            Response.End();
        }
    }
}
