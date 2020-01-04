using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;

namespace ELT.CDT
{
    public class HierarchyData<T> : IHierarchyData
       where T : IModelWithHierarchy<T>
    {
        private readonly T _modelWithHierarchy;
        public HierarchyData(T modelWithHierarchy)
        {
            _modelWithHierarchy = modelWithHierarchy;
        }

        #region IHierarchyData Members

        public IHierarchicalEnumerable GetChildren()
        {
            return _modelWithHierarchy.Children.ToHierarchicalModelList();
        }

        public IHierarchyData GetParent()
        {
            return new HierarchyData<T>(_modelWithHierarchy.Parent);
        }

        public bool HasChildren
        {
            get { return _modelWithHierarchy.Children.Count > 0; }
        }

        public object Item
        {
            get { return _modelWithHierarchy; }
        }

        public string Type
        {
            get { return _modelWithHierarchy.GetType().ToString(); }
        }

        public string Path
        {
            get { return string.Empty; }
        }

        public override string ToString()
        {
            return _modelWithHierarchy.Name;
        }
        public string Text { get { return _modelWithHierarchy.Text; } }
        public string NavigateUrl { get { return _modelWithHierarchy.NavigateUrl; } }
        #endregion
    }
}
