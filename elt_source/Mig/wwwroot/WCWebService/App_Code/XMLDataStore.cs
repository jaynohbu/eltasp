using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Reflection;
using System.Data;
using System.IO;
using System.Xml;
using System.Xml.Schema;

/// <summary>
/// XMLDataStore takes an pure getter/setter class file and
/// takes care of the serialization aspects.
/// 
/// Well, that's the theory, but since this goal is really outside
/// the scope of this project it's fudged a bit for now. I.e.
/// I'm going to manually create the schema for the class.
/// This should be automated by this class, but I don't have
/// time right now to work through all the issues :-).
/// </summary>
public class XMLDataStore
{
	public XMLDataStore()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static LocalData getLocalData(String username, String password)
    {
        LocalData localData = new LocalData();
        Type objectType = localData.GetType();
        MethodInfo[] methods = objectType.GetMethods();

        try
        {
            //Create a DataSet object
            DataSet ds = new DataSet();

            // Look for <username>.xml

            //Create a FileStream to the Xml Database file in Read mode
            FileStream findata = new FileStream(username + ".xml", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);

            //Read the DataBase into the DataSet
            ds.ReadXml(findata);

            /*        for (int i = 0; i < methods.GetLength(0); i++)
                    {
                        if (methods[i].Name.StartsWith("set"))
                        {
                            methods[i].Invoke(localData, thisvalue);
                        }
                    }
                    */
        }
        catch (System.IO.FileNotFoundException e)
        {
            // No file, no worries, we'll just
            // return an empty localData
        }
        return localData;
    }

    public static void putLocalData(LocalData localData, String username, String password)
    {
        Type objectType = localData.GetType();
        MethodInfo[] methods = objectType.GetMethods();

        try
        {
            XmlSchema xsd;
            //xsd.

            //Create a DataSet object
            DataSet ds = new DataSet();

            //Create a FileStream to the Xml Database file in Read mode
            FileStream findata = new FileStream(username + ".xml", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);

            //Read the DataBase into the DataSet
            ds.ReadXml(findata);

            /*        for (int i = 0; i < methods.GetLength(0); i++)
                    {
                        if (methods[i].Name.StartsWith("set"))
                        {
                            methods[i].Invoke(localData, thisvalue);
                        }
                    }
                    */
        }
        catch (System.IO.FileNotFoundException e)
        {
            // No file, no worries, we'll just
            // return an empty localData
        }






        for (int i = 0; i < methods.GetLength(0); i++)
        {
            String name = methods[i].Name;
            if (name.StartsWith("get"))
            {
                Object o = methods[i].Invoke(localData, null);
                // Store name with value o
            }
        }
    }
}
