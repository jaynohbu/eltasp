using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    

    [Serializable]
    public class SalesItem
    {
        public SalesItem()
        {
            TransactionItems = new List<SalesTransactionalItem>();
        }
        public string customer_name { get; set; }
        public string customer_number { get; set; }
        public double Amount { get; set; }
       
        public string Balance { get; set; }
        public List<SalesTransactionalItem> TransactionItems { get; set; }
    }
     [Serializable]
    public class SalesTransactionalItem
    {
        public string elt_account_number { get; set; }
        public string Customer_Name { get; set; }
        public string Customer_Number { get; set; }
        public string air_ocean { get; set; }
        public string Type { get; set; }
        public string Num { get; set; }
        public string Date { get; set; }
        public double Amount { get; set; }  
        public string Balance { get; set; }  
        public string Link { get; set; }
    }
}
