using ELT.CDT;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ELT.WEB.Models
{
    [Serializable]
    public class APDisputeMasterModel
    {
        public string PeriodBegin { get; set; }
        public string PeriodEnd { get; set; }
        public string VendorName { get; set; }
        public string KeyFieldName { get; set; }
        public List<APDisputeItem> Elements { get; set; }
    }
}