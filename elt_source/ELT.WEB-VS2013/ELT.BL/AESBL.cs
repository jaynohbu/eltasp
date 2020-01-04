using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.CDT;
using ELT.DA;

namespace ELT.BL
{
    public class AESBL
    {
        AESDA da = new AESDA();
       
     
        public ScheduleBItem GetScheduleB(string elt_account_number, string description)
        {
            //description,sb
            return da.GetScheduleB(elt_account_number, description);
        }
        public List<AESLineItem> GetAESLineItems(int AesID, int ELT_ACCOUNT_NUMBER, string MAWB, string HAWB, string FileType)
        {
            AESDA AESDA = new AESDA();
            return AESDA.GetAESLineItems(AesID, ELT_ACCOUNT_NUMBER, MAWB, HAWB, FileType);
        }

        public void InsertAESLineItem(AESLineItem AESAirLineItem)
        {
            AESDA AESDA = new AESDA();
            AESDA.InsertAESLineItem(AESAirLineItem);
        }
        public void DeleteAESLineItem(int ID) { AESDA AESDA = new AESDA(); AESDA.DeleteAESLineItem(ID); }
        public void UpdateAESLineItem(AESLineItem AESAirLineItem)
        {
            AESDA AESDA = new AESDA();
            AESDA.UpdateAESLineItem(AESAirLineItem);
        }

       

    }
}
