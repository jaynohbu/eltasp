using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ELT.WEB.Models;
using ELT.BL;
using ELT.CDT;
using System.IO;

namespace ELT.WEB.Controllers
{
    [Authorize]
    public class AspPrintPDFController : Controller
    {        // GET: ~/aspPrintPDF/
        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public ActionResult HAWBPrintPDF(AspPrintPDFAirExportHAWB model)
        {
            string url = string.Empty;
            model.HAWB = Request["HAWB"];
            url = GenerateHAWBPrintUrl(model);
            Stream receiveStream = null;
            ELT.COMMON.Util.ReadFileStream(url, ref receiveStream);
            return File(receiveStream, "application/pdf", model.HAWB + ".pdf");
       
        }
        [HttpGet]
        [Authorize]
        public ActionResult HAWBPrintPDF(string HAWB)
        {
            AspPrintPDFAirExportHAWB model = new AspPrintPDFAirExportHAWB() {HAWB = HAWB };
            return View(model);
        }
       
        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public ActionResult MAWBPrintPDF(AspPrintPDFAirExportMAWB model)
        {
            string url = string.Empty;        
            url = GenerateMAWBPrintUrl(model);
           Stream receiveStream = null;
           ELT.COMMON.Util.ReadFileStream(url, ref receiveStream);
           return File(receiveStream, "application/pdf", model.MAWB + ".pdf");
           // return new ContentResult() { Content = "<script>parent.ShowInModalBox('" + url + "');</script>" };        
        }
        [HttpGet]
        [Authorize]
        public ActionResult MAWBPrintPDF(string MAWB)
        {
            AspPrintPDFAirExportMAWB model = new AspPrintPDFAirExportMAWB() { ManifestTypeList = GetManifestTypesMAWB(MAWB), MAWB = MAWB };
            return View(model);
        }  
        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public ActionResult HBOLPrintPDF(AspPrintPDFOceanExportHBOL model)
        {
            string url = string.Empty;
          
            url = GenerateHBOLPrintUrl(model);
          
            Stream receiveStream = null;
            ELT.COMMON.Util.ReadFileStream(url, ref receiveStream);
            return File(receiveStream, "application/pdf", model.HBOL + ".pdf");
        }
        [HttpGet]
        [Authorize]
        public ActionResult HBOLPrintPDF(string HBOL)
        {
            AspPrintPDFOceanExportHBOL model = new AspPrintPDFOceanExportHBOL() { HBOL = HBOL };
            return View(model);
        }
        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public ActionResult MBOLPrintPDF(AspPrintPDFOceanExportMBOL model)
        {
            string url = string.Empty;
        
            url = GenerateMBOLPrintUrl(model);
            Stream receiveStream = null;
           ELT.COMMON.Util.ReadFileStream(url, ref receiveStream);
           return File(receiveStream, "application/pdf", model.MBOL + ".pdf");
        }
        [HttpGet]
        [Authorize]
        public ActionResult MBOLPrintPDF(string MBOL)
        {
            AspPrintPDFOceanExportMBOL model = new AspPrintPDFOceanExportMBOL() { ManifestTypeList = GetManifestTypesMAWB(MBOL), MBOL = MBOL };
            return View(model);
        }
      
  
        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public ActionResult DmHAWBPrintPDF(AspPrintPDFAirExportDmHAWB model)
        {
            string url = string.Empty;
            model.DmHAWB = Request["DmHAWB"];
            url = GenerateDmHAWBPrintUrl(model);
            Stream receiveStream = null;
            ELT.COMMON.Util.ReadFileStream(url, ref receiveStream);
            return File(receiveStream, "application/pdf", model.DmHAWB + ".pdf");
        }
        [HttpGet]
        [Authorize]
        public ActionResult DmHAWBPrintPDF(string DmHAWB)
        {
            AspPrintPDFAirExportDmHAWB model = new AspPrintPDFAirExportDmHAWB() { DmHAWB = DmHAWB };
            return View(model);
        }
        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public ActionResult DmMAWBPrintPDF(AspPrintPDFAirExportDmMAWB model)
        {
            string url = string.Empty;

            url = GenerateDmMAWBPrintUrl(model);
            Stream receiveStream = null;
            ELT.COMMON.Util.ReadFileStream(url, ref receiveStream);
            return File(receiveStream, "application/pdf", model.DmMAWB + ".pdf");
        }
        [HttpGet]
        [Authorize]
        public ActionResult DmMAWBPrintPDF(string DmMAWB)
        {
            AspPrintPDFAirExportDmMAWB model = new AspPrintPDFAirExportDmMAWB() { ManifestTypeList = GetManifestTypesDmMAWB(DmMAWB), DmMAWB = DmMAWB };
            return View(model);
        }
        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public ActionResult GroundMAWBPrintPDF(AspPrintPDFGroundMAWB model)
        {
            string url = string.Empty;

            url = GenerateGroundMAWBPrintUrl(model);
            Stream receiveStream = null;
            ELT.COMMON.Util.ReadFileStream(url, ref receiveStream);
            return File(receiveStream, "application/pdf", model.MAWB + ".pdf");
        }
        [HttpGet]
        [Authorize]
        public ActionResult GroundMAWBPrintPDF(string MAWB)
        {
            AspPrintPDFGroundMAWB model = new AspPrintPDFGroundMAWB() { MAWB = MAWB };
            return View(model);
        }


        private List<SelectListItem> GetManifestTypesMAWB(string MAWB)
        {
            AirExportBL aeBL = new AirExportBL();

            AuthenticationBL bl = new AuthenticationBL();
            ELTUser authBLGetELTUser = null;
            authBLGetELTUser = bl.GetELTUser( User.Identity.Name);
           
            int ELT_ACCOUNT_NUMBER = Convert.ToInt32(authBLGetELTUser.elt_account_number);
            List<ManifestAgentInfo> agents = aeBL.GetAgentsInMAWB(ELT_ACCOUNT_NUMBER, MAWB);
            List<SelectListItem> items = new List<SelectListItem>();
            items.Add(new SelectListItem { Text = "Consolidated Manifest", Value = "All" });
            foreach (var agent in agents)
            {
                string text = agent.agent_name;
                string value = String.Format("MAWB={0}&Agent={1}&MasterAgentNo=0", MAWB, agent.agent_no);
                items.Add(new SelectListItem { Text = text, Value = HttpUtility.HtmlEncode(value) });
            }

            return items;
        }
        private List<SelectListItem> GetManifestTypesMBOL(string MBOL)
        {

            OceanExportBL oeBL = new OceanExportBL();
            AuthenticationBL bl = new AuthenticationBL();
            ELTUser authBLGetELTUser = null;
            authBLGetELTUser = bl.GetELTUser( User.Identity.Name);
           
            int ELT_ACCOUNT_NUMBER = Convert.ToInt32(authBLGetELTUser.elt_account_number);
            List<ManifestAgentInfo> agents = oeBL.GetAgentsInMBOL(ELT_ACCOUNT_NUMBER, MBOL);
            List<SelectListItem> items = new List<SelectListItem>();
            items.Add(new SelectListItem { Text = "Consolidated Manifest", Value = "All" });
            foreach (var agent in agents)
            {
                string text = agent.agent_name;
                string value = String.Format("MBOL={0}&Agent={1}&MasterAgentNo=0", MBOL, agent.agent_no);
                items.Add(new SelectListItem { Text = text, Value = HttpUtility.HtmlEncode(value) });
            }

            return items;
        }
        private List<SelectListItem> GetManifestTypesDmMAWB(string DmMAWB)
        {

            DomesticFreightBL aeBL = new DomesticFreightBL();
            AuthenticationBL bl = new AuthenticationBL();
            ELTUser authBLGetELTUser = null;
            authBLGetELTUser = bl.GetELTUser( User.Identity.Name);
           
            int ELT_ACCOUNT_NUMBER = Convert.ToInt32(authBLGetELTUser.elt_account_number);
            List<ManifestAgentInfo> agents = aeBL.GetAgentsInDmMAWB(ELT_ACCOUNT_NUMBER, DmMAWB);
            List<SelectListItem> items = new List<SelectListItem>();
            items.Add(new SelectListItem { Text = "Consolidated Manifest", Value = "All" });
            foreach (var agent in agents)
            {
                string text = agent.agent_name;
                string value = String.Format("mawb={0}&Agent={1}&MasterAgentNo=0", DmMAWB, agent.agent_no);
                items.Add(new SelectListItem { Text = text, Value = HttpUtility.HtmlEncode(value) });
            }

            return items;
        }
        private string GenerateMBOLPrintUrl(AspPrintPDFOceanExportMBOL model)
        {
            string url = string.Empty;
            if (model.DocType == "1")
            {
                url = String.Format("/asp/ocean_export/bol_instruction.asp?BookingNum={0}",  model.MBOL, model.PDFCopyType);
                           
            }
            else if (model.DocType == "2")
            {
                if (model.ManifestType == "All")
                {
                    url = String.Format("/asp/ocean_export/manifest_pdf.asp?MBOL={0}",  model.MBOL);
                  

                }
                else if (model.ManifestType != "All")
                {
                    url = String.Format("/asp/ocean_export/manifest_pdf.asp?{0}", model.ManifestType);
                  
                }
            }
          
            return HttpUtility.UrlEncode(url);
        }
        private string GenerateHBOLPrintUrl(AspPrintPDFOceanExportHBOL model)
        {
            string url = string.Empty;
            if (model.DocType == "1")
            {
                url = String.Format("/asp/ocean_export/hbol_pdf.asp?hbol={0}&Copy={1}",  model.HBOL, model.PDFCopyType);
                             
            }
            else if (model.DocType == "2")
            {
                url = String.Format("/asp/ocean_export/print_rider.asp?vMaster={0}",  model.HBOL, model.PDFCopyType);
                            
            }
          
            return HttpUtility.UrlEncode(url);
        }
        private string GenerateMAWBPrintUrl(AspPrintPDFAirExportMAWB model)
        {
            string url = string.Empty;
            if (model.DocType == "1")
            {
                url = String.Format("/asp/air_export/mawb_pdf.asp?MAWB={0}&Copy={1}",  model.MAWB, model.PDFCopyType);
                           
            }
            else if (model.DocType == "2")
            {
                string AddInfo = "&AddInfo=";
                if (model.IncludeAdditionalInfo)
                {
                    AddInfo = AddInfo + "Y";
                }
                else
                {
                    AddInfo = AddInfo + "N";
                }
                if (model.ManifestType == "All")
                {
                    url = String.Format("/asp/air_export/manifest_pdf.asp?MAWB={0}", model.MAWB);
                  
                }
                else if (model.ManifestType != "All")
                {
                    url = String.Format("/asp/air_export/manifest_pdf.asp?{0}",   model.ManifestType);
                  
                }
                url = url + AddInfo;
              

            }
            else if (model.DocType == "3")
            {
                if (model.IACType == "U")
                {
                    url = String.Format("/asp/air_export/iac_unknow_pdf.asp?MAWB={0}",  model.MAWB);
                  
                }
                else
                {
                    url = String.Format("/asp/air_export/iac_pdf.asp?MAWB={0}",  model.MAWB);
                  
                }
            }
          
            return HttpUtility.UrlEncode(url);
        }
        private string GenerateHAWBPrintUrl(AspPrintPDFAirExportHAWB model)
        {
            string url = string.Empty;
            if (model.DocType == "1")
            {
                url = String.Format("/asp/air_export/hawb_pdf.asp?HAWB={0}&Copy={1}",  model.HAWB, model.PDFCopyType);
              
          
            }
            else if (model.DocType == "2")
            {
                url = String.Format("/asp/air_export/print_rider.asp?vMaster={0}",  model.HAWB, model.PDFCopyType);              
            }
        
            return HttpUtility.UrlEncode(url);
        }
        private string GenerateDmMAWBPrintUrl(AspPrintPDFAirExportDmMAWB model)
        {
            string url = string.Empty;
            if (model.DocType == "1")
            {
                url = String.Format("/asp/domestic/mawb_pdf.asp?mawb={0}&Copy={1}",  model.DmMAWB, model.PDFCopyType);
              
              //  url = url);
            }
            else if (model.DocType == "2")
            {
                string AddInfo = "&AddInfo=";
                if (model.IncludeAdditionalInfo)
                {
                    AddInfo = AddInfo + "Y";
                }
                else
                {
                    AddInfo = AddInfo + "N";
                }
                if (model.ManifestType == "All")
                {
                    url = String.Format("/asp/domestic/manifest_pdf.asp?mawb={0}",  model.DmMAWB);
                  

                }
                else if (model.ManifestType != "All")
                {
                    url = String.Format("/asp/domestic/manifest_pdf.asp?{0}",   model.ManifestType);
                  
                }
                url = url + AddInfo;
               // url = url);

            }
            else if (model.DocType == "3")
            {
                if (model.IACType == "K")
                {
                    url = String.Format("/asp/domestic/iac_unknow_pdf.asp?mawb={0}", model.DmMAWB);
                 
                }
                else
                {
                    url = String.Format("/asp/domestic/iac_pdf.asp?mawb={0}", model.DmMAWB);
                  
                }
            }
          
            return HttpUtility.UrlEncode(url);
        }
        private string GenerateDmHAWBPrintUrl(AspPrintPDFAirExportDmHAWB model)
        {
            string url = string.Empty;
            if (model.DocType == "1")
            {
                url = String.Format("/asp/domestic/hawb_pdf.asp?hawb={0}&Copy={1}", model.DmHAWB, model.PDFCopyType);
              
       
            }
            else if (model.DocType == "2")
            {
                url = String.Format("/asp/domestic/print_rider.asp?vMaster={0}", model.DmHAWB, model.PDFCopyType);            
            }
          
            return HttpUtility.UrlEncode(url);
        }
        private string GenerateGroundMAWBPrintUrl(AspPrintPDFGroundMAWB model)
        {
            string url = string.Empty;
            if (model.DocType == "1")
            {
                url = String.Format("/asp/domestic/ground_mawb_pdf.asp?MAWB={0}&Copy={1}", model.MAWB, model.PDFCopyType);
            }          
            return HttpUtility.UrlEncode(url);
        }
       

    }
}
