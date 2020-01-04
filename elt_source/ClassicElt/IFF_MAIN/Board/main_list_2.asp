<% session("read")="" %>


<%  all_url = "/IFF_MAIN/Board/" %>


<!-- #include Virtual ="/IFF_MAIN/Board/inc/dbinfo.asp" -->
<!-- #include Virtual ="/IFF_MAIN/Board/inc/info_tb.asp" -->
<!-- #include Virtual ="/IFF_MAIN/Board/inc/joint.asp" -->

<LINK rel="stylesheet" type="text/css" href="<%=all_url%>/inc/style.css">
<script LANGUAGE="VBScript" RUNAT="Server">
Function CheckWord(CheckValue)

CheckValue = replace(CheckValue, "&lt;", "<")
CheckValue = replace(CheckValue, "&gt;", ">")
CheckValue = replace(CheckValue, "&quot;", "'")
CheckValue = replace(CheckValue, "&amp;", "&" )
CheckWord = CheckValue
End Function
</script>
<br>
<br>
<table width="700px" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="23" ><img src="../images/spacer.gif" width="1" height="1"></td>
    <td width="17" background="../images/lt_coner.gif">&nbsp;</td>
    <td width="615" background="../images/top_shadow.gif">&nbsp;</td>
    <td width="16" background="../images/rt_coner.gif">&nbsp;</td>
  </tr>
  <tr>
    <td >&nbsp;</td>
    <td background="/images/Login/left_shadow.gif">&nbsp;</td>
    <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
        <%

		tb= "inno_1"
		show_list = 5	'## 화면에 보여줄 게시물 갯수
		
		len_title = 3		'## 제목 짜르는 글자수
		nt_img = 1
		new_title = 2			'## 새글표시 일수
			
		SQL="SELECT * FROM "&tb&" order by re desc, reid asc, num DESC"
		Set rs = db.Execute(SQL)
				
				
		i=0
		Do until Rs.EOF or i = show_list

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
		tag = rs("tag")
	    
		if session("admin")="admin" or (session("id") <> "" and session("id")=id) then
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
	    
	    
'		if left(now,2)<>"20" then
'			nowday="20"&now
'		else
'			nowday=now
'		end if

		nowday=now
				
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
        <tr> 
          <td width="78" bgcolor="#F6F6F6"><font color="#F76521"><%=writeday%></font></td>
          <td width="557" bgcolor="#F6F6F6"> 
            <% if nt_img = 1 and DateDiff("d",write_diff,nowday) < new_title then %>
            <img src="<%=all_url%>img/new_normal<% if rs("secret")=1 then %>_s<% end if %>.gif" border="0"> 
            <% else %>
            <img src="<%=all_url%>img/normal<% if rs("secret")=1 then %>_s<% end if %>.gif" border="0"> 
            <% end if %>
            &nbsp; 
            <% if resame <> 0  then %>
            <img src="<%=all_url%>img/blank.gif" width="<%=blank%>" height="5" border="0"><img src="<%=all_url%>img/re.gif" border="0"> 
            <% end if %>
            <% if (r_level >= user_level) or (session("admin") = "admin") then %>
            <a target = "_parent" href="<%=all_url%><% if secret <> 0 then %>pin<% else %>Board/view<% end if %>.asp?tb=<%=tb%>&num=<%=num%>&page=<%=page%><% if secret <> 0 then %>&mode=secret<% end if %>"> 
            <% end if %>
            <%=title%> 
            <% if (r_level >= user_level) or (session("admin") = "admin") then %>
            </a> 
            <% end if %>
            <% if com_record<>0 then %>
            &nbsp;<img src="<%=all_url%>img/comment.gif" border="0"><span style="font-size:8pt;<% if 12 > DateDiff("h",com_date,nowday) then %>color:red;<% end if %>">(<%=com_record%>)</span> 
            <% end if %>
          </td>
        </tr>
        <%
			Rs.Movenext
			id_num = id_num - 1
			i=i+1
			Loop
			
			rs.close
			set rs=nothing
		%>
      </table></td>
    <td background="/images/Login/right_shadow.gif">&nbsp;</td>
  </tr>
  <tr>
    <td >&nbsp;</td>
    <td background="/images/Login/left_bconer.gif">&nbsp;</td>
    <td background="/images/Login/bottom_shadow.gif">&nbsp;</td>
    <td background="/images/Login/rb_coner.gif">&nbsp;</td>
  </tr>
</table>
</body>
</html>
