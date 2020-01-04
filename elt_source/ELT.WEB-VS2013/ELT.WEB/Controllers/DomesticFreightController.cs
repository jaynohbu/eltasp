using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ELT.COMMON;
using ELT.WEB.Models;
using ELT.CDT;
namespace ELT.WEB.Controllers
{
    [Authorize]
    public class DomesticFreightController : OperationBaseController
    {
        public DomesticFreightController()
        {
            if (System.Web.HttpContext.Current.Session != null)
            {
                
                SetSubMenu(MainMenuContext.DomesticFreight);
                SetProductMenu(ProductMenuContext.Domestic);
            }
        }
        public ActionResult Index()
        {

            //SetSubMenu(MainMenuContext.DomesticFreight);
            //SetProductMenu(ProductMenuContext.Domestic);
            return View();
        }
        public ActionResult AirBooking(string param)
        {
            CheckAccess();
            SetSubMenu(MainMenuContext.DomesticFreight);
            SetProductMenu(ProductMenuContext.Domestic);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        public ActionResult GroundBooking(string param)
        {
            CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        public ActionResult MasterAirBill(string param)
        {
            CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        public ActionResult MasterGroundBill(string param)
        {
            CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        public ActionResult HouseAirBill(string param)
        {
            CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }       
        public ActionResult PrintLabel(string param)
        {
            CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        public ActionResult Search(string param)
        {
            CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        public ActionResult AgentPreAlert(string param)
        {
            CheckAccess();
            Session["mailerSelectedBillType"] = "1";
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            Session["EmailNotificationFormModel"] = null;
            EmailNotificationFormModel model = new EmailNotificationFormModel();
            Session["EmailNotificationFormModel"] = model;
            model.SenderEmail = GetCurrentELTUser().user_email;
            model.SenderName = GetCurrentELTUser().company_name;
            model.EmailType = EmailType.DomesticFreight_Agent_PreAlert;
            return View(model);
        }
        [HttpPost]
        public ActionResult AgentPreAlert(EmailNotificationFormModel model)
        {
            return View(model);
        }
        public ActionResult _SendAgentPreAlert(string Type, string BillNo)
        {
            return Json(new { Status = "Success", ErrorMsg = "" });
        }
        public ActionResult ShippingNotice(string param)
        {
            Session["mailerSelectedBillType"] = "1";
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            Session["EmailNotificationFormModel"] = null;
            EmailNotificationFormModel model = new EmailNotificationFormModel();
            model.EmailType = EmailType.DomesticFreight_Agent_PreAlert;
            Session["EmailNotificationFormModel"] = model;
            model.SenderEmail = GetCurrentELTUser().user_email;
            model.SenderName = GetCurrentELTUser().company_name;
            return View(model);
        }
        [HttpPost]
        public ActionResult ShippingNotice(EmailNotificationFormModel model)
        {
            CheckAccess();
            return View(model);
        }
   
    
    
    }
}
