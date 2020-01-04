<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SBSelect.aspx.cs" Inherits="ASPX_OnLines_ScheduleB_SBSelect" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Schedule B</title>
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
        function go_scheduleB()
        {
            var vURL = "/IFF_MAIN/ASPX/Misc/EditSB.aspx?SBID=&orgID=" + document.getElementById("hOrgID").value;
            var vWinArg = "dialogWidth:460px; dialogHeight:315px; help:no; status:no; scroll:no; center:yes";
            var vReturn = showModalDialog(vURL, "popWindow", vWinArg);

            if(vReturn != null && vReturn != undefined){
                window.location.href = "./SBSelect.aspx?OrgID=" + document.getElementById("hOrgID").value;
            }
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hOrgID" runat="server" />
        <asp:Label ID="txtResultBox" runat="server" Visible="false" />
        <div class="NewEntryDiv">
            <ul>
                <li>
                    <div style="width: 380px;" class="pageheader">
                        Schedule B Added</div>
                    <div style="width: 380px; height: 470px; overflow: scroll; border: solid 1px #cdcdcd">
                        <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource1" CellPadding="1"
                            AutoGenerateColumns="false" OnRowCommand="GridView1_RowCommand" AlternatingRowStyle-BackColor="#ecf7f8">
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 350px; background-color: #ccebed"
                                            class="gridViewTable">
                                            <tr>
                                                <td style="width: 15%">
                                                </td>
                                                <td style="width: 30%">
                                                    <b>Schedule B</b>
                                                </td>
                                                <td style="width: 55%">
                                                    <b>Description</b>
                                                </td>
                                            </tr>
                                        </table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 350px" class="gridViewTable"
                                            id="tblAdded">
                                            <tr>
                                                <td style="width: 15%">
                                                    <asp:Button ID="btnDelete" CommandName="Remove" runat="server" Text="DEL" CommandArgument='<%# Eval("sb_id")%>'
                                                        CssClass="bodycopy" />
                                                </td>
                                                <td style="width: 30%">
                                                    <%# Eval("sb")%>
                                                </td>
                                                <td style="width: 55%">
                                                    <%# Eval("description")%>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div style="width: 380px;">
                        <br />
                        <asp:Button ID="btnDeleteAll" runat="server" Text="Delete all schedule B" OnClick="btnDeleteAll_Click"
                            CssClass="bodycopy" />
                        <input type="button" onclick="go_scheduleB();" value="Add new schedule B" class="bodycopy" />
                    </div>
                </li>
                <li>
                    <div style="width: 380px;" class="pageheader">
                        All Schedule B (Not Added)</div>
                    <div style="width: 380px; height: 470px; overflow: scroll; border: solid 1px #cdcdcd"">
                        <asp:GridView ID="GridView2" runat="server" DataSourceID="SqlDataSource2" CellPadding="1"
                            AutoGenerateColumns="false" OnRowCommand="GridView2_RowCommand" AlternatingRowStyle-BackColor="#ecf7f8">
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 350px; background-color: #ccebed"
                                            class="gridViewTable">
                                            <tr>
                                                <td style="width: 15%">
                                                </td>
                                                <td style="width: 30%">
                                                    <b>Schedule B</b>
                                                </td>
                                                <td style="width: 55%">
                                                    <b>Description</b>
                                                </td>
                                            </tr>
                                        </table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 350px" class="gridViewTable"
                                            id="tblAdded">
                                            <tr>
                                                <td style="width: 15%">
                                                    <asp:Button ID="btnAdd" CommandName="Add" runat="server" Text="Add" CommandArgument='<%# Eval("sb_id")%>'
                                                        CssClass="bodycopy" />
                                                </td>
                                                <td style="width: 30%">
                                                    <%# Eval("sb")%>
                                                </td>
                                                <td style="width: 55%">
                                                    <%# Eval("description")%>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div style="width: 380px;">
                        <br />
                        <asp:Button ID="btnAddAll" runat="server" Text="Add all schedule B" OnClick="btnAddAll_Click"
                            CssClass="bodycopy" /></div>
                </li>
            </ul>
        </div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" OnInit="SqlDataSource1_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" OnInit="SqlDataSource2_Init"></asp:SqlDataSource>
    </form>
</body>
</html>
