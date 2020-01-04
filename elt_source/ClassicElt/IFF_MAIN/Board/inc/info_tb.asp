<%
	'Call SESSION_VALID
	dim tb,tb_name,board_type,gallery_type,upload_type,upload_form,content_type,maxsize,board_size,bgcolor,tb_bgcolor,tr_chcolor,board_title,top_file,top_board,bottom_board,down_file,use_smtp,use_reco,use_cookies
	dim pagesize,block,len_title,new_title,nt_img,nt_tr,nt_color,view_reco,view_upload,view_img,view_multi
	dim relation,view_ip,use_comment
	dim l_level,r_level,w_level,cw_level,nw_level,rw_level
	dim admin_name,sql,rs,starttime
	
	'관리자 아이디 입력부분
	admin_name="admin"
	
	On Error resume next
	tb=Request("tb")
	
	if tb="" then tb = Request("tb")
	
	if db.Errors.Count > 0 then
	tb=bbs("tb")
	
	if tb="" then tb = bbs("tb")
	end if
	
	if tb="" then tb = session("tb")		
	
	if tb="admin" then '### admin 모드로 들어갈때는 검색 안함.
		dim c_sql,c_rs
		c_SQL = "SELECT tb FROM inno_admin where tb='"&tb&"'"
		Set c_rs = db.Execute(c_SQL)
		
		if c_rs.BOF or c_rs.EOF then
			response.Redirect "../inc/error.asp?no=15"
		end if
	end if		
		
	'### 자동로그인을 위한 부분
'	if request.Cookies("a_login")("auto_login") = 1 and session_login_name = "" then
'		response.Redirect "../member/login_ok.asp?join_id="&request.Cookies("a_login")("id")&"&join_pin="&request.Cookies("a_login")("pin")&"&auto_login=1&h_url="&h_url
'	end if
	'### 자동로그인을 위한 부분 끝
	
			
	SQL = "Select * From inno_admin Where tb='"&tb&"'"
	Set rs = db.Execute(SQL)
	
	if rs.BOF or rs.EOF then
		
	else
	
	tb_name = rs("tb_name")
	board_type = rs("board_type")
	gallery_type = rs("gallery_type")
	upload_type = rs("upload_type")
	upload_form = rs("upload_form")
	content_type = rs("content_type")
	maxsize = rs("maxsize")
	board_size = rs("board_size")
	bgcolor = rs("bgcolor")
	tb_bgcolor = rs("tb_bgcolor")
	tr_chcolor = rs("tr_chcolor")
	board_title = rs("board_title")
	top_file = rs("top_file")
	top_board = rs("top_board")
	top_board = replace(top_board, "&quot;","'")
	bottom_board = rs("bottom_board")
	bottom_board = replace(bottom_board, "&quot;","'")
	down_file = rs("down_file")
	use_smtp = rs("use_smtp")
	use_reco = rs("use_reco")
	use_cookies = rs("use_cookies")

	pagesize = rs("pagesize")
	block = rs("block")
	len_title = rs("len_title")
	new_title = rs("new_title")
	nt_img = rs("nt_img")
	nt_tr = rs("nt_tr")
	nt_color = rs("nt_color")
	view_reco = rs("view_reco")
	view_upload = rs("view_upload")
	view_img = rs("view_img")
	view_multi = rs("view_multi")

	relation = rs("relation")
	view_ip = rs("view_ip")
	use_comment = rs("use_comment")
	
	l_level = rs("l_level")
	r_level = rs("r_level")
	w_level = rs("w_level")
	cw_level = rs("cw_level")
	nw_level = rs("nw_level")
	rw_level = rs("rw_level")
	
%>


<% '###################################################################################################################################
	dim sql_info,rs_info
	SQL_info = "SELECT * FROM view_login where elt_account_number=" & elt_account_number& " AND logout=1 and ip='"&session_ip&"'" & " AND server_name='" & 	session_server_name & "'"

	Set rs_info = eltConn.execute (SQL_info)

	if not (rs_info.eof or rs_info.bof) then 
		
	SQL_info = "Update view_login Set logout = 0, alive = 0 where elt_account_number=" & elt_account_number& " AND logout=1 and ip='"&session_ip&"'"
	eltConn.Execute SQL_info		
		%>
		<script language="JavaScript">
			alert("Another user is using your ID.");
			
		<%	if redPage = "" then %>
				top.location.replace('/freighteasy/index.aspx');
		<%	else %>
				top.location.replace('<%=redPage%>');
		<%	end if %>

		</script>
		<% 
	end if
 '###################################################################################################################################
 %>
 

 <%
	'###################################################################################################################################
	if session_login_name <> "" then 
		dim user_level,sql_level,rs_level
		SQL_level = "SELECT user_level,name FROM member where elt_account_number=" & elt_account_number & " AND id='"&session_uid&"'"		'### 현재 아이디의 레벨을 가져온다.
		Set rs_level = db.execute (SQL_level)
				
			
		user_level=rs_level(0)
			
		rs_level.close
		set rs_level=nothing
	else
		user_level=10
	
	end if
	
	'###################################################################################################################################
 
 	end if
 %>
 
 <%
Sub SESSION_VALID
Dim SQL_SESSION,rs_session,another_user

	SQL_SESSION = "SELECT * FROM view_login where elt_account_number="&elt_account_number&" AND ip='"&session_ip&"'" & " AND server_name='" & 	session_server_name & "'"
	Set rs_session = eltConn.execute (SQL_SESSION)

	if not (rs_session.eof or rs_session.bof) Then 
		If (rs_session("user_name") = "invalid") then
			SQL_SESSION = "DELETE view_login where elt_account_number="&elt_account_number&" AND ip='"&session_ip&"'"& " AND server_name='" & 	session_server_name & "'"
			eltConn.execute (SQL_SESSION)
	
			SQL_SESSION = "SELECT * FROM view_login where elt_account_number="&elt_account_number&" AND user_id="&session_uid
			rs_session.close
			Set rs_session = eltConn.execute (SQL_SESSION)
			if not (rs_session.eof or rs_session.bof) Then  another_user = rs_session("ip")
			%><script language="javascript">
				alert("Your session was disconnected by another user! ("+"<%=another_user%>" +")" );
				self.close();
			<%  if redPage = "" then %>
				top.location.replace('/freighteasy/index.aspx');  
			<% else %>
				top.location.replace('<%=redPage%>');			
			<% end if %>
			 </script>
			<%
			response.End()			
		Else
			SQL_SESSION = "SELECT * FROM view_login where elt_account_number="&elt_account_number&" AND user_id='"&session_uid&"'"
			rs_session.close
			Set rs_session = eltConn.execute (SQL_SESSION)
			if (rs_session.eof or rs_session.bof) Then  
			%><script language="javascript">
				alert("You can`t use different user ID in one Session." );
				self.close();
			<%  if redPage = "" then %>
				top.location.replace('/freighteasy/index.aspx');  
			<% else %>
				top.location.replace('<%=redPage%>');			
			<% end if %>
			 </script>
			<%
			Else
				If auto_update_view_login then	
					session_login_name = rs_session("login_name")
					session_lname = rs_session("user_lname") & "," & rs_session("user_fname")
					If session_lname = "," Then session_lname = ""
					session_email = rs_session("user_email")

			SQL_SESSION = "Update view_login Set alive = 1, u_time='"&now&"' where elt_account_number="&elt_account_number& " AND ip='"&session_ip&"'" 
					eltConn.Execute SQL_SESSION
				End if
			End if

		End if
	Else
		%><script language="javascript">
			alert('cYour session was expired or disconnected!');
			self.close();
			<%  if redPage = "" then %>
				top.location.replace('/freighteasy/index.aspx');  
			<% else %>
				top.location.replace('<%=redPage%>');			
			<% end if %>
  		 </script>
		<%
		response.End()			
	End If

	rs_session.close
	set rs_session = nothing
	
End SUB
%>

 <!-- #include file="../statistics/statistics_process.asp" -->
