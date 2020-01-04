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
    [Authorize]
    public partial class AccountingController : OperationBaseController
    {
        [CheckSession]
        public ActionResult TrialBalance(string param)
        {
            CheckAccess();
            //http://e-logitech.net/IFF_MAIN/ASPX/Reports/Accounting/GLSelection.aspx?parm=trial
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
                return RedirectToAction("ExportTo", new { Operation = "TrialBalance", typeName = TypeName });
            }
            if (Request["PeriodEnd"] == null || Request["ReSelect"] != null)
            {
                Session["TrialBalanceMasterReportData"] = null;
                ViewBag.IsSelected = false;
            }
            else
            {
                TrialBalanceSelection ReportSelection = new TrialBalanceSelection(ELT_account_number);
                CultureInfo ci = new CultureInfo("en-US");
                ReportSelection.PeriodEnd = Convert.ToDateTime(Request["PeriodEnd"], ci);
                ReportSelection.Branch = Convert.ToString(Request["Branch"]);

                Session["TrialBalanceReportSelection"] = ReportSelection;
                ViewBag.IsSelected = true;

                return View("TrialBalance", GetTrialBalanceTransactionalData());
            }
            return View();
        }
        private List<TrialBalanceItem> GetTrialBalanceTransactionalData()
        {
            TrialBalanceSelection selection = (TrialBalanceSelection)Session["TrialBalanceReportSelection"];
            ViewBag.AsOf = selection.PeriodEnd.ToShortDateString();
            ViewBag.Branch = selection.Branch;

            foreach (var item in selection.BranchList)
            {
                if (item.Value == selection.Branch)
                    ViewBag.Branch = item.Text;

            }
            ELT.BL.ReportingBL ReportBL = new ELT.BL.ReportingBL();
            if (Session["TrialBalanceMasterReportData"] == null)
            {
                var user = GetCurrentELTUser();
                string ELT_account_number = user.elt_account_number;
                if (ELT_account_number == null)
                    Response.Redirect("~/Account/Login", true);
                Session["TrialBalanceMasterReportData"]
                    = ReportBL.GetTrialBalanceItem(ELT_account_number, selection);
            }

            var model = (List<TrialBalanceItem>)Session["TrialBalanceMasterReportData"];
            var returnvalue = from m in model select m;
            return model;
        }
        public ActionResult TrialBalancePartial()
        {
            return PartialView("_/Trial_Balance/_TrialBalance", GetTrialBalanceTransactionalData());
        }
        public static GridViewSettings CreateTrialBalanceGridViewSettings()
        {
            GridViewSettings settings = new GridViewSettings();
            settings.Name = "All";
            var date = settings.Columns.Add("GlAccountNumber");
            date.SortOrder = DevExpress.Data.ColumnSortOrder.Ascending;
            date.Width = 80;

            var glacc = settings.Columns.Add("GLAccountName");
            glacc.Width = 390;

            settings.Columns.Add(c =>
            {
                c.FieldName = "Debit";
                c.UnboundType = DevExpress.Data.UnboundColumnType.Decimal;
                c.Width = 110;
                c.CellStyle.CssClass = "numeric";
            });
            settings.Columns.Add(c =>
            {
                c.FieldName = "Credit";
                c.UnboundType = DevExpress.Data.UnboundColumnType.Decimal;
                c.Width = 110;
                c.CellStyle.CssClass = "numeric";
            });
            settings.Columns.Add(c =>
            {
                c.FieldName = "Balance ";
                c.UnboundType = DevExpress.Data.UnboundColumnType.Decimal;
                c.Width = 110;
                c.CellStyle.CssClass = "numeric";
            });

            decimal total = 0;
            settings.CustomUnboundColumnData = (sender, e) =>
            {
                decimal amount = Convert.ToDecimal(e.GetListSourceFieldValue("Balance"));
                decimal cre = Convert.ToDecimal(e.GetListSourceFieldValue("CreditAmt"));
                decimal deb = Convert.ToDecimal(e.GetListSourceFieldValue("DebitAmt"));
                if (e.Column.FieldName == "Debit")
                {
                    e.Value = deb;
                }
                if (e.Column.FieldName == "Credit")
                {
                    e.Value = cre;
                }
                if (e.Column.FieldName == "Balance ")
                {
                    // total = amount + total;
                    e.Value = amount;
                }
            };
            settings.Settings.ShowFooter = true;
            var creSum = settings.TotalSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Credit");
            creSum.DisplayFormat = "f";
            creSum.ShowInColumn = "Credit";
            var debSum = settings.TotalSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Debit");
            debSum.DisplayFormat = "f";
            debSum.ShowInColumn = "Debit";
            var balSum = settings.TotalSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Balance");
            balSum.DisplayFormat = "f";
            balSum.ShowInColumn = "Balance ";
            return settings;
        }

    }
}
