using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{

    [Serializable]
    public class ReportSearchItem
    {
        public virtual string MAWB
        {
            get;
            set;
        }

        public virtual string HAWB
        {
            get;
            set;
        } 

        public virtual string CategorizeBy
        {
            get;
            set;
        }
        public virtual DateTime PeriodBegin
        {
            get;
            set;
        }
        public virtual DateTime PeriodEnd
        {
            get;
            set;
        }
        public virtual string WeightScale
        {
            get;
            set;
        }
        public virtual string MeasurementScale
        {
            get;
            set;
        }
        
        public virtual string AnalysisOn
        {
            get;
            set;
        }
        
    }
}
