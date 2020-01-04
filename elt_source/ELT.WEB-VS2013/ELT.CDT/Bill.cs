using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace ELT.CDT
{
    [Serializable]
    public class Bill
    {
        
        public virtual string BillNumber { get; set; }
        public virtual string ParentBillNumber { get; set; }
        public virtual Company Shipper { get; set; }
        public virtual Company Agent { get; set; }
        public virtual Company Consignee { get; set; }
        public virtual Port[] Ports { get; set; }
        public virtual Charge[] Charges { get; set; }
        public virtual Cost[] Costs { get; set; }
        public virtual DateTime CreatedDate { get; set; }
        public virtual DateTime LastUpdatedDate { get; set; }
        public virtual  int CreatedBy { get; set; }
    }

  
  
   
  

    


}
