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
using Infragistics.WebUI.UltraWebGrid;
using System.Data.SqlClient;

public partial class ASPX_Misc_RecentWork : System.Web.UI.Page
{
    public string elt_account_number;
    public string user_id;
    public string recent_work;
    protected string ParentTable = "RC";
    protected string ChildTable = "RCDETAIL";
    protected string keyColName = "DATE";
    protected DataSet ds = new DataSet();
    protected string ConnectStr;

    protected void Page_Load(object sender, EventArgs e)
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        recent_work = Request.Cookies["CurrentUserInfo"]["recent_work"];


        if (!IsPostBack)
        {
            PerformSearch();
            PerformDataBind();
        }    
    }

    private string PerformValidName(string Url)
    {
        int lastSlashIndex = Url.LastIndexOf("/");
        if (lastSlashIndex < 0) return Url;

        string parentVirPath = Url.Substring(0, lastSlashIndex);
        string strUrl = Url.Substring(lastSlashIndex + 1);

        return strUrl;
    }

    private string PerformGetWorkName(string Url)
    {
        if (Url == null) return Url;

        int lastSlashIndex = Url.LastIndexOf("/");

        if (lastSlashIndex <= 0) return Url;

        string parentVirPath = Url.Substring(0, lastSlashIndex);

        string strUrl1 = PerformValidName(Url);
        string strUrl2 = PerformValidName(parentVirPath);
        string tmpStr = strUrl2 + "/" + strUrl1;
        return tmpStr;

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

    private void PerformDataBind()
    {
        this.UltraWebGrid1.DataSource = ds.Tables[ParentTable].DefaultView;
        this.UltraWebGrid1.DataBind();
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

    
    private void PerformSearch()
    {
        string strStart =  getStartdaySQL();
        string strEnd   =  getTodaySQL(1);
        string strToday =  getTodaySQL(0);
        string strYester = getTodaySQL(-1);
        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);

        SqlCommand cmdHeader = new SqlCommand(@" select Distinct
                                                    substring(workdate,1,10) as DATE 
                                                       from    recent_work 
                                                      where   elt_account_number =" + elt_account_number +
                                                    " and user_id ='" + user_id + "'" +
                                                    " and convert(char(20), workdate, 101) between '" +
                                                    strStart + "' and '" + strEnd + "' order by DATE desc", Con);


        SqlCommand cmdDetail = new SqlCommand(@" select 
                                                           workid,
                                                           substring(workdate,1,10) as DATE, 
                                                           substring(workdate,11,18) as TIME, 
                                                           title as TITLE,
                                                           docnum as DOC_NUM,
                                                           workdate,
                                                           surl,
                                                           workdetail AS DETAIL,+
                                                           remark AS REMARKS,
                                                           '' as STATUS,
                                                           status as x 
                                                       from    recent_work    
                                                       where   elt_account_number =" + elt_account_number +
                                                     " and user_id ='" + user_id + "'" +
                                                     " and convert(char(20), workdate, 101) between '" +
                                                     strStart + "' and '" + strEnd + "' order by workdate desc", Con);


        SqlDataAdapter Adap = new SqlDataAdapter();
        Con.Open();

        Adap.SelectCommand = cmdHeader;
        Adap.Fill(ds, ParentTable);
        Adap.SelectCommand = cmdDetail;
        Adap.Fill(ds, ChildTable);

        Con.Close();


        #region

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
            dr[6] = eRow[6];
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

        #endregion

        if (ds.Relations.Count < 1)
            ds.Relations.Add(ds.Tables[ParentTable].Columns[keyColName], ds.Tables[ChildTable].Columns[keyColName]);


    }
    protected void UltraWebGrid1_InitializeLayout1(object sender, LayoutEventArgs e)
    {
        e.Layout.SelectTypeColDefault = SelectType.Single;
        e.Layout.SelectTypeRowDefault = SelectType.Extended;

        e.Layout.ViewType = ViewType.Hierarchical;
        e.Layout.TableLayout = TableLayout.Fixed;
        e.Layout.RowStyleDefault.BorderDetails.ColorTop = Color.Gray;

        for (int i = 0; i < UltraWebGrid1.Bands.Count; i++)
        {
            for (int j = 0; j < UltraWebGrid1.Bands[i].Columns.Count; j++)
            {
                UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.BackColor = Color.Yellow;
                UltraWebGrid1.DisplayLayout.Bands[i].Columns[j].SelectedCellStyle.ForeColor = Color.Black;
            }
        }

        e.Layout.Bands[1].Columns.FromKey("DATE").ServerOnly = true;
        e.Layout.Bands[1].Columns.FromKey("workdate").Hidden = true;
        e.Layout.Bands[1].Columns.FromKey("workid").Hidden = true;
        e.Layout.Bands[1].Columns.FromKey("x").Hidden = true;
        e.Layout.Bands[1].Columns.FromKey("surl").ServerOnly = true;

        e.Layout.Bands[1].Columns.FromKey("STATUS").Header.Caption = "";
        e.Layout.Bands[0].Columns.FromKey("DATE").Width = new Unit("120px");
        e.Layout.Bands[1].Columns.FromKey("TIME").Width = new Unit("60px");
        e.Layout.Bands[1].Columns.FromKey("TITLE").Width = new Unit("100px");
        e.Layout.Bands[1].Columns.FromKey("DETAIL").Width = new Unit("150px");
        e.Layout.Bands[1].Columns.FromKey("REMARKS").Width = new Unit("180px");

        e.Layout.Bands[0].Columns.FromKey("DATE").CellStyle.BackColor = Color.Yellow;

        e.Layout.Bands[1].Columns.FromKey("STATUS").CellStyle.BackgroundImage = "../../Images/mark_o.gif";
        e.Layout.Bands[1].Columns.FromKey("STATUS").CellStyle.HorizontalAlign = HorizontalAlign.Center;
        e.Layout.Bands[1].Columns.FromKey("STATUS").CellStyle.CustomRules = "background-position:center ;background-repeat:no-repeat";
        e.Layout.Bands[1].Columns.FromKey("STATUS").Header.Caption = "";
        e.Layout.Bands[1].Columns.FromKey("STATUS").Width = new Unit("40px");
        e.Layout.Bands[1].Columns.FromKey("STATUS").CellStyle.BackColor = Color.FromArgb(204, 235, 237);
        e.Layout.Bands[1].Columns.FromKey("STATUS").CellStyle.Cursor = Infragistics.WebUI.Shared.Cursors.Hand;
        e.Layout.Bands[1].Columns.FromKey("STATUS").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;

        e.Layout.Bands[1].Columns.FromKey("TIME").CellStyle.BackColor = Color.WhiteSmoke;
        e.Layout.Bands[1].Columns.FromKey("TITLE").CellStyle.BackColor = Color.WhiteSmoke;
        e.Layout.Bands[1].Columns.FromKey("DOC_NUM").CellStyle.BackColor = Color.WhiteSmoke;
        e.Layout.Bands[1].Columns.FromKey("DETAIL").CellStyle.BackColor = Color.WhiteSmoke;

        e.Layout.Bands[0].Columns.FromKey("DATE").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
        e.Layout.Bands[1].Columns.FromKey("TIME").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
        e.Layout.Bands[1].Columns.FromKey("TITLE").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
        e.Layout.Bands[1].Columns.FromKey("DOC_NUM").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;
        e.Layout.Bands[1].Columns.FromKey("DETAIL").AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No;

    }
    protected void UltraWebGrid1_InitializeRow(object sender, RowEventArgs e)
    {
        string s = "";
        if (e.Row.Band.BaseTableName == ChildTable)
        {
            s = e.Row.Cells.FromKey("surl").Text;
            e.Row.Cells.FromKey("TITLE").TargetURL = "@[mainFrame]" + s;

            if (e.Row.Cells.FromKey("x").Text == "X")
            {
                e.Row.Cells.FromKey("STATUS").Style.BackgroundImage = "../../Images/mark_x.gif";
            }

        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string strUpdate = @" UPDATE            RECENT_WORK
													SET	 
                                                         remark=@remark,
                                                         status=@status
												 WHERE  workid=@workid ";

        string strRemark, charStatus;
        int iWorkid;
        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand cmdRecent = new SqlCommand();
        cmdRecent.Connection = Con;

        Con.Open();

        SqlTransaction trans = Con.BeginTransaction();

        cmdRecent.Transaction = trans;

        try
        {

            foreach (UltraGridRow eRow in UltraWebGrid1.Rows)
            {

                    for (int i = 0; i < eRow.Rows.Count; i++)
                    {
                        strRemark = "";
                        charStatus = "";
                        iWorkid = 0;

                        if (eRow.Rows[i].Cells.FromKey("REMARKS").Text != null)
                        {
                            strRemark = eRow.Rows[i].Cells.FromKey("REMARKS").Text;
                        }

                        if (eRow.Rows[i].Cells.FromKey("x").Style.BackgroundImage  != null)
                        {
                            charStatus = eRow.Rows[i].Cells.FromKey("x").Text;
                        }

                        if (eRow.Rows[i].Cells.FromKey("workid").Text != null)
                        {
                            iWorkid = int.Parse(eRow.Rows[i].Cells.FromKey("workid").Text);
                        }

                        cmdRecent.CommandText = strUpdate;
                        cmdRecent.Parameters.Clear();
                        cmdRecent.Parameters.Add("@remark", SqlDbType.NVarChar, 128).Value = strRemark;
                        cmdRecent.Parameters.Add("@status", SqlDbType.Char, 1).Value = charStatus;
                        cmdRecent.Parameters.Add("@workid", SqlDbType.Decimal, 9).Value = iWorkid;
                        cmdRecent.ExecuteNonQuery();
                    }
            }


                            trans.Commit();
        }
        catch
        {
                            trans.Rollback();
                            Con.Close();
        }
        finally
        {
                            Con.Close();
                            PerformSearch();
                            PerformDataBind();

        }

    }

}
