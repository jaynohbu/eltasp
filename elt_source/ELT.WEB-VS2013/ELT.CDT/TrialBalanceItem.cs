using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    [Serializable]
    public class TrialBalanceItem
    {
        /*
         * gl_account_number              
         * gl_account_name                  
         * Debit                           
         * Credit                          
         * Balance
         */

        public string GlAccountNumber { get; set; }
        public string GLAccountName { get; set; }
        public string DebitAmt { get; set; }
        public string CreditAmt { get; set; }
        public string Balance { get; set; }
    }
}
