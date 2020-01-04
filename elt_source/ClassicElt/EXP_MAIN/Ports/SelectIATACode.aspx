<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SelectIATACode.aspx.cs" Inherits="Ports_SelectIATACode" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Search Port</title>
    <base target="_self" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style01 {
            font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 14px;
	        font-weight: bold;
	        text-transform: uppercase;
	        color: #000000;
	    }
    </style>
    <script type="text/javascript">
        function SearchStatusChange(labelText){
            document.getElementById("txtSearchStatus").value = labelText;
        }
        
        function ConfirmNext(){
            var resVal = true;
            
            if(document.getElementById("lstPortCode").value == ""){
                alert("No Port has been selected.");
                resVal = false;
            }
            
            return resVal;
        }
        
        function close_window_return(argID)
        {
            window.returnValue = argID;
            window.close();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align: center">
            <div style="width: 95%; text-align: left; margin: 10px 0px 10px 0px">
                <table cellpadding="2" cellspacing="0" border="0" style="width: 100%; border: solid 1px #999999">
                    <tr>
                        <td class="bodyheader">
                            Port Search Key
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtSearchKey" CssClass="shorttextfield" Width="150px" />
                        </td>
                        <td><input type="text" id="txtSearchStatus" class="bodycopy" style="border:none 0px" />
                        </td>
                        <td>
                            <asp:ImageButton runat="server" ID="imgButSearch" ImageUrl="../Images/icon_search_small.gif"
                                OnClick="imgButSearch_Click" OnClientClick="SearchStatusChange('Loading...');" />
                        </td>
                    </tr>
                </table>
                <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                    <tr><td style="height:5px"></td></tr>
                    <tr>
                        <td>
                            <table cellpadding="2" cellspacing="0" border="0" style="width: 100%">
                                <tr>
                                    <td class="bodyheader">
                                        IATA Airport Code (Airports Only)
                                    </td>
                                    <td style="text-align: right">
                                        <asp:ListBox runat="server" ID="lstPortCode" Width="330px" CssClass="bodycopy"  Rows="10"></asp:ListBox>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr><td style="height:5px"></td></tr>
                </table>
                <table cellpadding="2" cellspacing="0" border="0" class="bodycopy" style="width: 100%;
                    border: solid 1px #999999">
                    <tr>
                        <td colspan="2" style="background-color: #dddddd; text-align: center">
                            <table cellspacing="0" cellpadding="2" border="0">
                                <tr>
                                    <td>
                                        <asp:ImageButton runat="server" ID="btnNext" ImageUrl="../Images/button_next_bold.gif" align="absBottom" OnClick="btnNext_Click" OnClientClick="return ConfirmNext();" />
                                    </td>
                                    <td style="width:15px"></td>
                                    <td>
                                        <asp:ImageButton runat="server" ID="btnClose" ImageUrl="../Images/button_closebooking.gif" OnClientClick="javascript:window.close();" /></td>
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
