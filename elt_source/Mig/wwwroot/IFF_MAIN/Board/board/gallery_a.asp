<table border="0" cellpadding="0" cellpadding ="0" ID="Table1">
<tr>
<%	
	for j=1 to nanuki

    num = rs("num")
    id = rs("id")
    name = rs("name")
    title = rs("title")
    email = rs("email")
    url = rs("url")
    write_diff=rs("writeday")
    writeday = left(write_diff,10)
    visit = rs("visit")
    reco = rs("reco")
    resame = rs("resame")
    filename1 = rs("filename1")
    i_width1 = rs("i_width1")
    i_height1 = rs("i_height1")
    
    if i_width1=0 and i_height1=0 then 
		filename1 = "../../img/noimage.jpg"
		i_height1 = 100
		i_width1 =  145
	elseif i_width1 > 145 and i_height1 > 100 then
		
		i_height1 = 100
		i_width1 =  i_width1 / (rs("i_height1")/i_height1)
		
		if i_width1 > 145 then
			i_width1 = 145
			i_height1 =  rs("i_height1") / (rs("i_width1")/145)
		end if
	end if
	
    
    tag = rs("tag")
    if session_admin = "admin" then
		secret=0
	else
		secret = rs("secret")
	end if    
    mem_auth = rs("mem_auth")
    
    if rs("filename1")<>"" or rs("filename2")<>"" or rs("filename3")<>"" or rs("filename4")<>"" then
		file=1
	else
		file=0
    end if
    
    blank=4*resame
    
'	if left(now,2)<>"20" then
'		nowday="20"&now
'	else
		nowday=now
'	end if
	
	if writeday = left(nowday,10) then
		writeday=right(write_diff,11)
		writeday=left(writeday,8)
	end if
	
	call len_process
	
	call search_fontcolor
	
	call db_comment
	
	call nickname_joint
	
	call img_name_joint
		    
%>

	<td align="center" valign="top">
	<table width="145" height="110" border="0" cellpadding="0" cellpadding ="0" ID="Table6"><tr><td align="center">
	<a href="<% if secret <> 0 then %>pin<% else %>view<% end if %>.asp?tb=<%=tb%>&num=<%=num%>&page=<%=page%><% if secret <> 0 then %>&mode=secret<% end if %><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>"><img src="../files/<%=tb%>/<%=filename1%>" width="<%=i_width1%>" height="<%=i_height1%>" border="0"></a></td></tr></table>
	<a href="<% if secret <> 0 then %>pin<% else %>view<% end if %>.asp?tb=<%=tb%>&num=<%=num%>&page=<%=page%><% if secret <> 0 then %>&mode=secret<% end if %><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>"><B><%=title%></B></a><% if com_record<>0 then %> &nbsp;<img src="../img/comment.gif" border="0"><span style="font-size:8pt;<% if 12 > DateDiff("h",com_date,nowday) then %>color:red;<% end if %>">(<%=com_record%>)</span><% end if %>
	<br><span onMousedown="inno_layer('info_layer<%=id_num%>','visible')" style=cursor:hand><% if mem_auth = 0 then %><%=name%><% else %><b><%=name%></b><% end if %></span><script>show_layer('info_layer<%=id_num%>', '<%=rs("name")%>', '<%=email%>', '<%=url%>', '<%=tb%>', '<%=mem_auth%>', '<%=id%>', '<% if session_admin="admin" then %>1<% end if %>');</script><br><% if session_admin = "admin" then %><input type="checkbox" name="cart" value="<%=num%>" ID="Checkbox1"><% end if %><span style="font-size:7pt;">[<%=writeday%>]</span></td>

<%
    Rs.Movenext
    id_num = id_num - 1
    
    if rs.EOF then 
exit for
end if
next
%>
</tr>

</table>