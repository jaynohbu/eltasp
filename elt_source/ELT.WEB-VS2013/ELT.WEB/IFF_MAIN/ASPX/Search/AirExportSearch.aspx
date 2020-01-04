<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AirExportSearch.aspx.cs"
    Inherits="ASPX_Search_AirExportSearch" %>
<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport" TagPrefix="cc1" %>
<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Search</title>
    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
    <link href="../CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <script src="/ASP/ajaxFunctions/ajax.js" type="text/javascript"></script>
    <script src="/ASP/Include/JPED.js" type="text/javascript"></script>
    <script src="/ASP/Include/JPTableDOM.js" type="text/javascript"></script>
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

    <script type="text/javascript">

        function openWindowFromSearch(url) {
            window.open(url, "popUpWindow", "menubar=0,toolbar=0,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600");
        }

        function lstShipperNameChange(orgNum, orgName) {
            var hiddenObj = document.getElementById("hShipperAcct");
            var txtObj = document.getElementById("lstShipperName");
            var divObj = document.getElementById("lstShipperNameDiv")

            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }

        function lstCarrierNameChange(orgNum, orgName) {
            var c_hiddenObj = document.getElementById("hCarrierAcct");
            var c_txtObj = document.getElementById("lstCarrierName");
            var c_divObj = document.getElementById("lstCarrierNameDiv");

            c_hiddenObj.value = orgNum;
            c_txtObj.value = orgName;
            c_divObj.style.position = "absolute";
            c_divObj.style.visibility = "hidden";
        }

        function lstAgentNameChange(ANum, AName) {
            var AhiddenObj = document.getElementById("hAgentAcct");
            var AtxtObj = document.getElementById("lstAgentName");
            var AdivObj = document.getElementById("lstAgentNameDiv");

            AhiddenObj.value = ANum;
            AtxtObj.value = AName;
            AdivObj.style.position = "absolute";
            AdivObj.style.visibility = "hidden";
        }

        function lstConsigneeNameChange(orgNum, orgName) {
            var hiddenObj = document.getElementById("hConsigneeAcct");
            var txtObj = document.getElementById("lstConsigneeName");
            var divObj = document.getElementById("lstConsigneeNameDiv");

            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.innerHTML = "";
        }

        function searchNumFill(obj, changeFunction, vHeight) {
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if (qStr != "" && keyCode != 229 && keyCode != 27) {
                url = "/ASP/ajaxFunctions/ajax_get_international_mawb_list.asp?mode=AE&qStr=" + qStr;
                FillOutJPED(obj, url, changeFunction, vHeight);
            }
        }

        function searchNumFillAll(objName, changeFunction, vHeight) {
            var obj = document.getElementById(objName);
            url = "/ASP/ajaxFunctions/ajax_get_international_mawb_list.asp?mode=AE";
            FillOutJPED(obj, url, changeFunction, vHeight);
        }

        function lstSearchNumChange(argV, argL) {
            var divObj = document.getElementById("lstSearchNumDiv");
            var hiddenObj = document.getElementById("hSearchNum");
            var txtObj = document.getElementById("lstSearchNum");
            hiddenObj.value = argV;
            txtObj.value = argL;
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.innerHTML = "";
        }

        function EditClick(MAWB, status) {
            if (status != "Closed") {
                url = "/ASP/air_export/new_edit_mawb.asp?Edit=yes&mawb=" + encodeURIComponent(MAWB) + "&WindowName=popUpWindow";
                openWindowFromSearch(url);
            }
            else {
                alert("Master AWB No.#" + MAWB + " is Closed!");
            }
        }

        function EditClickName(org_No) {
            var eltno = document.getElementById("hELTNO").value;
            if (org_No == eltno) {
                url = "/ASP/site_admin/co_config.asp?WindowName=popUpWindow";
            }
            else {
                url = "/ASP/master_data/client_profile.asp?Action=filter&n=" + org_No + "&WindowName=popUpWindow";
            }
            openWindowFromSearch(url);
        }

        function EditClickFILE(FILENO, status) {
            if (status != "Closed") {
                url = "/ASP/air_export/booking.asp?Edit=yes&FILENO=" + encodeURIComponent(FILENO) + "&WindowName=popUpWindow";
                openWindowFromSearch(url);
            }
            else {
                alert("That Master AWB No Was Be Closed!");
            }
        }

        function EditClickHAWB(HAWB) {
            url = "/ASP/air_export/new_edit_hawb.asp?Edit=yes&hawb=" + encodeURIComponent(HAWB) + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
        }

        function lstSearchType_Change() {

            if (document.getElementById("lstSearchType").value == "house") {
                document.getElementById("MasterFilter").style.position = "absolute";
                document.getElementById("MasterFilter").style.visibility = "hidden";
                document.getElementById("HouseFilter").style.position = "static";
                document.getElementById("HouseFilter").style.visibility = "visible";
            }
            if (document.getElementById("lstSearchType").value == "master") {
                document.getElementById("MasterFilter").style.position = "static";
                document.getElementById("MasterFilter").style.visibility = "visible";
                document.getElementById("HouseFilter").style.position = "absolute";
                document.getElementById("HouseFilter").style.visibility = "hidden";
            }
        }
        
    </script>

   
    <style type="text/css">
        #gvHouseResult > tbody > tr.header1 > td > table > tbody > tr > td > a, #gvHouseResult > tbody > tr.header1 > td > table > tbody > tr > td > a:visited, #gvHouseResult > tbody > tr.header1 > td > table > tbody > tr > td > a.link
        {
            font-size: 14px;
            color: Green;
            padding: 0 4px;
        }
        #gvHouseResult > tbody > tr.header1 > td > table > tbody > tr > td > span
        {
            font-size: 14px;
            color: Blue;
            padding: 0 4px;
        }
    </style>
    <!--  #INCLUDE FILE="../include/common.htm" -->
</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
    <div align="center">
        <table cellpadding="0" cellspacing="0" border="0" style="width: 95%; text-align: left">
            <tr>
                <td class="pageheader">
                    Search
                </td>
                <td>
                </td>
            </tr>
        </table>
        <table cellpadding="0" cellspacing="0" border="0" style="width: 95%; border-color: #a0829c"
            class="border1px">
            <tr>
                <td style="height: 8px; background-color: #E5D4E3">
                </td>
            </tr>
            <tr>
                <td style="height: 1px; background-color: #a0829c">
                </td>
            </tr>
            <tr>
                <td align="center">
                    <br />
                    <table cellpadding="2" cellspacing="2" border="0" style="width: 700px; text-align: left;
                        background-color: #dddddd; border: solid 1px #aaaaaa">
                        <tr>
                            <td>
                                <asp:DropDownList runat="server" ID="lstSearchType" Width="150px" AutoPostBack="false"
                                    onChange="lstSearchType_Change()">
                                    <asp:ListItem Text="House AWB No." Value="house" />
                                    <asp:ListItem Text="Master AWB No." Value="master" />
                                </asp:DropDownList>
                            </td>
                            <td>
                               <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="ddlPeriod" />
                            </td>
                            <td>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                        <asp:TextBox ID="Webdatetimeedit1" runat="server" CssClass="m_shorttextfield" ></asp:TextBox>
                                          
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                             <asp:TextBox ID="Webdatetimeedit2" runat="server" CssClass="m_shorttextfield" ></asp:TextBox>
                                           
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <table cellpadding="2" cellspacing="2" border="0" style="width: 700px; text-align: left;
                        background-color: #eeeeee; border: solid 1px #aaaaaa">
                        <tr class="bodyheader">
                            <td>
                                MAWB No.
                            </td>
                            <td>
                                File no.
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <asp:HiddenField ID="hSearchNum" runat="server" Value="" />
                                            <div id="lstSearchNumDiv">
                                            </div>
                                            <asp:TextBox ID="lstSearchNum" runat="server" autocomplete="off" class="shorttextfield"
                                                Style="width: 110px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: Black"
                                                onkeyup=" searchNumFill(this,'lstSearchNumChange','');" onfocus="initializeJPEDField(this,event);"></asp:TextBox>
                                        </td>
                                        <td style="width: 16px">
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" />
                                        </td>
                                        <td>
                                            <span style="margin-left: 10px; margin-right: 10px">
                                                <asp:TextBox ID="txtlast" runat="server" CssClass="m_shorttextfield" Width="50px"></asp:TextBox>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="bodyheader">Last 4 Digits/Letters</span>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <asp:TextBox ID="txtFileNo" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="bodyheader">
                            <td>
                                Departure Port
                            </td>
                            <td>
                                Destination Port
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="OriginPortSelect" />
                            </td>
                            <td>
                                <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="DestPortSelect" />
                            </td>
                        </tr>
                        <tr class="bodyheader">
                            <td>
                                Shipper
                            </td>
                            <td>
                                Consignee
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <!-- Start JPED -->
                                <asp:HiddenField runat="Server" ID="hShipperAcct" Value="" />
                                <div id="lstShipperNameDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <asp:TextBox runat="server" autocomplete="off" ID="lstShipperName" name="lstShipperName"
                                                value="" class="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                color: #000000" onKeyUp="organizationFill(this,'Shipper','lstShipperNameChange',null,event)"
                                                onfocus="initializeJPEDField(this,event);" />
                                        </td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','shipper','lstShipperNameChange')"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" />
                                        </td>
                                    </tr>
                                </table>
                                <!-- End JPED -->
                            </td>
                            <td>
                                <asp:HiddenField runat="Server" ID="hConsigneeAcct" Value="" />
                                <div id="lstConsigneeNameDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="height: 18px">
                                            <asp:TextBox runat="server" autocomplete="off" ID="lstConsigneeName" name="lstConsigneeName"
                                                CssClass="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                color: #000000" onKeyUp="organizationFill(this,'Consignee','lstConsigneeNameChange',null,event)"
                                                onfocus="initializeJPEDField(this,event);" />
                                        </td>
                                        <td style="height: 18px">
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange')"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" />
                                        </td>
                                        <td style="height: 18px">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr class="bodyheader">
                            <td>
                                Airline Carrier
                            </td>
                            <td>
                                Number of Pieces
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <asp:HiddenField runat="Server" ID="hCarrierAcct" Value="" />
                                <div id="lstCarrierNameDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="height: 18px">
                                            <asp:TextBox runat="server" autocomplete="off" ID="lstCarrierName" name="lstCarrierName"
                                                CssClass="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                color: #000000" onKeyUp="organizationFill(this, 'Carrier','lstCarrierNameChange',null,event)"
                                                onfocus="initializeJPEDField(this,event);" />
                                        </td>
                                        <td style="height: 18px">
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" id="img1" onclick="organizationFillAll('lstCarrierName','Carrier','lstCarrierNameChange')"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" />
                                        </td>
                                        <td style="height: 18px">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <asp:TextBox ID="NoPiece" runat="server" CssClass="m_shorttextfield" Width="120px"
                                    Style=""></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="bodyheader">
                            <td>
                                Sales Person
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:DropDownList CssClass="bodycopy" Width="150px" runat="server" ID="SaleDroplist" />
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <asp:Panel runat="server" ID="HouseFilter">
                        <table cellpadding="2" cellspacing="2" border="0" style="width: 700px; text-align: left;
                            background-color: #eeeeee; border: solid 1px #aaaaaa">
                            <tr class="bodyheader">
                                <td>
                                    House AWB No.
                                </td>
                                <td>
                                    Type of House
                                </td>
                                <td colspan="2">
                                    Agent
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtHouseNo" runat="server" CssClass="shorttextfield" Width="150px" />
                                </td>
                                <td>
                                    <asp:RadioButtonList ID="lstHouseType" runat="server" CssClass="bodycopy" RepeatDirection="Horizontal">
                                        <asp:ListItem Text="Master" Value="Master"></asp:ListItem>
                                        <asp:ListItem Text="Sub" Value="Sub"></asp:ListItem>
                                        <asp:ListItem Text="All" Value="All" Selected="True"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td colspan="2">
                                    <!-- Start JPED -->
                                    <asp:HiddenField runat="Server" ID="hAgentAcct" Value="" />
                                    <div id="lstAgentNameDiv">
                                    </div>
                                    <table cellpadding="0" cellspacing="0" border="0" runat="server" id="tblAgent">
                                        <tr>
                                            <td>
                                                <asp:TextBox runat="server" autocomplete="off" ID="lstAgentName" name="lstAgentName"
                                                    value="" class="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                    border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                    color: #000000" onKeyUp="organizationFill(this,'Agent','lstAgentNameChange',null,event)"
                                                    onfocus="initializeJPEDField(this,event);" />
                                            </td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstAgentName','Agent','lstAgentNameChange')"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" />
                                            </td>
                                        </tr>
                                    </table>
                                    <!-- End JPED -->
                                </td>
                            </tr>
                            <tr class="bodyheader">
                                <td>
                                    LC No.
                                </td>
                                <td>
                                    CI No.
                                </td>
                                <td>
                                    Other Reference No.
                                </td>
                                <td>
                                    AES ITN No.
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="LCNO" runat="server" CssClass="m_shorttextfield" Width="120px" />
                                </td>
                                <td>
                                    <asp:TextBox ID="CINO" runat="server" CssClass="m_shorttextfield" Width="120px" />
                                </td>
                                <td>
                                    <asp:TextBox ID="OTH_REF_NO" runat="server" CssClass="m_shorttextfield" Width="120px" />
                                </td>
                                <td>
                                    <asp:TextBox ID="AESNO" runat="server" CssClass="m_shorttextfield" Width="120px" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <asp:Panel runat="server" ID="MasterFilter">
                        <table cellpadding="2" cellspacing="2" border="0" style="width: 700px; text-align: left;
                            background-color: #eeeeee; border: solid 1px #aaaaaa">
                            <tr class="bodyheader">
                                <td>
                                    Type of Shipment
                                </td>
                                <td>
                                    Master AWB Status
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:RadioButtonList runat="server" ID="lstShipmentType" CssClass="bodycopy" RepeatDirection="Horizontal">
                                        <asp:ListItem Text="Direct" Value="Direct"></asp:ListItem>
                                        <asp:ListItem Text="Consol" Value="Consol"></asp:ListItem>
                                        <asp:ListItem Text="All" Value="All" Selected="true"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td>
                                    <asp:RadioButtonList runat="server" ID="lstMasterStatus" CssClass="bodycopy" RepeatDirection="Horizontal">
                                        <asp:ListItem Text="Closed" Value="Closed"></asp:ListItem>
                                        <asp:ListItem Text="Used" Value="Used"></asp:ListItem>
                                        <asp:ListItem Text="All" Value="All" Selected="true"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <table cellpadding="2" cellspacing="2" border="0" style="width: 700px; text-align: left">
                        <tr>
                            <td style="text-align: right">
                                <asp:ImageButton runat="server" ImageUrl="../../Images/button_go.gif" ID="btnGo"
                                    OnClick="btnGo_Click" />
                            </td>
                        </tr>
                    </table>
                    <table cellpadding="0" cellspacing="0" border="0" style="width: 1000px; text-align: left">
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="txtResultBox" CssClass="bodycopy" />
                            </td>
                            <td style="text-align: right">
                                <asp:ImageButton ID="btnExcelExport" runat="server" ImageUrl="/ASP/Images/button_exel.gif"
                                    OnClick="btnExcelExport_Click" Visible="false" />
                            </td>
                        </tr>
                    </table>
                    <asp:GridView ID="gvHouseResult" runat="server" BackColor="White" BorderColor="#DEDFDE"
                        BorderStyle="None" BorderWidth="1px" CellPadding="4" AutoGenerateColumns="False"
                        AllowPaging="True" AllowSorting="True" PageSize="20" OnPageIndexChanging="gvHouseResult_PageIndexChanging"
                        Visible="false">
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            <asp:TemplateField HeaderText="House AWB">
                                <ItemTemplate>
                                    <a href="javascript:EditClickHAWB('<%# Eval("HAWB_NUM") %>');">
                                        <%# Eval("HAWB_NUM") %></a>
                                </ItemTemplate>
                                <ItemStyle Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Master AWB">
                                <ItemTemplate>
                                    <a href="javascript:EditClick('<%# Eval("MasterNo") %>');">  <%# Eval("MasterNo")%></a>
                                </ItemTemplate>
                                <ItemStyle Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="File No.">
                                <ItemTemplate>
                                    <a href="javascript:EditClickFILE('<%# Eval("file#") %>');">
                                        <%# Eval("file#")%></a>
                                </ItemTemplate>
                                <ItemStyle Width="80px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Carrier_Desc" HeaderText="Carrier" InsertVisible="False"
                                ReadOnly="True">
                                <ItemStyle Width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Shipper_Name" HeaderText="Shipper" InsertVisible="False"
                                ReadOnly="True">
                                <ItemStyle Width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="consignee_name" HeaderText="Consingee" InsertVisible="False"
                                ReadOnly="True">
                                <ItemStyle Width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Agent_name" HeaderText="Agent" InsertVisible="False" ReadOnly="True">
                                <ItemStyle Width="110px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Departure_Airport" HeaderText="Departure Port" InsertVisible="False"
                                ReadOnly="True">
                                <ItemStyle Width="110px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Dest_Airport" HeaderText="Destination Port" InsertVisible="False"
                                ReadOnly="True">
                                <ItemStyle Width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Status" HeaderText="Status" InsertVisible="False" ReadOnly="True">
                                <ItemStyle Width="60px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Type" HeaderText="Type" InsertVisible="False" ReadOnly="True">
                                <ItemStyle Width="60px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CreatedDate" HeaderText="Date" InsertVisible="False" ReadOnly="True"
                                DataFormatString="{0:d}">
                                <ItemStyle Width="70px" />
                            </asp:BoundField>
                        </Columns>
                        <FooterStyle BackColor="#CCCC99" />
                        <HeaderStyle BackColor="#CCCCCC" Font-Bold="True" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" CssClass="header1" HorizontalAlign="Right" />
                        <RowStyle BackColor="#F7F7DE" />
                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <SortedAscendingCellStyle BackColor="#FBFBF2" />
                        <SortedAscendingHeaderStyle BackColor="#848384" />
                        <SortedDescendingCellStyle BackColor="#EAEAD3" />
                        <SortedDescendingHeaderStyle BackColor="#575357" />
                    </asp:GridView>
                    <asp:GridView ID="gvMasterResult" runat="server" BackColor="White" BorderColor="#DEDFDE"
                        BorderStyle="None" BorderWidth="1px" CellPadding="4" AutoGenerateColumns="False"
                        AllowPaging="True" AllowSorting="True" PageSize="20" OnPageIndexChanging="gvMasterResult_PageIndexChanging"
                        Visible="false" PagerSettings-Position="TopAndBottom">
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            <asp:TemplateField HeaderText="Master AWB">
                                <ItemTemplate>
                                    <a href="javascript:EditClick('<%# Eval("MasterNo") %>');"><%# Eval("MasterNo")%></a>
                                </ItemTemplate>
                                <ItemStyle Width="120px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="File No.">
                                <ItemTemplate>
                                    <a href="javascript:EditClickFILE('<%# Eval("file#") %>');">
                                        <%# Eval("file#")%></a>
                                </ItemTemplate>
                                <ItemStyle Width="80px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Carrier_Desc" HeaderText="Carrier" InsertVisible="False"
                                ReadOnly="True">
                                <ItemStyle Width="130px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Shipper_Name" HeaderText="Shipper" InsertVisible="False"
                                ReadOnly="True">
                                <ItemStyle Width="130px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="consignee_name" HeaderText="Consingee" InsertVisible="False"
                                ReadOnly="True">
                                <ItemStyle Width="130px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Departure_Airport" HeaderText="Departure Port" InsertVisible="False"
                                ReadOnly="True">
                                <ItemStyle Width="120px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Dest_Airport" HeaderText="Destination Port" InsertVisible="False"
                                ReadOnly="True">
                                <ItemStyle Width="120px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Status" HeaderText="Status" InsertVisible="False" ReadOnly="True">
                                <ItemStyle Width="60px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Type" HeaderText="Type" InsertVisible="False" ReadOnly="True">
                                <ItemStyle Width="60px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CreatedDate" HeaderText="Date" InsertVisible="False" ReadOnly="True"
                                DataFormatString="{0:d}">
                                <ItemStyle Width="70px" />
                            </asp:BoundField>
                        </Columns>
                        <FooterStyle BackColor="#CCCC99" Font-Size="Large" />
                        <HeaderStyle BackColor="#CCCCCC" Font-Bold="True" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" Font-Size="Large" CssClass="Total14pt"
                            HorizontalAlign="Right" />
                        <RowStyle BackColor="#F7F7DE" />
                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <SortedAscendingCellStyle BackColor="#FBFBF2" />
                        <SortedAscendingHeaderStyle BackColor="#848384" />
                        <SortedDescendingCellStyle BackColor="#EAEAD3" />
                        <SortedDescendingHeaderStyle BackColor="#575357" />
                    </asp:GridView>
                    <br />
                </td>
            </tr>
            <tr>
                <td style="height: 1px; background-color: #a0829c">
                </td>
            </tr>
            <tr>
                <td style="height: 25px; background-color: #E5D4E3">
                </td>
            </tr>
        </table>
    </div>
    <br />
    <br />
    <br />
  
    </form>
</body>
<script type="text/javascript">

    lstSearchType_Change();
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
