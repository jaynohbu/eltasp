using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ELT.CDT
{
    [Serializable]
    public class EmailAttachment
    {
        public int FileID
        {
            get;
            set;
        }

        public string FileName
        {
            get;
            set;

        }
        public string GeneratorPath
        {
            get;
            set;
        }
        public string Owner_Email
        {
            get;
            set;
        }
        public bool IsSelected
        {
            get;
            set;
        }
    }
}
