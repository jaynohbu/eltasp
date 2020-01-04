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

public partial class ASPX_OceanExport_BookingConfirm : System.Web.UI.Page
{
    protected string user_id, login_name, user_right, elt_account_number;
    protected DataSet ds;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;

        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        string bc_uid = Request.Params["UID"];

        if (!IsPostBack)
        {
            Load_Prefix();
            Load_Ports();

            if (bc_uid != "" && bc_uid != null)
            {
                Load_Booking_Confirm(bc_uid);
            }
            else
            {
                this.txt_document_date.Text = DateTime.Now.ToShortDateString();
                this.rbl_dangerous_good.SelectedValue = "No";
                this.txtConsigneeInfo.Text = GetAgentInfo();
            }
        }
        else
        {

        }
    }

    protected void Load_Booking_Confirm(string bc_uid)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("BookingConfirm", "select * from booking_confirm where elt_account_number="
            + elt_account_number + " and auto_uid=" + bc_uid + "");
        DataTable dt = feData.Tables["BookingConfirm"];
        this.hSearchNum.Value = dt.Rows[0]["auto_uid"].ToString();
        this.spn_prefix_select.Visible = false;
        this.td_bill_select.Visible = false;
        if (dt.Rows[0]["document_date"] != DBNull.Value) this.txt_document_date.Text = Convert.ToDateTime(dt.Rows[0]["document_date"]).ToShortDateString();
        this.txt_booking_no.Text = dt.Rows[0]["booking_no"].ToString();
        this.lstSearchNum.Text = dt.Rows[0]["bc_no"].ToString();
        this.hf_booking_no.Value = dt.Rows[0]["booking_no"].ToString();
        this.hf_master_no.Value = dt.Rows[0]["master_no"].ToString();
        this.hf_house_no.Value = dt.Rows[0]["house_no"].ToString();
        this.hf_sub_house_no.Value = dt.Rows[0]["sub_house_no"].ToString();
        this.hShipperAcct.Value = dt.Rows[0]["shipper_acct"].ToString();
        this.lstShipperName.Text = dt.Rows[0]["shipper_name"].ToString();
        this.txtShipperInfo.Text = dt.Rows[0]["shipper_info"].ToString();
        this.hConsigneeAcct.Value = dt.Rows[0]["deliver_to_acct"].ToString();
        this.lstConsigneeName.Text = dt.Rows[0]["deliver_to_name"].ToString();
        this.txtConsigneeInfo.Text = dt.Rows[0]["deliver_to_info"].ToString();
        this.txt_cut_off_date.Text = dt.Rows[0]["cut_off_date"].ToString();
        this.txt_export_reference.Text = dt.Rows[0]["export_reference"].ToString();
        this.hCarrierAcct.Value = dt.Rows[0]["carrier_acct"].ToString();
        this.lstCarrierName.Text = dt.Rows[0]["carrier_name"].ToString();
        this.txt_carrier_no.Text = dt.Rows[0]["carrier_no"].ToString();
        this.txt_place_of_receipt.Text = dt.Rows[0]["place_of_receipt"].ToString();
        this.txt_place_of_delivery.Text = dt.Rows[0]["place_of_delivery"].ToString();
        this.ddl_origin_port.SelectedValue = dt.Rows[0]["dep_port"].ToString();
        this.ddl_dest_port.SelectedValue = dt.Rows[0]["arr_port"].ToString();
        if (dt.Rows[0]["eta"] != DBNull.Value) this.txt_eta_date.Text = Convert.ToDateTime(dt.Rows[0]["eta"]).ToShortDateString();
        if (dt.Rows[0]["etd"] != DBNull.Value) this.txt_etd_date.Text = Convert.ToDateTime(dt.Rows[0]["etd"]).ToShortDateString();
        this.txt_type_of_move.Text = dt.Rows[0]["move_type"].ToString();
        this.hAgentAcct.Value = dt.Rows[0]["dest_agent_acct"].ToString();
        this.lstAgentName.Text = dt.Rows[0]["dest_agent_name"].ToString();
        this.txtAgentInfo.Text = dt.Rows[0]["dest_agent_info"].ToString();
        this.hEmptyPickupAcct.Value = dt.Rows[0]["empty_container_pick_up_acct"].ToString();
        this.lstEmptyPickupName.Text = dt.Rows[0]["empty_container_pick_up_name"].ToString();
        this.txtEmptyPickupInfo.Text = dt.Rows[0]["empty_container_pick_up_info"].ToString();
        this.rbl_dangerous_good.SelectedValue = dt.Rows[0]["dangerous"].ToString();
        this.txt_quantity.Text = dt.Rows[0]["quantity"].ToString();
        this.ddl_quantity_unit.SelectedValue = dt.Rows[0]["quantity_unit"].ToString();
        this.txt_description.Text = dt.Rows[0]["item_desc"].ToString();
        this.txt_weight.Text = dt.Rows[0]["gross_weight"].ToString();
        this.ddl_weight_scale.SelectedValue = dt.Rows[0]["weight_scale"].ToString();
        this.txt_dimension.Text = dt.Rows[0]["dimension"].ToString();
        this.ddl_dimension_scale.SelectedValue = dt.Rows[0]["dimension_scale"].ToString();
        this.txt_remark.Text = dt.Rows[0]["remark"].ToString();
    }

    protected void img_SaveBC_Click(object sender, EventArgs e)
    {
        if (this.hSearchNum.Value != "" && this.hSearchNum.Value != "0")
        {
            Update_Booking_Confirm();
        }
        else
        {
            Insert_Booking_Confirm();
        }
    }

    protected void img_NewBC_Click(object sender, EventArgs e)
    {
        Response.Redirect("/IFF_MAIN/ASPX/OceanExport/BookingConfirm.aspx");
    }

    protected void img_DeleteBC_Click(object sender, EventArgs e)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();

        ArrayList tranStrAL = new ArrayList();
        string tranStr = "DELETE FROM booking_confirm WHERE elt_account_number=" + elt_account_number
            + " AND auto_uid=" + hSearchNum.Value;

        tranStrAL.Add(tranStr);

        if (!feData.DataTransactions((string[])tranStrAL.ToArray(typeof(string))))
        {
            Response.Write(feData.GetLastTransactionError());
        }
        else
        {
            Response.Redirect("BookingConfirm.aspx");
        }
    }

    protected void Load_Prefix()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("PrefixTable", "select * from user_prefix where elt_account_number=" + elt_account_number
            + " and type='BC'");
        ddl_prefix.DataSource = feData.Tables["PrefixTable"];
        ddl_prefix.DataTextField = "prefix";
        ddl_prefix.DataValueField = "next_no";
        ddl_prefix.DataBind();

        if (feData.Tables["PrefixTable"].Rows.Count == 0)
        {
            string script = "<script type='text/javascript'>no_prefix_alert();</script>";
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "", script);
        }
        else
        {
            lbl_bc_no.Text = ddl_prefix.SelectedValue;
        }
    }

    protected void Load_Ports()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("Ports", "select * from port where elt_account_number=" + elt_account_number);

        ddl_dest_port.DataSource = feData.Tables["Ports"];
        ddl_dest_port.DataTextField = "port_desc";
        ddl_dest_port.DataValueField = "port_code";
        ddl_dest_port.DataBind();
        ddl_dest_port.Items.Insert(0, new ListItem("", ""));

        ddl_origin_port.DataSource = feData.Tables["Ports"];
        ddl_origin_port.DataTextField = "port_desc";
        ddl_origin_port.DataValueField = "port_code";
        ddl_origin_port.DataBind();
        ddl_origin_port.Items.Insert(0, new ListItem("", ""));
    }

    protected void btn_print_Click(object sender, EventArgs e)
    {
        if (this.hSearchNum.Value != "" && this.hSearchNum.Value != "0")
        {
            Update_Booking_Confirm();
        }
        else
        {
            Insert_Booking_Confirm();
        }
        string script = "<script type='text/javascript'>viewPDF(" + this.hSearchNum.Value + ");</script>";
        this.ClientScript.RegisterStartupScript(this.GetType(), "PreLoad", script);
    }

    protected void ddl_prefix_Change(object sender, EventArgs e)
    {
        try
        {
            lbl_bc_no.Text = ddl_prefix.SelectedValue;
        }
        catch { }
    }

    protected void btn_load_bill_info_Click(object sender, EventArgs e)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        if (this.lstSearchType.SelectedValue == "house")
        {
            feData.AddToDataSet("BillInfo", "select * from hbol_master where elt_account_number=" + elt_account_number
                + " and hbol_num=N'" + this.lstBillNum.Text + "'");
            feData.AddToDataSet("BookingInfo", "select * from ocean_booking_number where elt_account_number=" + elt_account_number
                + " and booking_num=N'" + feData.Tables["BillInfo"].Rows[0]["booking_num"].ToString() + "'");
            this.hShipperAcct.Value = feData.Tables["BillInfo"].Rows[0]["shipper_acct_num"].ToString();
            this.lstShipperName.Text = feData.Tables["BillInfo"].Rows[0]["shipper_name"].ToString();
            this.txtShipperInfo.Text = feData.Tables["BillInfo"].Rows[0]["shipper_info"].ToString();
            this.txt_booking_no.Text = feData.Tables["BillInfo"].Rows[0]["booking_num"].ToString();
            this.txt_export_reference.Text = feData.Tables["BillInfo"].Rows[0]["export_ref"].ToString();
            this.txt_place_of_receipt.Text = feData.Tables["BillInfo"].Rows[0]["pre_receipt_place"].ToString();
            this.txt_place_of_delivery.Text = feData.Tables["BillInfo"].Rows[0]["delivery_place"].ToString();
            this.txt_type_of_move.Text = feData.Tables["BillInfo"].Rows[0]["move_type"].ToString();
            this.txt_quantity.Text = feData.Tables["BillInfo"].Rows[0]["pieces"].ToString();
            this.ddl_quantity_unit.SelectedValue = feData.Tables["BillInfo"].Rows[0]["unit_qty"].ToString();
            this.txt_description.Text = feData.Tables["BillInfo"].Rows[0]["desc3"].ToString();
            this.txt_weight.Text = feData.Tables["BillInfo"].Rows[0]["gross_weight"].ToString();
            this.txt_dimension.Text = feData.Tables["BillInfo"].Rows[0]["measurement"].ToString();
            if (feData.Tables["BillInfo"].Rows[0]["scale"].ToString().Contains("K"))
            {
                this.ddl_weight_scale.SelectedValue = "KG";
                this.ddl_dimension_scale.SelectedValue = "CBM";
            }
            else
            {
                this.ddl_weight_scale.SelectedValue = "LB";
                this.ddl_dimension_scale.SelectedValue = "CFT";
            }
            this.ddl_weight_scale.SelectedValue = feData.Tables["BillInfo"].Rows[0]["gross_weight"].ToString();

            if (feData.Tables["BookingInfo"].Rows.Count > 0)
            {
                this.hCarrierAcct.Value = feData.Tables["BookingInfo"].Rows[0]["carrier_code"].ToString();
                this.lstCarrierName.Text = feData.Tables["BookingInfo"].Rows[0]["carrier_desc"].ToString();
                this.txt_carrier_no.Text = feData.Tables["BookingInfo"].Rows[0]["vsl_name"].ToString();
                this.ddl_dest_port.SelectedValue = feData.Tables["BookingInfo"].Rows[0]["dest_port_id"].ToString();
                this.ddl_origin_port.SelectedValue = feData.Tables["BookingInfo"].Rows[0]["origin_port_id"].ToString();
                this.txt_etd_date.Text = Convert.ToDateTime(feData.Tables["BookingInfo"].Rows[0]["departure_date"]).ToShortDateString();
                this.txt_eta_date.Text = Convert.ToDateTime(feData.Tables["BookingInfo"].Rows[0]["arrival_date"]).ToShortDateString();
                this.txt_cut_off_date.Text = Convert.ToDateTime(feData.Tables["BookingInfo"].Rows[0]["cutoff"]).ToShortDateString()
                    + " " + feData.Tables["BookingInfo"].Rows[0]["cutoff_time"].ToString();
            }

            this.hf_booking_no.Value = feData.Tables["BillInfo"].Rows[0]["booking_num"].ToString();
            this.hf_house_no.Value = feData.Tables["BillInfo"].Rows[0]["hbol_num"].ToString();
            this.hf_master_no.Value = feData.Tables["BillInfo"].Rows[0]["mbol_num"].ToString();
            this.hf_sub_house_no.Value = feData.Tables["BillInfo"].Rows[0]["sub_no"].ToString();

            this.hAgentAcct.Value = feData.Tables["BillInfo"].Rows[0]["agent_no"].ToString();
            this.lstAgentName.Text = feData.Tables["BillInfo"].Rows[0]["agent_name"].ToString();
            this.txtAgentInfo.Text = feData.Tables["BillInfo"].Rows[0]["agent_info"].ToString();
        }
        else
        {
            feData.AddToDataSet("BillInfo", "select * from mbol_master where elt_account_number=" + elt_account_number
                + " and booking_num=N'" + this.lstBillNum.Text + "'");
            feData.AddToDataSet("BookingInfo", "select * from ocean_booking_number where elt_account_number=" + elt_account_number
                + " and booking_num=N'" + this.lstBillNum.Text + "'");

            this.hCarrierAcct.Value = feData.Tables["BookingInfo"].Rows[0]["carrier_code"].ToString();
            this.lstCarrierName.Text = feData.Tables["BookingInfo"].Rows[0]["carrier_desc"].ToString();
            this.txt_carrier_no.Text = feData.Tables["BookingInfo"].Rows[0]["vsl_name"].ToString();
            this.ddl_dest_port.SelectedValue = feData.Tables["BookingInfo"].Rows[0]["dest_port_id"].ToString();
            this.ddl_origin_port.SelectedValue = feData.Tables["BookingInfo"].Rows[0]["origin_port_id"].ToString();
            this.txt_etd_date.Text = Convert.ToDateTime(feData.Tables["BookingInfo"].Rows[0]["departure_date"]).ToShortDateString();
            this.txt_eta_date.Text = Convert.ToDateTime(feData.Tables["BookingInfo"].Rows[0]["arrival_date"]).ToShortDateString();
            this.txt_cut_off_date.Text = Convert.ToDateTime(feData.Tables["BookingInfo"].Rows[0]["cutoff"]).ToShortDateString()
                + " " + feData.Tables["BookingInfo"].Rows[0]["cutoff_time"].ToString();
            this.hf_booking_no.Value = feData.Tables["BookingInfo"].Rows[0]["booking_num"].ToString();
            this.txt_booking_no.Text = feData.Tables["BookingInfo"].Rows[0]["booking_num"].ToString();
            this.hf_house_no.Value = "";
            this.hf_master_no.Value = feData.Tables["BookingInfo"].Rows[0]["mbol_num"].ToString();
            this.hf_sub_house_no.Value = "";

            if (feData.Tables["BillInfo"].Rows.Count > 0)
            {
                this.hShipperAcct.Value = feData.Tables["BillInfo"].Rows[0]["shipper_acct_num"].ToString();
                this.lstShipperName.Text = feData.Tables["BillInfo"].Rows[0]["shipper_name"].ToString();
                this.txtShipperInfo.Text = feData.Tables["BillInfo"].Rows[0]["shipper_info"].ToString();
                this.txt_export_reference.Text = feData.Tables["BillInfo"].Rows[0]["export_ref"].ToString();
                this.txt_place_of_receipt.Text = feData.Tables["BillInfo"].Rows[0]["pre_receipt_place"].ToString();
                this.txt_place_of_delivery.Text = feData.Tables["BillInfo"].Rows[0]["delivery_place"].ToString();
                this.txt_type_of_move.Text = feData.Tables["BillInfo"].Rows[0]["move_type"].ToString();
                this.txt_quantity.Text = feData.Tables["BillInfo"].Rows[0]["pieces"].ToString();
                this.ddl_quantity_unit.SelectedValue = feData.Tables["BillInfo"].Rows[0]["unit_qty"].ToString();
                this.txt_description.Text = feData.Tables["BillInfo"].Rows[0]["desc3"].ToString();
                this.txt_weight.Text = feData.Tables["BillInfo"].Rows[0]["gross_weight"].ToString();
                this.txt_dimension.Text = feData.Tables["BillInfo"].Rows[0]["measurement"].ToString();
                if (feData.Tables["BillInfo"].Rows[0]["scale"].ToString().Contains("K"))
                {
                    this.ddl_weight_scale.SelectedValue = "KG";
                    this.ddl_dimension_scale.SelectedValue = "CBM";
                }
                else
                {
                    this.ddl_weight_scale.SelectedValue = "LB";
                    this.ddl_dimension_scale.SelectedValue = "CFT";
                }
                this.ddl_weight_scale.SelectedValue = feData.Tables["BillInfo"].Rows[0]["gross_weight"].ToString();
            }
            else
            {
                this.hShipperAcct.Value = "";
                this.lstShipperName.Text = "";
                this.txtShipperInfo.Text = "";
                this.txt_export_reference.Text = "";
                this.txt_place_of_receipt.Text = "";
                this.txt_place_of_delivery.Text = "";
                this.txt_type_of_move.Text = "";
                this.txt_quantity.Text = "";
                this.ddl_quantity_unit.SelectedValue = "";
                this.txt_description.Text = "";
                this.txt_weight.Text = "";
                this.txt_dimension.Text = "";
                this.ddl_weight_scale.SelectedValue = "";
                this.ddl_dimension_scale.SelectedValue = "";
                this.ddl_weight_scale.SelectedValue = "";
            }
            this.hAgentAcct.Value = "";
            this.lstAgentName.Text = "";
            this.txtAgentInfo.Text = "";
        }
    }

    protected void Insert_Booking_Confirm()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();

        ArrayList tranStrAL = new ArrayList();
        string tranStr = "";

        tranStr = "SET ANSI_WARNINGS OFF";
        tranStrAL.Add(tranStr);

        tranStr = @"INSERT INTO booking_confirm(elt_account_number,document_date,air_ocean,bc_no,booking_no,master_no,house_no,sub_house_no,shipper_acct,
            shipper_name,shipper_info,deliver_to_acct,deliver_to_name,deliver_to_info,cut_off_date,export_reference,carrier_acct,carrier_name,carrier_no,
            place_of_receipt,place_of_delivery,dep_port,arr_port,eta,etd,move_type,dest_agent_acct,dest_agent_name,dest_agent_info,empty_container_pick_up_acct,
            empty_container_pick_up_name,empty_container_pick_up_info,dangerous,quantity,quantity_unit,item_desc,gross_weight,weight_scale,dimension,dimension_scale,remark)
            VALUES(" + elt_account_number + "," + MakeDateString(this.txt_document_date.Text) + ",'O',N'" + this.ddl_prefix.Items[this.ddl_prefix.SelectedIndex].Text
            + "-" + this.ddl_prefix.SelectedValue + "',N'" + this.txt_booking_no.Text + "',N'" + this.hf_master_no.Value + "',N'" + this.hf_house_no.Value
            + "',N'" + this.hf_sub_house_no.Value + "'," + MakeNullCase(this.hShipperAcct.Value) + ",N'" + this.lstShipperName.Text
            + "',N'" + this.txtShipperInfo.Text + "'," + MakeNullCase(this.hConsigneeAcct.Value) + ",N'" + this.lstConsigneeName.Text
            + "',N'" + this.txtConsigneeInfo.Text + "',N'" + this.txt_cut_off_date.Text + "',N'" + this.txt_export_reference.Text
            + "'," + MakeNullCase(this.hCarrierAcct.Value) + ",N'" + this.lstCarrierName.Text + "',N'" + this.txt_carrier_no.Text
            + "',N'" + this.txt_place_of_receipt.Text + "',N'" + this.txt_place_of_delivery.Text + "',N'" + this.ddl_origin_port.SelectedValue
            + "',N'" + this.ddl_dest_port.SelectedValue + "'," + MakeDateString(this.txt_eta_date.Text)
            + "," + MakeDateString(this.txt_etd_date.Text) + ",N'" + this.txt_type_of_move.Text
            + "'," + MakeNullCase(this.hAgentAcct.Value) + ",N'" + this.lstAgentName.Text + "',N'" + this.txtAgentInfo.Text
            + "'," + MakeNullCase(this.hEmptyPickupAcct.Value) + ",N'" + this.lstEmptyPickupName.Text + "',N'" + this.txtEmptyPickupInfo.Text
            + "',N'" + this.rbl_dangerous_good.SelectedValue + "'," + MakeNullCase(this.txt_quantity.Text) + ",N'" + this.ddl_quantity_unit.SelectedValue + "',N'" + this.txt_description.Text
            + "'," + MakeNullCase(this.txt_weight.Text) + ",N'" + this.ddl_weight_scale.SelectedValue + "'," + MakeNullCase(this.txt_dimension.Text)
            + ",N'" + this.ddl_dimension_scale.SelectedValue + "',N'" + this.txt_remark.Text + "')";
        tranStrAL.Add(tranStr);

        tranStr = "UPDATE user_prefix SET next_no=next_no+1 WHERE elt_account_number=" + elt_account_number
            + "AND type='BC' AND prefix=N'" + this.ddl_prefix.Items[this.ddl_prefix.SelectedIndex].Text + "'";
        tranStrAL.Add(tranStr);

        tranStr = "SET ANSI_WARNINGS ON";
        tranStrAL.Add(tranStr);

        if (!feData.DataTransactions((string[])tranStrAL.ToArray(typeof(string))))
        {
            Response.Write(feData.GetLastTransactionError());
        }
        else
        {
            feData.AddToDataSet("BookingConfirmNew", "SELECT * FROM booking_confirm WHERE auto_uid=IDENT_CURRENT('booking_confirm')");
            Load_Booking_Confirm(feData.Tables["BookingConfirmNew"].Rows[0]["auto_uid"].ToString());
        }
    }

    protected void Update_Booking_Confirm()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();

        ArrayList tranStrAL = new ArrayList();
        string tranStr = "";

        tranStr = "SET ANSI_WARNINGS OFF";
        tranStrAL.Add(tranStr);

        tranStr = @"UPDATE booking_confirm
            SET elt_account_number=" + elt_account_number + ","
            + "document_date=" + MakeDateString(this.txt_document_date.Text) + ","
            + "air_ocean='O',"
            + "booking_no=N'" + this.txt_booking_no.Text + "',"
            + "master_no=N'" + this.hf_master_no.Value + "',"
            + "house_no=N'" + this.hf_house_no.Value + "',"
            + "sub_house_no=N'" + this.hf_house_no.Value + "',"
            + "shipper_acct=" + MakeNullCase(this.hShipperAcct.Value) + ","
            + "shipper_name=N'" + this.lstShipperName.Text + "',"
            + "shipper_info=N'" + this.txtShipperInfo.Text + "',"
            + "deliver_to_acct=" + MakeNullCase(this.hConsigneeAcct.Value) + ","
            + "deliver_to_name=N'" + this.lstConsigneeName.Text + "',"
            + "deliver_to_info=N'" + this.txtConsigneeInfo.Text + "',"
            + "cut_off_date=N'" + this.txt_cut_off_date.Text + "',"
            + "export_reference=N'" + this.txt_export_reference.Text + "',"
            + "carrier_acct=" + MakeNullCase(this.hCarrierAcct.Value) + ","
            + "carrier_name=N'" + this.lstCarrierName.Text + "',"
            + "carrier_no=N'" + this.txt_carrier_no.Text + "',"
            + "place_of_receipt=N'" + this.txt_place_of_receipt.Text + "',"
            + "place_of_delivery=N'" + this.txt_place_of_delivery.Text + "',"
            + "dep_port=N'" + this.ddl_origin_port.SelectedValue + "',"
            + "arr_port=N'" + this.ddl_dest_port.SelectedValue + "',"
            + "eta=" + MakeDateString(this.txt_eta_date.Text) + ","
            + "etd=" + MakeDateString(this.txt_etd_date.Text) + ","
            + "move_type=N'" + this.txt_type_of_move.Text + "',"
            + "dest_agent_acct=" + MakeNullCase(this.hAgentAcct.Value) + ","
            + "dest_agent_name=N'" + this.lstAgentName.Text + "',"
            + "dest_agent_info=N'" + this.txtAgentInfo.Text + "',"
            + "empty_container_pick_up_acct=" + MakeNullCase(this.hEmptyPickupAcct.Value) + ","
            + "empty_container_pick_up_name=N'" + this.lstEmptyPickupName.Text + "',"
            + "empty_container_pick_up_info=N'" + this.txtEmptyPickupInfo.Text + "',"
            + "dangerous=N'" + this.rbl_dangerous_good.SelectedValue + "',"
            + "quantity=" + MakeNullCase(this.txt_quantity.Text) + ","
            + "quantity_unit=N'" + this.ddl_quantity_unit.SelectedValue + "',"
            + "item_desc=N'" + this.txt_description.Text + "',"
            + "gross_weight=" + MakeNullCase(this.txt_weight.Text) + ","
            + "weight_scale=N'" + this.ddl_weight_scale.SelectedValue + "',"
            + "dimension=" + MakeNullCase(this.txt_dimension.Text) + ","
            + "dimension_scale=N'" + this.ddl_dimension_scale.SelectedValue + "',"
            + "remark=N'" + this.txt_remark.Text + "' "
            + "WHERE auto_uid=" + hSearchNum.Value;

        tranStrAL.Add(tranStr);

        tranStr = "SET ANSI_WARNINGS ON";
        tranStrAL.Add(tranStr);

        if (!feData.DataTransactions((string[])tranStrAL.ToArray(typeof(string))))
        {
            Response.Write(feData.GetLastTransactionError());
        }
    }

    protected string MakeDateString(string input)
    {
        string output = "null";
        try
        {
            if (input.Trim() != "")
            {
                output = "'" + Convert.ToDateTime(input).ToShortDateString() + "'";
            }
        }
        catch { }
        return output;
    }

    protected string MakeNullCase(string input)
    {
        string output = "null";
        if (input.Trim() == "0" || input.Trim() == "")
        {
            output = "null";
        }
        else
        {
            output = input;
        }
        return output;
    }

    protected string GetAgentInfo()
    {
        string agent_info = "";
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("AgentInfo", "SELECT * FROM agent WHERE elt_account_number=" + elt_account_number);

        if (feData.Tables["AgentInfo"].Rows.Count > 0)
        {
            DataRow dr = feData.Tables["AgentInfo"].Rows[0];
            agent_info = dr["dba_name"] + "\n" + dr["business_address"] + "\n" + dr["business_city"] + "," +
                dr["business_state"] + " " + dr["business_zip"] + " " + dr["business_country"];
        }

        return agent_info;
    }
}
