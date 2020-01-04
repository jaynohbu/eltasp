<%@ Page Language="C#" AutoEventWireup="true" CodeFile="APDisputeSelect.aspx.cs"
    Inherits="ASPX_Reports_Accounting_APDisputeSelect" %>

<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>AP Dispute</title>

    <script src="/IFF_MAIN/ASPX/jScripts/ig_editDrop1.js" type="text/javascript"></script>

    <link href="/IFF_MAIN/ASPX/CSS/AppStyle.css" rel="stylesheet" type="text/css" />
    <link href="/IFF_MAIN/ASPX/CSS/elt_css.css" rel="stylesheet" type="text/css" />

    <script src="/ASP/ajaxFunctions/ajax.js" type="text/javascript"></script>

    <script src="/ASP/Include/JPED.js" type="text/javascript"></script>

    <script src="/ASP/Include/JPTableDOM.js" type="text/javascript"></script>

    <script type="text/javascript">
        function lstVendorNameChange(orgNo,orgName)
        {
            var hiddenObj = document.getElementById("hVendorAcct");
            var divObj = document.getElementById("lstVendorNameDiv");
            var txtObj = document.getElementById("lstVendorName");
            
            hiddenObj.value = orgNo;
            txtObj.value = orgName;
            
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
    </script>
    <script src="/Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery-ui-1.8.20.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery.plugin.period.js" type="text/javascript"></script>
     <link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css"
        rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        $(document).ready(function () {
            $("#Webdatetimeedit1").datepicker();
            $("#Webdatetimeedit2").datepicker();
            $("#ddlPeriod").PeriodList({ StartDateField: $("#Webdatetimeedit1").get(0), EndDateField: $("#Webdatetimeedit2").get(0) });
        });
    </script>
    <!--  #INCLUDE FILE="../../include/common.htm" -->
</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
        <center>
            <input type="image" style="width: 0px; height: 0px; position:absolute" onclick="return false;" />
            <div style="width: 95%; text-align: left" class="pageheader">
                A/P Dispute</div>
            <table cellpadding="0" cellspacing="0" border="0" style="border: solid 1px #89a979;
                width: 95%; text-align: left">
                <tr>
                    <td style="height: 10px; background-color: #D5E8CB" colspan="4">
                    </td>
                </tr>
                <tr align="left" valign="middle">
                    <td style="height: 1px; background-color: #89A979" colspan="4">
                    </td>
                </tr>
                <tr>
                    <td style="background-color: #f3f3f3; text-align: center">
                        <br />
                        <div style="width: 62%; text-align: right; height: 20px">
                            <span class="bodyheader">
                                <img src="/ASP/Images/required.gif" align="absbottom" alt="" />Required
                                field</span>
                        </div>
                        <table width="62%" border="0" cellpadding="0" cellspacing="0" style="padding-left: 10px;
                            border: solid 1px #89a979; background-color: #ffffff; text-align: left">
                            <tr style="background-color: #E7F0E2; height: 22px">
                                <td>
                                    <asp:Label ID="Label2" runat="server" CssClass="bodyheader">Period</asp:Label></td>
                                <td colspan="2">
                                    <asp:Label ID="Label3" runat="server" CssClass="bodyheader"><img src="/ASP/Images/required.gif" align="absbottom" alt="" />From</asp:Label></td>
                                <td>
                                    <asp:Label ID="Label1" runat="server" CssClass="bodyheader"><img src="/ASP/Images/required.gif" align="absbottom" alt="" />To</asp:Label></td>
                            </tr>
                            <tr style="height: 22px">
                                <td>
                                    <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="ddlPeriod" />

                                </td>
                                <td colspan="2">
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                             <asp:TextBox runat="server" ID="Webdatetimeedit1"></asp:TextBox>
                                            </td>
                                            <td style="padding-left: 4px">
                                                <asp:RequiredFieldValidator ID="rfvWebdatetimeedit1" runat="server" ControlToValidate="Webdatetimeedit1"
                                                    ErrorMessage="Select From"></asp:RequiredFieldValidator></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                            <asp:TextBox runat="server" ID="Webdatetimeedit2"></asp:TextBox>
                                               
                                            </td>
                                            <td style="padding-left: 4px">
                                                <asp:RequiredFieldValidator ID="rfvWebdatetimeedit2" runat="server" ControlToValidate="Webdatetimeedit2"
                                                    ErrorMessage="Select To"></asp:RequiredFieldValidator></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" style="background-color: #89A979; height: 2px">
                                </td>
                            </tr>
                            <tr style="height: 22px">
                                <td colspan="2">
                                    <asp:Label ID="lblBranch" runat="server" Visible="False" CssClass="bodyheader">Branch</asp:Label></td>
                                <td colspan="2">
                                    <asp:Label ID="Label8" runat="server" CssClass="bodyheader">Vendor</asp:Label></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:DropDownList ID="DlBranch" runat="server" CssClass="smallselect" Font-Names="Verdana"
                                        Height="20px" Visible="False" Width="260px">
                                    </asp:DropDownList></td>
                                <td colspan="2">
                                    <!-- Start JPED -->
                                    <asp:HiddenField runat="server" ID="hVendorAcct" Value="0" />
                                    <div id="lstVendorNameDiv">
                                    </div>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <asp:TextBox runat="server" autocomplete="off" ID="lstVendorName" Width="250px" Text=""
                                                    CssClass="shorttextfield" Style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Vendor','lstVendorNameChange',null,event)"
                                                    onfocus="initializeJPEDField(this,event);" ForeColor="#00000" /></td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstVendorName','Vendor','lstVendorNameChange')"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>

                                        </tr>
                                    </table>
                                    <!-- End JPED -->
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" style="height: 10px">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="left" valign="top">
                                    &nbsp;</td>
                                <td colspan="2" align="center" valign="middle" style="height: 22px">
                                    <asp:ImageButton ID="btn_Go" runat="server" ImageUrl="../../../images/button_go.gif"
                                        OnClick="btnGo_Click"></asp:ImageButton></td>
                            </tr>
                        </table>
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td style="height: 1px; background-color: #89A979" colspan="4">
                    </td>
                </tr>
                <tr>
                    <td style="height: 22px; background-color: #D5E8CB" colspan="4">
                    </td>
                </tr>
            </table>
            <br />
            <br />
            <br />
           
        </center>
    </form>
</body>

<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</html>
