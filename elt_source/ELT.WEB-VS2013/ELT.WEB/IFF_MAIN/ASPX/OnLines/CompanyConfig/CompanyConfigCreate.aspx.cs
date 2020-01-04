using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.IO;

namespace IFF_MAIN.ASPX.OnLines.CompanyConfig
{
    /// <summary>
    /// CompanyConfigEdit에 대한 요약 설명입니다.
    /// </summary>
    public partial class CompanyConfigCreate : System.Web.UI.Page
    {
        //***********************************************************//
        protected string ConnectStr;
        string qry1 = "";
        string qry2 = "";

        public string elt_account_number;
        public string user_id, login_name, user_right;
        public static bool igR;
        public int allIndex = 0;
        public string windowName;
        public bool bReadOnly = false;
        public string strMode = "";
        //***********************************************************//


        protected void Page_Load(object sender, System.EventArgs e)
        {
            Session.LCID = 1033;

            qry1 = elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
            user_id = Request.Cookies["CurrentUserInfo"]["user_id"];
            user_right = Request.Cookies["CurrentUserInfo"]["user_right"];
            login_name = Request.Cookies["CurrentUserInfo"]["login_name"];
            ConnectStr = (new igFunctions.DB().getConStr());
            bReadOnly = new igFunctions.DB().AUTH_CHECK(elt_account_number, user_id, ConnectStr, Request.ServerVariables["URL"].ToLower(), "");

            windowName = Request.QueryString["WindowName"];

            if (!IsPostBack)
            {
                ViewState["Count"] = 1;
                PerformDefault();

                loadSalesPerson();
                //------------------------------------------------> added to be passed dba name from quick add page
                if (Request.QueryString["newDBA"] != null)
                {
                    this.txtDBA.Text = Request.QueryString["newDBA"].ToString();
                }
                //-----------------------------------------------------------------------------------
                if (Request.QueryString["R"] != null)
                {
                    igR = true;
                }
                else
                {
                    igR = false;
                }

                if (Request.QueryString["AutoCreate"] != null)
                {
                    string strAutoCreate = Request.QueryString["AutoCreate"];
                    if (strAutoCreate == "yes")
                    {
                        string vHAWB = null;
                        if (Request.QueryString["HAWB_NUM"] != null)
                        {
                            PerformMode(0, true);
                            vHAWB = Request.QueryString["HAWB_NUM"];
                            PerformAutoCreate(vHAWB);
                        }
                    }
                }
                else
                {
                    if (Request.QueryString["number"] != null)
                    {
                        qry2 = txtAccountNumber.Text = Request.QueryString["number"].ToString();
                        PerformRemoteEdit();
                    }
                    else if (Request.QueryString["name"] != null)
                    {
                        string vName = Request.QueryString["name"].ToString();

                        if (vName == "")
                        {
                            txtAccountNumber.Text = "0";
                        }
                        else
                        {
                            SqlConnection Con = new SqlConnection(ConnectStr);
                            SqlCommand Cmd = new SqlCommand();
                            Cmd.Connection = Con;

                            Con.Open();
                            Cmd.CommandText = "select org_account_number  from organization where elt_account_number = " + elt_account_number + " AND dba_name like '" + vName + "'";
                            SqlDataReader reader = Cmd.ExecuteReader();

                            if (reader.Read())
                            {
                                txtAccountNumber.Text = reader["org_account_number"].ToString();
                            }
                            else
                            {
                                txtAccountNumber.Text = "0";
                            }
                            reader.Close();
                            Con.Close();
                        }
                        PerformRemoteEdit();
                    }
                    else
                    {
                        PerformMode(0, true);
                    }
                }

            }
            else
            {
                ViewState["Count"] = (int)ViewState["Count"] + 1;
            }
           
           
        }

        private void loadSalesPerson()
        {
        
            ddlSalesPerson.Items.Add("");
            ddlSalesPerson.Items[0].Value = "";
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Con.Open();
            Cmd.CommandText = "select user_lname, user_fname from users where user_type =10 and elt_account_number = " + elt_account_number;
            SqlDataReader reader = Cmd.ExecuteReader();

            while (reader.Read())
            {
                ddlSalesPerson.Items.Add(reader["user_fname"].ToString()+" "+ reader["user_lname"].ToString());
            }
            reader.Close();
            Con.Close();

        }
   

        private void PerformSelectionDataBindingColo()
        {

            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmdColo = new SqlCommand("select * from colo where coloder_elt_acct = " + elt_account_number + " order by colodee_name", Con);

            SqlDataAdapter Adap = new SqlDataAdapter();
            DataSet ds = new DataSet();

            Con.Open();

            Adap.SelectCommand = cmdColo;
            Adap.Fill(ds, "Colo");

            Con.Close();

            dlColodee.DataSource = ds.Tables["Colo"];
            dlColodee.DataTextField = "colodee_name";
            dlColodee.DataValueField = "colodee_elt_acct";
            dlColodee.DataBind();
            dlColodee.Items.Insert(0, "");
            dlColodee.SelectedIndex = 0;

        }
        
        private void PerformAutoCreate(string vHAWB)
        {
            string ConsigneeInfo = "";
            //			string vDBA = "";
            //			string vBName = "";
            //			string vBAddress = "";
            //			string vBCity = "";
            string vBState = "";
            string vBCountry = "";
            int pos = 0;

            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Cmd.CommandText =
                "select consignee_info from import_hawb where elt_account_number =" + elt_account_number + " and hawb_num='" + vHAWB + "'";

            Con.Open();
            SqlDataReader reader = Cmd.ExecuteReader();
            if (reader.Read())
            {
                ConsigneeInfo = reader["consignee_info"].ToString();
                pos = ConsigneeInfo.IndexOf("\r\n");
                if (pos > 0)
                {
                    this.txtDBA.Text = ConsigneeInfo.Substring(0, pos);
                    ConsigneeInfo = ConsigneeInfo.Substring(pos + 2);
                }

                pos = 0;
                pos = ConsigneeInfo.IndexOf("\r\n");
                if (pos > 0)
                {
                    ConsigneeInfo = ConsigneeInfo.Substring(pos + 2);
                }

                pos = 0;
                pos = ConsigneeInfo.IndexOf("\r\n");
                if (pos > 0)
                {
                    //					vBAddress=ConsigneeInfo.Substring(0,pos);
                    txtBAdress.Text = ConsigneeInfo.Substring(0, pos);
                    ConsigneeInfo = ConsigneeInfo.Substring(pos + 2);
                }

                pos = 0;
                pos = ConsigneeInfo.IndexOf(",");
                if (pos > 0)
                {
                    //					vBCity=ConsigneeInfo.Substring(0,pos);
                    this.txtBCity.Text = ConsigneeInfo.Substring(0, pos);
                    ConsigneeInfo = ConsigneeInfo.Substring(pos + 2);
                }

                pos = 0;
                pos = ConsigneeInfo.IndexOf(",");
                if (pos > 0)
                {
                    vBState = ConsigneeInfo.Substring(0, pos);
                    if (vBState != "")
                    {
                        ListItem crItema = this.dlState.Items.FindByValue(vBState);
                        if (crItema == null) { vBState = ""; }
                        else { dlState.SelectedValue = crItema.Value; }
                    }

                    ConsigneeInfo = ConsigneeInfo.Substring(pos + 2);
                }

                pos = 0;
                pos = ConsigneeInfo.IndexOf(",");
                if (pos > 0)
                {
                    vBCountry = ConsigneeInfo.Substring(0, pos);
                    if (vBCountry != "")
                    {
                        ListItem crItemb = this.dlCountry.Items.FindByValue(vBCountry);
                        if (crItemb == null) { vBCountry = ""; }
                        else { dlCountry.SelectedValue = crItemb.Value; }
                    }
                    ConsigneeInfo = ConsigneeInfo.Substring(pos + 2);
                }

            }

            reader.Close();
            Con.Close();

            this.chkConsignee.Checked = true;

        }
        private void PerformRemoteEdit()
        {
            PerformDataEdit();
        }

        private void PerformDefault()
        {
            lblTask.Text = "Creation";
            PerformSelectionDataBinding();
            PerformSelectionDataBindingColo();

            chkCopy.Attributes.Add("onclick", "Javascript:setBillAddr();");
            dlState.Attributes.Add("onchange", "Javascript:setCountry();");
            dlState2.Attributes.Add("onchange", "Javascript:setCountry2();");
            Go.Attributes.Add("onclick", "javascript:return loadProfile('ComboSearchKey');");
        }


        #region Web Form 디자이너에서 생성한 코드
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: 이 호출은 ASP.NET Web Form 디자이너에 필요합니다.
            //
            InitializeComponent();
            base.OnInit(e);
        }

        /// <summary>
        /// 디자이너 지원에 필요한 메서드입니다.
        /// 이 메서드의 내용을 코드 편집기로 수정하지 마십시오.
        /// </summary>
        private void InitializeComponent()
        {
        }
        #endregion


        private bool PerformSaveColodee(int iPickedAccountNumber)
        {

            string strDelete = @" DELETE colo where colodee_org_num =" + iPickedAccountNumber.ToString() + " AND coloder_elt_acct =" + elt_account_number;

            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmdColo = new SqlCommand();
            cmdColo.Connection = Con;

            Con.Open();

            SqlTransaction trans = Con.BeginTransaction();
            cmdColo.Transaction = trans;

            try
            {
                cmdColo.CommandText = strDelete;
                cmdColo.ExecuteNonQuery();

                if(chkColodee.Checked)
                {
                     string strInsert = @" INSERT INTO colo ( colodee_elt_acct,colodee_name,coloder_elt_acct,coloder_name,colodee_org_num,tran_date ) 
                                                     VALUES ( "+ txtAgent_elt_acct.Text +
                                                            ",'"+ txtDBA.Text + "'" +
                                                            ","+ elt_account_number +
                                                            ",'"+ Request.Cookies["CurrentUserInfo"]["company_name"] + "'" +
                                                            ","+ iPickedAccountNumber.ToString() +
                                                            ",'"+ DateTime.Now.ToShortDateString() + "' )";
                    cmdColo.CommandText = strInsert;
                    cmdColo.ExecuteNonQuery();
                }

                trans.Commit();

            }
            catch (Exception ex)
            {
                trans.Rollback();
                lblError.Text = ex.Message;
                Con.Close();
            }
            finally
            {
                Con.Close();
            }

            return true;
        }


        private bool PerformSave(bool forceInsert)
        {

            Page.Validate();
            if (!Page.IsValid) return false;

            int iPickedAccountNumber = int.Parse(ViewState["iPickedAccountNumber"].ToString());

            if (this.lblTask.Text == "Create" || (forceInsert))
            {
            }
            else if (this.lblTask.Text == "Edit")
            {
            }

            PerformSaveColodee(iPickedAccountNumber);

            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand sqlCmd = new SqlCommand("dbo.ig_up_organization_update", Con);
            sqlCmd.CommandType = CommandType.StoredProcedure;

            sqlCmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal, 9);
            sqlCmd.Parameters.Add("@org_account_number", SqlDbType.Decimal, 9);
            sqlCmd.Parameters.Add("@acct_name", SqlDbType.VarChar, 16);
            sqlCmd.Parameters.Add("@dba_name", SqlDbType.VarChar, 128);
            sqlCmd.Parameters.Add("@class_code", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@date_opened", SqlDbType.DateTime, 8);
            sqlCmd.Parameters.Add("@last_update", SqlDbType.DateTime, 8);
            sqlCmd.Parameters.Add("@business_legal_name", SqlDbType.VarChar, 128);
            sqlCmd.Parameters.Add("@business_fed_taxid", SqlDbType.VarChar, 16);
            sqlCmd.Parameters.Add("@business_st_taxid", SqlDbType.VarChar, 16);
            sqlCmd.Parameters.Add("@business_address", SqlDbType.VarChar, 128);
            sqlCmd.Parameters.Add("@business_city", SqlDbType.VarChar, 32);
            sqlCmd.Parameters.Add("@business_state", SqlDbType.VarChar, 32); //  
            sqlCmd.Parameters.Add("@business_zip", SqlDbType.VarChar, 10);
            sqlCmd.Parameters.Add("@business_country", SqlDbType.VarChar, 64);
            sqlCmd.Parameters.Add("@b_country_code", SqlDbType.VarChar, 16);
            sqlCmd.Parameters.Add("@business_phone", SqlDbType.VarChar, 32);
            sqlCmd.Parameters.Add("@business_fax", SqlDbType.VarChar, 32);
            sqlCmd.Parameters.Add("@business_url", SqlDbType.VarChar, 64);
            sqlCmd.Parameters.Add("@owner_ssn", SqlDbType.VarChar, 9);
            sqlCmd.Parameters.Add("@owner_lname", SqlDbType.VarChar, 32);
            sqlCmd.Parameters.Add("@owner_fname", SqlDbType.VarChar, 32);
            sqlCmd.Parameters.Add("@owner_mname", SqlDbType.VarChar, 32);
            sqlCmd.Parameters.Add("@owner_mail_address", SqlDbType.VarChar, 128);
            sqlCmd.Parameters.Add("@owner_mail_city", SqlDbType.VarChar, 32);
            sqlCmd.Parameters.Add("@owner_mail_state", SqlDbType.VarChar, 32);
            sqlCmd.Parameters.Add("@owner_mail_zip", SqlDbType.VarChar, 10);
            sqlCmd.Parameters.Add("@owner_mail_country", SqlDbType.VarChar, 16);
            sqlCmd.Parameters.Add("@owner_phone", SqlDbType.VarChar, 32);
            sqlCmd.Parameters.Add("@owner_email", SqlDbType.VarChar, 64);
            sqlCmd.Parameters.Add("@attn_name", SqlDbType.VarChar, 64);
            sqlCmd.Parameters.Add("@notify_name", SqlDbType.VarChar, 64);
            sqlCmd.Parameters.Add("@is_shipper", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@is_consignee", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@broker_info", SqlDbType.VarChar, 256);
            sqlCmd.Parameters.Add("@is_agent", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@agent_elt_acct", SqlDbType.Char, 8);
            sqlCmd.Parameters.Add("@edt", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@is_vendor", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@is_carrier", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@iata_code", SqlDbType.VarChar, 16);
            sqlCmd.Parameters.Add("@carrier_code", SqlDbType.VarChar, 16);
            sqlCmd.Parameters.Add("@carrier_id", SqlDbType.VarChar, 16);
            sqlCmd.Parameters.Add("@carrier_type", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@account_status", SqlDbType.VarChar, 1);
            sqlCmd.Parameters.Add("@comment", SqlDbType.VarChar, 512);
            sqlCmd.Parameters.Add("@credit_amt", SqlDbType.Decimal, 9);
            sqlCmd.Parameters.Add("@bill_term", SqlDbType.Int, 4);
            sqlCmd.Parameters.Add("@is_colodee", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@colodee_elt_acct", SqlDbType.Decimal, 9);
            sqlCmd.Parameters.Add("@z_is_trucker", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@z_is_special", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@z_is_broker", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@z_is_warehousing", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@z_is_cfs", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@z_is_govt", SqlDbType.Char, 1);
            sqlCmd.Parameters.Add("@z_bond_number", SqlDbType.Decimal, 9);
            sqlCmd.Parameters.Add("@z_bond_exp_date", SqlDbType.DateTime, 8);
            sqlCmd.Parameters.Add("@z_bond_amount", SqlDbType.Decimal, 9);
            sqlCmd.Parameters.Add("@z_bond_surety", SqlDbType.Char, 30);
            sqlCmd.Parameters.Add("@z_bank_name", SqlDbType.Char, 50);
            sqlCmd.Parameters.Add("@z_bank_account_no", SqlDbType.Char, 20);
            sqlCmd.Parameters.Add("@z_chl_no", SqlDbType.Char, 30);
            sqlCmd.Parameters.Add("@z_firm_code", SqlDbType.Char, 20);
            sqlCmd.Parameters.Add("@z_carrier_code", SqlDbType.Char, 20);
            sqlCmd.Parameters.Add("@z_carrier_prefix", SqlDbType.NChar, 20);
            sqlCmd.Parameters.Add("@z_attn_txt", SqlDbType.NChar, 20);
            sqlCmd.Parameters.Add("@SalesPerson", SqlDbType.VarChar, 64);


            sqlCmd.Parameters[0].Value = elt_account_number;																		/* EmailItemID */
            sqlCmd.Parameters[1].Value = iPickedAccountNumber.ToString();													/* org_account_number */
            sqlCmd.Parameters[3].Value = txtDBA.Text;																		/* dba_name */
            sqlCmd.Parameters[5].Value = DateTime.Now.ToString();															/* date_opened */
            sqlCmd.Parameters[6].Value = DateTime.Now.ToString();															/* last_update */
            sqlCmd.Parameters[7].Value = txtBName.Text;																		/* business_legal_name */
            sqlCmd.Parameters[8].Value = txtTAXID.Text;																		/* business_fed_taxid */
            sqlCmd.Parameters[10].Value = txtBAdress.Text;																	/* business_address */
            sqlCmd.Parameters[11].Value = txtBCity.Text;																	/* business_city */
            sqlCmd.Parameters[12].Value = dlState.SelectedValue.ToString();													/* business_state */
            sqlCmd.Parameters[13].Value = txtBZIP.Text;																		/* business_zip */
            sqlCmd.Parameters[14].Value = dlCountry.SelectedItem.ToString();												/* business_country */
            sqlCmd.Parameters[15].Value = dlCountry.SelectedValue.ToString();												/* b_country_code */
            sqlCmd.Parameters[16].Value = txtBPhone.Text;																	/* business_phone */
            sqlCmd.Parameters[17].Value = txtBFax.Text;																		/* business_fax */
            sqlCmd.Parameters[18].Value = txtBURL.Text;																		/* business_url */
            sqlCmd.Parameters[20].Value = txtBCLName.Text;																	/* owner_lname */
            sqlCmd.Parameters[21].Value = txtBCFName.Text;																	/* owner_fname */
            sqlCmd.Parameters[22].Value = txtBCMName.Text;																	/* owner_mname */
            sqlCmd.Parameters[23].Value = txtCAddress.Text;																	/* owner_mail_address */
            sqlCmd.Parameters[24].Value = txtCCity.Text;																	/* owner_mail_city */
            sqlCmd.Parameters[25].Value = dlState2.SelectedValue.ToString();												/* owner_mail_state */
            sqlCmd.Parameters[26].Value = txtBCZIP.Text;																	/* owner_mail_zip */
            sqlCmd.Parameters[27].Value = dlCountry2.SelectedValue.ToString();												/* owner_mail_country */
            sqlCmd.Parameters[28].Value = txtCPhone.Text.Replace("(   )    -", "");																	/* owner_phone */
            sqlCmd.Parameters[29].Value = txtCEmail.Text;																	/* owner_email */
            sqlCmd.Parameters[56].Value = (txtBond.Text == "" ? "0" : txtBond.Text); ;										/* z_bond_number */
            sqlCmd.Parameters[47].Value = (txtInvoiceTerm.Text == "" ? "0" : txtInvoiceTerm.Text); ;														/* bill_term; */

            sqlCmd.Parameters[32].Value = (chkShipper.Checked == true ? "Y" : "");											/* is_shipper */
            sqlCmd.Parameters[33].Value = (chkConsignee.Checked == true ? "Y" : "");										/* is_consignee */
            sqlCmd.Parameters[35].Value = (chkForwarder.Checked == true ? "Y" : "");										/* is_agent */
            sqlCmd.Parameters[39].Value = (chkCarrier.Checked == true ? "Y" : "");											/* is_carrier */
            sqlCmd.Parameters[50].Value = (chkTrucker.Checked == true ? "Y" : "");											/* new z_is_truecker*/
            sqlCmd.Parameters[51].Value = (chkSpecial.Checked == true ? "Y" : "");											/* new z_is_special*/
            sqlCmd.Parameters[52].Value = (chkBroker.Checked == true ? "Y" : "");											/* New z_is_broker*/
            sqlCmd.Parameters[53].Value = (chkWarehousing.Checked == true ? "Y" : "");									    /* New z_is_warehousing*/
            sqlCmd.Parameters[54].Value = (chkCFS.Checked == true ? "Y" : "");												/* New z_is_cfs*/
            sqlCmd.Parameters[55].Value = (chkGovt.Checked == true ? "Y" : "");												/* New z_is_govt*/
            sqlCmd.Parameters[44].Value = (chkActivate.Checked == true ? "A" : "");												/* account_status*/
            sqlCmd.Parameters[37].Value = (chkEDT.Checked == true ? "Y" : "");															/* edt; */
            sqlCmd.Parameters[48].Value = (chkColodee.Checked == true ? "Y" : "");
            if (this.ddlSalesPerson.SelectedIndex != 0)
            {
                sqlCmd.Parameters["@SalesPerson"].Value = this.ddlSalesPerson.SelectedValue.ToString();
            }
            else
            {
                sqlCmd.Parameters["@SalesPerson"].Value = "";
            }

														/* is_colodee; */

            if (txtExpDate.Text != "")
            {
                sqlCmd.Parameters[57].Value = txtExpDate.Text;											/* z_bond_exp_date */
            }
            else
            {
                sqlCmd.Parameters[57].Value = System.DBNull.Value;
            }

            sqlCmd.Parameters[58].Value = txtBondAmount.ValueDecimal.ToString();											/* z_bond_amount */
            sqlCmd.Parameters[59].Value = txtSurety.Text;																	/* z_bond_surety */
            sqlCmd.Parameters[60].Value = txtBankName.Text;																	/* z_bank_name */
            sqlCmd.Parameters[61].Value = txtBankAccountNo.Text;															/* z_bank_account_no */
            sqlCmd.Parameters[62].Value = txtCHLNo.Text;															/* z_chl_no */
            sqlCmd.Parameters[63].Value = txtFirmsCode.Text;																/* z_firm_code */
            sqlCmd.Parameters[66].Value = txtz_attn_txt.Text;
            sqlCmd.Parameters[46].Value = txtCreditAmount.ValueDecimal.ToString();

            if (txtCarrierPrefix.Text == "")
            {
                sqlCmd.Parameters[64].Value = txtOceanSCAC.Text;														/* z_carrier_code */
                sqlCmd.Parameters[42].Value = txtOceanSCAC.Text;														/* carrier_id; */
                sqlCmd.Parameters[65].Value = "";																	/* z_carrier_prefix */
                sqlCmd.Parameters[41].Value = "";																	/* carrier_code */
            }
            else
            {
                sqlCmd.Parameters[64].Value = txtAirLineCode.Text;														/* z_carrier_code */
                sqlCmd.Parameters[42].Value = txtAirLineCode.Text;														/* carrier_id; */
                sqlCmd.Parameters[65].Value = txtCarrierPrefix.Text;																	/* z_carrier_prefix */
                sqlCmd.Parameters[41].Value = txtCarrierPrefix.Text;																	/* carrier_code */
            }


            sqlCmd.Parameters[40].Value = txtCarrierPrefix.Text;														/* iata_code; */
            txtAgent_elt_acct.Text = txtAgent_elt_acct.Text.Trim();
            if (txtAgent_elt_acct.Text == "")
            {
                txtAgent_elt_acct.Text = "0";
            }

            sqlCmd.Parameters[36].Value = txtAgent_elt_acct.Text;																/* agent_elt_acct; */

            //			sqlCmd.Parameters[36].Value = dlAgent_elt_acct.SelectedValue;																/* agent_elt_acct; */ 


            sqlCmd.Parameters[43].Value = System.DBNull.Value;																/* carrier_type; */
            sqlCmd.Parameters[2].Value = System.DBNull.Value;																/* acct_name */
            sqlCmd.Parameters[4].Value = System.DBNull.Value;																/* class_code; */
            sqlCmd.Parameters[9].Value = System.DBNull.Value;																/* business_st_taxid; */
            sqlCmd.Parameters[19].Value = System.DBNull.Value;																/* owner_ssn; */
            sqlCmd.Parameters[30].Value = System.DBNull.Value;																/* attn_name; */
            sqlCmd.Parameters[31].Value = System.DBNull.Value;																/* notify_name; */


            if ((chkForwarder.Checked) || (chkCarrier.Checked) || (chkTrucker.Checked) || (chkBroker.Checked) || (chkWarehousing.Checked) || (chkCFS.Checked))
            {
                sqlCmd.Parameters[38].Value = "Y";																					/* is_vendor; */
            }
            else
            {
                sqlCmd.Parameters[38].Value = System.DBNull.Value;																/* is_vendor; */
            }
            sqlCmd.Parameters[45].Value = txtComments.Text;																/* comment; */
//            sqlCmd.Parameters[46].Value = System.DBNull.Value;																/* credit_amt; */

            if (dlColodee.SelectedIndex > 0)
            {
                sqlCmd.Parameters[49].Value = this.dlColodee.SelectedValue;														/* colodee_elt_acct; */
            }
            else
            {
                sqlCmd.Parameters[49].Value = System.DBNull.Value;												/* colodee_elt_acct; */
            }
            sqlCmd.Parameters[34].Value = this.txtBrokerInfo.Text;																/* broker_info */

            Con.Open();
            SqlTransaction trans = Con.BeginTransaction();
            sqlCmd.Transaction = trans;

            try
            {
                int i = sqlCmd.ExecuteNonQuery();
                trans.Commit();
            }
            catch (Exception ex)
            {
                trans.Rollback();
                lblError.Text = ex.Message;
                Con.Close();
                return false;
            }
            finally
            {
                Con.Close();
            }

            return true;

        }

        private int PerformPickAccountNumber()
        {
            int i = 0;

            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            try
            {
                Con.Open();
                Cmd.CommandText = "select max(org_account_number) as org_account_number from organization where elt_account_number = " + elt_account_number;
                SqlDataReader reader = Cmd.ExecuteReader();

                if (reader.Read())
                {
                    string strI = reader["org_account_number"].ToString();
                    if (strI != "")
                    {
                        //qry2 = strI;

                        i = int.Parse(strI);
                    }
                }
                else
                {
                    lblError.Text = "Error was occured - ( Account Number Creation Error )";
                }

                reader.Close();
            }
            catch (Exception ex)
            {
                lblError.Text = "Error was occured - ( Account Number Creation Error ) <br/> ";
                lblError.Text += ex.Message;
                Con.Close();
                return -1;
            }
            finally
            {
                i++;
            }

            try
            {
                Cmd.CommandText = "insert into organization ( elt_account_number,org_account_number ) VALUES ( " + elt_account_number + ", " + i.ToString() + ")";
                if (Cmd.ExecuteNonQuery() == 0)
                {
                    lblError.Text = "Error was occured - ( Account Number Creation Error )";
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Error was occured - ( Account Number Creation Error ) <br/> ";
                lblError.Text += ex.Message;
                return -1;
            }
            finally
            {

            }

            //// insert into enque table

            //string strSessionID = Session.SessionID.ToString();
            //try
            //{
            //    Cmd.CommandText = "insert into ig_org_que ( sessionid,EmailItemID,org_account_number ) VALUES ( '" + strSessionID + "'," + EmailItemID + "," + i.ToString() + ")";
            //    if (Cmd.ExecuteNonQuery() == 0)
            //    {
            //        lblError.Text = "Error was occured - ( Account Number Creation Error )";
            //    }
            //}
            //catch (Exception ex)
            //{
            //    lblError.Text = "Error was occured - ( Account Number Creation Error ) <br/> ";
            //    lblError.Text += ex.Message;
            //    return -1;
            //}
            //finally
            //{
            //    Con.Close();
            //}


            return i;
        }

        private void PerformBack()
        {
            int a = int.Parse(ViewState["Count"].ToString());
            string script = "<script language='javascript'>";

            script += "if(history.length >= " + a.ToString() + ")";
            script += "{ history.go(-" + a.ToString() + "); }";
            script += "else{location.replace('AirExportOperationSelection.aspx')}";
            script += "</script>";
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "Pre", script);
        }

        private void PerformNew()
        {

            lblError.Text = "";
            ViewState["iPickedAccountNumber"] = "-1";
            txtAccountNumber.Text = "";
            PerformMode(0, true);
            lblTask.Text = "New";
            txtDBA.Text = "";
            txtBName.Text = "";
            txtTAXID.Text = "";
            txtBAdress.Text = "";
            txtBCity.Text = "";
            dlState.SelectedIndex = 0;
            dlCountry.SelectedIndex = 0;
            txtBZIP.Text = "";
            txtBPhone.Text = "";
            txtBFax.Text = "";
            txtBURL.Text = "";
            txtBCLName.Text = "";
            txtBCFName.Text = "";
            txtBCMName.Text = "";
            txtCAddress.Text = "";
            txtz_attn_txt.Text = "";
            txtCCity.Text = "";
            dlState2.SelectedIndex = 0;
            txtBCZIP.Text = "";
            dlCountry2.SelectedIndex = 0;
            txtCPhone.Text = "";
            txtCEmail.Text = "";

            chkShipper.Checked = false;
            chkForwarder.Checked = false;
            chkTrucker.Checked = false;
            chkSpecial.Checked = false;
            chkCarrier.Checked = false;
            chkConsignee.Checked = false;
            chkBroker.Checked = false;
            chkCFS.Checked = false;
            chkGovt.Checked = false;
            chkActivate.Checked = true;
            chkCopy.Checked = false;
            chkEDT.Checked = false;
            chkColodee.Checked = false;

            chkWarehousing.Text = "";
            txtBond.Text = "";
            txtInvoiceTerm.Text = "";
            txtExpDate.Text = "";
            txtBondAmount.Text = "";
            txtCreditAmount.Text = "";
            txtSurety.Text = "";
            txtBankName.Text = "";
            txtBankAccountNo.Text = "";
            txtCHLNo.Text = "";
            txtFirmsCode.Text = "";
            txtFirmsCode.Text = "";
            txtOceanSCAC.Text = "";
            txtAirLineCode.Text = "";
            txtCarrierPrefix.Text = "";
            txtAgent_elt_acct.Text = "";
            txtComments.Text = "";
            txtBrokerInfo.Text = "";
        }

        private void view_waiting()
        {
            Response.Buffer = true;
            Response.Write("<table id='waiting' height='50' style='position:absolute; visibility:hidden'> ");
            Response.Write("<tr><td align=center width=400 style='font-size:9pt; background:#d6d3ce;'> ");
            Response.Write("<b>Please wait...</b> ");
            Response.Write("</td></tr></table> ");

            Response.Write("<script language='Javascript'> ");
            Response.Write("waiting.style.visibility='visible' ");
            Response.Write("</script>");
        }

        private void hide_waiting()
        {
            Response.Write("<script language='Javascript'> ");
            Response.Write("waiting.style.visibility='hidden' ");
            Response.Write("</script>");


        }
        private void PerformSelectionDataBinding()
        {

            #region // Set Unite State
            for (int i = 0; i < 53; i++)
            {
                dlState.Items.Add("");
            }
            dlState.Items[0].Value = "  "; dlState.Items[0].Text = "                  ";
            dlState.Items[1].Value = "OT"; dlState.Items[1].Text = "Other Country";
            dlState.Items[2].Value = "AK"; dlState.Items[2].Text = "Alaska";
            dlState.Items[3].Value = "AL"; dlState.Items[3].Text = "Alabama";
            dlState.Items[4].Value = "AR"; dlState.Items[4].Text = "Arkansas";
            dlState.Items[5].Value = "AZ"; dlState.Items[5].Text = "Arizona";
            dlState.Items[6].Value = "CA"; dlState.Items[6].Text = "California";
            dlState.Items[7].Value = "CO"; dlState.Items[7].Text = "Colorado";
            dlState.Items[8].Value = "CT"; dlState.Items[8].Text = "Connecticut";
            dlState.Items[9].Value = "DC"; dlState.Items[9].Text = "DC";
            dlState.Items[10].Value = "DE"; dlState.Items[10].Text = "Delaware";
            dlState.Items[11].Value = "FL"; dlState.Items[11].Text = "Florida";
            dlState.Items[12].Value = "GA"; dlState.Items[12].Text = "Georgia";
            dlState.Items[13].Value = "HI"; dlState.Items[13].Text = "Hawaii";
            dlState.Items[14].Value = "IA"; dlState.Items[14].Text = "Iowa";
            dlState.Items[15].Value = "ID"; dlState.Items[15].Text = "Idaho";
            dlState.Items[16].Value = "IL"; dlState.Items[16].Text = "Illinois";
            dlState.Items[17].Value = "IN"; dlState.Items[17].Text = "Indiana";
            dlState.Items[18].Value = "KS"; dlState.Items[18].Text = "Kansas";
            dlState.Items[19].Value = "KY"; dlState.Items[19].Text = "Kentucky";
            dlState.Items[20].Value = "LA"; dlState.Items[20].Text = "Louisiana";
            dlState.Items[21].Value = "MA"; dlState.Items[21].Text = "Massachusetts";
            dlState.Items[22].Value = "MD"; dlState.Items[22].Text = "Maryland";
            dlState.Items[23].Value = "ME"; dlState.Items[23].Text = "Maine";
            dlState.Items[24].Value = "MI"; dlState.Items[24].Text = "Michigan";
            dlState.Items[25].Value = "MN"; dlState.Items[25].Text = "Minnesota";
            dlState.Items[26].Value = "MO"; dlState.Items[26].Text = "Missouri";
            dlState.Items[27].Value = "MS"; dlState.Items[27].Text = "Mississippi";
            dlState.Items[28].Value = "MT"; dlState.Items[28].Text = "Montana";
            dlState.Items[29].Value = "NC"; dlState.Items[29].Text = "North Carolina";
            dlState.Items[30].Value = "ND"; dlState.Items[30].Text = "North Dakota";
            dlState.Items[31].Value = "NE"; dlState.Items[31].Text = "Nebraska";
            dlState.Items[32].Value = "NH"; dlState.Items[32].Text = "New Hampshire";
            dlState.Items[33].Value = "NJ"; dlState.Items[33].Text = "New Jersey";
            dlState.Items[34].Value = "NM"; dlState.Items[34].Text = "New Mexico";
            dlState.Items[35].Value = "NV"; dlState.Items[35].Text = "Nevada";
            dlState.Items[36].Value = "NY"; dlState.Items[36].Text = "New York";
            dlState.Items[37].Value = "OH"; dlState.Items[37].Text = "Ohio";
            dlState.Items[38].Value = "OK"; dlState.Items[38].Text = "Oklahoma";
            dlState.Items[39].Value = "OR"; dlState.Items[39].Text = "Oregon";
            dlState.Items[40].Value = "PA"; dlState.Items[40].Text = "Pennsylvania";
            dlState.Items[41].Value = "RI"; dlState.Items[41].Text = "Rhode Island";
            dlState.Items[42].Value = "SC"; dlState.Items[42].Text = "South Carolina";
            dlState.Items[43].Value = "SD"; dlState.Items[43].Text = "South Dakota";
            dlState.Items[44].Value = "TN"; dlState.Items[44].Text = "Tennessee";
            dlState.Items[45].Value = "TX"; dlState.Items[45].Text = "Texas";
            dlState.Items[46].Value = "UT"; dlState.Items[46].Text = "Utah";
            dlState.Items[47].Value = "VA"; dlState.Items[47].Text = "Virginia";
            dlState.Items[48].Value = "VT"; dlState.Items[48].Text = "Vermont";
            dlState.Items[49].Value = "WA"; dlState.Items[49].Text = "Washington";
            dlState.Items[50].Value = "WI"; dlState.Items[50].Text = "Wisconsin";
            dlState.Items[51].Value = "WV"; dlState.Items[51].Text = "West Virginia";
            dlState.Items[52].Value = "WY"; dlState.Items[52].Text = "Wyoming";

            dlState.SelectedIndex = 0;
            #endregion
            #region // Set Unite State2
            for (int i = 0; i < 53; i++)
            {
                dlState2.Items.Add("");
            }
            dlState2.Items[0].Value = "  "; dlState2.Items[0].Text = "                  ";
            dlState2.Items[1].Value = "OT"; dlState2.Items[1].Text = "Other Country";
            dlState2.Items[2].Value = "AK"; dlState2.Items[2].Text = "Alaska";
            dlState2.Items[3].Value = "AL"; dlState2.Items[3].Text = "Alabama";
            dlState2.Items[4].Value = "AR"; dlState2.Items[4].Text = "Arkansas";
            dlState2.Items[5].Value = "AZ"; dlState2.Items[5].Text = "Arizona";
            dlState2.Items[6].Value = "CA"; dlState2.Items[6].Text = "California";
            dlState2.Items[7].Value = "CO"; dlState2.Items[7].Text = "Colorado";
            dlState2.Items[8].Value = "CT"; dlState2.Items[8].Text = "Connecticut";
            dlState2.Items[9].Value = "DC"; dlState2.Items[9].Text = "DC";
            dlState2.Items[10].Value = "DE"; dlState2.Items[10].Text = "Delaware";
            dlState2.Items[11].Value = "FL"; dlState2.Items[11].Text = "Florida";
            dlState2.Items[12].Value = "GA"; dlState2.Items[12].Text = "Georgia";
            dlState2.Items[13].Value = "HI"; dlState2.Items[13].Text = "Hawaii";
            dlState2.Items[14].Value = "IA"; dlState2.Items[14].Text = "Iowa";
            dlState2.Items[15].Value = "ID"; dlState2.Items[15].Text = "Idaho";
            dlState2.Items[16].Value = "IL"; dlState2.Items[16].Text = "Illinois";
            dlState2.Items[17].Value = "IN"; dlState2.Items[17].Text = "Indiana";
            dlState2.Items[18].Value = "KS"; dlState2.Items[18].Text = "Kansas";
            dlState2.Items[19].Value = "KY"; dlState2.Items[19].Text = "Kentucky";
            dlState2.Items[20].Value = "LA"; dlState2.Items[20].Text = "Louisiana";
            dlState2.Items[21].Value = "MA"; dlState2.Items[21].Text = "Massachusetts";
            dlState2.Items[22].Value = "MD"; dlState2.Items[22].Text = "Maryland";
            dlState2.Items[23].Value = "ME"; dlState2.Items[23].Text = "Maine";
            dlState2.Items[24].Value = "MI"; dlState2.Items[24].Text = "Michigan";
            dlState2.Items[25].Value = "MN"; dlState2.Items[25].Text = "Minnesota";
            dlState2.Items[26].Value = "MO"; dlState2.Items[26].Text = "Missouri";
            dlState2.Items[27].Value = "MS"; dlState2.Items[27].Text = "Mississippi";
            dlState2.Items[28].Value = "MT"; dlState2.Items[28].Text = "Montana";
            dlState2.Items[29].Value = "NC"; dlState2.Items[29].Text = "North Carolina";
            dlState2.Items[30].Value = "ND"; dlState2.Items[30].Text = "North Dakota";
            dlState2.Items[31].Value = "NE"; dlState2.Items[31].Text = "Nebraska";
            dlState2.Items[32].Value = "NH"; dlState2.Items[32].Text = "New Hampshire";
            dlState2.Items[33].Value = "NJ"; dlState2.Items[33].Text = "New Jersey";
            dlState2.Items[34].Value = "NM"; dlState2.Items[34].Text = "New Mexico";
            dlState2.Items[35].Value = "NV"; dlState2.Items[35].Text = "Nevada";
            dlState2.Items[36].Value = "NY"; dlState2.Items[36].Text = "New York";
            dlState2.Items[37].Value = "OH"; dlState2.Items[37].Text = "Ohio";
            dlState2.Items[38].Value = "OK"; dlState2.Items[38].Text = "Oklahoma";
            dlState2.Items[39].Value = "OR"; dlState2.Items[39].Text = "Oregon";
            dlState2.Items[40].Value = "PA"; dlState2.Items[40].Text = "Pennsylvania";
            dlState2.Items[41].Value = "RI"; dlState2.Items[41].Text = "Rhode Island";
            dlState2.Items[42].Value = "SC"; dlState2.Items[42].Text = "South Carolina";
            dlState2.Items[43].Value = "SD"; dlState2.Items[43].Text = "South Dakota";
            dlState2.Items[44].Value = "TN"; dlState2.Items[44].Text = "Tennessee";
            dlState2.Items[45].Value = "TX"; dlState2.Items[45].Text = "Texas";
            dlState2.Items[46].Value = "UT"; dlState2.Items[46].Text = "Utah";
            dlState2.Items[47].Value = "VA"; dlState2.Items[47].Text = "Virginia";
            dlState2.Items[48].Value = "VT"; dlState2.Items[48].Text = "Vermont";
            dlState2.Items[49].Value = "WA"; dlState2.Items[49].Text = "Washington";
            dlState2.Items[50].Value = "WI"; dlState2.Items[50].Text = "Wisconsin";
            dlState2.Items[51].Value = "WV"; dlState2.Items[51].Text = "West Virginia";
            dlState2.Items[52].Value = "WY"; dlState2.Items[52].Text = "Wyoming";
            dlState2.SelectedIndex = 0;
            #endregion

            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmdCry = new SqlCommand("select * from country_code where elt_account_number=" + elt_account_number.ToString() + " order by country_name", Con);
            SqlCommand cmdDBA = new SqlCommand("select org_account_number,dba_name from organization where elt_account_number = " + elt_account_number + " and dba_name <> '' order by dba_name", Con);

            SqlDataAdapter Adap = new SqlDataAdapter();
            DataSet ds = new DataSet();

            Con.Open();

            Adap.SelectCommand = cmdCry;
            Adap.Fill(ds, "Country");

            Adap.SelectCommand = cmdDBA;
            Adap.Fill(ds, "DBA");

            Con.Close();

            dlCountry.DataSource = ds.Tables["Country"];
            dlCountry.DataTextField = ds.Tables["Country"].Columns["country_name"].ToString();
            dlCountry.DataValueField = ds.Tables["Country"].Columns["country_code"].ToString();
            dlCountry.DataBind();
            dlCountry.Items.Insert(0, "  ");
            dlCountry.SelectedIndex = 0;

            dlCountry2.DataSource = ds.Tables["Country"];
            dlCountry2.DataTextField = ds.Tables["Country"].Columns["country_name"].ToString();
            dlCountry2.DataValueField = ds.Tables["Country"].Columns["country_code"].ToString();
            dlCountry2.DataBind();
            dlCountry2.Items.Insert(0, "  ");
            dlCountry2.SelectedIndex = 0;

            ComboSearchKey.DataSource = ds.Tables["DBA"];
            ComboSearchKey.DataTextField = ds.Tables["DBA"].Columns["dba_name"].ToString();
            ComboSearchKey.DataValueField = ds.Tables["DBA"].Columns["org_account_number"].ToString();
            ComboSearchKey.DataBind();
            ComboSearchKey.Items.Insert(0, "");
            ComboSearchKey.SelectedIndex = 0;

        }

        protected void btnSave_Click(object sender, System.EventArgs e)
        {


            int iPickedAccountNumber = int.Parse(ViewState["iPickedAccountNumber"].ToString());

            if (iPickedAccountNumber < 0)
            {
                int i = PerformPickAccountNumber();
                if (i > 0)
                {
                    ViewState["iPickedAccountNumber"] = i;
                    iPickedAccountNumber = i;
                    lblError.Text = "Now you are working with Temp.No.:" + "*" + ViewState["iPickedAccountNumber"];
                    qry2 = this.lblAccountNo.Text = " * Temp # " + ViewState["iPickedAccountNumber"];
                    this.txtAccountNumber.Text = ViewState["iPickedAccountNumber"].ToString();
                }
                else
                {
                    Response.Write("<script language= 'javascript'> alert('Number creation error!'); </script>");
                }
            }

            // 


            lblError.Text = "";
            lblAccountNo.Text = "";
            if (PerformSave(false))
            {
                PerformDataEdit();

                lblError.Text = txtDBA.Text + " was saved successfully.";


                string sUrl = "/IFF_MAIN/ASPX/OnLines/CompanyConfig/CompanyConfigCreate.aspx?number=" + txtAccountNumber.Text;
                PerformRecentDB(sUrl, txtAccountNumber.Text, "Save client profile of " + txtDBA.Text, "MD->Cli.Profile");
                performReloadCombo();
            }

        }

        private void performReloadCombo()
        {
            ComboSearchKey.Items.Clear();
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmdDBA = new SqlCommand("select org_account_number,dba_name from organization where elt_account_number = " + elt_account_number + " and dba_name <> '' order by dba_name", Con);

            SqlDataAdapter Adap = new SqlDataAdapter();
            DataSet ds = new DataSet();

            Con.Open();

            Adap.SelectCommand = cmdDBA;
            Adap.Fill(ds, "DBA");

            Con.Close();

            ComboSearchKey.DataSource = ds.Tables["DBA"];
            ComboSearchKey.DataTextField = ds.Tables["DBA"].Columns["dba_name"].ToString();
            ComboSearchKey.DataValueField = ds.Tables["DBA"].Columns["org_account_number"].ToString();
            ComboSearchKey.DataBind();
            ComboSearchKey.Items.Insert(0, "");
            ComboSearchKey.SelectedIndex = 0;
            PerformSelectionDataBindingColo();
        }
               

        //private void PerformRecent(string sURL,string DocNum)
        //{
        //    string[] myArr = new string[51];
        //    string[] newArr = new string[51];
        //    string tmpLogDir = Request.Cookies["CurrentUserInfo"]["temp_path"];
        //    string strFilePath = tmpLogDir+"/"+EmailItemID+user_id+ ".txt";
        //    const int RCNT = 51;

        //    if (!File.Exists(strFilePath)) 
        //    {
        //        FileInfo cFile = new FileInfo(strFilePath);
        //        StreamWriter cf = cFile.CreateText();
        //        cf.WriteLine(" ");
        //        cf.Close();
        //    }

        //    StreamReader rf = File.OpenText(strFilePath);
        //    string line;
        //    int iCnt = 0;
        //    while ((line=rf.ReadLine())!= null && iCnt < (RCNT-1)) 
        //    {
        //        myArr[iCnt] = line;
        //        iCnt++;
        //    }
        //    rf.Close();

        //    for (int i=0;i<iCnt;i++)
        //    {
        //        newArr[i+1] = myArr[i];
        //    }

        //    newArr[0] =  DateTime.Now.ToString() + "^" + DocNum + "^" + sURL;
        //    FileInfo wFile = new FileInfo(strFilePath);
        //    StreamWriter wf = wFile.CreateText();
        //    for (int i=0;i<iCnt;i++)
        //    {
        //        wf.WriteLine(newArr[i]);
        //    }
        //    wf.Close();	

        //}

        private void PerformRecentDB(string sURL, string DocNum, string WorkDetail, string strSoTitle)
        {
            WorkDetail = WorkDetail.Replace("'", "''");
            string SQL = "insert INTO Recent_Work ( elt_account_number, user_id, workdate, title, docnum, surl, workdetail,remark,status ) ";
            SQL =
            SQL + " VALUES (" + elt_account_number + ", '" + user_id + "', '" + getDateTime() + "', '" + strSoTitle + "','" + DocNum + "' ,'" + sURL + "' ,'" + WorkDetail + "','','')";

            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmdRecent = new SqlCommand();
            cmdRecent.Connection = Con;
            Con.Open();
            cmdRecent.CommandText = SQL;
            cmdRecent.ExecuteNonQuery();
            Con.Close();
        }

        private string getDateTime()
        {
            string strDateTime = "";
            string strDate = getTodaySQL();
            string strTime = getTimeSQL();

            strDateTime = strDate.Substring(4, 2) + "/" + strDate.Substring(6, 2) + "/" + strDate.Substring(0, 4);
            strDateTime = strDateTime + " " + strTime.Substring(0, 2) + ":" + strTime.Substring(2, 2) + ":" + strTime.Substring(4, 2);

            return strDateTime;
        }

        private string getTimeSQL()
        {
            string strTime = "";

            if (DateTime.Now.Hour.ToString().Length == 1)
            {
                strTime = strTime + "0" + DateTime.Now.Hour.ToString();
            }
            else
            {
                strTime = strTime + DateTime.Now.Hour.ToString();
            }

            if (DateTime.Now.Minute.ToString().Length == 1)
            {
                strTime = strTime + "0" + DateTime.Now.Minute.ToString();
            }
            else
            {
                strTime = strTime + DateTime.Now.Minute.ToString();
            }

            if (DateTime.Now.Second.ToString().Length == 1)
            {
                strTime = strTime + "0" + DateTime.Now.Second.ToString();
            }
            else
            {
                strTime = strTime + DateTime.Now.Second.ToString();
            }

            return strTime;
        }

        private string getTodaySQL()
        {
            string strDate = "";
            strDate = DateTime.Now.Year.ToString();

            if (DateTime.Now.Month.ToString().Length == 1)
            {
                strDate = strDate + "0" + DateTime.Now.Month.ToString();
            }
            else
            {
                strDate = strDate + DateTime.Now.Month.ToString();
            }

            if (DateTime.Now.Day.ToString().Length == 1)
            {
                strDate = strDate + "0" + DateTime.Now.Day.ToString();
            }
            else
            {
                strDate = strDate + DateTime.Now.Day.ToString();
            }

            return strDate;
        }

        protected void btnNew_Click(object sender, System.EventArgs e)
        {
            PerformNew();
        }

        protected void btnBack_Click(object sender, System.EventArgs e)
        {
            PerformBack();
        }

        protected void btnCancel_Click(object sender, System.EventArgs e)
        {

            if (lblTask.Text == "Edit")
            {
                int i = int.Parse(txtAccountNumber.Text);
                PerformDataShow();
                PerformMode(3, true);
            }
            if (lblTask.Text == "Create")
            {
                lblError.Text = "";
                PerformMode(0, true);
            }
        }

        protected void btnShow_Click(object sender, System.EventArgs e)
        {
            PerformDataEdit();
        }

        private void PerformDataEdit()
        {
            int i = int.Parse(txtAccountNumber.Text);
            ViewState["iPickedAccountNumber"] = txtAccountNumber.Text;
            lblError.Text = "";
            lblTask.Text = "Edit";
            lblAccountNo.Text = "";
            PerformDataShow();
            PerformMode(3, true);

        }

        private void PerformDataShow()
        {

            ConnectStr = (new igFunctions.DB().getConStr());
            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand Cmd = new SqlCommand();
            Cmd.Connection = Con;

            Con.Open();

            Cmd.CommandText = " SELECT * FROM organization "
                + " WHERE elt_account_number=" + elt_account_number + " AND org_account_number = '" + txtAccountNumber.Text + "'";

            SqlDataReader reader = Cmd.ExecuteReader();

            if (reader.Read())
            {
                PerformFillData(reader);
            }
            else
            {
                lblError.Text = "Data was not found.";
            }

            reader.Close();

            Con.Close();

        }

        private void PerformFillData(SqlDataReader Reader)
        {

            dlCountry.SelectedValue = PerformConvertCountryName(dlCountry, Reader["b_country_code"].ToString());
            dlCountry2.SelectedValue = PerformConvertCountryName(dlCountry, Reader["owner_mail_country"].ToString());
            dlState.SelectedValue = PerformConvertStateName(dlState, Reader["business_state"].ToString());
            dlState2.SelectedValue = PerformConvertStateName(dlState, Reader["owner_mail_state"].ToString());

            txtDBA.Text = Reader["dba_name"].ToString();
            txtBName.Text = Reader["business_legal_name"].ToString();
            txtTAXID.Text = Reader["business_fed_taxid"].ToString();
            txtBAdress.Text = Reader["business_address"].ToString();
            txtBCity.Text = Reader["business_city"].ToString();
            txtBZIP.Text = Reader["business_zip"].ToString();

            txtBPhone.Text = Reader["business_phone"].ToString();
            txtBFax.Text = Reader["business_fax"].ToString();
            txtCPhone.Text = Reader["owner_phone"].ToString();

            txtBURL.Text = Reader["business_url"].ToString();
            txtBCLName.Text = Reader["owner_lname"].ToString();
            txtBCFName.Text = Reader["owner_fname"].ToString();
            txtBCMName.Text = Reader["owner_mname"].ToString();
            txtCAddress.Text = Reader["owner_mail_address"].ToString();
            txtz_attn_txt.Text = Reader["z_attn_txt"].ToString();
            txtCCity.Text = Reader["owner_mail_city"].ToString();

            txtBCZIP.Text = Reader["owner_mail_zip"].ToString();
            txtCEmail.Text = Reader["owner_email"].ToString();
            chkShipper.Checked = (Reader["is_shipper"].ToString() == "Y" ? true : false);
            chkConsignee.Checked = (Reader["is_consignee"].ToString() == "Y" ? true : false);
            chkForwarder.Checked = (Reader["is_agent"].ToString() == "Y" ? true : false);
            chkCarrier.Checked = (Reader["is_carrier"].ToString() == "Y" ? true : false);
            chkTrucker.Checked = (Reader["z_is_trucker"].ToString() == "Y" ? true : false);
            chkSpecial.Checked = (Reader["z_is_special"].ToString() == "Y" ? true : false);
            chkBroker.Checked = (Reader["z_is_broker"].ToString() == "Y" ? true : false);
            chkWarehousing.Checked = (Reader["z_is_warehousing"].ToString() == "Y" ? true : false);
            chkCFS.Checked = (Reader["z_is_cfs"].ToString() == "Y" ? true : false);
            chkGovt.Checked = (Reader["z_is_govt"].ToString() == "Y" ? true : false);

            txtBond.Text = Reader["z_bond_number"].ToString();
            txtInvoiceTerm.Text = Reader["bill_term"].ToString();

            txtAgent_elt_acct.Text = Reader["agent_elt_acct"].ToString();
            if (txtAgent_elt_acct.Text.Trim() == "0")
            {
                txtAgent_elt_acct.Text = "";
            }
            if (Reader["z_bond_exp_date"] != null && Reader["z_bond_exp_date"].ToString().Trim() != "")
            {
                txtExpDate.Text = DateTime.Parse(Reader["z_bond_exp_date"].ToString()).ToShortDateString();
            }
            else
            {
                txtExpDate.Text = "";
            }
            txtBondAmount.Text = Reader["z_bond_amount"].ToString();
            txtCreditAmount.Text = Reader["credit_amt"].ToString();

            txtSurety.Text = Reader["z_bond_surety"].ToString();
            txtBankName.Text = Reader["z_bank_name"].ToString();
            txtBankAccountNo.Text = Reader["z_bank_account_no"].ToString();
            txtCHLNo.Text = Reader["z_chl_no"].ToString().Trim();
            txtFirmsCode.Text = Reader["z_firm_code"].ToString().Trim();

            txtCarrierPrefix.Text = Reader["carrier_code"].ToString().Trim();
            txtOceanSCAC.Text = Reader["carrier_id"].ToString().Trim();
            txtAirLineCode.Text = Reader["carrier_id"].ToString().Trim();

            if (txtCarrierPrefix.Text != "")
            {
                txtOceanSCAC.Text = "";
            }
            else
            {
                txtAirLineCode.Text = "";
            }

            chkActivate.Checked = (Reader["account_status"].ToString() == "A" ? true : false);
            chkEDT.Checked = (Reader["edt"].ToString() == "Y" ? true : false);
            chkColodee.Checked = (Reader["is_colodee"].ToString() == "Y" ? true : false);

            if (Reader["colodee_elt_acct"] != null)
            {
                if (dlColodee.Items.FindByValue(Reader["colodee_elt_acct"].ToString()) != null)
                {
                    dlColodee.SelectedValue = Reader["colodee_elt_acct"].ToString();
                }
            }

            txtComments.Text = Reader["comment"].ToString().Trim();

            for (int i = 0; i < this.ddlSalesPerson.Items.Count; i++)
            {
                if (ddlSalesPerson.Items[i].Value == Reader["SalesPerson"].ToString().Trim())
                {
                    ddlSalesPerson.SelectedIndex = i;
                }
            }

            txtBrokerInfo.Text = Reader["broker_info"].ToString().Trim();

        }

        private string performMaskDelete(string p)
        {
            return p.Replace("(", "").Replace(")", "").Replace("-", "");
        }

        private string PerformConverTruckerConType(DropDownList dl, string strFclName)
        {
            string tmpStr = strFclName;
            //		switch(strFclName) 
            //		{
            //			default:
            //				tmpStr = ""; break;
            //		}

            ListItem crItem = dl.Items.FindByValue(tmpStr.ToUpper());
            if (crItem == null) tmpStr = "";
            return tmpStr;

        }

        private string PerformConvertStateName(DropDownList dl, string strOldStateName)
        {
            string tmpStr = strOldStateName;
            ListItem crItem;
            //			switch(tmpStr) 
            //			{
            //				default:
            //					tmpStr = "                  "; break;
            //			}

            crItem = dl.Items.FindByText(tmpStr);
            if (crItem == null)
            {
                crItem = dl.Items.FindByValue(tmpStr.ToUpper());
                if (crItem != null) tmpStr = crItem.Value;
            }

            if (crItem == null) tmpStr = "  ";

            return tmpStr;

        }

        private string PerformConvertCountryName(DropDownList dl, string strOldCountryName)
        {
            string tmpStr = strOldCountryName;
            switch (tmpStr)
            {
                case "USA":
                    tmpStr = "US"; break;
                case "US":
                    tmpStr = "US"; break;
                case "UNITED STATES":
                    tmpStr = "US"; break;
                case "U.S.A.":
                    tmpStr = "US"; break;
                case "MALAYSIA":
                    tmpStr = "MY"; break;
                case "INDONESIA":
                    tmpStr = "ID"; break;
                case "KOREA":
                    tmpStr = "KR"; break;
                case "KO":
                    tmpStr = "KR"; break;
                case "BRAZIL":
                    tmpStr = "BR"; break;
                case "CHINA":
                    tmpStr = "CN"; break;
                case "CANADA":
                    tmpStr = "CA"; break;
                case "HONG KONG":
                    tmpStr = "HK"; break;
                case "PHILIPPINES":
                    tmpStr = "PH"; break;
                default:
                    tmpStr = strOldCountryName; break;
            }

            ListItem crItem = dl.Items.FindByValue(tmpStr);
            if (crItem == null) tmpStr = "  ";
            return tmpStr;

        }

        protected void btnEdit_Click(object sender, System.EventArgs e)
        {
            PerformMode(3, true);
        }

        private void PerformMode(int mode, bool scrn)
        {
            strMode = mode.ToString();
        }

        protected void btnDelete_Click(object sender, System.EventArgs e)
        {
            string tmpTest = txtDBA.Text;
            int iPickedAccountNumber = int.Parse(ViewState["iPickedAccountNumber"].ToString());
            if (iPickedAccountNumber < 0) return;
            if (PerformDelete(iPickedAccountNumber))
            {
                PerformNew();
                lblError.Text = tmpTest + " was deleted successfully.";

                performReloadCombo();
            }
        }
        private bool PerformResetColo(int iPickedAccountNumber)
        {

            string strDelete = @" DELETE colo where colodee_org_num =" + iPickedAccountNumber.ToString() + " AND coloder_elt_acct =" + elt_account_number;

            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand cmdColo = new SqlCommand();
            cmdColo.Connection = Con;

            Con.Open();

            SqlTransaction trans = Con.BeginTransaction();

            cmdColo.Transaction = trans;

            try
            {
                cmdColo.CommandText = strDelete;
                cmdColo.ExecuteNonQuery();
                trans.Commit();
            }
            catch (Exception ex)
            {
                trans.Rollback();
                lblError.Text = ex.Message;
                Con.Close();
            }
            finally
            {
                Con.Close();
            }

            return true;

        }
        private bool PerformDelete(int iPickedAccountNumber)
        {
            PerformResetColo(iPickedAccountNumber);

            SqlConnection Con = new SqlConnection(ConnectStr);
            SqlCommand sqlCmd = new SqlCommand("dbo.ig_up_organization_delete", Con);
            sqlCmd.CommandType = CommandType.StoredProcedure;

            sqlCmd.Parameters.Add("@elt_account_number", SqlDbType.Decimal, 9);
            sqlCmd.Parameters.Add("@org_account_number", SqlDbType.Decimal, 9);

            sqlCmd.Parameters[0].Value = elt_account_number;																		/* EmailItemID */
            sqlCmd.Parameters[1].Value = iPickedAccountNumber.ToString();													/* org_account_number */

            Con.Open();
            SqlTransaction trans = Con.BeginTransaction();
            sqlCmd.Transaction = trans;

            try
            {
                int a = sqlCmd.ExecuteNonQuery();
                if (a < 1)
                {
                    lblError.Text = "Data not found!";
                    Con.Close();
                    return false;
                }
                trans.Commit();
            }
            catch (Exception ex)
            {
                trans.Rollback();
                lblError.Text = ex.Message;
                Con.Close();
                return false;
            }
            finally
            {
                Con.Close();
            }

            return true;

        }
                
        protected void btnSaveNew_Click(object sender, System.EventArgs e)
        {
            int iPickedAccountNumber = 0;

            int i = PerformPickAccountNumber();
            if (i > 0)
            {
                ViewState["iPickedAccountNumber"] = i;
                iPickedAccountNumber = i;
                lblError.Text = "Now you are working with Temp.No.:" + "*" + ViewState["iPickedAccountNumber"];
                this.lblAccountNo.Text = " * Temp # " + ViewState["iPickedAccountNumber"];
                this.txtAccountNumber.Text = ViewState["iPickedAccountNumber"].ToString();
            }
            else
            {
                Response.Write("<script language= 'javascript'> alert('Number creation error!'); </script>");
            }


            lblError.Text = "";
            lblAccountNo.Text = "";
            if (PerformSave(true))
            {

                PerformDataEdit();

                lblError.Text = txtDBA.Text + " was saved successfully.";

                string sUrl = "/IFF_MAIN/ASPX/OnLines/CompanyConfig/CompanyConfigCreate.aspx?number=" + txtAccountNumber.Text;
                PerformRecentDB(sUrl, txtAccountNumber.Text, "Save client profile of " + txtDBA.Text, "MD->Cli.Profile");
                performReloadCombo();
            }
            else
            {
                string strSessionID = Session.SessionID.ToString();
                SqlConnection Con = new SqlConnection(ConnectStr);
                SqlCommand cmdDelete = new SqlCommand("", Con);
                Con.Open();
//              cmdDelete.ExecuteNonQuery();
                cmdDelete.CommandText = "delete from organization where elt_account_number=" + elt_account_number + " and org_account_number=" + iPickedAccountNumber.ToString();
                cmdDelete.ExecuteNonQuery();
                Con.Close();
            }


        }

        protected void btnPrint_Click(object sender, EventArgs e)
        {
            qry2 += ViewState["iPickedAccountNumber"];
            printClientProfile(qry1, qry2);
        }

        private void printClientProfile(string agentID, string clinetID)
        {

            string path = Request.ApplicationPath;
            path = path + "/ASP/master_data/clientProfile_pdf.asp?agent=" + agentID + "&client=" + clinetID;


            if (!qry1.Equals("") && !qry2.Equals("-1"))
            {
                Response.Write("<script language='javascript'> window.open ('" + path + "',  'mywin', 'height=700,width=600,left=150,top=100,resizable=yes,scrollbars=yes,toolbar=no,status=no')</script>");
            }
        }
        protected void Go_Click(object sender, EventArgs e)
        {

            PerformDataEdit();
            PerformSelectionDataBindingColo();

        }
        protected void ComboSearchKey_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtAccountNumber.Text = ComboSearchKey.SelectedValue;
            txtDBA.Text = ComboSearchKey.SelectedItem.Text;
            ComboSearchKey.SelectedIndex = -1;
            PerformDataEdit();
        }
    }

}
