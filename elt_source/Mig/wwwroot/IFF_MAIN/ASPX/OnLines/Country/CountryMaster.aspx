<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CountryMaster.aspx.cs" 
Inherits="ASPX_OnLines_Country_CountryMaster" CodePage="65001" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Countries</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../../CSS/elt_css.css" type="text/css" rel="stylesheet" />

    <script src="../../../ASP/include/JPTableDOM.js" type="text/jscript"></script>

    <style type="text/css">
        *{
		    list-style:none;
		    text-decoration:none;
		    margin: 0;
	    }
	    body{
	        margin: 5px 5px 5px 5px;
	    }
	    .NewEntryDiv {
	        width: 800px;
	        
	    }
	    .NewEntryDiv li{ 
	        float: left;
	        padding-right: 10px;
	        padding-left: 5px;
	    }
	    .clear {
	        clear: both;
	        display: block;
	        width: 200px;  
	        font: 0.65em/1.2em Verdana;
	    }
	    
	    .gridViewTable {
	        table-layout:fixed;
	        border-collapse: collapse;
	     }
	     
        .gridViewTable td {
	        padding: 1px 1px 1px 1px;
	        text-overflow:ellipsis;
	        overflow:hidden;
	        white-space:nowrap;
	        text-align:left;
	        font: 0.65em/1.2em Verdana;
         } 
         
    </style>

    <script type="text/jscript">
    
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="NewEntryDiv">
            <ul>
                <li>
                    <div style="width: 350px;" class="pageheader">
                        Countries Added</div>
                    <div style="width: 350px; height: 470px; overflow: scroll; border: solid 1px #cdcdcd">
                        <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource1" CellPadding="1"
                            AutoGenerateColumns="false" OnRowCommand="GridView1_RowCommand" AlternatingRowStyle-BackColor="#eeeeee">
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 320px; background-color: #cccccc"
                                            class="gridViewTable">
                                            <tr>
                                                <td style="width: 15%">
                                                </td>
                                                <td style="width: 70%">
                                                    <b>Country</b>
                                                </td>
                                                <td style="width: 15%">
                                                    <b>Code</b>
                                                </td>
                                            </tr>
                                        </table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 320px" class="gridViewTable"
                                            id="tblAdded">
                                            <tr>
                                                <td style="width: 15%">
                                                    <asp:Button ID="btnDelete" CommandName="Remove" runat="server" Text="DEL" CommandArgument='<%# Eval("country_code")%>'
                                                        CssClass="bodycopy" />
                                                </td>
                                                <td style="width: 70%">
                                                    <%# Eval("country_name")%>
                                                </td>
                                                <td style="width: 15%">
                                                    <%# Eval("country_code")%>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div style="width: 350px;">
                        <br />
                        <asp:Button ID="btnDeleteAll" runat="server" Text="Delete all countries" OnClick="btnDeleteAll_Click"
                            CssClass="bodycopy" /></div>
                </li>
                <li>
                    <div style="width: 350px;" class="pageheader">
                        All Countries (Not Added)</div>
                    <div style="width: 350px; height: 470px; overflow: scroll; border: solid 1px #cdcdcd"">
                        <asp:GridView ID="GridView2" runat="server" DataSourceID="SqlDataSource2" CellPadding="1"
                            AutoGenerateColumns="false" OnRowCommand="GridView2_RowCommand" AlternatingRowStyle-BackColor="#eeeeee">
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 320px; background-color: #cccccc"
                                            class="gridViewTable">
                                            <tr>
                                                <td style="width: 15%">
                                                </td>
                                                <td style="width: 70%">
                                                    <b>Country</b>
                                                </td>
                                                <td style="width: 15%">
                                                    <b>Code</b>
                                                </td>
                                            </tr>
                                        </table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 320px" class="gridViewTable"
                                            id="tblNotAdded">
                                            <tr>
                                                <td style="width: 15%">
                                                    <asp:Button ID="btnAdd" CommandName="Add" runat="server" Text="Add" CommandArgument='<%# Eval("country_code")%>'
                                                        CssClass="bodycopy" />
                                                </td>
                                                <td style="width: 70%">
                                                    <%# Eval("country_name")%>
                                                </td>
                                                <td style="width: 15%">
                                                    <%# Eval("country_code")%>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div style="width: 350px;">
                        <br />
                        <asp:Button ID="btnAddAll" runat="server" Text="Add all countries" OnClick="btnAddAll_Click"
                            CssClass="bodycopy" /></div>
                </li>
            </ul>
        </div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" OnInit="SqlDataSource1_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" OnInit="SqlDataSource2_Init"></asp:SqlDataSource>
    </form>
</body>
</html>
