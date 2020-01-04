<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>

<!-- #include virtual="/IFF_MAIN/Board/inc/dbinfo.asp" -->
<%
'Call SESSION_VALID
%>
<!-- #include virtual="/IFF_MAIN/Board/inc/info_tb_board.asp" -->
<!-- #include virtual="/IFF_MAIN/Board/inc/joint.asp" -->


<%
	SQL1 = "SELECT m_read FROM message where (m_box like '0') and (m_read like '0') AND  r_id='" & session_uid & "'"
	Set rs1 = db.execute (SQL1)
			
			
	if rs1.eof or rs1.bof then
		check_read="off"
	else
		check_read="on"
	end if
		
	rs1.close
	set rs1=nothing
	
	eltConn.Close()
	Set eltConn = Nothing
%>

<%
Sub SESSION_VALID

On Error Resume Next:
Dim SQL_SESSION,rs_session,another_user,errMsg,another_ip

	SQL_SESSION = "SELECT * FROM view_login where elt_account_number=" & elt_account_number _
	    & " AND ip LIKE '" & Mid(session_ip,1,InStr(1,session_ip,":")) & "%' AND server_name='" & session_server_name & "'"

	Set rs_session = eltConn.execute (SQL_SESSION)

	If Not (rs_session.EOF Or rs_session.BOF) Then 
	Else
		rs_session.close
		SQL_SESSION = "SELECT * FROM view_login where elt_account_number=" & elt_account_number _
		    & " AND user_id='" & session_uid & "'"
		Set rs_session = eltConn.execute (SQL_SESSION)

		If (rs_session.eof or rs_session.bof) Then  
		%>
			 <script type="text/javascript" language="javascript">
				alert('Your session was expired or disconnected!');
				self.close();
			<%  If redPage = "" Then %>
				top.location.replace('/freighteasy/index.aspx');  
			<% Else %>
				top.location.replace('<%=redPage%>');			
			<% End If %>
			 </script>
		<%
		else
		another_user = rs_session("server_name")
		another_ip = rs_session("intIP")
		errMsg = "Your session was disconnected by another computer! \n (" & another_user & ":" & another_ip & ")"
		
		%>
			<script type="text/javascript" language="javascript">
			alert("<%=errMsg%>");
			self.close();
			<%  If redPage = "" Then %>
				top.location.replace('/freighteasy/index.aspx');  
			<% Else %>
				top.location.replace('<%=redPage%>');			
			<% End If %>
  			</script>
		<%
		End If
		rs_session.Close()
		Set rs_session = Nothing
		eltConn.Close()
	    Set eltConn = Nothing
		response.End()			
	End If

	rs_session.Close()
	Set rs_session = Nothing

End SUB
%>

<img name="icon_messgae" id="img_memo_<%=check_read%>" alt="" src="/IFF_MAIN/Board/img/but_top_mem_msg_<%=check_read%>.gif" border="0" onclick="javascript:OpenWindow('/IFF_MAIN/BOARD/message/m_list.asp?com=yes&m_box=0&id=<%=session_uid%>','400','400')" style="cursor:hand" />
<img src="/IFF_MAIN/Images/icon_readmessage.gif" name="rollover" alt="" width="203" height="31" border="0" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('icon_messgae','','/IFF_MAIN/Board/img/but_top_mem_msg_over.gif','rollover','','/IFF_MAIN/Images/icon_readmessage_over.gif',1)" onclick="javascript:OpenWindow('/IFF_MAIN/BOARD/message/m_list.asp?com=yes&m_box=0&id=<%=session_uid%>','400','400')" style="cursor:hand" />
<% session("msg")="" %>

