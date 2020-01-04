using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ELT.CDT;
namespace ELT.WEB.Models
{
    [Serializable]
    public class SalesReportMasterModel
    {
        public string Total { get; set; }
        public string Cumulative_Total { get; set; }
        public List<SalesItem> SalesItems { get; set; }
        public string PeriodBegin { get; set; }
        public string PeriodEnd{ get; set; }
        public string CompanyName { get; set; }
    }

  


    
}