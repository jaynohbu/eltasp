using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Mvc;
using System.Web.Routing;
using WarpLX.Shared.Constants;
using AuthorizationContext = System.Web.Mvc.AuthorizationContext;
using AuthorizeAttribute = System.Web.Http.AuthorizeAttribute;

namespace WarpLX.Api
{
    public class APIAuthorizeAttribute : AuthorizeAttribute
    {
        private readonly string resourceAction; 

        public APIAuthorizeAttribute()
        {
            this.resourceAction = null;
        }

        public APIAuthorizeAttribute(string resourceAction)
        {
            this.resourceAction = resourceAction;
        }

        public override void OnAuthorization(HttpActionContext actionContext)
        {
            base.OnAuthorization(actionContext);
            if (actionContext.RequestContext.Principal != null && actionContext.RequestContext.Principal.Identity.IsAuthenticated)
            {
                if (!string.IsNullOrEmpty(this.resourceAction))
                {
                    // compare against resource action in cookies
                    var claimValue = (from claim in (HttpContext.Current.User as ClaimsPrincipal).Claims
                                      where claim.Type == AuthConstants.ResourceActions
                                      select claim.Value).FirstOrDefault();

                    if (!claimValue.Contains(this.resourceAction))
                    {
                        actionContext.Response = new HttpResponseMessage(HttpStatusCode.Forbidden);
                        HttpContext.Current.Response.StatusCode = (int)HttpStatusCode.Forbidden;
                        HttpContext.Current.Response.End();
                    }
                }
            }
            else if (actionContext.RequestContext.Principal != null && !actionContext.RequestContext.Principal.Identity.IsAuthenticated)
            {
                actionContext.Response = new HttpResponseMessage(HttpStatusCode.Unauthorized);
                HttpContext.Current.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
                HttpContext.Current.Response.End();
            }
            else
            {
                actionContext.Response = new HttpResponseMessage(HttpStatusCode.BadRequest);
                HttpContext.Current.Response.StatusCode = (int)HttpStatusCode.BadRequest;
                HttpContext.Current.Response.End();
            }
        }


    }

    public class PageAuthorizeAttribute : System.Web.Mvc.AuthorizeAttribute
    {
        private readonly string resourceAction; 

        public PageAuthorizeAttribute()
        {
            this.resourceAction = null;
        }

        public PageAuthorizeAttribute(string resourceAction)
        {
            this.resourceAction = resourceAction;
        }

        public override void OnAuthorization(AuthorizationContext filterContext)
        {
            base.OnAuthorization(filterContext);
            if (filterContext.HttpContext.Request.IsAuthenticated)
            {
                if (!string.IsNullOrEmpty(this.resourceAction))
                {
                    // compare against resource action in cookies
                    var claimValue = (from claim in (HttpContext.Current.User as ClaimsPrincipal).Claims
                                      where claim.Type == AuthConstants.ResourceActions
                                      select claim.Value).FirstOrDefault();

                    if(!claimValue.Contains(this.resourceAction))
                    {
                        filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new { controller = "Error", action = "AccessDenied" }));
                    }
                }  
            }
        }
    }
}