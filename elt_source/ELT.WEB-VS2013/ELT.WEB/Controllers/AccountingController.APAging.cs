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
        public ActionResult APAging(string param)
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
                return RedirectToAction("ExportTo", new { Operation = "APAging", typeName = TypeName });
            }
            if (param == "dataready")
            {
                return View(GetAPAgingMasterModel());
            }
            else
            {
                return View("AccountingReportSelectionApAgingClassic");
            }

        }
        private APAgingMasterModel GetAPAgingMasterModel()
        {

            string KeyFieldName = "Customer_Number";
            APAgingMasterModel model = new APAgingMasterModel() { KeyFieldName = KeyFieldName };
            model.AsOf = Session["Accounting_sPeriodBegin"] as string;
            model.Branch = Session["Accounting_sBranchName"] == null ? "" : Session["Accounting_sBranchName"] as string;
            model.Company = Session["Accounting_sCompanName"] == null ? "" : Session["Accounting_sCompanName"] as string;
           
            var data = GetAPAgingTransactionalData();
            model.Elements = data;
            return model;
        }
        private List<APAgingItem> GetAPAgingTransactionalData()
        {
            GlBL BL = new GlBL();
            List<APAgingItem> list = new List<APAgingItem>();
            DataSet ds = BL.PerformSearch();
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                if (Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Posted Transactions")
                {
                    APAgingItem item = new APAgingItem();
                    item.Company_Name = Convert.ToString(ds.Tables[0].Rows[i]["vendor_name"]);
                    item.Current = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["Current"]).ToString("#0.00"));
                    item.Customer_Number = Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]);
                    item.One_Month = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["1~30"]).ToString("#0.00"));
                    item.Two_Month = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["31~60"]).ToString("#0.00"));
                    item.Three_Month = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["61~90"]).ToString("#0.00"));
                    item.More_Than_Three_Month = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["+90"]).ToString("#0.00"));

                    item.Total = Convert.ToString(Convert.ToDecimal(ds.Tables[0].Rows[i]["Total"]).ToString("#0.00"));              
               
                    item.Phone = Convert.ToString(ds.Tables[0].Rows[i]["telephone"]);
                

                    for (int k = 0; k < ds.Tables[1].Rows.Count; k++)
                    {
                        if (ds.Tables[0].Rows[i]["Customer_Name"].GetType() != Type.GetType("System.DBNull") && Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Total" && Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]) != "Cumulative Total")
                            if (Convert.ToString(ds.Tables[1].Rows[k]["Customer_Name"]) == Convert.ToString(ds.Tables[0].Rows[i]["Customer_Name"]))
                            {
                                APAgingTransactionalItem trans = new APAgingTransactionalItem();
                                trans.Aging = Convert.ToString(ds.Tables[1].Rows[k]["Aging"]);
                                trans.Date = Convert.ToString(ds.Tables[1].Rows[k]["Date"]);
                                trans.Company_Name = Convert.ToString(ds.Tables[1].Rows[k]["vendor_name"]);
                                //trans.Current = Convert.ToString(ds.Tables[1].Rows[k]["Current"]);
                                trans.Customer_Number = Convert.ToString(ds.Tables[1].Rows[k]["Customer_Name"]);
                                trans.Due_Date = Convert.ToString(ds.Tables[1].Rows[k]["Due Date"]);
                                trans.Doc_Number = Convert.ToString(ds.Tables[1].Rows[k]["Doc.No."]);
                                trans.Ref_Number = Convert.ToString(ds.Tables[1].Rows[k]["Ref No."]);
                                trans.File_Number = Convert.ToString(ds.Tables[1].Rows[k]["File No."]);
                                trans.Link = Convert.ToString(ds.Tables[1].Rows[k]["Link"]);
                                trans.Type = Convert.ToString(ds.Tables[1].Rows[k]["Type"]);
                                trans.Open_Balance = Convert.ToString(ds.Tables[1].Rows[k]["Open Balance"].GetType() == Type.GetType("System.DBNull") ? "0.00" : Convert.ToDecimal(ds.Tables[1].Rows[k]["Open Balance"]).ToString("#0.00"));
                                trans.Ref_Number = Convert.ToString(ds.Tables[1].Rows[k]["Ref No."]);

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
            }
            Session["GetAPAgingTransactionalData"] = list;
            return list;
        }
        public ActionResult APAgingDetail(string KeyFieldName, string Key)
        {
            SetSubMenu(MainMenuContext.Accounting_AccountPayable);
            var data = GetAPAgingTransactionalData();
            APAgingDetailModel model = new APAgingDetailModel();
            model.Key = Key;
            model.KeyFieldName = KeyFieldName;
            model.Elements = (from c in data where Convert.ToString(ELT.COMMON.Util.GetPropValue(c, KeyFieldName)) == Key select c).Single().TransactionItems;
            //model.Settings = CreateAPAgingGridViewSettings();
            return PartialView("_APAging/_APAgingDetail", model);
        }
        public ActionResult APAgingMaster()
        {
            APAgingMasterModel model = GetAPAgingMasterModel();
            return PartialView("_APAging/_APAgingMaster", model);
        }

        static GridViewSettings CreateAPAgingGridViewSettings()
        {
            GridViewSettings settings = new GridViewSettings();
            settings.Name = "AP Aging";
            settings.Columns.Add("Type");
            settings.Columns.Add("Date");
            settings.Columns.Add("File_Number", "File No.");
            settings.Columns.Add("Ref_Number", "Ref #");
            settings.Columns.Add("APAgingTransactionalItem","Doc No.");
            settings.Columns.Add("Due_Date", "Due");
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
