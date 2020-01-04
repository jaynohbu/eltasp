<%@ Application Inherits="IFF_V1.Global" Language="C#" %>
<script runat="server">
  void Session_Start(object sender, EventArgs e) 
    {
        // Code that runs when a new session is started
        
        //This is needed so the SessionID does not change on every postback
        //http://msdn.microsoft.com/en-us/library/system.web.sessionstate.httpsessionstate.sessionid.aspx
        Session.Add("wcp", "started");
    }
</script>