<%@ Page language="c#" Inherits="IFF_MAIN.ASPX.Reports.Accounting.ReconcileReport" trace="false" CodeFile="ReconcileReport.aspx.cs" %>
<%@ Register TagPrefix="uc1" TagName="rdSelectDateControl1" Src="../SelectionControls/rdSelectDateControl1.ascx" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML >
  <HEAD>
		<title>Invoice Queue</title>
		<META http-equiv=Content-Type content="text/html; charset=euc-kr">
		<meta content="Microsoft Visual Studio .NET 7.1" name=GENERATOR>
		<meta content=C# name=CODE_LANGUAGE>
		<meta content=JavaScript name=vs_defaultClientScript>
		<meta content=http://schemas.microsoft.com/intellisense/ie5 name=vs_targetSchema>
		
        <script type="text/javascript" language="javascript" src="../../ASP/ajaxFunctions/ajax.js"></script>
       
		<LINK href="../CSS/AppStyle.css" type=text/css rel=stylesheet>
<!--  #INCLUDE FILE="../include/common.htm" -->
<style type="text/css">
<!--
body {
	margin: 0;
	padding: 0;
}
-->
</style>

    
</HEAD>
	<BODY>
		<form id=form1 method=post runat="server">			
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td width="30%" align="left" valign="middle" class="pageheader" style="height: 53px">
                Reconcile rEPORT</td>
			<td width="70%" align="right" valign="baseline" style="height: 53px"><span class="labelSearch"></span>&nbsp;<!-- Search -->
			</td>
		</tr>
	</table>
            
            

			<P style="text-align: left">
                &nbsp; &nbsp;&nbsp;
                <table width="90%" border="0" align="center" cellpadding="2" cellspacing="0" bordercolor="#89A979" class="border1px" id="Table2">
                    <tr align="left" bgcolor="#ffffff" valign="middle" class="bodycopy">
                        <td class="bodycopy">
                        </td>
                        <td class="bodyheader" style="width: 335px">
                            Bank Account
                        </td>
                        <td class="bodyheader" style="width: 5px">
                            Statement Ending Date
                        </td>
                        <td class="bodyheader">
                        </td>
                    </tr>
                    <tr align="left" bgcolor="#ffffff" valign="middle">
                        <td class="bodyheader" style="height: 22px">
                        </td>
                        <td style="width: 335px; height: 22px">
                            <asp:DropDownList ID="ddlBankAcct" runat="server" CssClass="smallselect" Height="18px"
                                Width="150px" AutoPostBack="True" OnSelectedIndexChanged="ddlBankAcct_SelectedIndexChanged">
                            </asp:DropDownList></td>
                        <td style="width: 5px; height: 22px">
                            <asp:DropDownList ID="ddlSTendingDate" runat="server" DataTextField="statement_ending_date"
                                Width="240px">
                            </asp:DropDownList></td>
                        <td style="height: 22px">
                            </td>
                    </tr>
            </table>                         
                <!-- end --></P>
	</form>
		<SCRIPT type=text/javascript>
			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1 Webdatetimeedit2");
		</SCRIPT>
		
		


</BODY>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</HTML>
