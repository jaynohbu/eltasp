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
    
    public partial class AEOperationReport_Result
    {
        public Nullable<System.Guid> KeyField { get; set; }
        public string File_ { get; set; }
        public string Master { get; set; }
        public string House { get; set; }
        public string Shipper { get; set; }
        public string Consignee { get; set; }
        public string Agent { get; set; }
        public string Carrier { get; set; }
        public string Origin { get; set; }
        public string Destination { get; set; }
        public string Date { get; set; }
        public string Sales_Rep_ { get; set; }
        public string Processed_By { get; set; }
        public decimal Quantity { get; set; }
        public Nullable<decimal> Gross_Wt_ { get; set; }
        public Nullable<decimal> Chargeable_Wt_ { get; set; }
        public decimal Freight_Charge { get; set; }
        public decimal Other_Charge { get; set; }
    }
}
