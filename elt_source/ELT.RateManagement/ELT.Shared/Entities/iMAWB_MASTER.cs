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
    
    public partial class iMAWB_MASTER
    {
        public decimal elt_account_number { get; set; }
        public Nullable<decimal> agent_elt_acct { get; set; }
        public Nullable<System.DateTime> tran_dt { get; set; }
        public string MAWB_NUM { get; set; }
        public string carrier { get; set; }
        public string file_no { get; set; }
        public Nullable<System.DateTime> etd { get; set; }
        public Nullable<System.DateTime> eta { get; set; }
        public string dep_port { get; set; }
        public string arr_port { get; set; }
        public string cargo_location { get; set; }
        public Nullable<System.DateTime> storage_begin_date { get; set; }
        public string it_number { get; set; }
        public Nullable<System.DateTime> it_date { get; set; }
        public string job_file_no { get; set; }
        public string agent_debit_no { get; set; }
        public Nullable<decimal> agent_debit_amt { get; set; }
        public Nullable<decimal> freight_collect { get; set; }
        public Nullable<decimal> profit { get; set; }
        public string DEP_AIRPORT_CODE { get; set; }
        public Nullable<decimal> master_agent { get; set; }
        public Nullable<decimal> airline_vendor_num { get; set; }
        public string Shipper_Name { get; set; }
        public string Shipper_Info { get; set; }
        public string Shipper_account_number { get; set; }
        public string Consignee_Name { get; set; }
        public string Consignee_Info { get; set; }
        public string Consignee_acct_num { get; set; }
        public string Issue_Carrier_agent { get; set; }
        public string Agent_IATA_Code { get; set; }
        public string Account_No { get; set; }
        public string Departure_Airport { get; set; }
        public string DEPARTURE_STATE { get; set; }
        public string IssuedBy { get; set; }
        public string Account_Info { get; set; }
        public string to_1 { get; set; }
        public string by_1 { get; set; }
        public string to_2 { get; set; }
        public string by_2 { get; set; }
        public string to_3 { get; set; }
        public string by_3 { get; set; }
        public string Currency { get; set; }
        public string Charge_Code { get; set; }
        public string PPO_1 { get; set; }
        public string COLL_1 { get; set; }
        public string PPO_2 { get; set; }
        public string COLL_2 { get; set; }
        public string Declared_Value_Carriage { get; set; }
        public string Declared_Value_Customs { get; set; }
        public string Dest_Airport { get; set; }
        public string Flight_Date_1 { get; set; }
        public string Flight_Date_2 { get; set; }
        public string Insurance_AMT { get; set; }
        public string Handling_Info { get; set; }
        public string dest_country { get; set; }
        public string SCI { get; set; }
        public Nullable<decimal> Total_Pieces { get; set; }
        public Nullable<decimal> Adjusted_Weight { get; set; }
        public Nullable<decimal> Total_Gross_Weight { get; set; }
        public string Weight_Scale { get; set; }
        public Nullable<decimal> Total_Weight_Charge_HAWB { get; set; }
        public Nullable<decimal> Total_Weight_Charge_ACCT { get; set; }
        public Nullable<decimal> Total_Other_Charges { get; set; }
        public Nullable<decimal> Prepaid_Weight_Charge { get; set; }
        public Nullable<decimal> Collect_Weight_Charge { get; set; }
        public Nullable<decimal> Prepaid_Valuation_Charge { get; set; }
        public Nullable<decimal> Collect_Valuation_Charge { get; set; }
        public Nullable<decimal> Prepaid_Tax { get; set; }
        public Nullable<decimal> Collect_Tax { get; set; }
        public Nullable<decimal> Prepaid_Due_Agent { get; set; }
        public Nullable<decimal> Collect_Due_Agent { get; set; }
        public Nullable<decimal> Prepaid_Due_Carrier { get; set; }
        public Nullable<decimal> Collect_Due_Carrier { get; set; }
        public Nullable<decimal> Prepaid_Unused { get; set; }
        public Nullable<decimal> Collect_Unused { get; set; }
        public Nullable<decimal> Prepaid_Total { get; set; }
        public Nullable<decimal> Collect_Total { get; set; }
        public string Signature { get; set; }
        public Nullable<System.DateTime> Date_Executed { get; set; }
        public string Place_Executed { get; set; }
        public string Execution { get; set; }
        public Nullable<System.DateTime> Date_Last_Modified { get; set; }
        public Nullable<decimal> Currency_Conv_Rate { get; set; }
        public Nullable<decimal> CC_Charge_Dest_Rate { get; set; }
        public Nullable<decimal> Charge_at_Dest { get; set; }
        public Nullable<decimal> Total_Collect_Charge { get; set; }
        public string Desc1 { get; set; }
        public string Desc2 { get; set; }
        public string Show_Weight_Charge_Shipper { get; set; }
        public string Show_Weight_Charge_Consignee { get; set; }
        public string Show_Prepaid_Other_Charge_Shipper { get; set; }
        public string Show_Collect_Other_Charge_Shipper { get; set; }
        public string Show_Prepaid_Other_Charge_Consignee { get; set; }
        public string Show_Collect_Other_Charge_Consignee { get; set; }
        public string Invoiced { get; set; }
    }
}
