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
    
    public partial class mb_cost_item
    {
        public decimal auto_uid { get; set; }
        public Nullable<decimal> elt_account_number { get; set; }
        public string mb_no { get; set; }
        public Nullable<int> item_id { get; set; }
        public Nullable<int> item_no { get; set; }
        public string item_desc { get; set; }
        public Nullable<int> qty { get; set; }
        public string ref_no { get; set; }
        public Nullable<decimal> cost_amount { get; set; }
        public Nullable<decimal> vendor_no { get; set; }
        public string iType { get; set; }
        public string lock_ap { get; set; }
        public string is_org_merged { get; set; }
        public Nullable<decimal> bill_number { get; set; }
        public Nullable<decimal> rate { get; set; }
    }
}