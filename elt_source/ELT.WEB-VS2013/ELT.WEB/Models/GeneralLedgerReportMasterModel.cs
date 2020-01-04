using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ELT.CDT;
namespace ELT.WEB.Models
{
    [Serializable]
    public class GeneralLedgerReportMasterModel
    {
        public string Total { get; set; }
        public string Cumulative_Total { get; set; }
        public List<GeneralLedgerReportItem> GeneralLedgerItems { get; set; }

        public string PeriodBegin { get; set; }
        public string PeriodEnd { get; set; }
        public string GLFrom { get; set; }
        public string GLTo { get; set; }
        public string TranType { get; set; }
    }

}