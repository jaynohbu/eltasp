using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    [Serializable]
    public class PNLTransactionItem
    {
        public string Type { get; set; }
        public string ImportExport { get; set; }
        public string AirOcean { get; set; }
        public string Master_House { get; set; }
        public string MBL_NUM { get; set; }
        public string HBL_NUM { get; set; }
        public string elt_account_number { get; set; }
        public string Item_Code { get; set; }
        public string Description { get; set; }
        public int Customer_ID { get; set; }
        public int ID{get;set;}
        public string  Customer_Name{get;set;}
        public decimal Profit { get { return Revenue - Expense; } }
        public decimal Revenue { get; set; }
        public decimal Expense { get; set; }
        public string Origin { get; set; }
        public string ORIGIN { get; set; }
        public string DEST { get; set; }
        public string Date { get; set; }
        public string MBL_LINK { get {

            if (AirOcean == "A" && ImportExport == "E")
            {
                return string.Format("~/ASP/air_export/new_edit_mawb.asp?MAWB={0}&WindowName=popUpWindow", MBL_NUM);
            }
            if (AirOcean == "A" && ImportExport == "I")
            {
                return string.Format("~/ASP/air_export/new_edit_mawb.asp?MAWB={0}&WindowName=popUpWindow", MBL_NUM);
            }
            if (AirOcean == "O" && ImportExport == "E")
            {
                return string.Format("~/ASP/Ocean_export/new_edit_mbol.asp?BookingNum={0}&WindowName=popUpWindow ", MBL_NUM);
            }
            if (AirOcean == "O" && ImportExport == "I")
            {
                return string.Format("~/ASP/ocean_import/ocean_import2.asp?iType=O&Edit=yes&MAWB={0}&Sec=1&AgentOrgAcct={1}&WindowName=popUpWindow ", MBL_NUM, Customer_ID);
            }
            return "";
        } }
        public string HBL_LINK
        {
            get
            {
                if (AirOcean == "A" && ImportExport == "E")
                {
                    return string.Format("~/ASP/air_export/new_edit_hawb.asp?Edit=yes&hawb={0}&WindowName=popUpWindow", HBL_NUM);
                }
                if (AirOcean == "A" && ImportExport == "I")
                {
                    return string.Format("~/ASP/air_import/arrival_notice.asp?iType=A&Edit=yes&AgentOrgAcct={0}&MAWB={1}&HAWB={2}&Sec=1&WindowName=popUpWindow ",Customer_ID,MBL_NUM, HBL_NUM);
                }
                if (AirOcean == "O" && ImportExport == "E")
                {
                    return string.Format("~/ASP/Ocean_export/new_edit_hbol.asp?hbol={0}&WindowName=popUpWindow", HBL_NUM);
                }
                if (AirOcean == "O" && ImportExport == "I")
                {
                    return string.Format("~/ASP/ocean_import/arrival_notice.asp?iType=O&Edit=yes&AgentOrgAcct={0}&MAWB={1}&HAWB={2}&Sec=1 ", Customer_ID, MBL_NUM, HBL_NUM);
                }
                return "";
            }
        }
    }
 
}
