using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Mvc;
using ELT.BL;
using ELT.CDT;
using ELT.WEB.Models;
using DevExpress.Web.Mvc;
using System.Web.UI;
using ELT.WEB.Filters;  
namespace ELT.WEB.Controllers
{
    [Authorize]
    public partial class AccountingController : OperationBaseController
    {
        [CheckSession]
        public ActionResult Sales(string param)
        {
            CheckAccess();
            SetSubMenu(MainMenuContext.Accounting_Report);
            if (param != null)
                ViewBag.Params = "?" + param;

            bool forwardToPrint = false;
            string TypeName = "";
            foreach (string typeName in GridViewExportHelper.ExportTypes.Keys)
            {
                if (Request.Params[typeName] != null)
                {
                    TypeName = typeName;
                    forwardToPrint = true;
                }
            }
            if (forwardToPrint)
            {
                return RedirectToAction("ExportTo", new { Operation = "Sales", typeName = TypeName });
            }

            if (param == "dataready")
            {
                return View(GetSalesReportMasterModel());
            }
            else
            {
                return View("AccountingReportSelectionClassic");
            }

        }
        public ActionResult _SalesMasterPartial()
        {
            SetSubMenu(MainMenuContext.Accounting_Report);
            return PartialView("_Sales/_SalesMasterPartial", GetSalesReportMasterModel().SalesItems);
        }
        public ActionResult _SalesDetailPartial(string customerNumber)
        {
            SetSubMenu(MainMenuContext.Accounting_Report);
            ViewData["CustomerNumber"] = customerNumber;
            var data = GetSalesReportMasterModel();
            var model = (from c in data.SalesItems where c.customer_number == customerNumber select c).Single().TransactionItems;
            return PartialView("_Sales/_SalesDetailPartial", model);
        }
        private SalesReportMasterModel GetSalesReportMasterModel()
        {
            SalesReportMasterModel SalesReportMasterModel = new Models.SalesReportMasterModel();
            GetSalesDetailTransactionalData(SalesReportMasterModel);
            SalesReportMasterModel.CompanyName = Session["Accounting_sCompanName"] == null ? "" : Session["Accounting_sCompanName"] as string;
            SalesReportMasterModel.PeriodBegin = Session["Accounting_sPeriodBegin"] as string;
            SalesReportMasterModel.PeriodEnd = Session["Accounting_sPeriodEnd"] as string;
            return SalesReportMasterModel;
        }

        private void GetSalesDetailTransactionalData(SalesReportMasterModel MasterModel)
        {
            GlBL BL = new GlBL();
            List<SalesItem> list = new List<SalesItem>();
            MasterModel.SalesItems = list;
            DataSet ds = BL.PerformSearch();
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                if (Convert.ToString(ds.Tables[0].Rows[i]["Customer_Number"]).GetType() != Type.GetType("System.DBNull"))
                {
                   
                    {
                        SalesItem item = new SalesItem();
                        item.Amount = Convert.ToString(ds.Tables[0].Rows[i]["Amount"]) == "" ? 0 : Convert.ToDouble(ds.Tables[0].Rows[i]["Amount"]);
                        item.Balance = Convert.ToString(ds.Tables[0].Rows[i]["Balance"]);
                        item.customer_name = Convert.ToString(ds.Tables[0].Rows[i]["customer_name"]);
                        item.customer_number = Convert.ToString(ds.Tables[0].Rows[i]["customer_number"]);

                        for (int k = 0; k < ds.Tables[1].Rows.Count; k++)
                        {

                            if (ds.Tables[0].Rows[i]["Customer_Name"].GetType() != Type.GetType("System.DBNull") && Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Total" && Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Cumulative Total")

                                if (Convert.ToString(ds.Tables[1].Rows[k]["Customer_Name"]) == Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]))
                                {

                                    SalesTransactionalItem trans = new SalesTransactionalItem();
                                    trans.elt_account_number = Convert.ToString(ds.Tables[1].Rows[k]["elt_account_number"]);
                                    trans.Amount = Convert.ToString(ds.Tables[1].Rows[k]["Amount"]) == "" ? 0 : Convert.ToDouble(ds.Tables[1].Rows[k]["Amount"]);

                                    trans.Balance = Convert.ToString(ds.Tables[1].Rows[k]["Balance"]);
                                    trans.Customer_Name = Convert.ToString(ds.Tables[1].Rows[k]["Customer_Name"]);
                                    trans.Customer_Number = Convert.ToString(ds.Tables[1].Rows[k]["Customer_Number"]);
                                    trans.air_ocean = Convert.ToString(ds.Tables[1].Rows[k]["air_ocean"]);
                                    trans.Date = Convert.ToString(ds.Tables[1].Rows[k]["Date"]);
                                    trans.Link = Convert.ToString(ds.Tables[1].Rows[k]["Link"]);
                                    trans.Num = Convert.ToString(ds.Tables[1].Rows[k]["Num"]);
                                    trans.Type = Convert.ToString(ds.Tables[1].Rows[k]["Type"]);
                                    item.TransactionItems.Add(trans);
                                }
                            if (Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) == "Total")
                            {
                                MasterModel.Total = Convert.ToString(ds.Tables[1].Rows[k]["Amount"]);
                            } if (Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) == "Cumulative Total")
                            {
                                MasterModel.Cumulative_Total = Convert.ToString(ds.Tables[1].Rows[k]["Amount"]);
                            }
                        }
                        if (item.Amount != 0)
                        {

                            list.Add(item);
                        }

                    }
                }
            }


        }

        public static GridViewSettings SalesGridViewSettings()
        {
            GridViewSettings settings = new GridViewSettings();
            settings.Name = "All";

          
            settings.SettingsPager.PageSize = 200;
            settings.KeyFieldName = "Num";
            settings.Columns.Add("Date");
            settings.Columns.Add("Type");
            settings.Columns.Add("Num","No.");
            settings.Columns.Add("Amount");





           
              
              

            return settings;
        }
       
    }
}
