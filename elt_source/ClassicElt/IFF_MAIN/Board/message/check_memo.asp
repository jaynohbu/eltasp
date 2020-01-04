<!-- #include virtual="/IFF_MAIN/Board/inc/dbinfo.asp" -->
<%
'Call SESSION_VALID
%>
<!-- #include virtual="/IFF_MAIN/Board/inc/info_tb_board.asp" -->
<!-- #include virtual="/IFF_MAIN/Board/inc/joint.asp" -->

<Script Language="javascript">
<!--

function OpenWindow(url,intWidth,intHeight) { 
      window.open(url, "msg", "width="+intWidth+",height="+intHeight+",resizable=0,scrollbars=1");
}

//-->
</Script>

<%
	SQL1 = "SELECT m_read FROM message where (m_box like '0') and (m_read like '0') AND  r_id='"&session_uid&"'"
	Set rs1 = db.execute (SQL1)
			
			
	if rs1.eof or rs1.bof then
		check_read="off"
	else
		check_read="on"
		%>
			<script language="javascript">
//				alert("You've got message.");
			</script>
		<%
	end if
		
	rs1.close
	set rs1=nothing
%>

<%
Sub SESSION_VALID
Dim SQL_SESSION,rs_session,another_user,elt_User_id

elt_User_id = elt_account_number & user_id

	SQL_SESSION = "SELECT * FROM view_login where elt_account_number=" & elt_account_number _
	    & " AND ip='" & session_ip & "'" & " AND server_name='" & session_server_name & "'"

	Set rs_session = eltConn.execute (SQL_SESSION)

	if not (rs_session.eof or rs_session.bof) Then 
	Else
		%><script type="text/javascript" language="javascript">
			alert('dYour session was expired or disconnected!');
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

<!--
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" WIDTH="11" HEIGHT="15" id="arr_memo_<%=check_read%>" ALIGN="" VIEWASTEXT>
 <PARAM NAME=movie VALUE="../inc/arr_memo_<%=check_read%>.swf"> <PARAM NAME=quality VALUE=high> <PARAM NAME=wmode VALUE=transparent> <PARAM NAME=bgcolor VALUE=#FFFFFF> <EMBED src="../inc/arr_memo_<%=check_read%>.swf" quality=high wmode=transparent bgcolor=#FFFFFF  WIDTH="11" HEIGHT="15" NAME="arr_memo_<%=check_read%>" ALIGN="" TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer"></EMBED>
</OBJECT>
-->

<img id="img_memo_<%=check_read%>" src="../img/but_mem_msg_<%=check_read%>.gif" border="0">
<% session("msg")="" %>
<% 'end if %>