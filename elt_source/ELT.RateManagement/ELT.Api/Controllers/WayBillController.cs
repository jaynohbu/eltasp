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
    [RoutePrefix("api/waybill")]
    public class WayBillController : BaseApiController
    {
        [Inject]
        public IWayBillLogic WayBillLogic { get; set; }

        [Route("mawb_booking_info")]
        [HttpGet]
        public IHttpActionResult GetMawbBookingInfo(string mawb, int elt_account_number)
        {
            return Execute(() => WayBillLogic.GetMawbBookingInfo(mawb,  elt_account_number));
        }
       
    }
}
