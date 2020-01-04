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

public partial class ASPX_DOMESTIC_DELIVERY_CONFIRMATION : System.Web.UI.Page
{
    protected DataSet ds = null;
    protected DataSet dn = null;
    protected string ConnectStr = null;
    private string elt_account_number = null;
    private string user_id, login_name, user_right;
    private int maxRows = 20;
    private string NOL ="";
    private string del = "N";
    private string s_num = "";
    private int Findex = 0;
    private int zindex = 0;
    private int Rindex = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        object PreNo = Request.Params.Get("searchNo");
    /*  try
       {*/
            Session.LCID = 1033;
            elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
            login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
            ConnectStr = (new igFunctions.DB().getConStr());
            /*
            if (!IsPostBack)
            {
                LoadParameters();
                //BindGridView();
                userinfo();

            }
             * */
            LoadParameters();
            //BindGridView();
            userinfo();
            if (PreNo != null && PreNo.ToString().Trim() != "")
            {
                GetSearchType();
                BindGridView();
            }

     /* }
        catch
        {
           Response.Write("<script>alert('Session Expired. Try logining in again'); self.close();</script>");
           Response.End();
        }*/
    }
    protected void SearchNoChange(object sender, EventArgs e)
    {
        
        BindGridView();
        
    }
    protected void LoadParameters()
    {
        NOL = "";
        
        
    }



    protected void GetSearchType()
    {
        object SType = Request.Params.Get("searchType");

        if (SType != null && SType.ToString().Trim() != "")
        {
            if (SType.ToString() == "File")
            {
                lstSearchType.SelectedIndex = 2;
            }
            else if (SType.ToString() == "MAWB")
            {
                lstSearchType.SelectedIndex = 1;
            }
            else
            {
                lstSearchType.SelectedIndex = 0;
            }
        }
        else
        {
            lstSearchType.SelectedIndex = 0;
        }
    }
    protected void BindGridView()
    {
       /* string sqlText = "select a.shipper_name as shipper_name, a.shipper_account_number as shipper_account_number, c.owner_email as Email, "
           + " a.Consignee_Name as Consignee_Name, a.Consignee_acct_num as Consignee_acct_num, a.MAWB_num as mawbNum, a.HAWB_num as HAWB_num, "
           + " d.dba_name as AgentName, a.ci as Nsubject ";
        if (lstSearchType.SelectedIndex > 0)
        {
            sqlText = sqlText + ", b.File# as FileNo ";
        }
            sqlText = sqlText + " from organization c left join  HAWB_Master a"
           + " on (c.EmailItemID=a.EmailItemID and c.org_account_number = a.shipper_account_number) "
           + " left join agent d "
           + " on (a.EmailItemID=d.EmailItemID )";

        if (lstSearchType.SelectedIndex > 0)
        {
            sqlText = sqlText + "left join MAWB_number b "
           + " on (a.EmailItemID=b.EmailItemID and a.MAWB_num = b.MAWB_no and b.is_dome ='Y') ";
        }
        sqlText = sqlText + " where a.EmailItemID=" + EmailItemID + " AND a.is_dome = 'Y'  and a.shipper_account_number <> ''";*/

        string sqlText = "select a.shipper_name,a.shipper_account_number as shipper_account_number,c.owner_email as Email,a.consignee_name,a.Consignee_acct_num,e.owner_email as consignee_email,a.MAWB_num as mawbNum,a.HAWB_num as HAWB_num,d.dba_name as AgentName, a.ci as Nsubject,b.File# as FileNo from HAWB_Master a left join organization c on (a.elt_account_number=c.elt_account_number and a.shipper_account_number = c.org_account_number) left join organization e on (a.elt_account_number=e.elt_account_number and a.shipper_account_number = e.org_account_number) left join agent d on (a.elt_account_number=d.elt_account_number) left join MAWB_number b on (a.elt_account_number=b.elt_account_number and a.MAWB_num = b.MAWB_no and b.is_dome ='Y') where a.elt_account_number=" + elt_account_number + " AND a.is_dome = 'Y' and a.shipper_account_number <> ''";
        string HAWBSQL = "select a.shipper_account_number as shipper_account_number, a.HAWB_num as HAWB_num from HAWB_Master a left join organization c "
           + " on (a.elt_account_number=c.elt_account_number and a.shipper_account_number = c.org_account_number) "
           + " left join agent d "
           + " on (a.elt_account_number=d.elt_account_number )"
           + "left join MAWB_number b "
           + " on (a.elt_account_number=b.elt_account_number and a.MAWB_num = b.MAWB_no and b.is_dome ='Y') "
           + " where a.elt_account_number=" + elt_account_number + " AND a.is_dome = 'Y'  and a.shipper_account_number <> '' ";

        string FileSQL = "select elt_account_number,cast(org_no as nnvarchar(16)) as org_no,file_name,file_size,file_type,file_checked,in_dt from user_files where elt_account_number=" + elt_account_number;
        sqlText = SQLSetFilter(sqlText) + " order by a.shipper_name";
        HAWBSQL = SQLSetFilter2(HAWBSQL) + " order by a.shipper_account_number";
        


    
            MakeDataSet("SOList", sqlText);
            MakeDataSet("HAWBList", HAWBSQL);
            MakeDataSet("FileList", FileSQL);
            //ds.Relations.Add("FileRelation", ds.Tables["SOList"].Columns["shipper_account_number"], ds.Tables["FileList"].Columns["shipper_account_number"]);
           
        FormatDataSet();

        if (ds.Tables[0].Rows.Count == 0)
        {
            MakeEmptyGridView();
        }
        else
        {
            //GridView1.PageSize = maxRows;
            //GridView1.DataSource = ds.Tables[0].DefaultView;
            //GridView1.DataBind();
            //ds.Relations.Clear();
            //bindChildGridView("SQList", "FileList", "GridViewFile", GridView1, "FileRelation");


            if (ds.Tables["SOList"].Rows.Count == 0)
            {
                MakeEmptyGridView();

            }
            else
            {
                GridView1.PageSize = maxRows;
                GridView1.DataSource = ds.Tables["SOList"].DefaultView;
                GridView1.DataBind();
                ds.Relations.Clear();
    try
        {
                ds.Relations.Add(ds.Tables["SOList"].Columns["shipper_account_number"], ds.Tables["HAWBList"].Columns["shipper_account_number"]);

            }
            catch { } 
                if (GridView1.Rows.Count != 0)
                {
                    for (int rowIndex = 0; rowIndex < GridView1.Rows.Count; rowIndex++)
                    {
                        GridView childgv = (GridView)GridView1.Rows[rowIndex].FindControl("GridViewHAWB");
                        GridView childgv2 = (GridView)GridView1.Rows[rowIndex].FindControl("GridViewFile");
                        if (childgv != null)
                        {
                            DataRow[] subSet = ds.Tables["SOList"].Rows[rowIndex].GetChildRows(ds.Relations[0]);


                            DataTable dt = new DataTable();
                            dt = ds.Tables["HAWBList"].Clone();

                            if (subSet.Length == 0)
                            {
                                if (rowIndex == 0)
                                {
                                    MakeEmptyGridView();

                                }
                                else
                                {
                                    GridView1.Rows[rowIndex].Visible = false;
                                }

                            }
                            else
                            {
                                for (int i = 0; i < subSet.Length; i++)
                                {
                                    dt.Rows.Add(subSet[i].ItemArray);
                                }

                                childgv.DataSource = dt;
                                childgv.DataBind();
                                if (GridView1.Rows[0].Cells[0].Text == "No Records Found.")
                                {
                                    GridView1.Rows[0].Visible = false;
                                }
                            }

                        }
                        
                    }
                }
                try
                {
                    ds.Relations.Add(ds.Tables["SOList"].Columns["shipper_account_number"], ds.Tables["FileList"].Columns["org_no"]);
                }
                catch { }
                if (GridView1.Rows.Count != 0)
                {
                    for (int rowIndex = 0; rowIndex < GridView1.Rows.Count; rowIndex++)
                    {

                        GridView childgv2 = (GridView)GridView1.Rows[rowIndex].FindControl("GridViewFile");
                        
                        if (childgv2 != null)
                        {
                            DataRow[] subSet = ds.Tables["SOList"].Rows[rowIndex].GetChildRows(ds.Relations[1]);


                            DataTable dm = new DataTable();
                            dm = ds.Tables["FileList"].Clone();

                            if (subSet.Length == 0)
                            {
                                if (rowIndex == 0)
                                {
                                    //MakeEmptyGridView();

                                }
                                else
                                {
                                    // GridViewFile.Rows[rowIndex].Visible = false;
                                }

                            }
                            else
                            {
                                for (int i = 0; i < subSet.Length; i++)
                                {
                                    dm.Rows.Add(subSet[i].ItemArray);
                                }

                                childgv2.DataSource = dm;
                                childgv2.DataBind();
                                if (GridView1.Rows[0].Cells[0].Text == "No Records Found.")
                                {
                                    // GridViewFile.Rows[0].Visible = false;
                                }
                            }

                        }
                    }

                }
            }
        
        ds.Dispose();
    }
    }
    protected string SQLSetFilter(string sqlText)
    {
        object searchNo = Request.Params.Get("searchNo");

        if (lstSearchType.SelectedIndex == 0)
        {
            if (searchNo != null && searchNo.ToString().Trim() != "")
            {
                sqlText = sqlText + " AND a.HAWB_num like '" + searchNo.ToString() + "%'";
            }
        }
        else if (lstSearchType.SelectedIndex == 1)
        {
            if (searchNo != null && searchNo.ToString().Trim() != "")
            {
                sqlText = sqlText + " AND b.MAWB_no like '" + searchNo.ToString() + "%'";
            }
        }
        else if (lstSearchType.SelectedIndex == 2)
        {
            if (searchNo != null && searchNo.ToString().Trim() != "")
            {
                sqlText = sqlText + " AND b.File# like '" + searchNo.ToString() + "%'";
            }
        }
        return sqlText;
    }

    protected string SQLSetFilter2(string sqlText)
    {
        object searchNo = Request.Params.Get("searchNo");

        if (lstSearchType.SelectedIndex == 0)
        {
            if (searchNo != null && searchNo.ToString().Trim() != "")
            {
                sqlText = sqlText + " AND a.HAWB_num like '" + searchNo.ToString() + "%'";
            }
        }

        return sqlText;
    }

    public string CheckHAWB(object shipper_Num)
    {
        int index=0;
        for (int rowIndex = 0; rowIndex < GridView1.Rows.Count; rowIndex++)
        {
            index = rowIndex;
        }
        if (del == "Y")
        {
            GridView1.Rows[index].Visible = false;
        }
        if (shipper_Num.ToString() == s_num.ToString())
        {
            del = "Y";
            
        }
        else
        {
            del = "N";
        }
        s_num = shipper_Num.ToString();

        return "";
    }

    protected void bindChildGridView(string parentTable, string childTable, string childGV, GridView parentGVObj, string dsRelation)
    {
        for (int rowIndex = 0; rowIndex < parentGVObj.Rows.Count; rowIndex++)
        {
            GridView childgv = (GridView)parentGVObj.Rows[rowIndex].FindControl(childGV);
           if (childgv != null)
            {
                DataRow[] subSet = ds.Tables[parentTable].Rows[rowIndex].GetChildRows(ds.Relations[dsRelation]);
                DataTable dt = new DataTable();
                dt = ds.Tables[childTable].Clone();
            }
        }
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

    protected void FormatDataSet()
    {
        try
        {
            DataColumn newColumn = new DataColumn("row_index", typeof(int));
            ds.Tables[0].Columns.Add(newColumn);
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                ds.Tables[0].Rows[i][newColumn] = i;
            }
        }
        catch { }
    }
    
    
    protected void GridViewOutDetail_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
       
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

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        BindGridView();
        //DetailsView1.Visible = false;
    }

    
    public string GetNo()
    {
        int index = 0;
        
        index = GridView1.Rows.Count;
        return index.ToString();
    }

    public string GetShipID(string ID, string Rowno)
    {
        HiddenField shipperID;
        int INDEX = GridView1.Rows.Count;
         shipperID = (HiddenField)GridView1.Rows[0].FindControl("hShipID");
        shipperID.Value = ID.ToString();
        return "";
    }
    public string GetNo2()
    {
        Findex = Findex + 1;
        return Findex.ToString();
    }
    public string GetNoC()
    {
        zindex = zindex + 1;
        return zindex.ToString();
    }
    public string GetNoR()
    {
        int index;
        index = Rindex - 1;
        return index.ToString();
    }

    public string GetNoX()
    {
        Rindex = Rindex + 1;

        zindex = 0;
        return "";
    }
    public string GetNoV()
    {
        Findex = 0;
        return "";
    }

    protected void userinfo()
    {
        string sqlText = "select * from users where elt_account_number=" + elt_account_number;
        if(user_id != "0000")
        {
            sqlText = sqlText + "and userid=" + user_id;
        }
        DataTable dt = new DataTable("user_title");
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
        txtname.Text = dt.Rows[0]["user_fname"].ToString() + " " + dt.Rows[0]["user_lname"].ToString();
        txtEmail.Text = dt.Rows[0]["user_email"].ToString();
    }

    protected void btnUpload_Click(object sender, ImageClickEventArgs e)
    {
        int index = 0;
        FileUpload Fileupload2;
        HiddenField shipperID;
        string ftype ="";
        string fname = "";
        string fcontect="";
        string fsize= "";
        string orgid="";
        string now="";
        try{
             Fileupload2 = (FileUpload)GridView1.Rows[index].FindControl("FileUploadx");
            shipperID = (HiddenField)GridView1.Rows[index].FindControl("hShipID");
            while (Fileupload2.HasFile == false && index<GridView1.Rows.Count)
            {

                index = index + 1;
                Fileupload2 = (FileUpload)GridView1.Rows[index].FindControl("FileUploadx");
            }
            if (Fileupload2.HasFile)
            {
                Fileupload2 = (FileUpload)GridView1.Rows[index].FindControl("FileUploadx");
                
                int byts = Convert.ToInt32(Fileupload2.PostedFile.InputStream.Length);
                Byte[] bytes = new Byte[byts];

                TextBox1.Value = Fileupload2.PostedFile.ContentType.ToString();
                TextBox5.Value = index.ToString();
                TextBox3.Value = Fileupload2.PostedFile.ContentLength.ToString();
                TextBox4.Value = Fileupload2.PostedFile.InputStream.Read(bytes, 0, byts).ToString();
                TextBox2.Value = Fileupload2.FileName;
            }
        }
        catch
        {}
 }
}