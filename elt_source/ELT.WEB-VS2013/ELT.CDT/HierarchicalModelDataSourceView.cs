using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;

namespace ELT.CDT
{
    public class HierarchicalModelDataSourceView : HierarchicalDataSourceView
    {
        public IHierarchicalEnumerable _dataSource;
        public HierarchicalModelDataSourceView(IHierarchicalEnumerable dataSource)
        {
            _dataSource = dataSource;
        }

        public override IHierarchicalEnumerable Select()
        {
            return _dataSource;
        }
    }
}
