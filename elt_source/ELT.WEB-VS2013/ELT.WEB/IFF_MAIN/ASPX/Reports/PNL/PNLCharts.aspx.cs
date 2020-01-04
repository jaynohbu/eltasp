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
using System.Data.SqlClient;

public partial class ASPX_Reports_PNL_PNLCharts : System.Web.UI.Page
{
    string ParentTable = "INVOICE";
    string sHeaderName = "PNLINDEX";
    protected string ConnectStr;
    protected DataSet ds = new DataSet();
    static public string windowName;
    static public string strResultStyle;
    static string keyColName;

    protected void Page_Load(object sender, EventArgs e)
    {
        UltraChart1.BackgroundImageFileName = Server.MapPath("chart_gray_bg.jpg");
        if (!IsPostBack)
        {
            PerformSearch();
        }
    }

    private void PerformClose()
    {
        Response.Write("<script language=javascript>window.close();</script>");
    }
    private void PerformSearch()
    {
        ConnectStr = (new igFunctions.DB().getConStr());

        string strSelectionHeader = Session[sHeaderName].ToString();
        string[] str = new string[8];

        str[0] = Session["Accounting_sPeriod"].ToString();
        str[1] = Session["Accounting_sBranchName"] .ToString();
        str[2] = Session["Accounting_sBranch_elt_account_number"] .ToString();
        str[3] = Session["Accounting_sCompanName"] .ToString();
        str[4] = Session["Accounting_sReportTitle"] .ToString();
        str[5] = Session["Accounting_sSelectionParam"] .ToString();
        str[6] = Session["str6"].ToString();
        str[7] = Session["str7"].ToString();
        keyColName = Session["PNLkey"].ToString();

        for (int i = 0; i < str.Length - 1; i++)
        {
            if (str[i + 1] != "") str[i] = str[i] + "/";
        }

        Label2.Text = string.Format("<FONT color='navy' size='1pt'>{0} {1} {2} {3} {4} {5}  {6} {7}</FONT>", str[0], str[1], str[2], str[3], str[4], str[5], str[6], str[7]);

        if (strSelectionHeader == "") PerformClose();

        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand cmdHeader = new SqlCommand(strSelectionHeader, Con);
        SqlDataAdapter Adap = new SqlDataAdapter();

        Con.Open();

        Adap.SelectCommand = cmdHeader;

        Adap.Fill(ds, ParentTable);

        Con.Close();

        performInsertSubTotal();

    }

    private void performInsertSubTotal()
    {
        string tmpkey = "";
        double subtotAmount = 0;
        double subtotCost = 0;
        double subtotProfit = 0;
        double totAmount = 0;
        double totCost = 0;
        double totProfit = 0;
        int iCnt = 0;
        DataTable dt = new DataTable("Tmp");
        DataRow dr;

        dt.Columns.Add(new DataColumn(keyColName, typeof(string)));
        dt.Columns.Add(new DataColumn("Amount", typeof(System.Decimal)));
        dt.Columns.Add(new DataColumn("Cost", typeof(System.Decimal)));
        dt.Columns.Add(new DataColumn("Profit", typeof(System.Decimal)));

        foreach (DataRow eRow in ds.Tables[ParentTable].Rows)
        {
            iCnt++;
            if (iCnt == 1) tmpkey = eRow[0].ToString().Trim();
            if (eRow[0].ToString().Trim() != tmpkey)
            {
                totAmount += subtotAmount;
                totCost += subtotCost;
                totProfit += subtotProfit;
                dr = dt.NewRow();
                dr[keyColName] = performGetSubTotalCaption(tmpkey.ToString());
                dr["Amount"] = subtotAmount;
                dr["Cost"] = subtotCost;
                dr["Profit"] = subtotProfit;
                dt.Rows.Add(dr);
                tmpkey = eRow[0].ToString().Trim();
                subtotAmount = subtotCost = subtotProfit = 0;
            }

            subtotAmount += double.Parse(eRow["Amount"].ToString());
            subtotCost += double.Parse(eRow["Cost"].ToString());
            subtotProfit += double.Parse(eRow["Profit"].ToString());

            if (iCnt == ds.Tables[ParentTable].Rows.Count)
            {

                    totAmount += subtotAmount;
                    totCost += subtotCost;
                    totProfit += subtotProfit;

                    dr = dt.NewRow();
                    dr[keyColName] = performGetSubTotalCaption(tmpkey.ToString());
                    dr["Amount"] = subtotAmount;
                    dr["Cost"] = subtotCost;
                    if (subtotProfit < 0)
                    {
                        subtotProfit = 0;
                    }
                    dr["Profit"] = subtotProfit;
                    dt.Rows.Add(dr);
                    break;
            }

        }

        ds.Tables.Remove(ParentTable);

        if (dt.Rows.Count > 30)
        {
            UltraChart1.Visible = false;
            UltraChart2.EnableScrollBar = true;
            UltraChart2.DataSource = dt;
            UltraChart2.DataBind();
        }
        else
        {
            UltraChart2.Visible = false;
            UltraChart1.DataSource = dt;
            UltraChart1.DataBind();
        }
        
    }

    private string performGetSubTotalCaption(string p)
    {
        string strTitle = "";
            if (keyColName == "Route")
            {
                if (p.Trim() == "->" || p.Trim() == " -> ")
                {
                    strTitle = "";
                }
                else
                {
                    strTitle = p;
                }
            }
            else
            {
                strTitle = p;
            }
        return strTitle;
    }
}
