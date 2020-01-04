using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.CDT;
using ELT.DA;
using System.Web;
using System.Data;
namespace ELT.BL
{
    public class RateManagementBL
    {
        int elt_account_number, customer_org_num, rate_type;
        RateManagementDA da = new RateManagementDA();
        Dictionary<string, List<RateRouting>> dict = new Dictionary<string, List<RateRouting>>();

        public RateManagementBL()
        {
            customer_org_num = HttpContext.Current.Session["rate_customer_org_num"]==null?0:int.Parse(HttpContext.Current.Session["rate_customer_org_num"].ToString());
            rate_type = HttpContext.Current.Session["rate_rate_type"] == null ? 0 : int.Parse(HttpContext.Current.Session["rate_rate_type"].ToString());
            elt_account_number = HttpContext.Current.Session["rate_elt_account_number"] == null ? 0 : int.Parse(HttpContext.Current.Session["rate_elt_account_number"].ToString());
        }
        public void  SetParms(int elt_account_number, int customer_org_num, int rate_type)
        {
            HttpContext.Current.Session["rate_elt_account_number"] = elt_account_number;
            HttpContext.Current.Session["rate_customer_org_num"] = customer_org_num;
            HttpContext.Current.Session["rate_rate_type"] = rate_type;           
        }       
        public List<FlattenRateItem> GetAllRate(int elt_account_number, int customer_org_num, int rate_type)
        {
            List<FlattenRateItem> list = null;
            list = da.GetAllRate(elt_account_number, customer_org_num, rate_type);
            return list;
        }
        public List<RateRouting> SaveRateInfo(List<RateRouting> rRList)
        {           
            
            List<FlattenRateItem> list = new List<FlattenRateItem>();
            int item_no = 0;
            foreach (var routing in rRList)
            {
                foreach (var rate in routing.Rates)
                {
                    foreach (var br in rate.RateDefinitionColums)
                    {
                        if (!string.IsNullOrEmpty(br.Rate) && !string.IsNullOrEmpty(rate.CarrierCode) && !string.IsNullOrEmpty(routing.Origin) && !string.IsNullOrEmpty(routing.Dest))
                        {
                            FlattenRateItem item = new FlattenRateItem();
                            item.rate_type = rate_type;
                            item.item_no = item_no;
                            item.weight_break = br.Value;
                            item.rate = Convert.ToDecimal(br.Rate);
                            item.kg_lb = routing.Unit;
                            item.agent_no = rate_type == 1 ? routing.agent_org_account_number : 0;
                            item.customer_no = rate_type == 4 ? routing.customer_org_account_number : 0;
                            item.carrier = Convert.ToInt32(rate.CarrierCode);
                            item.elt_account_number = elt_account_number;
                            item.origin_port = routing.Origin;
                            item.dest_port = routing.Dest;
                            item.share = Convert.ToDecimal(rate.Share);
                            list.Add(item);
                            item_no++;
                        }
                    }
                }
            }
            RateManagementDA DA = new RateManagementDA();
            try
            {
                DA.SaveRate(elt_account_number, customer_org_num, rate_type, list);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            ClearRateRoutings();
            return GetRateRoutings( elt_account_number,  customer_org_num,  rate_type);
        }            
        public int InsertRoute(RateRouting routinng)
        {          
            var rlist = GetRateRoutings(elt_account_number, customer_org_num, rate_type);
            if (rlist.Count > 0)
            {
                routinng.ID = rlist.OrderByDescending(r => r.ID).First().ID + 1;
            }
            else
            {
                routinng.ID = 1;
            }
            rlist.Add(routinng);
            PesisteRateRouting(rlist);
            return routinng.ID;
        }
        public void DeleteRoute(RateRouting r)
        {           
            var rlist = GetRateRoutings(elt_account_number, customer_org_num, rate_type);
            var route = from c in rlist where c.ID == r.ID select c;
            rlist.Remove(route.First());
            PesisteRateRouting(rlist);
            //rlist = GetRateRoutings(elt_account_number, customer_org_num, rate_type);
            //SaveRateInfo(rlist);
        }
        public void PesisteRateRouting(List<RateRouting> list)
        {
            HttpContext.Current.Session["RateDict"] = list;
           
        }
        
        public RateRouting GetRouting(int routeId)
        {           
            var list =GetRateRoutings( elt_account_number,  customer_org_num,  rate_type);
            var route = (from c in list where c.ID == routeId select c).First();
            foreach (var rate in route.Rates)
            {
                RefreshWeightBreakText(rate.RateDefinitionColums);
            }
            return route;
        }
       
        public List<RateRouting> GetRateRoutings(int elt_account_number, int customer_org_num, int rate_type)
        {
            List<RateRouting> RoutingList = GetRateRoutingFromSession(rate_type);
            if (RoutingList == null)
            {
                RoutingList = GetRoutingsFromDB(elt_account_number, customer_org_num, rate_type, RoutingList);
                PesisteRateRouting(RoutingList);
            }
            foreach (var route in RoutingList)
            {
                foreach (var rate in route.Rates)
                {
                    RefreshWeightBreakText(rate.RateDefinitionColums);
                }
            }
            return RoutingList;
        }

        public void ClearRateRoutings()
        {
            HttpContext.Current.Session["RateDict"] = null;
        }
        public List<RateRouting> GetRateRoutingFromSession(int rate_type)
        {
            if (HttpContext.Current.Session["RateDict"] != null)
            {
                return (List<RateRouting>)HttpContext.Current.Session["RateDict"];
            }
            return null;
        }
        private List<RateRouting> GetRoutingsFromDB(int elt_account_number, int customer_org_num, int rate_type, List<RateRouting> RoutingList)
        {
            var list = GetAllRate(elt_account_number, customer_org_num, rate_type);
            RoutingList = TranferRateRoutingsFromRaw(list);
            foreach (var route in RoutingList)
            {
                DataTable dt = new DataTable();               
                dt = GetDynamicColumsForRoute(route, dt);               
            }
            return RoutingList;
        }
     
        private DataTable GetDynamicColumsForRoute(RateRouting route, DataTable dt)
        {
            var rate = route.Rates[0];
            if (rate.RateDefinitionColums != null)
            {
                RefreshWeightBreakText(rate.RateDefinitionColums);
            }
            rate.RateDefinitionColums = rate.RateDefinitionColums.OrderBy(r => r.Value).ToList();
            foreach (var brk in rate.RateDefinitionColums)
            {
               
                dt.Columns.Add(brk.Value, typeof(string)).Caption = brk.Caption;
            }

            return dt;
        }
        public DataTable GetDynamicTableForRoute(int routeId)
        {
           
            List<dynamic> list = new List<dynamic>();
            var rlist = GetRateRoutings(elt_account_number, customer_org_num, rate_type);
            var route = (from c in rlist where c.ID == routeId select c).Single();

            DataTable dt = new DataTable();
         

            dt = GetDynamicColumsForRoute(route, dt);
            return dt;
        }
    
        public Rate GetRate(int rateId)
        {
            
            var rlist = GetRateRoutings(elt_account_number, customer_org_num, rate_type);
            foreach (var route in rlist)
            {
                foreach (var rate in route.Rates)
                {
                    if (rate.RateID == rateId)
                    {
                        return rate;
                    }
                }
            }
            return null;
        }
        public int GetNewRoutingID()
        {
            int newId = 1;
            var rlist = GetRateRoutings(elt_account_number, customer_org_num, rate_type);
            if (rlist.Count > 0)
            {
                 newId = rlist.OrderByDescending(r => r.ID).First().ID + 1;
            }
            return newId;
        }
        public List<RateRouting> TranferRateRoutingsFromRaw(List<FlattenRateItem> rawList)
        {
            List<RateRouting> RoutingList = new List<RateRouting>();
           
            PrepRouteList(RoutingList, rawList);
            int rateid = 1;
            foreach (var RoutingItem in RoutingList)
            {
                var rawItems = (from c in rawList where c.kg_lb == RoutingItem.Unit && c.dest_port == RoutingItem.Dest && c.origin_port == RoutingItem.Origin select c).ToList();
                var rawItemsbyGroup = (from c in rawItems group c by c.carrier into grps select grps).SelectMany(g => g);

                RoutingItem.Rates = new List<Rate>();
                int CurrentCarrier = 0;
                Rate CurrentRate = null;

                foreach (var r in rawItemsbyGroup)
                {
                    if (CurrentCarrier != r.carrier)
                    {
                        Rate rate = new Rate() { RouteID = RoutingItem.ID, RateID = rateid, CarrierCode = r.carrier.ToString(), Share = r.share.ToString(), RateDefinitionColums = new List<RateDefinitionColum>() };
                        CurrentRate = rate;
                        RoutingItem.Rates.Add(rate);
                    }

                    RateDefinitionColum RateBreak = new RateDefinitionColum();
                    RateBreak.Caption = r.weight_break;
                    RateBreak.Value = r.weight_break;
                    RateBreak.Rate = r.rate.ToString();
                    RateBreak.ID = r.id;
                    CurrentRate.RateDefinitionColums.Add(RateBreak);
                    CurrentRate.RawItemID = r.id;
                    CurrentCarrier = r.carrier;
                    rateid++;
                }
            }
            RoutingList = (from c in RoutingList where c.Rates.Count > 0 select c).ToList();
            int routeid = 1;
            foreach (var r in RoutingList)
            {
                r.ID = routeid++;
               
            }
            
            return RoutingList;
        }
        public void RefreshWeightBreakText(List<RateDefinitionColum> DefinitionColums)
        {
            DefinitionColums = DefinitionColums.OrderBy(r => int.Parse(r.Value)).ToList();
            for (int i = 0; i < DefinitionColums.Count; i++)
            {
                if (i < DefinitionColums.Count - 1)
                {
                    if (int.Parse(DefinitionColums[i].Value) == 0) 
                    {
                        DefinitionColums[i].Caption = "MIN.($)"; 
                    }
                    else
                    {
                        DefinitionColums[i].Caption = DefinitionColums[i].Value + " ~ " + (int.Parse(DefinitionColums[i + 1].Value) - 1).ToString();
                    }
                }
                else
                {
                    DefinitionColums[i].Caption = DefinitionColums[i].Value + " ~ ";
                }
            }
        }
        public int GetNextRateID()
        {            
             var rlist = GetRateRoutings(elt_account_number, customer_org_num, rate_type);
             List<Rate> rateList = new List<Rate>();
             foreach (var r in rlist)
             {
                 rateList.AddRange(r.Rates);
             }
             int newId = 1;
             if (rateList.Count > 0)
                 newId = rateList.OrderByDescending(r => r.RateID).First().RateID + 1;
             return newId;
        }
        public void InsertRate(Rate rate, int routeid)
        {            
            RateRouting route = GetRouting(routeid);
            int newId = GetNextRateID();            
            rate.RateID = newId;
            route.Rates.Add(rate);
            var rlist = GetRateRoutings(elt_account_number, customer_org_num, rate_type);           
            var original = (from c in rlist where c.ID == routeid select c).First();
            rlist.Remove(original);
            rlist.Add(route);
            PesisteRateRouting(rlist);           
        }
        public void DeleteRate(int rateId, int routeid)
        {            
            RateRouting route = GetRouting(routeid);
            var rate = (from c in route.Rates where c.RateID == rateId select c).First();
            route.Rates.Remove(rate);
            var rlist = GetRateRoutings(elt_account_number, customer_org_num, rate_type);

            PesisteRateRouting(rlist); 
        }
        public void UpdateRate(Rate rate, int routeid)
        {           
            RateRouting route = GetRouting(routeid);
            var rateOriginal = (from c in route.Rates where c.RateID == rate.RateID select c).First();
            route.Rates.Remove(rateOriginal);
            route.Rates.Add(rate);
            var rlist = GetRateRoutings(elt_account_number, customer_org_num, rate_type);
            
            PesisteRateRouting(rlist); 
        }
        public DataTable GetRatesAndBreaks(int routeId)
        {          
            List<dynamic> list = new List<dynamic>();
            var rlist = GetRateRoutings(elt_account_number, customer_org_num, rate_type);
            var route = (from c in rlist where c.ID == routeId select c).Single();
            DataTable dt = new DataTable();
            var rate = route.Rates[0];
            dt.Columns.Add("CarrierCode", typeof(string));
            dt.Columns.Add("RateID", typeof(int));
            dt.Columns.Add("Share", typeof(string));
            dt.Columns.Add("RawItemId", typeof(string));
            foreach (var brk in rate.RateDefinitionColums)
            {
                dt.Columns.Add(brk.Value, typeof(string)).Caption = brk.Caption;             
            }
            route.Rates = route.Rates.OrderBy(r => r.RateID).ToList();
            for (int i = 0; i < route.Rates.Count; i++)
            {
                var r = route.Rates[i];
                DataRow dr = dt.NewRow();
                foreach (var brk in r.RateDefinitionColums)
                {
                    dr["RateID"] = r.RateID;
                    dr["Share"] = r.Share;
                    dr["RawItemId"] = r.RawItemID;
                    dr["CarrierCode"] = r.CarrierCode;
                    dr[brk.Value] = brk.Rate;
                }
                dt.Rows.Add(dr);
            }
            return dt;
        }
        private static void PrepRouteList(List<RateRouting> list, List<FlattenRateItem> rawList)
        {
            var o = rawList.GroupBy(c => c.origin_port).Select(group => group.First());
            List<string> Origins = (from c in o select c.origin_port).ToList();

            var d = rawList.GroupBy(c => c.dest_port).Select(group => group.First());
            List<string> Destins = (from c in d select c.dest_port).ToList();

            var u = rawList.GroupBy(c => c.kg_lb).Select(group => group.First());
            List<string> Units = (from c in u select c.kg_lb).ToList();

            foreach (var unit in Units)
            {
                foreach (var s1 in Origins)
                {
                    foreach (var s2 in Destins)
                    {
                        RateRouting route = new RateRouting();

                        route.elt_account_number = rawList[0].elt_account_number;
                        route.Origin = s1;
                        route.Dest = s2;                       
                        route.Unit = unit;
                        list.Add(route);                         
                    }
                }
            }


            foreach (var route in list)
            {
                var customer = from c in rawList where c.customer_no > 0 && c.dest_port == route.Dest && c.origin_port == route.Origin && c.kg_lb == route.Unit select c;
                if (customer.Count() > 0)
                {
                    route.customer_org_account_number = customer.First().customer_no;
                    route.CustomerOrgName = customer.First().dba_name;
                }
                var agent = from c in rawList where c.customer_no > 0 && c.dest_port == route.Dest && c.origin_port == route.Origin && c.kg_lb == route.Unit select c;
                if (agent.Count() > 0)
                {
                    route.agent_org_account_number = agent.First().customer_no;
                    route.AgentOrgName = agent.First().dba_name;
                }
            }
        }
    }
}
