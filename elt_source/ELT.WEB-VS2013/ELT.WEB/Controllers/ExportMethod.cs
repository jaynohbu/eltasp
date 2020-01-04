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
    public delegate ActionResult ExportMethod(GridViewSettings settings, object dataObject);
}
