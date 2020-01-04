using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;
using ELT.Printing;
using Neodynamic.SDK.Web;
namespace IFF_MAIN
{
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
        public string session_id = "";

        protected void Page_Init(object sender, System.EventArgs e)
        {
            if (WebClientPrint.ProcessPrintJob(this.Request))
            {
                session_id = this.Request.QueryString["sid"];
                PrintingManager.Print((string)Application[session_id + CommonConstants.PrintCommand], this);
//                PrintingManager.Print("^XA" + "\n" +
//"^PW900" + "\n" +
//"^FO0,158^GB830,0,2,^FS" + "\n" +
//"^FO0,441^GB830,0,2,^FS" + "\n" +
//"^FO0,562^GB830,0,2,^FS" + "\n" +
//"^FO400,562^GB2,121,2^FS" + "\n" +
//"^FO0,683^GB830,0,2,^FS" + "\n" +
//"^FO600,683^GB2,100,2^FS" + "\n" +
//"^FO0,784^GB830,0,2,^FS" + "\n" +
//"^FO550,784^GB2,100,2^FS" + "\n" +
//"^FO0,884^GB830,0,2,^FS" + "\n" +
//"^FO33,12^AD,18^FDAir Line^FS" + "\n" +
//"^FO33,452^AD,18^FDAir Waybill No.^FS" + "\n" +
//"^FO33,574^AD,18^FDDestination^FS" + "\n" +
//"^FO410,574^AD,18^FDTotal No. of Pieces^FS" + "\n" +
//"^FO610,695^AD,18^FDOrigin^FS" + "\n" +
//"^FO33,796^AD,18^FDHAWB No.^FS" + "\n" +
//"^FO560,796^AD,18^FDHAWB PCS^FS" + "\n" +
//"^FO33,896^AD,18^FDHAWB Weight^FS" + "\n" +
//"^XZ",this);
            }
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.Now); //or a date much earlier than current time
        }

  	[WebMethod]
        public static void SetPrintCommand(string sid_command)
        {           
            string sid=sid_command.Split('_')[0];
            string command = sid_command.Split('_')[1];
           HttpContext.Current.Application[sid + CommonConstants.PrintCommand] = command;
        }


        protected void Page_Load(object sender, System.EventArgs e)
        {
            ConnectStr = (new igFunctions.DB().getConStr());

            try
            {
                elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
                user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
                user_type = Request.Cookies["CurrentUserInfo"]["user_type"];
                login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
                login_lname = Request.Cookies["CurrentUserInfo"]["lname"];
                if (Request.Params["Setup"] != "N")
                {
                    CheckSetupSession();
                }
            }
            catch
            {
                string script = "<script language='javascript'>";
                script += "alert('Your session was disconnected by system!\\n');";
                script += "top.location.replace('/freighteasy/index.aspx');";
                script += "</script>";
                Response.Write(script);
                Response.End();
            }

            if (login_lname == "")
            {
                login_lname = login_name;
            }

            PerformLogoView();

            if (!IsPostBack)
            {
                checkView();
                PerformLoadMenuData();
                if (Session["DefaultPage"] != null)
                {
                    txtDefaultPage.Text = Session["DefaultPage"].ToString();
                }
                Session["DefaultPage"] = "";

                PerformGreetingMessage();
            }


        }

        protected void CheckSetupSession()
        {
            string returnURL = "";
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;
            SqlDataReader reader = null;
            string script = "";

            Cmd.CommandText = @"SELECT sid FROM agent a LEFT OUTER JOIN setup_session b ON 
                (a.elt_account_number=b.elt_account_number) WHERE b.page_id IS NOT NULL AND 
                b.updated_date<GETDATE() AND ISNULL(b.elt_account_number,0)=" + elt_account_number;
            try
            {
                Con.Open();
                reader = Cmd.ExecuteReader();
                if (reader.Read())
                {
                    // Forward cookies to setup wizard location
                    Response.Cookies["CurrentUserInfo"].Value = Request.Cookies["CurrentUserInfo"].Value;
                    Response.Cookies["CurrentUserInfo"]["Free_Session_ID"] = reader["sid"].ToString();

                    script = "<script>ask_setup_wizard();</script>";
                    this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script);
                }
            }
            catch { }
            finally
            {
                reader.Close();
                Con.Close();
                Cmd = null;
                Con = null;
            }
        }



        private bool PerformCreateLoginInfo()
        {

            session_id = Request.Cookies["CurrentUserInfo"]["Session_ID"];
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
                    SQL = SQL + "user_type,user_right,login_name,password,org_acct,user_lname,user_fname,user_title,user_address,user_city,user_state,user_zip,user_country,user_phone,user_email,last_login_date,default_warehouse,awb_port,bol_port,sed_port,invoice_port,check_port,shipping_label_port,awb_queue,bol_queue,sed_queue,invoice_queue,check_queue,shipping_label_queue,awb_prn_name,bol_prn_name,sed_prn_name,invoice_prn_name,check_prn_name,shipping_label_prn_name,ig_user_ssn,ig_user_dob,ig_user_cell,ig_recent_work from users where elt_account_number=" + elt_account_number + " AND userid='" + user_id + "'";
                }
                else
                {
                    SQL = SQL + "user_type,user_right,login_name,password,org_acct,user_lname,user_fname,user_title,user_address,user_city,user_state,user_zip,user_country,user_phone,user_email,last_login_date,default_warehouse,awb_port,bol_port,sed_port,invoice_port,check_port,shipping_label_port,awb_queue,bol_queue,sed_queue,invoice_queue,check_queue,shipping_label_queue,awb_prn_name,bol_prn_name,sed_prn_name,invoice_prn_name,check_prn_name,shipping_label_prn_name,ig_user_ssn,ig_user_dob,ig_user_cell,ig_recent_work from users where elt_account_number=80002000 AND userid='1000'";
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

        private void checkView()
        {
            string strTr = "";
            string strTr2 = "";

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
                string script = "<script language='javascript'>";
                string alertHTML = "/IFF_MAIN/FEAlert.html";
                script += "cBoardAssign();";
                if (File.Exists(Server.MapPath(alertHTML)))
                {
                    script += "setTimeout(\"OpenWindow('" + alertHTML + "',650,450)\",3000);";
                }
                script += "</script>";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script);
                Session["MainTR"] = (int)Session["MainTR"] + 1;
            }

            if (elt_account_number == "" || elt_account_number == null)
            {
                string script = "<script language='javascript'>";
                script += "top.location.replace('/freighteasy/index.aspx');";
                script += "</script>";
                Response.Write(script);
            }
        }

        private void PerformGreetingMessage()
        {
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Cmd.CommandText = "SELECT * from ELT_NOTIFICATION where elt_account_number='" + elt_account_number + "' AND userid=" + user_id;

            try
            {
                Con.Open();
                SqlDataReader reader = Cmd.ExecuteReader();
                if (reader.Read())
                {
                    if (DateTime.Parse(reader["expired_to"].ToString()) > DateTime.Now)
                    {
                        this.lblGreeting.Text = reader["message"].ToString();
                    }
                    reader.Close();

                }
                else
                {
                    reader.Close();
                    Cmd.CommandText = "SELECT * from ELT_NOTIFICATION where elt_account_number='" + elt_account_number + "' AND userid=0";
                    reader = Cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        if (DateTime.Parse(reader["expired_to"].ToString()) > DateTime.Now)
                        {
                            this.lblGreeting.Text = reader["message"].ToString();
                        }
                        reader.Close();
                    }
                    else
                    {
                        reader.Close();
                        Cmd.CommandText = " SELECT * from ELT_NOTIFICATION where elt_account_number='0'";
                        reader = Cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            this.lblGreeting.Text = reader["message"].ToString();
                        }
                        reader.Close();
                    }
                }
            }
            catch
            {
                this.lblGreeting.Text = "";
            }
            finally
            {
                Con.Close();
                Cmd = null;
                Con = null;
            }
        }
        private void PerformLogoView()
        {
            string ServerUrl = Server.MapPath("/IFF_MAIN") + "\\ClientLogos\\";
            string strFilePath = "";

            strFilePath = ServerUrl + elt_account_number + ".gif";

            if (File.Exists(strFilePath))
            {
                logoUrl = "ClientLogos/" + elt_account_number + ".gif";
            }
            else
            {
                strFilePath = ServerUrl + elt_account_number + ".jpg";
                if (File.Exists(strFilePath))
                {
                    logoUrl = "ClientLogos/" + elt_account_number + ".jpg";
                }
            }

            if (logoUrl == "")
            {
                logoUrl = "ClientLogos/default.gif";
            }
        }

        private void PerformLoadMenuData()
        {
            ds = new DataSet();
            string topSQL = "select distinct top_module,top_seq_id from tab_master where page_id in (SELECT page_id FROM tab_user WHERE is_faved='Y' AND is_denied='N' AND elt_account_number=" + elt_account_number + " AND user_id=" + user_id + ") order by top_seq_id";
            string midSQL = "select distinct (top_module+' - '+sub_module) as sort_key,top_module,sub_module,top_seq_id,sub_seq_id from tab_master where page_id in (SELECT page_id FROM tab_user WHERE is_faved='Y' AND is_denied='N' AND elt_account_number=" + elt_account_number + " AND user_id=" + user_id + ") order by top_seq_id,sub_seq_id";
            string botSQL = "select (top_module+' - '+sub_module) as sort_key,* from tab_master where page_id in (SELECT page_id FROM tab_user WHERE is_faved='Y' AND is_denied='N' AND elt_account_number=" + elt_account_number + " AND user_id=" + user_id + ") order by top_seq_id,sub_seq_id,page_seq_id";

            try
            {
                MakeDataSet("topLevel", topSQL);
                MakeDataSet("midLevel", midSQL);
                MakeDataSet("botLevel", botSQL);

                DataRelation relation = new DataRelation("topLevelRelation", ds.Tables["topLevel"].Columns["top_module"], ds.Tables["midLevel"].Columns["top_module"], true);
                relation.Nested = true;
                ds.Relations.Add(relation);
                relation = new DataRelation("botLevelRelation", ds.Tables["midLevel"].Columns["sort_key"], ds.Tables["botLevel"].Columns["sort_key"], true);
                relation.Nested = true;
                ds.Relations.Add(relation);
            }
            catch { }
            PopulateTreeView();

        }

        protected void MakeDataSet(string tableName, string sqlText)
        {
            SqlDataAdapter Adap = null;
            SqlConnection Con = null;

            if (sqlText != null && sqlText.Trim() != "")
            {
                try
                {
                    DataTable tempTable = new DataTable(tableName);

                    ConnectStr = (new igFunctions.DB().getConStr());
                    Con = new SqlConnection(ConnectStr);
                    Adap = new SqlDataAdapter();

                    Con.Open();
                    SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
                    Adap.SelectCommand = cmd;
                    Adap.Fill(tempTable);
                    ds.Tables.Add(tempTable);
                }
                catch
                {
                }
                finally
                {
                    if (Adap != null)
                    {
                        Adap.Dispose();
                    }
                    if (Con != null)
                    {
                        Con.Close();
                    }
                }
            }
        }

        public void PopulateTreeView()
        {
            TreeView1.Nodes.Clear();
            try
            {
                foreach (DataRow topRow in ds.Tables["topLevel"].Rows)
                {
                    TreeNode topNode = new TreeNode("<div onclick='return false;' style='color:#000000'>" + topRow["top_module"].ToString() + "</div>");
                    TreeView1.Nodes.Add(topNode);
                    foreach (DataRow midRow in topRow.GetChildRows("topLevelRelation"))
                    {
                        TreeNode midNode = new TreeNode("<div onclick='return false;' style='color:#000000'>" + midRow["sub_module"].ToString() + "</div>");
                        topNode.ChildNodes.Add(midNode);
                        foreach (DataRow botRow in midRow.GetChildRows("botLevelRelation"))
                        {
                            TreeNode botNode = new TreeNode("<div onclick=\"return go_favorite('" + botRow["page_url"].ToString() + "','" + botRow["top_module"].ToString() + "');\" >" + botRow["page_label"].ToString() + "</div>");
                            midNode.ChildNodes.Add(botNode);
                        }
                    }
                }
                TreeView1.CollapseAll();
            }
            catch { }
        }

        override protected void OnInit(EventArgs e)
        {
            InitializeComponent();
            base.OnInit(e);
        }


        private void InitializeComponent()
        {

        }

        private void PerformDBLogOut()
        {
            if (Request.Cookies["CurrentUserInfo"]["elt_account_number"] != null)
            {
                string elt_user_id = Request.Cookies["CurrentUserInfo"]["elt_account_number"].ToString() + Request.Cookies["CurrentUserInfo"]["user_id"].ToString();
                SqlConnection Con = new SqlConnection(ConnectStr);
                SqlCommand Cmd = new SqlCommand();
                Cmd.Connection = Con;
                Con.Open();
                Cmd.CommandText = "Delete view_login where ip='" + Request.Cookies["CurrentUserInfo"]["IP"].ToString() + "' and user_id='" + elt_user_id + "'";
                Cmd.ExecuteNonQuery();
                Con.Close();
                Session["MainTR"] = "";
            }
        }


        protected void btnOut_Click(object sender, System.EventArgs e)
        {

            PerformDBLogOut();

            string strNull = Response.Cookies["CurrentUserInfo"]["elt_account_number"];
            string redPage = "";

            if (Request.Cookies["CurrentUserInfo"] != null)
            {
                try
                {
                    redPage = Request.Cookies["CurrentUserInfo"]["ORIGINPAGE"].ToString();
                }
                catch
                {

                }
                Response.Cookies["CurrentUserInfo"].Value = null;
                Response.Cookies["CurrentUserInfo"].Expires = DateTime.Now;
            }
            if (redPage.ToUpper().IndexOf("LOGIN2.ASPX") >= 0)
            {
                redPage = "";
            }
            string script = "<script language='javascript'>";
            if (redPage != "")
            {
                script += "top.location.replace('" + redPage + "');";
            }
            else
            {
                script += "top.location.replace('/freighteasy/index.aspx');";
            }
            script += "</script>";
            Response.Write(script);
            Response.End();


        }

        protected void btnChkIsAuthenticated_Click(object sender, System.EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                if (Response.Cookies["CurrentUserInfo"] != null)
                {
                    Response.Cookies["CurrentUserInfo"].Value = "";
                    Response.Cookies["CurrentUserInfo"].Expires = DateTime.Now;
                }
                Response.Redirect("Main.aspx");
            }
        }

        protected void btnReload_Click(object sender, System.EventArgs e)
        {
            PerformLoadMenuData();
        }

        protected string GetStartingPage()
        {
            string returnURL = "";
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Cmd.CommandText = "SELECT is_dome,is_intl from agent where elt_account_number=" + elt_account_number;

            try
            {
                Con.Open();
                SqlDataReader reader = Cmd.ExecuteReader();
                if (reader.Read())
                {
                    if (reader["is_dome"].ToString() == "Y")
                    {
                        returnURL = "/IFF_MAIN/ASP/tabs/site_admin_domestic.htm";
                    }
                    else
                    {
                        returnURL = "/IFF_MAIN/ASP/tabs/site_admin.htm";
                    }
                }

                reader.Close();
            }
            catch { }
            finally
            {
                Con.Close();
                Cmd = null;
                Con = null;
            }
            return returnURL;
        }

    }
}
