using ELT.CDT;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ELT.WEB.Models
{
    [Serializable]
    public class PNLMasterModel
    {
        public string KeyFieldName { get; set; }
        public DateTime Begin { get; set; }
        public DateTime End { get; set; }
        public string MAWB { get; set; }
        public string AirOcean
        {
            get;
            set;
        }
        public string ImportExport
        {
            get;
            set;
        } 
        public List<PNLTransactionItem> PNLTransactionItems { get; set; }
    }
}