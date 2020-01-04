using System;
using System.IO;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Net.Mail;
using System.ComponentModel;


/// <summary>
/// Summary description for GoofyMailSender
/// </summary>
public class GoofyMailSender 
{
    protected MailMessage mail;
    protected int threadNum = 10;
    protected string threadID;
    protected SmtpClient client = null;
    protected static bool mailSent;
    protected string sendlog = null;
    
	public GoofyMailSender(string host)
	{
        client = new SmtpClient(host, 25);
	}

    //[STAThread]
    public bool SendMail(string to, string from, string subject, string body, string token)
    {
        try
        {
            mail = new MailMessage(from, to, subject, body);
            mail.IsBodyHtml = true;
            
            /*
            client.SendCompleted += new SendCompletedEventHandler(SendCompletedCallback);
            client.SendAsync(mail, token);
            if (mailSent == false)
            {
                client.SendAsyncCancel();
            }
            */
            client.Send(mail);
            mail.Dispose();
            mailSent = true;

        }
        catch {
            mailSent = false;
        }
        return mailSent;
    }    
    //Added by Stanley 10/23/2007
    public bool SendMailWithAttachment(string to, string from, string subject, string body, string token)
    {
        try
        {
            mail = new MailMessage(from, to, subject, body);
            mail.IsBodyHtml = true;
            mailSent = true;

        }
        catch
        {
            mailSent = false;
        }
        return mailSent;
    }

    //Added by Stanley 10/23/2007
    public bool SendMailWithCC(string to, string from, string subject, string body, string CC,string token)
    {
        try
        {
            mail = new MailMessage(from, to, subject, body);
            if (CC.Length != 0)
            {
                // attach CC
                mail.CC.Add(CC);
            }
            mail.IsBodyHtml = true;
            mailSent = true;
        }
        catch
        {
            mailSent = false;
        }

        return mailSent;
    }

    //Added on 10/23/2007
    public bool AttachBinary(byte[] filebyte, string fileName, string type)
    {
        try
        {

            MemoryStream ms = new MemoryStream(filebyte);
            mail.Attachments.Add(new Attachment(ms, fileName, type));
            /*MemoryStream ms = new MemoryStream(filebyte);
            ms.Write(filebyte, 0, filebyte.Length);
            Attachment data = new Attachment(ms, fileName, type);
            mail.Attachments.Add(data);
            ms.Close();*/
            mailSent = true;
       }
        catch
        {
            mailSent = false;
        }
        return mailSent;
    }

    //Added by Stanley 10/23/2007
    public bool AttachFile(string filelocation)
    {
        try
        {
           Attachment attachfile = new Attachment(filelocation);
            mail.Attachments.Add(attachfile);
            mailSent = true;
        }
        catch
        {
            mailSent = false;
        }
        return mailSent;
    }

    //Added by Stanley 10/23/2007
    public bool AttachDateFile(byte[] filebyte, string FileName, string fileLocation, int lengthx)
    {
        try
        {
            FileStream fs = new FileStream(fileLocation, FileMode.CreateNew, FileAccess.Write);
            MemoryStream ms = new MemoryStream(filebyte);
            byte[] decompressedData = new byte[lengthx];
            fs.Write(filebyte, 0, lengthx);
            Attachment data = new Attachment(fs,FileName);
            mail.Attachments.Add(data);
            fs.Close();
        }
        catch
        {
            mailSent = false;
        }
        return mailSent;
    }

    //send mail
    public bool MailSend()
    {
        try
        {
            client.Send(mail);
            mail.Dispose();
            mailSent = true;
        }
        catch
        {
            mailSent = false;
        }
        return mailSent;
    }
    private void SendCompletedCallback(object sender, AsyncCompletedEventArgs e)
    {
        string token = (string)e.UserState;
        //string result = "unknown";

        if (e.Cancelled)
        {
            sendlog = "Canceled";
        }
        if (e.Error != null)
        {
            sendlog = "failed: " + token + " " + e.Error.Message;
        }
        else
        {
            sendlog = "Mail sent";
        }
        mailSent = true;
    }
}
