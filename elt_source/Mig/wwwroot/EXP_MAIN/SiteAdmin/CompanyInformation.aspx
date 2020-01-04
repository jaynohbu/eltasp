<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CompanyInformation.aspx.cs"
    Inherits="SiteAdmin_CompanyInformation" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Company Information</title>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
        <div style="text-align: center">
            <div style="width: 95%; text-align: left" class="pageheader">
                Exporter Information</div>
            <div style="width: 95%; text-align: left" class="bodycopy">
                <table cellpadding="3" cellspacing="0" border="0" style="width: 100%; border: solid 1px #9190A5">
                    <tr style="background-color: #C7C6E1; height: 8px">
                        <td>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr style="background-color: #9190A5; height: 1px">
                        <td colspan="4">
                        </td>
                    </tr>
                    <tr style="background-color: #DDDDED" class="bodyheader">
                        <td colspan="4">
                            Business Information
                        </td>
                    </tr>
                    <tr style="background-color: #9190A5; height: 1px">
                        <td colspan="4">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img align="absBottom" alt="" src="../Images/required.gif" />Name (DBA)
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtDBA" CssClass="shorttextfield" Width="200px" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtDBA" SetFocusOnError="true" /></td>
                        <td>
                            Legal Name
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtLegalName" CssClass="shorttextfield" Width="200px" />
                        </td>
                    </tr>
                    <tr style="background-color: #f3f3f3">
                        <td>
                            <img align="absBottom" alt="" src="../Images/required.gif" />Tax Payer ID
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtTaxID" CssClass="shorttextfield" Width="100px" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*" ControlToValidate="txtTaxID" SetFocusOnError="true" /></td>
                        <td>
                            USPPI EIN
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtUSPPI" CssClass="shorttextfield" Width="100px" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img align="absBottom" alt="" src="../Images/required.gif" />Address
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtAddress" CssClass="shorttextfield" Width="300px" ></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*" ControlToValidate="txtAddress" SetFocusOnError="true" /></td>
                        <td>
                            <img align="absBottom" alt="" src="../Images/required.gif" />City
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtCity" CssClass="shorttextfield" Width="150px" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="*" ControlToValidate="txtCity" SetFocusOnError="true" /></td>
                    </tr>
                    <tr style="background-color: #f3f3f3">
                        <td>
                            <img align="absBottom" alt="" src="../Images/required.gif" />State
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
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="*" ControlToValidate="lstState" SetFocusOnError="true" /></td>
                        <td>
                            <img align="absBottom" alt="" src="../Images/required.gif" />Business Zip
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtZip" CssClass="shorttextfield" />
                            <asp:RequiredFieldValidator ID="rfvZip" runat="server" ErrorMessage="*" ControlToValidate="txtZip" SetFocusOnError="true" /></td>
                    </tr>
                    <tr>
                        <td>
                            <img align="absBottom" alt="" src="../Images/required.gif" />Phone Number
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtCompanyPhone" CssClass="m_shorttextfield" preset="phone" Height="13px" />
                            <asp:RequiredFieldValidator ID="rfvCompanyPhone" runat="server" ErrorMessage="*" ControlToValidate="txtCompanyPhone" SetFocusOnError="true" /></td>
                        <td>
                            Fax Number
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtCompanyFax" CssClass="m_shorttextfield" preset="phone" Height="13px" />
                        </td>
                    </tr>
                    <tr style="background-color: #f3f3f3">
                        <td>
                            Business Website (URL)
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtCompanyURL" CssClass="shorttextfield" Width="200px" />
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr style="background-color: #9190A5; height: 1px">
                        <td colspan="4">
                        </td>
                    </tr>
                    <tr style="background-color: #DDDDED" class="bodyheader">
                        <td colspan="4" align="center">
                            <asp:ImageButton runat="server" ID="btnSave" ImageUrl="../Images/button_save.gif" OnClick="btnSave_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
