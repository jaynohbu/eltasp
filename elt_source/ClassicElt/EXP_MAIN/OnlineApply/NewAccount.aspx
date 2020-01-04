<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NewAccount.aspx.cs" Inherits="OnlineApply_NewAccount"
    CodePage="65001" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>New Account</title>
    <link href="../CSS/AppStyle.css" type="text/css" rel="stylesheet" />

    <script type="text/jscript">
        function AccountTypeDetail(){
            showModalDialog("./AccountTypeDetail.html", "popWindow", "dialogWidth:400px; dialogHeight:300px; help:0; status:1; scroll:0; center:1; Sunken;");
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align: center">
            <div style="width: 95%; text-align: left" class="pageheader">
                <img src="../Images/aeseasy.jpg" alt="" /></div>
            <asp:Label ID="lblMessage" runat="server" ForeColor="Red" Visible="false"></asp:Label>
            <table cellspacing="0" cellpadding="4" border="0" class="bodycopy" style="width: 95%">
                <tr>
                    <td align="right" colspan="11">
                        <img alt="" src="/iff_main/ASP/Images/required.gif" />Required field
                    </td>
                </tr>
                <tr>
                    <td colspan="11" align="left" valign="top" style="background-color: #999999" class="bodyheader">
                    </td>
                </tr>
                <tr align="center" valign="middle">
                    <td align="left" style="background-color: #dddddd" class="bodyheader">
                    </td>
                    <td colspan="10" align="left" style="background-color: #dddddd" class="bodyheader">
                        Business Information</td>
                </tr>
                <tr valign="middle">
                    <td align="left">
                    </td>
                    <td align="left">
                        <img alt="" src="/iff_main/ASP/Images/required.gif" align="absbottom" />Name (DBA)</td>
                    <td colspan="3" align="left">
                        <asp:TextBox ID="txtDBA" runat="server" CssClass="shorttextfield" Width="150px" /><asp:RequiredFieldValidator
                            ID="rfv_DBA" runat="server" ControlToValidate="txtDBA" ErrorMessage="*" SetFocusOnError="true" /></td>
                    <td align="left" style="width: 10px">
                    </td>
                    <td align="left">
                        Legal Name
                    </td>
                    <td colspan="4" align="left">
                        <asp:TextBox ID="txtLegalName" runat="server" CssClass="shorttextfield" Width="150px"></asp:TextBox></td>
                </tr>
                <tr valign="middle">
                    <td align="left">
                    </td>
                    <td align="left">
                        <img alt="" src="/iff_main/ASP/Images/required.gif" align="absbottom" />Address</td>
                    <td colspan="3" align="left">
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="shorttextfield" Width="250px"></asp:TextBox><asp:RequiredFieldValidator
                            ID="rfv_Address" runat="server" ControlToValidate="txtAddress" ErrorMessage="*"
                            SetFocusOnError="true" /></td>
                    <td align="left">
                    </td>
                    <td align="left">
                        <img alt="" src="/iff_main/ASP/Images/required.gif" align="absbottom" />City</td>
                    <td colspan="4" align="left">
                        <asp:TextBox ID="txtCity" runat="server" CssClass="shorttextfield" Width="200px"></asp:TextBox><asp:RequiredFieldValidator
                            ID="rfv_City" runat="server" ControlToValidate="txtCity" ErrorMessage="*" SetFocusOnError="true" /></td>
                </tr>
                <tr valign="middle">
                    <td align="left">
                    </td>
                    <td align="left">
                        <img alt="" src="/iff_main/ASP/Images/required.gif" align="absbottom" />State</td>
                    <td colspan="3" align="left">
                        <asp:DropDownList runat="server" ID="ddState1" CssClass="bodycopy">
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
                        </asp:DropDownList><asp:RequiredFieldValidator ID="rfv_ddState1" runat="server" ControlToValidate="ddState1"
                            ErrorMessage="*" SetFocusOnError="true" /></td>
                    <td align="left">
                    </td>
                    <td align="left">
                        <img alt="" src="/iff_main/ASP/Images/required.gif" align="absbottom" />Zip Code</td>
                    <td colspan="4" align="left">
                        <asp:TextBox ID="txtZip" runat="server" CssClass="shorttextfield" Width="50px"></asp:TextBox><asp:RequiredFieldValidator
                            ID="rfv_Zip" runat="server" ControlToValidate="txtZip" ErrorMessage="*" SetFocusOnError="true" /></td>
                </tr>
                <tr valign="middle">
                    <td align="left">
                    </td>
                    <td align="left">
                        <img alt="" src="/iff_main/ASP/Images/required.gif" align="absbottom" />Country</td>
                    <td colspan="3" align="left">
                        <asp:DropDownList ID="ddCountry1" runat="server" CssClass="bodycopy">
                        </asp:DropDownList><asp:RequiredFieldValidator ID="rfv_ddCountry1" runat="server"
                            ControlToValidate="ddCountry1" ErrorMessage="*" SetFocusOnError="true" /></td>
                    <td align="left">
                    </td>
                    <td align="left">
                        URL</td>
                    <td colspan="4" align="left">
                        <asp:TextBox ID="txtURL" runat="server" CssClass="shorttextfield" Width="200px"></asp:TextBox></td>
                </tr>
                <tr valign="middle">
                    <td align="left">
                    </td>
                    <td align="left">
                        <img alt="" src="/iff_main/ASP/Images/required.gif" align="absbottom" />Phone Number</td>
                    <td colspan="3" align="left">
                        <asp:TextBox ID="txtBusPhone" runat="server" CssClass="shorttextfield" Width="150px"></asp:TextBox><asp:RequiredFieldValidator
                            ID="rfv_BusPhone" runat="server" ControlToValidate="txtBusPhone" ErrorMessage="*"
                            SetFocusOnError="true" /></td>
                    <td align="left">
                    </td>
                    <td align="left">
                        Fax Number</td>
                    <td colspan="4" align="left">
                        <asp:TextBox ID="txtBusFax" runat="server" CssClass="shorttextfield" Width="150px"></asp:TextBox></td>
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
                    <td align="left" style="background-color: #dddddd">
                    </td>
                    <td colspan="10" align="left" style="background-color: #dddddd" class="bodyheader">
                        Administrator Information</td>
                </tr>
                <tr valign="middle">
                    <td align="left">
                    </td>
                    <td align="left">
                        User ID</td>
                    <td colspan="3" align="left">
                        <asp:TextBox ID="txtAdminID" runat="server" CssClass="shorttextfield" Width="150px"
                            Text="admin" BackColor="#cdcdcd" ReadOnly="true" /></td>
                    <td align="left">
                    </td>
                    <td align="left">
                        <img alt="" src="/iff_main/ASP/Images/required.gif" align="absbottom" />Password</td>
                    <td colspan="4" align="left">
                        <asp:TextBox ID="txtAdminPassword" runat="server" CssClass="shorttextfield" Width="150px"></asp:TextBox><asp:RequiredFieldValidator
                            ID="rfv_AdminPass" runat="server" ControlToValidate="txtAdminPassword" ErrorMessage="*"
                            SetFocusOnError="true" /></td>
                </tr>
                <tr>
                    <td colspan="11" align="left" valign="top" style="background-color: #999999" class="bodyheader">
                    </td>
                </tr>
                <tr valign="middle">
                    <td align="left" style="background-color: #dddddd">
                    </td>
                    <td colspan="10" align="left" style="background-color: #dddddd" class="bodyheader">
                        Contact Information</td>
                </tr>
                <tr valign="middle">
                    <td align="left">
                    </td>
                    <td align="left">
                        <img alt="" src="/iff_main/ASP/Images/required.gif" align="absbottom" />First Name</td>
                    <td colspan="3" align="left">
                        <asp:TextBox ID="txtFName" runat="server" CssClass="shorttextfield" Width="150px"></asp:TextBox><asp:RequiredFieldValidator
                            ID="rfv_FName" runat="server" ControlToValidate="txtFName" ErrorMessage="*" SetFocusOnError="true" /></td>
                    <td align="left">
                    </td>
                    <td align="left">
                        <img alt="" src="/iff_main/ASP/Images/required.gif" align="absbottom" />Last Name</td>
                    <td colspan="4" align="left">
                        <asp:TextBox ID="txtLname" runat="server" CssClass="shorttextfield" Width="150px"></asp:TextBox><asp:RequiredFieldValidator
                            ID="rfv_LName" runat="server" ControlToValidate="txtLname" ErrorMessage="*" SetFocusOnError="true" /></td>
                </tr>
                <tr valign="middle">
                    <td align="left">
                    </td>
                    <td align="left">
                        Title
                    </td>
                    <td colspan="3" align="left">
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="shorttextfield" Width="200px"></asp:TextBox>
                    </td>
                    <td align="left">
                    </td>
                    <td align="left">
                        <img alt="" src="/iff_main/ASP/Images/required.gif" align="absbottom" />Email
                    </td>
                    <td colspan="4" align="left">
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="shorttextfield" Width="200px"></asp:TextBox><asp:RequiredFieldValidator
                            ID="rfv_Email" runat="server" ControlToValidate="txtEmail" ErrorMessage="*" SetFocusOnError="true" />
                    </td>
                </tr>
                <tr>
                    <td colspan="11" align="left" valign="top" style="background-color: #999999" class="bodyheader">
                    </td>
                </tr>
                <tr valign="middle">
                    <td align="left" style="background-color: #dddddd">
                    </td>
                    <td colspan="10" align="left" style="background-color: #dddddd" class="bodyheader">
                        Mailing Address</td>
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
                        <asp:TextBox ID="txtMailAddress" runat="server" CssClass="shorttextfield" Width="250px"></asp:TextBox></td>
                    <td align="left">
                    </td>
                    <td align="left">
                        Mailing City</td>
                    <td colspan="4" align="left">
                        <asp:TextBox ID="txtMailCity" runat="server" CssClass="shorttextfield" Width="200"></asp:TextBox></td>
                </tr>
                <tr valign="middle">
                    <td align="left">
                    </td>
                    <td align="left">
                        Mailing State</td>
                    <td colspan="3" align="left">
                        <asp:DropDownList ID="ddState2" runat="server" CssClass="bodycopy">
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
                        </asp:DropDownList></td>
                    <td align="left">
                    </td>
                    <td align="left">
                        Mailing Zip</td>
                    <td colspan="4" align="left">
                        <asp:TextBox ID="txtMailZip" runat="server" CssClass="shorttextfield" Width="50px"></asp:TextBox></td>
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
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="shorttextfield" Width="150px"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="11" align="left" valign="top" style="background-color: #999999" class="bodyheader">
                    </td>
                </tr>
                <tr valign="middle">
                    <td align="left" style="background-color: #dddddd">
                    </td>
                    <td colspan="10" align="left" style="background-color: #dddddd" class="bodyheader">
                        Select FreightEasy Account Type</td>
                </tr>
                <tr valign="middle">
                    <td align="left">
                    </td>
                    <td align="left">
                        Account Type
                    </td>
                    <td colspan="9" align="left">
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td>
                                    <asp:RadioButtonList ID="rlAcType" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="F">Standard</asp:ListItem>
                                        <asp:ListItem Value="A" Selected="True">Premium</asp:ListItem>
                                    </asp:RadioButtonList></td>
                                <td style="width: 20px">
                                </td>
                                <td>
                                    <a href="javascript:AccountTypeDetail();">Click here for account type detail</a></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="11" align="left" valign="top" style="background-color: #999999" class="bodyheader">
                    </td>
                </tr>
                <tr>
                    <td colspan="11" align="right" valign="top" class="bodyheader">
                        <asp:Button ID="btnCreate" runat="server" OnClick="btnCreate_Click" Text="Create Account Now" /></td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
