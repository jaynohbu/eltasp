using System.Collections.Generic;
using ELT.Shared.Model;

namespace ELT.Logic
{
    public interface IRateLogic
    {

        RateTable GetCustomerSellingRate(int customerId, int skip, int count, string sessionId);
     RateTable GetAgentBuyingRate(int agentId, int skip, int count, string sessionId);
        RateTable GetIataRate(int skip, int count, string sessionId);
        RateTable GetAirlineBuyingRate(int skip, int count, string sessionId);
        void SaveTable(List<RateRoute> rateRoute, string sessionId);
        void SaveWrappers(List<CompanyRateWrapper> wrappers, string sessionId);
    }
}