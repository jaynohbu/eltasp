using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    public class BrachAccount
    {
        public int elt_account_number { get; set; }        
        public string dba_name { get; set; }

    }
    public class ClientProfile
    {
        public  int  elt_account_number { get; set; }
        public int org_account_number { get; set; }
        public string CompanyName
        {
            get
            {
                if (string.IsNullOrEmpty(dba_name))
                {
                    return business_legal_name;
                }
                else
                {
                    return dba_name;
                }
            }

        }
        public string dba_name { get; set; }
        public string class_code { get; set; }
        public string isFrequently { get; set; }
        public string business_legal_name { get; set; }
        public string business_fed_taxid { get; set; }
        public string business_address { get; set; }
        public string business_address2 { get; set; }
        public string business_address3 { get; set; }
        public string business_city { get; set; }
        public string business_state { get; set; }
        public string business_zip { get; set; }
        public string business_country { get; set; }
        public string b_country_code { get; set; }
        public string business_phone { get; set; }
        public string business_phone_ext { get; set; }
        public string business_phone_mask { get; set; }
        public string business_phone2 { get; set; }
        public string business_phone2_ext { get; set; }
        public string business_phone2_mask { get; set; }
        public string business_fax { get; set; }
        public string business_fax_mask { get; set; }
        public string business_url { get; set; }
        public string web_login_id { get; set; }
        public string web_login_pin { get; set; }
        public string owner_lname { get; set; }
        public string owner_fname { get; set; }
        public string owner_mname { get; set; }
        public string owner_title { get; set; }
        public string owner_departm { get; set; }
        public string owner_mail_address { get; set; }
        public string owner_mail_address2 { get; set; }
        public string owner_mail_address3 { get; set; }
        public string owner_mail_city { get; set; }
        public string owner_mail_state { get; set; }
        public string owner_mail_zip { get; set; }
        public string owner_mail_country { get; set; }
        public string owner_phone { get; set; }
        public string owner_phone_mask { get; set; }
        public string owner_email { get; set; }
        public string attn_name { get; set; }
        public string notify_name { get; set; }
        public string agent_elt_acct { get; set; }
        public string edt { get; set; }
        public string iata_code { get; set; }
        public string carrier_code { get; set; }
        public string carrier_id { get; set; }
        public string carrier_type { get; set; }
        public string account_status { get; set; }
        public string comment { get; set; }
        public string comment2 { get; set; }
        public  string  credit_amt { get; set; }
        public  string  bill_term { get; set; }
        public string coloader_elt_acct { get; set; }
        public string colodee_elt_acct_name { get; set; }
        public  string  z_bond_number { get; set; }
        public string z_bond_exp_date { get; set; }
        public  string  z_bond_amount { get; set; }
        public string z_bond_surety { get; set; }
        public string z_bank_name { get; set; }
        public string z_bank_account_no { get; set; }
        public string z_chl_no { get; set; }
        public string z_firm_code { get; set; }
        public string z_carrier_code { get; set; }
        public string z_carrier_prefix { get; set; }
        public string z_attn_txt { get; set; }
        public string SalesPerson { get; set; }
        public string c2FirstName { get; set; }
        public string c2MiddleName { get; set; }
        public string c2LastName { get; set; }
        public string c2Title { get; set; }
        public string c2Phone { get; set; }
        public string c2Ext { get; set; }
        public string c2Phone_mask { get; set; }
        public string c2Cell { get; set; }
        public string c2Cell_mask { get; set; }
        public string c2Fax { get; set; }
        public string c2Fax_mask { get; set; }
        public string c2Email { get; set; }
        public string c3FirstName { get; set; }
        public string c3MiddleName { get; set; }
        public string c3LastName { get; set; }
        public string c3Title { get; set; }
        public string c3Phone { get; set; }
        public string c3Phone_mask { get; set; }
        public string c3Ext { get; set; }
        public string c3Cell { get; set; }
        public string c3Cell_mask { get; set; }
        public string c3Fax { get; set; }
        public string c3Fax_mask { get; set; }
        public string c3Email { get; set; }
        public string is_shipper { get; set; }
        public string is_consignee { get; set; }
        public string is_agent { get; set; }
        public string is_vendor { get; set; }
        public string is_carrier { get; set; }
        public string is_coloader { get; set; }
        public string z_is_trucker { get; set; }
        public string z_is_special { get; set; }
        public string z_is_broker { get; set; }
        public string z_is_warehousing { get; set; }
        public string z_is_cfs { get; set; }
        public string z_is_govt { get; set; }
        public string SubConsignee { get; set; }
        public string SubShipper { get; set; }
        public string SubAgent { get; set; }
        public string SubCarrier { get; set; }
        public string SubTrucker { get; set; }
        public string SubWarehousing { get; set; }
        public string SubCFS { get; set; }
        public string SubBroker { get; set; }
        public string SubGovt { get; set; }
        public string SubVendor { get; set; }
        public string SubSpecial { get; set; }
        public string defaultBroker { get; set; }
        public string defaultBrokerName { get; set; }
        public string broker_info { get; set; }
        public string refferedBy { get; set; }
        public string date_opened { get; set; }
        public string last_update { get; set; }
        public string acct_name { get; set; }
        public string business_st_taxid { get; set; }
        public string owner_ssn { get; set; }
        public string business_phone_mask_exp { get; set; }
        public string business_phone2_mask_exp { get; set; }
        public string business_fax_mask_exp { get; set; }
        public string owner_phone_mask_exp { get; set; }
        public string c2Phone_mask_exp { get; set; }
        public string c2Cell_mask_exp { get; set; }
        public string c2Fax_mask_exp { get; set; }
        public string c3Phone_mask_exp { get; set; }
        public string c3Cell_mask_exp { get; set; }
        public string c3Fax_mask_exp { get; set; }
        public string business_phone_mask_pre { get; set; }
        public string business_phone2_mask_pre { get; set; }
        public string business_fax_mask_pre { get; set; }
        public string owner_phone_mask_pre { get; set; }
        public string c2Phone_mask_pre { get; set; }
        public string c2Cell_mask_pre { get; set; }
        public string c2Fax_mask_pre { get; set; }
        public string c3Phone_mask_pre { get; set; }
        public string c3Cell_mask_pre { get; set; }
        public string c3Fax_mask_pre { get; set; }
        public string print_check_as { get; set; }
        public string print_check_as_info { get; set; }
        public string known_shipper { get; set; }
        public string coloader_elt_acct_name { get; set; }
        public string ICC_MC { get; set; }
        public string FF_account_no { get; set; }
        public string is_customer { get; set; }
        public string subCustomer { get; set; }
        public int OrgId { get; set; }
    }
}
