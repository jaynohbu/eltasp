<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OceanExportSearch.aspx.cs"
    Inherits="ASPX_Search_OceanExportSearch" %>

<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport" TagPrefix="cc1" %>
<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>

<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Search</title>
    <script src="/IFF_MAIN/ASPX/jScripts/ig_editDrop1.js" type="text/javascript"></script>
    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
    <link href="../CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <script src="/ASP/ajaxFunctions/ajax.js" type="text/javascript"></script>
    <script src="/ASP/Include/JPED.js" type="text/javascript"></script>
    <script src="/ASP/Include/JPTableDOM.js" type="text/javascript"></script>
    <script type="text/javascript">
    
        function openWindowFromSearch(url){
            window.open(url, "popUpWindow", "menubar=0,toolbar=0,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600");
        }
    
        function lstShipperNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hShipperAcct");
            var txtObj = document.getElementById("lstShipperName");
            var divObj = document.getElementById("lstShipperNameDiv")
    
            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
        
        function lstCarrierNameChange(orgNum,orgName){
	        var c_hiddenObj = document.getElementById("hCarrierAcct");
	        var c_txtObj = document.getElementById("lstCarrierName");
	        var c_divObj = document.getElementById("lstCarrierNameDiv");
        	
	        c_hiddenObj.value = orgNum;
	        c_txtObj.value = orgName;
	        c_divObj.style.position = "absolute";
	        c_divObj.style.visibility = "hidden";
	    }
        
        function lstAgentNameChange(ANum,AName){
		    var AhiddenObj = document.getElementById("hAgentAcct");
		    var AtxtObj = document.getElementById("lstAgentName");
		    var AdivObj = document.getElementById("lstAgentNameDiv");
		
		    AhiddenObj.value = ANum;
		    AtxtObj.value = AName;
		    AdivObj.style.position = "absolute";
		    AdivObj.style.visibility = "hidden";
	    }
	    
        function lstConsigneeNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hConsigneeAcct");
            var txtObj = document.getElementById("lstConsigneeName");
            var divObj = document.getElementById("lstConsigneeNameDiv");
                    
            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
		    divObj.innerHTML = "";
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            url = "/ASP/ajaxFunctions/ajax_get_international_mawb_list.asp?mode=OEM";
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
       
        function lstSearchNumChange(argV,argL){
            var divObj = document.getElementById("lstSearchNumDiv");
		    var hiddenObj = document.getElementById("hSearchNum");
		    var txtObj = document.getElementById("lstSearchNum");	
            hiddenObj.value = argV;
		    txtObj.value = argL;	    
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
        }
        
        function lstBookingNumChange(argV,argL){
            var divObj = document.getElementById("lstBookingNumDiv");
		    var hiddenObj = document.getElementById("hBookingNum");
		    var txtObj = document.getElementById("lstBookingNum");	
            hiddenObj.value = argV;
		    txtObj.value = argL;	    
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
        }
        
        function BookingNumFill(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/ASP/ajaxFunctions/ajax_get_international_mawb_list.asp?mode=OEB&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function BookingNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            url = "/ASP/ajaxFunctions/ajax_get_international_mawb_list.asp?mode=OEB";
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        
        function EditClick(BookingNo){
            url ="/ASP/Ocean_export/new_edit_mbol.asp?Edit=yes&BookingNum=" + encodeURIComponent(BookingNo) + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
        }
        
        function EditBookClick(BookingNo){
            url ="/ASP/Ocean_export/Booking.asp?Edit=yes&BookingNum=" + encodeURIComponent(BookingNo) + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
        }
			
        function EditClickName(org_No){
           url ="/ASP/master_data/client_profile.asp?Action=filter&n="+ encodeURIComponent(org_No) + "&WindowName=popUpWindow";
           openWindowFromSearch(url);
		}
		
        function EditClickHAWB(HAWB){
            url ="/ASP/Ocean_export/new_edit_hbol.asp?Edit=yes&hbol=" + encodeURIComponent(HAWB) + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
        }

        function EditClickFILE(FILENO){
            url ="/ASP/Ocean_export/booking.asp?Edit=yes&FILENO=" + encodeURIComponent(FILENO) + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
        }
        
        function lstSearchType_Change(){

            if(document.getElementById("lstSearchType").value == "house"){
                document.getElementById("MasterFilter").style.position = "absolute";
                document.getElementById("MasterFilter").style.visibility = "hidden";
                document.getElementById("HouseFilter").style.position = "static";
                document.getElementById("HouseFilter").style.visibility = "visible";
            }
            if(document.getElementById("lstSearchType").value == "master"){
                document.getElementById("MasterFilter").style.position = "static";
                document.getElementById("MasterFilter").style.visibility = "visible";
                document.getElementById("HouseFilter").style.position = "absolute";
                document.getElementById("HouseFilter").style.visibility = "hidden";
            }
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

    <!--  #INCLUDE FILE="../include/common.htm" -->
</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
        <div align="center">
            <table cellpadding="0" cellspacing="0" border="0" style="width: 95%">
                <tr>
                    <td class="pageheader" style="text-align: left">
                        Search
                    </td>
                    <td>
                    </td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="0" border="0" style="width: 95%; border-color: #6D8C80"
                class="border1px">
                <tr>
                    <td style="height: 8px; background-color: #BFD0C9">
                    </td>
                </tr>
                <tr>
                    <td style="height: 1px; background-color: #6D8C80">
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
                                        <asp:ListItem Text="House B/L No." Value="house" />
                                        <asp:ListItem Text="Booking No." Value="master" />
                                    </asp:DropDownList>
                                </td>
                                <td>
                               <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="ddlPeriod" />                                </td>
                                <td colspan="2">
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                 <asp:TextBox runat="server" ID="Webdatetimeedit1"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <asp:TextBox runat="server" ID="Webdatetimeedit2"></asp:TextBox>
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
                                    Booking No.</td>
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <asp:HiddenField ID="hBookingNum" runat="server" Value="" />
                                                <div id="lstBookingNumDiv">
                                                </div>
                                                <asp:TextBox ID="lstBookingNum" runat="server" autocomplete="off" class="shorttextfield"
                                                    Style="width: 200px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: Black"
                                                    onkeyup=" BookingNumFill(this,'lstBookingNumChange','');" onfocus="initializeJPEDField(this,event);"></asp:TextBox></td>
                                            <td style="width: 16px">
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="BookingNumFillAll('lstBookingNum','lstBookingNumChange',200);"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                </td>
                            </tr>
                            <tr class="bodyheader">
                                <td>
                                    Master No.</td>
                                <td>
                                    File No.</td>
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
                                                    Style="width: 200px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: Black"
                                                    onkeyup=" searchNumFill(this,'lstSearchNumChange','');" onfocus="initializeJPEDField(this,event);"></asp:TextBox></td>
                                            <td style="width: 16px">
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtFileNo" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                            </tr>
                            <tr class="bodyheader">
                                <td>
                                    Departure Port</td>
                                <td>
                                    Destination Port</td>
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
                                    Shipper</td>
                                <td>
                                    Consignee</td>
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
                                                    color: #000000" onKeyUp="organizationFill(this,'Shipper','lstShipperNameChange')"
                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','shipper','lstShipperNameChange')"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
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
                                                    color: #000000" onKeyUp="organizationFill(this,'Consignee','lstConsigneeNameChange')"
                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                            <td style="height: 18px">
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange')"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                            <td style="height: 18px">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                        <tr class="bodyheader">
                                            <td>
                                                Vessel Name</td>
                                            <td style="width: 4px">
                                            </td>
                                            <td>
                                                Number of Pieces
                                            </td>
                                            <td style="width: 4px">
                                            </td>
                                            <td>
                                                Gross Weight</td>
                                            <td style="width: 4px">
                                            </td>
                                            <td>
                                                Dimension(CBM)
                                            </td>
                                            <td style="width: 4px">
                                            </td>
                                            <td>
                                                Salse Person</td>
                                        </tr>
                                        <tr style="height: 4px">
                                            <td>
                                            </td>
                                        </tr>
                                        <tr class="bodyheader">
                                            <td>
                                                <asp:TextBox ID="VesselName" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                                            <td style="width: 4px">
                                            </td>
                                            <td>
                                                <asp:TextBox ID="NoPiece" runat="server" CssClass="m_shorttextfield" Width="90px"
                                                    Style="behavior: url(/ASP/include/igNumDotChkLeft.htc)"></asp:TextBox>
                                            </td>
                                            <td>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="TxtWeight" runat="server" CssClass="m_shorttextfield" Width="70px"
                                                    Style="behavior: url(/ASP/include/igNumDotChkLeft.htc)"></asp:TextBox>
                                                <asp:DropDownList CssClass="bodycopy" Width="40px" runat="server" ID="WeightSelect"
                                                    AutoPostBack="false">
                                                    <asp:ListItem Text="KG" Value="KG" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Text="LB" Value="LB"></asp:ListItem>
                                                </asp:DropDownList></td>
                                            <td>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="TxtCBM" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                            </td>
                                            <td>
                                            </td>
                                            <td>
                                                <asp:DropDownList CssClass="bodycopy" Width="150px" runat="server" ID="SaleDroplist" /></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <br />
                        <asp:Panel runat="server" ID="HouseFilter">
                            <table cellpadding="2" cellspacing="2" border="0" style="width: 700px; text-align: left;
                                background-color: #eeeeee; border: solid 1px #aaaaaa">
                                <tr class="bodyheader">
                                    <td>
                                        House AWB No.</td>
                                    <td>
                                        Type of House</td>
                                    <td colspan="2">
                                        Agent</td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox ID="txtHouseNo" runat="server" CssClass="shorttextfield" Width="150px" /></td>
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
                                                        color: #000000" onKeyUp="organizationFill(this,'Agent','lstAgentNameChange')"
                                                        onfocus="initializeJPEDField(this,event);" /></td>
                                                <td>
                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstAgentName','Agent','lstAgentNameChange')"
                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                            </tr>
                                        </table>
                                        <!-- End JPED -->
                                    </td>
                                </tr>
                                <tr class="bodyheader">
                                    <td>
                                        LC No.</td>
                                    <td>
                                        CI No.</td>
                                    <td>
                                        Other Reference No.</td>
                                    <td>
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
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel runat="server" ID="MasterFilter">
                            <table cellpadding="2" cellspacing="2" border="0" style="width: 700px; text-align: left;
                                background-color: #eeeeee; border: solid 1px #aaaaaa">
                                <tr class="bodyheader">
                                    <td>
                                        Type of Shipment</td>
                                    <td>
                                        Master AWB Status</td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:RadioButtonList runat="server" ID="lstShipmentType" CssClass="bodycopy" RepeatDirection="Horizontal">
                                            <asp:ListItem Text="Direct" Value="Direct"></asp:ListItem>
                                            <asp:ListItem Text="Consol" Value="Consol"></asp:ListItem>
                                            <asp:ListItem Text="All" Value="All" Selected="True"></asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <td>
                                        <asp:RadioButtonList runat="server" ID="lstMasterStatus" CssClass="bodycopy" RepeatDirection="Horizontal">
                                            <asp:ListItem Text="Closed" Value="Closed"></asp:ListItem>
                                            <asp:ListItem Text="Used" Value="Used"></asp:ListItem>
                                            <asp:ListItem Text="All" Value="All" Selected="True"></asp:ListItem>
                                        </asp:RadioButtonList></td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <table cellpadding="2" cellspacing="2" border="0" style="width: 700px; text-align: left">
                            <tr>
                                <td colspan="5" style="text-align: right">
                                    <asp:ImageButton runat="server" ImageUrl="../../Images/button_go.gif" ID="btnGo"
                                        OnClick="btnGo_Click" /></td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" border="0" style="width: 98%; text-align: left">
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="txtResultBox" CssClass="bodycopy" /></td>
                                <td style="text-align: right">
                                    <asp:ImageButton ID="btnExcelExport" runat="server" ImageUrl="/ASP/images/button_exel.gif"
                                        OnClick="btnExcelExport_Click" Visible="false" /></td>
                            </tr>
                        </table>
                        <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Width="95%" OnInitializeLayout="UltraWebGrid1_InitializeLayout"
                            OnInitializeRow="UltraWebGrid1_InitializeRow">
                            <Bands>
                                <igtbl:UltraGridBand>
                                    <FilterOptions EmptyString="" AllString="" NonEmptyString="">
                                        <FilterDropDownStyle BorderWidth="1px" BorderColor="Silver" BorderStyle="Solid" BackColor="White"
                                            Width="200px" CssClass="bodycopy" />
                                        <FilterHighlightRowStyle ForeColor="White" BackColor="#151C55" CssClass="bodycopy" />
                                    </FilterOptions>
                                </igtbl:UltraGridBand>
                            </Bands>
                            <DisplayLayout Name="UltraWebGrid1" BorderCollapseDefault="Separate" RowHeightDefault="20px"
                                SelectTypeRowDefault="None" RowSizingDefault="Free" ViewType="OutlookGroupBy"
                                SelectTypeCellDefault="None" SelectTypeColDefault="None" EnableInternalRowsManagement="True"
                                AllowSortingDefault="Yes" HeaderClickActionDefault="SortSingle" RowSelectorsDefault="No"
                                Version="4.00" TableLayout="Fixed" AllowColSizingDefault="Free" ScrollBarView="Horizontal">
                                <FrameStyle BorderWidth="1px" BorderStyle="Solid" Width="98%" BorderColor="#aaaaaa"
                                    TextOverflow="Ellipsis">
                                </FrameStyle>
                                <GroupByBox Hidden="true">
                                    <Style BorderColor="Window" BackColor="#cccccc" CssClass="bodycopy" Height="25px"></Style>
                                </GroupByBox>
                                <FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray" CssClass="bodycopy">
                                    <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
                                </FooterStyleDefault>
                                <RowStyleDefault Font-Names="Verdana,Arial,Helvetica,Sans-serif" Font-Size="9px"
                                    BorderWidth="1px" BorderColor="#bcbcbc" BorderStyle="Solid" BackColor="Window"
                                    TextOverflow="Ellipsis">
                                    <BorderDetails ColorTop="Window" ColorLeft="Window"></BorderDetails>
                                    <Padding Left="3px"></Padding>
                                </RowStyleDefault>
                                <FilterOptionsDefault EmptyString="(Empty)" AllString="(All)" NonEmptyString="(NonEmpty)">
                                    <FilterDropDownStyle BorderWidth="1px" BorderColor="Silver" BorderStyle="Solid" BackColor="White"
                                        Width="200px">
                                    </FilterDropDownStyle>
                                    <FilterHighlightRowStyle ForeColor="White" BackColor="#151C55">
                                    </FilterHighlightRowStyle>
                                </FilterOptionsDefault>
                                <HeaderStyleDefault HorizontalAlign="Left" BorderStyle="Solid" BackColor="#dddddd"
                                    ForeColor="Black" Height="19px" Cursor="Hand">
                                </HeaderStyleDefault>
                                <EditCellStyleDefault BorderWidth="0px" BorderStyle="None">
                                </EditCellStyleDefault>
                                <Pager AllowPaging="True" StyleMode="PrevNext" PageSize="100" Alignment="Center" PagerAppearance="Both">
                                    <Style BorderWidth="3px" BorderStyle="Solid" BackColor="#eeeeee" BorderColor="#eeeeee"
                                        CssClass="bodycopy" Height="25px" />
                                </Pager>
                            </DisplayLayout>
                        </igtbl:UltraWebGrid>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td style="height: 1px; background-color: #6D8C80">
                    </td>
                </tr>
                <tr>
                    <td style="height: 25px; background-color: #BFD0C9">
                    </td>
                </tr>
            </table>
        </div>
        <cc1:UltraWebGridExcelExporter ID="UltraWebGridExcelExporter1" runat="server">
        </cc1:UltraWebGridExcelExporter>
        <br />
        <br />
        <br />
        <div>
            
        </div>
    </form>
</body>

<script type="text/javascript">
        
        lstSearchType_Change();
</script>

<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
