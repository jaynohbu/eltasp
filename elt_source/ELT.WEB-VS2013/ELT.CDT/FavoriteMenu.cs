using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.CDT
{
    public class TreeMenu : IModelWithHierarchy<TreeMenu>
    {
        public TreeMenu()
        {
            Children = new List<TreeMenu>();
        }
        public TreeMenu(string Text, string NavigateUrl)
        {
            Children = new List<TreeMenu>();
            this.Text = Text;
            this.NavigateUrl = NavigateUrl;
        }
        public string Name { get; set; }
        public string Text { get; set; }
        public string NavigateUrl { get; set; }
        public TreeMenu Parent { get; set; }
        public List<TreeMenu> Children { get; set; }
    }
}
