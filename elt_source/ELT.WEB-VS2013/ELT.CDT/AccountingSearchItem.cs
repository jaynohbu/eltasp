using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace ELT.CDT
{
    [Serializable]
    public class AccountingSearchItem
    {
        public virtual DateTime PeriodBegin { get; set; }
        public virtual DateTime PeriodEnd { get; set; }
        public virtual string Branch { get; set; }
        public virtual string Company { get; set; }
        public virtual string Vendor { get; set; }
        public virtual bool IsIncludeUnpostedTrnasaction { get; set; }
        public virtual string BankAccount { get; set; }
        public virtual string PaymentMethod { get; set; }
        public virtual string GLNoFrom { get; set; }
        public virtual string GLNoTo { get; set; }
        public virtual string TransactionType { get; set; }
        public virtual string GLAccountType { get; set; }
    }
}
