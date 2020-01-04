using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.CDT;
using ELT.DA;
namespace ELT.BL
{
    public class OceanExportBL
    {
        OceanExportDA OceanExportDA = new OceanExportDA();
        public List<ManifestAgentInfo> GetAgentsInMBOL(int ELT_ACCOUNT_NUMBER, string mawb)
        {
            return OceanExportDA.GetAgentsInMBOL(ELT_ACCOUNT_NUMBER, mawb);
        }
        public List<EmailItem> GetOceanExportAgentPreAlertEmailItems(int ELT_ACCOUNT_NUMBER, string BillNum, BillType billType)
        {
            List<EmailItem> eitems = new List<EmailItem>();
            var hbItems = OceanExportDA.GetOceanExportDocumentList(ELT_ACCOUNT_NUMBER, BillNum, billType.ToString().Split('_')[1]);
            if (hbItems.Count() > 0)
            {
                var agents = (from c in hbItems where string.IsNullOrEmpty(c.agent_no) != true select c.agent_no).Distinct();
                int itemid = 1;
                foreach (var agent in agents)
                {
                    var hbols = (from c in hbItems where c.agent_no == agent select c).ToList();
                    EmailItem eitem = new EmailItem() { RecipientRelation = "Agent", Attachments = new List<EmailAttachment>(), RecipientEmail = hbols[0].agent_email, RecipientName = hbols[0].agent_name, EmailType = EmailType.OceanExport_Agent_PreAlert, IsSelected = true, EmailItemID = itemid++ };

                    eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/Ocean_export/manifest_pdf.asp?MBOL={0}&Agent={1}&MasterAgentNo={2}", hbItems[0].mbol_num, agent, hbItems[0].master_agent), FileName = string.Format("Manifest {0}.pdf", hbItems[0].mbol_num) });
                    if (hbItems[0].isDirect != "Y")
                    {
                        foreach (var h in hbols)
                        {
                            eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/Ocean_export/hbol_pdf.asp?hbol={0}&Copy=CONSIGNEE", h.hbol_num), FileName = string.Format("HBOL {0}.pdf", h.hbol_num) });
                            if (!string.IsNullOrEmpty(h.invoice_no) && h.invoice_no != "-1")
                            {
                                eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/acct_tasks/invoice_pdf.asp?InvoiceNo={0}", h.invoice_no), FileName = string.Format("INV {0}.pdf", h.invoice_no) });
                            }
                        }
                    }
                    else//Direct Master
                    {
                        eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/acct_tasks/invoice_pdf.asp?InvoiceNo={0}", hbItems[0].invoice_no), FileName = string.Format("INV {0}.pdf", hbItems[0].invoice_no) });
                    }
                    eitems.Add(eitem);
                }
            }

            return eitems;
        }
        
        public List<EmailItem> GetOceanExportShippingNoticeEmailItems(int ELT_ACCOUNT_NUMBER, string BillNum, BillType billType)
        {
            List<EmailItem> eitems = new List<EmailItem>();
            var hbItems = OceanExportDA.GetOceanExportDocumentList(ELT_ACCOUNT_NUMBER, BillNum, billType.ToString().Split('_')[1]);
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
                            eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/air_export/hbol_pdf.asp?HAWB={0}&Copy=CONSIGNEE", h.hbol_num), FileName = string.Format("HBOL {0}.pdf", h.hbol_num) });
                            if (!string.IsNullOrEmpty(h.invoice_no) && h.invoice_no != "-1")
                            {
                                eitem.Attachments.Add(new EmailAttachment() { IsSelected = true, GeneratorPath = string.Format("~/ASP/acct_tasks/invoice_pdf.asp?InvoiceNo={0}", h.invoice_no), FileName = string.Format("INV {0}.pdf", h.invoice_no) });
                            }
                        }

                    }
                    else //Direct Master
                    {

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
