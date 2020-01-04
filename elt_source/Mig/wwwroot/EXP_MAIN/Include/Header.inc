<%
    Response.Expires = 0  
    Response.AddHeader "Pragma","no-cache"  
    Response.AddHeader "Cache-Control","no-cache,must-revalidate"  

    '// Cookies ///////////////////////////////////////////////////////////////////
    
    Dim elt_account_number,login_name,user_id,ClientOS,session_ip,session_IntIp
    Dim session_server_name,session_user_lname,redPage,user_email
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	user_id = Request.Cookies("CurrentUserInfo")("user_id")
	ClientOS = Request.Cookies("CurrentUserInfo")("ClientOS")
	session_ip = Request.Cookies("CurrentUserInfo")("IP")
	session_IntIp = Request.Cookies("CurrentUserInfo")("intIP")
	session_server_name = Request.Cookies("CurrentUserInfo")("Server_Name")
	session_user_lname = Request.Cookies("CurrentUserInfo")("lname")
	redPage = Request.Cookies("CurrentUserInfo")("ORIGINPAGE")
	user_email = Request.Cookies("CurrentUserInfo")("user_email")
	
	'////////////////////////////////////////////////////////////////////////////////
	
	Dim vWindowName
	vWindowName = Request.QueryString("WindowName")
	If vWindowName <> "" Then
	    Response.Write("<script>window.name='" & vWindowName & "';</script>")
	End If
	
	Call SESSION_VALID

    Sub CHECK_COOKIES
        If elt_account_number = "" Then
        %>
            <script type="text/jscript" language="javascript">
                alert('Your session was expired or disconnected! Error Code - 0006');
                self.close();
                top.location.replace('/EXP_MAIN/Default.aspx');  
            </script>
        <%
            eltConn.Close()
            Set eltConn = Nothing
        End If
    End Sub
    
    Sub SESSION_VALID
        '// On Error Resume Next:

        Dim SQL_SESSION,rs_session,another_user,errMsg,another_ip

	    SQL_SESSION = "SELECT * FROM view_login where elt_account_number=" _
	        & elt_account_number & " AND ip='" & session_ip & "'" & " AND server_name='" _
	        & session_server_name & "'"

	    Set rs_session = eltConn.execute (SQL_SESSION)

	    If Not (rs_session.eof Or rs_session.bof) Then 
	    Else
		    rs_session.close
		    SQL_SESSION = "SELECT * FROM view_login where elt_account_number=" _
		        & elt_account_number & " AND user_id='" & session_uid & "'"
		    Set rs_session = eltConn.execute (SQL_SESSION)

		    if (rs_session.eof or rs_session.bof) Then  
		    %>
			    <script type="text/jscript" language="javascript">
                    alert('Your session was expired or disconnected! Error Code - 0007');
                    self.close();
                    top.location.replace('/EXP_MAIN/Default.aspx');  
                </script>
		    <%
		    else
		        another_user = rs_session("server_name")
		        another_ip = rs_session("intIP")
		        errMsg = "Your session was disconnected by another computer! Error Code - 0008\n (" & another_user & ":" & another_ip & ")"
		    %>
  			    <script type="text/jscript" language="javascript">
                    alert('<%=errMsg%>');
                    self.close();
                    top.location.replace('/EXP_MAIN/Default.aspx');  
                </script>
		    <%
		    End If
		    eltConn.Close()
            Set eltConn = Nothing
	    End If
        
    End SUB
 %>
 
 