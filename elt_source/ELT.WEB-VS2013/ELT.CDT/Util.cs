using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.IO;
using System.Web;
using System.Net;

namespace ELT.COMMON
{

    public static class Util
    {
        public static object GetPropValue(object src, string propName)
        {
            return src.GetType().GetProperty(propName).GetValue(src, null);
        }

        public static void ReadFileStream(string url, ref Stream receiveStream)
        {
            url = HttpUtility.UrlDecode(url);
            
            System.Net.HttpWebRequest myHttpWebRequest 
                = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(ToAbsoluteUrl(url));
            CookieContainer cContainer = new CookieContainer();
            myHttpWebRequest.CookieContainer = cContainer;
            for( int i=0; i<  HttpContext.Current.Request.Cookies.Count;i++)
            {
                var cookie =HttpContext.Current.Request.Cookies[i];
                System.Net.Cookie netCookie = new Cookie();
                netCookie.Domain = HttpContext.Current.Request.Url.Host;
                netCookie.Expires = cookie.Expires;
                netCookie.Name = cookie.Name;
                netCookie.Path = cookie.Path;
                netCookie.Secure = cookie.Secure;
                netCookie.Value =  cookie.Value;
               cContainer.Add(netCookie);
            }
            try
            {
                System.Net.HttpWebResponse myHttpWebResponse
                   = (System.Net.HttpWebResponse)myHttpWebRequest.GetResponse();
                try
                {
                    receiveStream = myHttpWebResponse.GetResponseStream();
                }
                catch (System.NotSupportedException systemNetConnectStream)
                {
                    throw;
                }
                catch (Exception ex)
                {
                    throw;
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static string ToAbsoluteUrl(this string relativeUrl)
        {
            if (string.IsNullOrEmpty(relativeUrl))
                return relativeUrl;

            if (HttpContext.Current == null)
                return relativeUrl;

            if (relativeUrl.StartsWith("/"))
                relativeUrl = relativeUrl.Insert(0, "~");
            if (!relativeUrl.StartsWith("~/"))
                relativeUrl = relativeUrl.Insert(0, "~/");

            var url = HttpContext.Current.Request.Url;
            var port = url.Port != 80 ? (":" + url.Port) : String.Empty;

            return String.Format("{0}://{1}{2}{3}",
                url.Scheme, url.Host, port, VirtualPathUtility.ToAbsolute(relativeUrl));
        }

        public static string GetOutputFileExtension(string fileName)
        {
            for (int i = 0; i < AppConstants.AllowedFileExtensions.Length; i++)
            {
                if(fileName.ToLower().EndsWith(AppConstants.AllowedFileExtensions[i]))
                    return AppConstants.OutputFileExtensions[i];
            }
            return string.Empty;
        }

        public static bool IsNumber(String value)
        {
            return value.All(Char.IsDigit);
        }
    }
}
