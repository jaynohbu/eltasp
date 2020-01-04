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
using Infragistics.WebUI.UltraWebGrid;


public partial class ASPX_Misc_2EditAES : System.Web.UI.Page
{
    protected string user_id, login_name, user_right, elt_account_number, aes_id, move_type;
    protected DataSet ds;
    public bool isValid;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.LCID = 1033;
        
        if (!IsPostBack)
        {
            btnSaveAESBot.Attributes.Add("onclick", "return ValidateControls();");
            // New AES
            if (aes_id == "" || aes_id == "0")
            {
                LoadHeaderInfoAE();
            }
            // Saved AES
            else
            {
                LoadHeaderInfo();
            }
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        // Naviagtor assigned
        //WebNavBar1.GridID = UltraWebGrid1.UniqueID;

        // FreightEasyData Initialized
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("Ports", "SELECT port_code + ' - ' + port_desc as port_name,port_code FROM port WHERE elt_account_number=" + elt_account_number + " AND ISNULL(port_id,'')<>'' ORDER BY port_desc");
        feData.AddToDataSet("Countries", "SELECT * FROM country_code WHERE elt_account_number=" + elt_account_number + " order by country_name");
        feData.AddToDataSet("MOT", "SELECT code_id,code_desc FROM aes_codes WHERE code_type='Transport Code' ORDER BY code_id");
        feData.AddToDataSet("Carriers", "SELECT ISNULL(carrier_id,'') AS carrier_code,LEFT(dba_name,22) AS carrier_name FROM organization WHERE is_carrier='Y' AND ISNULL(carrier_id,'') <> '' AND ISNULL(carrier_code,'')<>'' AND elt_account_number=" + elt_account_number + " ORDER BY dba_name");

        // Form initialize
        POE.DataSource = feData.Tables["Ports"];
        POE.DataTextField = "port_name";
        POE.DataValueField = "port_code";
        POE.DataBind();
        POE.Items.Insert(0, new ListItem("", ""));

        POU.DataSource = feData.Tables["Ports"];
        POU.DataTextField = "port_name";
        POU.DataValueField = "port_code";
        POU.DataBind();
        POU.Items.Insert(0, new ListItem("", ""));

        COD.DataSource = feData.Tables["Countries"];
        COD.DataTextField = "country_name";
        COD.DataValueField = "country_code";
        COD.DataBind();
        COD.Items.Insert(0, new ListItem("", ""));

        MOT.DataSource = feData.Tables["MOT"];
        MOT.DataTextField = "code_desc";
        MOT.DataValueField = "code_id";
        MOT.DataBind();
        MOT.Items.Insert(0, new ListItem("", ""));

        lstCarrier.DataSource = feData.Tables["Carriers"];
        lstCarrier.DataTextField = "carrier_name";
        lstCarrier.DataValueField = "carrier_code";
        lstCarrier.DataBind();
        lstCarrier.Items.Insert(0, new ListItem("", ""));

        hFileType.Value = move_type;

        // New AES
        if (aes_id == "" || aes_id == "0")
        {
            labelPageTitle.Text = "New AES Form";
            trInfo1.Visible = false;
            trInfo2.Visible = false;
        }
        // Saved AES
        else
        {
            labelPageTitle.Text = "Edit AES Form";
        }
    }

    protected void SqlDataSource1_Init(object sender, EventArgs e)
    {

        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
        
        LoadParameters();
        CheckExistingAES();

        SqlDataSource obj = (SqlDataSource)sender;
        obj.ConnectionString = (new igFunctions.DB().getConStr());

        // New AES
        if (aes_id == "" || aes_id == "0")
        {
            obj.SelectCommand = "SELECT newid() as id , dfm,b_number,b_number as b_number_copy,b_qty1,unit1,b_qty2,unit2,"
                + "gross_weight,item_value,export_code,license_type,license_number,eccn,vin_type,vin,vc_title,vc_state FROM aes_detail "
                + "WHERE elt_account_number=" + elt_account_number + " AND aes_id=" + aes_id + " ORDER BY item_no";
            
            if (txtHouse.Text != "" && txtMaster.Text != "")
            {
                obj.SelectCommand = "SELECT newid() as id , 'D' AS dfm,commodity_item_no AS b_number,commodity_item_no AS b_number_copy,"
                    + "No_pieces AS b_qty1,'' AS unit1,0 AS b_qty2,'' AS unit2,"
                    + "(CASE WHEN (Kg_Lb='L' OR Kg_Lb='LB') THEN CAST(gross_weight/2.20462262 AS INT)  ELSE gross_weight END) AS gross_weight"
                    + ",0 AS item_value,'' AS export_code,'' AS license_type,'' AS license_number,'' AS eccn,'' AS vin_type,'' AS vin,'' AS vc_title,'' AS vc_state "
                    + "FROM hawb_weight_charge WHERE elt_account_number=" + elt_account_number + " AND hawb_num='" + txtHouse.Text + "'";
            }
            else if (txtHouse.Text == "" && txtMaster.Text != "")
            {
                obj.SelectCommand = "SELECT newid() as id ,  'D' AS dfm,commodity_item_no AS b_number,commodity_item_no AS b_number_copy,"
                    + "No_pieces AS b_qty1,'' AS unit1,0 AS b_qty2,'' AS unit2,"
                    + "(CASE WHEN (Kg_Lb='L' OR Kg_Lb='LB') THEN CAST(gross_weight/2.20462262 AS INT)  ELSE gross_weight END) AS gross_weight"
                    + ",0 AS item_value,'' AS export_code,'' AS license_type,'' AS license_number,'' AS eccn,'' AS vin_type,'' AS vin,'' AS vc_title,'' AS vc_state "
                    + "FROM mawb_weight_charge WHERE elt_account_number=" + elt_account_number + " AND mawb_num='" + txtMaster.Text + "'";
            }
        }
        // Saved AES
        else
        {
            obj.SelectCommand = "SELECT newid() as id ,  dfm,b_number,b_number as b_number_copy,b_qty1,unit1,b_qty2,unit2,"
                + "gross_weight,item_value,export_code,license_type,license_number,eccn,vin_type,vin,vc_title,vc_state FROM aes_detail "
                + "WHERE elt_account_number=" + elt_account_number + " AND aes_id=" + aes_id + " ORDER BY item_no";
        }
    }

    protected void CheckExistingAES()
    {
        if (aes_id == "" || aes_id == "0")
        {
            string aesFindSQL = @"SELECT * FROM aes_master WHERE elt_account_number=" + elt_account_number
                + " AND file_type='AE' AND house_num=N'" + txtHouse.Text + "' AND master_num=N'" + txtMaster.Text + "'";
            FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
            feData.AddToDataSet("AESEntity", aesFindSQL);
            if (feData.Tables["AESEntity"].Rows.Count > 0)
            {
                DataRow drTmp = feData.Tables["AESEntity"].Rows[0];
                aes_id = drTmp["auto_uid"].ToString();
            }
        }
    }

    protected void LoadHeaderInfo()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("AESInfo", "SELECT * FROM aes_master WHERE elt_account_number=" + elt_account_number + " AND auto_uid=" + aes_id);

        if (feData.Tables["AESInfo"].Rows.Count > 0)
        {
            DataRow drTmp = feData.Tables["AESInfo"].Rows[0];

            AESNO.Value = drTmp["auto_uid"].ToString();
            SRN.Text = drTmp["shipment_ref_no"].ToString();
            BN.Text = drTmp["tran_ref_no"].ToString();
            ST.SelectedValue = drTmp["origin_state"].ToString();
            POE.SelectedValue = drTmp["export_port"].ToString();
            COD.SelectedValue = drTmp["dest_country"].ToString();
            POU.SelectedValue = drTmp["unloading_port"].ToString();
            EDA.Value = DateTime.Parse(drTmp["export_date"].ToString());
            MOT.SelectedValue = drTmp["tran_method"].ToString();
            lstCarrier.SelectedValue = drTmp["carrier_id_code"].ToString();
            RCC.SelectedValue = drTmp["party_to_transaction"].ToString();
            HAZ.SelectedValue = drTmp["hazardous_materials"].ToString();
            RT.SelectedValue = drTmp["route_export_tran"].ToString();
            ITN.Text = drTmp["aes_itn"].ToString();
            STATUS.Text = drTmp["aes_status"].ToString();

            if (drTmp["in_bond_type"].ToString() != "")
            {
                IBT.SelectedValue = drTmp["in_bond_type"].ToString();
                IBN.Text = drTmp["in_bond_no"].ToString();
                FTZ.Text = drTmp["ftz"].ToString();
                trInbond.Visible = true;
            }

            LastUpdated.Text = drTmp["last_modified"].ToString();
            SubmittedDate.Text = drTmp["tran_date"].ToString();
            hFileType.Value = drTmp["file_type"].ToString();
            txtHouse.Text = drTmp["house_num"].ToString();
            txtMaster.Text = drTmp["master_num"].ToString();

            string orgFindSQL = @"SELECT a.*,(CASE WHEN ISNULL(a.b_country_code,'')<>'' 
                THEN a.b_country_code ELSE b.country_code END) AS country_code_find FROM organization a 
                LEFT OUTER JOIN country_code b ON (a.elt_account_number=b.elt_account_number AND 
                a.b_country_code=b.country_code) WHERE a.elt_account_number=" + elt_account_number;

            hConsigneeAcct.Value = drTmp["consignee_acct"].ToString();
            if (drTmp["consignee_acct"].ToString() != "")
            {
                feData.AddToDataSet("ConsigneeInfo", orgFindSQL + " AND a.org_account_number=" + drTmp["consignee_acct"].ToString());
                if (feData.Tables["ConsigneeInfo"].Rows.Count > 0)
                {
                    DataRow drConsigneeTmp = feData.Tables["ConsigneeInfo"].Rows[0];
                    lstConsigneeName.Text = AD1_3.Value = drConsigneeTmp["dba_name"].ToString();
                    AD1_3.Value = drConsigneeTmp["dba_name"].ToString();
                    AD1_8.Text = drConsigneeTmp["business_address"].ToString();
                    AD1_9.Text = drConsigneeTmp["business_address2"].ToString();
                    AD1_10.Text = drConsigneeTmp["business_city"].ToString();
                    AD1_11.Text = drConsigneeTmp["business_state"].ToString();
                    AD1_12.Text = drConsigneeTmp["b_country_code"].ToString();
                    AD1_13.Text = drConsigneeTmp["business_zip"].ToString();
                }
            }

            hInterConsigneeAcct.Value = drTmp["inter_consignee_acct"].ToString();
            if (drTmp["inter_consignee_acct"].ToString() != "")
            {
                feData.AddToDataSet("InterConsigneeInfo", orgFindSQL + " AND org_account_number=" + drTmp["inter_consignee_acct"].ToString());
                if (feData.Tables["InterConsigneeInfo"].Rows.Count > 0)
                {
                    DataRow drInterConsigneeTmp = feData.Tables["InterConsigneeInfo"].Rows[0];
                    lstInterConsigneeName.Text = AD1_3.Value = drInterConsigneeTmp["dba_name"].ToString();
                    AD4_3.Value = drInterConsigneeTmp["dba_name"].ToString();
                    AD4_8.Text = drInterConsigneeTmp["business_address"].ToString();
                    AD4_9.Text = drInterConsigneeTmp["business_address2"].ToString();
                    AD4_10.Text = drInterConsigneeTmp["business_city"].ToString();
                    AD4_11.Text = drInterConsigneeTmp["business_state"].ToString();
                    AD4_12.Text = drInterConsigneeTmp["b_country_code"].ToString();
                    AD4_13.Text = drInterConsigneeTmp["business_zip"].ToString();
                }
            }

            hShipperAcct.Value = drTmp["shipper_acct"].ToString();
            if (drTmp["shipper_acct"].ToString() != "" && drTmp["shipper_acct"].ToString() != "0")
            {
                feData.AddToDataSet("ShipperInfo", orgFindSQL + " AND org_account_number=" + drTmp["shipper_acct"].ToString());
                if (feData.Tables["ShipperInfo"].Rows.Count > 0)
                {
                    DataRow drShipperTmp = feData.Tables["ShipperInfo"].Rows[0];
                    lstShipperName.Text = drShipperTmp["dba_name"].ToString();
                    AD0_2.Text = drShipperTmp["business_fed_taxid"].ToString();
                    AD0_4.Text = drShipperTmp["business_address"].ToString();
                    AD0_5.Text = drShipperTmp["business_address2"].ToString();
                    AD0_6.Text = drShipperTmp["business_city"].ToString();
                    AD0_7.Text = drShipperTmp["business_state"].ToString();
                    AD0_8.Text = drShipperTmp["business_zip"].ToString();
                    AD0_9.Text = drShipperTmp["owner_fname"].ToString();
                    AD0_10.Text = drShipperTmp["owner_mname"].ToString();
                    AD0_11.Text = drShipperTmp["owner_lname"].ToString();
                    AD0_12.Text = drShipperTmp["business_phone"].ToString();
                }
                else if (drTmp["shipper_acct"].ToString() == elt_account_number.ToString())
                {
                    feData.AddToDataSet("MasterShipperInfo", "SELECT * FROM agent WHERE elt_account_number=" + elt_account_number);
                    if (feData.Tables["MasterShipperInfo"].Rows.Count > 0)
                    {
                        DataRow drMasterShipperTmp = feData.Tables["MasterShipperInfo"].Rows[0];
                        lstShipperName.Text = drMasterShipperTmp["dba_name"].ToString();
                        AD0_2.Text = drMasterShipperTmp["business_fed_taxid"].ToString();
                        AD0_4.Text = drMasterShipperTmp["business_address"].ToString();
                        AD0_5.Text = "";
                        AD0_6.Text = drMasterShipperTmp["business_city"].ToString();
                        AD0_7.Text = drMasterShipperTmp["business_state"].ToString();
                        AD0_8.Text = drMasterShipperTmp["business_zip"].ToString();
                        AD0_9.Text = drMasterShipperTmp["owner_fname"].ToString();
                        AD0_10.Text = drMasterShipperTmp["owner_mname"].ToString();
                        AD0_11.Text = drMasterShipperTmp["owner_lname"].ToString();
                        AD0_12.Text = drMasterShipperTmp["business_phone"].ToString();
                    }
                }
            }

            feData.AddToDataSet("AgentInfo", "SELECT * FROM agent WHERE elt_account_number=" + elt_account_number);
            if (feData.Tables["AgentInfo"].Rows.Count > 0)
            {
                DataRow drAgentTmp = feData.Tables["AgentInfo"].Rows[0];
                AD3_2.Value = "E";
                AD3_3.Text = drAgentTmp["dba_name"].ToString();
                AD3_4.Text = drAgentTmp["business_fed_taxid"].ToString();
                AD3_5.Text = drAgentTmp["owner_fname"].ToString() + " " + drAgentTmp["owner_lname"].ToString();
                AD3_7.Text = drAgentTmp["business_phone"].ToString();
                AD3_8.Text = drAgentTmp["business_address"].ToString();
                AD3_9.Text = "";
                AD3_10.Text = drAgentTmp["business_city"].ToString();
                AD3_11.Text = drAgentTmp["business_state"].ToString();
                AD3_12.Text = drAgentTmp["business_country"].ToString();
                AD3_13.Text = drAgentTmp["business_zip"].ToString();
            }
        }
    }

    protected void LoadHeaderInfoAE()
    {
        string strSQL = "";
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();

        strSQL = "SELECT a.*,b.* FROM hawb_master a LEFT OUTER JOIN mawb_number b ON "
            + "(a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_no) "
            + "WHERE a.elt_account_number=" + elt_account_number + " AND a.hawb_num=N'" + txtHouse.Text 
            + "' AND a.mawb_num=N'" + txtMaster.Text + "'";

        feData.AddToDataSet("AESInfo", strSQL);
        DataRow drTmp = null;

        string orgFindSQL = @"SELECT a.*,(CASE WHEN ISNULL(a.b_country_code,'')<>'' 
                THEN a.b_country_code ELSE b.country_code END) AS country_code_find FROM organization a 
                LEFT OUTER JOIN country_code b ON (a.elt_account_number=b.elt_account_number AND 
                a.b_country_code=b.country_code) WHERE a.elt_account_number=" + elt_account_number;

        // Populate Data for House Bills
        if (feData.Tables["AESInfo"].Rows.Count > 0)
        {
            drTmp = feData.Tables["AESInfo"].Rows[0];

            AESNO.Value = "";
            SRN.Text = drTmp["HAWB_NUM"].ToString();
            BN.Text = drTmp["MAWB_NUM"].ToString().Replace(" ", "");
            ST.SelectedValue = drTmp["departure_state"].ToString();
            POE.SelectedValue = drTmp["origin_port_id"].ToString();
            COD.SelectedValue = drTmp["dest_country_code"].ToString();
            POU.SelectedValue = drTmp["dest_port_id"].ToString();
            EDA.Value = DateTime.Parse(drTmp["ETD_DATE1"].ToString());
            MOT.SelectedValue = "40";
            try
            {
                lstCarrier.SelectedValue = lstCarrier.Items.FindByText(drTmp["carrier_desc"].ToString()).Value;
            }
            catch { }

            hConsigneeAcct.Value = drTmp["consignee_acct_num"].ToString();
            if (drTmp["consignee_acct_num"].ToString() != "")
            {
                feData.AddToDataSet("ConsigneeInfo", orgFindSQL + " AND org_account_number=" + drTmp["consignee_acct_num"].ToString());
                if (feData.Tables["ConsigneeInfo"].Rows.Count > 0)
                {
                    DataRow drConsigneeTmp = feData.Tables["ConsigneeInfo"].Rows[0];
                    lstConsigneeName.Text = AD1_3.Value = drConsigneeTmp["dba_name"].ToString();
                    AD1_3.Value = drConsigneeTmp["dba_name"].ToString();
                    AD1_8.Text = drConsigneeTmp["business_address"].ToString();
                    AD1_9.Text = drConsigneeTmp["business_address2"].ToString();
                    AD1_10.Text = drConsigneeTmp["business_city"].ToString();
                    AD1_11.Text = drConsigneeTmp["business_state"].ToString();
                    AD1_12.Text = drConsigneeTmp["b_country_code"].ToString();
                    AD1_13.Text = drConsigneeTmp["business_zip"].ToString();
                }
            }

            hShipperAcct.Value = drTmp["shipper_account_number"].ToString();
            if (drTmp["shipper_account_number"].ToString() != "")
            {
                feData.AddToDataSet("ShipperInfo", "SELECT * FROM organization WHERE elt_account_number=" + elt_account_number + " AND org_account_number=" + drTmp["shipper_account_number"].ToString());
                if (feData.Tables["ShipperInfo"].Rows.Count > 0)
                {
                    DataRow drShipperTmp = feData.Tables["ShipperInfo"].Rows[0];
                    lstShipperName.Text = drShipperTmp["dba_name"].ToString();
                    AD0_2.Text = drShipperTmp["business_fed_taxid"].ToString();
                    AD0_4.Text = drShipperTmp["business_address"].ToString();
                    AD0_5.Text = drShipperTmp["business_address2"].ToString();
                    AD0_6.Text = drShipperTmp["business_city"].ToString();
                    AD0_7.Text = drShipperTmp["business_state"].ToString();
                    AD0_8.Text = drShipperTmp["business_zip"].ToString();
                    AD0_9.Text = drShipperTmp["owner_fname"].ToString();
                    AD0_10.Text = drShipperTmp["owner_mname"].ToString();
                    AD0_11.Text = drShipperTmp["owner_lname"].ToString();
                    AD0_12.Text = drShipperTmp["business_phone"].ToString();
                }
            }
        }
        // Populate Data for direct shipements
        else if (txtHouse.Text == "")
        {
            feData.AddToDataSet("AESInfoMaster", "SELECT * FROM mawb_master a LEFT OUTER JOIN mawb_number b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_no) WHERE a.elt_account_number=" + elt_account_number + " AND a.mawb_num=N'" + txtMaster.Text + "'");
            if (feData.Tables["AESInfoMaster"].Rows.Count > 0)
            {
                drTmp = feData.Tables["AESInfoMaster"].Rows[0];

                AESNO.Value = "";
                SRN.Text = drTmp["MAWB_NUM"].ToString().Replace(" ", "");
                BN.Text = drTmp["MAWB_NUM"].ToString().Replace(" ", "");
                ST.SelectedValue = drTmp["origin_port_state"].ToString();
                POE.SelectedValue = drTmp["origin_port_id"].ToString();
                COD.SelectedValue = drTmp["dest_country_code"].ToString();
                POU.SelectedValue = drTmp["dest_port_id"].ToString();
                EDA.Value = DateTime.Parse(drTmp["ETD_DATE1"].ToString());
                MOT.SelectedValue = "40";
                try
                {
                    lstCarrier.SelectedValue = lstCarrier.Items.FindByText(drTmp["carrier_desc"].ToString()).Value;
                }
                catch { }

                hShipperAcct.Value = drTmp["shipper_account_number"].ToString();
                if (drTmp["shipper_account_number"].ToString() != "")
                {
                    feData.AddToDataSet("ShipperInfo", orgFindSQL + " AND org_account_number=" + drTmp["shipper_account_number"].ToString());
                    if (feData.Tables["ShipperInfo"].Rows.Count > 0)
                    {
                        DataRow drShipperTmp = feData.Tables["ShipperInfo"].Rows[0];
                        lstShipperName.Text = drShipperTmp["dba_name"].ToString();
                        AD0_2.Text = drShipperTmp["business_fed_taxid"].ToString();
                        AD0_4.Text = drShipperTmp["business_address"].ToString();
                        AD0_5.Text = drShipperTmp["business_address2"].ToString();
                        AD0_6.Text = drShipperTmp["business_city"].ToString();
                        AD0_7.Text = drShipperTmp["business_state"].ToString();
                        AD0_8.Text = drShipperTmp["business_zip"].ToString();
                        AD0_9.Text = drShipperTmp["owner_fname"].ToString();
                        AD0_10.Text = drShipperTmp["owner_mname"].ToString();
                        AD0_11.Text = drShipperTmp["owner_lname"].ToString();
                        AD0_12.Text = drShipperTmp["business_phone"].ToString();
                    }
                    else
                    {
                        feData.AddToDataSet("MasterShipperInfo", "SELECT * FROM agent WHERE elt_account_number=" + elt_account_number);
                        if (feData.Tables["MasterShipperInfo"].Rows.Count > 0)
                        {
                            DataRow drMasterShipperTmp = feData.Tables["MasterShipperInfo"].Rows[0];
                            lstShipperName.Text = drMasterShipperTmp["dba_name"].ToString();
                            AD0_2.Text = drMasterShipperTmp["business_fed_taxid"].ToString();
                            AD0_4.Text = drMasterShipperTmp["business_address"].ToString();
                            AD0_5.Text = "";
                            AD0_6.Text = drMasterShipperTmp["business_city"].ToString();
                            AD0_7.Text = drMasterShipperTmp["business_state"].ToString();
                            AD0_8.Text = drMasterShipperTmp["business_zip"].ToString();
                            AD0_9.Text = drMasterShipperTmp["owner_fname"].ToString();
                            AD0_10.Text = drMasterShipperTmp["owner_mname"].ToString();
                            AD0_11.Text = drMasterShipperTmp["owner_lname"].ToString();
                            AD0_12.Text = drMasterShipperTmp["business_phone"].ToString();
                        }
                    }
                }

                hConsigneeAcct.Value = drTmp["consignee_acct_num"].ToString();
                if (drTmp["consignee_acct_num"].ToString() != "")
                {
                    feData.AddToDataSet("ConsigneeInfo", orgFindSQL + " AND org_account_number=" + drTmp["consignee_acct_num"].ToString());
                    if (feData.Tables["ConsigneeInfo"].Rows.Count > 0)
                    {
                        DataRow drConsigneeTmp = feData.Tables["ConsigneeInfo"].Rows[0];
                        lstConsigneeName.Text = AD1_3.Value = drConsigneeTmp["dba_name"].ToString();
                        AD1_3.Value = drConsigneeTmp["dba_name"].ToString();
                        AD1_8.Text = drConsigneeTmp["business_address"].ToString();
                        AD1_9.Text = drConsigneeTmp["business_address2"].ToString();
                        AD1_10.Text = drConsigneeTmp["business_city"].ToString();
                        AD1_11.Text = drConsigneeTmp["business_state"].ToString();
                        AD1_12.Text = drConsigneeTmp["b_country_code"].ToString();
                        AD1_13.Text = drConsigneeTmp["business_zip"].ToString();
                    }
                }
            }
        }
        feData.AddToDataSet("AgentInfo", "SELECT * FROM agent WHERE elt_account_number=" + elt_account_number);
        if (feData.Tables["AgentInfo"].Rows.Count > 0)
        {
            DataRow drAgentTmp = feData.Tables["AgentInfo"].Rows[0];
            AD3_2.Value = "E";
            AD3_3.Text = drAgentTmp["dba_name"].ToString();
            AD3_4.Text = drAgentTmp["business_fed_taxid"].ToString();
            AD3_5.Text = drAgentTmp["owner_fname"].ToString() + " " + drAgentTmp["owner_lname"].ToString();
            AD3_7.Text = drAgentTmp["business_phone"].ToString();
            AD3_8.Text = drAgentTmp["business_address"].ToString();
            AD3_9.Text = "";
            AD3_10.Text = drAgentTmp["business_city"].ToString();
            AD3_11.Text = drAgentTmp["business_state"].ToString();
            AD3_12.Text = drAgentTmp["business_country"].ToString();
            AD3_13.Text = drAgentTmp["business_zip"].ToString();
        }
    }

    protected void LoadParameters()
    {
        aes_id = Request.Params["AESID"];
        if (aes_id == "" || aes_id == null) { aes_id = "0"; }
        move_type = "AE";

        txtHouse.Text = Request.Params["HAWB"];
        txtMaster.Text = Request.Params["MAWB"];
    }

    protected void UltraWebGrid1_InitializeLayout(object sender, Infragistics.WebUI.UltraWebGrid.LayoutEventArgs e)
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();

        feData.AddToDataSet("ScheduleB", "SELECT * FROM scheduleB WHERE elt_account_number=" + elt_account_number + " ORDER BY description");
        feData.AddToDataSet("ExportCode", "SELECT code_id,LEFT(code_id+'-'+CAST(code_desc AS NVARCHAR),32) AS code_desc FROM aes_codes WHERE code_type='Export Code' ORDER BY code_id");
        feData.AddToDataSet("LicenseCode", "SELECT code_id,LEFT(code_id+'-'+CAST(code_desc AS NVARCHAR),32) AS code_desc FROM aes_codes WHERE code_type='License Code' ORDER BY code_id");
        feData.AddToDataSet("UOMCode", "SELECT code_id,LEFT(CAST(code_desc AS NVARCHAR),32) AS code_desc FROM aes_codes WHERE code_type='UOM' ORDER BY code_desc");

        ColumnsCollection cols = e.Layout.Bands[0].Columns;

        cols.FromKey("dfm").Header.Caption = "Origin";
        cols.FromKey("b_number").Header.Caption = "Item";
        cols.FromKey("b_number_copy").Header.Caption = "Schedule B";
        cols.FromKey("b_qty1").Header.Caption = "Qty 1";
        cols.FromKey("unit1").Header.Caption = "Unit 1";
        cols.FromKey("b_qty2").Header.Caption = "Qty 2";
        cols.FromKey("unit2").Header.Caption = "Unit 2";
        cols.FromKey("gross_weight").Header.Caption = "Gross Weight<br/>(KG)";
        cols.FromKey("vin_type").Header.Caption = "Vehicle ID<br/>Type";
        cols.FromKey("vin").Header.Caption = "Vehicle ID";
        cols.FromKey("vc_title").Header.Caption = "Vehicle Title";
        cols.FromKey("vc_state").Header.Caption = "Vehicle <br/>Title State";
        cols.FromKey("item_value").Header.Caption = "Item Value<br/>(USD)";
        cols.FromKey("export_code").Header.Caption = "<a href='http://www.aesdirect.gov/support/tables/eic.txt' target='_blank'>Export<br/>Code</a>";
        cols.FromKey("license_type").Header.Caption = "<a href='http://www.aesdirect.gov/support/tables/lic.txt' target='_blank'>License<br/>Type</a>";
        cols.FromKey("license_number").Header.Caption = "License<br/>Number";
        cols.FromKey("eccn").Header.Caption = "ECCN<img src='/ASP/images/button_info.gif' alt='' border='0' id='imgInfoECCN' />";

        cols.FromKey("dfm").Type = ColumnType.DropDownList;
        cols.FromKey("dfm").ValueList.ValueListItems.Add(new ValueListItem("", ""));
        cols.FromKey("dfm").ValueList.ValueListItems.Add(new ValueListItem("Domestic", "D"));
        cols.FromKey("dfm").ValueList.ValueListItems.Add(new ValueListItem("Foreign", "F"));
        cols.FromKey("dfm").ValueList.ValueListItems.Add(new ValueListItem("FMS", "M"));
        cols.FromKey("dfm").ValueList.Style.CssClass = "bodycopy";

        cols.FromKey("b_number").Type = ColumnType.DropDownList;
        cols.FromKey("b_number").ValueList.DataSource = feData.Tables["ScheduleB"];
        cols.FromKey("b_number").ValueList.DisplayMember = feData.Tables["ScheduleB"].Columns["description"].ToString();
        cols.FromKey("b_number").ValueList.ValueMember = feData.Tables["ScheduleB"].Columns["sb"].ToString();
        cols.FromKey("b_number").ValueList.DataBind();
        cols.FromKey("b_number").ValueList.ValueListItems.Insert(0, new ValueListItem("", ""));
        cols.FromKey("b_number").ValueList.Style.CssClass = "bodycopy";

        cols.FromKey("unit1").Type = ColumnType.DropDownList;
        cols.FromKey("unit1").ValueList.DataSource = feData.Tables["UOMCode"];
        cols.FromKey("unit1").ValueList.DisplayMember = feData.Tables["UOMCode"].Columns["code_desc"].ToString();
        cols.FromKey("unit1").ValueList.ValueMember = feData.Tables["UOMCode"].Columns["code_id"].ToString();
        cols.FromKey("unit1").ValueList.DataBind();
        cols.FromKey("unit1").ValueList.ValueListItems.Insert(0, new ValueListItem("", ""));
        cols.FromKey("unit1").ValueList.Style.CssClass = "bodycopy";

        cols.FromKey("unit2").Type = ColumnType.DropDownList;
        cols.FromKey("unit2").ValueList.DataSource = feData.Tables["UOMCode"];
        cols.FromKey("unit2").ValueList.DisplayMember = feData.Tables["UOMCode"].Columns["code_desc"].ToString();
        cols.FromKey("unit2").ValueList.ValueMember = feData.Tables["UOMCode"].Columns["code_id"].ToString();
        cols.FromKey("unit2").ValueList.DataBind();
        cols.FromKey("unit2").ValueList.ValueListItems.Insert(0, new ValueListItem("", ""));
        cols.FromKey("unit2").ValueList.Style.CssClass = "bodycopy";

        cols.FromKey("vin_type").Type = ColumnType.DropDownList;
        cols.FromKey("vin_type").ValueList.ValueListItems.Add(new ValueListItem("", ""));
        cols.FromKey("vin_type").ValueList.ValueListItems.Add(new ValueListItem("VIN", "V"));
        cols.FromKey("vin_type").ValueList.ValueListItems.Add(new ValueListItem("Product ID", "P"));
        cols.FromKey("vin_type").ValueList.Style.CssClass = "bodycopy";

        cols.FromKey("export_code").Type = ColumnType.DropDownList;
        cols.FromKey("export_code").ValueList.DataSource = feData.Tables["ExportCode"];
        cols.FromKey("export_code").ValueList.DisplayMember = feData.Tables["ExportCode"].Columns["code_id"].ToString();
        cols.FromKey("export_code").ValueList.ValueMember = feData.Tables["ExportCode"].Columns["code_id"].ToString();
        cols.FromKey("export_code").ValueList.DataBind();
        cols.FromKey("export_code").ValueList.ValueListItems.Insert(0, new ValueListItem("", ""));
        cols.FromKey("export_code").ValueList.Style.CssClass = "bodycopy";

        cols.FromKey("license_type").Type = ColumnType.DropDownList;
        cols.FromKey("license_type").ValueList.DataSource = feData.Tables["LicenseCode"];
        cols.FromKey("license_type").ValueList.DisplayMember = feData.Tables["LicenseCode"].Columns["code_id"].ToString();
        cols.FromKey("license_type").ValueList.ValueMember = feData.Tables["LicenseCode"].Columns["code_id"].ToString();
        cols.FromKey("license_type").ValueList.DataBind();
        cols.FromKey("license_type").ValueList.ValueListItems.Insert(0, new ValueListItem("", ""));
        cols.FromKey("license_type").ValueList.Style.CssClass = "bodycopy";

        cols.FromKey("dfm").Width = Unit.Pixel(60);
        cols.FromKey("b_number").Width = Unit.Pixel(200);
        cols.FromKey("unit1").Width = Unit.Pixel(150);
        cols.FromKey("unit2").Width = Unit.Pixel(150);
        cols.FromKey("vin_type").Width = Unit.Pixel(60);
        cols.FromKey("export_code").Width = Unit.Pixel(45);
        cols.FromKey("license_type").Width = Unit.Pixel(45);
        cols.FromKey("eccn").Width = Unit.Pixel(70);
        cols.FromKey("b_qty1").Width = Unit.Pixel(40);
        cols.FromKey("b_qty2").Width = Unit.Pixel(40);
        cols.FromKey("license_number").Width = Unit.Pixel(80);
        cols.FromKey("gross_weight").Width = Unit.Pixel(80);
        cols.FromKey("item_value").Width = Unit.Pixel(80);
        cols.FromKey("b_number_copy").Width = Unit.Pixel(80);
        cols.FromKey("vin_type").Width = Unit.Pixel(65);
        cols.FromKey("vin").Width = Unit.Pixel(80);
        cols.FromKey("vc_title").Width = Unit.Pixel(70);
        cols.FromKey("vc_state").Width = Unit.Pixel(60);
    }

    protected void btnSaveAES_Click(object sender, EventArgs e)
    {
        
        string script = "";
        isValid = true;
        for (int i = 0; i < UltraWebGrid1.Rows.Count; i++)
        {
            if (UltraWebGrid1.Rows[i].Cells.FromKey("dfm").Value == null)
            {
                script = "alert('Please, select origin from line item(s)');";
                isValid = false;
                break;
            }
            else if (UltraWebGrid1.Rows[i].Cells.FromKey("b_number").Value == null || UltraWebGrid1.Rows[i].Cells.FromKey("b_number").Value.ToString() == "")
            {
                script = "alert('Please, select item name from line item(s)');";
                isValid = false;
                break;
            }
            //else if (UltraWebGrid1.Rows[i].Cells.FromKey("b_qty1").Value == null)
           // {
            //    script = "alert('Please, enter item quantity from line item(s)');";
            //    isValid = false;
            //    break;
            //}
            else if (UltraWebGrid1.Rows[i].Cells.FromKey("unit1").Value == null)
            {
                script = "alert('Please, select item unit from line item(s)');";
                isValid = false;
                break;
            }
            //else if (UltraWebGrid1.Rows[i].Cells.FromKey("gross_weight").Value == null)
           // {//7
           //     script = "alert('Please, enter gross weight from line item(s)');";
           //     isValid = false;
           //     break;
           // }
           // else if (UltraWebGrid1.Rows[i].Cells.FromKey("item_value").Value == null)
           // {//8
           //     script = "alert('Please, enter item value from line item(s)');";
          //      isValid = false;
          //      break;
          //  }
            else if (UltraWebGrid1.Rows[i].Cells.FromKey("export_code").Value == null || UltraWebGrid1.Rows[i].Cells.FromKey("export_code").Value.ToString() == "")
            {
                //9
                script = "alert('Please, select export code from line item(s)');";
                isValid = false;
                break;
            }
            else if (UltraWebGrid1.Rows[i].Cells.FromKey("license_type").Value == null || UltraWebGrid1.Rows[i].Cells.FromKey("license_type").Value.ToString() == "")
            {
                //10
                script = "alert('Please, select license type from line item(s)');";
                isValid = false;
                break;
            }

        }
        if (isValid)
        {
            if (AESNO.Value != "")
            {
                UpdateAES();
            }
            else
            {
                AddNewAES();
            }
        }
        else
        {
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "GoBack", script, true);


        }
    }

    protected void UpdateAES()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        ArrayList tranStrAL = new ArrayList();
        string tranStr = "";

        tranStr = "SET ANSI_WARNINGS OFF";
        tranStrAL.Add(tranStr);

        tranStr = "UPDATE aes_master SET "
            + "party_to_transaction=N'" + RCC.SelectedValue
            + "',export_date=N'" + EDA.Text
            + "',tran_ref_no=N'" + BN.Text
            + "',consignee_acct=" + MakeNullCase(hConsigneeAcct.Value)
            + ",inter_consignee_acct=" + MakeNullCase(hInterConsigneeAcct.Value)
            + ",origin_state=N'" + ST.SelectedValue
            + "',dest_country=N'" + COD.SelectedValue
            + "',tran_method=N'" + MOT.SelectedValue
            + "',export_port=N'" + POE.SelectedValue
            + "',unloading_port=N'" + POU.SelectedValue
            + "',carrier_id_code=N'" + lstCarrier.SelectedValue
            + "',export_carrier=N'" + lstCarrier.Items[lstCarrier.SelectedIndex].Text
            + "',shipment_ref_no=N'" + SRN.Text
            + "',hazardous_materials=N'" + HAZ.SelectedValue
            + "',route_export_tran=N'" + RT.SelectedValue
            + "',in_bond_type=N'" + IBT.SelectedValue
            + "',in_bond_no=N'" + IBN.Text
            + "',ftz=N'" + FTZ.Text
            + "',last_modified=GETDATE()"
            + ",shipper_acct=" + MakeNullCase(hShipperAcct.Value)
            + ",file_type=N'" + hFileType.Value
            + "',house_num=N'" + txtHouse.Text
            + "',master_num=N'" + txtMaster.Text
            + "' WHERE elt_account_number=" + elt_account_number + " AND auto_uid=" + AESNO.Value;
        tranStrAL.Add(tranStr);

        tranStr = "DELETE FROM aes_detail WHERE elt_account_number=" + elt_account_number + " AND aes_id=" + AESNO.Value;
        tranStrAL.Add(tranStr);

        // AES item insert loop using grid entries
        for (int i = 0; i < UltraWebGrid1.Rows.Count; i++)
        {
            if (UltraWebGrid1.Rows[i].Cells[3].Value == null)
            {
                UltraWebGrid1.Rows[i].Cells[3].Value = "0";
            }
            if (UltraWebGrid1.Rows[i].Cells[5].Value == null)
            {
                UltraWebGrid1.Rows[i].Cells[5].Value = "0";
            }
            if (UltraWebGrid1.Rows[i].Cells[7].Value == null)
            {
                UltraWebGrid1.Rows[i].Cells[7].Value = "0";
            }
            if (UltraWebGrid1.Rows[i].Cells[8].Value == null)
            {
                UltraWebGrid1.Rows[i].Cells[8].Value = "0";
            }

            tranStr = @"INSERT INTO aes_detail(elt_account_number,item_no,dfm,b_number,item_desc,b_qty1,unit1,b_qty2,unit2,gross_weight,item_value,export_code,license_type,license_number,eccn,vin_type,vin,vc_title,vc_state,aes_id)
                VALUES(" + elt_account_number + "," + i + ",N'" + UltraWebGrid1.Rows[i].Cells[0].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[1].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[1].Text
                + "'," + UltraWebGrid1.Rows[i].Cells[3].Value + ",N'" + UltraWebGrid1.Rows[i].Cells[4].Value + "'," + UltraWebGrid1.Rows[i].Cells[5].Value + ",N'" + UltraWebGrid1.Rows[i].Cells[6].Value
                + "'," + UltraWebGrid1.Rows[i].Cells[7].Value + "," + UltraWebGrid1.Rows[i].Cells[8].Value + ",N'" + UltraWebGrid1.Rows[i].Cells[9].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[10].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[11].Value
                + "',N'" + UltraWebGrid1.Rows[i].Cells[12].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[13].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[14].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[15].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[16].Value + "'," + AESNO.Value + ")";
            tranStrAL.Add(tranStr);

            tranStr = "SET ANSI_WARNINGS ON";
            tranStrAL.Add(tranStr);
        }

        if (!feData.DataTransactions((string[])tranStrAL.ToArray(typeof(string))))
        {
            txtResultBox.Text = feData.GetLastTransactionError();
            txtResultBox.Visible = true;
        }
        else
        {
            Response.Redirect("EditAES.aspx?AESID=" + AESNO.Value);
        }
    }

    protected void AddNewAES()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        ArrayList tranStrAL = new ArrayList();
        string tranStr = "";

        tranStr = "SET ANSI_WARNINGS OFF";
        tranStrAL.Add(tranStr);

        tranStr = @"INSERT INTO aes_master(elt_account_number,party_to_transaction,export_date,tran_ref_no,consignee_acct,inter_consignee_acct,origin_state,dest_country,tran_method,export_port,unloading_port,carrier_id_code,export_carrier,shipment_ref_no,entry_no,hazardous_materials,route_export_tran,in_bond_type,in_bond_no,ftz,last_modified,shipper_acct,file_type,house_num,master_num)
            VALUES(" + elt_account_number + ",N'" + RCC.SelectedValue + "',N'" + EDA.Text + "',N'" + BN.Text + "'," + MakeNullCase(hConsigneeAcct.Value) + "," + MakeNullCase(hInterConsigneeAcct.Value) + ",N'" + ST.SelectedValue + "',N'" + COD.SelectedValue + "',N'" + MOT.SelectedValue + "',N'" + POE.SelectedValue + "',N'" + POU.SelectedValue
            + "',N'" + lstCarrier.SelectedValue + "',N'" + lstCarrier.Items[lstCarrier.SelectedIndex].Text + "',N'" + SRN.Text + "','',N'" + HAZ.SelectedValue + "',N'" + RT.SelectedValue + "',N'" + IBT.SelectedValue + "',N'" + IBN.Text + "',N'" + FTZ.Text + "',GETDATE()," + MakeNullCase(hShipperAcct.Value) + ",N'" + hFileType.Value + "',N'" + txtHouse.Text + "',N'" + txtMaster.Text + "')";
        tranStrAL.Add(tranStr);

        // AES item insert loop using grid entries
        for (int i = 0; i < UltraWebGrid1.Rows.Count; i++)
        {
            if (UltraWebGrid1.Rows[i].Cells[3].Value == null)
            {
                UltraWebGrid1.Rows[i].Cells[3].Value = "0";
            }
            if (UltraWebGrid1.Rows[i].Cells[5].Value == null)
            {
                UltraWebGrid1.Rows[i].Cells[5].Value = "0";
            }
            if (UltraWebGrid1.Rows[i].Cells[7].Value == null)
            {
                UltraWebGrid1.Rows[i].Cells[7].Value = "0";
            }
            if (UltraWebGrid1.Rows[i].Cells[8].Value == null)
            {
                UltraWebGrid1.Rows[i].Cells[8].Value = "0";
            }

            tranStr = @"INSERT INTO aes_detail(elt_account_number,item_no,dfm,b_number,item_desc,b_qty1,unit1,b_qty2,unit2,gross_weight,item_value,export_code,license_type,license_number,eccn,vin_type,vin,vc_title,vc_state,aes_id)
                VALUES(" + elt_account_number + "," + i + ",N'" + UltraWebGrid1.Rows[i].Cells[0].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[1].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[1].Text
                + "'," + UltraWebGrid1.Rows[i].Cells[3].Value + ",N'" + UltraWebGrid1.Rows[i].Cells[4].Value + "'," + UltraWebGrid1.Rows[i].Cells[5].Value + ",N'" + UltraWebGrid1.Rows[i].Cells[6].Value
                + "'," + UltraWebGrid1.Rows[i].Cells[7].Value + "," + UltraWebGrid1.Rows[i].Cells[8].Value + ",N'" + UltraWebGrid1.Rows[i].Cells[9].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[10].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[11].Value
                + "',N'" + UltraWebGrid1.Rows[i].Cells[12].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[13].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[14].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[15].Value + "',N'" + UltraWebGrid1.Rows[i].Cells[16].Value + "',IDENT_CURRENT('aes_master'))";
            tranStrAL.Add(tranStr);

            tranStr = "SET ANSI_WARNINGS ON";
            tranStrAL.Add(tranStr);
        }

        if (!feData.DataTransactions((string[])tranStrAL.ToArray(typeof(string))))
        {
            txtResultBox.Text = feData.GetLastTransactionError();
            txtResultBox.Visible = true;
        }
        else
        {
            feData.AddToDataSet("AESInfo", "SELECT * FROM aes_master WHERE elt_account_number=" + elt_account_number + " AND shipment_ref_no=N'" + SRN.Text + "'AND file_type='AE'");

            if (feData.Tables["AESInfo"].Rows.Count > 0)
            {
                Response.Redirect("EditAES.aspx?AESID=" + feData.Tables["AESInfo"].Rows[0]["auto_uid"].ToString());
            }
        }
    }

    protected string MakeNullCase(string input)
    {
        string output = "null";
        if (input == "0" || input == "")
        {
            output = "null";
        }
        else
        {
            output = input;
        }
        return output;
    }

    protected void IBT_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IBT.SelectedValue != "")
        {
            trInbond.Visible = true;
        }
        else
        {
            trInbond.Visible = false;
            FTZ.Text = "";
            IBN.Text = "";
        }
    }
}
