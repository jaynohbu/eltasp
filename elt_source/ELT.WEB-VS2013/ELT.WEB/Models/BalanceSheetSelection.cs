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
    public class BalanceSheetSelection : AccountingSearchItem
    {
        public BalanceSheetSelection(string _EltAccountNumber)
        {
            EltAccountNumber = _EltAccountNumber;
        }
        public string EltAccountNumber { get; set; }
        public override DateTime PeriodEnd { get; set; }
        public override string Branch { get; set; }
        public List<SelectListItem> BranchList
        {
            get
            {
                ELT.BL.ReportingBL bl = new BL.ReportingBL();

                // if headquater
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
    }
}