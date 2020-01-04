<%@ LANGUAGE = VBScript %>
<html>
<head>
<title>AE Search</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<script type="text/jscript" language="javascript" src="../include/WebDateSetJN.js"></script>
<script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>
<script type="text/jscript" language="javascript" src="../include/JPED.js"></script>
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<script language='JScript' src='../Include/iMoonCombo.js'></script>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->

<script type="text/javascript">

var ComboBoxes =  new Array('lstMAWB');
// -->
</script>

<script type="text/jscript">
	// changed by stanley
	function lstShipperNameChange(orgNum,orgName){
		var hiddenObj = document.getElementById("hShipperAcct");
		var infoObj = document.getElementById("txtShipperInfo");
		var txtObj = document.getElementById("lstShipperName");
		var divObj = document.getElementById("lstShipperNameDiv");
		
		hiddenObj.value = orgNum;
		infoObj.value = getOrganizationInfo(orgNum,"B");
		txtObj.value = orgName;
		divObj.style.position = "absolute";
		divObj.style.visibility = "hidden";
		divObj.style.height = "0px";
		divObj.innerHTML = "";

	}
	// changed by stanley
	function lstConsigneeNameChange(CONum,COName){
		var chiddenObj = document.getElementById("hConsigneeAcct");
		var cinfoObj = document.getElementById("txtConsigneeInfo");
		var ctxtObj = document.getElementById("lstConsigneeName");
		var cdivObj = document.getElementById("lstConsigneeNameDiv");
		
		chiddenObj.value = CONum;
		cinfoObj.value = getOrganizationInfo(CONum,"B");
		ctxtObj.value = COName;
		cdivObj.style.position = "absolute";
		cdivObj.style.visibility = "hidden";
		cdivObj.style.height = "0px";
		cdivObj.innerHTML = "";

	}
	// changed by stanley
	function lstCarrierNameChange(orgNum,orgName){
	var c_hiddenObj = document.getElementById("hCarrierAcct");
	var c_infoObj = document.getElementById("txtCarrierInfo");
	var c_txtObj = document.getElementById("lstCarrierName");
	var c_divObj = document.getElementById("lstCarrierNameDiv");
	
	c_hiddenObj.value = orgNum;
	c_infoObj.value = getOrganizationInfo(orgNum,"B");
	c_txtObj.value = orgName;
	c_divObj.style.position = "absolute";
	c_divObj.style.visibility = "hidden";
	c_divObj.style.height = "0px";
	c_divObj.innerHTML = "";

	}
		function lstNotifyNameChange(CONum,COName){
		var NhiddenObj = document.getElementById("hNotifyAcct");
		var NinfoObj = document.getElementById("txtNotifyInfo");
		var NtxtObj = document.getElementById("lstNotifyName");
		var NdivObj = document.getElementById("lstNotifyNameDiv");
		
		NhiddenObj.value = CONum;
		NinfoObj.value = getOrganizationInfo(CONum,"B");
		NtxtObj.value = COName;
		NdivObj.style.position = "absolute";
		NdivObj.style.visibility = "hidden";
		NdivObj.style.height = "0px";
		NdivObj.innerHTML = "";

	}
	// changed by stanley
	function HreloadPage()
	{
	document.getElementById("lstAgentName").value="";
	document.getElementById("txt_HAWB").value="";
	document.getElementById("txtLC").value="";
	document.getElementById("txtInvoice").value="";
	document.getElementById("txtUserRef").value="";
    vreloadPage();
	}
// changed by stanley	
	function MreloadPage()
	{
	document.getElementById("Check_Clo").checked=false;
    document.getElementById("Check_Clo").value="";
	document.getElementById("Check_Use").checked=false;
	document.getElementById("Check_Use").value="";
	document.getElementById("Check_Al2").checked=true;
    vreloadPage();
	}



	// changed by stanley	
	function vreloadPage()
	{
	document.getElementById("lstSalesRP").value="";
	document.getElementById("LastFour").value="";
	document.getElementById("txt_FILE_NO").value="";
	document.getElementById("txt_ITN_NO").value="";
	document.getElementById("lstCarrierName").value="";
	document.getElementById("lstConsigneeName").value="";
	document.getElementById("lstMAWB").value="";
	document.getElementById("Service_L").value="";
	document.getElementById("SalesRf").value="";
	document.getElementById("lstShipperName").value="";
	document.getElementById("lstNotifyName").value="";
	document.getElementById("lstDestPort").value="";
	document.getElementById("Rew").value="";
	document.getElementById("lstOriginPort").value="";
	document.getElementById("txtNoPiece").value="";
    document.getElementById("lstSortType").value="";
	document.getElementById("Rsort").value="";
	document.getElementById("D_select").value="Clear";
	document.getElementById("txtEndDate").value="";
	document.getElementById("txtStartDate").value="";
	document.getElementById("Refer").value="Y";
	document.getElementById("COD").value=""		
	document.getElementById("COD_AL").checked=true;
	GoSearch();
	}

// changed by stanley
	function lstAgentNameChange(ANum,AName){
		var AhiddenObj = document.getElementById("hAgentAcct");
		var AinfoObj = document.getElementById("txtAgentInfo");
		var AtxtObj = document.getElementById("lstAgentName");
		var AdivObj = document.getElementById("lstAgentNameDiv");
		AhiddenObj.value = ANum;
		AinfoObj.value = getOrganizationInfo(ANum,"B");
		AtxtObj.value = AName;
		AdivObj.style.position = "absolute";
		AdivObj.style.visibility = "hidden";
		AdivObj.style.height = "0px";
		AdivObj.innerHTML = "";		
	}
// changed by stanley
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
		var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=" + infoFormat + "&org=" + orgNum;	
		xmlHTTP.open("GET",url,false); 
		xmlHTTP.send();		
		return xmlHTTP.responseText; 
	}
	// changed by stanley
	function S_checked(){
	if (document.getElementById("Check_Sub").checked=true)
	{
	document.getElementById("Check_Sub").value="Y";
	document.getElementById("Check_AL1").checked=false;
	document.getElementById("Check_Mas").checked=false;
	document.getElementById("Check_Mas").value="";
	}
	}
	// changed by stanley
	function M_checked(){
	if (document.getElementById("Check_Mas").checked=true)
	{
	document.getElementById("Check_Mas").value="Y";
	document.getElementById("Check_AL1").checked=false;
	document.getElementById("Check_Sub").checked=false;
	document.getElementById("Check_Sub").value="";
	}
	}
	// changed by stanley	
	function AL_checked(){
	if (document.getElementById("Check_AL1").checked=true)
	{
	document.getElementById("Check_Mas").checked=false;
	document.getElementById("Check_Sub").checked=false;
	document.getElementById("Check_Mas").value="";
    document.getElementById("Check_Sub").value="";
	}
	}
	// changed by stanley
	function Y_checked(){
	if (document.getElementById("Check_Yes").checked=true)
	{
	document.getElementById("Check_Yes").value="yes";
	document.getElementById("Check_Co").value="";
	document.getElementById("Check_Co").checked=false;
	document.getElementById("Check_Bo").checked=false;
	}
	}
		// changed by stanley
	function Y_COD(){
	if (document.getElementById("COD_YES").checked=true)
	{
	document.getElementById("COD").value="Y";
	document.getElementById("COD_NO").checked=false;
	document.getElementById("COD_AL").checked=false;
	}
	}
	function N_COD(){
	if (document.getElementById("COD_NO").checked=true)
	{
	document.getElementById("COD").value="N";
	document.getElementById("COD_YES").checked=false;
	document.getElementById("COD_AL").checked=false;
	}
	}
	function A_COD(){
	if (document.getElementById("COD_AL").checked=true)
	{
	document.getElementById("COD").value="";
	document.getElementById("COD_YES").checked=false;
	document.getElementById("COD_NO").checked=false;
	}
	}
	
	// changed by stanley
	function C_checked(){
	if (document.getElementById("Check_Co").checked=true)
	{
	document.getElementById("Check_Co").value="yes";
	document.getElementById("Check_Yes").value="";
	document.getElementById("Check_Yes").checked=false;
	document.getElementById("Check_Bo").checked=false;
	}
	}
	// changed by stanley
	function B_checked(){
	if (document.getElementById("Check_Bo").checked=true)
	{
	document.getElementById("Check_Yes").value="";
	document.getElementById("Check_Co").value="";
	document.getElementById("Check_Yes").checked=false;
	document.getElementById("Check_Co").checked=false;
	}
	}
	// changed by stanley
	function Cl_checked(){
	if (document.getElementById("Check_Clo").checked=true)
	{
    document.getElementById("Check_Clo").value="C";
	document.getElementById("Check_Use").checked=false;
	document.getElementById("Check_Al2").checked=false;
	document.getElementById("Check_Use").value="";
	}
	}
	// changed by stanley
	function U_checked(){
	if (document.getElementById("Check_Use").checked=true)
	{
	document.getElementById("Check_Use").value="Y";
	document.getElementById("Check_Clo").checked=false;
	document.getElementById("Check_Al2").checked=false;
	document.getElementById("Check_Clo").value="";
	}
	}
	// changed by stanley
	function A_checked(){
	if (document.getElementById("Check_Al2").checked=true)
	{
	document.getElementById("Check_Clo").checked=false;
	document.getElementById("Check_Use").checked=false;
	document.getElementById("Check_Use").value="";
	document.getElementById("Check_Clo").value="";
	}
	}

</script>

<style type="text/css">
<!--
.style2 {color: #cc6600}
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style4 {color: #C64506}
.style5 {color: #CC0000}
.style6 {color: #CC3300}
-->
</style>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<%
dim vNoResult
vNoResult=false
Dim bSale_Per
		
Search=Request.QueryString("Search")
if Search="yes" then
	SMAWB=Request.QueryString("SMAWB")
End if

'//////////////////////////////////// 
hawbno=""
vHAWB=hawbno
mawbno=""
vMAWB=mawbno

'////////////////////////////////////

SelectD=request("select")
vStartDate=Request("txtStartDate")
vEndDate=Request("txtEndDate")

'/////////////////////////////////////

if vStartDate="" then vStartDate=Date
if vEndDate="" then vEndDate=Date+1
'//changed by stanley//
vMAWB=Request("lstMAWB")
vMAWB = Replace(vMAWB,"'","`")
vCOD =Request("COD")
'//changed by stanley//
vShipper=Request("lstShipperName")
vShipper = Replace(vShipper,"'","`")
'//changed by stanley//
vConsignee=Request("lstConsigneeName")
vConsignee = Replace(vConsignee,"'","`")
'//changed by stanley//
vSale_Pers=Request("lstSalesRP")
vSale_Pers = Replace(vSale_Pers,"'","`")
'//changed by stanley//
vAgent=Request("lstAgentName")
vAgent = Replace(vAgent,"'","`")
'//changed by stanley//
vFile=Request("txt_FILE_NO")
vFile = Replace(vFile,"'","`")
'//changed by stanley//
vITN=Request("txt_ITN_NO")
vITN = Replace(vITN,"'","`")
vServiceL=Request("Service_L")
vServiceL = Replace(vServiceL,"'","`")
vSalesRf=Request("SalesRf")
vSalesRf = Replace(vSalesRf,"'","`")
'//changed by stanley//
vCarrier=Request("lstCarrierName")
vCarrier = Replace(vCarrier,"'","`")
'//changed by stanley//
vThirdParty=Request("lstNotifyName")
vThirdParty = Replace(vThirdParty,"'","`")
vDeptPort=Request("lstOriginPort")
vDeptPort = Replace(vDeptPort,"'","`")
'//changed by stanley//
vDestPort=Request("lstDestPort")
vDestPort = Replace(vDestPort,"'","`")
'//changed by stanley//
vHAWB=Request("txt_HAWB")
vHAWB = Replace(vHAWB,"'","`")
'//changed by stanley//
vON_CLO=Request("Check_Clo")
vON_USE=Request("Check_Use")
vRew=Request("Rew")
IsCont=request("Check_Co")
vLast=Request("LastFour")
vLast = Replace(vLast,"'","`")
vLC=Request("txtLC")
vLC = Replace(vLC,"'","`")
vInvoice=Request("txtInvoice")
vInvoice = Replace(vInvoice,"'","`")
vUserRef=Request("txtUserRef")
vUserRef = Replace(vUserRef,"'","`")
vNoPiece=Request("txtNoPiece")
vNoPiece = Replace(vNoPiece,"'","`")
sort_By_TH=request("lstSortType")
sort_By_TY=request("lstSortType")
MMS=request("Rsort")
vREF=request("refer")
'///////////////////////////////////////////////////////////////////
myServer=Request.ServerVariables("SERVER_NAME")
if myServer="10.1.1.53" then
	DM="#"
else
	DM="'"
end If
'//changed by stanley//
Dim aMAWB(2000)
Dim rsm,SQLm,LabelStartNo
Set rsm = Server.CreateObject("ADODB.Recordset")
SQLm= "select mawb_no,File# from mawb_number where elt_account_number= " & elt_account_number & " and Status='B' and is_dome='Y' order by mawb_no"
rsm.Open SQLm, eltConn, adOpenStatic, , adCmdText
mIndex=1
aMAWB(0)="Select One"
Do While Not rsm.EOF 
	aMAWB(mIndex)=rsm("mawb_no")
	mIndex=mIndex+1
	rsm.MoveNext
Loop
rsm.close
goMAWB=Request.QueryString("MAWB")
vMAWB=Request("lstMAWB")
if ( goMAWB="yes" ) then
	Dim aHAWB(128),aPiece(128),aFrom(128),aDest(128),aLabel(128),aDestCode(128)
	if goMAWB="yes" then
		SQLm= "select * from hawb_master where elt_account_number= " & elt_account_number & " and mawb_num='" & vMAWB & "' order by hawb_num"
	end if
	rsm.Open SQLm, eltConn, adOpenStatic, , adCmdText
	hIndex=0
	Do While Not rsm.EOF 
		hMAWB=rsm("mawb_num")
	rsm.MoveNext
	Loop
	rsm.close	
	if hIndex=0 then 
		SQLm= "select * from mawb_master where elt_account_number= " & elt_account_number & " and mawb_num='" & vMAWB & "'"
		rsm.Open SQLm, eltConn, adOpenStatic, , adCmdText
		if Not rsm.EOF  then
			hMAWB=rsm("mawb_num")
		end if
		rsm.close
		hIndex=1
	end if
		rsm.close
	end if
Set rsm=Nothing
%>
<!--changed by stanley//-->
<%
Dim rsp, SQLp
Set rsp = Server.CreateObject("ADODB.Recordset")
Dim PortCode(200),PortID(200),PortDesc(200),PortState(200),PortCountry(200),PortCountryCode(200)
SQLp= "select * from port where elt_account_number = " & elt_account_number & " order by port_desc"
rsp.Open SQLp, eltConn, adOpenForwardOnly, , adCmdText
pIndex=0
Do While Not rsp.EOF
	PortCode(pIndex)=rsp("port_code")
	PortID(pIndex)=rsp("port_id")
	PortDesc(pIndex)=rsp("port_desc")
	PortState(pIndex)=rsp("port_state")
	PortCountry(pIndex)=rsp("port_country")
	PortCountryCode(pIndex)=rsp("port_country_code")
	pIndex=pIndex+1
	rsp.MoveNext
Loop
rsp.Close
Set rsp=Nothing
%>

<!--changed by stanley//-->
<%
Dim rss, SQLs,SPS,SPL
Set rss = Server.CreateObject("ADODB.Recordset")
Dim Sale_P(1000),Sale_L(1000)
SQLs= "select SalesPerson from MAWB_MASTER where elt_account_number = " & elt_account_number & " order by SalesPerson DESC"
rss.Open SQLs, eltConn, adOpenForwardOnly, , adCmdText
SIndex=0
Do While Not rsS.EOF
    SPS=rss("SalesPerson")
	SPL=Len(SPS) 
	If SPL > 1 And Not SPL ="" then 
	Sale_P(SIndex)=rss("SalesPerson")
	Sale_L(SIndex)=Len(Sale_P(SIndex)) 
	SIndex=SIndex+1
	rss.MoveNext
	Else
	rss.MoveNext
    End if
Loop
rss.Close
Set rss=Nothing
%>
<!--changed by stanley//-->
<script type="text/javascript">

    function S_BH(){
	var Sort_B_H;
	Sort_B_H=document.getElementById("lstSortType").value
	if (Sort_B_H=="BY House AWB No")
	{
	if (document.getElementById("Rsort").value=="")
	{
    document.getElementById("Rsort").value="Y";
	}
	else
	{
	document.getElementById("Rsort").value="";
	}
	}
	document.getElementById("lstSortType").value="BY House AWB No";
	GoSearch();
	}

    function S_BM(){	
	var Sort_B_M;
	Sort_B_M=document.getElementById("lstSortType").value
	if (Sort_B_M=="BY Master AWB No")
	{
	if (document.getElementById("Rsort").value=="")
	{
    document.getElementById("Rsort").value="Y";
	}
	else
	{
	document.getElementById("Rsort").value="";
	}
	}
	document.getElementById("lstSortType").value="BY Master AWB No";
	GoSearch();
	}

	
    function S_BF(){	
	var Sort_B_F;
	Sort_B_F=document.getElementById("lstSortType").value
	if (Sort_B_F=="BY FILE No")
	{
	if (document.getElementById("Rsort").value=="")
	{
    document.getElementById("Rsort").value="Y";
	}
	else
	{
	document.getElementById("Rsort").value="";
	}
	}
	document.getElementById("lstSortType").value="BY FILE No";
	GoSearch();
	}

    function S_BE(){
	var Sort_B_E;
	Sort_B_E=document.getElementById("lstSortType").value
	if (Sort_B_E=="BY ETD")
	{
	if (document.getElementById("Rsort").value=="")
	{
    document.getElementById("Rsort").value="Y";
	}
	else
	{
	document.getElementById("Rsort").value="";
	}
	}
	document.getElementById("lstSortType").value="BY ETD";
	GoSearch();
	}
    
	function S_BS(){
	var Sort_B_S;
	Sort_B_S=document.getElementById("lstSortType").value
	if (Sort_B_S=="BY SHIPPER NAME")
	{
	if (document.getElementById("Rsort").value=="")
	{
    document.getElementById("Rsort").value="Y";
	}
	else
	{
	document.getElementById("Rsort").value="";
	}
	}
	document.getElementById("lstSortType").value="BY SHIPPER NAME";
	GoSearch();
	}
    
	function S_BC(){
	var Sort_B_C;
	Sort_B_C=document.getElementById("lstSortType").value
	if (Sort_B_C=="BY CONSIGEE NAME")
	{
	if (document.getElementById("Rsort").value=="")
	{
    document.getElementById("Rsort").value="Y";
	}
	else
	{
	document.getElementById("Rsort").value="";
	}
	}
	document.getElementById("lstSortType").value="BY CONSIGEE NAME";
	GoSearch();
	}
    
	function S_BA(){
	var Sort_B_A;
	Sort_B_A=document.getElementById("lstSortType").value
	if (Sort_B_A=="BY AGENT NAME")
	{
	if (document.getElementById("Rsort").value=="")
	{
    document.getElementById("Rsort").value="Y";
	}
	else
	{
	document.getElementById("Rsort").value="";
	}
	}
	document.getElementById("lstSortType").value="BY AGENT NAME";
	GoSearch();
	}

	function S_BP(){
	var Sort_B_P;
	Sort_B_P=document.getElementById("lstSortType").value
	if (Sort_B_P=="BY DEPARTURE PORT")
	{
	if (document.getElementById("Rsort").value=="")
	{
    document.getElementById("Rsort").value="Y";
	}
	else
	{
	document.getElementById("Rsort").value="";
	}
	}
	document.getElementById("lstSortType").value="BY DEPARTURE PORT";
	GoSearch();
	}


    function S_BT(){
	var Sort_B_T;
	Sort_B_T=document.getElementById("lstSortType").value
	if (Sort_B_T=="BY DESTINATION PORT")
	{
	if (document.getElementById("Rsort").value=="")
	{
    document.getElementById("Rsort").value="Y";
	}
	else
	{
	document.getElementById("Rsort").value="";
	}
	}
	document.getElementById("lstSortType").value="BY DESTINATION PORT";
	GoSearch();
	}
    function S_BTP(){
	var Sort_B_TP;
	Sort_B_TP=document.getElementById("lstSortType").value
	if (Sort_B_TP=="BY THIRD PARTY BILLING")
	{
	if (document.getElementById("Rsort").value=="")
	{
    document.getElementById("Rsort").value="Y";
	}
	else
	{
	document.getElementById("Rsort").value="";
	}
	}
	document.getElementById("lstSortType").value="BY THIRD PARTY BILLING";
	GoSearch();
	}	
	function exchange_ST(){	
    vreloadPage();

	}
function dw_change(){	
    document.getElementById("Rew").value="Y";
	document.getElementById("D_select").value="clear";
	SelectD=document.getElementById("D_select").value;

	vStartDate= Date ;
    vEndDate= Date+1;
	document.getElementById("txtStartDate").value="<%=vStartDate  %>";
    document.getElementById("txtEndDate").value="<%= vEndDate %>";

	document.getElementById("txtStartDate").style.background="#FFFFFF";
	document.getElementById("txtEndDate").style.background="#FFFFFF";
	}
	function dw_change2(){	
	document.getElementById("txtStartDate").style.background="#FFFFFF";
	document.getElementById("txtEndDate").style.background="#FFFFFF";
	}

	function loadCheckValues(){
	if("<%=vCOD%>" != "Y" && "<%=vCOD%>" != "N"){
	document.getElementById("COD_AL").checked=true;
	}
	if ("<%=vCOD%>" == "Y"){
	document.getElementById("COD").value="Y"
	document.getElementById("COD_YES").checked=true;
	}
			
	if("<%=vCOD%>" == "N"){
	document.getElementById("COD").value="N"		
	document.getElementById("COD_NO").checked=true;
	}
	if("<%=MMS%>" == "Y"){
	document.getElementById("Rsort").value="Y";
	}
	if("<%=SelectD%>" == "All Time"){
	document.getElementById("txtStartDate").style.background="#CCCCCC";
	document.getElementById("txtEndDate").style.background="#CCCCCC";
	}
	if ("<%=SelectD%>" == "")
	{
	document.getElementById("txtStartDate").style.background="#CCCCCC";
	document.getElementById("txtEndDate").style.background="#CCCCCC";			  
	}			
		if ("<%=SMAWB%>" == "yes")
		{
			if ("<%=vON_USE%>"== "Y")
			{
			document.getElementById("Check_Use").checked=true;
			}
			if ("<%=vON_CLO%>"== "C")
			{
			document.getElementById("Check_Clo").checked=true;
			}
			if ("<%=vON_CLO%>"!= "C" && "<%=vON_USE%>"!= "Y")
			{
			document.getElementById("Check_AL2").checked=true;
			}


		}

	}
</script>

<body link="336699" vlink="336699" topmargin="0" onLoad="self.focus(); loadCheckValues();">
<form id="form1" name="frmSearch" action="Post" method="post">
<!-- pointer disabled
<table width="100%" height="12" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" valign="top"><img src="../images/spacer.gif" width="657" height="6"><img src=<% 
	if Not isPopWin then  

response.write("'../images/pointer_ae.gif'") 
end if%> width="11" height="7"><img src="../images/spacer.gif" width="12" height="6"></td>
  </tr>
</table>
-->
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
    <td height="32" align="left" valign="middle" class="pageheader">Domestic Search </td>
  </tr>
</table>
<div class="selectarea"></div>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#997132">
  <tr> 
    <td>
        <input type="hidden" name="elt_num" value="<%= elt_account_number %>">
		<input type="hidden"  id="Refer" name="Refer" value=""  />
		<input type="hidden"  id="COD" name="COD" value=""  />
		<input type="hidden"  id="Rew" name="Rew" value=""  />
        <table width="100%" border="0" cellpadding="2" cellspacing="1">
          <tr> 
            <td colspan="14" height="8" align="left" valign="top" bgcolor="#eec983" class="bodyheader"></td>
          </tr>
          <tr align="center" valign="middle"> 
            <td colspan="14" bgcolor="#F3f3f3"><br>
                <table width="64%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td align="right"><%If (SMAWB = "yes") then%>
                        <img src="../images/button_fresh.gif" width="64" height="18" onClick="MreloadPage()" style="cursor:hand">
                        <%end if%>
                        <%If Not (SMAWB = "yes") then%>
                        <img src="../images/button_fresh.gif" width="64" height="18" onClick="HreloadPage()" style="cursor:hand">
                        <%end if%></td>
                </tr>
            </table>
                <table width="64%" border="0" cellpadding="0" cellspacing="0" bordercolor="#997132" bgcolor="f3f3f3" class="border1px" style="padding-left:8px">
                  <tr align="left" valign="middle">
                    <td colspan="7" align="left" valign="middle" bgcolor="efe1df" class="bodycopy"></td>
                  </tr>
                  <tr bgcolor="#f3d9a8">
                    <td height="20" align="left" valign="middle"><strong class="bodycopy style1 style4">List Results By</strong></td>
                    <td align="left" valign="middle" bgcolor="#f3d9a8" class="bodyheader">Departure Date</td>
                    <td width="103" align="left" valign="middle" class="bodyheader">Start Date</td>
                    <td width="152" align="left" valign="middle" class="bodyheader">End Date</td>
                  </tr>
                  <!-- second line -->
                  <tr bgcolor="#FFFFFF">
                    <td height="20" align="left" valign="middle" class="bodyheader"><strong>
                      <select name="lstSearchType" size="1" class="bodyheader" style="WIDTH: 104px" onChange="vreloadPage()">
                        <option id= "ID_HAWB" value="HAWB"  <% if isnull(SMAWB) then response.write("selected") %>  >House AWB No.</option>
                        <option id= "ID_MAWB" value="MAWB" <% if SMAWB="yes" then response.write("selected") %>   >Master AWB No.</option>
                      </select>
                    </strong></td>
                    <!--  row -->
                                       <td align="left" valign="middle"><select name="select"  id="D_select" class="smallselect" onChange= "Javascript:myRadioButtonforDateSet1CheckDate(this)" onmousedown="dw_change2()">
                        <!--change by stanley -->
                        <% If vRew="Y" And selectD="" then%>
                        <option value="Clear" > Select </option>
                        <%else%>
                        <% If selectD="Clear" then%>
                        <option value="Clear" > Select </option>
                        <%elseIf selectD="" then%>
                        <option value="All Time" >All Time</option>
                        <%else%>
                        <option value="<%= selectD %>" selected="selected"><%= selectD %></option>
                        <%End if%>
                        <%End if%>
                        <!--change by stanley -->
                        <%If Not selectD="" Or vRew="Y" then%>
                        <option value="All Time" >All Time</option>
                        <%End if%>
                        <option value="Today">Today</option>
                        <option value="Month to Date">Month to Date</option>
                        <option value="Quarter to Date">Quarter to Date</option>
                        <option value="Year to Date">Year to Date</option>
                        <option value="This Month">This Month</option>
                        <option value="This Quarter">This Quarter</option>
                        <option value="This Year">This Year</option>
                        <option value="Last Month">Last Month</option>
                        <option value="Last Quarter">Last Quarter</option>
                        <option value="Last Year">Last Year</option>
                    </select></td>
                    <% If selectD = "All Time" Then 
						vStartDate=Date 
						vEndDate=Date+1
						end If
						%>
                    <!--  row -->
                    <td align="left" valign="middle" class="bodycopy"><input id="txtStartDate" name="txtStartDate" class="m_shorttextfield " preset="shortdate" value="<%= vStartDate %>" size="16"style="readonly" onMouseDown="dw_change()"></td>
                    <td align="left" valign="middle" class="bodycopy"><input id="txtEndDate" name="txtEndDate" class="m_shorttextfield " preset="shortdate" value="<%= vEndDate %>" size="16" onMouseDown="dw_change()"></td>	
                    <!--  row -->
                  </tr>
                  <!--  third line A-->
                  <tr>
                    <td height="2" colspan="4" align="left" valign="middle" bgcolor="#997132"></td>
                  </tr>
                  <tr bgcolor="#F3F3F3">
                    <td height="20" colspan="2" bgcolor="#F3f3f3" class="bodyheader style2">Master AWB No.</td>
                    <td class="bodyheader" colspan="2">File No.</td>
                  </tr>
                  <!--  fouth line -->
                  <tr bgcolor="#F3f3f3">
                    <td colspan="2" bgcolor="#FFFFFF" class="bodycopy"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="53%"><%
		if vMAWB = "Select One" then
			vMAWB = ""
		end if

		%>
                              <%  iMoonDefaultValue = vMAWB %>
                              <%  iMoonComboBoxName =  "lstMAWB" %>
                              <%  iMoonComboBoxWidth =  "160px" %>
                              <div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width:<%=iMoonComboBoxWidth%>;POSITION:;TOP:;LEFT:;Z-INDEX:;">
                                <input name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text" class="ComboBox" autocomplete="off" style="width:<%=iMoonComboBoxWidth%>;vertical-align:middle" value="<%=iMoonDefaultValue%>"/>
                                <div id="<%=iMoonComboBoxName%>_Div" style="display:none;position:absolute;top:0;left:0;width:17px"><img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif" border="0" /></div>
                              </div>
                            <div id="<%=iMoonComboBoxName%>_NewDiv" style="display:none;position:absolute;top:0;left:0;width:17px"><img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif" border="0" /></div>
                            <!-- /End of Combobox/ -->
                              <select name="lstMAWB" id="lstMAWB" value="<%= vMAWB %>" listsize = "20" class="ComboBox" style="width: 160px;display:none" onChange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                                <% for i=0 to mIndex-1 %>
                                <option <% if vMAWB=aMAWB(i) then response.write("selected") %>><%= aMAWB(i) %></option>
                                <% next %>
                              </select>
                              <!-- /End of Combobox/ -->                          </td>
                          <td width="47%" class="bodycopy"><input name="LastFour" class="shorttextfield" id="LastFour" value="<%= vLast %>" size="6" maxlength="4"/>
                            Last 4 Digits</td>
                        </tr>
                      </table>
                        <!--end table -->
                        <!--changed by stanley//-->                    </td>
                    <!--row-->
                    <td colspan="2" bgcolor="#FFFFFF" class="bodycopy"><input name="txt_FILE_NO" class="shorttextfield" value="<%= vFile %>" size="20" style="WIDTH: 230px">                    </td>
                    <!--fifth line -->
                  <tr align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">
                    <td width="123" height="20" bgcolor="#f3f3f3" class="bodycopy">Airport of Departure </td>
                    <td width="161" bgcolor="#f3f3f3" class="bodycopy">&nbsp;</td>
                    <td bgcolor="#f3f3f3" class="bodycopy" colspan="2">Airport of Destination</td>
                  </tr>
                  <!--fifth line -->
                  <tr align="left" valign="middle" bgcolor="#f3f3f3">
                    <!--airport droplist -->
                    <td colspan="2" bgcolor="#FFFFFF" class="bodycopy"><select name="lstOriginPort" size="1" class="shorttextfield" value="" style="WIDTH: 230px" tabindex=7>
                        <%If vDeptPort = "" then%>
                        <option value="<%= vDeptPort %>" selected="selected">Select One</option>
                        <%End if%>
                        <%If Not vDeptPort = "" then%>
                        <option value="<%= vDeptPort %>" selected="selected"><%= vDeptPort %></option>
                        <%End if%>
                        <option value=""> </option>
                        <% for i= 0 to pIndex-1 %>
                        <option value="<%=  PortDesc(i) %>" <% if vOriginPort=PortCode(i) Then response.write("selected") %>><%= PortCode(i) & "-" & PortDesc(i) %></option>
                        <% next %>
                    </select></td>
                    <!--port droplist-->
                    <td colspan="2" bgcolor="#FFFFFF" class="bodycopy"><select name="lstDestPort" value="" size="1" class="smallselect" style="WIDTH: 230px" tabindex=14>
                        <%If vDestPort = "" then%>
                        <option value="<%= vDestPort %>" selected="selected">Select One</option>
                        <%End if%>
                        <%If Not vDestPort = "" then%>
                        <option value="<%= vDestPort %>" selected="selected"><%= vDestPort %></option>
                        <%End if%>
                        <option value=""> </option>
                        <% for i= 0 to pIndex-1 %>
                        <option value="<%= PortDesc(i) %>" <% if vDestPort=PortCode(i) Then response.write("selected") %>><%= PortCode(i) & "-" & PortDesc(i) %></option>
                        <% next %>
                    </select></td>
                  </tr>
                  <!--sixth line -->
                  <tr bgcolor="#FFFFFF">
                    <td height="20" bgcolor="#F3f3f3" class="bodylistheader">Shipper </td>
                    <td bgcolor="#f3f3f3"></td>
                    <td bgcolor="#F3f3f3" class="bodyheader" colspan="2">Consignee</td>
                  </tr>
                  <!--seventh line -->
                  <tr bgcolor="#F3f3f3">
                    <!--Consigneeeacct table -->
                    <td colspan="2" bgcolor="#FFFFFF" class="bodycopy"><input type="hidden" id="hShipperAcct" name="hShipperAcct" />
                        <div id="lstshipperNameDiv"></div>
                      <!--shipper table-->
                        <table cellpadding="0" cellspacing="0" border="0">
                          <tr>
                            <td><input type="text" autocomplete="off" id="lstShipperName" name="lstShipperName" value="<%= vShipper %>"
					class="shorttextfield" style="width: 215px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
					border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Shipper','lstShipperNameChange',null,event)"
					onFocus="initializeJPEDField(this,event);" /></td>
                            <td><img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange',null,event)"
					style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
					border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                          </tr>
                        </table>
                      <input type="hidden" id="txtShipperInfo" name="txtShipperInfo" class="multilinetextfield" cols="" rows="5" style="width: 300px"/>                    </td>
                    <!--changed by stanley//-->
                    <td colspan="2" bgcolor="#FFFFFF" class="bodycopy"><input type="hidden" id="hConsigneeAcct" name="hConsigneeAcct" />
                        <div id="lstConsigneeNameDiv"></div>
                      <table cellpadding="0" cellspacing="0" border="0">
                          <tr>
                            <td ><input type="text" autocomplete="off" id="lstConsigneeName" name="lstConsigneeName" value="<%= vConsignee %>"
					class="shorttextfield" style="width: 215px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
					border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Consignee','lstConsigneeNameChange',null,event)"
					onFocus="initializeJPEDField(this,event);" /></td>
                            <td><img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange',null,event)"
					style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
					border-left: 0px solid #7F9DB9; cursor: hand;" /></td>

                        </tr>
                      </table>
                      <input type="hidden" id="txtConsigneeInfo" name="txtConsigneeInfo" class="multilinetextfield" cols="" rows="5" style="width: 300px"/></td>
                  </tr>
                  <tr align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">
                    <td height="20" colspan="2" class="bodycopy">Shipper's Reference No. </td>
                    <td colspan="2" class="bodycopy style2">Service Level<span class="bodycopy"><span class="style6"> </span></span></td>
                  </tr>
                  <tr align="left" valign="middle" bgcolor="#f3f3f3">
                    <td colspan="2" bgcolor="#FFFFFF" class="bodycopy"><input id="SalesRf" name="SalesRf" class="shorttextfield" value="<%=vSalesRf%>" size="20" style="width:160px" /></td>
                    <td colspan="2" bgcolor="#FFFFFF" class="bodycopy"><input id="Service_L" name="Service_L" class="shorttextfield" value="<%=vServiceL%>" size="20" style="width:160px" />
                        <span class="bodycopy style2"> </span></td>
                  </tr>
                  <!--eighth line -->
                  <tr bgcolor="#F3f3f3">
                    <td height="20" colspan="2" bgcolor="#f3f3f3" class="bodylistheader">Carrier </td>
                    <td colspan="2" bgcolor="#F3f3f3" class="bodyheader">Third Party Billing </td>
                  </tr>
                  <!--nine line -->
                  <tr align="left" valign="middle" bgcolor="#f3f3f3">
                    <!--row -->
                    <td colspan="2" bgcolor="#FFFFFF" class="bodycopy"><input type="hidden" id="hCarrierAcct" name="hCarrierAcct" />
                        <div id="lstCarrierNameDiv"></div>
                      <!--  start carrier table-->
                        <table cellpadding="0" cellspacing="0" border="0">
                          <td><input type="text" autocomplete="off" id="lstCarrierName" name="lstCarrierName" value="<%= vCarrier %>"
					class="shorttextfield" style="width: 215px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
					border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Carrier','lstCarrierNameChange',null,event)"
					onFocus="initializeJPEDField(this,event);" /></td>
            <td><img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstCarrierName','Carrier','lstCarrierNameChange',null,event)"
					style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
					border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                      </table>
                      <!--  end table -->
                        <input type="hidden" id="txtNotifyInfo" name="txtNotifyInfo" class="multilinetextfield"
		cols="" rows="5" style="width: 300px"/></td>
		 <td colspan="2" bgcolor="#FFFFFF" class="bodycopy"><input type="hidden" id="hNotifyAcct" name="hNotifyAcct" />
                        <div id="lstNotifyNameDiv"></div>
                      <!--  start Notify table-->
                        <table cellpadding="0" cellspacing="0" border="0">
                          <td><input type="text" autocomplete="off" id="lstNotifyName" name="lstNotifyName" value="<%= vThirdParty %>"
					class="shorttextfield" style="width: 215px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
					border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Notify','lstNotifyNameChange',null,event)"
					onFocus="initializeJPEDField(this,event);" /></td>
            <td><img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstNotifyName','Notify','lstNotifyNameChange',null,event)"
					style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
					border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                    </table>
                      <!--  end table -->
                        <input type="hidden" id="txtNotifyInfo" name="txtNotifyInfo" class="multilinetextfield"
		cols="" rows="5" style="width: 300px"/></td>
                    <!--row,sale table -->
                    <!--row -->
                    <!--row -->
                  </tr>
                  <tr align="left" valign="middle" bgcolor="#f3f3f3">
                    <td height="20" colspan="2" bgcolor="#f3f3f3" class="bodycopy"><span class="bodylistheader">Sales Rep.</span></td>
                    <td bgcolor="#f3f3f3" class="bodycopy"><span class="bodyheader"><span class="bodylistheader">No. of Pieces</span></span></td>
                    <td bgcolor="#f3f3f3" class="bodycopy"><span class="bodyheader"><span class="bodylistheader">AES ITN No.</span></span></td>
                  </tr>
                  <tr align="left" valign="middle" bgcolor="#ffffff">
                    <td height="20" colspan="2" class="bodycopy"><select name="lstSalesRP" size="1" value="" class="smallselect" style="WIDTH: 230px" tabindex=7 >
                        <%If vSale_Pers = "" then%>
                        <option value="<%= vSale_Pers %>" selected="selected">Select One</option>
                        <%End if%>
                        <%If Not vSale_Pers = "" then%>
                        <option value="<%= vSale_Pers %>" selected="selected"><%= vSale_Pers %></option>
                        <%End if%>
                        <option value="" ></option>
                        <% For i=0 To SIndex-1 %>
                        <option value="<%= SALE_P(i)%>"
  	                <%if Not SALE_P(i)= NULL And SALE_L(i)= "12" then response.write("selected") %>> <%= SALE_P(i) %> </option>
                        <%  Next  %>
                    </select></td>
                    <td class="bodycopy"><input  name="txtNoPiece" class="shorttextfield" value="<%= vNoPiece %>" size="8" style="behavior: url(../include/igNumChkLeft.htc);"></td>
                    <td class="bodycopy"><input name="txt_ITN_NO" class="shorttextfield" value="<%= vITN %>" size="20"/></td>
                  </tr>
                  <tr align="left" valign="middle" bgcolor="#f3f3f3">
                    <td height="20" colspan="2" bgcolor="#f3f3f3" class="bodyheader">C.O.D.</td>
                    <td bgcolor="#f3f3f3" class="bodycopy">&nbsp;</td>
                    <td bgcolor="#f3f3f3" class="bodycopy">&nbsp;</td>
                  </tr>
                  <tr align="left" valign="middle" bgcolor="#f3f3f3">
                    <td height="24" colspan="2" bgcolor="#FFFFFF" class="bodycopy"><input type="checkbox" id="COD_YES" name="COD_YES" value="" onClick="if (this.checked) {Y_COD()}"/>Yes
                      <input type="checkbox" id="COD_NO" name="COD_NO" value="" onClick="if (this.checked) {N_COD()}" style="margin-left:20px"/>No
					  <input type="checkbox" id="COD_AL" name="COD_AL" value="" onClick="if (this.checked) {A_COD()}" style="margin-left:20px"/>ALL</td>
                    <td bgcolor="#FFFFFF" class="bodycopy">&nbsp;</td>
                    <td bgcolor="#FFFFFF" class="bodycopy">&nbsp;</td>
                  </tr>
                  <tr align="left" valign="middle" bgcolor="#f3f3f3">
                    <td height="1" colspan="4" bgcolor="#997132" class="bodycopy"></td>
                  </tr>
                  <!--Tenth line -->
                  <!--eleven line -->
                  <!--twelve line -->
                  <tr bgcolor="#F3f3f3">
                    <%If Not (SMAWB = "yes") then%>
                    <td height="20" bgcolor="#f3f3f3" class="bodyheader">House AWB No.</td>
                    <td bgcolor="#f3f3f3" class="bodyheader" colspan="2">Agent</td>
					<td bgcolor="#f3f3f3" class="bodyheader"></td>
                    <%else%>
                    <td width="103" colspan="2" bgcolor="#f3f3f3" class="bodyheader">Master AWB Status</td>
                    <%End IF%>
                  </tr>
                  <!--thirteen line -->
                  <tr align="left" valign="middle" bgcolor="#f3f3f3">
                    <%If Not (SMAWB = "yes") then%>
                    <td bgcolor="#FFFFFF" class="bodycopy"><input name="txt_HAWB" class="shorttextfield" value="<%= vHAWB %>" size="20">
                        <input type="hidden" id="txtLC" name="txtLC" class="shorttextfield" value="<%= vLC %>" size="20"></td>
						<input type="hidden" id="txtInvoice" name="txtInvoice" class="shorttextfield" value="<%= vInvoice %>" size="20">

                    <td bgcolor="#FFFFFF" class="bodycopy" colspan="2"><input type="hidden" id="hAgentAcct" name="hAgentAcct" />
                        <div id="lstAgentNameDiv"> </div>
                      <!-- Agent droplist -->
                        <table cellpadding="0" cellspacing="0" border="0" >
                          <tr>
                            <td><input type="text" autocomplete="off" id="lstAgentName" name="lstAgentName" value="<%= vAgent %>"
					class="shorttextfield" style="width: 215px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
					border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Agent','lstAgentNameChange',null,event)"
					onFocus="initializeJPEDField(this,event);" /></td>
                            <td><img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstAgentName','Agent','lstAgentNameChange',null,event)"
					style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
					border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                          </tr>
                        </table>
                      <input type="hidden" id="txtAgentInfo" name="txtAgentInfo" class="multilinetextfield"
	cols="" rows="5" style="width: 200px"/>
                        <input type="hidden" id="txtUserRef" name="txtUserRef" class="shorttextfield" value="<%= vUserRef %>" size="20"></td>
                    <%else%>
                   
                    <td colspan="2" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                          <td width="78" bgcolor="#FFFFFF"><% If vON_CLO ="C" Then %>
                              <input type="checkbox" id="check_Clo" name="check_Clo" value="C" onClick="if (this.checked) {Cl_checked()}"/>
                            Closed
                            <%else%>
                            <input type="checkbox" id="Checkbox5" name="check_Clo" value="" onClick="if (this.checked) {Cl_checked()}"/>
                            Closed
                            <%end if%></td>
                          <td width="70" bgcolor="#FFFFFF"><% If vON_USE ="Y" Then %>
                              <input type="checkbox" id="check_Use" name="check_Use" value="Y" onClick="if (this.checked) {U_checked()}"/>
                            Used
                            <%else%>
                            <input type="checkbox" id="Checkbox6" name="check_Use" value="" onClick="if (this.checked) {U_checked()}"/>
                            Used
                            <%end if%></td>
                          <td bgcolor="#FFFFFF"><input type="checkbox" id="check_AL2" name="check_AL2" value="" onClick="if (this.checked) {A_checked()}"/>
                            All</td>
                        </tr>
                    </table></td>
                    <%end if%>
                  </tr>
                  <!-- sixteen line-->
                  <tr bgcolor="#f3f3f3">
                    <td colspan="2" class="bodycopy"><select name="lstSortType" id="lstSortType" size="1" class="bodyheader" style="WIDTH: 0px">
                        <%If (SMAWB = "yes") then%>
                        <%If sort_By_TY = "" then%>
                        <option value="<%= sort_By_TY %>" selected="selected">SELECT SORT TYPE!</option>
                        <%End if%>
                        <%If Not sort_By_TY = "" then%>
                        <option value="<%= sort_By_TY %>" selected="selected"><%= sort_By_TY %></option>
                        <%End if%>
                        <%End if%>
                        <%If Not (SMAWB = "yes") then%>
                        <%If sort_By_TH = "" then%>
                        <option value="<%= sort_By_TH %>" selected="selected">SELECT SORT TYPE!</option>
                        <%End if%>
                        <%If Not sort_By_TH = "" then%>
                        <option value="<%= sort_By_TH %>" selected="selected"><%= sort_By_TH %></option>
                        <%End if%>
                        <option id= "BY_HOUSE" value="BY House AWB No"   > BY House AWB No.</option>
                        <%End if%>
                        <option id= "BY_MAWB" value="BY Master AWB No"  >BY Master AWB No.</option>
                        <option id= "BY_FILE" value="BY FILE No"  >BY FILE No.</option>
                        <option id= "BY_ETD" value="BY ETD"  >BY ETD.</option>
                        <option id= "BY_SHIP" value="BY SHIPPER NAME"  >BY SHIPPER NAME.</option>
                        <option id= "BY_CONS" value="BY CONSIGEE NAME"  >BY CONSIGEE NAME.</option>
                        <%If Not (SMAWB = "yes") then%>
                        <option id= "BY_AGEN" value="BY AGENT NAME"  >BY AGENT NAME.</option>
                        <%End IF%>
                        <option id= "BY_DEPA" value="BY DEPARTURE PORT"  >BY DEPARTURE PORT.</option>
                        <option id= "BY_DEST" value="BY DESTINATION PORT"  >BY DESTINATION PORT.</option>
						<option id= "BY_Third" value="BY THIRD PARTY BILLING"  >BY THIRD PARTY BILLING.</option>
                      </select>
                        <% If MMS ="Y" Then %>
                        <input type="hidden"  id="RSort" name="RSort" value="Y"  />
                        <%else%>
                        <input type="hidden"  id="RSort" name="RSort" value=""  />
                        <%end if%></td>
                    <td class="bodycopy">&nbsp;</td>
                    <td height="32" align="center" valign="middle" class="bodycopy"><img src="../images/button_go.gif" width="31" height="18" onClick="GoSearch()"  style="cursor:hand"></td>
                  </tr>
                </table>
                <!-- end table-->
                <br> </td>		  
          <tr bgcolor="edd3cf"> 
            <%If Not (SMAWB = "yes") then%>
    <td width="81" height="36" valign="top" bgcolor="#f3d9a8" class="bodyheader">House AWB No.<img src="../images/Expand.gif" width="10" height="7"  onclick="S_BH()" style="cursor:hand"></td>
    <%End if%>
    <td width="81" valign="top" bgcolor="#f3d9a8" class="bodyheader">Master AWB No.<img src="../images/Expand.gif" width="10" height="7"  onclick="S_BM()" style="cursor:hand"></td>

    <td width="81" valign="top" bgcolor="#f3d9a8" class="bodyheader">ETD <img src="../images/Expand.gif" width="10" height="7"  onclick="S_BE()" style="cursor:hand"></td>
    <td width="45" valign="top" bgcolor="#f3d9a8" class="bodyheader">File No.<img src="../images/Expand.gif" width="10" height="7"  onclick="S_BF()" style="cursor:hand"></td>
	    <td width="74" valign="top" bgcolor="#f3d9a8" class="bodyheader">Departure Port <img src="../images/Expand.gif" width="10" height="7"  onclick="S_BP()" style="cursor:hand"></td>
    <td width="68" valign="top" bgcolor="#f3d9a8" class="bodyheader">Destination Port <img src="../images/Expand.gif" width="10" height="7"  onclick="S_BT()" style="cursor:hand"></td>
    <td width="88" valign="top" bgcolor="#f3d9a8" class="bodyheader">Shipper <img src="../images/Expand.gif" width="10" height="7"  onclick="S_BS()" style="cursor:hand"></td>
    <td width="80" valign="top" bgcolor="#f3d9a8" class="bodyheader">Consignee <img src="../images/Expand.gif" width="10" height="7"  onclick="S_BC()" style="cursor:hand"></td>
    <td width="80" valign="top" bgcolor="#f3d9a8" class="bodyheader">Third Party Billing <img src="../images/Expand.gif" width="10" height="7"  onclick="S_BTP()" style="cursor:hand"></td>	
    <%If Not (SMAWB = "yes") then%>
    <td width="81" valign="top" bgcolor="#f3d9a8" class="bodyheader">Agent <img src="../images/Expand.gif" width="10" height="7"  onclick="S_BA()" style="cursor:hand"></td>
    <%End if%>
    <%if(SMAWB = "yes") then%>
    <td width="43" valign="top" bgcolor="#f3d9a8" class="bodyheader">MAWB Status</td>
    <%end if%>
    <td width="37" valign="top" bgcolor="#f3d9a8" class="bodycopy">&nbsp;</td>
    <td width="62" valign="top" bgcolor="#f3d9a8" class="bodycopy">&nbsp;</td>
          </tr>
    <%If vRef= "Y" Then %>     
	<tr bgcolor="#FFFFFF"> </tr>

<%
else

Dim rs,SQL,hno,SQLC,rsc
if Search="yes" then
	Set rs = Server.CreateObject("ADODB.Recordset")
	if SMAWB = "yes" then
	'//changed by stanley
    SQL= "select a.MAWB_NUM as MAWB_NUM,b.file# as file#,b.Carrier_Desc as Carrier_Desc,a.Notify_no as Notify_no,a.CreatedDate as CreatedDate,a.COD_Amount as COD_Amount,Right(rtrim(a.MAWB_NUM),4) as lastF#,a.Account_Info as Account_Info,a.Shipper_Info as Shipper_Info,b.Status as Status,b.used as used,b.file# as fileN,a.SalesPerson as SalesPerson,a.shipper_reference_num as shipper_reference_num, a.Service_Level as Service_Level,a.consignee_name as consignee_name,a.master_agent as master_agent,a.Departure_Airport as Departure_Airport,a.Dest_Airport as Dest_Airport from mawb_master a left outer join mawb_number b on a.elt_account_number = b.elt_account_number and a.mawb_num = b.mawb_no where a.is_dome='Y' and a.elt_account_number = " & elt_account_number	

		if not mawbno="" then
			SQL=SQL & " and a.MAWB_NUM like '" & mawbno & "%'"
		else
			'---------------------------------------------------------------------------------------------------------------------------------------------------------------------
			If Not selectD = "All Time" then

			if not vStartDate="" Then
				SQL=SQL & " and a.CreatedDate Between " & DM & vStartDate & DM & " and DATEADD(day, 1," & DM  & vEndDate & DM & ")"
			end If

			End if'-------------------------------------------------------------------------------------------------------------------------------------------------------------------
			'//changed by stanley
			if not vDeptPort="" Then
				SQL=SQL & " and a.Departure_Airport like '%" & vDeptPort & "%'"
			end if			
			if not vServiceL="" Then
				SQL=SQL & " and a.Service_Level like '%" & vServiceL & "%'"
			end if
			if not vCOD="" Then
				if vCOD="Y" then   
				SQL=SQL & " and a.COD_Amount >" & 0.00
				else 
				SQL=SQL & " and a.COD_Amount <=" & 0.00
				end if
			end if
			if not vSalesRf="" Then
				SQL=SQL & " and a.shipper_reference_num like '%" & vSalesRf & "%'"
			end if
			'//changed by stanley			
			if not vThirdParty="" Then
				SQL=SQL & " and a.Account_Info like '%" & vThirdParty & "%'"
			end If	
			if not vFile="" Then
				SQL=SQL & " and b.file# like '%" & vFile & "%'"
			end If
			'//changed by stanley
			if not vON_USE="" Then
				SQL=SQL & " and b.used like '%" & vON_USE & "%'"
			end If
			'//changed by stanley
			if not vON_CLO="" Then
				SQL=SQL & " and b.Status like '%" & vON_CLO & "%'"
			end If
			'//changed by stanley
			if not vShipper="" then
				SQL=SQL & " and a.Shipper_Info like '%" & vShipper & "%'"
			end If
			'//changed by stanley
			if not vDestPort="" Then
				SQL=SQL & " and a.Dest_Airport like '%" & vDestPort & "%'"
			end If
			'//changed by stanley			
			if not vConsignee="" then
				SQL=SQL & " and a.Consignee_name like '%" & vConsignee & "%'"
			end If
			'//changed by stanley
			if not vAgent="" then
				SQL=SQL & " and a.master_agent  like '%" & vAgent & "%'"
			end If
			'//changed by stanley
			if not vLast="" then
				SQL=SQL & " and Right(rtrim(a.MAWB_NUM),4) like '%" & vLast & "%'"
			end If
			'//changed by stanley			
			if not vSale_Pers="" then
				SQL=SQL & " and a.SalesPerson  like '%" & vSale_Pers & "%'"
			end If
			'//changed by stanley
			if not vCarrier="" then
				SQL=SQL & " and b.Carrier_Desc like '%" & vCarrier & "%'"
			end If
			if not vMAWB="" then
				SQL=SQL & " and a.MAWB_NUM like '%" & vMAWB & "%'"
			end if
'			if Not vLC="" then
'				SQL=SQL & " and a.lc like '%" & vLC & "%'"
'			end If
'			if Not vInvoice="" then
'				SQL=SQL & " and a.ci like '%" & vInvoice & "%'"
'			end if
'			if Not vUserRef="" Then
'				SQL=SQL & " and a.other_ref like '%" & vUserRef & "%'"
'			end if
			if not vNoPiece="" then
				SQL=SQL & " and a.Total_Pieces=" & vNoPiece
			end if
		end If

		'//CHANGE BY STANLEY 
			If Not MMS="Y" then
			If sort_By_TY="" Or sort_By_TY="BY Master AWB No" Then
			SQL=SQL & "order by a.MAWB_Num"
			End IF
			If sort_By_TY="BY FILE No" Then
			SQL=SQL & "order by b.file#"
			End If
			
	        If sort_By_TY="BY ETD" Then
			SQL=SQL & "order by a.CreatedDate"
			End IF
			If sort_By_TY="BY SHIPPER NAME" Then
			SQL=SQL & "order by a.Shipper_Info"
			End IF
			If sort_By_TY="BY CONSIGEE NAME" Then
			SQL=SQL & "order by a.Consignee_name"
			End IF
			If sort_By_TY="BY DEPARTURE PORT" Then
			SQL=SQL & "order by a.Departure_Airport"
			End If		
			If sort_By_TY="BY DESTINATION PORT" Then
			SQL=SQL & "order by a.Dest_Airport"
			End If
			If sort_By_TY="BY THIRD PARTY BILLING" Then
			SQL=SQL & "order by a.Account_Info"
			End If			
			else
			If sort_By_TY="" Or sort_By_TY="BY Master AWB No" Then
			SQL=SQL & "order by a.MAWB_Num desc"
			End IF
			If sort_By_TY="BY FILE No" Then
			SQL=SQL & "order by b.file# DESC"
			End If
	        If sort_By_TY="BY ETD" Then
			SQL=SQL & "order by a.CreatedDate DESC"
			End IF
			If sort_By_TY="BY SHIPPER NAME" Then
			SQL=SQL & "order by a.Shipper_Info DESC"
			End IF
			If sort_By_TY="BY CONSIGEE NAME" Then
			SQL=SQL & "order by a.Consignee_name DESC"
			End IF
			If sort_By_TY="BY DEPARTURE PORT" Then
			SQL=SQL & "order by a.Departure_Airport DESC"
			End IF
			If sort_By_TY="BY DESTINATION PORT" Then
			SQL=SQL & "order by a.Dest_Airport DESC"
			End IF
			If sort_By_TY="BY THIRD PARTY BILLING" Then
			SQL=SQL & "order by a.Account_Info DESC"
			End If	
		End If

	'//changed by stanley
	else
	SQL= "select a.HAWB_NUM as HAWB_NUM,a.MAWB_NUM as MAWB_NUM,isnull(b.file#,'') as file#,isnull(b.Carrier_Desc, '') as Carrier_Desc,a.Notify_no as Notify_no,a.COD_Amount as COD_Amount,a.aes_xtn as aes_xtn,a.is_sub as is_sub,b.Status as Status,b.used as used,a.is_master as is_master,a.CreatedDate as CreatedDate,a.Shipper_Info as Shipper_Info,a.Account_Info as Account_Info,a.Service_Level as Service_Level, a.shipper_reference_num as shipper_reference_num,a.consignee_name as consignee_name,a.Agent_name as Agent_name,Right(rtrim(a.MAWB_NUM),4) as lastF#,a.SalesPerson as SalesPerson,a.is_master_closed as is_master_closed,a.Departure_Airport as Departure_Airport,a.Dest_Airport as Dest_Airport from hawb_master a left outer join mawb_number b on a.elt_account_number = b.elt_account_number and a.mawb_num = b.mawb_no where a.is_dome='Y' and a.elt_account_number =" & elt_account_number 

		if not hawbno="" then
			SQL=SQL & " and a.HAWB_NUM='" & hawbno & "'"
		elseif not mawbno="" then
			SQL=SQL & " and a.MAWB_NUM like '" & mawbno & "%'"
		Else	'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		If Not selectD = "All Time" then
				if not vStartDate="" Then
					SQL=SQL & " and a.CreatedDate Between " & DM & vStartDate & DM & " and DATEADD(day, 1," & DM  & vEndDate & DM & ")"
			end If
			End if'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			'//changed by stanley			
			if not vDeptPort="" Then
				SQL=SQL & " and a.Departure_Airport like '%" & vDeptPort & "%'"
			end If
			'//changed by stanley		
			if not vDestPort="" Then
				SQL=SQL & " and a.Dest_Airport like '%" & vDestPort & "%'"
			end If
			'//changed by stanley			
			if not vThirdParty="" Then
				SQL=SQL & " and a.Account_Info like '%" & vThirdParty & "%'"
			end If
			if not vCOD="" Then
				if vCOD="Y" then   
				SQL=SQL & " and a.COD_Amount >" & 0.00
				else 
				SQL=SQL & " and a.COD_Amount <=" & 0.00
				end if
			end if			
			'//changed by stanley
			if not vFile="" Then
				SQL=SQL & " and isnull(b.file#,'') like '%" & vFile & "%'"
			end If
			'//changed by stanley
			if not vON_USE="" Then
				SQL=SQL & " and b.used like '%" & vON_USE & "%'"
			end If
			'//changed by stanley
			if not vON_CLO="" Then
				SQL=SQL & " and b.Status like '%" & vON_CLO & "%'"
			end If
			'//changed by stanley
			if not vITN="" Then
				SQL=SQL & " and a.aes_xtn like '%" & vITN & "%'"
			end if
			
			if not vServiceL="" Then
				SQL=SQL & " and a.Service_Level like '%" & vServiceL & "%'"
			end if
			if not vSalesRf="" Then
				SQL=SQL & " and a.shipper_reference_num like '%" & vSalesRf & "%'"
			end if			
			if not vShipper="" then
				SQL=SQL & " and a.Shipper_Info like '%" & vShipper & "%'"
			end If
			'//changed by stanley			
			if not vConsignee="" then
				SQL=SQL & " and a.Consignee_name like '%" & vConsignee & "%'" 
			end If
			'//changed by stanley
			if not vON_SUB="" then
				SQL=SQL & " and a.is_sub like '%" & vON_SUB & "%'"
			end If
			'//changed by stanley
			if not vON_MAS="" then
				SQL=SQL & " and a.is_master like '%" & vON_MAS & "%'"
			end If
			'//changed by stanley			
			if not vSale_Pers="" then
				SQL=SQL & " and a.SalesPerson  like '%" & vSale_Pers & "%'"
			end If
			if not vAgent="" then
				SQL=SQL & " and a.Agent_Name like '%" & vAgent & "%'"
			end If
			'//changed by stanley
			if not vLast="" then
				SQL=SQL & " and Right(rtrim(a.MAWB_NUM),4) like '%" & vLast & "%'"
			end If
			'//changed by stanley
			if not vCarrier="" then
				SQL=SQL & " and b.Carrier_Desc like '%" & vCarrier & "%'"
			end If
			if not vHAWB="" then
				SQL=SQL & " and a.HAWB_NUM like '%"  & vHAWB & "%'" 
			end If
			if not vMAWB="" then
				SQL=SQL & " and a.MAWB_NUM like '%" & vMAWB & "%'"
			end if
			if Not vLC="" then
				SQL=SQL & " and a.lc like '%" & vLC & "%'"
			end if
			if Not vInvoice="" then
				SQL=SQL & " and a.ci like '%" & vInvoice & "%'"
			end if
			if Not vUserRef="" Then
				SQL=SQL & " and a.other_ref like '%" & vUserRef & "%'"
			end if
			if not vNoPiece="" then
				SQL=SQL & " and a.Total_Pieces=" & vNoPiece
			end if
		end If
			If Not MMS="Y" then
			If sort_By_TH="" Or sort_By_TH="BY House AWB No" Then
			SQL=SQL & "order by a.HAWB_NUM"
			End IF
			If sort_By_TH="BY Master AWB No" Then
			SQL=SQL & "order by A.MAWB_NUM"
			End If
			If sort_By_TH="BY FILE No" Then
			SQL=SQL & "order by ib.file#"
			End If
	        If sort_By_TH="BY ETD" Then
			SQL=SQL & "order by a.CreatedDate"
			End IF
			If sort_By_TH="BY SHIPPER NAME" Then
			SQL=SQL & "order by a.Shipper_Info"
			End IF
			If sort_By_TH="BY CONSIGEE NAME" Then
			SQL=SQL & "order by a.Consignee_name"
			End IF
			If sort_By_TH="BY DEPARTURE PORT" Then
			SQL=SQL & "order by a.Departure_Airport"
			End IF
			If sort_By_TH="BY DESTINATION PORT" Then
			SQL=SQL & "order by a.Dest_Airport"
			End If			
			If sort_By_TH="BY THIRD PARTY BILLING" Then
			SQL=SQL & "order by a.Account_Info"
			End If	
			If sort_By_TH="BY AGENT NAME" Then
			SQL=SQL & "order by a.Agent_Name"
			End If

			Else

			If sort_By_TH="" Or sort_By_TH="BY House AWB No" Then
			SQL=SQL & "order by a.HAWB_NUM DESC"
			End IF
			If sort_By_TH="BY Master AWB No" Then
			SQL=SQL & "order by A.MAWB_NUM DESC"
			End If
			If sort_By_TH="BY FILE No" Then
			SQL=SQL & "order by ib.file# DESC"
			End If
	        If sort_By_TH="BY ETD" Then
			SQL=SQL & "order by a.CreatedDate DESC"
			End IF
			If sort_By_TH="BY SHIPPER NAME" Then
			SQL=SQL & "order by a.Shipper_Info DESC"
			End IF
			If sort_By_TH="BY CONSIGEE NAME" Then
			SQL=SQL & "order by a.Consignee_name DESC"
			End IF
			If sort_By_TH="BY DEPARTURE PORT" Then
			SQL=SQL & "order by a.Departure_Airport DESC"
			End IF
			If sort_By_TH="BY DESTINATION PORT" Then
			SQL=SQL & "order by a.Dest_Airport DESC"
			End If
			If sort_By_TH="BY THIRD PARTY BILLING" Then
			SQL=SQL & "order by a.Account_Info DESC"
			End If				
			If sort_By_TH="BY AGENT NAME" Then
			SQL=SQL & "order by a.Agent_Name DESC"
			End If
			End IF
	end If
	
'response.write SQL	
'//changed by stanley
	rs.Open SQL, eltConn, , , adCmdText
			Dim SS
	if rs.EOF =true then vNoResult=True
	Do While Not rs.EOF
		if SMAWB = "yes" then
			Agent=rs("master_agent")
			MAWB=rs("MAWB_NUM")
		Else
		    IS_MAS_CL=rs("is_master_closed")
			HAWB=rs("HAWB_NUM")
			Sale_Person=rs("SalesPerson")
			Agent=rs("agent_name")
			Carrier=rs("Carrier_Desc")
			ITN=rs("aes_xtn")
			IS_C=rs("status")
			IS_U=rs("used")
			MAWB=rs("MAWB_NUM")


		end If
		

	    LAST=rs("lastF#")
		Tran_Date=rs("CreatedDate")
		 '<----------------------------------------------------------------------------- cut time out
		Dim timeCutter
		
		If checkBlank(Tran_Date,"") <> "" Then
	        timeCutter=Split(Tran_Date," ")
	        Tran_Date=timeCutter(0)
	    End If
		Sale_Person=rs("SalesPerson")
		FileV=rs("file#")
		TH_Par_N=rs("Notify_no")
		Shipper=rs("Shipper_Info")
		pos=Instr(Shipper,chr(10))
		if pos>0 then
			Shipper=Left(Shipper,pos-1)
		end if
		Consignee=rs("consignee_name")
		IS_C=rs("status")
		IS_U=rs("used")
		Carrier=rs("Carrier_Desc")
		DeptPort=rs("Departure_Airport")
		DestPort=rs("Dest_Airport")
		FileV=rs("file#")
		
%>
  <%
        '//Change By Stanley
		Dim UOA
	if vON_CLO="C" then
    UOA= "CLOSED" 
	Elseif vON_Use="Y" then
    UOA = "USED" 
    Else
    if IS_C="C" then
    UOA= "CLOSED" 
	Elseif IS_U="Y" Then
    UOA="USED"
	Else
    UOA="NOT USED"	
	end if
	end if
%>
<%

            if not TH_Par_N="0" and not TH_Par_N=""  then 
			Set rsc = Server.CreateObject("ADODB.Recordset")
			SQLC= "select dba_name from organization where org_account_number like '%" & TH_Par_N & "%'"	
			rsc.Open SQLC, eltConn, adOpenForwardOnly, , adCmdText

			Do While Not rsc.EOF
			TH_Par=rsc("dba_name")
			rsc.MoveNext					
			Loop		
			rsc.Close
			Set rsc=Nothing

			else
			TH_Par=""
			end if
			%>
			<!--changed by stanley-->
          <tr bgcolor="#FFFFFF"> 
          
    <%If Not (SMAWB = "yes") then%>
    <td class="bodycopy"><%= HAWB %></td>
    <%End if%>
    <td class="bodycopy"><%= MAWB %></td>
    <td class="bodycopy"><%= Tran_Date %></td>
    <td class="bodycopy"><%= FileV %></td>
    <td class="bodycopy"><%= DeptPort %></td>
    <td class="bodycopy"><%= DestPort %></td>
    <td class="bodycopy"><%= Shipper %></td>
    <td class="bodycopy"><%= Consignee %></td>
    <td class="bodycopy"><%= TH_Par %></td>		
    <%If not(SMAWB = "yes") then%>
    <td class="bodycopy"><%= Agent %></td>
    <%End if%>
    <%if(SMAWB = "yes") then%>
    <td class="bodycopy"><%= UOA %></td>	
    <%End if%>
    <td width="37" align="center"><img src="../images/button_edit.gif" width="37" height="18" name="Edit" onClick="EditClick('<%= HAWB %>','<%= MAWB %>')"  style="cursor:hand"></td>
    <td width="62" align="center"><img src="../images/button_view.gif" width="42" height="18" name="View" onClick="ViewClick('<%= HAWB %>','<%= MAWB %>')"  style="cursor:hand"></td>
    </tr>
         

  <%
		rs.MoveNext
	Loop
	rs.Close

end if
Set rs=Nothing

End if

if vNoResult=true then 
		%>
<tr bgcolor="ffffff"> 
            <td colspan="14" height="22" align="center" valign="middle" class="bodycopy"><font color="#FF0000">No result found from the search!</font> </td>
          </tr><%
end if 

%>
          <tr bgcolor="#F2DEBF"> 
            <td height="22" colspan="14" align="left" valign="middle" bgcolor="#eec983" class="bodycopy">&nbsp;</td>
          </tr>
        </table>
      
	  </td>
    </tr>
</table>
<!-- end UI screen-->
</form>
</body>

<SCRIPT LANGUAGE="vbscript">
<!---

Sub S_B_H()
If Not SMAWB="yes" then
sort_By_TH="BY House AWB No"
End if
GoSearch()
End sub

Sub GoSearch()
sIndex=document.frmSearch.lstSearchType.selectedindex
if sIndex = 0 then
	HAWBclick()
else
	MAWBclick()
end if

End Sub

Sub HAWBclick()
Dim hawbno
hawbno=""
document.frmSearch.action="ae_search.asp?Search=yes&hawb=" & hawbno  & "&windowName=" & window.name
document.frmSearch.method="POST"
document.frmSearch.target = "_self"
frmSearch.submit()
End Sub

Sub MAWBclick()
Dim mawbno
mawbno=""
document.frmSearch.action="ae_search.asp?Search=yes&mawb=" & mawbno & "&SMAWB=yes"  & "&windowName=" & window.name
document.frmSearch.method="POST"
document.frmSearch.target = "_self"
frmSearch.submit()
End Sub

Sub Allclick()
Dim StartDate,EndDate,NoPiece,GrossWeight
StartDate=document.frmSearch.txtStartDate.Value
EndDate=document.frmSearch.txtEndDate.Value
NoPiece=document.frmSearch.txtNoPiece.Value
If Not StartDate="" And IsDate(StartDate)=False Then
	MsgBox "Please enter a correct date! (MM/DD/YYYY)"
	document.frmSearch.txtStartDate.Value=""
Elseif Not EndDate="" And IsDate(EndDate)=False Then
	MsgBox "Please enter a correct date! (MM/DD/YYYY)"
	document.frmSearch.txtEndDate.Value=""
ElseIf Not NoPiece="" And IsNumeric(NoPiece)=False Then
	MsgBox "Please enter a numeric value!"
	document.frmSearch.txtNoPiece.Value=""
Else
	document.frmSearch.action="ae_search.asp?Search=yes" & "&windowName=" & window.name
	document.frmSearch.target = "_self"
	document.frmSearch.method="POST"
	frmSearch.submit()
End If
End Sub

Sub EditClick(hawbno,mawbno)
jPopUpNormal()
if not hawbno = "" then
	document.frmSearch.action= "new_edit_hawb.asp?mode=search&hawb=" & hawbno & "&WindowName=popUpWindow"
else
	document.frmSearch.action= "new_edit_mawb.asp?Edit=yes&mawb=" & mawbno & "&WindowName=popUpWindow"
end if
document.frmSearch.target="popUpWindow"
document.frmSearch.method="POST"
frmSearch.submit()
End Sub
Sub ViewClick(hawbno,mawbno)
jPopUpNormal()
if not hawbno = "" then
	document.frmSearch.action= "view_print.asp?sType=house&hawb=" & hawbno & "&WindowName=popUpWindow"
else
	document.frmSearch.action= "view_print.asp?sType=master&hawb=" & mawbno & "&WindowName=popUpWindow"
end if
document.frmSearch.target="popUpWindow"
document.frmSearch.method="POST"
frmSearch.submit()
End Sub

Sub MenuMouseOver()
End Sub

Sub MenuMouseOut()
End Sub
--->

</SCRIPT>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
