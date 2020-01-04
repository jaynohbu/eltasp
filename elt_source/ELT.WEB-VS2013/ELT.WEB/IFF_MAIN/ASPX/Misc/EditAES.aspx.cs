using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI.WebControls;
using DevExpress.Web.ASPxGridView;
using ELT.BL;
using ELT.CDT;
using ELT.COMMON;

public partial class ASPX_Misc_EditAES : System.Web.UI.Page
{
    protected string user_id, login_name, user_right, elt_account_number, AESID, move_type;
    protected DataSet ds;
    public bool isValid;
   
    protected void Page_Load(object sender, EventArgs e)
    {        
        Session.LCID = 1033;
        if (!IsPostBack)
        {
            HttpContext.Current.Session["AESLineItems"] = null;
            ResetAESLineItems();

            ObjectDataSourceAES.SelectParameters["AesID"].DefaultValue = AESID;
            ObjectDataSourceAES.SelectParameters["MAWB"].DefaultValue = txtMaster.Text;
            ObjectDataSourceAES.SelectParameters["HAWB"].DefaultValue = txtHouse.Text;

            gridBatchAES.DataBind();


            LoadHeader();
        }
        else
        {
            string eventTarget = (this.Request["__EVENTTARGET"] == null) ?
            string.Empty : this.Request["__EVENTTARGET"];
            string eventArgument = (this.Request["__EVENTARGUMENT"] == null) ?
             string.Empty : this.Request["__EVENTARGUMENT"];

            if (eventTarget == "btnSaveAES_Click")
                btnSaveAES_Click();
        }
    }

    private static void ResetAESLineItems()
    {
        HttpContext.Current.Session["AESLineItems"] = null;
        HttpContext.Current.Session["AESLineItemsToDelete"] = null;

    }

    protected void Page_PreInit(object sender, EventArgs e)
    {
        LoadUserInfo();
    }  

    protected void Page_Init(object sender, EventArgs e)
    {

        LoadUserInfo();
        if (!IsPostBack)
        {
            LoadParameters();
            CheckExistingAES();
        }
        // FreightEasyData Initialized
        FreightEasy.DataManager.FreightEasyData feData = SetDataList();
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
        if (string.IsNullOrEmpty(AESID))
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

    private FreightEasy.DataManager.FreightEasyData SetDataList()
    {
     
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("Ports", "SELECT port_code + ' - ' + port_desc as port_name,port_code FROM port WHERE elt_account_number=" + elt_account_number + " AND ISNULL(port_id,'')<>'' ORDER BY port_desc");
        feData.AddToDataSet("Countries", "SELECT * FROM country_code WHERE elt_account_number=" + elt_account_number + " order by country_name");
        feData.AddToDataSet("MOT", "SELECT code_id,code_desc FROM aes_codes WHERE code_type='Transport Code' ORDER BY code_id");
        feData.AddToDataSet("Carriers", "SELECT ISNULL(carrier_id,'') AS carrier_code,LEFT(dba_name,22) AS carrier_name FROM organization WHERE is_carrier='Y' AND ISNULL(carrier_id,'') <> '' AND ISNULL(carrier_code,'')<>'' AND elt_account_number=" + elt_account_number + " ORDER BY dba_name");
        feData.AddToDataSet("ScheduleB", "SELECT * FROM scheduleB WHERE elt_account_number=" + elt_account_number + " ORDER BY description");
       // Session["AES_DATA"] = feData;
        return feData;
    }

   

    private void LoadHeader()
    {
        // New AES
        if (string.IsNullOrEmpty(AESID) || AESID=="0")
        {
            LoadHeaderInfoAE();
        }
        // Saved AES
        else
        {
            LoadHeaderInfo();
        }
    }

    protected void CheckExistingAES()
    {
        if (string.IsNullOrEmpty(AESID))
        {
            string aesFindSQL = @"SELECT * FROM aes_master WHERE elt_account_number=" + elt_account_number
                + " AND file_type='AE' AND house_num=N'" + txtHouse.Text + "' AND master_num=N'" + txtMaster.Text + "'";
            FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
            feData.AddToDataSet("AESEntity", aesFindSQL);
            if (feData.Tables["AESEntity"].Rows.Count > 0)
            {
                DataRow drTmp = feData.Tables["AESEntity"].Rows[0];
                AESID = drTmp["auto_uid"].ToString();
            }
        }
    }

    protected void LoadHeaderInfo()
    {
        FreightEasy.DataManager.FreightEasyData feData = new FreightEasy.DataManager.FreightEasyData();
        feData.AddToDataSet("AESInfo", "SELECT * FROM aes_master WHERE elt_account_number=" + elt_account_number + " AND auto_uid=" + AESID);

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
            EDA.Text = drTmp["export_date"].ToString();
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
            EDA.Text = drTmp["ETD_DATE1"].ToString();
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
                EDA.Text = drTmp["ETD_DATE1"].ToString();
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
    protected void LoadUserInfo()
    {
        elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
        user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
        user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
        login_name = Request.Cookies["CurrentUserInfo"]["login_name"];

    }

    protected void LoadParameters()
    {
       
            AESID = Request.Params["AESID"];
            if (AESID == "" || AESID == null) { AESID = "0"; }
            move_type = "AE";
           

            txtHouse.Text = Request.Params["HAWB"];
            txtMaster.Text = Request.Params["MAWB"];
     
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

       // tranStr = "DELETE FROM aes_detail WHERE EmailItemID=" + EmailItemID + " AND aes_id=" + AESNO.Value;
         
          
        
        tranStrAL.Add(tranStr);

        if (!feData.DataTransactions((string[])tranStrAL.ToArray(typeof(string))))
        {
            txtResultBox.Text = feData.GetLastTransactionError();
            txtResultBox.Visible = true;
        }
        else
        {
            SaveLineItems(int.Parse(AESNO.Value));    
            Response.Redirect("EditAES.aspx?AESID=" + AESNO.Value);
        }
    }

    private static void SaveLineItems(int AesID)
    {

        AESBL AESBL = new AESBL();
        var AirAESLineItems = (List<AESLineItem>)HttpContext.Current.Session["AESLineItems"];
        var AirAESLineItemsToDelete = (List<int>)HttpContext.Current.Session["AESLineItemsToDelete"];

        if(AirAESLineItemsToDelete!=null)
        foreach (var item in AirAESLineItemsToDelete)
        {
            
            AESBL.DeleteAESLineItem(item);
        }
        if (AirAESLineItems != null)
        foreach (var item in AirAESLineItems)
        {
            if (item.ID == 0)
            {
                item.AesID = AesID;
                AESBL.InsertAESLineItem(item);
            }
            else
            {
                if (item.IsModified)
                {
                    item.AesID = AesID;
                    AESBL.UpdateAESLineItem(item);
                }
            }
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
                SaveLineItems(Convert.ToInt32(feData.Tables["AESInfo"].Rows[0]["auto_uid"]));  
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

   

    protected void btnSaveAES_Click()
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

    protected void ComboBoxDataSourceUnit1_Init(object sender, EventArgs e)
    {
        ComboBoxDataSourceUnit1.SelectCommand = SQLConstants.SELECT_LIST_UOM_CODE;
        ComboBoxDataSourceUnit1.DataSourceMode = SqlDataSourceMode.DataSet;
        ComboBoxDataSourceUnit1.ConnectionString = (new igFunctions.DB().getConStr());

      
    }
    protected void ComboBoxDataSourceUnit2_Init(object sender, EventArgs e)
    {
        ComboBoxDataSourceUnit2.SelectCommand = SQLConstants.SELECT_LIST_UOM_CODE;
        ComboBoxDataSourceUnit2.DataSourceMode = SqlDataSourceMode.DataSet;
        ComboBoxDataSourceUnit2.ConnectionString = (new igFunctions.DB().getConStr());
    }
    
    protected void ComboBoxDataSourceExportCode_Init(object sender, EventArgs e)
    {
        ComboBoxDataSourceExportCode.SelectCommand = SQLConstants.SELECT_LIST_EXPORT_CODE;
        ComboBoxDataSourceExportCode.DataSourceMode = SqlDataSourceMode.DataSet;
        ComboBoxDataSourceExportCode.ConnectionString = (new igFunctions.DB().getConStr());

       
    }
    protected void ComboBoxDataSourceLicenseType_Init(object sender, EventArgs e)
    {
        ComboBoxDataSourceLicenseType.SelectCommand = SQLConstants.SELECT_LIST_LICENSE_CODE;
        ComboBoxDataSourceLicenseType.DataSourceMode = SqlDataSourceMode.DataSet;
        ComboBoxDataSourceLicenseType.ConnectionString = (new igFunctions.DB().getConStr());
    }
   
    protected void ComboBoxDataSourceVeicleState_Init(object sender, EventArgs e)
    {

        ComboBoxDataSourceVeicleState.SelectCommand = SQLConstants.SELECT_LIST_STATES;
        ComboBoxDataSourceVeicleState.DataSourceMode = SqlDataSourceMode.DataSet;
        ComboBoxDataSourceVeicleState.ConnectionString = (new igFunctions.DB().getConStr());       

    }
    protected void ComboBoxDataSourceScheduleB_Init(object sender, EventArgs e)
    {       
        ComboBoxDataSourceScheduleB.SelectCommand = string.Format(SQLConstants.SELECT_LIST_SCHEDULE_B, elt_account_number);
        ComboBoxDataSourceScheduleB.DataSourceMode = SqlDataSourceMode.DataSet;
        ComboBoxDataSourceScheduleB.ConnectionString = (new igFunctions.DB().getConStr());

    }
    protected void gridBatchAES_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
    {
        List<string> RequiredFields = SetRequiredFields();
     
        foreach (GridViewColumn column in gridBatchAES.Columns)
        {
            GridViewDataColumn dataColumn = column as GridViewDataColumn;

            if (dataColumn == null) continue;
            for (int i = 0; i < RequiredFields.Count; i++)
            {
                if (RequiredFields[i] == dataColumn.FieldName)
                {
                    if (e.NewValues[dataColumn.FieldName] == null)
                    {
                        e.Errors[dataColumn] = "Value can't be empty.";
                    }
                }
            }
        }

       
        if (string.IsNullOrEmpty(e.RowError) && e.Errors.Count > 0) e.RowError = "Please, correct all errors.";
    }

    private static List<string> SetRequiredFields()
    {
        List<string> RequiredFields = new List<string>();
        RequiredFields.Add("Origin");
        RequiredFields.Add("ScheduleB");
        RequiredFields.Add("Qty1");
        RequiredFields.Add("Unit1");
        RequiredFields.Add("GrossWeight");
        RequiredFields.Add("ExportCode");
        RequiredFields.Add("LicenseType");
        return RequiredFields;
    }
    void AddError(Dictionary<GridViewColumn, string> errors, GridViewColumn column, string errorText)
    {
        if (errors.ContainsKey(column)) return;
        errors[column] = errorText;
    }
}
