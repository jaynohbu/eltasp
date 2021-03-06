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
    using System.Collections.Generic;
    
    public partial class certificate_origin_air
    {
        public decimal auto_uid { get; set; }
        public string doc_num { get; set; }
        public string hawb_num { get; set; }
        public string mawb_num { get; set; }
        public Nullable<decimal> elt_account_number { get; set; }
        public string shipper_name { get; set; }
        public string shipper_info { get; set; }
        public Nullable<decimal> shipper_acct_num { get; set; }
        public string consignee_name { get; set; }
        public string consignee_info { get; set; }
        public Nullable<decimal> consignee_acct_num { get; set; }
        public string agent_name { get; set; }
        public string agent_info { get; set; }
        public Nullable<decimal> agent_acct_num { get; set; }
        public string notify_name { get; set; }
        public string notify_info { get; set; }
        public Nullable<decimal> notify_acct_num { get; set; }
        public string export_ref { get; set; }
        public string origin_country { get; set; }
        public string export_instr { get; set; }
        public string pre_carriage { get; set; }
        public string pre_receipt_place { get; set; }
        public string export_carrier { get; set; }
        public string loading_port { get; set; }
        public string loading_terminal { get; set; }
        public string unloading_port { get; set; }
        public string delivery_place { get; set; }
        public string move_type { get; set; }
        public Nullable<System.DateTime> updated_date { get; set; }
        public string file_name { get; set; }
        public string anonymous { get; set; }
        public string us_state { get; set; }
        public string dest_country { get; set; }
        public string shipping_city { get; set; }
        public string ff_name { get; set; }
        public string ff_city { get; set; }
        public string ff_county { get; set; }
        public Nullable<System.DateTime> created_date { get; set; }
        public Nullable<System.DateTime> sworn_date { get; set; }
        public string employee { get; set; }
        public string origin_state { get; set; }
        public string is_org_merged { get; set; }
        public string session_id { get; set; }
        public Nullable<decimal> ff_county_acct { get; set; }
        public string ff_county_name { get; set; }
    }
}
