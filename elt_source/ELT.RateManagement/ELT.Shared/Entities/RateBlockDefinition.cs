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
    
    public partial class RateBlockDefinition
    {
        public int ID { get; set; }
        public int RangeStart { get; set; }
        public string Caption { get; set; }
        public int RateEntryRowID { get; set; }
        public string Value { get; set; }
    
        public virtual RateEntryRow RateEntryRow { get; set; }
    }
}
