using System;
using System.Linq;
using System.Web.Mvc;
using ELT.BL;
using ELT.WEB.Models;
using ELT.CDT;
using System.Collections.Generic;
using DevExpress.Web.Mvc;
using DevExpress.Web.ASPxGridView;
using System.Globalization;
using System.Collections;
using System.Web;
using ELT.WEB.Filters;
namespace ELT.WEB.Controllers
{
    [Authorize]
    public class ReportController : OperationBaseController
    {

        public ReportController()
        {
            if (System.Web.HttpContext.Current.Session != null)
            {
                SetSubMenu(MainMenuContext.Report);
                SetProductMenu(ProductMenuContext.International);
            }
        }

        public ActionResult Index()
        {
            return View();
        }
        #region AirExport
          [CheckSession]
        public ActionResult AirExport()
        {
            CheckAccess();
            AirReportMasterModel model = new AirReportMasterModel();
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
                return RedirectToAction("ExportTo", new { Operation = "AirExport", typeName = TypeName });
            }
            if (Request["PeriodBegin"] == null || Request["ReSelect"] != null)
            {
                Session["AirExportMasterReportData"]=null;
                ViewBag.IsSelected = false;
            }
            else
            {
                ReportSelection ReportSelection = new ReportSelection();
                CultureInfo ci = new CultureInfo("en-US");
                ReportSelection.PeriodBegin = Convert.ToDateTime(Request["PeriodBegin"], ci);
                ReportSelection.PeriodEnd = Convert.ToDateTime(Request["PeriodEnd"], ci);
                ReportSelection.CategorizeBy = Convert.ToString(Request["CategorizeBy"]);
                ReportSelection.WeightScale = Convert.ToString(Request["WeightScale"]);
                ReportSelection.AnalysisOn = Convert.ToString(Request["chkAnalysisOn"]);

                Session["AirExportReportSelection"] = ReportSelection;
                model = GetAirExportMasterModel();

                model.PeriodBegin = ReportSelection.PeriodBegin;
                model.PeriodEnd = ReportSelection.PeriodEnd;
                model.CategorizeBy = ReportSelection.CategorizeBy;
                model.WeightScale = ReportSelection.WeightScale;
                model.AnalysisOn = ReportSelection.AnalysisOn;

                ViewBag.IsSelected = true;
            }
            return View(model);
        }
        private AirReportMasterModel GetAirExportMasterModel()
        {
            ReportSelection selection = (ReportSelection)Session["AirExportReportSelection"];
            string KeyFieldName = selection.CategorizeBy;
            Session["KeyFieldName"] = selection.CategorizeBy;

            AirReportMasterModel model = new AirReportMasterModel() { KeyFieldName = KeyFieldName };
            var data = GetAirExportTransactionalData();
            if (KeyFieldName == "Agent")
            {
                model.Elements = data.GroupBy(d => d.Agent).Select(grp => grp.First()).ToList();
            }
            if (KeyFieldName == "Shipper")
            {
                model.Elements = data.GroupBy(d => d.Shipper).Select(grp => grp.First()).ToList();
            }
            if (KeyFieldName == "Carrier")
            {
                model.Elements = data.GroupBy(d => d.Carrier).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Consignee")
            {
                model.Elements = data.GroupBy(d => d.Consignee).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Origin")
            {
                model.Elements = data.GroupBy(d => d.Origin).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Destination")
            {
                model.Elements = data.GroupBy(d => d.Destination).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Sale_Rep")
            {
                model.Elements = data.GroupBy(d => d.Sale_Rep).Select(grp => grp.First()).ToList();
            }
            return model;
        }
        private List<AirTransactionItem> GetAirExportTransactionalData()
        {
            ReportSelection selection = (ReportSelection)Session["AirExportReportSelection"];

           
            ELT.BL.ReportingBL ReportBL = new ReportingBL();
            if (Session["AirExportMasterReportData"] == null)
            {
                var user = GetCurrentELTUser();
                string ELT_account_number = user.elt_account_number;
                if (ELT_account_number == null)
                    Response.Redirect("~/Account/Login", true);
                Session["AirExportMasterReportData"]
                    = ReportBL.GetAirExportTransItems(ELT_account_number,selection);
            }

            var model = (List<AirTransactionItem>)Session["AirExportMasterReportData"];

            return model;
        }
        public ActionResult AirExportDetail(string KeyFieldName, string Key)
        {
            var data = GetAirExportTransactionalData();
            AirReportDetailModel model = new AirReportDetailModel();
            model.Key = Key;
            model.KeyFieldName = KeyFieldName;
            model.Elements = (from c in data where Convert.ToString(ELT.COMMON.Util.GetPropValue(c, KeyFieldName)) == Key select c).ToList();
            model.Settings = CreateAirGridViewSettings();
            return PartialView("_AirExportDetail", model);
        }
        public ActionResult AirExportMaster()
        {
            AirReportMasterModel model = GetAirExportMasterModel();
            return PartialView("_AirExportMaster", model);
        }
        #endregion 

        #region AirImport
          [CheckSession]
        public ActionResult AirImport()
        {
            CheckAccess();
            AirReportMasterModel model = new AirReportMasterModel();
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
                return RedirectToAction("ExportTo", new { Operation = "AirImport", typeName = TypeName });
            }
            if (Request["PeriodBegin"] == null || Request["ReSelect"] != null)
            {
                Session["AirImportMasterReportData"] = null;
                ViewBag.IsSelected = false;
            }
            else
            {
                ReportSelection ReportSelection = new ReportSelection();
                CultureInfo ci = new CultureInfo("en-US");
                ReportSelection.PeriodBegin = Convert.ToDateTime(Request["PeriodBegin"], ci);
                ReportSelection.PeriodEnd = Convert.ToDateTime(Request["PeriodEnd"], ci);
                ReportSelection.CategorizeBy = Convert.ToString(Request["CategorizeBy"]);
                ReportSelection.WeightScale = Convert.ToString(Request["WeightScale"]);
                ReportSelection.AnalysisOn = Convert.ToString(Request["chkAnalysisOn"]);

                Session["AirImportReportSelection"] = ReportSelection;
                model = GetAirImportMasterModel();

                model.PeriodBegin = ReportSelection.PeriodBegin;
                model.PeriodEnd = ReportSelection.PeriodEnd;
                model.CategorizeBy = ReportSelection.CategorizeBy;
                model.WeightScale = ReportSelection.WeightScale;
                model.AnalysisOn = ReportSelection.AnalysisOn;

                ViewBag.IsSelected = true;
            }
            return View(model);
        }
        private AirReportMasterModel GetAirImportMasterModel()
        {
            ReportSelection selection = (ReportSelection)Session["AirImportReportSelection"];
            string KeyFieldName = selection.CategorizeBy;
            Session["KeyFieldName"] = selection.CategorizeBy;

            AirReportMasterModel model = new AirReportMasterModel() { KeyFieldName = KeyFieldName };
            var data = GetAirImportTransactionalData();
            if (KeyFieldName == "Agent")
            {
                model.Elements = data.GroupBy(d => d.Agent).Select(grp => grp.First()).ToList();
            }
            if (KeyFieldName == "Shipper")
            {
                model.Elements = data.GroupBy(d => d.Shipper).Select(grp => grp.First()).ToList();
            }
            if (KeyFieldName == "Carrier")
            {
                model.Elements = data.GroupBy(d => d.Carrier).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Consignee")
            {
                model.Elements = data.GroupBy(d => d.Consignee).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Origin")
            {
                model.Elements = data.GroupBy(d => d.Origin).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Destination")
            {
                model.Elements = data.GroupBy(d => d.Destination).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Sale_Rep")
            {
                model.Elements = data.GroupBy(d => d.Sale_Rep).Select(grp => grp.First()).ToList();
            }
            return model;
        }
        private List<AirTransactionItem> GetAirImportTransactionalData()
        {
            ReportSelection selection = (ReportSelection)Session["AirImportReportSelection"];

           
            
            ELT.BL.ReportingBL ReportBL = new ReportingBL();
            if (Session["AirImportMasterReportData"] == null)
            {
                var user = GetCurrentELTUser();
                string ELT_account_number = user.elt_account_number;
                if (ELT_account_number == null)
                    Response.Redirect("~/Account/Login",true);
                Session["AirImportMasterReportData"]
                    = ReportBL.GetAirImportTransItems(ELT_account_number,selection);
            }

            var model = (List<AirTransactionItem>)Session["AirImportMasterReportData"];

            return model;
        }
        public ActionResult AirImportDetail(string KeyFieldName, string Key)
        {
            var data = GetAirImportTransactionalData();
            AirReportDetailModel model = new AirReportDetailModel();
            model.Key = Key;
            model.KeyFieldName = KeyFieldName;
            model.Elements = (from c in data where Convert.ToString(ELT.COMMON.Util.GetPropValue(c, KeyFieldName)) == Key select c).ToList();
            model.Settings = CreateAirGridViewSettings();
            return PartialView("_AirImportDetail", model);
        }
        public ActionResult AirImportMaster()
        {
            AirReportMasterModel model = GetAirImportMasterModel();
            return PartialView("_AirImportMaster", model);
        }
        #endregion

        #region OceanExport
          [CheckSession]
        public ActionResult OceanExport()
        {
            CheckAccess();
            OceanReportMasterModel model = new OceanReportMasterModel();
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
                return RedirectToAction("ExportTo", new { Operation = "OceanExport", typeName = TypeName });
            }
            if (Request["PeriodBegin"] == null || Request["ReSelect"] != null)
            {
                Session["OceanExportMasterReportData"] = null;
                ViewBag.IsSelected = false;
            }
            else
            {
                ReportSelection ReportSelection = new ReportSelection();
                CultureInfo ci = new CultureInfo("en-US");
                ReportSelection.PeriodBegin = Convert.ToDateTime(Request["PeriodBegin"], ci);
                ReportSelection.PeriodEnd = Convert.ToDateTime(Request["PeriodEnd"], ci);
                ReportSelection.CategorizeBy = Convert.ToString(Request["CategorizeBy"]);
                ReportSelection.WeightScale = Convert.ToString(Request["WeightScale"]);
                ReportSelection.AnalysisOn = Convert.ToString(Request["chkAnalysisOn"]);


                Session["OceanExportReportSelection"] = ReportSelection;
                model = GetOceanExportMasterModel();

                model.PeriodBegin = ReportSelection.PeriodBegin;
                model.PeriodEnd = ReportSelection.PeriodEnd;
                model.CategorizeBy = ReportSelection.CategorizeBy;
                model.WeightScale = ReportSelection.WeightScale;
                model.AnalysisOn = ReportSelection.AnalysisOn;

                ViewBag.IsSelected = true;
            }
            return View(model);
        }
        private OceanReportMasterModel GetOceanExportMasterModel()
        {
            ReportSelection selection = (ReportSelection)Session["OceanExportReportSelection"];
            string KeyFieldName = selection.CategorizeBy;
            Session["KeyFieldName"] = selection.CategorizeBy;

            OceanReportMasterModel model = new OceanReportMasterModel() { KeyFieldName = KeyFieldName };
            var data = GetOceanExportTransactionalData();
            if (KeyFieldName == "Agent")
            {
                model.Elements = data.GroupBy(d => d.Agent).Select(grp => grp.First()).ToList();
            }
            if (KeyFieldName == "Shipper")
            {
                model.Elements = data.GroupBy(d => d.Shipper).Select(grp => grp.First()).ToList();
            }
            if (KeyFieldName == "Carrier")
            {
                model.Elements = data.GroupBy(d => d.Carrier).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Consignee")
            {
                model.Elements = data.GroupBy(d => d.Consignee).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Origin")
            {
                model.Elements = data.GroupBy(d => d.Origin).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Destination")
            {
                model.Elements = data.GroupBy(d => d.Destination).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Sale_Rep")
            {
                model.Elements = data.GroupBy(d => d.Sale_Rep).Select(grp => grp.First()).ToList();
            }
            return model;
        }
        private List<OceanTransactionItem> GetOceanExportTransactionalData()
        {
            ReportSelection selection = (ReportSelection)Session["OceanExportReportSelection"];


            ELT.BL.ReportingBL ReportBL = new ReportingBL();
            if (Session["OceanExportMasterReportData"] == null)
            {
                var user = GetCurrentELTUser();
                string ELT_account_number = user.elt_account_number;
                if (ELT_account_number == null)
                    Response.Redirect("~/Account/Login", true);
                Session["OceanExportMasterReportData"]
                    = ReportBL.GetOceanExportTransItems(ELT_account_number, selection);
            }

            var model = (List<OceanTransactionItem>)Session["OceanExportMasterReportData"];

            return model;
        }
        public ActionResult OceanExportDetail(string KeyFieldName, string Key)
        {
            var data = GetOceanExportTransactionalData();
            OceanReportDetailModel model = new OceanReportDetailModel();
            model.Key = Key;
            model.KeyFieldName = KeyFieldName;
            model.Elements = (from c in data where Convert.ToString(ELT.COMMON.Util.GetPropValue(c, KeyFieldName)) == Key select c).ToList();
          
            return PartialView("_OceanExportDetail", model);
        }
        public ActionResult OceanExportMaster()
        {
            OceanReportMasterModel model = GetOceanExportMasterModel();
            return PartialView("_OceanExportMaster", model);
        }
        #endregion

        #region OceanImport
          [CheckSession]
        public ActionResult OceanImport()
        {
            CheckAccess();
            OceanReportMasterModel model = new OceanReportMasterModel();
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
                return RedirectToAction("ExportTo", new { Operation = "OceanImport", typeName = TypeName });
            }
            if (Request["PeriodBegin"] == null || Request["ReSelect"] != null)
            {
                Session["OceanImportMasterReportData"] = null;
                ViewBag.IsSelected = false;
            }
            else
            {
                ReportSelection ReportSelection = new ReportSelection();
                CultureInfo ci = new CultureInfo("en-US");
                ReportSelection.PeriodBegin = Convert.ToDateTime(Request["PeriodBegin"], ci);
                ReportSelection.PeriodEnd = Convert.ToDateTime(Request["PeriodEnd"], ci);
                ReportSelection.CategorizeBy = Convert.ToString(Request["CategorizeBy"]);
                ReportSelection.WeightScale = Convert.ToString(Request["WeightScale"]);
                ReportSelection.AnalysisOn = Convert.ToString(Request["chkAnalysisOn"]);

                Session["OceanImportReportSelection"] = ReportSelection;
                model = GetOceanImportMasterModel();

                model.PeriodBegin = ReportSelection.PeriodBegin;
                model.PeriodEnd = ReportSelection.PeriodEnd;
                model.CategorizeBy = ReportSelection.CategorizeBy;
                model.WeightScale = ReportSelection.WeightScale;
                model.AnalysisOn = ReportSelection.AnalysisOn;

                ViewBag.IsSelected = true;
            }
            return View(model);
        }
        private OceanReportMasterModel GetOceanImportMasterModel()
        {
            ReportSelection selection = (ReportSelection)Session["OceanImportReportSelection"];
            string KeyFieldName = selection.CategorizeBy;
            Session["KeyFieldName"] = selection.CategorizeBy;

            OceanReportMasterModel model = new OceanReportMasterModel() { KeyFieldName = KeyFieldName };
            var data = GetOceanImportTransactionalData();
            if (KeyFieldName == "Agent")
            {
                model.Elements = data.GroupBy(d => d.Agent).Select(grp => grp.First()).ToList();
            }
            if (KeyFieldName == "Shipper")
            {
                model.Elements = data.GroupBy(d => d.Shipper).Select(grp => grp.First()).ToList();
            }
            if (KeyFieldName == "Carrier")
            {
                model.Elements = data.GroupBy(d => d.Carrier).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Consignee")
            {
                model.Elements = data.GroupBy(d => d.Consignee).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Origin")
            {
                model.Elements = data.GroupBy(d => d.Origin).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Destination")
            {
                model.Elements = data.GroupBy(d => d.Destination).Select(grp => grp.First()).ToList();
            }

            if (KeyFieldName == "Sale_Rep")
            {
                model.Elements = data.GroupBy(d => d.Sale_Rep).Select(grp => grp.First()).ToList();
            }
            return model;
        }
        private List<OceanTransactionItem> GetOceanImportTransactionalData()
        {
            ReportSelection selection = (ReportSelection)Session["OceanImportReportSelection"];



            ELT.BL.ReportingBL ReportBL = new ReportingBL();
            if (Session["OceanImportMasterReportData"] == null)
            {
                var user = GetCurrentELTUser();
                string ELT_account_number = user.elt_account_number;
                if (ELT_account_number == null)
                    Response.Redirect("~/Account/Login", true);
                Session["OceanImportMasterReportData"]
                    = ReportBL.GetOceanImportTransItems(ELT_account_number, selection);
            }

            var model = (List<OceanTransactionItem>)Session["OceanImportMasterReportData"];

            return model;
        }
        public ActionResult OceanImportDetail(string KeyFieldName, string Key)
        {
            var data = GetOceanImportTransactionalData();
            OceanReportDetailModel model = new OceanReportDetailModel();
            model.Key = Key;
            model.KeyFieldName = KeyFieldName;
            model.Elements = (from c in data where Convert.ToString(ELT.COMMON.Util.GetPropValue(c, KeyFieldName)) == Key select c).ToList();
            //model.Settings = CreateOceanGridViewSettings();
            return PartialView("_OceanImportDetail", model);
        }
        public ActionResult OceanImportMaster()
        {
            OceanReportMasterModel model = GetOceanImportMasterModel();
            return PartialView("_OceanImportMaster", model);
        }
        #endregion
        #region PNL
          [CheckSession]
        public ActionResult PNL()
        {
            CheckAccess();
            PNLMasterModel model = new PNLMasterModel();
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
                return RedirectToAction("ExportTo", new { Operation = "PNL", typeName = TypeName });
            }
            if (Request["PeriodBegin"] == null || Request["ReSelect"] != null)
            {
                Session["PNLReportData"] = null;
                ViewBag.IsSelected = false;
                if (Session["RefreshPNL"] == null)
                {                   
                    RefreshPNL();
                    Session["RefreshPNL"] = true;
                }
            }
            else
            {
                PNLSelection ReportSelection = new PNLSelection();
                CultureInfo ci = new CultureInfo("en-US");
                ReportSelection.PeriodBegin = Convert.ToDateTime(Request["PeriodBegin"], ci);
                ReportSelection.PeriodEnd = Convert.ToDateTime(Request["PeriodEnd"], ci);
                ReportSelection.MAWB = Convert.ToString(Request["MAWB"]);
                ReportSelection.AirOcean = Convert.ToString(Request["AirOcean"]);
                ReportSelection.ImportExport = Convert.ToString(Request["ImportExport"]);
                ReportSelection.MAWB = Convert.ToString(Request["MAWB"]);
                Session["PNLReportSelection"] = ReportSelection;
                 model = GetPNLMasterModel();
                ViewBag.IsSelected = true;
            }
            return View(model);
        }
        public ActionResult RefreshPNL()
        {
            ELT.BL.ReportingBL ReportBL = new ReportingBL();
            var user = GetCurrentELTUser();
            int elt_account_number = int.Parse(user.elt_account_number);
            ReportBL.RefreshPNL(elt_account_number);
            return new EmptyResult();
        }
        private PNLMasterModel GetPNLMasterModel()
        {
            PNLSelection selection = (PNLSelection)Session["PNLReportSelection"];
            string KeyFieldName = "ID";
            PNLMasterModel model = new PNLMasterModel() { KeyFieldName = KeyFieldName , Begin=selection.PeriodBegin, End=selection.PeriodEnd, MAWB=selection.MAWB};
            model.PNLTransactionItems = GetPNLTransactionalData();
            model.ImportExport = selection.ImportExport;
            model.MAWB = selection.MAWB;
            model.AirOcean = selection.AirOcean;
            return model;
        }
        private List<PNLTransactionItem> GetPNLTransactionalData()
        {
            PNLSelection selection = (PNLSelection)Session["PNLReportSelection"];

            ELT.BL.ReportingBL ReportBL = new ReportingBL();
            if (Session["PNLReportData"] == null)
            {
                var user = GetCurrentELTUser();
                string ELT_account_number = user.elt_account_number;
                if (ELT_account_number == null)
                    Response.Redirect("~/Account/Login", true);
                if (Session["PNLReportData"]==null)
                Session["PNLReportData"]
                    = ReportBL.GetPNLTransactionItem(int.Parse(ELT_account_number), selection);
            }
       
            var model = (List<PNLTransactionItem>)Session["PNLReportData"];
            if (selection.ImportExport != "All")
            {
                model = (from c in model where c.ImportExport == selection.ImportExport select c).ToList();
            }
            if (selection.AirOcean != "All")
            {
                model = (from c in model where c.AirOcean == selection.AirOcean select c).ToList();
            }
          
            return model;
        }
        public ActionResult AddGroupToPnl()
        {
            string GroupBy = Request.QueryString["GroupBy"];
            ArrayList PNLGropuing = null;
            PNLGropuing = GetPNLGrouping();
            PNLGropuing.Add(GroupBy);
            Session["GroupAdded"] = true;
            return new EmptyResult();
        }
        public ActionResult PNLMaster(int? group, bool? clear)
        {
            PNLMasterModel model = GetPNLMasterModel();
            ArrayList PNLGropuing = null;
            string sGroupBy = string.Empty;
            string sGroupByOrder = string.Empty;
            if (clear == true)
            {
                ViewBag.ClearGrouping = true;
                PNLGropuing = GetPNLGrouping();
                PNLGropuing.Clear();
            }
            else if (group!=null)
            {
                ViewBag.ClearGrouping = false;
                sGroupBy = SetGroup(group, sGroupBy);
                Session["GroupAdded"] = true;
            }
            if (Session["GroupAdded"] != null)
            {
                Session["GroupAdded"] = null;
                PNLGropuing = GetPNLGrouping();
                PNLGropuing.Add(sGroupBy);
                ViewBag.GroupBy = PNLGropuing;
            }
            return PartialView("_PNLMaster", model);
        }
        private static string SetGroup(int? group, string sGroupBy)
        {
            if (group == 1)
            {
                sGroupBy = "Customer_Name";
            }
            else if (group == 2)
            {
                sGroupBy = "MBL_NUM";
            }
            else if (group == 3)
            {
                sGroupBy = "HBL_NUM";
            }
            else if (group == 4)
            {
                sGroupBy = "Description";
            }
            else if (group == 5)
            {
                sGroupBy = "Date";
            }
            else if (group == 6)
            {
                sGroupBy = "ORIGN";
            }
            else if (group == 7)
            {
                sGroupBy = "DEST";
            }
            else if (group == 8)
            {
                sGroupBy = "AirOcean";
            }
            else if (group == 9)
            {
                sGroupBy = "ImportExport";
            }
            else
            {
                sGroupBy = "Customer_Name";
            }
            return sGroupBy;
        }
        private ArrayList GetPNLGrouping()
        {
            ArrayList PNLGropuing=null;
            if (Session["PNLGropuing"] != null)
            {
                PNLGropuing = (ArrayList)Session["PNLGropuing"];
            }
            else
            {
                PNLGropuing = new ArrayList();
            }
            return PNLGropuing;
        }      
        #endregion 
        public ActionResult ExportTo(string Operation, string typeName)
        {
            GridViewSettings settings = null;
            if (Operation == "PNL")
            {
                settings = CreatePNLGridViewSettings();
                return GridViewExportHelper.ExportTypes[typeName].Method(settings, GetPNLTransactionalData());
            }
            else if (Operation == "AirExport")
                {
                    settings = CreateAirGridViewSettings();
                    return GridViewExportHelper.ExportTypes[typeName].Method(settings, GetAirExportTransactionalData());
                }
                else if (Operation == "AirImport")
                {
                    settings = CreateAirGridViewSettings();
                    return GridViewExportHelper.ExportTypes[typeName].Method(settings, GetAirImportTransactionalData());
                }
                else if (Operation == "OceanExport")
                {
                    settings = CreateOceanGridViewSettings();
                    return GridViewExportHelper.ExportTypes[typeName].Method(settings, GetOceanExportTransactionalData());
                }
                else
                {
                    settings = CreateOceanGridViewSettings();
                    return GridViewExportHelper.ExportTypes[typeName].Method(settings, GetOceanImportTransactionalData());
                }

        }
        private int GetGroupIndex(string name){
             ArrayList PNLGropuing  = GetPNLGrouping();
            int index=-1;
            for (int i = 0; i < PNLGropuing.Count; i++)
            {
                
                    if (name== PNLGropuing[i].ToString())
                    {
                        index = i;
                    }
                }

            
        return index;
        }
        public  GridViewSettings CreatePNLGridViewSettings()
        {
            GridViewSettings settings = new GridViewSettings();
            settings.Name = "grid";              
            settings.SettingsPager.PageSize = 30;

            settings.Columns.Add("Customer_Name", "Customer").GroupIndex = GetGroupIndex("Customer_Name");
            settings.Columns.Add("ImportExport", "Import/Export").GroupIndex = GetGroupIndex("ImportExport");
            settings.Columns.Add("AirOcean", "Air/Ocean").GroupIndex = GetGroupIndex("AirOcean");
            settings.Columns.Add("MBL_NUM", "MAWB/MBOL").GroupIndex = GetGroupIndex("MBL_NUM");
            settings.Columns.Add("HBL_NUM", "HAWB/HBOL").GroupIndex = GetGroupIndex("HBL_NUM");
            settings.Columns.Add("Date").GroupIndex = GetGroupIndex("Date");
            settings.Columns.Add("Description", "Item").GroupIndex = GetGroupIndex("Description");
            settings.Columns.Add("ORIGIN", "Origination").GroupIndex = GetGroupIndex("ORIGIN");
            settings.Columns.Add("DEST", "Destination").GroupIndex = GetGroupIndex("DEST");     
            settings.Columns.Add("Revenue");
            settings.Columns.Add("Expense");
            settings.Columns.Add("Profit");
            settings.Settings.ShowFooter = true;
            settings.TotalSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Revenue");
            settings.TotalSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Expense");
            settings.TotalSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Profit");
            settings.GroupSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Revenue");
            settings.GroupSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Expense");
            settings.GroupSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Profit");
            settings.Settings.ShowGroupPanel = true;

            settings.DataBound = (sender, e) =>
            {
                MVCxGridView grid = (MVCxGridView)sender;
                ArrayList PNLGropuing = GetPNLGrouping();
                for (int i = 0; i < PNLGropuing.Count; i++)
                    grid.GroupBy(grid.Columns[PNLGropuing[i].ToString()]);
                grid.ExpandAll();              
               

            };

            return settings;
        }
        public GridViewSettings CreateOceanGridViewSettings()
        {
            GridViewSettings settings = new GridViewSettings();
               settings.Name = "All";
           
              settings.Columns.Add("FileNo", "File#");
              settings.Columns.Add("Master", "MBOL#");
              settings.Columns.Add("House", "HBOL#");

              settings.Columns.Add("Shipper");
              settings.Columns.Add("Consignee");
              settings.Columns.Add("Agent");
              settings.Columns.Add("Carrier");
              settings.Columns.Add("Origin");
              settings.Columns.Add("Destination");

              settings.Columns.Add("Date", "ETD");
              settings.Columns.Add("Sale_Rep", "Sales Rep.");
              settings.Columns.Add("Processed_By", "Processed By");
              settings.Columns.Add("Processed_By", "Processed By");
              settings.Columns.Add(c =>
              {
                  c.FieldName = "Quantity";
                  c.Caption = "";
                  ((MVCxGridViewColumn)c).CellStyle.CssClass = "numeric";
              });

              settings.Columns.Add(c =>
              {
                  c.FieldName = "Gros_Wt";
                  c.Caption = "Gros Wt.";
                  ((MVCxGridViewColumn)c).CellStyle.CssClass = "numeric";
              });

              settings.Columns.Add(c =>
              {
                  c.FieldName = "Measurement";
                  c.Caption = "Measurement (CBM)";
                  ((MVCxGridViewColumn)c).CellStyle.CssClass = "numeric";
              });
              settings.Columns.Add(c =>
              {
                  c.FieldName = "Freight_Charge";
                  c.Caption = "Freight Charge";
                  ((MVCxGridViewColumn)c).CellStyle.CssClass = "numeric";
              });

              settings.Columns.Add(c =>
              {
                  c.FieldName = "Other_Charge";
                  c.Caption = "Other Charge";
                  ((MVCxGridViewColumn)c).CellStyle.CssClass = "numeric";
              });
              settings.DataBound = (sender, e) =>
              {
                  MVCxGridView grid = (MVCxGridView)sender;
                  string KeyFieldName = (string)Session["KeyFieldName"];
                  grid.GroupBy(grid.Columns[KeyFieldName]);

              };

            return settings;
        }
        public GridViewSettings CreateAirGridViewSettings()
        {
            GridViewSettings settings = new GridViewSettings();
            settings.Name = "All";
            settings.Columns.Add("Master");
            settings.Columns.Add("FileNo");
            settings.Columns.Add("House");
            settings.Columns.Add("Shipper");
            settings.Columns.Add("Consignee");
            settings.Columns.Add("Agent");
            settings.Columns.Add("Carrier");
            settings.Columns.Add("Origin");
            settings.Columns.Add("Destination");
            settings.Columns.Add("Quantity").PropertiesEdit.DisplayFormatString = "n";
            settings.Columns.Add("Date").PropertiesEdit.DisplayFormatString = "d";
            settings.Columns.Add(column =>
            {
                column.FieldName = "Gros_Wt";
                column.SetHeaderCaptionTemplateContent("Gros WT.");
            });

            settings.Columns.Add("ChargeableWeight");

            settings.Columns.Add(column =>
            {
                column.FieldName = "ChargeableWeight";
                column.SetHeaderCaptionTemplateContent("Chargeable WT.");

            });

            settings.Columns.Add(column =>
            {
                column.FieldName = "Freight_Charge";
                column.SetHeaderCaptionTemplateContent("Freight Charge");
                column.PropertiesEdit.DisplayFormatString = "c";
            });

            settings.Columns.Add(column =>
            {
                column.FieldName = "Other_Charge";
                column.SetHeaderCaptionTemplateContent("Other Charge");
                column.PropertiesEdit.DisplayFormatString = "c";
            });

            settings.Settings.ShowFooter = true;
            settings.TotalSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Gros_Wt");
            settings.TotalSummary.Add(DevExpress.Data.SummaryItemType.Sum, "ChargeableWeight");
            settings.TotalSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Freight_Charge");
            settings.TotalSummary.Add(DevExpress.Data.SummaryItemType.Sum, "Other_Charge");


            settings.DataBound = (sender, e) =>
            {
                MVCxGridView grid = (MVCxGridView)sender;
                string KeyFieldName = (string)Session["KeyFieldName"];
                grid.GroupBy(grid.Columns[KeyFieldName]);              
                            
            };

            return settings;


        }       
        
    }
}