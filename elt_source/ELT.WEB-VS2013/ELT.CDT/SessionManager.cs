using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace ELT.COMMON
{
    public class SessionManager
    {
       public void  ClearReportSessionVars(){

          HttpContext.Current.Session["HEADER"] = null;
          HttpContext.Current.Session["DETAIL"] = null;
          HttpContext.Current.Session["strlblBranch"] = null;
          HttpContext.Current.Session["strBranch"] = null;
          HttpContext.Current.Session["Accounting_sPeriod"] = null;
          HttpContext.Current.Session["Accounting_sBranchName"] = null;
          HttpContext.Current.Session["Accounting_sBranch_elt_account_number"] = null;
          HttpContext.Current.Session["Accounting_sCompanName"] = null;
          HttpContext.Current.Session["Accounting_sReportTitle"] = null;
          HttpContext.Current.Session["Accounting_sSelectionParam"] = null;
          HttpContext.Current.Session["Branch"] = null;
          HttpContext.Current.Session["AsOf"] = null;
          HttpContext.Current.Session["APDisputeDS"] = null;
        }
    }
}
