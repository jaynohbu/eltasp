using System;

namespace ELT.Shared.Model
{
    public class ELTUser
    {
        public string elt_account_number;
        public int IntEltAccountNumber => Convert.ToInt32(elt_account_number);
        public string userid;
        public string user_type;
        public string user_right;
        public string login_name;
        public string password;
        public string org_acct;
        public string user_lname;
        public string user_fname;
        public string user_title;
        public string user_address;
        public string user_city;
        public string user_state;
        public string user_zip;
        public string user_country;
        public string user_phone;
        public string user_email;
        public string create_date;
        public string pw_change_date;
        public string last_modified;
        public string last_login_date;
        public string default_warehouse;
        public string awb_port;
        public string bol_port;
        public string sed_port;
        public string invoice_port;
        public string check_port;
        public string shipping_label_port;
        public string awb_queue;
        public string bol_queue;
        public string sed_queue;
        public string invoice_queue;
        public string check_queue;
        public string shipping_label_queue;
        public string ig_user_ssn;
        public string ig_user_dob;
        public string ig_user_cell;
        public string ig_recent_work;
        public string page_id;
        public string label_type;
        public string add_to_label;
        public string awb_prn_name;
        public string bol_prn_name;
        public string sed_prn_name;
        public string invoice_prn_name;
        public string check_prn_name;
        public string shipping_label_prn_name;
        public string is_org_merged;
        public string page_tab_id;
        public string board_name;
        public string company_name;

    }
}