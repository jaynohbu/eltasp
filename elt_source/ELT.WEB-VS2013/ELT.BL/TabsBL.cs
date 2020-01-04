using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.CDT;
using ELT.DA;

namespace ELT.BL
{
    public class TabsBL
    {
        public List<TabItem> GetAllFavoriteTabItem(string elt_account_number, string userid)
        {
            TabsDA da = new TabsDA();
            return da.GetAllFavoriteTabItem(elt_account_number, userid);
        }
    }
}
