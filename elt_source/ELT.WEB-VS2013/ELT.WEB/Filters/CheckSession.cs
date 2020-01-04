using System;
using System.Web;
using System.Web.Mvc;
using ELT.BL;

namespace ELT.WEB.Filters
{
    public class CheckSessionAttribute : ActionFilterAttribute
    {
        public override void OnResultExecuting(ResultExecutingContext filterContext)
        {
            if (filterContext.RequestContext.HttpContext.Request.IsAuthenticated)
            {
               
                string clientIp = filterContext.RequestContext.HttpContext.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                if (string.IsNullOrEmpty(clientIp))
                {
                    clientIp = filterContext.RequestContext.HttpContext.Request.UserHostAddress;
                }

                //string SessionID = filterContext.RequestContext.HttpContext.Session.SessionID;
                var httpCookie = filterContext.RequestContext.HttpContext.Request.Cookies["ELTSession"];
                if (httpCookie != null)
                {
                    string SessionID = httpCookie.Value;

                    AuthenticationBL sMgr = new AuthenticationBL();
                    string Msg="";
                    bool isUserValid = sMgr.CheckSession(2, filterContext.RequestContext.HttpContext.Session["login_name"].ToString(), Convert.ToInt32(filterContext.RequestContext.HttpContext.Session["elt_account_number"]), "", SessionID, filterContext.RequestContext.HttpContext.Request.Url.PathAndQuery, out Msg);
                    if (!isUserValid)
                    {
                        try
                        {
                            HttpContext.Current.Response.Redirect("~/Account/LogOff?Msg=" + Msg);
                        }
                        catch (Exception) { }//There are casese when Redirection already took place. In this case, the redirection will not work. 
                    }
                }
            }

            base.OnResultExecuting(filterContext);
        }
    }
}