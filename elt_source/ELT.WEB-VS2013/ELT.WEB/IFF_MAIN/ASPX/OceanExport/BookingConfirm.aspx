<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BookingConfirm.aspx.cs" Inherits="ASPX_OceanExport_BookingConfirm" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Booking Confirmation</title>
    <style type="text/css">
		.style6 {
			color: #09609F
		}
		.style8 {	
			color: #cc6600;
			font-weight: bold;
		}
		.style9 {
			color: #cc6600
		}
		body {
			margin-left: 0px;
			margin-right: 0px;
			margin-bottom: 0px;
		}
		.statement {	line-height: 15px;
		}
		.read, .write {
			background:#dddddd;
			border-top-width: 1px;
			border-right-width: 1px;
			border-bottom-width: 1px;
			border-left-width: 1px;
			border-top-style: solid;
			border-right-style: solid;
			border-bottom-style: solid;
			border-left-style: solid;
			border-top-color: #666666;
			border-right-color: #cccccc;
			border-bottom-color: #cccccc;
			border-left-color: #666666;
			height: 16px;
			font-family:Verdana, Arial, Helvetica, sans-serif;	
			font-size:9px;
		}
		.write {
			background:#ffffff;			
		}
    </style>
    <link rel="stylesheet" type="text/css" href="/IFF_MAIN/ASPX/CSS/elt_css.css" />

    <script type="text/javascript" language="javascript" src="/ASP/include/JPED.js"></script>

    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript">
        function no_prefix_alert()
        {
            alert("Please, add a booking confirmation prefix before accessing booking confirmation");
            window.location.href = "/ASP/site_admin/prefix_manager.asp";
        }
        
        function searchNumFill(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/ASP/ajaxFunctions/ajax_booking_confirm.asp?mode=list&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            url = "/ASP/ajaxFunctions/ajax_booking_confirm.asp?mode=list&qStr=";
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        
        function lstSearchNumChange(argV,argL){
            var divObj = document.getElementById("lstSearchNumDiv");
	        divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
		    if(argV > 0)
		    {
		        window.location.href="BookingConfirm.aspx?UID=" + argV;
		    }
        }
        
        function lstBillNumChange(argV,argL){
            var divObj = document.getElementById("lstBillNumDiv");
	        divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
		    
		    if(argV != "0")
		    {
		        if(confirm("Please, click OK to load values from bill."))
		        {
		            document.getElementById("hBillNum").value = argV;
		            document.getElementById("lstBillNum").value = argV;
		            __doPostBack("btn_load_bill_info", null);
		        }
		    }
        }
        
        function lstShipperNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hShipperAcct");
            var infoObj = document.getElementById("txtShipperInfo");
            var txtObj = document.getElementById("lstShipperName");
            var divObj = document.getElementById("lstShipperNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum, "B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
        
        function lstConsigneeNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hConsigneeAcct");
            var infoObj = document.getElementById("txtConsigneeInfo");
            var txtObj = document.getElementById("lstConsigneeName");
            var divObj = document.getElementById("lstConsigneeNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum, "B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
        
        function lstAgentNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hAgentAcct");
            var infoObj = document.getElementById("txtAgentInfo");
            var txtObj = document.getElementById("lstAgentName");
            var divObj = document.getElementById("lstAgentNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum, "B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
        
        function lstEmptyPickupNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hEmptyPickupAcct");
            var infoObj = document.getElementById("txtEmptyPickupInfo");
            var txtObj = document.getElementById("lstEmptyPickupName");
            var divObj = document.getElementById("lstEmptyPickupNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum, "B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
        
        function lstCarrierNameChange(orgNum,orgName){
	        var hiddenObj = document.getElementById("hCarrierAcct");
	        var txtObj = document.getElementById("lstCarrierName");
	        var divObj = document.getElementById("lstCarrierNameDiv");
        	
	        hiddenObj.value = orgNum;
	        txtObj.value = orgName;
	        divObj.style.position = "absolute";
	        divObj.style.visibility = "hidden";
	    }
	    
	    function BillNumFill(obj,eType,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	        var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/ASP/ajaxFunctions/ajax_certificate_origin.asp?mode=list&export=" + eType 
                    + "&qStr=" + qStr + "&type=" + typeValue;

                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function BillNumFillAll(objName,eType,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            var typeIndex = document.getElementById("lstSearchType").selectedIndex;
	        var typeValue = document.getElementById("lstSearchType").options[typeIndex].value;
	        
            var url = "/ASP/ajaxFunctions/ajax_certificate_origin.asp?mode=list&type=" + typeValue 
                + "&export=" + eType;

            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        
        function lstSearchTypeChange()
        {
            document.getElementById("hBillNum").value = "";
            document.getElementById("lstBillNum").value = "";
        }
        
	    function getOrganizationInfo(orgNum,infoFormat){
            if (window.ActiveXObject) {
                try {
                    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
                } catch(error) {
                    try {
                        xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch(error) { return ""; }
                }
            } 
            else if (window.XMLHttpRequest) {
                xmlHTTP = new XMLHttpRequest();
            } 
            else { return ""; }

            var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=" + infoFormat + "&org=" + encodeURIComponent(orgNum);
        
            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send();
            
            return xmlHTTP.responseText; 
        }
	    
	    function confirm_delete()
	    {
	        if(document.getElementById("hSearchNum").value == "" || document.getElementById("hSearchNum").value == "0")
	        {
	            return false;
	        }
            var ans = confirm("Please, click OK to delete this booking confirmation.");
            if(!ans)
            {
                return false;
            }
	    }
	    
		function viewPDF(arg)
		{
			var url = "/ASP/ocean_export/booking_confirm_pdf.asp?uid=" + arg;
			setTimeout(function(){showPDF(url)}, 1000);
		}
		
		function showPDF(url)
		{
		    newWindow = window.open(url, 'newWindow', 'menubar=1,toolbar=1,height=600,width=800,hotkeys=0,scrollbars=1,resizable=1');
		}
    </script>

    <!--  #INCLUDE FILE="../include/common.htm" -->
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hf_booking_no" runat="server" />
        <asp:HiddenField ID="hf_master_no" runat="server" />
        <asp:HiddenField ID="hf_house_no" runat="server" />
        <asp:HiddenField ID="hf_sub_house_no" runat="server" />
        <div>
            <center>
                <table style="width: 95%; text-align: left; border: none 0px" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="left" valign="middle" class="pageheader" style="width: 50%">
                            BOOKING CONFIRMATION
                        </td>
                        <td align="right" valign="middle" style="width: 50%">
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <div class="selectarea">
                    <table style="width: 95%; text-align: left; border: none 0px" cellpadding="0" cellspacing="0">
                        <tr>
                            <td valign="bottom">
                                <div style="margin-bottom: 5px">
                                    <span class="select">Select Booking Confirmation No.</span>
                                </div>
                                <div>
                                    <!-- Start JPED -->
                                    <asp:HiddenField runat="Server" ID="hSearchNum" />
                                    <div id="lstSearchNumDiv">
                                    </div>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <asp:TextBox runat="server" AutoCompleteType="None" ID="lstSearchNum" CssClass="shorttextfield"
                                                    Style="width: 150px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="searchNumFill(this,'lstSearchNumChange',200);"
                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                            <td align="right" valign="bottom">
                                <div id="print">
                                    <asp:ImageButton ID="btn_print" runat="server" OnClick="btn_print_Click" ImageUrl="/ASP/Images/icon_printer.gif" />
                                    <asp:LinkButton ID="lnk_btn_print" runat="server" OnClick="btn_print_Click" Text="Booking Confirmation Form" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <table width="95%" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: solid 1px #6D8C80">
                                            <tr>
                                                <td style="background-color: #BFD0C9; height: 24px" align="center" valign="middle"
                                                    class="bodyheader">
                                                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td style="width: 26%" valign="middle" align="left">
                                                                <span id="spn_prefix_select" runat="server">Prefix:&nbsp;&nbsp;<asp:DropDownList
                                                                    ID="ddl_prefix" runat="server" CssClass="bodycopy" OnSelectedIndexChanged="ddl_prefix_Change"
                                                                    AutoPostBack="true" />
                                                                    -
                                                                    <asp:Label ID="lbl_bc_no" runat="server"></asp:Label>
                                                                </span>
                                                            </td>
                                                            <td style="width: 48%" align="center" valign="middle">
                                                                <asp:ImageButton runat="server" ImageUrl="~/images/button_save_medium.gif" ID="img_SaveBC"
                                                                    OnClick="img_SaveBC_Click" /></td>
                                                            <td style="width: 13%" align="right" valign="middle">
                                                                <asp:ImageButton runat="server" ImageUrl="~/images/button_new.gif" ID="img_NewBC"
                                                                    OnClick="img_NewBC_Click" /></td>
                                                            <td style="width: 13%" align="right" valign="middle">
                                                                <asp:ImageButton runat="server" ImageUrl="~/images/button_delete_medium.gif" ID="img_DeleteBC"
                                                                    OnClick="img_DeleteBC_Click" OnClientClick="return confirm_delete();" /></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="background-color: #6D8C80; height: 1px">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="center" style="background-color: #f3f3f3; height: 8px"
                                                    class="bodycopy">
                                                    <br />
                                                    <br />
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 82%; height: 30px">
                                                        <tr>
                                                            <td align="left" id="td_bill_select" runat="server">
                                                                <!-- Start JPED -->
                                                                <div style="margin-bottom: 5px">
                                                                    <span class="select">Select B/L type and number to import data.</span>
                                                                </div>
                                                                <asp:HiddenField runat="Server" ID="hBillNum" />
                                                                <div id="lstBillNumDiv">
                                                                </div>
                                                                <table cellpadding="0" cellspacing="0" border="0" style="margin-bottom: 5px">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:DropDownList ID="lstSearchType" runat="server" CssClass="bodyheader" onchange="lstSearchTypeChange();">
                                                                                <asp:ListItem Value="house">House B/L No.</asp:ListItem>
                                                                                <asp:ListItem Value="booking">Booking No</asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                        <td style="width: 5px">
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox runat="server" AutoCompleteType="None" ID="lstBillNum" CssClass="shorttextfield"
                                                                                Style="width: 150px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="BillNumFill(this,'O','lstBillNumChange',200);"
                                                                                onfocus="initializeJPEDField(this,event);" /></td>
                                                                        <td>
                                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="BillNumFillAll('lstBillNum','O','lstBillNumChange',200);"
                                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                        <td>
                                                                            <asp:Button ID="btn_load_bill_info" runat="server" OnClick="btn_load_bill_info_Click"
                                                                                Visible="false" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td align="right" valign="bottom">
                                                                <span class="bodyheader" >
                                                                    <img src="/ASP/Images/required.gif" align="absbottom" alt="" />Required
                                                                    field</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table class="bodycopy" border="0" cellpadding="5" cellspacing="0" style="text-align: left;
                                                        width: 82%; border: solid 1px #6D8C80; background-color: #ffffff">
                                                        <tr>
                                                            <td style="vertical-align: top; text-align: left" rowspan="3">
                                                                <span class="bodyheader">Shipper</span>
                                                                <!-- Start JPED -->
                                                                <asp:HiddenField runat="server" ID="hShipperAcct" />
                                                                <div id="lstShipperNameDiv">
                                                                </div>
                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:TextBox runat="server" autocomplete="off" ID="lstShipperName" CssClass="shorttextfield"
                                                                                Style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Shipper','lstShipperNameChange')"
                                                                                onfocus="initializeJPEDField(this,event);" /></td>
                                                                        <td>
                                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange')"
                                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                border-left: 0px solid #7F9DB9; cursor: hand" /></td>
                                                                        <td>
                                                                            <input type='hidden' id='quickAdd_output'/>
                                                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="" style="cursor: hand; border: solid 0px"
                                                                                onclick="quickAddClient('hShipperAcct','lstShipperName','txtShipperInfo')" /></td>
                                                                    </tr>
                                                                </table>
                                                                <asp:TextBox runat="server" ID="txtShipperInfo" CssClass="multilinetextfield" TextMode="MultiLine"
                                                                    Rows="5" Style="width: 300px"></asp:TextBox>
                                                                <!-- End JPED -->
                                                            </td>
                                                            <td style="vertical-align: top; text-align: left">
                                                                <span class="bodyheader">Date</span>
                                                                <div>
                                                                    <asp:TextBox ID="txt_document_date" runat="server" CssClass="m_shorttextfield" preset="shortdate" /></div>
                                                            </td>
                                                            <td style="vertical-align: top; text-align: left">
                                                                <span class="bodyheader">Booking No</span>
                                                                <div>
                                                                    <asp:TextBox ID="txt_booking_no" runat="server" CssClass="m_shorttextfield" /></div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <span class="bodyheader">Export Reference</span>
                                                                <div>
                                                                    <asp:TextBox ID="txt_export_reference" runat="server" CssClass="m_shorttextfield"
                                                                        Style="width: 200px" /></div>
                                                            </td>
                                                            <td>
                                                                <span class="bodyheader">Place of Receipt</span>
                                                                <div>
                                                                    <asp:TextBox ID="txt_place_of_receipt" runat="server" CssClass="m_shorttextfield"
                                                                        Style="width: 200px" /></div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <span class="bodyheader">Carrier</span>
                                                                <!-- Start JPED -->
                                                                <asp:HiddenField runat="server" ID="hCarrierAcct" />
                                                                <div id="lstCarrierNameDiv">
                                                                </div>
                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:TextBox runat="server" autocomplete="off" ID="lstCarrierName" CssClass="shorttextfield"
                                                                                Style="width: 220px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Carrier','lstCarrierNameChange')"
                                                                                onfocus="initializeJPEDField(this,event);" /></td>
                                                                        <td>
                                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCarrierName','Carrier','lstCarrierNameChange')"
                                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                border-left: 0px solid #7F9DB9; cursor: hand" /></td>
                                                                    </tr>
                                                                </table>
                                                                <!-- End JPED -->
                                                            </td>
                                                            <td>
                                                                <span class="bodyheader">Vessel/Voyager</span>
                                                                <div>
                                                                    <asp:TextBox ID="txt_carrier_no" runat="server" CssClass="m_shorttextfield" Style="width: 200px" /></div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="vertical-align: top; text-align: left" rowspan="3">
                                                                <span class="bodyheader">Deliver Good To</span>
                                                                <!-- Start JPED -->
                                                                <asp:HiddenField runat="server" ID="hConsigneeAcct" />
                                                                <div id="lstConsigneeNameDiv">
                                                                </div>
                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:TextBox runat="server" autocomplete="off" ID="lstConsigneeName" CssClass="shorttextfield"
                                                                                Style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange')"
                                                                                onfocus="initializeJPEDField(this,event);" /></td>
                                                                        <td>
                                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange')"
                                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                border-left: 0px solid #7F9DB9; cursor: hand" /></td>
                                                                        <td>
                                                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="" style="cursor: hand; border: solid 0px"
                                                                                onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" /></td>
                                                                    </tr>
                                                                </table>
                                                                <asp:TextBox runat="server" ID="txtConsigneeInfo" CssClass="multilinetextfield" TextMode="MultiLine"
                                                                    Rows="5" Style="width: 300px"></asp:TextBox>
                                                                <!-- End JPED -->
                                                            </td>
                                                            <td>
                                                                <span class="bodyheader">Port of Loading</span>
                                                                <div>
                                                                    <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="ddl_origin_port" />
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <span class="bodyheader">Port of Unloading</span>
                                                                <div>
                                                                    <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="ddl_dest_port" />
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <span class="bodyheader">ETD</span>
                                                                <div>
                                                                    <asp:TextBox ID="txt_etd_date" runat="server" CssClass="m_shorttextfield" preset="shortdate" />
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <span class="bodyheader">ETA</span>
                                                                <div>
                                                                    <asp:TextBox ID="txt_eta_date" runat="server" CssClass="m_shorttextfield" preset="shortdate" />
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <span class="bodyheader">Place of Delivery</span>
                                                                <div>
                                                                    <asp:TextBox ID="txt_place_of_delivery" runat="server" CssClass="m_shorttextfield"
                                                                        Style="width: 200px" /></div>
                                                            </td>
                                                            <td>
                                                                <span class="bodyheader">Type of Move</span>
                                                                <div>
                                                                    <asp:TextBox ID="txt_type_of_move" runat="server" CssClass="m_shorttextfield" Style="width: 200px" /></div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="vertical-align: top; text-align: left" rowspan="3">
                                                                <span class="bodyheader">Agent at Destination</span>
                                                                <!-- Start JPED -->
                                                                <asp:HiddenField runat="server" ID="hAgentAcct" />
                                                                <div id="lstAgentNameDiv">
                                                                </div>
                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:TextBox runat="server" autocomplete="off" ID="lstAgentName" CssClass="shorttextfield"
                                                                                Style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Agent','lstAgentNameChange')"
                                                                                onfocus="initializeJPEDField(this,event);" /></td>
                                                                        <td>
                                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstAgentName','Agent','lstAgentNameChange')"
                                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                border-left: 0px solid #7F9DB9; cursor: hand" /></td>
                                                                        <td>
                                                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="" style="cursor: hand; border: solid 0px"
                                                                                onclick="quickAddClient('hAgentAcct','lstAgentName','txtAgentInfo')" /></td>
                                                                    </tr>
                                                                </table>
                                                                <asp:TextBox runat="server" ID="txtAgentInfo" CssClass="multilinetextfield" TextMode="MultiLine"
                                                                    Rows="5" Style="width: 300px"></asp:TextBox>
                                                                <!-- End JPED -->
                                                            </td>
                                                            <td>
                                                                <span class="bodyheader">Cut off Date & Time</span>
                                                                <div>
                                                                    <asp:TextBox CssClass="m_shorttextfield" Width="218px" runat="server" ID="txt_cut_off_date" />
                                                                </div>
                                                            </td>
                                                            <td style="vertical-align: top; text-align: left" rowspan="3">
                                                                <span class="bodyheader">Empty Container Pickup Location</span>
                                                                <!-- Start JPED -->
                                                                <asp:HiddenField runat="server" ID="hEmptyPickupAcct" />
                                                                <div id="lstEmptyPickupNameDiv">
                                                                </div>
                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                    <tr style="height: 20px">
                                                                        <td>
                                                                            <asp:TextBox runat="server" autocomplete="off" ID="lstEmptyPickupName" CssClass="shorttextfield"
                                                                                Style="width: 250px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Consignee','lstEmptyPickupNameChange')"
                                                                                onfocus="initializeJPEDField(this,event);" /></td>
                                                                        <td>
                                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstEmptyPickupName','Consignee','lstEmptyPickupNameChange')"
                                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                                border-left: 0px solid #7F9DB9; cursor: hand" /></td>
                                                                    </tr>
                                                                </table>
                                                                <asp:TextBox runat="server" ID="txtEmptyPickupInfo" CssClass="multilinetextfield"
                                                                    TextMode="MultiLine" Rows="5" Style="width: 265px"></asp:TextBox>
                                                                <!-- End JPED -->
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <span class="bodyheader">Dagerous Good</span>
                                                                <div>
                                                                    <asp:RadioButtonList ID="rbl_dangerous_good" runat="server" RepeatDirection="Horizontal">
                                                                        <asp:ListItem>Yes</asp:ListItem>
                                                                        <asp:ListItem>No</asp:ListItem>
                                                                    </asp:RadioButtonList>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <br />
                                                    <table class="bodycopy" border="0" cellpadding="5" cellspacing="0" style="text-align: left;
                                                        width: 82%; border: solid 1px #6D8C80; background-color: #ffffff">
                                                        <tr valign="top">
                                                            <td>
                                                                <span class="bodyheader">No of Packages</span>
                                                                <div>
                                                                    <asp:TextBox ID="txt_quantity" runat="server" CssClass="bodycopy" />
                                                                    <asp:DropDownList ID="ddl_quantity_unit" runat="server" CssClass="bodycopy">
                                                                        <asp:ListItem>PCS</asp:ListItem>
                                                                        <asp:ListItem>BOX</asp:ListItem>
                                                                        <asp:ListItem>PLT</asp:ListItem>
                                                                        <asp:ListItem>CTN</asp:ListItem>
                                                                        <asp:ListItem>SET</asp:ListItem>
                                                                        <asp:ListItem>CRT</asp:ListItem>
                                                                        <asp:ListItem>SKD</asp:ListItem>
                                                                        <asp:ListItem>UNIT</asp:ListItem>
                                                                        <asp:ListItem>PKGS</asp:ListItem>
                                                                        <asp:ListItem>CNTR</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <span class="bodyheader">Descriptiton</span>
                                                                <div>
                                                                    <asp:TextBox ID="txt_description" runat="server" CssClass="multilinetextfield" TextMode="MultiLine"
                                                                        Rows="4" Width="300px" />
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <span class="bodyheader">Weight</span>
                                                                <div>
                                                                    <asp:TextBox ID="txt_weight" runat="server" CssClass="bodycopy" />
                                                                    <asp:DropDownList ID="ddl_weight_scale" runat="server" CssClass="bodycopy">
                                                                        <asp:ListItem>KG</asp:ListItem>
                                                                        <asp:ListItem>LB</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <span class="bodyheader">Dimension</span>
                                                                <div>
                                                                    <asp:TextBox ID="txt_dimension" runat="server" CssClass="bodycopy" />
                                                                    <asp:DropDownList ID="ddl_dimension_scale" runat="server" CssClass="bodycopy">
                                                                        <asp:ListItem>CBM</asp:ListItem>
                                                                        <asp:ListItem>CFT</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <br />
                                                    <table class="bodycopy" border="0" cellpadding="5" cellspacing="0" style="text-align: left;
                                                        width: 82%; border: solid 1px #6D8C80; background-color: #ffffff">
                                                        <tr valign="top">
                                                            <td>
                                                                <span class="bodyheader">Remark</span>
                                                                <div>
                                                                    <asp:TextBox ID="txt_remark" runat="server" TextMode="multiLine" CssClass="multilinetextfield"
                                                                        Width="600px" Rows="5" />
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <br />
                                                    <br />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="background-color: #6D8C80; height: 1px">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="background-color: #BFD0C9; height: 24px" align="center" valign="middle"
                                                    class="bodyheader">
                                                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td style="width: 26%" valign="middle" align="left">
                                                            </td>
                                                            <td style="width: 48%" align="center" valign="middle">
                                                                <asp:ImageButton runat="server" ImageUrl="~/images/button_save_medium.gif" ID="img_SaveBC2"
                                                                    OnClick="img_SaveBC_Click" /></td>
                                                            <td style="width: 13%" align="right" valign="middle">
                                                                <asp:ImageButton runat="server" ImageUrl="~/images/button_new.gif" ID="img_NewBC2"
                                                                    OnClick="img_NewBC_Click" /></td>
                                                            <td style="width: 13%" align="right" valign="middle">
                                                                <asp:ImageButton runat="server" ImageUrl="~/images/button_delete_medium.gif" ID="img_DeleteBC2"
                                                                    OnClick="img_DeleteBC_Click" OnClientClick="return confirm_delete();" /></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </center>
            <br />
            <br />
        </div>
    </form>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
