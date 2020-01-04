using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using  ELT.COMMON;
using ELT.CDT;
namespace ELT.WEB.Models
{
    [Serializable]
    public class Menu
    {
        public ProductMenuContext Context
        {
            get;
            set;
        }
        public MainMenuContext SubContext
        {
            get;
            set;
        }  

        public int ContextToInt
        {
            get { return (int)Context; }
        
        }
        public int SubContextToInt
        {
            get { return (int)SubContext; }         
        }
    }
}