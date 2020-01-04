using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ELT.WEB.Models
{
    [Serializable]
    public class FileRequestModel
    {
        public string Token { get; set; }
        public int FileID { get; set; }
        public int GID { get; set; }
        public string UserEmail { get; set; }
        public string FileAccessUrl { get; set; }
    }
}