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
    
    public partial class email_report
    {
        public int auto_uid { get; set; }
        public string session_id { get; set; }
        public string sqlstr { get; set; }
        public string status { get; set; }
        public Nullable<decimal> elt_account_number { get; set; }
        public Nullable<int> company { get; set; }
        public string message { get; set; }
        public Nullable<System.DateTime> sent_date { get; set; }
        public string email { get; set; }
        public string period { get; set; }
        public string is_org_merged { get; set; }
    }
}