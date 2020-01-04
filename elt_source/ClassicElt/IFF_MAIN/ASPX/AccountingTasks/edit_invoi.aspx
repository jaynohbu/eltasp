<%@ Page Language="C#" AutoEventWireup="true" CodeFile="edit_invoi.aspx.cs" Inherits="ASPX_edit_invoi" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="Controls/CostItemControl.ascx" TagName="CostItemControl" TagPrefix="uc2" %>

<%@ Register Src="Controls/ChargeItemControl.ascx" TagName="ChargeItemControl" TagPrefix="uc1" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
    
<script type="text/javascript" src="../jScripts/JPED_NET.js"></script>
<script type="text/javascript" src="../jScripts/WindowsManip.js"></script>
<script type="text/javascript" language="javascript" src="../../ASP/ajaxFunctions/ajax.js"></script>
 <script type="text/javascript" src="../jScripts/datetimepicker.js"></script>
 <script type="text/javascript" src="../jScripts/ig_dropCalendar.js"></script>
<SCRIPT src="../jScripts/stanley_J_function.js" type=text/javascript></SCRIPT> 
 <link href="../CSS/elt_css.css" type="text/css" rel="stylesheet"/>
 <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
 <style type="text/css">
<!--
.style1 {color: #cc6600}
-->
 </style>
    <link href="../../CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<body>
<script  type="text/vbscript" language="vbscript">

Sub PrintClick()
    Dim vPrintPort
    vPrintPort = queryPort( "<%=invoicePort%>", "<%=invoiceQueue%>" )
    if( vPrintPort = "-1" ) then exit sub

    On Error Resume Next :

    Dim CustomerInfo(5),vCustomerInfo,InvoiceNo,InvoiceDate,RefNo,vFileNo
    Dim TotalPieces,TotalGrossWeight,Description
    Dim Customer
    Dim OriginDest,CustomerNumber
    Dim EntryNo,EntryDate
    Dim Carrier,ArrivalDept
    Dim MAWB,HAWB
    Dim Remarks(8)
    Dim NoItem,aDesc(128),aAmount(128)
    Dim TotalAmount

    vCustomerInfo=document.form1.txtCustomerInfo.value
    pos=Instr(vCustomerInfo,chr(10))
    i=0
    do While pos>0 And i<5
	    CustomerInfo(i)=Left(vCustomerInfo,pos-2)
	    vCustomerInfo=Mid(vCustomerInfo,pos+1,2000)
	    pos=Instr(vCustomerInfo,chr(10))
	    i=i+1
    loop
    CustomerInfo(i)=vCustomerInfo

    InvoiceNo=document.form1.txtInvoice_no.Value

    If InvoiceNo = "0" Or InvoiceNo = "" Then
	    MsgBox "Please save Invoice data first!"
	    Exit sub
    End if

    InvoiceDate=document.form1.txtIVDate.Value
    RefNo=document.form1.txtRefNo.Value
    RefNoOur=document.form1.txtFileNo.Value
    TotalPieces=document.form1.txtPieces.Value
    TotalGrossWeight=document.form1.txtGrossWeight.Value
    Description=document.form1.txtDescription.Value
    vShipper=document.form1.lstShipperName.Value
    OriginDest=document.form1.txtOrigin.Value &"/"& form1. txtDestination.Value
    CustomerNumber=document.form1.hCustomerAcct.Value
    EntryNo=document.form1.txtEntryNo.value
    EntryDate=document.form1.txtEntryDate.value
    Carrier=document.form1.txtAirlineSteamShip.value
    ArrivalDept=document.form1.txtArrivalDeparture.value
    MAWB=document.form1.txtMasterBillNo.value
    HAWB=document.form1.txtHoutBillNo.value

    //-------------------------------------------------------------------
    ItemDesc=document.form1.ChargeItemControl1_hChItemsDefaultDscArray.Value
    ItemDescArray=Split(ItemDesc,"^^",-1)
    ItemAmount=document.form1.ChargeItemControl1_hChItemsDefaultAmtArray.Value
    ItemAmountArray=Split(ItemAmount,"^^",-1)

    NoItem=UBound(ItemDescArray)

    for i=0 to NoItem
	    aDesc(i)=ItemDescArray(i)
	    aAmount(i)=ItemAmountArray(i)

    next
    //-------------------------------------------------------------------

    TotalAmount=document.form1.txtTotal.Value

    for i=0 to 7
	    Remarks(i)=""
    next


    Set fso = CreateObject("Scripting.FileSystemObject")

    If Not fso.FolderExists("C:\TEMP") Then
	    Set f = fso.CreateFolder("C:\TEMP")
    End If

    If Not fso.FolderExists("C:\TEMP\Eltdata" ) Then
	    Set f = fso.CreateFolder("C:\TEMP\Eltdata" )
    End If

    Set MyFile = fso.CreateTextFile("C:\TEMP\Eltdata\invoice" & InvoiceNo & ".txt", True)
    MyFile.WriteLine(chr(27) & "C" & chr(51))

    Dim Line(40)
    pTop=10
    pLeft=2

    for i=1 to pTop
	    MyFile.WriteLine("")
    next

    Line(1)= Space(45) & InvoiceNo
    Line(1)= Line(1) & Space(57-Len(line(1))) & InvoiceDate
    Line(1)= Line(1) & Space(69-Len(line(1))) & RefNo
    Line(1)= Space(pLeft) & Line(1)

    Line(2)=""
    for i=3 to 7
	    Line(i)=Space(pLeft+1) & CustomerInfo(i-3)
    next

    line(8)=""
    line(9)=Space(42) & aDesc(0)
    line(9)=line(9) & Space(69-Len(line(9))) & aAmount(0)
    line(9)=Space(pLeft) & line(9)
    line(10)=""

    line(11)=TotalPieces

    if Len(line(11)) < 7 then
    line(11)=line(11) & Space(6-Len(line(11))) & TotalGrossWeight
    else
    line(11)=line(11) & Space(10-Len(line(11))) & TotalGrossWeight
    end if

    if Len(line(11)) < 13 then
    line(11)=line(11) & Space(13-Len(line(11))) & Description
    else
    line(11)=line(11) & Space(20-Len(line(11))) & Description
    end if

    line(11)=line(11) & Space( CalcSpace( 46, Len(line(11)) ) ) & aDesc(1)
    line(11)=line(11) & Space( CalcSpace( 69, Len(line(11)) ) ) & aAmount(1)
    line(11)=Space(pLeft) & line(11)

    line(12)=""
    line(13)=Space(42) & aDesc(2)
    line(13)=line(13) & Space( CalcSpace( 69, Len(line(13)) ) ) & aAmount(2)
    line(13)=Space(pLeft) & line(13)
    line(14)=Space(pLeft) & vShipper
    line(15)=Space(42) & aDesc(3)
    line(15)=line(15) & Space( CalcSpace( 69, Len(line(15)) ) ) & aAmount(3)
    line(15)=Space(pLeft) & line(15)
    line(16)=""
    line(17)=OriginDest
    line(17)=line(17) & Space( CalcSpace( 25, Len(line(17)) ) ) & CustomerNumber
    line(17)=line(17) & Space( CalcSpace( 42, Len(line(17)) ) ) & aDesc(4)
    line(17)=line(17) & Space( CalcSpace( 69, Len(line(17)) ) ) & aAmount(4)
    line(17)=Space(pLeft) & line(17)
    line(18)=""
    line(19)=Space(42) & aDesc(5)
    line(19)=line(19) & Space( CalcSpace( 69, Len(line(19)) ) ) & aAmount(5)
    line(19)=Space(pLeft) & line(19)
    line(20)=EntryNo
    line(20)=line(20) & Space( CalcSpace( 23, Len(line(20)) ) ) & EntryDate
    line(21)=Space(42) & aDesc(6)
    line(21)=line(21) & Space( CalcSpace( 69, Len(line(21)) ) ) & aAmount(6)
    line(21)=Space(pLeft) & line(21)
    line(22)=""
    line(23)=Carrier
    line(23)=line(23) & Space( CalcSpace( 25, Len(line(23)) ) ) & ArrivalDept
    line(23)=line(23) & Space( CalcSpace( 42, Len(line(23)) ) ) & aDesc(7)
    line(23)=line(23) & Space( CalcSpace( 69, Len(line(23)) ) ) & aAmount(7)
    line(23)=Space(pLeft) & line(23)
    line(24)=""
    line(25)=Space(42) & aDesc(8)
    line(25)=line(25) & Space( CalcSpace( 69, Len(line(25)) ) ) & aAmount(8)
    line(25)=Space(pLeft) & line(25)
    line(26)=MAWB
    line(26)=line(26) & Space( CalcSpace( 23, Len(line(26)) ) ) & HAWB
    line(27)=Space(42) & aDesc(9)
    line(27)=line(27) & Space( CalcSpace( 69, Len(line(27)) ) ) & aAmount(9)
    line(27)=Space(pLeft) & line(27)
    line(28)=Space(pLeft) & Remarks(0)
    line(29)=Remarks(1)
    line(29)=line(29) & Space( CalcSpace( 42, Len(line(29)) ) ) & aDesc(10)
    line(29)=line(29) & Space( CalcSpace( 69, Len(line(29)) ) ) & aAmount(10)
    line(29)=Space(pLeft) & line(29)
    line(30)=Space(pLeft) & Remarks(2)
    line(31)=Remarks(3)
    line(31)=line(31) & Space( CalcSpace( 42, Len(line(31)) ) ) & aDesc(11)
    line(31)=line(31) & Space( CalcSpace( 69, Len(line(31)) ) ) & aAmount(11)
    line(31)=Space(pLeft) & line(31)
    line(32)=Space(pLeft) & Remarks(4)
    line(33)=Remarks(5)
    line(33)=line(33) & Space( CalcSpace( 42, Len(line(33)) ) ) & aDesc(12)
    line(33)=line(33) & Space( CalcSpace( 69, Len(line(33)) ) ) & aAmount(12)
    line(33)=Space(pLeft) & line(33)
    line(34)=Space(pLeft) & Remarks(6)
    line(35)=Remarks(7)
    line(35)=line(35) & Space( CalcSpace( 42, Len(line(35)) ) ) & aDesc(13)
    line(35)=line(35) & Space( CalcSpace( 69, Len(line(35)) ) ) & aAmount(13)
    line(35)=Space(pLeft) & line(35)
    line(36)=""
    line(37)=Space(69) & TotalAmount
    line(37)=Space(pLeft) & line(37)

    For i=1 to 40
	    MyFile.WriteLine(Line(i))
    next

    MyFile.Close
    Set MyFile=Nothing

    DIM fileName 
    fileName = "c:\TEMP\EltData\invoice" & InvoiceNo & ".txt"

    DIM tmpPort
    On Error Resume Next:
    tmpPort = TRIM(UCASE(vPrintPort))

    if tmpPort = "LPT1" or tmpPort = "LPT2" or tmpPort = "LPT3" or tmpPort = "LPT4" or tmpPort = "LPT5" _ 
    or tmpPort = "LPT6" or tmpPort = "LPT7" or tmpPort = "LPT8" then
	    Call ELTClient.ELTPrintForm(FileName,vPrintPort)
    else
	    Call ELTClient.ELTPrintFormWithNetwork(FileName,vPrintPort)
    end if
    Sleep 2
    // LPT9 port init
    Call ELTClient.ELTPrintPortInit()

End Sub




Sub Sleep(tmpSeconds)
Dim dtmOne,dtmTwo
dtmOne = Now()
While DateDiff("s",dtmOne,dtmTwo) < tmpSeconds
	dtmTwo = Now()
Wend
End Sub


Sub StmtClick()
    On Error Resume Next
    InvoiceNo=document.form1.txtInvoice_no.value
    If InvoiceNo = "0" Or InvoiceNo = "" Then
	    MsgBox "Please save Invoice data first!"
	    Exit sub
    End if

    // by iMoon 2/22/2007
    DIM iType
    if document.form1.hAO.value = "OCEAN" then
	    iType = "O"
    else
	    iType = "A"
    end if

    MAWB=document.form1.txtMasterBillNo.VAlue
    AgentNo=document.form1.hCustomerAcct.Value
    InvoiceDate=document.form1.txtIVDate.Value

    jPopUpPDF()
    window.open("/iff_main/ASP/Acct_tasks/agent_stmt.asp?iType="&iType&"&MAWB=" & MAWB & "&AgentNo=" & AgentNo )
    
End Sub

/////////////////////////////
Sub PDFClick()
    /////////////////////////////
    On Error Resume Next
    InvoiceNo=document.form1.txtInvoice_no.value
    If InvoiceNo = "0" Or InvoiceNo = "" Then
	    MsgBox "Please save Invoice data first!"
	    Exit sub
    End if

    // viewPop2 "PopWin", "/iff_main/ASP/Acct_tasks/invoice_pdf.asp?InvoiceNo=" & InvoiceNo & "&WindowName=" & window.name

    jPopUpPDF()
    window.open("/iff_main/ASP/Acct_tasks/invoice_pdf.asp?Branch="&"<%=elt_account_number%>"&"&InvoiceNo=" & InvoiceNo)
    

END Sub

'Sub ProfitAdj() 
'    InvoiceNo=document.form1.txtInvoice_no.value
'    
'    If InvoiceNo = "0" Or InvoiceNo = "" Then
'	    MsgBox "Please save Invoice data first!"
'	    Exit sub
'    End if
'    qStr="InvoiceNo=" & InvoiceNo & "&" & qStr
'  

'    jPopUpNormal()

'    if "<%=vAO%>" = "OCEAN" then
'	    document.form1.action="of_cost_adjustment.asp?" & qStr & "&WindowName=popUpWin"
'    else
'	    document.form1.action="af_cost_adjustment.asp?" & qStr & "&WindowName=popUpWin"
'    end if
'    	
'    document.form1.method="POST"
'    document.form1.target="popUpWindow"
'    form1.submit()

'End Sub
</script>

<script  type="text/javascript" language="javascript">
	
function validateCustomer()
{    
        if(document.getElementById("lstCustomerName").value=="")
        {
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
        if(ChargeAmountList()){
            CommandChange("SAVE");
            form1.submit();
           }
        }
    }    
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


function ClickPDF()
{

    if( validateCustomer())
    {
        if(validateVendorList())
        { 
            InvoiceNo=document.getElementById("txtInvoice_no").value;
            if (InvoiceNo == "0" ||InvoiceNo == "")
            {
                alert("Please save Invoice data first!");
                return;
            }
            CommandChange("PRINT");
            form1.submit();
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
        alert("You cannot delete this invoice since, Invoice number required!");
    }
    
    else
    {
        var r=confirm("Do you really want to delete Invoice No. '" + INV_No + "' ?");
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
        CommandChange("SAVENEW");
        form1.submit();
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
        
        
         function lstShipperNameChange(orgNum,orgName)
        {          
            var txtObj = document.getElementById("lstShipperName");
            var divObj = document.getElementById("lstShipperNameDiv")            
            document.getElementById("hShipperAcct").value=orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";		    
        }
        
        function lstConsigneeNameChange(orgNum,orgName)
        {            
            var txtObj = document.getElementById("lstConsigneeName");
            var divObj = document.getElementById("lstConsigneeNameDiv") ;       
            document.getElementById("hConsigneeAcct").value=orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";    
		    
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
            
             CommandChange("CHANGECUSTOMER");
             form1.submit();
        }
        
        function reCalculateTotalAmount(salesTax,TotalCharge,AgentProfit, Total){
          var sale=salesTax.value;

          if (sale=="" || sale=="NaN")
          {
            document.getElementById("txtSalesTax").value="0.00"
          }
          if (AgentProfit.value=="" || AgentProfit.value=="NaN" )
          {
            document.getElementById("txtAgentProfit").value="0.00"
          }
          Total.value=parseFloat(TotalCharge.value)-parseFloat(AgentProfit.value)-parseFloat(salesTax.value);
        }
        
        function CommandChange(command){           
            document.getElementById("hCommand").value=command;                     
        }
        
        function clearSearch(obj){        
           obj.value = ''; 
          // obj.style.color='#000000';         
        }
        function resetSearch(obj){
           obj.value = 'Search Here'; 
                  
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


//-->
</script>
    <form id="form1"  method="post"  runat="server">
     <input type="image" style="width:0px; height:0px" onclick="return false;" />
        	<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td width="30%" height="32" align="left" valign="middle" class="pageheader">
                Add Invoices</td>
			<td width="70%" align="right" valign="baseline">
			        <asp:DropDownList ID="ddlNOlist" runat="server" CssClass="net_smallselect">
			                <asp:ListItem Value="arrive" Selected="true">Invoice No.</asp:ListItem>
                            <asp:ListItem Value="house" >House AWB/House B/L No.</asp:ListItem>
                            <asp:ListItem Value="master" >Master AWB/Master B/L No.</asp:ListItem>
                    </asp:dropdownlist>
                <asp:TextBox ID="txtSearchIVNO" value="Search Here" runat="server"  onKeyDown="javascript: if(event.keyCode == 13) { btnSearchClick(); }"  CssClass="lookup" Height="14px" ForeColor="Black"></asp:TextBox>
                                            <asp:ImageButton ID="btnSearchIV" runat="server" ImageUrl="../../asp/images/button_newsearch.gif"  />&nbsp;<!-- Search -->
			</td>
		</tr>
	</table>
	<div class="selectarea">
		<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				<!-- use this when applicable-->
					<span class="select"><!--Select Booking No.--></span></td>
				<td width="55%" rowspan="2" align="right" valign="bottom">
					<div id="print" class="bodyheader">
                        &nbsp;<img align="absBottom" height="27" src="/iff_main/ASP/Images/icon_printer.gif" />&nbsp;
                         <a href="javascript:;" onclick="ClickPDF();return false;" class="bodyheader">Invoice&nbsp;</a>
                        <img height="10" src="/iff_main/ASP/Images/button_devider.gif" />
                        <a href="javascript:;" onclick="StmtClick();return false;">Agent Statement</a></div>
				</td>
			</tr>
			<tr>
				<!-- combo box here -->
				<td width="45%" valign="bottom" style="height: 15px"></td>
			</tr>
		</table>
		<asp:ScriptManager ID="ScriptManager1" runat="server">
			<Services>
				<asp:ServiceReference Path="WebService/WebService.asmx" />
				<asp:ServiceReference Path="WebService/ARStatusService.asmx" />
			</Services>
		</asp:ScriptManager>
	</div>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89a979" class="border1px">
        <tr>
            <td height="24" align="center" valign="middle" bgcolor="#d5e8cb" style="border-bottom: 1px solid #89a979" colspan="4"><table align="center" border="0" cellpadding="0" cellspacing="0" width="98%">
                <tr align="center">
                    <td width="24%">&nbsp;</td>
                    <td bgcolor="#d5e8cb" colspan="1" height="100%" valign="middle" width="52%"><asp:Image ID="btnSaveUp" runat="server" ImageUrl="../../ASP/images/button_save_medium.gif" /></td>
                    <td align="right" valign="middle" width="12%">&nbsp;</td>
                    <td align="right" valign="middle" width="12%">&nbsp;</td>
                </tr>
            </table>            </td>
        </tr>
        <tr>
            <td colspan="4" bgcolor="#f3f3f3" class="bodycopy" style="border-bottom: 2px solid #89a979"><br />
                <br />
                                
                <table border="0" cellspacing="0" cellpadding="0" style="width: 92%; height: 19px">
                    <tr>
                        <td align="right" style="width: 1189px; height: 27px" >
                            <span class="bodyheader">&nbsp;<img src="/iff_main/ASP/Images/required.gif" align="absbottom">Required field</span></td>
                    </tr>
                </table>
                <table width="84%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89a979" bgcolor="#FFFFFF" class="border1px" style="padding-left:10px">
                    <tr>
                        <td height="20" colspan="2" bgcolor="#E7F0E2" class="bodyheader">Invoice No.</td>
                        <td width="26%" bgcolor="#e7f0e2"><span class="bodyheader style1">Invoice Date</span> </td>
                        <td width="15%" bgcolor="#e7f0e2"><span class="bodyheader" style="height: 12px"><span class="bodyheader" style="height: 12px">File No.</span></span></td>
                        <td width="17%" bgcolor="#e7f0e2" class="bodyheader">Reference No.</td>
                    </tr>
                    <tr>
                        <td colspan="2"><asp:TextBox ID="txtInvoice_no" runat="server" CssClass="readonlybold" ReadOnly="true"></asp:TextBox></td>
                        <td><igtxt:WebDateTimeEdit ID="dInvoice" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                    Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                <ButtonsAppearance CustomButtonDisplay="OnRight"> </ButtonsAppearance>
                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                            </igtxt:WebDateTimeEdit>                        </td>
                        <td><asp:TextBox ID="txtFileNo" MaxLength="32" runat="server" CssClass="shorttextfield" ForeColor="Black" Width="90px"></asp:TextBox></td>
                        <td><asp:TextBox ID="txtRefNo" runat="server" MaxLength="64" CssClass="shorttextfield" ForeColor="Black" Width="90px"></asp:TextBox></td>
                    </tr>
                    <tr bgcolor="#f3f3f3">
                        <td width="14%" height="18" class="bodyheader style1"> <img src="/iff_main/ASP/Images/required.gif" align="absbottom">Customer</td>
                        <td width="28%" style="height: 12px">&nbsp;</td>
                        <td style="height: 12px"><span class="bodyheader">Customer No.</span></td>
                        <td style="height: 12px"><span class="bodyheader">Term</span></td>
                        <td style="height: 12px" class="bodyheader">A/R</td>
                    </tr>
                    <tr bgcolor="#ffffff">
                        <td bgcolor="#ffffff" colspan="2" rowspan="5"><!-- Start JPED -->
                                <div id="lstCustomerNameDiv"> </div>
                            <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td><asp:TextBox type="text" autocomplete="off" ID="lstCustomerName" name="lstCustomerName" 
                                                                        class="shorttextfield" style="width: 240px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; height: 12px;"  onkeyup="organizationFill(this,'Customer','lstCustomerNameChange')"
                                                                        onfocus="initializeJPEDField(this);" runat="server" ForeColor="Black" /></td>
                                        <td><img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCustomerName','Customer','lstCustomerNameChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        <td><img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hCustomerAcct','lstCustomerName','txtCustomerInfo')" /></td>
                                        <td><br /></td>
                                    </tr>
                                </table>
                            <!-- End JPED -->
                                <asp:TextBox ID="txtCustomerInfo" runat="server" Rows="5" TextMode="MultiLine" Width="257px" CssClass="outlineTextbox"></asp:TextBox></td>
                        <td height="18"><asp:TextBox ID="txtCustomerNo" onKeyPress="checkNum()" runat="server" CssClass="shorttextfield" ForeColor="Black" Width="125px"></asp:TextBox></td>
                        <td><asp:TextBox ID="txtTerm" runat="server" CssClass="shorttextfield" ForeColor="Black" Width="90px"></asp:TextBox></td>
                        <td><asp:DropDownList ID="ddlARAcct" runat="server" CssClass="smallselect" Width="128px" Height="23px"> </asp:DropDownList></td>
                    </tr>
                    <tr bgcolor="#f3f3f3">
                        <td bgcolor="#f3f3f3"><span class="bodyheader"><span style="height: 12px"><span class="style1">Master AWB</span> / <span class="style1">Master B/L</span></span></span></td>
                        <td height="18" colspan="2" bgcolor="#f3f3f3"><span class="bodyheader"><span class="style1">Hosue AWB</span> / <span class="style1">House B/L</span></span></td>
                    </tr>
                    <tr bgcolor="#ffffff">
                        <td style="height: 18px"><asp:TextBox ID="txtMasterBillNo" MaxLength="32" runat="server" CssClass="shorttextfield" ForeColor="Black" Width="125px"></asp:TextBox></td>
                        <td colspan="2" style="height: 18px"><asp:TextBox ID="txtHoutBillNo" MaxLength="32" runat="server" CssClass="shorttextfield" ForeColor="Black" Width="125px"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td bgcolor="#FFFFFF" class="bodyheader">&nbsp;Due Date</td>
                        <td height="18" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                        <td bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="bodyheader" colspan="3"><igtxt:WebDateTimeEdit ID="dDueDate" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                    Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                            <ButtonsAppearance CustomButtonDisplay="OnRight">
                            </ButtonsAppearance>
                            <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                        </igtxt:WebDateTimeEdit>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3"></td>
                        <td colspan="2"></td>
                    </tr>
                    <tr bgcolor="#f3f3f3">
                        <td height="18" class="bodyheader">Shipper</td>
                        <td class="bodyheader">&nbsp;</td>
                        <td class="bodyheader">Consignee</td>
                        <td class="bodyheader">&nbsp;</td>
                        <td class="bodyheader">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="bodycopy" colspan="2"><div id="lstShipperNameDiv"> </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td><asp:TextBox type="text" autocomplete="off" ID="lstShipperName" name="lstShipperName" value=""
                                                                        class="shorttextfield" style="width: 240px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; height: 12px;" onkeyup="organizationFill(this,'Shipper','lstShipperNameChange')"
                                                                        onfocus="initializeJPEDField(this);" runat="server" ForeColor="Black" /></td>
                                        <td><img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        <td><img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hShipperAcct','lstShipperName','txtShipperInfo')" /></td>
                                    </tr>
                            </table></td>
                        <td colspan="3" class="bodycopy"><div id="lstConsigneeNameDiv"> </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td><asp:TextBox type="text" autocomplete="off" ID="lstConsigneeName" name="lstConsigneeName" value=""
                                                                        class="shorttextfield" style="width: 240px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; height: 12px;" onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange')"
                                                                        onfocus="initializeJPEDField(this);" runat="server" ForeColor="Black" /></td>
                                        <td><img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        <td><img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" /></td>
                                    </tr>
                            </table></td>
                    </tr>
                    <tr bgcolor="#f3f3f3">
                        <td height="18" class="bodyheader"> Pieces</td>
                        <td class="bodyheader">Gross Weight</td>
                        <td class="bodyheader">Charge Weight</td>
                        <td class="bodyheader">Description</td>
                        <td class="bodyheader">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="height: 12px"><asp:TextBox ID="txtPieces" runat="server" MaxLength="32" onKeyPress="checkNum()" CssClass="shorttextfield" ForeColor="Black" Width="70px"></asp:TextBox></td>
                        <td style="height: 12px"><asp:TextBox ID="txtGrossWeight" MaxLength="32" runat="server" CssClass="shorttextfield" ForeColor="Black" Width="125px"></asp:TextBox></td>
                        <td style="height: 12px"><asp:TextBox ID="txtChargeWeight" MaxLength="32" runat="server" CssClass="shorttextfield" ForeColor="Black" Width="125px"></asp:TextBox></td>
                        <td colspan="2" style="height: 12px"><asp:TextBox ID="txtDescription" runat="server" CssClass="shorttextfield" ForeColor="Black" Width="200px"></asp:TextBox></td>
                    </tr>
                    <tr bgcolor="#f3f3f3">
                        <td height="18" class="bodyheader" >Entry No</td>
                        <td class="bodyheader" >Entry Date</td>
                        <td class="bodyheader" >Origin</td>
                        <td class="bodyheader" >Destination</td>
                        <td class="bodyheader">&nbsp;</td>
                    </tr>
                    <tr>
                        <td><asp:TextBox ID="txtEntryNo" runat="server" MaxLength="16" CssClass="shorttextfield" ForeColor="Black" Width="70px"></asp:TextBox></td>
                        <td><igtxt:WebDateTimeEdit ID="dEntry" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                    Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                <ButtonsAppearance CustomButtonDisplay="OnRight"> </ButtonsAppearance>
                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                            </igtxt:WebDateTimeEdit>                        </td>
                        <td><asp:TextBox ID="txtOrigin" runat="server" MaxLength="32" CssClass="shorttextfield" ForeColor="Black" Width="125px"></asp:TextBox></td>
                        <td colspan="2"><asp:TextBox ID="txtDestination" MaxLength="32" runat="server" CssClass="shorttextfield" ForeColor="Black" Width="125px"></asp:TextBox></td>
                    </tr>
                    <tr bgcolor="#f3f3f3">
                        <td height="18" class="bodyheader">Airline/Steamship</td>
                        <td></td>
                        <td class="bodyheader">
                            Arrival Date</td>
                        <td class="bodyheader">&nbsp;Departure Date</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="2" style="height: 12px"><asp:TextBox ID="txtAirlineSteamShip" runat="server" CssClass="shorttextfield" ForeColor="Black" Width="257px"></asp:TextBox></td>
                        <td style="height: 12px"><igtxt:WebDateTimeEdit ID="dArrival" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                    Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                            <ButtonsAppearance CustomButtonDisplay="OnRight">
                            </ButtonsAppearance>
                            <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                        </igtxt:WebDateTimeEdit>
                        </td>
                        <td style="height: 12px"><igtxt:WebDateTimeEdit ID="dDeparture" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                    Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                            <ButtonsAppearance CustomButtonDisplay="OnRight">
                            </ButtonsAppearance>
                            <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                        </igtxt:WebDateTimeEdit>
                        </td>
                        <td style="height: 12px">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="3" style="height: 12px"><asp:Label ID="lblARLock" runat="server" CssClass="bodyheader" ForeColor="Red"
                                                Text="Payment Received for this Invoice" Visible="False" Width="430px"></asp:Label></td>
                        <td style="height: 12px"></td>
                        <td style="height: 12px"></td>
                    </tr>
                </table>
                <br />
            <br /></td></tr>
        
        <tr>
            <td colspan="4"><asp:UpdatePanel ID="upnlChargeItem" runat="server">
                <ContentTemplate>
                    <uc1:ChargeItemControl ID="ChargeItemControl1" runat="server" />
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                        <tr>
                            <td style="width: 30%"></td>
                            <td style="width: 30%; padding-right: 15px" align="right"></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td style="width: 30%; height: 18px;"></td>
                            <td class="bodyheader" align="right" style="padding-right: 15px; height: 18px;">Sales Tax</td>
                            <td style="height: 18px"><asp:TextBox ID="txtSalesTax" onKeyup="checkLimit(this,10000000000,10)" onKeyPress="checkNum()" runat="server"  Text="0.00"  CssClass="numberalign" Width="80px" ></asp:TextBox>
                                &nbsp; </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td class="bodyheader" style="padding-right: 15px" align="right">Agent Profit</td>
                            <td><asp:TextBox ID="txtAgentProfit" runat="server" onKeyup="checkLimit(this,1000000000,9)" onKeyPress="checkNum()" Text="0.00"  CssClass="numberalign" Width="80px"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td class="bodyheader" style="padding-right: 15px" align="right"><span class="style1">TOTAL</span></td>
                            <td style="height: 20px"><asp:TextBox ID="txtTotal" runat="server"  Text="0.00"  CssClass="readonlyboldright" ReadOnly="True" Width="80px"></asp:TextBox></td>
                        </tr>
                    </table>
                    <br />
                </ContentTemplate>
            </asp:UpdatePanel></td>
        </tr>
		<tr>
            <td colspan="4" style="border-top: 1px solid #89a979; border-bottom: 2px solid #89a979"><asp:UpdatePanel ID="upnlCostItem" runat="server">
                <ContentTemplate>
                    <uc2:CostItemControl ID="CostItemControl1" runat="server" />
                </ContentTemplate>
            </asp:UpdatePanel></td>
        </tr>
        <tr bgcolor="#f3f3f3">
            <td width="354" height="18" class="bodyheader" style="padding-left:10px">Remarks</td>
            <td width="694" class="bodyheader">Internal Memo</td>
        </tr>
        <tr>
            <td style="width: 247px; padding-left:10px">
                <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Width="280px" CssClass="outlineTextbox" Rows="4"></asp:TextBox></td>
            <td>
                                                            <asp:TextBox ID="txtInternalMemo" runat="server" TextMode="MultiLine" Width="280px" CssClass="outlineTextbox" Rows="4"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="width: 247px">
                                            <asp:HiddenField ID="hCustomerAcct" runat="server" /><asp:HiddenField ID="hDoNotValidate" runat="server" />
                                            <asp:HiddenField ID="hConsigneeAcct" runat="server" /><asp:HiddenField ID="hVendorIDs" runat="server" />
                                            <asp:HiddenField ID="hShipperAcct" runat="server" /><td colspan="2"><asp:TextBox ID="txttest" runat="server" CssClass="readonlybold" ReadOnly="true"></asp:TextBox>
                                                    <asp:HiddenField ID="hCommand" runat="server" /><asp:HiddenField ID="hELT_ACCT" runat="server" />            </td>
            <td>            </td>
        </tr>
        
        <tr>
            <td height="24" colspan="4" align="center" valign="middle" bgcolor="#d5e8cb" style="border-top: 1px solid #89a979">
				<table align="center" border="0" cellpadding="0" cellspacing="0" width="98%">
					<tr align="center">
						<td width="24%" align="left"><asp:Image ID="btnSaveNew" runat="server" ImageUrl="../../ASP/images/button_save_new.gif" /></td>
						<td bgcolor="#d5e8cb" valign="middle" width="52%">
							<asp:Image ID="btnSaveDown" runat="server" ImageUrl="../../ASP/images/button_save_medium.gif" />                        
						</td>
						<td align="right" valign="middle" width="12%">&nbsp;</td>
						<td align="right" valign="middle" width="12%">
							<img onclick="btnDeleteClick();" src="../../ASP/images/button_delete_medium.gif"
								style="cursor: hand" id="btnDelete" runat="server" /></td>
					</tr>
				</table>
			</td>
        </tr>
    </table>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td width="55%" align="right" valign="bottom" style="height: 31px"><div id="print">
				<img align="absBottom" height="27" src="/iff_main/ASP/Images/icon_printer.gif" />
				<a href="javascript:;"onclick="ClickPDF();return false;" class="bodyheader">Invoice</a>
				<img height="10" src="/iff_main/ASP/Images/button_devider.gif" />
				<a href="javascript:;" onclick="StmtClick();return false;">Agent Statement</a></div></td>
        </tr>
    </table>
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
    
    </form>
    
  
   
    
      <script type="text/javascript" language="javascript">
			ig_initDropCalendar("CustomDropDownCalendar dInvoice dEntry dArrival dDeparture dDueDate");
    </script>
    
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
