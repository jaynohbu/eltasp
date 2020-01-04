using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    [Serializable]
    public class ARAgingTransactionalItem
    {
        public string More_Than_Three_Month { get; set; }
        public string Customer_Number { get; set; }
        public string Company_Name { get; set; }
        public string Type { get; set; }
        public string Term { get; set; }
        public string Aging { get; set; }
        public string Open_Balance { get; set; }
        public string IV_Date { get; set; }
        public string IV_Number { get; set; }
        public string House_Type { get; set; }
        public string House_Number { get; set; }
        public string Ref_Number { get; set; }
        public string Due_Date { get; set; } 
        public string Current { get; set; }
        public string One_Month { get; set; }
        public string Two_Month { get; set; }
        public string Three_Month { get; set; }
        public string Total { get; set; }   

    }
}
