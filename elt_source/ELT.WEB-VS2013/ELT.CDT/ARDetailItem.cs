using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace ELT.CDT
{
    [Serializable]
    public class ARDetailItem
    {
        public ARDetailItem()
        {
            TransactionItems = new List<ARDetailTransactionItem>();
        }
        public string elt_account_number { get; set; }
        public string Customer_Name { get; set; }
        public string Customer_Number { get; set; }        
        public string Start { get; set;}
        public string Invoiced { get; set; }
        public string Received { get; set; }
        public string Amount { get; set; } 
        public string Balance { get; set; }
        public string To_do { get; set; }
        public List<ARDetailTransactionItem> TransactionItems
        {
            get;
            set;
        }
    }
     [Serializable]
    public class ARDetailTransactionItem
    {
        public string elt_account_number { get; set; }
        public string Customer_Name { get; set; }
        public string Customer_Number { get; set; }
        public string Start { get; set; }
        public string Invoiced { get; set; }
        public string Received { get; set; }
        public string Amount { get; set; }
        public string Balance { get; set; }
        public string Link { get; set; }
        public string Memo { get; set; }
        public string Num { get; set; }
        public string Date { get; set; }
        public string Type { get; set; }      
        public string File_No { get; set; }
    }

     [Serializable]
     public class APDetailItem
     {
         public APDetailItem()
         {
             TransactionItems = new List<APDetailTransactionItem>();
         }
         public string elt_account_number { get; set; }
         public string Customer_Name { get; set; }
         public string Customer_Number { get; set; }
         public string Start { get; set; }
         public string Billed { get; set; }
         public string Paid { get; set; }
         public string Amount { get; set; }
         public string Balance { get; set; }
         public string To_do { get; set; }
         public List<APDetailTransactionItem> TransactionItems
         {
             get;
             set;
         }
     }
     [Serializable]
     public class APDetailTransactionItem
     {
         public string elt_account_number { get; set; }
         public string Customer_Name { get; set; }
         public string Customer_Number { get; set; }
         public string Start { get; set; }
         public string Billed { get; set; }
         public string Paid { get; set; }
         public string Amount { get; set; }
         public string Balance { get; set; }
         public string Link { get; set; }
         public string Memo { get; set; }
         public string Num { get; set; }
         public string Date { get; set; }
         public string Type { get; set; }
         public string IsPosted { get; set; }
     }


    


}
