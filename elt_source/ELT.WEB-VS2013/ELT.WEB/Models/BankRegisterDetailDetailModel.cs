using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ELT.COMMON;
using ELT.CDT;
using System.Collections;
using DevExpress.Web.Mvc;

namespace ELT.WEB.Models
{
    public class BankRegisterDetailModel
    {
        public string Key { get; set; }
        public string KeyFieldName { get; set; }
        public List<BankRegisterItem> Elements { get; set; }
        public GridViewSettings Settings { get; set; }
    }
}