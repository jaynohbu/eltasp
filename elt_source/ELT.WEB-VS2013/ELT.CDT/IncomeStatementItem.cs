using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    [Serializable]
    public class IncomeStatementItem
    {
        /*
         * Area                             
         * Category                        
         * Type                            
         * GL_Number                       
         * GL_Name                      
         * Amount
         */
        public string Area { get; set; }
        public string Category { get; set; }
        public string SubCategory { get; set; }
        public string Type { get; set; }
        public string GlAccountNumber { get; set; }
        public string GLAccountName { get; set; }
        public string Amount { get; set; }
    }
}
