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
    
    public partial class account_payable_journal
    {
        public decimal elt_account_number { get; set; }
        public Nullable<decimal> gl_account_number { get; set; }
        public Nullable<System.DateTime> tran_date { get; set; }
        public string tran_type { get; set; }
        public Nullable<decimal> invoice_No { get; set; }
        public Nullable<decimal> customer_number { get; set; }
        public string customer_name { get; set; }
        public Nullable<decimal> debit_amount { get; set; }
        public Nullable<decimal> credit_amount { get; set; }
        public string check_no { get; set; }
        public string po_no { get; set; }
        public Nullable<System.DateTime> last_modified { get; set; }
        public string is_org_merged { get; set; }
    }
}
