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
/// Summary description for LocalData
/// </summary>
public class LocalData
{
    #region MemberData
    private String lastCompanyPath;
    private String lastCompanyGuid;    // OwnerID, I think
    private DateTime firstAccess;
    private DateTime lastAccess;
    private DateTime lastModify;
    #endregion

    public LocalData()
	{
        firstAccess = DateTime.Now;
        lastAccess = DateTime.Now;
        lastModify = DateTime.Now;
    }

    public void setCompanyPath(String companyPath)
    {
        lastCompanyPath = companyPath;
        lastModify = DateTime.Now;
    }
    public String getCompanyPath()
    {
        return lastCompanyPath;
    }

    public void setCompanyGuid(String guid)
    {
        lastCompanyGuid = guid;
        lastModify = DateTime.Now;
    }
    public String getCompanyGuid()
    {
        return lastCompanyGuid;
    }

    public void setFirstAccess(DateTime timestamp)
    {
        firstAccess = timestamp;
    }
    public DateTime getFirstAccess()
    {
        return firstAccess;
    }

    public void setLastAccess(DateTime timestamp)
    {
        lastAccess = timestamp;
    }
    public DateTime getLastAccess()
    {
        return lastAccess;
    }

    public void setLastModify(DateTime timestamp)
    {
        lastModify = timestamp;
    }
    public DateTime getLastModify()
    {
        return lastModify;
    }
}
