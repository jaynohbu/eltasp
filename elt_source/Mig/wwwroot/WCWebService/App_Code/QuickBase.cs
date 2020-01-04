using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml;
using System.Net;
using System.Text;
using System.IO;

class QuickBaseError : Exception
{
    public QuickBaseError(String reason) { }
}

/// <summary>
/// Summary description for QuickBase
/// </summary>
public class QuickBase
{
    private string server = "www.quickbase.com";
    private string ticket = null;

	public QuickBase()
	{

	}

    public QuickBase(String myTicket)
    {
        ticket = myTicket;
    }

    public void setServer(String server)
    {
        server = server;
    }

    /// <summary>
    /// If you authenticate with a separate QuickBase object you
    /// can use this to reuse the ticket you got upon authentication.
    /// </summary>
    /// <param name="myTicket"></param>
    public void setTicket(String myTicket)
    {
        ticket = myTicket;
    }

    public XmlDocument postXML(string dbid, string action, XmlDocument xmlQDBRequest)
    {
        // This should be in the QuickBase module (which I need to create :-)
        // Converted from the APIXMLPost() function in QuickBaseClients.cls
        // which is part of the qbdvbsdk code I got from the QuickBase developer site
        string script;
        long hInternetOpen;
        long hInternetConnect;
        long hHttpOpenRequest;
        bool bRet;
        long httpPort;
        long fFlags;
        XmlDocument xmlDoc = new XmlDocument();
        string content;

        script = "/db/" + dbid + "?act=" + action;
        content = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>" + xmlQDBRequest.OuterXml;
        //   xmlDoc.async = False
        xmlDoc.LoadXml(httpPost("https://" + server + script, "application/xml", content, action));

        XmlNode ticketNode = xmlDoc.DocumentElement.SelectSingleNode("/*/ticket");
        if (ticketNode != null)
        {
            ticket = ticketNode.InnerText;
        }

        string errordetail;
        if (xmlDoc.DocumentElement.SelectSingleNode("/*/errdetail") == null)
        {
            errordetail = xmlDoc.DocumentElement.SelectSingleNode("/*/errtext").InnerText;
        }
        else
        {
            errordetail = xmlDoc.DocumentElement.SelectSingleNode("/*/errdetail").InnerText;
        }

        XmlNode errCodeNode = xmlDoc.DocumentElement.SelectSingleNode("/qdbapi/errcode");
        if (errCodeNode != null)
        {
            if (! errCodeNode.InnerText.Equals("0")) {
                throw new QuickBaseError(errCodeNode.InnerText + ": " + errordetail);
            }
        }

        return (xmlDoc);
    }

    private string httpPost(string url, string content_type, string content, string action)
    {

        HttpWebRequest httpReq = (HttpWebRequest)WebRequest.Create(url);

        httpReq.Method = "POST";

        byte[] byte1 = Encoding.ASCII.GetBytes(content);

        httpReq.ContentType = "text/xml"; //content_type;
        httpReq.ContentLength = byte1.Length;
        httpReq.Headers.Add("QUICKBASE-ACTION:" + action);

        Stream newStream = httpReq.GetRequestStream();
        newStream.Write(byte1, 0, byte1.Length);

        WebResponse httpResponse = httpReq.GetResponse();
        StreamReader sr = new StreamReader(httpResponse.GetResponseStream());
        string strResponse = sr.ReadToEnd();

        httpResponse.Close();

        return (strResponse);
    }

    /// <summary>
    /// Get the current ticket.
    /// </summary>
    /// <returns></returns>
    public string getTicket()
    {
        return (ticket);
    }

    /// <summary>
    /// Get a new ticket for the indicated user and password.
    /// </summary>
    /// <param name="username"></param>
    /// <param name="password"></param>
    /// <returns></returns>
    public string getTicket(string username, string password)
    {
        if (ticket == null)
        {
            XmlDocument xmlQDBRequest = new XmlDocument();

            xmlQDBRequest = InitXMLRequest(username, password);
            postXML("main", "API_Authenticate", xmlQDBRequest);
        }
        return (ticket);
    }

    private XmlElement MakeSimpleElem(XmlDocument doc, string tagName, string tagVal)
    {
        XmlElement elem = doc.CreateElement(tagName);
        elem.InnerText = tagVal;
        return elem;
    }

    private XmlDocument InitXMLRequest(string username, string password)
    {
        XmlDocument xmlQDBRequest = new XmlDocument();
        XmlNode Root;

        Root = xmlQDBRequest.AppendChild(xmlQDBRequest.CreateElement("qdbapi"));
        if (ticket != null)
        {
            Root.AppendChild(MakeSimpleElem(xmlQDBRequest, "ticket", ticket));
        }
        else if (username != "")
        {
            Root.AppendChild(MakeSimpleElem(xmlQDBRequest, "username", username));
            Root.AppendChild(MakeSimpleElem(xmlQDBRequest, "password", password));
        }
        return (xmlQDBRequest);
    }

}
