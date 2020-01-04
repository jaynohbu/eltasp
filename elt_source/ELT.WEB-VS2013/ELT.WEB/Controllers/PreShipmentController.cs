using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ELT.COMMON;
using ELT.WEB.Models;
using ELT.CDT;
using ELT.WEB.Filters;
namespace ELT.WEB.Controllers
{
    [Authorize]
    public class PreShipmentController : OperationBaseController
    {
        public PreShipmentController()
        {
            if (System.Web.HttpContext.Current.Session != null)
            {
                SetSubMenu(MainMenuContext.PreShipment);

                SetProductMenu(CurrentMenu.Context);
                
            }
        }

        public ActionResult Index()
        {
            return View();
        }
          [CheckSession]
        public ActionResult PickupOrder(string param)
        {
            CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
          [CheckSession]
        public ActionResult WarehouseReceipt(string param)
          {
              CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
          [CheckSession]
        public ActionResult ShipOut(string param)
          {
              CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
          [CheckSession]
        public ActionResult OnHandReport(string param)
        {

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        public ActionResult InOutReport(string param)
        {

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
    //PickupOrder
    //WarehouseReceipt
    //ShipOut
    //OnHandReport
    //InOutReport

    }
}
