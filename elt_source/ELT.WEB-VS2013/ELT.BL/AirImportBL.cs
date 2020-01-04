using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.CDT;
using ELT.DA;
namespace ELT.BL
{
    public class AirImportBL
    {
        AirImportDA AirImportDA = new AirImportDA();

        public List<ProofOfDeliveryEmailItem> GetAirImportProofOfDeliveryEmailItems(int ELT_ACCOUNT_NUMBER, string BillNum, BillType billType)
        {
            List<ProofOfDeliveryEmailItem> eitems = new List<ProofOfDeliveryEmailItem>();
            var hbItems = AirImportDA.GetAirImportDocumentList(ELT_ACCOUNT_NUMBER, BillNum, billType.ToString().Split('_')[1]);
            if (hbItems.Count() > 0)
            {
                var agents = (from c in hbItems where string.IsNullOrEmpty(c.agent_no) != true select c.agent_no).Distinct();
                int itemid = 1;
                foreach (var agent in agents)
                {
                    var hawbs = (from c in hbItems where c.agent_no == agent select c).ToList();
                    ProofOfDeliveryEmailItem eitem = new ProofOfDeliveryEmailItem() { RecipientRelation = "Agent", Attachments = new List<EmailAttachment>(), RecipientEmail = hawbs[0].agent_email, RecipientName = hawbs[0].agent_name, EmailType = EmailType.AirImport_Proof_Of_Delivery, IsSelected = true, EmailItemID = itemid++ };
                    foreach (var h in hawbs)
                    {
                        eitem.HouseBillItems.Add(new HouseBillItem() { BillNo=h.hawb_num, PickupDate=h.pickup_date, CollectAmount=h.col_amt, Units=h.pieces, Weight=h.gross_wt });
                    }
                    eitems.Add(eitem);
                }
            }

            return eitems;
        }

        public List<EArrivalNoticeEmailItem> GetAirImportEArrivalNoticeEmailItems(int ELT_ACCOUNT_NUMBER, string BillNum, BillType billType)
        {
            List<EArrivalNoticeEmailItem> eitems = new List<EArrivalNoticeEmailItem>();
            var hbItems = AirImportDA.GetAirImportDocumentList(ELT_ACCOUNT_NUMBER, BillNum, billType.ToString().Split('_')[1]);
            if (hbItems.Count() > 0)
            {
                var agents = (from c in hbItems where string.IsNullOrEmpty(c.agent_no) != true select c.agent_no).Distinct();
                int itemid = 1;
                foreach (var agent in agents)
                {
                    var hawbs = (from c in hbItems where c.agent_no == agent select c).ToList();
                    EArrivalNoticeEmailItem eitem = new EArrivalNoticeEmailItem() { RecipientRelation = "Agent", Attachments = new List<EmailAttachment>(), RecipientEmail = hawbs[0].agent_email, RecipientName = hawbs[0].agent_name, EmailType = EmailType.AirImport_Proof_Of_Delivery, IsSelected = true, EmailItemID =    itemid++ };
                    foreach (var h in hawbs)
                    {
                        eitem.ArrivalNoticeItems.Add(new ArrivalNoticeItem() { HouseBillNo = h.hawb_num, invoice_no = h.invoice_no });
                    }
                    eitems.Add(eitem);
                }
            }

            return eitems;
        }


    }
}
