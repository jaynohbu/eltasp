<!--  #INCLUDE FILE="../include/transaction.txt" -->
<!--  #INCLUDE FILE="../include/connection.asp" -->

<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate" 
dim HAWBS(50),hIndex

vAirOrgNum=request("vAirOrgNum")
vOriginPortID=request("vOriginPortID") 
vDepartureAirport=request("vDepartureAirport") 
vTo=request("vTo") 
vBy=request("vBy") 
vTo1=request("vTo1") 
vBy1=request("vBy1")
vTo2=request("vTo2")
vBy2=request("vBy2") 
vDestAirport=request("vDestAirport")
vFlightDate1=request("vFlightDate1") 
vFlightDate2=request("vFlightDate2")
vExportDate=request("vExportDate")
vDestCountry=request("vDestCountry")
vDepartureState=request("vDepartureState")
vIssuedBy=request("vIssuedBy")
vExecute=request("vExecute")
vHAWB=request("vHAWB")
vMAWB=request("vMAWB")
vMAWB=replace(vMAWB,":"," ")

vBookingNum=request("vBookingNum") 
response.Write(vBookingNum)
response.End()

set rs= Server.CreateObject("ADODB.Recordset")
 elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")


SQL= "select hawb_num as hb from hawb_master  where (elt_account_number= "
SQL= SQL& elt_account_number & " or coloder_elt_acct="
SQL= SQL& elt_account_number & ") and is_sub='Y' and sub_to_no='"& vHAWB & "'"

if AO="O" then
    SQL= "select hbol_num as hb from hbol_master  where (elt_account_number= "
    SQL= SQL& elt_account_number & " or coloder_elt_acct="
    SQL= SQL& elt_account_number & ") and is_sub='Y' and sub_to_no='"& vHAWB & "'"
end if 
 	


rs.Open SQL, eltConn, adOpenStatic, , adCmdText

If Not rs.EOF Then
    hIndex=0
	
	Do While Not rs.EOF
		HAWBS(hIndex)=rs("hb")
		hIndex=hIndex+1
		rs.MoveNext		
	Loop
	
ELSE
		response.Write("No Record")
End If

rs.close



For i =0 to hIndex -1

	SQL= "select * from hawb_master  where (elt_account_number= "
	SQL= SQL& elt_account_number & " or coloder_elt_acct="
	SQL= SQL& elt_account_number & ") and is_sub='Y' and hawb_num='"& HAWBS(i) & "'"
	
	if AO="O" then
		SQL= "select * from hbol_master  where (elt_account_number= "
		SQL= SQL& elt_account_number & " or coloder_elt_acct="
		SQL= SQL& elt_account_number & ") and is_sub='Y' and hbol_num='"& HAWBS(i) & "'"
	end if 
		
	'response.Write(SQL)
	
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	if not rs.EOF then
		rs("mawb_num")=vMAWB
		rs("airline_vendor_num")=vAirOrgNum
		rs("DEP_AIRPORT_CODE") = vOriginPortID
		rs("Departure_Airport") = vDepartureAirport
		rs("To_1") = vTo
		rs("by_1") = vBy 
		rs("To_2") = vTo1
		rs("By_2") = vBy1
		rs("To_3") = vTo2
		rs("By_3") = vBy2
		rs("Dest_Airport") = vDestAirport
		rs("Flight_Date_1") = vFlightDate1
		rs("Flight_Date_2") = vFlightDate2
		rs("export_date")=vExportDate
		rs("dest_country")=vDestCountry
		rs("departure_state")=vDepartureState
		rs("IssuedBy")=vIssuedBy   
		rs("Execution")=vExecute
		rs.Update
	end if 
	if i=(hIndex-1)then
		if rs.status = 0 then
			response.Write("Success")
		else 
			response.Write("Fail")
		end if 
	end if 
	rs.close
next

set rs=nothing 

response.End()



%>