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
    
    public partial class reconcile_receivement_detail
    {
        public decimal recon_id { get; set; }
        public decimal elt_account_number { get; set; }
        public decimal tran_seq_num { get; set; }
        public Nullable<decimal> gl_account_number { get; set; }
        public string gl_account_name { get; set; }
        public string tran_type { get; set; }
        public string tran_num { get; set; }
        public Nullable<System.DateTime> tran_date { get; set; }
        public string customer_name { get; set; }
        public Nullable<decimal> customer_number { get; set; }
        public Nullable<decimal> debit_amount { get; set; }
        public string ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public string memo { get; set; }
        public string is_recon_cleared { get; set; }
    }
}