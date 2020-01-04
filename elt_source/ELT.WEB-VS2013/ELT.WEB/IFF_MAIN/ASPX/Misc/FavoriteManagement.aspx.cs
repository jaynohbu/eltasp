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

namespace IFF_MAIN.ASPX.Misc
{
    /// <summary>
    /// FavoriteManagement에 대한 요약 설명입니다.
    /// </summary>
    public partial class FavoriteManagement : System.Web.UI.Page
    {
        public string elt_account_number;
		public string user_id,login_name,user_right;

        public string windowName;
        public bool bReadOnly;
        public string ConnectStr;
        protected DataSet ds;
        protected SqlDataAdapter Adap;
        private void Page_Load(object sender, System.EventArgs e)
        {
            Session.LCID = 1033;
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
            login_name = Request.Cookies["CurrentUserInfo"]["login_name"];

            windowName = Request.QueryString["WindowName"];

            ConnectStr = (new igFunctions.DB().getConStr());
            bReadOnly = new igFunctions.DB().AUTH_CHECK(elt_account_number, user_id, ConnectStr, Request.ServerVariables["URL"].ToLower(), "");

            if (!IsPostBack)
            {
                PerformGetAll();
            }
        }

        private void PerformGetAll()
        {
            PerformGetAllData();

            PerformFilterAll();

        }
        private void PerformFilterAll()
        {

            foreach (Infragistics.WebUI.UltraWebNavigator.Node node in wtFavorite.Nodes)
            {
                if (node.Nodes.Count == 0)
                {
                    node.Hidden = true;
                }
            }
        }

        private void PerformGetAllData()
        {
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmdModule = new SqlCommand("SELECT module_id, Description as Module from SE_MODULES order by module_id", Con);
            SqlCommand cmdPage = new SqlCommand("", Con);

            cmdPage.CommandText = @"SELECT 
                                              a.Page_Id as page_id, 
                                              b.module_id as module_Id, 
                                              ( c.name + ' (' + c.description + ') ' ) as Page,
                                     CASE    WHEN a.Fav = 'X' THEN
                                                 'true' 
                                            ELSE '' 
                                     END AS FavChk
                                   from SE_User_Authority a,SE_MODULES b,SE_Pages c where b.module_id = c.module_id and a.Page_id = c.Page_id";
            cmdPage.CommandText += " and a.elt_account_number=" + elt_account_number + " and UserID=" + user_id;
            cmdPage.CommandText += " order by b.module_id ,c.morder ";


            Adap = new SqlDataAdapter();
            ds = new DataSet();

            Con.Open();

            Adap.SelectCommand = cmdModule;
            Adap.Fill(ds, "Module");

            Adap.SelectCommand = cmdPage;
            Adap.Fill(ds, "Page");

            if (ds.Tables["Page"].Rows.Count == 0)
            {
                if (user_right == "9")
                {
                    cmdPage.CommandText = @"SELECT 
                                              c.Page_Id as page_id, 
                                              b.module_id as module_Id, 
                                              ( c.name + ' (' + c.description + ') ' ) as Page,
                                              '' AS FavChk
                                   from SE_MODULES b,SE_Pages c where b.module_id = c.module_id ";
                    cmdPage.CommandText += " order by b.module_id ,c.morder ";
                    Adap.SelectCommand = cmdPage;
                    Adap.Fill(ds, "Page");
                }
            }

            Con.Close();

            try
            {
                ds.Relations.Add("module_id", ds.Tables["Module"].Columns["module_id"], ds.Tables["Page"].Columns["module_id"]);
            }
            catch (System.Exception x)
            {
                string s = x.Message;
            }

            this.wtFavorite.DataSource = ds.Tables["Module"].DefaultView;
            this.wtFavorite.Levels[0].RelationName = "module_id";
            this.wtFavorite.Levels[0].LevelKeyField = "module_id";
            this.wtFavorite.Levels[1].LevelKeyField = "page_id";
            this.wtFavorite.Levels[0].ColumnName = "Module";
            this.wtFavorite.Levels[1].ColumnName = "Page";
            this.wtFavorite.Levels[1].CheckboxColumnName = "FavChk";

            this.wtFavorite.DataMember = "Module";
            this.wtFavorite.DataBind();

            try
            {
                foreach (Infragistics.WebUI.UltraWebNavigator.Node node in wtFavorite.Nodes)
                {
                    if (node.Nodes.Count > 0)
                    {
                        int iCnt = 0;
                        foreach (Infragistics.WebUI.UltraWebNavigator.Node ChildNode in node.Nodes)
                        {
                            if (ChildNode.Checked)
                            {
                                iCnt++;
                            }
                        }
                        node.Style.Font.Bold = true;
                        if (iCnt == node.Nodes.Count) node.Checked = true;
                    }

                }
            }
            catch (Exception ex)
            {
            }
            
            this.wtFavorite.ExpandAll();


        }

        #region Web Form 디자이너에서 생성한 코드
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: 이 호출은 ASP.NET Web Form 디자이너에 필요합니다.
            //
            InitializeComponent();
            base.OnInit(e);
        }

        /// <summary>
        /// 디자이너 지원에 필요한 메서드입니다.
        /// 이 메서드의 내용을 코드 편집기로 수정하지 마십시오.
        /// </summary>
        private void InitializeComponent()
        {
        }
        #endregion

        protected void btnStReload_Click1(object sender, ImageClickEventArgs e)
        {
            this.wtFavorite.ClearAll();
            PerformGetAll();
        }
        protected void btnSave_Click1(object sender, ImageClickEventArgs e)
        {
            if (performSave())
            {
                lblError.Text = "Data was saved successfully.";
                string script = "<script language='javascript'>";
                script += "refreshMain();";
                script += "</script>";
                this.ClientScript.RegisterClientScriptBlock(this.GetType(), "PreLoad", script);
            }
        }

        private bool performSave()
        {
            string e = "";    
            string strUpdate = @" UPDATE SE_User_Authority SET Fav = @Fav
                                    WHERE  
                                        elt_account_number = @elt_account_number
                                    AND UserID = @UserID
                                    AND Page_id = @Page_id
                                ";

            string strInsert = @" INSERT INTO     SE_User_Authority  
											   (
												elt_account_number,                                                                         
												userid,
												page_id,
												authority_id,
												fav
                                                )
										VALUES  
											   (
												@elt_account_number,
												@userid,
												@page_id,
												0,
												@fav
												)";

            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Con.Open();

            SqlTransaction trans = Con.BeginTransaction();

            Cmd.Transaction = trans;

            try
            {
                foreach (Infragistics.WebUI.UltraWebNavigator.Node node in wtFavorite.Nodes)
                {
                    if (node.Nodes.Count > 0)
                    {
                        foreach (Infragistics.WebUI.UltraWebNavigator.Node ChildNode in node.Nodes)
                        {
                            string strPage_id = ChildNode.DataKey.ToString();
                            string strX = "";
                            if (ChildNode.Checked)
                            {
                                strX = "X";
                            }
                            else
                            {
                                strX = " ";
                            }

                            Cmd.CommandText =
                            "SELECT COUNT(*) as CNT FROM SE_User_Authority WHERE elt_account_number=" + elt_account_number +
                            " AND userid=" + user_id + " AND page_id=" + strPage_id;
                            SqlDataReader reader = Cmd.ExecuteReader();
                            if (reader.Read()) /* Update */
                            {
                                if (int.Parse(reader["CNT"].ToString()) > 0)
                                {
                                    reader.Close();
                                    Cmd.CommandText = strUpdate;
                                    Cmd.Parameters.Clear();
                                    Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal, 9).Value = elt_account_number;
                                    Cmd.Parameters.Add("@UserID", SqlDbType.Decimal, 9).Value = user_id;
                                    Cmd.Parameters.Add("@Page_Id", SqlDbType.Int, 4).Value = strPage_id;
                                    Cmd.Parameters.Add("@Fav", SqlDbType.Char, 1).Value = strX;
                                    Cmd.ExecuteNonQuery();
                                }
                                else
                                {
                                    reader.Close();
                                    Cmd.CommandText = strInsert;
                                    Cmd.Parameters.Clear();
                                    Cmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal, 9).Value = elt_account_number;
                                    Cmd.Parameters.Add("@UserID", SqlDbType.Decimal, 9).Value = user_id;
                                    Cmd.Parameters.Add("@Page_Id", SqlDbType.Int, 4).Value = strPage_id;
                                    Cmd.Parameters.Add("@Fav", SqlDbType.Char, 1).Value = strX;
                                    Cmd.ExecuteNonQuery();
                                }
                            }
                        }
                    }

                }
                trans.Commit();
            }
            catch (Exception ex)
            {
                trans.Rollback();
                lblError.Text = ex.Message;
                e = ex.Message;
            }
            finally
            {
                Con.Close();
            }
            if (e != "")
            {
                return false;
            }
            else
            {
                return true;
            }

        }
}
}
