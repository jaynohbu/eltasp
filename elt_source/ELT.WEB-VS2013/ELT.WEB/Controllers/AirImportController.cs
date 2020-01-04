using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ELT.COMMON;
using ELT.WEB.Models;
using ELT.CDT;
using ELT.BL;
using ELT.WEB.Filters; 

namespace ELT.WEB.Controllers
{
    [Authorize]
    public class AirImportController : OperationBaseController
    {
        public AirImportController()
        {
            if (System.Web.HttpContext.Current.Session != null)
            {
                SetSubMenu(MainMenuContext.AirImport);
                SetProductMenu(ProductMenuContext.International);
            }
        }

        public ActionResult Index()
        {
            return View();
        }
              [CheckSession]
        public ActionResult DeconsolidationQueue (string param)
        {
            CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult Deconsolidation(string param)
        {
            CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult ArrivalNotice(string param)
        {
            CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult DeliveryOrder (string param)
        {
            CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }       
        //public ActionResult EArrivalNotice(string param)
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
        //    model.EmailType = EmailType.AirImport_E_Arrival_Notice;
        //    return View(model);
        //}
        //[HttpPost]
        //public ActionResult EArrivalNotice(EmailNotificationFormModel model)
        //{
        //    return View(model);
        //}
        [CheckSession]
        public ActionResult ProofOfDelivery(string param)
        {
            CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();

        }
        [CheckSession]
        public ActionResult EArrivalNotice(string param)
        {
            CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();

        }
        [CheckSession]
        public ActionResult AISearch (string param)
        {
            CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }

        //public ActionResult ProofOfDelivery(string param)
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
        //    model.EmailType = EmailType.AirImport_Proof_Of_Delivery;
        //    return View(model);
        //}
        //[HttpPost]
        //public ActionResult ProofOfDelivery(EmailNotificationFormModel model)
        //{
        //    return View(model);
        //}


        //public ActionResult _NotificationEmailItems(EmailNotificationFormModel model)
        //{
        //    if (!string.IsNullOrEmpty(model.BillNumber))
        //    {
        //        ViewBag.Message = string.Empty;
        //        if (model.ShouldSend)
        //        {

        //            if (model.EmailType == EmailType.AirExport_Agent_PreAlert)
        //            {
        //                SendAgentPreAlertEmails(model);
        //            }
        //            if (model.EmailType == EmailType.AirExport_Shipping_Notice)
        //            {
        //                SendShippingNoticeEmails(model);
        //            }

        //        }
        //        if (Session["mailerSelectedBillType"] != null)
        //        {
        //            int billType = Convert.ToInt32(Session["mailerSelectedBillType"]);
        //            AirImportBL BL = new AirImportBL();
        //            if (model.EmailType == ELT.CDT.EmailType.AirImport_Proof_Of_Delivery)
        //            {
        //                model.Items.Clear();
        //                model.Items.AddRange(BL.GetAirImportProofOfDeliveryEmailItems(int.Parse(GetCurrentELTUser().EmailItemID), model.BillNumber, (BillType)billType).ToArray());
        //            }
        //            if (model.EmailType == ELT.CDT.EmailType.AirImport_E_Arrival_Notice)
        //            {
        //                model.Items.Clear();
        //                model.Items.AddRange( BL.GetAirImportEArrivalNoticeEmailItems(int.Parse(GetCurrentELTUser().EmailItemID), model.BillNumber, (BillType)billType).ToArray());
        //            }
        //        }
        //    }
        //    return PartialView(model);
        //}
        //public ActionResult _BillSelectionBox(EmailNotificationFormModel model)
        //{
        //    Session["mailerSelectedBillType"] = model.BillType;
        //    return PartialView(model);
        //}
        //public ActionResult _SelectBill()
        //{
        //    return PartialView();
        //}


        public ActionResult _SendAgentPreAlert(string Type, string BillNo)
        {
            return Json(new { Status = "Success", ErrorMsg = "" });
        }
    }
}
