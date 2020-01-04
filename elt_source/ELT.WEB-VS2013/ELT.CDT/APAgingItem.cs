using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    [Serializable]
    public class APAgingItem
    {
        public APAgingItem()
        {
            TransactionItems = new List<APAgingTransactionalItem>();

        }

        public string Customer_Number { get; set; }
        public string Company_Name { get; set; }
        public string Phone { get; set; }     
        public string Current { get; set; }
        public string One_Month { get; set; }
        public string Two_Month { get; set; }
        public string Three_Month { get; set; }
        public string More_Than_Three_Month { get; set; }
        public string Total { get; set; }
      
        public List<APAgingTransactionalItem> TransactionItems { get; set; }
    }
}
