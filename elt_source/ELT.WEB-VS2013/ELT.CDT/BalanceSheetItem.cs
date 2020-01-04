using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    [Serializable]
    public class BalanceSheetItem
    {       
        public string Category { get; set; }
        public string Type { get; set; }        
        public string GlAccountNumber { get; set; }
        public string GLAccountName { get; set; }
        public string Amount { get; set; }
        public string BeginBalance { get; set; }
    }
}
