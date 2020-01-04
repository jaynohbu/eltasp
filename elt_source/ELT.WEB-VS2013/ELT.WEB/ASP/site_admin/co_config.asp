

<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
    
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/CountryStates.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Company Information</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/jscript">

	function GoCountrySet() {
		var sURL = "/IFF_MAIN/ASPX/OnLines/Country/countryMaster.aspx?WindowName=PopWin";
		viewPop(sURL);
	}

    function lstCurrencyChange(){
        var vCurrencyCode = document.getElementById("lstCurrency").value;
        document.getElementById("txtCurrency").value = vCurrencyCode;
    }
    
    function GetOtherCurrency(thisObj,countryObjId){
        var vCountryCode = document.getElementById(countryObjId).value;
        var vURL = "/ASP/site_admin/select_currency.asp?code=" + thisObj.value + "&ccode=" + vCountryCode;
        var vWinArg = "dialogWidth:370px; dialogHeight:280px; help:no; status:no; scroll:no; center:yes";
        
        var vReturn = showModalDialog(vURL, "popWindow", vWinArg);
        if (vReturn){
            thisObj.value = vReturn;
        }
    }

    function GetOtherCountry(thisObj){
        var vURL = "/ASP/site_admin/select_country.asp?code=" + thisObj.value;
        var vWinArg = "dialogWidth:370px; dialogHeight:280px; help:no; status:no; scroll:no; center:yes";
        
        var vReturn = showModalDialog(vURL, "popWindow", vWinArg);
        if (vReturn){
            thisObj.value = vReturn;
        }
    }
    </script>

</head>
<%
   
Dim rs, SQL
Set rs = Server.CreateObject("ADODB.Recordset")
Dim vFiscalEndMonth 
Dim OrgID
Dim Save,Add,Delete,SeqNum,jAdd,jDelete
Dim vFAANum,vFAAEDate
Dim vUSPPI,vInvoicePrefix,vNextInvoiceNo,vInvoiceDate,vNextCheckNo,vInterPDF
Dim vUOM,vUOMQty,vCurrency,vCGS,vCHIAIR,vCHIOCN,vCOIAIR,vCOIOCN,tIndex,vOTICode
Dim jIndex,CGSIndex,ChIIndex,COIIndex,msgIndex,i,k
Dim dOpenDynamic,vCountryCode,vSEDStatement

eltConn.BeginTrans
'/////////////////////////////////////////////////////////////////////

Save=Request.QueryString("Save")
Add=Request.QueryString("Add")
Delete=Request.QueryString("Delete")
SeqNum=Request.QueryString("SeqNum")
jAdd=Request.QueryString("jAdd")
jDelete=Request.QueryString("jDelete")

Dim SelectedBname
Dim vDBA,vBname,vTaxID,vBaddress,vBcity,vBstate,vBzip,vBcountry,vBurl,vBphone,vBfax
Dim vCFname,vCLname,vCphone,vCaddress,vCcity,vCstate,vCzip,vMCountry,vCemail
Dim vIATACode
Dim v_iv_statement,v_maxuser

Dim msgTypes(8), msgTxts(8), code_list_all

msgTypes(0)="AE/Agent Pre-Alert"
msgTypes(1)="AE/Shipping Notice"
msgTypes(2)="OE/Agent Pre-Alert"
msgTypes(3)="OE/Shipping Notice"
msgTypes(4)="AI/Proof of Delivery"
msgTypes(5)="AI/eArrival Notice"
msgTypes(6)="OI/Proof of Delivery"
msgTypes(7)="OI/eArrival Notice" 

DIM qDAFStr, qDOFStr
qDAFStr = Request.QueryString("DAF")
qDOFStr = Request.QueryString("DOF")

			
DIM qDAFCostStr, qDOFCostStr
qDAFCostStr = Request.QueryString("DAFCost")
qDOFCostStr = Request.QueryString("DOFCost")

if Delete="yes" or jDelete="yes" then
	SQL= "delete from user_prefix where elt_account_number = " & elt_account_number & " and seq_num=" & SeqNum
	eltConn.Execute SQL
end if

'// HAWB,HBOL Prefix by ig 7/8/2006

if Add="yes" then
	SQL= "select max(seq_num) as seq_num from user_prefix where elt_account_number = " & elt_account_number
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing

	If Not rs.EOF And IsNull(rs("seq_num"))=False Then
		SeqNum = CLng(rs("seq_num")) + 1
	Else
		SeqNum=1
	End If
	rs.Close
	addPrefix=Request("txtAddPrefix")
	addType=Request("lstAddType")
	addDesc=Request("txtAddDesc")
	addNextNo=Request("txtAddNextNo")

	if ( isnull(addNextNo)= true or trim(addNextNo) = "") then addNextNo = "1"
	
	SQL ="select * from user_prefix where elt_account_number="&elt_account_number&" and seq_num="&SeqNum
    rs.Open SQL, eltConn, dOpenDynamic, adLockPessimistic,  adCmdText   
	'rs.Open "user_prefix", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
	if rs.eof then
		rs.AddNew
		rs("elt_account_number") = elt_account_number
		rs("seq_num")=SeqNum
		rs("prefix")=addPrefix
		rs("type")=addType
		rs("desc")=addDesc
		rs("next_no")=addNextNo
		rs.Update
	end if
	rs.Close

end if

'// File # Prefix by ig 7/8/2006
if jAdd="yes" then
	SQL= "select max(seq_num) as seq_num from user_prefix where elt_account_number = " & elt_account_number 
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF And IsNull(rs("seq_num"))=False Then
		jSeqNum = CLng(rs("seq_num")) + 1
	Else
		jSeqNum=1
	End If
	rs.Close
	jaddPrefix=Request("jtxtAddPrefix")
	jaddType=Request("jlstAddType")
	jaddDesc=Request("jtxtAddDesc")
	jaddNextNo=Request("jtxtAddNextNo")
	if ( isnull(jaddNextNo)= true or trim(jaddNextNo) = "") then jaddNextNo = "1"

	SQL ="select * from user_prefix where elt_account_number="&elt_account_number&" and seq_num="&jSeqNum

    rs.Open SQL, eltConn, dOpenDynamic, adLockPessimistic,  adCmdText   
	'rs.Open "user_prefix", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
	if rs.eof then	
		rs.AddNew
		rs("elt_account_number") = elt_account_number
		rs("seq_num")=jSeqNum
		rs("prefix")=jaddPrefix
		rs("type")=jaddType
		rs("desc")=jaddDesc
		rs("next_no")=jaddNextNo
		rs.Update
	end if
	rs.Close
end if

    vFAANum = Request("txtFAANum")
	vFAAEDate = Request("txtFAAEDate")
	vDBA=Request("txtDBA")
'// by iMoon
	v_iv_statement=Request("iv_statement")		
	vBName=Request("txtBName")
	vTaxID=Request("txtTaxID")
	vUSPPI=Request("txtUSPPI")
	vBaddress=Request("txtBaddress")
	vBcity=Request("txtBcity")
	
	If checkBlank(Request("lstBstate"),"") <> "" Then
	    vBstate=Request("lstBstate")
	Else
	    vBstate=Request("txtBstate")
	End If
	
	vBzip=Request("txtBzip")
	vBcountry=Request("lstBCountry")
	vBurl=Request("txtBurl")
	vBphone=Request("txtBphone")
	vBfax=Request("txtBfax")
	vCFname=Request("txtCFname")
	vCLname=Request("txtCLname")
	vCphone=Request("txtCphone")
	vCaddress=Request("txtCaddress")
	vCcity=Request("txtCcity")
	vIATACode = Request("txtIATACode")
	vOTICode = Request("txtOTICode")
	
	If checkBlank(Request("lstCstate"),"") <> "" Then
	    vCstate=Request("lstCstate")
	Else
	    vCstate=Request("txtCstate")
	End If
	
	vCzip=Request("txtCzip")
	vMCountry=Request("lstMCountry")
	vCemail=Request("txtCemail")
	vInvoicePrefix=Request("txtInvoicePrefix")
	vNextInvoiceNo=Request("txtNextInvoiceNo")
	if vNextInvoiceNo="" then vNextInvoiceNo=1
	vInvoiceDate=Request("lstInvoiceDate")
	vInterPDF=Request("lstInternationalPDF")
	vNextCheckNo=Request("txtNextCheckNo")
	if vNextCheckNo="" then vNextCheckNo=1
	vUOM=Request("lstUOM")
	vUOMQty=Request("lstUOMQty")
	vCurrency=Request("txtCurrency")
	vCGS=Request("lstCGS")
	'-----------------------------------------------------------------------------GETTING DEFAULT FREIGHT CHARGE ITEM
	vCHIAIR=Request("lstCHIAIR") 
	'response.Write("------------"&vCHIAIR)
	vCHIOCN=Request("lstCHIOCN")
	'response.Write("------------"&vCHIOCN)
	
	vCOIAIR=Request("lstCOIAIR") 
	'response.Write("------------"&vCHIAIR)
	vCOIOCN=Request("lstCOIOCN")
	'response.Write("------------"&vCHIOCN)
	vFiscalEndMonth=Request("lstEndOfFiscalMonth")
	vSEDStatement = Request("txtSEDStatement")
	v_maxuser=checkBlank(Request("lstMaxUser"),null)
	vCountryCode = Request.Form("txtCountryCode")
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Save the Form to the DB
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	
	
if Save="yes" or Add = "yes" or jAdd = "yes" or Delete = "yes" or jDelete = "yes" then	

    'Saving Greeting Messages '''''''''''''''''''''''''''''''''''''''''''''''''
	
	SQL="select * from greetMessage where AgentID =" & elt_account_number 
    rs.Open SQL, eltConn, dOpenDynamic, adLockPessimistic,  adCmdText   
    
    if isNull(Session("msg")) then  

      For i=0 to 7
      msgTxts(i)=""
      Next
      
     end if
    
    if Not rs.EOF then 
       for i=0 to 7
           rs("MsgType")=msgTypes(i)
           rs("MsgTxt")=Request("txtGMsg" & i)
           rs.Update  
           rs.MoveNext      
       next        
       rs.Close       
    
    else    
        for i=0 to 7
         rs.AddNew
         rs("AgentID")=elt_account_number 
         rs("MsgType")=msgTypes(i)
         rs("MsgTxt")=Request("txtGMsg" & i)
         rs.Update
        next 
        rs.Close
    end if 
   ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	SQL= "select * from agent where elt_account_number = " & elt_account_number
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText

	If Not rs.EOF then
		rs("dba_name")=ltrim(vDBA)
		rs("business_legal_name")=ltrim(vBName)
		rs("business_fed_taxid")=vTaxID
		rs("usppi")=vUSPPI
		rs("business_address")=vBaddress
		rs("business_city")=vBcity
		rs("business_state")=vBstate
		rs("business_zip")=vBzip
		rs("business_country")=vBcountry
		rs("business_url")=vBurl
		rs("business_phone")=vBphone
		rs("business_fax")=vBfax
		rs("owner_lname")=vCFname
		rs("owner_fname")=vCLname
		rs("owner_phone")=vCphone
		rs("owner_mail_address")=vCaddress
		rs("owner_mail_city")=vCcity
		rs("agent_iata_code")=vIATACode
		rs("OTI_Code") = vOTICode
		rs("owner_mail_state")=vCstate
		rs("owner_mail_zip")=vCzip
		rs("owner_mail_country")=vMCountry
		rs("owner_email")=vCemail
'// by iMoon
		rs("iv_statement")=v_iv_statement			
		'// Added by Joon on Feb/27/2007 /////////////////////////////////////
		rs("faa_approval_no") = vFAANum
		rs("faa_approval_date")=vFAAEDate
		If Not isNull(v_maxuser) Then
		    rs("maxuser") = v_maxuser
		End If
		rs("country_code") = vCountryCode
		rs.Update
	else
		rs.AddNew
		rs("elt_account_number") = elt_account_number
		rs("dba_name")=vDBA
		rs("business_legal_name")=vBName
		rs("business_fed_taxid")=vTaxID
		rs("usppi")=vUSPPI
		rs("business_address")=vBaddress
		rs("business_city")=vBcity
		rs("business_state")=vBstate
		rs("business_zip")=vBzip
		rs("business_country")=vBcountry
		rs("business_url")=vBurl
		rs("business_phone")=vBphone
		rs("business_fax")=vBfax
		rs("owner_lname")=vCFname
		rs("owner_fname")=vCLname
		rs("owner_phone")=vCphone
		rs("owner_mail_address")=vCaddress
		rs("owner_mail_city")=vCcity
		rs("agent_iata_code")=vIATACode
		rs("OTI_Code") = vOTICode
		rs("owner_mail_state")=vCstate
		rs("owner_mail_zip")=vCzip
		rs("owner_mail_country")=vMCountry
		rs("owner_email")=vCemail
		'// Added by iMoon on Feb/26/2007 
		rs("iv_statement")=v_iv_statement
		'// Added by Joon on Feb/27/2007 /////////////////////////////////////
		rs("faa_approval_no") = vFAANum
		rs("faa_approval_date") = vFAAEDate
		If Not isNull(v_maxuser) Then
		    rs("maxuser") = v_maxuser
		End If
		rs("country_code") = vCountryCode
		rs.Update
	end if
	
	rs.Close
	
	
	SQL= "select * from user_profile where elt_account_number = " & elt_account_number
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	if rs.EOF then
		rs.AddNew
		rs("elt_account_number")=elt_account_number
	end if
	rs("invoice_prefix")=vInvoicePrefix
	rs("next_invoice_no")=vNextInvoiceNo
	rs("default_invoice_date")=vInvoiceDate
	rs("next_check_no")=vNextCheckNo
	rs("uom")=vUOM
	rs("uom_qty")=vUOMQty
	rs("currency")=vCurrency
	rs("default_cgs")=vCGS
	'-------------------------------------------------------------------------SAVING DEFAULT AIR/OCEAN FREIGHT CHARGE ITEM
	
	rs("default_air_charge_item")=vCHIAIR
	rs("default_ocean_charge_item")=vCHIOCN
	
	rs("default_air_cost_item")=vCOIAIR
	rs("default_ocean_cost_item")=vCOIOCN

	rs("fiscalEndMonth")=vFiscalEndMonth
	rs("international_pdf") = vInterPDF
	rs("sed_statement") = vSEDStatement
	rs.Update
	rs.close

end if

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Initialize the form with data from DB
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

SQL= "select * from agent where elt_account_number = " & elt_account_number
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
If Not rs.EOF Then
	vDBA=rs("dba_name")
	vBName=rs("business_legal_name")
	vTaxID=rs("business_fed_taxid")
	vUSPPI=rs("usppi")
	vBaddress=rs("business_address")
	vBcity=rs("business_city")
	vBstate=rs("business_state")
	vBzip=rs("business_zip")
	vBcountry=rs("business_country")
	vBurl=rs("business_url")
	vBphone=rs("business_phone")
	vBfax=rs("business_fax")
	vCFname=rs("owner_lname")
	vCLname=rs("owner_fname")
	vCphone=rs("owner_phone")
	vCaddress=rs("owner_mail_address")
	vCcity=rs("owner_mail_city")
	vIATACode=rs("agent_iata_code")
	vOTICode = rs("OTI_Code")
	vCstate=rs("owner_mail_state")
	vCzip=rs("owner_mail_zip")
	vMCountry=rs("owner_mail_country")
	vCemail=rs("owner_email")
	v_iv_statement=rs("iv_statement")	
	'// Added by Joon on Feb/27/2007 /////////////////////////////////////
	vFAANum = rs("faa_approval_no")
	vFAAEDate = rs("faa_approval_date")	
	v_maxuser = rs("maxuser")	
	vCountryCode = rs("country_code")
End If
rs.Close
SQL= "select * from user_profile where elt_account_number = " & elt_account_number
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
If Not rs.EOF Then
	vInvoicePrefix=rs("invoice_prefix")
	vNextInvoiceNo=rs("next_invoice_no")
	vInvoiceDate=rs("default_invoice_date")
	vNextCheckNo=rs("next_check_no")
	vUOM=rs("uom")
	vUOMQty=rs("uom_qty")
	vCurrency=rs("currency")
	vInterPDF=rs("international_pdf")
	vSEDStatement = rs("sed_statement")
	
	If IsNull(rs("default_cgs")) = False then
		vCGS=rs("default_cgs")
	else
		vCGS=0
	end if
	vfiscalEndMonth=rs("fiscalEndMonth")
	
	if (NOT isnull(rs("default_air_charge_item"))) then
		vCHIAIR=rs("default_air_charge_item")
	else
		vCHIAIR=-1
	end if	

	if (NOT isnull(rs("default_ocean_charge_item"))) then
		vCHIOCN=rs("default_ocean_charge_item")	
	else
		vCHIOCN=-1
	end if	
	
	if (NOT isnull(rs("default_air_cost_item"))) then
		vCOIAIR=rs("default_air_cost_item")
	else
		vCOIAIR=-1
	end if	
	
	if (NOT isnull(rs("default_ocean_cost_item"))) then
		vCOIOCN=rs("default_ocean_cost_item")	
	else
		vCOIOCN=-1
	end if	


end if
rs.close

'// domestic/international bill prefix

Dim aSeq(100),aPrefix(100),aType(100),aDesc(100),aNextNo(100)

If agent_is_dome="Y" And agent_is_intl="Y" Then
    SQL= "select * from user_prefix where elt_account_number = " & elt_account_number _
        & " and (type='HAWB' or type='HBOL' or type='DOME' or type='WR' or type='SO') order by type,prefix"
Elseif agent_is_dome="Y" And agent_is_intl="N" Then
    SQL= "select * from user_prefix where elt_account_number = " & elt_account_number _
        & " and (type='DOME' or type='WR' or type='SO') order by type,prefix"
Elseif agent_is_dome="N" And agent_is_intl="Y" Then
    SQL= "select * from user_prefix where elt_account_number = " & elt_account_number _
        & " and (type='HAWB' or type='HBOL') order by type,prefix"
Else
    SQL = "SELECT TOP 0 * FROM user_prefix where elt_account_number = " & elt_account_number
End If

rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
tIndex=0
do While Not rs.EOF
	aSeq(tIndex)=rs("seq_num")
	aPrefix(tIndex)=rs("prefix")
	aType(tIndex)=rs("type")
	aDesc(tIndex)=rs("desc")
	aNextNo(tIndex)=rs("next_no")
	rs.MoveNext
	tIndex=tIndex+1
loop
rs.close


'// domestic/international file prefix

Dim jSeq(100),jPrefix(100),jType(100),jDesc(100),jNextNo(100)

If agent_is_dome="Y" And agent_is_intl="Y" Then
    SQL= "select seq_num,prefix,type,[desc],next_no from user_prefix where elt_account_number = " & elt_account_number _
        & " and (type='AEJ' or type='OEJ' or type='AIJ' or type='OIJ' or type='ETC' or type='DAJ' or type='DTJ') order by type,prefix"
Elseif agent_is_dome="Y" And agent_is_intl="N" Then
    SQL= "select seq_num,prefix,type,[desc],next_no from user_prefix where elt_account_number = " & elt_account_number _
        & " and (type='ETC' or type='DAJ' or type='DTJ') order by type,prefix"
Elseif agent_is_dome="N" And agent_is_intl="Y" Then
    SQL= "select seq_num,prefix,type,[desc],next_no from user_prefix where elt_account_number = " & elt_account_number _
        & " and (type='AEJ' or type='OEJ' or type='AIJ' or type='OIJ' or type='ETC') order by type,prefix"
Else
    SQL = "SELECT TOP 0 * FROM user_prefix where elt_account_number = " & elt_account_number
End If


rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
jIndex=0
do While Not rs.EOF
	jSeq(jIndex)=rs("seq_num")
	jPrefix(jIndex)=rs("prefix")
	jType(jIndex)=rs("type")
	jDesc(jIndex)=rs("desc")
	jNextNo(jIndex)=rs("next_no")
	rs.MoveNext
	jIndex=jIndex+1
loop
rs.close

'get Cost of Goods Sold info
SQL= "select gl_account_number,gl_account_desc from gl where elt_account_number = " & elt_account_number & " and gl_account_type='"&CONST__COST_OF_SALES&"' order by gl_account_number"
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
'----------------------------------------------------------------------->
Dim DefaultCGS(1024),DefaultCGSName(1024)
CGSIndex=0
Do While Not rs.EOF
	DefaultCGS(CGSIndex)=Clng(rs("gl_account_number"))
	DefaultCGSName(CGSIndex)=rs("gl_account_desc")
	CGSIndex=CGSIndex+1
	rs.MoveNext
Loop
rs.Close
'------------------------------------------------------------------------->
'get item_charge info
SQL= "select item_no,item_desc from item_charge  where elt_account_number = " & elt_account_number & " ORDER BY item_name"
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing

Dim DefaultChI(1024),DefaultChIName(1024)
DefaultChI(0)=-1
DefaultChIName(0)="SELECT ONE"
ChIIndex=1
Do While Not rs.EOF
	DefaultChI(ChIIndex)=Clng(rs("item_no"))
	DefaultChIName(ChIIndex)=rs("item_desc")
	ChIIndex=ChIIndex+1
	rs.MoveNext
Loop
rs.Close

'-------------------------------------------------------------------------->

'------------------------------------------------------------------------->
'get item_cost info
SQL= "select item_no,item_desc from item_cost  where elt_account_number = " & elt_account_number & " ORDER BY item_name"
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing

Dim DefaultCOI(1024),DefaultCOIName(1024)
DefaultCOI(0)=-1
DefaultCOIName(0)="SELECT ONE"
COIIndex=1
Do While Not rs.EOF
	DefaultCOI(COIIndex)=Clng(rs("item_no"))
	DefaultCOIName(COIIndex)=rs("item_desc")
	COIIndex=COIIndex+1
	rs.MoveNext
Loop
rs.Close

'-------------------------------------------------------------------------->


'get Greeting Messages from the database

SQL="select MsgTxt from greetMessage where AgentID =" & elt_account_number 
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
msgIndex=0

if Not rs.EOF then 
 Session("msg")= true
end if 
    Do While Not rs.EOF	
	    msgTxts(msgIndex)=rs("MsgTxt")	
        msgIndex=msgIndex+1
	    rs.MoveNext
    Loop

rs.Close 

Set rs=Nothing

'////////////// Fiscal Year
if isnull(vFiscalEndMonth) or trim(vFiscalEndMonth) = "" then
	vFiscalEndMonth = "12"
end if

'////////////////////////////////////////////////////////////////////////////

eltConn.CommitTrans

GetAllCountryCodes()

Sub GetAllCountryCodes
    Dim tmpTable, SQL, rs
    
    set code_list_all = Server.CreateObject("System.Collections.ArrayList")
	SQL = "select country_code, substring(country_name,0,40) as country_name from all_country_code order by country_name" 

	Set rs = eltConn.Execute(SQL)

	Do While Not rs.EOF
		Set tmpTable = Server.CreateObject("System.Collections.HashTable")
		tmpTable.Add "code",rs("country_code").value
		tmpTable.Add "code_description", rs("country_name").value '& fill_space(rs("country_name").value,35) & rs("country_code").value
		
		tmpTable.Add "description",rs("country_name").value  
		code_list_all.Add tmpTable	
		rs.MoveNext
	Loop
	rs.Close
End Sub

%>
<!--  #include file="../include/recent_file.asp" -->
<body link="336699" vlink="336699" leftmargin="0" topmargin="0">
    <form name="form1" method="POST">
        <input type="image" style="position:absolute; visibility:hidden" onclick="return false;" />
        <div id="tooltipcontent">
        </div>
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td height="32" align="left" valign="middle" class="pageheader">
                    Company Information
                </td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="1" cellspacing="0" bgcolor="#9190A5">
            <tr>
                <td>
                    <input type="hidden" name="scrollPositionX">
                    <input type="hidden" name="scrollPositionY">
                    <input type="hidden" name="hNoItem" value="<%= tIndex %>">
                    <input type="hidden" name="jhNoItem" value="<%= jIndex %>">
                    <table width="100%" border="0" cellpadding="1" cellspacing="0">
                        <tr bgcolor="C7C6E1">
                            <td height="22" align="left" valign="top" class="bodyheader">
                            </td>
                            <td height="24" colspan="10" align="center" valign="middle">
                                <img src="../images/button_save_medium.gif" width="46" height="18" onclick="SaveClick()"
                                    style="cursor: hand"></td>
                        </tr>
                        <tr>
                            <td height="1" align="left" valign="top" bgcolor="#9190A5" class="bodyheader">
                            </td>
                            <td width="111">
                            </td>
                            <td width="105">
                            </td>
                            <td width="291">
                            </td>
                            <td width="0">
                            </td>
                            <td width="31">
                            </td>
                            <td width="86">
                            </td>
                            <td colspan="2">
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr align="center" valign="middle">
                            <td width="2" height="20" align="left" bgcolor="DDDDED" class="bodyheader">
                                &nbsp;</td>
                            <td colspan="10" align="left" bgcolor="DDDDED" class="bodyheader">
                                Business Information</td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                Name (DBA)</td>
                            <td colspan="3" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <input name="txtDBA" class="shorttextfield" value="<%= vDBA %>" maxlength="128" style="width: 230px">
                            </td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                Legal Name
                            </td>
                            <td colspan="4" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <input name="txtBname" class="shorttextfield" value="<%= vBname %>" maxlength="128"
                                    style="width: 230px"></td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#f3f3f3" class="bodycopy" style="height: 20px">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#f3f3f3" class="bodycopy" style="height: 20px">
                                Tax Payer ID</td>
                            <td colspan="3" align="left" bgcolor="#f3f3f3" class="bodycopy" style="height: 20px">
                                <b><font size="2">
                                    <input name="txtTaxID" class="shorttextfield" maxlength="16" value="<%= vTaxID %>">
                                </font></b>
                            </td>
                            <td align="left" bgcolor="#f3f3f3" class="bodycopy" style="height: 20px">
                                &nbsp;</td>
                            <td align="left" bgcolor="#f3f3f3" class="bodycopy" style="height: 20px">
                                USPPI EIN
                            </td>
                            <td colspan="4" align="left" bgcolor="#f3f3f3" class="bodycopy" style="height: 20px">
                                <b><font size="2">
                                    <input name="txtUSPPI" class="shorttextfield" value="<%= vUSPPI %>" maxlength="64"
                                        size="24">
                                </font></b>
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                Address</td>
                            <td colspan="3" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <b><font size="2">
                                    <input name="txtBaddress" class="shorttextfield" maxlength="128" value="<%= vBaddress %>"
                                        style="width: 230px">
                                </font></b>
                            </td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                City</td>
                            <td colspan="4" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <b><font size="2">
                                    <input name="txtBcity" class="shorttextfield" value="<%= vBcity %>" size="24">
                                </font></b>
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                State/Province</td>
                            <td colspan="3" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                <b><font size="2">
                                    <select name="lstBstate" size="1" class="smallselect" style="width: 60px">
                                        <option></option>
                                        <% for i=0 to 50 %>
                                        <option <% if vBstate=USState(i) then response.write("selected") %>>
                                            <%= USState(i) %>
                                        </option>
                                        <% next %>
                                    </select> <input type="text" id="txtBstate" name="txtBstate" class="shorttextfield" value="<%=vBstate %>" />
                                </font></b>
                            </td>
                            <td align="left" bgcolor="#f3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#f3f3f3" class="bodycopy">
                                Business Zip</td>
                            <td colspan="4" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                <input name="txtBzip" class="m_shorttextfield" value="<%= vBzip %>"
                                    size="15"></td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                Country</td>
                            <td colspan="3" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <select name="lstBCountry" id="lstBCountry" size="1" class="smallselect" style="width: 160px">
                                        <option></option>
                                        <% For i=0 To code_list_all.Count-1 %>
                                        <option value="<%=code_list_all(i)("description") %>" <% If vBcountry=code_list_all(i)("description") Then Response.Write("selected=selected") %>>
                                            <%=code_list_all(i)("description") %>
                                        </option>
                                        <% next %>
                                    </select>
                            </td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                URL</td>
                            <td colspan="4" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <b><font size="2">
                                    <input name="txtBurl" class="shorttextfield" value="<%= vBurl %>" maxlength="64"
                                        size="24">
                                </font></b>
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                Phone Number</td>
                            <td colspan="3" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                <b><font size="2">
                                    <input name="txtBphone" class="m_shorttextfield" value="<%= vBphone %>"
                                        size="24">
                                </font></b>
                            </td>
                            <td align="left" bgcolor="#f3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#f3f3f3" class="bodycopy">
                                Fax Number</td>
                            <td colspan="4" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                <b><font size="2">
                                    <input name="txtBfax" class="m_shorttextfield" value="<%= vBfax %>"
                                        size="24">
                                </font></b>
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" height="18" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                IATA Code
                            </td>
                            <td colspan="3" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <b><font size="2">
                                    <input name="txtIATACode" class="shorttextfield" value="<%= vIATACode %>" maxlength="32"
                                        size="24">
                                </font></b>
                            </td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                FAA IAC No.</td>
                            <td colspan="4" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <input name="txtFAANum" class="shorttextfield" value="<%= vFAANum %>" size="24">
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" height="18" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                </td>
                            <td colspan="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                OTI No.
                            </td>
                            <td colspan="3" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <input name="txtOTICode" class="shorttextfield" value="<%=vOTICode %>" size="24" />
                            </td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                IAC Exp Date</td>
                            <td colspan="4" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <input name="txtFAAEDate" class="m_shorttextfield " preset="shortdate" value="<%= vFAAEDate %>"
                                    size="24">
                            </td>
                        </tr>
                        <tr>
                            <td height="1" colspan="11" align="left" valign="top" bgcolor="#9190A5" class="bodyheader">
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" height="20" align="left" bgcolor="DDDDED" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="10" align="left" bgcolor="DDDDED" class="bodyheader">
                                Contact Information</td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#FFFFFF" class="bodycopy" style="height: 20px">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#FFFFFF" class="bodycopy" style="height: 20px">
                                First Name</td>
                            <td colspan="3" align="left" bgcolor="#FFFFFF" class="bodycopy" style="height: 20px">
                                <input name="txtCFname" class="shorttextfield" maxlength="64" value="<%= vCFname %>">
                            </td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy" style="height: 20px">
                                &nbsp;</td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy" style="height: 20px">
                                Last Name</td>
                            <td colspan="4" align="left" bgcolor="#FFFFFF" class="bodycopy" style="height: 20px">
                                <b><font size="2">
                                    <input name="txtCLname" class="shorttextfield" maxlength="64" value="<%= vCLname %>">
                                </font></b>
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                Mailing Address</td>
                            <td colspan="3" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                <b><font size="2">
                                    <input name="txtCaddress" class="shorttextfield" value="<%= vCaddress %>" maxlength="128"
                                        style="width: 230px">
                                </font></b>
                            </td>
                            <td align="left" bgcolor="#f3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#f3f3f3" class="bodycopy">
                                Mailing City</td>
                            <td colspan="4" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                <b><font size="2">
                                    <input name="txtCcity" class="shorttextfield" maxlength="64" value="<%= vCcity %>"
                                        size="15">
                                </font></b>
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                Mailing State/Province</td>
                            <td colspan="3" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <select name="lstCstate" size="1" class="smallselect" style="width: 60px">
                                    <option></option>
                                    <% for i=0 to 50 %>
                                    <option <% if vCstate=USState(i) then response.write("selected") %>>
                                        <%= USState(i) %>
                                    </option>
                                    <% next %>
                                </select> <input type="text" id="txtCstate" name="txtCstate" class="shorttextfield" value="<%=vCstate %>" />
                            </td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                Mailing Zip</td>
                            <td colspan="4" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <b><font size="2">
                                    <input name="txtCzip" class="m_shorttextfield" value="<%= vCzip %>"
                                        size="15">
                                </font></b>
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                Mailing Country</td>
                            <td colspan="3" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                <select name="lstMCountry" id="lstMCountry" size="1" class="smallselect" style="width: 160px">
                                        <option></option>
                                        <% For i=0 To code_list_all.Count-1 %>
                                        <option value="<%=code_list_all(i)("description") %>" <% If vMCountry=code_list_all(i)("description") Then Response.Write("selected=selected") %>>
                                            <%=code_list_all(i)("description") %>
                                        </option>
                                        <% next %>
                                    </select>
                            </td>
                            <td align="left" bgcolor="#f3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#f3f3f3" class="bodycopy">
                                Phone Number</td>
                            <td colspan="4" align="left" bgcolor="#f3f3f3" class="bodycopy">
                                <b><font size="2">
                                    <input name="txtCPhone" class="m_shorttextfield" value="<%= vCphone %>">
                                </font></b>
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                Email Address</td>
                            <td colspan="3" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <b><font size="2">
                                    <input name="txtCemail" class="shorttextfield" maxlength="128" value="<%= vCemail %>"
                                        size="32">
                                </font></b>
                            </td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="4" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" height="18" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="3" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                <b><font size="2"></font></b>
                            </td>
                            <td align="left" bgcolor="#F3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#F3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="4" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                <b><font size="2"></font></b>
                            </td>
                        </tr>
                        <tr>
                            <td height="1" colspan="11" align="left" valign="top" bgcolor="#9190A5" class="bodyheader">
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" height="20" align="left" bgcolor="DDDDED" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="10" align="left" bgcolor="DDDDED" class="bodyheader">
                                Company Configuration
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                Invoice Prefix</td>
                            <td colspan="3" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <input name="txtInvoicePrefix" maxlength="16" type="text" class="shorttextfield"
                                    value="<%= vInvoicePrefix %>" size="15"></td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                Next Invoice No.</td>
                            <td colspan="4" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <b><font size="2">
                                    <input name="txtNextInvoiceNo" type="text" class="shorttextfield" maxlength="9" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                        value="<%= vNextInvoiceNo %>" size="15" />
                                    <input name="txtNextCheckNo" type="hidden" class="shorttextfield" value="<%= vNextCheckNo %>" />
                                </font></b>
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                Default Invoice Date</td>
                            <td colspan="3" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                <b><font size="2">
                                    <select name="lstInvoiceDate" size="1" class="smallselect" style="width: 76px">
                                        <option>Today</option>
                                        <option <% if vInvoiceDate="ETD" then response.write("selected") %>>ETD</option>
                                        <option <% if vInvoiceDate="ETA" then response.write("selected") %>>ETA</option>
                                    </select>
                                </font></b>
                            </td>
                            <td align="left" bgcolor="#F3f3f3" class="bodycopy">
                            </td>
                            <td align="left" bgcolor="#F3f3f3" class="bodycopy">
                                International PDF Support</td>
                            <td colspan="4" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                <select id="lstInternationalPDF" name="lstInternationalPDF" class="smallselect">
                                    <option value="N" <% if vInterPDF="N" then response.write("selected") %>>Off</option>
                                    <!--<option value="Y" <% if vInterPDF="Y" then response.write("selected") %>>On</option>-->
                                </select>
                                * for non-US customers only
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                Default UOM</td>
                            <td colspan="3" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <select name="lstUOM" size="1" class="smallselect" style="width: 80px">
                                    <option value="LB" <% if vUOM="LB" then response.write("selected") %>>LB/IN</option>
                                    <option value="KG" <% if vUOM="KG" then response.write("selected") %>>KG/CM</option>
                                </select>
                                <select name="lstUOMQty" size="1" class="smallselect" style="width: 70px">
                                    <option value="PCS" <% if vUOMQty="PCS" then response.write("selected") %>>PCS</option>
                                    <option value="BOX" <% if vUOMQty="BOX" then response.write("selected") %>>BOX</option>
                                    <option value="PLT" <% if vUOMQty="PLT" then response.write("selected") %>>PLT</option>
                                    <option value="CTN" <% if vUOMQty="CTN" then response.write("selected") %>>CTN</option>
                                    <option value="SET" <% if vUOMQty="SET" then response.write("selected") %>>SET</option>
                                    <option value="CRT" <% if vUOMQty="CRT" then response.write("selected") %>>CRT</option>
                                    <option value="SKD" <% if vUOMQty="SKD" then response.write("selected") %>>SKD</option>
                                    <option value="UNIT" <% if vUOMQty="UNIT" then response.write("selected") %>>UNIT</option>
                                    <option value="PKGS" <% if vUOMQty="PKGS" then response.write("selected") %>>PKGS</option>
                                    <option value="CNTR" <% if vUOMQty="CNTR" then response.write("selected") %>>CNTR</option>
                                </select>
                            </td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                Country / Currency</td>
                            <td colspan="4" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <input type="text" id="txtCountryCode" name="txtCountryCode" value="<%=vCountryCode %>"
                                    class="shorttextfield" maxlength="9" size="5" onclick="GetOtherCountry(this)"
                                    readonly="readonly" style="cursor: hand" />
                                <input type="text" id="txtCurrency" name="txtCurrency" value="<%=vCurrency %>" class="shorttextfield"
                                    maxlength="9" size="5" onkeydown="GetOtherCurrency(this,'txtCountryCode')" onclick="GetOtherCurrency(this,'txtCountryCode')"
                                    readonly="readonly" style="cursor: hand" />
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                Default Air Freight Charge
                            </td>
                            <td colspan="3" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                <select name="lstCHIAIR" size="1" class="smallselect" style="width: 150px">
                                    <% for k=0 to ChIIndex-1 %>
                                    <option value="<%= DefaultChI(k) %>" <% if DefaultChI(k)=cLng(vCHIAIR) then response.write("selected") %>>
                                        <%= DefaultChIName(k) %>
                                    </option>
                                    <% next %>
                                </select>
                                <% if mode_begin then %>
                                <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip(' Indicates which Charge Item Air Freight will be listed as in the accounting system. Default is AIR FREIGHT.');"
                                    onmouseout="hidetip()">
                                    <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                <% end if %>
                            </td>
                            <td align="left" bgcolor="#F3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#F3f3f3" class="bodycopy">
                                Default Ocean Freight Charge
                            </td>
                            <td colspan="4" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                <select name="lstCHIOCN" size="1" class="smallselect" style="width: 150px">
                                    <% for k=0 to ChIIndex-1 %>
                                    <option value="<%= DefaultChI(k) %>" <% if DefaultChI(k)=cLng(vCHIOCN) then response.write("selected") %>>
                                        <%= DefaultChIName(k) %>
                                    </option>
                                    <% next %>
                                </select>
                                <% if mode_begin then %>
                                <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip(' Indicates which Charge Item Ocean Freight will be listed as in the accounting system. Default is OCEAN FREIGHT.');"
                                    onmouseout="hidetip()">
                                    <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                <% end if %>
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td align="left" bgcolor="#F3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                Default Air Freight Cost
                            </td>
                            <td colspan="3" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                <select name="lstCOIAIR" size="1" class="smallselect" style="width: 150px">
                                    <% for k=0 to COIIndex-1 %>
                                    <option value="<%= DefaultCOI(k) %>" <% if DefaultCOI(k)=cLng(vCOIAIR) then response.write("selected") %>>
                                        <%= DefaultCOIName(k) %>
                                    </option>
                                    <% next %>
                                </select>
                                <% if mode_begin then %>
                                <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip(' Indicates which Cost Item Air Freight will be listed as in the accounting system. Default is AIR FREIGHT.');"
                                    onmouseout="hidetip()">
                                    <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                <% end if %>
                            </td>
                            <td align="left" bgcolor="#F3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#F3f3f3" class="bodycopy">
                                Default Ocean Freight Cost
                            </td>
                            <td colspan="4" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                <select name="lstCOIOCN" size="1" class="smallselect" style="width: 150px">
                                    <% for k=0 to COIIndex-1 %>
                                    <option value="<%= DefaultCOI(k) %>" <% if DefaultCOI(k)=cLng(vCOIOCN) then response.write("selected") %>>
                                        <%= DefaultCOIName(k) %>
                                    </option>
                                    <% next %>
                                </select>
                                <% if mode_begin then %>
                                <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip(' Indicates which Cost Item Ocean Freight will be listed as in the accounting system. Default is AIR FREIGHT.');"
                                    onmouseout="hidetip()">
                                    <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                <% end if %>
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                Default Agent Profit Category
                                <br>
                            </td>
                            <td colspan="3" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <b><font size="2">
                                    <select name="lstCGS" size="1" class="smallselect" style="width: 150px">
                                        <% for k=0 to CGSIndex-1 %>
                                        <option value="<%= DefaultCGS(k) %>" <% if DefaultCGS(k)=cLng(vCGS) then response.write("selected") %>>
                                            <%= DefaultCGSName(k) %>
                                        </option>
                                        <% next %>
                                    </select>
                                    <% if mode_begin then %>
                                </font></b>
                                <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Indicates what the profit category will be by default for agent profit.  This can be changed at the agent profit area in accounting to suit the individual situation.');"
                                    onmouseout="hidetip()">
                                    <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                <% end if %>
                                <b><font size="2"></font></b>
                            </td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#FFFFFF" class="bodycopy">
                                Country Master
                            </td>
                            <td colspan="4" align="left" bgcolor="#FFFFFF" class="bodycopy">
                                <b><font size="2">
                                    <input name="btnCountry" type="button" class="formbody" value="Go" onclick="javascript:GoCountrySet();"
                                        style="cursor: hand">
                                    <% if mode_begin then %>
                                </font></b>
                                <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Takes you to the screen to select which countries you would like to set up in the system.  If you do not see a country you need in a dropdown, this is the place to add it.');"
                                    onmouseout="hidetip()">
                                    <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                <% end if %>
                                <b><font size="2"></font></b>
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" height="18" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                Last Month of Fiscal Year
                            </td>
                            <td colspan="3" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                <select name="lstEndOfFiscalMonth" size="1" class="smallselect" style="width: 40px">
                                    <option value="01" <% if vfiscalEndMonth= "01" then response.write("selected") %>>01</option>
                                    <option value="02" <% if vfiscalEndMonth= "02" then response.write("selected") %>>02</option>
                                    <option value="03" <% if vfiscalEndMonth= "03" then response.write("selected") %>>03</option>
                                    <option value="04" <% if vfiscalEndMonth= "04" then response.write("selected") %>>04</option>
                                    <option value="05" <% if vfiscalEndMonth= "05" then response.write("selected") %>>05</option>
                                    <option value="06" <% if vfiscalEndMonth= "06" then response.write("selected") %>>06</option>
                                    <option value="07" <% if vfiscalEndMonth= "07" then response.write("selected") %>>07</option>
                                    <option value="08" <% if vfiscalEndMonth= "08" then response.write("selected") %>>08</option>
                                    <option value="09" <% if vfiscalEndMonth= "09" then response.write("selected") %>>09</option>
                                    <option value="10" <% if vfiscalEndMonth= "10" then response.write("selected") %>>10</option>
                                    <option value="11" <% if vfiscalEndMonth= "11" then response.write("selected") %>>11</option>
                                    <option value="12" <% if vfiscalEndMonth= "12" then response.write("selected") %>>12</option>
                                </select>
                            </td>
                            <td align="left" bgcolor="#F3f3f3" class="bodycopy">
                                </td>
                            <td align="left" bgcolor="#F3f3f3" class="bodycopy">
                                SED Statement
                            </td>
                            <td colspan="4" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                <input type="text" class="shorttextfield" id="txtSEDStatement" name="txtSEDStatement" style="width:250px" value="<%=vSEDStatement %>" />
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" height="18" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                </td>
                            <td colspan="2" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                
                            </td>
                            <td colspan="3" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                
                            </td>
                            <td align="left" bgcolor="#F3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td align="left" bgcolor="#F3f3f3" class="bodycopy">
                                <% If LCase(login_name) = "system" Then %>
                                Max. User
                                <% End IF %>
                            </td>
                            <td colspan="4" align="left" bgcolor="#F3f3f3" class="bodycopy">
                                <% If LCase(login_name) = "system" Then %>
                                <b><font size="2">
                                    <input type="text" name="lstMaxUser" class="shorttextfield" maxlength="18" style="behavior: url(../include/igNumDotChkLeft.htc);
                                        width: 70px" value="<%=checkBlank(v_maxuser,3) %>" />
                                </font></b>
                                <% end if%>
                            </td>
                        </tr>
                        <tr>
                            <td height="1" colspan="11" align="left" valign="top" bgcolor="#9190A5" class="bodyheader">
                            </td>
                        </tr>
                        <tr>
                            <td height="1" colspan="11" align="left" valign="top" bgcolor="#9190A5">
                            </td>
                        </tr>
                        <tr valign="middle">
                            <td width="2" height="20" align="left" bgcolor="DDDDED" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="10" align="left" bgcolor="DDDDED" class="bodyheader">
                                Default E-mail Message Setup
                                <% if mode_begin then %>
                                <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('The messages you type here will but automatically placed on the emails you send, in addition to any attachments, for the Operation specified.');"
                                    onmouseout="hidetip()">
                                    <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                <% end if %>
                            </td>
                        </tr>
                        <% for i=0 to 7 %>
                        <tr>
                            <td bgcolor="f3f3f3">
                                &nbsp;</td>
                            <td colspan="4" bgcolor="f3f3f3">
                                <span class="bodyheader">
                                    <%=msgTypes(i)%>
                                </span>
                            </td>
                            <td colspan="4" bgcolor="f3f3f3">
                                <span class="bodyheader">
                                    <%=msgTypes(i+1)%>
                                </span>
                            </td>
                            <td bgcolor="f3f3f3">
                                &nbsp;</td>
                            <td bgcolor="f3f3f3">
                                &nbsp;</td>
                        </tr>
                        <tr valign="middle" bgcolor="#FFFFFF">
                            <td align="left" bgcolor="#FFFFFF">
                                &nbsp;</td>
                            <td height="22" colspan="4" align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy">
                                <textarea name="txtGMsg<%= i %>" cols="54" rows="4" class="multilinetextfield"><%=msgTxts(i)%></textarea><br>
                                &nbsp;</td>
                            <%i=i+1%>
                            <td colspan="5" align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy">
                                <textarea name="txtGMsg<%= i %>" cols="60" rows="4" class="multilinetextfield"><%=msgTxts(i)%></textarea></td>
                            <td align="left" valign="top" bgcolor="#FFFFFF">
                                &nbsp;</td>
                        </tr>
                        <% Next %>
                        <tr valign="middle">
                            <td width="2" height="20" align="left" bgcolor="DDDDED" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="10" align="left" bgcolor="DDDDED" class="bodyheader">
                                Default Invoice Statement
                            </td>
                        </tr>
                        <tr valign="middle" bgcolor="#FFFFFF">
                            <td align="left" bgcolor="#FFFFFF">
                                &nbsp;</td>
                            <td height="22" colspan="10" align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy">
                                <textarea name="iv_statement" cols="115" rows="10" class="multilinetextfield"><%=v_iv_statement%></textarea></td>
                        </tr>
                        <tr>
                            <td height="1" colspan="11" align="left" valign="top" bgcolor="#9190A5" class="bodyheader">
                            </td>
                        </tr>
                        <tr align="center">
                            <td height="24" colspan="11" valign="middle" bgcolor="C7C6E1">
                                <input type="image" src="../images/button_save_medium.gif" width="46" height="18"
                                    onclick="SaveClick(); return false;" style="cursor: pointer" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
<script type="text/javascript">
function SaveClick(){
    var AccountInfoLen = document.form1.txtBcity.value.length
        + document.form1.lstBstate.value.length 
        + document.form1.txtBzip.value.length 
        + document.form1.lstBCountry.value.length ;
    if ( AccountInfoLen > 40 ) {
	    alert( "The total length of City,State,Zip,Country is too long (" + AccountInfoLen+ ") \r\nIt could not be printed at dot metrix printer.");
	    return false;
    }

    document.form1.action="co_config.asp?Save=yes" + "&WindowName=" + window.name;
    document.form1.target="_self";
    document.form1.method="POST";
    form1.submit();
}
</script>
<script type="text/vbscript">
<!--
Sub AddClick()  'never used
    Prefix=document.form1.txtAddPrefix.Value
    NoItem=cint(document.form1.hNoItem.Value)

    if Not Prefix="" then
	    for i= 1 to NoItem
		    if Prefix =  document.all("Prefix").item(i).value then
			    msgbox "The prefix " & Prefix & " exists already."
			    exit sub
		    end if
	    next

	    document.form1.action="co_config.asp?Add=yes"
	    document.form1.method="POST"
	    form1.submit()
    end if

End Sub

Sub jAddClick()  'never used
    Prefix=document.form1.jtxtAddPrefix.Value
    NoItem=cint(document.form1.jhNoItem.Value)

    if Not Prefix="" then
        for i= 0 to NoItem-1
	        if Prefix =  document.all("jPrefix").item(i).value then
		        msgbox "The prefix " & Prefix & " exists already."
		        exit sub
	        end if
        next

        document.form1.action="co_config.asp?jAdd=yes"
        document.form1.method="POST"
        form1.submit()
    end if
End Sub

Sub DeleteClick(iNum, SeqNum)  'never used
    if Not SeqNum="" then
	    Prefix=document.all("Prefix").item(iNum).value
	    ok=MsgBox ("Do you really want to delete this Prefix?" & chr(13) & "Continue?",36,"Message")
	    if ok=6 then	
		    document.form1.action="co_config.asp?Delete=yes&SeqNum=" & SeqNum & "&WindowName=" & window.name
		    document.form1.target="_self"
		    document.form1.method="POST"
		    form1.submit()
	    end if
    end if
End Sub

Sub jDeleteClick(iNum, SeqNum)  'never used
    if Not SeqNum="" then
	    Prefix=document.all("jPrefix").item(iNum).value
	    ok=MsgBox ("Do you really want to delete this Prefix?" & chr(13) & "Continue?",36,"Message")
	    if ok=6 then	
		    document.form1.action="co_config.asp?jDelete=yes&SeqNum=" & SeqNum & "&WindowName=" & window.name
		    document.form1.target="_self"
		    document.form1.method="POST"
		    form1.submit()
	    end if
    end if
End Sub

Sub MenuMouseOver()
End Sub
Sub MenuMouseOut()

End Sub
-->
</script>

<script type="text/jscript">
if ('<%=qDAFStr%>' == 'Y') {
    var obj=document.getElementById('lstCHIAIR');    
    obj.focus();   
    
}

if ('<%=qDOFStr%>' == 'Y') {
    var obj=document.getElementById('lstCHIOCN');    
    obj.focus();   
    
}

//alert('<%=qDAFCostStr%>');
		
if ('<%=qDAFCostStr%>' == 'Y') {
	var obj=document.getElementById('lstCOIAIR');    
	obj.focus(); 
}

//alert('<%=qDOFCostStr%>');
if ('<%=qDOFCostStr%>' == 'Y') {
	var obj=document.getElementById('lstCOIOCN');    
	obj.focus(); 
}

</script>

<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
