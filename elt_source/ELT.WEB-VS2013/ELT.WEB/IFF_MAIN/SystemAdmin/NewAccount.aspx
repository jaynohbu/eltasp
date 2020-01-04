<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NewAccount.aspx.cs" Inherits="SystemAdmin_NewAccount"
    CodePage="65001" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>New Account</title>
    <link href="../ASPX/css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/jscript">
        function openWindow(vURL){
            var oWindow = window.open(vURL, "popUpWindow", 
                "top=0,left=0,staus=0,titlebar=0,toolbar=0,menubar=0,scrollbars=0,resizable=1,location=0,width=600,height=400,hotkeys=0");
            oWindow.focus();
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <br />
        <table cellspacing="0" cellpadding="4" border="0" class="bodycopy" style="width: 800px">
            <tr>
                <td align="right" colspan="11">
                    <img alt="" src="/ASP/Images/required.gif" />Required field
                </td>
            </tr>
            <tr>
                <td colspan="11" align="left" valign="top" style="background-color: #999999" class="bodyheader">
                </td>
            </tr>
            <tr align="center" valign="middle">
                <td align="left" style="background-color: #eeeeee" class="bodyheader">
                </td>
                <td colspan="10" align="left" style="background-color: #eeeeee" class="bodyheader">
                    Business Information</td>
            </tr>
            <tr valign="middle">
                <td align="left">
                </td>
                <td align="left">
                    <img alt="" src="/ASP/Images/required.gif" />Name (DBA)</td>
                <td colspan="3" align="left">
                    <asp:TextBox ID="txtDBA" runat="server" CssClass="m_shorttextfield"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfv_DBA" runat="server" ControlToValidate="txtDBA"
                        ErrorMessage="DBA Name is  required "></asp:RequiredFieldValidator></td>
                <td align="left" style="width: 10px">
                </td>
                <td align="left">
                    Legal Name
                </td>
                <td colspan="4" align="left">
                    <asp:TextBox ID="txtLegalName" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
            </tr>
            <tr valign="middle">
                <td align="left">
                </td>
                <td align="left">
                    Address</td>
                <td colspan="3" align="left">
                    <asp:TextBox ID="txtAddress" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
                <td align="left">
                </td>
                <td align="left">
                    City</td>
                <td colspan="4" align="left">
                    <asp:TextBox ID="txtCity" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
            </tr>
            <tr valign="middle">
                <td align="left">
                </td>
                <td align="left">
                    State</td>
                <td colspan="3" align="left">
                    <asp:DropDownList ID="ddState1" runat="server" CssClass="bodycopy">
                    </asp:DropDownList></td>
                <td align="left">
                </td>
                <td align="left">
                    Business Zip</td>
                <td colspan="4" align="left">
                    <asp:TextBox ID="txtZip" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
            </tr>
            <tr valign="middle">
                <td align="left">
                </td>
                <td align="left">
                    Country</td>
                <td colspan="3" align="left">
                    <asp:DropDownList ID="ddCountry1" runat="server" CssClass="bodycopy">
                    </asp:DropDownList></td>
                <td align="left">
                </td>
                <td align="left">
                    URL</td>
                <td colspan="4" align="left">
                    <asp:TextBox ID="txtURL" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
            </tr>
            <tr valign="middle">
                <td align="left">
                </td>
                <td align="left">
                    Phone Number</td>
                <td colspan="3" align="left">
                    <asp:TextBox ID="txtBusPhone" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
                <td align="left">
                </td>
                <td align="left">
                    Fax Number</td>
                <td colspan="4" align="left">
                    <asp:TextBox ID="txtBusFax" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
            </tr>
            <tr valign="middle">
                <td align="left">
                </td>
                <td align="left">
                </td>
                <td colspan="3" align="left">
                </td>
                <td align="left">
                </td>
                <td align="left">
                </td>
                <td colspan="4" align="left">
                </td>
            </tr>
            <tr>
                <td colspan="11" align="left" valign="top" style="background-color: #999999" class="bodyheader">
                </td>
            </tr>
            <tr valign="middle">
                <td align="left" style="background-color: #eeeeee">
                </td>
                <td colspan="10" align="left" style="background-color: #eeeeee" class="bodyheader">
                    Contact Information</td>
            </tr>
            <tr valign="middle">
                <td align="left">
                </td>
                <td align="left">
                    First Name</td>
                <td colspan="3" align="left">
                    <asp:TextBox ID="txtFName" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
                <td align="left">
                </td>
                <td align="left">
                    Last Name</td>
                <td colspan="4" align="left">
                    <asp:TextBox ID="txtLname" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
            </tr>
            <tr valign="middle">
                <td colspan="9" align="left">
                    <asp:CheckBox ID="chkSame" runat="server" OnCheckedChanged="chkSame_CheckedChanged"
                        AutoPostBack="True" />
                    Check if mailing address is same as above</td>
            </tr>
            <tr valign="middle">
                <td align="left">
                </td>
                <td align="left">
                    Mailing Addess</td>
                <td colspan="3" align="left">
                    <asp:TextBox ID="txtMailAddress" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
                <td align="left">
                </td>
                <td align="left">
                    Mailing City</td>
                <td colspan="4" align="left">
                    <asp:TextBox ID="txtMailCity" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
            </tr>
            <tr valign="middle">
                <td align="left">
                </td>
                <td align="left">
                    Mailing State</td>
                <td colspan="3" align="left">
                    <asp:DropDownList ID="ddState2" runat="server" CssClass="bodycopy">
                    </asp:DropDownList></td>
                <td align="left">
                </td>
                <td align="left">
                    Mailing Zip</td>
                <td colspan="4" align="left">
                    <asp:TextBox ID="txtMailZip" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
            </tr>
            <tr valign="middle">
                <td align="left">
                </td>
                <td align="left">
                    Mailing Country</td>
                <td colspan="3" align="left">
                    <asp:DropDownList ID="ddCountry2" runat="server" CssClass="bodycopy">
                    </asp:DropDownList></td>
                <td align="left">
                </td>
                <td align="left">
                    Phone Number</td>
                <td colspan="4" align="left">
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
            </tr>
            <tr valign="middle">
                <td align="left">
                </td>
                <td align="left">
                    Email Address</td>
                <td colspan="3" align="left">
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
                <td align="left">
                </td>
                <td align="left">
                </td>
                <td colspan="4" align="left">
                </td>
            </tr>
            <tr>
                <td colspan="11" align="left" valign="top" style="background-color: #999999" class="bodyheader">
                </td>
            </tr>
            <tr valign="middle">
                <td align="left" style="background-color: #eeeeee">
                </td>
                <td colspan="10" align="left" style="background-color: #eeeeee" class="bodyheader">
                    Account Information</td>
            </tr>
            <tr valign="middle">
                <td align="left">
                </td>
                <td align="left">
                    Account Type</td>
                <td colspan="3" align="left">
                    <asp:RadioButtonList ID="rlAcType" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Value="T" Selected="True">Trial</asp:ListItem>
                        <asp:ListItem Value="A" Selected="True">Premium</asp:ListItem>
                    </asp:RadioButtonList></td>
                <td colspan="6">
                    <asp:CheckBox ID="chkIsIntl" runat="server" Checked="true" />
                    <img alt="" src="/ASP/Images/required.gif" />International &nbsp;&nbsp;
                    <asp:CheckBox ID="chkIsDome" runat="server" />Domestic &nbsp;&nbsp;
                    <asp:CheckBox ID="chkIsCart" runat="server" />Cartage &nbsp;&nbsp;
                    <asp:CheckBox ID="chkIsWare" runat="server" Checked="true" />Warehouse
                    <asp:CheckBox ID="chkIsAcct" runat="server" Checked="true" />Accounting
                </td>
            </tr>
            <tr valign="middle">
                <td align="left">
                </td>
                <td align="left">
                    <img alt="" src="/ASP/Images/required.gif" />Account No.
                </td>
                <td align="left" colspan="3">
                    <asp:TextBox ID="txtNewAccNo" runat="server" MaxLength="8" CssClass="m_shorttextfield"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvNewAccountNumber" runat="server" ControlToValidate="txtNewAccNo"
                        ErrorMessage="Please enter Account No."></asp:RequiredFieldValidator></td>
                <td align="left">
                </td>
                <td align="left">
                </td>
                <td align="left" colspan="4">
                    <asp:CustomValidator runat="server" ID="rfvNewAccountType" OnServerValidate="rfvNewAccountType_ServerValidate"
                        ErrorMessage="Business type is required!"></asp:CustomValidator>
                </td>
            </tr>
            <tr>
                <td colspan="11" align="left" valign="top" style="background-color: #999999" class="bodyheader">
                </td>
            </tr>
            <tr>
                <td colspan="11" align="right" valign="top" class="bodyheader">
                    <asp:Button ID="btnCreate" runat="server" OnClick="btnCreate_Click" Text="Create Account" /></td>
            </tr>
        </table>
        <br />
        <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
    </form>
</body>
</html>
