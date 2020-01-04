<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LabelPrintUtil.aspx.cs" Inherits="LabelPrintUtil" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
   <%=Neodynamic.SDK.Web.WebClientPrint.CreateScript()%>
   <script type="text/javascript">
       function SetPrintLabelText(str) {         
           var sid = '<%=Session.SessionID%>';
           PageMethods.SetPrintCommand(sid + "_" + str, onSucess, onError);
       }
       function onSucess(result) {
           $("[id$='labelPrintBtn']").click();
       }
       function onError(result) {
           alert(result.responseText);
       }

    </script>
</head>
<body>
    <form id="form1" runat="server">
     <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
    <div>
     <a href="#" id="labelPrintBtn" onclick="jsWebClientPrint.print('sid=<%=Session.SessionID%>');" style="display:none"/>

    </div>
    </form>
</body>
</html>
