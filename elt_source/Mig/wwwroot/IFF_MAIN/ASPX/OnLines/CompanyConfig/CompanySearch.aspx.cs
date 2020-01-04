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

public partial class ASPX_OnLines_CompanyConfig_CompanySearch : System.Web.UI.Page
{
    protected string ConnectStr;
    private string elt_account_number;
    private string user_id, login_name, user_right;
    private bool bReadOnly = false;
    private string[] alphabet = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "?" };
    private string[] strParams = null;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Cookies["CurrentUserInfo"] == null)
        {
            Response.Write("Try again after login: <a href=\"javascript:window.close()\">Close</a>");
            Response.End();
        }
        else
        {
            strParams = new string[2];
            Session.LCID = 1033;
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
            login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
            ConnectStr = (new igFunctions.DB().getConStr());
            bReadOnly = new igFunctions.DB().AUTH_CHECK(elt_account_number, user_id, ConnectStr, Request.ServerVariables["URL"].ToLower(), ""); 
        }
    }

/******************************
 * Initiating Components
 * OnInit has been overridden
 ******************************/

    override protected void OnInit(EventArgs e)
    {
        
        initBizType();
        initRegionOpt();
        initBizFL();
        initBizAct();
        initSortKey();
        base.OnInit(e);

    }

    private void initBizType()
    {
        BizType.Items.Add("ALL");
        BizType.Items.Add("Shipper");
        BizType.Items.Add("Consignee");
        BizType.Items.Add("Forwarder");
        BizType.Items.Add("Broker");
        BizType.Items.Add("Trucker");
        BizType.Items.Add("Warehousing");
        BizType.Items.Add("Special/Others");
        BizType.Items.Add("Govt");
        BizType.Items.Add("CFS");
        BizType.Items.Add("Carrier");
        BizType.SelectedIndex = 0;
    }

    private void initRegionOpt()
    {
        RegionOpt.Items.Add("");
        RegionOpt.Items.Add("City");
        RegionOpt.Items.Add("State");
        RegionOpt.Items.Add("Country");
        RegionOpt.Items.Add("Zipcode (First 2 Digit)");
        RegionOpt.SelectedIndex = 0;
    }

    private void initBizFL()
    {
        BizFL.Items.Add("");
        if (alphabet != null)
        {
            for (int i = 0; i < alphabet.Length; i++)
            {
                BizFL.Items.Add(alphabet[i]);
            }
        }
        BizFL.SelectedIndex = 0;
    }

    private void initBizAct()
    {
        BizAct.Items.Add("ALL");
        BizAct.Items.Add("Active");
        BizAct.Items.Add("Inactive");
        BizAct.SelectedIndex = 0;
    }

    private void initSortKey()
    {
        SortKey.Items.Add(new ListItem("Business Name", "dba_name"));
        SortKey.Items.Add(new ListItem("City", "business_city"));
        SortKey.Items.Add(new ListItem("State", "business_state"));
        SortKey.Items.Add(new ListItem("Country", "business_country"));
        SortKey.SelectedIndex = 0;
    }

/****************************************
 * Event Handling
 *
 ***************************************/

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        string[] conditions = new string[6];
        conditions[0] = BizType.SelectedValue;
        conditions[1] = RegionOpt.SelectedValue;
        conditions[2] = RegionList.SelectedValue;
        conditions[3] = BizFL.SelectedValue;
        conditions[4] = BizNamePiece.Text;
        conditions[5] = BizAct.SelectedValue;

        makeSQLStatement(conditions);
        strParams[1] = SortKey.SelectedValue;
        Session.Add("CompanySearch", strParams);

        Response.Redirect("CompanySearchResult.aspx");
    }

    protected void RegionOpt_SelectedIndexChanged(object sender, EventArgs e)
    {
        string tempStr = RegionOpt.SelectedValue;
        if (tempStr != null && tempStr.Trim() != "")
        {
            string keyStr = "";
            ConnectStr = (new igFunctions.DB().getConStr());
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlDataAdapter Adap = new SqlDataAdapter();
            System.Text.StringBuilder state = new System.Text.StringBuilder();
            DataTable datTab = new DataTable();

            state.Append(@"SELECT DISTINCT");

            switch (tempStr)
            {
                case "City":
                    keyStr = " business_city ";
                    break;
                case "State":
                    keyStr = " business_state ";
                    break;
                case "Country":
                    keyStr = " business_country ";
                    break;
                case "Zipcode (First 2 Digit)":
                    keyStr = " substring(business_zip,0,3) ";
                    break;
            }

            state.Append(keyStr);
            state.Append("FROM organization WHERE elt_account_number = " + elt_account_number);
            state.Append(" and" + keyStr + "is NOT NULL and LTRIM(" + keyStr + ") != ''");

            Con.Open();
            SqlCommand cmd = new SqlCommand(state.ToString(), Con);
            Adap.SelectCommand = cmd;
            Adap.Fill(datTab);
            Adap.Dispose();
            Con.Close();
            UpdateRegionList(datTab);
        }
        else
        {
            RegionList.Items.Clear();
        }
    }

    protected void UpdateRegionList(DataTable datTab)
    {
        RegionList.Items.Clear();
        for (int i=0; i < datTab.Rows.Count; i++)
        {
            RegionList.Items.Add(datTab.Rows[i][0].ToString());
        }
    }

/*************************************
 * SQL Analyzing
 * 
 * **********************************/

    private void makeSQLStatement(string [] conditions)
    {
        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlDataAdapter Adap = new SqlDataAdapter();
        System.Text.StringBuilder state = makeSQLHeader(conditions);

        for (int i = 0; i < conditions.Length; i++)
        {
            if (conditions[i] != null && conditions[i].Trim() != "" && conditions[i]!= "ALL")
            {
                switch (i)
                {
                    case 0:
                        state.Append(" AND ");
                        state.Append(SQLMultiListBox(BizType));
                        break;
                    case 1:
                        break;
                    case 2:
                        state.Append(" AND ");
                        state.Append(SQLMultiListBox(RegionList));
                        break;
                    case 3:
                        state.Append(" AND dba_name LIKE '");
                        state.Append(conditions[i]);
                        state.Append("%' ");
                        break;
                    case 4:
                        state.Append(" AND dba_name LIKE '%");
                        state.Append(conditions[i]);
                        state.Append("%' ");
                        break;
                    case 5:
                        state.Append(" AND account_status");
                        if (conditions[i].Equals("Active"))
                        {
                            state.Append("='A'");
                        }
                        else
                        {
                            state.Append("<>'A'");
                        }
                        break;
                }
            }
        }

        Con.Close();

        strParams[0] = state.ToString();
    }

    private string SQLMultiListBox(ListBox listBox)
    {
        int selectedCount = 0;
        int totalSelectedCount = 0;
        System.Text.StringBuilder tempStr = new System.Text.StringBuilder();

        totalSelectedCount = GetTotalSelectedCount(listBox);
        tempStr.Append("(");
        for (int j = 0; j < listBox.Items.Count; j++)
        {
            if (listBox.Items[j].Selected)
            {
                selectedCount++;
                if (listBox.ID.ToString() == "BizType")
                {
                    tempStr.Append(SQLBizType(listBox.Items[j].ToString()));
                }
                if (listBox.ID.ToString() == "RegionList")
                {
                    tempStr.Append(SQLRegion(RegionOpt.SelectedValue.ToString(), listBox.Items[j].ToString()));
                }

                if(selectedCount<totalSelectedCount)
                {
                    tempStr.Append(" OR ");
                }
            }
        }
        tempStr.Append(")");
        return tempStr.ToString();
    }

    private string SQLBizType(string arg)
    {
        System.Text.StringBuilder strHeader = new System.Text.StringBuilder();
        switch (arg)
        {
            case "ALL":
                break;
            case "Shipper":
                strHeader.Append(" is_shipper = 'Y' ");
                break;
            case "Consignee":
                strHeader.Append(" is_consignee = 'Y' ");
                break;
            case "Forwarder":
                strHeader.Append(" is_agent = 'Y' ");
                break;
            case "Broker":
                strHeader.Append(" z_is_broker = 'Y' ");
                break;
            case "Trucker":
                strHeader.Append(" z_is_trucker = 'Y' ");
                break;
            case "Warehousing":
                strHeader.Append(" z_is_warehousing = 'Y' ");
                break;
            case "Special/Others":
                strHeader.Append(" z_is_special = 'Y' ");
                break;
            case "Govt":
                strHeader.Append(" z_is_govt = 'Y' ");
                break;
            case "CFS":
                strHeader.Append(" z_is_cfs = 'Y' ");
                break;
            case "Carrier":
                strHeader.Append(" is_carrier = 'Y' ");
                break;
            default:
                break;
        }

        return strHeader.ToString();
    }

    private string SQLRegion(string arg1, string arg2)
    {
        System.Text.StringBuilder strHeader = new System.Text.StringBuilder();

        switch(arg1)
        {
            case "City":
                strHeader.Append(" business_city='");
                break;
            case "State":
                strHeader.Append(" business_state='");
                break;
            case "Country":
                strHeader.Append(" business_country='");
                break;
            case "Zipcode (First 2 Digit)":
                strHeader.Append(" substring(business_zip,0,3)='");
                break;
        }
        strHeader.Append(arg2+"'");
        
        return strHeader.ToString();
    }

    private System.Text.StringBuilder makeSQLHeader(string[] strs)
    {
        System.Text.StringBuilder strHeader = new System.Text.StringBuilder(4096);

        if (strs[1].Contains("Zipcode"))
        {
            strHeader.Append(@"
										SELECT
                                                org_account_number,
                                                dba_name,
												business_city,
												business_state,
												business_zip,
												business_phone,
												business_fax,
												business_url,
												( owner_lname + owner_mname + owner_fname ) as name,
												owner_phone,
												owner_email,
                                                is_consignee,
                                                is_shipper, 
                                                is_agent, 
                                                is_carrier,
                                                z_is_trucker,
                                                z_is_warehousing,
                                                z_is_cfs,
                                                z_is_broker,
                                                z_is_govt,
                                                z_is_special
                                           FROM organization 
                                           WHERE elt_account_number = " + elt_account_number
                );
        }

        else
        {
            strHeader.Append(@"
										SELECT
                                                org_account_number,
                                                dba_name,
												business_city,
												business_state,
												business_country,
												business_phone,
												business_fax,
												business_url,
												( owner_lname + owner_mname + owner_fname ) as name,
												owner_phone,
												owner_email,
                                                is_consignee,
                                                is_shipper, 
                                                is_agent, 
                                                is_carrier,
                                                z_is_trucker,
                                                z_is_warehousing,
                                                z_is_cfs,
                                                z_is_broker,
                                                z_is_govt,
                                                z_is_special
                                           FROM organization 
                                           WHERE elt_account_number = " + elt_account_number
                            );
        }
        return strHeader;
    }
/*
 * Additional Functions
 * 
 */
    private int GetTotalSelectedCount(ListBox listBox)
    {
        int totalCount = 0;

        for (int i = 0; i < listBox.Items.Count; i++)
        {
            if (listBox.Items[i].Selected)
            {
                totalCount++;
            }
        }
        return totalCount;
    }
}
