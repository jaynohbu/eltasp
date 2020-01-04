using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{

    public interface IMessage
    {
        int ID { get; set; }
        string Subject { get; set; }
        DateTime Date { get; set; }
        string From { get; set; }
        string To { get; set; }
        string Text { get; set; }
        string Folder { get; set; }
        bool HasAttachment { get; set; }
        bool IsReply { get; set; }
        bool Unread { get; set; }
    }
}
