<% 'Option Explicit %>
<% response.buffer = true %>
<% Response.Expires=-1 %>


 



<!-- #include file="../inc/dbinfo.asp" -->



<%
	dim mode
	mode = Request.QueryString("mode")
	sw = Request.QueryString("sw")
	
%>

<%	'### 현재 이것은 무용지물~~~ 없어도 되는 부분~~~
	if mode="admin" then
		
		dim board_admin,admin
		
		board_admin = Request.Form("board_admin")
		id = Request.QueryString("id")
		
		SQL = "SELECT admin FROM inno_admin where tb='"&board_admin&"'"
		Set rs = db.execute (SQL)
		
		admin = rs("admin")&id&chr(44)
		
		SQL = "Update inno_admin set admin = '" & admin & "'"
		SQL = SQL & " where tb = '"&board_admin&"'"
		db.Execute SQL
		
		Response.Redirect "user_edit.asp?id="&id
		
	end if
%>



<%
	if mode="cart" then		'### 회원 레벨 변경일때.. 하지만 포인트별로 자동 레벨로 인해 이것도 무용지물~
	
	cart_num = Request.Form("cart").count
	i_level = Request.Form("i_level")
	
	i=1
	Do until i > cart_num
	id = Request.Form("cart")(i)
	
	SQL = "Update member set user_level="&i_level&" where id = '"&id&"'"
	db.execute SQL

	i=i+1
	loop
	
	if sw <> "" then
		Response.Redirect "user_list.asp?pagesize="&Request.QueryString("pagesize")&"&sw="&sw&"&ss="&Request.QueryString("ss")
	else
		Response.Redirect "user_list.asp?pagesize="&Request.QueryString("pagesize")
	end if
	
	end if
	
%>

<%
	if mode="del" then '#### 회원 탈퇴 일때~~ ###########
		if Request.QueryString("sel") > 0 then
			cart_num = 1
		else	
			cart_num = Request.Form("cart").count
		end if
		
	i=1
	Do until i > cart_num
	
	if Request.QueryString("sel") > 0 then
		id=Request.form("id")
	else	
		id = Request.Form("cart")(i)
	end if
	
	
	'### 현재 아이디를 멤버 테이블에서 삭제한다.
	SQL = "DELETE FROM member where elt_account_number=" & elt_account_number & " AND id='"&id&"'"
'response.write SQL
	db.Execute SQL

	
	'### 현재 아이디의 쪽지를 보관함에서 삭제한다.
	SQL = "DELETE FROM message where elt_account_number="&elt_account_number&" AND r_id='"&id&"'"
	db.Execute SQL
	
	
	'### 현재 아이디의 이미지네임 파일을 삭제한다.
	filename1 = Server.MapPath("..")&"\files\img_name\" & id & ".gif"
	
	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	if fso.fileExists(filename1) then
		Set fs = Server.CreateObject("Scripting.FileSystemObject")
			filename1 = Server.MapPath("..")&"\files\img_name\" & id & ".gif"
			If fs.FileExists(filename1) then
				fs.DeleteFile(filename1)
			End if
		set fs = Nothing
	end if
		
	
	i=i+1
	loop
	
	if request("style") = "del" then

	if session_login_name <> "admin" then
'		session_login_name = ""
'		session_pin = ""
'		session_login_name = ""
'		session_email = ""
'		session_url = ""
'		session_level = 10
'		session_admin = ""
	end if 
	
	
%>
<script language=javascript>
	alert("회원탈퇴가 되었습니다.");
	window.opener.location = '../board/list.asp?tb=<%=Request.QueryString("tb")%>';
	self.close();	
</script>
<%
	else
	
	if sw <> "" then
		Response.Redirect "user_list.asp?pagesize="&Request.QueryString("pagesize")&"&sw="&sw&"&ss="&Request.QueryString("ss")
	else
		Response.Redirect "user_list.asp?pagesize="&Request.QueryString("pagesize")
	end if
	
	end if 	

	end if
	
%>


<%

  'Rs.close
  db.close
  'Set Rs = Nothing
  Set db = Nothing
%>
