<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LabelPrinting.ascx.cs" Inherits="LabelPrinting" %>
 <%=Neodynamic.SDK.Web.WebClientPrint.CreateScript()%>
<a href="#" id="labelPrintBtn" onclick="alert('clicked');jsWebClientPrint.print('sid=<%=Session.SessionID%>');">
            Print</a>