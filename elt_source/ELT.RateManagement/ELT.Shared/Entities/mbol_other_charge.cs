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
    
    public partial class mbol_other_charge
    {
        public decimal elt_account_number { get; set; }
        public string booking_num { get; set; }
        public string mbol_num { get; set; }
        public int tran_no { get; set; }
        public string Coll_Prepaid { get; set; }
        public Nullable<int> charge_code { get; set; }
        public string charge_desc { get; set; }
        public Nullable<decimal> charge_amt { get; set; }
        public Nullable<decimal> vendor_num { get; set; }
        public Nullable<int> cost_code { get; set; }
        public string cost_desc { get; set; }
        public Nullable<decimal> cost_amt { get; set; }
        public string is_org_merged { get; set; }
    }
}
