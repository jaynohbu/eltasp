<% Option Explicit %>
<% response.buffer = true %>

 



<!-- #include file="../inc/dbinfo.asp" -->

<%
	dim tb,id,fs,filename1,up_dir
	
	if request.QueryString("mode") = "write" then	
	
	dim bbs,maxsize,allfile1,filesize1,filesize_ok,strname,strext,i_w1,i_h1,strfilename1,aname1,sql
	
	Response.Expires = -10000
	Server.ScriptTimeout = 3600

	Set bbs = Server.CreateObject("ABCUpload4.XForm")
	bbs.MaxUploadSize = 1024 * 1024 * 1000
	tb = bbs("tb")
	
	id = bbs("id")

	maxsize = 300000
	
	bbs.AbsolutePath = True
	bbs.Overwrite = true
	
	set allfile1 = bbs("allfile1")(1)
		
	dim strext_img
	
	strext_img = "gif"
	



	If allfile1<>"" Then '���ε��� ������ �ִٸ�
		
	filesize1=allfile1.Length '���� ������
	
		if filesize1 < maxsize then
		
			filesize_ok = "ok"
		
			Set fs = Server.CreateObject("Scripting.FileSystemObject")
			up_dir = Server.MapPath("..")&"\files\img_name\"			'������ ����� ���
			filename1 = allfile1.SafeFileName							'�����̸��� ���Ѵ�.
			strname = mid(filename1, 1 , instrrev(filename1,".")-1)	'���ϸ��� ���Ѵ�.
			strext = allfile1.RawFileType							'������ Ȯ���ڸ� ���Ѵ�.
			strext = Lcase(strext)
			
			if Instr(strext_img,right(Lcase(strext),3)) = 0 then
				Response.Redirect "../inc/error.asp?no=12&strext="&strext	'���� Ȯ���ڸ� ���� ������ ���ε� �ɰ�� �����޼��� ���.
			End if
			
			if Instr(strext_img,right(Lcase(strext),3)) > 0 then
				i_w1 = allfile1.imagewidth
				i_h1 = allfile1.imageheight
			
				if 80 < i_w1 then Response.Redirect "../inc/error.asp?no=13"
				if 18 < i_h1 then Response.Redirect "../inc/error.asp?no=14"
			End if		
			
			
			filename1 = id & "." & strext
			strfilename1 = up_dir & filename1

			allfile1.Save Strfilename1

			Set fs=Nothing  

		
			SQL = "Update member set name_img=1 where id='"&id&"'"
			db.execute SQL
		else
			Response.Redirect "../inc/error.asp?no=10"
		end if
		
		
		
	end if
		Set bbs=Nothing  
		
		response.Redirect "user_edit.asp?tb="&tb&"&id="&id&"&reload=write"	
	end if
	
	if request.QueryString("mode")="del" then
	
		tb=request.QueryString("tb")
		id=request.QueryString("id")
		
		Set fs = Server.CreateObject("Scripting.FileSystemObject")
			filename1 = Server.MapPath("..")&"\files\img_name\" & id & ".gif"
			If fs.FileExists(filename1) then
			fs.DeleteFile(filename1)
			End if
		set fs = Nothing
		
		SQL = "Update member set name_img=0 where id='"&id&"'"
		db.execute sql
	
	response.Redirect "user_edit.asp?tb="&tb&"&id="&id&"&reload=del"	
	end if 
	
	
%>
