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
/// Summary description for GeneralUtility
/// </summary>
public class GeneralUtility
{	
    public bool removeNull(ref DataTable dt)
    {
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            for (int k = 0; k < dt.Columns.Count; k++)
            {
                if (dt.Rows[i][k].GetType().ToString()=="System.DBNull")
                {
                    try
                    {
                        dt.Rows[i][k] = "";
                    }
                    catch
                    {
                        try
                        {
                            dt.Rows[i][k] = 0;
                        }
                        catch 
                        {
                           
                        }                        
                    }
                }               
            }
        }
        return true;
    }
    public bool removeNull(ref DataSet ds, int index)
    {
        for (int i = 0; i < ds.Tables[index].Rows.Count; i++)
        {
            for (int k = 0; k < ds.Tables[index].Columns.Count; k++)
            {
                if (ds.Tables[index].Rows[i][k].GetType().ToString() == "System.DBNull")
                {
                    try
                    {
                        ds.Tables[index].Rows[i][k] = "";
                    }
                    catch 
                    {
                        try
                        {
                            ds.Tables[index].Rows[i][k] = 0;
                        }
                        catch 
                        {
                                                    
                        }
                    }
                }

            }
        }
        return true;
    }
    public bool removeNull(ref string obj)
    {
        if (obj == null)
        {
            try
            {
                obj = "";
            }
            catch 
            {
               
              
            }
        }
        return true;
    }
    public bool removeNull(ref int obj)
    {
        if (obj == null)
        {
            try
            {
                obj = 0;
            }
            catch
            {

            }
        }
        return true;
    }
    public bool removeNull(ref double obj)
    {
        if (obj == null)
        {
            try
            {
                obj = 0;
            }
            catch 
            {

            }
        }
        return true;
    }
    public string replaceQuote(string original)
    {
        if (original != null)
        {
            return original.Replace("'", "`");
        }
        else
        {
            return "";
        }
    }
}
