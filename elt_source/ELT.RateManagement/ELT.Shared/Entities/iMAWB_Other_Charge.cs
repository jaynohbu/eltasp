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
    
    public partial class iMAWB_Other_Charge
    {
        public decimal elt_account_number { get; set; }
        public string MAWB_NUM { get; set; }
        public int Tran_No { get; set; }
        public string Coll_Prepaid { get; set; }
        public string Carrier_Agent { get; set; }
        public string charge_code { get; set; }
        public string Charge_Desc { get; set; }
        public Nullable<decimal> Amt_MAWB { get; set; }
        public Nullable<decimal> Amt_Acct { get; set; }
        public string Vendor_Num { get; set; }
        public Nullable<decimal> Cost_Amt { get; set; }
    }
}
