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
/// Summary description for SynchronizationController
/// </summary>
public class SynchronizationController: IController
{
    enum ControllerStates { Start=0, 
        HackRequest1,
        HackResponse1,
        HackRequest2,
        HackResponse2,
        HackRequest3,
        HackResponse3,
        
        End=9999 };

	public SynchronizationController()
	{
		//   
		// TODO: Add constructor logic here
		//
	}

    public bool haveAnyWork(Session sess)
    {
        // TAB: HACKHackhack - clearly I need a better implementation :-)
        return true;
    }

    public String getNextAction(Session sess)
    {
        ControllerStates controllerState = ControllerStates.HackRequest1;
        String action;
        int completion = 0;

        if (sess.getProperty("controllerState") != null)
        {
            controllerState = (ControllerStates)sess.getProperty("controllerState");
        }

        if (controllerState == ControllerStates.HackRequest1)
        {
            action = "<?xml version=\"1.0\"?><?qbxml version=\"4.0\"?><QBXML><QBXMLMsgsRq onError=\"stopOnError\"><CustomerQueryRq requestID=\"1\"><MaxReturned>1</MaxReturned></CustomerQueryRq></QBXMLMsgsRq></QBXML>";
            controllerState = ControllerStates.HackResponse1;
            completion = 33;
        }
        else if (controllerState == ControllerStates.HackRequest2)
        {
            action = "<?xml version=\"1.0\"?><?qbxml version=\"4.0\"?><QBXML><QBXMLMsgsRq onError=\"stopOnError\"><InvoiceQueryRq requestID=\"2\"><MaxReturned>1</MaxReturned></InvoiceQueryRq></QBXMLMsgsRq></QBXML>";
            controllerState = ControllerStates.HackResponse2;
            completion = 66;
        }
        else if (controllerState == ControllerStates.HackRequest3)
        {
            action = "<?xml version=\"1.0\"?><?qbxml version=\"4.0\"?><QBXML><QBXMLMsgsRq onError=\"stopOnError\"><InvoiceQueryRq requestID=\"2\"><MaxReturned>1</MaxReturned></InvoiceQueryRq></QBXMLMsgsRq></QBXML>";
            controllerState = ControllerStates.HackResponse3;
            completion = 100;
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

        return action;
    }

    public int processLastAction(Session sess, String response)
    {
        ControllerStates controllerState = ControllerStates.Start;
        int completion = 0;

        if (sess.getProperty("controllerState") != null)
        {
            controllerState = (ControllerStates)sess.getProperty("controllerState");
        }

        if (controllerState == ControllerStates.HackResponse1)
        {
            controllerState = ControllerStates.HackRequest2;
            completion = 66;
        }
        else if (controllerState == ControllerStates.HackResponse2)
        {
            controllerState = ControllerStates.HackRequest3;
            completion = 100;
        }
        else if (controllerState == ControllerStates.End)
        {
            // Should not get here, previous completion=100 should terminate sequence.
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
