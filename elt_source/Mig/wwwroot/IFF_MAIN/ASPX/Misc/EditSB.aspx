<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditSB.aspx.cs" Inherits="Common_EditSB" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add/Update Schedule B</title>
    <base target="_self" />
    <link href="../../ASP/css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/jscript">
        function close_window(){
            window.close();
        }
        
        function close_window_return(argID,argName)
        {
            try{
                var arrayReturnValue = new Array();
                
                arrayReturnValue[0] = argID;
                arrayReturnValue[1] = argName;
                
                window.returnValue = arrayReturnValue;
            }catch(err){}
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
        <asp:HiddenField runat="server" ID="hSBID" />
        <asp:HiddenField runat="server" ID="hOrgID" />
        <center>
            <div style="width: 95%; text-align: left; margin: 10px 0px 10px 0px">
                <asp:Label runat="server" ID="labelTitle" CssClass="style01" />
            </div>
            <div style="width: 95%; text-align: left; margin: 10px 0px 10px 0px">
                <table cellpadding="2" cellspacing="0" border="0" class="bodycopy" style="width: 100%;
                    border: solid 1px #73beb6" runat="server" id="tableContent">
                    <tr style="background-color: #ccebed">
                        <td colspan="2">
                            <strong>Item Information</strong>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="background-color: #999999; height: 1px">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img src="../../ASP/Images/required.gif" align="absbottom" alt="" />Schedule B Code
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtSBCode" CssClass="shorttextfield" MaxLength="16"
                                Width="150px" />
                            <asp:RequiredFieldValidator runat="server" ID="rfvSBCode" ControlToValidate="txtSBCode"
                                ErrorMessage="*" SetFocusOnError="true" />
                        </td>
                    </tr>
                    <tr style="background-color:#eeeeee">
                        <td>
                            <img src="../../ASP/Images/required.gif" align="absbottom" alt="" />Item Description
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtItemDesc" CssClass="shorttextfield" MaxLength="128"
                                Width="260px" />
                            <asp:RequiredFieldValidator runat="server" ID="rfvItemDesc" ControlToValidate="txtItemDesc"
                                ErrorMessage="*" SetFocusOnError="true" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img src="../../ASP/Images/required.gif" align="absbottom" alt="" />Schedule B Unit 1
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="lstSBUnit1" CssClass="bodycopy" />
                            <asp:RequiredFieldValidator runat="server" ID="rfvSBUnit1" ControlToValidate="lstSBUnit1"
                                ErrorMessage="*" SetFocusOnError="true" />
                        </td>
                    </tr>
                    <tr style="background-color:#eeeeee">
                        <td>
                            Schedule B Unit 2
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="lstSBUnit2" CssClass="bodycopy" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Export Code
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="lstExportCode" CssClass="bodycopy" />
                        </td>
                    </tr>
                    <tr style="background-color:#eeeeee">
                        <td>
                            License Type
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="lstLicenseType" CssClass="bodycopy" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            ECCN
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtECCN" CssClass="shorttextfield" Width="40px" MaxLength="5" />
                        </td>
                    </tr>
                </table>
                <asp:Label runat="server" ID="txtResultBox" Width="100%" Visible="false" CssClass="bodycopy" />
                <br />
                <table cellpadding="2" cellspacing="0" border="0" class="bodycopy" style="width: 100%;
                    border: solid 1px #73beb6">
                    <tr>
                        <td colspan="2" style="background-color: #ccebed; text-align: center">
                            <table cellspacing="0" cellpadding="2" border="0">
                                <tr>
                                    <td>
                                        <asp:ImageButton runat="server" ID="btnSave" ImageUrl="../../ASP/Images/button_smallsave.gif"
                                            BorderWidth="0" OnClick="btnSave_Click" />
                                            </td>
                                    <td style="width: 5px">
                                    </td>
                                    <td>
                                        <a href="javascript:;" onclick="javascript:close_window();">
                                            <img src="../../ASP/Images/button_closebooking.gif" alt="" style="border-width: 0px" /></a></td>
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
