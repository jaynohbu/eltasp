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
    
    public partial class PNL
    {
        public decimal ID { get; set; }
        public string Type { get; set; }
        public string ImportExport { get; set; }
        public string AirOcean { get; set; }
        public string Master_House { get; set; }
        public Nullable<decimal> elt_account_number { get; set; }
        public string MBL_NUM { get; set; }
        public string HBL_NUM { get; set; }
        public string Item_Code { get; set; }
        public string Description { get; set; }
        public Nullable<decimal> Customer_ID { get; set; }
        public Nullable<double> Amount { get; set; }
        public string ORIGIN { get; set; }
        public string DEST { get; set; }
        public string Customer_Name { get; set; }
        public Nullable<System.DateTime> Date { get; set; }
    }
}
