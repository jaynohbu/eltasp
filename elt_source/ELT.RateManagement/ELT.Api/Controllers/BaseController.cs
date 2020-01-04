using System.Net.Http;
using System.Reflection;
using System.Web.Http;
using System.Web.Http.Results;
using System;
using System.IO;
using System.Net;
using log4net;
using log4net.Config;
using System.Configuration;
using ELT.Shared.Common;


namespace ELT.Api.Controllers
{
   
    public abstract class BaseApiController : ApiController
    {
        protected static void DefaultPageCount(ref int? skip, ref int? count)
        {
            if (skip == null)
            {
                skip = 0;
            }
            if (count == null)
            {
                count = AppConstant.PAGE_COUNT_RATE;
            }

        }
        private static readonly ILog Logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        protected BaseApiController()
        {
            XmlConfigurator.Configure();
        }
        public HttpResponseMessage Error(string function, Exception ex)
        {
            Logger.Error(function, ex);
            return new HttpResponseMessage { StatusCode = HttpStatusCode.InternalServerError };
        }
        public IHttpActionResult Execute<T>(Func<T> func)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }
                var results = func.Invoke();


                return Ok(results);
            }
            catch (Exception ex)
            {
                Logger.Error(func.GetMethodInfo().Name, ex);
                return InternalServerError(ex);
            }
        }

        public IHttpActionResult Execute(Action func)
        {
            try
            {
                func.Invoke();
                return new StatusCodeResult(HttpStatusCode.OK, Request);
            }
            catch (Exception ex)
            {
                Logger.Error(func.GetMethodInfo().Name, ex);
                return InternalServerError(ex);
            }
        }

        public HttpResponseMessage Options()
        {
            return new HttpResponseMessage { StatusCode = HttpStatusCode.OK };
        }

       
    }
}