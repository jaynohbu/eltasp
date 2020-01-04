using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Mvc;
using ELT.BL;
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
        public ActionResult BalanceSheet(string param)
        {
            CheckAccess();
            SetSubMenu(MainMenuContext.Accounting_Financial);
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
                return RedirectToAction("ExportTo", new { Operation = "BalanceSheet", typeName = TypeName });
            }

            if (param == "dataready")
            {
                BalanceSheetMasterModel model = new BalanceSheetMasterModel();
                var data = GetBalanceSheetTransactionalData();
                model.AsOf = Session["Accounting_sPeriodBegin"] as string;
                model.Asset = (from c in data where c.Type == "ASSET" select c).ToList();
                model.LiabilityEquity = (from c in data where c.Type == "LIABILITY" || c.Type == "EQUITY" select c).ToList();
                Session["BalanceSheetReportData"] = model;
                return View(model);
            }
            else
            {
                return View("AccountingReportSelectionClassic");
            }

        }
        private List<BalanceSheetItem> GetBalanceSheetTransactionalData()
        {
            GlBL BL = new GlBL();
            List<BalanceSheetItem> list = new List<BalanceSheetItem>();
            DataSet ds = BL.PerformSearch();
            for (int i = 0; i < ds.Tables["Detail"].Rows.Count; i++)
            {

                {
                    BalanceSheetItem item = new BalanceSheetItem();
                    item.Amount = Convert.ToString(ds.Tables["Detail"].Rows[i]["Amount"]);
                    item.GLAccountName = Convert.ToString(ds.Tables["Detail"].Rows[i]["gl_name"]);
                    item.GlAccountNumber = Convert.ToString(ds.Tables["Detail"].Rows[i]["gl_number"]);
                    item.Type = Convert.ToString(ds.Tables["Detail"].Rows[i]["Type"]);
                    item.Category = Convert.ToString(ds.Tables["Detail"].Rows[i]["gl_account_type"]);
                    list.Add(item);
                }
            }
            Session["GetBalanceSheetTransactionalData"] = list;
            return list;

        }

        GridViewSettings CreateBalanceSheetGridViewSettings()
        {
            //BalanceSheetItem item = new BalanceSheetItem();
            //item.Amount = Convert.ToString(ds.Tables["Detail"].Rows[i]["Amount"]);
            //item.GLAccountName = Convert.ToString(ds.Tables["Detail"].Rows[i]["gl_name"]);
            //item.GlAccountNumber = Convert.ToString(ds.Tables["Detail"].Rows[i]["gl_number"]);
            //item.Type = Convert.ToString(ds.Tables["Detail"].Rows[i]["Type"]);
            //item.Category = Convert.ToString(ds.Tables["Detail"].Rows[i]["gl_account_type"]);
            //list.Add(item);

            GridViewSettings settings = new GridViewSettings();
            settings.Name = "All";
            var cat = settings.Columns.Add("Type", "Type");
            cat.GroupIndex = 0;
            cat.SortOrder = DevExpress.Data.ColumnSortOrder.Descending;           
            var subcat = settings.Columns.Add("Category", "Category");
            subcat.GroupIndex = 1;
            subcat.SortOrder = DevExpress.Data.ColumnSortOrder.Descending;
            settings.Columns.Add("GlAccountNumber", "Account Number");
            var subsubcat = settings.Columns.Add("GLAccountName", "Account Name");
            subsubcat.GroupIndex = 2;
            subsubcat.SortOrder = DevExpress.Data.ColumnSortOrder.Descending;


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


            //settings.GroupSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Amount ").DisplayFormat = "c";

            //var balSum = settings.TotalSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Amount");

            //balSum.DisplayFormat = "NET INCOME : {0:c2}";
            //balSum.ShowInColumn = "Amount ";
            return settings;
        }

    }
}
