using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace ELT.Shared.Util
{
    public class HttpUtil
    {
        public static NameValueCollection GetEltCookie()
        {
            var cookie = HttpContext.Current.Request.Cookies["CurrentUserInfo"];
            if (cookie?.Value != null)
            {
                var col=new NameValueCollection();
                var pairs = cookie.Value.Split('&');
                foreach (var p in pairs)
                {
                    var n = p.Split('=');
                    var name = n[0];
                    if(n[1]!=null)
                    col.Add(name, n[1]);
                }

            }
            return null;
        }

        public static string GetConnectionString(string name)
        {
            return System.Configuration.ConfigurationManager.ConnectionStrings[name].ToString();
        }

    }
}
