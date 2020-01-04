using System;
using System.IO;
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
using CrystalDecisions.Shared;

public partial class ASPX_OnLines_CompanyConfig_CompanySearchResult : System.Web.UI.Page
{
    protected DataSet ds;
    protected string ConnectStr;
    private string elt_account_number;
    private string user_id, login_name, user_right;
    //private bool bReadOnly = false;
    private string OrgSqlText;
    private string sqlText;
    private string countText;
    private string orderKey;
    private string uniqueKey;
    private int iPage = 0;
    private int maxRows = 40;
    private string descending;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Cookies["CurrentUserInfo"] == null)
        {
            Response.Write("Try again after login: <a href=\"javascript:window.close()\">Close</a>");
            Response.End();
        }
        else
        {
            try
            {
                elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
                user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
                user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
                login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
                ConnectStr = (new igFunctions.DB().getConStr());
                //bReadOnly = new igFunctions.DB().AUTH_CHECK(elt_account_number, user_id, ConnectStr, Request.ServerVariables["URL"].ToLower(), "");
                string[] strParams = (string[])Session["CompanySearch"];

                OrgSqlText = strParams[0];
                orderKey = strParams[1];
                uniqueKey = "org_account_number";
                
                Session["XML_SQLText"] = OrgSqlText + " order by " + orderKey;

                descending = Request.Params["desc"];
                if (descending == null)
                {
                    descending = "n";
                }

                if (Request.Params["order"] != null)
                {
                    orderKey = Request.Params["order"];
                }

                if (!IsPostBack)
                {
                    BindAll();
                }
            }
            catch (Exception ex)
            {
                if (ex != null)
                {
                    Response.Redirect("CompanySearch.aspx");
                    Response.End();
                }
            }
        }
    }

    protected void BindAll()
    {
        DataGrid1.PageSize = maxRows;
        FormatCountText();
        DataGrid1.VirtualItemCount = GetTotalCount();

        FormatSQLText();
        BindToDataSet("organization");
        FormatDataSet("organization");

        DataGrid1.DataSource = ds.Tables["organization"].DefaultView;
        DataGrid1.DataBind();
        ds.Dispose();
    }

    /* 
     * OnItemCreated event handler
     * Cell format can be changed in this event handler
     */ 
    
    protected void ItemCreated(object sender, DataGridItemEventArgs e)
    {
        int numColumns = 19;

        /*
        if (e.Item.ItemType == ListItemType.Header)
        {
            numColumns = e.Item.Cells.Count;
        }
        */

        if (e.Item.ItemType == ListItemType.Pager)
        {
            TableCell c = e.Item.Cells[0];
            c.Attributes.Add("colspan", numColumns.ToString());
        }

        if (e.Item.ItemType == ListItemType.Item)
        {
            e.Item.Cells[0].Width = Unit.Pixel(130);
            e.Item.Cells[1].Width = Unit.Pixel(110);
            e.Item.Cells[2].Width = Unit.Pixel(40);
            e.Item.Cells[3].Width = Unit.Pixel(80);
            e.Item.Cells[4].Width = Unit.Pixel(110);
            e.Item.Cells[5].Width = Unit.Pixel(110);
            e.Item.Cells[6].Width = Unit.Pixel(110);
            e.Item.Cells[7].Width = Unit.Pixel(110);
            e.Item.Cells[8].Width = Unit.Pixel(100);
        }
    }

    protected void FormatSQLText()
    {
        int indexWhere = OrgSqlText.IndexOf(@"WHERE"); //last occurance of "WHERE"
        System.Text.StringBuilder tempStr = new System.Text.StringBuilder();

        if (OrgSqlText != null && OrgSqlText.Trim() != "")
        {
            string desc = "";

            if (descending == "y")
            {
                desc = "DESC";
            }

            string condStr = OrgSqlText.Substring(indexWhere);

            tempStr.Append(OrgSqlText.Replace("SELECT", "SELECT TOP " + maxRows));
            //tempStr.Append(" AND " + orderKey + " IS NOT NULL AND LTRIM(" + orderKey + ") != ''");
            tempStr.Append(" AND " + uniqueKey + " NOT IN (SELECT TOP " + iPage * maxRows + " " + uniqueKey);
            tempStr.Append(" FROM organization " + condStr);
            //tempStr.Append(" AND " + orderKey + " IS NOT NULL AND LTRIM(" + orderKey + ") != ''");
            tempStr.Append(" ORDER BY " + orderKey + " " + desc +") ORDER BY " + orderKey + " " + desc);

            sqlText = tempStr.ToString();
        }

        //Response.Write(sqlText);
    }


    protected void FormatCountText()
    {
        int indexWhere = OrgSqlText.IndexOf(@"WHERE"); //last occurance of "WHERE"

        if (OrgSqlText != null && OrgSqlText.Trim() != "")
        {
            string condStr = OrgSqlText.Substring(indexWhere);
            countText = "SELECT COUNT(*) FROM organization " + condStr
                //+ " AND " + orderKey + " IS NOT NULL AND LTRIM(" + orderKey + ") != ''"
                ;
        }
    }

    protected void BindToDataSet(string tName)
    {
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;

        if (OrgSqlText != null && OrgSqlText.Trim() != "")
        {
            try
            {
                ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                Adap = new SqlDataAdapter();
                System.Text.StringBuilder state = new System.Text.StringBuilder();
                ds = new DataSet();

                Con.Open();
                SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
                Adap.SelectCommand = cmd;
                Adap.Fill(ds,tName);
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

    protected void FormatDataSet(string tName)
    {
        string tempStr = null;
        
        // loop once in the refined dataset to format the item data
        for (int i = 0; i < ds.Tables["organization"].Rows.Count; i++)
        {
            // make hyperlink
            tempStr = ShortenText(ds.Tables["organization"].Rows[i][1].ToString(),16);
            ds.Tables["organization"].Rows[i][1] = "<a href=\"javascript:call_win('../../../ASP/master_data/client_profile.asp?Action=filter&n="
                + ds.Tables["organization"].Rows[i][0] + "')\">" + tempStr + "</a>";

            // replacing Y's
            for (int j = 10; j < ds.Tables["organization"].Columns.Count; j++)
            {
                if (ds.Tables["organization"].Rows[i][j].ToString() == "Y")
                {
                    ds.Tables["organization"].Rows[i][j] = "<img border=\"0\" src=\"../../../Images/check.gif\">";
                }
            }

            // email format
            tempStr = ShortenText(ds.Tables["organization"].Rows[i][10].ToString(), 12);
            ds.Tables["organization"].Rows[i][10] = "<a href=\"mailto:" + tempStr + "\">" + tempStr + "</a>";

            // city , country name limit
            ds.Tables["organization"].Rows[i][2] = ShortenText(ds.Tables["organization"].Rows[i][2].ToString(), 12);
            ds.Tables["organization"].Rows[i][4] = ShortenText(ds.Tables["organization"].Rows[i][4].ToString(), 10);
            ds.Tables["organization"].Rows[i][5] = ShortenText(ds.Tables["organization"].Rows[i][5].ToString(), 14);
            ds.Tables["organization"].Rows[i][6] = ShortenText(ds.Tables["organization"].Rows[i][5].ToString(), 14);
            ds.Tables["organization"].Rows[i][9] = ShortenText(ds.Tables["organization"].Rows[i][9].ToString(), 14);
        }

        // remove unused columns
        ds.Tables["organization"].Columns.Remove("org_account_number");
        ds.Tables["organization"].Columns.Remove("business_url");

        // make hyperlinked columns headers (sortable columns)
        if (orderKey == "dba_name")
        {
            if (descending == "n")
            {
                ds.Tables["organization"].Columns["dba_name"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=y&order=dba_name\"><font color=\"#ffffff\">Company Name</font><img border=\"0\" src=\"../../../Images/Expand.gif\"></a>";
            }
            else
            {
                ds.Tables["organization"].Columns["dba_name"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=n&order=dba_name\"><font color=\"#ffffff\">Company Name</font><img border=\"0\" src=\"../../../Images/Collapse.gif\"></a>";
            }
        }
        else
        {
            ds.Tables["organization"].Columns["dba_name"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=n&order=dba_name\"><font color=\"#ffffff\">Company Name</font></a>";
        }

        if (orderKey == "business_city")
        {
            if (descending == "n")
            {
                ds.Tables["organization"].Columns["business_city"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=y&order=business_city\"><font color=\"#ffffff\">City</font><img border=\"0\" src=\"../../../Images/Expand.gif\"></a>";
            }
            else
            {
                ds.Tables["organization"].Columns["business_city"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=n&order=business_city\"><font color=\"#ffffff\">City</font><img border=\"0\" src=\"../../../Images/Collapse.gif\"></a>";
            }
        }
        else
        {
            ds.Tables["organization"].Columns["business_city"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=n&order=business_city\"><font color=\"#ffffff\">City</font></a>";
        }


        if (orderKey == "business_state")
        {
            if (descending == "n")
            {
                ds.Tables["organization"].Columns["business_state"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=y&order=business_state\"><font color=\"#ffffff\">State</font><img border=\"0\" src=\"../../../Images/Expand.gif\"></a>";
            }
            else
            {
                ds.Tables["organization"].Columns["business_state"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=n&order=business_state\"><font color=\"#ffffff\">State</font><img border=\"0\" src=\"../../../Images/Collapse.gif\"></a>";
            }
        }
        else
        {
            ds.Tables["organization"].Columns["business_state"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=n&order=business_state\"><font color=\"#ffffff\">State</font></a>";
        }

        if (ds.Tables["organization"].Columns.Contains("business_country"))
        {
            if (orderKey == "business_country")
            {
                if (descending == "n")
                {
                    ds.Tables["organization"].Columns["business_country"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=y&order=business_country\"><font color=\"#ffffff\">Country</font><img border=\"0\" src=\"../../../Images/Expand.gif\"></a>";
                }
                else
                {
                    ds.Tables["organization"].Columns["business_country"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=n&order=business_country\"><font color=\"#ffffff\">Country</font><img border=\"0\" src=\"../../../Images/Collapse.gif\"></a>";
                }
            }
            else
            {
                ds.Tables["organization"].Columns["business_country"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=n&order=business_country\"><font color=\"#ffffff\">Country</font></a>";
            }
        }

        if (ds.Tables["organization"].Columns.Contains("business_zip"))
        {
            if (orderKey == "business_zip")
            {
                if (descending == "n")
                {
                    ds.Tables["organization"].Columns["business_zip"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=y&order=business_zip\"><font color=\"#ffffff\">Zipcode</font><img border=\"0\" src=\"../../../Images/Expand.gif\"></a>";
                }
                else
                {
                    ds.Tables["organization"].Columns["business_zip"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=n&order=business_zip\"><font color=\"#ffffff\">Zipcode</font><img border=\"0\" src=\"../../../Images/Collapse.gif\"></a>";
                }
            }
            else
            {
                ds.Tables["organization"].Columns["business_zip"].ColumnName = "<a href=\"CompanySearchResult.aspx?desc=n&order=business_zip\"><font color=\"#ffffff\">Zipcode</font></a>";
            }
        }

        ds.Tables["organization"].Columns["business_phone"].ColumnName = "Phone";
        ds.Tables["organization"].Columns["business_fax"].ColumnName = "Fax";
        ds.Tables["organization"].Columns["name"].ColumnName = "Contact";
        ds.Tables["organization"].Columns["owner_phone"].ColumnName = "Contact Phone";
        ds.Tables["organization"].Columns["owner_email"].ColumnName = "Email";
        ds.Tables["organization"].Columns["is_consignee"].ColumnName = "Cgn";
        ds.Tables["organization"].Columns["is_shipper"].ColumnName = "Shp";
        ds.Tables["organization"].Columns["is_agent"].ColumnName = "Agn";
        ds.Tables["organization"].Columns["is_carrier"].ColumnName = "Crr";
        ds.Tables["organization"].Columns["z_is_trucker"].ColumnName = "Trk";
        ds.Tables["organization"].Columns["z_is_warehousing"].ColumnName = "WH";
        ds.Tables["organization"].Columns["z_is_cfs"].ColumnName = "CFS";
        ds.Tables["organization"].Columns["z_is_broker"].ColumnName = "Brk";
        ds.Tables["organization"].Columns["z_is_govt"].ColumnName = "Gov";
        ds.Tables["organization"].Columns["z_is_special"].ColumnName = "Otr";
    }

    //Gets the total number of data rows in the beginning (for paging)
    private int GetTotalCount()
    {
        int count = 0;
        SqlConnection Con = null;

        if (OrgSqlText != null && OrgSqlText.Trim() != "")
        {
            try
            {
                ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                System.Text.StringBuilder state = new System.Text.StringBuilder();
                ds = new DataSet();
                
                Con.Open();
                SqlCommand cmd = new SqlCommand(countText, Con);
                count = (int)cmd.ExecuteScalar();
            }
            catch (Exception ex)
            {
                Response.Write(ex.ToString());
                Response.End();
            }
            finally
            {
                if (Con != null)
                {
                    Con.Close();
                }
            }
        }
        return count;
    }

    // OnSelectedIndexChanged even handler
    // ipage keeps track of current page number
    protected void SelectedIndexChanged(object sender, DataGridPageChangedEventArgs e)
    {
        iPage = e.NewPageIndex;
        DataGrid1.CurrentPageIndex = e.NewPageIndex;
        BindAll();
    }

    // Utility function to shrink down a text so that it can fit into a given space of a column
    private string ShortenText(string text, int limit)
    {
        string temp = "";
        if (text != null && text.Trim() != "")
        {
            if (text.Length > limit)
            {
                temp = text.Substring(0, limit) + "...";
            }
            else
            {
                temp = text;
            }
        }
        return temp;
    }


    //exporting Document
    protected ReportSourceManager rsm = null;

    private void LoadReport()
    {
        rsm = new ReportSourceManager();

        try
        {
            rsm.LoadDataSet(ds);
            rsm.WriteXSD(Server.MapPath("../../../CrystalReportResources/xsd/CompanySearch.xsd"));
            rsm.BindNow(Server.MapPath("../../../CrystalReportResources/rpt/CompanySearch.rpt"));
        }
        catch (Exception e)
        {
            Response.Write("Failed to Load");
            Response.End();
        }
    }

    protected void ExportToPDF(object sender, System.EventArgs e)
    {
        string tempFile = Session.SessionID.ToString();
        sqlText = OrgSqlText + " order by " + orderKey;
        BindToDataSet("organization");
        LoadReport();
        //rsm.getReportDocument().ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, tempFile);
        //rsm.CloseReportDocumnet();

        Response.Clear();
        Response.Buffer = true;
        Response.ContentType = "application/pdf";
        Response.AddHeader("Content-Type", "application/pdf");
        Response.AddHeader("Content-disposition", "attachment;filename=" + tempFile + ".pdf");

        MemoryStream oStream; // using System.IO
        oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.PortableDocFormat);
        rsm.CloseReportDocumnet();
        Response.BinaryWrite(oStream.ToArray());
        Response.Flush();
        Response.End();
    }

    protected void ExportToDOC(object sender, System.EventArgs e)
    {
        string tempFile = Session.SessionID.ToString();
        sqlText = OrgSqlText + " order by " + orderKey;
        BindToDataSet("organization");
        LoadReport();
        //rsm.getReportDocument().ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, tempFile);
        //rsm.CloseReportDocumnet();

        Response.Clear();
        Response.Buffer = true;
        Response.ContentType = "application/pdf";
        Response.AddHeader("Content-Type", "application/pdf");
        Response.AddHeader("Content-disposition", "attachment;filename=" + tempFile + ".doc");

        MemoryStream oStream; // using System.IO
        oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.WordForWindows);
        rsm.CloseReportDocumnet();
        Response.BinaryWrite(oStream.ToArray());
        Response.Flush();
        Response.End();
    }

    protected void ExportToExcel(object sender, System.EventArgs e)
    {
        string tempFile = Session.SessionID.ToString();
        sqlText = OrgSqlText + " order by " + orderKey;
        BindToDataSet("organization");
        LoadReport();
        //rsm.getReportDocument().ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, tempFile);
        //rsm.CloseReportDocumnet();

        Response.Clear();
        Response.Buffer = true;
        Response.ContentType = "application/pdf";
        Response.AddHeader("Content-Type", "application/pdf");
        Response.AddHeader("Content-disposition", "attachment;filename=" + tempFile + ".xls");

        MemoryStream oStream; // using System.IO
        oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.ExcelRecord);
        rsm.CloseReportDocumnet();
        Response.BinaryWrite(oStream.ToArray());
        Response.Flush();
        Response.End();
    }

    protected void SearchNew(object sender, System.EventArgs e)
    {
        Response.Redirect("./CompanySearch.aspx");
    }
}
