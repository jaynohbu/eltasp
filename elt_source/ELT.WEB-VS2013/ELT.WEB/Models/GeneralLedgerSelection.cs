using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ELT.COMMON;
using ELT.CDT;
using ELT.BL;
using System.Web.Mvc;

namespace ELT.WEB.Models
{
    [Serializable]
    public class GeneralLedgerSelection : AccountingSearchItem
    {
        public GeneralLedgerSelection(string _EltAccountNumber)
        {
            EltAccountNumber = _EltAccountNumber;
        }
        public string EltAccountNumber { get; set; }
        public override DateTime PeriodBegin { get; set; }
        public override DateTime PeriodEnd { get; set; }
        public override string Branch { get; set; }
        public override string GLNoFrom { get; set; }
        public override string GLNoTo { get; set; }
        public override string TransactionType { get; set; }
        public List<SelectListItem> BranchList
        {
            get
            {
                ELT.BL.ReportingBL bl = new BL.ReportingBL();
                var all = bl.GetBranches(EltAccountNumber);
                List<SelectListItem> items = new List<SelectListItem>();

                if (all.Count > 1)
                    items.Add(new SelectListItem { Text = "All", Value = "" });
                foreach (var b in all)
                {
                    if (b.Item1.ToString() == EltAccountNumber)
                    {
                        items.Add(new SelectListItem
                        {
                            Text = b.Item2,
                            Value = b.Item1,
                            Selected = true
                        });
                    }
                    else
                    {
                        items.Add(new SelectListItem
                        {
                            Text = b.Item2,
                            Value = b.Item1
                        });
                    }
                    //
                }



                return items;
            }
        }
        public List<SelectListItem> PeriodList
        {
            get
            {
                List<SelectListItem> items = new List<SelectListItem>();

                items.Add(new SelectListItem { Text = "Today", Value = "0", Selected = true });
                items.Add(new SelectListItem { Text = "Month to Date", Value = "1" });
                items.Add(new SelectListItem { Text = "Quarter to Date", Value = "2" });
                items.Add(new SelectListItem { Text = "Year to Date", Value = "3" });
                items.Add(new SelectListItem { Text = "This Month", Value = "4" });
                items.Add(new SelectListItem { Text = "This Quearter", Value = "5" });
                items.Add(new SelectListItem { Text = "This Year", Value = "6" });

                return items;
            }
        }
        public List<SelectListItem> GLNoFromList
        {
            get
            {
                ELT.BL.ReportingBL bl = new BL.ReportingBL();
                var all = bl.GetAllGLAccount(EltAccountNumber);
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "", Value = "", Selected = true });
                foreach (var a in all)
                {

                    items.Add(new SelectListItem { Text = a.gl_text, Value = a.gl_account_number.ToString(), Selected = false });
                }
                
                return items;
            }
        }
        public List<SelectListItem> GLNoToList
        {
            get
            {
                ELT.BL.ReportingBL bl = new BL.ReportingBL();
                var all = bl.GetAllGLAccount(EltAccountNumber);

                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "", Value = "", Selected = true });
                foreach (var a in all)
                {

                    items.Add(new SelectListItem { Text = a.gl_text, Value = a.gl_account_number.ToString(), Selected = false });
                }

                return items;
            }
        }
        public List<SelectListItem> TransactionTypeList
        {
            get
            {
                ELT.BL.ReportingBL bl = new BL.ReportingBL();
                var all = bl.GetAllGLTranType(EltAccountNumber);

                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "", Value = "", Selected = true });
                foreach (var a in all)
                {

                    items.Add(new SelectListItem { Text = a.tran_type, Value =a.tran_type, Selected = false });
                }

                return items;
            }
        }
    }
}



