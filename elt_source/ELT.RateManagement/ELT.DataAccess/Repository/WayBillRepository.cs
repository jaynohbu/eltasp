using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Core.Common.CommandTrees;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using ELT.Shared.Common;
using ELT.Shared.Entities;
using ELT.Shared.Model;
using RateRoute = ELT.Shared.Model.RateRoute;

namespace ELT.DataAccess.Repository
{
    public interface IWayBillRepository
    {
        dynamic GetMawbBookingInfo(string mawb, int elt_account_number);
    }

    public class WayBillRepository :BaseRepository, IWayBillRepository
    {
       public dynamic GetMawbBookingInfo(string mawb, int elt_account_number)
       {
           var mb = EltUnitOfWorkContainer.Context.vw_mawb_booking_info.SingleOrDefault(a => a.mawb_no == mawb && a.elt_account_number==elt_account_number);
           if (mb == null) return null;
           return new
           {
               mawb_no = mb.mawb_no,
               mBy = mb.mBy,
               mBy1 = mb.mBy1,
               mBy2 = mb.mBy2,
               mTo= mb.mTo,
               mTo1=mb.mTo1,
               mTo2= mb.mTo2,
               mCarrierDesc = mb.mCarrierDesc,
               mDepartureAirport = mb.mDepartureAirport,
               mDepartureAirportCode = mb.mDepartureAirportCode,
               mDepartureState = mb.mDepartureState,
               mDestAirport = mb.mDestAirport,
               mDestCountry = mb.mDestCountry,
               mETDDate1 = mb.mETDDate1,
               mETDDate2 = mb.mETDDate2,
               mExportDate = mb.mExportDate,
               mFile = mb.mFile,
               mFlight1 = mb.mFlight1,
               mFlight2 = mb.mFlight2,
               mFlightDate1 = mb.mFlightDate1,
               mFlightDate2 = mb.mFlightDate2,
               mOrgNum = mb.mOrgNum,
               mServiceLevel = mb.mServiceLevel
           };
       }
    }
}
