<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditCarrier.aspx.cs" Inherits="Common_EditCarrier" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit Carrier</title>
    <base target="_self" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/jscript">
        function close_window(){
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
<body>
    <form id="form1" runat="server">
        <asp:HiddenField runat="server" ID="hCID" />
        <div style="text-align: center">
            <div style="width: 95%; text-align: left; margin: 10px 0px 10px 0px">
                <asp:Label runat="server" ID="labelTitle" CssClass="style01" />
            </div>
            <div style="width: 95%; text-align: left; margin: 10px 0px 10px 0px">
                <table cellpadding="2" cellspacing="0" border="0" class="bodycopy" style="width: 100%;
                    border: solid 1px #999999" runat="server" id="tableContent">
                    <tr style="background-color: #dddddd">
                        <td colspan="2">
                            <img src="../Images/required.gif" align="absbottom" alt="" /><strong>Carrier Information</strong>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="background-color: #999999; height: 1px">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Carrier Name
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtCarrierName" CssClass="shorttextfield" Width="160px"
                                MaxLength="22" />
                            <asp:RequiredFieldValidator runat="server" ID="rfvCarrierName" ControlToValidate="txtCarrierName"
                                ErrorMessage="*" SetFocusOnError="true" />
                        </td>
                    </tr>
                    <tr style="background-color:#eeeeee">
                        <td>
                            Code Type
                        </td>
                        <td>
                            <asp:RadioButtonList runat="server" ID="lstCodeType" RepeatDirection="Horizontal"
                                RepeatLayout="Flow">
                                <asp:ListItem Text="IATA" Value="IATA" Selected="True" />
                                <asp:ListItem Text="SCAC" Value="SCAC" />
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Carrier Type
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="lstCarrierType" CssClass="bodycopy">
                                <asp:ListItem Text="" Value="" Selected="True" />
                                <asp:ListItem Text="Airline" Value="Airline" />
                                <asp:ListItem Text="Vessel" Value="Vessel" />
                                <asp:ListItem Text="Truck" Value="Truck" />
                                <asp:ListItem Text="Rail" Value="Rail" />
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr style="background-color:#eeeeee">
                        <td>
                            Code
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtCarrierCode" CssClass="shorttextfield" Width="60px"
                                MaxLength="8" />
                            <asp:RequiredFieldValidator runat="server" ID="rfvCarrierCode" ControlToValidate="txtCarrierCode"
                                ErrorMessage="*" SetFocusOnError="true" />
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
                                        <asp:ImageButton runat="server" ID="btnSave" ImageUrl="../Images/button_smallsave.gif"
                                            BorderWidth="0" OnClick="btnSave_Click" /></td>
                                    <td style="width: 5px">
                                    </td>
                                    <td>
                                        <a href="javascript:;" onclick="javascript:close_window();">
                                            <img src="../Images/button_closebooking.gif" alt="" style="border-width: 0px" /></a></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
