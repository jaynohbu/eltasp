using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Cors;
using ELT.Logic;
using Microsoft.SqlServer.Server;
using Ninject;

namespace ELT.Api.Controllers
{

    [RoutePrefix("api/reference")]

    public class ReferenceController : BaseApiController
    {
        [Inject]
        public IReferenceLogic ReferenceLogic { get;  set; }
        [Route("agents")]
        public IHttpActionResult GetAgents(string qry, string sessionId)
        {
            return Execute(() => ReferenceLogic.GetAgents(qry, sessionId));
        }
        [Route("customers")]
        public IHttpActionResult GetCustomers(string qry, string sessionId)
        {
            return Execute(() => ReferenceLogic.GetCustomers(qry, sessionId));
        }
        [Route("airlines")]
        public IHttpActionResult GetAirLines(string qry, string sessionId)
        {
            return Execute(() => ReferenceLogic.GetAirLines(qry, sessionId));
        }
        [Route("ports")]
        public IHttpActionResult GetPorts(string qry, string sessionId)
        {
            return Execute(() => ReferenceLogic.GetPorts(qry, sessionId));
        }
    }
}
