using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Mvc;
using DevExpress.Web.Mvc;
using ELT.BL;
using ELT.CDT;
using ELT.WEB.Models;
using ELT.WEB.Filters; 
namespace ELT.WEB.Controllers
{
    [Authorize]
    public partial class AccountingController : OperationBaseController
    {
        [CheckSession]
        public ActionResult APDetail(string param)
        {
            CheckAccess();
            SetSubMenu(MainMenuContext.Accounting_AccountPayable);
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
                return RedirectToAction("ExportTo", new { Operation = "APDetail", typeName = TypeName });
            }
            if (param == "dataready")
            {
                return View(GetAPDetailMasterModel());
            }
            else
            {
                return View("AccountingReportSelectionClassic");
            }

        }
        private APDetailMasterModel GetAPDetailMasterModel()
        {

            string KeyFieldName = "Customer_Name";
            APDetailMasterModel model = new APDetailMasterModel() { KeyFieldName = KeyFieldName };
            var data = GetAPDetailTransactionalData();

            model.CompanyName = Session["Accounting_sCompanName"] == null ? "" : Session["Accounting_sCompanName"] as string;
            model.PeriodBegin = Session["Accounting_sPeriodBegin"] as string;
            model.PeriodEnd = Session["Accounting_sPeriodEnd"] as string;

            model.Elements = data;
            return model;
        }
        private List<APDetailItem> GetAPDetailTransactionalData()
        {
            GlBL BL = new GlBL();
            List<APDetailItem> list = new List<APDetailItem>();
            DataSet ds = BL.PerformSearch();
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                if (Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Posted Transactions")
                {
                    APDetailItem item = new APDetailItem();
                    item.elt_account_number = Convert.ToString(ds.Tables[0].Rows[i]["elt_account_number"]);
                    item.Amount = Convert.ToString(ds.Tables[0].Rows[i]["Amount"]);
                    item.Balance = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["Balance"]).ToString("#0.00"));
                    item.Customer_Name = Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]);
                    item.Billed = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["Billed"]).ToString("#0.00"));
                    item.Paid = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["Paid"]).ToString("#0.00"));

                    item.Start = Convert.ToString(ds.Tables[0].Rows[i]["Start"].GetType() == Type.GetType("System.DBNull") ? "0.00" : Convert.ToDecimal(ds.Tables[0].Rows[i]["Start"]).ToString("#0.00"));
                            
                

                    for (int k = 0; k < ds.Tables[1].Rows.Count; k++)
                    {
                        if (ds.Tables[0].Rows[i]["Customer_Name"].GetType() != Type.GetType("System.DBNull") && Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Total" && Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Cumulative Total")
                            if (Convert.ToString(ds.Tables[1].Rows[k]["Customer_Name"]) == Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]))
                            {
                                APDetailTransactionItem trans = new APDetailTransactionItem();
                                trans.elt_account_number = Convert.ToString(ds.Tables[1].Rows[k]["elt_account_number"]);
                                trans.Amount = Convert.ToString(ds.Tables[1].Rows[k]["Amount"]);
                                trans.Balance = Convert.ToString(Convert.ToDecimal(ds.Tables[1].Rows[k]["Balance"]).ToString("#0.00"));
                                trans.Customer_Name = Convert.ToString(ds.Tables[1].Rows[k]["Customer_Name"]);
                                trans.Billed = Convert.ToString(Convert.ToDecimal(ds.Tables[1].Rows[k]["Billed"]).ToString("#0.00"));
                                trans.Paid = Convert.ToString(Convert.ToDecimal(ds.Tables[1].Rows[k]["Paid"]).ToString("#0.00"));
                                trans.Start = Convert.ToString(ds.Tables[1].Rows[k]["Start"].GetType() == Type.GetType("System.DBNull") ? "0.00" : Convert.ToDecimal(ds.Tables[1].Rows[k]["Start"]).ToString("#0.00"));
                                trans.Link = Convert.ToString(ds.Tables[1].Rows[k]["Link"]);
                                trans.IsPosted = Convert.ToString(ds.Tables[1].Rows[k]["s"]);
                                trans.Date = Convert.ToString(ds.Tables[1].Rows[k]["Date"]);
                                trans.Memo = Convert.ToString(ds.Tables[1].Rows[k]["Memo"]);
                                trans.Num = Convert.ToString(ds.Tables[1].Rows[k]["Num"]);
                                trans.Type = Convert.ToString(ds.Tables[1].Rows[k]["Type"]);
                                trans.Customer_Number = Convert.ToString(ds.Tables[1].Rows[k]["Customer_Number"]);
                                item.TransactionItems.Add(trans);
                            }
                    }
                    list.Add(item);
                }
            }
            Session["GetAPDetailTransactionalData"] = list;
            return list;
        }
        public ActionResult APDetailDetail(string KeyFieldName, string Key)
        {
            SetSubMenu(MainMenuContext.Accounting_AccountPayable);
            var data = GetAPDetailTransactionalData();
            APDetailDetailModel model = new APDetailDetailModel();
            model.Key = Key;
            model.KeyFieldName = KeyFieldName;
            model.Elements = (from c in data where Convert.ToString(ELT.COMMON.Util.GetPropValue(c, KeyFieldName)) == Key select c).Single().TransactionItems;
            //model.Settings = CreateAPDetailGridViewSettings();
            return PartialView("_APDetail/_APDetailDetail", model);
        }
        public ActionResult APDetailMaster()
        {
            APDetailMasterModel model = GetAPDetailMasterModel();
            return PartialView("_APDetail/_APDetailMaster", model);
        }
        static GridViewSettings CreateAPDetailGridViewSettings()
        {
            GridViewSettings settings = new GridViewSettings();
            settings.Name = "AP Detail";
            settings.Columns.Add("Customer_Name", "Customer");   
            settings.Columns.Add("Type");
            settings.Columns.Add("Date");
            settings.Columns.Add("Num", "No.");
            settings.Columns.Add("Start", "Start Balance");
            settings.Columns.Add("Billed");
            settings.Columns.Add("Paid");
            settings.Columns.Add("Balance");
            return settings;
        }     
       
    }
}
