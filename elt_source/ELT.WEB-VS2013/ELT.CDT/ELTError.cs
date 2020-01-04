using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    public class ELTError
    {
        public ELTErrorType Type { get; set; }
        public string Description { get; set; }
        public int ReferenceID { get; set; }
    }
}
