using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Interop.QBFC6;

// Questions for reviewers:
// This class bends over backwards to do everything in static methods.
// I did this so as to not have to keep a QuickBooksCustomerOps object
// in the session. But maybe that is better than having to sling the
// country/major/minor stuff around all the time. 
//
// My opposition to keeping this object in the session is that I'm thinking
// of sites that might want to have multiple servers handling events.
// We would either have to have sticky sessions, or we'd have to serialize
// this object so it's available through the shared session store. Yuck.
//
// Thoughts?

// TAB: Nota Bene:
// 1. Always check Detail for nullness before using it
// 2. You need to check every IResponse for success
//    before proceeding. A status code of 0 means the
//    request succeeded.

/// <summary>
/// Operations with QuickBooks Customer objects.
/// </summary>
public class QuickBooksCustomerOps
{
    private static bool forceV1 = true;
    private static int chunkSize = 100;

	public QuickBooksCustomerOps()
	{
    }

    #region publicMethods
    public static String queryAll(String qbXMLCountry, short qbXMLMajorVer, short qbXMLMinorVer)
    {
        if (forceV1) qbXMLMajorVer = 1;

		// Create the session manager object using QBFC
		QBSessionManager sessionManager = new QBSessionManager();
   		// Get the RequestMsgSet based on the correct QB Version
        IMsgSetRequest requestSet = sessionManager.CreateMsgSetRequest(qbXMLCountry, qbXMLMajorVer, qbXMLMinorVer);

        if (qbXMLMajorVer >= 5) {
            return queryAllV5(sessionManager, requestSet);
        }
        else {
            return queryAllV1(sessionManager, requestSet);
        }
	}

    public static ICustomerRetList extractResponses(String response, String qbXMLCountry, short qbXMLMajorVer, short qbXMLMinorVer)
    {
        if (forceV1) qbXMLMajorVer = 1;

   		// Create the session manager object using QBFC
		QBSessionManager sessionManager = new QBSessionManager();
   		// Rebuild the response structure from the qbXML string
        IMsgSetResponse responseSet = sessionManager.ToMsgSetResponse(response, qbXMLCountry, qbXMLMajorVer, qbXMLMinorVer);

        // IResponse response = responseSet.ResponseList.GetAt(0);
        // int statusCode = response.StatusCode;
        // string statusMessage = response.StatusMessage;
        // string statusSeverity = response.StatusSeverity;
        // MessageBox.Show("Status:\nCode = " + statusCode + "\nMessage = " + statusMessage + "\nSeverity = " + statusSeverity);

        // I don't think this is V5 specific ... yet :-)

        //TAB: HACKHackhack - what if responseSet is null, or there's no ResponseList, or there are 0 items in the list
        // Handle all these cases better.
        ICustomerRetList customerRetList = (ICustomerRetList)(responseSet.ResponseList.GetAt(0).Detail) as ICustomerRetList;
        String lookie = customerRetList.ToString();

        return customerRetList;
    }

    public static Object hasMoreData(String response, Object lastQueryContext, String qbXMLCountry, short qbXMLMajorVer, short qbXMLMinorVer)
    {
        if (forceV1) qbXMLMajorVer = 1;

        // Create the session manager object using QBFC
        QBSessionManager sessionManager = new QBSessionManager();

        IMsgSetResponse responseSet = sessionManager.ToMsgSetResponse(response, qbXMLCountry, qbXMLMajorVer, qbXMLMinorVer);

        if (qbXMLMajorVer >= 5)
        {
            return hasMoreDataV5(sessionManager, responseSet, lastQueryContext);
        }
        else
        {
            return hasMoreDataV1(sessionManager, responseSet, lastQueryContext);
        }
    }

    public static string queryNext(Object queryContext, String qbXMLCountry, short qbXMLMajorVer, short qbXMLMinorVer)
    {
        if (forceV1) qbXMLMajorVer = 1;

        // Create the session manager object using QBFC
        QBSessionManager sessionManager = new QBSessionManager();

        // Get the RequestMsgSet based on the correct QB Version
        IMsgSetRequest requestSet = sessionManager.CreateMsgSetRequest(qbXMLCountry, qbXMLMajorVer, qbXMLMinorVer);

        if (qbXMLMajorVer >= 5)
        {
            return queryNextV5(sessionManager, requestSet, queryContext);
        }
        else
        {
            return queryNextV1(sessionManager, requestSet, queryContext);
        }
    }
    #endregion

    #region v5Implementations
    private static string queryAllV5(QBSessionManager sessionManager, IMsgSetRequest requestSet)
    {

        // Initialize the message set request object
        requestSet.Attributes.OnError = ENRqOnError.roeStop;

        // Add the request to the message set request object
        ICustomerQuery CustQ = requestSet.AppendCustomerQueryRq();
        CustQ.iterator.SetValue(ENiterator.itStart);

        CustQ.ORCustomerListQuery.CustomerListFilter.MaxReturned.SetValue(chunkSize);

        // TAB: NOTENotenote - Should exclude shipping address because of performance issues

        return requestSet.ToXMLString();
    }

    public static Object hasMoreDataV5(QBSessionManager sessionManager, IMsgSetResponse responseSet, Object lastQueryContext)
    {
        Object oReturn = null;

        int iRemain = responseSet.ResponseList.GetAt(0).iteratorRemainingCount;
        if (iRemain > 0)
        {
            oReturn = responseSet.ResponseList.GetAt(0).iteratorID;
        }
        return oReturn;
    }

    // TAB: MAxReturn comes in at 2.0
    // TAB: Don't support < 2005

    private static string queryNextV5(QBSessionManager sessionManager, IMsgSetRequest requestSet, Object queryContext)
    {
        // Initialize the message set request object
        requestSet.Attributes.OnError = ENRqOnError.roeStop;

        // Add the request to the message set request object
        ICustomerQuery CustQ = requestSet.AppendCustomerQueryRq();
        CustQ.iterator.SetValue(ENiterator.itContinue);
        CustQ.iteratorID.SetValue(queryContext.ToString());

        CustQ.ORCustomerListQuery.CustomerListFilter.MaxReturned.SetValue(chunkSize);

        return requestSet.ToXMLString();
    }
    #endregion

    #region V1Implementations
    private static string queryAllV1(QBSessionManager sessionManager, IMsgSetRequest requestSet)
    {

        // Initialize the message set request object
        requestSet.Attributes.OnError = ENRqOnError.roeStop;

        // Add the request to the message set request object
        ICustomerQuery CustQ = requestSet.AppendCustomerQueryRq();

        CustQ.ORCustomerListQuery.CustomerListFilter.ORNameFilter.NameRangeFilter.FromName.SetValue("0");
        // 41 Z's ... longest permitted is 41, so this should be the highest value
        CustQ.ORCustomerListQuery.CustomerListFilter.ORNameFilter.NameRangeFilter.ToName.SetValue("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");

        CustQ.ORCustomerListQuery.CustomerListFilter.MaxReturned.SetValue(chunkSize);

        return requestSet.ToXMLString();
    }

    public static Object hasMoreDataV1(QBSessionManager sessionManager, IMsgSetResponse responseSet, Object lastQueryContext)
    {
        Object oReturn = null;

        // Whatever the _highest_ name is in that group, we'll start the next search with that
        // we will get double entries on this name, but the caller can ignore that easily enough.
        if (responseSet == null)
            throw new Exception("responseSet is null");

        if (responseSet.ResponseList == null)
            throw new Exception("responseSet.ResponseList is null");

        if (responseSet.ResponseList.Count >= 1)
        {
            IResponse resp = responseSet.ResponseList.GetAt(0);
            if (resp == null)
                throw new Exception("responseSet.ResponseList is null");

            IResponseType type = resp.Type;
            if (ENResponseType.rtCustomerQueryRs.Equals(resp.Type))
                throw new Exception("Response is not a CustomerQueryRs");

            if (resp.Detail == null)
                throw new Exception("resp.Detail is null");

            int iStatusCode = resp.StatusCode;
            String sStatusMessage = resp.StatusMessage;
            String sStatusSeverity = resp.StatusSeverity;

            ICustomerRetList customerRetList = resp.Detail as ICustomerRetList;
            if (customerRetList == null)
                throw new Exception("customerRetList is null");

            int iCount = customerRetList.Count;
            if (customerRetList.Count > 0)
            {
                ICustomerRet customerRet = customerRetList.GetAt(iCount - 1);
                if (customerRet == null)
                    throw new Exception("customerRet is null");

                if (customerRet.FullName == null)
                    throw new Exception("customerRet.FullName is null");

                oReturn = customerRet.FullName.GetValue();
            }
        }
        if (oReturn.Equals(lastQueryContext))
        {
            // It looks like we're going to search from the same
            // context we did last time, which means we're at the
            // end of the line. No more results.
            oReturn = null;
        }
        else
        {
            lastQueryContext = null;
        }
        return oReturn;
    }

    private static string queryNextV1(QBSessionManager sessionManager, IMsgSetRequest requestSet, Object queryContext)
    {
        // Initialize the message set request object
        requestSet.Attributes.OnError = ENRqOnError.roeStop;

        // Add the request to the message set request object
        ICustomerQuery CustQ = requestSet.AppendCustomerQueryRq();

        CustQ.ORCustomerListQuery.CustomerListFilter.ORNameFilter.NameRangeFilter.FromName.SetValue((String)queryContext);
        // 41 Z's ... longest permitted is 41, so this should be the highest value
        CustQ.ORCustomerListQuery.CustomerListFilter.ORNameFilter.NameRangeFilter.ToName.SetValue("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");

        CustQ.ORCustomerListQuery.CustomerListFilter.MaxReturned.SetValue(chunkSize);

        return requestSet.ToXMLString();
    }
    #endregion
}
