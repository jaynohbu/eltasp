using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ELT.COMMON;
using ELT.WEB.Models;
using ELT.CDT;
using ELT.WEB.DataProvider;
using ELT.BL;
namespace ELT.WEB.Controllers
{
    [Authorize]
    public class PublicController : OperationBaseController
    {
        public PublicController()
        {
            if (System.Web.HttpContext.Current.Session != null)
            {
                
                SetSubMenu(MainMenuContext.Public);
                SetProductMenu(ProductMenuContext.Public);
            }
        }

        public ActionResult Index()
        {

            //SetSubMenu(MainMenuContext.DomesticFreight);
            //SetProductMenu(ProductMenuContext.Domestic);
            return View();
        }

        public ActionResult EmailClient(string param)
        {
        
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View();
        }
        public ActionResult DocumentManager(string param)
        {
            string RootFolder = string.Empty;
            ELTFileSystemProvider provider = new ELTFileSystemProvider(RootFolder);
            FileSystemBL bl =new FileSystemBL();
            int id = bl.GetRootFileItemID(User.Identity.Name);
            var rootfolder = bl.GetFileByID(id);
            ViewBag.InitialFolder = rootfolder.Name;

            if (Session["FileFolderToBeSet"] != null)
            {
                ViewBag.InitialFolder = (string)Session["FileFolderToBeSet"];
                Session["FileFolderToBeSet"] = null;
            }

            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            return View(provider);
        }

        [ValidateInput(false)]
        public ActionResult FileManager()
        {
            string RootFolder = string.Empty;
            ELTFileSystemProvider provider = new ELTFileSystemProvider(RootFolder);
            return PartialView("FileManager", provider);
        }

    }
}
