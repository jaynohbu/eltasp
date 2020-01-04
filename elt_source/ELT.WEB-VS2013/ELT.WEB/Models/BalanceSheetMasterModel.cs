using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ELT.COMMON;
using ELT.CDT;
using System.Collections;


namespace ELT.WEB.Models
{
     [Serializable]
    public class BalanceSheetMasterModel
    {
         public string AsOf { get; set; }
        public string KeyFieldName { get; set; }
        public List<BalanceSheetItem> Asset { get; set; }
        public List<BalanceSheetItem> LiabilityEquity { get; set; }
    }
}