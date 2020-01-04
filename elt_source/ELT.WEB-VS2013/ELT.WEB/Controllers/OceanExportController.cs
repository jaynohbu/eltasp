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
using ELT.WEB.Filters;

namespace ELT.WEB.Controllers
{
    [Authorize]
    public class OceanExportController : OperationBaseController
    {
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
        //    model.EmailType = EmailType.OceanExport_Agent_PreAlert;
        //    Session["EmailNotificationFormModel"] = model;
        //    model.SenderEmail = GetCurrentELTUser().user_email;
        //    model.SenderName = GetCurrentELTUser().company_name;
        //    return View(model);
        //}
        //[HttpPost]
        //public ActionResult AgentPreAlert(EmailNotificationFormModel model)
        //{
        //    return View(model);
        //}   
        //public ActionResult _SendAgentPreAlert(string Type, string BillNo)
        //{
        //    return Json(new { Status = "Success", ErrorMsg = "" });
        //}   
        public OceanExportController()
        {
          
            if (System.Web.HttpContext.Current.Session != null)
            {
                SetSubMenu(MainMenuContext.OceanExport);
                SetProductMenu(ProductMenuContext.International);
            }
        }
        //public ActionResult ShippingNotice(string param)
        //{
           
        //    Session["mailerSelectedBillType"] = "1";
        //    if (param != null)
        //        param = "?" + param;
        //    ViewBag.Params = param;
        //    Session["EmailNotificationFormModel"] = null;
        //    EmailNotificationFormModel model = new EmailNotificationFormModel();
        //    model.EmailType = EmailType.OceanExport_Shipping_Notice;
        //    Session["EmailNotificationFormModel"] = model;
        //    model.SenderEmail = GetCurrentELTUser().user_email;
        //    model.SenderName = GetCurrentELTUser().company_name;
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

        [HttpPost]
        public ActionResult ShippingNotice(EmailNotificationFormModel model)
        {
            return View(model);
        }
        public ActionResult Index()
        {
            SetSubMenu(MainMenuContext.OceanExport);
            SetProductMenu(ProductMenuContext.International);
            return View();
        }
        public ActionResult HouseOceanBill()
        {
            return View();
        }
          [CheckSession]
        public ActionResult HBOL(string param)
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
        }
          [CheckSession]
        public ActionResult MBOL(string param)
          {
              CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();

        }
          [CheckSession]
        public ActionResult BookingConfirmation(string param)
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
        public ActionResult PrintLabel(string param)
          {
              CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();

        }
        //OESearch
          [CheckSession]
        public ActionResult OESearch(string param)
          {
              CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();

        }
        //OEPNL
        public ActionResult OEPNL(string param)
          {
              CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();

        }

    }
}
