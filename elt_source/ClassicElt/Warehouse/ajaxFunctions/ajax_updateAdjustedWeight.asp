<!--  #INCLUDE FILE="../include/transaction.txt" -->
<!--  #INCLUDE FILE="../include/connection.asp" -->

<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate" 
 
dim rs,vMAWB,HAWB,MAWB,SQL,AWeight

HAWB=request.QueryString("HAWB")
MAWB=request.QueryString("MAWB")
AWeight=request.QueryString("AWeight")
AO=request.QueryString("AO")
tran_no=request.QueryString("tran_no")

elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")


SQL= "UPDATE hawb_weight_charge set Adjusted_Weight="&AWeight&" where (elt_account_number= "
SQL= SQL& elt_account_number & ") and hawb_num='"& HAWB & "'"

SQL= SQL& " and tran_no='"& tran_no & "'"

if AO="O" then
    SQL= "UPDATE  hbol_master set measurement="&AWeight&" where (elt_account_number= " 
    SQL= SQL& elt_account_number & ") and  hbol_num='"& HAWB & "'"	
end if 

on error resume next
 	eltConn.Execute(SQL)
 
if eltConn.Errors.Count <> 0 then
	response.write("Fail")	
	'response.write(SQL)
else 
	response.write("Success")
	'response.write(SQL)
end if 	


response.End()



%>