using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ELT.CDT;
namespace ELT.WEB.Models
{
    [Serializable]
    public class HWAB:Bill
    {
        public HWAB()
        {
            base.Agent = new Company() { OperationalRole = OperationalRole.Agent };
            base.Shipper = new Company() { OperationalRole = OperationalRole.Shipper };
            base.Consignee = new Company() { OperationalRole = OperationalRole.Consignee };
            
        }
        public string HAWBNumber
        {
            get { return  base.BillNumber; }
            set { base.BillNumber = value; }
        }
        

    }
}