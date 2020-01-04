<%@ Application Language="C#" %>

<script runat="server">
    void Application_PreRequestHandlerExecute(object sender, EventArgs e) {
        DevExpress.Web.ASPxClasses.ASPxWebControl.GlobalTheme = Utils.CurrentTheme;
    }
    void Application_Start(Object sender, EventArgs e) {
        DevExpress.Web.ASPxClasses.Internal.DemoUtils.RegisterDemo("WebMailClient");
    }
</script>
