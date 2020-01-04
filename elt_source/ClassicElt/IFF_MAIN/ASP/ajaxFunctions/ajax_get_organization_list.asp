<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->

<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  

DIM biz_type,elt_account_number,login_name,UserRight

' On error Resume Next :
biz_type = Request.QueryString("t")
elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
login_name = Request.Cookies("CurrentUserInfo")("login_name")
UserRight = Request.Cookies("CurrentUserInfo")("user_right")	

if isnull(biz_type) or biz_type = "" then
	response.write "e"
else
	call gather_list( biz_type )
end if

eltConn.Close
Set eltConn = Nothing

sub gather_list( sType )

		select case sType
			case "Shipper" 
			case "Consignee" 
			case "Notify" 
			case "Agent" 
			case "Customer" 
			case "Vendor" 
			case "colodee_elt_acct_name" 
				call gather_list_colo()
			case "defaultBrokerName" 
				call gather_list_broker()
		end select

end sub
%>

<%
sub gather_list_colo()
DIM rs,SQL,i
Dim account_text,name_text

response.write " <option></option><br>"

SQL = "select * from colo where coloder_elt_acct = " & elt_account_number & " order by colodee_name"
Set rs = eltConn.execute(SQL)

'On Error Resume Next:
Do While Not rs.EOF and NOT rs.bof
	account_text = rs("colodee_elt_acct").value
	name_text = rs("colodee_name").value
	response.write " <option value='" & account_text & "'>" & name_text & "</option><br>"
	rs.MoveNext
Loop

end sub
%>
<% 
sub gather_list_broker()
DIM rs,SQL,i
Dim account_text,name_text,info_text

response.write " <option></option><br>"

SQL = "select org_account_number,dba_name,isnull(business_address,'') as business_address,isnull(business_city,'') as business_city,isnull(business_State,'') as business_State,isnull(business_zip,'') as business_zip,isnull(business_Country,'') as business_Country,isnull(business_phone,'') as business_phone,isnull(business_fax,'') as business_fax from organization where elt_account_number = " & elt_account_number & " AND account_status='A' AND isnull(z_is_broker,'') = 'Y' order by dba_name"
Set rs = eltConn.execute(SQL)

'On Error Resume Next:
Do While Not rs.EOF and NOT rs.bof
	account_text = rs("org_account_number").value
	name_text = rs("dba_name").value
	info_text = rs("org_account_number").value & "-" & rs("dba_name").value _
		& chr(10) & rs("business_address").value & chr(10) & rs("business_city").value _
		& "," & rs("business_State").value & " " & rs("business_Zip").value _
		& "," & rs("business_Country").value & chr(10) & "Tel:" & rs("business_phone").value _
		& " " & "Fax:" & rs("business_fax").value
	name_text = replace(name_text,",,","")	
	response.write " <option value='" & info_text & "'>" & name_text & "</option><br>"
	rs.MoveNext
Loop

end sub
%>