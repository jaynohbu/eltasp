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
    
    public partial class GetAllRate_Result
    {
        public Nullable<decimal> elt_account_number { get; set; }
        public Nullable<decimal> item_no { get; set; }
        public Nullable<int> rate_type { get; set; }
        public Nullable<int> agent_no { get; set; }
        public Nullable<int> customer_no { get; set; }
        public string airline { get; set; }
        public string origin_port { get; set; }
        public string dest_port { get; set; }
        public Nullable<decimal> weight_break { get; set; }
        public Nullable<decimal> rate { get; set; }
        public string kg_lb { get; set; }
        public Nullable<decimal> share { get; set; }
        public string is_org_merged { get; set; }
        public Nullable<decimal> fl_rate { get; set; }
        public Nullable<decimal> sec_rate { get; set; }
        public string include_fl_rate { get; set; }
        public string include_sec_rate { get; set; }
        public int id { get; set; }
        public string dba_name { get; set; }
    }
}