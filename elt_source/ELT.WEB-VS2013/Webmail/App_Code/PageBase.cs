using System;
using System.Linq;
using System.Collections.Generic;
using System.Web;
using System.Web.UI.WebControls;
using DevExpress.Web.ASPxEditors;
using DevExpress.Web.ASPxSplitter;
using DevExpress.XtraScheduler;
using DevExpress.XtraScheduler.iCalendar;
using DevExpress.Web.ASPxNavBar;
using System.Collections;
using System.Web.SessionState;
using ELT.BL;
public  class PageBase : System.Web.UI.Page
{
    protected void Page_PreInit(object sender, EventArgs e)
    {

       
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        AuthenticationBL aBl = new AuthenticationBL();
        aBl.UnifiySession(HttpContext.Current);       
    }

 

    protected void Page_Load(object sender, EventArgs e)
    {
       
    }


}