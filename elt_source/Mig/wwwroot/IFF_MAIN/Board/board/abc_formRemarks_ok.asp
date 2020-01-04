<%@  transaction="supported" language="vbscript" codepage="65001" %>
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<% response.buffer = true %>

<!-- #include virtual="/IFF_MAIN/Board/inc/dbinfo.asp" -->

<%
	dim bbs,num,pin,mode
	dim allfile,allfile1,allfile2,allfile3,allfile4,test
	dim name,title,email,url,secret_pin,link_1,link_2,ip,notice,tag,secret,reply_mail,writeday,mem_auth
	dim filesize1,filesize_ok,fs,strname,strext,strext_1,strfilename1,aname1,filename1,oldfilename1
	dim filesize2,strfilename2,aname2,filename2,oldfilename2
	dim filesize3,strfilename3,aname3,filename3,oldfilename3
	dim filesize4,strfilename4,aname4,filename4,oldfilename4
	dim up_dir,fexist,count

	Response.Expires = -10000
	Server.ScriptTimeout = 3600
			
			
			
	Set bbs = Server.CreateObject("ABCUpload4.XForm")
	bbs.CodePage = "65001"


	bbs.MaxUploadSize = 1024 * 1024 * 1000
	bbs.ID = Request.QueryString("id")
	tb = bbs("tb")

%>

<!-- #include virtual="/IFF_MAIN/Board/inc/info_tb.asp" -->
<!-- #include virtual="/IFF_MAIN/Board/inc/joint.asp" -->

<%

	Set Rs = db.Execute("Select maxsize From inno_admin Where tb='"&tb&"'")
		maxsize = Rs(0)*1024
	Rs.Close
	bbs.AbsolutePath = True
	bbs.Overwrite = False

	pin = bbs("pin")
	
	if Trim(pin)="" then
		h_url = "/IFF_MAIN/Board/board/listRemarks.asp?tb=Remarks&page=" & page
		Response.Redirect "/IFF_MAIN/Board/inc/error.asp?no=11&h_url="&h_url

	else
	
	set allfile1 = bbs("allfile1")(1)
	if upload_form > 1 then set allfile2 = bbs("allfile2")(1)
	if upload_form > 2 then set allfile3 = bbs("allfile3")(1)
	if upload_form > 3 then set allfile4 = bbs("allfile4")(1)

	num = bbs("num")
	page = bbs("page")
	mode = bbs("mode")
	pin = bbs("pin")
	
%>

<script LANGUAGE="VBScript" RUNAT="Server">

Function CheckWord(CheckValue)

CheckValue = replace(CheckValue, "&" , "&amp;")
CheckValue = replace(CheckValue, "<", "&lt;")
CheckValue = replace(CheckValue, ">", "&gt;")
CheckValue = replace(CheckValue, "'", "''")

CheckWord=CheckValue

End Function

</script>

<%
	dim strext_error,strext_img
	
	strext_error = "asp,aspx,php,php3,php4,cgi,asa"
	strext_img = "jpg,jpeg,gif,pcx,bmp"
%>

<%
	dim temp_path,vDest
	temp_path = UCase(Server.MapPath("../../temp"))
	vDest=temp_path & "\Eltdata\" & elt_account_number & "\" & session("vOrgNum") & "\"
%>

<%
	' ABC 업로드 시작부분 1
	If allfile1<>"" Then '업로드할 파일이 있다면
		
		filesize1 = allfile1.Length '파일 사이즈
		if filesize1 < maxsize then
		
			filesize_ok = "ok"
			
			if bbs("oldfilename1")<>"" then
			
				Set fs = Server.CreateObject("Scripting.FileSystemObject")
				oldfilename1 = vDest&bbs("oldfilename1")		
				If fs.FileExists(oldfilename1) then
					fs.DeleteFile(oldfilename1)
				End if
				set fs = nothing
			end if
			
			Set fs = Server.CreateObject("Scripting.FileSystemObject")
			up_dir = vDest				
			filename1 = allfile1.SafeFileName							
			strname = mid(filename1, 1 , instrrev(filename1,".")-1)	
			strext = allfile1.RawFileType							
			strext = Lcase(strext)
			
			if Instr(strext_error,right(Lcase(strext),3)) > 0 Then
				h_url = "/IFF_MAIN/Board/board/listRemarks.asp?tb=Remarks&page=" & page			
				Response.Redirect "/IFF_MAIN/Board/inc/error.asp?no=12&strext="&strext&"&h_url="&h_url
			End if
			
			if Instr(strext_img,right(Lcase(strext),3)) > 0 then
				i_w1 = allfile1.imagewidth
				i_h1 = allfile1.imageheight
			else
				i_w1 = 0
				i_h1 = 0
			End if		
			
			strfilename1 = up_dir & filename1
			fexist =true		'우선 같은이름의 파일이 존재한다고 가정한다.
			count = 0			'파일이 존재할 경우, 이름 뒤에 붙일 숫자를 세팅한다.
 
			Do while fexist		'우선 같은 파일이 있다고 생각한다.
				if (fs.fileexists(strfilename1)) then		'같은 이름의 파일이 있을때
					count = count + 1						'파일명에 숫자를 붙일 새로운 파일 이름 생성
					filename1 = strname & "("& count &")."&strext
					strfilename1 = up_dir & filename1
				else										'같은 이름의 파일이 없을때	
					fexist = false
				end if
			loop	


			allfile1.Save Strfilename1			'파일을 저장한다.

			Set fs=Nothing  

		Else
			h_url = "/IFF_MAIN/Board/board/listRemarks.asp?tb=Remarks&page=" & page			
			Response.Redirect "/IFF_MAIN/Board/inc/error.asp?no=10&h_url="&h_url		
		end if
		
	else
	
		if mode <> "edit" then
			filename1=""
			filesize1=""
			i_w1 = 0
			i_h1 = 0
		else
			if bbs("del_file1") = "1" then
				Set fs = Server.CreateObject("Scripting.FileSystemObject")
				oldfilename1 = vDest&bbs("oldfilename1")	
				If fs.FileExists(oldfilename1) then
				fs.DeleteFile(oldfilename1)
				End if
				set fs = nothing
				filename1=""
				filesize1=""
				i_w1 = 0
				i_h1 = 0
			else
				filename1=bbs("oldfilename1")
				filesize1=bbs("oldfilesize1")
				i_w1 = bbs("i_w1")
				i_h1 = bbs("i_h1")
			end if
		end if
	end if

	' ABC 업로드 끝부분
%>

<%
	' ABC 업로드 시작부분 2
	If allfile2<>"" Then '업로드할 파일이 있다면
		
		filesize2 = allfile2.Length '파일 사이즈
		
		if filesize2 < maxsize then
		
			filesize_ok = "ok"
			
		
			if bbs("oldfilename2")<>"" then
			
				Set fs = Server.CreateObject("Scripting.FileSystemObject")
				oldfilename2= vDest&bbs("oldfilename2")	
				If fs.FileExists(oldfilename2) then
				fs.DeleteFile(oldfilename2)
				End if
				set fs = nothing
			end if
			
			Set fs = Server.CreateObject("Scripting.FileSystemObject")
			up_dir = vDest
			filename2 = allfile2.SafeFileName							'파일이름을 구한다.
			strname = mid(filename2, 1 , instrrev(filename2,".")-1)	'파일명을 구한다.
			strext = allfile2.RawFileType							'파일의 확장자를 구한다.
			
			if Instr(strext_error,right(Lcase(strext),3)) > 0 then
					h_url = "/IFF_MAIN/Board/board/listRemarks.asp?tb=Remarks&page=" & page			
					Response.Redirect "/IFF_MAIN/Board/inc/error.asp?no=12&strext="&strext&"&h_url="&h_url	
			End if
			
			if Instr(strext_img,right(Lcase(strext),3)) > 0 then
				i_w2 = allfile2.imagewidth
				i_h2 = allfile2.imageheight
			else
				i_w2 = 0
				i_h2 = 0
			End if	
			
			strfilename2 = up_dir & filename2
			fexist =true		'우선 같은이름의 파일이 존재한다고 가정한다.
			count = 0			'파일이 존재할 경우, 이름 뒤에 붙일 숫자를 세팅한다.
 
			Do while fexist		'우선 같은 파일이 있다고 생각한다.
				if (fs.fileexists(strfilename2)) then		'같은 이름의 파일이 있을때
					count = count + 1						'파일명에 숫자를 붙일 새로운 파일 이름 생성
					filename2 = strname & "("& count &")."&strext
					strfilename2 = up_dir & filename2
				else										'같은 이름의 파일이 없을때	
					fexist = false
				end if
			loop	


			allfile2.Save Strfilename2			'파일을 저장한다.

			Set fs=Nothing  

		Else
			h_url = "/IFF_MAIN/Board/board/listRemarks.asp?tb=Remarks&page=" & page			
			Response.Redirect "/IFF_MAIN/Board/inc/error.asp?no=10&h_url="&h_url	
		end if
		
	else
	
		if mode <> "edit" then
			filename2=""
			filesize2=""
			i_w2 = 0
			i_h2 = 0
		else
			if bbs("del_file2") = "1" then
				Set fs = Server.CreateObject("Scripting.FileSystemObject")
				oldfilename2= vDest&bbs("oldfilename2")	
			If fs.FileExists(oldfilename2) then				
				fs.DeleteFile(oldfilename2)
			End if
				set fs = nothing
				filename2=""
				filesize2=""
				i_w2 = 0
				i_h2 = 0
			else
				filename2=bbs("oldfilename2")
				filesize2=bbs("oldfilesize2")
				i_w2 = bbs("i_w2")
				i_h2 = bbs("i_h2")
			end if
		end if
	end if

	' ABC 업로드 끝부분
%>

<%
	' ABC 업로드 시작부분 3
	If allfile3<>"" Then '업로드할 파일이 있다면
		
		filesize3 = allfile3.Length '파일 사이즈
		
		if filesize3 < maxsize then
		
			filesize_ok = "ok"

		
			if bbs("oldfilename3")<>"" then
			
				Set fs = Server.CreateObject("Scripting.FileSystemObject")
				oldfilename3= vDest&bbs("oldfilename3")	
			If fs.FileExists(oldfilename3) then				
				fs.DeleteFile(oldfilename3)
			End if
				set fs = nothing
			end if
			
			Set fs = Server.CreateObject("Scripting.FileSystemObject")
			up_dir = vDest
			filename3 = allfile3.SafeFileName							'파일이름을 구한다.
			strname = mid(filename3, 1 , instrrev(filename3,".")-1)	'파일명을 구한다.
			strext = allfile3.RawFileType							'파일의 확장자를 구한다.
			
			if Instr(strext_error,right(Lcase(strext),3)) > 0 then
				h_url = "/IFF_MAIN/Board/board/listRemarks.asp?tb=Remarks&page=" & page			
				Response.Redirect "/IFF_MAIN/Borad/inc/error.asp?no=12&strext="&strext&"&h_url="&h_url
			End if
			
			if Instr(strext_img,right(Lcase(strext),3)) > 0 then
				i_w3 = allfile3.imagewidth
				i_h3 = allfile3.imageheight
			else
				i_w3 = 0
				i_h3 = 0
			End if
			
			strfilename3 = up_dir & filename3
			fexist =true		'우선 같은이름의 파일이 존재한다고 가정한다.
			count = 0			'파일이 존재할 경우, 이름 뒤에 붙일 숫자를 세팅한다.
 
			Do while fexist		'우선 같은 파일이 있다고 생각한다.
				if (fs.fileexists(strfilename3)) then		'같은 이름의 파일이 있을때
					count = count + 1						'파일명에 숫자를 붙일 새로운 파일 이름 생성
					filename3 = strname & "("& count &")."&strext
					strfilename3 = up_dir & filename3
				else										'같은 이름의 파일이 없을때	
					fexist = false
				end if
			loop	


			allfile3.Save Strfilename3			'파일을 저장한다.

			Set fs=Nothing  

		Else
			h_url = "/IFF_MAIN/Board/board/listRemarks.asp?tb=Remarks&page=" & page			
			Response.Redirect "/IFF_MAIN/Borad/inc/error.asp?no=10&h_url="&h_url
		end if
		
	else
		
		if mode <> "edit" then
			filename3=""
			filesize3=""
			i_w3 = 0
			i_h3 = 0
		else
			if bbs("del_file3") = "1" then
				Set fs = Server.CreateObject("Scripting.FileSystemObject")
				oldfilename3= vDest&bbs("oldfilename3")	
				If fs.FileExists(oldfilename3) then				
					fs.DeleteFile(oldfilename3)
				End if
				set fs = nothing
				filename3=""
				filesize3=""
				i_w3 = 0
				i_h3 = 0
			else
				filename3=bbs("oldfilename3")
				filesize3=bbs("oldfilesize3")
				i_w3 = bbs("i_w3")
				i_h3 = bbs("i_h3")
			end if
		end if
	end if

	' ABC 업로드 끝부분
%>

<%
	' ABC 업로드 시작부분 4
	If allfile4<>"" Then '업로드할 파일이 있다면
		
		filesize4 = allfile4.Length '파일 사이즈
		
		if filesize4 < maxsize then
		
			filesize_ok = "ok"
			
		
			if bbs("oldfilename4")<>"" then
			
				Set fs = Server.CreateObject("Scripting.FileSystemObject")
				oldfilename4= vDest&bbs("oldfilename4")	
			If fs.FileExists(oldfilename4) then				
				fs.DeleteFile(oldfilename4)
			End if
				set fs = nothing
			end if
			
			Set fs = Server.CreateObject("Scripting.FileSystemObject")
			up_dir = vDest
			filename4 = allfile4.SafeFileName							'파일이름을 구한다.
			strname = mid(filename4, 1 , instrrev(filename4,".")-1)	'파일명을 구한다.
			strext = allfile4.RawFileType							'파일의 확장자를 구한다.
			
			if Instr(strext_error,right(Lcase(strext),3)) > 0 Then
				h_url = "/IFF_MAIN/Board/board/listRemarks.asp?tb=Remarks&page=" & page			
				Response.Redirect "/IFF_MAIN/Borad/inc/error.asp?no=12&strext="&strext&"&h_url="&h_url
			End if
			
			if Instr(strext_img,right(Lcase(strext),3)) > 0 then
				i_w4 = allfile4.imagewidth
				i_h4 = allfile4.imageheight
			else
				i_w4 = 0
				i_h4 = 0
			End if
			
			strfilename4 = up_dir & filename4
			fexist =true		'우선 같은이름의 파일이 존재한다고 가정한다.
			count = 0			'파일이 존재할 경우, 이름 뒤에 붙일 숫자를 세팅한다.
 
			Do while fexist		'우선 같은 파일이 있다고 생각한다.
				if (fs.fileexists(strfilename4)) then		'같은 이름의 파일이 있을때
					count = count + 1						'파일명에 숫자를 붙일 새로운 파일 이름 생성
					filename4 = strname & "("& count &")."&strext
					strfilename4 = up_dir & filename4
				else										'같은 이름의 파일이 없을때	
					fexist = false
				end if
			loop	


			allfile4.Save Strfilename4			'파일을 저장한다.

			Set fs=Nothing  

		else
			h_url = "/IFF_MAIN/Board/board/listRemarks.asp?tb=Remarks&page=" & page			
			Response.Redirect "/IFF_MAIN/Borad/inc/error.asp?no=10&h_url="&h_url
		end if
		
	else
	
		if mode <> "edit" then
			filename4=""
			filesize4=""
			i_w4 = 0
			i_h4 = 0
		else
			if bbs("del_file4") = "1" then
				Set fs = Server.CreateObject("Scripting.FileSystemObject")
				oldfilename4= vDest&bbs("oldfilename4")	
			If fs.FileExists(oldfilename4) then				
				fs.DeleteFile(oldfilename4)
			End if
				set fs = nothing
				filename4=""
				filesize4=""
				i_w4 = 0
				i_h4 = 0
			else
				filename4=bbs("oldfilename4")
				filesize4=bbs("oldfilesize4")
				i_w4 = bbs("i_w4")
				i_h4 = bbs("i_h4")
			end if
		end if
	end if

	' ABC 업로드 끝부분
%>


<%
	if not(allfile1<>"") or not(allfile2<>"") or not(allfile3<>"") or not(allfile4<>"") or filesize_ok="ok" then
	
	
			
	name = Trim(bbs("name"))
	name = checkword(name)

	if name = "" then
		name = "none"
	end if
	
	title = Trim(bbs("title"))
	title = checkword(title)

	if title = "" then
		title = "Untitled"
	end if
	
	email = Trim(bbs("email"))
	email = CheckWord(email)
	
	url = Trim(bbs("url"))
	if left(url,7) = "http://" then
		url = mid(url,8)
	end if
	
	link_1 = Trim(bbs("link_1"))
	if left(link_1,7) = "http://" then
		link_1 = mid(link_1,8)
	end if
	link_2 = Trim(bbs("link_2"))
	if left(link_2,7) = "http://" then
		link_2 = mid(link_2,8)
	end if
		
	content = checkword(bbs("content"))
		
	ip = session_ip
	
	notice = bbs("notice")

	if mode <> "edit" then
		if notice = "1" then
	SQL="SELECT MAX(num) FROM "&tb&" where num > 100000000" & " and elt_account_number = " & elt_account_number & " and org_account_number= " & session("vOrgNum")
			Set rs = db.Execute(SQL)
	
			if IsNULL(rs(0)) then
				num = 100000001
			else
				num = rs(0)+1
			end if

		else
		
			SQL="SELECT MAX(num) FROM "&tb&" where num < 100000000" & " and elt_account_number = " & elt_account_number & " and org_account_number= " & session("vOrgNum")
			Set rs = db.Execute(SQL)
	
			if IsNULL(rs(0)) then
				num = 1
			else
				num = rs(0)+1
			end if

		end if
		rs.close
		Set rs = nothing
	end if
	
	tag = bbs("tag")
	secret = bbs("secret")
	if secret = "1" then
		secret_pin = bbs("secret_pin")
	elseif secret = "2" then
		secret_pin = pin
	end if 
	
	reply_mail = bbs("reply_mail")
			
	writeday = now()

  	dim o_email,o_title,re,resame,reid,reid2,newreid,newresame
  	
  	if mode = "reply" then
		
	SQL = "SELECT email,title,re,resame,reid,reply_mail FROM "&tb&" where num="&bbs("num") & " and elt_account_number = " & elt_account_number & " and org_account_number= " & session("vOrgNum")

	Set rs = db.Execute(SQL)
	
	o_email = rs("email")
	o_title = rs("title")
	re = rs("re")
    resame = rs("resame")
    reid = rs("reid")
    reply_mail = rs("reply_mail")
    
	SQL = "SELECT * FROM "&tb&" where elt_account_number = " & elt_account_number & " and org_account_number= " & session("vOrgNum") & " and re="& re &" and reid>"& reid &" and resame <= "& resame &" order by reid"
	Set rs = db.Execute(SQL)
	if rs.BOF or rs.EOF then
		SQL = "SELECT * FROM "&tb&" where elt_account_number = " & elt_account_number & " and org_account_number= " & session("vOrgNum") & " and re="& re &" and reid > "& reid &" and resame > "& resame &" order by reid DESC"
	else
		reid2 = rs("reid")

		SQL = "SELECT * FROM "&tb&" where elt_account_number = " & elt_account_number & " and org_account_number= " & session("vOrgNum") & " and re="& re &" and reid > "& reid &" and reid< " & reid2 & " and resame > " & resame & " order by reid DESC"
    end if

	Set rs = db.Execute(SQL)

	if not (rs.BOF or rs.EOF) then
		reid= rs("reid")
    end if
    
    SQL="UPDATE "&tb&" SET reid = reid + 1 where elt_account_number = " & elt_account_number & " and org_account_number= " & session("vOrgNum") & " and  re = "& re & " and reid > " & reid
	db.Execute(SQL)
	
	newreid = reid + 1
	newresame = resame + 1
	
	if reply_mail = 1 then
		call reply_email
	end if
	
	else
	
	re = num
	newresame = 0
	newreid = 0
	
	end if
	'답변처리부분 끝
	
	call process_write_remarks
	
	db.close
	Set db = nothing
	if bbs("sw") <> "" then
		Response.Redirect "listRemarks.asp?tb="&tb&"&page="&page&"&st="&bbs("st")&"&sc="&bbs("sc")&"&sn="&bbs("sn")&"&sw="&bbs("sw")
	else
		Response.Redirect "listRemarks.asp?tb="&tb&"&page="&page
	end if
	Set bbs = nothing
	end if

%>

<%
sub process_write_remarks 


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

	SQL = "INSERT INTO "&tb&" (num,elt_account_number,org_account_number,id,name,email,url,title,content,pin,secret_pin,writeday,ip,link_1,link_2,filename1,filesize1,filename2,filesize2,filename3,filesize3,filename4,filesize4,down1,down2,down3,down4,visit,reco,re,resame,reid,notice,tag,secret,reply_mail,i_width1,i_height1,i_width2,i_height2,i_width3,i_height3,i_width4,i_height4,mem_auth) VALUES "
	SQL = SQL & "(" & num & ""
	SQL = SQL & ",'" & elt_account_number & "'"
	SQL = SQL & "," & session("vOrgNum")
	SQL = SQL & ",N'" & session_uid & "'"
	SQL = SQL & ",N'" & session_login_name & "'"
	SQL = SQL & ",N'" & email & "'"
	SQL = SQL & ",N'" & url & "'"
	SQL = SQL & ",N'" & title & "'"
	SQL = SQL & ",N'" & content & "'"
	SQL = SQL & ",N'" & pin & "'"
	SQL = SQL & ",N'" & secret_pin & "'"
	SQL = SQL & ",N'" & writeday & "'"
	SQL = SQL & ",N'" & ip & "'"
	SQL = SQL & ",N'" & link_1 & "'"
	SQL = SQL & ",N'" & link_2 & "'"
	SQL = SQL & ",N'" & filename1 &"'"
	SQL = SQL & ",N'" & filesize1 & "'"
	SQL = SQL & ",N'" & filename2 & "'"
	SQL = SQL & ",N'" & filesize2 & "'"
	SQL = SQL & ",N'" & filename3 & "'"
	SQL = SQL & ",N'" & filesize3 & "'"
	SQL = SQL & ",N'" & filename4 & "'"
	SQL = SQL & ",N'" & filesize4 & "'"
	SQL = SQL & "," & 0 & ""
	SQL = SQL & "," & 0 & ""
	SQL = SQL & "," & 0 & ""
	SQL = SQL & "," & 0 & ""
	SQL = SQL & "," & 0 & ""
	SQL = SQL & "," & 0 & ""
	SQL = SQL & ",N'" & re & "'"
	SQL = SQL & ",N'" & newresame & "'"
	SQL = SQL & ",N'" & newreid & "'"
	SQL = SQL & ",N'" & notice & "'"
	SQL = SQL & ",N'" & tag & "'"
	SQL = SQL & ",N'" & secret & "'"
	SQL = SQL & ",N'" & reply_mail & "'"
	SQL = SQL & "," & i_w1 & ""
	SQL = SQL & "," & i_h1 & ""
	SQL = SQL & "," & i_w2 & ""
	SQL = SQL & "," & i_h2 & ""
	SQL = SQL & "," & i_w3 & ""
	SQL = SQL & "," & i_h3 & ""
	SQL = SQL & "," & i_w4 & ""
	SQL = SQL & "," & i_h4 & ""
	SQL = SQL & ",N'" & mem_auth & "')"
	
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
	SQL = SQL & " where num = " & num & " and elt_account_number=" & elt_account_number & " and org_account_number= " & session("vOrgNum")
	db.Execute SQL
	end if		

end sub
%>
<% end if %>
