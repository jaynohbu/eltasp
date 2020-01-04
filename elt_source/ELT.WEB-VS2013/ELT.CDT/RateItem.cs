using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    [Serializable]
    public class RateDefinitionColum
    {      
        public int ID { get; set; }
        public string Caption { get; set; }
        public string Value { get; set; }
        public string Rate { get; set; }
    }

    //[Serializable]
    //public class WeightBreakColumn
    //{
    //    public int ID { get; set; }
    //    public string Text { get; set; }
    //    public string Value { get; set; }
    //    public string PreviousValue { get; set; }
    //    public bool Updated { get; set; }
    //    public bool Deleted { get; set; }
    //    public bool Inserted { get; set; }
    //}
     [Serializable]
    public class RateRouting{
         public RateRouting()
         {
             Rates = new List<Rate>();
               //_WeightBreakColums = new List<WeightBreakColumn>();
         }
         public int ID { get; set; }
         public string Origin { get; set; }
         public string Dest { get; set; }
         public string Unit { get; set; }
         public string UnitText
         {
             get
             {
                 if (Unit == "L") return "LB";
                 else return "KG";
             }
             set
             {
                 if (value == "LB") Unit = "L";
                 else Unit = "K";
             }
         }
         public string CustomerOrgName { get; set; }
         public int customer_org_account_number { get; set; }

         public string AgentOrgName { get; set; }
         public int agent_org_account_number { get; set; }
         
         public int elt_account_number { get; set; }
         public List<Rate> Rates { get; set; }
         //private List<WeightBreakColumn> _WeightBreakColums;
         //public List<WeightBreakColumn> WeightBreakColums {

         //    get
         //    {

         //        if (Rates.Count > 0)
         //        {
         //            var DefinitionColums = Rates[0].RateDefinitionColums.OrderBy(r => int.Parse(r.Value)).ToList();
         //            for (int i = 0; i < DefinitionColums.Count; i++)
         //            {
         //                if (i < DefinitionColums.Count - 1)
         //                {
         //                    if (int.Parse(DefinitionColums[i].Value) == 0) { DefinitionColums[i].Text = "MIN.($)"; }
         //                    DefinitionColums[i].Text = DefinitionColums[i].Value + " ~ " + (int.Parse(DefinitionColums[i + 1].Value) - 1).ToString();
         //                }
         //                else
         //                {
         //                    DefinitionColums[i].Text = DefinitionColums[i].Value + " ~ ";
         //                }
         //            }

         //        }

         //        return _WeightBreakColums;

         //    }

         //}

    }
      [Serializable]
    public class Rate
    {
        public Rate()
        {
            RateDefinitionColums = new List<RateDefinitionColum>();
        }
       public int RouteID { get; set; }
       public int RateID { get; set; }
       public int RawItemID { get; set; }

        public List<RateDefinitionColum> RateDefinitionColums
        {
            get;
            set;
        }
        public string CarrierCode { get; set; }
        public string Share { get; set; }
    }

    [Serializable]
    public class FlattenRateItem
    {
        public int id { get; set; }
        public int elt_account_number { get; set; }
        public int item_no { get; set; }
        public int rate_type { get; set; }
        public int agent_no { get; set; }
        public int customer_no { get; set; }
        public int carrier { get; set; }
        public string origin_port { get; set; }
        public string dest_port { get; set; }
        public string weight_break { get; set; }
        public decimal rate { get; set; }
        public string kg_lb { get; set; }
        public decimal share { get; set; }
        public string is_org_merged { get; set; }
        public string fl_rate { get; set; }
        public string sec_rate { get; set; }
        public string include_fl_rate { get; set; }
        public string include_sec_rate { get; set; }
        public string dba_name { get; set; }
    }
}
