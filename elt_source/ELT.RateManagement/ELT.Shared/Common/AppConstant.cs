using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ELT.Shared.Common
{
    public class AppConstant
    {
        public static int MAX_RATE_COUNT=200;
        public static int PAGE_COUNT_RATE = 50;
    }

    public enum SystemError
    {
      RateMan_MaxRateCount=1,
    }
}
