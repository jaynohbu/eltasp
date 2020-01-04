<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WIO2.aspx.cs" Inherits="ASPX_WMS_WIO2"
    CodePage="65001" %>

<%--<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=11.5.3700.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>--%>
<%@ Register Assembly="iMoon.WebControls.ComboBox" Namespace="iMoon.WebControls"
    TagPrefix="iMoon" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="uc1" TagName="rdSelectDateControl1" Src="../SelectionControls/rdSelectDateControl1.ascx" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>IN & OUT REPORT</title>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
    <meta content="C#" name="CODE_LANGUAGE" />
    <meta content="JavaScript" name="vs_defaultClientScript" />
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
    <style type="text/css">
        .fromCalendar{
            position:absolute; 
            top:0px; 
            left:20px; 
            background-color:#ffffff;
            z-index:2;
        }
        .toCalendar{
            position:absolute; 
            top:0px; 
            left:20px; 
            background-color:#ffffff;
            z-index:2;
        }
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
        .style1 {color: #c16b42}

        #Layer1 {
	        position:absolute;
	        width:320px;
	        height:180;
	        z-index:1;
	        left: 534px;
	        top: 81px;
        }
		.marginleft {
		margin-left:18px;
		}
		.style3 {
		color: #cc6600;
		}

    </style>

    <script type="text/javascript" language="javascript" src="/IFF_MAIN/ASP/ajaxFunctions/ajax.js"></script>

    <script src="../jScripts/WebDateSet1.js" type="text/javascript"></script>

    <script src="../jScripts/ig_dropCalendar.js" type="text/javascript"></script>

    <script src="../jScripts/ig_editDrop1.js" type="text/javascript"></script>

    <script type="text/javascript" src="/IFF_MAIN/ASP/include/JPED.js">
        function lstAccountOfName_onclick() {
        }
    </script>

    <script type="text/jscript">
     
        function lstAccountOfChange(orgNum,orgName) {
        
            var url;
            if (orgNum=="" || orgName==""){
                url = "./WIO2.aspx" 
            }
            else{
                url = "./WIO2.aspx?orgAcct=" + orgNum + "&orgName=" + encodeURIComponent(orgName);
            }
            document.location.href = url;
        }
        
        function CheckDate() {

            if( document.form1.ComboBox1.value != "") {
	            document.form1.txtNum.value = document.form1.ComboBox1.selectedIndex;
	             return true;
            }
            if( document.form1.lstSearchNum.value != "") return true;
            if( document.form1.lstShipOut.value != "") return true;
            if( document.form1.txtHAWBNum.value != "") return true;
            if( document.form1.txtMAWBNum.value != "") return true;
            if( document.form1.txtRefNo.value != "") return true;
            if( document.form1.txtFileNo.value != "") return true;

            var	Wedit1 = igedit_getById('Webdatetimeedit1')
            var a=Wedit1.getValue();
            
            if(!a){
                alert(' Please input the from date!');
                return false;
            }
            return true; 
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
        
        function lstSearchNumChange2(argV,argL){
            var divObj = document.getElementById("lstShipOutDiv");
		    var hiddenObj = document.getElementById("hShipOut");
		    var txtObj = document.getElementById("lstShipOut");	
       

            hiddenObj.value = argV;
		    txtObj.value = argL;	    
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
        }
		
        function lstDataChange(orgNum,orgName) {
            var url = "./WIO2.aspx?orgAcct=" + orgNum + "&orgName=" + encodeURIComponent(orgName);
            document.location.href = url;
        }

        function lstAccountOfChange2(ANum,AName){
            var AdivObj = document.getElementById("lstAccountOfNameDiv");
		    var AhiddenObj = document.getElementById("hAccountOfAcct");
		    var AtxtObj = document.getElementById("lstAccountOfName");

		    AhiddenObj.value = ANum;

		    AtxtObj.value = AName;
		    AdivObj.style.position = "absolute";
		    AdivObj.style.visibility = "hidden";
		    AdivObj.innerHTML = "";		
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

            var url="/IFF_MAIN/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=" + infoFormat + "&org=" + orgNum;

            xmlHTTP.open("GET",url,false);
            xmlHTTP.send();
            
            return xmlHTTP.responseText; 
        }
        
    // End of list change effect ///////////////////////////////////////////////////////////////////  
    
        function checkAllWRs() {
            var chkObj = document.getElementsByName("chkWR");
            var txtObj = document.getElementsByName("txtPiece");

            for(var i=0;i<chkObj.length;i++){
                chkObj[i].checked = true;
                txtObj[i].style.backgroundColor = "transparent";
                txtObj[i].readOnly = false;
            }
        }
        
        function countChecked() {
            var count = 0;
            var chkObj = document.getElementsByName("chkWR");
            var txtObj = document.getElementsByName("txtPiece");

            for(var i=0;i<chkObj.length;i++){
                if(chkObj[i].checked) count++;
            }
            return count;
        }
        
        function clearAll() {
            var url = "./WIO2.aspx";
            document.location.href = url;
        }
            
        function enableTxtPiece(chkObj,row_id) {
            var txtObj = document.getElementById("txtPiece" + row_id);
            txtObj.readOnly = !chkObj.checked;
            
            
            if(!txtObj.readOnly){
                txtObj.style.backgroundColor = "transparent";
            }
            else{
                txtObj.style.backgroundColor = "#cccccc";
            }
        }
        
        function checkNum() {
	        var ValidChars = "0123456789.-";

            if(ValidChars.indexOf(String.fromCharCode(event.keyCode)) == -1){
                event.returnValue=false;
            }
            else{
                event.returnValue=true;
            }
        }
        function searchNumFill(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_warehouse_receipt.asp?mode=list&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            
            url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_warehouse_receipt.asp?mode=list";
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        

        function searchNumFill2(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_shipout.asp?mode=list&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll2(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);

            url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_shipout.asp?mode=list";
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        
        function checkPieceLimit(txtObj,limitPiece) {
            if (txtObj.value > limitPiece){
                alert("Can't enter more than remaining pieces");
                txtObj.value = limitPiece;
            }
        }
        
        function doShipout(){
        
            if(countChecked() == 0){
                return false;
            }
            
            var objPCS = document.getElementsByName("txtPiece");
            var totalPCS = tmpPCS = 0;

            for(var i=0;i<objPCS.length;i++){
                tmpPCS = parseInt(objPCS[i].value);
                if(objPCS[i].value != "" && tmpPCS > 0){
                    totalPCS = totalPCS + tmpPCS;
                }
            }
            document.getElementById("hTotalPCS").value = totalPCS;
            
            jPopUpNormal();
            document.form1.action="/IFF_MAIN/ASP/WMS/shipout_detail.asp?SO=Q";
            document.form1.method="POST";
            document.form1.target="popUpWindow";
            document.form1.submit();
        }
        
        function jPopUpNormal(){
            var argS = 'menubar=1,toolbar=1,height=400,width=780,hotkeys=0,scrollbars=1,resizable=1';
            popUpWindow = window.open('','popUpWindow', argS);
        }
			
        function goSOScreen(orgnum_g,orgname_g) {
    
            url ="/IFF_MAIN/ASP/WMS/shipout_detail.asp?mode=Reload&o=" + encodeURIComponent(orgname_g)
                + "&n=" + orgnum_g + "&WindowName=popUpWindow";
            window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
        }
        
        function goWRScreen(orgnum,orgname) {
            url ="/IFF_MAIN/ASP/WMS/warehouse_receipt.asp?o=" + encodeURIComponent(orgname)
                + "&n=" + orgnum + "&WindowName=popUpWindow";
                window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
        }
			

	    function goCustomerScreen(cus_acct) {
            url ="/IFF_MAIN/ASP/master_data/client_profile.asp?Action=filter&n=" + cus_acct + "&WindowName=popUpWindow";
            window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
        }			
        
    </script>

    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server" class="bodycopy">
        <input type="image" style="position:absolute; visibility:hidden" onclick="return false;" />
        <input type="hidden" id="hTotalPCS" name="hTotalPCS" value="0" />
        <!-- page title -->
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td align="left" valign="middle" class="pageheader">
                    In & Out Report
                </td>
                <td align="right" valign="middle">
                    &nbsp;<!--<asp:Button ID="Button2" runat="server" OnClick="Page_Load" Text="Go" />-->
            </tr>
        </table>
        <!--warp table starts -->
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#9e816e"
            class="border1px">
            <tr>
                <td height="8" bgcolor="#e5cfbf">
                </td>
            </tr>
            <tr>
                <td height="1" bgcolor="#9e816e">
                </td>
            </tr>
            <tr>
                <td align="center" bgcolor="#f3f3f3" class="bodycopy" style="padding-left: 10px">
                    <br />
                    <br />
                    <table border="0" cellpadding="0" cellspacing="0" bordercolor="#9e816e" bgcolor="#FFFFFF"
                        class="border1px" style="padding-left: 8px">
                        <tr class="bodyheader">
                            <td align="left" valign="middle" bgcolor="#f4e9e0" style="height: 19px">
                                <span class="style1">Report by</span></td>
                            <td align="left" valign="middle" bgcolor="#f4e9e0" style="padding-left: 38px; height: 19px">
                                Period</td>
                            <td align="left" bgcolor="#f4e9e0" style="padding-left: 28px; height: 19px;">
                                From</td>
                            <td colspan="2" align="left" bgcolor="#f4e9e0" style="height: 19px">
                                To</td>
                        </tr>
                        <tr>
                            <td align="left" valign="top">
                                <asp:DropDownList runat="server" ID="listResultSelect" CssClass="bodycopy">
                                    <asp:ListItem Value="WRINOUT" Text="Warehouse In & Out"></asp:ListItem>
                                    <asp:ListItem Value="WRIN" Text="Warehouse In"></asp:ListItem>
                                    <asp:ListItem Value="WROUT" Text="Warehouse Out"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td align="left" valign="top" style="padding-left: 38px">
                                <uc1:rdSelectDateControl1 ID="RdSelectDateControl11" runat="server"></uc1:rdSelectDateControl1>
                            </td>
                            <td align="left" valign="top">
                                <table border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td align="left" valign="top" style="padding-left: 20px; height: 12px;">
                                            <igtxt:WebDateTimeEdit ID="Webdatetimeedit1" AccessKey="e" runat="server" ForeColor="Black"
                                                Width="120px" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" " Height="17px">
                                                <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                </ButtonsAppearance>
                                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
                                            </igtxt:WebDateTimeEdit>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td align="left" valign="top" colspan="2">
                                <table border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top">
                                            <igtxt:WebDateTimeEdit ID="Webdatetimeedit2" AccessKey="e" runat="server" ForeColor="Black"
                                                Width="120px" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" " Height="17px">
                                                <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                </ButtonsAppearance>
                                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                            </igtxt:WebDateTimeEdit>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="middle">
                            </td>
                            <td align="left" valign="middle">
                            </td>
                            <td align="left" valign="middle">
                            </td>
                            <td align="left" valign="middle">
                            </td>
                        </tr>
                        <tr>
                            <td height="2" align="left" valign="middle" bgcolor="#9e816e" colspan="4">
                            </td>
                        </tr>
                        <tr class="bodyheader">
                            <td height="18" colspan="2" align="left" bgcolor="#f3f3f3">
                                Customer</td>
                            <td align="left" bgcolor="#f3f3f3">
                                &nbsp;</td>
                            <td align="left" bgcolor="#f3f3f3">
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td height="24" colspan="2" align="left">
                                <!-- Start JPED -->
                                <input type="hidden" id="hAccountOfAcct" name="hAccountOfAcct" value="<%=Request.Form.Get("hAccountOfAcct") %>" />
                                <div id="lstAccountOfNameDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <!--<%=Request.Params.Get("orgName") %>-->
                                            <input type="text" autocomplete="off" id="lstAccountOfName" name="lstAccountOfName"
                                                value="<%=Request.Form.Get("lstAccountOfName") %>" class="shorttextfield" style="width: 240px;
                                                border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9;
                                                border-right: 0px solid #7F9DB9; color: Black" onkeyup="organizationFill(this,'','lstAccountOfChange2')"
                                                onfocus="initializeJPEDField(this);" language="javascript" onclick="return lstAccountOfName_onclick()" /></td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstAccountOfName','','lstAccountOfChange2')"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: pointer;" /></td>
                                        <td>
                                            <!-- <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: pointer onclick="quickAddClient('hAccountOfAcct','lstAccountOfName','txtAccountOfInfo')" /></td>
                                        <td width="20%" style="padding-left: 10px; height: 44px
                                        -->
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td colspan="2" align="left" valign="top">
                                <asp:CheckBox ID="check1" Text="Sort by Customer" TextAlign="Right" runat="server" /></td>
                            <!--<input type="checkbox" name="checkbox" value="checkbox" />
		AutoPostBack="True" OnCheckedChanged="Check"  -->
                        </tr>
                        <tr>
                            <td height="1" align="left" valign="middle" bgcolor="#9e816e" colspan="4">
                            </td>
                        </tr>
                        <tr class="bodyheader">
                            <td height="18" align="left" bgcolor="#f3f3f3">
                                Warehouse Receipt No.</td>
                            <td align="left" bgcolor="#f3f3f3">
                                &nbsp;</td>
                            <td align="left" bgcolor="#f3f3f3" style="border-left: 1px solid #9e816e">
                                Ship Out No.
                            </td>
                            <td bgcolor="#f3f3f3">
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" class="bodycopy">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <asp:HiddenField ID="hSearchNum" runat="server" Value="" />
                                            <!--<input type="hidden" id="hSearchNum" name="hSearchNum" />-->
                                            <div id="lstSearchNumDiv">
                                            </div>
                                            <!--<input type="text"-->
                                            <asp:TextBox ID="lstSearchNum" runat="server" autocomplete="off" class="shorttextfield"
                                                Style="width: 106px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: Black"
                                                onkeyup=" searchNumFill(this,'lstSearchNumChange','');" onfocus="initializeJPEDField(this);"></asp:TextBox></td>
                                        <td style="width: 16px">
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                    </tr>
                                </table>
                            </td>
                            <td align="left" valign="top" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" class="bodycopy" style="border-left: 1px solid #9e816e">
                                <table border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td>
                                            <asp:HiddenField ID="hShipOut" runat="server" Value="" />
                                            <div id="lstShipOutDiv">
                                            </div>
                                            <!--<input type="text"-->
                                            <asp:TextBox ID="lstShipOut" runat="server" autocomplete="off" class="shorttextfield"
                                                Style="width: 106px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: Black"
                                                onkeyup=" searchNumFill2(this,'lstSearchNumChange2','');" onfocus="initializeJPEDField(this);"></asp:TextBox></td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll2('lstShipOut','lstSearchNumChange2',200);"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: pointer;" /></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr class="bodyheader">
                            <td height="18" align="left" bgcolor="#f3f3f3">
                                Customer Reference No.</td>
                            <td align="left" bgcolor="#f3f3f3">
                                P.O. No.</td>
                            <td align="left" bgcolor="#f3f3f3" style="border-left: 1px solid #9e816e; height: 18px;">
                                Customer Reference No.</td>
                            <td align="left" bgcolor="#f3f3f3">
                                P.O. No.
                            </td>
                        </tr>
                        <tr>
                            <td height="22" align="left" valign="middle">
                                <asp:TextBox ID="txtCustomerRef" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                            <td align="left" valign="middle" style="padding-right: 12px">
                                <asp:TextBox ID="txtPO" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                            <td align="left" valign="middle" style="border-left: 1px solid #9e816e">
                                <asp:TextBox ID="txtCustomerRef2" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                            <td align="left" valign="middle" style="padding-right: 12px">
                                <asp:TextBox ID="txtPO2" runat="server" CssClass="m_shorttextfield" Style="width: 120px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" bgcolor="#f3f3f3">
                                &nbsp;</td>
                            <td align="right" bgcolor="#f3f3f3">
                                &nbsp;</td>
                            <td align="right" bgcolor="#f3f3f3">
                                &nbsp;</td>
                            <td align="right" bgcolor="#f3f3f3" style="padding: 3px 32px 3px">
                                <asp:ImageButton ID="ImageButton4" runat="server" ImageUrl="../../Images/button_go.gif"
                                    OnClick="Page_Load"></asp:ImageButton></td>
                        </tr>
                    </table>
                    <br />
            </tr>
            <tr>
                <td align="left" valign="middle" style="height: 24px">
                </td>
                <td colspan="2" align="left" style="height: 24px">
                </td>
            </tr>
            <tr>
                <td align="left" bgcolor="#f3f3f3" class="bodyheader style1" style="padding-left: 10px">
                    <asp:LinkButton ID="LinkButton1" runat="server" Visible="False">LinkButton</asp:LinkButton>
                    <asp:LinkButton ID="LinkButton2" runat="server" Visible="False">LinkButton</asp:LinkButton></td>
            </tr>
            <tr>
                <td bgcolor="#f3f3f3" style="padding-left: 10px; height: 24px;">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="61%" style="height: 20px">
                                <asp:ImageButton ID="ExcelPrintButton" runat="server" ImageUrl="../../Images/button_exel.gif"
                                    OnClick="ExcelPrintButton_Click"></asp:ImageButton>
                                <asp:ImageButton ID="PDFPrintButton" runat="server" ImageUrl="../../Images/button_pdf.gif"
                                    OnClick="PDFPrintButton_Click" CssClass="marginleft"></asp:ImageButton>
                            </td>
                            <td width="39%" align="right" class="bodycopy" style="padding-right: 10px; height: 20px;">
                                <asp:TextBox ID="sortway" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                <asp:TextBox ID="sortway2" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                <asp:TextBox ID="sortwayB" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                <asp:TextBox ID="sortway2B" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" id="tableIN"
            style="border-right: 1px solid #9e816e; border-left: 1px solid #9e816e">
            <tr>
                <td width="100%" colspan="3" background="#ffffff">
                    <asp:GridView ID="GridView2" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                        OnPageIndexChanging="GridView2_PageIndexChanging" Width="100%" BorderWidth="0px"
                        BorderStyle="None" CellPadding="0">
                        <PagerSettings Position="Top" />
                        <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                            BackColor="White" ForeColor="Black" />
                        <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                        <RowStyle BackColor="White" BorderStyle="None" />
                        <AlternatingRowStyle BackColor="#F3F3F3" />
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <!-- list header -->
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td valign="middle" bgcolor="#f4e9e0" class="bodyheader style1" style="height: 20px;
                                                padding-left: 12px">
                                                WAREHOUSE IN
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="1" align="left" valign="middle" bgcolor="#9e816e">
                                            </td>
                                        </tr>
                                    </table>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr class="bodyheader" bgcolor="#f3f3f3">
                                            <td width="12" rowspan="2" align="left" height="13">
                                            </td>
                                            <td width="8%" rowspan="2" align="left">
                                                Received Date
                                                <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="Date_Click"
                                                    ID="WR_Sort1" /></td>
                                            <td width="8%" rowspan="2" align="left">
                                                W/R No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="WR_Click"
                                                    ID="Date_Sort1" /></td>
                                            <td width="19%" rowspan="2" align="left">
                                                Customer<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="customer_Click"
                                                    ID="customer_Sort1" /></td>
                                            <td width="10%" rowspan="2" align="left">
                                                Customer Ref No.</td>
                                            <td width="9%" rowspan="2" align="left">
                                                P.O. No.</td>
                                            <td width="19%" rowspan="2" align="left">
                                                Received From
                                            </td>
                                            <td width="19%" rowspan="2" align="left">
                                                Descriptions</td>
                                            <td width="7%" align="center" style="border-left: 1px solid #9e816e">
                                                NO. OF QTY</td>
                                        </tr>
                                        <tr class="bodyheader" bgcolor="#f3f3f3">
                                            <td width="7%" align="center" style="border-top: 1px solid #9e816e; border-left: 1px solid #9e816e"
                                                height="13">
                                                <span class="style3">Received</span></td>
                                        </tr>
                                        <tr>
                                            <td height="1" align="left" valign="middle" bgcolor="#9e816e" colspan="9">
                                            </td>
                                        </tr>
                                    </table>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <!-- list item -->
                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                        <tr id='Row<%# Eval("auto_uid").ToString() %>'>
                                            <td width="12" align="left" height="20">
                                                <input type="hidden" name="hWRNum" value="<%# Eval("wr_num").ToString() %>" />
                                                <input type="hidden" name="hWRValue" value="<%# Eval("auto_uid").ToString() %>" /></td>
                                            <td width="8%" align="left">
                                                <%# Eval("received_date","{0:d}").ToString() %>
                                            </td>
                                            <td width="8%" align="left" class="searchList">
                                                <a href="javascript:;" onclick="goWRScreen('<%# Eval("auto_uid").ToString() %>','<%# Eval("wr_num").ToString() %>')">
                                                    <%# Eval("wr_num").ToString() %>
                                                </a>
                                            </td>
                                            <td width="19%" align="left" class="searchList">
                                                <a href="javascript:;" onclick="goCustomerScreen('<%# Eval("customer_acct").ToString() %>')">
                                                    <%# Eval("customer_name").ToString() %>
                                                </a>
                                            </td>
                                            <td width="10%" align="left">
                                                <%# Eval("customer_ref_no").ToString() %>
                                            </td>
                                            <td width="9%" align="left">
                                                <%# Eval("PO_NO").ToString() %>
                                            </td>
                                            <td width="19%" align="left" class="searchList">
                                                <a href="javascript:;" onclick="goCustomerScreen('<%# Eval("shipper_acct").ToString() %>')">
                                                    <%# Eval("shipper_name").ToString() %>
                                                </a>
                                            </td>
                                            <td width="19%" align="left">
                                                <%# Eval("item_desc").ToString()%>
                                            </td>
                                            <td width="7%" align="right" style="padding-right: 10px" class="bodyheader">
                                                <%# Eval("item_piece_origin").ToString()%>
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
        </table>
        <table id="tableOUT" width="95%" border="0" align="center" cellpadding="0" cellspacing="0"
            style="border-right: 1px solid #9e816e; border-left: 1px solid #9e816e; border-bottom: 1px solid #9e816e">
            <tr>
                <td bgcolor="#ffffff" style="height: 1px">
                </td>
            </tr>
            <!-- test2-->
            <tr>
                <td align="left" valign="middle" bgcolor="#ffffff">
                    <asp:GridView ID="GridView5" runat="Server" AllowPaging="True" AutoGenerateColumns="False"
                        OnPageIndexChanging="GridView5_PageIndexChanging" Width="100%" BorderWidth="0px"
                        BorderStyle="None" CellPadding="0">
                        <PagerSettings Position="Top" />
                        <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                            BackColor="White" ForeColor="Black" />
                        <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                        <RowStyle BackColor="#F3F3F3" BorderStyle="None" />
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <!-- list header -->
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td bgcolor="#f4e9e0" class="bodyheader style1" style="padding-left: 12px; height: 20px;">
                                                WAREHOUSE IN
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="1" align="left" valign="middle" bgcolor="#9e816e">
                                            </td>
                                        </tr>
                                    </table>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr class="bodyheader" bgcolor="#f3f3f3">
                                            <td width="12" rowspan="2" align="left" height="13">
                                            </td>
                                            <td width="8%" rowspan="2" align="left">
                                                Received Date<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                    OnClick="Date_Click" ID="Date_Sort2" /></td>
                                            <td width="8%" rowspan="2" align="left">
                                                W/R No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="WR_Click"
                                                    ID="WR_Sort2" /></td>
                                            <td width="10%" rowspan="2" align="left">
                                                Customer Ref No.</td>
                                            <td width="9%" rowspan="2" align="left">
                                                P.O. No.</td>
                                            <td width="23%" rowspan="2" align="left">
                                                Received From
                                            </td>
                                            <td width="11%" rowspan="2" align="left">
                                                Storage Start Date</td>
                                            <td width="23%" rowspan="2" align="left">
                                                Descriptions</td>
                                            <td width="7%" align="center" style="border-left: 1px solid #9e816e">
                                                NO. OF QTY</td>
                                        </tr>
                                        <tr class="bodyheader" bgcolor="#f3f3f3">
                                            <td width="7%" align="center" style="border-top: 1px solid #9e816e; border-left: 1px solid #9e816e"
                                                height="13">
                                                <span class="style3">Received</span></td>
                                        </tr>
                                        <tr>
                                            <td height="1" align="left" valign="middle" bgcolor="#9e816e" colspan="9">
                                            </td>
                                        </tr>
                                    </table>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <table width="100%" id="ChildTable<%# Eval("row_index").ToString() %>">
                                        <tr>
                                            <td class="bodyheader" style="padding-left: 10px">
                                                <%# Eval("customer_name").ToString() %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:GridView ID="GridView6" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                    OnPageIndexChanging="GridView6_PageIndexChanging" Width="100%" BorderWidth="0px"
                                                    BorderStyle="None" CellPadding="0">
                                                    <PagerSettings Position="Top" />
                                                    <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                                                        BackColor="White" ForeColor="Black" />
                                                    <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                                                    <Columns>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <!-- list header -->
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <!-- list item -->
                                                                <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                                    <tr id='Row<%# Eval("auto_uid").ToString() %>'>
                                                                        <td width="12" align="left" height="20">
                                                                            <input type="hidden" name="hWRNum" value="<%# Eval("wr_num").ToString() %>" />
                                                                            <input type="hidden" name="hWRValue" value="<%# Eval("auto_uid").ToString() %>" />
                                                                            <!-- Eval("item_piece_origin-item_shipout").ToString() %>  -->
                                                                        </td>
                                                                        <td width="8%" align="left">
                                                                            <%# Eval("received_date","{0:d}").ToString() %>
                                                                        </td>
                                                                        <td width="8%" align="left" class="searchList">
                                                                            <a href="javascript:;" onclick="goWRScreen('<%# Eval("auto_uid").ToString() %>','<%# Eval("wr_num").ToString() %>')">
                                                                                <%# Eval("wr_num").ToString() %>
                                                                            </a>
                                                                        </td>
                                                                        <td width="10%" align="left">
                                                                            <%# Eval("customer_ref_no").ToString() %>
                                                                        </td>
                                                                        <td width="9%" align="left">
                                                                            <%# Eval("PO_NO").ToString() %>
                                                                        </td>
                                                                        <td width="23%" align="left" class="searchList">
                                                                            <a href="javascript:;" onclick="goCustomerScreen('<%# Eval("shipper_acct").ToString() %>')">
                                                                                <%# Eval("shipper_name").ToString() %>
                                                                            </a>
                                                                        </td>
                                                                        <td width="11%" align="left">
                                                                            <%# Eval("storage_date","{0:d}").ToString()%>
                                                                        </td>
                                                                        <td width="23%" align="left">
                                                                            <%# Eval("item_desc").ToString()%>
                                                                        </td>
                                                                        <td width="7%" align="right" style="padding-right: 10px" class="bodyheader">
                                                                            <%# Eval("item_piece_origin").ToString()%>
                                                                    </tr>
                                                                </table>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EditRowStyle BorderStyle="None" />
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td>
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                        <tr class="bodyheader" align="left">
                            <td width="68%" align="left" height="20">
                            </td>
                            <td width="18%" align="Right">
                            </td>
                            <td width="7%" align="right" style="padding-right: 10px">
                                <p>
                                    <asp:Label ID="label4" runat="server" /></p>
                            </td>
                            <td width="7%" align="right" style="padding-right: 10px" class="bodyheader">
                                <p>
                                    <asp:Label ID="label1" runat="server" /></p>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="left" valign="middle" bgcolor="#ffffff">
                    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                        OnPageIndexChanging="GridView1_PageIndexChanging" Width="100%" BorderWidth="0px"
                        BorderStyle="None" CellPadding="0">
                        <PagerSettings Position="Top" />
                        <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                            BackColor="White" ForeColor="Black" />
                        <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                        <RowStyle BackColor="White" BorderStyle="None" />
                        <AlternatingRowStyle BackColor="#F3F3F3" />
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <!-- list header -->
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td height="1" align="left" valign="middle" bgcolor="#9e816e">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="#f4e9e0" class="bodyheader style1" style="padding-left: 12px; height: 20px;">
                                                WAREHOUSE OUT
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="1" align="left" valign="middle" bgcolor="#9e816e">
                                            </td>
                                        </tr>
                                    </table>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr class="bodyheader" align="left" bgcolor="#f3f3f3">
                                            <td width="12" height="13" rowspan="2" align="left">
                                            </td>
                                            <td width="9%" rowspan="2" align="left">
                                                Ship Out Date<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                    OnClick="SODate_Click" ID="SODate_Sort1" /></td>
                                            <td width="9%" rowspan="2" align="left">
                                                Ship Out No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                    OnClick="SO_Click" ID="SO_Sort1" /></td>
                                            <td width="8%" rowspan="2" align="left">
                                                W/R No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="WR2_Click"
                                                    ID="WR_Sort3" /></td>
                                            <td width="21%" rowspan="2" align="left">
                                                Customer<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="SOcustomer_Click"
                                                    ID="customer_Sort2" /></td>
                                            <td width="9%" rowspan="2" align="left">
                                                Customer Ref No.</td>
                                            <td width="9%" rowspan="2" align="left">
                                                P.O NO.</td>
                                            <td width="22%" rowspan="2" align="left">
                                                Descriptions</td>
                                            <td colspan="2" align="center" style="border-left: 1px solid #9e816e">
                                                NO. OF QTY
                                            </td>
                                        </tr>
                                        <tr class="bodyheader" align="left" bgcolor="#f3f3f3">
                                            <td width="6%" align="center" style="border-left: 1px solid #9e816e; border-top: 1px solid #9e816e">
                                                Ship Out
                                            </td>
                                            <td width="6%" align="center" style="border-left: 1px solid #9e816e; border-top: 1px solid #9e816e">
                                                <span class="style1">On-Hand </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="1" align="left" valign="middle" bgcolor="#9e816e" colspan="13">
                                            </td>
                                        </tr>
                                    </table>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <!-- list item -->
                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                        <tr id='Row<%# Eval("auto_uid").ToString() %>'>
                                            <td width="12" align="left" height="20">
                                                <input type="hidden" name="hWRNum" value="<%# Eval("wr_num").ToString() %>" />
                                                <input type="hidden" name="hWRValue" value="<%# Eval("auto_uid").ToString() %>" />
                                                <!-- Eval("item_piece_origin-item_shipout").ToString() %>  -->
                                            </td>
                                            <td width="9%" align="left">
                                                <%# Eval("shipout_date","{0:d}").ToString() %>
                                            </td>
                                            <td width="9%" align="left" class="searchList">
                                                <a href="javascript:;" onclick="goSOScreen('<%# Eval("so_uid").ToString() %>','<%# Eval("so_no").ToString() %>')">
                                                    <%# Eval("so_no").ToString() %>
                                                </a>
                                            </td>
                                            <td width="8%" align="left" class="searchList">
                                                <a href="javascript:;" onclick="goWRScreen('<%# Eval("auto_uid").ToString() %>','<%# Eval("wr_num").ToString() %>')">
                                                    <%# Eval("wr_num").ToString() %>
                                                </a>
                                            </td>
                                            <td width="21%" align="left" class="searchList">
                                                <a href="javascript:;" onclick="goCustomerScreen('<%# Eval("customer_acct").ToString() %>')">
                                                    <%# Eval("customer_name").ToString() %>
                                                </a>
                                            </td>
                                            <td width="9%" align="left">
                                                <%# Eval("customer_ref").ToString() %>
                                            </td>
                                            <td width="9%" align="left">
                                                <%# Eval("PONO").ToString() %>
                                            </td>
                                            <td width="20%" align="left">
                                                <%# Eval("item_desc").ToString()%>
                                            </td>
                                            <td width="7%" align="right" class="bodyheader" style="padding-right: 6px">
                                                <%# Eval("item_shipout").ToString() %>
                                            </td>
                                            <td width="7%" align="right" style="padding-right: 6px">
                                                <%# Eval("item_remain").ToString()%>
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <!-- test -->
            <tr>
                <td align="left" valign="middle" bgcolor="#ffffff">
                    <asp:GridView ID="GridView3" runat="Server" AllowPaging="True" AutoGenerateColumns="False"
                        OnPageIndexChanging="GridView3_PageIndexChanging" Width="100%" BorderWidth="0px"
                        BorderStyle="None" CellPadding="0">
                        <PagerSettings Position="Top" />
                        <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                            BackColor="White" ForeColor="Black" />
                        <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                        <RowStyle BackColor="White" BorderStyle="None" />
                        <AlternatingRowStyle BackColor="#F3F3F3" />
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <!-- list header -->
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td height="1" align="left" valign="middle" bgcolor="#9e816e">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="#f4e9e0" class="bodyheader style1" style="padding-left: 12px; height: 20px;">
                                                WAREHOUSE OUT
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="1" align="left" valign="middle" bgcolor="#9e816e">
                                            </td>
                                        </tr>
                                    </table>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr class="bodyheader" align="left" bgcolor="#f3f3f3">
                                            <td width="12" height="13" rowspan="2" align="left">
                                            </td>
                                            <td width="9%" rowspan="2" align="left">
                                                Ship Out Date<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                    OnClick="SODate_Click" ID="SoDate_Sort2" /></td>
                                            <td width="9%" rowspan="2" align="left">
                                                Ship Out No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                    OnClick="SO_Click" ID="SO_Sort2" /></td>
                                            <td width="8%" rowspan="2" align="left">
                                                W/R No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="WR2_Click"
                                                    ID="WR_Sort4" /></td>
                                            <td width="9%" rowspan="2" align="left">
                                                Customer Ref No.</td>
                                            <td width="9%" rowspan="2" align="left">
                                                P.O NO.</td>
                                            <td width="21%" rowspan="2" align="left">
                                                Ship Out TO
                                            </td>
                                            <td width="22%" rowspan="2" align="left">
                                                Descriptions</td>
                                            <td colspan="2" align="center" style="border-left: 1px solid #9e816e">
                                                NO. OF QTY
                                            </td>
                                        </tr>
                                        <tr class="bodyheader" align="left" bgcolor="#f3f3f3">
                                            <td width="6%" align="center" style="border-left: 1px solid #9e816e; border-top: 1px solid #9e816e">
                                                Ship Out
                                            </td>
                                            <td width="6%" align="center" style="border-left: 1px solid #9e816e; border-top: 1px solid #9e816e">
                                                <span class="style1">On-Hand </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="1" align="left" valign="middle" bgcolor="#9e816e" colspan="13">
                                            </td>
                                        </tr>
                                    </table>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <table width="100%" id="ChildTable<%# Eval("row_index").ToString() %>">
                                        <tr>
                                            <td class="bodyheader" style="padding-left: 10px">
                                                <%# Eval("customer_name").ToString() %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:GridView ID="GridView4" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                    OnPageIndexChanging="GridView4_PageIndexChanging" Width="100%" BorderWidth="0px"
                                                    BorderStyle="None" CellPadding="0">
                                                    <PagerSettings Position="Top" />
                                                    <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                                                        BackColor="White" ForeColor="Black" />
                                                    <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                                                    <Columns>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <!-- list header -->
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <!-- list item -->
                                                                <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                                    <tr id='Row<%# Eval("auto_uid").ToString() %>'>
                                                                        <td width="12" align="left" height="20">
                                                                            <input type="hidden" name="hWRNum" value="<%# Eval("wr_num").ToString() %>" />
                                                                            <input type="hidden" name="hWRValue" value="<%# Eval("auto_uid").ToString() %>" />
                                                                            <!-- Eval("item_piece_origin-item_shipout").ToString() %>  -->
                                                                        </td>
                                                                        <td width="9%" align="left">
                                                                            <%# Eval("shipout_date","{0:d}").ToString() %>
                                                                        </td>
                                                                        <td width="9%" align="left" class="searchList">
                                                                            <a href="javascript:;" onclick="goSOScreen('<%# Eval("so_uid").ToString() %>','<%# Eval("so_no").ToString() %>')">
                                                                                <%# Eval("so_no").ToString() %>
                                                                            </a>
                                                                        </td>
                                                                        <td width="8%" align="left" class="searchList">
                                                                            <a href="javascript:;" onclick="goWRScreen('<%# Eval("auto_uid").ToString() %>','<%# Eval("wr_num").ToString() %>')">
                                                                                <%# Eval("wr_num").ToString() %>
                                                                            </a>
                                                                        </td>
                                                                        <td width="9%" align="left">
                                                                            <%# Eval("customer_ref").ToString() %>
                                                                        </td>
                                                                        <td width="9%" align="left">
                                                                            <%# Eval("PONO").ToString() %>
                                                                        </td>
                                                                        <td width="21%" align="left" class="searchList">
                                                                            <a href="javascript:;" onclick="goCustomerScreen('<%# Eval("shipout_acct").ToString() %>')">
                                                                                <%# Eval("shipout_name").ToString() %>
                                                                            </a>
                                                                        </td>
                                                                        <td width="20%" align="left">
                                                                            <%# Eval("item_desc").ToString()%>
                                                                        </td>
                                                                        <td width="7%" align="right" style="padding-right: 5px">
                                                                            <%# Eval("item_shipout").ToString() %>
                                                                        </td>
                                                                        <td width="7%" align="right" class="bodyheader" style="padding-right: 6px">
                                                                            <%# Eval("item_remain").ToString()%>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
            </tr>
            <tr>
                <td style="height: 22px">
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                        <tr class="bodyheader" align="left">
                            <td width="12" align="left" height="20">
                            </td>
                            <td width="61%" align="left" height="20">
                            </td>
                            <td width="21%" align="Right">
                            </td>
                            <td width="5%" align="right" height="20">
                                <p>
                                    <asp:Label ID="label3" runat="server" /></p>
                            </td>
                            <td width="6%" align="right" style="padding-right: 10px">
                                <p>
                                    <asp:Label ID="label2" runat="server" /></p>
                            </td>
                            <td width="7%" align="right" style="padding-right: 10px">
                                <p>
                                    <asp:Label ID="label5" runat="server" /></p>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br />
        <br />
        <p>
            <asp:Button ID="btnValidate" runat="server" Text="for Validation" Visible="False"></asp:Button><asp:LinkButton
                ID="LinkButton3" runat="server" Visible="False">LinkButton</asp:LinkButton><asp:TextBox
                    ID="txtNum" runat="server" Height="1px" Width="1px"></asp:TextBox><!-- end --></p>
        <igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="180px" Height="126px">
            <Layout CellPadding="0" FooterFormat="" NextMonthText="&gt;&gt;" PrevMonthText="&lt;&lt;"
                ShowFooter="False" ShowMonthDropDown="False" ShowYearDropDown="False" TitleFormat="Month">
                <DayStyle BackColor="White" CssClass="CalDay" />
                <SelectedDayStyle BackColor="#C5D5FC" CssClass="CalSelectedDay" />
                <OtherMonthDayStyle ForeColor="Silver" />
                <NextPrevStyle CssClass="NextPrevStyle" />
                <CalendarStyle CssClass="CalStyle" Height="126px" Width="180px">
                </CalendarStyle>
                <TodayDayStyle CssClass="CalToday" />
                <DayHeaderStyle CssClass="CalDayHeader" Font-Bold="False">
                    <BorderDetails StyleBottom="None" />
                </DayHeaderStyle>
                <TitleStyle CssClass="TitleStyle" Font-Bold="True" />
            </Layout>
        </igsch:WebCalendar>
    </form>
 
    <script type="text/javascript">
            if(document.getElementById('Webdatetimeedit2')) {

    			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1 Webdatetimeedit2");
            }
            else
            {

    			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1");            
            }

    </script>

</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
