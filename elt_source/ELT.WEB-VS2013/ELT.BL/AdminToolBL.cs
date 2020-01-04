using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.CDT;
using ELT.DA;
namespace ELT.BL
{

    public class AdminToolBL
    {       
        public List<ELTUser> GetAllELTUsers()
        { 
            AdminToolDA da = new AdminToolDA();
            return da.GetAllELTUsers();
        }

        public void UpdateLoginName(int elt_account_number, int userid, string email)
        {
            AdminToolDA da = new AdminToolDA();
            da.UpdateLoginName(elt_account_number,  userid,  email);
        }
    }
}
