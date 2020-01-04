<%@ WebHandler Language="C#" Class="ViewEmailReport" %>

using System;
using System.IO;
using System.Threading;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;

public class ViewEmailReport : IHttpHandler
{
    protected DataSet ds = null;
    protected ReportSourceManager rsm = null;
    private string uid = "";
    private string sid = "";
    private string sqlText;
    private string ConnectStr;
    private string sender;
    private string period;
    
    public void ProcessRequest (HttpContext context) {

        try
        {
            context.Response.Clear();
            context.Response.Buffer = true;
            context.Response.ContentType = "application/pdf";
            context.Response.AddHeader("Content-Type", "application/pdf");
            context.Response.AddHeader("Content-disposition", "inline");
            
            uid = context.Request.Params["mid"].ToString();
            sid = context.Request.Params["sid"].ToString();
            
            ProcessEmail();
            BindToDataSet("ARDetail");
            AdjustBalance();

            rsm = new ReportSourceManager();
            rsm.LoadDataSet(ds);
            
            string imageFile = context.Server.MapPath("../../../ClientLogos/" + sender + ".jpg");
            string[] str = new string[1];

            str[0] = period;
            rsm.LoadCompanyInfo(sender,imageFile);
            rsm.LoadOtherInfo(str);
            rsm.WriteXSD(context.Server.MapPath("../../../CrystalReportResources/xsd/ARdetView.xsd"));
            rsm.BindNow(context.Server.MapPath("../../../CrystalReportResources/rpt/ARdetView.rpt"));
            UpdateEmailStatus("Report Viewed");
            
            ReportDocument rd = rsm.getReportDocument();
            
            //rd.ExportToHttpResponse(ExportFormatType.PortableDocFormat, context.Response, false, "ARDetail");
            
            MemoryStream oStream; // using System.IO
            oStream = (MemoryStream)rsm.getReportDocument().ExportToStream(ExportFormatType.PortableDocFormat);
            context.Response.BinaryWrite(oStream.ToArray());
        }
        catch (ThreadAbortException e2)
        {
            if (e2 != null)
            {
            }
        }
        catch
        {
            context.Response.Redirect("../../../../");
        }
        finally
        {
            rsm.CloseReportDocumnet();
        }
    }
 
    public bool IsReusable {
        get {
            return true;
        }
    }

    protected void BindToDataSet(string tName)
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
                System.Text.StringBuilder state = new System.Text.StringBuilder();
                ds = new DataSet();

                Con.Open();
                SqlCommand cmd = new SqlCommand(sqlText, Con);
                Adap.SelectCommand = cmd;
                Adap.Fill(ds, tName);
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

    protected void ProcessEmail()
    {
        SqlDataAdapter Adap = null;
        SqlConnection Con = null;
        DataTable dt = null;
        string selectText = "SELECT sqlstr, elt_account_number, period from email_report where auto_uid ="
            + uid + " AND session_id ='" + sid + "'";

        try
        {
            ConnectStr = (new igFunctions.DB().getConStr());
            Con = new SqlConnection(ConnectStr);
            Adap = new SqlDataAdapter();
            dt = new DataTable();
            System.Text.StringBuilder state = new System.Text.StringBuilder();

            Con.Open();
            SqlCommand cmd = new SqlCommand(selectText, Con);
            Adap.SelectCommand = cmd;
            Adap.Fill(dt);
            sqlText = dt.Rows[0][0].ToString();
            sender = dt.Rows[0][1].ToString();
            period = dt.Rows[0][2].ToString();
        }
        catch { }
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
    
    private void AdjustBalance()
    {
        double prev = 0;
        double debit = 0;
        double credit = 0;

        for (int i = 1; i < ds.Tables["ARDetail"].Rows.Count; i++)
        {
            prev = double.Parse(ds.Tables["ARDetail"].Rows[i - 1]["balance"].ToString());
            debit = double.Parse(ds.Tables["ARDetail"].Rows[i]["debit_amount"].ToString());
            credit = double.Parse(ds.Tables["ARDetail"].Rows[i]["credit_amount"].ToString());

            ds.Tables["ARDetail"].Rows[i]["balance"] = prev + debit + credit;
        }
    }

    private void UpdateEmailStatus(string status)
    {
        SqlConnection Con = null;

        string updateStr = "Update email_report set status = '" + status
            + "' where auto_uid = " + uid + " AND session_id ='" + sid + "'";

        try
        {
            ConnectStr = (new igFunctions.DB().getConStr());
            Con = new SqlConnection(ConnectStr);
            
            Con.Open();
            SqlCommand cmd = new SqlCommand(updateStr, Con);
            cmd.ExecuteNonQuery();
        }
        catch {}
        finally{ if (Con != null){ Con.Close(); } }
        
    }
}