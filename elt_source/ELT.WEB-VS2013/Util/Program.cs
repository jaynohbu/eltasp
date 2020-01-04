using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml;
using System.Xml.Linq;
namespace Util
{
    class Program
    {
        static void Main(string[] args)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load("C:\\ELT.Refactor\\ELT.WEB-VS2013\\IFF_MAIN\\web.config");
            var a = doc.DocumentElement.ChildNodes[1];
            for (int i = 0; i < a.ChildNodes.Count; i++)
            {
                if (a.ChildNodes[i].Name == "httpHandlers")
                {
                    //httpHandlers
                    var httpHandlers = a.ChildNodes[i];
                    for (int j = 0; j < httpHandlers.ChildNodes.Count; j++)
                    {
                        if (httpHandlers.ChildNodes[j].Attributes["type"].Value.Contains("DevExpress.Web.ASPxClasses"))
                        {
                            var DevExpress = httpHandlers.ChildNodes[j];
                            httpHandlers.RemoveChild(DevExpress);
                        }
                    }
                }
            }

            for (int i = 0; i < a.ChildNodes.Count; i++)
            {
                if (a.ChildNodes[i].Name == "httpModules")
                {
                    //httpModules
                    var httpModules = a.ChildNodes[i];
                    for (int j = 0; j < httpModules.ChildNodes.Count; j++)
                    {
                        if (httpModules.ChildNodes[j].Attributes["type"].Value.Contains("DevExpress.Web.ASPxClasses"))
                        {
                            var DevExpress = httpModules.ChildNodes[j];
                            httpModules.RemoveChild(DevExpress);
                        }
                    }
                }
            }

            var b = doc.DocumentElement.ChildNodes[5];



            for (int i = 0; i < b.ChildNodes.Count; i++)
            {
                if (b.ChildNodes[i].Name == "handlers")
                {
                    //httpHandlers
                    var httpHandlers = b.ChildNodes[i];
                    for (int j = 0; j < httpHandlers.ChildNodes.Count; j++)
                    {
                        if (httpHandlers.ChildNodes[j].Attributes["type"].Value.Contains("DevExpress.Web.ASPxClasses"))
                        {
                            var DevExpress = httpHandlers.ChildNodes[j];
                            httpHandlers.RemoveChild(DevExpress);
                        }
                    }
                }
            }

            for (int i = 0; i < b.ChildNodes.Count; i++)
            {
                if (b.ChildNodes[i].Name == "modules")
                {
                    //httpModules
                    var httpModules = b.ChildNodes[i];
                    for (int j = 0; j < httpModules.ChildNodes.Count; j++)
                    {
                        if (httpModules.ChildNodes[j].Attributes["type"].Value.Contains("DevExpress.Web.ASPxClasses"))
                        {
                            var DevExpress = httpModules.ChildNodes[j];
                            httpModules.RemoveChild(DevExpress);
                        }
                    }
                }
            }
            doc.Save("C:\\ELT.Refactor\\ELT.WEB-VS2013\\IFF_MAIN\\web.config");
        }
    }
}
