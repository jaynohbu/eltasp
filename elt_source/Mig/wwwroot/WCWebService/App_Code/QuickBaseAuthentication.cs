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
/// Summary description for QuickBaseAuthentication
/// </summary>
public class QuickBaseAuthentication: IAuthentication
{
    private QuickBase qb;
    private Object context;

	#region Constructor
	public QuickBaseAuthentication()
	{
    }
    #endregion

    public void CreateAuthentication(Object context)
    {
        if (context != null)
        {
            qb.setServer(context.ToString());
        }
    }

    public Object authenticate(String username, String password, Object context)
    {
        String ticket = null;
        qb = (QuickBase)context;
        try
        {
            ticket = qb.getTicket(username, password);
        }
        catch (QuickBaseError e)
        {
            throw new AuthenticateExceptionInvalidCredentials();
        }
        catch (Exception e2)
        {
            // A temporary exception, retry later
            throw new AuthenticateException(e2.ToString());
        }
        return (ticket);
    }
}
