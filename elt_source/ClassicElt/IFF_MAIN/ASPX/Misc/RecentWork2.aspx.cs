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
using System.IO;
using System.Configuration;
using System.Data.SqlClient;

public partial class ASPX_Misc_RecentWork2 : System.Web.UI.Page
{
    private string elt_account_number;
    private string user_id;
    private string recent_work;

    protected DataSet ds = new DataSet();
    protected string ConnectStr;

    protected string ParentTable = "RC";
    protected string ChildTable = "RCDETAIL";
    protected string keyColName = "DATE";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session.LCID = 1033;
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            recent_work = Request.Cookies["CurrentUserInfo"]["recent_work"];

            if (!IsPostBack)
            {
                PerformSearch();
                PerformDataBind();
            }
        }
        catch
        {
            Response.Write("<script>alert('Session Expired. Try logining in again'); self.close();</script>");
            Response.End();
        }
    }

    private void PerformDataBind()
    {
        GridView1.DataSource = ds.Tables["RC"].DefaultView;
        GridView1.DataMember = "RC";
        GridView1.DataBind();
    }

    private string convertDateFormat(string dateTxt)
    {
        string[] dateArray = new string[3];
        char[] splitter  = {'/'};
        string returnDate = "";

        dateArray = dateTxt.Split(splitter);
        returnDate = dateArray[2] + "-" + dateArray[1] + "-" + dateArray[0];
        return returnDate;
    }

    private void PerformSearch()
    {
        string strStart = getStartdaySQL();
        string strEnd = getTodaySQL(1);
        string strToday = getTodaySQL(0);
        string strYester = getTodaySQL(-1);
        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);

        SqlCommand cmdHeader = new SqlCommand(@"select Distinct
                                                substring(workdate,1,10) as DATE 
                                                from recent_work 
                                                where   elt_account_number =" + elt_account_number +
                                                " and user_id ='" + user_id + "'" +
                                                " and convert(char(20), workdate, 105) between cast('" +
                                                strStart + "' as datetime) and cast('" +
                                                strEnd + "' as datetime) order by DATE desc", Con);


        SqlCommand cmdDetail = new SqlCommand(@"select workid,
                                                substring(workdate,1,10) as DATE, 
                                                substring(workdate,11,18) as TIME,
                                                title as TITLE,
                                                docnum as DOC_NUM,
                                                workdate,
                                                surl,
                                                workdetail AS DETAIL,
                                                remark AS REMARKS,
                                                '' as STATUS,
                                                status as x 
                                                from recent_work    
                                                where elt_account_number =" + elt_account_number +
                                                " and user_id ='" + user_id + "'" +
                                                " and convert(char(20), workdate, 101) between cast('" +
                                                strStart + "' as datetime) and cast('" + strEnd + 
                                                "' as datetime) order by workdate desc", Con);


        SqlDataAdapter Adap = new SqlDataAdapter();
        Con.Open();
        
        Adap.SelectCommand = cmdHeader;
        Adap.Fill(ds, ParentTable);
        Adap.SelectCommand = cmdDetail;
        Adap.Fill(ds, ChildTable);

        Con.Close();

        foreach (DataRow eRow in ds.Tables[ParentTable].Rows)
        {
            if (eRow[0].ToString() == strToday)
            {
                eRow[0] = eRow[0] + " (Today)";
            }
            if (eRow[0].ToString() == strYester)
            {
                eRow[0] = eRow[0] + " (Yesterday)";
            }

        }

        DataTable dt = ds.Tables[ChildTable].Clone();
        string strKey = "";

        foreach (DataRow eRow in ds.Tables[ChildTable].Rows)
        {
            DataRow dr = dt.NewRow();
            if (eRow[1].ToString() == strToday)
            {
                eRow[1] = eRow[1] + " (Today)";
            }
            if (eRow[1].ToString() == strYester)
            {
                eRow[1] = eRow[1] + " (Yesterday)";
            }
            dr[0] = eRow[0];
            dr[1] = eRow[1];
            dr[2] = eRow[2];
            dr[3] = eRow[3];
            dr[4] = eRow[4];
            dr[5] = eRow[5];
            if (eRow[3].ToString().Substring(0, 4) == "Acct")
            {
                dr[6] = "";
            }
            else
            {
                dr[6] = eRow[6];
            }
            dr[7] = eRow[7];
            dr[8] = eRow[8];
            dr[9] = eRow[9];
            dr[10] = eRow[10];

            if (strKey != (dr[1].ToString() + dr[4].ToString()))
            {
                dt.Rows.Add(dr);
            }
            strKey = dr[1].ToString() + dr[4].ToString();
        }

        ds.Tables.Remove(ChildTable);
        ds.Tables.Add(dt);

        if (ds.Relations.Count < 1)
            ds.Relations.Add(ds.Tables[ParentTable].Columns[keyColName], ds.Tables[ChildTable].Columns[keyColName]);


    }

    private string getStartdaySQL()
    {
        string tmpDay = DateTime.Now.DayOfWeek.ToString();
        int tmpDays;
        if (recent_work == "")
        {
            recent_work = "3";
        }
        int iRecent_work = int.Parse(recent_work);

        switch (tmpDay)
        {
            case "Sunday": tmpDays = iRecent_work * 7 + 0; break;
            case "Monday": tmpDays = iRecent_work * 7 + 1; break;
            case "Tuesday": tmpDays = iRecent_work * 7 + 2; break;
            case "Wednesday": tmpDays = iRecent_work * 7 + 3; break;
            case "Thursday": tmpDays = iRecent_work * 7 + 4; break;
            case "Friday": tmpDays = iRecent_work * 7 + 5; break;
            case "Saturday": tmpDays = iRecent_work * 7 + 6; break;
            default: tmpDays = iRecent_work * 7; break;
        }

        tmpDays = tmpDays * -1;
        DateTime tmpStartDate = DateTime.Now.AddDays(tmpDays);

        string strDate = "";
        string strDateTime = "";

        strDate = tmpStartDate.Year.ToString();

        if (tmpStartDate.Month.ToString().Length == 1)
        {
            strDate = strDate + "0" + tmpStartDate.Month.ToString();
        }
        else
        {
            strDate = strDate + tmpStartDate.Month.ToString();
        }

        if (tmpStartDate.Day.ToString().Length == 1)
        {
            strDate = strDate + "0" + tmpStartDate.Day.ToString();
        }
        else
        {
            strDate = strDate + tmpStartDate.Day.ToString();
        }

        strDateTime = strDate.Substring(4, 2) + "/" + strDate.Substring(6, 2) + "/" + strDate.Substring(0, 4);

        return strDateTime;

    }

    private string getTodaySQL(int iDay)
    {
        string strDate = "";
        string strDateTime = "";
        DateTime dToDay = DateTime.Now.AddDays(iDay);

        strDate = dToDay.Year.ToString();

        if (dToDay.Month.ToString().Length == 1)
        {
            strDate = strDate + "0" + dToDay.Month.ToString();
        }
        else
        {
            strDate = strDate + dToDay.Month.ToString();
        }

        if (dToDay.Day.ToString().Length == 1)
        {
            strDate = strDate + "0" + dToDay.Day.ToString();
        }
        else
        {
            strDate = strDate + dToDay.Day.ToString();
        }

        strDateTime = strDate.Substring(4, 2) + "/" + strDate.Substring(6, 2) + "/" + strDate.Substring(0, 4);

        return strDateTime;
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        GridView gv = (GridView)sender;
        int rowIndex = int.Parse(e.CommandArgument.ToString());

        switch (e.CommandName)
        {
            case "select":
                GridView childgv = (GridView)gv.Rows[rowIndex].FindControl("GridView2");
                if (childgv != null)
                {
                    childgv.Visible = !childgv.Visible;
                    PerformSearch();

                    DataRow[] subSet = ds.Tables["RC"].Rows[rowIndex].GetChildRows(ds.Relations[0]);
                    
                    DataTable dt = new DataTable();
                    dt = ds.Tables["RCDetail"].Clone();

                    for (int i = 0; i < subSet.Length; i++)
                    {
                        dt.Rows.Add(subSet[i].ItemArray);
                    }

                    childgv.DataSource = dt;
                    childgv.DataMember = "RCDetail";
                    childgv.DataBind();
                }
                break;
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        GridView childgv;
        TextBox remark;
        HiddenField workid;
        DataTable dt = new DataTable();
        DataRow newRow = null;

        dt.Columns.Add("workid",typeof(int));
        dt.Columns.Add("remark",typeof(string));

        for (int i = 0; i < GridView1.Rows.Count; i++)
        {
            childgv = (GridView)GridView1.Rows[i].FindControl("GridView2");
            for (int j = 0; j < childgv.Rows.Count; j++)
            {
                remark = (TextBox)childgv.Rows[j].Controls[4].FindControl("Remark");
                workid = (HiddenField)childgv.Rows[j].Controls[4].FindControl("WorkID");
                if (remark.Text.Trim() != "")
                {
                    newRow = dt.NewRow();
                    newRow["workid"] = int.Parse(workid.Value);
                    newRow["remark"] = remark.Text.ToString();
                    dt.Rows.Add(newRow);
                }
            }
        }
        RemarkUpdate(dt);
    }
    
    private int RemarkUpdate(DataTable dt)
    {
        int rows = 0;
        string updateText = @"
                    update Recent_Work  
                    set 
                        remark = @remark 
                    where 
                        workid = @workid";

        SqlConnection Con = null;

        try
        {
            string ConnectStr = (new igFunctions.DB().getConStr());
            Con = new SqlConnection(ConnectStr);
            SqlDataAdapter Adap = new SqlDataAdapter();
            SqlCommand cmd = new SqlCommand(updateText, Con);
            
            cmd.Parameters.Add("@remark", SqlDbType.NVarChar, 128, "remark");
            cmd.Parameters.Add("@workid", SqlDbType.Int, 4, "workid");

            Adap.InsertCommand = cmd;
            rows = Adap.Update(dt);
        }

        catch (Exception e) { Response.Write(e.Message);  return 0; }
        finally { if (Con != null) { Con.Close(); } }
        return rows;
    }
}
