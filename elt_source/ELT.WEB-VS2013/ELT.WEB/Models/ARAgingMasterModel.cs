using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ELT.CDT;
namespace ELT.WEB.Models
{
    public class ARAgingMasterModel
    {
        public string AsOf { get; set; }
        public string Branch { get; set; }
        public string Company { get; set; }
        public string KeyFieldName { get; set; }
        public List<ARAgingItem> Elements { get; set; }
    }
}