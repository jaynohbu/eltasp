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
        public ActionResult ARAging(string param)
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
                return RedirectToAction("ExportTo", new { Operation = "ARAging", typeName = TypeName });
            }

            if (param == "dataready")
            {
                return View(GetARAgingMasterModel());
            }
            else
            {
                return View("AccountingReportSelectionArAgingClassic");
            }

        }
        private ARAgingMasterModel GetARAgingMasterModel()
        {
            string KeyFieldName = "Customer_Number";
            ARAgingMasterModel model = new ARAgingMasterModel() { KeyFieldName = KeyFieldName };
            model.AsOf = Session["Accounting_sPeriodBegin"] as string;
            model.Branch = Session["Accounting_sBranchName"] == null ? "" : Session["Accounting_sBranchName"] as string;
            model.Company = Session["Accounting_sCompanName"] == null ? "" : Session["Accounting_sCompanName"] as string;
           
            var data = GetARAgingTransactionalData();
            model.Elements = data;
            return model;
        }
        private List<ARAgingItem> GetARAgingTransactionalData()
        {
            GlBL BL = new GlBL();
            List<ARAgingItem> list = new List<ARAgingItem>();
            DataSet ds = BL.PerformSearch();
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                ARAgingItem item = new ARAgingItem();

                item.Company_Name = Convert.ToString(ds.Tables[0].Rows[i]["Company Name"]);
                item.Credit = item.Current = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["Credit"]).ToString("#0.00"));
                item.Current = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["Current"]).ToString("#0.00"));
                item.Customer_Number = Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]);
                item.Phone = Convert.ToString(ds.Tables[0].Rows[i]["Phone"]);
                item.One_Month = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["1~30"]).ToString("#0.00"));
                item.Two_Month = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["31~60"]).ToString("#0.00"));
                item.Three_Month = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["61~90"]).ToString("#0.00"));
                item.More_Than_Three_Month = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["+90"]).ToString("#0.00"));

                item.Total = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["Total"]).ToString("#0.00"));
                
               
                for (int k = 0; k < ds.Tables[1].Rows.Count; k++)
                {
                    if (ds.Tables[0].Rows[i]["Customer_Name"].GetType() != Type.GetType("System.DBNull") && Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Total" && Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Cumulative Total")
                        if (Convert.ToString(ds.Tables[1].Rows[k]["Customer_Name"]) == Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]))
                        {
                            ARAgingTransactionalItem trans = new ARAgingTransactionalItem();
                            trans.Aging = Convert.ToString(ds.Tables[1].Rows[k]["Aging"]);
                            trans.Company_Name = Convert.ToString(ds.Tables[1].Rows[k]["Company Name"]);
                            //trans.Current = Convert.ToString(ds.Tables[1].Rows[k]["Current"]);
                            trans.Customer_Number = Convert.ToString(ds.Tables[1].Rows[k]["Customer_Name"]);
                            trans.Due_Date = Convert.ToString(ds.Tables[1].Rows[k]["Due Date"]);
                            trans.House_Number = Convert.ToString(ds.Tables[1].Rows[k]["House No."]);
                            trans.IV_Date = Convert.ToString(ds.Tables[1].Rows[k]["I/V Date"]);
                            trans.House_Type = Convert.ToString(ds.Tables[1].Rows[k]["House Type"]);
                            trans.IV_Number = Convert.ToString(ds.Tables[1].Rows[k]["I/V No."]);
                            trans.Type = Convert.ToString(ds.Tables[1].Rows[k]["Type"]);
                           
                            trans.Open_Balance = Convert.ToString(ds.Tables[1].Rows[k]["Open Balance"].GetType() == Type.GetType("System.DBNull") ? "0.00" : Convert.ToDecimal(ds.Tables[1].Rows[k]["Open Balance"]).ToString("#0.00"));


                            trans.Ref_Number = Convert.ToString(ds.Tables[1].Rows[k]["Ref No."]);
                            trans.Term = Convert.ToString(ds.Tables[1].Rows[k]["Term"]);

                            trans.One_Month = Convert.ToString(Convert.ToDecimal(ds.Tables[1].Rows[k]["1~30"]).ToString("#0.00"));
                            trans.Two_Month = Convert.ToString(Convert.ToDecimal(ds.Tables[1].Rows[k]["31~60"]).ToString("#0.00"));
                            trans.Three_Month = Convert.ToString(Convert.ToDecimal(ds.Tables[1].Rows[k]["61~90"]).ToString("#0.00"));
                            trans.More_Than_Three_Month = Convert.ToString(Convert.ToDecimal(ds.Tables[1].Rows[k]["+90"]).ToString("#0.00"));


                            trans.Total = Convert.ToString(Convert.ToDecimal(ds.Tables[1].Rows[k]["Total"]).ToString("#0.00"));                          
                           
                            item.TransactionItems.Add(trans);
                        }
                }


                list.Add(item);
            }
            Session["GetARAgingTransactionalData"] = list;
            return list;
        }
        public ActionResult ARAgingDetail(string KeyFieldName, string Key)
        {
            SetSubMenu(MainMenuContext.Accounting_AccountReceivable);
            var data = GetARAgingTransactionalData();
            ARAgingDetailModel model = new ARAgingDetailModel();
            model.Key = Key;
            model.KeyFieldName = KeyFieldName;
            model.Elements = (from c in data where Convert.ToString(ELT.COMMON.Util.GetPropValue(c, KeyFieldName)) == Key select c).Single().TransactionItems;
            //model.Settings = CreateARAgingGridViewSettings();
            return PartialView("_ARAging/_ARAgingDetail", model);
        }
        public ActionResult ARAgingMaster()
        {
            ARAgingMasterModel model = GetARAgingMasterModel();
            return PartialView("_ARAging/_ARAgingMaster", model);
        }
        static GridViewSettings CreateARAgingGridViewSettings()
        {
            GridViewSettings settings = new GridViewSettings();
            settings.Name = "AR Aging";

            settings.Columns.Add("IV_Date", "I/V Date");
            settings.Columns.Add("IV_Number", "I/V No.");
            settings.Columns.Add("House_Number", "House No.");
            settings.Columns.Add("Ref_Number", "Ref No.");
            settings.Columns.Add("Due_Date", "Due");
            settings.Columns.Add("Term");
            settings.Columns.Add("Aging");
            settings.Columns.Add("Open_Balance", "Open Balance");
            settings.Columns.Add("Current");
            settings.Columns.Add("One_Month", "1~30");
            settings.Columns.Add("Two_Month", "31~60");
            settings.Columns.Add("Three_Month", "61~90");
            settings.Columns.Add("More_Than_Three_Month", "+90");
            settings.Columns.Add("Total");   
            return settings;
        }
    }
}
