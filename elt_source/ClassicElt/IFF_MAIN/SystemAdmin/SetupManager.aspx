<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SetupManager.aspx.cs" Inherits="SystemAdmin_SetupManager" CodePage="65001" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Setup Manager</title>
    <link type="text/css" rel="stylesheet" href="/IFF_MAIN/ASPX/CSS/elt_css.css" />
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
	        padding-left: 10px;
	    }
	    .clear {
	        clear: both;
	        display: block;
	        width: 200px;  
	        font: 0.65em/1.2em Verdana;
	    }
    </style>

    <script type="text/jscript">
        function get_confirm(arg){
            return confirm("Click OK to proceed: " + arg);
        }
    </script>

</head>
<body>
    <br />
    <form id="form1" runat="server">
        <asp:HiddenField ID="hSeqId" runat="server" Value="" />
        <asp:HiddenField ID="hPageId" runat="server" Value="" />
        <div id="NewEntryDiv" style="margin-left: 10px">
            <table cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td valign="top">
                        <asp:ListBox ID="ListBox1" runat="server" Height="450px" Width="300px" OnSelectedIndexChanged="ListBox1_SelectedIndexChanged"
                            AutoPostBack="True"></asp:ListBox>
                    </td>
                    <td valign="top">
                        <ul>
                            <li>
                                <label class="clear">
                                    Page Title</label>
                                <asp:TextBox ID="txtPageTitle" runat="server" CssClass="m_shorttextfield" MaxLength="35"
                                    Width="200px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPageTitle" runat="server" ControlToValidate="txtPageTitle"
                                    ErrorMessage="*"></asp:RequiredFieldValidator>
                            </li>
                            <li>
                                <label class="clear">
                                    Setup URL</label>
                                <asp:TextBox ID="txtPageURL" runat="server" CssClass="m_shorttextfield" MaxLength="128"
                                    Width="300px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPageURL" runat="server" ControlToValidate="txtPageURL"
                                    ErrorMessage="*"></asp:RequiredFieldValidator>
                            </li>
                            <li>
                                <label class="clear">
                                    Validation URL</label>
                                <asp:TextBox ID="txtValidURL" runat="server" CssClass="m_shorttextfield" MaxLength="128"
                                    Width="300px"></asp:TextBox>
                            </li>
                            <li>
                                <label class="clear">
                                    Setup Type</label>
                                <asp:DropDownList ID="lstSetupType" runat="server" Width="100px">
                                    <asp:ListItem Value="Required" Text="Required"></asp:ListItem>
                                    <asp:ListItem Value="Optional" Text="Optional"></asp:ListItem>
                                </asp:DropDownList>
                            </li>
                            <li>
                                <label class="clear">
                                    Instruction Text</label>
                                <asp:TextBox ID="txtRemark" runat="server" CssClass="m_shorttextfield" Rows="8" TextMode="MultiLine"
                                    Width="350px"></asp:TextBox>
                            </li>
                            <li>
                                <label class="clear">
                                    &nbsp;</label>
                                <input type="button" value="New Page" class="bodycopy" onclick="javascript:window.location='/IFF_MAIN/SystemAdmin/SetupManager.aspx';"
                                    style="width: 100px" />
                            </li>
                            <li>
                                <label class="clear">
                                    &nbsp;</label>
                                <asp:Button runat="server" Text="Save Page" ID="btnSave" OnClick="btnSave_Click"
                                    CssClass="bodycopy" Width="100px" />
                            </li>
                            <li>
                                <label class="clear">
                                    &nbsp;</label>
                                <asp:Button runat="server" Text="Delete Page" ID="btnDelete" OnClick="btnDelete_Click"
                                    OnClientClick="return get_confirm('deleting setup page');" Width="100px" CssClass="bodycopy" />
                            </li>
                        </ul>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
