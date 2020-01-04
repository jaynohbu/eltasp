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
        public ActionResult ARDetail(string param)
        {
            CheckAccess();
            SetSubMenu(MainMenuContext.Accounting_AccountReceivable);
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
                return RedirectToAction("ExportTo", new { Operation = "ARDetail", typeName = TypeName });
            }

            if (param == "dataready")
            {
                return View(GetARDetailMasterModel());
            }
            else
            {
                return View("AccountingReportSelectionClassic");
            }

        }
        private ARDetailMasterModel GetARDetailMasterModel()
        {
            string KeyFieldName = "Customer_Name";
            ARDetailMasterModel model = new ARDetailMasterModel() { KeyFieldName = KeyFieldName };
            model.CompanyName = Session["Accounting_sCompanName"] == null ? "" : Session["Accounting_sCompanName"] as string;
            model.PeriodBegin = Session["Accounting_sPeriodBegin"] as string;
            model.PeriodEnd = Session["Accounting_sPeriodEnd"] as string;
            var data = GetARDetailTransactionalData();
            model.Elements = data;
            return model;
        }
        private List<ARDetailItem> GetARDetailTransactionalData()
        {
            GlBL BL = new GlBL();
            List<ARDetailItem> list = new List<ARDetailItem>();
            DataSet ds = BL.PerformSearch();
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                ARDetailItem item = new ARDetailItem();
                item.elt_account_number = Convert.ToString(ds.Tables[0].Rows[i]["elt_account_number"]);
                item.Amount = Convert.ToString(ds.Tables[0].Rows[i]["Amount"]);
                item.Balance = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["Balance"]).ToString("#0.00"));
                item.Customer_Name = Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]);
                item.Invoiced = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["Invoiced"]).ToString("#0.00"));
                item.Received = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["Received"]).ToString("#0.00"));
             

                item.Start = Convert.ToString(ds.Tables[0].Rows[i]["Start"].GetType() == Type.GetType("System.DBNull") ? "0.00" : Convert.ToDecimal(ds.Tables[0].Rows[i]["Start"]).ToString("#0.00"));
                            
                
                item.To_do = Convert.ToString(ds.Tables[0].Rows[i]["To_do"]);
                for (int k = 0; k < ds.Tables[1].Rows.Count; k++)
                {
                    if (ds.Tables[0].Rows[i]["Customer_Name"].GetType() != Type.GetType("System.DBNull") && Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Total" && Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Cumulative Total")
                        if (Convert.ToString(ds.Tables[1].Rows[k]["Customer_Name"]) == Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]))
                        {
                            ARDetailTransactionItem trans = new ARDetailTransactionItem();
                            trans.elt_account_number = Convert.ToString(ds.Tables[1].Rows[k]["elt_account_number"]);
                            trans.Amount = Convert.ToString(ds.Tables[1].Rows[k]["Amount"]);
                            trans.Balance = Convert.ToString(Convert.ToDecimal(ds.Tables[1].Rows[k]["Balance"]).ToString("#0.00"));
                            trans.Customer_Name = Convert.ToString(ds.Tables[1].Rows[k]["Customer_Name"]);
                            trans.Invoiced = Convert.ToString(Convert.ToDecimal(ds.Tables[1].Rows[k]["Invoiced"]).ToString("#0.00"));
                            trans.Received = Convert.ToString(Convert.ToDecimal(ds.Tables[1].Rows[k]["Received"]).ToString("#0.00"));
                         
                            trans.Start = Convert.ToString(ds.Tables[1].Rows[k]["Start"].GetType() == Type.GetType("System.DBNull") ? "0.00" : Convert.ToDecimal(ds.Tables[1].Rows[k]["Start"]).ToString("#0.00"));
                            
                            trans.Link = Convert.ToString(ds.Tables[1].Rows[k]["Link"]);
                            trans.File_No = Convert.ToString(ds.Tables[1].Rows[k]["File No."]);
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
            Session["GetARDetailTransactionalData"] = list;
            return list;
        }
        public ActionResult ARDetailDetail(string KeyFieldName, string Key)
        {
            SetSubMenu(MainMenuContext.Accounting_AccountReceivable);
            var data = GetARDetailTransactionalData();
            ARDetailDetailModel model = new ARDetailDetailModel();
            model.Key = Key;
            model.KeyFieldName = KeyFieldName;
            model.Elements = (from c in data where Convert.ToString(ELT.COMMON.Util.GetPropValue(c, KeyFieldName)) == Key select c).Single().TransactionItems;
            //model.Settings = CreateARDetailGridViewSettings();
            return PartialView("_ARDetail/_ARDetailDetail", model);
        }
        public ActionResult ARDetailMaster()
        {
            ARDetailMasterModel model = GetARDetailMasterModel();
            return PartialView("_ARDetail/_ARDetailMaster", model);
        }
        static GridViewSettings CreateARDetailGridViewSettings()
        {
            GridViewSettings settings = new GridViewSettings();
            settings.Name = "AR Detail";
            settings.Columns.Add("Customer_Name", "Customer");   
            settings.Columns.Add("Type");
            settings.Columns.Add("Date");
            settings.Columns.Add("Num", "No.");
            settings.Columns.Add("Start", "Start Balance");
            settings.Columns.Add("Invoiced");
            settings.Columns.Add("Received");
            settings.Columns.Add("Balance");
            return settings;
        }
    }
}
