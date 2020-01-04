using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ELT.CDT;
using System.Web.Mvc;
using ELT.BL;
using ELT.COMMON;
namespace ELT.WEB.Models
{
    public class RateManagerMaster
    {
        public string SessionId { get; set; }
        public string UIState { get; set; }
        public RateType Type { get; set; }
        public int CustomerID { get; set; }
        public RateTable RateTable  { get; set; }   
        public string ShouldSave { get; set; }
        public bool RedirectedFromClientProfile { get; set; }
        public List<SelectListItem> GetRateTypes()
        {
            var RateTypes = new List<SelectListItem>();
            RateTypes.Add(new SelectListItem() { Text = "Customer Selling Rate", Value = "4" });
            RateTypes.Add(new SelectListItem() { Text = "Airline Buying Rate", Value = "3" });
            RateTypes.Add(new SelectListItem() { Text = "Agent Buying Rate", Value = "1" });
            RateTypes.Add(new SelectListItem() { Text = "IATA Rate", Value = "5" });            
            return RateTypes;
        }

    }
    public class RateRoute
    {
        public int RouteID { get; set; }
        private RateRouteMode _mode;
        public RateRouteMode Mode {
            get { return _mode; }
            set {
                _mode = value;
                if (value == RateRouteMode.Add) 
                { 
                    HeaderRow.Mode = RateHeaderRowMode.Add; 
                } else { 
                    HeaderRow.Mode = RateHeaderRowMode.Edit;
                }
            }
        }
        public RateType RateType { get; set; }
        public RateHeaderRow HeaderRow { get; set; }
        public List<RateRow> Rows { get; set; }
        public RateRoute()
        {
           
        }
        public RateRoute(RateType RateType)
        {
            this.RateType = RateType;
            Rows = new List<RateRow>();
            HeaderRow = new RateHeaderRow(RateType);                  
            Mode = RateRouteMode.Edit;
        }
    }
    public class RateHeaderRow 
    {
        public RateHeaderRow()
        {

        }
        public RateType RateType { get; set; }
        private RateHeaderRowMode _mode;
        public RateHeaderRowMode Mode
        {

            get { return _mode; }
            set
            {
                _mode = value;
                if (_mode == RateHeaderRowMode.Add)
                {

                    foreach (var item in this.RateHeaderColumns)
                    {
                        item.RateHeaderColumnMode = RateHeaderColumnMode.Add;
                    }

                }
                else
                {

                    foreach (var item in this.RateHeaderColumns)
                    {
                        item.RateHeaderColumnMode = RateHeaderColumnMode.Edit;
                    }
                }

            }


        }
        public List<RateHeaderColumn> RateHeaderColumns { get; set; }
        public RateHeaderRow(RateType RateType)
        {
            this.RateType = RateType;
            int ColumCount = 0;
            RateHeaderColumns = new List<RateHeaderColumn>();
            CodeListBL CodeListBL = new CodeListBL();
            if (RateType == CDT.RateType.CustomerSellingRate)
            {
               ColumCount= AppConstants.CustomerSellingRateHeaderColumCount;
            }
            if (RateType == CDT.RateType.AirLineBuyingRate)
            {
                ColumCount = AppConstants.AirLineBuyingRateHeaderColumCount;
            }
            if (RateType == CDT.RateType.AgentBuyingRate)
            {
                ColumCount = AppConstants.AgentBuyingRateHeaderColumCount;
            }
            if (RateType == CDT.RateType.IATARate)
            {
                ColumCount = AppConstants.IATARateHeaderColumnCount;
            }
          
            for (int i = 0; i < ColumCount; i++)
            {
                var col = new RateHeaderColumn(RateType) { Id = i + 1 };
                if (RateType == CDT.RateType.CustomerSellingRate)
                {
                    CreateCustomerSellingRateHeaderColums(RateType, ColumCount, CodeListBL, i, col);
                }
                if (RateType == CDT.RateType.AirLineBuyingRate)
                {
                    CreateAirlineBuyingRateHeaderColums(RateType, ColumCount, CodeListBL, i, col);
                }
                if (RateType == CDT.RateType.AgentBuyingRate)
                {
                    CreateAgentBuyingRateHeaderColums(RateType, ColumCount, CodeListBL, i, col);
                }
                if (RateType == CDT.RateType.IATARate)
                {
                    CreateIATARateHeaderColums(RateType, ColumCount, CodeListBL, i, col);
                }
            }

        }
        private void CreateIATARateHeaderColums(RateType RateType, int ColumCount, CodeListBL CodeListBL, int i, RateHeaderColumn col)
        {
            col.Text = "";
            col.Value = "";

            if (i == 2)
            {
                col.IsDropDown = true;
                col.DropDownType = ColumnDropDownType.Unit;
                col.DropDownItems.Add(new SelectListItem() { Text = "LB", Value = "L" });
                col.DropDownItems.Add(new SelectListItem() { Text = "KG", Value = "K" });
            }

            if (i == 0 || i == 1)
            {
                col.IsDropDown = true;
                col.DropDownType = ColumnDropDownType.Port;
                var list = CodeListBL.GetPortList();
                foreach (var item in list)
                {
                    col.DropDownItems.Add(new SelectListItem() { Text = item.Text, Value = item.Value });
                }
            }
            if (i == 3)
            {

                col.IsMin = true;
            }
            if (i == ColumCount - 1)
            {

                col.IsProfitShare = true;
            }
            col.RateType = RateType;
            RateHeaderColumns.Add(col);
        }
       
        private void CreateAgentBuyingRateHeaderColums(RateType RateType, int ColumCount, CodeListBL CodeListBL, int i, RateHeaderColumn col)
        {
            col.Text = "";
            col.Value = "";
            if (i == 0)
            {
                col.IsDropDown = true;
                col.DropDownType = ColumnDropDownType.Agent;
            }
            if (i == 3)
            {
                col.IsDropDown = true;
                col.DropDownType = ColumnDropDownType.Unit;
                col.DropDownItems.Add(new SelectListItem() { Text = "LB", Value = "L" });
                col.DropDownItems.Add(new SelectListItem() { Text = "KG", Value = "K" });
            }

            if (i == 1 || i == 2)
            {
                col.IsDropDown = true;
                col.DropDownType = ColumnDropDownType.Port;
                var list = CodeListBL.GetPortList();
                foreach (var item in list)
                {
                    col.DropDownItems.Add(new SelectListItem() { Text = item.Text, Value = item.Value });
                }
            }
            if (i == 4)
            {

                col.IsMin = true;
            }
            if (i == ColumCount - 1)
            {

                col.IsProfitShare = true;
            }
            col.RateType = RateType;
            RateHeaderColumns.Add(col);
        }
    
        private void CreateAirlineBuyingRateHeaderColums(RateType RateType, int ColumCount, CodeListBL CodeListBL, int i, RateHeaderColumn col)
        {
            col.Text = "";
            col.Value = "";
           
            if (i == 2)
            {
                col.IsDropDown = true;
                col.DropDownType = ColumnDropDownType.Unit;
                col.DropDownItems.Add(new SelectListItem() { Text = "LB", Value = "L" });
                col.DropDownItems.Add(new SelectListItem() { Text = "KG", Value = "K" });
            }

            if (i == 0|| i == 1)
            {
                col.IsDropDown = true;
                col.DropDownType = ColumnDropDownType.Port;
                var list = CodeListBL.GetPortList();
                foreach (var item in list)
                {
                    col.DropDownItems.Add(new SelectListItem() { Text = item.Text, Value = item.Value });
                }
            }
            if (i == 3)
            {

                col.IsMin = true;
            }
            if (i == ColumCount - 1)
            {

                col.IsProfitShare = true;
            }
            col.RateType = RateType;
            RateHeaderColumns.Add(col);
        }
       
        private void CreateCustomerSellingRateHeaderColums(RateType RateType, int ColumCount, CodeListBL CodeListBL, int i, RateHeaderColumn col)
        {
            col.Text = "";
            col.Value = "";
            if (i == 0)
            {
                col.IsDropDown = true;
                col.DropDownType = ColumnDropDownType.Customer;
            }
            if (i == 3)
            {
                col.IsDropDown = true;
                col.DropDownType = ColumnDropDownType.Unit;
                col.DropDownItems.Add(new SelectListItem() { Text = "LB", Value = "L" });
                col.DropDownItems.Add(new SelectListItem() { Text = "KG", Value = "K" });
            }

            if (i == 1 || i == 2)
            {
                col.IsDropDown = true;
                col.DropDownType = ColumnDropDownType.Port;
                var list = CodeListBL.GetPortList();
                foreach (var item in list)
                {
                    col.DropDownItems.Add(new SelectListItem() { Text = item.Text, Value = item.Value });
                }
            }
            if (i == 4)
            {

                col.IsMin = true;
            }
            if (i == ColumCount - 1)
            {

                col.IsProfitShare = true;
            }
            col.RateType = RateType;
            RateHeaderColumns.Add(col);
        }
    
    }
    public class RateHeaderColumn
    {
        public bool IsMin
        {
            get;
            set;
        }
        public bool IsProfitShare
        {
            get;
            set;
        }
        public RateHeaderColumnMode RateHeaderColumnMode
        {
            get;
            set;
        }
        public RateHeaderColumn()
        {
            DropDownItems = new List<SelectListItem>();
        }
        public RateHeaderColumn(RateType RateType)
        {
            DropDownItems = new List<SelectListItem>();
        }

        public bool IsVisible { get; set; }
        public bool IsDropDown { get; set; }
        public int Id { get; set; }
        public string Text { get; set; }
        public string Value { get; set; }
        public RateType RateType { get; set; }
        public ColumnDropDownType DropDownType { get; set; }
        public List<SelectListItem> DropDownItems { get; set; }
        
    }
    public class RateRow
    {
    
        public int Id { get; set; }
        public int RouteId { get; set; }    
        public RateType RateType { get; set; }
        public List<RateColumn> Columns { get; set; }
        public RateRow()
        {
            Columns = new List<RateColumn>();
        }
        
        public RateRow(RateType RateType, int ColumCount)
        {
            this.RateType = RateType;
            Columns = new List<RateColumn>();
          
            CodeListBL CodeListBL=new CodeListBL();
            for (int i = 0; i < ColumCount; i++)
            {
                var col = new RateColumn(RateType) { Id = i + 1 };

                if (i == 0)
                {
                    col.IsDropDown = true;
                    col.DropDownType = ColumnDropDownType.Carrier;
                    var list = CodeListBL.GetCarrierList();
                    foreach (var item in list)
                    {
                        col.DropDownItems.Add(new SelectListItem() { Text = item.Text, Value = item.Value });
                    }
                }

                if (i == 1 || i == 2)
                {
                    col.IsDropDown = true;
                    col.DropDownType = ColumnDropDownType.Port;
                    var list = CodeListBL.GetPortList();
                    foreach (var item in list)
                    {
                        col.DropDownItems.Add(new SelectListItem() { Text = item.Text, Value = item.Value });
                    }
                }
                if (i == 3)
                {
                    col.IsDropDown = true;
                }
               
              
                Columns.Add(col);
            }
        }
    }
    public class RateColumn
    {
        public RateColumn()
        {
            DropDownItems = new List<SelectListItem>();
        }
        public RateColumn(RateType RateType)
        {
            this.RateType = RateType;
            DropDownItems = new List<SelectListItem>();
        }
        public bool IsEmptyCell { get; set; }
        public bool IsHidden{ get; set; }
        public bool IsDropDown { get; set; }
        public int Id { get; set; }
        public string WeightBreakValueTag { get; set; }
        public string Text { get; set; }
        public string Value { get; set; }
        public RateType RateType { get; set; }
        public ColumnDropDownType DropDownType { get; set; }
        public List<SelectListItem> DropDownItems { get; set; }
        
    }
    public enum RateRouteMode
    {
        Add=1,
        Edit=2
    }
    public enum RateHeaderRowMode
    {
        Add = 1,
        Edit = 2
    }
    public enum RateHeaderColumnMode
    {
        Add = 1,
        Edit = 2
    }
    public class CustomerSellingRateTable : RateTable
    {
        public CustomerSellingRateTable()
        {
        }
        public override RateType RateType { get { return RateType.CustomerSellingRate; } }
        public int CustomerID { get; set; } 
    }
    public class AirlineBuyingRateTable : RateTable
    {
        public AirlineBuyingRateTable()
        {
        }
        public override RateType RateType { get { return RateType.AirLineBuyingRate; } }
        public int AirlineID { get; set; }
    }
    public class AgentBuyingRateTable : RateTable
    {
        public AgentBuyingRateTable()
        {
        }
        public override RateType RateType { get { return RateType.AgentBuyingRate; } }
        public int AgentID { get; set; }
    }
    public class IataRateTable : RateTable
    {
        public IataRateTable()
        {
        }
        public override RateType RateType { get { return RateType.IATARate; } }
        public int AirlineID { get; set; }
    }
    public enum ColumnDropDownType
    {
        Port,
        Carrier,
        Customer,
        Agent,
        Unit
    }
    public class RateTable
    {
        public RateTable()
        {
            RateRoutes = new List<RateRoute>();
        }
        public int CustomerAccount { get; set; }
        public int AgentAccount { get; set; }

        public List<RateRoute> RateRoutes { get; set; }
        public virtual RateType RateType { get; set; }
        public string ShouldAdd { get; set; }
        public int AddCarrierRouteID { get; set; }
        public int DeleteCarrierRouteID { get; set; }
        public int DeleteCarrierID { get; set; }
        public string ShouldSave { get; set; }
        public string IsInit { get; set; }
        public string ClientAction { get; set; }
        public string Message { get; set; }
        public bool ShouldOpenAddRoute { get; set; }
    }

}

