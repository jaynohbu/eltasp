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
    public class OceanReportMasterModel
    {
        public string CategorizeBy
        {
            get;
            set;
        }
        public DateTime PeriodEnd
        {
            get;
            set;
        }
        public string WeightScale
        {
            get;
            set;
        }
        public DateTime PeriodBegin
        {
            get;
            set;
        }
        public string AnalysisOn
        {
            get;
            set;
        }
        public string KeyFieldName { get; set; }
        public List<OceanTransactionItem> Elements { get; set; }
    }
}