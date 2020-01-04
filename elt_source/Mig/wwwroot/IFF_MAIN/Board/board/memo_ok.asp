<% Option Explicit %>
<% response.buffer = true %>
<% StartTime = Timer() %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->

<%



	dim com_id,num,com_name,com_memo,com_pin,com_ip,writeday,mode,com_mem_auth,com_mem_id,po_write,po_comment
	
	
	h_url = request("h_url")
	
	
	
	num = request("num")
	mode = Request("mode")
	com_mem_id = Request.Form("com_mem_id")
	
	
	call f_member
	if mode = "com_del" then

		dim h_url1
		
		h_url = instr(q_info,"h_url=")
		h_url1 = len(q_info)
		h_url = h_url+5
		h_url = h_url1-h_url
		h_url = right(q_info,h_url)
	
		dim com_sql,com_rs,sql2,com_writeday,form_pin
		
		com_id = Request.QueryString("com_id")
				
		if session_login_name <> "" and Request.QueryString("mem") = "ok" then
			SQL="SELECT com_mem_id,com_pin FROM inno_comment where tb='"&tb&"' and com_num=" & num &" and com_id="& com_id
			Set rs = db.Execute(SQL)
			
			if session_login_name <> rs(0) and session_admin <> admin_name then Response.Redirect "../inc/error.asp?no=4&h_url="&h_url
			form_pin = rs(1)			
		else
			form_pin = Request.Form("form_pin")
		end if
		
		com_SQL = "SELECT com_mem_id FROM inno_comment where tb='"&tb&"' and com_num=" & num & " and com_id="& com_id &" and com_pin='" & form_pin & "'"
	    Set com_rs = db.Execute(com_SQL)
    
		if com_rs.EOF or com_rs.BOF then Response.Redirect "../inc/error.asp?no=2"
		
		if com_rs("com_mem_id") <> "" then
			sql = "select po_comment from member where elt_account_number=" & elt_account_number & "AND id='"&com_rs("com_mem_id")&"'"
			Set rs= db.Execute(sql)
				
			po_comment=rs(0)
			
			if po_comment > 0 then
				SQL = "Update member set po_comment=po_comment-1,point=point-"&c_point&" where elt_account_number=" & elt_account_number & "AND id='"&com_rs(0)&"'"
				db.execute SQL
			end if
		end if 
		
		SQL2 = "DELETE FROM inno_comment where tb='"&tb&"' and com_num=" & num &" and com_id="& com_id
		db.Execute SQL2
		
		
		
		
	else

	com_name = trim(Request.Form("com_name"))
	com_memo = trim(Request.Form("com_memo"))
	com_pin = trim(Request.Form("com_pin"))
	if com_name="" then
%>
<script language="javascript">
location.href="javascript:history.back()";
</script>
<%
	elseif com_pin="" then
%>
<script language="javascript">
location.href="javascript:history.back()";
</script>	
<%
	elseif com_memo="" then
%>
<script language="javascript">
alert("Please enter a comment");
location.href="javascript:history.back()";
</script>
<% else 
%>

<script LANGUAGE="VBScript" RUNAT="Server">

Function CheckWord(CheckValue)

CheckValue = replace(CheckValue, "&" , "&amp;")
CheckValue = replace(CheckValue, "<", "&lt;")
CheckValue = replace(CheckValue, ">", "&gt;")
CheckValue = replace(CheckValue, "'", "''")

CheckWord=CheckValue

End Function

</script>

<%
	SQL="SELECT MAX(com_id) FROM inno_comment where com_num="&num
	Set rs = db.Execute(SQL)
	
	if IsNULL(rs(0)) then
		com_id = 1
	else
		com_id = rs(0)+1
	end if

	rs.close
	Set rs = nothing
	
yy = year(now)
mm = right("0" & month(now),2)
dd = right("0" & day(now),2)
hh = right("0" & hour(now),2)
mi = right("0" & minute(now),2)
se = right("0" & second(now),2)

writeday = yy & "-" & mm & "-" & dd & " " & hh & ":" & mi & ":" & se

	
	com_ip = session_ip
	
	if session_login_name <> "" then
		com_mem_auth = 1
	else
		com_mem_auth = 0
	end if
	 
	SQL = "INSERT INTO inno_comment (com_id,tb,com_num,com_mem_id,com_name,com_pin,com_writeday,com_memo,com_ip,com_mem_auth) VALUES "
	SQL = SQL & "(" & com_id & ""
	SQL = SQL & ",'" & tb & "'"
	SQL = SQL & "," & num & ""
	SQL = SQL & ",'" & com_mem_id & "'"
	SQL = SQL & ",'" & com_name & "'"
	SQL = SQL & ",'" & com_pin & "'"
	SQL = SQL & ",'" & writeday & "'"
	SQL = SQL & ",'" & com_memo & "'"
	SQL = SQL & ",'" & com_ip & "'"
	SQL = SQL & "," & com_mem_auth & ")"
		
	db.Execute SQL
	
	if session_login_name <> "" then
		SQL = "Update member set po_comment=po_comment+1,point=point+"&c_point&" where id='"&session_uid&"'"
		db.execute SQL
	end if 
	
	
%>


<% end if %><% end if %>

<% Response.Redirect h_url %>