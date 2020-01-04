using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
   public class AESearchItem
    {
        public string HAWB_NUM { get; set; }
        public string MasterNo { get; set; }
        public string file_No { get; set; }
        public string Carrier_Desc { get; set; }
        public string aes_xtn { get; set; }
        public string is_sub { get; set; }
        public string Status { get; set; }
        public string used { get; set; }
        public string is_master { get; set; }
        public string Shipper_Name { get; set; }
        public string shipper_account_number { get; set; }
        public string Consignee_acct_num { get; set; }
        public string Agent_No { get; set; }
        public string consignee_name { get; set; }
        public string Agent_name { get; set; }
        public string lastF_No { get; set; }
        public string SalesPerson { get; set; }
        public string is_master_closed { get; set; }
        public string Departure_Airport { get; set; }
        public string Dest_Airport { get; set; }
        public string Type { get; set; }
        public string CreatedDate { get; set; }
    }

   public class OESearchItem
   {

       public string houseNo { get; set; }
       public string booking_num { get; set; }
       public string MasterNo { get; set; }
       public string file_No { get; set; }
       public string shipper_name { get; set; }
       public string shipper_no { get; set; }
       public string measurement { get; set; }
       public string consignee_name { get; set; }
       public string consignee_no { get; set; }
       public string is_master { get; set; }
       public string is_sub { get; set; }
       public string lastF_No { get; set; }
       public string agent { get; set; }
       public string agent_no { get; set; }
       public string p1 { get; set; }
       public string p2 { get; set; }
       public string Type { get; set; }
       public string CreatedDate { get; set; }

   }

   public class OISearchItem
   {

       public string hawb_num { get; set; }
       public string lastF_No { get; set; }
       public string masterNo { get; set; }
       public string file_No { get; set; }
       public string sec { get; set; }
       public string Shipper_name { get; set; }
       public string Shipper_acct { get; set; }
       public string consignee_name { get; set; }
       public string p1 { get; set; }
       public string p2 { get; set; }
       public string iType { get; set; }
       public string agent_org_acct { get; set; }
       public string consignee_acct { get; set; }
       public string CreatedDate { get; set; }
 



   }


   public class AISearchItem
   {
       public string hawb_num { get; set; }
       public string lastF_No { get; set; }
       public string masterNo { get; set; }
       public string file_No { get; set; }
       public string sec { get; set; }
       public string Shipper_name { get; set; }
       public string Shipper_acct { get; set; }
       public string consignee_name { get; set; }
       public string p1 { get; set; }
       public string p2 { get; set; }
       public string iType { get; set; }
       public string agent_org_acct { get; set; }
       public string consignee_acct { get; set; }
       public string CreatedDate { get; set; }

       






   }


}
