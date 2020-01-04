using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.Net.Mail;
namespace ELT.COMMON
{
    public static class Email
    {
        #region Method Definitions
      

        public static void SendSmtp(string mailTo,  string subject, string body, bool isHtmlBody, string FromAddress)
        {

            SmtpClient mailer = SetMailerServer();

            // Configure the mail message and sent it.
            MailMessage message = new MailMessage
            {
                Subject = subject,
                Body = body,
                IsBodyHtml = isHtmlBody,
                From = new MailAddress(FromAddress)
                //ReplyToList = new MailAddress(ConfigurationManager.AppSettings[ConfigurationKeys.Smtp.ReplyAddress])
            };

            message.To.Add(new MailAddress(mailTo, ""));
            try
            {
                //mailer.Send(message);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static SmtpClient SetMailerServer()
        {
            SmtpClient mailer = new SmtpClient();
            mailer.Host = ConfigurationManager.AppSettings["SMTP_SERVER"];
            mailer.Port = int.Parse(ConfigurationManager.AppSettings["SMTP_PORT"]);
            mailer.DeliveryMethod = SmtpDeliveryMethod.Network;
            mailer.Credentials = new NetworkCredential(ConfigurationManager.AppSettings["SMTP_USER_NAME"], ConfigurationManager.AppSettings["SMTP_PASSWORD"]);
            return mailer;
        }


        public static void SendSmtp(string recipientAddress,  string subject, string body, bool isHtmlBody, List<string> attachments, string FromAddress)
        {
            SmtpClient mailer = SetMailerServer();
            // Configure the mail message and sent it.
            MailMessage message = new MailMessage
            {
                Subject = subject,
                Body = body,
                IsBodyHtml = isHtmlBody,
                From = new MailAddress(FromAddress),              
            };


            foreach (var attachment in attachments)
            {
                message.Attachments.Add(new Attachment(attachment));
            }

            message.To.Add(new MailAddress(recipientAddress, ""));
            mailer.Send(message);
        }


        public static void SendSmtp(string recipientAddress,  List<string> ccAddresses, string subject, string fromAddress, string body, bool isHtmlBody)
        {
            SmtpClient mailer = SetMailerServer();
            // Configure the mail message and sent it.
            MailMessage message = new MailMessage
            {
                Subject = subject,
                Body = body,
                IsBodyHtml = isHtmlBody,
                From = new MailAddress(fromAddress),
                
            };

            foreach (var item in ccAddresses)
            {
                message.To.Add(new MailAddress(item, ""));
            }
            message.To.Add(new MailAddress(recipientAddress, ""));
            mailer.Send(message);
        }

       
      

        public static string GetEmailTemplate( string templatePath)
        {
            if (System.IO.File.Exists(templatePath))
                return System.IO.File.ReadAllText(templatePath);
            return string.Empty;
        }

        public static string ReplaceTokens(string emailBody, EmailMessageTokens tokens)
        {
            //If no tokens provided for replacement, return the email body as it is.
            if (tokens.Count == 0) return emailBody;

            foreach (EmailMessageToken token in tokens)
                emailBody = emailBody.Replace(token.TokenName, token.TokenValue);

            return emailBody;
        }

        public static EmailMessageToken SetEmailMessageToken(string key, string value)
        {
            EmailMessageToken token = new EmailMessageToken();

            token.TokenName = string.Format("${0}$", key);
            token.TokenValue = value;

            return token;
        }
        #endregion

      
    }

    #region Email Message Tokens
    public class EmailMessageToken
    {
        public string TokenName { get; set; }
        public string TokenValue { get; set; }
    }

    public class EmailMessageTokens : List<EmailMessageToken>
    {
    }
    #endregion
}
