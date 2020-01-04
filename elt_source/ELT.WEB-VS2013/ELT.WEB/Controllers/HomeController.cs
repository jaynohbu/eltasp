using System;
using System.Collections.Specialized;
using System.Web;
using System.Web.Mvc;
using ELT.COMMON;
using ELT.WEB.Models;
using WebMatrix.WebData;
using ELT.WEB.Filters;
namespace ELT.WEB.Controllers
{
    [InitializeSimpleMembership]
    public class HomeController : ControllerBase
    {
        public ActionResult Index()
        {
            if (Session["NewUserFromFileAccess"] != null)
            {
                NameValueCollection qscoll = HttpUtility.ParseQueryString((string) Session["NewUserFromFileAccess"]);
                Session["NewUserFromFileAccess"] = null; 
                string UserEmail = qscoll["UserEmail"];
                 if (WebSecurity.UserExists(UserEmail))
                 {
                     return RedirectToAction("Login", "Account", new { UserEmail = UserEmail });
                 }
                 else
                 {
                     RerequestFile(qscoll);
                     ViewBag.ShowNewUser = true;
                 }
            }

            return View();
        }

        private void RerequestFile(NameValueCollection qscoll)
        {
            FileRequestModel FileRequestModel = new FileRequestModel();
            FileRequestModel.Token = qscoll["Token"];
            FileRequestModel.FileID = Convert.ToInt32(qscoll["FileID"]);
            FileRequestModel.GID = Convert.ToInt32(qscoll["GID"]);
            FileRequestModel.UserEmail = Convert.ToString(qscoll["UserEmail"]);
            FileRequestModel.FileAccessUrl = Url.Content(AppConstants.URL_FILE_ACCESS_PAGE + "?Token=" + qscoll["Token"] + "&FileID=" + qscoll["FileID"] + "&GID=" + qscoll["GID"] + "&UserEmail=" + qscoll["UserEmail"]);
            Session["FileRequestModel"] = FileRequestModel;
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your app description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Navigation = "Home / Contact";
            return View();
        }

        public ActionResult FeatureStory()
        {
            ViewBag.Navigation = "Home / Features";
            return View();
        }
        public ActionResult Company()
        {
            ViewBag.Navigation = "Home / Company";
            return View();
        }
        public ActionResult Introduction()
        {
            ViewBag.Navigation = "Home / Product / Introduction";
            return View();
        }
        public ActionResult WhyFE()
        {
            ViewBag.Navigation = "Home / Product / Why FreightEasy";
            return View();
        }

        public ActionResult Features()
        {
            ViewBag.Navigation = "Home / Product / Features ";
            return View();
        }
        public ActionResult FAQs()
        {
            ViewBag.Navigation = "Home / Product / FAQs ";
            return View();
        }
        public ActionResult GettingTips()
        {
            ViewBag.Navigation = "Home / Product / Getting Started tips ";
            return View();
        }
        public ActionResult Support()
        {
            ViewBag.Navigation = "Home / Support";
            return View();
        }
        public ActionResult WebBased()
        {
            ViewBag.Navigation = "Home / Product";
            return View();
        }
        public ActionResult Legal()
        {
            ViewBag.Navigation = "Home / Legal & Privacy";
            return View();
        }

        public ActionResult Logo()
        {        
          ViewBag.ClientLogo =  GetClientLogo();
          return PartialView("_Logo");
      
        }
    }
}
