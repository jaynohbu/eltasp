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
    
    public partial class email_history
    {
        public decimal auto_uid { get; set; }
        public string email_id { get; set; }
        public Nullable<decimal> elt_account_number { get; set; }
        public Nullable<decimal> user_id { get; set; }
        public Nullable<decimal> to_org_id { get; set; }
        public string to_org_name { get; set; }
        public string email_sender { get; set; }
        public string email_from { get; set; }
        public string email_to { get; set; }
        public string email_cc { get; set; }
        public string email_subject { get; set; }
        public string email_content { get; set; }
        public Nullable<System.DateTime> sent_date { get; set; }
        public string sent_status { get; set; }
        public string air_ocean { get; set; }
        public string im_export { get; set; }
        public string screen_name { get; set; }
        public string master_num { get; set; }
        public string house_num { get; set; }
        public string manifest_link { get; set; }
        public string invoice_num { get; set; }
        public string attached_files { get; set; }
        public string attached_pdf { get; set; }
        public string online_alert { get; set; }
        public string is_org_merged { get; set; }
    }
}
