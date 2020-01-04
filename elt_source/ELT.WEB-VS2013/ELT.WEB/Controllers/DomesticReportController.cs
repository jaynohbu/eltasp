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
    public class DomesticReportController : OperationBaseController
    {
        //
        // GET: /DomesticReport/

        public DomesticReportController()
        {
            if (System.Web.HttpContext.Current.Session != null)
            {
                SetSubMenu(MainMenuContext.DomesticReport);
                SetProductMenu(ProductMenuContext.Domestic);
            }
        }
        public ActionResult Index(string param)
        {
            SetSubMenu(MainMenuContext.DomesticReport);
            SetProductMenu(ProductMenuContext.Domestic);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        public ActionResult OperatonReport (string param)
        {
            CheckAccess();
            SetSubMenu(MainMenuContext.DomesticReport);
            SetProductMenu(ProductMenuContext.Domestic);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
    }
}
