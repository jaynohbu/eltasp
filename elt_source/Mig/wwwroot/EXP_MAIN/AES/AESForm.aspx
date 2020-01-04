<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AESForm.aspx.cs" Inherits="AES_AESForm" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v6.2, Version=6.2.20062.34, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<%@ Register Assembly="Infragistics2.WebUI.WebNavBar.v6.2, Version=6.2.20062.34, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebNavBar" TagPrefix="ignavbar" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDataInput.v6.2, Version=6.2.20062.34, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>AES Submit</title>
    <link href="../CSS/elt_css.css" rel="stylesheet" type="text/css" />

    <script src="../AJAX/ajax.js" type="text/javascript"></script>

    <script src="../Include/JPED.js" type="text/javascript"></script>

    <script id="main" type="text/javascript">
    
        function lstConsigneeNameChange(orgNo,orgName)
        {
            var hiddenObj = document.getElementById("hConsigneeAcct");
            var divObj = document.getElementById("lstConsigneeNameDiv")
            hiddenObj.value = orgNo;
            getOrganizationInfo(orgNo,"Consignee");
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
        
        function lstInterConsigneeNameChange(orgNo,orgName)
        {
            var hiddenObj = document.getElementById("hInterConsigneeAcct");
            var divObj = document.getElementById("lstInterConsigneeNameDiv")
            hiddenObj.value = orgNo;
            getOrganizationInfo(orgNo,"InterConsignee");
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
        
        function getOrganizationInfo(orgNo,objGroupName)
        {
            var url = "/EXP_MAIN/AJAX/ajax_get_org_detail_xml.asp?orgNo=" + orgNo
            var displayFunctionName = "";
            
            if(objGroupName == "Consignee"){
                new ajax.xhr.Request('GET','',url,displayConsigneeUpdate,'','','','');
            }
            if(objGroupName == "InterConsignee"){
                new ajax.xhr.Request('GET','',url,displayInterConsigneeUpdate,'','','','');
            }
        }

        function displayConsigneeUpdate(req,field,tmpVal,tWidth,tMaxLength,url)
        {
            if (req.readyState == 4)
            {   
		        if (req.status == 200)
		        {
		            try{
		                var xmlObj = req.responseXML;
		                
		                setField("dba_name","lstConsigneeName",xmlObj);
		                setField("business_address","AD1_3",xmlObj);
		                setField("business_address","AD1_8",xmlObj);
		                setField("business_address2","AD1_9",xmlObj);
		                setField("business_city","AD1_10",xmlObj);
		                setField("business_state","AD1_11",xmlObj);
		                setField("b_country_code","AD1_12",xmlObj);
		                setField("business_zip","AD1_13",xmlObj);
		                
                    }catch(error)
                    {
                        alert(error.description);
                        xmlObj = null;
                    }
                    xmlObj = null;
		        }
		    }
		}
		
        function displayInterConsigneeUpdate(req,field,tmpVal,tWidth,tMaxLength,url)
        {
            if (req.readyState == 4)
            {   
		        if (req.status == 200)
		        {
		            try{
		                var xmlObj = req.responseXML;
		                
		                setField("dba_name","lstInterConsigneeName",xmlObj);
		                setField("business_address","AD4_3",xmlObj);
		                setField("business_address","AD4_8",xmlObj);
		                setField("business_address2","AD4_9",xmlObj);
		                setField("business_city","AD4_10",xmlObj);
		                setField("business_state","AD4_11",xmlObj);
		                setField("b_country_code","AD4_12",xmlObj);
		                setField("business_zip","AD4_13",xmlObj);
		                
                    }catch(error)
                    {
                        alert(error.description);
                        xmlObj = null;
                    }
                    xmlObj = null;
		        }
		    }
		}
		
		function setField(xmlTag,htmlTag,xmlObj)
        {
            if(xmlObj.getElementsByTagName(xmlTag)[0] != null && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null)
            {
                document.getElementById(htmlTag).value = xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue;
            }
            else
            {
                document.getElementById(htmlTag).value = "";
            }
        }
		
    </script>

    <script id="Infragistics" type="text/javascript">

        function UltraWebGrid1_AfterCellUpdateHandler(gridName, cellId){
        	var currentCell = igtbl_getCellById(cellId);
            var error;
            
	        if(currentCell.Column.Key == "b_number"){
                var currentValue = currentCell.getValue();
                var currentRow = igtbl_getActiveRow(gridName);

                var xmlObj = getScheduleBInfo(currentValue);
                
                currentRow.getCell(2).setValue("");
                currentRow.getCell(4).setValue("");
                currentRow.getCell(6).setValue("");
                currentRow.getCell(12).setValue("");
                
                try{
                    currentRow.getCell(2).setValue(xmlObj.getElementsByTagName("sb")[0].childNodes[0].nodeValue);
                }catch(error){}
                try{
                    currentRow.getCell(4).setValue(xmlObj.getElementsByTagName("sb_unit1")[0].childNodes[0].nodeValue);
                }catch(error){}
                try{
                    currentRow.getCell(6).setValue(xmlObj.getElementsByTagName("sb_unit2")[0].childNodes[0].nodeValue);
                }catch(error){}
                try{
                    currentRow.getCell(9).setValue(xmlObj.getElementsByTagName("export_code")[0].childNodes[0].nodeValue);
                }catch(error){}
                try{
                    currentRow.getCell(10).setValue(xmlObj.getElementsByTagName("license_type")[0].childNodes[0].nodeValue);
                }catch(error){}
                try{
                    currentRow.getCell(12).setValue(xmlObj.getElementsByTagName("eccn")[0].childNodes[0].nodeValue);
                }catch(error){}
            }
        }
        
        function getScheduleBInfo(scheB)
        {
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

            var url="../AJAX/ajax_get_sb_detail_xml.asp?scheB="+ scheB;

            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send(); 
            
            return xmlHTTP.responseXML; 
        }
        
        function AESSubmitClick(){
            if(document.getElementById("AESNO").value != ""){
            
                var vURL = "./tran_send_aes.asp?WindowName=AESDIRECT&AESID=" + document.getElementById("AESNO").value;
                var vWinArg = "left=0,top=0,staus=0,titlebar=0,toolbar=0,menubar=0,scrollbars=1,resizable=1,location=0,width=710,height=500,hotkeys=0";
                
                var vWindow = window.open(vURL, "AESDIRECT", vWinArg);
                vWindow.focus();
                return false;
            }
            else{
                
                alert("Please, save the form before submitting to AES direct");
            }
        }
        
        function infoTextLoad(){
            var oImgInfoECCN = document.getElementById("imgInfoECCN");
            oImgInfoECCN.onmouseover = function(){showtip("Some license types require an ECCN number.");};
            oImgInfoECCN.onmouseout = function(){hidetip();};
        }

    </script>

</head>
<body style="margin: 0px 0px 0px 0px" onload="infoTextLoad()">
    <div id="tooltipcontent">
    </div>
    <form id="form1" runat="server">
        <asp:HiddenField runat="server" ID="AESNO" Value="" />
        
        <div style="text-align: center">
            <table cellpadding="0" cellspacing="0" border="0" style="width: 95%; text-align: left">
                <tr>
                    <td class="pageheader">
                        <asp:Label runat="server" ID="labelPageTitle" />
                    </td>
                    <td style="text-align: right" id="print">
                        <img src="/iff_main/ASP/Images/icon_submit.gif" align="absbottom" alt="" /><a href="javascript:;"
                            onclick="AESSubmitClick();">Submit to AES Weblink</a>
                    </td>
                </tr>
            </table>
            <asp:Label runat="server" ID="txtResultBox" Width="95%" Visible="false" />
            <table cellpadding="2" cellspacing="0" border="0" style="width: 95%; text-align: left;
                border: solid 1px #a0829c" class="bodycopy">
                <tr style="height: 8px; background-color: #E5D4E3">
                    <td style="text-align: center">
                        <asp:ImageButton runat="server" ImageUrl="../Images/button_save.gif" ID="btnSaveAESTop"
                            OnClick="btnSaveAES_Click" />
                    </td>
                </tr>
                <tr style="height: 1px; background-color: #a0829c">
                    <td>
                    </td>
                </tr>
                <tr style="background-color: #f0e7ef">
                    <td>
                        <strong>
                            <img src="../Images/required.gif" align="absbottom" alt="" />Shipment Information</strong>
                    </td>
                </tr>
                <tr style="height: 1px; background-color: #a0829c">
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table cellpadding="2" cellspacing="0" border="0" style="width: 100%" class="bodycopy">
                            <tr>
                                <td style="width: 25%">
                                    Shipment Reference Number</td>
                                <td style="width: 25%">
                                    <asp:TextBox ID="SRN" runat="server" CssClass="shorttextfield" MaxLength="16" Width="120px" />
                                    <asp:RequiredFieldValidator ID="rfvSRN" runat="server" ErrorMessage="*"
                                        ControlToValidate="SRN" SetFocusOnError="true" /></td>
                                <td style="width: 25%">
                                    Transportation Reference Number (Vessel Only)</td>
                                <td style="width: 25%">
                                    <asp:TextBox ID="BN" runat="server" CssClass="shorttextfield" MaxLength="30" Width="200px" /></td>
                            </tr>
                            <tr style="background-color:#eeeeee">
                                <td>
                                    State of Origin</td>
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
                                    <asp:RequiredFieldValidator ID="rfvST" runat="server" ControlToValidate="ST"
                                        ErrorMessage="*" SetFocusOnError="true" /></td>
                                <td>
                                    Port of Export
                                </td>
                                <td>
                                    <asp:DropDownList runat="server" ID="POE" CssClass="bodycopy" Width="200px" />
                                    <asp:RequiredFieldValidator ID="rfvPOE" runat="server" ErrorMessage="*"
                                        ControlToValidate="POE" SetFocusOnError="true" /></td>
                            </tr>
                            <tr>
                                <td>
                                    Country of Destination
                                </td>
                                <td>
                                    <asp:DropDownList ID="COD" runat="server" CssClass="bodycopy" Width="250px" />
                                    <asp:RequiredFieldValidator ID="rfvCOD" runat="server" ControlToValidate="COD"
                                        ErrorMessage="*" SetFocusOnError="true" />
                                </td>
                                <td>
                                    Port of Unloading (Vessel Only)
                                </td>
                                <td>
                                    <asp:DropDownList ID="POU" runat="server" CssClass="bodycopy" Width="200px" /></td>
                            </tr>
                            <tr style="background-color:#eeeeee">
                                <td>
                                    Departure Date (MM/DD/YY)</td>
                                <td>
                                    <igtxt:WebDateTimeEdit ID="EDA" runat="server" CssClass="shorttextfield" EditModeFormat="MM/dd/yy"
                                        Width="50px" />
                                    <asp:RequiredFieldValidator ID="rfvEDA" runat="server" ControlToValidate="EDA"
                                        ErrorMessage="*" SetFocusOnError="true" /></td>
                                <td>
                                    Mode of Transportation</td>
                                <td>
                                    <asp:DropDownList ID="MOT" runat="server" CssClass="bodycopy">
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvMOT" runat="server" ControlToValidate="MOT"
                                        ErrorMessage="*" SetFocusOnError="true" /></td>
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
                                    Parties to Transaction</td>
                                <td>
                                    <asp:RadioButtonList ID="RCC" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow"
                                        CssClass="RightMargin">
                                        <asp:ListItem Text="Related&nbsp;&nbsp;&nbsp;" Value="Y" />
                                        <asp:ListItem Text="Non-related" Value="N" Selected="True" />
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr style="background-color:#eeeeee">
                                <td>
                                    Hazardous Cargo</td>
                                <td>
                                    <asp:RadioButtonList ID="HAZ" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow"
                                        CssClass="RightMargin">
                                        <asp:ListItem Text="Yes&nbsp;&nbsp;&nbsp;" Value="Y" />
                                        <asp:ListItem Text="No" Value="N" Selected="True" />
                                    </asp:RadioButtonList></td>
                                <td>
                                    Routed Export Transaction</td>
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
                            <tr runat="server" id="trInbond" visible="false" style="background-color:#eeeeee">
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
                                    ITN No.</td>
                                <td>
                                    <asp:Label runat="server" ID="ITN" CssClass="bodycopy" Text="N/A" /></td>
                                <td>
                                    AES Status
                                </td>
                                <td>
                                    <asp:Label runat="server" ID="STATUS" CssClass="bodycopy" Text="N/A" />
                                </td>
                            </tr>
                            <tr style="background-color: #dcdcdc" runat="server" id="trInfo2">
                                <td>
                                    AES Submit Date</td>
                                <td>
                                    <asp:Label runat="server" ID="SubmittedDate" CssClass="bodycopy" Text="N/A" /></td>
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
                    <td>
                    </td>
                </tr>
                <tr style="background-color: #f0e7ef">
                    <td>
                        <strong>Consignee(s)</strong>
                    </td>
                </tr>
                <tr style="height: 1px; background-color: #a0829c">
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table cellpadding="2" cellspacing="0" border="0" style="width: 100%" class="bodycopy">
                            <tr>
                                <td style="width: 50%">
                                    <strong>
                                        <img src="../Images/required.gif" align="absbottom" alt="" />Ultimate Consignee</strong></td>
                                <td style="width: 50%">
                                    <strong>Intermediate Consignee</strong></td>
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
                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange')"
                                                    onfocus="initializeJPEDField(this);" /></td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange')"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" style="cursor: hand" onclick="quickAddClientNew('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo','lstConsigneeNameChange')" />
                                                <asp:RequiredFieldValidator ID="rfvConsignee" runat="server" ControlToValidate="lstConsigneeName"
                                                    ErrorMessage="*" ></asp:RequiredFieldValidator></td>
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
                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Consignee','lstInterConsigneeNameChange')"
                                                    onfocus="initializeJPEDField(this);" /></td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstInterConsigneeName','Consignee','lstInterConsigneeNameChange')"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" style="cursor: hand" onclick="quickAddClientNew('hInterConsigneeAcct','lstInterConsigneeName','txtInterConsigneeInfo','lstInterConsigneeNameChange')" /></td>
                                        </tr>
                                    </table>
                                    <!-- End JPED -->
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table cellpadding="2" cellspacing="0" border="0" class="bodycopy">
                                        <tr>
                                            <td>
                                                Address 1</td>
                                            <td>
                                                <asp:TextBox runat="server" ID="AD1_8" CssClass="shorttextfield" MaxLength="32" Width="220px" /></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Address 2</td>
                                            <td>
                                                <asp:TextBox runat="server" ID="AD1_9" CssClass="shorttextfield" MaxLength="32" Width="220px" /></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                City</td>
                                            <td>
                                                <asp:TextBox runat="server" ID="AD1_10" CssClass="shorttextfield" MaxLength="25"
                                                    Width="180px" /></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                State</td>
                                            <td>
                                                <asp:TextBox runat="server" ID="AD1_11" CssClass="shorttextfield" MaxLength="2" Width="25px" /></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Country</td>
                                            <td>
                                                <asp:TextBox runat="server" ID="AD1_12" CssClass="shorttextfield" MaxLength="2" Width="25px" /></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Postal Code</td>
                                            <td>
                                                <asp:TextBox runat="server" ID="AD1_13" CssClass="shorttextfield" MaxLength="9" Width="70px" /></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <table cellpadding="2" cellspacing="0" border="0" class="bodycopy">
                                        <tr>
                                            <td>
                                                Address 1</td>
                                            <td>
                                                <asp:TextBox runat="server" ID="AD4_8" CssClass="shorttextfield" MaxLength="32" Width="220px" /></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Address 2</td>
                                            <td>
                                                <asp:TextBox runat="server" ID="AD4_9" CssClass="shorttextfield" MaxLength="32" Width="220px" /></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                City</td>
                                            <td>
                                                <asp:TextBox runat="server" ID="AD4_10" CssClass="shorttextfield" MaxLength="25"
                                                    Width="180px" /></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                State</td>
                                            <td>
                                                <asp:TextBox runat="server" ID="AD4_11" CssClass="shorttextfield" MaxLength="2" Width="25px" /></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Country</td>
                                            <td>
                                                <asp:TextBox runat="server" ID="AD4_12" CssClass="shorttextfield" MaxLength="2" Width="25px" /></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Postal Code</td>
                                            <td>
                                                <asp:TextBox runat="server" ID="AD4_13" CssClass="shorttextfield" MaxLength="9" Width="70px" /></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr style="height: 1px; background-color: #a0829c">
                    <td>
                    </td>
                </tr>
                <tr style="background-color: #f0e7ef">
                    <td>
                        <strong>Line Items</strong>
                    </td>
                </tr>
                <tr style="height: 1px; background-color: #a0829c">
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div>
                            <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Height="200px" Width="100%"
                                DataSourceID="SqlDataSource1" OnInitializeLayout="UltraWebGrid1_InitializeLayout">
                                <Bands>
                                    <igtbl:UltraGridBand>
                                        <FilterOptions EmptyString="" AllString="" NonEmptyString="">
                                            <FilterDropDownStyle BorderWidth="1px" BorderColor="Silver" BorderStyle="Solid" BackColor="White"
                                                Width="200px" CustomRules="overflow:auto;" CssClass="bodycopy" />
                                            <FilterHighlightRowStyle ForeColor="White" BackColor="#151C55" CssClass="bodycopy" />
                                        </FilterOptions>
                                        <AddNewRow View="NotSet" Visible="NotSet">
                                        </AddNewRow>
                                    </igtbl:UltraGridBand>
                                </Bands>
                                <DisplayLayout Name="UltraWebGrid1" BorderCollapseDefault="Separate" RowHeightDefault="20px"
                                    SelectTypeRowDefault="Single" RowSizingDefault="Free" AllowAddNewDefault="Yes"
                                    AllowDeleteDefault="Yes" AllowUpdateDefault="Yes" SelectTypeCellDefault="Single"
                                    SelectTypeColDefault="Single" EnableInternalRowsManagement="True" RowSelectorsDefault="No"
                                    Version="4.00">
                                    <FrameStyle BorderWidth="1px" BorderStyle="Solid" Height="200px" Width="100%">
                                    </FrameStyle>
                                    <FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray" CssClass="bodycopy">
                                        <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
                                    </FooterStyleDefault>
                                    <RowStyleDefault Font-Names="Verdana,Arial,Helvetica,Sans-serif" Font-Size="9px"
                                        BorderWidth="1px" BorderColor="#888888" BorderStyle="Solid" BackColor="Window"
                                        TextOverflow="Ellipsis">
                                        <BorderDetails ColorTop="Window" ColorLeft="Window"></BorderDetails>
                                        <Padding Left="3px"></Padding>
                                    </RowStyleDefault>
                                    <FilterOptionsDefault EmptyString="(Empty)" AllString="(All)" NonEmptyString="(NonEmpty)">
                                        <FilterDropDownStyle BorderWidth="1px" BorderColor="Silver" BorderStyle="Solid" BackColor="White"
                                            Width="200px" CustomRules="overflow:auto;">
                                        </FilterDropDownStyle>
                                        <FilterHighlightRowStyle ForeColor="White" BackColor="#151C55">
                                        </FilterHighlightRowStyle>
                                    </FilterOptionsDefault>
                                    <HeaderStyleDefault HorizontalAlign="Left" BorderStyle="Solid" BackColor="#E5D4E3"
                                        ForeColor="Black" Height="19px">
                                    </HeaderStyleDefault>
                                    <EditCellStyleDefault BorderWidth="0px" BorderStyle="None">
                                    </EditCellStyleDefault>
                                    <ActivationObject BorderColor="168, 167, 191">
                                    </ActivationObject>
                                    <SelectedRowStyleDefault BackColor="Highlight" ForeColor="HighlightText">
                                    </SelectedRowStyleDefault>
                                    <ImageUrls CollapseImage="/ig_common/Images/ig_treeMinus.gif" ExpandImage="/ig_common/Images/ig_treePlus.gif" />
                                    <ClientSideEvents AfterCellUpdateHandler="UltraWebGrid1_AfterCellUpdateHandler" />
                                </DisplayLayout>
                            </igtbl:UltraWebGrid>
                            <ignavbar:WebNavBar ID="WebNavBar1" runat="server" BorderWidth="1px" BackColor="#EDEDED"
                                BorderColor="Gainsboro" ForeColor="" Position="Top" BorderStyle="Solid" Movable="True"
                                Height="25px">
                                <Navigation Visible="False">
                                    <Start AutoPostBack="False" DepthFirst="False" Key="start" Step="-2147483648" StepUnit="First"
                                        TabIndex="1" ToolTip="Start" Visible="False">
                                    </Start>
                                    <Rewind AutoPostBack="False" DepthFirst="False" Key="rew" Step="-1" StepUnit="Page"
                                        TabIndex="2" ToolTip="Reverse" Visible="False">
                                    </Rewind>
                                    <Prev AutoPostBack="False" DepthFirst="False" Key="prev" Step="-1" StepUnit="Row"
                                        TabIndex="3" ToolTip="Previous" Visible="False">
                                    </Prev>
                                    <Next AutoPostBack="False" DepthFirst="False" Key="next" Step="1" StepUnit="Row"
                                        TabIndex="4" ToolTip="Next" Visible="False">
                                    </Next>
                                    <FastForward AutoPostBack="False" DepthFirst="False" Key="ff" Step="1" StepUnit="Page"
                                        TabIndex="5" ToolTip="Forward" Visible="False">
                                    </FastForward>
                                    <End AutoPostBack="False" DepthFirst="False" Key="end" Step="2147483647" StepUnit="Last"
                                        TabIndex="6" ToolTip="End" Visible="False">
                                    </End>
                                </Navigation>
                                <Extension>
                                    <Insert AutoPostBack="False" ToolTip="Click to Add Item" Key="add" TabIndex="1" DefaultStyle-Width="100px"
                                        Text="Add Item" DefaultStyle-TextAlign="Left">
                                    </Insert>
                                    <Delete AutoPostBack="False" ToolTip="Remove Selected Item" Key="del" TabIndex="2"
                                        DefaultStyle-Width="100px" Text="Remove Item" DefaultStyle-TextAlign="Left">
                                    </Delete>
                                    <Submit Visible="false" AutoPostBack="False" ToolTip="Reset" Key="submit" TabIndex="3">
                                    </Submit>
                                </Extension>
                                <ClientSideEvents AfterDeleteRow="" AfterInsertRow="" AfterMoveBackward="" AfterMoveForward=""
                                    AfterMoveNext="" AfterMovePrev="" AfterMoveToEnd="" AfterMoveToStart="" BeforeDeleteRow=""
                                    BeforeInsertRow="" BeforeMoveBackward="" BeforeMoveForward="" BeforeMoveNext=""
                                    BeforeMovePrev="" BeforeMoveToEnd="" BeforeMoveToStart="" Click="" Initialize=""
                                    MouseOut="" MouseOver="" />
                            </ignavbar:WebNavBar>
                        </div>
                    </td>
                </tr>
                <tr style="height: 1px; background-color: #a0829c">
                    <td>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center; background-color: #E5D4E3">
                        <asp:ImageButton runat="server" ImageUrl="../Images/button_save.gif" ID="btnSaveAESBot"
                            OnClick="btnSaveAES_Click" />
                    </td>
                </tr>
            </table>
        </div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" OnInit="SqlDataSource1_Init"></asp:SqlDataSource>
    </form>
    <br />
</body>

<script language="JavaScript" type="text/javascript" src="../Include/tooltips.js"></script>

<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
