using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ELT.COMMON;
using ELT.CDT;
using System.Collections;

namespace ELT.WEB.Models
{
    public class BankRegisterMasterModel
    {
        public string KeyFieldName { get; set; }
        public List<BankRegisterItem> Elements { get; set; }
    }
}