using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using DevExpress.Data.Filtering;
using DevExpress.Web.ASPxClasses;
using DevExpress.Web.ASPxGridView;
using System.Web.UI.WebControls;
using System.Web.UI;
using ELT.BL;
using ELT.CDT;
using DevExpress.Web.ASPxTreeView;
public partial class _Default : System.Web.UI.Page {
    const string
        PreviewMessageFormat = 
            "<div class='MailPreview'>" +
                "<div class='Subject'>{0}</div>" +
                "<div class='Info'>" +
                    "<div>From: {1}</div>" +
                    "<div>To: {2}</div>" +
                    "<div>Date: {3:g}</div>" +
                "</div>" +
                "<div class='Separator'></div>" +
                "<div class='Body'>{4}</div>" +
            "</div>",
        ReplyMessageFormat = "Hi,<br/><br/><br/><br/>Thanks,<br/>Thomas Hardy<br/><br/><br/>----- Original Message -----<br/>Subject: {0}<br/>From: {1}<br/>To: {2}<br/>Date: {3:g}<br/>{4}",
        NotFoundMessageFormat = "<h1>Can't find message with the key={0}</h1>";

    protected string SearchText { get { return Utils.GetSearchText(this); } }

    protected void Page_PreInit(object sender, EventArgs e) {
        Utils.ApplyTheme(this);
    }

    protected void Page_Init(object sender, EventArgs e) {
        if(!IsPostBack)
            MailTree.SelectedNode = MailTree.Nodes.FindByText("Inbox");
    }

    protected void Page_Load(object s, EventArgs e) {

       
        if(ShouldBindGrid())
            BindGrid();
        if(MailFormPanel.IsCallback || IsPostBack && !IsCallback) {
          
            ContactsBL bl = new ContactsBL();
            var Contacts = bl.GetAllContacts(User.Identity.Name);
            AddressesList.DataSource =Contacts.Select(c => new {
                Text = c.Name,
                Value = c.Email,
                ImageUrl = Utils.GetContactPhotoUrl(c.PhotoUrl)
            });
            AddressesList.DataBind();
        }

        MailGrid.DataColumns["To"].Visible = ShowToColumn();
        MailGrid.DataColumns["From"].Visible = !ShowToColumn();

        
    }

 

    void BindGrid() {       
        MailGrid.DataSource = SelectMessages();
      
        MailGrid.DataBind();
        
    }

    bool ShouldBindGrid() {
        return !IsCallback || MailGrid.IsCallback;
    }

    protected bool ShowToColumn() {
        return MailTree.SelectedNode.Name == "Sent Items" || MailTree.SelectedNode.Name == "Drafts";
    }

    protected void MailPreviewPanel_Callback(object sender, CallbackEventArgsBase e) {
        int id;
        var text = string.Format(NotFoundMessageFormat, e.Parameter);
        if(int.TryParse(e.Parameter, out id)) {
            MessageBL bl = new MessageBL();
           var Messages= bl.GetAllMessages(User.Identity.Name);
            var message = Messages.FirstOrDefault(m => m.ID == id);
            if(message != null) {
                bl.MarkMessagesAs(true, new int[] { id });
                var subject = message.Subject;
                if(message.IsReply)
                    subject = "Re: " + subject;
                text = string.Format(PreviewMessageFormat, subject, message.From, message.To, message.Date, message.Text);
            }
        }
        MailPreviewPanel.Controls.Add(new LiteralControl(text));
    }

  
    protected void MailGrid_CustomDataCallback(object sender, ASPxGridViewCustomDataCallbackEventArgs e) {
        Session["CurrentReplyEmailID"] = null;
        var args = e.Parameters.Split('|');
        if(args[0] == "MailForm" && args[1] == "Reply" && args.Length == 3) {
            int id;
            if(!int.TryParse(args[2], out id))
                return;
            MessageBL bl = new MessageBL();
            var Messages = bl.GetAllMessages(User.Identity.Name);
            var message = Messages.FirstOrDefault(m => m.ID == id);
            if(message == null)
                return;
            var result = new Dictionary<string, string>();

            Session["CurrentReplyEmailID"] = id;
            result["To"] = message.To;

            var subject = message.Subject;
            if(!subject.StartsWith("Re: "))
                subject = "Re: " + subject;
            result["Subject"] = subject;

            result["Text"] = FormatMessageCore(message, ReplyMessageFormat);
            e.Result = result;
        }
        if(args[0] == "MailForm" && args.Length == 3 && args[1] == "EditDraft") {
            int id;
            if(!int.TryParse(args[2], out id))
                return;
            MessageBL bl = new MessageBL();
            var Messages = bl.GetAllMessages(User.Identity.Name);
            var message = Messages.FirstOrDefault(m => m.ID == id);
            if(message == null)
                return;
            var result = new Dictionary<string, string>();
            result["To"] = message.To;
            result["Subject"] = message.Subject;
            result["Text"] = message.Text;
            e.Result = result;
        }
        if(args[0] == "MarkAs" && args.Length > 2) {
            var read = args[1] == "Read";
            int[] keys = null;
            if(!TryParseKeyValues(args.Skip(2), out keys))
                return;
            MessageBL bl = new MessageBL();
            bl.MarkMessagesAs(read, keys);
        }
    }

    protected void MailGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e) {
        if(string.IsNullOrEmpty(e.Parameters))
            return;
        var args = e.Parameters.Split('|');
        if(args[0] == "FolderChanged") {
            MailGrid.FilterExpression = "";
            BindGrid();
            MailGrid.ExpandAll();
        }
        if(args[0] == "Search") {
            if(string.IsNullOrEmpty(SearchText))
                MailGrid.FilterExpression = "";
            CriteriaOperator criteria = new GroupOperator(GroupOperatorType.Or,
                new FunctionOperator(FunctionOperatorType.Contains, new OperandProperty(ShowToColumn() ? "To" : "From"), SearchText),
                new FunctionOperator(FunctionOperatorType.Contains, new OperandProperty("Subject"), SearchText)
            );
            MailGrid.FilterExpression = criteria.ToString();

            BindGrid();
            MailGrid.ExpandAll();
        }
        if(args[0] == "SendMail" || args[0] == "SaveMail") {
            var subject = SubjectEditor.Text;
            var to = ToEditor.Text;
            string messageText = MailEditor.Html.Length <= 10000 ? MailEditor.Html : MailEditor.Html.Substring(0, 10000);
            string folder = args[0] == "SendMail" ? "Sent Items" : "Drafts";
            int id;
            if (args.Length == 2 && int.TryParse(args[1], out id))
            {
                MessageBL bl = new MessageBL();
                bl.UpdateMessage(id, subject, to, messageText, folder);
            }
            else
            {
                MessageBL bl = new MessageBL();
                bool IsReply = false;
                if (Session["CurrentReplyEmailID"] != null)
                {
                    IsReply = true;
                }
                bl.AddMessage(subject, User.Identity.Name, to, messageText, folder, IsReply);
            }

            Session["CurrentReplyEmailID"] = null;
            BindGrid();
        }
        if(args[0] == "Delete" && args.Length > 1) {
            int[] keys = null;
            if(!TryParseKeyValues(args.Skip(1), out keys))
                return;

            MessageBL bl = new MessageBL();

            bl.DeleteMessages(keys);
            BindGrid();
        }
    }

    protected void MailGrid_CustomJSProperties(object sender, ASPxGridViewClientJSPropertiesEventArgs e) {
        if(MailTree.SelectedNode.Name == "Inbox") {
            var list = new List<IMessage>();
            for(var i = 0; i < MailGrid.VisibleRowCount; i++) { 
                if(MailGrid.IsGroupRow(i)) continue;
                var message = MailGrid.GetRow(i) as IMessage;
                if(message != null)
                    list.Add(message);
            }
            e.Properties["cpVisibleMailKeysHash"] = GetMessagesKeyMap(list);
        }
    }

    protected void MailTree_CustomJSProperties(object sender, CustomJSPropertiesEventArgs e) {
        MessageBL bl = new MessageBL();
        e.Properties["cpUnreadMessagesHash"] = GetMessagesKeyMap(bl.UnreadMessages(""));
    }

    protected void MailGrid_CustomColumnDisplayText(object sender, ASPxGridViewColumnDisplayTextEventArgs e) {
        if(e.Column.FieldName == "Subject" && (bool)e.GetFieldValue("IsReply"))
            e.DisplayText = "Re: " + HttpUtility.HtmlEncode(e.Value);
        if(e.Column.FieldName == "To") {
            var list = new List<string>();
            foreach(var item in e.Value.ToString().Split(',')) {
                var email = item.Trim();
                ContactsBL bl = new ContactsBL();
                var Contacts = bl.GetAllContacts(User.Identity.Name);
                var contact = Contacts.FirstOrDefault(c => c.Email == email);
                list.Add(contact != null ? contact.Name : email);
            }
            e.DisplayText = string.Join(", ", list);
        }
        if(e.Column.FieldName == "From") {
            var from = e.Value.ToString();
            ContactsBL bl = new ContactsBL();
            var Contacts = bl.GetAllContacts(User.Identity.Name);
            var contact = Contacts.FirstOrDefault(c => c.Email == from);
            e.DisplayText = contact != null ? contact.Name : from;
        }
        if(!string.IsNullOrEmpty(SearchText) && (e.Column.FieldName == "From" || e.Column.FieldName == "To" || e.Column.FieldName == "Subject")) {
            string text = string.IsNullOrEmpty(e.DisplayText) ? e.Value.ToString() : e.DisplayText;
            e.DisplayText = new Regex(SearchText, RegexOptions.IgnoreCase).Replace(text, "<span class='hgl'>$0</span>");
        }
    }

    protected void MailGrid_CustomGroupDisplayText(object sender, ASPxGridViewColumnDisplayTextEventArgs e) {
        if(e.Column.FieldName == "Subject")
            e.DisplayText = HttpUtility.HtmlEncode(e.Value);
    }

    List<Message> SelectMessages() {
     
        MessageBL BL = new MessageBL();
        var Messages = BL.GetAllMessages(User.Identity.Name);
        var result = Messages.AsQueryable();
        if(MailTree.SelectedNode.Text == "Inbox")
            result = result.Where(m => m.Folder != "Sent Items" && m.Folder != "Drafts");
        else
            result = result.Where(m => m.Folder == MailTree.SelectedNode.Text);
        return result.ToList();
    }

    string FormatMessageCore(IMessage message, string format) {
        var subject = message.Subject;
        if(message.IsReply)
            subject = "Re: " + subject;
        return string.Format(format, subject, message.From, message.To, message.Date, message.Text);
    }

    protected bool TryParseKeyValues(IEnumerable<string> stringKeys, out int[] resultKeys) {
        resultKeys = null;
        var list = new List<int>();
        foreach(var sKey in stringKeys) {
            int key;
            if(!int.TryParse(sKey, out key))
                return false;
            list.Add(key);
        }
        resultKeys = list.ToArray();
        return true;
    }

    Dictionary<string, List<string>> GetMessagesKeyMap(IEnumerable<IMessage> messages) {
        var dict = new Dictionary<string, List<string>>();
        var query = messages.GroupBy(m => m.Folder).Where(g => g.Count() > 0);
        foreach(var item in messages.GroupBy(m => m.Folder).Where(g => g.Count() > 0))
            dict.Add(item.Key, item.Select(m => m.ID.ToString()).ToList());
        return dict;
    }
}
