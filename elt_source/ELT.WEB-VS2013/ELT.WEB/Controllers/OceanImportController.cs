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
    public class OceanImportController : OperationBaseController
    {
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
        //    model.EmailType = EmailType.OceanImport_Proof_Of_Delivery;
        //    return View(model);
        //}
        //[HttpPost]
        //public ActionResult ProofOfDelivery(EmailNotificationFormModel model)
        //{
        //    return View(model);
        //}
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
        //    model.EmailType = EmailType.OceanImport_E_Arrival_Notice;
        //    return View(model);
        //}
        //[HttpPost]
        //public ActionResult EArrivalNotice(EmailNotificationFormModel model)
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
        //            OceanImportBL BL = new OceanImportBL();
        //            if (model.EmailType == ELT.CDT.EmailType.OceanImport_Proof_Of_Delivery)
        //            {
        //                model.Items.Clear();
        //                model.Items.AddRange(BL.GetOceanImportProofOfDeliveryEmailItems(int.Parse(GetCurrentELTUser().EmailItemID), model.BillNumber, (BillType)billType).ToArray());
        //            }
        //            if (model.EmailType == ELT.CDT.EmailType.OceanImport_E_Arrival_Notice)
        //            {
        //                model.Items.Clear();
        //                model.Items.AddRange(BL.GetOceanImportEArrivalNoticeEmailItems(int.Parse(GetCurrentELTUser().EmailItemID), model.BillNumber, (BillType)billType).ToArray());
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

        public OceanImportController()
        {
            if (System.Web.HttpContext.Current.Session != null)
            {
                SetSubMenu(MainMenuContext.OceanImport);
                SetProductMenu(ProductMenuContext.International);
            }
        }

        public ActionResult Index()
        {
            return View();
        }
          [CheckSession]
        public ActionResult DeconsolidationQueue(string param)
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
        public ActionResult DeliveryOrder(string param)
          {
              CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
       [CheckSession]
        public ActionResult OISearch(string param)
        {
            CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
    }
}
