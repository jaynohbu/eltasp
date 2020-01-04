<!--  #INCLUDE FILE="../include/transaction.txt" -->
<!--  #INCLUDE FILE="../include/connection.asp" -->
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>
<%



dim elt_account_number 
    elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")  

SQL=""
Dim rs
    
SQL="select dba_name,business_address,business_city,business_state,business_zip,business_country,business_phone,business_fax from agent where elt_account_number=" & elt_account_number   

Set rs = eltConn.execute(SQL)

if Not rs.EOF and NOT rs.bof then
	response.Write rs("dba_name")&"^^^"&rs("dba_name")&chr(13)&rs("business_address")&chr(13)&rs("business_state")&rs("business_zip")&chr(13)&"FAX:"&rs("business_fax")&" TEL:"&rs("business_fax")
   'response.Write SQL
	response.End
	
else 
	 response.Write "False^^^"&""
   ' response.Write SQL
	response.End
end if 
	
rs.close
Set rs=Nothing
 %>
