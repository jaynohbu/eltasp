using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Mvc;
using System.Web.Routing;
using AuthorizationContext = System.Web.Mvc.AuthorizationContext;
using AuthorizeAttribute = System.Web.Http.AuthorizeAttribute;
using ELT.Shared;
using ELT.Shared.Util;

namespace ELT.Api
{
    public class ApiAuthorizeAttribute : AuthorizeAttribute
    {
       
        public ApiAuthorizeAttribute()
        {
           
        }

        public ApiAuthorizeAttribute(string resourceAction)
        {
          //  this.resourceAction = resourceAction;
        }

        public override void OnAuthorization(HttpActionContext actionContext)
        {
            base.OnAuthorization(actionContext);
            var col= HttpContext.Current.Request["sessionId"];
            if (col == null)
            {
                actionContext.Response = new HttpResponseMessage(HttpStatusCode.Unauthorized);
                HttpContext.Current.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
                HttpContext.Current.Response.End();
            }
            else
            {
                actionContext.Response = new HttpResponseMessage(HttpStatusCode.Unauthorized);
                HttpContext.Current.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
                HttpContext.Current.Response.End();
            }
        }


    }

  
}