<% Option Explicit %>
<% response.buffer = true %>

 



<!-- #include file="../inc/dbinfo.asp" -->

<%
	dim bbs,num,pin,mode
	dim allfile,allfile1,allfile2,allfile3,allfile4,test
	dim name,title,email,url,secret_pin,link_1,link_2,ip,notice,tag,secret,reply_mail,writeday,mem_auth
	dim filesize1,filesize_ok,fs,strname,strext,strext_1,strfilename1,aname1,filename1,oldfilename1
	dim filesize2,strfilename2,aname2,filename2,oldfilename2
	dim filesize3,strfilename3,aname3,filename3,oldfilename3
	dim filesize4,strfilename4,aname4,filename4,oldfilename4
	dim i_width1,i_height1,i_width2,i_height2,i_width3,i_height3,i_width4,i_height4
	
	
	
	Set bbs = Server.CreateObject("DEXT.FileUpload")
	tb = bbs("tb")
%>

<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->

<%
	Set Rs = db.Execute("Select maxsize From inno_admin Where tb='"&tb&"'")
		maxsize = Rs(0)*1024
	Rs.Close
	
	bbs.DefaultPath = Server.MapPath("..")&"\files\"&tb&"\"
	bbs.UploadTimeout = 3600
	
	pin = bbs("pin")
	
	if Trim(pin)="" then

		Response.Redirect "../inc/error.asp?no=11"

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
	' DEXT 업로드 시작부분 1
	If allfile1<>"" Then '업로드할 파일이 있다면
		
		filesize1=allfile1.FileLen
		
		
		

		if filesize1 < maxsize then
		
			filesize_ok = "ok"
		
			if bbs("oldfilename1")<>"" then
			
				oldfilename1 = Server.MapPath("..")&"\files\"&tb&"\"&bbs("oldfilename1")		'앞에서 기존 파일을 불러와서..
				bbs.DeleteFile oldfilename1											'그 파일을 삭제한다.

			end if
			
			Set fs = Server.CreateObject("Scripting.FileSystemObject")
			filename1 = allfile1.FileName								'파일이름을 구한다.
			strname = mid(filename1, 1 , instrrev(filename1,".")-1)	'파일명을 구한다.
			strext = Lcase(Mid(filename1, InstrRev(filename1, ".") + 1))'확장자을 구한다.
			
			if Instr(strext_error,right(Lcase(strext),3)) > 0 then
				Response.Redirect "../inc/error.asp?no=12&strext="&strext	'위의 확장자를 가진 파일이 업로드 될경우 에러메세지 출력.
			End if
			
			if Instr(strext_img,right(Lcase(strext),3)) > 0 then
				i_w1 = allfile1.imagewidth
				i_h1 = allfile1.imageheight
			else
				i_w1 = 0
				i_h1 = 0
			End if		
			
			strfilename1 = bbs.DefaultPath & filename1


			aname1=bbs("allfile1").Saveas(strfilename1,false)

			
			filename1= Mid(aname1, InstrRev(aname1, "\") + 1)
			
			Set fs=Nothing  

		else
			Response.Redirect "../inc/error.asp?no=10"
		end if
		
	else
	
		if mode <> "edit" then
			filename1=""
			filesize1=""
			i_w1 = 0
			i_h1 = 0
		else
			if bbs("del_file1") = "1" then
				oldfilename1 = Server.MapPath("..")&"\files\"&tb&"\"&bbs("oldfilename1")		'앞에서 기존 파일을 불러와서..
				bbs.DeleteFile oldfilename1										'그 파일을 삭제한다.
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

	' DEXT 업로드 끝부분
%>
<%
	' DEXT 업로드 시작부분 2
	If allfile2<>"" Then '업로드할 파일이 있다면
		
		filesize2=allfile2.FileLen
		
		if filesize2 < maxsize then
		
			filesize_ok = "ok"
			
			if bbs("oldfilename2")<>"" then
			
				oldfilename2 = Server.MapPath("..")&"\files\"&tb&"\"&bbs("oldfilename2")		'앞에서 기존 파일을 불러와서..
				bbs.DeleteFile oldfilename2											'그 파일을 삭제한다.

			end if
		
			Set fs = Server.CreateObject("Scripting.FileSystemObject")
			bbs.DefaultPath = Server.MapPath("..")&"\files\"&tb&"\"				'파일이 저장될 경로
			filename2 = allfile2.FileName								'파일이름을 구한다.
			strname = mid(filename2, 1 , instrrev(filename2,".")-1)	'파일명을 구한다.
			strext = Lcase(Mid(filename2, InstrRev(filename2, ".") + 1))'확장자을 구한다.
			
			if Instr(strext_error,right(Lcase(strext),3)) > 0 then
				Response.Redirect "../inc/error.asp?no=12&strext="&strext	'위의 확장자를 가진 파일이 업로드 될경우 에러메세지 출력.
			End if
			
			if Instr(strext_img,right(Lcase(strext),3)) > 0 then
				i_w2 = allfile2.imagewidth
				i_h2 = allfile2.imageheight
			else
				i_w2 = 0
				i_h2 = 0
			End if	
			
			strfilename2 = bbs.DefaultPath & filename2


			aname2=bbs("allfile2").Saveas(strfilename2,false)

			
			filename2= Mid(aname2, InstrRev(aname2, "\") + 1)
			
			Set fs=Nothing  

		else
			Response.Redirect "../inc/error.asp?no=10"
		end if
		
	else
	
		if mode <> "edit" then
			filename2=""
			filesize2=""
			i_w2 = 0
			i_h2 = 0
		else
			if bbs("del_file2") = "1" then
				oldfilename2 = Server.MapPath("..")&"\files\"&tb&"\"&bbs("oldfilename2")		'앞에서 기존 파일을 불러와서..
				bbs.DeleteFile oldfilename2										'그 파일을 삭제한다.
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

	' DEXT 업로드 끝부분
%>
<%
	' DEXT 업로드 시작부분 3
	If allfile3<>"" Then '업로드할 파일이 있다면
		
		filesize3=allfile3.FileLen
		
		if filesize3 < maxsize then
		
			filesize_ok = "ok"
			
			if bbs("oldfilename3")<>"" then
			
				oldfilename3 = Server.MapPath("..")&"\files\"&tb&"\"&bbs("oldfilename3")		'앞에서 기존 파일을 불러와서..
				bbs.DeleteFile oldfilename3											'그 파일을 삭제한다.

			end if
		
			Set fs = Server.CreateObject("Scripting.FileSystemObject")
			bbs.DefaultPath = Server.MapPath("..")&"\files\"&tb&"\"				'파일이 저장될 경로
			filename3 = allfile3.FileName								'파일이름을 구한다.
			strname = mid(filename3, 1 , instrrev(filename3,".")-1)	'파일명을 구한다.
			strext = Lcase(Mid(filename3, InstrRev(filename3, ".") + 1))'확장자을 구한다.
			
			if Instr(strext_error,right(Lcase(strext),3)) > 0 then
				Response.Redirect "../inc/error.asp?no=12&strext="&strext	'위의 확장자를 가진 파일이 업로드 될경우 에러메세지 출력.
			End if
			
			if Instr(strext_img,right(Lcase(strext),3)) > 0 then
				i_w3 = allfile3.imagewidth
				i_h3 = allfile3.imageheight
			else
				i_w3 = 0
				i_h3 = 0
			End if	
			
			strfilename3 = bbs.DefaultPath & filename3


			aname3=bbs("allfile3").Saveas(strfilename3,false)

			
			filename3= Mid(aname3, InstrRev(aname3, "\") + 1)
			
			Set fs=Nothing  

		else
			Response.Redirect "../inc/error.asp?no=10"
		end if
		
	else
	
		if mode <> "edit" then
			filename3=""
			filesize3=""
			i_w3 = 0
			i_h3 = 0
		else
			if bbs("del_file3") = "1" then
				oldfilename3 = Server.MapPath("..")&"\files\"&tb&"\"&bbs("oldfilename3")		'앞에서 기존 파일을 불러와서..
				bbs.DeleteFile oldfilename3										'그 파일을 삭제한다.
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

	' DEXT 업로드 끝부분
%>
<%
	' DEXT 업로드 시작부분 4
	If allfile4<>"" Then '업로드할 파일이 있다면
		
		filesize4=allfile4.FileLen
		
		if filesize4 < maxsize then
		
			filesize_ok = "ok"
			
			if bbs("oldfilename4")<>"" then
			
				oldfilename4 = Server.MapPath("..")&"\files\"&tb&"\"&bbs("oldfilename4")		'앞에서 기존 파일을 불러와서..
				bbs.DeleteFile oldfilename4											'그 파일을 삭제한다.

			end if
		
			Set fs = Server.CreateObject("Scripting.FileSystemObject")
			bbs.DefaultPath = Server.MapPath("..")&"\files\"&tb&"\"				'파일이 저장될 경로
			filename4 = allfile4.FileName								'파일이름을 구한다.
			strname = mid(filename4, 1 , instrrev(filename4,".")-1)	'파일명을 구한다.
			strext = Lcase(Mid(filename4, InstrRev(filename4, ".") + 1))'확장자을 구한다.
			
			if Instr(strext_error,right(Lcase(strext),3)) > 0 then
				Response.Redirect "../inc/error.asp?no=12&strext="&strext	'위의 확장자를 가진 파일이 업로드 될경우 에러메세지 출력.
			End if
			
			if Instr(strext_img,right(Lcase(strext),3)) > 0 then
				i_w4 = allfile4.imagewidth
				i_h4 = allfile4.imageheight
			else
				i_w4 = 0
				i_h4 = 0
			End if	
			
			strfilename4 = bbs.DefaultPath & filename4


			aname4=bbs("allfile4").Saveas(strfilename4,false)

			
			filename4= Mid(aname4, InstrRev(aname4, "\") + 1)
			
			Set fs=Nothing  

		else
			Response.Redirect "../inc/error.asp?no=10"
		end if
		
	else
		
		if mode <> "edit" then
			filename4=""
			filesize4=""
			i_w4 = 0
			i_h4 = 0
		else
			if bbs("del_file4") = "1" then
				oldfilename4 = Server.MapPath("..")&"\files\"&tb&"\"&bbs("oldfilename4")		'앞에서 기존 파일을 불러와서..
				bbs.DeleteFile oldfilename4										'그 파일을 삭제한다.
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

	' DEXT 업로드 끝부분
	

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
		title = "제목이 없습니다."
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
			SQL="SELECT MAX(num) FROM "&tb&" where num > 100000000"
			Set rs = db.Execute(SQL)
	
			if IsNULL(rs(0)) then
				num = 100000001
			else
				num = rs(0)+1
			end if

		else
		
			SQL="SELECT MAX(num) FROM "&tb&" where num < 100000000"
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

	
	
		'답변처리부분
  	dim o_email,o_title,re,resame,reid,reid2,newreid,newresame
  	
  	if mode = "reply" then
		
	SQL = "SELECT email,title,re,resame,reid,reply_mail FROM "&tb&" where num="&bbs("num")
	Set rs = db.Execute(SQL)
	
	o_email = rs("email")
	o_title = rs("title")
	re = rs("re")
    resame = rs("resame")
    reid = rs("reid")
    reply_mail = rs("reply_mail")
    
	SQL = "SELECT * FROM "&tb&" where re="& re &" and reid>"& reid &" and resame <= "& resame &" order by reid"
	Set rs = db.Execute(SQL)
	
	if rs.BOF or rs.EOF then
		SQL = "SELECT * FROM "&tb&" where re="& re &" and reid > "& reid &" and resame > "& resame &" order by reid DESC"
	else
		reid2 = rs("reid")

		SQL = "SELECT * FROM "&tb&" where re="& re &" and reid > "& reid &" and reid< " & reid2 & " and resame > " & resame & " order by reid DESC"
    end if

	Set rs = db.Execute(SQL)

	if not (rs.BOF or rs.EOF) then
		reid= rs("reid")
    end if
    
    SQL="UPDATE "&tb&" SET reid = reid + 1 where re = "& re & " and reid > " & reid
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
	

	call process_write
	
	db.close
	Set db = nothing
	
	
	if bbs("sw") <> "" then
		Response.Redirect "list.asp?tb="&tb&"&page="&page&"&st="&bbs("st")&"&sc="&bbs("sc")&"&sn="&bbs("sn")&"&sw="&bbs("sw")
	else
		Response.Redirect "list.asp?tb="&tb&"&page="&page
	end if
	Set bbs = nothing
	end if

%>
<% end if %>

