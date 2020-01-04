using System.Collections.Generic;
using Microsoft.SqlServer.Server;

namespace ELT.DataAccess.Repository
{
    public interface IReferenceRepository
    {
        IEnumerable<dynamic> GetAgents(string qry, string sessionId );
        IEnumerable<dynamic> GetCustomers(string qry, string sessionId);
        IEnumerable<dynamic> GetAirLines(string qry, string sessionId);
         IEnumerable<dynamic> GetPorts(string qry, string sessionId);
    }
}