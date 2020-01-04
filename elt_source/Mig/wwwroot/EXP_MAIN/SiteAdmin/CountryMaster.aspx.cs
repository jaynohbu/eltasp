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
public partial class SiteAdmin_CountryMaster : System.Web.UI.Page
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
    }

    protected void SqlDataSource1_Init(object sender, EventArgs e)
    {
        Get_Cookies();
        SqlDataSource obj = (SqlDataSource)sender;
        obj.ConnectionString = (new igFunctions.DB().getConStr());
        obj.SelectCommand = "SELECT country_name,country_code FROM country_code WHERE elt_account_number="
            + elt_account_number + " order by country_code";
    }

    protected void SqlDataSource2_Init(object sender, EventArgs e)
    {
        Get_Cookies();
        SqlDataSource obj = (SqlDataSource)sender;
        obj.ConnectionString = (new igFunctions.DB().getConStr());
        obj.SelectCommand = "SELECT distinct country_name,country_code FROM all_country_code where "
            + "country_code not in (SELECT country_code FROM country_code WHERE elt_account_number="
            + Request.Cookies["CurrentUserInfo"]["elt_account_number"]
            + ") order by country_code";
    }

    protected void MakeEmptyGridView(GridView gridie, SqlDataSource sqlSource)
    {
        sqlSource.SelectCommand = "SELECT '' as country_name,'' as country_code";
        gridie.DataBind();
        gridie.Rows[0].Cells[0].Text = "";
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Remove")
        {
            string sqlStr = "DELETE FROM country_code WHERE country_code='"
                + e.CommandArgument.ToString() + "' AND elt_account_number=" + elt_account_number;
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
            string sqlStr = "INSERT INTO country_code SELECT " + elt_account_number
                + ",country_name,country_code FROM all_country_code WHERE country_code='"
                + e.CommandArgument.ToString() + "'";
            FreightEasy.DataManager.FreightEasyData FEData = new FreightEasy.DataManager.FreightEasyData();
            FEData.DataTransaction(sqlStr);
        }

        GridView1.DataBind();
        GridView2.DataBind();
        Initialize_Components();
    }

    protected void btnAddAll_Click(object sender, EventArgs e)
    {

        string sqlStr = "INSERT INTO country_code SELECT " + elt_account_number
            + ",country_name,country_code FROM all_country_code WHERE "
            + "country_code not in (SELECT country_code FROM country_code WHERE elt_account_number="
            + elt_account_number + ")";

        FreightEasy.DataManager.FreightEasyData FEData = new FreightEasy.DataManager.FreightEasyData();
        FEData.DataTransaction(sqlStr);

        GridView1.DataBind();
        GridView2.DataBind();
        Initialize_Components();
    }

    protected void btnDeleteAll_Click(object sender, EventArgs e)
    {
        string sqlStr = "DELETE FROM country_code WHERE elt_account_number=" + elt_account_number;

        FreightEasy.DataManager.FreightEasyData FEData = new FreightEasy.DataManager.FreightEasyData();
        FEData.DataTransaction(sqlStr);

        GridView1.DataBind();
        GridView2.DataBind();
        Initialize_Components();
    }
}

