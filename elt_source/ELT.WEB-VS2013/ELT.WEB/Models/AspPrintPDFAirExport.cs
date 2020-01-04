using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ELT.COMMON;
using ELT.CDT;
using System.Web.Mvc;
namespace ELT.WEB.Models
{
    
     [Serializable]
    public class AspPrintPDFGroundMAWB
    {

         public AspPrintPDFGroundMAWB()
         {
           
        }

       
        public string MAWB
        {
            get;
            set;
        }

       
        public string DocType
        {
            get;
            set;
        }      
      
     
        public string PDFCopyType
        {
            get;
            set;
        }
      
        public List<SelectListItem> PDFCopyTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Shipper Copy", Value = "SHIPPER" });               
                items.Add(new SelectListItem { Text = "Consignee Copy", Value = "CONSIGNEE" });              
                return items;
            }
        }
        public List<SelectListItem> DocTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Select Document Type", Value = "0" });
                items.Add(new SelectListItem { Text = "PDF", Value = "1" });              
                return items;
            }
        }
        public List<SelectListItem> ManifestTypeList
        {
            get;
            set;
        }
    }

    [Serializable]
    public class AspPrintPDFAirExportMAWB
    {
       
        public AspPrintPDFAirExportMAWB(){
            ManifestTypeList = new List<SelectListItem>();
        }

        public bool IncludeAdditionalInfo
        {
            get;
            set;
        }
        public string MAWB
        {
            get;
            set;
        }

        public string HAWB
        {
            get;
            set;
        }  
        public string DocType
        {
            get;
            set;
        }      
      
        public string ManifestType
        {
            get;
            set;
        }
        public string IACType
        {
            get;
            set;
        }
        public string PDFCopyType
        {
            get;
            set;
        }
        public List<SelectListItem> IACTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Known Shipper", Value = "K" });
                items.Add(new SelectListItem { Text = "Unknown Shipper", Value = "U" });
                return items;
            }
        }
        public List<SelectListItem> PDFCopyTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Shipper Copy", Value = "SHIPPER" });
                items.Add(new SelectListItem { Text = "Shipper Copy with IATA Terms", Value = "SHIPPER&IATA=Y" });
                items.Add(new SelectListItem { Text = "Consignee Copy", Value = "CONSIGNEE" });
                items.Add(new SelectListItem { Text = "Consignee Copy with IATA Terms", Value = "CONSIGNEE&IATA=Y" });
                items.Add(new SelectListItem { Text = "Issuing Copy", Value = "CARRIER" });
                items.Add(new SelectListItem { Text = "Issuing Copy with IATA Terms", Value = "CARRIER&IATA=Y" });
                items.Add(new SelectListItem { Text = "Copy", Value = "COPY" });
                items.Add(new SelectListItem { Text = "Copy with IATA Terms", Value = "COPY&IATA=Y" });
                return items;
            }
        }
        public List<SelectListItem> DocTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Select Document Type", Value = "0" });
                items.Add(new SelectListItem { Text = "PDF", Value = "1" });
                items.Add(new SelectListItem { Text = "Manifest", Value = "2" });
                items.Add(new SelectListItem { Text = "IAC", Value = "3" });
                return items;
            }
        }
        public List<SelectListItem> ManifestTypeList
        {
            get;
            set;
        }
    }
    [Serializable]
    public class AspPrintPDFAirExportHAWB
    {

        public AspPrintPDFAirExportHAWB()
        {
           
        }

        public bool IncludeAdditionalInfo
        {
            get;
            set;
        }
        public string MAWB
        {
            get;
            set;
        }

        public string HAWB
        {
            get;
            set;
        }
        public string DocType
        {
            get;
            set;
        }       
       
        public string PDFCopyType
        {
            get;
            set;
        }
        
        public List<SelectListItem> PDFCopyTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Shipper Copy", Value = "SHIPPER" });
                items.Add(new SelectListItem { Text = "Shipper Copy with IATA Terms", Value = "SHIPPER&IATA=Y" });
                items.Add(new SelectListItem { Text = "Consignee Copy", Value = "CONSIGNEE" });
                items.Add(new SelectListItem { Text = "Consignee Copy with IATA Terms", Value = "CONSIGNEE&IATA=Y" });
               
                return items;
            }
        }
        public List<SelectListItem> DocTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Select Document Type", Value = "0" });
                items.Add(new SelectListItem { Text = "PDF", Value = "1" });
                items.Add(new SelectListItem { Text = "Rider", Value = "2" });               
                return items;
            }
        }
       
    }
    [Serializable]
    public class AspPrintPDFAirExportDmMAWB
    {

        public AspPrintPDFAirExportDmMAWB()
        {
            ManifestTypeList = new List<SelectListItem>();
        }

        public bool IncludeAdditionalInfo
        {
            get;
            set;
        }
        public string DmMAWB
        {
            get;
            set;
        }

        public string DmHAWB
        {
            get;
            set;
        }
        public string DocType
        {
            get;
            set;
        }

        public string ManifestType
        {
            get;
            set;
        }
        public string IACType
        {
            get;
            set;
        }
        public string PDFCopyType
        {
            get;
            set;
        }
        public List<SelectListItem> IACTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Known Shipper", Value = "K" });
                items.Add(new SelectListItem { Text = "Unknown Shipper", Value = "U" });
                return items;
            }
        }
        public List<SelectListItem> PDFCopyTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Shipper Copy", Value = "SHIPPER" });
                items.Add(new SelectListItem { Text = "Consignee Copy", Value = "CONSIGNEE" });
              
                return items;
            }
        }
        public List<SelectListItem> DocTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Select Document Type", Value = "0" });
                items.Add(new SelectListItem { Text = "PDF", Value = "1" });
                items.Add(new SelectListItem { Text = "Manifest", Value = "2" });
                items.Add(new SelectListItem { Text = "IAC", Value = "3" });
                return items;
            }
        }
        public List<SelectListItem> ManifestTypeList
        {
            get;
            set;
        }
    }
    [Serializable]
    public class AspPrintPDFAirExportDmHAWB
    {

        public AspPrintPDFAirExportDmHAWB()
        {

        }

        public bool IncludeAdditionalInfo
        {
            get;
            set;
        }
        public string DmMAWB
        {
            get;
            set;
        }

        public string DmHAWB
        {
            get;
            set;
        }
        public string DocType
        {
            get;
            set;
        }

        public string PDFCopyType
        {
            get;
            set;
        }

        public List<SelectListItem> PDFCopyTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Shipper Copy", Value = "SHIPPER" });
                items.Add(new SelectListItem { Text = "Consignee Copy", Value = "CONSIGNEE" });
                return items;
            }
        }
        public List<SelectListItem> DocTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Select Document Type", Value = "0" });
                items.Add(new SelectListItem { Text = "PDF", Value = "1" });
                //items.Add(new SelectListItem { Text = "Rider", Value = "2" });
                return items;
            }
        }

    }
    [Serializable]
    public class AspPrintPDFOceanExportMBOL
    {

        public AspPrintPDFOceanExportMBOL()
        {
            ManifestTypeList = new List<SelectListItem>();
        }

        public bool IncludeAdditionalInfo
        {
            get;
            set;
        }
        public string MBOL
        {
            get;
            set;
        }

        public string HBOL
        {
            get;
            set;
        }
        public string DocType
        {
            get;
            set;
        }

        public string ManifestType
        {
            get;
            set;
        }
        public string IACType
        {
            get;
            set;
        }
        public string PDFCopyType
        {
            get;
            set;
        }
        public List<SelectListItem> IACTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Known Shipper", Value = "K" });
                items.Add(new SelectListItem { Text = "Unknown Shipper", Value = "U" });
                return items;
            }
        }

        public List<SelectListItem> DocTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Select Document Type", Value = "0" });
                items.Add(new SelectListItem { Text = "PDF", Value = "1" });
                items.Add(new SelectListItem { Text = "Manifest", Value = "2" });              
                return items;
            }
        }
        public List<SelectListItem> ManifestTypeList
        {
            get;
            set;
        }
    }
    [Serializable]
    public class AspPrintPDFOceanExportHBOL
    {

        public AspPrintPDFOceanExportHBOL()
        {

        }

        public bool IncludeAdditionalInfo
        {
            get;
            set;
        }
        public string MBOL
        {
            get;
            set;
        }

        public string HBOL
        {
            get;
            set;
        }
        public string DocType
        {
            get;
            set;
        }

        public string PDFCopyType
        {
            get;
            set;
        }

        public List<SelectListItem> PDFCopyTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Non-Negotiable", Value = "Non-Negotiable" });
                items.Add(new SelectListItem { Text = "Original", Value = "Original" });
              
                return items;
            }
        }
        public List<SelectListItem> DocTypeList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Select Document Type", Value = "0" });
                items.Add(new SelectListItem { Text = "PDF", Value = "1" });
               // items.Add(new SelectListItem { Text = "Rider", Value = "2" });
                return items;
            }
        }

    }
}