using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.DA;
using ELT.CDT;
namespace ELT.BL
{
    public class MessageBL
    {
        public void CopyAttachment(int GID, string RecipientEmail, int ParentID)
        {

            MessagesDA da = new MessagesDA();
            da.CopyAttachment(GID, RecipientEmail, ParentID);
        }
        public List<string> GetAllMailNodes(string account_email)
        {
            MessagesDA da = new MessagesDA();
            return da.GetAllMailNodes(account_email);
        }
        public List<Message> UnreadMessages(string account_email)
        {
            MessagesDA da = new MessagesDA();
            return da.UnreadMessages(account_email);
        }
        public List<Message> GetAllMessages(string account_email)
        {
             MessagesDA da = new MessagesDA();
             return da.GetAllMessages(account_email);
        }
        public void AddMessage(string subject, string from, string to, string text, string folder, bool isReply)
        {
            MessagesDA da = new MessagesDA();
            da.AddMessage( subject,  from,  to,  text,  folder, isReply );           
        }
        public void UpdateMessage(int id, string subject, string to, string text, string folder)
        {
            MessagesDA da = new MessagesDA();
            da.UpdateMessage( id,  subject,  to,  text,  folder);
        }
        public void MarkMessagesAs(bool read, IEnumerable<int> ids)
        {

            MessagesDA da = new MessagesDA();
            da.MarkMessagesAs(read, ids);

        }
        public void DeleteMessages(IEnumerable<int> ids)
        {
            MessagesDA da = new MessagesDA();
            da.DeleteMessages(ids);           
        }


        public int CreateFileAttachmentGroup(string OriginatorEmail, string ReferenceNo, int ReferenceType)
        {
            MessagesDA da = new MessagesDA();
            return da.CreateFileAttachmentGroup( OriginatorEmail, ReferenceNo, ReferenceType);
        }

        public int LogFileAttachment(string Name, int FileID, int GID, string RecipientEmail)
        {
            MessagesDA da = new MessagesDA();
            return da.LogFileAttachment(Name, FileID, GID, RecipientEmail);
        }

        public List<AttachmentLog> GetAttachmentLog(int GID)
        {
            MessagesDA da = new MessagesDA();
            return da.GetAttachmentLog(GID);       

        }

       // COMM.GetAttachmentLog
        
     
    }

    
}
