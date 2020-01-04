//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ELT.Shared.Entities
{
    using System;
    using System.Collections.Generic;
    
    public partial class rate_table
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public rate_table()
        {
            this.all_rate_table = new HashSet<all_rate_table>();
        }
    
        public decimal id { get; set; }
        public int elt_account_number { get; set; }
        public Nullable<int> customer_no { get; set; }
        public Nullable<int> agent_no { get; set; }
        public string origin_port { get; set; }
        public string dest_port { get; set; }
        public int airline { get; set; }
        public string kg_lb { get; set; }
        public Nullable<decimal> share { get; set; }
        public Nullable<decimal> min { get; set; }
        public Nullable<decimal> minPlus { get; set; }
        public string breaks { get; set; }
        public string rates { get; set; }
        public short rate_type { get; set; }
        public Nullable<bool> enabled { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<all_rate_table> all_rate_table { get; set; }
    }
}
