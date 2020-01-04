using System;
using System.Collections.Generic;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using ELT.Shared.Model;
using ELT.Shared.Util;
using Microsoft.Web.Infrastructure;

namespace ELT.DataAccess.Repository
{
    public class ReferenceRepository :BaseRepository,  IReferenceRepository
    {
        public IEnumerable<dynamic> GetPorts(string qry, string sessionId)
        {
            var user = GetEltUser(sessionId);
            var elt_account_number = user.IntEltAccountNumber;
            if (qry == "default1000")
                return
                    EltUnitOfWorkContainer.Context.ports.Where(a => a.elt_account_number == elt_account_number )
                        .Take(1000)
                        .Select(a => new
                        {
                            Text =
                                a.port_desc,
                            Value = a.port_code
                        }).ToList();
            else
            {
                return
                      EltUnitOfWorkContainer.Context.ports.Where(a => a.elt_account_number == elt_account_number && a.port_desc.Contains(qry))
                       .Select(a => new
                       {
                           Text =
                                a.port_desc,
                           Value = a.port_code
                       }).ToList();

            }
        }
        public  IEnumerable<dynamic> GetAgents(string qry, string sessionId)
        {
            var user = GetEltUser(sessionId);
            var elt_account_number = user.IntEltAccountNumber;
            if (qry == "default1000")
            {
                var list =
                    EltUnitOfWorkContainer.Context.organizations.Where(
                        a => a.elt_account_number == elt_account_number && a.is_agent == "Y")
                        .Take(1000)
                        .Select(a => new
                        {
                            Text =
                                a.business_legal_name,
                            Value = a.org_account_number
                        }).ToList();
                list.Insert(0, item: new { Text = "All", Value = Convert.ToDecimal(-1) });
                return list;
            }

            else
            {
                var list =
                    EltUnitOfWorkContainer.Context.organizations.Where(
                        a =>
                            a.elt_account_number == elt_account_number && a.business_legal_name.Contains(qry) &&
                            a.is_agent == "Y")

                        .Select(a => new
                        {
                            Text =
                                a.business_legal_name,
                            Value = a.org_account_number
                        }).ToList();
                list.Insert(0, item: new { Text = "All", Value = Convert.ToDecimal(-1) });
                return list;
            }
        }

        public IEnumerable<dynamic> GetCustomers(string qry, string sessionId)
        {
            var user = GetEltUser(sessionId);
            var elt_account_number = user.IntEltAccountNumber;
            if (qry == "default1000")
            {
                var list=
                    EltUnitOfWorkContainer.Context.organizations.Where(a => a.elt_account_number == elt_account_number)
                        .Take(1000)
                        .Select(a => new
                        {
                            Text =
                                a.dba_name,
                            Value = a.org_account_number
                        }).ToList();
                list.Insert(0,item: new {Text="All",Value=Convert.ToDecimal(-1)});
                return list;
            }
            else
            {
                var list=
                    EltUnitOfWorkContainer.Context.organizations.Where(
                        a => a.elt_account_number == elt_account_number && a.dba_name.Contains(qry))

                        .Select(a => new
                        {
                            Text =
                                a.dba_name,
                            Value = a.org_account_number
                        }).ToList();
                list.Insert(0, item: new { Text = "All", Value = Convert.ToDecimal(-1) });
                return list;
            }

        }

        public IEnumerable<dynamic> GetAirLines(string qry, string sessionId)
        {
            var user = GetEltUser(sessionId);
            int n;
            bool isNumeric = int.TryParse("123", out n);
            var elt_account_number = user.IntEltAccountNumber;
            if (qry == "default1000") { 
                var list =
                    EltUnitOfWorkContainer.Context.GetAirlines(elt_account_number,null)
                        .Take(1000)
                        .Select(a => new
                        {
                            Text =
                                a.dba_name,
                            Value = Convert.ToInt32(a.carrier_code)
                        }).ToList();

            list.Insert(0, item: new {Text = "All", Value = -1});
            return list;
        }

    else
            {
                var list =
                      EltUnitOfWorkContainer.Context.GetAirlines(elt_account_number, qry)

                          .Select(a => new
                          {
                              Text =
                                  a.dba_name,
                              Value = Convert.ToInt32(a.carrier_code)
                          }).ToList();

              
                return list;

            }
        }
    }
}
