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
using System.Web.UI.WebControls;
using ELT.WEB.Filters; 
namespace ELT.WEB.Controllers
{
    [Authorize]
    public partial class AccountingController : OperationBaseController
    {
       [CheckSession]
        public ActionResult Expenses(string param)
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
                return RedirectToAction("ExportTo", new { Operation = "Expenses", typeName = TypeName });
            }

            if (param == "dataready")
            {
                return View(GetExpenseReportMasterModel());
            }
            else
            {
                return View("AccountingReportSelectionClassic");
            } 
        }
        public ActionResult _ExpensesMasterPartial()
        {
            SetSubMenu(MainMenuContext.Accounting_Report);
            return PartialView("_Expenses/_ExpensesMasterPartial", GetExpenseReportMasterModel().ExpenseItems);
        }
        public ActionResult _ExpensesDetailPartial(string customer_number)
        {
            SetSubMenu(MainMenuContext.Accounting_Report);
            ViewData["customer_number"] = customer_number;
            var data = (from c in GetExpenseReportMasterModel().ExpenseItems where c.customer_number == customer_number select c).Single().TransactionItems;

            return PartialView("_Expenses/_ExpensesDetailPartial", data);
        }
        private ExpenseReportMasterModel GetExpenseReportMasterModel()
        {
            ExpenseReportMasterModel ExpenseReportMasterModel = new Models.ExpenseReportMasterModel();
            GetExpenseDetailTransactionalData(ExpenseReportMasterModel);

          
            ExpenseReportMasterModel.PeriodBegin = Session["Accounting_sPeriodBegin"] as string;
            ExpenseReportMasterModel.PeriodEnd = Session["Accounting_sPeriodEnd"] as string;


            return ExpenseReportMasterModel;
        }
        private void GetExpenseDetailTransactionalData(ExpenseReportMasterModel MasterModel)
        {
            GlBL BL = new GlBL();
            List<ExpenseItem> list = new List<ExpenseItem>();
            MasterModel.ExpenseItems = list;
            DataSet ds = BL.PerformSearch();
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                if (Convert.ToString(ds.Tables[0].Rows[i]["Customer_Number"]).GetType() != Type.GetType("System.DBNull"))
                {
                    ExpenseItem item = new ExpenseItem();
                    item.Amount = Convert.ToString(ds.Tables[0].Rows[i]["Amount"]);
                    item.Balance = Convert.ToString(ds.Tables[0].Rows[i]["Balance"]);
                    item.customer_name = Convert.ToString(ds.Tables[0].Rows[i]["customer_name"]);
                    item.customer_number = Convert.ToString(ds.Tables[0].Rows[i]["customer_number"]);

                    for (int k = 0; k < ds.Tables[1].Rows.Count; k++)
                    {

                        if (ds.Tables[0].Rows[i]["Customer_Name"].GetType() != Type.GetType("System.DBNull") && Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Total" && Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Cumulative Total")

                            if (Convert.ToString(ds.Tables[1].Rows[k]["Customer_Name"]) == Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]))
                            {
                                ExpenseTransactionalItem trans = new ExpenseTransactionalItem();
                                trans.elt_account_number = Convert.ToString(ds.Tables[1].Rows[k]["elt_account_number"]);
                                trans.Amount = Convert.ToString(ds.Tables[1].Rows[k]["Amount"]);
                                trans.Balance = Convert.ToString(ds.Tables[1].Rows[k]["Balance"]);
                                trans.Customer_Name = Convert.ToString(ds.Tables[1].Rows[k]["Customer_Name"]);
                                trans.Customer_Number = Convert.ToString(ds.Tables[1].Rows[k]["Customer_Number"]);

                                trans.Date = Convert.ToString(ds.Tables[1].Rows[k]["Date"]);
                                trans.Link = Convert.ToString(ds.Tables[1].Rows[k]["Link"]);
                                trans.Num = Convert.ToString(ds.Tables[1].Rows[k]["Num"]);
                                trans.Memo = Convert.ToString(ds.Tables[1].Rows[k]["Memo"]);
                                trans.Split = Convert.ToString(ds.Tables[1].Rows[k]["Split"]);
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
                    if (item.Amount != "")
                    {
                        if (double.Parse(item.Amount) != 0)
                            list.Add(item);
                    }
                }
            }

        }             
        public static GridViewSettings CreateExpensesGridViewSettings()
        {
            GridViewSettings settings = new GridViewSettings();
            settings.Name = "All";       
            settings.Width = Unit.Percentage(100);
            settings.SettingsPager.PageSize = 200;
            settings.KeyFieldName = "Num";
            settings.Columns.Add("Date");
            settings.Columns.Add("Type");
            settings.Columns.Add(c =>
            {
                c.Caption = "No.";
                c.FieldName = "Num";       
            });

            settings.Columns.Add("Memo");
            settings.Columns.Add("Account");
            settings.Columns.Add("Split");
            settings.Columns.Add("Amount");          

            return settings;
        }

    }
}
