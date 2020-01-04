using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Web.Mvc;
using DevExpress.Web.Mvc;
using ELT.BL;
using ELT.CDT;
using ELT.WEB.Filters;
namespace ELT.WEB.Controllers
{
    [Authorize]
    public partial class AccountingController : OperationBaseController
    {
        [CheckSession]       
        public ActionResult BankRegister(string param)
        {
            CheckAccess();
            SetSubMenu(MainMenuContext.Accounting_Bank);
            if (param != null)              
            ViewBag.Params  = "?" + param;

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
                return RedirectToAction("ExportTo",  new { Operation = "BankRegister", typeName = TypeName });
            }

            if (param == "dataready")
            {

                PrepViewBag();
                
                return View(GetBankRegisterTransactionalData());
            }
            else
            {
                return View("AccountingReportSelectionClassic");
            }
         
        }

        private void PrepViewBag()
        {
            ViewBag.PaymentMethod = Session["PaymentMethod"] as string;
            ViewBag.PeriodBegin = Session["Accounting_sPeriodBegin"] as string;
            ViewBag.PeriodEnd = Session["Accounting_sPeriodEnd"] as string;
            ViewBag.BankAccount = Session["BankAccount"] as string;
        }        
        public ActionResult BankRegisterPartial()
        {PrepViewBag();
            return PartialView("_BankRegister/_BankRegister", GetBankRegisterTransactionalData());
        }
        private IEnumerable GetBankRegisterTransactionalData()
        {
            GlBL BL = new GlBL();
            List<BankRegisterItem> list = new List<BankRegisterItem>();
            DataSet ds = BL.PerformSearch();
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                if (Convert.ToString(ds.Tables[0].Rows[i]["Date"]) != "" && Convert.ToString(ds.Tables[0].Rows[i]["Bank_Account"]) != "")
                {
                    BankRegisterItem item = new BankRegisterItem();
                    item.elt_account_number = Convert.ToString(ds.Tables[0].Rows[i]["elt_account_number"]);
                    item.Date = Convert.ToString(ds.Tables[0].Rows[i]["Date"]);

                    item.Credit =
                        ds.Tables[0].Rows[i]["Credit(-)"].GetType() == Type.GetType("System.DBNull") ? "" : decimal.Parse(Convert.ToString(ds.Tables[0].Rows[i]["Credit(-)"])).ToString("#.#0");
                    item.Debit = ds.Tables[0].Rows[i]["Debit(+)"].GetType() == Type.GetType("System.DBNull") ? "" : decimal.Parse(Convert.ToString(ds.Tables[0].Rows[i]["Debit(+)"])).ToString("#.#0");

                    item.Memo = Convert.ToString(ds.Tables[0].Rows[i]["Memo"]);
                 
                    item.PrintCheckAs = Convert.ToString(ds.Tables[0].Rows[i]["PrintCheckAs"]);
                    item.Type = Convert.ToString(ds.Tables[0].Rows[i]["Type"]);
                    item.Void = Convert.ToString(ds.Tables[0].Rows[i]["Void"]);
                    item.Clear = Convert.ToString(ds.Tables[0].Rows[i]["Clear"]);
                    item.CheckNo = Convert.ToString(ds.Tables[0].Rows[i]["Check_No"]);
                    item.Link = Convert.ToString(ds.Tables[0].Rows[i]["Link"]);
                    item.Bank_Account = Convert.ToString(ds.Tables[0].Rows[i]["Bank_Account"]);
                    item.Description = Convert.ToString(ds.Tables[0].Rows[i]["Description"]);
                    list.Add(item);
                }
            }

            return list;
        }
        GridViewSettings CreateBankRegisterGridViewSettings()
        {
            GridViewSettings settings = new GridViewSettings();
            settings.Name = "All";
            settings.Columns.Add("Date", "Date");
            settings.Columns.Add("Bank_Account", "Bank Account");
            settings.Columns.Add("CheckNo", "Check#");
            settings.Columns.Add("Clear");
            settings.Columns.Add("Void");
            settings.Columns.Add("Type");
            settings.Columns.Add("Description", "Company Name");
            settings.Columns.Add("PrintCheckAs", "Pay to the Order of");
            var memo = settings.Columns.Add("Memo");
           
        
            settings.Columns.Add(c =>
            {
                c.Caption = "Debit(+)";
                c.FieldName = "Debit";
              
                
            });
            settings.Columns.Add(c =>
            {
                c.Caption = "Credit(-)";
                c.FieldName = "Credit";
               
            });
           
            return settings;
        }
    
        
    }
}
