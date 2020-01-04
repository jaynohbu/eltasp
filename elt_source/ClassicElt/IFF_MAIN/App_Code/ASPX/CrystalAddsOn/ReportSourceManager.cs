using System;
using System.IO;
using System.Data;
using System.Drawing;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;

/// <summary>
/// Summary description for DataSetLoader
/// </summary>
/// 
public class ReportSourceManager
{
    protected ReportDocument rd;
    protected ReportDocument sub;
    protected DataSet ds;

    public ReportSourceManager()
    {
        ds = new DataSet();
    }

    public DataSet GetDataSet()
    {
        return ds;
    }

    public ReportDocument getReportDocument()
    {
        return rd;
    }

    public bool isLoaded()
    {
        return rd.IsLoaded;
    }

    public void TableRename(string old, string nu)
    {
        if (ds != null && ds.Tables[old] != null)
        {
            ds.Tables[old].TableName = nu;
        }
    }
    private void addImageTable(string columName, string imageFile)
    {
        DataTable dataTable = new DataTable();
        dataTable.TableName = "Images";
        try
        {
            if (imageFile != null)
            {
                dataTable.Columns.Add(columName, System.Type.GetType("System.Byte[]"));
                DataRow dataRow = dataTable.NewRow();
                dataRow[0] = File.ReadAllBytes(imageFile);
                dataTable.Rows.Add(dataRow);                
            }
        }
        catch (Exception ex)
        {
        }
        ds.Tables.Add(dataTable);
    }

    public void LoadOtherInfo(string[] values)
    {
        DataTable dataTable = new DataTable();
        dataTable.TableName = "Other";

        if (values != null)
        {
            for(int i=0;i<values.Length;i++)
            {
                dataTable.Columns.Add("Param" + i, System.Type.GetType("System.String"));
            }
            dataTable.Rows.Add(values);
            ds.Tables.Add(dataTable);
        }
    }

    public void LoadCompanyInfo(string accountNumber, string imageFile)
    {
        string selectCompany = "select business_legal_name, business_address,business_city, "
            + "business_state, business_country, business_phone, business_fax, business_url "
            + "from agent where elt_account_number = " + accountNumber;
        string ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        SqlCommand cmd = new SqlCommand(selectCompany, Con);
        SqlDataAdapter Adap = new SqlDataAdapter();

        Con.Open();
        Adap.SelectCommand = cmd;
        Adap.Fill(ds, "Business");
        Con.Close();

        addImageTable("image_files", imageFile);
    }

    public void LoadDataSet(DataSet dset)
    {
        if (dset != null)
        {
            //ds = dset.Copy();
            ds = dset;
        }
    }

    public bool BindNow(string rptFile)
    {
        try
        {
            rd = new ReportDocument();
            rd.Load(rptFile, OpenReportMethod.OpenReportByTempCopy);
            rd.SetDataSource(ds); 
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return true;
    }

    public bool BindSub(string rptFile)
    {
        try
        {
            if (rd.IsLoaded)
            {
                sub = new ReportDocument();
                sub = rd.OpenSubreport(rptFile);
                sub.SetDataSource(ds);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return true;
    }

    public bool WriteXSD(string xsdFile)
    {
        bool res = true;

        if (xsdFile != null && (!File.Exists(xsdFile)))
        {
            try
            {
                ds.WriteXmlSchema(xsdFile);
            }
            catch (Exception ex)
            {
                throw ex;
            }
         }
         return res;
    }

    public bool CloseReportDocumnet()
    {
        try
        {
            ds.Dispose();
            if (rd != null)
            {
                rd.Close();
                rd.Dispose();
            }
            if (sub != null)
            {
                sub.Close();
                sub.Dispose();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return true;
    }

    public void AddField(string tName, string colName, Type dataType, object defaultValue)
    {
        ds.Tables[tName].Columns.Add(colName, dataType);
        for (int i = 0; i < ds.Tables[tName].Rows.Count; i++)
        {
            ds.Tables[tName].Rows[i][colName] = defaultValue;
        }
    }

    ~ReportSourceManager()
    {
        //CloseReportDocumnet();
    }
}
