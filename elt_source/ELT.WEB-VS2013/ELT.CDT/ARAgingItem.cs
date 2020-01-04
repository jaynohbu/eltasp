using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    [Serializable]
    public class ARAgingItem
    {
        public ARAgingItem()
        {
            TransactionItems = new List<ARAgingTransactionalItem>();
        }
        public List<ARAgingTransactionalItem> TransactionItems { get; set; }
        public string Customer_Number { get; set; }
        public string Company_Name { get; set; }
        public string Phone { get; set; }
        public string Credit { get; set; }
        public string Current { get; set; }
        public string One_Month { get; set; }
        public string Two_Month { get; set; }
        public string Three_Month { get; set; }
        public string More_Than_Three_Month { get; set; }
        public string Total { get; set; }   

    }
}
