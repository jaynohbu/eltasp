using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
namespace ELT.CDT
{
    [Serializable]
    public class HouseBillItem
    {
        public string BillNo
        {
            get;
            set;
        }
        public string Units
        {
            get;
            set;
        }
        public string Weight
        {
            get;
            set;
        }
        public string CollectAmount
        {
            get;
            set;
        }
        public string PickupDate
        {
            get;
            set;
        }
    }

    [Serializable]
    public class ArrivalNoticeItem
    {
        public string invoice_no
        {
            get;
            set;
        }
        public string ArrivalNoticeGeneratorPath
        {
            get;
            set;
        }
        public string ArrivalNoticeAndFreightChargeGenratorPath
        {
            get;
            set;
        }
        public string HouseBillNo
        {
            get;
            set;
        }
       
    }
    [Serializable]
    public class ProofOfDeliveryEmailItem : EmailItem
    {
        public ProofOfDeliveryEmailItem()
        {
            HouseBillItems = new List<HouseBillItem>();
        }
        public List<HouseBillItem> HouseBillItems
        {
            get;
            set;
        }
    }

    [Serializable]
    public class EArrivalNoticeEmailItem : EmailItem
    {
        public EArrivalNoticeEmailItem()
        {
            ArrivalNoticeItems = new List<ArrivalNoticeItem>();
        }
        public List<ArrivalNoticeItem> ArrivalNoticeItems
        {
            get;
            set;
        }
    }

      [Serializable]
    public class EmailItem
    {
        public int EmailItemID
        {
            get;
            set;
        }
        public string RecipientRelation
        {
            get;
            set;
        }
        [Display(Name = "Subject")]
        public string Subject
        {
            get;
            set;
        }
        [Display(Name = "CC")]
        [RegularExpression(RegexConstants.REGEX_MAIL_MUTIPLE_EMAILS, ErrorMessage = "Please check if the emails are sperated with a ',' or ';'.")]
        public string CC
        {
            get;
            set;
        }
        public bool IsSelected
        {
            get;
            set;
        }
        public int EmailTemplateID
        {
            get;
            set;
        }
        public EmailType EmailType
        {
            get;
            set;
        }
        [Required]
        [Display(Name = "From")]
        [DataType(DataType.EmailAddress)]
        public string SenderEmail
        {
            get;
            set;
        }
        [Display(Name = "Sender Name")]
        public string SenderName
        {
            get;
            set;
        }
        [Required]
        [Display(Name = "To")]
        [DataType(DataType.EmailAddress)]
        public string RecipientEmail
        {
            get;
            set;
        }
        [Required]
        [Display(Name = "Recipient Name")]
        public string RecipientName
        {
            get;
            set;
        }
        public string EmailContentHtml
        {
            get;
            set;
        }
        [Display(Name = "Message")]
        public string TextMessage
        {
            get;
            set;
        }
        [Display(Name = "Attachment(s)")]
        public List<EmailAttachment> Attachments
        {
            get;
            set;
        }
    }
}