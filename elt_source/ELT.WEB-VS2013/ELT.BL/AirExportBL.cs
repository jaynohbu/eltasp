using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.CDT;
using ELT.DA;
namespace ELT.BL
{
    public class AirExportBL
    {
        AirExportDA AirExportDA = new AirExportDA();
        public List<ManifestAgentInfo> GetAgentsInMAWB(int ELT_ACCOUNT_NUMBER, string mawb)
        {
            return AirExportDA.GetAgentsInMAWB(ELT_ACCOUNT_NUMBER, mawb);
        }

        public List<EmailItem> GetAirExportAgentPreAlertEmailItems(int ELT_ACCOUNT_NUMBER, string BillNum, BillType billType)
        {
            List<EmailItem> eitems = new List<EmailItem>();
            var hbItems = AirExportDA.GetAirExportDocumentList(ELT_ACCOUNT_NUMBER, BillNum, billType.ToString().Split('_')[1]);
            if (hbItems.Count() > 0)
            {
                var agents = (from c in hbItems where string.IsNullOrEmpty(c.agent_no) != true select c.agent_no).Distinct();
                int itemid = 1;
                foreach (var agent in agents)
                {
                  
                    var hawbs = (from c in hbItems where c.agent_no == agent select c).ToList();
                    EmailItem eitem = new EmailItem() { RecipientRelation = "Agent", Attachments = new List<EmailAttachment>(), RecipientEmail = hawbs[0].agent_email, RecipientName = hawbs[0].agent_name, EmailType = EmailType.AirExport_Agent_PreAlert, IsSelected = true, EmailItemID = itemid++ };

                    eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/air_export/mawb_pdf.asp?MAWB={0}&Copy=CONSIGNEE", hbItems[0].mawb_num), FileName = string.Format("MAWB {0}.pdf", hbItems[0].mawb_num) });

                    if (hbItems[0].isDirect != "Y")
                    {
                        eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/air_export/manifest_pdf.asp?MAWB={0}&Agent={1}&MasterAgentNo={2}", hbItems[0].mawb_num, agent, hbItems[0].master_agent), FileName = string.Format("Manifest {0}.pdf", hbItems[0].mawb_num) });

                        foreach (var h in hawbs)
                        {
                            eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/air_export/hawb_pdf.asp?HAWB={0}&Copy=CONSIGNEE", h.hawb_num), FileName = string.Format("HAWB {0}.pdf", h.hawb_num) });
                            if (!string.IsNullOrEmpty(h.invoice_no) && h.invoice_no!="-1")
                            {
                                eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/acct_tasks/invoice_pdf.asp?InvoiceNo={0}", h.invoice_no), FileName = string.Format("INV {0}.pdf", h.invoice_no) });
                            }
                        }
                        eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/acct_tasks/agent_stmt.asp?MAWB={0}&AgentNo={1}", hbItems[0].mawb_num, agent), FileName = string.Format("STMT {0}.pdf", hbItems[0].mawb_num) });

                    }
                    else //Direct Master
                    {
                        eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/acct_tasks/invoice_pdf.asp?InvoiceNo={0}", hbItems[0].invoice_no), FileName = string.Format("INV {0}.pdf", hbItems[0].invoice_no) });
                    }

                    eitems.Add(eitem);
                }
            }

            return eitems;
        }

        public List<EmailItem> GetAirExportShippingNoticeEmailItems(int ELT_ACCOUNT_NUMBER, string BillNum, BillType billType)
        {
            List<EmailItem> eitems = new List<EmailItem>();
            var hbItems = AirExportDA.GetAirExportDocumentList(ELT_ACCOUNT_NUMBER, BillNum, billType.ToString().Split('_')[1]);
            if (hbItems.Count() > 0)
            {
                var shippers = (from c in hbItems where string.IsNullOrEmpty(c.shipper_account_number) != true select c.shipper_account_number).Distinct();
                int itemid = 1;
                foreach (var shipper in shippers)
                {
                 
                    var hawbs = (from c in hbItems where c.shipper_account_number == shipper select c).ToList();
                    EmailItem eitem = new EmailItem() { RecipientRelation = "Shipper", Attachments = new List<EmailAttachment>(), RecipientEmail = hawbs[0].shipper_email, RecipientName = hawbs[0].shipper_name, EmailType = EmailType.AirExport_Agent_PreAlert, IsSelected = true, EmailItemID = itemid++ };
                    if (hbItems[0].isDirect != "Y")
                    {

                        foreach (var h in hawbs)
                        {
                            eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/air_export/hawb_pdf.asp?HAWB={0}&Copy=CONSIGNEE", h.hawb_num), FileName = string.Format("HAWB {0}.pdf", h.hawb_num) });
                            if (!string.IsNullOrEmpty(h.invoice_no) && h.invoice_no != "-1")
                            {
                                eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/acct_tasks/invoice_pdf.asp?InvoiceNo={0}", h.invoice_no), FileName = string.Format("INV {0}.pdf", h.invoice_no) });
                            }
                        }                 

                    }
                    else //Direct Master
                    {
                        eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/air_export/mawb_pdf.asp?MAWB={0}&Copy=Shipper", hbItems[0].mawb_num), FileName = string.Format("MAWB {0}.pdf", hbItems[0].mawb_num) });
                        if (!string.IsNullOrEmpty(hbItems[0].invoice_no) && hbItems[0].invoice_no != "-1")
                        eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/acct_tasks/invoice_pdf.asp?InvoiceNo={0}", hbItems[0].invoice_no), FileName = string.Format("INV {0}.pdf", hbItems[0].invoice_no) });
                    }

                    eitems.Add(eitem);
                }
            }

            return eitems;
        }


    }
}
