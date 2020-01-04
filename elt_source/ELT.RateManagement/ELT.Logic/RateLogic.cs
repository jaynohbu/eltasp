using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ELT.DataAccess;
using ELT.DataAccess.Repository;
using ELT.Shared.Model;
using Ninject;

namespace ELT.Logic
{
    public class RateLogic : IRateLogic
    {
        [Inject]
        public IRateRepository RateRepository { get; set; }
        [Inject]
        public IUnitOfWorkContainer UnitOfWork { get; set; }

        public RateTable GetCustomerSellingRate(int customerId, int skip, int count, string sessionId)
        {
            return UnitOfWork.Wrap(() => RateRepository.GetCustomerSellingRate(customerId, skip, count, sessionId));
        }

        public RateTable GetAgentBuyingRate(int agentId, int skip, int count, string sessionId)
        {
            return UnitOfWork.Wrap(() => RateRepository.GetAgentBuyingRate(agentId, skip, count, sessionId));
        }

        public RateTable GetIataRate(int skip, int count, string sessionId)
        {
            return UnitOfWork.Wrap(() => RateRepository.GetIataRate(skip, count, sessionId));
        }

        public RateTable GetAirlineBuyingRate(int skip, int count, string sessionId)
        {
            return UnitOfWork.Wrap(() => RateRepository.GetAirlineBuyingRate(skip, count, sessionId));
        }

        public void SaveTable(List<RateRoute> rateRoutes, string sessionId)
        {
            UnitOfWork.Wrap(() => RateRepository.SaveRate(rateRoutes, sessionId));
        }

        public void SaveWrappers(List<CompanyRateWrapper> wrappers, string sessionId)
        {
            UnitOfWork.Wrap(() => RateRepository.SaveWrappers(wrappers, sessionId));
        }
    }
}
