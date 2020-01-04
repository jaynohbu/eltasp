<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ModuleManagerVer2.aspx.cs"
    Inherits="SystemAdmin_ModuleManagerVer2" CodePage="65001" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Module Manager</title>
    <link href="../ASPX/css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        
        *{
		    list-style:none;
		    text-decoration:none;
		    margin: 0;
		    padding: 0 0 0 0px;
	    }
	    
	    #NewEntryDiv {
	        width: 500px;
	        
	    }
	    
	    #NewEntryDiv li{ 
	        /*float: left;*/
	        padding-right: 10px;
	        padding-left: 5px;
	    }
	    
	    .clear {
	        clear: both;
	        /*display: block;*/
	        width: 200px;  
	        font: 9pt Verdana;
	    }
	    
	    input {
	        font: 9pt Verdana;
	        margin: 0;
	        padding: 0;
	    }
	    
    </style>
</head>
<body>
    <br />
    <form id="form1" runat="server">
        <asp:HiddenField ID="hPageId" runat="server" Value="" />
        <table cellpadding="2" cellspacing="0" border="0">
            <tr>
                <td>
                    <div style="overflow-y: scroll; width: 250px; height: 600px; margin-left:10px; border:solid 1px #aaaaaa">
                        <asp:TreeView ID="TreeView1" runat="server" OnSelectedNodeChanged="TreeView1_SelectedNodeChanged">
                            <LevelStyles>
                                <asp:TreeNodeStyle CssClass="bodyheader" />
                                <asp:TreeNodeStyle CssClass="bodyheader" />
                                <asp:TreeNodeStyle CssClass="bodyheader" />
                            </LevelStyles>
                        </asp:TreeView>
                    </div>
                </td>
                <td style="vertical-align: top">
                    <div id="NewEntryDiv" style="margin-left:15px">
                        <ul>
                            <li style="height:25px; margin-right:5px">
                                <label class="clear">
                                    Top Module</label>
                                <asp:TextBox ID="txtTopModule" runat="server" Width="120px" ></asp:TextBox>
                            </li>
                            <li style="height:25px; margin-right:5px">
                                <label class="clear">
                                    Sub Module</label>
                                <asp:TextBox ID="txtSubModule" runat="server" Width="150px" ></asp:TextBox>
                            </li>
                            <li style="height:25px; margin-right:5px">
                                <label class="clear">
                                    Page Label</label>
                                <asp:TextBox ID="txtPageLabel" runat="server" Width="150px" ></asp:TextBox>
                            </li>
                            <li style="height:25px; margin-right:5px">
                                <label class="clear">
                                    Page URL</label>
                                <asp:TextBox ID="txtPageURL" runat="server" Width="250px" ></asp:TextBox>
                            </li>
                            <li style="height:25px; margin-right:5px">
                                <label class="clear">
                                    Active</label>
                                <asp:CheckBox ID="chkPageStatus" runat="server" />
                            </li>
                            <li style="height:25px; margin-right:5px">
                                <label class="clear">
                                    Page Access</label>
                                <asp:DropDownList ID="lstAccessLevel" runat="server" Width="110px" CssClass="clear">
                                    <asp:ListItem Text="Standard" Value="ALL" />
                                    <asp:ListItem Text="Premium" Value="LIMIT" />
                                </asp:DropDownList>
                            </li>
                            <li style="height:25px; margin-right:5px">
                                <label class="clear">
                                    Top ID</label>
                                <asp:TextBox runat="server" ID="txtTopSeqId" Text="" Width="50px" />
                                <label class="clear">
                                    Sub ID</label>
                                <asp:TextBox runat="server" ID="txtSubSeqId" Text="" Width="50px" />
                                <label class="clear">
                                    Page ID</label>
                                <asp:TextBox runat="server" ID="txtPageSeqId" Text="" Width="50px" />
                            </li>
                            <li></li>
                            <li>
                                <asp:Button runat="server" Text="Save" CssClass="bodycopy" OnClick="SaveButtonClick" />
                                &nbsp;<asp:Button runat="server" Text="Delete" CssClass="bodycopy" OnClick="DeleteButtonClick" />
                                &nbsp;<input type="button" class="bodycopy" value="Reset" onclick="document.location.href='ModuleManagerVer2.aspx';" />
                            </li>
                        </ul>
                    </div>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
