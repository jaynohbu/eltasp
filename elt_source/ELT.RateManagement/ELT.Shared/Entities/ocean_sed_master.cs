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
    
    public partial class ocean_sed_master
    {
        public decimal auto_uid { get; set; }
        public decimal elt_account_number { get; set; }
        public string hbol_num { get; set; }
        public string booking_num { get; set; }
        public Nullable<decimal> shipper_acct { get; set; }
        public string USPPI { get; set; }
        public string USPPI_taxid { get; set; }
        public string usppi_contact_firstname { get; set; }
        public string usppi_contact_lastname { get; set; }
        public string party_to_transaction { get; set; }
        public string zip_code { get; set; }
        public Nullable<System.DateTime> export_date { get; set; }
        public string tran_ref_no { get; set; }
        public Nullable<decimal> consignee_acct { get; set; }
        public string ulti_consignee { get; set; }
        public string inter_consignee { get; set; }
        public string forward_agent { get; set; }
        public string origin_state { get; set; }
        public string dest_country { get; set; }
        public string loading_pier { get; set; }
        public Nullable<int> tran_method { get; set; }
        public string export_carrier { get; set; }
        public string vessel_name { get; set; }
        public string export_port { get; set; }
        public string unloading_port { get; set; }
        public string containerized { get; set; }
        public string carrier_id_code { get; set; }
        public string shipment_ref_no { get; set; }
        public string entry_no { get; set; }
        public string hazardous_materials { get; set; }
        public Nullable<int> in_bond_code { get; set; }
        public string route_export_tran { get; set; }
        public string license_no { get; set; }
        public string ECCN { get; set; }
        public string duly { get; set; }
        public string title { get; set; }
        public string phone { get; set; }
        public string email { get; set; }
        public Nullable<System.DateTime> tran_date { get; set; }
        public Nullable<System.DateTime> last_modified { get; set; }
        public string is_org_merged { get; set; }
        public string aes_itn { get; set; }
        public string aes_status { get; set; }
    }
}
