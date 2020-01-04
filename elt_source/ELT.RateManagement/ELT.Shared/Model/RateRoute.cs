using System.Collections.Generic;

namespace ELT.Shared.Model
{
    public class CompanyRateWrapper
    {
       public List<RateRoute> RateRoutes { get; set; }
        public CompanyRateWrapper()
        {
            RateRoutes=new List<RateRoute>();
        }
        public int CompanyNo { get; set; }
        public int TotalRows { get; set; }
        public bool Disabled { get; set; }
        public string SessionId { get; set; }
        public bool CompanyDisabled { get; set; }
    }
    public class RateRoute
    {
        public RateRoute()
        {
            WeightBreak = new string[8];
        }
        public RateType RateType { get; set; }
        public int AgentNo { get; set; }
        public int CustomerNo { get; set; }
        public bool Disabled { get; set; }
        public List<PerCarrier> PerCarrier { get; set; }
        public string OriginPort { get; set; }
        public string DestPort { get; set; }
        public string KgLb { get; set; }
        public string[] WeightBreak{ get; set; }
    }
    public class PerCarrier
    {
        public int Id { get; set; }
        public PerCarrier()
        {
            RateBreak = new string[8];
        }
        public int Airline { get; set; }
        public string [] RateBreak { get; set; }
        public bool Disabled { get; set; }
        public decimal Share { get; set; }
        public decimal Min { get; set; }
        public decimal MinPlus { get; set; }
    }
}