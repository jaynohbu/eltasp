using System.Collections.Generic;

namespace ELT.Logic
{
    public interface IReferenceLogic
    {
        IEnumerable<dynamic> GetAgents(string qry, string sessionId);
        IEnumerable<dynamic> GetCustomers(string qry, string sessionId);
        IEnumerable<dynamic> GetAirLines(string qry, string sessionId);
        IEnumerable<dynamic> GetPorts(string qry, string sessionId);

    }
}