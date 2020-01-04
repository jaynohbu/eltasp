using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.CDT;
using ELT.DA;

namespace ELT.BL
{
    public class ClientProfileBL
    {
        public List<ClientProfile> GetClientList(int elt_account_number)
        {
            ClientProfileDA da = new ClientProfileDA();
            return da.GetClientList(elt_account_number);
        }
        public ClientProfile GetClient(int elt_account_number, int org_account_number)
        {
            ClientProfileDA da = new ClientProfileDA();
            return da.GetClient(elt_account_number, org_account_number);
        }

        public void CreateNewClientFileFolder(string email)
        {
            ClientProfileDA da = new ClientProfileDA();
            da.CreateNewClientFileFolder( email);
        }
    }
}
