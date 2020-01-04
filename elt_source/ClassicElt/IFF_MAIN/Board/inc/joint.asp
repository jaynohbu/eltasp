<%

dim f_level,f_term,f_jumin,f_msg,f_nickname,f_birthday,f_address,f_tel,f_phone,f_hobby,f_job,f_introduce,f_mailling,f_agreement,f_agreement_text
dim w_point,r_point,rw_point,c_point,level_1,level_2,level_3,level_4,level_5,level_6,level_7,level_8,img_name,up_com,level_select
Dim First_Page, End_Page, iii,page
dim sw,st,sc,sn,search
dim content
dim com_record,com_date
dim i_w1,i_h1,i_w2,i_h2,i_w3,i_h3,i_w4,i_h4

%>


<%
sub nickname_joint	'#### ÀÌ¸§´ë½Å¿¡ ´Ð³×ÀÓÀ¸·Î ³Ö±â

	if mem_auth <> "" then
	
		dim sql_nick,rs_nick
		
		SQL_nick = "SELECT nickname,o_nickname FROM member where elt_account_number=" & elt_account_number & "AND id='"&id&"'"
		Set rs_nick = db.execute (SQL_nick)
	    
	    if rs_nick.bof or rs_nick.eof then
			name = name
		else
			if trim(rs_nick("nickname"))<>"" and rs_nick("o_nickname") > 0 then
				name = rs_nick("nickname")
			else
				name=name
			end if
		end if 
	    
			
		rs_nick.close
		set rs_nick = nothing

	end if
	
end sub
%>


<%
sub img_name_joint	'#### ÀÌ¸§´ë½Å¿¡ ÀÌ¹ÌÁö·Î ³Ö±â
	dim sql_mem,rs_mem

	SQL_mem = "SELECT img_name FROM f_member"
    Set rs_mem = db.execute (SQL_mem)
    
	if rs_mem(0)=1 then
		if id <> "" then
			
			dim sql1,rs1
			
			SQL1 = "SELECT name_img FROM member where elt_account_number=" & elt_account_number & "AND id='"&id&"'"
			Set rs1 = db.execute (SQL1)
			
			if rs1.eof or rs1.bof then
				name=name
			else
				if rs1(0)=1 then
					name="<img src=../files/img_name/"&id&".gif border=0>"
				end if
			end if
			
			rs1.close
			set rs1=nothing
		end if
	end if
	
	rs_mem.close
	set rs_mem = nothing
	
end sub
%>

<%	'//////////// Á¦¸ñ°ú ÀÌ¸§ °ª ÃÊ°¡½Ã ... À¸·Î Ã³¸®
sub len_process
	if tag > 0 then
		title=CheckWord(title)
		if Len(title) > len_title+10 then
			title=mid(title,1,len_title+11)&".."
		end if
		name=CheckWord(name)
		If Len(name) > 15 Then
			name = Mid(name,1,16) & ".."
		End If
	else
		if Len(title) > len_title then
			title=mid(title,1,len_title+1)&".."
		end if
		title=replace(title,"&quot;","'")
		If Len(name) > 15 Then
			name = Mid(name,1,16) & ".."
		End If
		name=replace(name,"&quot;","'")
	end if
end sub
%>


<%	
sub process_write 


	if notice<>"" then
		notice=1
	else
		notice=0
	end if
	
	if tag="" then
		tag=0
	end if
	
	if secret="" then
		secret=0
	end if
	
	if reply_mail="" then
		reply_mail=0
	end if
	
	call f_member
	
if mode <> "edit" then
	
	if session_login_name <> "" then
		mem_auth = 1
	else
		mem_auth = 0
	end if

	SQL = "INSERT INTO "&tb&" (num,elt_account_number,id,name,email,url,title,content,pin,secret_pin,writeday,ip,link_1,link_2,filename1,filesize1,filename2,filesize2,filename3,filesize3,filename4,filesize4,down1,down2,down3,down4,visit,reco,re,resame,reid,notice,tag,secret,reply_mail,i_width1,i_height1,i_width2,i_height2,i_width3,i_height3,i_width4,i_height4,mem_auth) VALUES "
	SQL = SQL & "(" & num & ""
	SQL = SQL & ",'" & elt_account_number & "'"
	SQL = SQL & ",'" & session_uid & "'"
	SQL = SQL & ",'" & session_login_name & "'"
	SQL = SQL & ",'" & email & "'"
	SQL = SQL & ",'" & url & "'"
	SQL = SQL & ",'" & title & "'"
	SQL = SQL & ",'" & content & "'"
	SQL = SQL & ",'" & pin & "'"
	SQL = SQL & ",'" & secret_pin & "'"
	SQL = SQL & ",'" & writeday & "'"
	SQL = SQL & ",'" & ip & "'"
	SQL = SQL & ",'" & link_1 & "'"
	SQL = SQL & ",'" & link_2 & "'"
	SQL = SQL & ",'" & filename1 &"'"
	SQL = SQL & ",'" & filesize1 & "'"
	SQL = SQL & ",'" & filename2 & "'"
	SQL = SQL & ",'" & filesize2 & "'"
	SQL = SQL & ",'" & filename3 & "'"
	SQL = SQL & ",'" & filesize3 & "'"
	SQL = SQL & ",'" & filename4 & "'"
	SQL = SQL & ",'" & filesize4 & "'"
	SQL = SQL & "," & 0 & ""
	SQL = SQL & "," & 0 & ""
	SQL = SQL & "," & 0 & ""
	SQL = SQL & "," & 0 & ""
	SQL = SQL & "," & 0 & ""
	SQL = SQL & "," & 0 & ""
	SQL = SQL & ",'" & re & "'"
	SQL = SQL & ",'" & newresame & "'"
	SQL = SQL & ",'" & newreid & "'"
	SQL = SQL & ",'" & notice & "'"
	SQL = SQL & ",'" & tag & "'"
	SQL = SQL & ",'" & secret & "'"
	SQL = SQL & ",'" & reply_mail & "'"
	SQL = SQL & "," & i_w1 & ""
	SQL = SQL & "," & i_h1 & ""
	SQL = SQL & "," & i_w2 & ""
	SQL = SQL & "," & i_h2 & ""
	SQL = SQL & "," & i_w3 & ""
	SQL = SQL & "," & i_h3 & ""
	SQL = SQL & "," & i_w4 & ""
	SQL = SQL & "," & i_h4 & ""
	SQL = SQL & ",'" & mem_auth & "')"
	db.Execute SQL

	if session_login_name <> "" then
		if mode="reply" then
			SQL = "Update member set po_write=po_write+1,point=point+"&rw_point&" where elt_account_number="&elt_account_number&"  AND id='"&session_uid&"'"
		else
			SQL = "Update member set po_write=po_write+1,point=point+"&w_point&" where elt_account_number="&elt_account_number&"  AND id='"&session_uid&"'"
		end if
		db.execute SQL
		
		dim sql_level1,rs_level1
		SQL_level1 = "SELECT level_select FROM f_member"
		Set rs_level1 = db.execute (SQL_level1)
	 
		if rs_level1(0) = 1 then
			call point_up
		end if
		
		rs_level1.close
		set rs_level1=nothing
		
	end if 
	
	else
	SQL = "Update "&tb&" set name = '" & name & "'"
	SQL = SQL & ", pin ='" & pin & "'"
	SQL = SQL & ", secret_pin ='" & secret_pin & "'"
	SQL = SQL & ", email = '" & email & "'"
	SQL = SQL & ", url = '" & url & "'"
	SQL = SQL & ", link_1 = '" & link_1 & "'"
	SQL = SQL & ", link_2 = '" & link_2 & "'"
	SQL = SQL & ", title = '" & title & "'"
    SQL = SQL & ", content = '" & content & "'"
	SQL = SQL & ", notice ='" & notice & "'"
	SQL = SQL & ", tag ='" & tag & "'"
	SQL = SQL & ", secret ='" & secret & "'"
	SQL = SQL & ", reply_mail ='" & reply_mail & "'"
	SQL = SQL & ", filename1 ='" & filename1 & "'"
	SQL = SQL & ", filesize1 ='" & filesize1 & "'"
	SQL = SQL & ", filename2 ='" & filename2 & "'"
	SQL = SQL & ", filesize2 ='" & filesize2 & "'"
	SQL = SQL & ", filename3 ='" & filename3 & "'"
	SQL = SQL & ", filesize3 ='" & filesize3 & "'"
	SQL = SQL & ", filename4 ='" & filename4 & "'"
	SQL = SQL & ", filesize4 ='" & filesize4 & "'"
	SQL = SQL & ", i_width1 =" & i_w1 & ""
	SQL = SQL & ", i_height1 =" & i_h1 & ""
	SQL = SQL & ", i_width2 =" & i_w2 & ""
	SQL = SQL & ", i_height2 =" & i_h2 & ""
	SQL = SQL & ", i_width3 =" & i_w3 & ""
	SQL = SQL & ", i_height3 =" & i_h3 & ""
	SQL = SQL & ", i_width4 =" & i_w4 & ""
	SQL = SQL & ", i_height4 =" & i_h4 & ""
	SQL = SQL & " where num = " & num
	db.Execute SQL
	end if		

end sub
%>


<% sub member_form '############## ¸â¹ö ·Î±×ÀÎ °ü·Ã %>
<Script Language="javascript">
<!--


function OpenWindow(url,intWidth,intHeight) { 
      window.open(url, "_blank", "width="+intWidth+",height="+intHeight+",resizable=0,scrollbars=1");
}
//-->
</Script>
		<% if session_login_name <> "" then %>
		<%
			dim user_level,sql1,rs1
			SQL1 = "SELECT user_level,name FROM member where elt_account_number=" & elt_account_number & "AND id='"&session_uid&"'"		'### ÇöÀç ¾ÆÀÌµðÀÇ ·¹º§À» °¡Á®¿Â´Ù.
			Set rs1 = db.execute (SQL1)
			
			
			user_level=rs1(0)
			
			rs1.close
			set rs1=nothing		
			
			
			
			dim check_read
					
			SQL1 = "SELECT m_read FROM message where elt_account_number="&elt_account_number&" AND (m_box like '0') and (m_read like '0') and r_id='"&session_uid&"'"	'### ÇöÀç ¾ÆÀÌµðÀÇ ÂÊÁöÇÔÀ» °Ë»öÇÑ´Ù.
			Set rs1 = db.execute (SQL1)
			
			
			if rs1.eof or rs1.bof then	'### »õ ÂÊÁö°¡ ÀÖ´Ù¸é...
				check_read=1
			else						'### »õ ÂÊÁö°¡ ¾ø´Ù¸é..
				check_read=0
			end if
			
			rs1.close
			set rs1=nothing	
			
		%>
		<img src="../img/member.gif" border="0"> <span style="font-family:'verdana','µ¸¿ò','Arial';color:#333333;font-size:7.9pt;"><a href="javascript:OpenWindow('../member/user_view.asp?id=<%=session_uid%>','500','520')"><%=session_login_name%></a> &nbsp; 
		<!-- batch call for memo check -->
		<iframe src="../message/check_call.asp" width="0" height="0" FRAMEBORDER="no" MARGINWIDTH="0" MARGINHEIGHT="0" SCROLLING="no"></iframe>
		<!-- end -->		
		<iframe id="memoFrame" width="17" height="15" FRAMEBORDER="no" MARGINWIDTH="0" MARGINHEIGHT="0" SCROLLING="no" style="vertical-align:bottom"></iframe>
        <a href="javascript:OpenWindow('../message/m_list.asp?m_box=0&id=<%=session_uid%>','400','400')">Memo Box</a></span> &nbsp; 
		<% if session_admin = "admin" then %><a href="../admin/index.asp?tb=<%=tb%>" target="_blank"><img src="../img/but_admin_zone.gif" border="0"></a> <% end if %>
	<% end if %>

<% end sub %>

<% sub point_up 
	
	dim point,updatesql
	
	if session_login_name <> "" then
		SQL = "Select * From member Where elt_account_number=" & elt_account_number & "AND id ='"& session_uid &"'"
		Set rs = db.Execute(SQL)
			
		if rs.eof or rs.bof then Response.Redirect "../inc/error.asp?no=2"
	
		point = rs("point")
	
		if point >= level_1 then
			UPDATESQL = "Update member Set user_level = 1 where id='"& session_uid &"'"
		elseif point >= level_2 then
			UPDATESQL = "Update member Set user_level = 2 where id='"& session_uid &"'"
		elseif point >= level_3 then
			UPDATESQL = "Update member Set user_level = 3 where id='"& session_uid &"'"
		elseif point >= level_4 then
			UPDATESQL = "Update member Set user_level = 4 where id='"& session_uid &"'"
		elseif point >= level_5 then
			UPDATESQL = "Update member Set user_level = 5 where id='"& session_uid &"'"
		elseif point >= level_6 then
			UPDATESQL = "Update member Set user_level = 6 where id='"& session_uid &"'"
		elseif point >= level_7 then
			UPDATESQL = "Update member Set user_level = 7 where id='"& session_uid &"'"
		elseif point >= level_8 then
			UPDATESQL = "Update member Set user_level = 8 where id='"& session_uid &"'"
		else
			UPDATESQL = "Update member Set user_level = 9 where id='"& session_uid &"'"
		end if
		db.Execute UPDATESQL
	end if

end sub %>

<%	'//////////// ´äº¯±Û ¸ÞÀÏ¹ß¼Û
sub reply_email
	
	dim fmail,mail,o_content
	
	o_content = Replace(content, vbCrLf,"<br>")
	
	o_content = "<span style='font-size:9pt;color:#333333;'>"&o_content&"</span>"
	
	If email = "" Then
		fmail = "Anonymous"
	Else
		fmail = email
	End If

	Set Mail = Server.CreateObject("CDONTS.NewMail")
	Mail.From = fmail
	Mail.To = o_email
	Mail.Subject = "[´äº¯] " & o_title
	Mail.BodyFormat = 0
	Mail.MailFormat = 0
	Mail.Body = o_content
	Mail.Send

	Set Mail = Nothing
end sub
%>


<%	'//////////// ÆäÀÌÁö ³×ºñ°ÔÀÌ¼Ç
	sub pre_next(p_num,n_num,p_title,p_name,n_title,n_name)
	
	
	SQL = "Select Top 1 num, name, title From "&tb&" Where num = " & num & " And reid < " & reid & " Order by num, reid Desc"
	Set Rs = db.Execute(SQL)
	If Rs.EOF Then
		SQL = "Select Top 1 num, name, title From "&tb&" Where num > " & num & " Order by num, reid Desc"
		Set Rs = db.Execute(SQL)

		If Rs.EOF Then
			p_num = 0
		Else
			p_num = rs("num")
			p_name = rs("name")
			p_title = rs("title")
		End If
	Else
		p_num = rs("num")
		p_name = rs("name")
		p_title = rs("title")
	End If

	
	SQL = "Select Top 1 num, name, title From "&tb&" Where num = " & num & " And reid > "& reid &" Order by num Desc, reid"
	Set Rs = db.Execute(SQL)
	If Rs.EOF Then
		SQL = "Select Top 1 num, name, title From "&tb&" Where num < " & num & " Order by num Desc, reid"
		Set Rs = db.Execute(SQL)

		If Rs.EOF Then
			n_num = 0
		Else
			n_num = rs("num")
			n_name = rs("name")
			n_title = rs("title")
		End If
	Else
		n_num = rs("num")
		n_name = rs("name")
		n_title = rs("title")
	End If

	
	if tag > 0 then
		p_title=CheckWord(p_title)
		if Len(p_title) > len_title+10 then
			p_title=mid(p_title,1,len_title+11)&".."
		end if
		n_name=CheckWord(n_name)
		If Len(n_name) > 15 Then
			n_name = Mid(n_name,1,16) & ".."
		End If
	else
		if Len(p_title) > len_title then
			p_title=mid(p_title,1,len_title+1)&".."
		end if
		p_title=replace(p_title,"&quot;","'")
		If Len(n_name) > 15 Then
			n_name = Mid(n_name,1,16) & ".."
		End If
		n_name=replace(n_name,"&quot;","'")
	end if
	
	end sub
%>

<%
	sub pre_next_Remarks(p_num,n_num,p_title,p_name,n_title,n_name)
	
	
	SQL = "Select Top 1 num, name, title From "&tb&" Where num = " & num & " And reid < " & reid & " and elt_account_number = " & elt_account_number & " and org_account_number= " & session("vOrgNum") & " Order by num, reid Desc"
	Set Rs = db.Execute(SQL)
	If Rs.EOF Then
		SQL = "Select Top 1 num, name, title From "&tb&" Where num > " & num & "and elt_account_number = " & elt_account_number & " and org_account_number= " & session("vOrgNum") & " Order by num, reid Desc"
		Set Rs = db.Execute(SQL)

		If Rs.EOF Then
			p_num = 0
		Else
			p_num = rs("num")
			p_name = rs("name")
			p_title = rs("title")
		End If
	Else
		p_num = rs("num")
		p_name = rs("name")
		p_title = rs("title")
	End If

	
	SQL = "Select Top 1 num, name, title From "&tb&" Where num = " & num & " And reid > "& reid &" and elt_account_number = " & elt_account_number & " and org_account_number= " & session("vOrgNum") & " Order by num Desc, reid"
	Set Rs = db.Execute(SQL)
	If Rs.EOF Then
		SQL = "Select Top 1 num, name, title From "&tb&" Where num < " & num & " and elt_account_number = " & elt_account_number & " and org_account_number= " & session("vOrgNum") & " Order by num Desc, reid"
		Set Rs = db.Execute(SQL)

		If Rs.EOF Then
			n_num = 0
		Else
			n_num = rs("num")
			n_name = rs("name")
			n_title = rs("title")
		End If
	Else
		n_num = rs("num")
		n_name = rs("name")
		n_title = rs("title")
	End If

	
	if tag > 0 then
		p_title=CheckWord(p_title)
		if Len(p_title) > len_title+10 then
			p_title=mid(p_title,1,len_title+11)&".."
		end if
		n_name=CheckWord(n_name)
		If Len(n_name) > 15 Then
			n_name = Mid(n_name,1,16) & ".."
		End If
	else
		if Len(p_title) > len_title then
			p_title=mid(p_title,1,len_title+1)&".."
		end if
		p_title=replace(p_title,"&quot;","'")
		If Len(n_name) > 15 Then
			n_name = Mid(n_name,1,16) & ".."
		End If
		n_name=replace(n_name,"&quot;","'")
	end if
	
	end sub
%>

<% '//////////// list.asp ÆäÀÌÁö db ¿¬°áºÎºÐ
sub db_list

	
	sw = request("sw")
	
	if sw="" then
		SQL = "select count(num) as recCount from "&tb
		Set rs = db.Execute(SQL)

		recordCount = Rs(0)
		pagecount = int((recordCount-1)/pagesize) +1
		id_num = recordCount - (Page -1) * PageSize
  

		SQL = "SELECT TOP " & pagesize & " * FROM "&tb
		if int(page) > 1 then
		SQL = SQL & " WHERE num not in "
		SQL = SQL & "(SELECT TOP " & ((page - 1) * pagesize) & " num FROM "&tb
		SQL = SQL & " ORDER BY re DESC,reid asc,num DESC)"
		end if
		SQL = SQL & " order by re DESC,reid asc,num desc"
		
	else
		st=request("st")
		sc=request("sc")
		sn=request("sn")
		sw = replace(sw,"'","''")

		if st="on" then
			search="(title LIKE '%"& sw &"%')"
		
			if sc="on" or sn="on" then
				search=search & " or "
			end if
		else
			st="off"	
		end if
	
		if sc="on" then
			if st="on" then
				search=search & "(content LIKE '%"& sw &"%')"
			else
				search="(content LIKE '%"& sw &"%')"
			end if
			
			if sn="on" then
				search=search & " or "
			end if
	
		else
			sc="off"
		end if
	
		if sn="on" then
			if st="on" or sc="on" then
				search=search & "(name LIKE '%"& sw &"%')"
			else
				search="(name LIKE '%"& sw &"%')"
			end if
		else
			sn="off"		
		end if
		
		if st="off" and sc="off" and sn="off" then response.Redirect "../inc/error.asp?no=17"
		
		SQL = "select count(num) as recCount from "&tb&" where "&search
		Set rs = db.Execute(SQL)

		recordCount = Rs(0)
		pagecount = int((recordCount-1)/pagesize) +1
		id_num = recordCount - (Page -1) * PageSize
  

		SQL = "SELECT TOP " & pagesize & " * FROM "&tb
		SQL = SQL & " WHERE ("&search&")"
		if int(page) > 1 then
		SQL = SQL & " and num not in "
		SQL = SQL & "(SELECT TOP " & ((page - 1) * pagesize) & " num FROM "&tb
		SQL = SQL & " where "&search&" ORDER BY num DESC)"
		end if
		SQL = SQL & " order by num desc" 

	
	end if

	Set Rs = db.Execute(SQL)
end sub
%>

<%
sub db_comment_remarks
	
	dim com_sql,com_rs
	com_SQL = "SELECT count(com_num) FROM Remarks_comment where tb='"&tb&"' and com_num="&num& " and elt_account_number="&elt_account_number&" and org_account_number="&session("vOrgNum")

	Set com_rs = db.Execute(com_SQL)
	    
	if com_rs.BOF or com_rs.EOF then 
	
	else
	
	com_record = com_rs(0)	'ÇöÀç±Û¿¡ ÄÚ¸àÆ®ÀÇ °¹¼ö
	
	
	end if
	
	com_rs.close
	set com_rs=nothing
	
	
	com_SQL = "SELECT com_writeday FROM Remarks_comment where tb='"&tb&"' and com_num="&num& " and elt_account_number="&elt_account_number&" and org_account_number="&session("vOrgNum")& " order by com_id desc"
	Set com_rs = db.Execute(com_SQL)
	
	if com_rs.BOF or com_rs.EOF then	
		com_date=DateAdd("d",-1,now)
	else

	com_date=com_rs(0)
	
'	if left(com_date,2)<>"20" then
'		com_date="20"&mid(com_date,3)
'	end if
		com_date=mid(com_date,3)
	
	end if
	
	com_rs.close
	set com_rs=nothing
	
end sub
%>

<%	'//////////// ÄÚ¸àÆ® db ¿¬°áºÎºÐ
sub db_comment
	
	dim com_sql,com_rs
	com_SQL = "SELECT count(com_num) FROM inno_comment where tb='"&tb&"' and com_num="&num

	Set com_rs = db.Execute(com_SQL)
	    
	if com_rs.BOF or com_rs.EOF then 
	
	else
	
	com_record = com_rs(0)	'ÇöÀç±Û¿¡ ÄÚ¸àÆ®ÀÇ °¹¼ö
	
	
	end if
	
	com_rs.close
	set com_rs=nothing
	
	
	
	com_SQL = "SELECT com_writeday FROM inno_comment where tb='"&tb&"' and com_num="&num&" order by com_id desc"
	Set com_rs = db.Execute(com_SQL)
	
	if com_rs.BOF or com_rs.EOF then	
		com_date=DateAdd("d",-1,now)
	else

	com_date=com_rs(0)
	
'	if left(com_date,2)<>"20" then
'		com_date="20"&mid(com_date,3)
'	end if
		com_date=mid(com_date,3)
	
	end if
	
	com_rs.close
	set com_rs=nothing
	
end sub
%>

<%	'//////////// ÄÁµ§Ã÷¿¡¼­ url ÀÚµ¿À¸·Î ¸µÅ© ½ÃÅ°±â
	Sub Autolink(content)
		
	Dim Reg,AutoLink
	Set Reg = New RegExp
	Reg.pattern = "(\w+):\/\/([a-z0-9\_\-\./~@?=%&:\-]+)"
	Reg.Global = True
	Reg.IgnoreCase = True
	'Reg.multiline = true
	content = Reg.Replace(content, "<a href='$1://$2' target=_blank>$1://$2</a>")
	Reg.pattern = "(\w+)@([\w.\-]+)"
	content = Reg.Replace(content, "<a href=mailto:$1@$2>$1@$2</a>")
	
	End Sub
%>



<%	'//////////// È¸¿øÆû ¼±ÅÃ
sub f_member

	SQL = "SELECT f_level,f_term,f_jumin,f_nickname,f_msg,f_birthday,f_address,f_tel,f_phone,f_hobby,f_job,f_introduce,f_mailling,f_agreement,f_agreement_text,w_point,r_point,rw_point,c_point,level_1,level_2,level_3,level_4,level_5,level_6,level_7,level_8,img_name,up_com,level_select FROM f_member"

	Set rs = db.execute (SQL)
if not rs.eof and not rs.bof then	
	f_level = rs("f_level")
	f_term = rs("f_term")
	f_jumin = rs("f_jumin")
	f_nickname = rs("f_nickname")
	f_msg = rs("f_msg")	
	f_birthday = rs("f_birthday")
	f_address = rs("f_address")
	f_tel = rs("f_tel")
	f_phone = rs("f_phone")
	f_hobby = rs("f_hobby")
	f_job = rs("f_job")
	f_introduce = rs("f_introduce")
	f_mailling = rs("f_mailling")
	f_agreement = rs("f_agreement")
	f_agreement_text = rs("f_agreement_text")
	
	'###############################################
	
	w_point = rs("w_point")
	r_point = rs("r_point")
	rw_point = rs("rw_point")
	c_point = rs("c_point")
	
	level_1 = rs("level_1")
	level_2 = rs("level_2")
	level_3 = rs("level_3")
	level_4 = rs("level_4")
	level_5 = rs("level_5")
	level_6 = rs("level_6")
	level_7 = rs("level_7")
	level_8 = rs("level_8")
	
	img_name = rs("img_name")
	up_com = rs("up_com")
	
	level_select = rs("level_select")
else
	f_level = 9
	f_term = 0
	f_jumin = 0
	f_nickname = 1
	f_msg = 1
	f_birthday = 0
	f_address = 0
	f_tel = 0
	f_phone = 0
	f_hobby = 0
	f_job = 0
	f_introduce = 0
	f_mailling =0
	f_agreement = 0
	f_agreement_text = ""
	
	'###############################################
	
	w_point = 10
	r_point =1
	rw_point = 5
	c_point = 3
	
	level_1 = 4000
	level_2 = 3500
	level_3 = 3000
	level_4 = 2500
	level_5 = 2000
	level_6 = 1500
	level_7 = 1000
	level_8 = 500
	
	img_name = 1
	up_com = 0
	
	level_select = 1

end if
	rs.close
	set rs=nothing

end sub
%>

<%
sub view_login
	dim sql2,rs2,sql_del
		
		if (cServerNameBoard = "192.168.0.100") or (cServerNameBoard = "192.168.1.114") or (cServerNameBoard = "s-app01") or (cServerNameBoard = "www.kasamerica.vn") or (cServerNameBoard = "kasamerica.vn") then
			exit sub
		end if

		SQL2 = "SELECT u_time,session_id,elt_account_number,alive FROM view_login"
		Set rs2 = eltConn.execute(SQL2)
		
		if rs2.eof or rs2.bof then
		
		else
			do until rs2.eof
				if datediff("n",rs2("u_time"),now) >= 120 Then
					SQL_DEL = "DELETE FROM view_login where session_id='"&rs2("session_id")&"'"
					eltConn.execute(SQL_DEL)
				end if
			rs2.movenext
			loop
		end if

	rs2.close
	set rs2=nothing
	
end sub
%>




<% '//////////// °Ë»ö Æû
Sub form_search %>
<table border="0" cellpadding="0" cellspacing="0">
<tr>
	<form action="list.asp?tb=<%=tb%>" Method="POST" name="inno">
	<td valign="bottom">
		<input type=hidden name=st value="<% if st="on" then %>on<%elseif st="" then%>on<%else%>off<% end if %>">
		<input type=hidden name=sc value="<% if sc="on" then %>on<%elseif sc="" then%>on<%else%>off<% end if %>">
		<input type=hidden name=sn value="<% if sn="on" then %>on<%else%>off<% end if %>">
		<img src="../img/search0.gif" border="0"><a href="javascript:OnOff('st')"><img src="../img/st_<% if st="on" then %>on<%elseif st="" then%>on<%else%>off<% end if %>.gif" border="0" name="st" align="absmiddle"></a><a href="javascript:OnOff('sc')"><img src="../img/sc_<% if sc="on" then %>on<%elseif sc="" then%>on<%else%>off<% end if %>.gif" border="0" name="sc" align="absmiddle"></a><a href="javascript:OnOff('sn')"><img src="../img/sn_<% if sn="on" then %>on<%else%>off<% end if %>.gif" border="0" name="sn" align="absmiddle"></a></td>
	<td><input type="text" name="sw" value="<%=sw%>" class="form_input" size="20"></td>
	<td valign="bottom"><input type="image" border="0" src="../img/search.gif" align="absmiddle" id=image1 name=image1></td>
	<td valign="bottom"><a href="list.asp?tb=<%=tb%>"><img src="../img/search1.gif" border="0"></a></td>
</form>
	</tr>
	</table>
<% end sub %>

<% '//////////// °Ë»öµÈ ´Ü¾î¿¡ »öÇ¥½Ã
Sub search_fontcolor
	if sw<>"" then
		if st = "on" then
			title = replace(Ucase(title),sw,"<b><font color=#ff7b00>"&sw&"</font></b>")
			title = replace(Lcase(Ucase(title)),sw,"<b><font color=#ff7b00>"&sw&"</font></b>")
		end if
		if sc = "on" then
			content = replace(Ucase(content),sw,"<b><font color=#ff7b00>"&sw&"</font></b>")
			content = replace(Lcase(content),sw,"<b><font color=#ff7b00>"&sw&"</font></b>")
		end if
		if sn = "on" then
			name = replace(Ucase(name),sw,"<b><font color=#ff7b00>"&sw&"</font></b>")
			name = replace(Lcase(name),sw,"<b><font color=#ff7b00>"&sw&"</font></b>")
		end if
	end if 
End Sub
%>

<%	'//////////// ÆäÀÌÁö Ç¥½ÃºÎºÐ
Sub PageSearch %>
	<% If Rs.BOF Then %>
	
	<%
		Else
		If Int(Page) <> 1 Then 
	%>
		<a href="list.asp?tb=<%=tb%>&page=<%=Page-1%><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onfocus="this.blur()"><font color="#000000" style="font-size:8pt;">[prv]</font></a>
	<%
		end if
		
		First_Page = Int((Page-1)/Block)*Block+1
		If First_Page <> 1 Then
	%>
			[<a href="list.asp?tb=<%=tb%>&page=1<% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onfocus="this.blur()"><font color="#000000" style="font-size:8pt;">1</font></a>]&nbsp;..
	<%
		end if
		
		If PageCount - First_Page < Block Then
			End_Page = PageCount
		Else
			End_Page = First_Page + Block - 1
		End If

		For page_i = First_Page To End_Page
		If Int(Page) = page_i Then
	%>
			[<font color="#FF0000" style="font-size:8pt;"><b><%=page_i%></b></font>]
	<% Else %>
			[<a href="list.asp?tb=<%=tb%>&page=<%=page_i%><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onfocus="this.blur()"><font color="#000000" style="font-size:8pt;"><%=page_i%></font></a>]
	<%
		End If
		Next
		
		If End_Page <> PageCount Then
	%>
	&nbsp;..&nbsp;[<a href="list.asp?tb=<%=tb%>&page=<%=PageCount%><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onfocus="this.blur()"><font color="000000" style="font-size:8pt;"><%=PageCount%></font></a>]
	<%
		end if
		
		If Int(Page) <> PageCount Then
	%>
	&nbsp;<a href="list.asp?tb=<%=tb%>&page=<%=page+1%><% if sw<>"" then %>&st=<%=st%>&sc=<%=sc%>&sn=<%=sn%>&sw=<%=sw%><% end if %>" onfocus="this.blur()"><font color="#000000" style="font-size:8pt;">[next]</font></a>
	<%
		End If
		End If
	%>
<% End Sub 


sub rs_db_close
	rs.close
	db.Close
	Set rs=nothing
	Set db=nothing
end sub
%>