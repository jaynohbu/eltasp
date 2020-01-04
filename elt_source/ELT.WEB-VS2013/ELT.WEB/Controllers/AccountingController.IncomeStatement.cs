using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.Mvc;
using ELT.CDT;
using ELT.WEB.Models;
using DevExpress.Web.Mvc;
using ELT.WEB.Filters; 
namespace ELT.WEB.Controllers
{
    public partial class AccountingController : OperationBaseController
    {
       
        [Authorize]
        [CheckSession]
        public ActionResult IncomeStatement(string param)
        {
            CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASPX/Reports/Accounting/GLSelection.aspx?parm=incom
            SetSubMenu(MainMenuContext.Accounting_Financial);
            if (param != null)
                param = "?" + param;
            ViewBag.Params = param;
            var user = GetCurrentELTUser();
            string ELT_account_number = user.elt_account_number;
            if (ELT_account_number == null)
                Response.Redirect("~/Account/Login", true);
            ViewBag.EltAccountNumber = ELT_account_number;

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
                return RedirectToAction("ExportTo", new { Operation = "IncomeStatement", typeName = TypeName });
            }

            if (Request["PeriodEnd"] == null || Request["ReSelect"] != null)
            {
                Session["IncomeStatementReportData"] = null;
                ViewBag.IsSelected = false;
            }
            else
            {
                IncomeStatementSelection ReportSelection = new IncomeStatementSelection(ELT_account_number);
                CultureInfo ci = new CultureInfo("en-US");
                ReportSelection.PeriodBegin = Convert.ToDateTime(Request["PeriodBegin"], ci);
                ReportSelection.PeriodEnd = Convert.ToDateTime(Request["PeriodEnd"], ci);
                ReportSelection.Branch = Convert.ToString(Request["Branch"]);
                Session["IncomeStatementReportSelection"] = ReportSelection;
                ViewBag.IsSelected = true;

                return View("IncomeStatement", GetIncomeStatementTransactionalData());
            }
            return View();
        }
        private List<IncomeStatementItem> GetIncomeStatementTransactionalData()
        {
            IncomeStatementSelection selection = (IncomeStatementSelection)Session["IncomeStatementReportSelection"];
            ViewBag.PeriodBegin = selection.PeriodBegin.ToShortDateString();
            ViewBag.PeriodEnd = selection.PeriodEnd.ToShortDateString();
            foreach (var item in selection.BranchList)
            {
                if (item.Value == selection.Branch)
                    ViewBag.Branch = item.Text;

            }
            ELT.BL.ReportingBL ReportBL = new ELT.BL.ReportingBL();
            if (Session["IncomeStatementReportData"] == null)
            {
                var user = GetCurrentELTUser();
                string ELT_account_number = user.elt_account_number;
                if (ELT_account_number == null)
                    Response.Redirect("~/Account/Login", true);
                Session["IncomeStatementReportData"]
                    = ReportBL.GetIncomeStatementItem(ELT_account_number, selection);
            }

            var model = (List<IncomeStatementItem>)Session["IncomeStatementReportData"];         
            return model;
        }
        public ActionResult IncomeStatementPartial()
        {
            ViewBag.GroupedColumns = "Category;SubCategory";
            var returnvalue = (List<IncomeStatementItem>)Session["IncomeStatementReportData"];
            return PartialView("_IncomeStatement/_IncomeStatementPartial", returnvalue);
        }
       
        public static GridViewSettings IncomeStatementGridViewSettings()
        {
            GridViewSettings settings = new GridViewSettings();
            settings.Name = "All";
            var cat = settings.Columns.Add("Category", " ");
            cat.GroupIndex = 0;
            cat.SortOrder = DevExpress.Data.ColumnSortOrder.Descending;
            var subcat = settings.Columns.Add("SubCategory", "  ");
            subcat.GroupIndex = 1;
            subcat.SortOrder = DevExpress.Data.ColumnSortOrder.Descending;
            settings.Columns.Add("GlAccountNumber").Width = 100; ;
            settings.Columns.Add("GLAccountName");
            settings.Columns.Add(c =>
            {
                c.FieldName = "Amount ";
                c.UnboundType = DevExpress.Data.UnboundColumnType.Decimal;
                c.Width = 120;
                c.CellStyle.CssClass = "numeric";
                c.PropertiesEdit.DisplayFormatString = "c";
            });
            settings.CustomUnboundColumnData = (sender, e) =>
            {
                decimal amount = Convert.ToDecimal(e.GetListSourceFieldValue("Amount"));

                if (e.Column.FieldName == "Amount ")
                {
                    e.Value = amount;
                }
            };
            settings.Settings.ShowFooter = true;
            settings.Settings.ShowGroupPanel = true;
            settings.GroupSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Amount ").DisplayFormat = "c";
            var balSum = settings.TotalSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Amount");
            balSum.DisplayFormat = "NET INCOME : {0:c2}";
            balSum.ShowInColumn = "Amount ";
            return settings;
        }
    }
}
