<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>New/Edit HBOL</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
<!--  #INCLUDE FILE="../include/connection.asp" -->
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->

<%
qClose=Request.QueryString("Close")

if qClose = "yes" then

	vHBOL = session("HBOL_NUM")
	
	if not session("HBOL_CLOSE") = "OK" then
		CALL DELETE_TEMP_HAWB( vHBOL )
		%>
			<script type="text/jscript">
				window.close();
			</script>			
		<%		
	end if
	
end if

'///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'//////////////////// SUB ROUTINES /////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SUB DELETE_TEMP_HAWB( saved_HAWB_NUM )
	SQL= "delete hbol_master where elt_account_number = " & elt_account_number _
	    & " AND hbol_num=N'" & saved_HAWB_NUM & "' and CAST(Agent_Info AS VARCHAR)='Auto Generated No.'"	
	eltConn.Execute SQL	
END SUB
%>

</html>