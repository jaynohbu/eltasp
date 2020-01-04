using System;
using System.Web;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Reflection;
using ELT.COMMON;
using ELT.CDT;
namespace ELT.DA
{   
    public class ClientProfileDA:DABase
    {
        public void CreateNewClientFileFolder(string email)
        {

            string strInsert=SQLConstants.CreateNewClientFolder;

			SqlConnection Con = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
			SqlCommand		Cmd = new SqlCommand();
			Cmd.Connection = Con;
			Con.Open();

            try
            {
                Cmd.CommandText = strInsert;
                Cmd.Parameters.Clear();
                Cmd.Parameters.Add("@email", SqlDbType.VarChar, 100);
                Cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {

            }
            finally{

                Con.Close();
                Con.Dispose();                
            }

				                 
        }
        public List<ClientProfile> GetClientList(int elt_account_number)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.[GetClientList]" };
            List<ClientProfile> list = new List<ClientProfile>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@elt_account_number", elt_account_number));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        ClientProfile item = new ClientProfile() 
                        {
                            dba_name = Convert.ToString(reader["dba_name"]),
                            org_account_number = Convert.ToInt32(reader["org_account_number"]),
                            account_status = Convert.ToString(reader["account_status"]) ,
                            class_code = Convert.ToString(reader["class_code"]),
                            isFrequently = Convert.ToString(reader["isFrequently"]),
                            business_legal_name = Convert.ToString(reader["business_legal_name"]),
                            business_fed_taxid = Convert.ToString(reader["business_fed_taxid"]),
                            business_address = Convert.ToString(reader["business_address"]),
                            business_address2 = Convert.ToString(reader["business_address2"]),
                            business_address3 = Convert.ToString(reader["business_address3"]),
                            business_city = Convert.ToString(reader["business_city"]),
                            business_state = Convert.ToString(reader["business_state"]),
                            business_zip = Convert.ToString(reader["business_zip"]),
                            business_country = Convert.ToString(reader["business_country"]),
                            b_country_code = Convert.ToString(reader["b_country_code"]),
                            business_phone = Convert.ToString(reader["business_phone"]),
                            business_phone_ext = Convert.ToString(reader["business_phone_ext"]),
                            business_phone_mask = Convert.ToString(reader["business_phone_mask"]),
                            business_phone2 = Convert.ToString(reader["business_phone2"]),
                            business_phone2_ext = Convert.ToString(reader["business_phone2_ext"]),
                            business_phone2_mask = Convert.ToString(reader["business_phone2_mask"]),
                            business_fax = Convert.ToString(reader["business_fax"]),
                            business_fax_mask = Convert.ToString(reader["business_fax_mask"]),
                            business_url = Convert.ToString(reader["business_url"]),
                            web_login_id = Convert.ToString(reader["web_login_id"]),
                            web_login_pin = Convert.ToString(reader["web_login_pin"]),
                            owner_lname = Convert.ToString(reader["owner_lname"]),
                            owner_fname = Convert.ToString(reader["owner_fname"]),
                            owner_mname = Convert.ToString(reader["owner_mname"]),
                            owner_title = Convert.ToString(reader["owner_title"]),
                            owner_departm = Convert.ToString(reader["owner_departm"]),
                            owner_mail_address = Convert.ToString(reader["owner_mail_address"]),
                            owner_mail_address2 = Convert.ToString(reader["owner_mail_address2"]),
                            owner_mail_address3 = Convert.ToString(reader["owner_mail_address3"]),
                            owner_mail_city = Convert.ToString(reader["owner_mail_city"]),
                            owner_mail_state = Convert.ToString(reader["owner_mail_state"]),
                            owner_mail_zip = Convert.ToString(reader["owner_mail_zip"]),
                            owner_mail_country = Convert.ToString(reader["owner_mail_country"]),
                            owner_phone = Convert.ToString(reader["owner_phone"]),
                            owner_phone_mask = Convert.ToString(reader["owner_phone_mask"]),
                            owner_email = Convert.ToString(reader["owner_email"]),
                            attn_name = Convert.ToString(reader["attn_name"]),
                            notify_name = Convert.ToString(reader["notify_name"]),
                            agent_elt_acct = Convert.ToString(reader["agent_elt_acct"]),
                            edt = Convert.ToString(reader["edt"]),
                            iata_code = Convert.ToString(reader["iata_code"]),
                            carrier_code = Convert.ToString(reader["carrier_code"]),
                            carrier_id = Convert.ToString(reader["carrier_id"]),
                            carrier_type = Convert.ToString(reader["carrier_type"]),                         
                            comment = Convert.ToString(reader["comment"]),
                            comment2 = Convert.ToString(reader["comment2"]),
                            credit_amt = Convert.ToString(reader["credit_amt"]),
                            bill_term = Convert.ToString(reader["bill_term"]),
                            coloader_elt_acct = Convert.ToString(reader["coloader_elt_acct"]),
                            colodee_elt_acct_name = Convert.ToString(reader["colodee_elt_acct_name"]),
                            z_bond_number = Convert.ToString(reader["z_bond_number"]),
                            z_bond_exp_date = Convert.ToString(reader["z_bond_exp_date"]),
                            z_bond_amount = Convert.ToString(reader["z_bond_amount"]),
                            z_bond_surety = Convert.ToString(reader["z_bond_surety"]),
                            z_bank_name = Convert.ToString(reader["z_bank_name"]),
                            z_bank_account_no = Convert.ToString(reader["z_bank_account_no"]),
                            z_chl_no = Convert.ToString(reader["z_chl_no"]),
                            z_firm_code = Convert.ToString(reader["z_firm_code"]),
                            z_carrier_code = Convert.ToString(reader["z_carrier_code"]),
                            z_carrier_prefix = Convert.ToString(reader["z_carrier_prefix"]),
                            z_attn_txt = Convert.ToString(reader["z_attn_txt"]),
                            SalesPerson = Convert.ToString(reader["SalesPerson"]),
                            c2FirstName = Convert.ToString(reader["c2FirstName"]),
                            c2MiddleName = Convert.ToString(reader["c2MiddleName"]),
                            c2LastName = Convert.ToString(reader["c2LastName"]),
                            c2Title = Convert.ToString(reader["c2Title"]),
                            c2Phone = Convert.ToString(reader["c2Phone"]),
                            c2Ext = Convert.ToString(reader["c2Ext"]),
                            c2Phone_mask = Convert.ToString(reader["c2Phone_mask"]),
                            c2Cell = Convert.ToString(reader["c2Cell"]),
                            c2Cell_mask = Convert.ToString(reader["c2Cell_mask"]),
                            c2Fax = Convert.ToString(reader["c2Fax"]),
                            c2Fax_mask = Convert.ToString(reader["c2Fax_mask"]),
                            c2Email = Convert.ToString(reader["c2Email"]),
                            c3FirstName = Convert.ToString(reader["c3FirstName"]),
                            c3MiddleName = Convert.ToString(reader["c3MiddleName"]),
                            c3LastName = Convert.ToString(reader["c3LastName"]),
                            c3Title = Convert.ToString(reader["c3Title"]),
                            c3Phone = Convert.ToString(reader["c3Phone"]),
                            c3Phone_mask = Convert.ToString(reader["c3Phone_mask"]),
                            c3Ext = Convert.ToString(reader["c3Ext"]),
                            c3Cell = Convert.ToString(reader["c3Cell"]),
                            c3Cell_mask = Convert.ToString(reader["c3Cell_mask"]),
                            c3Fax = Convert.ToString(reader["c3Fax"]),
                            c3Fax_mask = Convert.ToString(reader["c3Fax_mask"]),
                            c3Email = Convert.ToString(reader["c3Email"]),
                            is_shipper = Convert.ToString(reader["is_shipper"]),
                            is_consignee = Convert.ToString(reader["is_consignee"]),
                            is_agent = Convert.ToString(reader["is_agent"]),
                            is_vendor = Convert.ToString(reader["is_vendor"]),
                            is_carrier = Convert.ToString(reader["is_carrier"]),
                            is_coloader = Convert.ToString(reader["is_coloader"]),
                            z_is_trucker = Convert.ToString(reader["z_is_trucker"]),
                            z_is_special = Convert.ToString(reader["z_is_special"]),
                            z_is_broker = Convert.ToString(reader["z_is_broker"]),
                            z_is_warehousing = Convert.ToString(reader["z_is_warehousing"]),
                            z_is_cfs = Convert.ToString(reader["z_is_cfs"]),
                            z_is_govt = Convert.ToString(reader["z_is_govt"]),
                            SubConsignee = Convert.ToString(reader["SubConsignee"]),
                            SubShipper = Convert.ToString(reader["SubShipper"]),
                            SubAgent = Convert.ToString(reader["SubAgent"]),
                            SubCarrier = Convert.ToString(reader["SubCarrier"]),
                            SubTrucker = Convert.ToString(reader["SubTrucker"]),
                            SubWarehousing = Convert.ToString(reader["SubWarehousing"]),
                            SubVendor = Convert.ToString(reader["SubVendor"]),
                            SubCFS = Convert.ToString(reader["SubCFS"]),
                            SubBroker = Convert.ToString(reader["SubBroker"]),
                            SubGovt = Convert.ToString(reader["SubGovt"]),
                            SubSpecial = Convert.ToString(reader["SubSpecial"]),
                            defaultBroker = Convert.ToString(reader["defaultBroker"]),
                            defaultBrokerName = Convert.ToString(reader["defaultBrokerName"]),
                            broker_info = Convert.ToString(reader["broker_info"]),
                            refferedBy = Convert.ToString(reader["refferedBy"]),
                            date_opened = Convert.ToString(reader["date_opened"]),
                            last_update = Convert.ToString(reader["last_update"]),
                            acct_name = Convert.ToString(reader["acct_name"]),
                            business_st_taxid = Convert.ToString(reader["business_st_taxid"]),
                            owner_ssn = Convert.ToString(reader["owner_ssn"]),
                            business_phone_mask_exp = Convert.ToString(reader["business_phone_mask_exp"]),
                            business_phone2_mask_exp = Convert.ToString(reader["business_phone2_mask_exp"]),
                            business_fax_mask_exp = Convert.ToString(reader["business_fax_mask_exp"]),
                            owner_phone_mask_exp = Convert.ToString(reader["owner_phone_mask_exp"]),
                            c2Phone_mask_exp = Convert.ToString(reader["c2Phone_mask_exp"]),
                            c2Cell_mask_exp = Convert.ToString(reader["c2Cell_mask_exp"]),
                            c2Fax_mask_exp = Convert.ToString(reader["c2Fax_mask_exp"]),
                            c3Phone_mask_exp = Convert.ToString(reader["c3Phone_mask_exp"]),
                            c3Cell_mask_exp = Convert.ToString(reader["c3Cell_mask_exp"]),
                            c3Fax_mask_exp = Convert.ToString(reader["c3Fax_mask_exp"]),
                            business_phone_mask_pre = Convert.ToString(reader["business_phone_mask_pre"]),
                            business_phone2_mask_pre = Convert.ToString(reader["business_phone2_mask_pre"]),
                            business_fax_mask_pre = Convert.ToString(reader["business_fax_mask_pre"]),
                            owner_phone_mask_pre = Convert.ToString(reader["owner_phone_mask_pre"]),
                            c2Phone_mask_pre = Convert.ToString(reader["c2Phone_mask_pre"]),
                            c2Cell_mask_pre = Convert.ToString(reader["c2Cell_mask_pre"]),
                            c2Fax_mask_pre = Convert.ToString(reader["c2Fax_mask_pre"]),
                            c3Phone_mask_pre = Convert.ToString(reader["c3Phone_mask_pre"]),
                            c3Cell_mask_pre = Convert.ToString(reader["c3Cell_mask_pre"]),
                            c3Fax_mask_pre = Convert.ToString(reader["c3Fax_mask_pre"]),
                            print_check_as = Convert.ToString(reader["print_check_as"]),
                            print_check_as_info = Convert.ToString(reader["print_check_as_info"]),
                            known_shipper = Convert.ToString(reader["known_shipper"]),
                            coloader_elt_acct_name = Convert.ToString(reader["coloader_elt_acct_name"]),
                            ICC_MC = Convert.ToString(reader["ICC_MC"]),
                            FF_account_no = Convert.ToString(reader["FF_account_no"]),
                            is_customer = Convert.ToString(reader["is_customer"]),
                            subCustomer = Convert.ToString(reader["subCustomer"]),
                            OrgId = Convert.ToInt32(reader["OrgId"])
                        

                        };
                        list.Add(item);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return list;

        }
        public ClientProfile GetClient(int elt_account_number, int org_account_number)
        {
            SqlConnection conn = new SqlConnection(GetConnectionString(AppConstants.DB_CONN_PROD));
            SqlCommand cmd = new SqlCommand() { Connection = conn, CommandType = CommandType.StoredProcedure, CommandText = "dbo.[GetClient]" };
            List<ClientProfile> list = new List<ClientProfile>();

            try
            {
                cmd.Parameters.Add(new SqlParameter("@elt_account_number", elt_account_number));
                cmd.Parameters.Add(new SqlParameter("@org_account_number", org_account_number));
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {

                        ClientProfile item = new ClientProfile()
                        {
                            dba_name = Convert.ToString(reader["dba_name"]),
                            org_account_number = Convert.ToInt32(reader["org_account_number"]),
                            account_status = Convert.ToString(reader["account_status"]),
                            class_code = Convert.ToString(reader["class_code"]),
                            isFrequently = Convert.ToString(reader["isFrequently"]),
                            business_legal_name = Convert.ToString(reader["business_legal_name"]),
                            business_fed_taxid = Convert.ToString(reader["business_fed_taxid"]),
                            business_address = Convert.ToString(reader["business_address"]),
                            business_address2 = Convert.ToString(reader["business_address2"]),
                            business_address3 = Convert.ToString(reader["business_address3"]),
                            business_city = Convert.ToString(reader["business_city"]),
                            business_state = Convert.ToString(reader["business_state"]),
                            business_zip = Convert.ToString(reader["business_zip"]),
                            business_country = Convert.ToString(reader["business_country"]),
                            b_country_code = Convert.ToString(reader["b_country_code"]),
                            business_phone = Convert.ToString(reader["business_phone"]),
                            business_phone_ext = Convert.ToString(reader["business_phone_ext"]),
                            business_phone_mask = Convert.ToString(reader["business_phone_mask"]),
                            business_phone2 = Convert.ToString(reader["business_phone2"]),
                            business_phone2_ext = Convert.ToString(reader["business_phone2_ext"]),
                            business_phone2_mask = Convert.ToString(reader["business_phone2_mask"]),
                            business_fax = Convert.ToString(reader["business_fax"]),
                            business_fax_mask = Convert.ToString(reader["business_fax_mask"]),
                            business_url = Convert.ToString(reader["business_url"]),
                            web_login_id = Convert.ToString(reader["web_login_id"]),
                            web_login_pin = Convert.ToString(reader["web_login_pin"]),
                            owner_lname = Convert.ToString(reader["owner_lname"]),
                            owner_fname = Convert.ToString(reader["owner_fname"]),
                            owner_mname = Convert.ToString(reader["owner_mname"]),
                            owner_title = Convert.ToString(reader["owner_title"]),
                            owner_departm = Convert.ToString(reader["owner_departm"]),
                            owner_mail_address = Convert.ToString(reader["owner_mail_address"]),
                            owner_mail_address2 = Convert.ToString(reader["owner_mail_address2"]),
                            owner_mail_address3 = Convert.ToString(reader["owner_mail_address3"]),
                            owner_mail_city = Convert.ToString(reader["owner_mail_city"]),
                            owner_mail_state = Convert.ToString(reader["owner_mail_state"]),
                            owner_mail_zip = Convert.ToString(reader["owner_mail_zip"]),
                            owner_mail_country = Convert.ToString(reader["owner_mail_country"]),
                            owner_phone = Convert.ToString(reader["owner_phone"]),
                            owner_phone_mask = Convert.ToString(reader["owner_phone_mask"]),
                            owner_email = Convert.ToString(reader["owner_email"]),
                            attn_name = Convert.ToString(reader["attn_name"]),
                            notify_name = Convert.ToString(reader["notify_name"]),
                            agent_elt_acct = Convert.ToString(reader["agent_elt_acct"]),
                            edt = Convert.ToString(reader["edt"]),
                            iata_code = Convert.ToString(reader["iata_code"]),
                            carrier_code = Convert.ToString(reader["carrier_code"]),
                            carrier_id = Convert.ToString(reader["carrier_id"]),
                            carrier_type = Convert.ToString(reader["carrier_type"]),
                            comment = Convert.ToString(reader["comment"]),
                            comment2 = Convert.ToString(reader["comment2"]),
                            credit_amt = Convert.ToString(reader["credit_amt"]),
                            bill_term = Convert.ToString(reader["bill_term"]),
                            coloader_elt_acct = Convert.ToString(reader["coloader_elt_acct"]),
                            colodee_elt_acct_name = Convert.ToString(reader["colodee_elt_acct_name"]),
                            z_bond_number = Convert.ToString(reader["z_bond_number"]),
                            z_bond_exp_date = Convert.ToString(reader["z_bond_exp_date"]),
                            z_bond_amount = Convert.ToString(reader["z_bond_amount"]),
                            z_bond_surety = Convert.ToString(reader["z_bond_surety"]),
                            z_bank_name = Convert.ToString(reader["z_bank_name"]),
                            z_bank_account_no = Convert.ToString(reader["z_bank_account_no"]),
                            z_chl_no = Convert.ToString(reader["z_chl_no"]),
                            z_firm_code = Convert.ToString(reader["z_firm_code"]),
                            z_carrier_code = Convert.ToString(reader["z_carrier_code"]),
                            z_carrier_prefix = Convert.ToString(reader["z_carrier_prefix"]),
                            z_attn_txt = Convert.ToString(reader["z_attn_txt"]),
                            SalesPerson = Convert.ToString(reader["SalesPerson"]),
                            c2FirstName = Convert.ToString(reader["c2FirstName"]),
                            c2MiddleName = Convert.ToString(reader["c2MiddleName"]),
                            c2LastName = Convert.ToString(reader["c2LastName"]),
                            c2Title = Convert.ToString(reader["c2Title"]),
                            c2Phone = Convert.ToString(reader["c2Phone"]),
                            c2Ext = Convert.ToString(reader["c2Ext"]),
                            c2Phone_mask = Convert.ToString(reader["c2Phone_mask"]),
                            c2Cell = Convert.ToString(reader["c2Cell"]),
                            c2Cell_mask = Convert.ToString(reader["c2Cell_mask"]),
                            c2Fax = Convert.ToString(reader["c2Fax"]),
                            c2Fax_mask = Convert.ToString(reader["c2Fax_mask"]),
                            c2Email = Convert.ToString(reader["c2Email"]),
                            c3FirstName = Convert.ToString(reader["c3FirstName"]),
                            c3MiddleName = Convert.ToString(reader["c3MiddleName"]),
                            c3LastName = Convert.ToString(reader["c3LastName"]),
                            c3Title = Convert.ToString(reader["c3Title"]),
                            c3Phone = Convert.ToString(reader["c3Phone"]),
                            c3Phone_mask = Convert.ToString(reader["c3Phone_mask"]),
                            c3Ext = Convert.ToString(reader["c3Ext"]),
                            c3Cell = Convert.ToString(reader["c3Cell"]),
                            c3Cell_mask = Convert.ToString(reader["c3Cell_mask"]),
                            c3Fax = Convert.ToString(reader["c3Fax"]),
                            c3Fax_mask = Convert.ToString(reader["c3Fax_mask"]),
                            c3Email = Convert.ToString(reader["c3Email"]),
                            is_shipper = Convert.ToString(reader["is_shipper"]),
                            is_consignee = Convert.ToString(reader["is_consignee"]),
                            is_agent = Convert.ToString(reader["is_agent"]),
                            is_vendor = Convert.ToString(reader["is_vendor"]),
                            is_carrier = Convert.ToString(reader["is_carrier"]),
                            is_coloader = Convert.ToString(reader["is_coloader"]),
                            z_is_trucker = Convert.ToString(reader["z_is_trucker"]),
                            z_is_special = Convert.ToString(reader["z_is_special"]),
                            z_is_broker = Convert.ToString(reader["z_is_broker"]),
                            z_is_warehousing = Convert.ToString(reader["z_is_warehousing"]),
                            z_is_cfs = Convert.ToString(reader["z_is_cfs"]),
                            z_is_govt = Convert.ToString(reader["z_is_govt"]),
                            SubConsignee = Convert.ToString(reader["SubConsignee"]),
                            SubShipper = Convert.ToString(reader["SubShipper"]),
                            SubAgent = Convert.ToString(reader["SubAgent"]),
                            SubCarrier = Convert.ToString(reader["SubCarrier"]),
                            SubTrucker = Convert.ToString(reader["SubTrucker"]),
                            SubWarehousing = Convert.ToString(reader["SubWarehousing"]),
                            SubVendor = Convert.ToString(reader["SubVendor"]),
                            SubCFS = Convert.ToString(reader["SubCFS"]),
                            SubBroker = Convert.ToString(reader["SubBroker"]),
                            SubGovt = Convert.ToString(reader["SubGovt"]),
                            SubSpecial = Convert.ToString(reader["SubSpecial"]),
                            defaultBroker = Convert.ToString(reader["defaultBroker"]),
                            defaultBrokerName = Convert.ToString(reader["defaultBrokerName"]),
                            broker_info = Convert.ToString(reader["broker_info"]),
                            refferedBy = Convert.ToString(reader["refferedBy"]),
                            date_opened = Convert.ToString(reader["date_opened"]),
                            last_update = Convert.ToString(reader["last_update"]),
                            acct_name = Convert.ToString(reader["acct_name"]),
                            business_st_taxid = Convert.ToString(reader["business_st_taxid"]),
                            owner_ssn = Convert.ToString(reader["owner_ssn"]),
                            business_phone_mask_exp = Convert.ToString(reader["business_phone_mask_exp"]),
                            business_phone2_mask_exp = Convert.ToString(reader["business_phone2_mask_exp"]),
                            business_fax_mask_exp = Convert.ToString(reader["business_fax_mask_exp"]),
                            owner_phone_mask_exp = Convert.ToString(reader["owner_phone_mask_exp"]),
                            c2Phone_mask_exp = Convert.ToString(reader["c2Phone_mask_exp"]),
                            c2Cell_mask_exp = Convert.ToString(reader["c2Cell_mask_exp"]),
                            c2Fax_mask_exp = Convert.ToString(reader["c2Fax_mask_exp"]),
                            c3Phone_mask_exp = Convert.ToString(reader["c3Phone_mask_exp"]),
                            c3Cell_mask_exp = Convert.ToString(reader["c3Cell_mask_exp"]),
                            c3Fax_mask_exp = Convert.ToString(reader["c3Fax_mask_exp"]),
                            business_phone_mask_pre = Convert.ToString(reader["business_phone_mask_pre"]),
                            business_phone2_mask_pre = Convert.ToString(reader["business_phone2_mask_pre"]),
                            business_fax_mask_pre = Convert.ToString(reader["business_fax_mask_pre"]),
                            owner_phone_mask_pre = Convert.ToString(reader["owner_phone_mask_pre"]),
                            c2Phone_mask_pre = Convert.ToString(reader["c2Phone_mask_pre"]),
                            c2Cell_mask_pre = Convert.ToString(reader["c2Cell_mask_pre"]),
                            c2Fax_mask_pre = Convert.ToString(reader["c2Fax_mask_pre"]),
                            c3Phone_mask_pre = Convert.ToString(reader["c3Phone_mask_pre"]),
                            c3Cell_mask_pre = Convert.ToString(reader["c3Cell_mask_pre"]),
                            c3Fax_mask_pre = Convert.ToString(reader["c3Fax_mask_pre"]),
                            print_check_as = Convert.ToString(reader["print_check_as"]),
                            print_check_as_info = Convert.ToString(reader["print_check_as_info"]),
                            known_shipper = Convert.ToString(reader["known_shipper"]),
                            coloader_elt_acct_name = Convert.ToString(reader["coloader_elt_acct_name"]),
                            ICC_MC = Convert.ToString(reader["ICC_MC"]),
                            FF_account_no = Convert.ToString(reader["FF_account_no"]),
                            is_customer = Convert.ToString(reader["is_customer"]),
                            subCustomer = Convert.ToString(reader["subCustomer"]),
                            OrgId = Convert.ToInt32(reader["OrgId"])


                        };
                        return item;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return null;
        }


    }
}
