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
    
    public partial class bug_master
    {
        public decimal auto_uid { get; set; }
        public string asp_code { get; set; }
        public string err_number { get; set; }
        public string source { get; set; }
        public string source_file { get; set; }
        public Nullable<decimal> err_line { get; set; }
        public string err_desc { get; set; }
        public string err_asp_desc { get; set; }
        public string last_sql { get; set; }
        public Nullable<System.DateTime> err_date { get; set; }
        public Nullable<decimal> elt_account_number { get; set; }
        public Nullable<decimal> user_id { get; set; }
    }
}
