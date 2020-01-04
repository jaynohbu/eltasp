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
    public interface IWayBillLogic
    {
        dynamic GetMawbBookingInfo(string mawb, int elt_account_number);
    }

    public class WayBillLogic : IWayBillLogic
    {
        [Inject]
        public IWayBillRepository WayBillRepository { get; set; }
        [Inject]
        public IUnitOfWorkContainer UnitOfWork { get; set; }

        public dynamic GetMawbBookingInfo(string mawb, int elt_account_number)
        {
            return UnitOfWork.Wrap(() => WayBillRepository.GetMawbBookingInfo(mawb,  elt_account_number));
        }
        
    }
}
