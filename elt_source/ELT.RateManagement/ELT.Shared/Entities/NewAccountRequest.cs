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
    
    public partial class NewAccountRequest
    {
        public decimal ID { get; set; }
        public string UserName { get; set; }
        public bool IsProcessed { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Title { get; set; }
        public string CompanyName { get; set; }
        public string DBAName { get; set; }
        public string Country { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Zip { get; set; }
        public string Fax { get; set; }
        public string Phone { get; set; }
        public System.DateTime DateRequested { get; set; }
        public System.DateTime DateProcessed { get; set; }
        public string ProcessedBy { get; set; }
        public bool CheckDomestic { get; set; }
        public bool CheckAirExport { get; set; }
        public bool CheckAirImport { get; set; }
        public bool CheckOceanExport { get; set; }
        public bool CheckOceanImport { get; set; }
        public bool CheckAccounting { get; set; }
        public bool CheckWMS { get; set; }
        public string FederalTaxID { get; set; }
    }
}
