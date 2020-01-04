using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.DA;
using ELT.CDT;
using System.Web;
namespace ELT.BL
{
    public class BillNumberListBL
    {
        public List<TextValuePair> GetHAWBNos(string ELT_account_number, string PortDirection)
        {
            BillNumberListDA da = new BillNumberListDA();
            return da.GetHAWBNos(ELT_account_number, PortDirection);
        }
        public List<TextValuePair> GetMAWBNos(string ELT_account_number, string PortDirection)
        {
            BillNumberListDA da = new BillNumberListDA();
            return da.GetMAWBNos(ELT_account_number, PortDirection);           
        }    
        public List<TextValuePair> GetHBOLNos(string ELT_account_number, string PortDirection)
        {
            BillNumberListDA da = new BillNumberListDA();
            return da.GetHBOLNos(ELT_account_number, PortDirection);
        }
        public List<TextValuePair> GetMBOLNos(string ELT_account_number, string PortDirection)
        {
            BillNumberListDA da = new BillNumberListDA();
            return da.GetMBOLNos(ELT_account_number, PortDirection);
        }
        public List<TextValuePair> GetAirImportFileNumbers(string ELT_account_number)
        {
            BillNumberListDA da = new BillNumberListDA();
            return da.GetImportFileNumbers(ELT_account_number, "A");
        }
        public List<TextValuePair> GetOceanImportFileNumbers(string ELT_account_number)
        {
            BillNumberListDA da = new BillNumberListDA();
            return da.GetImportFileNumbers(ELT_account_number, "O" );
        }
        public List<TextValuePair> GetAirExportFileNumbers(string ELT_account_number)
        {
            BillNumberListDA da = new BillNumberListDA();
            return da.GetAirExportFileNumbers(ELT_account_number);
        }
        public List<TextValuePair> GetOceanExportFileNumbers(string ELT_account_number)
        {
            BillNumberListDA da = new BillNumberListDA();
            return da.GetOceanExportFileNumbers(ELT_account_number);
        } 
    }
}
