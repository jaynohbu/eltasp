using DevExpress.Web.Mvc;
using ELT.BL;
using ELT.CDT;
using ELT.WEB.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Mvc;
using System.Web.UI;
using ELT.WEB.Filters;  
namespace ELT.WEB.Controllers
{
    [Authorize]
    public partial class AccountingController : OperationBaseController
    {
        [CheckSession]
        public ActionResult APDispute(string param)
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
                return RedirectToAction("ExportTo", new { Operation = "APDispute", typeName = TypeName });
            }

            if (param == "dataready")
            {

                return View(GetAPDisputeMasterModel());
            }
            else
            {
                return View("AccountingReportSelectionAPDisputeClassic");
            } 
        }

        private APDisputeMasterModel GetAPDisputeMasterModel()
        {
            APDisputeMasterModel APDisputeMasterModel = new Models.APDisputeMasterModel();
            APDisputeMasterModel.KeyFieldName = "Customer_Number";
            APDisputeMasterModel.PeriodBegin = Session["Accounting_sPeriodBegin"] as string;
            APDisputeMasterModel.PeriodEnd = Session["Accounting_sPeriodEnd"] as string;
            APDisputeMasterModel.VendorName = Session["Accounting_sCompanName"] == null ? "" : Session["Accounting_sCompanName"] as string;
            APDisputeMasterModel.Elements = GetAPDisputeTransactionalData();
            return APDisputeMasterModel;
        }
        private List<APDisputeItem> GetAPDisputeTransactionalData()
        {

            GlBL BL = new GlBL();          
            DataSet ds = BL.PerformSearch();
            List<APDisputeItem> List = new List<APDisputeItem>();
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                APDisputeItem item = new APDisputeItem();            

                item.Company_Name = Convert.ToString(ds.Tables[0].Rows[i]["dba_name"]);
                item.Phone = Convert.ToString(ds.Tables[0].Rows[i]["Phone"]);
                item.Class = Convert.ToString(ds.Tables[0].Rows[i]["class_code"]);
               
                item.Customer_Number = Convert.ToString(ds.Tables[0].Rows[i]["org_account_number"]);
                item.Balance = Convert.ToString(ds.Tables[0].Rows[i]["Balance"].GetType() == Type.GetType("System.DBNull") ? "0.00" : Convert.ToDecimal(ds.Tables[0].Rows[i]["Balance"]).ToString("#0.00"));
                item.Bill_Amount = Convert.ToString(ds.Tables[0].Rows[i]["Bill Amount"].GetType() == Type.GetType("System.DBNull") ? "0.00" : Convert.ToDecimal(ds.Tables[0].Rows[i]["Bill Amount"]).ToString("#0.00"));
                item.Paid_Amount = Convert.ToString(ds.Tables[0].Rows[i]["Paid Amount"].GetType() == Type.GetType("System.DBNull") ? "0.00" : Convert.ToDecimal(ds.Tables[0].Rows[i]["Paid Amount"]).ToString("#0.00"));
                item.Dispute_Amount = Convert.ToString(ds.Tables[0].Rows[i]["Dispute Amount"].GetType() == Type.GetType("System.DBNull") ? "0.00" : Convert.ToDecimal(ds.Tables[0].Rows[i]["Dispute Amount"]).ToString("#0.00"));            
           

                for (int k = 0; k < ds.Tables[1].Rows.Count; k++)
                {
                    if (ds.Tables[0].Rows[i]["Customer_Name"].GetType() != Type.GetType("System.DBNull") && Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Total" && Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Cumulative Total")
                        if (Convert.ToString(ds.Tables[1].Rows[k]["Customer_Name"]) == Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]))
                        {
                            List<APDisputeTransactionItem> list = new List<APDisputeTransactionItem>();
                            APDisputeTransactionItem trans =new APDisputeTransactionItem();
                            trans.Customer_Number = Convert.ToString(ds.Tables[1].Rows[k]["vendor_number"]);
                            trans.Date = Convert.ToString(ds.Tables[1].Rows[k]["bill_date"]);                           
                            trans.FileNo = Convert.ToString(ds.Tables[1].Rows[k]["file_no"]);
                            trans.Memo = Convert.ToString(ds.Tables[1].Rows[k]["Memo"]);                          
                            trans.Payment_Method = Convert.ToString(ds.Tables[1].Rows[k]["pmt_method"]);

                            trans.Dispute_Amount = Convert.ToString(ds.Tables[1].Rows[k]["amt_dispute"].GetType() == Type.GetType("System.DBNull") ? "0.00" : Convert.ToDecimal(ds.Tables[1].Rows[k]["amt_dispute"]).ToString("#0.00"));
                            trans.Due_Amount = Convert.ToString(ds.Tables[1].Rows[k]["amt_due"].GetType() == Type.GetType("System.DBNull") ? "0.00" : Convert.ToDecimal(ds.Tables[1].Rows[k]["amt_due"]).ToString("#0.00"));
                            trans.Paid_Amount = Convert.ToString(ds.Tables[1].Rows[k]["amt_paid"].GetType() == Type.GetType("System.DBNull") ? "0.00" : Convert.ToDecimal(ds.Tables[1].Rows[k]["amt_paid"]).ToString("#0.00"));

                            trans.Company_Name = item.Company_Name;
                            trans.Phone = item.Phone;

                            item.TransactionItems.Add(trans);
                        }
                }


                List.Add(item);
            }
            Session["GetAPDisputeTransactionalData"] = List;

            return List;
        }

        public ActionResult APDisputeDetail(string KeyFieldName, string Key)
        {
            SetSubMenu(MainMenuContext.Accounting_AccountReceivable);
            List<APDisputeItem> data = GetAPDisputeTransactionalData();
            APDisputeDetailModel model = new APDisputeDetailModel();
            model.Key = Key;
            model.KeyFieldName = KeyFieldName;
            model.Elements = (from c in data where Convert.ToString(ELT.COMMON.Util.GetPropValue(c, KeyFieldName)) == Key select c).Single().TransactionItems;
            //model.Settings = CreateAPDisputeGridViewSettings();
            return PartialView("_APDispute/_APDisputeDetail", model);
        }
        public ActionResult APDisputeMaster()
        {
            APDisputeMasterModel model = GetAPDisputeMasterModel();
            return PartialView("_APDispute/_APDisputeMaster", model);
        }

        public static GridViewSettings CreateAPDisputeGridViewSettings()
        {
            GridViewSettings settings = new GridViewSettings();
            settings.Name = "AP Dispute";
    
            settings.Columns.Add("Date");
            settings.Columns.Add("FileNo", "File No.");
            settings.Columns.Add("Payment_Method", "Payment Method");
            settings.Columns.Add("Due_Amount", "Due");
            settings.Columns.Add("Paid_Amount", "Paid");
            settings.Columns.Add("Dispute_Amount", "Dispute");
           

            return settings;
        }



    }
}
