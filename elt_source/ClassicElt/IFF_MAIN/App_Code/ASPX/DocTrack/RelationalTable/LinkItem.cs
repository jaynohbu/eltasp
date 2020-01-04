using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// Summary description for Class1
/// </summary>
public class LinkItem
{
    private string image;
    private string link;
    private string text;
    
    public LinkItem(string t, string u, string i)
    {
        link= u;
        image = i;
        text = t;
    }
    public string getText(){
        return text;
    }
    public string getImage()
    {
        return image;
    }
    public string getLink()
    {
        return link;
    }
}
