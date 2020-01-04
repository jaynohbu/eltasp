<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/AspFunctions.inc" -->

<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
Response.ContentType = "text/xml"
Response.CharSet = "utf-8"
%>

<%
	if not check_url("IFF_MAIN") then 
		response.write "e"
		response.end
	end if
%>

<%
DIM elt_account_number,login_name,UserRight
Dim Action
DIM vOrgInfo1,vOrgInfo2,vTelFax
DIM pCnt,flag
DIM TOTAL_MAWB_P,MAWB_P,TOTAL_HAWB_P,HAWB_P
DIM mAirLine,mShipper,mConsignee,mTotalPiece,mWeight

Action = Request.QueryString("Action")
if isnull(Action) then Action = ""

' On error Resume Next :
elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
login_name = Request.Cookies("CurrentUserInfo")("login_name")
UserRight = Request.Cookies("CurrentUserInfo")("user_right")	


if Action = "" then
	response.write "e"
else
		select case Action
			case "get" 
				 get_shipping_data()
		end select

end if
%>

<%
sub get_shipping_data()
	DIM hMAWB,txtStartNo,StartNo,hNoItem,i
	DIM aCheck(),aHAWB(),aNoLabel(),aPiece(),aFrom(),aDest()
	DIM tmpHAWB,tmpNoLabel,tmpPiece,tmpFrom,tmpDest
	DIM hCnt
	DIM rs,SQL


	hMAWB = Request("hMAWB")
	hNoItem = cInt(Request("hNoItem"))
	txtStartNo = Request("txtStartNo")

'On Error Resume Next :

'	StartNo = cInt(txtStartNo)
	StartNo = 1

	ReDim aHAWB(hNoItem),aNoLabel(hNoItem),aPiece(hNoItem),aFrom(hNoItem),aDest(hNoItem),aCheck(hNoItem)

	for i=0 to hNoItem - 1
		aCheck(i)= Request("cCheck" & i)
		if aCheck(i) = "Y" then aCheck(i) = true
		aHAWB(i)= Request("txtHAWB" & i)
		aNoLabel(i)=Request("txtNoLabel" & i)
		aPiece(i)=Request("txtPiece" & i)
		aFrom(i)=Request("txtFrom" & i)
		aDest(i)=Request("txtDest" & i)
	next
	call get_agent_info()

	mAirLine = ""
	mShipper = ""
	mConsignee = ""
	mTotalPiece = 0
	mWeight = 0

	Set rs = Server.CreateObject("ADODB.Recordset")
	if NOT hMAWB  = "" then
		SQL= "select * from mawb_master where elt_account_number = " & elt_account_number & " and mawb_num='" & hMAWB & "'"
		Set rs = eltConn.execute (SQL)
		if NOT rs.eof and NOT rs.bof then
			mAirLine = rs("by_1")
			if mAirLine = "Select One" then mAirLine = rs("issuedby")
			mShipper = rs("Shipper_Info")
			mConsignee = rs("Consignee_Info")
			mTotalPiece = rs("total_pieces")
			mWeight = rs("total_gross_weight")
		end if
		rs.Close	
	end if

'// by iMoon 04/10/2007 get Carrier Name 
	if NOT hMAWB  = "" then
		DIM prefix_MAWB,pos
		pos = inStr(hMAWB,"-")
		prefix_MAWB = trim(mid(hMAWB,1,pos-1))
		if prefix_MAWB <> "" then
			SQL= "select dba_name from organization where elt_account_number = " & elt_account_number & " and carrier_code='" & prefix_MAWB & "' and isnull(is_carrier,'') = 'Y'"
			Set rs = eltConn.execute (SQL)
			if NOT rs.eof and NOT rs.bof then
				mAirLine = rs("dba_name")
			end if
			rs.Close	
		end if
	end if

	MAWB_P = 0

	if NOT mTotalPiece = "" and isnull(mTotalPiece) = false then
		TOTAL_MAWB_P = mTotalPiece
	else
		TOTAL_MAWB_P = ""
	end if
	
	pCnt = 0

	MAWB_P = StartNo - 1


'	On Error Resume Next:

	response.write "<?xml version=""1.0"" encoding=""utf-8""?>"
	response.write "<labelInfo>"

	for  i=0 to hNoItem - 1
	if aCheck(i) then		
		call print_label_by_pieces( hMAWB, aHAWB(i), cInt(aNoLabel(i)),aPiece(i),aFrom(i),aDest(i), mAirLine , hCnt)
	else
DIM h
		tmpPiece = aPiece(i)
		hCnt = cInt(tmpPiece)
		for  h=0 to hCnt - 1
			if NOT TOTAL_MAWB_P = "" then
				MAWB_P = MAWB_P + 1
			else
				MAWB_P = ""
			end if
		next
	end if

	next

	response.write "</labelInfo>"

end sub
%>
<%
sub get_agent_info
DIM rs,SQL
	SQL= "select dba_name,business_address,business_city,business_state,business_zip,business_country,business_phone,business_fax from agent where elt_account_number = " & elt_account_number
	Set rs = eltConn.execute (SQL)
	If Not rs.EOF Then
		vOrgInfo1=rs("dba_name")
		vOrgInfo2=rs("business_address")
		vOrgInfo2=vOrgInfo2 & chr(13) & rs("business_city") & "," & rs("business_state") & " " & rs("business_zip")
		vOrgInfo2=vOrgInfo2 & chr(13) & rs("business_country")
		vTelFax="Tel: " & rs("business_phone") & "    " & "Fax: " & rs("business_fax")
	End If
	rs.Close
	Set rs = nothing

end sub
%>

<%
sub print_label_by_pieces( hMAWB, tmpHAWB, tmpNoLabel ,tmpPiece , tmpFrom, tmpDest,tmpAirLine, hCnt )
DIM tmpShipper,tmpConsignee,tmpWeight
DIM rs,SQL
if isnull(tmpAirLine) then tmpAirLine = ""

		if NOT tmpHAWB = "" and  isnull(tmpHAWB) = false then
			SQL= "select * from hawb_master where elt_account_number = " & elt_account_number & " and hawb_num='" & tmpHAWB & "'"
			Set rs = eltConn.execute (SQL)
			if NOT rs.eof and NOT rs.bof then
				if trim(tmpAirLine) = "" then
					tmpAirLine = rs("by_1")
				end if
				tmpShipper = rs("Shipper_Info")
				tmpConsignee = rs("Consignee_Info")
				tmpWeight = rs("total_gross_weight")
			end if
			rs.Close	
		else
			tmpShipper = mShipper
			tmpConsignee = mConsignee
			tmpWeight = mWeight
		end if

		TOTAL_HAWB_P = tmpPiece

'	On Error Resume Next:		
		hCnt = cInt(tmpPiece)
		
		HAWB_P = 0

DIM h,j,odd,num
		for  h=0 to hCnt - 1

				if NOT TOTAL_MAWB_P = "" then
					MAWB_P = MAWB_P + 1
				else
					MAWB_P = ""
				end if

				HAWB_P = HAWB_P + 1
				'///////////////////////////////////////
				for  j=0 to tmpNoLabel - 1
					odd = pCnt mod 2
					num = odd + 1
					pCnt = pCnt + 1 'Total Page Count

					if (num = 2) then
						flag = true
					else
						flag = false
					end if
CALL print_label(num,tmpAirLine,tmpFrom,tmpDest,hMAWB,tmpHAWB,MAWB_P,TOTAL_MAWB_P,HAWB_P,TOTAL_HAWB_P,tmpShipper,tmpConsignee,tmpWeight,flag)
				next
				'///////////////////////////////////////

		next

	Set rs = nothing

end sub
%>

<% 
sub print_label(num,tmpAirLine,tmpFrom,tmpDest,hMAWB,tmpHAWB,pMAWB_P,TOTAL_MAWB_P,HAWB_P,TOTAL_HAWB_P,tmpShipper,tmpConsignee,tmpWeight,flag)
	
	response.write "<item>"
	
	call write_xml( "airline", tmpAirLine )
	call write_xml( "MAWB", hMAWB )
	call write_xml( "destination", tmpDest )
	call write_xml( "mawb_piece", pMAWB_P & "/" & TOTAL_MAWB_P )
	call write_xml( "agentName", vOrgInfo1 )
	call write_xml( "origin", tmpFrom )
	call write_xml( "HAWB", tmpHAWB )
	call write_xml( "hawb_piece", HAWB_P & "/" & TOTAL_HAWB_P )
	call write_xml( "HAWB_weight", tmpWeight )
	call write_xml( "shipper", filter_address(tmpShipper) )
	call write_xml( "consignee", filter_address(tmpConsignee) )

'	call write_xml( "agentInfo", vOrgInfo2 )
'	call write_xml( "TeleFax", vTelFax )
'	call write_xml( "mawb_total_piece", TOTAL_MAWB_P )
'	call write_xml( "hawb_total_piece", TOTAL_HAWB_P )
	response.write "</item>"
end sub
%>
<% 
function filter_address(strAddress)
	
	strAddress = replace(strAddress,", ,",",")
	strAddress = replace(strAddress,",,",",")
	strAddress = replace(strAddress,chr(13),"::")
	filter_address = strAddress

end function
%>
<% 
sub write_xml(itemName, itemDesc )
		response.write "<itemcode>"
		response.write itemName
		response.write "</itemcode>"
		response.write "<itemdesc>" 
		response.write encodeXMLCode(itemDesc)
		response.write "</itemdesc>"
end sub
%>

<%
function encodeXMLCode( val )
DIM retVal
retVal = ""
if isnull(val) then
else
	retVal = val
	retVal = Replace(retVal,"&","&amp;") 
	retVal = Replace(retVal,"<","&lt;") 
	retVal = Replace(retVal,">","&gt;") 
end if
encodeXMLCode = retVal
end function
%>