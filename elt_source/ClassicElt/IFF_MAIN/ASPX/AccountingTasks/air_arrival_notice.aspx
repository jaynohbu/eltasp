<%@ Page Language="C#" AutoEventWireup="true" CodeFile="air_arrival_notice.aspx.cs" Inherits="ASPX_air_arrival_notice" %>
<%@ Register Src="Controls/AIR_ARNChargeItemControl.ascx" TagName="AIR_ARNChargeItemControl"    TagPrefix="uc3" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ASPX/AccountingTasks/Controls/AIR_ ARNCostItemControl.ascx" TagName="AIR_ARNCostItemControl" TagPrefix="uc2" %>


<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../jScripts/ig_dropCalendar.js"></script>         
    <script type="text/javascript" src="../jScripts/JPED_NET.js"></script>
    <script type="text/javascript" src="../jScripts/MAWB_DROPDOWN.js"></script>
    <SCRIPT src="../jScripts/stanley_J_function.js" type=text/javascript></SCRIPT> 
    <script type="text/javascript" src="../jScripts/WindowsManip.js"></script>
    <script type="text/javascript" language="JavaScript" src="../../ASP/ajaxFunctions/ajax.js"></script>
<!--  #INCLUDE FILE="../include/common.htm" -->
<link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
<link href="../CSS/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<body>
<script  type="text/vbscript" language="VBScript">

/////////////////////////////////////////////////
Sub PrintClick(doInvoice)
/////////////////////////////////////////////////
    iType="A"
    //Sec=document.form1.hSec.Value
    HAWB=document.form1.txtHAWB.Value
    MAWB=document.form1.lstMAWB.Value
    invoice_no=document.form1.txtInvoice_no.Value

    //AgentOrgAcct=document.form1.hAgentOrgAcct.Value
	
	url="../../ASP/air_import/arrival_notice_pdf.asp?iType=" & iType & "&HAWB=" & HAWB&"&MAWB="&MAWB& "&Sec=" & Sec & "&AgentOrgAcct=" & AgentOrgAcct& "&invoice_no="&invoice_no&"&doInvoice="&doInvoice
	//jPopUpPDF()
    window.open(url)
End Sub

/////////////////////////////////////////////////
Sub AuthClick()
/////////////////////////////////////////////////
iType="A"
//Sec=document.form1.hSec.Value
HAWB=document.form1.txtHAWB.Value
invoice_no=document.form1.txtInvoice_no.Value

//AgentOrgAcct=document.form1.hAgentOrgAcct.Value

	//jPopUpPDFAuth()
	//jPopUpPDF()
	url="../../ASP/air_import/AuthorityMakeEntry_pdf.asp?iType=" & iType & "&HAWB=" & HAWB &"&invoice_no="&invoice_no& "&Sec=" & Sec & "&AgentOrgAcct=" & AgentOrgAcct
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

function add_or_updateFC(amtfield){
var amount;
 amount=parseFloat(amtfield.value); 
 if(amtfield.value != "")
 {
      document.getElementById('txtFC').value=parseFloat(amount).toFixed(2);
 }
 if(amount!=0){

     var isThere=document.getElementById("AIR_ARNChargeItemControl1_hIsFCExist").value;
        if(isThere!="Y"){
            if(amount!=0)
            {
                CommandChange("ADDFC");
                document.getElementById("AIR_ARNChargeItemControl1_hFCAmount").value=amount;
                
               
                form1.submit();        
                }     
        }
        else
        {  
          ID=document.getElementById("AIR_ARNChargeItemControl1_hFCAmountFieldID").value;
          document.getElementById(ID).value=amtfield.value;      
        }

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
		
        }
   else{
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



function btnSaveClick(){
    if( validateCustomer()){
       if(validateVendorList()){   
           if(ChargeAmountList())
           {
            CommandChange("SAVE");
            form1.submit();
           }
       }
    }    
}

function btnDeleteClick()
{
    
    var INV_No=document.getElementById("txtInvoice_no").value;
    if("<%=ARLock%>"=="true")
    {
         alert("You cannot delete this invoice since, AR for this invoice has been processed!");
    }
    else if(INV_No == "" || INV_No == "0")
    {
        alert("You cannot delete this invoice since, Air Notice/Invoice Number required!");
    }
    else
    {
     var r=confirm("Do you really want to delete Air Invoice/Arrival Notice No. '" + INV_No + "' ?");
        if (r== true)
        {
            CommandChange("DELETEIV");
            form1.submit();
        }
    }
 }

 

function btnSaveNewClick(){
    if( validateCustomer()){
       if( validateVendorList()){
            if(ChargeAmountList())
           {       
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
         
        function getDefultBroker(org_account_number)
        {

            var url="../../ASPX/AccountingTasks/Ajax/getDefaultBroker.aspx?org_account_number="+ org_account_number;
            var req = new ActiveXObject("Microsoft.XMLHTTP");
            req.open("get",url,false);
            req.send();
            var result =req.responseText;

            return result;
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
    <div>
		<span style="border-bottom: #ba9590 1px solid"></span>
		<table align="center" border="0" cellpadding="2" cellspacing="0" width="95%">
            <tr>
                <td align="left" class="pageheader" valign="middle" style="width: 42%; height: 27px;">
                    Arrival notice &amp; frieght invoice</td>
                <td align="right" valign="baseline" style="width: 44%; height: 27px;">
                    <asp:DropDownList ID="ddlNOlist" runat="server" CssClass="net_smallselect">
			                <asp:ListItem Value="arrive" Selected="true">Arrival Notice(Invoice) No.</asp:ListItem>
                            <asp:ListItem Value="house" >House AWB No.</asp:ListItem>
                            <asp:ListItem Value="master" >Master AWB No.</asp:ListItem>
                    </asp:dropdownlist>
                        <asp:TextBox ID="txtSearchIVNO" runat="server" CssClass="shorttextfield"  Height="15px" ForeColor="Black"  value="Search Here" onKeyDown="javascript: if(event.keyCode == 13) { btnSearchClick(); }" class="lookup"></asp:TextBox>
                        	<asp:ImageButton ID="btnSearchIV"  runat="server" ImageUrl="/iff_main/ASP/Images/icon_search.gif" 
								OnClick="btnSearchIV_Click" />
                </td>
            </tr>
        </table>
        <div class="selectarea">
            <table align="center" border="0" cellpadding="0" cellspacing="0" width="95%" style="height: 29px">
                <tr>
                    <td>
                        <!-- use this when applicable-->
                        <span class="select">
                            <!--Select Booking No.-->
                        </span>
                    </td>
                    <td align="right" rowspan="2" width="55%">
                        <div id="print">
                        <img align="absbottom" height="27"src="/iff_main/ASP/Images/icon_printer.gif" style="font-weight: bold; font-size: 6pt;
                                        color: #000000; font-family: Verdana" width="40"><a href="javascript:;"  onclick="PrintClick('no');return;" >Arrival
                        Notice</a>
                        <img
                                                height="10" src="/iff_main/ASP/Images/button_devider.gif" style="font-weight: bold;
                                                font-size: 6pt; color: #000000; font-family: Verdana" width="19" /><a href="javascript:;"  onclick="PrintClick('yes');return;" >Arrival Notice &amp; Freight Invoice</a>
                        <img
                                                height="10" src="/iff_main/ASP/Images/button_devider.gif" style="font-weight: bold;
                                                font-size: 6pt; color: #000000; font-family: Verdana" width="19" />
                        <a href="javascript:;"  onclick="AuthClick();return;" >Authority to Make Entry</a>                        </div>
                    </td>
                </tr>

                <tr style="font-size: 12pt; font-family: Times New Roman">
                    <!-- combo box here -->
                    <td valign="bottom" width="45%" style="height: 35px">
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

                    

		<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#ba9590" class="border1px">
		          <tr bgcolor="#edd3cf" >
		          <td style="border-bottom: #ba9590 1px solid;"> &nbsp;</td>
                <td align="left"  bgcolor="#edd3cf" style="border-bottom: #ba9590 1px solid; height: 24px; width: 424px; padding-left:110px; ">
                    <asp:Image ID="btnSaveNew" runat="server" ImageUrl="../../ASP/images/button_save_new.gif" />
                     <asp:Image ID="btnSaveDown" runat="server" ImageUrl="../../ASP/images/button_save_medium.gif" />
                    </td>
            </tr>
			<tr>
				<td style="width: 424px; height: 430px;">
					<table border="0" cellpadding="0" cellspacing="0" style="padding-left:10px; width: 173%;">
					    <tr>
					        
							<td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 18px;">
							<table>
							
							        <td height="18" bgcolor="#efe1df" class="bodyheader" style="width: 492px">Master AWB No.</td>
							        
							        <td height="18" bgcolor="#efe1df" class="bodyheader" style="width: 402px">House AWB No.</td>
							
							</table>
							</td>
							
						</tr>
						<tr>
						
					<tr>
                        <td valign="middle">
							<div id="lstMAWBDiv" align=left></div>
								<table cellpadding="0" cellspacing="0" border="0">
									<tr>
										<td style="width: 164px; height: 24px; padding-bottom: 2px; padding-top: 2px;"><asp:TextBox type="text" autocomplete="off" id="lstMAWB" name="lstMAWB" 
												class="shorttextfield" style="width: 160px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
												border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; height: 12px;"  onKeyUp="mawbFill(this,'A','lstMAWBChange')"
												onfocus="initializeMAWB_DDRField(this);" runat="server" ForeColor="Black" /></td>
										<td style="width: 16px; height: 24px;">
											<img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="mawbFill('lstMAWB','A','lstMAWBChange')"
												style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
												border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
										<td style="width: 44px; height: 24px;"></td>		
										<td style="height: 24px"><br /></td>
										<td style="height: 24px">
										</td>
										 <td style="height: 24px" ><asp:TextBox ID="txtHAWB" Width="160" runat="server" CssClass="shorttextfield"
                                                MaxLength="32" ForeColor="Black"></asp:TextBox></td>
									</tr>
							</table>						</td>
                       
                    </tr>
						
						</tr>
						<tr>
						<td style="height: 25px">
							<img src="/iff_main/ASP/Images/icon_goto.gif" width="36" height="21" align="absbottom" /><span class="goto"><b onclick="goDeconsol();" style="cursor:hand">Go to Deconsolidation</b></span>						</td>
						</tr>
						<tr>
							<td height="18" bgcolor="#efe1df" class="bodyheader" style="width: 402px"><img src="/iff_main/ASP/Images/required.gif" align="absbottom"><strong><font color="c16b42">Customer</font></strong></td>
						</tr>
						<tr>
							<td style="width: 402px">
								<div id="lstCustomerNameDiv"></div>
                                <table cellpadding="0" cellspacing="0" border="0">
									<tr>
										  <td style="height: 22px"><asp:TextBox type="text" autocomplete="off" id="lstCustomerName" name="lstCustomerName" 
												class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB; 												border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; height: 12px;"
												onKeyUp="organizationFill(this,'Customer','lstCustomerNameChange')"
												onfocus="initializeJPEDField(this);" runat="server" ForeColor="Black" /></td>
										   <td style="height: 22px">
										   <img src="/ig_common/Images/combobox_drop.gif" alt="" 
												onclick="organizationFillAll('lstCustomerName','Customer','lstCustomerNameChange')"
												style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
												border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
										   <td style="height: 22px">
										   <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
										   onclick="quickAddClient('hCustomerAcct','lstCustomerName','txtCustomerInfo')" />										   </td>
									</tr>
								</table>
                               	<!-- End JPED -->  
                                <asp:TextBox ID="txtCustomerInfo" runat="server" Rows="5" TextMode="MultiLine" Width="300px" CssClass="multilinetextfield" ForeColor="Black">								</asp:TextBox>							</td>
						</tr>
						<tr>
						    <td height="18" bgcolor="#efe1df" class="bodyheader" style="width: 402px">Shipper</td>
					    </tr>
						<tr>
						    <td style="width: 402px">
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
                                            <asp:TextBox ID="txtShipperInfo" runat="server" Rows="5" TextMode="MultiLine" Width="300px" CssClass="multilinetextfield" ForeColor="Black"></asp:TextBox>
							</td>
					    </tr>
						<tr>
						    <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 18px;">Consignee</td>
					    </tr>
						<tr>
						    <td style="width: 402px">
								<div id="lstConsigneeNameDiv">  </div>
                                          <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td>
                                                                  <asp:TextBox type="text" autocomplete="off" id="lstConsigneeName" name="lstConsigneeName" value=""
                                                                        class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; height: 12px;" onKeyUp="organizationFill(this,'Consignee','lstConsigneeNameChange')"
                                                                        onfocus="initializeJPEDField(this);" runat="server" ForeColor="Black" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" /></td>
                                                            </tr>
                                          </table>
                                            <!-- End JPED -->
                                            <asp:TextBox ID="txtConsigneeInfo" runat="server" Rows="5" TextMode="MultiLine" Width="300px" CssClass="multilinetextfield" ForeColor="Black"></asp:TextBox>     
							</td>
					    </tr>
						<tr>
						    <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 18px;">Notify Party/Broker</td>
					    </tr>
						<tr>
						    <td style="width: 402px; height: 86px;">
								<!-- Start JPED -->    <div id="lstNotifyNameDiv">  </div>               <!-- Start JPED -->
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
                                                                         <asp:TextBox ID="txtNotifyInfo" runat="server" Rows="5" TextMode="MultiLine" Width="300px" CssClass="multilinetextfield" ForeColor="Black"></asp:TextBox> 
							</td>
					    </tr>
					</table>
				</td>
			    <td width="66%" align="left" valign="top" style="height: 430px; ">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="height: 54px" id="TABLE1">
                          <tr bgcolor="#efe1df" align="left">
                           <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 14px;">
							<table>
							
							        <td bgcolor="#efe1df" class="bodyheader" style="width: 492px; height: 18px;">Arrival Notice (Invoice)  No.</td>
							        
							        <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 18px;"></td>
							
							</table>
							</td>
                            <!--<td  style="height: 21px; width: 1%;" ></td>-->
                            
                            <td style="height: 14px; width: 1%;" class="bodyheader" ><span style="text-align: left">File No.</span></td>
                        </tr>
                     <tr >
                           
                            <td  style="height: 17px; width: 1%; padding-bottom: 5px; padding-top: 6px;" ><asp:TextBox ID="txtInvoice_no" Width="130px" runat="server" ReadOnly="true" CssClass="readonlybold"></asp:TextBox></td>
                            
                            <td style="height: 17px; width: 1%; padding-bottom: 5px; padding-top: 6px;"><span style="text-align: left">
                              <asp:TextBox ID="txtFileNo" runat="server" CssClass="shorttextfield" ForeColor="Black" MaxLength="64" Width="130px"></asp:TextBox>
                            </span></td>
                        </tr>
                        <tr align="left" style="height: 14px">
                                 <td  class="bodyheader" style="width: 402px; height: 16px;">
							        <table>
							            <tr>
							                <td  class="bodyheader" style="width: 409px; height: 14px;"></td>
							                <td  class="bodyheader" style="width: 402px; height: 14px;"><span style="height: 12px"></span></td>
							            </tr>
							        </table>
							        </td>
                                    
                                    <td style="height: 16px; width: 1%;" class="bodyheader" ></td>
                        </tr>
                       <tr bgcolor="#efe1df" align="left" style="height: 14px">
                         <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 12px;">
							<table>
							    <tr>
							        <td bgcolor="#efe1df" class="bodyheader" style="width: 374px; height: 14px;">Customer Reference No.</td>
							        
							        <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 14px;">Sub AWB No.</td>
							    </tr>
							</table>
							</td>
                            
                            <td style="height: 12px; width: 1%;" class="bodyheader" ><span style="text-align: left">Flight No.</span></td>
                        </tr>
                        
                        
                        <tr  align="left" style="height: 14px">
                        <td class="bodyheader" style="width: 402px; height: 10px;">
						<table>
							<tr>
                            <td class="bodyheader" style="width: 348px; height: 14px; padding-bottom: 6px; padding-top: 5px;">
                                  <asp:TextBox ID="txtRefNo" runat="server" CssClass="shorttextfield" MaxLength="64" ForeColor="Black" Width="130px"></asp:TextBox>
                            </td>
                            <td  class="bodyheader" style="width: 402px; height: 14px;">
                            <span style="height: 18px">
                                <asp:TextBox ID="txtSubAWB" runat="server" CssClass="shorttextfield" Width="130px" MaxLength="32" ForeColor="Black"></asp:TextBox>
                                </span>
                            </td>
						</tr>
						</table>
					    </td>
					    <td style="height: 10px; width: 1%;"  >
                            <span style="height: 18px">
                              <asp:TextBox ID="txtFlightNo" runat="server" CssClass="shorttextfield" ForeColor="Black" MaxLength="32" Width="130px"></asp:TextBox>
                            </span></td>
                        </tr>
                        
                        
                        <tr bgcolor="#efe1df" align="left" style="height: 14px">
                         <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 12px;">
							<table>
							    <tr bgcolor="#efe1df">
                         
							        <td bgcolor="#efe1df" class="bodyheader" style="width: 492px; height: 12px;">Invoice Date</td>
							        
							        <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 12px;"></td>
							    </tr>
							
							</table>
							</td>
                            
                            <td style="height: 12px; width: 1%;" class="bodyheader" ><span style="text-align: left">Dock. Pickup Date</span></td>
                        </tr>
                        <tr>
                         <td class="bodyheader" style="width: 402px; height: 12px;">
						    <table>
							    <tr>
                                <td class="bodyheader" style="width: 492px; height: 14px; padding-bottom: 5px; padding-top: 5px;">
                                    <span style="height: 18px; color: white;">
                                        <igtxt:WebDateTimeEdit ID="dInvoice" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                          Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                          <ButtonsAppearance CustomButtonDisplay="OnRight">
                                          </ButtonsAppearance>
                                          <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                      </igtxt:WebDateTimeEdit>
                                  </span>
                                </td>
                                      <td  class="bodyheader" style="width: 402px; height: 14px;"></td>
							    </tr>
							</table>
							</td>
                         <td style="height: 12px; width: 1%;"  >
                             <igtxt:WebDateTimeEdit ID="dPickup" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                    Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                    <ButtonsAppearance CustomButtonDisplay="OnRight">
                                    </ButtonsAppearance>
                                    <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                </igtxt:WebDateTimeEdit>
                         </td>
                        </tr>
    
                        <tr bgcolor="#efe1df" align="left" style="height: 14px">
                                 <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 12px;">
							        <table>
							            <tr>
							                <td bgcolor="#efe1df" class="bodyheader" style="width: 387px; height: 14px;">Port of Loading</td>
							                <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 14px;">ETD</td>
							            </tr>
							        </table>
							        </td>
                                    
                                    <td style="height: 12px; width: 1%;" class="bodyheader" ><span style="text-align: left">Last Free Date</span></td>
                                </tr>
                                <tr  align="left" style="height: 14px">
                                        <td class="bodyheader" style="width: 402px; height: 14px;">
						                <table>
							                <tr>
                                            <td class="bodyheader" style="width: 409px; height: 15px; padding-bottom: 5px; padding-top: 5px;">
                                            <asp:DropDownList ID="ddlPortOfLoading" runat="server" CssClass="net_smallselect"
                                                DataTextField="Port_desc" DataValueField="Port_code" Width="175px"> </asp:DropDownList>
                                        </td>
                                        <td  class="bodyheader" style="width: 402px; height: 15px;">
                                                <igtxt:WebDateTimeEdit ID="dETD" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                                Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                                <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                </ButtonsAppearance>
                                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                            </igtxt:WebDateTimeEdit>
                                        </td>
                                
						        </tr>
						        </table>
					            </td>
					            <td style="height: 14px; width: 1%;">
					            <span style="height: 7px">
					                   <igtxt:WebDateTimeEdit ID="dLastFree" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                    Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                    <ButtonsAppearance CustomButtonDisplay="OnRight">
                                    </ButtonsAppearance>
                                    <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                </igtxt:WebDateTimeEdit>
                            </span></td>
                        </tr>
                        <tr bgcolor="#efe1df" align="left" style="height: 14px">
                             <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 12px;">
							    <table>
							        <tr bgcolor="#efe1df">
							            <td bgcolor="#efe1df" class="bodyheader" style="width: 376px; height: 14px;">Port of Discharge</td>
							            <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 14px;">ETA</td>
							        </tr>
    							
							    </table>
							</td>
                            
                            <td style="height: 12px; width: 1%;" class="bodyheader" ><span style="text-align: left">G.O. Date</span></td>
                        </tr>
                        <tr>
                         <td class="bodyheader" style="width: 402px; height: 12px;">
						    <table>
							    <tr>
                                    <td class="bodyheader" style="width: 442px; height: 15px; padding-bottom: 5px; padding-top: 5px;">
                                            <asp:DropDownList ID="ddlPortOfDischarge" runat="server" CssClass="net_smallselect"
                                              DataTextField="Port_desc" DataValueField="Port_code" Width="175px"> </asp:DropDownList>
                                   </td>
                                   <td  class="bodyheader" style="width: 402px; height: 15px;"> 
                                        <igtxt:WebDateTimeEdit ID="dETA" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                          Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                          <ButtonsAppearance CustomButtonDisplay="OnRight">
                                          </ButtonsAppearance>
                                          <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                              </igtxt:WebDateTimeEdit></td>
                                  </tr>
							</table>
							</td>
							<td style="height: 12px; width: 1%;">
							<span style="height: 7px">
                              <igtxt:WebDateTimeEdit ID="dGoDate" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                  Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                  <ButtonsAppearance CustomButtonDisplay="OnRight">
                                  </ButtonsAppearance>
                                  <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                              </igtxt:WebDateTimeEdit>
                          </span></td>
                        </tr>
                            <tr bgcolor="#efe1df" align="left" style="height: 14px">
                                 <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 12px;">
							        <table>
							            <tr>
							                <td bgcolor="#efe1df" class="bodyheader" style="width: 387px; height: 14px;">Place of Delivery</td>
							                <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 14px;">ETD</td>
							            </tr>
							        </table>
							        </td>
                                    
                                    <td style="height: 12px; width: 1%;" class="bodyheader" ><span style="text-align: left">I.T. Date</span></td>
                                </tr>
                                <tr  align="left" style="height: 14px">
                                        <td class="bodyheader" style="width: 402px; height: 14px;">
						                <table>
							                <tr>
                                            <td class="bodyheader" style="width: 905px; height: 15px; padding-bottom: 4px; padding-top: 4px;">
                                            <asp:TextBox ID="txtPlaceOfDelivery" runat="server" CssClass="shorttextfield"
                                                Width="129px" MaxLength="64" ForeColor="Black"></asp:TextBox>
                                           </td>
             
                                            <td  class="bodyheader" style="width: 402px; height: 15px;">
                                            <span style="width: 11px">
                                                <igtxt:WebDateTimeEdit ID="dETD2" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                                    Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                                    <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                    </ButtonsAppearance>
                                                    <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                                </igtxt:WebDateTimeEdit>
                                                </span>
                                              </td>
						                </tr>
						            </table>
					            </td>
					            <td style="height: 14px; width: 1%;">
					                <igtxt:WebDateTimeEdit ID="dITDate" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                        Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                        <ButtonsAppearance CustomButtonDisplay="OnRight">
                                        </ButtonsAppearance>
                                        <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                    </igtxt:WebDateTimeEdit>
                            </td>                                
                        </tr>
                        <tr bgcolor="#efe1df" align="left" style="height: 14px">
                             <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 12px;">
							    <table>
							        <tr bgcolor="#efe1df">
							            <td bgcolor="#efe1df" class="bodyheader" style="width: 370px; height: 14px;">Final Destination</td>
							            <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 14px;"><span style="width: 11px">ETA</span></td>
							        </tr>
    							
							    </table>
							</td>
                            
                            <td style="height: 12px; width: 1%;" class="bodyheader" ><span style="height: 12px">I.T. Entry Port</span></td>
                        </tr>
                         <tr>
                         <td class="bodyheader" style="width: 402px; height: 12px;">
						    <table>
							    <tr>
                                    <td class="bodyheader" style="width: 1096px; height: 15px; padding-bottom: 5px; padding-top: 5px;">
                                    <span style="height: 12px">
                                        <asp:TextBox ID="txtFinalDest" runat="server" CssClass="shorttextfield" Width="130px" ForeColor="Black"></asp:TextBox>
                                      </span>
                                    </td>
                        
                                   <td  class="bodyheader" style="width: 402px; height: 15px; padding-bottom: 5px; padding-top: 5px;">
                                           <igtxt:WebDateTimeEdit ID="dETA2" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                          Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                          <ButtonsAppearance CustomButtonDisplay="OnRight">
                                          </ButtonsAppearance>
                                          <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                      </igtxt:WebDateTimeEdit>
                                   </td>
                        
                         </tr>
							</table>
							</td>
							<td style="height: 12px; width: 1%;"><a href="javascript:NewCal('txtETA2','mmddyyyy')"><asp:TextBox ID="txtITEntryPort" runat="server" CssClass="shorttextfield" Width="130px" ForeColor="Black"></asp:TextBox>
                          </a> </td>
							</tr>
							<tr bgcolor="#efe1df" align="left" style="height: 14px">
                                 <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 12px;">
							        <table>
							            <tr>
							                <td bgcolor="#efe1df" class="bodyheader" style="width: 409px; height: 14px;"><div align="left">Freight Location </div></td>
							                <td bgcolor="#efe1df" class="bodyheader" style="width: 402px; height: 14px;"><div align="left">Conainer Return Location </div></td>
							            </tr>
							        </table>
							        </td>
                                    
                                    <td style="height: 12px; width: 1%;" class="bodyheader" ><div align="left">I.T No. </div></td>
                                </tr>
                                <tr  align="left" style="height: 14px">
                                        <td class="bodyheader" style="width: 402px; height: 14px;">
						                <table>
							                <tr>
                                            <td class="bodyheader" style="width: 420px; height: 15px; padding-bottom: 4px; padding-top: 4px;">
                                               <div align="left">
                                                <asp:TextBox ID="txtFreightLocation" runat="server" CssClass="shorttextfield" Width="130px" ForeColor="Black"></asp:TextBox>
                                              </div></td>
                                            <td  class="bodyheader" style="width: 402px; height: 15px;">
                                               <span style="height: 7px">
                                              </span> <span style="height: 7px"><asp:TextBox ID="txtContainerReturnLoc" runat="server" CssClass="shorttextfield"
                                                                    Width="130px" ForeColor="Black"></asp:TextBox>
                                              </span>
                                             </td>
						                </tr>
						            </table>
					            </td>
                                <td style="height: 14px; width: 1%;">
                                    <asp:TextBox ID="txtITNo" runat="server" CssClass="shorttextfield" Width="130px" MaxLength="64" ForeColor="Black"></asp:TextBox>                          
                               </td>
                        </tr>

                         <tr>
                         
                        </tr>

                        <tr  align="left" style="height: 14px">
                                        <td class="bodyheader" style="width: 402px; height: 14px;">
						                <table>
							                <tr>
                                            <td class="bodyheader" style="width: 420px; height: 15px; padding-bottom: 4px; padding-top: 4px;">
                                           </td>
                                        <td  class="bodyheader" style="width: 402px; height: 15px; padding-bottom: 5px; padding-top: 5px;">
                                                
                                        </td>
                                    </tr>
						            </table>
					            </td>
                                <td style="height: 14px; width: 1%;">
                                       </td>
                        </tr>                        
                        </table></td>
			        </tr>
			        
			        
			<tr>
				<td style="width: 424px">&nbsp;</td>
			    <td>&nbsp;</td>
			</tr>
		</table>
		<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#ba9590" class="border1px" style="padding-left:10px">
    <tr class="bodyheader">
        <td height="18">Marks and Numbers</td>
        <td>No. of CTN</td>
        <td>Gross W/T</td>
        <td>Charge W/T</td>
        <td>Fetch Rate</td>
        <td>Rate</td>
        <td>&nbsp;</td>
        <td>Freight Charge</td>
        <td>Payment </td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td valign="top"><asp:TextBox ID="txtMarksNumbers" runat="server" Height="50px" TextMode="MultiLine" Width="200px" ForeColor="Black"></asp:TextBox>		</td>
        <td valign="top"><asp:TextBox ID="txtNoCtn" runat="server" onKeyPress="checkNum()" Width="30px" CssClass="grid_numberfield" ForeColor="Black"></asp:TextBox>		</td>
        <td valign="top">
            <asp:TextBox ID="txtGrossWT" runat="server" onKeyPress="checkNum()" Width="40px" CssClass="grid_numberfield" ForeColor="Black">			</asp:TextBox>
            <asp:DropDownList ID="ddlCTNUnit" runat="server" CssClass="net_smallselect">
			  <asp:ListItem>PCS</asp:ListItem>
			  <asp:ListItem>CTN</asp:ListItem>
			</asp:DropDownList>		</td>
        <td valign="top">
            <asp:TextBox ID="txtChWT" runat="server" Width="40px" onKeyPress="checkNum()" CssClass="grid_numberfield" ForeColor="Black">			</asp:TextBox>
            <asp:DropDownList ID="ddlScale" runat="server" CssClass="net_smallselect">
                <asp:ListItem Value="K">KG</asp:ListItem>
                <asp:ListItem Value="L">LB</asp:ListItem>
            </asp:DropDownList>		</td>
        <td valign="top">
            <asp:Image ID="imgFetch" runat="server" ImageUrl="../../ASP/Images/icon_rate_on.gif"  />            
        </td>
        <td valign="top">
            <asp:TextBox ID="txtRate" runat="server" onKeyPress="checkNum()"  Width="40px" CssClass="grid_numberfield" ForeColor="Black">
			</asp:TextBox>
        </td>
        <td valign="top"><asp:Image ID="imgCalc" runat="server" ImageUrl="../../ASP/Images/button_cal.gif" /></td>
        <td valign="top"><asp:TextBox ID="txtFC" onKeyPress="checkNum()" runat="server" Width="40px" CssClass="grid_numberfield" ForeColor="Black"></asp:TextBox></td>
        <td valign="top"> 
			<asp:RadioButtonList ID="rdPrepaidCollect" runat="server" RepeatDirection="Horizontal" >
			  <asp:ListItem Value="Prepaid">Prepaid</asp:ListItem>
			  <asp:ListItem Value="Collect" Selected="True">Collect</asp:ListItem>
			</asp:RadioButtonList>
		</td>
        <td valign="top">&nbsp;</td>
    </tr>

</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#ba9590" class="border1px" style="padding-left:10px">
<tr>
<td bgcolor="#efe1df" style="width: 1484px" >
<table>
<tr>
<td bgcolor="#efe1df" class="bodyheader" style=" height: 14px; width: 411px;">Descripton of Packages and Goods</td>
<td bgcolor="#efe1df" class="bodyheader" style=" height: 14px; width: 222px;"><span style="height: 12px">Remarks</span></td>
</tr>
</table>
</td>

</tr>
<tr>
<td bgcolor="#ffffff" style="width: 1484px" >
<table>
<tr>
    <td bgcolor="#ffffff" class="bodyheader" style=" height: 14px; width: 411px;"><div align="left"><span style="height: 12px">
         </span>
              </div><span style="height: 12px"><asp:TextBox ID="txtDescOfPackagesAndGoods" runat="server" TextMode="MultiLine" Width="250px" ForeColor="Black"></asp:TextBox>
         </span>
   </td>
<td bgcolor="#ffffff" class="bodyheader" style=" height: 14px; width: 222px;"><span style="height: 12px"><asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Width="250px" ForeColor="Black"></asp:TextBox> </span> </td>
</tr>
</table>
</td>
    </tr>
    <tr>

    </tr>
    <tr>
        <td colspan="2" style="text-align: left; height: 12px;"><div align="left"><span style="height: 14px">AR Account</span></div></td>
    </tr>
    <tr>
        <td style="height: 18px">
              <span style="height: 12px"><asp:DropDownList ID="ddlARAcct" runat="server" CssClass="net_smallselect"> </asp:DropDownList></span>   
        </td>
    </tr>
    <tr>
    <td style="width: 1484px">
    <fieldset style="height: 16px"><legend>ACCOUNTING</legend></fieldset>	
				    <asp:UpdatePanel ID="upnlChargeItem" runat="server">
					    <ContentTemplate>
						    <uc3:AIR_ARNChargeItemControl id="AIR_ARNChargeItemControl1" runat="server">
						    </uc3:AIR_ARNChargeItemControl>
					    </ContentTemplate>
				    </asp:UpdatePanel>								
				    <asp:UpdatePanel ID="upnlCostItem" runat="server">
					    <ContentTemplate>
						    <uc2:AIR_ARNCostItemControl ID="AIR_ARNCostItemControl1" runat="server" />
					    </ContentTemplate>
				    </asp:UpdatePanel></td>
    </tr>
    <tr>
               <td align="right">
                    <table>
                        <tr>
                            <td colspan="2" style="text-align: right"> 
                                <strong>Prepared by:</strong><asp:TextBox ID="txtPrePraredBy" runat="server" CssClass="shorttextfield" Width="200px" ForeColor="Black"></asp:TextBox></td>
                            <td> 
                                <strong>Sales Person:</strong><asp:DropDownList ID="ddlSalesPerson" runat="server" CssClass="net_smallselect"
                            Width="200px" DataTextField="Description" DataValueField="Person">
                            </asp:DropDownList>  
                            </td>
                        </tr>
                    </table>
            </td>
    </tr>
      <tr bgcolor="#efe1df">
                <td align="left" bgcolor="white" style="padding-right: 0px; padding-left: 0px;
                     border-bottom: #ba9590 2px solid">
					
                    <table bgcolor="#ffffff" border="0" bordercolor="#ba9590" cellpadding="0" cellspacing="0"
                        class="border1px" style="padding-left: 10px; text-align: left;" width="100%" id="TABLE2">
                        <tr>
                            <td colspan="6" style="height: 12px">
                                <asp:Label ID="lblARLock" runat="server" CssClass="bodyheader" ForeColor="Red"
                                                Text="Payment Received for this Invoice" Visible="False" Width="430px"></asp:Label></td>
                        </tr>
                        
		</table> 
		</td>
		</tr>
          <tr style="font-size: 12pt; font-family: Times New Roman">
                <td align="center" bgcolor="#edd3cf" height="24" style="border-top: #89a979 1px solid; width: 1484px;"
                    valign="middle">
                    <asp:Image ID="btnSaveUp" runat="server" ImageUrl="../../ASP/images/button_save_medium.gif" />

                                            <img onclick="btnDeleteClick();" src="../../ASP/images/button_delete_medium.gif"
                                                style="cursor: hand" id="btnDelete" runat="server" />
                                                       </td>
            </tr>



</table>

        <br />

        <table align="center" border="0" cellpadding="0" cellspacing="0" style="font-size: 12pt;
            font-family: Times New Roman" width="95%">
            <tr>
                <td align="right"  valign="bottom" width="55%">
                    <div id="Div1">
                        <img align="absbottom" height="27"src="/iff_main/ASP/Images/icon_printer.gif" style="font-weight: bold; font-size: 6pt;
                                        color: #000000; font-family: Verdana" width="40"><a href="javascript:;"  onclick="PrintClick('no');return;" ><span
                                            style="color: #000000; text-decoration: underline;">Arrival Notice</span></a>
                        <img
                                                height="10" src="/iff_main/ASP/Images/button_devider.gif" style="font-weight: bold;
                                                font-size: 6pt; color: #000000; font-family: Verdana" width="19" /><a href="javascript:;"  onclick="PrintClick('yes');return;" ><span style="color: #000000; text-decoration: underline;">Arrival Notice &amp;Freight
                                    Invoice</span></a>
                        <img
                                                height="10" src="/iff_main/ASP/Images/button_devider.gif" style="font-weight: bold;
                                                font-size: 6pt; color: #000000; font-family: Verdana" width="19" />
                        <a href="javascript:;"  onclick="AuthClick();return;" ><span style="color: #000000; text-decoration: underline;">Authority
                            Make Entry</span></a><a href="javascript:;" onclick="" style="cursor: pointer"><span
                                style="color: #0000ff"></span></a></div>
                </td>
            </tr>
        </table>
       
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
