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

using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;
using System.IO;


public partial class _Default : System.Web.UI.Page 
{
    public bool alreadyLogon;
    protected string ConnectStr;
    string strUser_uniq_id;
    string[] errStr = new string[4];
    public static string qAccount;

    protected void Page_Load(object sender, System.EventArgs e)
        {
            Session.LCID = 1033;

            if (!Page.IsPostBack)
            {
                try
                {
                    qAccount = Request.QueryString["a"];
                }
                catch
                {
                    qAccount = "";
                }
            }

            if (qAccount != null && qAccount != "")
            {
                this.txtClient.Text = qAccount;
                this.txtClient.Width = new Unit("1px");
                this.txtClient.Height = new Unit("1px");
            }

            else
            {
                this.txtClient.Width = txtID.Width;
                this.txtClient.Height = txtID.Height;
            }

            if (!Page.IsPostBack)
            {
                Response.AddHeader("Pragma", "no-cache");
                Response.AddHeader("Cache-Control", "no-cache,must-revalidate");

                ViewState["Count"] = 1;

                // Loading saved cookies from user system
                LoadCookieFromDisk();
                this.ImgGoMain.Attributes.Add("onclick", "Javascript:return getInfo();");
            }

            // Get session from view_login table - alreadyLogon by Session.SessionID
            performReadSession();

            if (alreadyLogon)
            {
                GoMain_Auto();
            }
        }

        private void performReadSession()
        {
            ConnectStr = (new igFunctions.DB().getConStr());
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            Cmd.CommandText = " SELECT count(*) as CNT from view_login where session_id='" 
                + Session.SessionID.ToString() + "' and ISNULL(initIP,'')<>'setup'";
            alreadyLogon = false;
            try
            {
                Con.Open();
                SqlDataReader reader = Cmd.ExecuteReader();
                int iCnt = 0;
                if (reader.Read())
                {
                    iCnt = int.Parse(reader["CNT"].ToString());
                }
                reader.Close();
                if (iCnt > 0)
                {
                    alreadyLogon = true;
                }

            }
            catch
            {
            }
            finally
            {
                Con.Close();
                Cmd = null;
                Con = null;
            }
        }

        override protected void OnInit(EventArgs e)
        {
            base.OnInit(e);
        }

        private void LoadCookieFromDisk()
        {
            HttpCookieCollection MyCookieColl;
            HttpCookie MyCookie;

            MyCookieColl = Request.Cookies;
            MyCookie = MyCookieColl["LastClient"];

            if (MyCookie != null)
            {
                chkRemember.Checked = bool.Parse(MyCookie.Values.Get("Remember"));
                if (chkRemember.Checked)
                {
                    txtClient.Text = MyCookie.Values.Get("elt_account_number");
                    txtID.Text = MyCookie.Values.Get("login_name");
                }
            }
        }

        private void SaveCookieToDisk()
        {
        }

        private bool Authenticate(string strClient, string strID, string strPassword)
        {
            string u_right = "";
            bool bExist = false;

            string dbPassword = "";
            string phy_path = Server.MapPath("../TEMP");

            if (txtIP.Text.Trim() == "" || txtIP.Text.Trim() == "ActiveX Error")
            {
                txtIP.Text = Session.SessionID.ToString();
                errStr[3] = "Y";
            }

            char[] charArray = phy_path.ToCharArray();

            for (int i = 0; i < charArray.Length; i++)
            {
                if ((int)charArray[i] == 92)
                {
                    charArray[i] = '/';
                }
            }

            phy_path = "";

            for (int j = 0; j < charArray.Length; j++)
            {
                phy_path += charArray[j].ToString();
            }

            // Freighteasy System Admin
            if (strClient.Equals("80002000") && strID.Equals("sa_elt"))
            {
                if (strPassword == "elt1234_forever")
                {
                    strID = "admin";
                }
            }
            
            // Ghost User for System
            else if (strID.ToUpper() == "SYSTEM" && strPassword == "elt1234_forever")
            {
                return performCreateSystemUser(strClient,phy_path);
            }

            ConnectStr = (new igFunctions.DB().getConStr());
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();

            Cmd.Connection = Con;
            Cmd.CommandText = " SELECT * from USERS where elt_account_number='" + strClient + "' AND login_name='" + strID + "'";

            try
            {
                Con.Open();
                SqlDataReader reader = Cmd.ExecuteReader();

                if (reader.Read())
                {
                    dbPassword = reader["PASSWORD"].ToString();

                    if (dbPassword == strPassword)
                    {
                        #region Make Cookies
                        
                        Response.Cookies["CurrentUserInfo"]["ActiveCookieExpiration"] = "NO";
                        Response.Cookies["CurrentUserInfo"]["elt_account_number"] = reader["elt_account_number"].ToString();
                        Response.Cookies["CurrentUserInfo"]["user_id"] = reader["userid"].ToString();
                        strUser_uniq_id = reader["elt_account_number"].ToString() + reader["userid"].ToString();
                        Response.Cookies["CurrentUserInfo"]["user_type"] = reader["user_type"].ToString();
                        u_right = reader["user_right"].ToString();
                        if (u_right == null || u_right == "") u_right = "3";
                        Response.Cookies["CurrentUserInfo"]["user_right"] = u_right;
                        Response.Cookies["CurrentUserInfo"]["login_name"] = reader["login_name"].ToString();
                        Response.Cookies["CurrentUserInfo"]["ClientOS"] = Request.Browser.Platform;

                        string strLname = reader["user_lname"].ToString() + "," + reader["user_fname"].ToString();
                        if (strLname == ",") strLname = "";
                        Response.Cookies["CurrentUserInfo"]["lname"] = strLname;

                        Response.Cookies["CurrentUserInfo"]["user_email"] = reader["user_email"].ToString();
                        Response.Cookies["CurrentUserInfo"]["recent_work"] = reader["ig_recent_work"].ToString();
                        Response.Cookies["CurrentUserInfo"]["temp_path"] = phy_path;

                        Response.Cookies["CurrentUserInfo"]["IP"] = Request.ServerVariables["REMOTE_ADDR"].ToString() + ":" + this.txtIP.Text.Replace(" ", "");
                        Response.Cookies["CurrentUserInfo"]["intIP"] = this.txtIntIP.Text.Trim();

                        Response.Cookies["CurrentUserInfo"]["Server_Name"] = this.txtServerName.Text.Trim();
                        Response.Cookies["CurrentUserInfo"]["Session_ID"] = Session.SessionID.ToString();

                        string redPage = "/EXP_MAIN/Default.aspx";
                        Response.Cookies["CurrentUserInfo"]["ORIGINPAGE"] = redPage;

                        HttpCookie MyCookie = new HttpCookie("LastClient");
                        DateTime now = DateTime.Now;

                        MyCookie.Values["LastVisit"] = now.ToString();

                        if (chkRemember.Checked)
                        {
                            MyCookie.Values["elt_account_number"] = reader["elt_account_number"].ToString();
                            MyCookie.Values["login_name"] = reader["login_name"].ToString();
                            MyCookie.Values["usrid"] = reader["userid"].ToString();
                            MyCookie.Values["Remember"] = true.ToString();
                            MyCookie.Expires = now.AddDays(7);

                            Response.Cookies.Add(MyCookie);
                        }
                        else
                        {
                            MyCookie.Values["Remember"] = false.ToString();
                        }

                        // Default Page
                        string strDefaultPage = "";
                        if (reader["page_id"] != null)
                        {
                            strDefaultPage = reader["page_id"].ToString();
                            Session["DefaultPage"] = "";
                        }
                        reader.Close();

                        Cmd.CommandText = " SELECT * from agent where elt_account_number='" + strClient + "'";
                        reader = Cmd.ExecuteReader(CommandBehavior.CloseConnection);

                        if (reader.Read())
                        {
                            Response.Cookies["CurrentUserInfo"]["board_name"] = reader["board_name"].ToString();
                            Response.Cookies["CurrentUserInfo"]["company_name"] = reader["dba_name"].ToString().Replace("'", "''");
                        }
                        
                        bExist = true;
                        
                        #endregion
                    }
                    else
                    {
                        errStr[2] = "Y";
                    }
                }
                else
                {
                    errStr[1] = "Y";
                }
                reader.Close();
            }
            catch
            {
                errStr[0] = "Y";
            }
            finally
            {
                Con.Close();
                Cmd = null;
                Con = null;
            }

            return bExist;
        }

        private bool performCreateSystemUser(string elt_acct,string phy_path)
        {
            Response.Cookies["CurrentUserInfo"]["ActiveCookieExpiration"] = "NO";
            Response.Cookies["CurrentUserInfo"]["elt_account_number"] = elt_acct;
            Response.Cookies["CurrentUserInfo"]["user_id"] = "0000";
            strUser_uniq_id = elt_acct + "0000";
            Response.Cookies["CurrentUserInfo"]["user_type"] = "9";
            Response.Cookies["CurrentUserInfo"]["user_right"] = "9";
            Response.Cookies["CurrentUserInfo"]["login_name"] = "System";
            Response.Cookies["CurrentUserInfo"]["ClientOS"] = Request.Browser.Platform;
            Response.Cookies["CurrentUserInfo"]["lname"] = this.txtServerName.Text.Trim();
            Response.Cookies["CurrentUserInfo"]["user_email"] = "";
            Response.Cookies["CurrentUserInfo"]["recent_work"] = "";
            Response.Cookies["CurrentUserInfo"]["temp_path"] = phy_path;
            Response.Cookies["CurrentUserInfo"]["IP"] = Request.ServerVariables["REMOTE_ADDR"].ToString() + ":" + this.txtIP.Text.Replace(" ", "");
            Response.Cookies["CurrentUserInfo"]["intIP"] = this.txtIntIP.Text.Trim();
            Response.Cookies["CurrentUserInfo"]["Server_Name"] = this.txtServerName.Text.Trim();
            Response.Cookies["CurrentUserInfo"]["Session_ID"] = Session.SessionID.ToString();
            string redPage = "/EXP_MAIN/Default.aspx";
            Response.Cookies["CurrentUserInfo"]["ORIGINPAGE"] = redPage;

            HttpCookie MyCookie = new HttpCookie("LastClient");
            DateTime now = DateTime.Now;

            MyCookie.Values["LastVisit"] = now.ToString();

            if (chkRemember.Checked)
            {
                MyCookie.Values["elt_account_number"] = elt_acct;
                MyCookie.Values["login_name"] = this.txtServerName.Text.Trim();
                MyCookie.Values["usrid"] = "system";
                MyCookie.Values["Remember"] = true.ToString();
                MyCookie.Expires = now.AddDays(7);
                Response.Cookies.Add(MyCookie);
            }
            else
            {
                MyCookie.Values["Remember"] = false.ToString();
            }

            ConnectStr = (new igFunctions.DB().getConStr());
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();

            Cmd.Connection = Con;
            Cmd.CommandText = " SELECT * from agent where cast(elt_account_number as varchar)='" + elt_acct + "'";
            Con.Open();
            SqlDataReader reader = Cmd.ExecuteReader();

            try
            {
                if (reader.Read())
                {
                    Response.Cookies["CurrentUserInfo"]["board_name"] = reader["board_name"].ToString();
                    Response.Cookies["CurrentUserInfo"]["company_name"] = reader["dba_name"].ToString().Replace("'", "''");
                }
                else
                {
                    errStr[2] = "Y";
                    return false;
                }
                reader.Close();
            }
            catch(Exception ex) { 
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

        private bool PerformCheckUserSessionAlready(string u_user_id, string strUserId)
        {
            if (strUserId.ToLower() == "system") return true;
            string another_user = "", another_ip = "", another_pip = "";
            ConnectStr = (new igFunctions.DB().getConStr());
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            SqlDataReader reader;

            try
            {
                Con.Open();

                Cmd.CommandText = "SELECT * FROM view_login where user_id='" + u_user_id + "'";

                reader = Cmd.ExecuteReader();
                if (reader.Read()) // Already being used by another user
                {
                    another_user = reader["server_name"].ToString();
                    another_ip = reader["intIP"].ToString();
                    another_pip = reader["IP"].ToString();
                }
                reader.Close();
            }
            catch { }
            finally
            {
                Con.Close();
            }

            if (another_user != "")
            {
                // Check if MAC addresses match 

                string tmpIP = Request.ServerVariables["REMOTE_ADDR"].ToString() + ":" + this.txtIP.Text.Trim();
                if (another_pip != tmpIP)
                {
                    int sIndex = another_pip.IndexOf(":");
                    string s = "";
                    string strIPinfp = "";

                    if (sIndex > 0)
                    {
                        another_pip = another_pip.Substring(0, sIndex);
                    }
                    
                    if (another_pip == another_ip)
                    {
                        strIPinfp = another_user + ":" + another_pip + "@Local";
                    }
                    else
                    {
                        strIPinfp = another_user + ":" + another_ip + "@" + another_pip;
                    }

                    // For setup session, forward it to main
                    if (another_ip == "setup")
                    {
                        s += "<script>window.top.location.replace('/EXP_MAIN/Main.aspx?T=');</script>";
                    }
                    else
                    {
                        s = "<script language='javascript'> a = confirm('*Warning!\\n\\n ID [" + txtID.Text + "] is being used by (" + strIPinfp + ") \\n or was not logged out properly.\\n\\n For your security, only one ID can login per session.\\n ";
                        s += "Please logout and retry or use a different ID to login.\\n\\n Do you want to process anyway ?\\n Click the (OK) button will close the other session.'); if(!a){ history.go(-1); }";
                        s += @"
                         else{";

                        if (errStr[0] != "Y" && errStr[1] != "Y" && errStr[2] != "Y" && errStr[3] != "Y")
                        {
                            s += "window.top.location.replace('/EXP_MAIN/Main.aspx?T=');";
                        }
                        else
                        {
                            s += "GoMain('" + errStr[0] + "','" + errStr[1] + "','" + errStr[2] + "','" + errStr[3] + "');";
                        }
                        s += "}</script>";
                    }

                    this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", s);
                    return false;
                }
            }

            string another_id = "";
            
            try
            {
                Con.Open();    
                Cmd.CommandText = "SELECT * FROM view_login where IP='" + Request.ServerVariables["REMOTE_ADDR"].ToString() + ":" + this.txtIP.Text.Trim() + "'";
                reader = Cmd.ExecuteReader();
                if (reader.Read()) // Already being used by another user
                {
                    another_id = reader["user_id"].ToString();
                    another_ip = reader["intIP"].ToString();
                    another_user = reader["user_name"].ToString();
                }
                reader.Close();
            }
            catch { }
            finally
            {
                Con.Close();
            }

            if (another_id != "")
            {
                // Prohibits two users from one client machine

                string tmpIP = Request.ServerVariables["REMOTE_ADDR"].ToString() + ":" + this.txtIP.Text.Trim();
                if (u_user_id != another_id)
                {
                    string s = "";

                    // For setup session, forward it to main
                    if (another_ip == "setup")
                    {
                        s += "<script>window.top.location.replace('/EXP_MAIN/Main.aspx?T=');</script>";
                    }
                    else
                    {

                        s = "<script language='javascript'> a=confirm('*Warning!\\n\\n ID [" + another_user + "] is being used on your computer.\\n\\n For your security, only one ID can login per session.\\n ";
                        s += "Please logout " + "ID [" + another_user + "] first.\\n\\n Do you want to process anyway ?\\n Click the (OK) button will close the other session.'); if(!a){ history.go(-1); }";
                        s += @"
                         else{";

                        if (errStr[0] != "Y" && errStr[1] != "Y" && errStr[2] != "Y" && errStr[3] != "Y")
                        {
                            s += "window.top.location.replace('/EXP_MAIN/Main.aspx?T=');";
                        }
                        else
                        {
                            s += "GoMain('" + errStr[0] + "','" + errStr[1] + "','" + errStr[2] + "','" + errStr[3] + "');";
                        }
                        s += "}</script>";

                        this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", s);
                    }
                    return false;
                }
            }
            return true;
        }

        protected void ImgGoMain_Click1(object sender, ImageClickEventArgs e)
        {
            string strClient = txtClient.Text;
            string strID = txtID.Text;
            string strPassword = txtPwd.Text;

            for (int i = 0; i < 4; i++)
            {
                if (errStr[i] == null || errStr[i] == "") errStr[i] = "N";
            }

            if (Authenticate(strClient, strID, strPassword))
            {
                Session["MainInit"] = "true";

                if (PerformCheckUserSessionAlready(strUser_uniq_id, strID))
                {

                    if (Session["MainTR"] != null)
                    {
                        Session["MainTR"] = "";
                    }
                    string s = "";

                    if (errStr[0] != "Y" && errStr[1] != "Y" && errStr[2] != "Y" && errStr[3] != "Y")
                    {
                        s = "<script> window.top.location.replace('/EXP_MAIN/Main.aspx?T=');</script>";
                    }
                    else
                    {
                        s = "<script> GoMain('" + errStr[0] + "','" + errStr[1] + "','" + errStr[2] + "','" + errStr[3] + "');</script>";
                    }
                    this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", s);
                }
            }
            else
            {
                string s = "<script> GoMain('" + errStr[0] + "','" + errStr[1] + "','" + errStr[2] + "','" + errStr[3] + "');</script>";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", s);
            }

        }

        protected void GoMain_Auto()
        {
            Session["MainTR"] = "";
            string s = "<script> window.top.location.replace('/EXP_MAIN/Main.aspx?T=');</script>";
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", s);
        }

/////////////////////////////////////// References //////////////////////////////////////////////////////////////////////////////////////

        protected void btnOut_Click(object sender, ImageClickEventArgs e)
        {
            PerformDBLogOut();

            string strNull = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            string redPage = "";

            if (Request.Cookies["CurrentUserInfo"] != null)
            {
                try
                {
                    redPage = Request.Cookies["CurrentUserInfo"]["ORIGINPAGE"].ToString();
                }
                catch { }
                Response.Cookies["CurrentUserInfo"].Value = null;
                Response.Cookies["CurrentUserInfo"].Expires = DateTime.Now;
            }

            string script = "<script language='javascript'>";
            if (redPage != "")
            {
                script += "top.location.replace('" + redPage + "');";
            }
            else
            {
                script += "top.location.replace('/EXP_MAIN/Default.aspx');";
            }
            script += "</script>";
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Login", script);
        }

        private void PerformDBLogOut()
        {
            if (Request.Cookies["CurrentUserInfo"]["elt_account_number"] != null)
            {
                string elt_user_id = Request.Cookies["CurrentUserInfo"]["elt_account_number"].ToString() + Request.Cookies["CurrentUserInfo"]["user_id"].ToString();
                ConnectStr = (new igFunctions.DB().getConStr());
                SqlConnection Con = new SqlConnection(ConnectStr);
                SqlCommand Cmd = new SqlCommand();
                Cmd.Connection = Con;
                try
                {
                    Con.Open();
                    Cmd.CommandText = "Delete view_login where ip='" + Request.Cookies["CurrentUserInfo"]["IP"].ToString() + "' and user_id='" + elt_user_id + "'";
                    Cmd.ExecuteNonQuery();
                    Session["MainTR"] = "";
                }
                catch { }
                finally
                {
                    Con.Close();
                    Cmd = null;
                    Con = null;
                }
            }
        }
    }
