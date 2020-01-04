<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ocean_arrival_notice.aspx.cs" Inherits="ASPX_ocean_arrival_notice" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Src="Controls/OCEAN_ARNChargeItemControl.ascx" TagName="OCEAN_ARNChargeItemControl" TagPrefix="uc3" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="Controls/OCEAN_ARNCostItemControl.ascx" TagName="OCEAN_ARNCostItemControl" TagPrefix="uc2" %>

<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
   
    <link href="../CSS/elt_css.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="../jScripts/JPED_NET.js"></script>
    <script type="text/javascript" src="../jScripts/ig_dropCalendar.js"></script>
    <script type="text/javascript" src="../jScripts/MAWB_DROPDOWN.js"></script>
    <SCRIPT src="../jScripts/stanley_J_function.js" type=text/javascript></SCRIPT> 
    <script type="text/javascript" src="../jScripts/WindowsManip.js"></script>
    <script type="text/javascript" src="../jScripts/datetimepicker.js"></script>
    <script type="text/javascript" language="JavaScript" src="../../ASP/ajaxFunctions/ajax.js"></script>
       
<!--  #INCLUDE FILE="../include/common.htm" -->

  
    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
    <link href="../CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<body>
<script  type="text/vbscript" language="VBScript">

/////////////////////////////////////////////////
Sub PrintClick(doInvoice)
/////////////////////////////////////////////////
    iType="O"
    //Sec=document.form1.hSec.Value
    HAWB=document.form1.txtHAWB.Value
    MAWB=document.form1.lstMAWB.Value
    invoice_no=document.form1.txtInvoice_no.Value

    //AgentOrgAcct=document.form1.hAgentOrgAcct.Value
	
	url="../../ASP/ocean_import/arrival_notice_pdf.asp?iType=" & iType & "&HAWB=" & HAWB&"&MAWB="&MAWB& "&Sec=" & Sec & "&AgentOrgAcct=" & AgentOrgAcct& "&invoice_no="&invoice_no&"&doInvoice="&doInvoice
	//jPopUpPDF()
    window.open(url)
End Sub

/////////////////////////////////////////////////
Sub AuthClick()
/////////////////////////////////////////////////
iType="O"
//Sec=document.form1.hSec.Value
HAWB=document.form1.txtHAWB.Value
invoice_no=document.form1.txtInvoice_no.Value

//AgentOrgAcct=document.form1.hAgentOrgAcct.Value

	//jPopUpPDFAuth()
	//jPopUpPDF()
	url="../../ASP/ocean_import/AuthorityMakeEntry_pdf.asp?iType=" & iType & "&HAWB=" & HAWB &"&invoice_no="&invoice_no& "&Sec=" & Sec & "&AgentOrgAcct=" & AgentOrgAcct
    window.open(url)	

End Sub




Sub Sleep(tmpSeconds)
    Dim dtmOne,dtmTwo
    dtmOne = Now()
    While DateDiff("s",dtmOne,dtmTwo) < tmpSeconds
	    dtmTwo = Now()
    Wend
End Sub


</script>

<script  type="text/javascript" language="JavaScript">
    
    function trim(sourceString) { return sourceString.replace(/(?:^\s+|\s+$)/ig, ""); }			
    function goDeconsol() {
    var mawb = document.getElementById("lstMAWB").value;
   
    if (trim(mawb) == '') 
    {
        alert('Please select a MAWB No.');
        return;
    }else{
        var url = '../../ASP/air_import/air_import2.asp?iType=A&Edit=yes&MAWB=' + mawb ;
        window.open(url);	
    }
}

function jPopUpPDFAuth(){
var argS = 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1';
 popUpPDF = window.open('','popUpPDFAuth', argS);
 
 }

    //Added by stanley Limit Fumction
    function checkNumPlus(obj)
    {
        var num=obj.value;
        obj.value = parseFloat(num).toFixed(2);
    }

function add_or_updateFC(amtfield){
    var amount;
     amount=parseFloat(amtfield.value);
      if(amtfield.value != "")
     {
          document.getElementById('txtFC').value=parseFloat(amount).toFixed(2);
     } 
    if(amount!=0){
        var isThere=document.getElementById("OCEAN_ARNChargeItemControl1_hIsFCExist").value;
        if(isThere!="Y"){
            if(amount!=0){
                CommandChange("ADDFC");
                document.getElementById("OCEAN_ARNChargeItemControl1_hFCAmount").value=amount;
                
               
                form1.submit();        }     
        }else{  
          ID=document.getElementById("OCEAN_ARNChargeItemControl1_hFCAmountFieldID").value;
          document.getElementById(ID).value=amtfield.value;      
        }
    }
}
function ChWTchange(obj)
{
    var WTValue=parseFloat(obj.value).toFixed(2)
    if(obj.value != "")
    {
        document.getElementById('txtChWT').value=WTValue;
    }
}

function GrWTchange(obj)
{
    var GrValue=parseFloat(obj.value).toFixed(2)
    if(obj.value != "")
    {
        document.getElementById('txtGrossWT').value=GrValue;
    }
}
function Ratechange(obj)
{
    var RateValue=parseFloat(obj.value).toFixed(0)
    if(obj.value != "")
    {
        document.getElementById('txtRate').value=RateValue;
    }
}
function scaleChange(obj)
{
   
   if(obj.value=='k'){
   
         var tmpGross=parseFloat(document.getElementById('txtGrossWT').value)
         if(document.getElementById('txtGrossWT').value !="" && tmpGross !="NaN")
         { 
            tmpGross=tmpGross/2.20462262;
         }
         else
         {
            tmpGross=0;
         } 
		 var tmpChargeable=parseFloat(document.getElementById('txtChWT').value)
		 if(document.getElementById('txtChWT').value !="" && tmpChargeable !="NaN")
         { 
            tmpChargeable=tmpChargeable/2.20462262;
         }
         else
         {
            tmpChargeable=0;
         } 

   		document.getElementById('txtGrossWT').value=Math.round(tmpGross*1000)/1000
		document.getElementById('txtChWT').value=Math.round(tmpChargeable*1000)/1000
		
   }else{
        var tmpGross=parseFloat(document.getElementById('txtGrossWT').value) 
         if(document.getElementById('txtGrossWT').value !="" && tmpGross !="NaN")
         { 
            tmpGross=tmpGross*2.20462262;
         }
         else
         {
            tmpGross=0;
         } 
		var tmpChargeable=parseFloat(document.getElementById('txtChWT').value)
		if(document.getElementById('txtChWT').value !="" && tmpChargeable !="NaN")
         { 
            tmpChargeable=tmpChargeable*2.20462262;
         }
         else
         {
            tmpChargeable=0;
         }  
		
   		document.getElementById('txtGrossWT').value=Math.round(tmpGross*1000)/1000
		document.getElementById('txtChWT').value=Math.round(tmpChargeable*1000)/1000
   }
   getCustomerSellingRate();
  
}

function catchRatingInfo(){

	 dep=document.getElementById("ddlPortOfLoading").value;
	 arp=document.getElementById("ddlPortOfDischarge").value;	
	
	 Unit=document.getElementById("ddlScale").value;
	 airline=document.getElementById("hCarrierCode").value;
	
    // var oSelect = document.getElementById("lstConsigneeName");	 
    // var tmpStr = oSelect.options[ oSelect.options.selectedIndex ].value;
    
	// cusAcc = tmpStr.substring(0,tmpStr.indexOf('-'));
	  cusAcc=document.getElementById("hConsigneeAcct").value;
	 elt_account_number='<%=elt_account_number%>';
	 wgt= document.form1.txtChWT.value;  
	
}

function getCustomerSellingRate(){  
      // alert();
		req = new ActiveXObject("Microsoft.XMLHTTP"); 
		if (req) {	
			catchRatingInfo();			
			req.onreadystatechange = processReqChange;		
			req.open("GET","../../ASP/ajaxFunctions/ajax_cus_rate.asp?cusAcc="+ cusAcc+"&Unit="+ Unit+ "&airline="+ airline+"&arp="+arp+"&dep="+dep+"&wgt="+wgt, true);		
			req.send();		
		}

}

function calculateTotalFc(){  

	var chargeable=document.getElementById("txtChWT").value;
	var CSRate=document.getElementById("txtRate").value;
	var TotalFC=document.getElementById("txtFC").value;	
	
	if(CSRate!=0){
	    try{
			CSRate=parseFloat(CSRate);
		}catch(e){}
	} 	
	if((CSRate*0)!=0){	
	  alert("Please Enter a number for rate");
	  document.getElementById("txtRate").value="0";
	  document.getElementById("txtFC").value="0";
	  document.getElementById("txtRate").focus();
	  return;
	}	
	
	chargeable=parseFloat(chargeable);
					
	if((chargeable*0)!=0){
	  alert("Please Enter a number for Chargeable Weight");
	  document.getElementById("txtChWT").value="0";
	  document.getElementById("txtFC").value="0";
	  document.getElementById("txtChWT").focus();
	 return;
	}	
	var tVal=chargeable * CSRate;
	tVal=Math.round(tVal*1000)/1000;
	document.getElementById("txtFC").value=tVal.toFixed(2);
	document.getElementById("txtFC").focus();	
}


function processReqChange(){

	if (req.readyState == 4) {	
		
		if (req.status == 200) {	
					
			var result = req.responseText;
			//document.getElementById("txtBrokerInfo").value=result;
		    var numericVar=parseFloat(result);
		    
		    if(numericVar < 0 ){
		        if(confirm("Minimum charge will be applied.\n Would you like to proceed?")){
		            var tVal=numericVar*-1;
	                tVal=Math.round(tVal*100)/100;
	                document.getElementById("txtFC").value=tVal.toFixed(2);
    	                      
		            document.getElementById("txtRate").value="0";
		            CSRate=parseFloat("0");
		        }
		        return;
		    }
			
		    document.getElementById("txtRate").focus();	
			CSRate=parseFloat(result);	
			if( document.getElementById("txtRate").value!=0){
			    document.getElementById("txtRate").value=CSRate;
				 calculateTotalFc();
			}
			document.getElementById("txtRate").value=CSRate;
		} else {
			
			document.getElementById("txtRate").focus();
			CSRate=parseFloat("0");
			document.getElementById("txtRate").value=CSRate;
		}
		
	}

}

	
function validateCustomer(){    
        if(document.getElementById("lstCustomerName").value==""){
            alert("Customer is required!");
            document.getElementById("lstCustomerName").focus();
            return false;
        }else{        
            return true; 
        } 
}

function getDefultBroker(org_account_number)
{
 
    var url="../../ASPX/AccountingTasks/Ajax/getDefaultBroker.aspx?org_account_number="+ org_account_number;
    var req = new ActiveXObject("Microsoft.XMLHTTP");
    req.open("get",url,false);
    req.send();
    var result =req.responseText;
    
    return result;
}


function btnSaveClick(){
    if( validateCustomer()){
       if(validateVendorList()){   
           if(ChargeAmountList()){    
              CommandChange("SAVE");
             form1.submit();
           }
       }
    }    
}



function btnDeleteClick(){

    if("<%=ARLock%>"=="true")
    {
         alert("You cannot delete this invoice since, AR for this invoice has been processed!");
    }else{
        CommandChange("DELETEIV");
         
        form1.submit();
    }
 }

 

function btnSaveNewClick(){
    if( validateCustomer()){
       if( validateVendorList()){ 
           if(ChargeAmountList()){   
                CommandChange("SAVENEW");
                form1.submit();
           }
       }
    }
}

function getCalendarDate()
{ 
   var now         = new Date();
   var monthnumber = now.getMonth();
   
   var monthday    = now.getDate();
   var year        = now.getYear();
  
   var dateString = monthnumber +
                    '/' +
                    monthday +
                    '/' +
                    year;
   return dateString;
}
// Start of list change effect //////////////////////////////////////////////////////////////////
       function checkDate(obj){
        if(obj.value.trim()==""){
        var now = new Date();

        obj.value=getCalendarDate();
        }    
       }
        function setConsigneeFromDB(name){
         document.getElementById('lstConsigneeName').value=name;
        }
        function getOrganizationInfo(orgNum)
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

            var url="../../ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=B&org="+ orgNum;
        
            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send(); 
            
            return xmlHTTP.responseText; 
        }
        
        
         function lstBrokerNameChange(orgNum,orgName)
        {  
            var infoObj = document.getElementById("txtBrokerInfo");  
            var txtObj = document.getElementById("lstBrokerName");
            var divObj = document.getElementById("lstBrokerNameDiv")            
            
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;
            document.getElementById("hBrokerAcct").value=orgNum;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";		    
        }
        
          function lstNotifyNameChange(orgNum,orgName)
        {   
     
            var infoObj = document.getElementById("txtNotifyInfo");  
            var txtObj = document.getElementById("lstNotifyName");
            var divObj = document.getElementById("lstNotifyNameDiv")            
            
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;
            document.getElementById("hNotifyAcct").value=orgNum;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";		    
        }
        
        
         function lstShipperNameChange(orgNum,orgName)
        {   
            var infoObj = document.getElementById("txtShipperInfo");  
            var txtObj = document.getElementById("lstShipperName");
            var divObj = document.getElementById("lstShipperNameDiv")            
            
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;
            document.getElementById("hShipperAcct").value=orgNum;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";		    
        }
        
        function lstConsigneeNameChange(orgNum,orgName)
        {   
            var infoObj = document.getElementById("txtConsigneeInfo");      
            var txtObj = document.getElementById("lstConsigneeName");
            var divObj = document.getElementById("lstConsigneeNameDiv") ;
           var infoObj2 = document.getElementById("txtNotifyInfo");  
            var txtObj2 = document.getElementById("lstNotifyName");
            var divObj2 = document.getElementById("lstNotifyNameDiv") 
               
                
            infoObj.value = getOrganizationInfo(orgNum);
            infoObj2.value = getOrganizationInfo(orgNum);
            document.getElementById("hConsigneeAcct").value=orgNum;
            document.getElementById("hNotifyAcct").value=orgNum;
            txtObj.value = orgName;
            txtObj2.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden"; 
            divObj2.style.position = "absolute";
            divObj2.style.visibility = "hidden";		
             try{        
               var broker=getDefultBroker(orgNum); 
                broker=broker.split("^^");                
		        lstNotifyNameChange(broker[0],broker[1]);
              
  		    }catch(e){}
             
           
       
        }       
        
        function lstMAWBChange(file_no, mawb_num){
         var txtObj = document.getElementById("lstMAWB");
         var divObj = document.getElementById("lstMAWBDiv");
         document.getElementById("txtFileNo").value=file_no;
         txtObj.value = mawb_num;
         divObj.style.position = "absolute";
         divObj.style.visibility = "hidden";  
         
          document.getElementById("hCommand").value="LOADMAWB";
          if(mawb_num!=""){
            form1.submit();
          }
        }
        
          function lstCustomerNameChange(orgNum,orgName)
        {
      
            var infoObj = document.getElementById("txtCustomerInfo");
            var txtObj = document.getElementById("lstCustomerName");
            var divObj = document.getElementById("lstCustomerNameDiv")
    
            infoObj.value = getOrganizationInfo(orgNum);
            document.getElementById("hCustomerAcct").value=orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
        
        function reCalculateTotalAmount(salesTax,TotalCharge,AgentProfit, Total){
          Total.value=parseFloat(TotalCharge.value)-parseFloat(AgentProfit.value)-parseFloat(salesTax.value);
        }
        
        function CommandChange(command){           
            document.getElementById("hCommand").value=command;                     
        }
<!--

function isNum(a) {

if(a.value == "") return true;

var number=parseInt(a.value,10);

if( number.toString()=="NaN") {
     alert('Please input a valid I/V No.');
	 return false;
 }
 else 
 {
 	 return true;
 }
}


function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0

  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_goToURL() { //v3.0
  var i, args=MM_goToURL.arguments; document.MM_returnValue = false;
  for (i=0; i<(args.length-1); i+=2) eval(args[i]+".location='"+args[i+1]+"'");
}

function clearSearch(obj){        
           obj.value = ''; 
          // obj.style.color='#000000';         
        }
        
function btnSearchClick(){
    var SearchNo=document.getElementById("txtSearchIVNO").value;
    if(SearchNo == "" || SearchNo=="Search Here")
    {
        alert("Please enter Invoice No first!");
    }
    else
    {
        CommandChange("SEARCH");
        form1.submit();
    }
}
//-->
</script>
    <form id="form1"  method="post"  runat="server">
    <input type="image" style="width:0px; height:0px" onclick="return false;" />
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td width="30%" height="32" align="left" valign="middle" class="pageheader">
                    Arrival notice &amp; frieght invoice</td>
			<td width="70%" align="right" valign="baseline"><span class="labelSearch">
			<asp:DropDownList id="ddlNOlist" runat="server" CssClass="net_smallselect">
<asp:ListItem Value="arrive" Selected="True">Arrival Notice(Invoice) No.</asp:ListItem>
                            <asp:ListItem Value="house" >House B/L NO.</asp:ListItem>
                            <asp:ListItem Value="master" >Master B/L NO.</asp:ListItem>
            </asp:DropDownList>
			<asp:TextBox ID="txtSearchIVNO" runat="server" CssClass="shorttextfield"  Height="12px" ForeColor="Black"  value="Search Here"  onKeyDown="javascript: if(event.keyCode == 13) { btnSearchClick(); }" class="lookup"></asp:TextBox><asp:ImageButton ID="btnSearchIV" runat="server" ImageUrl="../../asp/images/button_newsearch.gif" OnClick="btnSearchIV_Click" /></span>&nbsp;<!-- Search -->
			</td>
		</tr>
	</table>
	<div class="selectarea" style=" width: 100%; margin-left: auto; margin-right:auto;">
		<table border="0" align="center" cellpadding="0" cellspacing="0" style="width: 100%">
			<tr>
				<td style="width: 148px">
				<!-- use this when applicable-->
					<span class="select"><!--Select Booking No.--></span></td>
				<td rowspan="2" align="right" valign="bottom" style="width: 72%">
					<div id="print">
                        <img align="absbottom" height="27"src="/iff_main/ASP/Images/icon_printer.gif" style="font-weight: bold; font-size: 6pt;
                                        color: #000000; font-family: Verdana" width="40"  /><a href="javascript:;"  onClick="PrintClick('no');return;" >Arrival
                        Notice </a> /&nbsp;
                         
                        <a href="javascript:;"  onClick="PrintClick('yes');return;" >Arrival Notice &amp;Freight Invoice</a>
                        /&nbsp;
                       
                       <a href="javascript:;"  onClick="AuthClick();return;" > Release Order</a></div>
				</td>
			</tr>
			<tr>
				<!-- combo box here -->
				<td valign="bottom" style="width: 148px; height: 35px;">
                        <asp:ScriptManager ID="ScriptManager1" runat="server">
                        <Services>
                        <asp:ServiceReference Path="WebService/WebService.asmx" />
                            <asp:ServiceReference Path="WebService/ARStatusService.asmx" />
                        </Services>
                        </asp:ScriptManager>
        </td>
			</tr>
		</table>
	</div>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#909EB0" class="border1px">
        <tr>
            <td align="center" valign="middle" bgcolor="#cfd6df" style="border-bottom: 1px solid #909EB0; width: 1192px; height: 9px;">
                <asp:Image ID="btnSaveUp" runat="server" ImageUrl="../../ASP/images/button_save_medium.gif" />

                                            <img onclick="btnDeleteClick();" src="../../ASP/images/button_delete_medium.gif"
                                                style="cursor: hand" id="btnDelete" runat="server" /></td>
        </tr>
	
        <tr>
        <td style="width: 1192px">
        <table>

        <tr>
       <td style="width: 1282px; height: 430px; padding-left: 40px">
			<table border="0" cellpadding="0" cellspacing="0" style=" width: 100%;" >
			    <tr bgcolor="#dfe1e6">
			        <td bgcolor="#dfe1e6" class="bodyheader" style="width: 391px; padding-left:10px; height: 18px;" colspan="2">Master B/L No.</td>
			        
		        </tr>
		        <tr >
		            <td  class="bodyheader" style="width: 409px; height: 38px; padding-left:10px">
		                <div id="lstMAWBDiv" align=left></div>
                        <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td style="height: 24px"><asp:TextBox type="text" autocomplete="off" id="lstMAWB" name="lstMAWB" 
                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; height: 12px;"  onKeyUp="mawbFill(this,'O','lstMAWBChange')"
                                                    onfocus="initializeMAWB_DDRField(this);" runat="server" ForeColor="Black" /></td>
                                            <td style="height: 24px">
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="mawbFill('lstMAWB','O','lstMAWBChange')"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                    
                                                    </td>
                                                    <td style="height: 24px"><br /></td>
                                        </tr>
                                        <tr>
                                            <td style="height: 21px; padding-bottom:15px">
                                          <!-- End JPED -->  <img src="/iff_main/ASP/Images/icon_goto.gif" width="36" height="21" align="absbottom" /><span class="goto"><b onclick="goDeconsol();" style="cursor:hand">Go to Deconsolidation</b></span>
                                            </td>
                                        </tr>
                        </table>
		            </td>
		        </tr>
		        <tr>
		    			<td bgcolor="#ffffff" class="bodyheader" style="width: 409px; padding-left:10px; height: 18px;" ><img src="/iff_main/ASP/Images/required.gif" align="absbottom"><strong><font color="c16b42">Customer</font></strong></td>
				</tr>
				<tr>
					<td style="width: 409px; padding-left:10px">
					        <div  id="lstCustomerNameDiv"></div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td><asp:TextBox type="text" autocomplete="off" id="lstCustomerName" name="lstCustomerName" 
                                                                        class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; height: 12px;"  onKeyUp="organizationFill(this,'Customer','lstCustomerNameChange')"
                                                                        onfocus="initializeJPEDField(this);" runat="server" ForeColor="Black" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCustomerName','Customer','lstCustomerNameChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hCustomerAcct','lstCustomerName','txtCustomerInfo')" /></td>
                                                                        
                                                                        <td><br /></td>
                                                            </tr>
                                          </table>
                                                        
                                                        <!-- End JPED -->  
                                            <asp:TextBox ID="txtCustomerInfo" runat="server" Rows="5" TextMode="MultiLine" Width="300px" ForeColor="Black"></asp:TextBox>  &nbsp; &nbsp; &nbsp;&nbsp;
					    
					</td>
				</tr>
		         <tr>
		    			<td bgcolor="#ffffff" class="bodyheader" style="width: 391px; padding-left:10px; height: 18px;" colspan="2">Shipper</td>
				</tr>
				<tr>
					<td style="width: 409px; padding-left:10px">
					        <div id="lstShipperNameDiv"></div>
                                         <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td>
                                                                   <asp:TextBox type="text" autocomplete="off" id="lstShipperName" name="lstShipperName" value=""
                                                                        class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; height: 12px;" onKeyUp="organizationFill(this,'Shipper','lstShipperNameChange')"
                                                                        onfocus="initializeJPEDField(this);" runat="server" ForeColor="Black" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hShipperAcct','lstShipperName','txtShipperInfo')" /></td>
                                                            </tr>
                                          </table>                                                     
                                            <asp:TextBox ID="txtShipperInfo" runat="server" Rows="5" TextMode="MultiLine" Width="300px" ForeColor="Black"></asp:TextBox>
				    </td>
				</tr>	
				<tr>
		    			<td height="18" bgcolor="#ffffff" class="bodyheader" style="width: 391px; padding-left:10px" colspan="2">Consignee</td>
				</tr>
				<tr>
					<td style="width: 409px; padding-left:10px">
					<div id="lstConsigneeNameDiv">  </div>
                          <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td style="height: 19px">
                                                  <asp:TextBox type="text" autocomplete="off" id="lstConsigneeName" name="lstConsigneeName" value=""
                                                        class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; height: 12px;" onKeyUp="organizationFill(this,'Consignee','lstConsigneeNameChange')"
                                                        onfocus="initializeJPEDField(this);" runat="server" ForeColor="Black" /></td>
                                                <td style="height: 19px">
                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange')"
                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                <td style="height: 19px">
                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                        onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" /></td>
                                            </tr>
                          </table>
                            <!-- End JPED -->
                            <asp:TextBox ID="txtConsigneeInfo" runat="server" Rows="5" TextMode="MultiLine" Width="300px" ForeColor="Black"></asp:TextBox>
				</td>
				</tr>
				<tr>
		    			<td bgcolor="#ffffff" class="bodyheader" style="width: 391px; padding-left:10px; height: 18px;" colspan="2">Notify Party/Broker</td>
				</tr>
				<tr>
					<td style="width: 409px; padding-left:10px">
					    <div id="lstNotifyNameDiv">  </div>               <!-- Start JPED -->
                              <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                                    <td>
                                                      <asp:TextBox type="text" autocomplete="off" id="lstNotifyName" name="lstNotifyName" value=""
                                                            class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; height: 12px;" onKeyUp="organizationFill(this,'Notify','lstNotifyNameChange')"
                                                            onfocus="initializeJPEDField(this);" runat="server" ForeColor="Black" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstNotifyName','Notify','lstNotifyNameChange')"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hNotifyAcct','lstNotifyName','txtNotifyInfo')" /></td></tr>
                              </table>
                                                             <asp:TextBox ID="txtNotifyInfo" runat="server" Rows="5" TextMode="MultiLine" Width="300px" ForeColor="Black"></asp:TextBox>&nbsp;   
					</td>
			    </tr>
			    
		    </table>
	    </td>
        <td  align="left" valign="top" style="height: 430px; width: 66%; padding-right: 40px">
			    <table width="100%"  bgcolor="#ffffff" border="0" cellspacing="0" cellpadding="0" style="height: 1px" id="TABLE1">
                         <tr>
                            <td style="width: 773px; height: 99px;">
                                <table bgcolor="#ffffff">
                                     <tr bgcolor="#dfe1e6">
			                            <td  class="bodyheader" style="width: 402px;  height: 12px; padding-bottom 8px" colspan="2">Invoice No. </td>
			                            <td  class="bodyheader" style="width: 422px;  height: 12px; padding-bottom 8px" colspan="2">House B/L No.</td>
			                             <td  class="bodyheader" style="width: 340px;  height: 12px; padding-bottom 8px" colspan="2">AMS B/L No.</td>
			
		                            </tr>
		                            <tr bgcolor="#ffffff">
			                            <td class="bodyheader" style="width: 402px;  height: 21px;" colspan="2"><asp:TextBox ID="txtInvoice_no" runat="server" Width="70" ReadOnly="true" CssClass="readonlybold"></asp:TextBox> </td>
			                            <td  class="bodyheader" style="width: 422px;  height: 21px;" colspan="2"><asp:TextBox ID="txtHAWB" Width="70"  runat="server" MaxLength="32" CssClass="shorttextfield"
                                                ForeColor="Black"></asp:TextBox></td>
			                             <td  class="bodyheader" style="width: 340px;  height: 21px;" colspan="2"><asp:TextBox ID="txtAMSBLNo" runat="server" Width="70"   CssClass="shorttextfield" ForeColor="Black"></asp:TextBox></td>
		                            </tr>
		                            <tr bgcolor="#ffffff">
			                            <td  class="bodyheader" style="width: 402px;  height: 12px; padding-bottom 8px" colspan="2">Reference No. </td>
			                            <td  class="bodyheader" style="width: 422px;  height: 12px;" colspan="2">Sub B/L No.</td>
			                             <td  class="bodyheader" style="width: 340px;  height: 12px;" colspan="2"><span class="bodyheader" style="width: 157px">File No.</span></td>
		                            </tr>
		                            <tr bgcolor="#ffffff">
			                            <td  class="bodyheader" style="width: 402px;  height: 34px;" colspan="2"><asp:TextBox ID="txtRefNo" runat="server" Width="70"  CssClass="shorttextfield" MaxLength="64" ForeColor="Black"></asp:TextBox> </td>
			                            <td  class="bodyheader" style="width: 422px;  height: 34px;" colspan="2"><asp:TextBox ID="txtSubAWB" Width="70"  runat="server"
                                                    CssClass="shorttextfield" MaxLength="32" ForeColor="Black"></asp:TextBox></td>
			                             <td  class="bodyheader" style="width: 340px;  height: 34px;" colspan="2"><span style="width: 157px">
				                        <asp:TextBox ID="txtFileNo" runat="server" Width="70" MaxLength="64"  CssClass="shorttextfield" ForeColor="Black"></asp:TextBox>
				                      </span></td>
		                            </tr>
		                            <tr bgcolor="#ffffff">
			                            <td  class="bodyheader" style="width: 402px;  height: 12px; " colspan="2">Invoice Date </td>
			                            <td  class="bodyheader" style="width: 422px;  height: 12px;" colspan="2">Vessel Name </td>
			                             <td  class="bodyheader" style="width: 340px;  height: 12px;" colspan="2"><span class="bodyheader" style="width: 157px">Voyage No.</span></td>		                            
		                            </tr>
		                            <tr bgcolor="#ffffff">
			                            <td  class="bodyheader" style="width: 402px;  height: 28px;" colspan="2">
			                            <igtxt:WebDateTimeEdit ID="dInvoice" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                            Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                            <ButtonsAppearance CustomButtonDisplay="OnRight">
                                            </ButtonsAppearance>
                                            <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                            </igtxt:WebDateTimeEdit></td>
			                            <td  class="bodyheader" style="width: 402px;  height: 28px;" colspan="2">
			                                <asp:TextBox Width="70" MaxLength="16" ID="txtFlightNo" runat="server" CssClass="shorttextfield" ForeColor="Black"></asp:TextBox></td>
			                            <td  class="bodyheader" style="width: 340px;  height: 28px;" colspan="2"><asp:TextBox ID="txtVoyageNo" MaxLength="15" runat="server" Width="70"  CssClass="shorttextfield" ForeColor="Black"></asp:TextBox></td>
			                        </tr>
			                        <tr bgcolor="#ffffff">
			                            <td  class="bodyheader" style="width: 402px;  height: 12px;" colspan="2">Doc. Pickup Date </td>
			                            <td  class="bodyheader" style="width: 422px;  height: 12px;" colspan="2"> </td>
			                             <td  class="bodyheader" style="width: 340px;  height: 12px;" colspan="2"></td>		                            
		                            </tr>
		                              <tr bgcolor="#ffffff">
			                            <td  class="bodyheader" style="width: 402px;  height: 34px;" colspan="2">
			                                <igtxt:WebDateTimeEdit ID="dPickup" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                        Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                        <ButtonsAppearance CustomButtonDisplay="OnRight">
                                        </ButtonsAppearance>
                                        <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                    </igtxt:WebDateTimeEdit>    
                                            </Td>
			                            </tr>
			                        <tr bgcolor="#ffffff">
			                            <td  class="bodyheader" style="width: 402px;  height: 12px; " colspan="2">Port of Loading </td>
			                            <td  class="bodyheader" style="width: 422px;  height: 12px;" colspan="2">ETD </td>
			                             <td  class="bodyheader" style="width: 340px;  height: 12px;" colspan="2"><span class="bodyheader" style="width: 157px">Last Free Date </span></td>		                            
		                            </tr>
		                            
		                              <tr bgcolor="#ffffff">
			                            <td  class="bodyheader" style="width: 402px;  height: 28px;" colspan="2"><asp:DropDownList ID="ddlPortOfLoading" runat="server" CssClass="net_smallselect"
                                                DataTextField="Port_desc" DataValueField="Port_code" Width="120"> </asp:DropDownList></td>
                                        <td  class="bodyheader" style="width: 402px;  height: 28px;" colspan="2">
                                                <igtxt:WebDateTimeEdit ID="dETD" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                                Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                                <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                </ButtonsAppearance>
                                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                            </igtxt:WebDateTimeEdit>
                                        </td>
                                        <td  class="bodyheader" style="width: 340px;  height: 28px;" colspan="2">
                                                <igtxt:WebDateTimeEdit ID="dLastFree" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                                Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                                <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                </ButtonsAppearance>
                                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                            </igtxt:WebDateTimeEdit>
                                        </td>
			                            </tr>
                            
		                            <tr bgcolor="#ffffff">
			                            <td  class="bodyheader" style="width: 402px;  height: 12px; " colspan="2">Port of Discharge </td>
			                            <td  class="bodyheader" style="width: 422px;  height: 12px;" colspan="2">ETA </td>
			                             <td  class="bodyheader" style="width: 340px;  height: 12px;" colspan="2"><span class="bodyheader" style="width: 157px">G.O. Date</span></td>		                            
		                            </tr>
		                            <tr bgcolor="#ffffff">
			                            <td  class="bodyheader" style="width: 402px;  height: 34px;" colspan="2"><asp:DropDownList ID="ddlPortOfDischarge" runat="server" CssClass="net_smallselect"
                                              DataTextField="Port_desc" DataValueField="Port_code" Width="120" > </asp:DropDownList></td>
                                        <td  class="bodyheader" style="width: 402px;  height: 34px;" colspan="2">
                                            <igtxt:WebDateTimeEdit ID="dETA" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                            Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                            <ButtonsAppearance CustomButtonDisplay="OnRight">
                                            </ButtonsAppearance>
                                            <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                            </igtxt:WebDateTimeEdit>
                                        </td>
                                         <td  class="bodyheader" style="width: 340px;  height: 34px;" colspan="2">
                                             <igtxt:WebDateTimeEdit ID="dGoDate" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                                Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                                <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                </ButtonsAppearance>
                                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                            </igtxt:WebDateTimeEdit>
                                        </td>
			                            </tr>
			                            <tr bgcolor="#ffffff">
			                                <td  class="bodyheader" style="width: 402px;  height: 12px; " colspan="2">Place of Delivery </td>
			                                <td  class="bodyheader" style="width: 422px;  height: 12px;" colspan="2">ETD </td>
			                                 <td  class="bodyheader" style="width: 340px;  height: 12px;" colspan="2"><span class="bodyheader" style="width: 157px">IT Date</span></td>		                            
		                            </tr>
			        
			                        <tr bgcolor="#ffffff">
			                            <td  class="bodyheader" style="width: 402px;  height: 28px;" colspan="2">
			                            <asp:TextBox ID="txtPlaceOfDelivery" runat="server" CssClass="shorttextfield"
                                               Width="70" MaxLength="64" ForeColor="Black"></asp:TextBox></td>
                                        <td  class="bodyheader" style="width: 422px;  height: 28px;" colspan="2">
                                             <igtxt:WebDateTimeEdit ID="dETD2" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                                Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                                <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                </ButtonsAppearance>
                                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                            </igtxt:WebDateTimeEdit>
                                          </td>
			                            <td  class="bodyheader" style="width: 340px;  height: 12px;" colspan="2">
                                            <igtxt:WebDateTimeEdit ID="dITDate" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                                Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                                <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                </ButtonsAppearance>
                                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                            </igtxt:WebDateTimeEdit>
                                        </td>  
                                        </tr>
			                             <tr bgcolor="#ffffff">
	                                        <td  class="bodyheader" style="width: 402px;  height: 12px; " colspan="2">Final Destination </td>
	                                        <td  class="bodyheader" style="width: 422px;  height: 12px;" colspan="2">ETA </td>
	                                         <td  class="bodyheader" style="width: 340px;  height: 12px;" colspan="2">IT Entry Port</td>		                            
                                        </tr>
                                         <tr bgcolor="#ffffff">
    			                            <td  class="bodyheader" style="width: 402px;  height: 28px;" colspan="2"><span style="height: 30px">
					                            <asp:TextBox ID="txtFinalDest" runat="server" CssClass="shorttextfield" Width="70"  ForeColor="Black"></asp:TextBox>
					                          </span></td>
						                         <td  class="bodyheader" style="width: 422px;  height: 28px;" colspan="2">
                                                    <igtxt:WebDateTimeEdit ID="dETA2" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                                        Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                                        <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                        </ButtonsAppearance>
                                                        <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                                    </igtxt:WebDateTimeEdit>
                                                </td>
						                         <td  class="bodyheader" style="width: 340px;  height: 12px;" colspan="2">
						                            <asp:TextBox ID="txtITEntryPort" runat="server" CssClass="shorttextfield" Width="70" MaxLength="64"  ForeColor="Black"></asp:TextBox></td>
						                   </tr>
						                    <tr bgcolor="#ffffff">
	                                            <td  class="bodyheader" style="width: 402px;  height: 12px; " colspan="2">Freight Location </td>
	                                            <td  class="bodyheader" style="width: 422px;  height: 12px;" colspan="2">Container Location </td>
	                                             <td  class="bodyheader" style="width: 340px;  height: 12px;" colspan="2">IT No</td>		                            
                                            </tr>
                                            <TR BGCOLOR="#FFFFFF">
                                                        <td  class="bodyheader" style="width: 402px;  height: 12px; " colspan="2"><asp:TextBox ID="txtFreightLocation" runat="server" CssClass="shorttextfield" Width="70"  ForeColor="Black"></asp:TextBox></td>
                                                         <td  class="bodyheader" style="width: 422px;  height: 12px;" colspan="2"><span style="text-align: left">
                                                          <asp:TextBox ID="txtContainerReturnLoc" runat="server" CssClass="shorttextfield"
                                                                                Width="70" ForeColor="Black"></asp:TextBox>
                                                        </span></td>
                                                        <td  class="bodyheader" style="width: 340px;  height: 12px;" colspan="2"><span style="text-align: left">
                                                          <asp:TextBox ID="txtITNo" runat="server" CssClass="shorttextfield" Width="70" MaxLength="64" ForeColor="Black"></asp:TextBox>
                                                        </span> </td>

                                            </TR>

		                        </table>
		                    </td>
	                     </tr>
	                     
            </table>
            </td>
                        
        </tr>
        </table>
        </td>
        </tr>
        
        <tr>
            <td align="center" bgcolor="#f3f3f3" style="border-bottom: 2px solid #909EB0;  0 24px 0; width: 1192px;">
				<table width="92%" border="0" cellpadding="0" cellspacing="0" bordercolor="#909EB0" bgcolor="#FFFFFF" 
					class="bodyheader" style="padding-left: 10px">
		
					
					
					
				
                   
					
					<tr>
						<td colspan="2" style="text-align: left; height: 12px;">Particulars Furnished by Shipper                        </td>
						<td colspan="2" style="height: 12px">&nbsp;&nbsp;</td>
						<td style="height: 12px">&nbsp;</td>
					</tr>
					<tr>
					</tr>
                    <tr>
                        <td colspan="5" style="text-align: left">
                                            <table cellpadding="0" cellspacing="0" width="90%">
                                                <tr>
                                                    <td style="width: 104px;  text-align: left;">
                                                        Marks and Numbers                                                    </td>
                                                    <td colspan="2" style="text-align: left;">
                                                    No. of CTN</td>
                                                    <td style="width: 14px; text-align: left">
                                                        Gross W/T</td>
                                                    <td style="width: 20px; text-align: left">
                                                        Charge W/T</td>
                                                    <td style="width: 18px; text-align: center">
                                                        Scale</td>
                                                    <td style="width: 40px;  text-align: left">
                                                        Fetch Rate</td>
                                                    <td style="height: 14px; text-align: left" colspan="2">
                                                        Rate</td>
                                                    <td style="width: 102px;  text-align: left">
                                                        Freight Charge</td>
                                                    <td style="width: 114px; text-align: left;">
                                                        &nbsp;Payment </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" style="width: 104px" ><asp:TextBox ID="txtMarksNumbers" runat="server" Height="65px" TextMode="MultiLine" Width="100px" ForeColor="Black"></asp:TextBox></td>
                                                    <td valign="top" style="width: 26px; text-align: left; height: 55px;">
                                                        <asp:TextBox ID="txtNoCtn" onKeyPress="checkNum()" runat="server" Width="40px" CssClass="grid_numberfield" ForeColor="Black"></asp:TextBox></td>
                                                    <td width="28" valign="top" style="width: 26px; text-align: left; height: 55px;"><asp:DropDownList ID="ddlCTNUnit" runat="server" CssClass="net_smallselect"  Width="70px">
                                                      <asp:ListItem>PCS</asp:ListItem>
                                                      <asp:ListItem>CTN</asp:ListItem>
                                                    </asp:DropDownList></td>
                                                    <td valign="top" style="width: 14px; height: 55px; text-align: center">
                                                        <asp:TextBox ID="txtGrossWT" runat="server" Width="40px" onKeyPress="checkNum()" CssClass="grid_numberfield" ForeColor="Black"></asp:TextBox></td>
                                                    <td valign="top" style="width: 20px; height: 55px; text-align: center">
                                                        <asp:TextBox ID="txtChWT" runat="server" Width="40px" onKeyPress="checkNum()" CssClass="grid_numberfield" ForeColor="Black"></asp:TextBox></td>
                                                    <td valign="top" style="width: 18px; height: 55px; text-align: center">
                                                        <asp:DropDownList ID="ddlScale" runat="server" CssClass="net_smallselect"  Width="70px">                                                        
                                                            <asp:ListItem Value="k">KG</asp:ListItem>
                                                            <asp:ListItem Value="l">LB</asp:ListItem>
                                                        </asp:DropDownList></td>
                                                    <td valign="top" style="width: 40px; height: 55px; text-align: center">
                                                        <asp:Image ID="imgFetch" runat="server" ImageUrl="../../ASP/Images/icon_rate_on.gif"  /></td>
                                                    <td valign="top" style="width: 45px; height: 55px; text-align: left">
                                                       
                                                        <asp:TextBox ID="txtRate" runat="server" Width="50px" onKeyPress="checkNum()" CssClass="grid_numberfield" ForeColor="Black"></asp:TextBox></td>
                                                    <td valign="top" style="width: 45px; height: 55px; text-align: left"><asp:Image ID="imgCalc" runat="server" ImageUrl="../../ASP/Images/button_cal.gif" /></td>
                                                    <td style="width: 102px; height: 55px; text-align: center" valign="top">
                                                        <asp:TextBox ID="txtFC" runat="server" Width="93px" onKeyPress="checkNum()" CssClass="grid_numberfield" ForeColor="Black"></asp:TextBox></td>
                                                    <td style="width: 114px; height: 55px; text-align: center" valign="top">
                                                        <asp:RadioButtonList ID="rdPrepaidCollect" runat="server" RepeatDirection="Horizontal" >
                                                            <asp:ListItem Value="Prepaid">Prepaid</asp:ListItem>
                                                            <asp:ListItem Value="Collect" Selected="true">Collect</asp:ListItem>
                                                        </asp:RadioButtonList></td>
                                                </tr>
                                            </table>                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: left">
                                                            Description of Packages and Goods                        </td>
                        <td colspan="2" style="text-align: left">
                                                            Remarks</td>
                        <td>                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="height: 40px; text-align: left;">
                            <asp:TextBox ID="txtDescOfPackagesAndGoods" runat="server" TextMode="MultiLine" Width="250px" ForeColor="Black"></asp:TextBox></td>
                        <td colspan="2" style="height: 40px; text-align: left;">
                            <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Width="250px" ForeColor="Black"></asp:TextBox></td>
                        <td style="height: 40px">                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: left">
                            A/R Account</td>
                        <td>                        </td>
                        <td style="width: 329px">                        </td>
                        <td>                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: left">
                                            <asp:DropDownList ID="ddlARAcct" runat="server" CssClass="net_smallselect">                                            </asp:DropDownList></td>
                        <td>                        </td>
                        <td style="width: 329px">                        </td>
                        <td>                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Label ID="lblARLock" runat="server" CssClass="bodyheader" ForeColor="Red"
                                                Text="Payment Received for this Invoice" Visible="False" Width="430px"></asp:Label></td>
                        <td>                        </td>
                        <td style="width: 329px">                        </td>
                        <td>                        </td>
                    </tr>
                    <tr>
                        <td colspan="5" style="height: 12px; text-align: left">
                                            <asp:UpdatePanel ID="upnlChargeItem" runat="server">
                                                <ContentTemplate>
                                                    <uc3:OCEAN_ARNChargeItemControl id="OCEAN_ARNChargeItemControl1" runat="server"></uc3:OCEAN_ARNChargeItemControl>
                                                    <br />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>                        </td>
                    </tr>
                    <tr>
                        <td colspan="5" style="text-align: left">
                                           
                                            <asp:UpdatePanel ID="upnlCostItem" runat="server">
                                                <ContentTemplate>
                                                    <uc2:OCEAN_ARNCostItemControl ID="OCEAN_ARNCostItemControl1" runat="server" />
                                                </ContentTemplate>
                                            </asp:UpdatePanel>                        </td>
                    </tr>
                    <tr>
                         <td style="height: 12px">                        </td>
                       
                        <td style="text-align: right; height: 12px;">                        </td>
                        <td colspan="2" style="text-align: left; height: 12px;"> </td>
                        <td style="height: 12px">   </td>
                    </tr>
                    <tr>
                        <td>                        </td>
                       
                        <td style="text-align: right">                        </td>
                        <td colspan="2" style="text-align: right"> Prepared by:<asp:TextBox ID="txtPrePraredBy" runat="server" CssClass="shorttextfield" Width="200px" ForeColor="Black"></asp:TextBox></td>
                        <td> Sales Person:<asp:DropDownList ID="ddlSalesPerson" runat="server" CssClass="net_smallselect"
                                                Width="200px" DataTextField="Description" DataValueField="Person">
                                            </asp:DropDownList>                        </td>
                    </tr>
                    <tr>
                        <td style="height: 4px">                        </td>
                        <td style="height: 4px">                        </td>
                        <td style="height: 4px">                        </td>
                        <td style="width: 329px; height: 4px;">                        </td>
                        <td style="height: 4px">                        </td>
                    </tr>
            	</table>			</td>
        </tr>
        <tr>
            <td height="18" bgcolor="#dfe1e6" style="width: 1192px">&nbsp;</td>
        </tr>
        <tr>
            <td style="width: 1192px">&nbsp;</td>
        </tr>
        <tr>
            <td height="18" bgcolor="#f3f3f3" style="width: 1192px">&nbsp;</td>
        </tr>
        <tr>
            <td style="width: 1192px">&nbsp;</td>
        </tr>
        <tr bgcolor="3f3f3f3">
            <td height="18" bgcolor="#f3f3f3" style="width: 1192px"></td>
        </tr>
        <tr>
            <td style="width: 1192px">&nbsp;</td>
        </tr>
        
        <tr>
            <td height="24" align="center" valign="middle" bgcolor="#cfd6df" style="border-top: 1px solid #89a979; width: 1192px;">
                                                        <asp:Image ID="btnSaveNew" runat="server" ImageUrl="../../ASP/images/button_save_new.gif" />
                                                        <asp:Image ID="btnSaveDown" runat="server" ImageUrl="../../ASP/images/button_save_medium.gif" /></td>
        </tr>
</table>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td width="55%" align="right" valign="bottom"><div id="print"> <img align="absbottom" height="27"src="/iff_main/ASP/Images/icon_printer.gif" style="font-weight: bold; font-size: 6pt;
                                        color: #000000; font-family: Verdana" width="40"  /><a href="javascript:;"  onClick="PrintClick('no');return;" ><span
                                            style="color: #000000; text-decoration: underline;">Arrival Notice</span></a>
                        <img
                                                height="10" src="/iff_main/ASP/Images/button_devider.gif" style="font-weight: bold;
                                                font-size: 6pt; color: #000000; font-family: Verdana" width="19" /><a href="javascript:;"  onClick="PrintClick('yes');return;" ><span style="color: #000000; text-decoration: underline;">Arrival Notice &amp;Freight
                                    Invoice</span></a>
                        <img
                                                height="10" src="/iff_main/ASP/Images/button_devider.gif" style="font-weight: bold;
                                                font-size: 6pt; color: #000000; font-family: Verdana" width="19" />
                        <a href="javascript:;"  onClick="AuthClick();return;" ><span style="color: #000000; text-decoration: underline;">Authority
                            Make Entry</span></a><a href="javascript:;" onclick="" style="cursor: pointer"></a></div></td>
        </tr>
    </table>
    <div>
       
                                            <asp:HiddenField ID="hCustomerAcct" runat="server" /><asp:HiddenField ID="hDoNotValidate" runat="server" />
                                             <asp:HiddenField ID="hShipperAcct" runat="server" /><asp:HiddenField ID="hConsigneeAcct" runat="server" />
                                              <asp:HiddenField ID="hNotifyAcct" runat="server" /><asp:HiddenField ID="hBrokerAcct" runat="server" />
                                              
                                            <asp:HiddenField ID="hVendorIDs" runat="server" />
                                                    <asp:HiddenField ID="hCommand" runat="server" /><asp:HiddenField ID="hELT_ACCT" runat="server" />                                        
                                            <asp:HiddenField ID="hCarrierCode" runat="server" />
                     &nbsp;&nbsp;&nbsp;<br />
                    <igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="180px">
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
     
    </form>
    
     <script type="text/javascript" language="javascript">
	ig_initDropCalendar("CustomDropDownCalendar dInvoice dPickup dETD dGoDate dETD2 dETA dETA2 dITDate dLastFree");
</script>

</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
