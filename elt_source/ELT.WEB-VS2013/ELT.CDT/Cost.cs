using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace ELT.CDT
{
    [Serializable]
    public class Cost
    {
        public virtual decimal Amount { get; set; }
        public virtual string Name { get; set; }
        public virtual int Type { get; set; }
        public virtual string Detail { get; set; }
        public virtual string Memo { get; set; }
    }
}
