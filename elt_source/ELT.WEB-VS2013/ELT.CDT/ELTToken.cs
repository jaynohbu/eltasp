using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    public class ELTToken
    {
        public string Token { get; set; }
        public TokenType TokenType { get; set; }
        public string RecipientEmail { get; set; }
        public bool Expired { get; set; }
        public DateTime TimeStart { get; set; }
        public DateTime TimeEnd { get; set; }
        public DateTime CreatedDate { get; set; }
        public int Period { get; set; }

    }
}
