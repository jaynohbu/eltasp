using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Core.Common.CommandTrees;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using ELT.Shared.Common;
using ELT.Shared.Entities;
using ELT.Shared.Model;
using RateRoute = ELT.Shared.Model.RateRoute;

namespace ELT.DataAccess.Repository
{
    public class RateRepository :BaseRepository, IRateRepository
    {
        private ELTUser User { get; set; }
      
        public void SaveRate(List<RateRoute> rateRoutes, string sessionId)
        {
            var user = GetEltUser(sessionId);
            DisableMarkedRates(rateRoutes, user);
            UpdateExistingRates(rateRoutes, user);
            CreateRates(rateRoutes, user);
        }
        public void SaveWrappers(List<CompanyRateWrapper> wrappers, string sessionId)
        {
            foreach (var wrap in wrappers)
            {
                SaveRate(wrap.RateRoutes, sessionId);
            }
        }
        private static void CreateRates(List<RateRoute> rateRoutes, ELTUser user)
        {
            foreach (var r in rateRoutes)
            {
                if (!r.Disabled)
                {
                    var weight_break = String.Join(",", r.WeightBreak).Trim(',');
                    foreach (var item in r.PerCarrier)
                    {
                        if (item.Id == 0 && item.Disabled == false)
                        {
                           
                            var rate = new rate_table();
                            rate.breaks = weight_break;
                            rate.rates = String.Join(",", item.RateBreak).Trim(',');
                            rate.airline = item.Airline;
                            rate.min = item.Min;
                            rate.minPlus = item.MinPlus;
                            rate.agent_no = r.AgentNo;
                            if (r.RateType == RateType.AgentBuyingRate && r.AgentNo == 0) rate.agent_no = -1;
                            rate.dest_port = r.DestPort;
                            rate.origin_port = r.OriginPort;
                            rate.customer_no = r.CustomerNo;
                            if (r.RateType == RateType.CustomerSellingRate && r.CustomerNo == 0) rate.customer_no = -1;
                            rate.elt_account_number = user.IntEltAccountNumber;
                            rate.enabled = true;
                            rate.rate_type = Convert.ToInt16(r.RateType);
                            rate.kg_lb = r.KgLb;
                            rate.share = item.Share;

                            if (
                                EltUnitOfWorkContainer.Context.rate_table.Any(a => a.airline == rate.airline && a.origin_port == rate.origin_port &&
                                        a.dest_port == rate.dest_port && a.customer_no == rate.customer_no &&
                                        a.agent_no == rate.agent_no && a.elt_account_number == rate.elt_account_number &&
                                        a.enabled == true && a.rate_type == rate.rate_type))
                            {
                                var existing =
                                    EltUnitOfWorkContainer.Context.rate_table.Where(
                                        a => a.airline == rate.airline && a.origin_port == rate.origin_port &&
                                             a.dest_port == rate.dest_port && a.customer_no == rate.customer_no &&
                                             a.agent_no == rate.agent_no &&
                                             a.elt_account_number == rate.elt_account_number &&
                                             a.enabled == true && a.rate_type == rate.rate_type);

                                foreach (var e in existing)
                                {
                                    e.enabled = false;
                                    EltUnitOfWorkContainer.Context.Entry(e).State= EntityState.Modified;
                                }
                            }

                            EltUnitOfWorkContainer.Context.rate_table.Add(rate);
                            EltUnitOfWorkContainer.Context.SaveChanges();
                        }
                    }
                }
            }
        }

        private static void UpdateExistingRates(List<RateRoute> rateRoutes, ELTUser user)
        {
            foreach (var r in rateRoutes)
            {
                if (!r.Disabled)
                {
                    var weight_break = String.Join(",", r.WeightBreak).Trim(',');
                    foreach (var item in r.PerCarrier)
                    {
                        if (item.Id > 0 && item.Disabled == false)
                        {
                            var rate = EltUnitOfWorkContainer.Context.rate_table.Find(item.Id);
                            if (rate != null)
                            {
                                rate.breaks = weight_break;
                                rate.rates = String.Join(",", item.RateBreak).Trim(',');
                                rate.airline = item.Airline;
                                rate.min = item.Min;
                                rate.minPlus = item.MinPlus;
                                rate.agent_no = r.AgentNo;
                                if (r.RateType == RateType.AgentBuyingRate && r.AgentNo == 0) rate.agent_no = -1;
                                rate.dest_port = r.DestPort;
                                rate.origin_port = r.OriginPort;
                                rate.customer_no = r.CustomerNo;
                                if (r.RateType == RateType.CustomerSellingRate && r.CustomerNo == 0)
                                    rate.customer_no = -1;
                                rate.elt_account_number = user.IntEltAccountNumber;
                                rate.enabled = true;
                                rate.rate_type = Convert.ToInt16(r.RateType);
                                rate.kg_lb = r.KgLb;
                                rate.share = item.Share;
                                EltUnitOfWorkContainer.Context.Entry(rate).State = EntityState.Modified;
                                EltUnitOfWorkContainer.Context.SaveChanges();
                            }
                        }
                    }
                }
            }
        }

        private static void DisableMarkedRates(List<RateRoute> rateRoutes, ELTUser user)
        {
            foreach (var r in rateRoutes)
            {
                if (r.Disabled)
                {
                    DisableRateRoute(user, r);
                }
                else
                {
                    if (r.PerCarrier == null)
                    {
                        r.PerCarrier = new List<PerCarrier>();
                    }
                    foreach (var item in r.PerCarrier)
                    {
                        if (item.Disabled)
                        {
                            DisbleRatePerCarrier(item);
                        }
                    }
                }
            }
        }
        private static void DisbleRatePerCarrier( PerCarrier r)
        {
            var rate = EltUnitOfWorkContainer.Context.rate_table.Find(r.Id);
            if (rate != null)
            {
                rate.enabled = false;
                EltUnitOfWorkContainer.Context.Entry(rate).State = EntityState.Modified;
                EltUnitOfWorkContainer.Context.SaveChanges();
            }
        }
        private static void DisableRateRoute(ELTUser user, RateRoute r)
        {
            foreach (var item in r.PerCarrier)
            {
                if (item.Id > 0)
                {
                    var rate = EltUnitOfWorkContainer.Context.rate_table.Find(item.Id);
                    if(rate!=null)
                    rate.enabled = false;
                    EltUnitOfWorkContainer.Context.Entry(rate).State = EntityState.Modified;
                }
            }
            EltUnitOfWorkContainer.Context.SaveChanges();
        }

        public RateTable GetCustomerSellingRate(int customerId, int skip, int count, string sessionId)
        {
            var user = GetEltUser(sessionId);
            RateTable rTable=new RateTable();
            List < RateRoute > returnList=new List<RateRoute>();
            var total = 0;
            if (customerId <= 0)
            {
                total = EltUnitOfWorkContainer.Context.rate_table
                    .Count(a => a.elt_account_number == user.IntEltAccountNumber && a.rate_type == 4 && a.enabled == true);

                var customerRates = EltUnitOfWorkContainer.Context.rate_table.Where(
                    a => a.elt_account_number == user.IntEltAccountNumber && a.rate_type == 4 && a.enabled==true)
                    .OrderBy(a => a.customer_no)
                    .ToList().Skip(skip).Take(count).ToList();
           
                GroupCustomerSellingRates(customerRates, returnList);
            }
            else
            {
                total = EltUnitOfWorkContainer.Context.rate_table
                    .Count(a => a.customer_no == customerId && a.elt_account_number == user.IntEltAccountNumber &&
                        a.rate_type == 4 && a.enabled == true);

                var  customerRates = EltUnitOfWorkContainer.Context.rate_table.Where(
                    a =>
                        a.customer_no == customerId && a.elt_account_number == user.IntEltAccountNumber &&
                        a.rate_type == 4 && a.enabled == true).ToList()
                    .Skip(skip).Take(count).ToList();
                GroupCustomerSellingRates(customerRates, returnList);
            }
            rTable.Table = returnList;
            rTable.Total = total;
            var warppers =new List<CompanyRateWrapper>();
            foreach (var item in returnList)
            {
                if (warppers.All(a => a.CompanyNo != item.CustomerNo))
                {
                    var w=new CompanyRateWrapper();
                    warppers.Add(w);
                    w.CompanyNo = item.CustomerNo;
                    w.RateRoutes.Add(item);
                    w.CompanyDisabled = true;

                }
                else
                {
                    var w = warppers.Single(a => a.CompanyNo == item.CustomerNo);
                    w.RateRoutes.Add(item);
                    w.CompanyDisabled = true;
                }
            }
            rTable.CompanyWrappers = warppers;
            
            return rTable;
        }
        public RateTable GetAgentBuyingRate(int agentId, int skip, int take, string sessionId)
        {
            RateTable rTable = new RateTable();
            var user = GetEltUser(sessionId);
      
            List<RateRoute> returnList = new List<RateRoute>();
            var total = 0;
            if (agentId <= 0)
            {
                 total = EltUnitOfWorkContainer.Context.rate_table.
                      Count(a => a. elt_account_number == user.IntEltAccountNumber && (RateType)a.rate_type == RateType.AgentBuyingRate && a.enabled == true);

                     
                var agentRates = EltUnitOfWorkContainer.Context.rate_table.Where(
                      a => a.elt_account_number == user.IntEltAccountNumber && (RateType) a.rate_type ==RateType.AgentBuyingRate && a.enabled == true).OrderBy(a=>a.agent_no)
                     .ToList()
                    .Skip(skip).Take(take).ToList();

               
                GroupAgentBuyingRates(agentRates, returnList);
               
            }
            else
            {
                 total = EltUnitOfWorkContainer.Context.rate_table
                     .Count(a => a.agent_no == agentId && a.elt_account_number == user.IntEltAccountNumber &&
                         a.rate_type == 1 && a.enabled == true);

                var agentRates = EltUnitOfWorkContainer.Context.rate_table.Where(
                      a =>
                          a.agent_no == agentId && a.elt_account_number == user.IntEltAccountNumber &&
                          a.rate_type == 1 && a.enabled == true).OrderBy(a=>agentId).ToList()
                    .Skip(skip).Take(take).ToList();

                GroupAgentBuyingRates(agentRates, returnList);

            }
            rTable.Table = returnList;
            rTable.Total = total;
          
            var warppers = new List<CompanyRateWrapper>();
            foreach (var item in returnList)
            {
                if (warppers.All(a => a.CompanyNo != item.AgentNo))
                {
                    var w = new CompanyRateWrapper();
                    warppers.Add(w);
                    w.CompanyNo = item.AgentNo;
                    w.RateRoutes.Add(item);
                    w.CompanyDisabled = true;

                }
                else
                {
                    var w = warppers.Single(a => a.CompanyNo == item.AgentNo);
                    w.RateRoutes.Add(item);
                    w.CompanyDisabled = true;
                }
            }
            rTable.CompanyWrappers = warppers;
            return rTable;
        }

        public RateTable GetIataRate(int skip, int take, string sessionId)
        {
           
             RateTable rTable = new RateTable();
            var user = GetEltUser(sessionId);
         
            List<RateRoute> returnList = new List<RateRoute>();
            int total = EltUnitOfWorkContainer.Context.rate_table.Count(a => a.elt_account_number == user.IntEltAccountNumber && (RateType) a.rate_type == RateType.IataRate &&
                    a.enabled == true);
            var table = EltUnitOfWorkContainer.Context.rate_table.Where(
                a =>
                    a.elt_account_number == user.IntEltAccountNumber && (RateType) a.rate_type == RateType.IataRate &&
                    a.enabled == true)
                .OrderBy(a => a.airline).ToList()
                    .Skip(skip).Take(take).ToList();

           
            GroupIataRates(table, returnList);
            rTable.Table = returnList;
            rTable.Total = total;
            return rTable;
        }
        public RateTable GetAirlineBuyingRate(int skip, int take, string sessionId)
        {
            RateTable rTable = new RateTable();
            var user = GetEltUser(sessionId);
            List<RateRoute> returnList = new List<RateRoute>();
            int total = EltUnitOfWorkContainer.Context.rate_table
                .Count(a => a.elt_account_number == user.IntEltAccountNumber &&
                    (RateType) a.rate_type == RateType.AirlineBuyingRate && a.enabled == true);
            var table = EltUnitOfWorkContainer.Context.rate_table.Where(
                a =>
                   a.elt_account_number == user.IntEltAccountNumber &&
                    (RateType) a.rate_type == RateType.AirlineBuyingRate && a.enabled == true)
                .OrderBy(a => a.airline).ToList()
                    .Skip(skip).Take(take).ToList();

            
            GroupAirlineBuyingRates(table, returnList);
            rTable.Total = total;
            rTable.Table = returnList;
            return rTable;
        }
        private static void GroupCustomerSellingRates(List<rate_table> allRates, List<RateRoute> returnRouts)
        {
            var customerGroup = allRates.Select(a => a.customer_no).Distinct();// split for each customer
            var originGroup = allRates.Select(a => a.origin_port).Distinct();
            var destingGroup = allRates.Select(a => a.dest_port).Distinct();
            var carrierGroup = allRates.Select(a => a.airline).Distinct();
            foreach (var cid in customerGroup)
            {
                foreach (var org in originGroup)
                {
                    foreach (var des in destingGroup)
                    {
                        var route =
                            allRates.FirstOrDefault(a => a.dest_port == des && a.origin_port == org &&
                                                         a.customer_no == cid);
                        if (route != null)
                        {
                            var rateRoute = new RateRoute(); // RateRoute per ORGIN+DESTIN+CUSTOMER 
                            returnRouts.Add(rateRoute);
                            rateRoute.PerCarrier = new List<PerCarrier>();
                      
                            rateRoute.KgLb = route.kg_lb;
                            rateRoute.RateType = (RateType) route.rate_type;
                            rateRoute.DestPort = route.dest_port;
                            rateRoute.OriginPort = route.origin_port;
                            if (!string.IsNullOrEmpty(route.breaks))
                                rateRoute.WeightBreak = route.breaks.Split(','); //weight breaks are all the same
                            foreach (var cr in carrierGroup)
                            {
                                var carrier =
                                    allRates.FirstOrDefault(
                                        a => a.airline == cr && a.dest_port == des && a.origin_port == org &&
                                             a.customer_no == cid);

                                if (carrier != null)
                                {
                                    rateRoute.CustomerNo = Convert.ToInt32(carrier.customer_no);
                                    var item = new PerCarrier()
                                    {
                                        Id = Convert.ToInt32(carrier.id),
                                        Airline =
                                            Convert.ToInt32(carrier.airline) == 0
                                                ? -1
                                                : Convert.ToInt32(carrier.airline),
                                        Share = Convert.ToDecimal(carrier.share),
                                        Min = Convert.ToDecimal(carrier.min),
                                        MinPlus = Convert.ToDecimal(carrier.minPlus)
                                    };
                                    if (!string.IsNullOrEmpty(carrier.breaks))
                                    {
                                        var rates = carrier.rates.Split(',');
                                        for (int i = 0; i < rates.Length; i++)
                                        {
                                            item.RateBreak[i] = rates[i];
                                        }
                                    }
                                    rateRoute.PerCarrier.Add(item);
                                }
                            }
                        }
                    }
                }
            }
        }
        private static void GroupAgentBuyingRates(List<rate_table> allRates, List<RateRoute> returnRouts)
        {
            var agentGroup = allRates.Select(a => a.agent_no).Distinct();// split for each customer
            var originGroup = allRates.Select(a => a.origin_port).Distinct();
            var destingGroup = allRates.Select(a => a.dest_port).Distinct();
            var carrierGroup = allRates.Select(a => a.airline).Distinct();
            foreach (var aid in agentGroup)
            {
                foreach (var org in originGroup)
                {
                    foreach (var des in destingGroup)
                    {
                        var route =
                            allRates.FirstOrDefault(a => a.dest_port == des && a.origin_port == org &&
                                                         a.agent_no == aid);
                        if (route != null)
                        {
                            var rateRoute = new RateRoute(); // RateRoute per ORGIN+DESTIN+CUSTOMER 
                            returnRouts.Add(rateRoute);
                            rateRoute.PerCarrier = new List<PerCarrier>();
                         
                            rateRoute.KgLb = route.kg_lb;
                            rateRoute.RateType = (RateType) route.rate_type;
                            rateRoute.DestPort = route.dest_port;
                            rateRoute.OriginPort = route.origin_port;
                            if (!string.IsNullOrEmpty(route.breaks))
                                rateRoute.WeightBreak = route.breaks.Split(','); //weight breaks are all the same
                            foreach (var cr in carrierGroup)
                            {
                                var carrier =
                                    allRates.FirstOrDefault(
                                        a => a.airline == cr && a.dest_port == des && a.origin_port == org &&
                                             a.agent_no == aid);
                                if (carrier != null)
                                {
                                    rateRoute.AgentNo = Convert.ToInt32(carrier.agent_no);
                                    var item = new PerCarrier()
                                    {
                                        Id = Convert.ToInt32(carrier.id),
                                        Airline =
                                            Convert.ToInt32(carrier.airline) == 0
                                                ? -1
                                                : Convert.ToInt32(carrier.airline),
                                        Share = Convert.ToDecimal(carrier.share),
                                        Min = Convert.ToDecimal(carrier.min),
                                        MinPlus = Convert.ToDecimal(carrier.minPlus)
                                    };
                                    if (!string.IsNullOrEmpty(carrier.breaks))
                                    {
                                        var rates = carrier.rates.Split(',');
                                        for (int i = 0; i < rates.Length; i++)
                                        {
                                            item.RateBreak[i] = rates[i];
                                        }
                                    }
                                    rateRoute.PerCarrier.Add(item);
                                }
                            }
                        }
                    }
                }
            }
        }

        private static void GroupAirlineBuyingRates(List<rate_table> allRates, List<RateRoute> returnRouts)
        {
           
            var originGroup = allRates.Select(a => a.origin_port).Distinct();
            var destingGroup = allRates.Select(a => a.dest_port).Distinct();
            var carrierGroup = allRates.Select(a => a.airline).Distinct();
           
                foreach (var org in originGroup)
                {
                    foreach (var des in destingGroup)
                    {
                        var route =
                            allRates.FirstOrDefault(a => a.dest_port == des && a.origin_port == org);
                    if (route != null)
                    {
                        var rateRoute = new RateRoute(); // RateRoute per ORGIN+DESTIN+CUSTOMER 
                        returnRouts.Add(rateRoute);
                        rateRoute.PerCarrier = new List<PerCarrier>();
                      
                        rateRoute.KgLb = route.kg_lb;
                        rateRoute.RateType = (RateType)route.rate_type;
                        rateRoute.DestPort = route.dest_port;
                        rateRoute.OriginPort = route.origin_port;
                        if (!string.IsNullOrEmpty(route.breaks))
                            rateRoute.WeightBreak = route.breaks.Split(','); //weight breaks are all the same
                        foreach (var cr in carrierGroup)
                        {
                            var carrier =
                                allRates.FirstOrDefault(
                                    a => a.airline == cr && a.dest_port == des && a.origin_port == org);
                            if (carrier != null)
                            {
                                var item = new PerCarrier()
                                {
                                    Id = Convert.ToInt32(carrier.id),
                                    Airline =
                                        Convert.ToInt32(carrier.airline) == 0 ? -1 : Convert.ToInt32(carrier.airline),
                                    Share = Convert.ToDecimal(carrier.share),
                                    Min = Convert.ToDecimal(carrier.min),
                                    MinPlus = Convert.ToDecimal(carrier.minPlus)
                                };
                                if (!string.IsNullOrEmpty(carrier.breaks))
                                {
                                    var rates = carrier.rates.Split(',');
                                    for (int i = 0; i < rates.Length; i++)
                                    {
                                        item.RateBreak[i] = rates[i];
                                    }
                                }
                                rateRoute.PerCarrier.Add(item);
                            }
                        }
                    }
                 }
                
            }
        }



        private static void GroupIataRates(List<rate_table> allRates, List<RateRoute> returnRouts)
        {

            var originGroup = allRates.Select(a => a.origin_port).Distinct();
            var destingGroup = allRates.Select(a => a.dest_port).Distinct();
            var carrierGroup = allRates.Select(a => a.airline).Distinct();

            foreach (var org in originGroup)
            {
                foreach (var des in destingGroup)
                {
                    var route =
                        allRates.FirstOrDefault(a => a.dest_port == des && a.origin_port == org);
                    if (route != null)
                    {
                        var rateRoute = new RateRoute(); // RateRoute per ORGIN+DESTIN+CUSTOMER 
                    returnRouts.Add(rateRoute);
                    rateRoute.PerCarrier = new List<PerCarrier>();

                    rateRoute.KgLb = route.kg_lb;
                    rateRoute.RateType = (RateType)route.rate_type;
                    rateRoute.DestPort = route.dest_port;
                    rateRoute.OriginPort = route.origin_port;
                    if (!string.IsNullOrEmpty(route.breaks))
                        rateRoute.WeightBreak = route.breaks.Split(','); //weight breaks are all the same
                        foreach (var cr in carrierGroup)
                        {
                            var carrier =
                                allRates.FirstOrDefault(
                                    a => a.airline == cr && a.dest_port == des && a.origin_port == org);
                            if (carrier != null)
                            {
                                var item = new PerCarrier()
                                {
                                    Id = Convert.ToInt32(carrier.id),
                                    Airline =
                                        Convert.ToInt32(carrier.airline) == 0 ? -1 : Convert.ToInt32(carrier.airline),
                                    Share = Convert.ToDecimal(carrier.share),
                                    Min = Convert.ToDecimal(carrier.min),
                                    MinPlus = Convert.ToDecimal(carrier.minPlus)
                                };
                                if (!string.IsNullOrEmpty(carrier.breaks))
                                {
                                    var rates = carrier.rates.Split(',');
                                    for (int i = 0; i < rates.Length; i++)
                                    {
                                        item.RateBreak[i] = rates[i];
                                    }
                                }
                                rateRoute.PerCarrier.Add(item);
                            }
                        }
                    }
                }

            }
        }
    }
}
