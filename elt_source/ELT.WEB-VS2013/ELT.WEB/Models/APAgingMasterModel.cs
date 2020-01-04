using ELT.CDT;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ELT.WEB.Models
{
    public class APAgingMasterModel
    {
        public string KeyFieldName { get; set; }
        public List<APAgingItem> Elements { get; set; }

        public string AsOf { get; set; }
        public string Branch { get; set; }
        public string Company { get; set; }
    }
}