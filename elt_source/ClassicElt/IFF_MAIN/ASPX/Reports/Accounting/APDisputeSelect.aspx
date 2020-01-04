<%@ Page Language="C#" AutoEventWireup="true" CodeFile="APDisputeSelect.aspx.cs"
    Inherits="ASPX_Reports_Accounting_APDisputeSelect" %>

<%@ Register TagPrefix="uc1" TagName="rdSelectDateControl1" Src="../SelectionControls/rdSelectDateControl1.ascx" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>AP Dispute</title>

    <script src="../jScripts/WebDateSet1.js" type="text/javascript"></script>

    <script src="../jScripts/ig_dropCalendar.js" type="text/javascript"></script>

    <script src="../jScripts/ig_editDrop1.js" type="text/javascript"></script>

    <link href="../../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/elt_css.css" rel="stylesheet" type="text/css" />

    <script src="../../../ASP/ajaxFunctions/ajax.js" type="text/javascript"></script>

    <script src="../../../ASP/Include/JPED.js" type="text/javascript"></script>

    <script src="../../../ASP/Include/JPTableDOM.js" type="text/javascript"></script>

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
                                <img src="/iff_main/ASP/Images/required.gif" align="absbottom" alt="" />Required
                                field</span>
                        </div>
                        <table width="62%" border="0" cellpadding="0" cellspacing="0" style="padding-left: 10px;
                            border: solid 1px #89a979; background-color: #ffffff; text-align: left">
                            <tr style="background-color: #E7F0E2; height: 22px">
                                <td>
                                    <asp:Label ID="Label2" runat="server" CssClass="bodyheader">Period</asp:Label></td>
                                <td colspan="2">
                                    <asp:Label ID="Label3" runat="server" CssClass="bodyheader"><img src="/iff_main/ASP/Images/required.gif" align="absbottom" alt="" />From</asp:Label></td>
                                <td>
                                    <asp:Label ID="Label1" runat="server" CssClass="bodyheader"><img src="/iff_main/ASP/Images/required.gif" align="absbottom" alt="" />To</asp:Label></td>
                            </tr>
                            <tr style="height: 22px">
                                <td>
                                    <uc1:rdSelectDateControl1 ID="RdSelectDateControl11" runat="server"></uc1:rdSelectDateControl1>
                                </td>
                                <td colspan="2">
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <igtxt:WebDateTimeEdit ID="Webdatetimeedit1" AccessKey="e" runat="server" ForeColor="Black"
                                                    Width="171px" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" ">
                                                    <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                    </ButtonsAppearance>
                                                    <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
                                                </igtxt:WebDateTimeEdit>
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
                                                <igtxt:WebDateTimeEdit ID="Webdatetimeedit2" AccessKey="e" runat="server" ForeColor="Black"
                                                    Width="171px" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" ">
                                                    <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                    </ButtonsAppearance>
                                                    <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                                </igtxt:WebDateTimeEdit>
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
                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Vendor','lstVendorNameChange')"
                                                    onfocus="initializeJPEDField(this);" ForeColor="#00000" /></td>
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
                                    <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="../../../images/button_go.gif"
                                        OnClick="ImageButton1_Click1"></asp:ImageButton></td>
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
            <div>
                <igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="171px">
                    <Layout CellPadding="0" FooterFormat="" NextMonthText="&gt;&gt;" PrevMonthText="&lt;&lt;"
                        ShowFooter="False" ShowMonthDropDown="False" ShowYearDropDown="False" TitleFormat="Month">
                        <DayStyle BackColor="White" CssClass="CalDay" />
                        <SelectedDayStyle BackColor="#C5D5FC" CssClass="CalSelectedDay" />
                        <OtherMonthDayStyle ForeColor="Silver" />
                        <NextPrevStyle CssClass="NextPrevStyle" />
                        <CalendarStyle CssClass="CalStyle">
                        </CalendarStyle>
                        <TodayDayStyle CssClass="CalToday" />
                        <DayHeaderStyle CssClass="CalDayHeader" Font-Bold="False">
                            <BorderDetails StyleBottom="None" />
                        </DayHeaderStyle>
                        <TitleStyle CssClass="TitleStyle" Font-Bold="True" />
                    </Layout>
                </igsch:WebCalendar>
            </div>
        </center>
    </form>
</body>

<script type="text/javascript">
        if(document.getElementById('Webdatetimeedit2')) {
            ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1 Webdatetimeedit2");
        }
        else {
            ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1");            
        }
</script>

<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</html>
