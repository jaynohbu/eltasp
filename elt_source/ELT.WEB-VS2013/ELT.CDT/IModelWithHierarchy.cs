using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    public interface IModelWithHierarchy<T>
    {
        string Name { get; set; }
        T Parent { get; set; }
        List<T> Children { get; set; }
         string Text { get; set; }
         string NavigateUrl { get; set; }
    }
}
