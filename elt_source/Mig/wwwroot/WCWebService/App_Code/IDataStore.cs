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
/// Interface for data storage mechanisms.
/// Reasonable implementations would be XML File, SQL Database, ActiveDirectory, FTP, etc.
/// </summary>
public interface IDataStore
{
    LocalData getLocalData(String username, String password);
    void putLocalData(LocalData localData);
}
