using System;
using System.Collections.Generic;
using System.Web;
using ELT.CDT;
using System.Linq;
namespace ELT.BL
{
    public class AESManager
    {
        int ELT_ACCOUNT_NUMBER;
        public List<AESLineItem> GetAESLineItems(int AesID, string MAWB, string HAWB, string FileType)
        {
            if(HttpContext.Current.Session["AESLineItems"]!=null){
                return (List<AESLineItem>)HttpContext.Current.Session["AESLineItems"];
            }
            AESBL AESBL = new AESBL();
            var AirAESLineItems = AESBL.GetAESLineItems(AesID, ELT_ACCOUNT_NUMBER, MAWB, HAWB, FileType);
            HttpContext.Current.Session["AESLineItems"]=AirAESLineItems;
            return AirAESLineItems;
        }

        public void InsertAESLineItem(AESLineItem AESAirLineItem)
        {
            AirExportBL AirExportBL = new AirExportBL();
            AESAirLineItem.ELT_ACCOUNT_NUMBER = ELT_ACCOUNT_NUMBER;
            var AirAESLineItems = (List<AESLineItem>)HttpContext.Current.Session["AESLineItems"];
            AirAESLineItems.Add(AESAirLineItem);
        }
        public void DeleteAESLineItem(AESLineItem AESAirLineItem)
        {
            AirExportBL AirExportBL = new AirExportBL();
            var AirAESLineItems = (List<AESLineItem>)HttpContext.Current.Session["AESLineItems"];        
            if (HttpContext.Current.Session["AESLineItemsToDelete"] == null)
            {               
                HttpContext.Current.Session["AESLineItemsToDelete"] = new List<int>();
            }

            var AirAESLineItemsToDelete = (List<int>)HttpContext.Current.Session["AESLineItemsToDelete"];

            var item = (from c in AirAESLineItems where c.ID == AESAirLineItem.ID select c).Single();
            AirAESLineItemsToDelete.Add(item.ID);
            AirAESLineItems.Remove(item);
          
        }
        public void UpdateAESLineItem(AESLineItem AESAirLineItem)
        {
            AirExportBL AirExportBL = new AirExportBL();
            AESAirLineItem.ELT_ACCOUNT_NUMBER = ELT_ACCOUNT_NUMBER;
            var AirAESLineItems = (List<AESLineItem>)HttpContext.Current.Session["AESLineItems"];    
            var item = (from c in AirAESLineItems where c.ID == AESAirLineItem.ID select c).Single();
            item.IsModified = true;
            item.GrossWeight = AESAirLineItem.GrossWeight;
            item.ExportCode = AESAirLineItem.ExportCode;
            item.ECCN = AESAirLineItem.ECCN;
            item.ID = AESAirLineItem.ID;
            item.ItemDesc = AESAirLineItem.ItemDesc;
            item.ScheduleB = AESAirLineItem.ScheduleB;
            item.Unit1 = AESAirLineItem.Unit1;
            item.Unit2 = AESAirLineItem.Unit2;
            item.VehicleID = AESAirLineItem.VehicleID;
            item.VehicleIDType = AESAirLineItem.VehicleIDType;
            item.VehicleTitle = AESAirLineItem.VehicleTitle;
            item.VihicleState = AESAirLineItem.VihicleState;
            item.Qty1 = AESAirLineItem.Qty1;
            item.Qty2 = AESAirLineItem.Qty2;
            item.Origin = AESAirLineItem.Origin;
            item.LicenseType = AESAirLineItem.LicenseType;
            item.LicenseNumber = AESAirLineItem.LicenseNumber;
            item.ItemNo = AESAirLineItem.ItemNo;
            item.ItemDesc = AESAirLineItem.ItemDesc;
            item.VehicleID = AESAirLineItem.VehicleID;
            item.VehicleIDType = AESAirLineItem.VehicleIDType;
            item.ItemValue = AESAirLineItem.ItemValue;

          
        }

        public AESManager()
        {
            ELT_ACCOUNT_NUMBER = Convert.ToInt32(HttpContext.Current.Request.Cookies["CurrentUserInfo"]["elt_account_number"]);
        }
    }
}
