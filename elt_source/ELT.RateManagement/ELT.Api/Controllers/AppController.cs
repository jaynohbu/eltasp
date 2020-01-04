using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Cors;
using ELT.Logic;
using ELT.Shared.Model;
using Microsoft.SqlServer.Server;
using Ninject;

namespace ELT.Api.Controllers
{

    [RoutePrefix("api/app")]

    public class AppController : BaseApiController
    {
        

        [Inject]
        public IAppLogic AppLogic { get;  set; }

        [Route("init")]
        [HttpGet]
        public IHttpActionResult InitDbSession()
        {
            return Execute(() => AppLogic.InitDbSession());
        }
      
    }
}
