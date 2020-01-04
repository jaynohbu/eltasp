<%@ WebHandler Language="C#" Class="XMLReport"%>

using System;
using System.Web;
using System.Web.SessionState;
using System.Data;
using System.Data.SqlClient;

public class XMLReport : IHttpHandler, IReadOnlySessionState {

    DataSet ds;
    string sqlText;
    protected string ConnectStr;
    
    public void ProcessRequest (HttpContext context) {
        
        context.Response.ContentType = "text/xml";
        context.Response.AddHeader("Content-Type", "text/xml");
        context.Response.AddHeader("Content-Disposition", "inline");

        sqlText = context.Session["XML_SQLText"].ToString();
        
        BindToDataSet("organization");
        ds.WriteXml(context.Response.Output, XmlWriteMode.WriteSchema);
        context.Response.End();
        //ds.Dispose();
    }
 
    public bool IsReusable {
        get {
            return false;
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
                SqlCommand cmd = new SqlCommand(sqlText.ToString(), Con);
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
}