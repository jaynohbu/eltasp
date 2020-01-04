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


public partial class ASPX_OnLines_ScheduleB_SBSelect : System.Web.UI.Page
{
    public string elt_account_number, user_id, login_name, user_right;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        Initialize_Components();
    }

    protected void Initialize_Components()
    {
        if (GridView1.Rows.Count == 0)
        {
            MakeEmptyGridView(GridView1, SqlDataSource1);
        }
        if (GridView2.Rows.Count == 0)
        {
            MakeEmptyGridView(GridView2, SqlDataSource2);
        }
    }

    protected void Get_Cookies()
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];

        if (Request.Params["OrgID"] == null || Request.Params["OrgID"] == "")
        {
            hOrgID.Value = "-1";
        }
        else
        {
            hOrgID.Value = Request.Params["OrgID"];
        }
    }

    protected void SqlDataSource1_Init(object sender, EventArgs e)
    {
        Get_Cookies();
        SqlDataSource obj = (SqlDataSource)sender;
        obj.ConnectionString = (new igFunctions.DB().getConStr());
        obj.SelectCommand = "SELECT sb_id,sb,description FROM ig_schedule_b WHERE elt_account_number="
            + elt_account_number + " AND org_account_number=" + hOrgID.Value + " ORDER BY sb";
    }

    protected void SqlDataSource2_Init(object sender, EventArgs e)
    {
        Get_Cookies();
        SqlDataSource obj = (SqlDataSource)sender;
        obj.ConnectionString = (new igFunctions.DB().getConStr());
        obj.SelectCommand = "SELECT auto_uid AS sb_id,sb,description FROM scheduleB WHERE elt_account_number=" 
            + elt_account_number + " AND sb NOT IN (SELECt sb FROM ig_schedule_b WHERE elt_account_number=" 
            + elt_account_number + " AND org_account_number=" + hOrgID.Value + ") ORDER BY sb";
    }

    protected void MakeEmptyGridView(GridView gridie, SqlDataSource sqlSource)
    {
        sqlSource.SelectCommand = "SELECT '' AS sb_id,'' AS sb,'' AS description";
        gridie.DataBind();
        gridie.Rows[0].Cells[0].Text = "";
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Remove")
        {
            string sqlStr = "DELETE FROM ig_schedule_b WHERE elt_account_number=" 
                + elt_account_number + " AND org_account_number=" + hOrgID.Value
                + " AND sb_id=" + e.CommandArgument.ToString();

            FreightEasy.DataManager.FreightEasyData FEData = new FreightEasy.DataManager.FreightEasyData();
            FEData.DataTransaction(sqlStr);
        }

        GridView1.DataBind();
        GridView2.DataBind();
        Initialize_Components();
    }

    protected void GridView2_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Add")
        {
            string sqlStr = "INSERT INTO ig_schedule_b SELECT " + elt_account_number
            + " AS elt_account_number," + hOrgID.Value + " AS org_account_number"
            + ",sb,sb_unit1,sb_unit2,description,NULL AS is_org_merged,export_code,license_type,eccn,auto_uid"
            + " FROM scheduleB WHERE elt_account_number=" + elt_account_number + " AND auto_uid=" + e.CommandArgument.ToString();
            
            FreightEasy.DataManager.FreightEasyData FEData = new FreightEasy.DataManager.FreightEasyData();
            FEData.DataTransaction(sqlStr);
        }

        GridView1.DataBind();
        GridView2.DataBind();
        Initialize_Components();
    }

    protected void btnAddAll_Click(object sender, EventArgs e)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        ArrayList tranStrAL = new ArrayList();
        string tranStr = "";

        tranStr = "DELETE FROM ig_schedule_b WHERE elt_account_number=" + elt_account_number
            + " AND org_account_number=" + hOrgID.Value;
        tranStrAL.Add(tranStr);

        tranStr = "INSERT INTO ig_schedule_b SELECT " + elt_account_number 
            + " AS elt_account_number," + hOrgID.Value + " AS org_account_number"
            + ",sb,sb_unit1,sb_unit2,description,NULL AS is_org_merged,export_code,license_type,eccn,auto_uid"
            + " FROM scheduleB WHERE elt_account_number=" + elt_account_number;
        tranStrAL.Add(tranStr);

        
        if (!feData.DataTransactions((string[])tranStrAL.ToArray(typeof(string))))
        {
            txtResultBox.Text = feData.GetLastTransactionError();
            txtResultBox.Visible = true;
        }
        else
        {
            GridView1.DataBind();
            GridView2.DataBind();
            Initialize_Components();
        }
    }

    protected void btnDeleteAll_Click(object sender, EventArgs e)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        ArrayList tranStrAL = new ArrayList();
        string tranStr = "";

        tranStr = "DELETE FROM ig_schedule_b WHERE elt_account_number=" + elt_account_number
        +" AND org_account_number=" + hOrgID.Value;
        tranStrAL.Add(tranStr);

        if (!feData.DataTransactions((string[])tranStrAL.ToArray(typeof(string))))
        {
            txtResultBox.Text = feData.GetLastTransactionError();
            txtResultBox.Visible = true;
        }
        else
        {
            GridView1.DataBind();
            GridView2.DataBind();
            Initialize_Components();
        }
    }
}
