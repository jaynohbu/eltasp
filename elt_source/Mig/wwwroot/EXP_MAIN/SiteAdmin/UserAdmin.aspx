<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserAdmin.aspx.cs" Inherits="SiteAdmin_UserAdmin" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Admin Profile</title>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/jscript">
        function ConfirmDelete()
        {
            if(confirm("Are you sure to delete this user?"))
            {
                return true;
            }
            return false;
        }
    </script>

</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
        <center>
            <div style="width: 95%; text-align: left" class="pageheader">
                User Admin Profile
            </div>
            <div style="width: 95%; text-align: left" class="bodycopy">
                <table cellpadding="3" cellspacing="0" border="0" style="width: 100%; text-align: left;
                    border: solid 1px #9190A5" class="bodycopy">
                    <tr style="background-color:#C7C6E1; height: 8px">
                        <td style="width:10%"></td>
                        <td style="width:30%"></td>
                        <td style="width:10%"></td>
                        <td style="width:15%"></td>
                        <td style="width:10%"></td>
                        <td style="width:25%"></td>
                    </tr>
                    <tr style="background-color: #9190A5; height: 1px">
                        <td colspan="6">
                        </td>
                    </tr>
                    <tr style="background-color:#DDDDED" class="bodyheader">
                        <td>
                            <span style="color:#cc6600">Select Login ID</span>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="lstLoginID" CssClass="bodycopy" AutoPostBack="true" OnSelectedIndexChanged="lstUserType_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                        <td colspan="4">
                        </td>
                    </tr>
                    <tr style="background-color: #9190A5; height: 1px">
                        <td colspan="6">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            User Type
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="lstUserType" CssClass="bodycopy">
                                <asp:ListItem Text="Normal User" Value="7"></asp:ListItem>
                                <asp:ListItem Text="Super/Admin User" Value="9"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <!--Organization-->
                        </td>
                        <td colspan="3">
                            <asp:DropDownList runat="server" ID="lstOrganization" CssClass="bodycopy" Width="350px" Visible="false">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr style="background-color: #f3f3f3">
                        <td>
                            First Name
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtFirstName" CssClass="shorttextfield"></asp:TextBox>
                        </td>
                        <td>
                            Last Name
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtLastName" CssClass="shorttextfield"></asp:TextBox>
                        </td>
                        <td>
                            Title / Position
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtTitle" CssClass="shorttextfield"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img src="../Images/required.gif" align="absbottom" alt="" />Login ID
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtLoginID" CssClass="shorttextfield"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ID="rfvLoginID" ControlToValidate="txtLoginID" ErrorMessage="*" SetFocusOnError="true" />
                        </td>
                        <td>
                            <img src="../Images/required.gif" align="absbottom" alt="" />Password
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtPassword" CssClass="shorttextfield"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ID="rfvPassword" ControlToValidate="txtPassword" ErrorMessage="*" SetFocusOnError="true" />
                        </td>
                        <td>
                            <img src="../Images/required.gif" align="absbottom" alt="" />Repeat Password
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtRepeatPassword" CssClass="shorttextfield"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ID="rfvRepeatPassword" ControlToValidate="txtRepeatPassword" ErrorMessage="*" SetFocusOnError="true" />
                        </td>
                    </tr>
                    <tr style="background-color: #f3f3f3">
                        <td>
                            SSN
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtSSN" CssClass="shorttextfield" MaxLength="9"></asp:TextBox>
                        </td>
                        <td>
                            Date of Birth
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtBirth" CssClass="m_shorttextfield" preset="shortdate" Height="13px"></asp:TextBox>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Address
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtAddress" CssClass="shorttextfield" Width="300px"></asp:TextBox>
                        </td>
                        <td>
                            City
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtCity" CssClass="shorttextfield"></asp:TextBox>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr style="background-color: #f3f3f3">
                        <td>
                            State
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="lstState" CssClass="bodycopy">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                <asp:ListItem Text="AK" Value="AK"></asp:ListItem>
                                <asp:ListItem Text="AL" Value="AL"></asp:ListItem>
                                <asp:ListItem Text="AR" Value="AR"></asp:ListItem>
                                <asp:ListItem Text="AZ" Value="AZ"></asp:ListItem>
                                <asp:ListItem Text="CA" Value="CA"></asp:ListItem>
                                <asp:ListItem Text="CO" Value="CO"></asp:ListItem>
                                <asp:ListItem Text="CT" Value="CT"></asp:ListItem>
                                <asp:ListItem Text="DC" Value="DC"></asp:ListItem>
                                <asp:ListItem Text="DE" Value="DE"></asp:ListItem>
                                <asp:ListItem Text="FL" Value="FL"></asp:ListItem>
                                <asp:ListItem Text="GA" Value="GA"></asp:ListItem>
                                <asp:ListItem Text="HI" Value="HI"></asp:ListItem>
                                <asp:ListItem Text="IA" Value="IA"></asp:ListItem>
                                <asp:ListItem Text="ID" Value="ID"></asp:ListItem>
                                <asp:ListItem Text="IL" Value="IL"></asp:ListItem>
                                <asp:ListItem Text="IN" Value="IN"></asp:ListItem>
                                <asp:ListItem Text="KS" Value="KS"></asp:ListItem>
                                <asp:ListItem Text="KY" Value="KY"></asp:ListItem>
                                <asp:ListItem Text="LA" Value="LA"></asp:ListItem>
                                <asp:ListItem Text="MA" Value="MA"></asp:ListItem>
                                <asp:ListItem Text="MD" Value="MD"></asp:ListItem>
                                <asp:ListItem Text="ME" Value="ME"></asp:ListItem>
                                <asp:ListItem Text="MI" Value="MI"></asp:ListItem>
                                <asp:ListItem Text="MN" Value="MN"></asp:ListItem>
                                <asp:ListItem Text="MO" Value="MO"></asp:ListItem>
                                <asp:ListItem Text="MS" Value="MS"></asp:ListItem>
                                <asp:ListItem Text="MT" Value="MT"></asp:ListItem>
                                <asp:ListItem Text="NC" Value="NC"></asp:ListItem>
                                <asp:ListItem Text="ND" Value="ND"></asp:ListItem>
                                <asp:ListItem Text="NE" Value="NE"></asp:ListItem>
                                <asp:ListItem Text="NH" Value="NH"></asp:ListItem>
                                <asp:ListItem Text="NJ" Value="NJ"></asp:ListItem>
                                <asp:ListItem Text="NM" Value="NM"></asp:ListItem>
                                <asp:ListItem Text="NV" Value="NV"></asp:ListItem>
                                <asp:ListItem Text="NY" Value="NY"></asp:ListItem>
                                <asp:ListItem Text="OH" Value="OH"></asp:ListItem>
                                <asp:ListItem Text="OK" Value="OK"></asp:ListItem>
                                <asp:ListItem Text="OR" Value="OR"></asp:ListItem>
                                <asp:ListItem Text="PA" Value="PA"></asp:ListItem>
                                <asp:ListItem Text="RI" Value="RI"></asp:ListItem>
                                <asp:ListItem Text="SC" Value="SC"></asp:ListItem>
                                <asp:ListItem Text="SD" Value="SD"></asp:ListItem>
                                <asp:ListItem Text="TN" Value="TN"></asp:ListItem>
                                <asp:ListItem Text="TX" Value="TX"></asp:ListItem>
                                <asp:ListItem Text="UT" Value="UT"></asp:ListItem>
                                <asp:ListItem Text="VA" Value="VA"></asp:ListItem>
                                <asp:ListItem Text="VT" Value="VT"></asp:ListItem>
                                <asp:ListItem Text="WA" Value="WA"></asp:ListItem>
                                <asp:ListItem Text="WI" Value="WI"></asp:ListItem>
                                <asp:ListItem Text="WV" Value="WV"></asp:ListItem>
                                <asp:ListItem Text="WY" Value="WY"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            Zip Code
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtZip" MaxLength="5" CssClass="m_shorttextfield" preset="zip" Height="13px" Width="50px"></asp:TextBox>
                        </td>
                        <td>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtCountry" CssClass="shorttextfield" Visible="false"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Phone No.
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtPhoneNo" CssClass="m_shorttextfield" preset="phone" Height="13px"></asp:TextBox>
                        </td>
                        <td>
                            Cell No.
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtCellNo" CssClass="m_shorttextfield" preset="phone" Height="13px"></asp:TextBox>
                        </td>
                        <td>
                            <img src="../Images/required.gif" align="absbottom" alt="" />Email Address
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtEmail" CssClass="shorttextfield" Width="200px"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ErrorMessage="*" ControlToValidate="txtEmail" SetFocusOnError="true" /></td>
                    </tr>
                    <tr style="background-color: #9190A5; height: 1px">
                        <td colspan="6">
                        </td>
                    </tr>
                    <tr style="background-color: #DDDDED">
                        <td colspan="6" style="text-align: center">
                            <asp:ImageButton runat="server" ID="btnAddUser" ImageUrl="../Images/button_adduser.gif"
                                Style="margin-right: 25px; cursor: pointer" OnClick="btnAddUser_Click" />
                            <asp:ImageButton runat="server" ID="btnUpdateUser" ImageUrl="../Images/button_updateuser.gif"
                                Style="margin-right: 25px; cursor: pointer" OnClick="btnUpdateUser_Click" />
                            <asp:ImageButton runat="server" ID="btnDeleteUser" ImageUrl="../Images/button_deleteuser.gif"
                                Style="cursor: pointer" OnClick="btnDeleteUser_Click" OnClientClick="return ConfirmDelete();" />
                        </td>
                    </tr>
                </table>
            </div>
        </center>
    </form>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
