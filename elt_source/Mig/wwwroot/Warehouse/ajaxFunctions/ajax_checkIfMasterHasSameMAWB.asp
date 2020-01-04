<!--  #INCLUDE FILE="../include/transaction.txt" -->
<!--  #INCLUDE FILE="../include/connection.asp" -->

<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate" 
 
dim rs,vMAWB,HAWB,MAWB,SQL
HAWB=request.QueryString("HAWB")
MAWB=request.QueryString("MAWB")
AO=request.QueryString("AO")
set rs= Server.CreateObject("ADODB.Recordset")
 elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")


SQL= "select mawb_num from hawb_master  where (elt_account_number= "
SQL= SQL& elt_account_number & " or coloder_elt_acct="
SQL= SQL& elt_account_number & ") and is_master='Y' and hawb_num='"& HAWB & "'"

if AO="O" then
    SQL= "select booking_num from hbol_master  where (elt_account_number= "
    SQL= SQL& elt_account_number & " or coloder_elt_acct="
    SQL= SQL& elt_account_number & ") and is_master='Y' and hbol_num='"& HAWB & "'"
end if 
 	
rs.Open SQL, eltConn, adOpenStatic, , adCmdText



If Not rs.EOF Then
	
	if AO="O" then
		vMAWB=rs("booking_num")
	else 
	vMAWB=rs("mawb_num")
	end if 
	
	if  TRIM(vMAWB)=TRIM(MAWB) then 
		response.Write("Y"&":"&vMAWB)
	else
		response.Write("N"&":"&vMAWB)
	end if 
ELSE
		response.Write("N"&":"&SQL)
End If

rs.close
	
set rs=nothing 

response.End()



%>