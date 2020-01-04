using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ELT.CDT
{

    [Serializable]
    public class Port
    {
        public virtual string Name { get; set; }
        public virtual string Code { get; set; }
        public virtual PortBound Bound { get; set; }
        public virtual PortType Type { get; set; }
        public virtual Address Address { get; set; }

    }
}
