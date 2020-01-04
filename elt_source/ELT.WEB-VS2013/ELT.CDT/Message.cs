using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{

    public class Message : IMessage
    {
        DateTime _date;
        string _to;
        public int ID { get; set; }
        public string Subject { get; set; }
        public DateTime Date { get { return _date; } set { _date = value; } }
        public string From { get; set; }
        public string To { get { return _to; } set { _to = value; } }
        public string Text { get; set; }
        public string Folder { get; set; }
        public bool HasAttachment { get; set; }
        public bool IsReply { get; set; }
        public bool Unread { get; set; }
    }
}
