using ELT.CDT;
using System;
using System.Collections.Generic;

using System.Linq;
using System.Text;
using ELT.DA;
using System.Web;
namespace ELT.BL
{
    public class CodeListBL
    {

        public List<TextValuePair> GetCarrierList()
        {
            int elt_account_number = int.Parse(HttpContext.Current.Request.Cookies["CurrentUserInfo"]["elt_account_number"]);
            CodeListDA CodeListDA = new CodeListDA();
            return CodeListDA.GetCarrierList(elt_account_number);

        }
        public List<TextValuePair> GetPortList()
        {
            int elt_account_number = int.Parse(HttpContext.Current.Request.Cookies["CurrentUserInfo"]["elt_account_number"]);
            CodeListDA CodeListDA = new CodeListDA();
            return CodeListDA.GetPortList(elt_account_number);
        }      

    }
}
