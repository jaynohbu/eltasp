<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CompanySearchResult.aspx.cs"
    Inherits="ASPX_OnLines_CompanyConfig_CompanySearchResult" %>

<%--<%@ Register Assembly="CrystalDecisions.Web, Version=11.5.3700.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Client Search</title>
    <style type="text/css">

    .tableHeader {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
	color: #000000;
	text-transform: none;
	text-align: center;
    }
        
    .tableContent {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 9px;
	color: #000000;
	text-transform: none;
    }
    
    .tableFooter {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
	color: #000000;
	text-transform: none;
	text-align: right;
    }
    
    </style>

    <script type="text/javascript">
    
    function call_win(arg) {
        POP = window.open(arg, "_blank","menubar=1,toolbar=1,location=0,directory=0,status=1,scrollbars=1,resizable=1,width=900,height=600");
	    POP.focus(); 
	}
	
    </script>

</head>
<body style="margin: 0px 0px 0px 0px;">
    <form id="form1" runat="server">
        <div>
            <table border="0" cellpadding="1" cellspacing="1">
                <tr>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="width: 60Px">
                                    <asp:ImageButton ID="BACK" runat="server" ImageUrl="../../../Images/button_back.gif"
                                        OnClick="SearchNew" /></td>
                                <td style="width: 60Px">
                                    <asp:ImageButton ID="PDF" runat="server" ImageUrl="../../../Images/button_pdf.gif"
                                        OnClick="ExportToPDF" /></td>
                                <td style="width: 60Px">
                                    <asp:ImageButton ID="DOC" runat="server" ImageUrl="../../../Images/button_doc.gif"
                                        OnClick="ExportToDOC" /></td>
                                <td style="width: 60Px">
                                    <asp:ImageButton ID="Excel" runat="server" ImageUrl="../../../Images/button_exel.gif"
                                        OnClick="ExportToExcel" /></td>
                                <td style="width: 60Px">
                                    <asp:ImageButton ID="XML" runat="server" ImageUrl="../../../Images/button_xmlg.gif"
                                        OnClientClick="call_win('XMLReport.ashx');"/></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:DataGrid ID="DataGrid1" runat="server" AllowPaging="True" AllowCustomPaging="True"
                            OnPageIndexChanged="SelectedIndexChanged" OnItemCreated="ItemCreated">
                            <HeaderStyle ForeColor="White" Height="20px" BackColor="DimGray" CssClass="tableHeader" />
                            <ItemStyle CssClass="tableContent" BackColor="#E0E0E0" />
                            <AlternatingItemStyle BackColor="White" />
                            <PagerStyle Height="50px" Mode="NumericPages" BorderStyle="None" CssClass="tableFooter" />
                        </asp:DataGrid>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
