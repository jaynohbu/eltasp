using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;

/// <summary>
/// Summary description for MemorySession
/// </summary>
public sealed class MemorySession: ISessionPool
{
    #region GlobalVariables
    static readonly MemorySession instance = new MemorySession();   // Part of Singleton pattern
    private Hashtable sessionStore = new Hashtable();
    #endregion

    #region Constructor
    // Explicit static constructor to tell C# compiler
    // not to mark type as beforefieldinit
    static MemorySession()
	{
    }

    MemorySession()
    {
    }
    #endregion

    public static MemorySession Instance
    {
        get
        {
            return instance;
        }
    }

    public void put(String key, Session sess)
    {
        if (sessionStore.Contains(key))
        {
            sessionStore[key] = sess;
        }
        else
        {
            sessionStore.Add(key, sess);
        }
    }
    public Session get(String key)
    {
        return (Session)sessionStore[key];
    }
    public void invalidate(String key)
    {
        sessionStore.Remove(key);
    }
}
