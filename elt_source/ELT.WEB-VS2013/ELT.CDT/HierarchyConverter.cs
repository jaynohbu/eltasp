using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;

namespace ELT.CDT
{
    public static class HierarchyConverter
    {
        public static HierarchicalModelList
            ToHierarchicalModelList<T>(this IEnumerable<T> modelWithHierarchy)
            where T : IModelWithHierarchy<T>
        {
            return new HierarchicalModelList(
                modelWithHierarchy.Select(m => new HierarchyData<T>(m) as IHierarchyData));
        }
    }
}
