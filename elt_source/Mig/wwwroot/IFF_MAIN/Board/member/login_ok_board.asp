<% Option Explicit %>
<% response.buffer = true %>

 

<% dim sql,rs %>

<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/joint.asp" -->

<%

	call view_login	

	dim num,join_id,join_pin,url,point,updatesql
	
	h_url = Request("h_url")

	join_id = session_uid
	
	call f_member
	SQL = "Select * From member Where elt_account_number=" & elt_account_number & " AND id ='"& join_id &"'"
	Set rs = db.Execute(SQL)
	if rs.eof or rs.bof then 

		call insert_gwms_user(join_id,session_login_name,"-1")	
		
		SQL = "Select * From member Where elt_account_number=" & elt_account_number & "AND id ='"& join_id &"'"
		Set rs = db.Execute(SQL)	
	Else
		If (Not rs("email") = session_email) Or (Not rs("name") = session_login_name) Or (Not rs("jumin") = session_company) Or (Not rs("nickname") = session_lname) Then
			SQL = "UPDATE member set email='" & session_email & "' " & ", name='" & session_login_name & "', jumin='" & session_company & "' "  & ", nickname='" & session_lname & "' " & " Where elt_account_number=" & elt_account_number & "AND id ='"& join_id &"'"
			Set rs = db.Execute(SQL)	
			SQL = "Select * From member Where elt_account_number=" & elt_account_number & "AND id ='"& join_id &"'"
			Set rs = db.Execute(SQL)	
		End if
	End if

%>

<% 

 Sub insert_gwms_user(id,name,pin)
	dim sql_tmp,rs_sub
	Dim num,authority,user_level,b_admin

'	sql_tmp="SELECT MAX(num) FROM member WHERE elt_account_number=" & elt_account_number 
	sql_tmp="SELECT MAX(num) FROM member"
	Set rs_sub = db.Execute(sql_tmp)

	if IsNULL(rs_sub(0)) then
		num = 1
	else
		num = rs_sub(0)+1
	end if

	b_admin=""
	
	authority = 9
	
	if id="admin" then
		authority = 1
	end if

		sql_tmp = "INSERT INTO member (num,elt_account_number,id,pin,name,email,url,jumin,nickname,msg_tool,msg_id,birthday,zipcode,address,tel,phone,hobby,job,introduce,mailling,info_open,join_day,term_day,authority,user_level,o_nickname,o_email,o_url,o_msg,o_birthday,o_address,o_tel,o_phone,o_hobby,o_job,o_introduce,po_write,po_comment,point,name_img,b_admin) VALUES(" & num 
		sql_tmp = sql_tmp & ",'"&elt_account_number&"','"&session_uid&"','-1','"&session_login_name&"','"&session_email&"','','"&session_company&"','"&session_lname&"','','','','','','','','','','','',1,getdate(),'','',9,0,1,1,1,1,1,1,1,1,1,1,1,1,'','','' "
		sql_tmp = sql_tmp & ")"

		db.Execute sql_tmp
		
'		sql_tmp = "UPDATE member set elt_account_number ='" & elt_account_number & "',id = '" & session_uid & "'," & " name = '" & session_login_name & "'," & "pin = '" & pin & "', join_day= getdate()" & ",email='" & session_email & "', jumin='" & session_company & "' "  & ", nickname='" & session_lname & "' where num=" & num		

'		db.Execute sql_tmp
 End Sub
 %>


