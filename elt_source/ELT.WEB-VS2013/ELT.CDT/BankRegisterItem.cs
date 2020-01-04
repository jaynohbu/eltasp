using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace ELT.CDT
{
    [Serializable]
    public class BankRegisterItem
    {
      
        public string elt_account_number { get; set; }
        public string Type { get; set; }
        public string Date { get; set; }
        public string CheckNo { get; set; }
        public string Memo { get; set; }
        public string Bank_Account { get; set; }
        public string Description { get; set; } 
        public string PrintCheckAs { get; set; }
        public string Clear { get; set; }
        public string Void { get; set; }
        public string Customer_Name { get; set; }
        public string Debit { get; set; }
        public string Credit { get; set; }
        public string Balance { get; set; }
        public string Link { get; set; }
    }
}
