using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Collections;
using System.Text;


/// <summary>
/// Summary description for glManager
/// </summary>
public class PortManager:Manager
{
    public PortManager(string elt_acct)
        : base(elt_acct)
    {
       
    }

    public ArrayList getPortList(string gl_account_type)
    {
        SQL = "select port_code,port_desc from port where elt_account_number = " + elt_account_number + " AND ISNULL(port_desc,'') <> '' order by port_desc";
      
        DataTable dt = new DataTable();
        SqlDataAdapter ad = new SqlDataAdapter(SQL, Con);
        GeneralUtility gUtil = new GeneralUtility();
        ArrayList pRecList = new ArrayList();
        ad.Fill(dt);
        PortRecord pRec;
        try
        {
            pRec = new PortRecord();
            pRec.port_code = "-1";
            pRec.port_desc = "Select Port";
            pRecList.Add(pRec);
            gUtil.removeNull(ref dt);
           
            for (int i = 0; i < dt.Rows.Count; i++)
            {
               pRec = new PortRecord();
                pRec.port_code = dt.Rows[i]["port_code"].ToString();
                pRec.port_desc = dt.Rows[i]["port_desc"].ToString();
                pRecList.Add(pRec);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return pRecList;
    }   
}
