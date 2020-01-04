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
    
    public partial class warehouse_shipout
    {
        public decimal auto_uid { get; set; }
        public string so_num { get; set; }
        public string wr_num { get; set; }
        public Nullable<decimal> elt_account_number { get; set; }
        public string carrier_ref_no { get; set; }
        public string customer_ref_no { get; set; }
        public Nullable<System.DateTime> system_date { get; set; }
        public Nullable<System.DateTime> created_date { get; set; }
        public Nullable<System.DateTime> received_date { get; set; }
        public Nullable<System.DateTime> shipout_date { get; set; }
        public Nullable<decimal> consignee_acct { get; set; }
        public Nullable<decimal> customer_acct { get; set; }
        public string consignee_contact { get; set; }
        public string customer_contact { get; set; }
        public Nullable<decimal> trucker_acct { get; set; }
        public Nullable<decimal> inland_amount { get; set; }
        public string inland_type { get; set; }
        public string danger_good { get; set; }
        public string other_info { get; set; }
        public Nullable<decimal> item_piece_shipout { get; set; }
        public string item_desc { get; set; }
        public Nullable<decimal> item_weight { get; set; }
        public string item_weight_scale { get; set; }
        public string item_dimension { get; set; }
        public string item_dimension_scale { get; set; }
        public string item_remark { get; set; }
        public string shipout_status { get; set; }
        public string PO_NO { get; set; }
        public string file_type { get; set; }
        public string house_num { get; set; }
        public string master_num { get; set; }
        public string shipper_info { get; set; }
    }
}