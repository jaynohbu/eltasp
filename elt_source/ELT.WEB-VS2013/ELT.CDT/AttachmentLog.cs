using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    public class AttachmentLog
    {
        public int ID { get; set; }
        public int GID { get; set; }
        public string SenderEmail { get; set; }
        public string ReferenceNo { get; set; }
        public string RecipientEmail { get; set; }
        public int FileID { get; set; }
        public bool IsDelivered { get; set; }
       
    }
}
