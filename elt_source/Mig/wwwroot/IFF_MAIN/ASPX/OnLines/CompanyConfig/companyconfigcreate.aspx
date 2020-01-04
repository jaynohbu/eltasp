<% Response.Buffer = true; %>
<%@ Register Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>

<%@ Page CodeFile="CompanyConfigCreate.aspx.cs" CodePage="949" Inherits="IFF_MAIN.ASPX.OnLines.CompanyConfig.CompanyConfigCreate"
    Language="c#" %>

<%@ Register Assembly="iMoon.WebControls.ComboBox" Namespace="iMoon.WebControls"
    TagPrefix="iMoon" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title>Client/Partner Profile</title>
    <meta content="text/html; charset=euc-kr" http-equiv="Content-Type">
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <style type="text/css">
		.mouseOut{background:##f9f9ff; color:#000000;}
		.mouseOver{background:#ccccff; color:#000000;}
		 ul {list-style-type: none;margin-left:0px;padding-left:0px }
    </style>

    <script language="javascript">	
			
String.prototype.isInteger = function() {
var pattern = /^\d+$/;
return this != "" && pattern.test(this);
}

function goAddContact() {
    if ( !chkAccountNum() ) return false;
    
var param =  'Start=yes'+'&Num=' + document.CompanyCreate.txtAccountNumber.value + '&Name=' + encodeURIComponent(document.CompanyCreate.txtDBA.value); 
if ( document.CompanyCreate.dlCountry.value == 'US' )
{
    param += '&Mask=yes';
}
    popContact = showModalDialog("AddContact.asp?"+param,"AddContact","dialogWidth:950px; dialogHeight:600px; help:0; status:0; scroll:1;center:1;Sunken;");    
    return true;
}

function goRemarks() {
    if ( !chkAccountNum() ) return false;
    
var param =  'Start=yes'+'&Num=' + document.CompanyCreate.txtAccountNumber.value + '&Name=' + encodeURIComponent(document.CompanyCreate.txtDBA.value); 
 popRemarks = showModalDialog("AddRemarks.asp?"+param,"AddRemarks","dialogWidth:950px; dialogHeight:600px; help:0; status:0; scroll:0;center:1;Sunken;");    
    //window.open("AddRemarks.asp?"+param,"AddRemarks","dialogWidth:950px; dialogHeight:600px; help:0; status:0; scroll:1;center:1;Sunken;");
    return true;
}

function chkAccountNum()
{
var object = document.CompanyCreate.txtAccountNumber;
if (!eval("object.value.isInteger()")) {
	alert('Please select a company!');
	return false;
}
return true;
}


function goFocus() {

    if(event.keyCode == 13){
        document.CompanyCreate.Go.focus();
    }    
}

function goRateEdit() {

if ( !chkAccountNum() ) return false;

var tmpDBAText = document.CompanyCreate.txtDBA.value;
var indx1= tmpDBAText.indexOf('&');
if (indx1 > 0) 
{
   tmpDBAText = tmpDBAText.substring(0,indx1) + '^' +  tmpDBAText.substring(indx1+1);
}
var sURL = "../Rate/RateManagement.aspx?WindowName=PopWin&ff=" + document.CompanyCreate.txtAccountNumber.value + "&nn=" + tmpDBAText;

viewPop(sURL);

return true;

}

function goSc() {
if ( !chkAccountNum() ) return false;

var sURL = "../ScheduleB/ScheduleBCreate.aspx?WindowName=PopWin&ff=" + document.CompanyCreate.txtAccountNumber.value + "&nn=" + document.CompanyCreate.txtDBA.value;
viewPop(sURL);

return true;

}

function loadProfile(comboId) {

    var text  = document.getElementById( comboId + '_Text' );
    var combo = document.getElementById( comboId  );
    if( text ) {
        if(text.value=="") { 
//	        alert('Please input the search text.');
//	        return false; 
		__doPostBack("btnNew", "");   	
	        return false; 		

          }	    
	}
	else
	{
	        return false; 
	}
    
    var f = false;

    for(i = 0; i <= combo.options.length-1; i++) {
        if( text.value == combo.options[i].text) {
            document.getElementById( 'txtAccountNumber'  ).value = combo.options[i].value;
            document.getElementById( 'txtDBA'  ).value = combo.options[i].text;	
            text.value = '';    
            return true;
        }
	}
	
	if (f) {
	}
	else
	{
        goDupChk(text.value)
  	    return false;
	}
	
}

function goDupChk(strDBA) {
	if(strDBA =="" ) return true;	
	var WinWidth = 640;                                                                                     
	var WinHeight = 500;                                                                                    
	var x=screen.width/2-WinWidth/2;     
	var y=screen.height/2-WinHeight/2;
	var path='CompanyShowDialog.aspx'; 
	path +='?BusinessName='+ strDBA ; 
	path +='&chk=2'; 

	winopen = window.open(path,'popupN','left='+ x +',top='+ y +',width='+ WinWidth +', height='+ WinHeight +' , menubar=no, scrollbars=yes, staus=no, resizable=yes, titlebar=no, toolbar=no, hotkey=0,closeable=no');  
	winopen.focus();
	
}		

function goDupChk2(strDBA,AcctNum) {
	if(AcctNum =="") AcctNum = '-1';
	if(strDBA =="" ) return true;	
	var WinWidth = 640;                                                                                     
	var WinHeight = 500;                                                                                    
	var x=screen.width/2-WinWidth/2;     
	var y=screen.height/2-WinHeight/2;
	var path='CompanyShowDialog3.aspx'; 
	path +='?BusinessName='+ strDBA ; 
	path +='&AcctNum='+ AcctNum ; 
	path +='&chk=2'; 

	if(showModalDialog(path,'popupN','left='+ x +',top='+ y +',width='+ WinWidth +', height='+ WinHeight +' , menubar=no, scrollbars=no, staus=no, resizable=yes, titlebar=no, toolbar=no, hotkey=0,closeable=no') == 'Y') {
		return true;
	}
	else
	{
		return false;
	}		
}		


function formRest(idText) {

	if(idText == 'New') {
		document.CompanyCreate.reset();
	    document.CompanyCreate.txtSearchKey.value = '';		
		__doPostBack("btnNew", "");   
		return true;
	}
	else if(idText == 'Delete' ) {
		if(confirm('Do you really want to delete this client profile?')) {
		__doPostBack("btnDelete", "");   		
		}
		return true;
	}
	else if ( idText == 'Save' ) {
		if(!dataValidation()) return true;
//		if(!goDupChk2(document.CompanyCreate.txtDBA.value,document.CompanyCreate.txtAccountNumber.value)) return true;
		if(document.CompanyCreate.txtAccountNumber.value == "") 
		{ 
		__doPostBack("btnSaveNew", "");	
		}
		else
		{
		__doPostBack("btnSave", "");			
		}
	}	
	else if ( idText == 'Print' ) {
        print_client();	
//		__doPostBack("btnPrint", "");		
	}
	
	else if ( idText == 'SaveNew' ) {
//		if(!goDupChk2(document.CompanyCreate.txtDBA.value,document.CompanyCreate.txtAccountNumber.value)) return true;
		if(!dataValidation()) return true;
		__doPostBack("btnSaveNew", "");			
	}	
}

function print_client() {
var s = document.CompanyCreate.txtAccountNumber.value;
var a = '<%= elt_account_number %>';
if (s=='' || a=='') return false;
var Url = '/IFF_MAIN/ASP/master_data/clientProfile_pdf.asp?agent=' + a + '&client=' + s;
var saved_taraget = document.CompanyCreate.target;

jPopUpPDFc();
document.CompanyCreate.action=Url;
document.CompanyCreate.method="POST";
document.CompanyCreate.target="popUpPDF"
document.CompanyCreate.submit();
	
document.CompanyCreate.target = saved_taraget;
return false;

}
function jPopUpPDFc(){
var argS = 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1';
 popUpPDF = window.open('','popUpPDF', argS);
 }

function setCountry() {
 var s = document.CompanyCreate.dlState.value;
 
 if (s != "OT" && s.substring(0,2) != "  " ) {
	document.CompanyCreate.dlCountry.value = "US";
 }
 else
 {
	document.CompanyCreate.dlCountry.value = ""; 
 }
}		

function setCountry2() {

 var s = document.CompanyCreate.dlState2.value;
 if (s != "OT" && s.substring(0,2) != "  " ) {
	document.CompanyCreate.dlCountry2.value = "US";
 }		
 else
 {
	document.CompanyCreate.dlCountry2.value = ""; 
 }

}		

		

function goUrl() {
	var txtUrl = document.CompanyCreate.txtBURL.value;

	if(txtUrl != "") {
		window.open(txtUrl);
	}
	
}

function goEmail() {
	var txtEmail = document.CompanyCreate.txtCEmail.value;
	if(validateEmail(txtEmail)) {
		if(txtEmail != "") {
			parent.location.href='mailto:'+txtEmail;
		}							 
	}
}

function validateEmail(emailad) {

var exclude=/[^@\-\.\w]|^[_@\.\-]|[\._\-]{2}|[@\.]{2}|(@)[^@]*\1/;
var check=/@[\w\-]+\./;
var checkend=/\.[a-zA-Z]{2,3}$/;

	if(((emailad.search(exclude) != -1)||(emailad.search(check)) == -1)||(emailad.search(checkend) == -1)){
		alert("Incorrect email address");
		return false;
	}
	return true;
}

function setBillAddr() {
if(document.CompanyCreate.chkCopy.checked) {
	document.CompanyCreate.txtCAddress.value = document.CompanyCreate.txtBAdress.value;
	document.CompanyCreate.txtCCity.value = document.CompanyCreate.txtBCity.value;
	document.CompanyCreate.dlState2.value = document.CompanyCreate.dlState.value;
	document.CompanyCreate.txtBCZIP.value = document.CompanyCreate.txtBZIP.value; 
	document.CompanyCreate.dlCountry2.value = document.CompanyCreate.dlCountry.value; 
}

}

function dataValidation() {
//if(document.CompanyCreate.chkColodee.checked) {
//	if(document.CompanyCreate.dlColodee.selectedindex=0) {
//		alert('Please select colodee!');
//		return false;
//	}
//}

if (document.CompanyCreate.dlColodee.value != "" && document.CompanyCreate.txtAgent_elt_acct.value != "")
{
    if(document.CompanyCreate.dlColodee.value == document.CompanyCreate.txtAgent_elt_acct.value)
    {
    	alert('Please select another Coloadee!');
		document.CompanyCreate.dlColodee.focus();
		return false;
	}
}

if(document.CompanyCreate.chkColodee.checked || document.CompanyCreate.chkEDT.checked) {
	if(document.CompanyCreate.txtAgent_elt_acct.value == "") {
		alert('Please enter the Agent Acct. No.\n for Colodee and/or EDT!');
		document.CompanyCreate.txtAgent_elt_acct.focus();
		return false;
	}
}

var object = document.CompanyCreate.txtCHLNo;
if(object.value != "" && object.value != " ") {
	if (!eval("object.value.isInteger()")) {
						alert("Please enter a numeric value for C.H.L No." );
						object.focus();
						return false;
					}
}

//object = document.CompanyCreate.txtCarrierPrefix; 
//if(object.value != "" && object.value != " ") {
//if (!eval("object.value.isInteger()")) {
//						alert("Please enter a numeric value for Prefix" );
//						object.focus();
//						return false;						
//					}
//}
if(document.CompanyCreate.txtDBA.value=="") {
	alert("Please enter a business name!");
	return false;
}

//	if(document.CompanyCreate.chkTrucker.checked) {
//		if(document.CompanyCreate.txtCHLNo.value=="") {
//			alert("Please input the C.H.L number");
//			return false;
//		}
//	}
//	if(document.CompanyCreate.chkWarehousing.checked) {
//		if(document.CompanyCreate.txtCHLNo.value=="") {
//			alert("Please input the C.H.L number");
//			return false;
//		}
//	}
//	if(document.CompanyCreate.chkCFS.checked) {
//		if(document.CompanyCreate.txtFirmsCode.value=="") {
//			alert("Please input the Firms code");
//			return false;
//		}
//	}
	
	if(document.CompanyCreate.chkCarrier.checked) {
//		if(document.CompanyCreate.txtFirmsCode.value=="") {
//			alert("Please input the Firms code");
//			return false;
//		}		

        
		if(document.CompanyCreate.txtOceanSCAC.value=="" && document.CompanyCreate.txtAirLineCode.value=="") {
			alert("Please input the SCAC code or Air Line Code");
			return false;
		}
		else
		{
            if (document.CompanyCreate.txtAirLineCode.value!=""	&& document.CompanyCreate.txtCarrierPrefix.value==""){	
			alert("Please input the Carrier prefix.");
			return false;
			}		
		}	
	}

return true;

}

function ComboSearchKey_OnChangePlus() {
    return false;
var oSelect = document.getElementById( 'ComboSearchKey' );
        var text  = oSelect.value;
        if (text!="")
        {
	    document.CompanyCreate.ComboSearchKey_Text.value = "";
        document.CompanyCreate.txtAccountNumber.value = text;
		__doPostBack("Go", "");   	
		}

}

    </script>

    <link href="../../CSS/AppStyle.css" rel="stylesheet" type="text/css">
    <!--  #INCLUDE FILE="../../include/common.htm" -->
    <style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style4 {
	color: #c16b42;
	font-size: 9px;
	font-weight: bold;
}
-->
    </style>
</head>

<script language="javascript">
function view_layer(name,t) { 
	var obj=document.all[name];
if (!obj) return;	
	var mObj=document.all['wPri'];	
	var bObj=document.all['bToggle'];
	var sObj=document.getElementById( 'lblStatus' );
    var eObj=document.getElementById( 'addBtn' );
	
	var _tmpx,_tmpy, marginx, marginy;
	
	_tmpx = parseInt(mObj.offsetLeft);
	_tmpy = parseInt(mObj.offsetTop) + parseInt(mObj.offsetHeight);
	
	obj.style.posLeft=_tmpx;
	obj.style.posTop=_tmpy - 1;
	
	wstatus = obj.style.display;

    if (t)
    {
	    if(wstatus=='block') {
		    wstatus='none';
		    bObj.src = '/iff_main/Images/expand.gif';
	    }else{
		    wstatus='block';
		    bObj.src = '/iff_main/Images/collapse.gif';
	    }
	}
    else
    {
    	obj.style.display='block';  
    }	
    
	obj.style.display=wstatus;
	sObj.value = wstatus;
	

if(sObj.value != obj.style.display) 
{
    view_layer('wAdd',true);
}
    eObj.style.posLeft=obj.style.posLeft;
    eObj.style.posTop= _tmpy + parseInt(obj.offsetHeight) + 1;
}

</script>

<% Response.Flush(); %>
<body onResize="javascript:view_layer('wAdd',false);">
<!-- pointer disabled    
	<table border="0" cellpadding="0" cellspacing="0" height="12" width="100%">
        <tr>
            <td align="center" valign="top">
                <img height="3" src="../../../images/spacer.gif" width="120"><%	
                        if(Request.UrlReferrer != null && windowName != "PopWin" && windowName != "popupfavorite") 
                        { 
                %><img height="7" src="../../../Images/pointer_md.gif" width="11"><% } %><img height="3"
                    src="../../../images/spacer.gif" width="300"></td>
        </tr>
    </table>
	-->
    <form id="CompanyCreate" runat="server" method="post" onSubmit="">
        <table align="center" border="0" cellpadding="2" cellspacing="0" width="95%">
            <tr>
                <td align="left" class="pageheader" height="32" valign="middle">
                    Client/Partner Profile</td>
            </tr>
        </table>
        <!--
        <table align="center" bgcolor="#FF0000" border="0" bordercolor="73beb6" cellpadding="0"
            cellspacing="0" class="border1px" width="957">
            <tr bgcolor="73beb6">
                <td align="center" bgcolor="73beb6" height="0" valign="top" width="0">
-->
        <table id="wPri" align="center" bgcolor="#FF0000" border="0" bordercolor="73beb6"
            cellpadding="0" cellspacing="0" class="border1px" width="95%">
            <tr bgcolor="C7C6E1">
                <td align="center" bgcolor="#ccebed" colspan="7" height="22" valign="middle">
                    <img alt="Save" name='bSave' onClick="javascript:formRest('Save');" src='/IFF_MAIN/images/button_save_medium.gif'
                        style="cursor: hand">&nbsp;</td>
            </tr>
            <tr bgcolor="#73beb6">
                <td align="right" colspan="7" style="height: 1px" valign="top">
                </td>
            </tr>
            <tr align="left" bgcolor="DDDDED">
                <td bgcolor="#ecf7f8" style="height: 36px; width: 6px;" valign="middle" width="6">&nbsp;
                    
                </td>
                <td align="left" bgcolor="#ecf7f8" class="bodyheader" colspan="2" style="height: 36px"
                    valign="middle">
                    <table align="left" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td align="left" class="bodyheader">
                                Client/Partner Name</td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <iMoon:ComboBox ID="ComboSearchKey" runat="server" CssClass="ComboBox" Rows="20"
                                    Width="300px">
                                    <asp:ListItem>Unbound</asp:ListItem>
                                </iMoon:ComboBox>
                            </td>
                            <td align="left" valign="middle">
                                <asp:Button ID="Go" runat="server" CssClass="formbody" OnClick="Go_Click" Text="Go" />
                            </td>
                        </tr>
                    </table>
                </td>
                <td align="left" bgcolor="#ecf7f8" class="bodycopy" colspan="2" style="height: 36px"
                    valign="middle">
                    <table align="left" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="width: 5px; height: 13px">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblError" runat="server" CssClass="bodycopy" ForeColor="Red"></asp:Label></td>
                            <td align="left" style="width: 5px" valign="middle">&nbsp;
                                
                            </td>
                        </tr>
                    </table>
                </td>
                <td align="right" bgcolor="#ecf7f8" class="bodycopy" colspan="2" style="height: 36px"
                    valign="middle">
                    <% if (strMode == "1" || strMode == "2" || strMode == "3") { %>
                    <img alt="New" name='bNew' onClick="javascript:formRest('New');" src='/IFF_MAIN/images/button_new.gif'
                        style="cursor: hand">
                    <% Response.Write("&nbsp; &nbsp; &nbsp;&nbsp;");} %>
                    <% if (strMode == "3") { %>
                    <img alt="Print" name='bPrint' onClick="javascript:formRest('Print');" src='/IFF_MAIN/images/button_print.gif'
                        style="cursor: hand">
                    <% Response.Write("&nbsp; &nbsp; &nbsp;&nbsp;");} %>
                    <% if (strMode == "3") { %>
                    <img alt="Delete" name='bDelete' onClick="javascript:formRest('Delete');" src='/IFF_MAIN/images/button_delete_medium.gif'
                        style="cursor: hand">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <% } %>
            </tr>
            <tr bgcolor="#73beb6">
                <td align="left" colspan="7" style="height: 2px" valign="top">
                </td>
            </tr>
            <tr align="left" bgcolor="#DDDDED">
                <td bgcolor="#ecf7f8" height="20" style="width: 6px" valign="middle">&nbsp;
                    
                </td>
                <td bgcolor="#ecf7f8" class="bodyheader" colspan="2" valign="middle">
                    General Information</td>
                <td bgcolor="#ecf7f8" class="bodyheader" style="width: 152px" valign="middle" width="152">&nbsp;
                    
                </td>
                <td bgcolor="#ecf7f8" class="bodyheader" style="width: 211px" valign="middle" width="211">
                    &nbsp;
                    <asp:TextBox ID="txtSearchKey" runat="server" CssClass="m_shorttextfield" onkeydown="javascript:goFocus();"
                        Width="0px"></asp:TextBox></td>
                <td bgcolor="#ecf7f8" class="bodyheader" style="width: 104px" valign="middle" width="104">&nbsp;
                    
                </td>
                <td bgcolor="#ecf7f8" class="bodyheader" valign="middle" width="254">&nbsp;
                    
                </td>
            </tr>
            <tr align="left" bgcolor="#F3f3f3">
                <td bgcolor="#FFFFFF" style="height: 22px; width: 6px;" valign="middle">&nbsp;
                    
                </td>
                <td bgcolor="#FFFFFF" class="bodycopy" style="height: 22px" valign="middle" width="75">
                    Name(DBA)</td>
                <td bgcolor="#FFFFFF" class="bodycopy" style="width: 264px; height: 22px;" valign="middle"
                    width="264">
                    <asp:TextBox ID="txtDBA" runat="server" CssClass="m_shorttextfield" designtimedragdrop="1163"
                        Width="170px"></asp:TextBox>
                    <asp:CheckBox ID="chkActivate" runat="server" CssClass="bodycopy" designtimedragdrop="74"
                        ForeColor="red" Text="Active" /></td>
                <td bgcolor="#FFFFFF" class="bodycopy" style="width: 152px; height: 22px;" valign="middle">
                    Legal Name</td>
                <td bgcolor="#FFFFFF" class="bodycopy" style="width: 211px; height: 22px;" valign="middle">
                    <asp:TextBox ID="txtBName" runat="server" CssClass="m_shorttextfield" designtimedragdrop="776"
                        Width="170px"></asp:TextBox>
                </td>
                <td bgcolor="#FFFFFF" class="bodycopy" style="width: 104px; height: 22px;" valign="middle">
                    Tax ID/USPPI</td>
                <td bgcolor="#FFFFFF" style="height: 22px" valign="middle">
                    <asp:TextBox ID="txtTAXID" runat="server" CssClass="m_shorttextfield" designtimedragdrop="60"
                        Width="130px"></asp:TextBox>
                </td>
            </tr>
            <tr align="left" bgcolor="#FFFFFF">
                <td bgcolor="#F3f3f3" height="22" style="width: 6px" valign="middle">&nbsp;
                    
                </td>
                <td bgcolor="#F3f3f3" class="bodycopy" valign="middle">
                    Address</td>
                <td bgcolor="#F3f3f3" class="bodycopy" style="width: 264px" valign="middle">
                    <asp:TextBox ID="txtBAdress" runat="server" CssClass="m_shorttextfield" Width="170px"></asp:TextBox>
                </td>
                <td bgcolor="#F3f3f3" class="bodycopy" style="width: 152px" valign="middle">
                    City</td>
                <td bgcolor="#F3f3f3" class="bodycopy" style="width: 211px" valign="middle">
                    <asp:TextBox ID="txtBCity" runat="server" CssClass="m_shorttextfield" Width="160px"></asp:TextBox></td>
                <td bgcolor="#F3f3f3" class="bodycopy" style="width: 104px" valign="middle">
                    State/Province</td>
                <td bgcolor="#F3f3f3" valign="middle">
                    <asp:DropDownList ID="dlState" runat="server" CssClass="smallselect">
                    </asp:DropDownList></td>
            </tr>
            <tr align="left" bgcolor="#F3f3f3">
                <td bgcolor="#FFFFFF" height="22" style="width: 6px" valign="middle">&nbsp;
                    
                </td>
                <td bgcolor="#FFFFFF" class="bodycopy" valign="middle">
                    Zip/Postal
                </td>
                <td bgcolor="#FFFFFF" class="bodycopy" style="width: 264px" valign="middle">
                    <asp:TextBox ID="txtBZIP" runat="server" class="m_shorttextfield" CssClass="m_shorttextfield"
                        Width="80px"></asp:TextBox>
                </td>
                <td bgcolor="#FFFFFF" class="bodycopy" style="width: 152px" valign="middle">
                    Country</td>
                <td bgcolor="#FFFFFF" class="bodycopy" style="width: 211px" valign="middle">
                    <asp:DropDownList ID="dlCountry" runat="server" CssClass="smallselect" Width="160px">
                    </asp:DropDownList></td>
                <td bgcolor="#FFFFFF" class="bodycopy" style="width: 104px" valign="middle">
                    Website</td>
                <td bgcolor="#FFFFFF" valign="middle">
                    <asp:TextBox ID="txtBURL" runat="server" CssClass="m_shorttextfield" Width="130px"></asp:TextBox>
                    <input id="btnUrl" class="bodycopy" onClick="javascript:goUrl();" style="width: 40px;
                        background-color: #e0e0e0" tabindex="1" type="button" value="URL"></td>
            </tr>
            <tr bgcolor="#73beb6">
                <td align="left" colspan="7" height="1" valign="top">
                </td>
            </tr>
            <tr>
                <td bgcolor="#ecf7f8" style="width: 6px">&nbsp;
                    
                </td>
                <td bgcolor="#ecf7f8" class="bodyheader" colspan="6" height="20">
                    <span>
                        <asp:Label ID="Label5" runat="server" CssClass="bodyheader"> Business Type</asp:Label>
                    </span>
                </td>
            </tr>
            <tr align="left" bgcolor="#ffffff">
                <td colspan="4" style="height: 15px" valign="middle">
                    <table border="0" cellpadding="0" cellspacing="0" width="418">
                        <tr>
                            <td align="left" class="bodycopy" height="24" valign="middle">
                                <asp:CheckBox ID="chkConsignee" runat="server" Text="Consignee" /></td>
                            <td align="left" class="bodycopy" valign="middle">
                                <asp:CheckBox ID="chkShipper" runat="server" Text="Shipper" /></td>
                            <td align="left" class="bodycopy" valign="middle">
                                <asp:CheckBox ID="chkForwarder" runat="server" Text="Agent" /></td>
                            <td align="left" class="bodycopy" valign="middle">
                                <asp:CheckBox ID="chkCarrier" runat="server" Text="Carrier" /></td>
                            <td align="left" class="bodycopy" valign="middle">
                                <asp:CheckBox ID="chkTrucker" runat="server" Text="Trucker" /></td>
                        </tr>
                        <tr>
                            <td align="left" class="bodycopy" style="height: 24px" valign="middle">
                                <asp:CheckBox ID="chkWarehousing" runat="server" Text="Warehouse" /></td>
                            <td align="left" class="bodycopy" style="height: 24px" valign="middle">
                                <asp:CheckBox ID="chkCFS" runat="server" Text="Terminal/CFS" /></td>
                            <td align="left" class="bodycopy" style="height: 24px" valign="middle">
                                <asp:CheckBox ID="chkBroker" runat="server" Text="CHB" /></td>
                            <td align="left" class="bodycopy" style="height: 24px" valign="middle">
                                <asp:CheckBox ID="chkGovt" runat="server" Text="Gov't" /></td>
                            <td align="left" class="bodycopy" style="height: 24px" valign="middle">
                                <asp:CheckBox ID="chkSpecial" runat="server" Text="Other" /></td>
                        </tr>
                    </table>
                </td>
                <td class="bodycopy" colspan="3" style="height: 15px" valign="middle">
                    <input id="btnRateEdit" class="bodycopy" onClick="return goRateEdit();" style="width: 110px;
                        background-color: #E0E0E0" type="button" value="AE Rate Manager">
                    <input id="btnScheduleB" class="bodycopy" onClick="return goSc();" style="width: 70px;
                        background-color: #E0E0E0" type="button" value="Schedule B"></td>
            </tr>
            <tr align="left" bgcolor="#F3f3f3">
                <td style="height: 22px; width: 6px;" valign="middle">&nbsp;
                    
                </td>
                <td class="bodycopy" style="height: 22px" valign="middle">
                    C.H.L No.</td>
                <td class="bodycopy" style="height: 22px; width: 264px;" valign="middle">
                    <asp:TextBox ID="txtCHLNo" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
                <td class="bodycopy" style="height: 22px; width: 152px;" valign="middle">
                    Firms Code</td>
                <td class="bodycopy" style="height: 22px; width: 211px;" valign="middle">
                    <asp:TextBox ID="txtFirmsCode" runat="server" CssClass="m_shorttextfield" designtimedragdrop="5093"></asp:TextBox></td>
                <td class="bodycopy" style="height: 22px; width: 104px;" valign="middle">
                    SCAC Code</td>
                <td class="bodycopy" style="height: 22px" valign="middle">
                    <asp:TextBox ID="txtOceanSCAC" runat="server" CssClass="m_shorttextfield" designtimedragdrop="5099"
                        MaxLength="4" Width="130px"></asp:TextBox></td>
            </tr>
            <tr align="left" bgcolor="#ffffff">
                <td style="width: 6px" valign="middle">&nbsp;
                    
                </td>
                <td class="bodycopy" valign="middle">
                    Air Line Code</td>
                <td class="bodycopy" style="width: 264px;" valign="middle">
                    <asp:TextBox ID="txtAirLineCode" runat="server" CssClass="m_shorttextfield" designtimedragdrop="5099"
                        MaxLength="2"></asp:TextBox>
                </td>
                <td class="bodycopy" style="width: 152px;" valign="middle">
                    Prefix</td>
                <td class="bodycopy" style="width: 211px;" valign="middle">
                    <asp:TextBox ID="txtCarrierPrefix" runat="server" CssClass="m_shorttextfield" designtimedragdrop="2265"
                        MaxLength="3" Width="50px"></asp:TextBox>
                </td>
                <td class="bodycopy" style="width: 104px;" valign="middle">
                    Agent Acct. No.
                </td>
                <td valign="middle">
                    <asp:TextBox ID="txtAgent_elt_acct" runat="server" BorderStyle="Inset" BorderWidth="1px"
                        designtimedragdrop="1475" MaxLength="8" Style="behavior: url(../../Include/igNumChkLeft.htc)"
                        Width="100px"></asp:TextBox>&nbsp;</td>
            </tr>
            <tr align="left" bgcolor="#F3f3f3">
                <td style="width: 6px;" valign="middle">&nbsp;
                    
                </td>
                <td class="bodycopy" valign="middle">
                    Coloadee List</td>
                <td lass="bodycopy" style="width: 264px;" valign="middle">
                    <asp:DropDownList ID="dlColodee" runat="server" CssClass="smallselect" designtimedragdrop="2277"
                        EnableViewState="False">
                    </asp:DropDownList></td>
                <td class="bodycopy" style="width: 152px;" valign="middle">
                    <asp:CheckBox ID="chkColodee" runat="server" Text="Colodee" /></td>
                <td class="bodycopy" style="width: 211px;" valign="middle">&nbsp;
                    
                </td>
                <td style="width: 104px;" valign="middle">&nbsp;
                    
                </td>
                <td valign="middle">
                    <asp:CheckBox ID="chkEDT" runat="server" CssClass="bodycopy" designtimedragdrop="260"
                        ForeColor="Black" Text="Enable EDT" /></td>
            </tr>
            <tr bgcolor="#73beb6">
                <td align="left" colspan="7" style="height: 2px" valign="top">
                </td>
            </tr>
            <tr align="left" bgcolor="#ccebed">
                <td>
                </td>
                <td align="left" bgcolor="#ccebed" class="bodycopy" colspan="6" height="20" valign="middle">
                    <span class="style4">ADDITIONAL INFORMATION &nbsp;&nbsp;</span><img id='bToggle'
                        alt="Expand/Collapse" height="7" onClick="javascript:view_layer('wAdd',true);"
                        src='/iff_main/Images/collapse.gif' style="cursor: hand" width="10"></td>
            </tr>
        </table>
        <!-- Start of Additional -->
        <div id="wAdd" style="display: none; position: absolute; top: 418px; left: 32px;
            width: 95%">
            <table align="center" border="0" bordercolor="73beb6" cellpadding="0" cellspacing="0"
                class="border1px" style="height: 1px" width="100%">
                <tr>
                    <td bgcolor="#ecf7f8" style="width: 14px">&nbsp;
                        
                    </td>
                    <td bgcolor="#ecf7f8" class="bodyheader" colspan="6" height="20" valign="middle">
                        Contact Information
                    </td>
                </tr>
                <tr>
                    <td bgcolor="#ffffff" style="width: 14px">&nbsp;
                        
                    </td>
                    <td bgcolor="#ffffff" class="bodycopy" valign="middle" width="75">
                        Primary Contact</td>
                    <td bgcolor="#ffffff" class="bodycopy" style="width: 264px;" valign="middle">
                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                            <tr>
                                <td class="bodycopy">
                                    First Name
                                </td>
                                <td class="bodycopy">
                                    M.I.</td>
                                <td class="bodycopy">
                                    Last Name
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtBCFName" runat="server" CssClass="m_shorttextfield" Width="70px"></asp:TextBox></td>
                                <td>
                                    <asp:TextBox ID="txtBCMName" runat="server" CssClass="m_shorttextfield" Width="30px"></asp:TextBox></td>
                                <td>
                                    <asp:TextBox ID="txtBCLName" runat="server" CssClass="m_shorttextfield" Width="70px"></asp:TextBox></td>
                            </tr>
                        </table>
                    </td>
                    <td bgcolor="#ffffff" class="bodycopy" style="width: 152px;" valign="middle">
                        Phone</td>
                    <td bgcolor="#ffffff" class="bodyheader" style="width: 211px;" valign="middle">
                        <asp:TextBox ID="txtBPhone" runat="server" CssClass="m_shorttextfield" Width="100px"></asp:TextBox>
                    </td>
                    <td bgcolor="#ffffff" class="bodycopy" style="width: 104px;" valign="middle">
                        Fax</td>
                    <td bgcolor="#ffffff" class="bodyheader" valign="middle" style="width: 167px">
                        <asp:TextBox ID="txtBFax" runat="server" CssClass="m_shorttextfield" Width="130px"></asp:TextBox>
                    </td>
                </tr>
                <tr align="left" bgcolor="#F3f3f3">
                    <td bgcolor="#F3f3f3" valign="middle" style="width: 14px">&nbsp;
                        
                    </td>
                    <td bgcolor="#F3f3f3" class="bodycopy" valign="middle" width="75">
                        Cell</td>
                    <td bgcolor="#F3f3f3" class="bodycopy" style="width: 264px;" valign="middle">
                        <asp:TextBox ID="txtCPhone" runat="server" CssClass="m_shorttextfield" Width="160px"></asp:TextBox>
                    </td>
                    <td bgcolor="#F3f3f3" class="bodycopy" style="width: 152px;" valign="middle">
                        E-mail</td>
                    <td bgcolor="#F3f3f3" class="bodycopy" style="width: 211px;" valign="middle">
                        <asp:TextBox ID="txtCEmail" runat="server" CssClass="m_shorttextfield" Width="160px"></asp:TextBox>
                        <input id="btnEmail" class="bodycopy" designtimedragdrop="2075" onClick="javascript:goEmail();"
                            style="width: 40px; background-color: #cccccc" type="button" value="Email"></td>
                    <td bgcolor="#f3f3f3" style="width: 104px;" valign="middle">&nbsp;
                        
                    </td>
                    <td bgcolor="#f3f3f3" valign="middle" style="width: 167px">&nbsp;
                        
                    </td>
                </tr>
                <tr bgcolor="#73beb6">
                    <td align="left" colspan="7" style="height: 1px" valign="top">
                    </td>
                </tr>
                <tr>
                    <td bgcolor="#ecf7f8" valign="middle" style="width: 14px">&nbsp;
                        
                    </td>
                    <td align="left" bgcolor="#ecf7f8" colspan="6" height="20" valign="middle">
                        <asp:Label ID="Label2" runat="server" CssClass="bodyheader"> Billing Information</asp:Label>&nbsp;&nbsp;&nbsp;
                        <asp:CheckBox ID="chkCopy" runat="server" CssClass="bodycopy" Text="Same As Above" /></td>
                </tr>
                <tr align="left" bgcolor="#Ffffff">
                    <td height="22" valign="middle" style="width: 14px">&nbsp;
                        
                    </td>
                    <td class="bodycopy" valign="middle" width="75">
                        Address</td>
                    <td class="bodycopy" style="width: 264px" valign="middle">
                        <asp:TextBox ID="txtCAddress" runat="server" CssClass="m_shorttextfield" Width="200px">
                        </asp:TextBox></td>
                    <td class="bodycopy" style="width: 152px" valign="middle">
                        City</td>
                    <td class="bodycopy" style="width: 211px" valign="middle">
                        <asp:TextBox ID="txtCCity" runat="server" CssClass="m_shorttextfield"></asp:TextBox></td>
                    <td class="bodycopy" style="width: 104px" valign="middle">
                        State/Province</td>
                    <td class="bodycopy" valign="middle" style="width: 167px">
                        <asp:DropDownList ID="dlState2" runat="server" CssClass="smallselect" Width="120">
                        </asp:DropDownList></td>
                </tr>
                <tr align="left" bgcolor="#F3f3f3">
                    <td height="22" valign="middle" style="width: 14px">&nbsp;
                        
                    </td>
                    <td class="bodycopy" valign="middle" width="75">
                        Zip/Postal
                    </td>
                    <td class="bodycopy" style="width: 264px" valign="middle">
                        <asp:TextBox ID="txtBCZIP" runat="server" class="m_shorttextfield" CssClass="m_shorttextfield"
                            Width="80px"></asp:TextBox></td>
                    <td class="bodycopy" style="width: 152px" valign="middle">
                        Country</td>
                    <td class="bodycopy" style="width: 211px" valign="middle">
                        <asp:DropDownList ID="dlCountry2" runat="server" CssClass="smallselect" Width="120px">
                        </asp:DropDownList></td>
                    <td style="width: 104px" valign="middle">&nbsp;
                        
                    </td>
                    <td valign="middle" style="width: 167px">&nbsp;
                        
                    </td>
                </tr>
                <tr align="left" bgcolor="#Ffffff">
                    <td height="22" valign="middle" style="width: 14px">&nbsp;
                        
                    </td>
                    <td class="bodycopy" valign="middle" width="75">
                        Invoice Term</td>
                    <td class="bodycopy" style="width: 264px" valign="middle">
                        <asp:TextBox ID="txtInvoiceTerm" runat="server" CssClass="m_shorttextfield" Style="behavior: url(../../Include/igNumChkLeft.htc)"
                            Width="70px"></asp:TextBox></td>
                    <td class="bodycopy" style="width: 152px" valign="middle">
                        I/V ATTN. ( ATTN. :)</td>
                    <td class="bodycopy" style="width: 211px" valign="middle">
                        <asp:TextBox ID="txtz_attn_txt" runat="server" CssClass="m_shorttextfield" Width="160px"></asp:TextBox></td>
                    <td class="bodycopy" style="width: 104px" valign="middle">
                        Credit Amount</td>
                    <td class="bodycopy" valign="middle" style="width: 167px">
                        <igtxt:WebNumericEdit ID="txtCreditAmount" runat="server" CssClass="shorttextfield"
                            MinDecimalPlaces="Two" Width="100px">
                        </igtxt:WebNumericEdit>
                    </td>
                </tr>
                <tr bgcolor="#73beb6">
                    <td align="left" colspan="7" height="1" valign="top">
                    </td>
                </tr>
                <tr>
                    <td bgcolor="#ecf7f8" style="height: 20px; width: 14px;">&nbsp;
                        
                    </td>
                    <td bgcolor="#ecf7f8" class="bodyheader" colspan="6" height="20px" style="height: 12px"
                        valign="middle">
                        <asp:Label ID="Label4" runat="server" CssClass="bodyheader" designtimedragdrop="4548"
                            Width="100%"> Other Information</asp:Label></td>
                </tr>
                <tr align="left" bgcolor="#Ffffff">
                    <td height="22" valign="middle" style="width: 14px">&nbsp;
                        
                    </td>
                    <td class="bodycopy" valign="middle" width="75">
                        Bond No.</td>
                    <td class="bodycopy" style="width: 264px" valign="middle">
                        <asp:TextBox ID="txtBond" runat="server" CssClass="shorttextfield" Style="behavior: url(../../Include/igNumChkLeft.htc)"
                            Width="100px"></asp:TextBox></td>
                    <td class="bodycopy" style="width: 152px" valign="middle">
                        Exp. Date
                    </td>
                    <td class="bodycopy" style="width: 211px" valign="middle">
                        <asp:TextBox ID="txtExpDate" runat="server" CssClass="m_shorttextfield" preset="shortdate"
                            Width="80px"></asp:TextBox></td>
                    <td class="bodycopy" style="width: 104px" valign="middle">
                        Bond Amount&nbsp;</td>
                    <td class="bodycopy" valign="middle" style="width: 167px">
                        <igtxt:WebNumericEdit ID="txtBondAmount" runat="server" CssClass="shorttextfield"
                            MinDecimalPlaces="Two" Width="100px">
                        </igtxt:WebNumericEdit>
                    </td>
                </tr>
                <tr align="left" bgcolor="#F3f3f3">
                    <td valign="middle" style="width: 14px; height: 22px;">&nbsp;
                        
                    </td>
                    <td class="bodycopy" valign="middle" width="75" style="height: 22px">
                        Surety</td>
                    <td class="bodycopy" style="width: 264px; height: 22px;" valign="middle">
                        <asp:TextBox ID="txtSurety" runat="server" BorderWidth="1px" CssClass="m_shorttextfield"
                            Width="100px"></asp:TextBox></td>
                    <td class="bodycopy" style="width: 152px; height: 22px;" valign="middle">
                        Bank Name</td>
                    <td class="bodycopy" style="width: 211px; height: 22px;" valign="middle">
                        <asp:TextBox ID="txtBankName" runat="server" CssClass="m_shorttextfield" Width="160px"></asp:TextBox></td>
                    <td class="bodycopy" style="width: 104px; height: 22px;" valign="middle">
                        Account No.</td>
                    <td class="bodycopy" valign="middle" style="width: 167px; height: 22px;">
                        <asp:TextBox ID="txtBankAccountNo" runat="server" CssClass="m_shorttextfield" MaxLength="8"
                            Width="130px"></asp:TextBox></td>
                </tr>
                <tr align="left" bgcolor="#Ffffff">
                    <td valign="middle" style="width: 14px; height: 72px;">
                    </td>
                    <td class="bodycopy" valign="middle" width="75" style="height: 72px">
                        Comments</td>
                    <td class="bodycopy" colspan="2" valign="middle" style="height: 72px">
                        <asp:TextBox ID="txtComments" runat="server" BorderWidth="1px" CssClass="m_shorttextfield"
                            Width="300px" Columns="30" Height="50px" Rows="5" TextMode="MultiLine"></asp:TextBox></td>
                    <td colspan="3" valign="middle" style="height: 72px">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy" height="100%">
                    <tr><td class="bodycopy" valign="middle" width="100">
                        Default<br />
                        Broker info on A/N</td>
                        <td style="height: 100%; width: 301px;" valign="middle"><asp:TextBox ID="txtBrokerInfo" runat="server" Columns="50" CssClass="m_shorttextfield"
                            Height="50px" Rows="5" TextMode="MultiLine" Width="300px"></asp:TextBox>
                        </td>
                    </tr>
                    </table>
                    </td>
                </tr>
                <tr bgcolor="#73beb6">
                    <td align="left" colspan="7" valign="top" style="height: 1px">
                    </td>
                </tr>
                <tr>
                    <td bgcolor="#f3f3f3" class="bodycopy" colspan="1" style="height: 18px; width: 14px;">
                    </td>
                    <td bgcolor="#f3f3f3" class="bodycopy" colspan="7" style="height: 18px">
                        <asp:Label ID="Label1" runat="server" CssClass="bodyheader" designtimedragdrop="4548"
                            Width="100%">Client Managerial Information</asp:Label></td>
                </tr>
                <tr align="left" bgcolor="#Ffffff">
                    <td valign="middle" style="width: 14px">
                    </td>
                    <td class="bodycopy" valign="middle" width="75">
                        Sales Rep.</td>
                    <td bgcolor="#f3f3f3" class="bodycopy" colspan="7" style="height: 18px">
                        <asp:DropDownList ID="ddlSalesPerson" runat="server" CssClass="smallselect" Width="100px">
                        </asp:DropDownList></td>
                </tr>
                <tr bgcolor="#73beb6">
                    <td align="center" bgcolor="#73beb6" colspan="7" height="0" valign="top" width="0">
                    </td>
                </tr>
               <tr bgcolor="#73beb6">
                    <td align="center" bgcolor="#73beb6" colspan="7" height="0" valign="top" width="0">
                        <img alt="Save" name='bSave' onClick="javascript:formRest('Save');" src='/IFF_MAIN/images/button_save_medium.gif'
                            style="cursor: hand">&nbsp; &nbsp; &nbsp;&nbsp;
                        <% if (strMode == "1" || strMode == "2" || strMode == "3") { %>
                        <img alt="New" name='bNew' onClick="javascript:formRest('New');" src='/IFF_MAIN/images/button_new.gif'
                            style="cursor: hand">
                        <% Response.Write("&nbsp; &nbsp; &nbsp;&nbsp;");} %>
                        <% if (strMode == "3") { %>
                        <img alt="Print" name='bPrint' onClick="javascript:formRest('Print');" src='/IFF_MAIN/images/button_print.gif'
                            style="cursor: hand">
                        <% Response.Write("&nbsp; &nbsp; &nbsp;&nbsp;");} %>
                        <% if (strMode == "3") { %>
                        <img alt="Delete" name='bDelete' onClick="javascript:formRest('Delete');" src='/IFF_MAIN/images/button_delete_medium.gif'
                            style="cursor: hand">
                        <% } %>
                    </td>
                </tr>
            </table>
        </div>
        <!-- End of Additional -->
        <!--
                </td>
            </tr>
        </table>
        -->
        <div id="HiddenBtn" style="display: none; position: absolute; top: 0px; left: -500px">
            <asp:Button ID="btnSave" runat="server" DESIGNTIMEDRAGDROP="2846" Font-Size="Larger"
                OnClick="btnSave_Click" Visible="False" Width="60px" />
            <asp:Button ID="btnPrint" runat="server" DESIGNTIMEDRAGDROP="2846" Font-Size="Larger"
                OnClick="btnPrint_Click" Visible="False" Width="60px" />
            <asp:Button ID="btnNew" runat="server" DESIGNTIMEDRAGDROP="1398" Font-Size="Larger"
                OnClick="btnNew_Click" Visible="False" Width="60px" /><asp:Button ID="btnBack" runat="server"
                    DESIGNTIMEDRAGDROP="1399" Font-Size="Larger" OnClick="btnBack_Click" Visible="False"
                    Width="60px" /><asp:Button ID="btnCancel" runat="server" DESIGNTIMEDRAGDROP="1400"
                        Font-Size="Larger" OnClick="btnCancel_Click" Visible="False" Width="60px" /><asp:Button
                            ID="btnShow" runat="server" DESIGNTIMEDRAGDROP="1401" Font-Size="Larger" OnClick="btnShow_Click"
                            Visible="False" Width="60px" /><asp:Button ID="btnEdit" runat="server" DESIGNTIMEDRAGDROP="1402"
                                Font-Size="Larger" OnClick="btnEdit_Click" Visible="False" Width="60px" /><asp:Button
                                    ID="btnDelete" runat="server" DESIGNTIMEDRAGDROP="1403" Font-Size="Larger" OnClick="btnDelete_Click"
                                    Visible="False" Width="60px" /><asp:Label ID="lblAccountNo" runat="server" Font-Bold="True"
                                        Font-Italic="True" Font-Underline="True" ForeColor="Red" Visible="False" Width="136px"></asp:Label>
            <asp:TextBox ID="txtAccountNumber" runat="server" Width="0px"></asp:TextBox>&nbsp;
            <asp:Button ID="btnSaveNew" runat="server" Font-Size="Larger" OnClick="btnSaveNew_Click"
                Visible="False" Width="60px" /><asp:Label ID="lblTask" runat="server" Font-Bold="True"
                    Font-Italic="True" Font-Size="Larger" ForeColor="DarkGreen" Height="1%" Visible="False"
                    Width="0px"></asp:Label>
            <asp:TextBox ID="lblStatus" runat="server" Height="1%" Text="block" Width="0px"></asp:TextBox>
        </div>
        <div id="addBtn" style="display: block; position: absolute; top: 818px; left: 32px;
            width: 95%">
            <p align="center">
                <input id="Button1" class="bodycopy" designtimedragdrop="2075" onClick="return goAddContact();"
                    style="width: 143px; background-color: #f4f2e8" type="button" value="Additional Contact">
                <input id="Button2" class="bodycopy" designtimedragdrop="2075" onClick="return goRemarks();"
                    style="width: 143px; background-color: #f4f2e8" type="button" value="Additional Comments">
            </p>
        </div>
    </form>
</body>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
<% if  ( lblTask.Text == "Edit") { %>

<script language='javascript'> 
    var text  = document.getElementById( 'ComboSearchKey_Text' );
    text.focus();
</script>

<% 
   }
   else
   {  
%>

<script language='javascript'> 
    var text  = document.getElementById( 'txtDBA' );
    text.focus();    
</script>

<% 
   }
%>

<script language='javascript'> 
var sObj=document.all['lblStatus']; 
var obj=document.all['wAdd']; 
var mObj=document.all['wPri'];	
var eObj=document.getElementById( 'addBtn' );

if(sObj.value != obj.style.display) 
{
    view_layer('wAdd',true);
}

_tmpy = parseInt(obj.offsetTop);
eObj.style.posLeft=parseInt(mObj.offsetLeft);

if ( _tmpy > 0 )
{
    eObj.style.posTop= _tmpy + parseInt(obj.offsetHeight) + 1;
}
else
{
   _tmpy = parseInt(mObj.offsetTop) + parseInt(mObj.offsetHeight);
   eObj.style.posTop= _tmpy + parseInt(obj.offsetHeight) + 1;

}
</script>

<% Response.Flush(); %>
</html>
