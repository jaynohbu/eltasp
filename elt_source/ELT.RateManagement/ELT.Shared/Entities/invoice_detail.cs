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
    
    public partial class invoice_detail
    {
        public decimal elt_account_number { get; set; }
        public decimal invoice_no { get; set; }
        public int item_id { get; set; }
        public int item_no { get; set; }
        public string item_desc { get; set; }
        public Nullable<int> qty { get; set; }
        public string ref_no { get; set; }
        public Nullable<decimal> charge_amount { get; set; }
        public Nullable<decimal> cost_amount { get; set; }
        public Nullable<decimal> vendor_no { get; set; }
        public string is_org_merged { get; set; }
    }
}
