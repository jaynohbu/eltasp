<table width="<%=board_size%>" bgcolor="<%=tb_bgcolor%>" border="0" cellpadding="0" cellspacing="0" ID="Table1">
<tr>
	<td height="22" bgcolor="#333333">&nbsp; <font color="#ffffff"><b>Client Memo</b></font></td>
</tr>
<tr>
	<td>
<%
	
	Do until Rs.EOF
	
	
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
    
'	 if left(now,2)<>"20" then
'		nowday="20"&now
'	else
		nowday=now
'	end if
	
	if writeday = left(nowday,10) then
		writeday=right(write_diff,11)
		writeday=left(writeday,8)
	end if
	
	
	
	dim title1
	
	title1 = title
	
	if title1 <> "diary_cl" and title1 <> "diary_ra" and title1 <> "diary_sc" and title1 <> "diary_sn" and title1 <> "diary_su" then
		title1 = "diary_su"
	end if
	
	title = content
	call len_process
	content = title
	call search_fontcolor
	
	call db_comment_Remarks
	

	If tag = 1 Then
		title = checkword(title)
		content = checkword(content)
	ElseIf tag = 2 Then
		title = checkword(title)
		content = checkword(content)
	Else
		Call autolink(content)
	End If
	
	call nickname_joint
	
	call img_name_joint
%>

<table width="100%" border="0" cellpadding="0" cellpadding ="0">
<tr height="25">
	<td width="30" align="Center"><img src="../img/<%=title1%>.gif"></td>
	<td width="80" align="Center"><%=writeday%></td>
	<% if session_admin = "admin" then %><td width="24"><input type="checkbox" name="cart" value="<%=num%>"></td><% end if %>
	<td><% if nt_img = 1 and DateDiff("d",write_diff,nowday) < new_title then %><% if file=1 then %><img src="../img/new_file.gif" border="0"><% else %><img src="../img/new_normal<% if rs("secret")=1 then %>_s<% end if %>.gif" border="0"><% end if %><% else %><% if file=1 then %><img src="../img/file.gif" border="0"><% else %><img src="../img/normal<% if rs("secret")=1 then %>_s<% end if %>.gif" border="0"><% end if %><% end if %>&nbsp;<% if resame <> 0  then %><img src="../img/blank.gif" width="<%=blank%>" height="5" border="0"><img src="../img/re.gif" border="0"> <% end if %><% if (r_level >= user_level) or (session_admin = "admin") then %><a href="<% if secret <> 0 then %>pin<% else %>viewRemarks<% end if %>.asp?tb=<%=tb%>&num=<%=num%>&page=<%=page%><% if secret <> 0 then %>&mode=secret<% end if %><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>"><% end if %><%=content%><% if (r_level >= user_level) or (session_admin = "admin") then %></a><% end if %></td>
	<td width="40" class="font" align="Center"><%=visit%></td>
	<td width="40" class="font" align="Center"> &nbsp;<img src="../img/comment.gif" border="0"><span<% if 12 > DateDiff("h",com_date,nowday) then %> style="color:red;"<% end if %>> <%=com_record%></span></td>
</tr>
</table>
<table width="100%" border="0" cellpadding="0" cellpadding ="0">
<tr>
	<td height="1" bgcolor="#cdcdcd"></td>
</tr>
</table>
<%
    Rs.Movenext
    id_num = id_num - 1
  Loop
%>
	</td>
</tr>
<tr>
	<td height="10" bgcolor="#333333">&nbsp;</td>
</tr>

</table>