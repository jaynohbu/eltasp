﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditAES.aspx.cs" Inherits="ASPX_Misc_EditAES" %>
<%@ Register Assembly="DevExpress.Web.v13.2, Version=13.2.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v13.2, Version=13.2.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>AES Submit</title>
    <link href="/ASP/CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css"
        rel="stylesheet" type="text/css" />
    <script src="/ASP/ajaxFunctions/ajax.js" type="text/javascript"></script>
    <script src="/ASP/Include/JPED.js" type="text/javascript"></script>
    <script src="/ASP/Include/JPTableDOM.js" type="text/javascript"></script>
    <script src="/Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery-ui-1.8.20.min.js" type="text/javascript"></script>
    <script id="main" type="text/javascript">

        function UpdateItems() {

            var update_link=$(".dxgvEditFormTable").find("a");
            if (update_link.length > 0) {
                update_link.each(function() {
                    if ($(this).attr("onclick").indexOf("aspxGVScheduleCommand('gridBatchAES',['UpdateEdit'],") > -1) {
                        alert("Please Update or Cacel selected Line Item!");
                        return;
                    }
                });
            }
            __doPostBack('btnSaveAES_Click', null);
        }

        function lstConsigneeNameChange(orgNo, orgName) {
            var hiddenObj = document.getElementById("hConsigneeAcct");
            var txtObj = document.getElementById("lstConsigneeName");
            var divObj = document.getElementById("lstConsigneeNameDiv")
            hiddenObj.value = orgNo;
            var response = getOrganizationInfo(orgNo, "Consignee");
            var parsedJSON = eval('(' + response + ')');
            document.getElementById("lstConsigneeName").value = parsedJSON[0].DBA_NAME;
            document.getElementById("AD1_3").value = parsedJSON[0].DBA_NAME;
            document.getElementById("AD1_8").value = parsedJSON[0].business_address;
            document.getElementById("AD1_9").value = parsedJSON[0].business_address2;
            document.getElementById("AD1_10").value = parsedJSON[0].business_city;
            document.getElementById("AD1_11").value = parsedJSON[0].business_state;
            document.getElementById("AD1_12").value = parsedJSON[0].b_country_code;
            document.getElementById("AD1_13").value = parsedJSON[0].business_zip;


            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }

        function lstInterConsigneeNameChange(orgNo, orgName) {
            var hiddenObj = document.getElementById("hInterConsigneeAcct");
            var txtObj = document.getElementById("lstInterConsigneeName");
            var divObj = document.getElementById("lstInterConsigneeNameDiv")
            hiddenObj.value = orgNo;
            var response = getOrganizationInfo(orgNo, "InterConsignee");
            var parsedJSON = eval('(' + response + ')');

            document.getElementById("lstInterConsigneeName").value = parsedJSON[0].DBA_NAME;
            document.getElementById("AD4_3").value = parsedJSON[0].DBA_NAME;
            document.getElementById("AD4_8").value = parsedJSON[0].business_address;
            document.getElementById("AD4_9").value = parsedJSON[0].business_address2;
            document.getElementById("AD4_10").value = parsedJSON[0].business_city;
            document.getElementById("AD4_11").value = parsedJSON[0].business_state;
            document.getElementById("AD4_12").value = parsedJSON[0].b_country_code;
            document.getElementById("AD4_13").value = parsedJSON[0].business_zip;

            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }

        function lstShipperNameChange(orgNo, orgName) {
            var hiddenObj = document.getElementById("hShipperAcct");
            var txtObj = document.getElementById("lstShipperName");
            var divObj = document.getElementById("lstShipperNameDiv")
            hiddenObj.value = orgNo;
            var response = getOrganizationInfo(orgNo);

            var parsedJSON = eval('(' + response + ')');
            document.getElementById("lstShipperName").value = parsedJSON[0].DBA_NAME;
            document.getElementById("AD0_2").value = parsedJSON[0].business_fed_taxid;
            document.getElementById("AD0_4").value = parsedJSON[0].business_address;
            document.getElementById("AD0_5").value = parsedJSON[0].business_address2;
            document.getElementById("AD0_6").value = parsedJSON[0].business_city;
            document.getElementById("AD0_7").value = parsedJSON[0].business_state;
            document.getElementById("AD0_8").value = parsedJSON[0].business_zip;
            document.getElementById("AD0_9").value = parsedJSON[0].owner_fname;
            document.getElementById("AD0_10").value = parsedJSON[0].owner_mname;
            document.getElementById("AD0_11").value = parsedJSON[0].owner_lname;
            document.getElementById("AD0_12").value = parsedJSON[0].business_phone;

            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }

        function getOrganizationInfo(orgNo, objGroupName) {
            if (window.ActiveXObject) {
                try {
                    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (error) {
                    try {
                        xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (error) { return ""; }
                }
            }
            else if (window.XMLHttpRequest) {
                xmlHTTP = new XMLHttpRequest();
            }
            else { return ""; }

            var url = "/ASP/ajaxFunctions/ajax_get_org_address_info2.asp?type=B&org=" + orgNo;

            xmlHTTP.open("GET", url, false);
            xmlHTTP.send();

            return (xmlHTTP.responseText);
        }

        function displayShipperUpdate(req, field, tmpVal, tWidth, tMaxLength, url) {
            if (req.readyState == 4) {
                if (req.status == 200) {
                    try {
                        var xmlObj = req.responseXML;

                        setField("dba_name", "lstShipperName", xmlObj);
                        setField("business_fed_taxid", "AD0_2", xmlObj);
                        setField("business_address", "AD0_4", xmlObj);
                        setField("business_address2", "AD0_5", xmlObj);
                        setField("business_city", "AD0_6", xmlObj);
                        setField("business_state", "AD0_7", xmlObj);
                        setField("business_zip", "AD0_8", xmlObj);
                        setField("owner_fname", "AD0_9", xmlObj);
                        setField("owner_mname", "AD0_10", xmlObj);
                        setField("owner_lname", "AD0_11", xmlObj);
                        setField("business_phone", "AD0_12", xmlObj);

                    } catch (error) {
                        alert(error.description);
                        xmlObj = null;
                    }
                    xmlObj = null;
                }
            }
        }

        function displayConsigneeUpdate(req, field, tmpVal, tWidth, tMaxLength, url) {
            if (req.readyState == 4) {
                if (req.status == 200) {
                    try {
                        var xmlObj = req.responseXML;

                        setField("dba_name", "lstConsigneeName", xmlObj);
                        setField("business_address", "AD1_3", xmlObj);
                        setField("business_address", "AD1_8", xmlObj);
                        setField("business_address2", "AD1_9", xmlObj);
                        setField("business_city", "AD1_10", xmlObj);
                        setField("business_state", "AD1_11", xmlObj);
                        setField("b_country_code", "AD1_12", xmlObj);
                        setField("business_zip", "AD1_13", xmlObj);

                    } catch (error) {
                        alert(error.description);
                        xmlObj = null;
                    }
                    xmlObj = null;
                }
            }
        }

        function displayInterConsigneeUpdate(req, field, tmpVal, tWidth, tMaxLength, url) {
            if (req.readyState == 4) {
                if (req.status == 200) {
                    try {
                        var xmlObj = req.responseXML;

                        setField("dba_name", "lstInterConsigneeName", xmlObj);
                        setField("business_address", "AD4_3", xmlObj);
                        setField("business_address", "AD4_8", xmlObj);
                        setField("business_address2", "AD4_9", xmlObj);
                        setField("business_city", "AD4_10", xmlObj);
                        setField("business_state", "AD4_11", xmlObj);
                        setField("b_country_code", "AD4_12", xmlObj);
                        setField("business_zip", "AD4_13", xmlObj);

                    } catch (error) {
                        alert(error.description);
                        xmlObj = null;
                    }
                    xmlObj = null;
                }
            }
        }

        function setField(xmlTag, htmlTag, xmlObj) {
            if (xmlObj.getElementsByTagName(xmlTag)[0] != null && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null) {
                document.getElementById(htmlTag).value = xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue;
            }
            else {
                document.getElementById(htmlTag).value = "";
            }
        }


        

    </script>
    <script id="Infragistics" type="text/javascript">


        function AESSubmitClick() {
            if (document.getElementById("AESNO").value != "") {

                var vURL = "/ASP/aes/tran_send_aes.asp?WindowName=AESDIRECT&AESID=" + document.getElementById("AESNO").value;
                var vWinArg = "left=0,top=0,staus=0,titlebar=0,toolbar=0,menubar=0,scrollbars=1,resizable=1,location=0,width=710,height=500,hotkeys=0";

                var vWindow = window.open(vURL, "AESDIRECT", vWinArg);
                vWindow.focus();
                return false;
            }
            else {

                alert("Please, save the form before submitting to AES direct");
            }
        }

        
       
     
    </script>
    <!--  #INCLUDE FILE="../include/common.htm" -->
</head>
<body style="margin: 0px 0px 0px 0px" >
    <div id="tooltipcontent">
    </div>
    <form id="form1" runat="server">
    <asp:HiddenField runat="server" ID="AESNO" Value="" />
    <asp:HiddenField runat="server" ID="hFileType" />
    <center>
        <table cellpadding="0" cellspacing="0" border="0" style="width: 95%; text-align: left">
            <tr>
                <td class="pageheader">
                    <asp:Label runat="server" ID="labelPageTitle" />
                </td>
                <td style="text-align: right" id="print">
                    <img src="/ASP/Images/icon_submit.gif" alt="" /><a href="javascript:;" onclick="AESSubmitClick();">Submit
                        to AES Weblink</a>
                </td>
            </tr>
        </table>
        <asp:Label runat="server" ID="txtResultBox" Width="95%" Visible="false" />
        <table cellpadding="2" cellspacing="0" border="0" style="width: 95%; text-align: left;
            border: solid 1px #a0829c" class="bodycopy">
            <tr style="height: 8px; background-color: #E5D4E3">
                <td style="text-align: center">
                    <asp:ImageButton runat="server" ImageUrl="../../Images/button_save.gif" ID="btnSaveAESTop" OnClientClick="UpdateItems();"
                         />
                </td>
            </tr>
            <tr style="height: 1px; background-color: #a0829c">
                <td style="padding: 0">
                </td>
            </tr>
            <tr>
                <td>
                    <table cellpadding="2" cellspacing="0" border="0" class="bodyheader">
                        <tr>
                            <td>
                                House AWB:
                            </td>
                            <td style="width: 150px">
                                <asp:Label ID="txtHouse" runat="server" CssClass="bodycopy" ForeColor="blue" />
                            </td>
                            <td>
                                Master AWB:
                            </td>
                            <td style="width: 150px">
                                <asp:Label ID="txtMaster" runat="server" CssClass="bodycopy" ForeColor="blue" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="height: 1px; background-color: #a0829c">
                <td style="padding: 0">
                </td>
            </tr>
            <tr style="background-color: #f0e7ef">
                <td>
                    <strong>
                        <img src="/ASP/images/required.gif" align="absbottom" alt="" />Shipment Information</strong>
                </td>
            </tr>
            <tr style="height: 1px; background-color: #a0829c">
                <td style="padding: 0">
                </td>
            </tr>
            <tr>
                <td>
                    <table cellpadding="2" cellspacing="0" border="0" style="width: 100%" class="bodycopy">
                        <tr>
                            <td style="width: 25%">
                                Shipment Reference Number
                            </td>
                            <td style="width: 25%">
                                <asp:TextBox ID="SRN" runat="server" CssClass="shorttextfield" MaxLength="16" Width="120px" />
                                <asp:RequiredFieldValidator ID="rfvSRN" runat="server" ErrorMessage="*" ControlToValidate="SRN"
                                    SetFocusOnError="true" />
                            </td>
                            <td style="width: 25%">
                                Transportation Reference Number
                            </td>
                            <td style="width: 25%">
                                <asp:TextBox ID="BN" runat="server" CssClass="shorttextfield" MaxLength="30" Width="200px" />
                            </td>
                        </tr>
                        <tr style="background-color: #eeeeee">
                            <td>
                                State of Origin
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="ST" CssClass="bodycopy">
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
                                <asp:RequiredFieldValidator ID="rfvST" runat="server" ControlToValidate="ST" ErrorMessage="*"
                                    SetFocusOnError="true" />
                            </td>
                            <td>
                                Port of Export
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="POE" CssClass="bodycopy" Width="200px" />
                                <asp:RequiredFieldValidator ID="rfvPOE" runat="server" ErrorMessage="*" ControlToValidate="POE"
                                    SetFocusOnError="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Country of Destination
                            </td>
                            <td>
                                <asp:DropDownList ID="COD" runat="server" CssClass="bodycopy" Width="250px" />
                                <asp:RequiredFieldValidator ID="rfvCOD" runat="server" ControlToValidate="COD" ErrorMessage="*"
                                    SetFocusOnError="true" />
                            </td>
                            <td>
                                Port of Unloading (Vessel Only)
                            </td>
                            <td>
                                <asp:DropDownList ID="POU" runat="server" CssClass="bodycopy" Width="200px" />
                            </td>
                        </tr>
                        <tr style="background-color: #eeeeee">
                            <td>
                                Departure Date (MM/DD/YY)
                            </td>
                            <td>
                                <asp:TextBox ID="EDA" runat="server" CssClass="shorttextfield" 
                                    Width="50px" />
                                <asp:RequiredFieldValidator ID="rfvEDA" runat="server" ControlToValidate="EDA" ErrorMessage="*"
                                    SetFocusOnError="true" />
                            </td>
                            <td>
                                Mode of Transportation
                            </td>
                            <td>
                                <asp:DropDownList ID="MOT" runat="server" CssClass="bodycopy">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvMOT" runat="server" ControlToValidate="MOT" ErrorMessage="*"
                                    SetFocusOnError="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Carrier
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="lstCarrier" CssClass="bodycopy">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator runat="Server" ID="rfvCarrier" ControlToValidate="lstCarrier"
                                    Text="*" SetFocusOnError="true" />
                            </td>
                            <td>
                                Parties to Transaction
                            </td>
                            <td>
                                <asp:RadioButtonList ID="RCC" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow"
                                    CssClass="RightMargin">
                                    <asp:ListItem Text="Related&nbsp;&nbsp;&nbsp;" Value="Y" />
                                    <asp:ListItem Text="Non-related" Value="N" Selected="True" />
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr style="background-color: #eeeeee">
                            <td>
                                Hazardous Cargo
                            </td>
                            <td>
                                <asp:RadioButtonList ID="HAZ" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow"
                                    CssClass="RightMargin">
                                    <asp:ListItem Text="Yes&nbsp;&nbsp;&nbsp;" Value="Y" />
                                    <asp:ListItem Text="No" Value="N" Selected="True" />
                                </asp:RadioButtonList>
                            </td>
                            <td>
                                Routed Export Transaction
                            </td>
                            <td>
                                <asp:RadioButtonList ID="RT" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow"
                                    CssClass="RightMargin">
                                    <asp:ListItem Text="Yes&nbsp;&nbsp;&nbsp;" Value="Y" />
                                    <asp:ListItem Text="No" Value="N" Selected="True" />
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Inbond Type (Requires Inbond Number & FTZ)
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="IBT" CssClass="bodycopy" OnSelectedIndexChanged="IBT_SelectedIndexChanged"
                                    AutoPostBack="true">
                                    <asp:ListItem Text="" Value="" />
                                    <asp:ListItem Text="Warehouse Withdrawal for IE" Value="36" />
                                    <asp:ListItem Text="Warehouse Withdrawal for T&E" Value="37" />
                                    <asp:ListItem Text="Foreign Trade Zone Withdrawal for IE" Value="67" />
                                    <asp:ListItem Text="Foreign Trade Zone Withdrawal for T&E" Value="68" />
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr runat="server" id="trInbond" visible="false" style="background-color: #eeeeee">
                            <td>
                                Foreign Trade Zone (FTZ)
                            </td>
                            <td>
                                <asp:TextBox ID="FTZ" runat="server" CssClass="shorttextfield" MaxLength="5" Width="40px" />
                            </td>
                            <td>
                                Inbond Number
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="IBN" CssClass="shorttextfield" MaxLength="15" Width="110px" />
                            </td>
                        </tr>
                        <tr style="background-color: #dcdcdc" runat="server" id="trInfo1">
                            <td>
                                ITN No.
                            </td>
                            <td>
                                <asp:Label runat="server" ID="ITN" CssClass="bodycopy" Text="N/A" />
                            </td>
                            <td>
                                AES Status
                            </td>
                            <td>
                                <asp:Label runat="server" ID="STATUS" CssClass="bodycopy" Text="N/A" />
                            </td>
                        </tr>
                        <tr style="background-color: #dcdcdc" runat="server" id="trInfo2">
                            <td>
                                AES Submit Date
                            </td>
                            <td>
                                <asp:Label runat="server" ID="SubmittedDate" CssClass="bodycopy" Text="N/A" />
                            </td>
                            <td>
                                Last Updated
                            </td>
                            <td>
                                <asp:Label ID="LastUpdated" runat="server" CssClass="bodycopy" Text="N/A" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="height: 1px; background-color: #a0829c">
                <td style="padding: 0">
                </td>
            </tr>
            <tr style="background-color: #f0e7ef">
                <td>
                    <strong>Exporter & Freight Fowarder</strong>
                </td>
            </tr>
            <tr style="height: 1px; background-color: #a0829c">
                <td style="padding: 0">
                </td>
            </tr>
            <tr>
                <td>
                    <table cellpadding="2" cellspacing="0" border="0" style="width: 100%" class="bodycopy">
                        <tr>
                            <td style="width: 50%">
                                <img src="/ASP/images/required.gif" align="absbottom" alt="" /><strong>Exporter</strong>
                            </td>
                            <td style="width: 50%">
                                <strong>Freight Forwarder</strong>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <!-- Start JPED -->
                                <asp:HiddenField runat="server" ID="hShipperAcct" Value="0" />
                                <div id="lstShipperNameDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <asp:TextBox runat="server" autocomplete="off" ID="lstShipperName" Width="280px"
                                                Text="" CssClass="shorttextfield" Style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Shipper','lstShipperNameChange',null,event)"
                                                onfocus="initializeJPEDField(this,event);" />
                                        </td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange')"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" />
                                        </td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="Edit company" style="cursor: hand"
                                                onclick="quickAddClientNew('hShipperAcct','lstShipperName','txtShipperInfo','lstShipperNameChange')" />
                                            <asp:RequiredFieldValidator ID="rfvShipper" runat="server" ControlToValidate="lstShipperName"
                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                </table>
                                <!-- End JPED -->
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align: top">
                                <table cellpadding="2" cellspacing="0" border="0" class="bodycopy" id="tblShipper">
                                    <tr>
                                        <td>
                                            Tax ID
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD0_2" CssClass="shorttextfield" MaxLength="11" Width="90px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Address 1
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD0_4" CssClass="shorttextfield" MaxLength="32" Width="220px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Address 2
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD0_5" CssClass="shorttextfield" MaxLength="32" Width="220px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            City
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD0_6" CssClass="shorttextfield" MaxLength="25" Width="180px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            State
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD0_7" CssClass="shorttextfield" MaxLength="2" Width="25px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Zip Code
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD0_8" CssClass="shorttextfield" MaxLength="9" Width="70px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Contact Name
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD0_9" CssClass="shorttextfield" MaxLength="13" Width="100px" />
                                            <asp:TextBox runat="server" ID="AD0_10" CssClass="shorttextfield" MaxLength="1" Width="15px" />
                                            <asp:TextBox runat="server" ID="AD0_11" CssClass="shorttextfield" MaxLength="20"
                                                Width="150px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Phone No
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD0_12" CssClass="shorttextfield" MaxLength="9" Width="70px" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="vertical-align: top">
                                <asp:HiddenField ID="AD3_2" runat="server" />
                                <table cellpadding="2" cellspacing="0" border="0" class="bodycopy" id="tblAgent">
                                    <tr>
                                        <td style="width: 80px">
                                            DBA
                                        </td>
                                        <td>
                                            <asp:Label ID="AD3_3" runat="server" CssClass="bodycopy" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Tax ID
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="AD3_4" CssClass="bodycopy"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Address 1
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="AD3_8" CssClass="bodycopy" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Address 2
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="AD3_9" CssClass="bodycopy" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            City
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="AD3_10" CssClass="bodycopy" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            State
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="AD3_11" CssClass="bodycopy" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Zip Code
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="AD3_13" CssClass="bodycopy" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Country
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="AD3_12" CssClass="bodycopy" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Contact Name
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="AD3_5" CssClass="bodycopy" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Contact Phone
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="AD3_7" CssClass="bodycopy" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="height: 1px; background-color: #a0829c">
                <td style="padding: 0">
                </td>
            </tr>
            <tr style="background-color: #f0e7ef">
                <td>
                    <strong>Consignee(s)</strong>
                </td>
            </tr>
            <tr style="height: 1px; background-color: #a0829c">
                <td style="padding: 0">
                </td>
            </tr>
            <tr>
                <td>
                    <table cellpadding="2" cellspacing="0" border="0" style="width: 100%" class="bodycopy">
                        <tr>
                            <td style="width: 50%">
                                <strong>
                                    <img src="/ASP/images/required.gif" align="absbottom" alt="" />Ultimate Consignee</strong>
                            </td>
                            <td style="width: 50%">
                                <strong>Intermediate Consignee</strong>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <!-- Start JPED -->
                                <asp:HiddenField runat="server" ID="hConsigneeAcct" Value="0" />
                                <asp:HiddenField runat="server" ID="AD1_3" />
                                <div id="lstConsigneeNameDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <asp:TextBox runat="server" autocomplete="off" ID="lstConsigneeName" Width="280px"
                                                Text="" CssClass="shorttextfield" Style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange',null,event)"
                                                onfocus="initializeJPEDField(this,event);" />
                                        </td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange')"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" />
                                        </td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="Edit company" style="cursor: hand"
                                                onclick="quickAddClientNew('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo','lstConsigneeNameChange')" />
                                            <asp:RequiredFieldValidator ID="rfvConsignee" runat="server" ControlToValidate="lstConsigneeName"
                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                </table>
                                <!-- End JPED -->
                            </td>
                            <td>
                                <!-- Start JPED -->
                                <asp:HiddenField runat="server" ID="hInterConsigneeAcct" Value="0" />
                                <asp:HiddenField runat="server" ID="AD4_3" />
                                <div id="lstInterConsigneeNameDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <asp:TextBox runat="server" autocomplete="off" ID="lstInterConsigneeName" Width="280px"
                                                Text="" CssClass="shorttextfield" Style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Consignee','lstInterConsigneeNameChange',null,event)"
                                                onfocus="initializeJPEDField(this,event);" />
                                        </td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstInterConsigneeName','Consignee','lstInterConsigneeNameChange')"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" />
                                        </td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="Edit company" style="cursor: hand"
                                                onclick="quickAddClientNew('hInterConsigneeAcct','lstInterConsigneeName','txtInterConsigneeInfo','lstInterConsigneeNameChange')" />
                                        </td>
                                    </tr>
                                </table>
                                <!-- End JPED -->
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align: top">
                                <table cellpadding="2" cellspacing="0" border="0" class="bodycopy" id="tblConsignee">
                                    <tr>
                                        <td>
                                            Address 1
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD1_8" CssClass="shorttextfield" MaxLength="32" Width="220px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Address 2
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD1_9" CssClass="shorttextfield" MaxLength="32" Width="220px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            City
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD1_10" CssClass="shorttextfield" MaxLength="25"
                                                Width="180px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            State
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD1_11" CssClass="shorttextfield" MaxLength="2" Width="25px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Country
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD1_12" CssClass="shorttextfield" MaxLength="2" Width="25px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Postal Code
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD1_13" CssClass="shorttextfield" MaxLength="9" Width="70px" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="vertical-align: top">
                                <table cellpadding="2" cellspacing="0" border="0" class="bodycopy" id="tblInterConsignee">
                                    <tr>
                                        <td>
                                            Address 1
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD4_8" CssClass="shorttextfield" MaxLength="32" Width="220px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Address 2
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD4_9" CssClass="shorttextfield" MaxLength="32" Width="220px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            City
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD4_10" CssClass="shorttextfield" MaxLength="25"
                                                Width="180px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            State
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD4_11" CssClass="shorttextfield" MaxLength="2" Width="25px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Country
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD4_12" CssClass="shorttextfield" MaxLength="2" Width="25px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Postal Code
                                        </td>
                                        <td>
                                            <asp:TextBox runat="server" ID="AD4_13" CssClass="shorttextfield" MaxLength="9" Width="70px" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="height: 1px; background-color: #a0829c">
                <td style="padding: 0">
                </td>
            </tr>
            <tr style="background-color: #f0e7ef">
                <td>
                    <strong>Line Items</strong>
                </td>
            </tr>
            <tr style="height: 1px; background-color: #a0829c">
                <td style="padding: 0">
                </td>
            </tr>
            <tr>
                <td>
                    <div>
                        <dx:ASPxGridView ID="gridBatchAES" ClientInstanceName="gridBatchAES" runat="server" 
                            DataSourceID="ObjectDataSourceAES" KeyFieldName="ID" Width="100%" 
                            EnableRowsCache="False" AutoGenerateColumns="False" 
                            onrowvalidating="gridBatchAES_RowValidating">
                            <Columns>
                                <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowDeleteButton="True" ShowEditButton="True"
                                    ShowUpdateButton="false" ShowCancelButton="false" />
                                <dx:GridViewDataComboBoxColumn FieldName="Origin" Caption="Origin">
                                    <PropertiesComboBox ValueType="System.String" >
                                        <Items>
                                            <dx:ListEditItem Text="" Value="" />
                                            <dx:ListEditItem Text="Domestic" Value="D" />
                                            <dx:ListEditItem Text="Foreign" Value="F" />
                                            <dx:ListEditItem Text="FMS" Value="M" />
                                        </Items>
                                    </PropertiesComboBox>
                                </dx:GridViewDataComboBoxColumn>

                                <dx:GridViewDataComboBoxColumn FieldName="ItemDesc" Caption="Item" >
                                    <PropertiesComboBox DataSourceID="ComboBoxDataSourceScheduleB" ValueType="System.String"
                                         ClientSideEvents-SelectedIndexChanged="onComboBoxSelectedIndexChanged" ValueField="sb"
                                        TextField="description" >
<ClientSideEvents SelectedIndexChanged="onComboBoxSelectedIndexChanged"></ClientSideEvents>
                                    </PropertiesComboBox>
                                </dx:GridViewDataComboBoxColumn>

                                 <dx:GridViewDataTextColumn FieldName="ScheduleB" 
                                    PropertiesTextEdit-ClientInstanceName="txtScheduleB"    ReadOnly="true"  
                                    Caption="Schedule B" >

<PropertiesTextEdit ClientInstanceName="txtScheduleB"></PropertiesTextEdit>
                                </dx:GridViewDataTextColumn>

                                <dx:GridViewDataSpinEditColumn FieldName="Qty1" Caption="Qty 1" PropertiesSpinEdit-ClientInstanceName="spinQty1">
                                    <PropertiesSpinEdit MinValue="0" MaxValue="1000000" />
                                </dx:GridViewDataSpinEditColumn>

                                 <dx:GridViewDataComboBoxColumn FieldName="Unit1" Caption="Unit 1" PropertiesComboBox-ClientInstanceName ="comboUnit1">
                                    <PropertiesComboBox DataSourceID="ComboBoxDataSourceUnit1" 
                                         ValueType="System.String" 
                                        ValueField="code_id"
                                        TextField="code_desc"  ClientSideEvents-SelectedIndexChanged="onComboBoxSelectedIndexChanged2"  >

                                     </PropertiesComboBox>
                                </dx:GridViewDataComboBoxColumn>

                                <dx:GridViewDataSpinEditColumn FieldName="Qty2" Caption="Qty 2">
                                    <PropertiesSpinEdit MinValue="0" MaxValue="1000000" />
                                </dx:GridViewDataSpinEditColumn>
                                
                                <dx:GridViewDataComboBoxColumn FieldName="Unit2" Caption="Unit 2" PropertiesComboBox-ClientInstanceName ="comboUnit2">
                                    <PropertiesComboBox DataSourceID="ComboBoxDataSourceUnit2" ValueType="System.String" 
                                        ValueField="code_id"
                                        TextField="code_desc" />
                                </dx:GridViewDataComboBoxColumn>

                                <dx:GridViewDataTextColumn FieldName="GrossWeight" Caption="Gross Weight(KG)" />
                                <dx:GridViewDataTextColumn FieldName="ItemValue" Caption="Item Value(USD)" />
                                <dx:GridViewDataComboBoxColumn FieldName="ExportCode" Caption="Export Code" PropertiesComboBox-ClientInstanceName ="comboExportCode">
                                    <PropertiesComboBox DataSourceID="ComboBoxDataSourceExportCode" ValueType="System.String" ClientSideEvents-SelectedIndexChanged="onComboBoxSelectedIndexChanged3"
                                         ValueField="code_id"
                                        TextField="code_id" />
                                </dx:GridViewDataComboBoxColumn>
                                  <dx:GridViewDataComboBoxColumn FieldName="LicenseType" Caption="License Type" PropertiesComboBox-ClientInstanceName ="comboLicenseType">
                                    <PropertiesComboBox DataSourceID="ComboBoxDataSourceLicenseType" ValueType="System.String"
                                        ValueField="code_id"
                                        TextField="code_id" />
                                </dx:GridViewDataComboBoxColumn>
                                <dx:GridViewDataTextColumn FieldName="LicenseNumber" Caption="License Number" />
                                <dx:GridViewDataTextColumn FieldName="ECCN" Caption="ECCN"  
                                    PropertiesTextEdit-ClientInstanceName="txtECCN" >
<PropertiesTextEdit ClientInstanceName="txtECCN"></PropertiesTextEdit>
                                </dx:GridViewDataTextColumn>
                                 <dx:GridViewDataComboBoxColumn FieldName="VehicleIDType" Caption="Vehicle ID Type">
                                    <PropertiesComboBox ValueType="System.String"
                                       >
                                        <Items>
                                            <dx:ListEditItem Text="" Value="" />
                                            <dx:ListEditItem Text="VIN" Value="V" />
                                            <dx:ListEditItem Text="Product ID" Value="P" />
                                        </Items>
                                        </PropertiesComboBox>
                                </dx:GridViewDataComboBoxColumn>
                                <dx:GridViewDataTextColumn FieldName="VehicleID" Caption="Vehicle ID" />
                                <dx:GridViewDataTextColumn FieldName="VehicleTitle" Caption="Vehicle Title" />                               
                                <dx:GridViewDataComboBoxColumn FieldName="VihicleState" Caption="Vehicle State">
                                    <PropertiesComboBox DataSourceID="ComboBoxDataSourceVeicleState" ValueType="System.String"
                                         ValueField="Code"
                                        TextField="Name" />
                                </dx:GridViewDataComboBoxColumn>
                            </Columns>
                            <SettingsEditing Mode="EditFormAndDisplayRow" />
                        </dx:ASPxGridView>
                        <asp:ObjectDataSource ID="ObjectDataSourceAES" TypeName="ELT.BL.AESManager" DataObjectTypeName="ELT.CDT.AESLineItem"
                            SelectMethod="GetAESLineItems" DeleteMethod="DeleteAESLineItem" UpdateMethod="UpdateAESLineItem"
                            InsertMethod="InsertAESLineItem" runat="server">
                            <SelectParameters>
                                <asp:Parameter Name="AesID" Type="Int32" />
                                <asp:Parameter Name="MAWB" Type="String" />
                                <asp:Parameter Name="HAWB" Type="String" />
                                <asp:Parameter Name="FileType" Type="String"  DefaultValue="AE"/>
                            </SelectParameters>
                            
                           
                        </asp:ObjectDataSource>
                        
                        <asp:SqlDataSource ID="ComboBoxDataSourceScheduleB" runat="server" 
                            oninit="ComboBoxDataSourceScheduleB_Init"></asp:SqlDataSource>
                        <asp:SqlDataSource ID="ComboBoxDataSourceUnit1" runat="server" 
                            oninit="ComboBoxDataSourceUnit1_Init"></asp:SqlDataSource>
                        <asp:SqlDataSource ID="ComboBoxDataSourceUnit2" runat="server" 
                            oninit="ComboBoxDataSourceUnit2_Init"></asp:SqlDataSource>
                        <asp:SqlDataSource ID="ComboBoxDataSourceExportCode" runat="server" 
                            oninit="ComboBoxDataSourceExportCode_Init"></asp:SqlDataSource>
                        <asp:SqlDataSource ID="ComboBoxDataSourceLicenseType" runat="server" 
                            oninit="ComboBoxDataSourceLicenseType_Init"></asp:SqlDataSource>
                        <asp:SqlDataSource ID="ComboBoxDataSourceVeicleState" runat="server" 
                            oninit="ComboBoxDataSourceVeicleState_Init"></asp:SqlDataSource>
                    </div>
                </td>
            </tr>
            <tr style="height: 1px; background-color: #a0829c">
                <td style="padding: 0">
                </td>
            </tr>
            <tr>
                <td style="text-align: center; background-color: #E5D4E3">
                    <asp:ImageButton runat="server" ImageUrl="../../Images/button_save.gif" ID="btnSaveAESBot"
                         OnClientClick="UpdateItems()" />
                </td>
            </tr>
        </table>
    </center>
   
    </form>
    <br />
</body>
<script type="text/javascript">
    makeAllReadOnlyStyle(document.getElementById("tblShipper"));
    makeAllReadOnlyStyle(document.getElementById("tblConsignee"));
    makeAllReadOnlyStyle(document.getElementById("tblInterConsignee"));
</script>
<script language="JavaScript" type="text/javascript" src="/ASP/Include/tooltips.js"></script>
<script type="text/javascript">
    $(document).ready(function () {

        $("#EDA").datepicker();

    });
    function onComboBoxSelectedIndexChanged2(s, e) {
        if (s.GetValue() == "X") {
            
            spinQty1.SetValue(0);
        }
    }
    function onComboBoxSelectedIndexChanged3(s, e) {
        if (s.GetValue() == "HH") {         
            comboUnit1.SetValue("X");
            spinQty1.SetValue(0);
        }
    }
    function onComboBoxSelectedIndexChanged(s, e) {
        txtScheduleB.SetValue(s.GetValue());
        var URL = "/AirExport/GetScheduleB?description=" + s.GetText();
        $.ajax({
            url: URL,
            type: "GET",
            success: function (data, textStatus, jqXHR) {
                comboUnit1.SetValue(data.sb_unit1);
                comboUnit2.SetValue(data.sb_unit2);
                comboExportCode.SetValue(data.export_code);
                comboLicenseType.SetValue(data.license_type);
                txtECCN.SetValue(data.eccn);
               	
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(errorThrown);
            }
        });
    }

</script>
</html>
