<%@ Page Language="C#" AutoEventWireup="true" CodeFile="quickAddClientNew.aspx.cs" Inherits="ASPX_Include_quickAddClientNew" %>

<%@ Register Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit Company</title>
    <base target="_self" />
    <link href="../../ASP/css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/jscript">
        
        window.returnValue = null;
        
        function close_window()
        {
            window.close();
        }
        
        function close_window_return(argID,argName)
        {
            var arrayReturnValue = new Array();
            
            arrayReturnValue[0] = argID;
            arrayReturnValue[1] = argName;
            
            window.returnValue = arrayReturnValue;
            window.close();
        }
        
    </script>

    <style type="text/css">
        .style01 {
            font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 14px;
	        font-weight: bold;
	        text-transform: uppercase;
	        color: #000000;
	    }
    </style>
</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
        <center>
            <div style="width: 95%; text-align: left; margin: 10px 0px 10px 0px">
                <asp:Label runat="server" ID="labelTitle" CssClass="style01" />
            </div>
            <div style="width: 95%; text-align: left; margin: 10px 0px 10px 0px">
                <table cellpadding="2" cellspacing="0" border="0" class="bodycopy" style="width: 100%;
                    border: solid 1px #999999" runat="server" id="tableContent">
                    <tr style="background-color: #dddddd">
                        <td colspan="2">
                            <strong>Business Information</strong>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="background-color: #999999; height: 1px">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img src="../../ASP/Images/required.gif" align="absbottom" alt="" />Name (DBA)
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtDBA" CssClass="shorttextfield" MaxLength="30"
                                Width="230px" />
                            <asp:RequiredFieldValidator runat="server" ID="rfvDBA" ControlToValidate="txtDBA"
                                ErrorMessage="*" SetFocusOnError="true" />
                        </td>
                    </tr>
                    <tr style="background-color:#eeeeee">
                        <td>
                            Legal Name
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtLegalName" CssClass="shorttextfield" MaxLength="30"
                                Width="230px" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img src="../../ASP/Images/required.gif" align="absbottom" alt="" />Address
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtAddress1" CssClass="shorttextfield" MaxLength="32"
                                Width="240px" />
                            <asp:RequiredFieldValidator runat="server" ID="rfvAddress1" ControlToValidate="txtAddress1"
                                ErrorMessage="*" SetFocusOnError="true" />
                        </td>
                    </tr>
                    <tr style="background-color:#eeeeee">
                        <td>
                            Address 2
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtAddress2" CssClass="shorttextfield" MaxLength="32"
                                Width="240px" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img src="../../ASP/Images/required.gif" align="absbottom" alt="" />City
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtCity" CssClass="shorttextfield" MaxLength="25"
                                Width="180px" />
                            <asp:RequiredFieldValidator runat="server" ID="rfvCity" ControlToValidate="txtCity"
                                ErrorMessage="*" SetFocusOnError="true" />
                        </td>
                    </tr>
                    <tr style="background-color:#eeeeee">
                        <td>
                            State
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtState" CssClass="shorttextfield" MaxLength="2"
                                Width="20px" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Postal Code
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtZip" CssClass="shorttextfield" MaxLength="9" Width="80px" />
                        </td>
                    </tr>
                    <tr style="background-color:#eeeeee">
                        <td>
                            <img src="../../ASP/Images/required.gif" align="absbottom" alt="" />Country
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="lstCountry" CssClass="bodycopy" Width="260px" />
                            <asp:RequiredFieldValidator runat="server" ID="rfvCountry" ControlToValidate="lstCountry"
                                ErrorMessage="*" SetFocusOnError="true" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Tax ID (USPPI)
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtTaxID" CssClass="shorttextfield" Width="100px" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="background-color: #999999; height: 1px">
                        </td>
                    </tr>
                    <tr style="background-color: #dddddd">
                        <td colspan="2">
                            <strong>Contact Information</strong>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="background-color: #999999; height: 1px">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Name
                        </td>
                        <td>
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        First Name</td>
                                    <td>
                                        M.I.</td>
                                    <td>
                                        Last Name</td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtFirstName" CssClass="shorttextfield" Width="100px"
                                            MaxLength="32" />&nbsp;</td>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtMidName" CssClass="shorttextfield" Width="40px"
                                            MaxLength="32" />&nbsp;</td>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtLastName" CssClass="shorttextfield" Width="100px"
                                            MaxLength="32" /></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="background-color:#eeeeee">
                        <td>
                            Phone No.
                        </td>
                        <td>
                            <igtxt:WebMaskEdit ID="txtPhone" runat="server" CssClass="shorttextfield" InputMask="###########"
                                MaxLength="11" Width="85px">
                            </igtxt:WebMaskEdit>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Fax No.
                        </td>
                        <td>
                            <igtxt:WebMaskEdit ID="txtFax" runat="server" CssClass="shorttextfield" InputMask="###########"
                                MaxLength="11" Width="85px">
                            </igtxt:WebMaskEdit>
                        </td>
                    </tr>
                    <tr style="background-color:#eeeeee">
                        <td>
                            Cell No.
                        </td>
                        <td>
                            <igtxt:WebMaskEdit ID="txtCell" runat="server" CssClass="shorttextfield" InputMask="###########"
                                MaxLength="11" Width="85px">
                            </igtxt:WebMaskEdit>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Email
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtEmail" CssClass="shorttextfield" MaxLength="128"
                                Width="98%"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <asp:Label runat="server" ID="txtResultBox" Width="100%" Visible="false" />
                <br />
                <table cellpadding="2" cellspacing="0" border="0" class="bodycopy" style="width: 100%;
                    border: solid 1px #999999">
                    <tr>
                        <td colspan="2" style="background-color: #dddddd; text-align: center">
                            <table cellspacing="0" cellpadding="2" border="0">
                                <tr>
                                    <td>
                                        <asp:ImageButton runat="server" ID="btnSave" ImageUrl="../../ASP/Images/button_smallsave.gif"
                                            OnClick="btnSave_Click" style="border:none 0px" /></td>
                                    <td style="width: 5px">
                                    </td>
                                    <td>
                                        <a href="javascript:;" onclick="javascript:close_window();">
                                            <img src="../../ASP/Images/button_closebooking.gif" alt="" style="border:none 0px" /></a></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </center>
    </form>
</body>
</html>

