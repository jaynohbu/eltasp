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
    
    public partial class invoice_header
    {
        public decimal auto_id { get; set; }
        public Nullable<decimal> elt_account_number { get; set; }
        public decimal invoice_no { get; set; }
        public string mawb { get; set; }
        public string hawb { get; set; }
        public string ETA { get; set; }
        public string ETD { get; set; }
        public string Consignee { get; set; }
        public string Shipper { get; set; }
        public string FILE_NO { get; set; }
        public string GrossWeight { get; set; }
        public string ChargeableWeight { get; set; }
        public string unit { get; set; }
        public string Pieces { get; set; }
        public string Origin { get; set; }
        public string Destination { get; set; }
        public string Carrier { get; set; }
    }
}