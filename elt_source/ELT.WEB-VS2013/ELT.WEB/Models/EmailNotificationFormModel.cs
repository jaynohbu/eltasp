using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;
using ELT.CDT;
using DevExpress.Web.ASPxEditors;
namespace ELT.WEB.Models
{
    [Serializable]
    public class EmailNotificationFormModel
    {
        public EmailNotificationFormModel()
        {
            Items = new List<EmailItem>();
        }
        [Required]
        [Display(Name = "Your Name")]
        public string SenderName
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
        public List<Contact> Agents
        {
            get;
            set;
        }
        public List<EmailItem> Items
        {
            get;
            set;
        }
        public string BillNumber
        {
            get;
            set;            
        }
        public string BillType
        {
            get;
            set;
        }
        public bool ShouldSend
        {
            get;
            set;
        }
        public List<SelectListItem> GetBillTypes()
        {
            var BillTypes = new List<SelectListItem>();         
            BillTypes.Add(new SelectListItem() { Text = "House Bill No.", Value = "1" });
            BillTypes.Add(new SelectListItem() { Text = "Master Bill No.", Value = "2" });
            BillTypes.Add(new SelectListItem() { Text = "File No.", Value = "3" });
            return BillTypes;
        }

        public EmailType EmailType
        {
            get;
            set;
        }
    }
  
    
}