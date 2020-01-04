using System;
using System.Collections.Generic;
using System.Data.Linq;
using System.IO;
using System.Linq;
using System.Web;


namespace ELT.CDT
{
    [Serializable]
    public class ELTFileSystemItem
    {
        public int OrgId { get; set; }
        public string Owner_Email { get; set; }
        public int ID { get; set; }
        public int ParentID { get; set; }
        public string Name { get; set; }
        public bool IsFolder { get; set; }
        public Binary Data { get; set; }
        public DateTime LastWriteTime { get; set; }
    }
}
