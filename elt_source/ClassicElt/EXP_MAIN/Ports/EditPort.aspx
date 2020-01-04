<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditPort.aspx.cs" Inherits="Ports_EditPort" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add/Update Port</title>
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
        
        function search_iata()
        {
            var vURL = "./SelectIATACode.aspx";
            var vWinArg = "dialogWidth:460px; dialogHeight:290px; help:no; status:no; scroll:no; center:yes; maximize:yes";
            var vReturn = showModalDialog(vURL, "popWindow", vWinArg);
            
            if(vReturn != null){
                document.getElementById("txtIATACode").value = vReturn;
            }
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
        <div style="text-align: center">
            <div style="width: 95%; text-align: left; margin: 10px 0px 10px 0px">
                <asp:Label runat="server" ID="labelTitle" CssClass="style01" />
            </div>
            <div style="width: 95%; text-align: left; margin: 10px 0px 10px 0px">
                <table cellpadding="2" cellspacing="0" border="0" class="bodycopy" style="width: 100%;
                    border: solid 1px #999999" runat="server" id="tableContent">
                    <tr style="background-color: #dddddd">
                        <td colspan="2">
                            Enter Port Information below.
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="background-color: #999999; height: 1px">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img src="../Images/required.gif" align="absbottom" alt="" />Port Code
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtIATACode" CssClass="shorttextfield" MaxLength="3"
                                Width="25px" />
                            <asp:RequiredFieldValidator runat="server" ID="rfvIATACode" ControlToValidate="txtIATACode"
                                ErrorMessage="*" SetFocusOnError="true" />
                            <a href="javascript:;" onclick="search_iata()">Airport Code (IATA) Search</a>
                        </td>
                    </tr>
                    <tr style="background-color:#eeeeee">
                        <td>
                            <img src="../Images/required.gif" align="absbottom" alt="" />Port ID (Schedule D
                            or K Code)
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtAESCode" CssClass="shorttextfield" MaxLength="5"
                                Width="40px" />
                            <asp:RequiredFieldValidator runat="server" ID="rfvAESCode" ControlToValidate="txtAESCode"
                                ErrorMessage="*" SetFocusOnError="true" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img src="../Images/required.gif" align="absbottom" alt="" />Port Desc
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtPortDesc" CssClass="shorttextfield" MaxLength="32"
                                Width="150px" />
                            <asp:RequiredFieldValidator runat="server" ID="rfvPortDesc" ControlToValidate="txtPortDesc"
                                ErrorMessage="*" SetFocusOnError="true" />
                        </td>
                    </tr>
                    <tr style="background-color:#eeeeee">
                        <td>
                            Port City
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtPortCity" CssClass="shorttextfield" MaxLength="50"
                                Width="210px" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Port State
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="lstPortState" CssClass="bodycopy">
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
                    </tr>
                    <tr style="background-color:#eeeeee">
                        <td>
                            Port Country
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="lstPortCountry" CssClass="bodycopy" Width="240px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <div><asp:Label runat="server" ID="txtResultBox" Width="100%" Visible="false" /></div>
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

