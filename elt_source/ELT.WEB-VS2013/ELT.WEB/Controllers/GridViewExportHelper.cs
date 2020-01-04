using System;
using System.Linq;
using System.Web.Mvc;
using ELT.BL;
using ELT.WEB.Models;
using ELT.CDT;
using System.Collections.Generic;
using DevExpress.Web.Mvc;
using DevExpress.Web.ASPxGridView;

namespace ELT.WEB.Controllers
{
    public class GridViewExportHelper
    {        static Dictionary<string, ExportType> exportTypes;
        public static Dictionary<string, ExportType> ExportTypes
        {
            get
            {
                if (exportTypes == null)
                    exportTypes = CreateExportTypes();
                return exportTypes;
            }
        }
        static Dictionary<string, ExportType> CreateExportTypes()
        {
            Dictionary<string, ExportType> types = new Dictionary<string, ExportType>();
            //types.Add("PDF", new ExportType { Title = "Export to PDF", Method = GridViewExtension.ExportToPdf });
            types.Add("XLS", new ExportType { Title = "Export to XLS", Method = GridViewExtension.ExportToXls });
            types.Add("XLSX", new ExportType { Title = "Export to XLSX", Method = GridViewExtension.ExportToXlsx });
            types.Add("RTF", new ExportType { Title = "Export to RTF", Method = GridViewExtension.ExportToRtf });
            types.Add("CSV", new ExportType { Title = "Export to CSV", Method = GridViewExtension.ExportToCsv });
            return types;
        }
    }
}
