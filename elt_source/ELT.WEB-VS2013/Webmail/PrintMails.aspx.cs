using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ELT.BL;
using ELT.CDT;
public partial class PrintMails : System.Web.UI.Page {
    protected void Page_PreInit(object sender, EventArgs e) {
        Utils.ApplyTheme(this);
    }

    protected void Page_Load(object sender, EventArgs e) {
        MessageBL bl = new MessageBL();
        var Messages = bl.GetAllMessages(User.Identity.Name);
        var messages = Messages.Where(m => m.Folder != "Sent Items" && m.Folder != "Drafts").Select(m => new {
            From = m.From,
            Subject = m.Subject,
            Date = m.Date.ToShortDateString()
        });

        MailReportViewer.Report = new MailReport(messages);
    }
}
