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
using FreightEasy.DataManager;

public partial class SystemAdmin_ELTAccountManager : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void SqlDataSource1_Init(object sender, EventArgs e)
    {
        SqlDataSource obj = (SqlDataSource)sender;
        obj.ConnectionString = (new igFunctions.DB().getConStr());
        obj.SelectCommand = @"
            SELECT elt_account_number,dba_name,account_statue AS status,board_name,business_phone,
            (SELECT COUNT(*) FROM mawb_number WHERE elt_account_number=agent.elt_account_number) AS air_export,
            (SELECT COUNT(*) FROM ocean_booking_number WHERE elt_account_number=agent.elt_account_number) AS ocean_export,
            (SELECT COUNT(*) FROM import_mawb WHERE elt_account_number=agent.elt_account_number AND iType='A') AS air_import,
            (SELECT COUNT(*) FROM import_mawb WHERE elt_account_number=agent.elt_account_number AND iType='O') AS ocean_import,
            (SELECT COUNT(*) FROM organization WHERE elt_account_number=agent.elt_account_number) AS clients,
            (SELECT COUNT(*) FROM INVOICE WHERE elt_account_number=agent.elt_account_number) AS invoice,
            CASE WHEN account_statue<>'A' Then 'Delete' Else 'Delete' END AS delete_text 
            FROM agent ORDER BY elt_account_number";
        obj.DeleteCommand = "EXEC dbo.DeleteAllTableRowsByELT @elt_account_number";
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
    }
}
