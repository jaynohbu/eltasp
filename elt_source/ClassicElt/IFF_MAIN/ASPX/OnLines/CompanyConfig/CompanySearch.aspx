<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CompanySearch.aspx.cs" Inherits="ASPX_OnLines_CompanyConfig_CompanySearch" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Client Search</title>
    <link href="../../CSS/AppStyle.css" type="text/css" rel="stylesheet" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /><style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #cc6600}
-->
</style></head>
<body>
    <form id="form1" runat="server">
            <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
                <tr>
                    <td height="32" align="left" valign="middle" class="pageheader">Client search  </td>
                </tr>
            </table>
			<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#6f8fb6" class="border1px">
			<tr><td height="8" bgcolor="#b5d0f1"></td>
			</tr>
			<tr><td height="1" bgcolor="#6f8fb6"></td>
			</tr>
        <tr>
            <td bgcolor="#f3f3f3"><br />
                    <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#6f8fb6" class="border1px" style="background-color:#eeeeee;">
                <tr>
                    <td width="0%" valign="top" bgcolor="#dee9f6">&nbsp;</td>
                    <td width="20%" height="20" valign="middle" bgcolor="#dee9f6" class="bodyheader">Business Type</td>
                        <td width="44%" bgcolor="#dee9f6"><span class="bodyheader">Business Name </span></td>
                        <td width="36%" bgcolor="#dee9f6"><span class="bodyheader">Regional Option</span></td>
                    </tr>
                <tr>
                    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
                        <td rowspan="2" valign="top" bgcolor="#FFFFFF"><asp:ListBox ID="BizType" runat="server" Height="100px" SelectionMode="Multiple" Width="120px" CssClass="bodycopy"> </asp:ListBox>
                            <br />
                            <span class="bodycopy style1">Shift-Click to select multiple criteria</span></td>
                        <td align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy">Starting with:
                    <asp:DropDownList ID="BizFL" runat="server" CssClass="bodycopy"> </asp:DropDownList>
                            <img src="../../../ASP/Images/spacer.gif" width="10" height="6" />Containing:
                        <asp:TextBox ID="BizNamePiece" runat="server" style="width:120px;" CssClass="shorttextfield"></asp:TextBox></td>
				    <td rowspan="2" align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy"><table width="100%" border="0" cellspacing="0" cellpadding="0">
				        <tr>
				            <td width="15%" align="left" valign="top"><asp:DropDownList ID="RegionOpt" runat="server" OnSelectedIndexChanged="RegionOpt_SelectedIndexChanged" AutoPostBack="True" CssClass="bodycopy"> </asp:DropDownList></td>
                                <td width="85%"><asp:ListBox ID="RegionList" runat="server" SelectionMode="Multiple" Height="100px" Width="150px" CssClass="smallselect"> </asp:ListBox></td>
                            </tr>
				        </table></td>
                    </tr>
                <tr>
                    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
                        <td height="20" align="left" valign="top" bgcolor="#FFFFFF" class="bodyheader"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="37%" height="20" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">Active/Inactive</td>
                                <td width="63%" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">Sort By</td>
                            </tr>
                            <tr>
                                <td bgcolor="#FFFFFF"><asp:DropDownList ID="BizAct" runat="server" CssClass="bodycopy"> </asp:DropDownList></td>
                                <td bgcolor="#FFFFFF"><asp:DropDownList ID="SortKey" runat="server" CssClass="bodycopy"> </asp:DropDownList></td>
                            </tr>
                            </table></td>
                    </tr>
                
                
                <tr>
                    <td height="20">&nbsp;</td>
						<td><input id="reset" type="reset" style="width:70px; cursor:hand" class="bodycopy" value="Reset Form" /></td>
						<td></td>
						<td align="center" valign="middle"><asp:ImageButton ID="SubmitButton" runat="server" CssClass="bodycopy" ImageUrl="/iff_main/Images/button_go.gif" OnClick="SubmitButton_Click" text="Search Company" /></td>
                    </tr>
            </table>
        <br /></td></tr></table>
    </form>
</body>
</html>
