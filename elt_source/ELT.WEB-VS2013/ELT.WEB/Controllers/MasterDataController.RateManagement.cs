using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ELT.COMMON;
using ELT.WEB.Models;
using ELT.CDT;
using ELT.BL;
using ELT.WEB.Filters;

namespace ELT.WEB.Controllers
{
    [Authorize]
    public partial class MasterDataController : OperationBaseController
    {
        string MsgText = "";
          [CheckSession]
       [NoCache]
        public ActionResult RateManager(string param)
          {
           
            return View();
        }


       [NoCache]
       public ActionResult RateManagerPopup()
       {
           RateManagementBL bl = new RateManagementBL();
         
           RateManagerMaster model = new RateManagerMaster();

           bl.ClearRateRoutings();
           model.UIState = "Init";

           if (Request.QueryString["acct_no"] != null)
           {
               model.RedirectedFromClientProfile = true;
               model.CustomerID = int.Parse(Request.QueryString["acct_no"]);
           }
           return View(model);
       }      


     
       private void PersistViewModel(RateTable model){

           if (model.RateType == RateType.CustomerSellingRate)
           {
               PersistModelForCustomerSellingRate(model);
           }
           else if (model.RateType == RateType.AirLineBuyingRate)
           {
               PersistModelForAirlineBuyingRate(model);

           }
           else if (model.RateType == RateType.AgentBuyingRate)
           {
               PersistModelForAgentBuyingRate(model);

           }
           else if (model.RateType == RateType.IATARate)
           {
               PersistModelForIATARate(model);

           }
       }
       [NoCache]    
        public ActionResult RateTable(RateTable model)
       {
        
           RateManagementBL bl = new RateManagementBL();
          
            if (!string.IsNullOrEmpty(Request["ActionParam"]))
            {
                if (Convert.ToString(Request["ActionParam"]) == "SaveAll")
                {
                    List<RateRouting> rRList = null;
                    PersistViewModel(model);
                    rRList = bl.GetRateRoutingFromSession((int)model.RateType);
                    bool isValid = true;

                   //모든 타입에 저장시 보아야할 것은 중복된  carrier code 이다.
                    foreach (var r in rRList)
                    {
                        foreach (var rate in r.Rates)
                        {
                            var count = from c in r.Rates where c.CarrierCode == rate.CarrierCode select c;
                            if (count.Count() > 1)
                            {
                                MsgText = "Duplicate Carrier Code exists. Save failed!";
                                isValid = false;
                                break;
                            }
                        }
                        if (!isValid) break;
                    }   
                 


                    if(isValid)
                    {
                        MsgText = "Rate table saved successfully!";
                        try
                        {
                            bl.SaveRateInfo(rRList);
                        }
                        catch (Exception ex)
                        {
                            MsgText = ex.Message;
                        }
                    }
                 
                }
                if (Convert.ToString(Request["ActionParam"]) == "CancelAddRoute")
                {
                    model.ClientAction = "CancelAddRoute";
                }
                if (Convert.ToString(Request["ActionParam"]) == "SaveRoute")
                {  
                   var HeaderRow= model.RateRoutes[0].HeaderRow;
                    SetMissingDropDownTextForRateHeaderRow(HeaderRow);
                    RateRouting routing = new RateRouting();
                    try
                    {
                        GetNewRouteInfoFromView(model, routing);
                        bl.InsertRoute(routing);
                    }
                    catch (Exception ex)
                    {
                        model.ShouldOpenAddRoute = true;
                        MsgText = ex.Message;
                    }
                   
                }
                if (Convert.ToString(Request["ActionParam"]) == "AddRoute")
                {
                   PersistViewModel(model);          
                    int newRateId = bl.GetNewRoutingID();
                    RateRoute RateRoute = new RateRoute(model.RateType) { RouteID = newRateId, Mode = RateRouteMode.Add };
                    model.RateRoutes.Clear();
                    model.RateRoutes.Add(RateRoute);
                    model.ClientAction = "AddRoute";
                    return View(model);
                }
                if (Convert.ToString(Request["ActionParam"]) == "AddCarrier")
                {
                   PersistViewModel(model);    
                    int AddCarrierRouteID = model.AddCarrierRouteID;
                    RateRoute target = (from c in model.RateRoutes where c.RouteID == AddCarrierRouteID select c).Single();
                   var routing= bl.GetRouting(target.RouteID);
                   var emptyRate = GenerateEmptyRateAndCreateHeaderText(routing, target.HeaderRow);
                   routing.Rates.Add(emptyRate);        
                }
                if (Convert.ToString(Request["ActionParam"]) == "DeleteCarrier")
                {
                   PersistViewModel(model);    
                    int DeleteCarrierRouteID = model.DeleteCarrierRouteID;
                    int DeleteCarrierID = model.DeleteCarrierID;
                    RateRoute target_route = (from c in model.RateRoutes where c.RouteID == DeleteCarrierRouteID select c).Single();
                    RateRow target_row = (from c in target_route.Rows where c.Id == DeleteCarrierID select c).Single();
                    var routing = bl.GetRouting(target_route.RouteID);
                    if (routing.Rates.Count == 1)
                    {
                        bl.DeleteRoute(routing);
                    }
                    else
                    {
                        var rate = (from c in routing.Rates where c.RateID == DeleteCarrierID select c).Single();
                        bl.DeleteRate(DeleteCarrierID, DeleteCarrierRouteID);
                    }
                }      
            }
           
            SetVariablesToSession(model);

            if (model.IsInit == "Init")
            {
                model.IsInit = "";
                bl.ClearRateRoutings();
            }
           
            if (model.RateType == RateType.CustomerSellingRate)
            {
                GetCustomerSellingRate(model);              
            }
            if (model.RateType == RateType.AgentBuyingRate)
            {
                GetAgentBuyingRate(model);
            }
            if (model.RateType == RateType.IATARate)
            {
                GetIATARate(model);
            }
            if (model.RateType == RateType.AirLineBuyingRate)
            {
                GetAirlineBuyingRate(model);  
            }

            model.Message = MsgText;

            return View(model);

        }

       private void GetNewRouteInfoFromView(RateTable model, RateRouting routing)
       {
           RateManagementBL bl = new RateManagementBL();
           var  rRList = bl.GetRateRoutingFromSession((int)model.RateType);
         
           RateHeaderRow HeaderRow = model.RateRoutes[0].HeaderRow;
           try
           {

               if (model.RateType == RateType.CustomerSellingRate)
               {

                   //Check if 같은 customer , 같은 destination 그리고 같은 orgin 그리고 같은 Unit 이 있는지 보라.
                  
                   routing.customer_org_account_number = int.Parse(HeaderRow.RateHeaderColumns[0].Value);
                   routing.CustomerOrgName = HeaderRow.RateHeaderColumns[0].Text;
                   routing.Origin = HeaderRow.RateHeaderColumns[1].Value;
                   routing.Dest = HeaderRow.RateHeaderColumns[2].Value;
                   routing.elt_account_number = int.Parse(GetCurrentELTUser().elt_account_number);
                   routing.Unit = HeaderRow.RateHeaderColumns[3].Value;
                   routing.UnitText = HeaderRow.RateHeaderColumns[3].Text;

                   if (routing.Origin == routing.Dest)
                   {
                       throw new Exception("Destination cannot be the same as the Origination!");
                   }

                   var exists = from c in rRList where c.Dest == routing.Dest && c.Origin == routing.Dest && c.Unit == routing.Unit && c.customer_org_account_number == routing.customer_org_account_number select c;
                   if (exists.Count() > 0)
                   {
                       throw new Exception("Same route exists!");
                   }

                   Rate emptyRate = GenerateEmptyRateAndCreateHeaderText(routing, HeaderRow);
                   routing.Rates.Add(emptyRate);
               }
               if (model.RateType == RateType.AgentBuyingRate)
               {

                   //Check if 같은 agent, 같은 destination 그리고 같은 orgin 그리고 같은 Unit 이 있는지 보라.
                   routing.agent_org_account_number = int.Parse(HeaderRow.RateHeaderColumns[0].Value);
                   routing.AgentOrgName = HeaderRow.RateHeaderColumns[0].Text;
                   routing.Origin = HeaderRow.RateHeaderColumns[1].Value;
                   routing.Dest = HeaderRow.RateHeaderColumns[2].Value;
                   routing.elt_account_number = int.Parse(GetCurrentELTUser().elt_account_number);
                   routing.Unit = HeaderRow.RateHeaderColumns[3].Value;
                   routing.UnitText = HeaderRow.RateHeaderColumns[3].Text;
                   var exists = from c in rRList where c.Dest == routing.Dest && c.Origin == routing.Dest && c.Unit == routing.Unit && c.agent_org_account_number == routing.agent_org_account_number select c;
                   if (exists.Count() > 0)
                   {
                       throw new Exception("Same route exists!");
                   }
                   if (routing.Origin == routing.Dest)
                   {
                       throw new Exception("Destination cannot be the same as the Origination!");
                   }
                   Rate emptyRate = GenerateEmptyRateAndCreateHeaderText(routing, HeaderRow);
                   routing.Rates.Add(emptyRate);
               }

               if (model.RateType == RateType.AirLineBuyingRate)
               {
                   //Check if  같은 destination 그리고 같은 orgin 그리고 같은 Unit 이 있는지 보라.

                   routing.Origin = HeaderRow.RateHeaderColumns[0].Value;
                   routing.Dest = HeaderRow.RateHeaderColumns[1].Value;
                   routing.elt_account_number = int.Parse(GetCurrentELTUser().elt_account_number);
                   routing.Unit = HeaderRow.RateHeaderColumns[2].Value;
                   routing.UnitText = HeaderRow.RateHeaderColumns[2].Text;

                   var exists = from c in rRList where c.Dest == routing.Dest && c.Origin == routing.Dest && c.Unit == routing.Unit select c;
                   if (exists.Count() > 0)
                   {
                       throw new Exception("Same route exists!");
                   }
                   if (routing.Origin == routing.Dest)
                   {
                       throw new Exception("Destination cannot be the same as the Origination!");
                   }

                   Rate emptyRate = GenerateEmptyRateAndCreateHeaderText(routing, HeaderRow);
                   routing.Rates.Add(emptyRate);
               }

               if (model.RateType == RateType.IATARate)
               {
                   //Check if  같은 destination 그리고 같은 orgin 그리고 같은 Unit 이 있는지 보라.
                   routing.Origin = HeaderRow.RateHeaderColumns[0].Value;
                   routing.Dest = HeaderRow.RateHeaderColumns[1].Value;
                   routing.elt_account_number = int.Parse(GetCurrentELTUser().elt_account_number);
                   routing.Unit = HeaderRow.RateHeaderColumns[2].Value;
                   routing.UnitText = HeaderRow.RateHeaderColumns[2].Text;

                   var exists = from c in rRList where c.Dest == routing.Dest && c.Origin == routing.Dest && c.Unit == routing.Unit  select c;
                   if (exists.Count() > 0)
                   {
                       throw new Exception("Same route exists!");
                   }
                   if (routing.Origin == routing.Dest)
                   {
                       throw new Exception("Destination cannot be the same as the Origination!");
                   }
                   Rate emptyRate = GenerateEmptyRateAndCreateHeaderText(routing, HeaderRow);
                   routing.Rates.Add(emptyRate);
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
       }

       private static Rate GenerateEmptyRateAndCreateHeaderText(RateRouting routing, RateHeaderRow HeaderRow)
       {
           Rate emptyRate = new Rate();
           emptyRate.CarrierCode = "-1";
           int ratedef_id = 1;
           RateDefinitionColum wb = new RateDefinitionColum();
           int HeaderStartIndex = 0;
           int HeaderRowCount = 0;
           if (HeaderRow.RateType == RateType.CustomerSellingRate)
           {
               HeaderStartIndex = AppConstants.CustomerSellingRateHeaderColumnStartIndex;
               HeaderRowCount = AppConstants.CustomerSellingRateDataColumnCount;
           }
           else if (HeaderRow.RateType == RateType.AirLineBuyingRate)
           {
               HeaderStartIndex = AppConstants.AirLineBuyingRateHeaderColumnStartIndex;
               HeaderRowCount = AppConstants.AirLineBuyingRateDataColumnCount;

           }
           else if (HeaderRow.RateType == RateType.AgentBuyingRate)
           {
               HeaderStartIndex = AppConstants.AgentBuyingRateHeaderColumnStartIndex;
               HeaderRowCount = AppConstants.AgentBuyingRateDataColumnCount;

           }
           else if (HeaderRow.RateType == RateType.IATARate)
           {
               HeaderStartIndex = AppConstants.IATARateHeaderColumnStartIndex;
               HeaderRowCount = AppConstants.CustomerSellingRateDataColumnCount;

           }
           bool ValueExist = false;
           for (int i = HeaderStartIndex; i < HeaderRowCount - 1; i++)
           {
               if (HeaderRow.RateHeaderColumns[i].Value != null && HeaderRow.RateHeaderColumns[i].Value != "")
               {
                   ValueExist = true;
                   emptyRate.RateDefinitionColums.Add(new RateDefinitionColum() { Value = HeaderRow.RateHeaderColumns[i].Value, Rate = "", ID = ratedef_id++ });
               }
           }
           if (!ValueExist)
           {
               throw new Exception("At least one Rate Break shoud exist!");
           }
           RateManagementBL bl = new RateManagementBL();
           bl.GetNextRateID();
           emptyRate.RateID = bl.GetNextRateID();
           emptyRate.RouteID = routing.ID;
           return emptyRate;
       }

       private static void SetMissingDropDownTextForRateHeaderRow(RateHeaderRow HeaderRow)
       {
           foreach (var col in HeaderRow.RateHeaderColumns)
           {
               if (col.IsDropDown == true)
               {
                   if (col.DropDownType == ColumnDropDownType.Unit)
                   {
                       col.Text = col.Value == "K" ? "KG" : "LB";
                   }
                   else if (col.DropDownType == ColumnDropDownType.Port)
                   {
                       col.Text = col.Value;
                   }
                   else if (col.DropDownType == ColumnDropDownType.Carrier)
                   {
                       col.Text = col.Text;
                   }
               }
               else
               {
                   if (col.Value == "" || col.Value == null)
                   {
                       col.Text = "";
                       if (col.IsMin) col.Text = "MIN.($)";
                       if (col.IsProfitShare) col.Text = "Profit Share(%)";

                   }

               }
           }
       }

       private void PersistModelForCustomerSellingRate(RateTable model)
       {
           RateManagementBL bl = new RateManagementBL();
           List<RateRouting> routes = bl.GetRateRoutings(int.Parse(GetCurrentELTUser().elt_account_number), model.CustomerAccount, Convert.ToInt32(RateType.CustomerSellingRate));
           foreach (var view_route in model.RateRoutes)
           {
               RateRouting routing = new RateRouting();
               int count = (from c in routes where c.ID == view_route.RouteID select c).Count();
               if (count > 0)
               {
                   routing = (from c in routes where c.ID == view_route.RouteID select c).Single();
               }
               else
               {
                   routes.Add(routing);
               }
               foreach (var view_row in view_route.Rows)
               {
                   var rate = (from c in routing.Rates where c.RateID == view_row.Id select c).Single();
                   routing.customer_org_account_number = int.Parse(view_route.HeaderRow.RateHeaderColumns[0].Value);
                   routing.CustomerOrgName = view_route.HeaderRow.RateHeaderColumns[0].Text;
                   routing.Origin = view_route.HeaderRow.RateHeaderColumns[1].Text;
                   routing.Dest = view_route.HeaderRow.RateHeaderColumns[2].Text;
                   routing.Unit = view_route.HeaderRow.RateHeaderColumns[3].Value;
                                  
                   for (int i = 0; i < view_row.Columns.Count; i++)
                   {                       
                      
                           if (view_row.Columns[i].WeightBreakValueTag == "CarrierCode")
                           {
                               rate.CarrierCode = view_row.Columns[i].Value;
                           }

                           if (view_row.Columns[i].WeightBreakValueTag == "Share")
                           {
                               rate.Share = view_row.Columns[i].Text;
                           }

                           if (i >= AppConstants.CustomerSellingRateDataColumnStartIndex)
                           {
                               for (int k = 0; k < rate.RateDefinitionColums.Count; k++)
                               {
                                   if (view_row.Columns[i].WeightBreakValueTag == rate.RateDefinitionColums[k].Value)
                                   {
                                       rate.RateDefinitionColums[k].Rate = view_row.Columns[i].Text;
                                   }
                               }
                           }
                     

                   }
               }
           }
         
           
           bl.PesisteRateRouting(routes);
       }
       private void PersistModelForAgentBuyingRate(RateTable model)
       {
           RateManagementBL bl = new RateManagementBL();
           List<RateRouting> routes = bl.GetRateRoutings(int.Parse(GetCurrentELTUser().elt_account_number), model.AgentAccount, Convert.ToInt32(RateType.AgentBuyingRate));
           foreach (var view_route in model.RateRoutes)
           {
               RateRouting routing = new RateRouting();
               int count = (from c in routes where c.ID == view_route.RouteID select c).Count();
               if (count > 0)
               {
                   routing = (from c in routes where c.ID == view_route.RouteID select c).Single();
               }
               else
               {
                   routes.Add(routing);
               }
               foreach (var view_row in view_route.Rows)
               {
                   var rate = (from c in routing.Rates where c.RateID == view_row.Id select c).Single();
                   routing.agent_org_account_number = int.Parse(view_route.HeaderRow.RateHeaderColumns[0].Value);
                   routing.AgentOrgName = view_route.HeaderRow.RateHeaderColumns[0].Text;
                   routing.Origin = view_route.HeaderRow.RateHeaderColumns[1].Text;
                   routing.Dest = view_route.HeaderRow.RateHeaderColumns[2].Text;
                   routing.Unit = view_route.HeaderRow.RateHeaderColumns[3].Value;

                   for (int i = 0; i < view_row.Columns.Count; i++)
                   {

                       if (view_row.Columns[i].WeightBreakValueTag == "CarrierCode")
                       {
                           rate.CarrierCode = view_row.Columns[i].Value;
                       }

                       if (view_row.Columns[i].WeightBreakValueTag == "Share")
                       {
                           rate.Share = view_row.Columns[i].Text;
                       }

                       if (i >= AppConstants.AgentBuyingRateDataColumnStartIndex)
                       {
                           for (int k = 0; k < rate.RateDefinitionColums.Count; k++)
                           {
                               if (view_row.Columns[i].WeightBreakValueTag == rate.RateDefinitionColums[k].Value)
                               {
                                   rate.RateDefinitionColums[k].Rate = view_row.Columns[i].Text;
                               }
                           }
                       }


                   }
               }
           }


           bl.PesisteRateRouting(routes);
       }
       private void PersistModelForAirlineBuyingRate(RateTable model)
       {
           RateManagementBL bl = new RateManagementBL();
           List<RateRouting> routes = bl.GetRateRoutings(int.Parse(GetCurrentELTUser().elt_account_number), model.CustomerAccount, Convert.ToInt32(RateType.CustomerSellingRate));
           foreach (var view_route in model.RateRoutes)
           {
               RateRouting routing = new RateRouting();
               int count = (from c in routes where c.ID == view_route.RouteID select c).Count();
               if (count > 0)
               {
                   routing = (from c in routes where c.ID == view_route.RouteID select c).Single();
               }
               else
               {
                   routes.Add(routing);
               }
               foreach (var view_row in view_route.Rows)
               {
                   var rate = (from c in routing.Rates where c.RateID == view_row.Id select c).Single();
                  
                   routing.Origin = view_route.HeaderRow.RateHeaderColumns[0].Text;
                   routing.Dest = view_route.HeaderRow.RateHeaderColumns[1].Text;
                   routing.Unit = view_route.HeaderRow.RateHeaderColumns[2].Text;

                   for (int i = 0; i < view_row.Columns.Count; i++)
                   {

                       if (view_row.Columns[i].WeightBreakValueTag == "CarrierCode")
                       {
                           rate.CarrierCode = view_row.Columns[i].Value;
                       }

                       if (view_row.Columns[i].WeightBreakValueTag == "Share")
                       {
                           rate.Share = view_row.Columns[i].Text;
                       }

                       if (i >= AppConstants.AirLineBuyingRateDataColumnStartIndex)
                       {
                           for (int k = 0; k < rate.RateDefinitionColums.Count; k++)
                           {
                               if (view_row.Columns[i].WeightBreakValueTag == rate.RateDefinitionColums[k].Value)
                               {
                                   rate.RateDefinitionColums[k].Rate = view_row.Columns[i].Text;
                               }
                           }
                       }


                   }
               }
           }


           bl.PesisteRateRouting(routes);
       }
       private void PersistModelForIATARate(RateTable model)
       {
           RateManagementBL bl = new RateManagementBL();
           List<RateRouting> routes = bl.GetRateRoutings(int.Parse(GetCurrentELTUser().elt_account_number), model.CustomerAccount, Convert.ToInt32(RateType.CustomerSellingRate));
           foreach (var view_route in model.RateRoutes)
           {
               RateRouting routing = new RateRouting();
               int count = (from c in routes where c.ID == view_route.RouteID select c).Count();
               if (count > 0)
               {
                   routing = (from c in routes where c.ID == view_route.RouteID select c).Single();
               }
               else
               {
                   routes.Add(routing);
               }
               foreach (var view_row in view_route.Rows)
               {
                   var rate = (from c in routing.Rates where c.RateID == view_row.Id select c).Single();

                   routing.Origin = view_route.HeaderRow.RateHeaderColumns[0].Text;
                   routing.Dest = view_route.HeaderRow.RateHeaderColumns[1].Text;
                   routing.Unit = view_route.HeaderRow.RateHeaderColumns[2].Text;

                   for (int i = 0; i < view_row.Columns.Count; i++)
                   {

                       if (view_row.Columns[i].WeightBreakValueTag == "CarrierCode")
                       {
                           rate.CarrierCode = view_row.Columns[i].Value;
                       }

                       if (view_row.Columns[i].WeightBreakValueTag == "Share")
                       {
                           rate.Share = view_row.Columns[i].Text;
                       }

                       if (i >= AppConstants.IATARateDataColumnStartIndex)
                       {
                           for (int k = 0; k < rate.RateDefinitionColums.Count; k++)
                           {
                               if (view_row.Columns[i].WeightBreakValueTag == rate.RateDefinitionColums[k].Value)
                               {
                                   rate.RateDefinitionColums[k].Rate = view_row.Columns[i].Text;
                               }
                           }
                       }


                   }
               }
           }


           bl.PesisteRateRouting(routes);
       }
       private void GetCustomerSellingRate(RateTable model)
       {
           model.RateRoutes.Clear();
           RateManagementBL bl = new RateManagementBL();
           List<RateRouting> routes = bl.GetRateRoutings(int.Parse(GetCurrentELTUser().elt_account_number), model.CustomerAccount, Convert.ToInt32(RateType.CustomerSellingRate));

           AddMinCol(routes);

           CodeListBL BL = new CodeListBL();
           var list = BL.GetCarrierList();
           foreach (var route in routes)
           {
               var info = bl.GetRouting(route.ID);
               RateRoute r = new RateRoute(RateType.CustomerSellingRate) { RouteID = route.ID, Mode = RateRouteMode.Edit };
               r.RouteID = route.ID;

               r.HeaderRow.RateType = RateType.CustomerSellingRate;
               int data_start_index = 4;

               r.HeaderRow.RateHeaderColumns[0].Text = info.CustomerOrgName;
               r.HeaderRow.RateHeaderColumns[0].Value = info.customer_org_account_number.ToString();

               r.HeaderRow.RateHeaderColumns[1].Text = info.Origin;
               r.HeaderRow.RateHeaderColumns[2].Text = info.Dest;
               r.HeaderRow.RateHeaderColumns[3].Text = info.UnitText;
               r.HeaderRow.RateHeaderColumns[3].Value = info.Unit;

               bl.RefreshWeightBreakText(info.Rates[0].RateDefinitionColums);
               info.Rates[0].RateDefinitionColums = info.Rates[0].RateDefinitionColums.OrderBy(m => decimal.Parse( m.Value)).ToList();
               for (int i = 0; i < info.Rates[0].RateDefinitionColums.Count; i++)
               {
                   r.HeaderRow.RateHeaderColumns[data_start_index].Value = info.Rates[0].RateDefinitionColums[i].Value;
                   r.HeaderRow.RateHeaderColumns[data_start_index].Text = info.Rates[0].RateDefinitionColums[i].Caption;
                   data_start_index++;
               }

               foreach (var rate in route.Rates)
               {
                   rate.RateDefinitionColums = rate.RateDefinitionColums.OrderBy(m => decimal.Parse(m.Value)).ToList();
                   data_start_index = 3;
                   var data_row = new RateRow(RateType.CustomerSellingRate, AppConstants.CustomerSellingRateDataColumnCount);
                   data_row.RouteId = route.ID;
                   data_row.Id = rate.RateID;

                   data_row.Columns[0].WeightBreakValueTag = "CarrierCode";
                   data_row.Columns[0].Value = rate.CarrierCode;
                   data_row.Columns[0].Text = (from c in list where c.Value == rate.CarrierCode select c.Text).Single();
                   data_row.Columns[0].IsDropDown = true;
                   data_row.Columns[0].DropDownType = ColumnDropDownType.Carrier;
                
                   for (int i = 1; i < 3; i++)
                   {                    
                       data_row.Columns[i].IsDropDown = true;
                       data_row.Columns[i].IsHidden = true;
                   }

                   foreach (var col in rate.RateDefinitionColums)
                   {
                       data_row.Columns[data_start_index].WeightBreakValueTag = col.Value;
                       data_row.Columns[data_start_index].Value = col.Rate;
                       data_row.Columns[data_start_index].Text = col.Rate;
                       data_start_index++;
                   }
                   data_row.Columns[data_row.Columns.Count - 1].Text = rate.Share;
                   data_row.Columns[data_row.Columns.Count - 1].Value = rate.Share;
                   data_row.Columns[data_row.Columns.Count - 1].WeightBreakValueTag = "Share";

                   r.Rows.Add(data_row);
               }
               model.RateRoutes.Add(r);
           }

           foreach (var r in model.RateRoutes)
           {
               foreach (var row in r.Rows)
               {
                   foreach (var col in row.Columns)
                   {
                       if (col.Text == null || col.Text == "")
                       {
                           if (col.Value == null || col.Value == "")
                           col.IsEmptyCell = true;
                       }
                   }
               }
           }
       }
       private void GetAgentBuyingRate(RateTable model)
       {
           model.RateRoutes.Clear();
           RateManagementBL bl = new RateManagementBL();
           List<RateRouting> routes = bl.GetRateRoutings(int.Parse(GetCurrentELTUser().elt_account_number), model.CustomerAccount, Convert.ToInt32(model.RateType));

           AddMinCol(routes);

           CodeListBL BL = new CodeListBL();
           var list = BL.GetCarrierList();
           foreach (var route in routes)
           {
               var info = bl.GetRouting(route.ID);
               RateRoute r = new RateRoute(RateType.AgentBuyingRate) { RouteID = route.ID, Mode = RateRouteMode.Edit };
               r.RouteID = route.ID;
               r.HeaderRow.RateType = RateType.AgentBuyingRate;
               int data_start_index = 4;

               r.HeaderRow.RateHeaderColumns[0].Text = info.AgentOrgName;
               r.HeaderRow.RateHeaderColumns[0].Value = info.agent_org_account_number.ToString();

               r.HeaderRow.RateHeaderColumns[1].Text = info.Origin;
               r.HeaderRow.RateHeaderColumns[2].Text = info.Dest;
               r.HeaderRow.RateHeaderColumns[3].Text = info.UnitText;
               r.HeaderRow.RateHeaderColumns[3].Value = info.Unit;

               bl.RefreshWeightBreakText(info.Rates[0].RateDefinitionColums);
               info.Rates[0].RateDefinitionColums = info.Rates[0].RateDefinitionColums.OrderBy(m => decimal.Parse(m.Value)).ToList();
               for (int i = 0; i < info.Rates[0].RateDefinitionColums.Count; i++)
               {
                   r.HeaderRow.RateHeaderColumns[data_start_index].Value = info.Rates[0].RateDefinitionColums[i].Value;
                   r.HeaderRow.RateHeaderColumns[data_start_index].Text = info.Rates[0].RateDefinitionColums[i].Caption;
                   data_start_index++;
               }

               foreach (var rate in route.Rates)
               {
                   rate.RateDefinitionColums = rate.RateDefinitionColums.OrderBy(m => decimal.Parse(m.Value)).ToList();
                   data_start_index = 3;
                   var data_row = new RateRow(RateType.AgentBuyingRate, AppConstants.AgentBuyingRateDataColumnCount);
                   data_row.RouteId = route.ID;
                   data_row.Id = rate.RateID;

                   data_row.Columns[0].WeightBreakValueTag = "CarrierCode";
                   data_row.Columns[0].Value = rate.CarrierCode;
                   data_row.Columns[0].Text = (from c in list where c.Value == rate.CarrierCode select c.Text).Single();
                   data_row.Columns[0].IsDropDown = true;
                   data_row.Columns[0].DropDownType = ColumnDropDownType.Carrier;

                   for (int i = 1; i < 3; i++)
                   {
                       data_row.Columns[i].IsDropDown = true;
                       data_row.Columns[i].IsHidden = true;
                   }

                   foreach (var col in rate.RateDefinitionColums)
                   {
                       data_row.Columns[data_start_index].WeightBreakValueTag = col.Value;
                       data_row.Columns[data_start_index].Value = col.Rate;
                       data_row.Columns[data_start_index].Text = col.Rate;
                       data_start_index++;
                   }
                   data_row.Columns[data_row.Columns.Count - 1].Text = rate.Share;
                   data_row.Columns[data_row.Columns.Count - 1].Value = rate.Share;
                   data_row.Columns[data_row.Columns.Count - 1].WeightBreakValueTag = "Share";

                   r.Rows.Add(data_row);
               }
               model.RateRoutes.Add(r);
           }

           foreach (var r in model.RateRoutes)
           {
               foreach (var row in r.Rows)
               {
                   foreach (var col in row.Columns)
                   {
                       if (col.Text == null || col.Text == "")
                       {
                           if (col.Value == null || col.Value == "")
                               col.IsEmptyCell = true;
                       }
                   }
               }
           }
       }
       private void GetAirlineBuyingRate(RateTable model)
       {
           model.RateRoutes.Clear();
           RateManagementBL bl = new RateManagementBL();
           List<RateRouting> routes = bl.GetRateRoutings(int.Parse(GetCurrentELTUser().elt_account_number), model.CustomerAccount, Convert.ToInt32(RateType.AirLineBuyingRate));

           AddMinCol(routes);

           CodeListBL BL = new CodeListBL();
           var list = BL.GetCarrierList();
           foreach (var route in routes)
           {
               var info = bl.GetRouting(route.ID);
               RateRoute r = new RateRoute(RateType.AirLineBuyingRate) { RouteID = route.ID, Mode = RateRouteMode.Edit };
               r.RouteID = route.ID;

               r.HeaderRow.RateType = RateType.AirLineBuyingRate;
               int data_start_index = AppConstants.AirLineBuyingRateHeaderColumnStartIndex;

               r.HeaderRow.RateHeaderColumns[0].Text = info.Origin;
               r.HeaderRow.RateHeaderColumns[1].Text = info.Dest;
               r.HeaderRow.RateHeaderColumns[2].Text = info.UnitText;
               r.HeaderRow.RateHeaderColumns[2].Value = info.Unit;

               bl.RefreshWeightBreakText(info.Rates[0].RateDefinitionColums);
               info.Rates[0].RateDefinitionColums = info.Rates[0].RateDefinitionColums.OrderBy(m => decimal.Parse(m.Value)).ToList();
               for (int i = 0; i < info.Rates[0].RateDefinitionColums.Count; i++)
               {
                   r.HeaderRow.RateHeaderColumns[data_start_index].Value = info.Rates[0].RateDefinitionColums[i].Value;
                   r.HeaderRow.RateHeaderColumns[data_start_index].Text = info.Rates[0].RateDefinitionColums[i].Caption;
                   data_start_index++;
               }

               foreach (var rate in route.Rates)
               {
                   rate.RateDefinitionColums = rate.RateDefinitionColums.OrderBy(m => decimal.Parse(m.Value)).ToList();
                   data_start_index = AppConstants.AirLineBuyingRateDataColumnStartIndex;
                  
                   var data_row = new RateRow(RateType.AirLineBuyingRate, AppConstants.AirLineBuyingRateDataColumnCount);
                   data_row.RouteId = route.ID;
                   data_row.Id = rate.RateID;

                   data_row.Columns[0].WeightBreakValueTag = "CarrierCode";
                   data_row.Columns[0].Value = rate.CarrierCode;
                   data_row.Columns[0].Text = (from c in list where c.Value == rate.CarrierCode select c.Text).Single();
                   data_row.Columns[0].IsDropDown = true;
                   data_row.Columns[0].DropDownType = ColumnDropDownType.Carrier;

                   for (int i = 1; i < 2; i++)
                   {
                       data_row.Columns[i].IsDropDown = true;
                       data_row.Columns[i].IsHidden = true;
                   }

                   foreach (var col in rate.RateDefinitionColums)
                   {
                       data_row.Columns[data_start_index].WeightBreakValueTag = col.Value;
                       data_row.Columns[data_start_index].Value = col.Rate;
                       data_row.Columns[data_start_index].Text = col.Rate;
                       data_start_index++;
                   }
                   data_row.Columns[data_row.Columns.Count - 1].Text = rate.Share;
                   data_row.Columns[data_row.Columns.Count - 1].Value = rate.Share;
                   data_row.Columns[data_row.Columns.Count - 1].WeightBreakValueTag = "Share";

                   r.Rows.Add(data_row);
               }
               model.RateRoutes.Add(r);
           }

           foreach (var r in model.RateRoutes)
           {
               foreach (var row in r.Rows)
               {
                   foreach (var col in row.Columns)
                   {
                       if (col.Text == null || col.Text == "")
                       {
                           if (col.Value == null || col.Value == "")
                               col.IsEmptyCell = true;
                       }
                   }
               }
           }
       }
       private void GetIATARate(RateTable model)
       {
           model.RateRoutes.Clear();
           RateManagementBL bl = new RateManagementBL();
           List<RateRouting> routes = bl.GetRateRoutings(int.Parse(GetCurrentELTUser().elt_account_number), model.CustomerAccount, Convert.ToInt32(RateType.IATARate));

           AddMinCol(routes);

           CodeListBL BL = new CodeListBL();
           var list = BL.GetCarrierList();
           foreach (var route in routes)
           {
               var info = bl.GetRouting(route.ID);
               RateRoute r = new RateRoute(RateType.IATARate) { RouteID = route.ID, Mode = RateRouteMode.Edit };
               r.RouteID = route.ID;

               r.HeaderRow.RateType = RateType.IATARate;
               int data_start_index = AppConstants.IATARateHeaderColumnStartIndex;

               r.HeaderRow.RateHeaderColumns[0].Text = info.Origin;
               r.HeaderRow.RateHeaderColumns[1].Text = info.Dest;
               r.HeaderRow.RateHeaderColumns[2].Text = info.UnitText;
               r.HeaderRow.RateHeaderColumns[2].Value = info.Unit;

               bl.RefreshWeightBreakText(info.Rates[0].RateDefinitionColums);
               info.Rates[0].RateDefinitionColums = info.Rates[0].RateDefinitionColums.OrderBy(m => decimal.Parse(m.Value)).ToList();
               for (int i = 0; i < info.Rates[0].RateDefinitionColums.Count; i++)
               {
                   r.HeaderRow.RateHeaderColumns[data_start_index].Value = info.Rates[0].RateDefinitionColums[i].Value;
                   r.HeaderRow.RateHeaderColumns[data_start_index].Text = info.Rates[0].RateDefinitionColums[i].Caption;
                   data_start_index++;
               }

               foreach (var rate in route.Rates)
               {
                   rate.RateDefinitionColums = rate.RateDefinitionColums.OrderBy(m => decimal.Parse(m.Value)).ToList();
                   data_start_index = AppConstants.IATARateDataColumnStartIndex;

                   var data_row = new RateRow(RateType.IATARate, AppConstants.IATARateDataColumnCount);
                   data_row.RouteId = route.ID;
                   data_row.Id = rate.RateID;

                   data_row.Columns[0].WeightBreakValueTag = "CarrierCode";
                   data_row.Columns[0].Value = rate.CarrierCode;
                   data_row.Columns[0].Text = (from c in list where c.Value == rate.CarrierCode select c.Text).Single();
                   data_row.Columns[0].IsDropDown = true;
                   data_row.Columns[0].DropDownType = ColumnDropDownType.Carrier;

                   for (int i = 1; i < 2; i++)
                   {
                       data_row.Columns[i].IsDropDown = true;
                       data_row.Columns[i].IsHidden = true;
                   }

                   foreach (var col in rate.RateDefinitionColums)
                   {
                       data_row.Columns[data_start_index].WeightBreakValueTag = col.Value;
                       data_row.Columns[data_start_index].Value = col.Rate;
                       data_row.Columns[data_start_index].Text = col.Rate;
                       data_start_index++;
                   }
                   data_row.Columns[data_row.Columns.Count - 1].Text = rate.Share;
                   data_row.Columns[data_row.Columns.Count - 1].Value = rate.Share;
                   data_row.Columns[data_row.Columns.Count - 1].WeightBreakValueTag = "Share";

                   r.Rows.Add(data_row);
               }
               model.RateRoutes.Add(r);
           }

           foreach (var r in model.RateRoutes)
           {
               foreach (var row in r.Rows)
               {
                   foreach (var col in row.Columns)
                   {
                       if (col.Text == null || col.Text == "")
                       {
                           if (col.Value == null || col.Value == "")
                               col.IsEmptyCell = true;
                       }
                   }
               }
           }
       }
       private static void AddMinCol(List<RateRouting> routes)
       {
           foreach (var r in routes)
           {
               foreach (var a in r.Rates)
               {
                   var min = from c in a.RateDefinitionColums where float.Parse(c.Value) == 0 select c;
                   if (min.Count() == 0)
                   {
                       var IDs = (from d in a.RateDefinitionColums orderby d.ID descending select d.ID);
                       if (IDs.Count() > 0)
                       {
                           a.RateDefinitionColums.Add(new RateDefinitionColum() { Value = "0", ID = IDs.First() + 1 });
                       }
                   }
               }
           }
       }
        private void SetVariablesToSession(RateTable model)
        {
            Session["rate_customer_org_num"] = model.CustomerAccount;
            Session["rate_rate_type"] = (int)model.RateType;
            Session["rate_elt_account_number"] = int.Parse(GetCurrentELTUser().elt_account_number);

        }

      
    }
}
