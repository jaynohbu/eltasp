using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.CDT;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Reflection;
using ELT.COMMON;
using ELT.CDT;
using System.Web;

namespace ELT.DA
{
    public class OperationSearchDA
    {
        //
        public List<AESearchItem> GetAESearchItems()
        {
            List<AESearchItem> list = new List<AESearchItem>();
            if (HttpContext.Current.Session["AESearchItems"] != null)
            {
                DataSet ds = HttpContext.Current.Session["AESearchItems"] as DataSet;
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    AESearchItem item = new AESearchItem();
                    item.aes_xtn = Convert.ToString(ds.Tables[0].Rows[i]["aes_xtn"]);
                    item.Agent_name = Convert.ToString(ds.Tables[0].Rows[i]["Agent_name"]);
                    item.Agent_No = Convert.ToString(ds.Tables[0].Rows[i]["Agent_No"]);
                    item.Carrier_Desc = Convert.ToString(ds.Tables[0].Rows[i]["Carrier_Desc"]);
                    item.Consignee_acct_num = Convert.ToString(ds.Tables[0].Rows[i]["Consignee_acct_num"]);
                    item.consignee_name = Convert.ToString(ds.Tables[0].Rows[i]["consignee_name"]);
                    item.CreatedDate = Convert.ToString(ds.Tables[0].Rows[i]["CreatedDate"]);
                    item.Departure_Airport = Convert.ToString(ds.Tables[0].Rows[i]["Departure_Airport"]);
                    item.Dest_Airport = Convert.ToString(ds.Tables[0].Rows[i]["Dest_Airport"]);
                    item.file_No = Convert.ToString(ds.Tables[0].Rows[i]["file#"]);
                    item.HAWB_NUM = Convert.ToString(ds.Tables[0].Rows[i]["HAWB_NUM"]);
                    item.is_master = Convert.ToString(ds.Tables[0].Rows[i]["is_master"]);
                    item.is_master_closed = Convert.ToString(ds.Tables[0].Rows[i]["is_master_closed"]);
                    item.is_sub = Convert.ToString(ds.Tables[0].Rows[i]["is_sub"]);
                    item.lastF_No = Convert.ToString(ds.Tables[0].Rows[i]["lastF#"]);
                    item.MasterNo = Convert.ToString(ds.Tables[0].Rows[i]["MasterNo"]);
                    item.SalesPerson = Convert.ToString(ds.Tables[0].Rows[i]["SalesPerson"]);
                    item.shipper_account_number = Convert.ToString(ds.Tables[0].Rows[i]["shipper_account_number"]);
                    item.Shipper_Name = Convert.ToString(ds.Tables[0].Rows[i]["Shipper_Name"]);
                    item.Type = Convert.ToString(ds.Tables[0].Rows[i]["Type"]);
                    item.used = Convert.ToString(ds.Tables[0].Rows[i]["used"]);
                   
                }
            }
            return list;
        }
    }
}
