using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace ELT.CDT
{
    [Serializable]
    public class ExpenseItem
    {
        public ExpenseItem()
        {
            TransactionItems = new List<ExpenseTransactionalItem>();
        }
        public string customer_name { get; set; }
        public string customer_number { get; set; }
        public string Amount { get; set; }
        public string Balance { get; set; }
        public List<ExpenseTransactionalItem> TransactionItems { get; set; }
    }
      [Serializable]
    public class ExpenseTransactionalItem
    {
        public string elt_account_number { get; set; }
        public string Customer_Name { get; set; }
        public string Customer_Number { get; set; }
        public string Type { get; set; }
        public string Date { get; set; }
        public string Num { get; set; }
        public string Memo { get; set; }
        public string Account { get; set; }
        public string Split { get; set; }
        public string Amount { get; set; }
        public string Balance { get; set; }
        public string Link { get; set; }
    }
}
