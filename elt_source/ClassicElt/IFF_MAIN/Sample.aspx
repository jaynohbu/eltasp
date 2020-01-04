<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Sample.aspx.cs" Inherits="Sample" %>

<%@ Register src="LabelPrinting.ascx" tagname="LabelPrinting" tagprefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Web Client Print Test Page</title>
    <script src="Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
  
</head>
<body>
    <form id="form1" runat="server">
   
   
    <uc1:LabelPrinting ID="LabelPrinting1" runat="server" />
    <br />
    <br />
    <br />
   
   
    </form>
</body>
</html>
