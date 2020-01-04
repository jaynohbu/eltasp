<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CountryMaster.aspx.cs" Inherits="SiteAdmin_CountryMaster" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Countries</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../CSS/elt_css.css" type="text/css" rel="stylesheet" />

    <script src="../Include/JPTableDOM.js" type="text/jscript"></script>

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
        function resize_table(objName)
        {
            var x,y;
            if (self.innerHeight) // all except Explorer
            {
	            x = self.innerWidth;
	            y = self.innerHeight;
            }
            else if (document.documentElement && document.documentElement.clientHeight)
	            // Explorer 6 Strict Mode
            {
	            x = document.documentElement.clientWidth;
	            y = document.documentElement.clientHeight;
            }
            else if (document.body) // other Explorers
            {
	            x = document.body.clientWidth;
	            y = document.body.clientHeight;
            }
            if(document.getElementById(objName)!=null){
	            document.getElementById(objName).style.height=parseInt(y-
	            document.getElementById(objName).offsetTop - 160)+"px";
	        }	    
        }
        
        window.onresize = function(){
            resize_table("divAddedCountry"); resize_table("divNotAddedCountry");
        };
        window.onload = function(){
            resize_table("divAddedCountry"); resize_table("divNotAddedCountry");
        };
    </script>

</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
        <div style="text-align: center">
            <div class="pageheader" style="width: 95%; text-align: left">
                Countries
            </div>
            <div class="NewEntryDiv" style="width: 95%; text-align: left">
                <table cellpadding="4" cellspacing="0" border="0">
                    <tr>
                        <td class="bodyheader">
                            Countries Added
                        </td>
                        <td class="bodyheader">
                            All Countries (Not Added)
                        </td>
                    </tr>
                    <tr valign="top">
                        <td>
                            <div style="width: 350px; overflow: scroll; border: solid 1px #cdcdcd" id="divAddedCountry">
                            <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource1" CellPadding="1"
                                AutoGenerateColumns="false" OnRowCommand="GridView1_RowCommand" AlternatingRowStyle-BackColor="#eeeeee">
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <table border="0" cellpadding="0" cellspacing="0" style="width: 320px; background-color: #DDDDED"
                                                class="gridViewTable">
                                                <tr>
                                                    <td style="width: 60px">
                                                    </td>
                                                    <td style="width: 220px">
                                                        <b>Country</b>
                                                    </td>
                                                    <td>
                                                        <b>Code</b>
                                                    </td>
                                                </tr>
                                            </table>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <table border="0" cellpadding="0" cellspacing="0" style="width: 320px" class="gridViewTable"
                                                id="tblAdded">
                                                <tr>
                                                    <td style="width: 60px">
                                                        <asp:ImageButton ID="btnDelete" CommandName="Remove" runat="server" CommandArgument='<%# Eval("country_code")%>'
                                                            ImageUrl="../Images/button_delete.gif" />
                                                    </td>
                                                    <td style="width: 220px">
                                                        <%# Eval("country_name")%>
                                                    </td>
                                                    <td>
                                                        <%# Eval("country_code")%>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            </div>
                        </td>
                        <td>
                            <div style="width: 350px; overflow: scroll; border: solid 1px #cdcdcd" id="divNotAddedCountry">
                            <asp:GridView ID="GridView2" runat="server" DataSourceID="SqlDataSource2" CellPadding="1"
                                AutoGenerateColumns="false" OnRowCommand="GridView2_RowCommand" AlternatingRowStyle-BackColor="#eeeeee">
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <table border="0" cellpadding="0" cellspacing="0" style="width: 320px; background-color: #DDDDED"
                                                class="gridViewTable">
                                                <tr>
                                                    <td style="width: 60px">
                                                    </td>
                                                    <td style="width: 220px">
                                                        <b>Country</b>
                                                    </td>
                                                    <td>
                                                        <b>Code</b>
                                                    </td>
                                                </tr>
                                            </table>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <table border="0" cellpadding="0" cellspacing="0" style="width: 320px" class="gridViewTable"
                                                id="tblNotAdded">
                                                <tr>
                                                    <td style="width: 60px">
                                                        <asp:ImageButton ID="btnAdd" CommandName="Add" runat="server" CommandArgument='<%# Eval("country_code")%>'
                                                            ImageUrl="../Images/button_add.gif" />
                                                    </td>
                                                    <td style="width: 220px">
                                                        <%# Eval("country_name")%>
                                                    </td>
                                                    <td>
                                                        <%# Eval("country_code")%>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button ID="btnDeleteAll" runat="server" Text="Delete all countries" OnClick="btnDeleteAll_Click"
                                CssClass="bodycopy" />
                        </td>
                        <td>
                            <asp:Button ID="btnAddAll" runat="server" Text="Add all countries" OnClick="btnAddAll_Click"
                                CssClass="bodycopy" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" OnInit="SqlDataSource1_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" OnInit="SqlDataSource2_Init"></asp:SqlDataSource>
    </form>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
