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

// Questions for reviewer to consider:
//
// Consider whether we should use a data driven model for state transitions.
// Where each transition is then dependent on a few different factors, maybe:
//    current state, of course
//    hasMoreData()
//    error condition in last data parse

/// <summary>
/// SampleController implements the functionality of the original WCWebService
/// sample. I.e. it will do three send/receive cycles containing:
///     CustomerQuery
///     InvoiceQuery
///     BillQuery
/// </summary>
public class SampleController: IController
{
    /// <summary>
    /// In general we transition from Do*Query to Get*Response,
    /// but if there is more data than will fit in one response,
    /// then we go into a More*Query state which alternates
    /// 
    /// </summary>
    enum ControllerStates {
        Start=0,
        DoCustomerQuery=0,
        MoreCustomerQuery,      // A continuation state, there is more data to process
        GetCustomerResponse,
        DoInvoiceQuery,
        GetInvoiceResponse,
        DoBillQuery,
        GetBillResponse,
        End=9999 };

	public SampleController()
	{
	}

    public bool haveAnyWork(Session sess)
    {
        // The sample always has this same set of work to do :-)
        return true;
    }

    /// <summary>
    /// Called by sendRequestXML to determine what is sent next.
    /// Corresponds to states Start and *Query states.
    /// </summary>
    /// <param name="sess"></param>
    /// <param name="localData"></param>
    /// <returns></returns>
    public String getNextAction(Session sess)
    {
        ControllerStates controllerState = ControllerStates.DoCustomerQuery;
        String action;

        LocalData localData = XMLDataStore.getLocalData(sess.getUsername(), sess.getPassword());

        if (localData.getFirstAccess().Equals(localData.getLastAccess()))
        {
            // This data was just created, ergo we have an unknown
            // remote state.
        }

        if (sess.getProperty("controllerState") != null)
        {
            controllerState = (ControllerStates)sess.getProperty("controllerState");
        }

        if (controllerState == ControllerStates.DoCustomerQuery)
        {
            action = QuickBooksCustomerOps.queryAll(sess.getCountry(), sess.getMajorVers(), sess.getMinorVers());
            controllerState = ControllerStates.GetCustomerResponse;
        }
        else if (controllerState == ControllerStates.MoreCustomerQuery)
        {
            Object queryContext = sess.getProperty("queryContext");
            action = QuickBooksCustomerOps.queryNext(queryContext, sess.getCountry(), sess.getMajorVers(), sess.getMinorVers());
            controllerState = ControllerStates.GetCustomerResponse;
        }
        else if (controllerState == ControllerStates.DoInvoiceQuery)
        {
            action = "<?xml version=\"1.0\"?><?qbxml version=\"4.0\"?><QBXML><QBXMLMsgsRq onError=\"stopOnError\"><InvoiceQueryRq requestID=\"2\"><MaxReturned>1</MaxReturned></InvoiceQueryRq></QBXMLMsgsRq></QBXML>";
            controllerState = ControllerStates.GetInvoiceResponse;
        }
        else if (controllerState == ControllerStates.DoBillQuery)
        {
            action = "<?xml version=\"1.0\"?><?qbxml version=\"4.0\"?><QBXML><QBXMLMsgsRq onError=\"stopOnError\"><InvoiceQueryRq requestID=\"2\"><MaxReturned>1</MaxReturned></InvoiceQueryRq></QBXMLMsgsRq></QBXML>";
            controllerState = ControllerStates.GetBillResponse;
        }
        else if (controllerState == ControllerStates.End)
        {
            // Should not get here, previous completion=100 should terminate sequence.
            throw new Exception("getNextAction: Unexpected state: End");
        }
        else
        {
            throw new Exception("getNextAction: Unexpected state: " + controllerState);
        }

        sess.setProperty("controllerState", controllerState);

        XMLDataStore.putLocalData(localData, sess.getUsername(), sess.getPassword());

        return action;
    }

    /// <summary>
    /// Called by receiveResponseXML to process the last data received.
    /// Corresponds to states Get*Response
    /// </summary>
    /// <param name="sess"></param>
    /// <param name="localData"></param>
    /// <param name="response"></param>
    /// <returns></returns>
    public int processLastAction(Session sess, String response)
    {
        ControllerStates controllerState = ControllerStates.Start;
        int completion = 0;

        if (sess.getProperty("controllerState") != null)
        {
            controllerState = (ControllerStates)sess.getProperty("controllerState");
        }

        if (controllerState == ControllerStates.GetCustomerResponse)
        {
            ICustomerRetList customerRetList = QuickBooksCustomerOps.extractResponses(response, sess.getCountry(), sess.getMajorVers(), sess.getMinorVers());

			if (customerRetList.Count > 0)
			{
        for (int ndx=0; ndx < customerRetList.Count; ndx++)
        {
            ICustomerRet customerRet=customerRetList.GetAt(ndx);
            String sFullName = customerRet.FullName.GetValue();
        }
			}
            Object queryContext = QuickBooksCustomerOps.hasMoreData(response, sess.getProperty("queryContext"), sess.getCountry(), sess.getMajorVers(), sess.getMinorVers());
            if (queryContext != null)
            {
                sess.setProperty("queryContext", queryContext);
                controllerState = ControllerStates.MoreCustomerQuery;
            }
            else
            {
                controllerState = ControllerStates.DoInvoiceQuery;
            }
            completion = 33;
        }
        else if (controllerState == ControllerStates.GetInvoiceResponse)
        {
            controllerState = ControllerStates.DoBillQuery;
            completion = 66;
        }
        else if (controllerState == ControllerStates.GetBillResponse)
        {
            controllerState = ControllerStates.End;
            completion = 100;
        }
        else if (controllerState == ControllerStates.End)
        {
            throw new Exception("processLastAction: Unexpected state: End");
        }
        else
        {
            throw new Exception("processLastAction: Unexpected state: " + controllerState);
        }

        sess.setProperty("controllerState", controllerState);

        return completion;
    }
}
