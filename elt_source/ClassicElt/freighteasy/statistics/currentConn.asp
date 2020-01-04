<html xmlns="http://www.w3.org/1999/xhtml" >
<!-- #include file="dbinfo.asp" -->
<%
		dim rs,SQL
		
		SQL="select substring(convert(char(20),s_date),1,14),ip from iff_statistics where substring(convert(char(20),s_date),1,14) = substring(convert(char(20),getdate()),1,14) order by s_date"
		Set rs = db.Execute(SQL)
		if not(rs.eof or rs.bof) then
	
			do until rs.eof
				response.write "IP:" & rs("ip") & "<br>"
			rs.movenext
			loop
		End if
		rs.close
		set rs = nothing	
	
%>


<body>
</body>
</html>