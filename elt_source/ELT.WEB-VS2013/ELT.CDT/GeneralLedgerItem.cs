using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    [Serializable]
    public class GeneralLedgerReportItem
    {
        public GeneralLedgerReportItem()
        {
            TransactionItems = new List<GeneralLedgerTransactionalItem>();
        }
        public string elt_account_number { get; set; }    
        public string GL_Number { get; set; }
        public string GL_Name { get; set; }
        public string Start_Balance { get; set; }
        public string Debit { get; set; }
        public  string Credit { get; set; }      
      
        public List<GeneralLedgerTransactionalItem> TransactionItems { get; set; }
       
    }
    public class GeneralLedgerTransactionalItem
    {
        
        public string elt_account_number { get; set; }
        public string GL_Number { get; set; }
        public string Date { get; set; }
        public string GL_Name { get; set; }
        public string Type { get; set; }
        public string Company_Name { get; set; }
        public string Debit { get; set; }
        public string Credit { get; set; }
        public string Amount { get; set; }
        
        public string Num { get; set; } 
        public string Link { get; set; }
        public string Memo { get; set; }
        public string Split { get; set; }
      
    }
}
