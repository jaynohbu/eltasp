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
        private GeneralLedgerReportMasterModel GetGeneralLedgerReportMasterModel()
        {
            GeneralLedgerReportMasterModel GeneralLedgerReportMasterModel = new Models.GeneralLedgerReportMasterModel();
            GeneralLedgerReportMasterModel.PeriodBegin = Session["Accounting_sPeriodBegin"] as string;
            GeneralLedgerReportMasterModel.PeriodEnd = Session["Accounting_sPeriodEnd"] as string;
            GeneralLedgerReportMasterModel.GLFrom = Session["GLFrom"] as string;
            GeneralLedgerReportMasterModel.GLTo = Session["GLTo"] as string;
            GeneralLedgerReportMasterModel.TranType = Session["Accounting_sTranType"] as string;                 
            GetGeneralLedgerTransactionalData(GeneralLedgerReportMasterModel);

            return GeneralLedgerReportMasterModel;
        }
        private void GetGeneralLedgerTransactionalData(GeneralLedgerReportMasterModel MasterModel)
        {
            GlBL BL = new GlBL();
            List<GeneralLedgerReportItem> list = new List<GeneralLedgerReportItem>();
            MasterModel.GeneralLedgerItems = list;
            DataSet ds = BL.PerformSearch();
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                if (Convert.ToString(ds.Tables[0].Rows[i]["GL_Number"]).GetType() != Type.GetType("System.DBNull"))
                {
                    GeneralLedgerReportItem item = new GeneralLedgerReportItem();
                    item.elt_account_number = Convert.ToString(ds.Tables[0].Rows[i]["elt_account_number"]);

                    item.GL_Name = Convert.ToString(ds.Tables[0].Rows[i]["GL_Name"]);
                    item.GL_Number = Convert.ToString(ds.Tables[0].Rows[i]["GL_Number"]);
                    item.Start_Balance = ds.Tables[0].Rows[i]["Start Balance"].GetType() == Type.GetType("System.DBNull") ? "" : decimal.Parse(Convert.ToString(ds.Tables[0].Rows[i]["Start Balance"])).ToString("#.##");

                    item.Debit = ds.Tables[0].Rows[i]["Debit"].GetType() == Type.GetType("System.DBNull") ? "" : decimal.Parse(Convert.ToString(ds.Tables[0].Rows[i]["Debit"])).ToString("#.##");
                    item.Credit = ds.Tables[0].Rows[i]["Credit"].GetType() == Type.GetType("System.DBNull") ? "" : decimal.Parse(Convert.ToString(ds.Tables[0].Rows[i]["Credit"])).ToString("#.##");

                    for (int k = 0; k < ds.Tables[1].Rows.Count; k++)
                    {

                        if (ds.Tables[0].Rows[i]["GL_Number"].GetType() != Type.GetType("System.DBNull"))

                        // if (Convert.ToString(ds.Tables[1].Rows[k]["Customer_Name"]) == Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]))
                        {
                            GeneralLedgerTransactionalItem trans = new GeneralLedgerTransactionalItem();
                            trans.elt_account_number = Convert.ToString(ds.Tables[1].Rows[k]["elt_account_number"]);
                            trans.GL_Number = Convert.ToString(ds.Tables[1].Rows[k]["GL_Number"]);
                            trans.GL_Name = Convert.ToString(ds.Tables[1].Rows[k]["GL_Name"]);
                            trans.Company_Name = Convert.ToString(ds.Tables[1].Rows[k]["Company_Name"]);
                            trans.Date = Convert.ToString(ds.Tables[1].Rows[k]["Date"]);
                            trans.Debit = ds.Tables[1].Rows[k]["Debit"].GetType() == Type.GetType("System.DBNull") ? "" : decimal.Parse(Convert.ToString(ds.Tables[1].Rows[k]["Debit"])).ToString("#.##");
                            trans.Credit = ds.Tables[1].Rows[k]["Credit"].GetType() == Type.GetType("System.DBNull") ? "" : decimal.Parse(Convert.ToString(ds.Tables[1].Rows[k]["Credit"])).ToString("#.##");

                            trans.Memo = Convert.ToString(ds.Tables[1].Rows[k]["Memo"]);
                            trans.Num = Convert.ToString(ds.Tables[1].Rows[k]["Num"]);
                            trans.Type = Convert.ToString(ds.Tables[1].Rows[k]["Type"]);
                            trans.Split = Convert.ToString(ds.Tables[1].Rows[k]["Split"]);
                            trans.Link = Convert.ToString(ds.Tables[1].Rows[k]["Link"]);
                            item.TransactionItems.Add(trans);
                        }
                        //if (Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) == "Total")
                        //{
                        //    MasterModel.Total = Convert.ToString(ds.Tables[1].Rows[k]["Amount"]);
                        //} if (Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) == "Cumulative Total")
                        //{
                        //    MasterModel.Cumulative_Total = Convert.ToString(ds.Tables[1].Rows[k]["Amount"]);
                        //}
                    }
                    // if (item.Amount != "")
                    {
                        // if (double.Parse(item.Amount) != 0)
                        list.Add(item);
                    }

                }
            }


        }
        [CheckSession]
        public ActionResult GeneralLedger(string param)
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
                return RedirectToAction("ExportTo", new { Operation = "GeneralLedger", typeName = TypeName });
            }

            if (param == "dataready")
            {
                return View(GetGeneralLedgerReportMasterModel());
            }
            else
            {
                return View("AccountingReportSelectionClassic");
            }



        }
        public ActionResult _GeneralLedgerMasterPartial()
        {
            SetSubMenu(MainMenuContext.Accounting_Report);
            return PartialView("_GeneralLedger/_GeneralLedgerMasterPartial", GetGeneralLedgerReportMasterModel().GeneralLedgerItems);
        }
        public ActionResult _GeneralLedgerDetailPartial(string glNumber)
        {
            SetSubMenu(MainMenuContext.Accounting_Report);
            ViewData["GLNumber"] = glNumber;
            var data = (from c in GetGeneralLedgerReportMasterModel().GeneralLedgerItems where c.GL_Number == glNumber select c).Single().TransactionItems;
            return PartialView("_GeneralLedger/_GeneralLedgerDetailPartial", data);
        }

        public static GridViewSettings CreateGeneralLedgerGridViewSettings()
        {
            GridViewSettings settings = new GridViewSettings();
            settings.Name = "All";

            settings.Columns.Add("Date");
            settings.Columns.Add("Type");
            settings.Columns.Add("Num", "Tran(Check)#.");         

            settings.Columns.Add("Company_Name", "Company");
            settings.Columns.Add("Memo");
            settings.Columns.Add("Split");
            settings.Columns.Add("Debit");
            settings.Columns.Add("Credit");

          
          

            return settings;
        }

    }
}
