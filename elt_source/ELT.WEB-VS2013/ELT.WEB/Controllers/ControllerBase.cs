using System.IO;
using System.Linq;
using System.Web.Mvc;
using ELT.BL;
using ELT.CDT;
using ELT.WEB.Models;
using System;
using System.Web;
namespace ELT.WEB.Controllers
{
    public class ControllerBase : Controller
    {
        
        int elt_account_number;
        int user_id;

        protected void CheckAccess(){

            ViewBag.NotAllowed=false;
            AuthenticationBL BL=new AuthenticationBL();
            string url = HttpUtility.UrlDecode(Request.Url.PathAndQuery);
            if (Request.Url.Query != "")
            {
                url = url.Replace(Request.Url.Query, "");
            }
            if (url.ToLower().Contains("/dataready"))
            {
                url = url.Substring(0, url.ToLower().IndexOf("/dataready"));
            }
           if (url.ToLower().Contains("/window"))
           {
               url=url.Substring(0,url.ToLower().IndexOf("/window"));
           }
           if (url.ToLower().Contains("/parm"))
           {
               url = url.Substring(0, url.ToLower().IndexOf("/parm"));
           }

             if (url.ToLower().Contains("="))
           {
               url = url.Substring(0, url.ToLower().IndexOf("="));
               url = url.Substring(0, url.ToLower().LastIndexOf("/")+1);
           }

           
           if (url.EndsWith("/"))
           {
               url = url.Substring(0, url.ToLower().LastIndexOf("/"));
           }
           if (!BL.CheckAllowed(url, Session["login_name"].ToString()))
           {
               ViewBag.NotAllowed = true;
               string return_url = "/SiteAdmin/";
               if (Session["PevUrl"] != null)
               {
                  // return_url = Convert.ToString(Session["PevUrl"]);
               }
               ViewBag.Referer = return_url;
           }
           else
           {
               Session["PevUrl"] = url;
           }
        }
        public string GetClientLogo()
        {
            string logo_url = "~/Images/logo_FEintl.gif";
          
            if (Request.Cookies["CurrentUserInfo"] != null)
            {
                string elt_account_number = Request.Cookies["CurrentUserInfo"]["elt_account_number"];
             
                if (System.IO.File.Exists(Server.MapPath("~/IFF_MAIN/ClientLogos/" + elt_account_number + ".gif")))
                {

                    logo_url = "~/IFF_MAIN/ClientLogos/" + elt_account_number + ".gif";
                }

            }
            //IFF_MAIN/ClientLogos/80002000.gif

           return logo_url;
        }
        protected Menu CurrentMenu
        {
            get {
                if (System.Web.HttpContext.Current.Session["CurrentMenu"] == null)
                {
                    System.Web.HttpContext.Current.Session["CurrentMenu"] 
                        = new Menu() { Context = ProductMenuContext.International, SubContext = MainMenuContext.AirExport };

                }
                return (Menu)System.Web.HttpContext.Current.Session["CurrentMenu"];
            }
            set { System.Web.HttpContext.Current.Session["CurrentMenu"] = value; }
        }

        protected void SetSubMenu(MainMenuContext context)
        {
            CurrentMenu.SubContext = context;
        }
        protected void SetProductMenu(ProductMenuContext context)
        {
            CurrentMenu.Context = context;
        }
        protected int GetUserID(string email)
        {
               var context = new UsersContext();
               var user = context.UserProfiles.SingleOrDefault(u => u.UserName == email);
               return user.UserId;
        }

        protected ELTUser GetCurrentELTUser()
        {
            AuthenticationBL authBL = new AuthenticationBL();
            return authBL.GetELTUser(Session["login_name"].ToString());
        }

        protected ActionResult ReturnELTFile(int FileID)
        {
            FileSystemBL fBL = new FileSystemBL();
            ELTFileSystemItem file = fBL.GetFileByID(FileID);
            Stream receiveStream = new MemoryStream(file.Data.ToArray());

            return File(receiveStream, COMMON.Util.GetOutputFileExtension(file.Name), file.Name);
        }

        public  ActionResult ErrorView(ELTError eltError)
        {
            return View(eltError);

        }

    }
}
           