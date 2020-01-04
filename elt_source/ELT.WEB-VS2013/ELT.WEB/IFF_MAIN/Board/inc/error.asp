
<!-- #include file="../inc/dbinfo.asp" -->

<%
	no=request("no")
	h_url=request("h_url")
	Dim debug
	debug=request("debug")

	  
	caseVar = lcase (no)
	Select Case caseVar
		Case 1  msg = "You must login as admin." 'del_ok.asp,institute_ok.asp
				h_url = request("h_url")
		Case 2  msg = "Incorrect password."
		Case 3  msg = "Plese select at least one content."
		Case 4  msg = "You don't have authorization for this job."
				h_url = request("h_url")
		Case 5  msg = "Aready exists."	'join_ok.asp
		Case 6  msg = "Aready exists."	'join_ok.asp
		Case 7  msg = "Aready exists."	'join_ok.asp
		Case 8  msg = "Does not exist."	'tb_form_ok.asp
		Case 9  msg = "Enter a password."	'dext_form_ok.asp
		Case 10 msg = "Your file exceeds the limit size." 'write_ok.asp
		Case 11 msg = "Enter a password" 'write_ok.asp
		Case 12 msg = request("strext")&" can''t be uploaded."
		Case 13 msg = "Horizontal size of image must be under 80 pixels."
		Case 14 msg = "Vertical size of image must be under 18 pixels."
		Case 15 msg = "Board does not exist. \n Please confirm."
				h_url = request("h_url")
		Case 16 msg = "ID does not exist."
		Case 17 msg = "Enter a search condition."
		Case 18 msg = "ID expired."
		Case 19 msg = "Please select ID for mailing."
		Case 44 msg = "Your connection was refused by admin." 
		Case 99 msg = "You authorization using message board is currently not activated.\n Please contact administrator!"
		Case 98 msg = "Test"
	End Select

	if h_url<>"" then
		dim h_url1
		h_url = instr(q_info,"h_url=")
		h_url1 = len(q_info)
		h_url = h_url+5
		h_url = h_url1-h_url
		h_url = right(q_info,h_url)
	end if
%>

<% if debug <> "" then %>
<script language="JavaScript">
	alert("<%=debug%>");
</script>

<% end if %>

<% if h_url <> "" then %>
<script language="JavaScript">
	alert("<%=msg%>");
//	location.href="javascript:history.back()";
	location.href="<%=h_url%>";
</script>
<% else %>
<script language="JavaScript">
	alert("<%=msg%>");
	location.href="javascript:history.back()";
</script>
<% end if %>

