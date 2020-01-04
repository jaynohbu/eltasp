//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ELT.Shared.Entities
{
    using System;
    
    public partial class MigrateUser_Result
    {
        public decimal elt_account_number { get; set; }
        public decimal userid { get; set; }
        public Nullable<int> user_type { get; set; }
        public Nullable<int> user_right { get; set; }
        public string login_name { get; set; }
        public string password { get; set; }
        public Nullable<decimal> org_acct { get; set; }
        public string user_lname { get; set; }
        public string user_fname { get; set; }
        public string user_title { get; set; }
        public string user_address { get; set; }
        public string user_city { get; set; }
        public string user_state { get; set; }
        public string user_zip { get; set; }
        public string user_country { get; set; }
        public string user_phone { get; set; }
        public string user_email { get; set; }
        public Nullable<System.DateTime> create_date { get; set; }
        public Nullable<System.DateTime> pw_change_date { get; set; }
        public Nullable<System.DateTime> last_modified { get; set; }
        public Nullable<System.DateTime> last_login_date { get; set; }
        public Nullable<int> default_warehouse { get; set; }
        public string awb_port { get; set; }
        public string bol_port { get; set; }
        public string sed_port { get; set; }
        public string invoice_port { get; set; }
        public string check_port { get; set; }
        public string shipping_label_port { get; set; }
        public string awb_queue { get; set; }
        public string bol_queue { get; set; }
        public string sed_queue { get; set; }
        public string invoice_queue { get; set; }
        public string check_queue { get; set; }
        public string shipping_label_queue { get; set; }
        public string ig_user_ssn { get; set; }
        public string ig_user_dob { get; set; }
        public string ig_user_cell { get; set; }
        public Nullable<int> ig_recent_work { get; set; }
        public Nullable<int> page_id { get; set; }
        public Nullable<decimal> label_type { get; set; }
        public string add_to_label { get; set; }
        public string awb_prn_name { get; set; }
        public string bol_prn_name { get; set; }
        public string sed_prn_name { get; set; }
        public string invoice_prn_name { get; set; }
        public string check_prn_name { get; set; }
        public string shipping_label_prn_name { get; set; }
        public string is_org_merged { get; set; }
        public Nullable<decimal> page_tab_id { get; set; }
    }
}
