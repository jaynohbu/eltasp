using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Linq;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web.Mvc;
using ELT.BL;
using ELT.CDT;
using ELT.COMMON;
using ELT.WEB.Models;
using ELT.WEB.DataProvider;
using ELT.WEB.Filters;
namespace ELT.WEB.Controllers
{
    [Authorize]
    public partial class AirExportController : OperationBaseController 
    {       
        public AirExportController()
        {
            if (System.Web.HttpContext.Current.Session != null)
            {
                SetSubMenu(MainMenuContext.AirExport);
                SetProductMenu(ProductMenuContext.International);
            }
        }
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult HouseAirwayBill()
        {
            return View();
        }
        [CheckSession]
        public ActionResult HAWB(string param)
        {
            CheckAccess();
          
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
          [CheckSession]
        public ActionResult Booking(string param)
        {
            CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
            //http://e-logitech.net/IFF_MAIN/ASP/air_export/booking.asp
        }
          [CheckSession]
        public ActionResult MAWB(string param)
          {
              CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();

        }
          [CheckSession]
        public ActionResult CertificateOfOrigin(string param)
          {
              CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
          [CheckSession]
        public ActionResult AES(string param)
          {
              CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
          [CheckSession]
        public ActionResult AgentPreAlert(string param)
          {
              CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();

        }
        //public ActionResult AgentPreAlert(string param)
        //{
        //    Session["mailerSelectedBillType"] = "1";

        //    if (param != null)
        //        param = "?" + param;
        //    ViewBag.Params = param;          
        //    Session["EmailNotificationFormModel"] = null;
        //    EmailNotificationFormModel model = new EmailNotificationFormModel();
        //    Session["EmailNotificationFormModel"] = model;
        //    model.SenderEmail = GetCurrentELTUser().user_email;
        //    model.SenderName = GetCurrentELTUser().company_name;
        //    model.EmailType = EmailType.AirExport_Agent_PreAlert;
            
        //    return View(model);
        //}
        //[HttpPost]
        //public ActionResult AgentPreAlert(EmailNotificationFormModel model)
        //{
        //    return View(model);
        //}               
        //public ActionResult _SendAgentPreAlert(string Type, string BillNo)
        //{            
        //    return Json(new {Status="Success",ErrorMsg=""});
        //}     
        //public ActionResult ShippingNotice(string param)
        //{
        //    Session["mailerSelectedBillType"] = "1";
        //    if (param != null)
        //        param = "?" + param;
        //    ViewBag.Params = param;
        //    Session["EmailNotificationFormModel"] = null;
        //    EmailNotificationFormModel model = new EmailNotificationFormModel();
        //    model.EmailType = EmailType.AirExport_Shipping_Notice;
        //    Session["EmailNotificationFormModel"] = model;
        //    model.SenderEmail = GetCurrentELTUser().user_email;
        //    model.SenderName = GetCurrentELTUser().company_name;
        //    return View(model);
        //}
        //[HttpPost]
        //public ActionResult ShippingNotice(EmailNotificationFormModel model)
        //{
        //    return View(model);
        //}
        [CheckSession]
        public ActionResult ShippingNotice(string param)
          {
              CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();

        }
          [CheckSession]
        public ActionResult PrintLabel(string param)
        {
            CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
          [CheckSession]
        public ActionResult AESearch(string param)
          {
              CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        
    }
}
