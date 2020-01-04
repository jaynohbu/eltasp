using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ELT.CDT;
namespace ELT.WEB.Models
{
    [Serializable]
    public class ExpenseReportMasterModel
    {
        public string Total { get; set; }
        public string Cumulative_Total { get; set; }
        public List<ExpenseItem> ExpenseItems { get; set; }

        public string PeriodBegin { get; set; }
        public string PeriodEnd { get; set; }
       
    }

    

   

}
