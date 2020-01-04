using System.Collections.Generic;
using System.Linq;
using ELT.Shared.Common;

namespace ELT.Shared.Model
{
    public class RateTable
    {
       public List<CompanyRateWrapper> CompanyWrappers { get; set; }
        public List<RateRoute> Table { get; set; }
        public string SessionId { get; set; }
        public SystemError Error { get; set; }
        public int Total { get; set; }
        public int Skip { get; set; }
        public int Take { get; set; }
        
    }
}