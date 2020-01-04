using System;
using System.IO;
using System.Data;
using System.Drawing;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class ASPX_Misc_EmailHistory : System.Web.UI.Page
{
    protected DataSet ds = null;
    protected string ConnectStr = null;
    private string elt_account_number = null;
    private string user_id, login_name, user_right;
    private int maxRows = 20;
    // private string uniqueKey = "auto_uid";
    private string sortKey = "auto_uid";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session.LCID = 1033;
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
            login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
            ConnectStr = (new igFunctions.DB().getConStr());

            if (!IsPostBack)
            {
                DropDownList1_Load();
                LoadParameters();
                BindGridView();
            }
        }
        catch
        {
            Response.Write("<script>alert('Session Expired. Try logining in again'); self.close();</script>");
            Response.End();
        }
    }

    protected void LoadParameters()
    {
        DropDownList1.SelectedValue = Request.Params.Get("title");
        DropDownList2.SelectedValue = Request.Params.Get("ao");
        DropDownList3.SelectedValue = Request.Params.Get("ie");
    }

    protected void BindGridView()
    {
        string screenStr = DropDownList1.SelectedValue;
        string typeStr = DropDownList2.SelectedValue;
        string shipTypeStr = DropDownList3.SelectedValue;
        string fromDate = Webdatetimeedit1.Text.ToString();
        string toDate = Webdatetimeedit2.Text.ToString();
        string billNo = TextBox3.Text.ToString();
        string billType = DropDownList4.SelectedValue;

        string sqlText = "SELECT * FROM email_history where elt_account_number="
            + elt_account_number;
        if (screenStr != "")
        {
            sqlText = sqlText + " AND screen_name='" + screenStr + "'";
        }
        if (typeStr != "")
        {
            sqlText = sqlText + " AND air_ocean='" + typeStr + "'";
        }
        if (shipTypeStr != "")
        {
            sqlText = sqlText + " AND im_export='" + shipTypeStr + "'";
        }
        if (fromDate != "" )
        {
            sqlText = sqlText + " AND sent_date >= '" + fromDate + "'"; 
        }
        if (toDate != "")
        {
            sqlText = sqlText + "AND sent_date <= '" + toDate + "'";
        }
        if (billNo != "")
        {
            sqlText = sqlText + " AND " + billType + "_num LIKE '%" + billNo.Trim() + "%'";
        }
        sqlText = sqlText + " ORDER BY " + sortKey + " DESC"; 

        MakeDataSet("EmailHistory", sqlText);
        FormatDataSet();

        if (ds.Tables[0].Rows.Count == 0)
        {
            MakeEmptyGridView();
        }
        else
        {
            GridView1.PageSize = maxRows;
            GridView1.DataSource = ds.Tables[0].DefaultView;
            GridView1.DataBind();
        }
        ds.Dispose();
    }

    protected void MakeEmptyGridView()
    {
        ds.Tables[0].Rows.Add(ds.Tables[0].NewRow());
        GridView1.DataSource = ds.Tables[0].DefaultView;
        GridView1.DataBind();
        int columnCount = GridView1.Rows[0].Cells.Count;
        GridView1.Rows[0].Cells.Clear();
        GridView1.Rows[0].Cells.Add(new TableCell());
        GridView1.Rows[0].Cells[0].ColumnSpan = columnCount;
        GridView1.Rows[0].Cells[0].Text = "No Records Found.";
        GridView1.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
    }

    protected void BindDetailView(string index)
    {
        string sqlText = null;

        sqlText = "SELECT * FROM email_history WHERE elt_account_number="
            + elt_account_number // + " AND user_id=" + user_id 
            + " AND auto_uid=" + index;

        MakeDataSet("EmailHistory", sqlText);
        //FormatDataSet();
        DetailsView1.Visible = true;
        DetailsView1.DataSource = ds.Tables[0].DefaultView;
        DetailsView1.DataBind();
        ds.Dispose();
    }

    protected void MakeDataSet(string dsName, string sqlText)
    {
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;

        if (sqlText != null && sqlText.Trim() != "")
        {
            try
            {
                ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                Adap = new SqlDataAdapter();
                ds = new DataSet();

                Con.Open();
                SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
                Adap.SelectCommand = cmd;
                Adap.Fill(ds, dsName);
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

    protected void FormatDataSet()
    {
        DataColumn newColumn = new DataColumn("row_index",typeof(int));
        ds.Tables[0].Columns.Add(newColumn);
        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            ds.Tables[0].Rows[i][newColumn] = i;
        }
    }

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        BindGridView();
        DetailsView1.Visible = false;
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        GridView gv = (GridView)sender;
        
        string args = e.CommandArgument.ToString();
        char[] splitters = {'-'};
        string[] argList;
        argList = args.Split(splitters);
        
        switch (e.CommandName)
        {
            case "Detail":
                string emailID = argList[0];
                int rowIndex = int.Parse(argList[1]);
                BindDetailView(emailID);
                for (int i = 0; i < gv.Rows.Count; i++)
                {
                    if (i % 2 == 0)
                    {
                        gv.Rows[i].BackColor = ColorTranslator.FromHtml("#E0E0E0");
                    }
                    else
                    {
                        gv.Rows[i].BackColor = ColorTranslator.FromHtml("#FFFFFF");
                    }
                }
                gv.Rows[(rowIndex%maxRows)].BackColor = ColorTranslator.FromHtml("#EEFFCC");
                break;
        }
    }

    protected void DropDownList1_Load()
    {
        string sqlText = "SELECT DISTINCT screen_name from email_history where elt_account_number="
            + elt_account_number;
        DataTable dt = new DataTable("email_title");
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;

        if (sqlText != null && sqlText.Trim() != "")
        {
            try
            {
                ConnectStr = (new igFunctions.DB().getConStr());
                Con = new SqlConnection(ConnectStr);
                Adap = new SqlDataAdapter();
                ds = new DataSet();

                Con.Open();
                SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
                Adap.SelectCommand = cmd;
                Adap.Fill(dt);
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

        for(int i=0;i<dt.Rows.Count;i++)
        {
            DropDownList1.Items.Add(new ListItem(dt.Rows[i][0].ToString(),dt.Rows[i][0].ToString()));
        }
    }

    protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
    {
        BindGridView();
        DetailsView1.Visible = false;
    }

   



    protected void GridView1_EmptyCheck()
    {
        if (GridView1.Rows[0].Cells[0].Text == "No Records Found.")
        {
            GridView1.Rows[0].Cells[0].ColumnSpan = 1;
            GridView1.Rows[0].Cells[0].Text = "No Records Found.";
        }
    }

#region string reformat

    public string ShortenText(string text, int limit)
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

    public string ImportExport(string text)
    {
        string temp = "";
        if (text == "E")
        {
            temp = "Export";
        }
        else if (text == "I")
        {
            temp = "Import";
        }
        return temp;
    }

    public string AirOcean(string text)
    {
        string temp = "";
        if (text == "A")
        {
            temp = "Air";
        }
        else if (text == "O")
        {
            temp = "Ocean";
        }
        return temp;
    }
    public string PDFLocation(string text)
    {
        string temp = "";

        if (text != null && text != "")
        {
            temp = "<a href=\"javascript:call_win_blank('../../TEMP/Eltdata/"
                + elt_account_number + "/" + text + "')\">"
                + "<img alt=\"\" src=\"../../images/button_pdflogo.gif\""
                + "width=\"12\" style=\"border:0px;\"/></a>";
        }
        return temp;
    }

    public string SentStatus(string text)
    {
        string temp = "";
        if (text.StartsWith("Error"))
        {
            temp = "Failed";
        }
        else
        {
            temp = "Sent";
        }

        return temp;
    }

    public string GetAttachedFiles(string text, string orgText)
    {
        string temp = "";
        string[] tempList;
        char[] splitter = { Convert.ToChar(9) };

        if (text != null && text != "")
        {
            tempList = text.Split(splitter);
            for (int i = 0; i < tempList.Length - 1; i++)
            {
                temp = temp + "<a href=\"javascript:call_win_blank('../../TEMP/Eltdata/" + elt_account_number
                    + "/" + orgText + "/" + tempList[i] + "')\">" + tempList[i] + "</a><br/>";
            }
        }
        return temp;
    }

    public string GetHouses(string text, string airOcean, string imexport, string masterNum)
    {
        string temp = "";
        string[] tempList;
        char[] splitter = { Convert.ToChar(9) };
        string urlPrefix = "";

        if (airOcean == "A" && imexport == "E")
        {
            urlPrefix = "../../ASP/air_export/new_edit_hawb.asp?Edit=yes&hawb=";
        }
        if (airOcean == "O" && imexport == "E")
        {
            urlPrefix = "../../ASP/ocean_export/new_edit_hbol.asp?Edit=yes&hbol=";
        }
        if (airOcean == "A" && imexport == "I")
        {
            urlPrefix = "../../ASP/air_import/arrival_notice.asp?iType=A&Edit=yes&MAWB="
                + masterNum + "&HAWB=";
        }
        if (airOcean == "O" && imexport == "I")
        {
            urlPrefix = "../../ASP/ocean_import/arrival_notice.asp?iType=O&Edit=yes&MAWB="
                + masterNum + "&HAWB=";
        }

        if (text != null && text != "")
        {
            tempList = text.Split(splitter);
            for (int i = 0; i < tempList.Length - 1; i++)
            {
                if (tempList[i] == "")
                {
                    temp = temp + "<a href=\"javascript:call_win('"
                        + urlPrefix + "'+encodeURIComponent('" + tempList[i] + "'))\">" + "Anonymous" + "</a>&nbsp;&nbsp;";
                }
                else
                {
                    temp = temp + "<a href=\"javascript:call_win('"
                        + urlPrefix + "'+encodeURIComponent('" + tempList[i] + "'))\">" + tempList[i] + "</a>&nbsp;&nbsp;";
                }
            }
        }
        return temp;
    }

    public string GetMaster(string text, string airOcean, string imexport)
    {
        string temp = "";
        string urlPrefix = "";

        if (text != null && text != "")
        {
            if (airOcean == "A" && imexport == "E")
            {
                urlPrefix = "../../ASP/air_export/new_edit_mawb.asp?Edit=yes&mawb=";
            }
            if (airOcean == "O" && imexport == "E")
            {
                urlPrefix = "../../ASP/ocean_export/new_edit_mbol.asp?Edit=yes&BookingNum=";
            }
            if (airOcean == "A" && imexport == "I")
            {
                urlPrefix = "../../ASP/air_import/air_import2.asp?iType=A&Edit=yes&MAWB=";
            }
            if (airOcean == "O" && imexport == "I")
            {
                urlPrefix = "../../ASP/ocean_import/ocean_import2.asp?iType=O&Edit=yes&MAWB=";
            }

            temp = "<a href=\"javascript:call_win('" + urlPrefix 
                + "'+encodeURIComponent('" + text + "'))\">" + text + "</a>";
        }
        return temp;
    }

    public string GetInvoices(string text)
    {
        string temp = "";
        string[] tempList;
        char[] splitter = { Convert.ToChar(9) };

        if (text != null && text != "")
        {
            tempList = text.Split(splitter);
            for (int i = 0; i < tempList.Length - 1; i++)
            {
                temp = temp + "<a href=\"javascript:call_win('../../ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo="
                    + tempList[i] + "')\">" + tempList[i] + "</a>&nbsp;&nbsp;";
            }
        }
        return temp;
    }

#endregion

}
