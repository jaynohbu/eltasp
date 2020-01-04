using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    [Serializable]
    public class AuthorizedPage
    {
        public int user_id { get; set; }
        public string page_label { get; set; }
        public string top_module { get; set; }
        public string sub_module { get; set; }
        public int page_id { get; set; }
        public bool is_accessible { get; set; }
    }
}
