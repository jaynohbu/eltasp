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
    
    public partial class aes_master
    {
        public decimal auto_uid { get; set; }
        public decimal elt_account_number { get; set; }
        public string party_to_transaction { get; set; }
        public Nullable<System.DateTime> export_date { get; set; }
        public string tran_ref_no { get; set; }
        public Nullable<decimal> consignee_acct { get; set; }
        public Nullable<decimal> inter_consignee_acct { get; set; }
        public string origin_state { get; set; }
        public string dest_country { get; set; }
        public string tran_method { get; set; }
        public string export_carrier { get; set; }
        public string export_port { get; set; }
        public string unloading_port { get; set; }
        public string carrier_id_code { get; set; }
        public string shipment_ref_no { get; set; }
        public string entry_no { get; set; }
        public string hazardous_materials { get; set; }
        public string in_bond_type { get; set; }
        public string in_bond_no { get; set; }
        public string route_export_tran { get; set; }
        public Nullable<System.DateTime> tran_date { get; set; }
        public Nullable<System.DateTime> last_modified { get; set; }
        public string aes_itn { get; set; }
        public string aes_status { get; set; }
        public string ftz { get; set; }
        public Nullable<decimal> agent_acct { get; set; }
        public Nullable<decimal> shipper_acct { get; set; }
        public string file_type { get; set; }
        public string house_num { get; set; }
        public string master_num { get; set; }
    }
}
