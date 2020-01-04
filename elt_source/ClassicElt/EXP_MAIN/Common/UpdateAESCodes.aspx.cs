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
using System.Text;
using System.IO;
using System.Net;

public partial class Common_UpdateAESCodes : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AddPortCodes();
    }


    protected void AddPortCodes()
    {
        DataSet ds = new DataSet();
        /*
        ds.Tables.Add(GetScheduleD("http://www.aesdirect.gov/support/tables/schdd.txt"));
        ds.Tables.Add(GetScheduleK("http://www.aesdirect.gov/support/tables/schdk.txt"));
        ds.Tables.Add(GetPortCode("http://localhost:8080/EXP_MAIN/Code/IATA.txt"));
        ds.Tables.Add(GetIATACode3("http://www.aesdirect.gov/support/tables/iata3.txt"));
        ds.Tables.Add(GetIATACode2("http://www.aesdirect.gov/support/tables/iata2.txt"));
        InsertCodes(ds.Tables[0]);
        InsertCodes(ds.Tables[1]);
        InsertCodes(ds.Tables[2]);
        InsertCodes(ds.Tables[3]);
        InsertCodes(ds.Tables[4]);
        */
    }

    public void InsertCodes(DataTable dt)
    {
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = null;
        string returnURL = "";

        Con = new SqlConnection(ConnectStr);
        SqlCommand Cmd = new SqlCommand();
        Cmd.Connection = Con;
        Con.Open();
        SqlTransaction trans = Con.BeginTransaction();
        Cmd.Transaction = trans;

        try
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                Cmd.CommandText = "INSERT INTO aes_codes VALUES('" + dt.Rows[i][0].ToString()
                    + "','" + dt.Rows[i][1].ToString() + "','" + dt.Rows[i][2].ToString().Replace("'", "`") + "')";

                Cmd.ExecuteNonQuery().ToString();
            }

            trans.Commit();
            Con.Close();
        }
        catch
        {
            trans.Rollback();
        }
        finally { if (Con != null) { Con.Close(); } }

    }

    public DataTable GetPortCode(string url)
    {
        DataTable codeTable = new DataTable();
        DataRow codeRow;

        codeTable.Columns.Add(new DataColumn("code_type", typeof(string)));
        codeTable.Columns.Add(new DataColumn("code_id", typeof(string)));
        codeTable.Columns.Add(new DataColumn("code_desc", typeof(string)));

        try
        {
            WebRequest request = WebRequest.Create(url);
            StreamReader stream = new StreamReader(request.GetResponse().GetResponseStream());

            while (!(stream.Peek() == 0))
            {
                codeRow = codeTable.NewRow();
                string tmpStr = stream.ReadLine().ToUpper().Trim();
                codeRow[0] = "Port Code";
                codeRow[1] = tmpStr.Substring(tmpStr.Length - 3);
                codeRow[2] = tmpStr.Substring(0, tmpStr.Length - 4);

                if (codeRow[1].ToString() != string.Empty)
                {
                    codeTable.Rows.Add(codeRow);
                }
            }
            stream.Close();
        }
        catch (Exception ex)
        {
        }
        return codeTable;
    }

    

    public DataTable GetScheduleD(string url)
    {
        DataTable codeTable = new DataTable();
        DataRow codeRow;

        codeTable.Columns.Add(new DataColumn("code_type", typeof(string)));
        codeTable.Columns.Add(new DataColumn("code_id", typeof(string)));
        codeTable.Columns.Add(new DataColumn("code_desc", typeof(string)));

        try
        {
            WebRequest request = WebRequest.Create(url);
            StreamReader stream = new StreamReader(request.GetResponse().GetResponseStream());

            while (!(stream.Peek() == 0))
            {
                codeRow = codeTable.NewRow();
                string tmpStr = stream.ReadLine().ToUpper().Trim();
                codeRow[0] = "Schedule D";
                codeRow[1] = tmpStr.Substring(0, tmpStr.IndexOf("-"));
                codeRow[2] = tmpStr.Substring(tmpStr.IndexOf("-") + 1);
                if (codeRow[1].ToString() != string.Empty)
                {
                    codeTable.Rows.Add(codeRow);
                }
            }
            stream.Close();
        }
        catch (Exception ex)
        {
        }
        return codeTable;
    }

    public DataTable GetScheduleK(string url)
    {
        DataTable codeTable = new DataTable();
        DataRow codeRow;

        codeTable.Columns.Add(new DataColumn("code_type", typeof(string)));
        codeTable.Columns.Add(new DataColumn("code_id", typeof(string)));
        codeTable.Columns.Add(new DataColumn("code_desc", typeof(string)));

        try
        {
            WebRequest request = WebRequest.Create(url);
            StreamReader stream = new StreamReader(request.GetResponse().GetResponseStream());

            while (!(stream.Peek() == 0))
            {
                codeRow = codeTable.NewRow();
                string tmpStr = stream.ReadLine().ToUpper().Trim();
                codeRow[0] = "Schedule K";
                codeRow[1] = tmpStr.Substring(0, tmpStr.IndexOf("-"));
                codeRow[2] = tmpStr.Substring(tmpStr.IndexOf("-") + 1);
                if (codeRow[1].ToString() != string.Empty)
                {
                    codeTable.Rows.Add(codeRow);
                }
            }
            stream.Close();
        }
        catch (Exception ex)
        {
        }
        return codeTable;
    }

    public DataTable GetIATACode3(string url)
    {
        DataTable codeTable = new DataTable();
        DataRow codeRow;

        codeTable.Columns.Add(new DataColumn("code_type", typeof(string)));
        codeTable.Columns.Add(new DataColumn("code_id", typeof(string)));
        codeTable.Columns.Add(new DataColumn("code_desc", typeof(string)));

        try
        {
            WebRequest request = WebRequest.Create(url);
            StreamReader stream = new StreamReader(request.GetResponse().GetResponseStream());

            while (!(stream.Peek() == 0))
            {
                codeRow = codeTable.NewRow();
                string tmpStr = stream.ReadLine().ToUpper().Trim();
                codeRow[0] = "IATA Code 3";
                codeRow[1] = tmpStr.Substring(0, tmpStr.IndexOf("-"));
                codeRow[2] = tmpStr.Substring(tmpStr.IndexOf("-") + 1);
                if (codeRow[1].ToString() != string.Empty)
                {
                    codeTable.Rows.Add(codeRow);
                }
            }
            stream.Close();
        }
        catch (Exception ex)
        {
        }
        return codeTable;
    }

    public DataTable GetIATACode2(string url)
    {
        DataTable codeTable = new DataTable();
        DataRow codeRow;

        codeTable.Columns.Add(new DataColumn("code_type", typeof(string)));
        codeTable.Columns.Add(new DataColumn("code_id", typeof(string)));
        codeTable.Columns.Add(new DataColumn("code_desc", typeof(string)));

        try
        {
            WebRequest request = WebRequest.Create(url);
            StreamReader stream = new StreamReader(request.GetResponse().GetResponseStream());

            while (!(stream.Peek() == 0))
            {
                codeRow = codeTable.NewRow();
                string tmpStr = stream.ReadLine().ToUpper().Trim();
                codeRow[0] = "IATA Code 2";
                codeRow[1] = tmpStr.Substring(0, tmpStr.IndexOf("-"));
                codeRow[2] = tmpStr.Substring(tmpStr.IndexOf("-") + 1, tmpStr.Length - tmpStr.IndexOf("-") - 1);

                if (codeRow[1].ToString() != string.Empty)
                {
                    codeTable.Rows.Add(codeRow);
                }
            }
            stream.Close();
        }
        catch (Exception ex)
        {
        }
        return codeTable;
    }
}
