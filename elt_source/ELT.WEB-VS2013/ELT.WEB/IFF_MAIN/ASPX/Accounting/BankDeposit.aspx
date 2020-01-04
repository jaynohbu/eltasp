<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BankDeposit.aspx.cs" Inherits="ASPX_Accounting_BankDeposit" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="/ASP/CSS/elt_css.css" rel="stylesheet" type="text/css" />

    <script src="/ASP/ajaxFunctions/ajax.js" type="text/javascript"></script>

    <script src="/ASP/Include/JPED.js" type="text/javascript"></script>

    <script id="main" type="text/javascript">
        function lstVendorNameChange(orgNo,orgName)
        {
            var hiddenObj = document.getElementById("hVendorAcct");
            var divObj = document.getElementById("lstVendorNameDiv")
            var txtObj = document.getElementById("lstVendorName")
            
            hiddenObj.value = orgNo;
            txtObj.value = orgName;
            
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
    </script>

</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
        <asp:HiddenField runat="server" ID="hEntryNo" />
        <center>
            <table cellpadding="0" cellspacing="0" border="0" style="width: 95%; text-align: left">
                <tr>
                    <td class="pageheader">
                        <asp:Label runat="server" ID="labelPageTitle" Text="Bank Deposit" />
                    </td>
                    <td style="text-align: right">
                    </td>
                </tr>
            </table>
            <asp:Label runat="server" ID="txtResultBox" Width="95%" Visible="false" />
            <table cellpadding="2" cellspacing="0" border="0" style="width: 95%; border: solid 1px #89A979; text-align:center">
                <tr style="background-color: #D5E8CB">
                    <td>
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td><asp:ImageButton runat="server" ID="btnSaveTop" ImageUrl="/ASP/images/button_smallsave.gif" OnClick="btnSaveTop_Click" />
                                </td>
                                <td style="width:15px"></td>
                                <td><asp:ImageButton runat="server" ID="btnDeleteTop" ImageUrl="/ASP/images/button_delete_bold.gif" OnClick="btnDeleteTop_Click" Visible="false" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr style="background-color: #89A979; height: 1px">
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                        <table cellpadding="3" cellspacing="0" border="0" style="text-align: left; border: solid 1px #89A979"
                            class="bodycopy">
                            <tr style="background-color: #E7F0E2">
                                <td style="width: 105px">
                                    <b>Customer</b></td>
                                <td>
                                    <!-- Start JPED -->
                                    <asp:HiddenField runat="server" ID="hVendorAcct" Value="0" />
                                    <div id="lstVendorNameDiv">
                                    </div>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <asp:TextBox runat="server" autocomplete="off" ID="lstVendorName" Width="280px" Text=""
                                                    CssClass="shorttextfield" Style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Vendor','lstVendorNameChange',null,event)"
                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstVendorName','Vendor','lstVendorNameChange',null,event)"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                            <td>
                                                <input type='hidden' id='quickAdd_output'/>
                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" style="cursor: hand" onclick="quickAddClient('hVendorAcct','lstVendorName','txtVendorInfo','lstVendorNameChange')" />
                                                <asp:RequiredFieldValidator ID="rfvVendor" runat="server" ControlToValidate="lstVendorName"
                                                    ErrorMessage="*" SetFocusOnError="true"></asp:RequiredFieldValidator></td>
                                        </tr>
                                    </table>
                                    <!-- End JPED -->
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Bank</b></td>
                                <td>
                                    <asp:DropDownList runat="server" ID="lstBanks" CssClass="bodycopy" />
                                    <asp:RequiredFieldValidator ID="rfvBank" runat="server" ControlToValidate="lstBanks"
                                        SetFocusOnError="true" ErrorMessage="*">
                                    </asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr style="background-color: #E7F0E2">
                                <td>
                                    <b>Other Revenue Type</b></td>
                                <td>
                                    <asp:DropDownList runat="server" ID="lstRevenues" CssClass="bodycopy" />
                                    <asp:RequiredFieldValidator ID="rfvRevenue" runat="server" ControlToValidate="lstRevenues"
                                        SetFocusOnError="true" ErrorMessage="*">
                                    </asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Amount ($)</b></td>
                                <td>
                                    <asp:TextBox runat="server" ID="txtAmount" CssClass="shorttextfield" Style="behavior: url(../../ASP/include/igNumDotChkLeft.htc);" />
                                    <asp:RequiredFieldValidator ID="rfvAmount" runat="server" ControlToValidate="txtAmount"
                                        ErrorMessage="*" SetFocusOnError="true"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr style="background-color: #E7F0E2">
                                <td>
                                    <b>Memo</b></td>
                                <td>
                                    <asp:TextBox runat="server" ID="txtMemo" CssClass="shorttextfield" TextMode="MultiLine"
                                        Rows="5" Width="400px" />
                                </td>
                            </tr>
                        </table>
                        <br />
                    </td>
                </tr>
                <tr style="background-color: #89A979; height: 1px">
                    <td>
                    </td>
                </tr>
                <tr style="background-color: #D5E8CB">
                    <td>
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td><asp:ImageButton runat="server" ID="btnSaveBot" ImageUrl="/ASP/images/button_smallsave.gif" OnClick="btnSaveBot_Click" />
                                </td>
                                <td style="width:15px"></td>
                                <td><asp:ImageButton runat="server" ID="btnDeleteBot" ImageUrl="/ASP/images/button_delete_bold.gif" OnClick="btnDeleteBot_Click" Visible="false" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </center>
    </form>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
