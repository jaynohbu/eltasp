using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class SystemAdmin_ModuleManagerVer2 : System.Web.UI.Page
{
    protected DataSet ds;
    protected string ConnectStr = null;
    private string elt_account_number = null;
    private string user_id, login_name, user_right;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            ds = new DataSet();
            Session.LCID = 1033;
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
            login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
            ConnectStr = (new igFunctions.DB().getConStr());

            if (!IsPostBack)
            {
                LoadParameters();
                InitializeForm();
                PerformSearch();
                PopulateTreeView();
            }
        }
        catch { }
    }

    protected void LoadParameters()
    {
    }

    protected void InitializeForm()
    {
    }

    protected void PerformSearch()
    {
        string topSQL = "select distinct top_module,top_seq_id from tab_master order by top_seq_id";
        string midSQL = "select distinct (top_module+' - '+sub_module) as sort_key,top_module,sub_module,top_seq_id,sub_seq_id from tab_master order by top_seq_id,sub_seq_id";
        string botSQL = "select (top_module+' - '+sub_module) as sort_key,* from tab_master order by top_seq_id,sub_seq_id,page_seq_id";

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
        string tmpStr = "";
        //TreeView1.Nodes.Add(new TreeNode("<font color=#885599'>Add New</font>", "New^" ));
        foreach (DataRow topRow in ds.Tables["topLevel"].Rows)
        {
            TreeNode topNode = new TreeNode("<a>" + topRow["top_module"].ToString() + "</a>");
            TreeView1.Nodes.Add(topNode);
            //topNode.ChildNodes.Add(new TreeNode("<font color=#885599'>Add New</font>", "New^" + topRow["top_module"].ToString() ));
            foreach (DataRow midRow in topRow.GetChildRows("topLevelRelation"))
            {
                TreeNode midNode = new TreeNode("<a>" + midRow["sub_module"].ToString() + "</a>");
                topNode.ChildNodes.Add(midNode);
                //midNode.ChildNodes.Add(new TreeNode("<font color=#885599'>Add New</font>", "New^" + midRow["top_module"].ToString() + "^" + midRow["sub_module"].ToString()));
                foreach (DataRow botRow in midRow.GetChildRows("botLevelRelation"))
                {
                    tmpStr = botRow["top_module"].ToString() + "^" + botRow["sub_module"].ToString() + "^" + botRow["page_label"].ToString();
                    TreeNode botNode = new TreeNode("<font color=#669955'>" + botRow["page_label"].ToString() + "</font>",tmpStr);
                    midNode.ChildNodes.Add(botNode);
                }
            }
        }
        TreeView1.CollapseAll();
    }

    protected void TreeView1_SelectedNodeChanged(object sender, EventArgs e)
    {
        TreeView tv = (TreeView)sender;
        string[] args = tv.SelectedValue.Split('^');

        if (args[0] == "New")
        {
            if(tv.SelectedNode.Depth == 2){
                chkPageStatus.Checked = true;
                txtTopModule.Text = args[1];
                txtTopModule.BackColor = System.Drawing.Color.LightGray;
                txtTopModule.ReadOnly = true;
                txtSubModule.Text = args[2];
                txtSubModule.BackColor = System.Drawing.Color.LightGray;
                txtSubModule.ReadOnly = true;
                txtPageLabel.Text = "";
                txtPageURL.Text = "";
                txtTopSeqId.Text = "1";
                txtSubSeqId.Text = "1";
                txtPageSeqId.Text = "1";
                hPageId.Value = "";
            }
            else if (tv.SelectedNode.Depth == 1)
            {
                chkPageStatus.Checked = true;
                txtTopModule.Text = args[1];
                txtTopModule.BackColor = System.Drawing.Color.LightGray;
                txtTopModule.ReadOnly = true;
                txtSubModule.Text = "";
                txtSubModule.BackColor = System.Drawing.Color.Transparent;
                txtSubModule.ReadOnly = false;
                txtPageLabel.Text = "";
                txtPageURL.Text = "";
                txtTopSeqId.Text = "1";
                txtSubSeqId.Text = "1";
                txtPageSeqId.Text = "1";
                hPageId.Value = "";
            }
            else if (tv.SelectedNode.Depth == 0)
            {
                chkPageStatus.Checked = true;
                txtTopModule.Text = "";
                txtTopModule.BackColor = System.Drawing.Color.Transparent;
                txtTopModule.ReadOnly = false;
                txtSubModule.Text = "";
                txtSubModule.BackColor = System.Drawing.Color.Transparent;
                txtSubModule.ReadOnly = false;
                txtPageLabel.Text = "";
                txtPageURL.Text = "";
                txtTopSeqId.Text = "1";
                txtSubSeqId.Text = "1";
                txtPageSeqId.Text = "1";
                hPageId.Value = "";
            }
        }
        else
        {
            string sqlText = "select * from tab_master where top_module=N'"
                + args[0] + "' and sub_module=N'" + args[1] + "' and page_label=N'" + args[2] + "'";

            MakeDataSet("selectedPage", sqlText);
            DataTable tmpDt = ds.Tables["selectedPage"];
            if (tmpDt != null)
            {
                if (tmpDt.Rows[0]["page_status"].ToString() == "A")
                {
                    chkPageStatus.Checked = true;
                }
                else
                {
                    chkPageStatus.Checked = false;
                }
                txtTopModule.Text = args[0];
                txtTopModule.BackColor = System.Drawing.Color.LightGray;
                txtTopModule.ReadOnly = true;
                txtSubModule.Text = args[1];
                txtSubModule.BackColor = System.Drawing.Color.LightGray;
                txtSubModule.ReadOnly = true;
                txtPageLabel.Text = args[2];
                txtPageURL.Text = tmpDt.Rows[0]["page_url"].ToString();
                txtTopSeqId.Text = tmpDt.Rows[0]["top_seq_id"].ToString();
                txtSubSeqId.Text = tmpDt.Rows[0]["sub_seq_id"].ToString();
                txtPageSeqId.Text = tmpDt.Rows[0]["page_seq_id"].ToString();
                lstAccessLevel.SelectedValue = tmpDt.Rows[0]["access_level"].ToString();
                hPageId.Value = tmpDt.Rows[0]["page_id"].ToString();
            }
        }
    }

    protected void SaveButtonClick(object sender, EventArgs e)
    {
        if (txtTopModule.Text.Trim() != "" && txtSubModule.Text.Trim() != "" && txtPageLabel.Text.Trim() != ""
            && txtTopSeqId.Text.Trim() != "" && txtSubSeqId.Text.Trim() != "" && txtPageSeqId.Text.Trim() != "")
        {

            SqlConnection Con = null;
            try
            {
                string ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = Con;
                Con.Open();
                SqlTransaction trans = Con.BeginTransaction();
                cmd.Transaction = trans;
                try
                {
                    string statusStr = "";

                    if (chkPageStatus.Checked)
                    {
                        statusStr = "A";
                    }
                    else
                    {
                        statusStr = "C";
                    }

                    if (hPageId.Value == "")
                    {
                        cmd.CommandText = "UPDATE tab_master SET page_seq_id=page_seq_id+1 WHERE "
                            + "top_seq_id=" + txtTopSeqId.Text + " AND "
                            + "sub_seq_id=" + txtSubSeqId.Text + " AND "
                            + "page_seq_id>=" + txtPageSeqId.Text;

                        cmd.ExecuteNonQuery();

                        cmd.CommandText = "INSERT INTO tab_master(page_label,page_url,top_module,sub_module,"
                            + "page_status,access_level,page_seq_id,sub_seq_id,top_seq_id) "
                            + "VALUES (N'" + txtPageLabel.Text + "',N'" + txtPageURL.Text + "',N'" + txtTopModule.Text
                            + "',N'" + txtSubModule.Text + "',N'" + statusStr + "',N'" + lstAccessLevel.SelectedValue
                            + "'," + txtPageSeqId.Text + "," + txtSubSeqId.Text + "," + txtTopSeqId.Text + ") ";
                        
                        cmd.ExecuteNonQuery();
                    }
                    else
                    {
                         cmd.CommandText = "UPDATE tab_master SET page_label=N'" + txtPageLabel.Text + "',"
                            + "page_url=N'" + txtPageURL.Text + "',"
                            + "page_status=N'" + statusStr + "',"
                            + "access_level=N'" + lstAccessLevel.SelectedValue + "',"
                            + "page_seq_id=" + txtPageSeqId.Text + ","
                            + "sub_seq_id=" + txtSubSeqId.Text + ","
                            + "top_seq_id=" + txtTopSeqId.Text
                            + " WHERE page_id=" + hPageId.Value;

                         cmd.ExecuteNonQuery();
                    }
                    
                    trans.Commit();
                }
                catch (Exception ex) { trans.Rollback(); throw ex; }
            }
            catch (Exception outex) { throw outex; }
            finally { if (Con != null) { Con.Close(); } }

            Response.Redirect("/IFF_MAIN/SystemAdmin/ModuleManagerVer2.aspx");
        }
        else
        {
            Response.Write("<script> alert('Invalid data format!'); window.history.back(-1); </script>");
        }
    }

    protected void DeleteButtonClick(object sender, EventArgs e)
    {
        SqlConnection Con = null;
        try
        {
            string ConnectStr = (new igFunctions.DB().getConStr());
            Con = new SqlConnection(ConnectStr);
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = Con;
            Con.Open();
            SqlTransaction trans = Con.BeginTransaction();
            cmd.Transaction = trans;
            try
            {

                cmd.CommandText = "DELETE FROM tab_master WHERE page_id=" + hPageId.Value;
                cmd.ExecuteNonQuery();

                cmd.CommandText = "UPDATE tab_master SET page_seq_id=page_seq_id-1 WHERE "
                            + "top_seq_id=" + txtTopSeqId.Text + " AND "
                            + "sub_seq_id=" + txtSubSeqId.Text + " AND "
                            + "page_seq_id>" + txtPageSeqId.Text;

                cmd.ExecuteNonQuery();

                trans.Commit();
            }
            catch (Exception ex) { trans.Rollback(); throw ex; }
        }
        catch (Exception outex) { throw outex; }
        finally { if (Con != null) { Con.Close(); } }

        Response.Redirect("/IFF_MAIN/SystemAdmin/ModuleManagerVer2.aspx");
    }
}
