using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ELT.WEB.Controllers
{
    public class PrintCheckController : Controller
    {
        //
        // GET: /PrintCheck/

        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Clear()
        {
            int from = Convert.ToInt32(Request.QueryString["from"]);
            int to = Convert.ToInt32(Request.QueryString["to"]);
            return View();
        }

        
       


    }
}
