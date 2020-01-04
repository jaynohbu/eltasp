using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using ELT.DA;
namespace ELT.BL
{
    public class GlBL
    {
        GlDA da = new GlDA();            
        public DataSet PerformSearch()
        {
            string[] str = new string[4];

            string strlblBranch = Convert.ToString(HttpContext.Current.Session["strlblBranch"]);
            string strBranch = Convert.ToString(HttpContext.Current.Session["strBranch"]);
            string nBranch = Convert.ToString(HttpContext.Current.Session["Branch"]);
            string sPeriod = Convert.ToString(HttpContext.Current.Session["Accounting_sPeriod"]);
            string sBranchName = Convert.ToString(HttpContext.Current.Session["Accounting_sBranchName"]);
            string sBranch_elt_account_number = Convert.ToString(HttpContext.Current.Session["Accounting_sBranch_elt_account_number"]);
            string sCompanName = Convert.ToString(HttpContext.Current.Session["Accounting_sCompanName"]);
            string p_Code = Convert.ToString(HttpContext.Current.Session["Accounting_sSelectionParam"]);
            return da.PerformGet(p_Code, nBranch);
        }
       
    }
}
