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
    
    public partial class invoice_tmp
    {
        public decimal elt_account_number { get; set; }
        public decimal invoice_no { get; set; }
        public string invoice_type { get; set; }
        public string import_export { get; set; }
        public string air_ocean { get; set; }
        public Nullable<System.DateTime> invoice_date { get; set; }
        public string ref_no { get; set; }
        public string Customer_info { get; set; }
        public string Total_Pieces { get; set; }
        public string Total_Gross_Weight { get; set; }
        public string Total_Charge_Weight { get; set; }
        public string Description { get; set; }
        public string Origin_Dest { get; set; }
        public string origin { get; set; }
        public string dest { get; set; }
        public string Customer_Number { get; set; }
        public string Customer_Name { get; set; }
        public string shipper { get; set; }
        public string consignee { get; set; }
        public string entry_no { get; set; }
        public Nullable<System.DateTime> entry_date { get; set; }
        public string Carrier { get; set; }
        public string Arrival_Dept { get; set; }
        public string mawb_num { get; set; }
        public string hawb_num { get; set; }
        public Nullable<decimal> subtotal { get; set; }
        public Nullable<decimal> sale_tax { get; set; }
        public Nullable<decimal> agent_profit { get; set; }
        public Nullable<decimal> accounts_receivable { get; set; }
        public Nullable<decimal> amount_charged { get; set; }
        public Nullable<decimal> amount_paid { get; set; }
        public Nullable<decimal> balance { get; set; }
        public Nullable<decimal> total_cost { get; set; }
        public string remarks { get; set; }
        public string pay_status { get; set; }
        public Nullable<int> term_curr { get; set; }
        public string term30 { get; set; }
        public string term60 { get; set; }
        public string term90 { get; set; }
        public Nullable<decimal> received_amt { get; set; }
        public string pmt_method { get; set; }
        public Nullable<decimal> existing_credits { get; set; }
        public Nullable<decimal> deposit_to { get; set; }
        public string lock_ar { get; set; }
        public string lock_ap { get; set; }
        public string in_memo { get; set; }
    }
}