<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RefundTo.aspx.cs" Inherits="ASPX_AccountingTasks_RefundTo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Refund to Customer</title>
     <link href="../CSS/elt_css.css" type="text/css" rel="stylesheet"/>
    		<script type="text/javascript" src="../jScripts/JPED_NET.js"></script>
    		   		<script type="text/javascript" src="../jScripts/MAWB_DROPDOWN.js"></script>
		<script type="text/javascript" src="../jScripts/WindowsManip.js"></script>
        <script type="text/javascript" language="JavaScript" src="../../ASP/ajaxFunctions/ajax.js"></script>
<!--  #INCLUDE FILE="../include/common.htm" -->
 
   
    
    <script  type="text/javascript" language="JavaScript">

function lstCustomerNameChange(orgNum,orgName)
{
    //var infoObj = document.getElementById("txtCustomerInfo");
    var txtObj = document.getElementById("lstCustomerName");
    var divObj = document.getElementById("lstCustomerNameDiv")

    //infoObj.value = getOrganizationInfo(orgNum);
    document.getElementById("hCustomerAcct").value=orgNum;
    txtObj.value = orgName;
    divObj.style.position = "absolute";
    divObj.style.visibility = "hidden";
    form1.submit();
}
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table align="center" border="0" cellpadding="2" cellspacing="0" width="95%">
            <tr>
                <td align="left" class="pageheader" height="32" valign="middle" width="30%">
                    Refund to Customer</td>
                <td align="right" valign="baseline" width="70%">
                    <span class="labelSearch"></span>&nbsp;<!-- Search -->
                </td>
            </tr>
        </table>
        <table align="center" border="0" bordercolor="#89a979" cellpadding="0" cellspacing="0"
            class="border1px" width="95%">
            <tr>
                <td align="center" bgcolor="#d5e8cb" height="24" style="border-bottom: #89a979 1px solid"
                    valign="middle">
                </td>
            </tr>
            <tr>
                <td align="center" bgcolor="#f3f3f3" style="padding-right: 0px; padding-left: 0px;
                    padding-bottom: 24px; padding-top: 24px; border-bottom: #89a979 2px solid">
                    <table bgcolor="#ffffff" border="0" bordercolor="#89a979" cellpadding="0" cellspacing="0"
                        class="border1px" style="padding-left: 10px" width="80%">
                        <tr bgcolor="#e7f0e2">
                            <td bgcolor="#e7f0e2" height="18" style="text-align: left">
                                Customer&nbsp;</td>
                            <td style="text-align: left">
                                &nbsp;Method</td>
                        </tr>
                        <tr>
                            <td style="text-align: left" valign="top"><div  id="lstCustomerNameDiv" align=left  ></div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td><asp:TextBox type="text" autocomplete="off" id="lstCustomerName" name="lstCustomerName" 
                                                                        class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; height: 12px;"  onKeyUp="organizationFill(this,'Customer','lstCustomerNameChange')"
                                                                        onfocus="initializeJPEDField(this);" runat="server" ForeColor="Black" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCustomerName','Customer','lstCustomerNameChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hCustomerAcct','lstCustomerName','txtCustomerInfo')" /></td>
                                                                        
                                                                        <td><br /></td>
                                                            </tr>
                                          </table>
                                                        
                                                        <!-- End JPED --> 
                                &nbsp;</td>
                            <td style="text-align: left" valign="top">
                                &nbsp;<asp:RadioButtonList ID="checkMethod" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem>Credit</asp:ListItem>
                                    <asp:ListItem>Check</asp:ListItem>
                                </asp:RadioButtonList></td>
                        </tr>
                        <tr>
                            <td valign="top">
                            </td>
                            <td valign="top">
                                </td>
                        </tr>
                        <tr>
                            <td valign="top">
                            </td>
                            <td valign="top">
                                <asp:ImageButton ID="btnGo" runat="server" ImageUrl="../../images/button_go.gif"
                                    OnClick="btnGo_Click" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td bgcolor="#e7f0e2" height="18">
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="center" bgcolor="#d5e8cb" height="24" style="border-top: #89a979 1px solid"
                    valign="middle">
                </td>
            </tr>
        </table>
        <table align="center" border="0" cellpadding="0" cellspacing="0" width="95%">
            <tr>
                <td align="right" valign="bottom" width="55%">
                    <div id="print">
                        <asp:HiddenField ID="hCustomerAcct" runat="server" />
                        <a href="javascript:;" onclick="" style="cursor: pointer"></a>&nbsp;</div>
                </td>
            </tr>
        </table>
        <br />
    
    </div>
    </form>
</body>
</html>
