using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ELT.CDT
{
    [Serializable]
    public class Address
    {
        public virtual string Address1 { get; set; }
        public virtual string Address2 { get; set; }
        public virtual string ZipCode { get; set; }
        public virtual string City { get; set; }
        public virtual string State { get; set; }
        public virtual string Country { get; set; }
    }
}
