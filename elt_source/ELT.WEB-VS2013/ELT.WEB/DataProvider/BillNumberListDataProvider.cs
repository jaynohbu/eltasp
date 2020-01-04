using System.Collections.Generic;
using System.Linq;
using System.Web;
using DevExpress.Web.ASPxEditors;
using ELT.BL;
using ELT.CDT;

namespace ELT.WEB.DataProvider
{
    public static class BillNumberListDataProvider
    {
        public static object GetAirExportBillRange(ListEditItemsRequestedByFilterConditionEventArgs args)
        {  
            var skip = args.BeginIndex;
            var take = args.EndIndex - args.BeginIndex + 1;
            var BillNos = GetAirExportBillNos();

            if (args.Filter != "")
            {
                var selected = (from item in BillNos
                                where (item.Value).StartsWith(args.Filter)
                                orderby item.Value
                                select item
                        ).Skip(skip).Take(take);
                return selected.ToList();
            }
            else
            {
                var selected = (from item in BillNos
                                orderby item.Value
                                select item
                       ).Take(take);
                return selected.ToList(); 
            }
           
        }
        public static object GetAirExportBillByID(ListEditItemRequestedByValueEventArgs args)
        {           
            if (args.Value == null||args.Value == "")
                return GetAirExportBillNos();
            var BillNos = GetAirExportBillNos();
            return BillNos.Where(p => p.Value == args.Value).Take(1);
        }
        public static List<TextValuePair> GetAirExportBillNos()
        {
            string sel = "0";
            BillNumberListBL BL = new BillNumberListBL();
             System.Collections.Generic.List<TextValuePair> BillNos=new System.Collections.Generic.List<TextValuePair>  ();
            if (HttpContext.Current.Session["mailerSelectedBillType"] != null)
            {
                sel = HttpContext.Current.Session["mailerSelectedBillType"].ToString();
               
            }
            string elt_account_number = HttpContext.Current.Session["elt_account_number"].ToString();
           // ELTUser authBLGetELTUser =(ELTUser)HttpContext.Current.Session["authBLGetELTUser"];
            if(sel=="1")
                BillNos = BL.GetHAWBNos(elt_account_number,"Export");
            else if (sel == "2")
                BillNos = BL.GetMAWBNos(elt_account_number,"Export");
            else if (sel == "3")
                BillNos = BL.GetAirExportFileNumbers(elt_account_number);
            return BillNos;
        }
        public static object GetOceanExportBillRange(ListEditItemsRequestedByFilterConditionEventArgs args)
        {
            var skip = args.BeginIndex;
            var take = args.EndIndex - args.BeginIndex + 1;
            var BillNos = GetOceanExportBillNos();
            if (args.Filter != "")
            {
                var selected = (from item in BillNos
                                where (item.Value).StartsWith(args.Filter)
                                orderby item.Value
                                select item
                        ).Skip(skip).Take(take);

                return selected.ToList();
            }
            else
            {
                return BillNos;  
            }
        }
        public static object GetOceanExportBillByID(ListEditItemRequestedByValueEventArgs args)
        {
            int id;
            if (args.Value == null)
                return GetOceanExportBillNos();
            var BillNos = GetOceanExportBillNos();
            return BillNos.Where(p => p.Value == args.Value).Take(1);
        }
        public static List<TextValuePair> GetOceanExportBillNos()
        {
            string sel = "0";
            BillNumberListBL BL = new BillNumberListBL();
            System.Collections.Generic.List<TextValuePair> BillNos = new System.Collections.Generic.List<TextValuePair>();
            if (HttpContext.Current.Session["mailerSelectedBillType"] != null)
            {
                sel = HttpContext.Current.Session["mailerSelectedBillType"].ToString();

            }
            //  ELTUser authBLGetELTUser = (ELTUser)HttpContext.Current.Session["authBLGetELTUser"];
            string elt_account_number = HttpContext.Current.Session["elt_account_number"].ToString();
            if (sel == "1")
                BillNos = BL.GetHBOLNos(elt_account_number,"Export");
            else if (sel == "2")
                BillNos = BL.GetMBOLNos(elt_account_number,"Export");
            else if (sel == "3")
                BillNos = BL.GetOceanExportFileNumbers(elt_account_number);
            return BillNos;
        }        
        public static object GetAirImportBillRange(ListEditItemsRequestedByFilterConditionEventArgs args)
        {
            var skip = args.BeginIndex;
            var take = args.EndIndex - args.BeginIndex + 1;
            var BillNos = GetAirImportBillNos();

            if (args.Filter != "")
            {
                var selected = (from item in BillNos
                                where (item.Value).StartsWith(args.Filter)
                                orderby item.Value
                                select item
                        ).Skip(skip).Take(take);
                return selected.ToList();
            }
            else
            {
                return  BillNos;                               
            }

        }
        public static object GetAirImportBillByID(ListEditItemRequestedByValueEventArgs args)
        {
            int id;
            if (args.Value == null)
                return GetAirImportBillNos();
            var BillNos = GetAirImportBillNos();
            return BillNos.Where(p => p.Value == args.Value).Take(1);
        }
        public static List<TextValuePair> GetAirImportBillNos()
        {
            string sel = "0";
            BillNumberListBL BL = new BillNumberListBL();
            System.Collections.Generic.List<TextValuePair> BillNos = new System.Collections.Generic.List<TextValuePair>();
            if (HttpContext.Current.Session["mailerSelectedBillType"] != null)
            {
                sel = HttpContext.Current.Session["mailerSelectedBillType"].ToString();

            }
            // ELTUser authBLGetELTUser = (ELTUser)HttpContext.Current.Session["authBLGetELTUser"];
            string elt_account_number = HttpContext.Current.Session["elt_account_number"].ToString();
            if (sel == "1")
                BillNos = BL.GetHAWBNos(elt_account_number, "Import");
            else if (sel == "2")
                BillNos = BL.GetMAWBNos(elt_account_number, "Import");
            else if (sel == "3")
                BillNos = BL.GetAirImportFileNumbers(elt_account_number);
            return BillNos;
        }
        public static object GetOceanImportBillRange(ListEditItemsRequestedByFilterConditionEventArgs args)
        {
            var skip = args.BeginIndex;
            var take = args.EndIndex - args.BeginIndex + 1;
            var BillNos = GetOceanImportBillNos();

            if (args.Filter != "")
            {
                var selected = (from item in BillNos
                                where (item.Value).StartsWith(args.Filter)
                                orderby item.Value
                                select item
                        ).Skip(skip).Take(take);
                return selected.ToList();
            }
            else
            {
                return BillNos;  
            }

        }
        public static object GetOceanImportBillByID(ListEditItemRequestedByValueEventArgs args)
        {
            int id;
            if (args.Value == null)
                return GetOceanImportBillNos();
            var BillNos = GetOceanImportBillNos();
            return BillNos.Where(p => p.Value == args.Value).Take(1);
        }
        public static List<TextValuePair> GetOceanImportBillNos()
        {
            string sel = "0";
            BillNumberListBL BL = new BillNumberListBL();
            System.Collections.Generic.List<TextValuePair> BillNos = new System.Collections.Generic.List<TextValuePair>();
            if (HttpContext.Current.Session["mailerSelectedBillType"] != null)
            {
                sel = HttpContext.Current.Session["mailerSelectedBillType"].ToString();

            }
            // ELTUser authBLGetELTUser = (ELTUser)HttpContext.Current.Session["authBLGetELTUser"];
            string elt_account_number = HttpContext.Current.Session["elt_account_number"].ToString();
            if (sel == "1")
                BillNos = BL.GetHBOLNos(elt_account_number, "Import");
            else if (sel == "2")
                BillNos = BL.GetMBOLNos(elt_account_number, "Import");
            else if (sel == "3")
                BillNos = BL.GetOceanImportFileNumbers(elt_account_number);
            return BillNos;
        }
    }
}