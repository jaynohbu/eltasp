using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    [Serializable]
    public class APDisputeTransactionItem
    {


        public string Customer_Number { get; set; }  
        public string Date { get; set; }
        public string Memo { get; set; }
        public string FileNo { get; set; }
        public string Payment_Method { get; set; }
        public string Company_Name { get; set; }
        public string Phone { get; set; }     
        public string Due_Amount { get; set; }
        public string Paid_Amount { get; set; }
        public string Dispute_Amount { get; set; }    
    }
}
