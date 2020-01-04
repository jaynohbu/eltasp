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
    public partial class MasterDataController : OperationBaseController
    {
        public MasterDataController()
        {
            if (System.Web.HttpContext.Current.Session != null)
            {
                SetSubMenu(MainMenuContext.MasterData);
                SetProductMenu(CurrentMenu.Context);
            }
        }

        public ActionResult Index()
        {
            return View();
        }
        [CheckSession]
        public ActionResult ClientPartnerProfile(string param)
        {
            CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        public ActionResult ClientPartnerProfileDetail(string param)
        {

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }

          [CheckSession]
        public ActionResult Port(string param)
        {
            CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
          [CheckSession]
        public ActionResult FreightLocation(string param)
          {
              CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
          [CheckSession]
        public ActionResult ScheduleB(string param)
          {
              CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        [CheckSession]
        public ActionResult ChargeItems(string param)
        {
            CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
          [CheckSession]
        public ActionResult CostItems(string param)
        {
            CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
          [CheckSession]
        public ActionResult MasterAWBNo(string param)
          {
              CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
    }
}
