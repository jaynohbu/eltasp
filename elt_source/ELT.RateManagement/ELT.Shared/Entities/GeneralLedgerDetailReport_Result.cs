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
    
    public partial class GeneralLedgerDetailReport_Result
    {
        public decimal elt_account_number { get; set; }
        public Nullable<decimal> GL_Number { get; set; }
        public string GL_Name { get; set; }
        public string Type { get; set; }
        public string air_ocean { get; set; }
        public Nullable<System.DateTime> Date { get; set; }
        public string Num { get; set; }
        public Nullable<decimal> Check_No { get; set; }
        public string Company_Name { get; set; }
        public string Memo { get; set; }
        public string Split { get; set; }
        public Nullable<decimal> debit_amount { get; set; }
        public Nullable<decimal> credit_amount { get; set; }
    }
}
