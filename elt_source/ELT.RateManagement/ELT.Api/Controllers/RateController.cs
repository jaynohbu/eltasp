using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Web.Http;
using System.Web.Http.Cors;
using ELT.Logic;
using ELT.Shared.Common;
using ELT.Shared.Model;
using Microsoft.SqlServer.Server;
using Newtonsoft.Json.Linq;
using Ninject;

namespace ELT.Api.Controllers
{
    [EnableCors(origins: "*", headers: "*", methods: "*", exposedHeaders:"*")]
    [RoutePrefix("api/rate")]

    public class RateController : BaseApiController
    {

        [Route("companywrappermodel")]
        [HttpGet]
        public IHttpActionResult CompanyRateWrapperModel()
        {
            return Execute(() =>
            {
                var model = new CompanyRateWrapper();
                var rateRoute = new RateRoute();
                model.RateRoutes.Add(rateRoute);
                return model;
            });
        }

        [Route("carriermodel")]
        [HttpGet]
        public IHttpActionResult GetCarrierModel()
        {
            return Execute(() => new PerCarrier());
        }

        [Route("routemodel")]
        [HttpGet]
        public IHttpActionResult GetRateModel()
        {
            return Execute(() => new RateRoute());
        }
        [Inject]
        public IRateLogic RateLogic { get;  set; }

        
        [Route("save")]
        [HttpPost]
        public IHttpActionResult SaveTable(
            RateTable rateTable)
        {
            return Execute(() => RateLogic.SaveTable(rateTable.Table, rateTable.SessionId));
        }

        [Route("savewrappers")]
        [HttpPost]
        public void SaveWrappers(List<CompanyRateWrapper> wrappers)
        {
             Execute(() => RateLogic.SaveWrappers(wrappers, wrappers[0].SessionId));
        }


        [Route("customerselling")]
        [HttpGet]
        public IHttpActionResult GetCustomerSellingRate(int customerId, int? skip, int? take, string sessionId)
        {
            DefaultPageCount(ref skip, ref take);
            return Execute(() => RateLogic.GetCustomerSellingRate(customerId, (int) skip, (int)take, sessionId));
        }
        [Route("agentbuying")]
        [HttpGet]
        public IHttpActionResult GetAgentBuyingRate(int agentId, int? skip, int? take, string sessionId)
        {
            DefaultPageCount(ref skip, ref take);
            return Execute(() => RateLogic.GetAgentBuyingRate(agentId, (int)skip, (int)take, sessionId));
        }

        [Route("iata")]
        [HttpGet]
        public IHttpActionResult GetIataRate(int? skip, int? take, string sessionId)
        {
            DefaultPageCount(ref skip, ref take);
            return Execute(() => RateLogic.GetIataRate((int)skip, (int)take, sessionId));
        }

        [Route("airlineBuying")]
        public IHttpActionResult GetAirlineBuyingRate(int? skip, int? take, string sessionId)
        {
            DefaultPageCount(ref skip, ref take);
            return Execute(() => RateLogic.GetAirlineBuyingRate((int)skip, (int)take, sessionId));
        }
    }
}
