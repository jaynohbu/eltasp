<%
    num = rs("num")
    id = rs("id")
    name = rs("name")
    title = rs("title")
    email = rs("email")
    url = rs("url")
    content = rs("content")
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
		i_height1 = 50
		i_width1 =  72
	elseif i_width1 > 101 and i_height1 > 50 then
		
		i_height1 = 50
		i_width1 =  i_width1 / (rs("i_height1")/i_height1)
		
		if i_width1 > 72 then
			i_width1 = 72
			i_height1 =  rs("i_height1") / (rs("i_width1")/72)
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
    
'    if left(now,2)<>"20" then
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
	

	If tag = 1 Then
		title = checkword(title)
		content = Replace(checkword(content), vbCrLf,"<br>")
	ElseIf tag = 2 Then
		title = checkword(title)
		content = checkword(content)
	Else
		content = Replace(content, vbCrLf,"<br>")
		Call autolink(content)
	End If
	
	call nickname_joint
	
	call img_name_joint
%>

<table width="<%=board_size%>" border="0" cellpadding="0" cellpadding ="0" ID="Table7">
<tr>
	<td width="40" class="font" align="Center"><% if num > 100000000 then %><img src="../img/notice.gif"><% else %><%=id_num%><% end if %></td>
	<td width="24"><input type="checkbox" name="cart" value="<%=num%>"></td>
	<td width="80" align="center"><% if rs("i_width1")<>0 then %><a href="javascript:OpenWindow('../board/open_img.asp?img_file=../files/<%=tb%>/<%=filename1%>','<%=rs("i_width1")+16%>','<%=rs("i_height1")+4%>')"><% end if %><img src="../files/<%=tb%>/<%=filename1%>" width="<%=i_width1%>" height="<%=i_height1%>" border="0"><% if rs("i_width1")<>0 then %></a><% end if %><% if mem_auth = 0 or (mem_auth = 1 and session_uid = id) or session_admin = "admin" then %></div><% end if %></td>
	<td><% if nt_img = 1 and DateDiff("d",write_diff,nowday) < new_title then %><% if file=1 then %><img src="../img/new_file.gif" border="0"><% else %><img src="../img/new_normal<% if rs("secret")=1 then %>_s<% end if %>.gif" border="0"><% end if %><% else %><% if file=1 then %><img src="../img/file.gif" border="0"><% else %><img src="../img/normal<% if rs("secret")=1 then %>_s<% end if %>.gif" border="0"><% end if %><% end if %>&nbsp;<% if resame <> 0  then %><img src="../img/blank.gif" width="<%=blank%>" height="5" border="0"><img src="../img/re.gif" border="0"> <% end if %><% if (r_level >= user_level) or (session_admin = "admin") then %><a href="<% if secret <> 0 then %>pin<% else %>view<% end if %>.asp?tb=<%=tb%>&num=<%=num%>&page=<%=page%><% if secret <> 0 then %>&mode=secret<% end if %><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>"><% end if %><%=title%><% if (r_level >= user_level) or (session_admin = "admin") then %></a><% end if %><% if com_record<>0 then %> &nbsp;<img src="../img/comment.gif" border="0"><span style="font-size:8pt;<% if 12 > DateDiff("h",com_date,nowday) then %>color:red;<% end if %>">(<%=com_record%>)</span><% end if %></td>
	<td width="80" align="Center"><span onMousedown="inno_layer('info_layer_<%=num%>','visible')" style=cursor:hand><%=name%></span></td>
	<td width="80" align="Center"><%=writeday%><script>show_layer('info_layer_<%=num%>', '<%=rs("name")%>', '<%=email%>', '<%=url%>', '<%=tb%>', '<%=mem_auth%>', '<%=id%>', '<% if session_admin="admin" then %>1<% end if %>');</script></td>
	<td width="40" class="font" align="Center"><%=visit%></td>
</tr>
</table>
