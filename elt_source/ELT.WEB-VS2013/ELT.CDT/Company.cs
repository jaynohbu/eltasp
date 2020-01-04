using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace ELT.CDT
{
    [Serializable]
    public class Company
    {
        public virtual string CompanyName { get; set; }
        public virtual int CompanyId { get; set; }
        public virtual Address Address { get; set; }
        public virtual string DoingBusinessAs { get; set; }
        public virtual List<Contact> Contacts { get; set; }
        public virtual string AccountNumber { get; set; }
        public virtual OperationalRole OperationalRole { get; set; }
        public virtual string TaxID { get; set; }
    }
}
