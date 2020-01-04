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

public partial class ASPX_Misc_SBItemSelect : System.Web.UI.Page
{
    protected string ConnectStr, user_id, login_name, user_right, elt_account_number;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session.LCID = 1033;

            if (!IsPostBack)
            {
                LoadScheduleBList();
            }
        }
        catch
        {
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        hOrgID.Value = Request.Params["OrgID"];
    }

    protected void LoadScheduleBList()
    {
        string sqlTxt = "";
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();

        if (hOrgID.Value == "" || hOrgID.Value == "0")
        {
            sqlTxt = "SELECT auto_uid AS sb_id,[description] FROM scheduleB WHERE elt_account_number=" 
                + elt_account_number + " ORDER BY [description]";
        }
        else
        {
            sqlTxt = "IF EXISTS (SELECT * FROM ig_schedule_b WHERE elt_account_number="
                + elt_account_number + " AND org_account_number=" + hOrgID.Value + ")\n"
                + "SELECT sb_id,[description],org_account_number FROM ig_schedule_b WHERE elt_account_number="
                + elt_account_number + " AND org_account_number=" + hOrgID.Value + " ORDER BY [description]\n"
                + "ELSE\n"
                + "SELECT auto_uid AS sb_id,[description] FROM scheduleB WHERE elt_account_number=" + elt_account_number + " ORDER BY [description]";
        }

        feData.AddToDataSet("ScheduleB", sqlTxt);
        ListBox1.DataSource = feData.Tables["ScheduleB"];
        ListBox1.DataTextField = "description";
        ListBox1.DataValueField = "sb_id";
        ListBox1.DataBind();
    }

    protected void ListBox1_SelectedIndexChanged(object sender, EventArgs e)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        string sqlTxt = "";
        
        if (hOrgID.Value == "" || hOrgID.Value == "0")
        {
            sqlTxt = "SELECT * FROM ig_schedule_b WHERE elt_account_number=" + elt_account_number + " AND auto_uid=" + ListBox1.SelectedValue;
        }
        else
        {
            sqlTxt = "SELECT * FROM scheduleB WHERE elt_account_number=" + elt_account_number + " AND auto_uid=" + ListBox1.SelectedValue;
        }

        feData.AddToDataSet("scheduleBInfo", sqlTxt);

        if (feData.Tables["scheduleBInfo"].Rows.Count > 0)
        {
            DataRow dtTmp = feData.Tables["scheduleBInfo"].Rows[0];
            hSBCode.Value = dtTmp["sb"].ToString();
            hUnit1.Value = dtTmp["sb_unit1"].ToString();
            hUnit2.Value = dtTmp["sb_unit2"].ToString();
            hDesc.Value = dtTmp["description"].ToString();
            hExportCode.Value = dtTmp["export_code"].ToString();
            hLicenseType.Value = dtTmp["license_type"].ToString();
            hECCN.Value = dtTmp["eccn"].ToString();
        }
    }
}
