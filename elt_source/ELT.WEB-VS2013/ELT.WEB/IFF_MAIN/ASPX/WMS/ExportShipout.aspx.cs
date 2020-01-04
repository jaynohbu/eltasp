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

public partial class ASPX_WMS_ExportShipout : System.Web.UI.Page
{
    protected string elt_account_number, user_id, login_name, user_right, SONum;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            GetShipOutData();
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        SONum = Request.Params["SONum"];
    }

    protected void GetShipOutData()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();

        string txtSQL = "SELECT * FROM warehouse_shipout WHERE elt_account_number=" 
                + elt_account_number + " AND so_num=N'" + SONum + "'";
        feData.AddToDataSet("ShipOut", txtSQL);
        
        if (feData.Tables["ShipOut"].Rows.Count > 0)
        {
            DataRow drTmp = feData.Tables["ShipOut"].Rows[0];
            txtSONum.Text = drTmp["so_num"].ToString();


            if (drTmp["customer_acct"].ToString() != "")
            {
                txtSQL = "SELECT * FROM organization WHERE elt_account_number=" 
                    + elt_account_number + " AND org_account_number=" + drTmp["customer_acct"].ToString();
                feData.AddToDataSet("ShipperInfo", txtSQL);
                if (feData.Tables["ShipperInfo"].Rows.Count > 0)
                {
                    DataRow drShipperTmp = feData.Tables["ShipperInfo"].Rows[0];
                    txtShipper.Text = drShipperTmp["dba_name"].ToString();
                }
            }

            if (drTmp["consignee_acct"].ToString() != "")
            {
                txtSQL = "SELECT * FROM organization WHERE elt_account_number="
                    + elt_account_number + " AND org_account_number=" + drTmp["consignee_acct"].ToString();
                feData.AddToDataSet("ConsigneeInfo", txtSQL);
                if (feData.Tables["ConsigneeInfo"].Rows.Count > 0)
                {
                    DataRow drConsigneeTmp = feData.Tables["ConsigneeInfo"].Rows[0];
                    txtConsignee.Text = drConsigneeTmp["dba_name"].ToString();
                }
            }

            txtSQL = "SELECT * FROM warehouse_receipt a LEFT OUTER JOIN warehouse_history b "
                + "ON (a.elt_account_number=b.elt_account_number AND a.wr_num=b.wr_num) "
                + "WHERE a.elt_account_number=" + elt_account_number + " AND b.so_num=N'" 
                + drTmp["so_num"].ToString() + "' AND history_type='Ship-out Made'";
            feData.AddToDataSet("WarehouseReceipts", txtSQL);

            int item_qty = 0;
            for (int i = 0; i < feData.Tables["WarehouseReceipts"].Rows.Count; i++)
            {
                DataRow drWRTmp = feData.Tables["WarehouseReceipts"].Rows[i];
                if (drWRTmp["item_desc"].ToString() != "")
                {
                    txtItemDesc.Text = txtItemDesc.Text + drWRTmp["item_desc"].ToString() + "\n";
                }

                if (drWRTmp["handling_info"].ToString() != "")
                {
                    txtHandling.Text = txtHandling.Text + drWRTmp["handling_info"].ToString() + "\n";
                }

                item_qty = item_qty + int.Parse(drWRTmp["item_piece_shipout"].ToString());
            }
            txtItemQty.Text = item_qty.ToString();
        }
    }
}
