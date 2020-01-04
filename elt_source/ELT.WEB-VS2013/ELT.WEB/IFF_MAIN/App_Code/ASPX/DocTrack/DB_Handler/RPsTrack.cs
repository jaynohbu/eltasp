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

/// <summary>
/// Summary description for RPsTrack
/// </summary>
public class RPsTrack : DocTrack
{    
    public RPsTrack(string elt_account_number, string ConnectStr):base(elt_account_number, ConnectStr){

    } 

    public DataTable /*string*/ getRPsByIV(string refno) {

        string Qry = "";
        ConnectStr = (new igFunctions.DB().getConStr());
        SqlConnection Con = new SqlConnection(ConnectStr);
        DataTable dt = new DataTable();

        Qry = @"select
            '' as [Primary],
            '' as [Foreign], 
            a.payment_no as [RP#],         
           a.payment_date as [Date Issued],          
            b.payment as [Paid]
           from customer_payment a " +
           @"left outer join customer_payment_detail b
           on a.payment_no = b.payment_no and a.elt_account_number = b.elt_account_number" + " where a.elt_account_number = " + elt_account_number
            + " and b.type ='INVOICE' and b.invoice_no =" + refno + " order by [Date Issued] DESC";

           
        SqlCommand cmd = new SqlCommand(Qry);
        cmd.Connection = Con;
        SqlDataAdapter Adap = new SqlDataAdapter();

        Con.Open();
        Adap.SelectCommand = cmd;

        Adap.Fill(dt);
        Con.Close();

       return dt;
        //return Qry;
    }
   
}
