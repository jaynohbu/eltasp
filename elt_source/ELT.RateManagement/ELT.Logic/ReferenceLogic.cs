using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ELT.DataAccess;

using ELT.DataAccess.Repository;
using Ninject;

namespace ELT.Logic
{
    public class ReferenceLogic : IReferenceLogic
    {
        private IReferenceRepository _referenceRepository;
       
        [Inject]
        public IReferenceRepository RefRepository
        {
            set { _referenceRepository = value; }
        }

        [Inject]
        public IUnitOfWorkContainer UnitOfWork { get; set; }
        public IEnumerable<dynamic> GetAgents(string qry, string sessionId)
        {
            return UnitOfWork.Wrap(() => _referenceRepository.GetAgents(qry, sessionId));
        }

        public IEnumerable<dynamic> GetCustomers(string qry, string sessionId)
        {
            return UnitOfWork.Wrap(() => _referenceRepository.GetCustomers(qry, sessionId));
        }

        public IEnumerable<dynamic> GetAirLines(string qry, string sessionId)
        {
            return UnitOfWork.Wrap(() => _referenceRepository.GetAirLines(qry, sessionId));
        }

        public IEnumerable<dynamic> GetPorts(string qry, string sessionId)
        {
            return UnitOfWork.Wrap(() => _referenceRepository.GetPorts(qry, sessionId));
        }
    }
}
