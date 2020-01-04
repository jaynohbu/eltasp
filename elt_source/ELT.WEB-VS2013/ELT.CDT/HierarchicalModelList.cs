using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;

namespace ELT.CDT
{
    public class HierarchicalModelList : List<IHierarchyData>, IHierarchicalEnumerable
    {
        public HierarchicalModelList(IEnumerable<IHierarchyData> collection) : base(collection) { }

        #region IHierarchicalEnumerable Members

        public IHierarchyData GetHierarchyData(object enumeratedItem)
        {
            return enumeratedItem as IHierarchyData;
        }

        #endregion

    }
}
