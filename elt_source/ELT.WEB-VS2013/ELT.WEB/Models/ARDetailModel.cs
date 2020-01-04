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
    public class ARDetailMasterModel
    {
        public string PeriodBegin { get; set; }
        public string PeriodEnd { get; set; }
        public string CompanyName { get; set; }
        public string KeyFieldName { get; set; }
        public List<ARDetailItem> Elements { get; set; }
    }
}