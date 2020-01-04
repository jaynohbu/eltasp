using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.CDT;
using ELT.DA;
namespace ELT.BL
{
    public class OceanImportBL
    {
        OceanImportDA OceanImportDA = new OceanImportDA();

        public List<ProofOfDeliveryEmailItem> GetOceanImportProofOfDeliveryEmailItems(int ELT_ACCOUNT_NUMBER, string BillNum, BillType billType)
        {
            List<ProofOfDeliveryEmailItem> eitems = new List<ProofOfDeliveryEmailItem>();
            var hbItems = OceanImportDA.GetOceanImportDocumentList(ELT_ACCOUNT_NUMBER, BillNum, billType.ToString().Split('_')[1]);
            if (hbItems.Count() > 0)
            {
                var agents = (from c in hbItems where string.IsNullOrEmpty(c.agent_no) != true select c.agent_no).Distinct();
                int itemid = 1;
                foreach (var agent in agents)
                {
                    var hawbs = (from c in hbItems where c.agent_no == agent select c).ToList();
                    ProofOfDeliveryEmailItem eitem = new ProofOfDeliveryEmailItem() { RecipientRelation = "Agent", Attachments = new List<EmailAttachment>(), RecipientEmail = hawbs[0].agent_email, RecipientName = hawbs[0].agent_name, EmailType = EmailType.OceanImport_Proof_Of_Delivery, IsSelected = true, EmailItemID = itemid++ };
                    foreach (var h in hawbs)
                    {
                        eitem.HouseBillItems.Add(new HouseBillItem() { BillNo = h.hbol_num, PickupDate = h.pickup_date, CollectAmount = h.col_amt, Units = h.pieces, Weight = h.gross_wt });
                    }
                    eitems.Add(eitem);
                }
            }

            return eitems;
        }

        public List<EArrivalNoticeEmailItem> GetOceanImportEArrivalNoticeEmailItems(int ELT_ACCOUNT_NUMBER, string BillNum, BillType billType)
        {
            List<EArrivalNoticeEmailItem> eitems = new List<EArrivalNoticeEmailItem>();
            var hbItems = OceanImportDA.GetOceanImportDocumentList(ELT_ACCOUNT_NUMBER, BillNum, billType.ToString().Split('_')[1]);
            if (hbItems.Count() > 0)
            {
                var agents = (from c in hbItems where string.IsNullOrEmpty(c.agent_no) != true select c.agent_no).Distinct();
                int itemid = 1;
                foreach (var agent in agents)
                {
                    var hawbs = (from c in hbItems where c.agent_no == agent select c).ToList();
                    EArrivalNoticeEmailItem eitem = new EArrivalNoticeEmailItem() { RecipientRelation = "Agent", Attachments = new List<EmailAttachment>(), RecipientEmail = hawbs[0].agent_email, RecipientName = hawbs[0].agent_name, EmailType = EmailType.OceanImport_Proof_Of_Delivery, IsSelected = true, EmailItemID = itemid++ };
                    foreach (var h in hawbs)
                    {
                        eitem.ArrivalNoticeItems.Add(new ArrivalNoticeItem() { HouseBillNo = h.hbol_num, invoice_no = h.invoice_no });
                    }
                    eitems.Add(eitem);
                }
            }

            return eitems;
        }


    }
}
