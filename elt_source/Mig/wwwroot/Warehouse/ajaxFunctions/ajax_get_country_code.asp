<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/AspFunctions.inc" -->

<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>

<%
	if not check_url("IFF_MAIN") then 
		response.write "e"
		response.end
	end if
%>

<%
DIM code_type,elt_account_number,login_name,UserRight

elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
login_name = Request.Cookies("CurrentUserInfo")("login_name")
UserRight = Request.Cookies("CurrentUserInfo")("user_right")	

' On error Resume Next :
 call gather_list_all()

%>

<% 
sub gather_list_all()
DIM rs,SQL,code,codeText

response.write " <option></option><br>"

SQL = "select country_code, substring(country_name,0,40) as country_name from country_code where elt_account_number="&elt_account_number&" order by country_name" 
Set rs = eltConn.execute(SQL)

'On Error Resume Next:
response.write " <option value='_edit'>Edit List...</option>"
Do While Not rs.EOF and NOT rs.bof
	code = rs("country_code").value
	codeText = rs("country_name").value
	response.write " <option value='" & code & "'>" & codeText & "</option><br>"
	rs.MoveNext
Loop
end sub
%>

