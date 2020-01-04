using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace ELT.CDT
{
    [Serializable]
    public class AirImportDocument
    {      
        
        public string mawb_num { get; set; }
        public string hawb_num { get; set; }
        public string shipper_account_number { get; set; }
        public string shipper_name { get; set; }
        public string agent_email { get; set; }
        public string shipper_email { get; set; }
        public string agent_no { get; set; }
        public string agent_name { get; set; }
        public string invoice_no { get; set; }    
        public string edt { get; set; }
        public string agent_elt_acct { get; set; }
        public string MsgTxt { get; set; }
        public string sec { get; set; }
        public string pieces { get; set; }
        public string gross_wt { get; set; }
        public string col_amt { get; set; }
        public string pickup_date { get; set; }
            
    }
}
