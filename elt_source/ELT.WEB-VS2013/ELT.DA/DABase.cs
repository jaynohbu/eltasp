using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.DA
{
    public class DABase
    {
        public string GetConnectionString(string name)
        {
            return System.Configuration.ConfigurationManager.ConnectionStrings[name].ToString();
        }
    }
}
