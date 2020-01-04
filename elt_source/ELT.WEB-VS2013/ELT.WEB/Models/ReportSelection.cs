using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using  ELT.COMMON;
using ELT.CDT;
using System.Web.Mvc;
namespace ELT.WEB.Models
{
    [Serializable]
    public class ReportSelection:ReportSearchItem
    {
        public override string MAWB
        {
            get;
            set;
        }

        public override string HAWB
        {
            get;
            set;
        } 

        public override string CategorizeBy
        {
            get;
            set;
        }
        public override DateTime PeriodEnd
        {
            get;
            set;
        }
        public override string WeightScale
        {
            get;
            set;
        }
        public override DateTime PeriodBegin
        {
            get;
            set;
        }
        public override string AnalysisOn
        {
            get;
            set;
        }
        public List<SelectListItem> AnalysisList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                //"chkGW","chkCW","chkQT","chkFC"
                items.Add(new SelectListItem { Text = "Gross Weight", Value = "GrossWeight" });
                items.Add(new SelectListItem { Text = "Chargeable Weight", Value = "ChargeableWeight" });
                items.Add(new SelectListItem { Text = " Quantity", Value = "Quantity" });
                items.Add(new SelectListItem { Text = "Freight Charge", Value = "FreightCharge" });
                items.Add(new SelectListItem { Text = " Frequency", Value = "Frequency" });
                return items;
            }
        }
        public List<SelectListItem> CategoryList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();

                items.Add(new SelectListItem { Text = "Agent", Value = "Agent" });
                items.Add(new SelectListItem { Text = "Shipper", Value = "Shipper" });
                items.Add(new SelectListItem { Text = "Consignee", Value = "Consignee" });
                items.Add(new SelectListItem { Text = "Carrier", Value = "Carrier" });
                items.Add(new SelectListItem { Text = "Port of Departure", Value = "Origin" });
                items.Add(new SelectListItem { Text = "Port of Arrival", Value = "Destination" });
                items.Add(new SelectListItem { Text = "Sales Persons", Value = "Sale_Rep" });
                return items;
            }
        }
        public List<SelectListItem> PeriodList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();

                items.Add(new SelectListItem { Text = "Today", Value = "0", Selected = true });
                items.Add(new SelectListItem { Text = "Month to Date", Value = "1" });
                items.Add(new SelectListItem { Text = "Quarter to Date", Value = "2" });
                items.Add(new SelectListItem { Text = "Year to Date", Value = "3" });
                items.Add(new SelectListItem { Text = "This Month", Value = "4" });
                items.Add(new SelectListItem { Text = "This Quearter", Value = "5" });
                items.Add(new SelectListItem { Text = "This Year", Value = "6" });
            
                return items;
            }
        }
        public List<SelectListItem> WeightScaleList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "LB", Value = "LB", Selected = true });
                items.Add(new SelectListItem { Text = "KG", Value = "KG" });
             
                return items;
            }
        }
    }


    [Serializable]
    public class PNLSelection : ReportSearchItem
    {
        public override string MAWB
        {
            get;
            set;
        }
        public  string AirOcean
        {
            get;
            set;
        }
        public string ImportExport
        {
            get;
            set;
        } 
        public List<SelectListItem> AirOceanList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "All  ", Value = "All", Selected = true });
                items.Add(new SelectListItem { Text = "Air  ", Value = "A", Selected = true });
                items.Add(new SelectListItem { Text = "Ocean  ", Value = "O" });
                
                return items;
            }
        }
        public List<SelectListItem> ImportExportList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "All  ", Value = "All", Selected = true });
                items.Add(new SelectListItem { Text = "Export   ", Value = "E", Selected = true });
                items.Add(new SelectListItem { Text = "Import   ", Value = "I" });

                return items;
            }
        }
           
      
        public override DateTime PeriodEnd
        {
            get;
            set;
        }
       
        public override DateTime PeriodBegin
        {
            get;
            set;
        }      
        public List<SelectListItem> PeriodList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();

                items.Add(new SelectListItem { Text = "Today", Value = "0", Selected = true });
                items.Add(new SelectListItem { Text = "Month to Date", Value = "1" });
                items.Add(new SelectListItem { Text = "Quarter to Date", Value = "2" });
                items.Add(new SelectListItem { Text = "Year to Date", Value = "3" });
                items.Add(new SelectListItem { Text = "This Month", Value = "4" });
                items.Add(new SelectListItem { Text = "This Quearter", Value = "5" });
                items.Add(new SelectListItem { Text = "This Year", Value = "6" });

                return items;
            }
        }


     
    }
}