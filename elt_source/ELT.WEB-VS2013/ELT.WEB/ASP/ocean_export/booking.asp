<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Booking</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <!--  #INCLUDE FILE="../include/connection.asp" -->
    <style type="text/css">
        <!--
        .style1 {
	        color: #000000;
	        font-weight: bold;
        }
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
        .style6 {color: #c16b42}
        .style7 {color: #663366}
        -->
    </style>
    <!-- /Start of Combobox/ -->
    <script type="text/javascript">
        <!--
        // var ComboBoxes =  new Array('list1','list2','list3',.....);
        var ComboBoxes = new Array('lstBookingNum', 'lstCarrier', 'lstVendor');
        // -->
    </script>
    <script type="text/jscript" src="../Include/iMoonCombo.js"></script>
    
    <!-- /End of Combobox/ -->
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<%

'// by ig 7/11/2006 for FILE No.
Dim vBookingNum
Dim aFILEPrefix(128),aNextFILE(128),fIndex,vFILEPrefix, rs2,vFileNo

Dim vMBOL,vCarrier
Dim vOriginPort,vDestPort
Dim vDeptDate,vArrivalDate
Dim vMoveType
Dim Save,booking_date
Dim rs, SQL
Dim vVoyageNo, vCutOff_Time
Dim IsHouseExist,IsMasterExist

Save=Request.QueryString("Save")
Edit=Request.QueryString("Edit")
Close=Request.QueryString("Close")
myServer=Request.ServerVariables("SERVER_NAME")

eltConn.BeginTrans

Set rs = Server.CreateObject("ADODB.Recordset")

'// by ig 7/11/2006 for FILE No.
Set rs2 = Server.CreateObject("ADODB.Recordset")

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Saving a New/Existing Booking Entry
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


if Save="yes" then
	
	'// vBookingNum=Request("lstBookingNum")
	vBookingNum=checkBlank(Request.Form.Item("txtBookingNum"),"")
	vFileNo=Request.Form.Item("txtFileNo")
	'// by ig 7/11/2006 for FILE No. ///////////////////////////
	vFileNo = GET_FILE_NUMBER("OEJ", vFileNo, vBookingNum )
	'///////////////////////////////////////////////////////////

	'// Search by file number
	'// Added by Joon on 11-6-2007 //////////////////////////////
	IsHouseExist = checkBlank(vBookingNum,"")<>"" And IsDataExist("select * from hbol_master a left outer join ocean_booking_number b on (a.elt_account_number=b.elt_account_number and a.booking_num=b.booking_num) where b.elt_account_number = " & elt_account_number & " and b.file_no='" & vFileNo & "'") 
	IsMasterExist = checkBlank(vBookingNum,"")<>"" And IsDataExist("select * from mbol_master a left outer join ocean_booking_number b on (a.elt_account_number=b.elt_account_number and a.booking_num=b.booking_num) where b.elt_account_number = " & elt_account_number & " and b.file_no='" & vFileNo & "'") 
	'////////////////////////////////////////////////////////////

	vMBOL=Request("txtMBOLNum")
	vCarrierInfo=Request("lstCarrier")
	pos=0
	pos=instr(vCarrierInfo,"-")
	if pos>0 then
		vSCAC=Mid(vCarrierInfo,1,pos-1)
		vCarrierInfo=Mid(vCarrierInfo,pos+1,200)
	end if
	pos=instr(vCarrierInfo,"-")
	if pos>0 then
		vCarrierCode = Mid(vCarrierInfo,1,pos-1)
		vCarrierDesc = Mid(vCarrierInfo,pos+1,200)
	else
		vCarrierCode = 0
		vCarrierDesc = ""
	end if
	
	'vVendorInfo=Request("lstVendor")
	'pos=0
	'pos=instr(vVendorInfo,"-")
	'if pos>0 then
	'	vVendorCode=Mid(vVendorInfo,1,pos-1)
	'	vVendorName=Mid(vVendorInfo,pos+1,200)
	'end if
	
	vVendorName = Request("lstVendor:Text").Item
	vVendorCode = Request("lstVendor").Item
	
	vVSLName=Request("txtVSLName")
	
	vVoyageNo=request("txtVoageNo")'<----------------------------------------------------------insert from form request
	vCutOff_Time=request("txtCutOff_Time")
	
	vMoveType=Request("txtMoveType")
	vReceiptPlace=Request("txtReceiptPlace")
	PortInfo=Request("lstOriginPort")
	pos=0
	pos=instr(PortInfo,"-")
	if pos>0 then
		vOriginPort=Left(PortInfo,pos-1)
		PortInfo=Mid(PortInfo,pos+1,200)
	end if
	pos=instr(PortInfo,"-")
	if pos>0 then
		vOriginPortDesc=Left(PortInfo,pos-1)
		PortInfo=Mid(PortInfo,pos+1,200)
	end if
	pos=instr(PortInfo,"-")
	if pos>0 then
		vOriginPortState=Left(PortInfo,pos-1)
		PortInfo=Mid(PortInfo,pos+1,200)
	end if	
	pos=instr(PortInfo,"-")
	if pos>0 then
		vOriginPortCountry=Left(PortInfo,pos-1)
		PortInfo=Mid(PortInfo,pos+1,200)
	end if
	pos=instr(PortInfo,"-")
	if pos>0 then
		vOriginPortAESCode=Left(PortInfo,pos-1)
	end if
	
	PortInfo=Request("lstDestPort")
	pos=0
	pos=instr(PortInfo,"-")
	if pos>0 then
		vDestPort=Left(PortInfo,pos-1)
		PortInfo=Mid(PortInfo,pos+1,200)
	end if
	pos=instr(PortInfo,"-")
	if pos>0 then
		vDestPortDesc=Left(PortInfo,pos-1)
		PortInfo=Mid(PortInfo,pos+1,200)
	end if
	pos=instr(PortInfo,"-")
	if pos>0 then
		vDestPortCountry=Mid(PortInfo,1,pos-1)
		PortInfo=Mid(PortInfo,pos+1,200)
	end if
	pos=instr(PortInfo,"-")
	if pos>0 then
		vDestPortAESCode=Mid(PortInfo,1,pos-1)
		vDestCountryCode=Mid(PortInfo,pos+1,200)
	end if
	
	
	vDeptDate=Request("txtETD")
	vArrivalDate=Request("txtETA")
	vDeliveryPlace=Request("txtDeliveryPlace")
	vCutOff=Request("txtCutOff")
	vFCLLCL=Request("lstFCLLCL")
	vContainerType=Request("txtContainerType")
    booking_date = Request("txtBookingDate")

    '// insert or update ocean_booking_number
	SQL= "select * from ocean_booking_number where elt_account_number = " & elt_account_number 
	If vFileNo <> "" And Request.Form("lstBookingNum") <> "" Then 
		SQL = SQL & " and file_no=N'" & vFileNo & "'"
		If IsDataExist("select * from ocean_booking_number where elt_account_number = " & elt_account_number & " and booking_num=N'" & vBookingNum & "' AND file_no<>N'" & vFileNo & "'") Then
            Response.Write("<script>if(!confirm('The booking number already exists.\nDo you want to load this?')){window.history.go(-1);} else {window.location.href='booking.asp?Edit=yes&BookingNum=" & Server.URLEncode(vBookingNum) & "'; } </script>")
            Response.End()
        End If
	Else
		'// This is useless if file number becomes required field
		SQL = SQL & " and booking_num=N'" & vBookingNum & "'"
	End If

	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	if rs.EOF then
		rs.AddNew
		rs("elt_account_number")=elt_account_number
	end If
	If Not IsMasterExist And Not IsHouseExist Then
		rs("booking_num")=vBookingNum
	Else
		vBookingNum=rs("booking_num")
	End If
	rs("mbol_num")=vMBOL
	rs("carrier_code")=vCarrierCode
	rs("carrier_desc")=vCarrierDesc
	rs("scac")=Mid(vSCAC,1,4) '// Air7Seas problem
	rs("consolidator_name")=vVendorName
	rs("consolidator_code")=vVendorCode
	
	rs("vsl_name")=vVSLName '----------------------------------------------DB entry point 	
	rs("voyage_no")=vVoyageNo 	
	
	
	rs("receipt_place")=vReceiptPlace
	rs("origin_port_id")=vOriginPort
	rs("origin_port_aes_code")=vOriginPortAESCode
	rs("origin_port_location")=vOriginPortDesc
	rs("origin_port_state")=vOriginPortState
	rs("origin_port_country")=vOriginPortCountry
	rs("Dest_Port_ID")=vDestPort
	rs("dest_port_aes_code")=vDestPortAESCode
	rs("dest_port_location")=vDestPortDesc
	rs("dest_port_country")=vDestPortCountry
	rs("dest_country_code")=vDestCountryCode
	rs("departure_date")=vDeptDate
	rs("arrival_date")=vArrivalDate
	rs("delivery_place")=vDeliveryPlace
	rs("move_type")=vMoveType
	rs("cutoff")=vCutOff
	rs("cutoff_time")=vCutOff_Time'-------------------------------------------------cutoff time entry
	rs("fcl_lcl")=vFCLLCL
	rs("file_no")=vFileNo
	rs("container_type")=vContainerType
	rs("Status")="B"
	rs("booking_date") = ConvertAnyValue(booking_date,"Date",Date())
	
	rs.Update
	rs.close

	'// by ig 7/11/2006 for FILE No.		
	CALL UPDATE_USER_NEXT_NUMBER_IN_PREFIX( "OEJ", vFileNo )
	'//////////////////////////////

    '// update hbol_master
	SQL= "select * from hbol_master where elt_account_number = " _
	    & elt_account_number & " and booking_num=N'" & vBookingNum & "'"
	
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	do while Not rs.EOF
		rs("mbol_num")=vMBOL
		rs("export_carrier")=vCarrierDesc
		rs("pre_receipt_place")=vReceiptPlace
		rs("loading_port")=vOriginPortDesc
		rs("delivery_place")=vDeliveryPlace
		rs("unloading_port")=vDestPortDesc
		rs("origin_country")=vOriginPortState
		rs("export_instr")=vFileNo
		rs("move_type")=vMoveType
		rs("departure_date")=vDeptDate
		rs("dest_country")=vDestPortCountry
		rs.Update
		rs.MoveNext
	loop
	rs.close
	
    '// update mbol_master
	SQL= "select * from mbol_master where elt_account_number = " _
	    & elt_account_number & " and booking_num=N'" & vBookingNum & "'"
	
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	if Not rs.EOF then
		rs("mbol_num")=vMBOL
		rs("export_carrier")=vCarrierDesc
		rs("pre_receipt_place")=vReceiptPlace
		rs("loading_port")=vOriginPortDesc
		rs("delivery_place")=vDeliveryPlace
		rs("unloading_port")=vDestPortDesc
		rs("origin_country")=vOriginPortState
		rs("export_instr")=vFileNo
		rs("move_type")=vMoveType
		rs("departure_date")=vDeptDate
		rs("vessel_name")=vVSLName
		rs.Update
	end if
	rs.close
	
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Edit existing Booking Entry 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	
	
elseif Edit="yes" then

    IsHouseExist = False
    IsMasterExist = False
    
	vBookingNum=Request.QueryString("BookingNum")

	if NOT vBookingNum = "NEWBOOK" then
		If isnull(vBookingNum) or vBookingNum = "" then
		    vFileNo=Request.QueryString("FileNo")
		    SQL= "select * from ocean_booking_number where elt_account_number = " _
		        & elt_account_number & " and replace(file_no,'-','')=N'" & replace(vFileNo,"-","") & "'" 
		Else
			vBookingNum=Request.QueryString("BookingNum")
			SQL= "select * from ocean_booking_number where elt_account_number = " _
			    & elt_account_number & " and booking_num=N'" & vBookingNum & "'"
		End If
		
		rs.Open SQL, eltConn, , , adCmdText
		If Not rs.EOF Then
			vBookingNum=rs("booking_num")
			vMBOL=rs("mbol_num")
			vCarrierCode = ConvertAnyValue(rs("carrier_code").Value,"Long",0)
			vVendorCode = ConvertAnyValue(rs("consolidator_code").Value,"Long",0)
			vVSLName=rs("vsl_name")
		    vVoyageNo = rs("voyage_no")
			vReceiptPlace=rs("receipt_place")
			vOriginPort=rs("origin_port_id")
			vDestPort=rs("Dest_Port_ID")
			vArrivalDate=rs("arrival_date")
			vDeptDate=rs("departure_date")
			vDeliveryPlace=rs("delivery_place")
			vMoveType=rs("move_type")
			vCutOff=rs("cutoff")
			vFCLLCL=rs("fcl_lcl")
			vCutOff_Time = rs("cutoff_time")'----------------cut off time
			vContainerType=rs("container_type")
			vFileNo=rs("file_no")
			booking_date=rs("booking_date")
			rs.Close
			
			'// Added by Joon on 11-6-2007 //////////////////////////////
	        IsHouseExist = checkBlank(vBookingNum,"")<>"" And IsDataExist("select * from hbol_master where elt_account_number = " & elt_account_number & " and booking_num=N'" & vBookingNum & "'") 
	        IsMasterExist = checkBlank(vBookingNum,"")<>"" And IsDataExist("select * from mbol_master where elt_account_number = " & elt_account_number & " and booking_num=N'" & vBookingNum & "'")
	        '////////////////////////////////////////////////////////////
		Else
			rs.Close
			if isnull(vBookingNum) or vBookingNum = "" then
%>
<script type="text/jscript">    alert('File # ' + '<%=vFileNo%>' + ' does not exist.');</script>
<%		
				vFileNo = ""
			else
%>
<script type="text/jscript">    alert('Ocean Booking # ' + '<%=vBookingNum%>' + ' does not exist.');</script>
<%		
				vBookingNum = ""
			end if
		end if
	end if
elseif Close="yes" then
	vBookingNum=Request("lstBookingNum")
	'// Added by Joon on 11-6-2007 //////////////////////////////
	IsHouseExist = checkBlank(vBookingNum,"")<>"" And IsDataExist("select * from hbol_master where elt_account_number = " & elt_account_number & " and booking_num='" & vBookingNum & "'") 
	IsMasterExist = checkBlank(vBookingNum,"")<>"" And IsDataExist("select * from mbol_master where elt_account_number = " & elt_account_number & " and booking_num='" & vBookingNum & "'")
	'////////////////////////////////////////////////////////////
	SQL= "select * from ocean_booking_number where elt_account_number = " _
	    & elt_account_number & " and booking_num=N'" & vBookingNum & "'"
	
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	if not rs.EOF then
		rs("Status")="C"
	end if
	rs.Update
	rs.close
	vBookingNum=""
end if
'get Booking Number Info



Dim BookingNum(),aMBOL(),aBook(),bookingCount
SQL= "select booking_num,mbol_num from ocean_booking_number where elt_account_number = " _
    & elt_account_number & " and status='B' order by booking_num"

rs.Open SQL, eltConn, adOpenStatic, adLockReadOnly, adCmdText

If rs.RecordCount < 0 Then
    bookingCount = 0
Else
    bookingCount = rs.RecordCount
End If

reDim BookingNum(bookingCount+1)
reDim aMBOL(bookingCount+1)
reDim aBook(bookingCount+1)

bIndex=0
mIndex=0

Do While Not rs.EOF And Not rs.BOF
	if NOT TRIM(rs("booking_num")) = "" then
		BookingNum(bIndex)=rs("booking_num")
		bIndex=bIndex+1
	end if
	if NOT TRIM(rs("mbol_num")) = "" then
		aBook(mIndex) = rs("booking_num")
		aMBOL(mIndex) = rs("mbol_num")
		mIndex=mIndex+1		
	end if
	rs.MoveNext
Loop
rs.Close

'get carrier info


Dim CarrierName,CarrierCode,SCAC,VendorName,VendorCode

Set CarrierName = Server.CreateObject("System.Collections.ArrayList")
Set CarrierCode = Server.CreateObject("System.Collections.ArrayList")
Set SCAC = Server.CreateObject("System.Collections.ArrayList")
Set VendorName = Server.CreateObject("System.Collections.ArrayList")
Set VendorCode = Server.CreateObject("System.Collections.ArrayList")

SQL = "SELECT org_account_number,carrier_id,is_vendor,is_carrier, " _
            & "CASE WHEN isnull(class_code,'') = '' THEN dba_name " _
            & "ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' " _
            & "END as dba_name FROM organization where elt_account_number = " & elt_account_number _
            & " and (is_carrier='Y' or is_vendor='Y') order by dba_name"  
            


rs.CursorLocation = adUseClient	
rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
Set rs.ActiveConnection = Nothing

CarrierName.Add "Select One"
CarrierCode.Add 0
SCAC.Add ""

VendorName.Add "Select One"
VendorCode.Add 0
Do While Not rs.EOF And Not rs.BOF
	IsVendor=rs("is_vendor")
	IsCarrier=rs("is_carrier")
	If IsCarrier="Y" then
		CarrierName.Add rs("dba_name").value
		CarrierCode.Add ConvertAnyValue(rs("org_account_number").value,"Long",0)
		If IsNull(CarrierCode(cIndex)) then CarrierCode.Add 0
		    SCAC.Add rs("carrier_id").value
	End If
	If IsVendor="Y" then
		VendorName.Add rs("dba_name").value
		VendorCode.Add ConvertAnyValue(rs("org_account_number").value,"Long",0)
		If Isnull(VendorCode(vIndex)) then VendorCode.Add 0
	End If
	rs.MoveNext
Loop
rs.Close

'GET PORT INFO
Dim PortCode(1000),PortAESCode(1000),PortDesc(1000),PortState(1000),PortCountry(1000),PortCountryCode(1000)
SQL= "select * from port where elt_account_number = " & elt_account_number & " order by port_desc"



rs.Open SQL, eltConn, , , adCmdText
pIndex=0
Do While Not rs.EOF
	PortCode(pIndex)=rs("port_code")
	PortAESCode(pIndex)=rs("port_id")
	PortDesc(pIndex)=rs("port_desc")
	PortState(pIndex)=rs("port_state")
	PortCountry(pIndex)=rs("port_country")
	PortCountryCode(pIndex)=rs("port_country_code")
	pIndex=pIndex+1
	rs.MoveNext
Loop


CALL GET_FILE_PREFIX_FROM_USER_PROFILE( "OEJ" )
Set rs2=Nothing
rs.Close
Set rs = Nothing

eltConn.CommitTrans

%>
<%
'//////// by ig 07/09/2006 /////////////////////////////
'///////////////////////////////////////////////////////

SUB UPDATE_USER_NEXT_NUMBER_IN_PREFIX( strType, tmpFileNo )
DIM tmpNextNo,tPrefix

	if aFILEPrefix(0) = "NONE" then
		exit sub
	end if

	pos=0
	pos=instr(tmpFileNo,"-")
	if pos>0 then
		tPrefix=Mid(tmpFileNo,1,pos-1)
		tmpNextNo=Mid(tmpFileNo,pos+1,32)
	else
		exit sub
	end if

	SQL= "select * from user_prefix where elt_account_number=" & elt_account_number _
	    & " and type=N'"& strType &"' and prefix=N'" & tPrefix & "'"
    
	rs2.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If Not rs2.EOF Then
	    tmpNextNo = ConvertAnyValue(tmpNextNo,"Long",0)
		if tmpNextNo >= ConvertAnyValue(rs2("next_no").value,"Long",0) Then
			rs2("next_no") = tmpNextNo + 1
			rs2.Update
		end if
		for i=0 to fIndex
			if tPrefix=aFILEPrefix(i) then
				aNextFILE(i) = tmpNextNo + 1
			end if
		next
	end if
	rs2.Close

END SUB

FUNCTION GET_FILE_NUMBER ( strType, strFileNo, tmpBookNum)

DIM  tmpFileNo,FileNoExist,vNextFileNo

vFILEPrefix = request("txtFileNo")
pos=0
pos=instr(vFILEPrefix,"-")
if pos>0 then
	vFILEPrefix=Mid(vFILEPrefix,1,pos-1)
Else
	GET_FILE_NUMBER = strFileNo
	exit function
End If


if isnull(vFILEPrefix) or vFILEPrefix = "" then
	GET_FILE_NUMBER = strFileNo
	exit function
end if

vNextFileNo = request("hNEXTFILENo")

if vNextFileNo = "" then 
	vNextFileNo = "0"
end if
	
tmpFileNo = strFileNo

if tmpFileNo = "" then
	if Not vFILEPrefix="" then
		tmpFileNo=vFILEPrefix & "-" & vNextFileNo
	else
		tmpFileNo=vNextFileNo
	end if
end if

FileNoExist = true

DO WHILE FileNoExist
	SQL= "select * from ocean_booking_number where elt_account_number = " & elt_account_number _
	    & " and file_no=N'" & tmpFileNo & "' and booking_num<>N'" & tmpBookNum & "'"
	
	rs2.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If rs2.EOF=true Then		
		FileNoExist=false
		rs2.close
		GET_FILE_NUMBER = tmpFileNo
		exit function
	else
		tmpFileNo = rs2("file_no")
		rs2.close
		pos=0
		pos=instr(tmpFileNo,"-")
		if pos>0 then
			vNextFileNo=Mid(tmpFileNo,pos+1,32)
		end if

		vNextFileNo=vNextFileNo+1
		tmpFileNo=vFILEPrefix & "-" & vNextFileNo
		
	end if
LOOP

END FUNCTION

SUB GET_FILE_PREFIX_FROM_USER_PROFILE( strType )

	if isnull(vFileNo) then
		vFileNo = ""
	end if

	vFILEPrefix=Request("hFILEPrefix")

	if isnull(vFILEPrefix) then
		vFILEPrefix = ""
	end if

	if vFILEPrefix = "" then
		if not vFileNo = "" then
				pos=0
				pos=instr(vFileNo,"-")
				if pos>0 then
					vFILEPrefix=Mid(vFileNo,1,pos-1)
				end if
		end if
	end if

	SQL= "select prefix,next_no from user_prefix where elt_account_number = " _
	    & elt_account_number & " and type=N'"& strType & "' order by prefix"
	
	rs2.Open SQL, eltConn, , , adCmdText
	fIndex=0
	do While Not rs2.EOF
		aFILEPrefix(fIndex)=rs2("prefix")
		aNextFILE(fIndex)=rs2("next_no")

		if vFILEPrefix = "" then
			vFILEPrefix = aFILEPrefix(fIndex)
		end if
		
		if aFILEPrefix(fIndex)= vFILEPrefix then
			vNEXTFILENo = aNextFILE(fIndex)
		end if	
		
		rs2.MoveNext
		fIndex=fIndex+1
	loop
	rs2.Close

	if fIndex = 0 then
		aFILEPrefix(0) = "NONE"
		fIndex = 1
		vFILEPrefix = ""
	end if
	
	if NOT vFileNo = ""  then
		aFILEPrefix(0) = "EDIT"
		fIndex = 1
		vFILEPrefix = ""	
	end if
	
	if trim(vFileNo) = "" then
		if Not vFILEPrefix="" then
			vFileNo=vFILEPrefix & "-" & vNextFileNo
		else
			vFileNo=vNextFileNo
		end if
	end if
	
End SUB


%>
<% if vBookingNum="NEWBOOK" then vBookingNum="" %>
<!--  #include file="../include/recent_file.asp" -->
<body link="336699" vlink="336699" onload="self.focus();document.form1.txtFileNo.focus()">
    <form name="form1" method="post" action="">
    <input type="image" style="position: absolute; visibility: hidden" onclick="return false;" />
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td width="30%" height="32" align="left" valign="middle" class="pageheader">
                booking
            </td>
            <td width="70%" align="right" valign="baseline">
                <span class="bodyheader style7">FILE NO.</span>
                <input name="txtJobNum" type="text" class="lookup" size="22" value="Search Here"
                    onkeydown="javascript: if(event.keyCode == 13) { LookupFile(); }" onfocus="javascript: this.value = ''; this.style.color='#000000'; "
                    tabindex="1"><img src="../images/icon_search.gif" name="B1" width="33" height="27"
                        align="absmiddle" style="cursor: hand" onclick="LookupFile()">
            </td>
        </tr>
    </table>
    <div class="selectarea">
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <span class="select">Select Booking No. </span>
                </td>
                <td width="55%" rowspan="2" align="right" valign="bottom">
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td width="45%" valign="bottom">
                    <!-- //Start of Combobox// -->
                    <%  iMoonDefaultValue = vBookingNum %>
                    <%  iMoonComboBoxName =  "lstBookingNum" %>
                    <%  iMoonComboBoxWidth =  "148px" %>
                    <script language="javascript"> function <%=iMoonComboBoxName%>_OnChangePlus() { BookingChange(); } 
                    function <%=iMoonComboBoxName%>_OnAddNewPlus() { }
                    </script>
                    <div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width: <%=iMoonComboBoxWidth%>;
                        position: ; top: ; left: ; z-index: ;">
                        <input name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text"
                            class="ComboBox" autocomplete="off" style="width: <%=iMoonComboBoxWidth%>; vertical-align: middle"
                            value="<%=iMoonDefaultValue%>" tabindex="-1" />
                        <div id="<%=iMoonComboBoxName%>_Div" style="display: none; position: absolute; top: 0;
                            left: -140px; width: 17px">
                            <img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif"
                                border="0" />
                        </div>
                    </div>
                    <div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
                        top: 0; left: 0; width: 17px">
                        <img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif"
                            border="0" />
                    </div>
                    <!-- /End of Combobox/ -->
                    <select name="lstBookingNum" id="lstBookingNum" class="ComboBox" style="width: 148px;
                        height: 250px" onchange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                        <option value="0"></option>
                        <% for i=0 to bIndex-1 %>
                        <option value="<%= BookingNum(i) %>" <% if vBookingNum=BookingNum(i) then response.write("selected") %>>
                            <%= BookingNum(i) %>
                        </option>
                        <% next %>
                    </select>
                </td>
            </tr>
        </table>
    </div>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="6D8C80"
        bgcolor="6D8C80" class="border1px">
        <tr>
            <td>
                <input type="hidden" name="txtCarrierDesc">
                <input type="hidden" name="hFILEPrefix" value="<%= vFILEPrefix %>">
                <input type="hidden" name="hNEXTFILENo" value="<%= vNEXTFILENo %>">
                <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" bordercolor="6D8C80">
                    <tr>
                        <td height="24" align="center" valign="middle" bgcolor="BFD0C9">
                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="24%">
                                        <img src="/ASP/Images/spacer.gif" width="70" height="5">
                                    </td>
                                    <td width="52%" align="center" valign="middle">
                                        <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onclick="bsaveclick()"
                                            style="cursor: hand">
                                    </td>
                                    <td width="12%" align="right" valign="middle">
                                        <a href="/ASP/ocean_export/booking.asp" target="_self" tabindex="-1">
                                            <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0" style="cursor: hand"></a>
                                    </td>
                                    <td width="12%" align="right" valign="middle">
                                        <img src="../images/button_closebooking.gif" width="48" height="18" name="bClose"
                                            onclick="bCloseClick()" style="cursor: hand" alt="" />
                                        <% if mode_begin then %>
                                        <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Clicking this will close the current bill or booking. Closing it means it will still be saved in the system, but not accessible through the dropdowns on the Operations screen.  Often old bills that are very rarely accessed are closed to help keep the dropdowns clean.')"
                                            onmouseout="hidetip()">
                                            <img src="../Images/button_info.gif" align="bottom" class="bodylistheader" alt="" /></div>
                                        <% end if %>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td height="1" colspan="5" bgcolor="6D8C80">
                        </td>
                    </tr>
                    <tr>
                        <td height="1" align="center" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                            <br>
                            <br>
                            <table width="75%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <% if NOT vBookingNum = "" then %>
                                        <a href="javascript:;" onclick="javascript:goToMAWB(); return false;" class="goto">
                                            <img src="/ASP/Images/icon_goto.gif" width="36" height="21" align="absbottom">Go
                                            to Master B/L</a>
                                        <% end if %>
                                    </td>
                                    <td align="right">
                                        <span class="bodyheader">
                                            <img src="/ASP/Images/required.gif" align="absbottom">
                                            Required field </span>
                                    </td>
                                </tr>
                            </table>
                            <br>
                            <table width="75%" border="0" cellpadding="2" cellspacing="0" bordercolor="6D8C80"
                                bgcolor="6D8C80" class="border1px">
                                <tr align="left" valign="middle" bgcolor="E0EDE8" class="bodycopy">
                                    <td width="1%" height="22" valign="middle" bgcolor="E0EDE8">
                                        &nbsp;
                                    </td>
                                    <td valign="middle">
                                        <span class="style1">File No.</span>
                                    </td>
                                    <td valign="middle">
                                        &nbsp;
                                    </td>
                                    <td valign="middle">
                                        <span class="style1">Booking Date</span>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td colspan="2" valign="top">
                                        <% if NOT aFILEPrefix(0) = "NONE" and NOT aFILEPrefix(0) = "EDIT" then%>
                                        <select name="lstFILEPrefix" size="1" class="bodyheader" style="width: 80px" onchange="PrefixChange()">
                                            <% For i=0 To fIndex-1 %>
                                            <option value="<%= aNextFILE(i) %>" <% if vFILEPrefix=aFILEPrefix(i) then response.write("selected") %>>
                                                <%= aFILEPrefix(i) %>
                                            </option>
                                            <%  Next %>
                                        </select>
                                        <% end if %>
                                        <% if aFILEPrefix(0) = "NONE" then%>
                                        <input name="txtFileNo" class="shorttextfield" style="width: 110px" value="<%= vFileNo %>"
                                            size="20">
                                        <% else %>
                                        <input name="txtFileNo" class="readonlybold" style="width: 110px" value="<%= vFileNo %>"
                                            size="30" readonly="readonly">
                                        <% end if%>
                                    </td>
                                    <td>
                                        <input id="txtBookingDate" name="txtBookingDate" type="text" value="<%=checkBlank(booking_date,Date) %>"
                                            class="m_shorttextfield " preset="shortdate" />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                    <td height="2" colspan="5" bgcolor="6D8C80">
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                    <td bgcolor="f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td height="20" bgcolor="f3f3f3" class="bodyheader">
                                        <img src="/ASP/Images/required.gif" align="absbottom">New Ocean Booking No.
                                    </td>
                                    <td bgcolor="f3f3f3" class="bodyheader">
                                        &nbsp;
                                    </td>
                                    <td colspan="2" bgcolor="f3f3f3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                    <td height="19">
                                        &nbsp;
                                    </td>
                                    <td class="bodyheader">
                                        <% If IsMasterExist Or IsHouseExist Then %>
                                        <input name="txtBookingNum" value="<%= vBookingNum %>" size="27" class="d_shorttextfield"
                                            readonly="readonly" />
                                        <% Else %>
                                        <input name="txtBookingNum" value="<%= vBookingNum %>" size="27" class="m_shorttextfield" />
                                        <% End If %>
                                    </td>
                                    <td class="bodyheader">
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td class="bodyheader">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy">
                                    <td width="1%" height="20">
                                        &nbsp;
                                    </td>
                                    <td width="29%" height="20" class="bodyheader">
                                        Carrier
                                    </td>
                                    <td width="26%" class="bodyheader">
                                        &nbsp;
                                    </td>
                                    <td width="12%">
                                        <span class="bodyheader">Consolidator</span>
                                    </td>
                                    <td width="32%" class="bodyheader">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td colspan="2" class="bodycopy">
                                        <!-- /Start of Combobox/ -->
                                        <%  iMoonComboBoxName =  "lstCarrier" %>
                                        <%  iMoonComboBoxWidth =  "250px" %>
                                        <script language="javascript"> function <%=iMoonComboBoxName%>_OnChangePlus() {  } 
                                        function <%=iMoonComboBoxName%>_OnAddNewPlus() { }
                                        </script>
                                        <select name="lstCarrier" id="lstCarrier" listsize="20" class="ComboBox" size="1"
                                            style="width: 250px; display: none" onchange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                                            <% for i=0 to CarrierName.Count-1 %>
                                            <option value="<%= SCAC(i) & "-" & CarrierCode(i) & "-" & CarrierName(i) %>" <% 
					  if ConvertAnyValue(vCarrierCode,"Long",0) = ConvertAnyValue(CarrierCode(i),"Long",0) Then 
					    response.write("selected") 
						vCarrierName = CarrierName(i)
						if vCarrierName = "Select One" then vCarrierName = ""	
					  end if	
					  %>>
                                                <%= CarrierName(i) %>
                                            </option>
                                            <% next %>
                                        </select>
                                        <%  iMoonDefaultValue = vCarrierName %>
                                        <div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width: <%=iMoonComboBoxWidth%>;
                                            position: ; top: ; left: ; z-index: ;">
                                            <input name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text"
                                                class="ComboBox" autocomplete="off" style="width: <%=iMoonComboBoxWidth%>; vertical-align: middle"
                                                value="<%=iMoonDefaultValue%>" />
                                            <div id="<%=iMoonComboBoxName%>_Div" style="display: none; position: absolute; top: 0;
                                                left: -140px; width: 17px">
                                                <img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif"
                                                    border="0" />
                                            </div>
                                        </div>
                                        <div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
                                            top: 0; left: 0; width: 17px">
                                            <img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif"
                                                border="0" />
                                        </div>
                                        <!-- /End of Combobox/ -->
                                    </td>
                                    <td colspan="2">
                                        <!-- /Start of Combobox/ -->
                                        <%  iMoonComboBoxName =  "lstVendor" %>
                                        <%  iMoonComboBoxWidth =  "250px" %>

                                        <script language="javascript"> 
                                        function <%=iMoonComboBoxName%>_OnChangePlus() { }
                                         
    // Add New 10/30/2006
    function <%=iMoonComboBoxName%>_OnAddNewPlus(oText,oSelect,oDiv) 
    {  
        var orgNum = oSelect.value;
        var popAddClient = showModalDialog("../Include/quickAddClient.asp?orgNum=" + orgNum,"AddClient","dialogWidth:450px; dialogHeight:500px; help:0; status:0; scroll:0; center:1; Sunken;");
	    return true;
	    if (popAddClient != '' && typeof(popAddClient) != 'undefined')
	    { 
		    ajust_changed_list_vendor(popAddClient,oSelect,oDiv,oText);
	    }	
    }

    function ajust_changed_list_vendor(popAddClient,oSelect,oDiv,oText)
    {

	    // Add New 10/30/2006 // unremark followings if you want to disable edit mode.
	    ///////////////////////////////////// 	
	    //	oDiv.style.display = 'none'; 

	    var startPos = popAddClient.indexOf("-");
	    var sVal = popAddClient.substring(0,startPos);
	    var sName = popAddClient.substring(startPos+1);
	    var items = oSelect.options;
	    /////////////////////////////////////	

	    for( var i = 0; i < items.length; i++ ) {
		    var item = items[i];
		    if( item.text.toLowerCase() == sName.toLowerCase() ) {
			    oSelect.selectedIndex = i;
			    item.value = sVal;
			    break;
		    }
	    }

	    if ( i >= items.length )
	    {
		    var oOption = document.createElement("OPTION");
		    oSelect.options.add(oOption,1);
		    oOption.innerText = sName;
		    oOption.value = popAddClient;		
		    oSelect.selectedIndex = 1;
	    }

	    oText.value = sName;
    }

    function goToMAWB() {
         parent.window.location.href =
                "/OceanExport/MBOL/"
                + encodeURIComponent(
                    "ChangeBookingNum=yes&Edit=yes&BookingNum=<%=Server.URLEncode(vBookingNum) %>&WindowName=<%=WindowName %>"
                   
                );
	    //window.location.href = "new_edit_mbol.asp?ChangeBookingNum=yes&Edit=yes&BookingNum=<%=Server.URLEncode(vBookingNum) %>&WindowName=<%=WindowName %>";
    }

                                        </script>
                                        <select name="lstVendor" id="lstVendor" listsize="20" class="ComboBox" size="1" style="width: 250px;
                                            display: none" onchange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                                            <% for i=0 to VendorName.Count-1 %>
                                            <option value="<%= VendorCode(i) %>" <% 
					  if ConvertAnyValue(vVendorCode,"Long",0) = ConvertAnyValue(VendorCode(i),"Long",0) Then 
					  	response.write("selected") 
						vVendorName = VendorName(i)
						if vVendorName = "Select One" then vVendorName = ""							
					  end if		
					  %>>
                                                <%= VendorName(i) %>
                                            </option>
                                            <% next %>
                                        </select>
                                        <%  iMoonDefaultValue = vVendorName %>
                                        <div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width: <%=iMoonComboBoxWidth%>;
                                            position: ; top: ; left: ; z-index: ;">
                                            <input name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text"
                                                class="ComboBox" autocomplete="off" style="width: <%=iMoonComboBoxWidth%>; vertical-align: middle"
                                                value="<%=iMoonDefaultValue%>" />
                                            <div id="<%=iMoonComboBoxName%>_Div" style="display: none; position: absolute; top: 0;
                                                left: -140px; width: 17px">
                                                <img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif"
                                                    border="0" />
                                            </div>
                                        </div>
                                        <div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
                                            top: 0; left: 0; width: 17px">
                                            <img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif"
                                                border="0" alt="Quick Add Consolidator" />
                                        </div>
                                        <!-- /End of Combobox/ -->
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy">
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td class="bodyheader">
                                        Vessel Name
                                    </td>
                                    <td height="20" class="bodycopy">
                                        &nbsp;
                                    </td>
                                    <td class="bodyheader">
                                        Voyage No.
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td class="bodycopy">
                                        <input name="txtVSLName" class="shorttextfield" maxlength="64" value="<%= vVSLName %>"
                                            size="28" />
                                    </td>
                                    <td class="bodycopy">
                                        &nbsp;
                                    </td>
                                    <td colspan="2">
                                        <input name="txtVoageNo" class="shorttextfield" maxlength="16" value="<%= vVoyageNo %>"
                                            size="28" />
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy">
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td class="bodyheader">
                                        Port of Loading
                                    </td>
                                    <td height="20" class="bodyheader">
                                        <img src="/ASP/Images/required.gif" align="absbottom">ETD
                                    </td>
                                    <td class="bodyheader">
                                        Place of Receipt
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td class="bodycopy">
                                        <select name="lstOriginPort" size="1" class="smallselect" style="width: 160px">
                                            <option value="">Select One</option>
                                            <% for i= 0 to pIndex-1 %>
                                            <option value="<%= PortCode(i) & "-" & PortDesc(i) & "-" & PortState(i) & "-" & PortCountry(i) & "-" & PortAESCode(i) & "-" & PortCountryCode(i) %>"
                                                <% if vOriginPort=PortCode(i) Then response.write("selected") %>>
                                                <%= PortCode(i) & "-" & PortDesc(i) %>
                                            </option>
                                            <% next %>
                                        </select>
                                    </td>
                                    <td class="bodycopy">
                                        <input name="txtETD" id="txtETD" class="m_shorttextfield " preset="shortdate" value="<%= vDeptDate %>"
                                            size="19">
                                    </td>
                                    <td colspan="2">
                                        <input name="txtReceiptPlace" class="shorttextfield" maxlength="32" value="<%= vReceiptPlace %>"
                                            size="28">
                                    </td>
                                    <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy">
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td class="bodyheader">
                                            Port of Unloading
                                        </td>
                                        <td height="20" class="bodyheader">
                                            <img src="/ASP/Images/required.gif" align="absbottom">ETA
                                        </td>
                                        <td class="bodyheader">
                                            <img src="/ASP/Images/required.gif" align="absbottom">Cut-Off Date
                                        </td>
                                        <td class="bodyheader">
                                            Time
                                        </td>
                                        <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td class="bodycopy">
                                                <select name="lstDestPort" size="1" class="smallselect" style="width: 160px">
                                                    <option value="">Select One</option>
                                                    <% for i= 0 to pIndex-1 %>
                                                    <option value="<%= PortCode(i) & "-" & PortDesc(i) & "-" & PortCountry(i) & "-" & PortAESCode(i) & "-" & PortCountryCode(i) %>"
                                                        <% if vDestPort=PortCode(i) Then response.write("selected") %>>
                                                        <%= PortCode(i) & "-" & PortDesc(i) %>
                                                    </option>
                                                    <% next %>
                                                </select>
                                            </td>
                                            <td class="bodycopy">
                                                <input name="txtETA" id="txtETA"  class="m_shorttextfield " preset="shortdate" value="<%= vArrivalDate %>"
                                                    size="19" />
                                            </td>
                                            <td>
                                                <input name="txtCutOff" id="txtCutOff" class="m_shorttextfield " preset="shortdate" value="<%= vCutOff %>"
                                                    size="19" />
                                            </td>
                                            <td>
                                                <input name="txtCutOff_Time" class="m_shorttextfield maxsize" preset="maxsize" value="<%= vCutOff_Time %>"
                                                    size="19" />
                                            </td>
                                            <tr align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td height="20" class="bodyheader">
                                                    Type of Move
                                                </td>
                                                <td class="bodyheader">
                                                    FCL/LCL
                                                </td>
                                                <td colspan="2" class="bodyheader">
                                                    Place of Delivery
                                                </td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                <td height="20">
                                                    &nbsp;
                                                </td>
                                                <td valign="top" class="bodycopy">
                                                    <input name="txtMoveType" class="shorttextfield" maxlength="32" value="<%= vMoveType %>"
                                                        size="29">
                                                </td>
                                                <td class="bodycopy">
                                                    <select name="lstFCLLCL" size="1" class="smallselect" style="width: 88px" onchange="LCLChange()">
                                                        <option value="">Select One</option>
                                                        <option <% if vFCLLCL="FCL" then response.write("selected") %>>FCL</option>
                                                        <option <% if vFCLLCL="LCL" then response.write("selected") %>>LCL</option>
                                                    </select>
                                                    <input type="text" value="<%= vContainerType %>" name="txtContainerType" class="shorttextfield"
                                                        style="width: 80px; visibility: <% if Not vFCLLCL="FCL" then response.write("hidden") %>">
                                                </td>
                                                <td colspan="2" valign="top">
                                                    <input name="txtDeliveryPlace" class="shorttextfield" maxlength="32" value="<%= vDeliveryPlace %>"
                                                        size="29">
                                                </td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy">
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td height="20" class="bodycopy">
                                                    <strong>Master B/L No.</strong>
                                                </td>
                                                <td class="bodycopy">
                                                    &nbsp;
                                                </td>
                                                <td colspan="2">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#Ffffff" class="bodycopy">
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td height="20" colspan="2" class="bodycopy">
                                                    <input name="txtMBOLNum" class="shorttextfieldBold" maxlength="16" value="<%= vMBOL %>"
                                                        size="28">
                                                    <select name="lstMBOL" id="lstMBOL" size="1" class="smallselect" style="width: 148px; visibility: hidden">
                                                        <% for i=0 to mIndex-1 %>
                                                        <option value="<%= aBook(i) %>">
                                                            <%= aMBOL(i) %>
                                                        </option>
                                                        <% next %>
                                                    </select>
                                                </td>
                                                <td colspan="2">
                                                    &nbsp;
                                                </td>
                                            </tr>
                            </table>
                            <br>
                        </td>
                    </tr>
                    <tr>
                        <td height="1" align="left" valign="middle" bgcolor="#6D8C80">
                        </td>
                    </tr>
                    <tr>
                        <td height="24" align="center" valign="middle" bgcolor="#BFD0C9">
                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="24%">
                                        <img src="/ASP/Images/spacer.gif" width="70" height="5">
                                    </td>
                                    <td width="52%" align="center" valign="middle">
                                        <input type="image" src="../images/button_save_medium.gif" width="46" height="18"
                                            name="bSave" onclick="return false;" onmousedown="bsaveclick(); return false;"
                                            style="cursor: hand" />
                                    </td>
                                    <td width="12%" align="right" valign="middle">
                                        <a href="/ASP/ocean_export/booking.asp" target="_self">
                                            <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0" style="cursor: hand"></a>
                                    </td>
                                    <td width="12%" align="right" valign="middle">
                                        <input type="image" src="../images/button_closebooking.gif" width="48" height="18"
                                            name="bClose" onclick="return false;" onmousedown="bCloseClick(); return false;"
                                            style="cursor: hand" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <br>
    </form>
</body>
<script language="vbscript">
<!---

// by igMoon 07/10/2006 for File No.
Sub PrefixChange()
    sIndex = document.form1.lstFILEPrefix.selectedIndex
    Prefix = document.form1.lstFILEPrefix.item(sIndex).Text
    document.form1.hNEXTFILENo.value =  document.form1.lstFILEPrefix.value
    document.form1.txtFileNo.value = Prefix & "-" & document.form1.lstFILEPrefix.value
End Sub
/////////////////////////////////////
// Add search function 7/11/2006

/////////////////////////////
Sub Lookup()
/////////////////////////////
    DIM BookingNum
	BookingNum=document.form1.txtSMAWB.value

	if NOT TRIM(BookingNum) = "" then
		document.form1.txtsMAWB.value = ""
		document.form1.action="booking.asp?Edit=yes&BookingNum=" & encodeURIComponent(BookingNum)
		document.form1.method="POST"
		document.form1.target = "_self"
		form1.submit()
	END IF
End Sub
</script>
<script type="text/javascript">

    function LookupFile() {
        var FILENO = document.form1.txtJobNum.value;
        if (FILENO.trim() != "" && FILENO != "Search Here") {
            document.form1.txtJobNum.value = "";
            document.form1.action = "booking.asp?Edit=yes&FILENO=" + encodeURIComponent(FILENO);
            document.form1.method = "POST";
            document.form1.target = "_self";
            form1.submit();
        }
        else
            alert("Please enter a File No!");

    }
    function BookingChange() {
        var sIndex = document.form1.lstBookingNum.selectedIndex;
        var BookingNum = document.form1.lstBookingNum.item(sIndex).text;
        if (sIndex == 0)
            BookingNum = "NEWBOOK";

        document.form1.action = "booking.asp?Edit=yes&BookingNum=" + encodeURIComponent(BookingNum);
        document.form1.method = "POST";
        form1.submit();
    }
    function bsaveclick() {
        //sIndex = document.form1.lstBookingNum.selectedIndex
        var lstBookingObj = document.getElementById("lstBookingNum");
        var sIndex = lstBookingObj.selectedIndex;
        var mIndex = lstBookingObj.size;

        var BookNum = document.form1.txtBookingNum.value;

        if (BookNum.trim() == "") {
            alert("Please enter a Ocean Booking Number.");
            return;
        }
        if (document.form1.txtFileNo.value == "") {
            alert("Please, preset file numbers and prefixes in prefix manager. You can also manual enter it in this page.");
            return;
        }
        var existBookNum = false;
        if (sIndex > 0) {
            BookNum = document.form1.txtBookingNum.value.toUpperCase();
            existBookNum = false;

            for (var i = 0; i <= (mIndex - 1); i++) {
                if (BookNum == lstBookingObj.item(i).text.toUpperCase()) {
                    existBookNum = true;
                    i = mIndex;
                }
            }
          
        }
        else
            BookNum = lstBookingObj.item(sIndex).text;

        // If Not CheckBookingNo(TRIM(UCASE(document.form1.txtBookingNum.value))

        if (!CheckMBOLNo(document.form1.txtMBOLNum.value.toUpperCase(), BookNum))
            return;

        var DeptDate = document.form1.txtETD.value;
        var ArrivalDate = document.form1.txtETA.value;
        var CutOff = document.form1.txtCutOff.value;
        if (!IsDate(DeptDate))
            alert("Please enter Departure Date in MM/DD/YYYY format!");
        else if (!IsDate(ArrivalDate))
            alert("Please enter Arrival Date in MM/DD/YYYY format!");
        else if (!IsDate(CutOff))
            alert("Please enter Cutoff Date in MM/DD/YYYY HH:MM:SS format!");
        else {
            document.form1.action = "booking.asp?save=yes";
            document.form1.method = "POST";
            form1.submit();
        }
    }

    function LCLChange() {
        var sIndex = document.form1.lstFCLLCL.selectedIndex;
        if (document.form1.lstFCLLCL.item(sIndex).text != "FCL")
            document.form1.txtContainerType.style.visibility = "hidden";
        else
            document.form1.txtContainerType.style.visibility = "visible";
    }


    function bCloseClick() {
        var sIndex = document.form1.lstBookingNum.selectedIndex;
        if (sIndex > 0) {
            document.form1.action = "booking.asp?Close=yes";
            document.form1.method = "POST";
            form1.submit();
        }
    }
</script>
<script type="text/vbscript">
Sub MenuMouseOver()
  document.form1.lstBookingNum.style.visibility="hidden"
End Sub

Sub MenuMouseOut()
  document.form1.lstBookingNum.style.visibility="visible"
End Sub


--->
</script>
<script type="text/javascript">

    function CheckMBOLNo(vMBOL, vBookingNum) {
        var lstMBOL = document.getElementById("lstMBOL");

        for (var i = 0; i < lstMBOL.length; i++) {
            if (vMBOL == lstMBOL[i].text && vBookingNum != lstMBOL[i].value) {
                alert("The Master B/L " + vMBOL + " is already assigned to booking bumber " + lstMBOL[i].value);
                return false;
            }
        }

        return true;
    }

</script>

    
     <link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css"
        rel="stylesheet" type="text/css" />
        <script type="text/javascript">

            $(document).ready(function () {
                $("#txtETD").datepicker();            
                $("#txtETA").datepicker();  
                $("#txtBookingDate").datepicker(); 
                $("#txtCutOff").datepicker();                 
        
            });
        </script>
<!-- //for Tooltip// -->
<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
