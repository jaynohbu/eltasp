using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;

namespace ELT.CDT
{
    public class HierarchicalModelDataSource<T> : IHierarchicalDataSource
        where T : IModelWithHierarchy<T>
    {
        public IEnumerable<T> DataSource { get; set; }
        private HierarchicalDataSourceView _view;

        #region IHierarchicalDataSource Members

        public event EventHandler DataSourceChanged;

        public HierarchicalDataSourceView GetHierarchicalView(string viewPath)
        {
            if (_view == null)
            {
                _view = new HierarchicalModelDataSourceView(DataSource.ToHierarchicalModelList());
            }
            return _view;
        }

        #endregion
    }
}
