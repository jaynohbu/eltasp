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
    
    public partial class BalanceSheetReport_Result
    {
        public string Header { get; set; }
        public string Type { get; set; }
        public string gl_account_type { get; set; }
        public string gl_account_type2 { get; set; }
        public Nullable<decimal> GL_Number { get; set; }
        public string GL_Name { get; set; }
        public Nullable<decimal> Amount { get; set; }
        public Nullable<decimal> Begin_Balance { get; set; }
    }
}
