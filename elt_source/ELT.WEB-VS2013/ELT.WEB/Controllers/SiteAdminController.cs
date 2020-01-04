using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ELT.COMMON;
using ELT.WEB.Models;
using ELT.BL;
using ELT.CDT;
using ELT.WEB.Filters;
namespace ELT.WEB.Controllers
{
    
    [Authorize]
    public class SiteAdminController : OperationBaseController
    {
        
        public SiteAdminController()
        {
            if (System.Web.HttpContext.Current.Session != null)
            {
                SetSubMenu(MainMenuContext.SiteAdmin);
                SetProductMenu(CurrentMenu.Context);
            }
        }

        public ActionResult Index()
        {
            SetSubMenu(MainMenuContext.SiteAdmin);
            //SetProductMenu(ProductMenuContext.International);
            return View();
        }
          [CheckSession]
        public ActionResult UserAdmin (string param)
        {
            CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }

        [HttpGet]
         
          public ActionResult PageAccess(string UID)
          {
              List<AuthorizedPage> pages = new List<AuthorizedPage>();

              if (UID != null)
              {
                  AuthenticationBL BL = new AuthenticationBL();
                  pages = BL.GetAuthorizedPages(Convert.ToInt32(Session["elt_account_number"]), int.Parse(UID));
              }
              return View(pages);
          }

        [HttpPost]
        public ActionResult PageAccess(List<AuthorizedPage> model)
        {
            AuthenticationBL BL = new AuthenticationBL();
            BL.UpdateAuthorizePage(Convert.ToInt32(Session["elt_account_number"]), model[0].user_id, model);
            return View(model);
        }



          [CheckSession]
        public ActionResult CompanyInformation (string param)
        {
            CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
          [CheckSession]
        public ActionResult PrefixManager (string param)
        {
            CheckAccess();
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
          [CheckSession]
        public ActionResult FavoriteManager (string param)
          {
              CheckAccess();

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
    }
}
