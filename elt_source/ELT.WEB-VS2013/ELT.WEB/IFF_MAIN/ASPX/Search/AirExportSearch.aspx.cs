using System;
using System.IO;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using Infragistics.WebUI.UltraWebGrid;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;

public partial class ASPX_Search_AirExportSearch : System.Web.UI.Page
{
    protected string user_id, login_name, user_right, elt_account_number;
    FreightEasy.DataManager.FreightEasyData FEData;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];

        try
        {
            if (!IsPostBack)
            {
                FEData = new FreightEasy.DataManager.FreightEasyData();
                LoadPorts();
                LoadSalesPersons();
            }
        }
        catch
        {
        }
    }


    protected void btnGo_Click(object sender, ImageClickEventArgs e)
    {
        


        if (lstSearchType.SelectedValue == "house")
        {
            gvHouseResult.Visible = true;
            gvMasterResult.Visible = false;
            string txtSQL = BuildSearchSQL();
            SetFreightEasyData(gvHouseResult, txtSQL);

        }
        else if (lstSearchType.SelectedValue == "master")
        {
            gvHouseResult.Visible = false;
            gvMasterResult.Visible = true;
            string txtSQL = BuildSearchSQL();
            SetFreightEasyData(gvMasterResult,txtSQL);
        }
        else
        {
            gvHouseResult.Visible = false;
            gvMasterResult.Visible = false;
        }

        //gvHouseResult.DisplayLayout.Pager.CurrentPageIndex = 1;
    }

    protected void SetFreightEasyData(GridView control, string txtSQL)
    {
       // gvHouseResult.Clear();
        FEData = new FreightEasy.DataManager.FreightEasyData();
        FEData.AddToDataSet("SearchList", txtSQL);
        control.DataSource = FEData.Tables["SearchList"].DefaultView;
        control.DataBind();
        txtResultBox.Text = FEData.Tables["SearchList"].Rows.Count.ToString() + " Records Found.";
        btnExcelExport.Visible = true;
    }

    protected string BuildSearchSQL()
    {
        string txtSQL = "";

        if (lstSearchType.SelectedValue == "house")
        {
            txtSQL = "select a.HAWB_NUM as HAWB_NUM, isnull(a.MAWB_NUM,'') as MasterNo,isnull(b.file#,'') as file#,isnull(b.Carrier_Desc, '') as "
                 + "Carrier_Desc,a.aes_xtn as aes_xtn,a.is_sub as is_sub,b.Status as Status,b.used as used,a.is_master as is_master,"
                 + "a.Shipper_Name as Shipper_Name,a.shipper_account_number as shipper_account_number,"
                 + "a.Consignee_acct_num  as Consignee_acct_num, a.Agent_No as Agent_No,a.consignee_name as consignee_name,a.Agent_name as "
                 + "Agent_name,Right(rtrim(a.MAWB_NUM),4) as lastF#,a.SalesPerson as SalesPerson,a.is_master_closed as is_master_closed"
                 + ",a.Departure_Airport as Departure_Airport,a.Dest_Airport as Dest_Airport,CASE WHEN a.is_master='Y' THEN 'Master House' WHEN a.is_sub='Y' THEN 'Sub House' END AS Type,a.CreatedDate FROM hawb_master a left outer join mawb_number "
                 + "b on a.elt_account_number = b.elt_account_number and a.mawb_num = b.mawb_no where isnull(a.HAWB_NUM,'') <> '' and isnull(a.is_dome,'N') ='N' "
                 + "and a.elt_account_number =" + elt_account_number;

            // period filter
            if (Webdatetimeedit1.Text.Trim() != "")
            {
                txtSQL += " AND a.CreatedDate>=CAST('" + Webdatetimeedit1.Text + "' AS DATETIME)";
            }

            if (Webdatetimeedit2.Text.Trim() != "")
            {
                txtSQL += " AND a.CreatedDate<DATEADD(DAY,1,'" + Webdatetimeedit2.Text + "')";
            }

            if (txtlast.Text != "")
            {
                txtSQL += " AND Right(rtrim(a.MAWB_NUM),4) like N'" + txtlast.Text + "%'";
            }

            if (lstShipperName.Text != "")
            {
                txtSQL += " AND a.shipper_name like N'" + lstShipperName.Text + "%'";
            }

            if (OriginPortSelect.SelectedIndex > 0)
            {
                txtSQL += " AND b.origin_port_id='" + OriginPortSelect.SelectedValue + "'";
            }

            if (DestPortSelect.SelectedIndex > 0)
            {
                txtSQL += " AND b.dest_port_id='" + DestPortSelect.SelectedValue + "'";
            }

            if (lstCarrierName.Text != "")
            {
                txtSQL += " AND b.Carrier_Desc like N'" + lstCarrierName.Text + "%'";
            }

            if (hConsigneeAcct.Value != "" && hConsigneeAcct.Value != "0")
            {
                txtSQL += " AND a.consignee_acct_num=" + hConsigneeAcct.Value;
            }

            if (NoPiece.Text != "")
            {
                txtSQL += " AND a.Total_Pieces =" + NoPiece.Text;
            }

            if (AESNO.Text != "")
            {
                txtSQL += " AND a.aes_xtn =" + AESNO.Text;
            }

            if (LCNO.Text != "")
            {
                txtSQL += " AND a.lc like N'" + LCNO.Text + "%'";
            }

            if (CINO.Text != "")
            {
                txtSQL += " AND a.ci like N'" + CINO.Text + "%'";
            }

            if (OTH_REF_NO.Text != "")
            {
                txtSQL += " AND a.other_ref like N'" + OTH_REF_NO.Text + "%'";
            }

            if (txtFileNo.Text != "")
            {
                txtSQL += " AND b.file# like N'" + txtFileNo.Text + "%'";
            }

            if (lstSearchNum.Text != "")
            {
                txtSQL += " AND a.MAWB_NUM like N'" + lstSearchNum.Text + "%'";
            }

            if (txtHouseNo.Text != "")
            {
                txtSQL += " AND a.HAWB_NUM like N'" + txtHouseNo.Text + "%'";
            }

            if (lstAgentName.Text != "")
            {
                txtSQL += " AND a.Agent_name like N'" + lstAgentName.Text + "%'";
            }

            if (SaleDroplist.SelectedValue != "")
            {
                txtSQL += " AND a.SalesPerson like N'" + SaleDroplist.SelectedValue + "'";
            }

            if (lstHouseType.SelectedValue == "Master")
            {
                txtSQL += " AND a.is_master='Y'";
            }

            if (lstHouseType.SelectedValue == "Sub")
            {
                txtSQL += " AND a.is_sub='Y'";
            }

            txtSQL += " ORDER BY a.HAWB_NUM";
        }

        if (lstSearchType.SelectedValue == "master")
        {
            txtSQL = "select isnull(a.MAWB_NUM,'') as MasterNo,b.file# as file#,b.Carrier_Desc as Carrier_Desc,"
                + " Right(rtrim(a.MAWB_NUM),4) as lastF#,a.Shipper_Name as Shipper_Name,a.shipper_account_number as shipper_account_number,b.used as used,"
                + " a.SalesPerson as SalesPerson,a.consignee_name as consignee_name,a.master_agent as master_agent, a.Consignee_acct_num  as Consignee_acct_num,"
                + " a.Departure_Airport as Departure_Airport,a.Dest_Airport as Dest_Airport,CASE WHEN b.Status='B' THEN 'Booked' WHEN b.Status='C' THEN 'Closed' WHEN b.Status='A' THEN 'Assigned' END AS Status,"
                + "CASE WHEN a.MAWB_NUM IN (select a.MAWB_NUM from hawb_master a left outer join mawb_number b on a.elt_account_number = b.elt_account_number and a.mawb_num = b.mawb_no where a.elt_account_number="
                + elt_account_number + " AND a.mawb_num <> '') THEN 'Consol' ELSE 'Direct' END AS Type,a.CreatedDate FROM mawb_master a left join mawb_number b "
                + " on (a.elt_account_number = b.elt_account_number and a.mawb_num = b.mawb_no) where a.is_dome='N' and a.elt_account_number = " + elt_account_number;

            // period filter
            if (Webdatetimeedit1.Text.Trim() != "")
            {
                txtSQL += " AND a.CreatedDate>=CAST('" + Webdatetimeedit1.Text + "' AS DATETIME)";
            }

            if (Webdatetimeedit2.Text.Trim() != "")
            {
                txtSQL += " AND a.CreatedDate<DATEADD(DAY,1,'" + Webdatetimeedit2.Text + "')";
            }

            if (txtlast.Text != "")
            {
                txtSQL += "AND Right(rtrim(a.MAWB_NUM),4) like N'" + txtlast.Text + "%'";
            }

            if (OriginPortSelect.SelectedIndex > 0)
            {
                txtSQL += " AND b.origin_port_id='" + OriginPortSelect.SelectedValue + "'";
            }

            if (DestPortSelect.SelectedIndex > 0)
            {
                txtSQL += " AND b.dest_port_id='" + DestPortSelect.SelectedValue + "'";
            }

            if (lstCarrierName.Text != "")
            {
                txtSQL += " AND b.Carrier_Desc like N'" + lstCarrierName.Text + "%'";
            }

            if (lstShipperName.Text != "")
            {
                txtSQL += " AND a.shipper_name like N'" + lstShipperName.Text + "%'";
            }

            if (hConsigneeAcct.Value != "" && hConsigneeAcct.Value != "0")
            {
                txtSQL += " AND a.consignee_acct_num=" + hConsigneeAcct.Value;
            }

            if (NoPiece.Text != "")
            {
                txtSQL += " AND a.Total_Pieces =" + NoPiece.Text;
            }

            if (txtFileNo.Text != "")
            {
                txtSQL += " AND b.file# like N'%" + txtFileNo.Text + "%'";
            }
            if (lstSearchNum.Text != "")
            {
                txtSQL += " AND a.MAWB_NUM like N'%" + lstSearchNum.Text + "%'";
            }

            if (SaleDroplist.SelectedIndex > 0)
            {
                txtSQL += " AND a.SalesPerson like N'" + SaleDroplist.SelectedValue + "'";
            }

            if (lstMasterStatus.SelectedValue == "Closed")
            {
                txtSQL += " AND b.Status like N'%C%'";
            }

            if (lstMasterStatus.SelectedValue == "Used")
            {
                txtSQL += " AND b.used like N'%Y%'";
            }

            if (lstShipmentType.SelectedValue == "Consol")
            {
                txtSQL += "AND a.MAWB_NUM IN (select a.MAWB_NUM from hawb_master a left outer join mawb_number b on "
                    + " a.elt_account_number = b.elt_account_number and a.mawb_num = b.mawb_no where a.elt_account_number= " 
                    + elt_account_number + " and a.mawb_num <> '')";
            }

            if (lstShipmentType.SelectedValue == "Direct")
            {
                txtSQL += "AND a.MAWB_NUM Not IN (select a.MAWB_NUM from hawb_master a left outer join mawb_number b on "
                    + " a.elt_account_number = b.elt_account_number and a.mawb_num = b.mawb_no where a.elt_account_number= " 
                    + elt_account_number + " and a.mawb_num <> '')";
            }

            txtSQL += " ORDER BY a.MAWB_NUM";
        }

        return txtSQL;
    }

    protected void LoadPorts()
    {
        FEData.AddToDataSet("Ports", "SELECT port_code + ' - ' + port_desc as port_name,port_code FROM port WHERE elt_account_number=" + elt_account_number + " ORDER BY port_desc");
        OriginPortSelect.DataSource = FEData.Tables["Ports"].DefaultView;
        OriginPortSelect.DataTextField = "port_name";
        OriginPortSelect.DataValueField = "port_code";
        OriginPortSelect.DataBind();
        OriginPortSelect.Items.Insert(0, new ListItem("", ""));
        DestPortSelect.DataSource = FEData.Tables["Ports"].DefaultView;
        DestPortSelect.DataTextField = "port_name";
        DestPortSelect.DataValueField = "port_code";
        DestPortSelect.DataBind();
        DestPortSelect.Items.Insert(0, new ListItem("", ""));
    }

    protected void LoadSalesPersons()
    {
        FEData.AddToDataSet("SalesPersons", "select distinct(SalesPerson) from MAWB_MASTER where elt_account_number = " + elt_account_number + " and len(SalesPerson)>0 and SalesPerson <> 'none'order by SalesPerson DESC");
        SaleDroplist.DataSource = FEData.Tables["SalesPersons"].DefaultView;
        SaleDroplist.DataTextField = "SalesPerson";
        SaleDroplist.DataValueField = "SalesPerson";
        SaleDroplist.DataBind();
        SaleDroplist.Items.Insert(0, new ListItem("", ""));
    }

    protected void btnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        Response.ClearContent();
        Response.AddHeader("content-disposition",
            "attachment;filename=AESearch.xls");
        Response.ContentType = "applicatio/excel";
        StringWriter sw = new StringWriter(); ;
        HtmlTextWriter htm = new HtmlTextWriter(sw);

        if (gvHouseResult.Visible)
        {
            gvHouseResult.RenderControl(htm);

        }
        else if (gvMasterResult.Visible)
        {
            gvMasterResult.RenderControl(htm);
        }
        else
        {
            
        }

        
        
        
        Response.Write(sw.ToString());
        Response.End();
    }

    protected override object LoadPageStateFromPersistenceMedium()
    {
        object state = this.Session["GridState"];
        return state;
    }

    protected override void SavePageStateToPersistenceMedium(object viewState)
    {
        this.Session.Add("GridState", viewState);
    }



    protected void gvHouseResult_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        string txtSQL = BuildSearchSQL();
        
        gvHouseResult.PageIndex = e.NewPageIndex;
        SetFreightEasyData(gvHouseResult, txtSQL);
        //gvHouseResult.DataBind();
    }

    protected void gvMasterResult_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        string txtSQL = BuildSearchSQL();
        
        gvMasterResult.PageIndex = e.NewPageIndex;
        SetFreightEasyData(gvMasterResult, txtSQL);
       // gvMasterResult.DataBind();
    }


    public override void VerifyRenderingInServerForm(Control control)
    {
        /* Confirms that an HtmlForm control is rendered for the specified ASP.NET
           server control at run time. */
    }
}
