using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    [Serializable]
    public class APDisputeItem
    {
        public APDisputeItem()
        {
            TransactionItems = new List<APDisputeTransactionItem>();
        }

        public string Class { get; set; }
        public string Customer_Number { get; set; }
        public string Company_Name { get; set; }
        public string Phone { get; set; }     
        public string Bill_Amount { get; set; }
        public string Balance { get; set; }
        public string Paid_Amount { get; set; }
        public string Dispute_Amount { get; set; }      
        public List<APDisputeTransactionItem> TransactionItems { get; set; }
    }
}
