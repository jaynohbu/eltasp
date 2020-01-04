using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ELT.BL;
using ELT.WEB.Models;
using ELT.CDT;
using ELT.COMMON;
using System.Configuration;
using System.IO;
using System.Globalization;
using System.Data.Linq;
using Neodynamic.SDK.Web;
using ELT.WEB.DataProvider;
namespace ELT.WEB.Controllers
{
    [Authorize]
    public class OperationBaseController : ControllerBase
    {
       

        const string PRINTER_COMMANDS = "-PrinterCommands";
        public void PrintCommands(string sid)
        {
            if (WebClientPrint.ProcessPrintJob(System.Web.HttpContext.Current.Request))
            {
                HttpApplicationStateBase app = HttpContext.Application;
                //Create a ClientPrintJob obj that will be processed at the client side by the WCPP
                ClientPrintJob cpj = new ClientPrintJob();
                //get printer commands for this user id
                object printerCommands = app[sid + PRINTER_COMMANDS];
                if (printerCommands != null)
                {
                    cpj.PrinterCommands = printerCommands.ToString();
                    cpj.FormatHexValues = true;
                }
                cpj.ClientPrinter = new UserSelectedPrinter();
                //Send ClientPrintJob back to the client
                cpj.SendToClient(System.Web.HttpContext.Current.Response);
            }

        }

        [HttpPost]
        public void SetPrintCommand(string sid, string printerCommands)
        {
            try
            {
                HttpApplicationStateBase app = HttpContext.Application;
                app[sid + PRINTER_COMMANDS] = printerCommands;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public ActionResult _NotificationEmailItems(EmailNotificationFormModel model)
        {
            if (string.IsNullOrEmpty(model.BillNumber))
            {
                return PartialView(model);
            }
            ViewBag.Message = string.Empty;
            if (model.ShouldSend)
            {
                if (model.EmailType == EmailType.AirExport_Agent_PreAlert)
                {
                    SendAgentPreAlertEmails(model);
                }
                if (model.EmailType == EmailType.AirExport_Shipping_Notice)
                {
                    SendShippingNoticeEmails(model);
                }
            }
            if (Session["mailerSelectedBillType"] != null)
            {
                int billType = Convert.ToInt32(Session["mailerSelectedBillType"]);
               
                if (model.EmailType == ELT.CDT.EmailType.AirExport_Agent_PreAlert)
                {
                    AirExportBL BL = new AirExportBL();
                    model.Items = BL.GetAirExportAgentPreAlertEmailItems(int.Parse(GetCurrentELTUser().elt_account_number), model.BillNumber, (BillType)billType);
                }
                if (model.EmailType == ELT.CDT.EmailType.AirExport_Shipping_Notice)
                {
                    AirExportBL BL = new AirExportBL();
                    model.Items = BL.GetAirExportShippingNoticeEmailItems(int.Parse(GetCurrentELTUser().elt_account_number), model.BillNumber, (BillType)billType);
                }
                if (model.EmailType == ELT.CDT.EmailType.OceanExport_Agent_PreAlert)
                {
                    OceanExportBL BL = new OceanExportBL();
                    model.Items = BL.GetOceanExportAgentPreAlertEmailItems(int.Parse(GetCurrentELTUser().elt_account_number), model.BillNumber, (BillType)billType);
                }
                if (model.EmailType == ELT.CDT.EmailType.OceanExport_Shipping_Notice)
                {
                    OceanExportBL BL = new OceanExportBL();
                    model.Items = BL.GetOceanExportShippingNoticeEmailItems(int.Parse(GetCurrentELTUser().elt_account_number), model.BillNumber, (BillType)billType);
                }
                if (model.EmailType == ELT.CDT.EmailType.AirImport_E_Arrival_Notice)
                {
                    AirImportBL BL = new AirImportBL();
                    model.Items.AddRange(BL.GetAirImportEArrivalNoticeEmailItems(int.Parse(GetCurrentELTUser().elt_account_number), model.BillNumber, (BillType)billType).ToArray());
                }
                if (model.EmailType == ELT.CDT.EmailType.AirImport_Proof_Of_Delivery)
                {
                    AirImportBL BL = new AirImportBL();
                    model.Items.AddRange(BL.GetAirImportProofOfDeliveryEmailItems(int.Parse(GetCurrentELTUser().elt_account_number), model.BillNumber, (BillType)billType).ToArray());
                }
                if (model.EmailType == ELT.CDT.EmailType.OceanImport_E_Arrival_Notice)
                {
                    OceanImportBL BL = new OceanImportBL();
                    model.Items.AddRange(BL.GetOceanImportEArrivalNoticeEmailItems(int.Parse(GetCurrentELTUser().elt_account_number), model.BillNumber, (BillType)billType).ToArray());
                }
                if (model.EmailType == ELT.CDT.EmailType.OceanImport_Proof_Of_Delivery)
                {
                    OceanImportBL BL = new OceanImportBL();
                    model.Items.AddRange(BL.GetOceanImportProofOfDeliveryEmailItems(int.Parse(GetCurrentELTUser().elt_account_number), model.BillNumber, (BillType)billType).ToArray());
                }
                if (model.EmailType == ELT.CDT.EmailType.DomesticFreight_Agent_PreAlert)
                {
                    DomesticFreightBL BL = new DomesticFreightBL();
                    model.Items = BL.GetDomesticFreightAgentPreAlertEmailItems(int.Parse(GetCurrentELTUser().elt_account_number), model.BillNumber, (BillType)billType);
                }
                if (model.EmailType == ELT.CDT.EmailType.DomesticFreight_Shipping_Notice)
                {
                    DomesticFreightBL BL = new DomesticFreightBL();
                    model.Items = BL.GetDomesticFreightShippingNoticeEmailItems(int.Parse(GetCurrentELTUser().elt_account_number), model.BillNumber, (BillType)billType);
                }
            }
            return PartialView(model);
        }
        public ActionResult _BillSelectionBox(EmailNotificationFormModel model)
        {
            Session["mailerSelectedBillType"] = model.BillType;
            return PartialView(model);
        }
        public ActionResult _SelectBill()
        {
            ViewBag.GetAirExportBillNos = BillNumberListDataProvider.GetAirExportBillNos();
            return PartialView();
        }
        public ActionResult OtherCharges()
        {
            return new EmptyResult();
        }

        public ActionResult GetScheduleB()
        {
            string description = Request.QueryString["description"];
            AESBL AESBL = new AESBL();
            var item = AESBL.GetScheduleB(GetCurrentELTUser().elt_account_number, description);
            return Json(item, JsonRequestBehavior.AllowGet);
        }
        protected void GeneratePDFFiles(EmailAttachment attachment, List<EmailAttachment> ListWithID)
        {

            FileSystemBL FSBL = new FileSystemBL();
            if (attachment.IsSelected)
            {
                var count = (from c in ListWithID where c.FileName == attachment.FileName select c).Count();
                if (count == 0)
                {
                    Stream receiveStream = null;
                    ELT.COMMON.Util.ReadFileStream(Url.Content(attachment.GeneratorPath), ref receiveStream);
                    if (receiveStream != null)
                    {
                        using (var memoryStream = new MemoryStream())
                        {
                            receiveStream.CopyTo(memoryStream);
                            Byte[] array = memoryStream.ToArray();
                            ELTFileSystemItem item = new ELTFileSystemItem() { Data = new Binary(array), Name = attachment.FileName + ".pdf", ParentID = -1, Owner_Email = "generator@e-logitech.net" };

                            FSBL.InsertFile(item);
                            attachment.FileID = item.ID;
                            ListWithID.Add(attachment);
                        }
                    }
                }
            }
        }      
        protected void SendAgentPreAlertEmails(EmailNotificationFormModel model)
        {
            MessageBL MsgBL = new MessageBL();
            TokenBL tBL = new TokenBL();
            List<EmailAttachment> ListWithID = new List<EmailAttachment>();
            int GID = 0;
            string Token = string.Empty;
            int billType = Convert.ToInt32(Session["mailerSelectedBillType"]);

            foreach (var mailItem in model.Items)
            {
                if (mailItem.IsSelected)
                {
                    //Create File Group and get the GID
                    GID = MsgBL.CreateFileAttachmentGroup(User.Identity.Name, model.BillNumber, billType);
                    tBL.CreateToken(ref Token, TokenType.Agent_PreAlert, mailItem.RecipientEmail, true, AppConstants.TOKEN_PERIOD_FILE_ACCESS);
                    string Attachments = "<ul>";
                    foreach (var attachment in mailItem.Attachments)
                    {
                        if (attachment.FileID == 0 && attachment.IsSelected)
                        {
                            //Generate PDF files
                            GeneratePDFFiles(attachment, ListWithID);
                            MsgBL.LogFileAttachment(attachment.FileName, attachment.FileID, GID, mailItem.RecipientEmail);
                            Attachments += "<li><a href='" + ConfigurationManager.AppSettings["URL.MailerRedirect.FileViewer"] + "?GID=" + GID + "&FileID=" + attachment.FileID + "&Token=" + Token + "&UserEmail=" + mailItem.RecipientEmail + "'>" + attachment.FileName + "</a></li>";
                        }
                    }
                    Attachments += "</ul>";
                    //Create Links
                    //Create a Token                    
                    //GET MessageTemplate 
                    string emailBody = string.Empty;
                    
                    Email.GetEmailTemplate(Server.MapPath(EmailConstants.PATH_TEMPLATE_AGENT_PRE_ALERT));
                    
                    string emailSubject = EmailConstants.SUBJECT_AGENT_PRE_ALERT;
                    if (!string.IsNullOrEmpty(mailItem.Subject)) { emailSubject = mailItem.Subject; }
                    EmailMessageTokens tokens = new EmailMessageTokens();
                    var eltuser = GetCurrentELTUser();

                    string sender = CultureInfo.InvariantCulture.TextInfo.ToTitleCase(eltuser.user_fname) +
                    " " + CultureInfo.InvariantCulture.TextInfo.ToTitleCase(eltuser.user_lname);
                    if (string.IsNullOrEmpty(sender.Trim())) sender = User.Identity.Name;
                    tokens.Add(Email.SetEmailMessageToken("CompanyName", eltuser.company_name));
                    tokens.Add(Email.SetEmailMessageToken("SenderName", sender));
                    tokens.Add(Email.SetEmailMessageToken("BillNo", model.BillNumber));
                    tokens.Add(Email.SetEmailMessageToken("MessageBody", mailItem.TextMessage));
                    tokens.Add(Email.SetEmailMessageToken("Attachments", Attachments));

                    //Swap Tokens with data
                    emailBody = Email.ReplaceTokens(emailBody, tokens);
                    //Store Message
                    string Folder = "Pre Alert";
                    MsgBL.AddMessage(emailSubject, User.Identity.Name, mailItem.RecipientEmail, emailBody, Folder, false);

                    //Store to Sent Itmes 
                    Folder = " Sent Items";
                    MsgBL.AddMessage(emailSubject, User.Identity.Name, mailItem.RecipientEmail, emailBody, Folder, false);

                    //Send email
                    //Get all the CC list
                    List<string> CCList = new List<string>();
                    if (!string.IsNullOrEmpty(mailItem.CC))
                    {
                        mailItem.CC = mailItem.CC.Replace(',', ';');
                        var ccs = mailItem.CC.Split(',');
                        CCList.AddRange(ccs);
                    }
                    try
                    {
                        Email.SendSmtp(mailItem.RecipientEmail, emailSubject, emailBody, true, User.Identity.Name);
                        ViewBag.Message = "Email Sent Successfully!";
                    }
                    catch (Exception ex)
                    {
                        ViewBag.Message = ex.Message;
                    }
                }

            }
        }

        protected void SendShippingNoticeEmails(EmailNotificationFormModel model)
        {
            MessageBL MsgBL = new MessageBL();
            TokenBL tBL = new TokenBL();
            List<EmailAttachment> ListWithID = new List<EmailAttachment>();
            int GID = 0;
            string Token = string.Empty;
            int billType = Convert.ToInt32(Session["mailerSelectedBillType"]);

            foreach (var mailItem in model.Items)
            {
                if (mailItem.IsSelected)
                {
                    //Create File Group and get the GID
                    GID = MsgBL.CreateFileAttachmentGroup(User.Identity.Name, model.BillNumber, billType);
                    tBL.CreateToken(ref Token, TokenType.Shipping_Notice, mailItem.RecipientEmail, true, AppConstants.TOKEN_PERIOD_FILE_ACCESS);
                    string Attachments = "<ul>";
                    foreach (var attachment in mailItem.Attachments)
                    {
                        if (attachment.FileID == 0 && attachment.IsSelected)
                        {
                            //Generate PDF files
                            GeneratePDFFiles(attachment, ListWithID);
                            MsgBL.LogFileAttachment(attachment.FileName, attachment.FileID, GID, mailItem.RecipientEmail);
                            Attachments += "<li><a href='" + ConfigurationManager.AppSettings["URL.MailerRedirect.FileViewer"] + "?GID=" + GID + "&FileID=" + attachment.FileID + "&Token=" + Token + "&UserEmail=" + mailItem.RecipientEmail + "'>" + attachment.FileName + "</a></li>";
                        }
                    }
                    Attachments += "</ul>";
                    //Create Links
                    //Create a Token                    
                    //GET MessageTemplate 
                    string emailBody = Email.GetEmailTemplate(Server.MapPath(EmailConstants.PATH_TEMPLATE_SHIPPING_NOTICE));
                    string emailSubject = EmailConstants.SUBJECT_SHIPPING_NOTICE;
                    if (!string.IsNullOrEmpty(mailItem.Subject)) { emailSubject = mailItem.Subject; }
                    EmailMessageTokens tokens = new EmailMessageTokens();
                    var eltuser = GetCurrentELTUser();

                    string sender = CultureInfo.InvariantCulture.TextInfo.ToTitleCase(eltuser.user_fname) +
                    " " + CultureInfo.InvariantCulture.TextInfo.ToTitleCase(eltuser.user_lname);
                    if (string.IsNullOrEmpty(sender.Trim())) sender = User.Identity.Name;
                    tokens.Add(Email.SetEmailMessageToken("CompanyName", eltuser.company_name));
                    tokens.Add(Email.SetEmailMessageToken("SenderName", sender));
                    tokens.Add(Email.SetEmailMessageToken("BillNo", model.BillNumber));
                    tokens.Add(Email.SetEmailMessageToken("MessageBody", mailItem.TextMessage));
                    tokens.Add(Email.SetEmailMessageToken("Attachments", Attachments));

                    //Swap Tokens with data
                    emailBody = Email.ReplaceTokens(emailBody, tokens);
                    //Store Message
                    string Folder = "Shipping Notice";
                    MsgBL.AddMessage(emailSubject, User.Identity.Name, mailItem.RecipientEmail, emailBody, Folder, false);

                    //Store to Sent Itmes 
                    Folder = " Sent Items";
                    MsgBL.AddMessage(emailSubject, User.Identity.Name, mailItem.RecipientEmail, emailBody, Folder, false);

                    //Send email
                    //Get all the CC list
                    List<string> CCList = new List<string>();
                    if (!string.IsNullOrEmpty(mailItem.CC))
                    {
                        mailItem.CC = mailItem.CC.Replace(',', ';');
                        var ccs = mailItem.CC.Split(',');
                        CCList.AddRange(ccs);
                    }
                    try
                    {
                        Email.SendSmtp(mailItem.RecipientEmail, emailSubject, emailBody, true, User.Identity.Name);
                        ViewBag.Message = "Email Sent Successfully!";
                    }
                    catch (Exception ex)
                    {
                        ViewBag.Message = ex.Message;
                    }
                }

            }
        }


    }
}
