<% Option Explicit %>
<% response.buffer = true %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<% if session_admin <> "admin" then Response.Redirect "../inc/error.asp?no=1" %>

<%

	dim folder_url,folder,fs,fso
	dim num,createsql
	
	tb_name = Request.Form("tb_name")

	board_type = Request.Form("board_type")
	gallery_type = Request.Form("gallery_type")
	upload_type = Request.Form("upload_type")
	upload_form = Request.Form("upload_form")
	content_type = Request.Form("content_type")
	maxsize = Request.Form("maxsize")
	board_size = Request.Form("board_size")
	if board_size < 101 then
		board_size = board_size&"%"
	end if
	bgcolor = Request.Form("bgcolor")
	tb_bgcolor = Request.Form("tb_bgcolor")
	tr_chcolor = Request.Form("tr_chcolor")
	board_title = Request.Form("board_title")
	top_file = Request.Form("top_file")
	top_board = Request.Form("top_board")
	top_board = replace(top_board, "'", "''")
	bottom_board = Request.Form("bottom_board")
	bottom_board = replace(bottom_board, "'", "''")
	down_file = Request.Form("down_file")
	use_smtp = Request.Form("use_smtp")
	use_reco = Request.Form("use_reco")
	use_cookies = Request.Form("use_cookies")
	
	pagesize = Request.Form("pagesize")
	block = Request.Form("block")
	len_title = Request.Form("len_title")
	new_title = Request.Form("new_title")
	nt_img = Request.Form("nt_img")
	nt_tr = Request.Form("nt_tr")
	nt_color = Request.Form("nt_color")
	view_reco = Request.Form("view_reco")
	view_upload = Request.Form("view_upload")
	
	relation = Request.Form("relation")
	view_ip = Request.Form("view_ip")
	view_img = Request.Form("view_img")
	view_multi = Request.Form("view_multi")
	use_comment = Request.Form("use_comment")

	l_level = Request.Form("l_level")
	r_level = Request.Form("r_level")
	w_level = Request.Form("w_level")
	cw_level = Request.Form("cw_level")
	nw_level = Request.Form("nw_level")
	rw_level = Request.Form("rw_level")
	
	if use_smtp<>"" then
		use_smtp=1
	else
		use_smtp=0
	end if
	
	if use_reco<>"" then
		use_reco=1
	else
		use_reco=0
	end if
	
	if use_cookies<>"" then
'		use_cookies=1 // by ig
		use_cookies=0 
	else
		use_cookies=0
	end if
	
	if nt_img<>"" then
		nt_img=1
	else
		nt_img=0
	end if
	
	if nt_tr<>"" then
		nt_tr=1
	else
		nt_tr=0
	end if
	
	if view_reco<>"" then
		view_reco=1
	else
		view_reco=0
	end if
		
	if view_upload<>"" then
		view_upload=1
	else
		view_upload=0
	end if
		
	if view_ip<>"" then
		view_ip=1
	else
		view_ip=0
	end if
	
	if view_img<>"" then
		view_img=1
	else
		view_img=0
	end if
	
	if view_multi<>"" then
		view_multi=1
	else
		view_multi=0
	end if
		
	if use_comment<>"" then
		use_comment=1
	else
		use_comment=0
	end if
	
	if Request.Form("mode")<>"edit" then
	
	SQL="SELECT MAX(num) FROM inno_admin"
	Set rs = db.Execute(SQL)
	
	if IsNULL(rs(0)) then
		num = 1
	else
		num = rs(0)+1
	end if
	
	tb = "inno_"& num
	
	

	folder_url = Request("PATH_TRANSLATED")
	folder_url = left(folder_url, InStrRev(folder_url, "\admin\")) & "files\"
	folder = folder_url&tb
	
	Set fs = CreateObject("Scripting.FileSystemObject")
	if not (fs.FolderExists(folder_url)) Then
		Set fso = fs.CreateFolder(folder_url)
	end if
	
	If not (fs.FolderExists(folder)) Then
		Set fso = fs.CreateFolder(folder)
	end if
	
	SQL = "INSERT INTO inno_admin (num,tb,tb_name,board_type,gallery_type,upload_type,upload_form,content_type,maxsize,board_size,bgcolor,tb_bgcolor,tr_chcolor,board_title,top_file,top_board,bottom_board,down_file,use_smtp,use_reco,use_cookies,pagesize,block,len_title,new_title,nt_img,nt_tr,nt_color,view_reco,view_upload,relation,view_ip,view_img,view_multi,use_comment,l_level,r_level,w_level,cw_level,nw_level,rw_level) VALUES "
	SQL = SQL & "(" & num & ""
	SQL = SQL & ",'" & tb & "'"
	SQL = SQL & ",'" & tb_name & "'"
	SQL = SQL & "," & board_type & ""
	SQL = SQL & ",'" & gallery_type & "'"
	SQL = SQL & ",'" & upload_type & "'"
	SQL = SQL & "," & upload_form & ""
	SQL = SQL & "," & content_type & ""
	SQL = SQL & "," & maxsize & ""
	SQL = SQL & ",'" & board_size & "'"
	SQL = SQL & ",'" & bgcolor & "'"
	SQL = SQL & ",'" & tb_bgcolor & "'"
	SQL = SQL & ",'" & tr_chcolor & "'"
	SQL = SQL & ",'" & board_title & "'"
	SQL = SQL & ",'" & top_file & "'"
	SQL = SQL & ",'" & top_board & "'"
	SQL = SQL & ",'" & bottom_board & "'"
	SQL = SQL & ",'" & down_file & "'"
	SQL = SQL & "," & use_smtp & ""
	SQL = SQL & "," & use_reco & ""
	SQL = SQL & "," & use_cookies & ""
	SQL = SQL & "," & pagesize & ""
	SQL = SQL & "," & block & ""
	SQL = SQL & "," & len_title & ""
	SQL = SQL & "," & new_title & ""
	SQL = SQL & "," & nt_img & ""
	SQL = SQL & "," & nt_tr & ""
	SQL = SQL & ",'" & nt_color & "'"
	SQL = SQL & "," & view_reco & ""
	SQL = SQL & "," & view_upload & ""
	SQL = SQL & "," & relation & ""
	SQL = SQL & "," & view_ip & ""
	SQL = SQL & "," & view_img & ""
	SQL = SQL & "," & view_multi & ""
	SQL = SQL & "," & use_comment & ""
	SQL = SQL & "," & l_level & ""
	SQL = SQL & "," & r_level & ""
	SQL = SQL & "," & w_level & ""
	SQL = SQL & "," & cw_level & ""
	SQL = SQL & "," & nw_level & ""
	SQL = SQL & "," & rw_level & ")"
	db.Execute SQL
	
	
	CREATESQL = "Create table [dbo].["&tb&"]"
	CREATESQL = CREATESQL & " (num				int NOT NULL ,"
	CREATESQL = CREATESQL & "  elt_account_number	[decimal](8, 0) NOT NULL ,"
	CREATESQL = CREATESQL & "  id				varchar(50) NOT NULL,"
	CREATESQL = CREATESQL & "  name				varchar(50) NOT NULL,"
	CREATESQL = CREATESQL & "  email			varchar(50)  NULL,"
	CREATESQL = CREATESQL & "  url				varchar(50)  NULL,"
	CREATESQL = CREATESQL & "  title			varchar(250) NOT NULL,"
	CREATESQL = CREATESQL & "  pin				varchar(20) NOT NULL,"
	CREATESQL = CREATESQL & "  secret_pin		varchar(20) NULL,"
	CREATESQL = CREATESQL & "  writeday			varchar(30) NOT NULL,"
	CREATESQL = CREATESQL & "  ip				varchar(64) NOT NULL,"
	CREATESQL = CREATESQL & "  link_1			varchar(250)  NULL,"
	CREATESQL = CREATESQL & "  link_2			varchar(250)  NULL,"
	CREATESQL = CREATESQL & "  filename1		varchar(150)  NULL,"
	CREATESQL = CREATESQL & "  filesize1		varchar(150)  NULL,"
	CREATESQL = CREATESQL & "  filename2		varchar(150)  NULL,"
	CREATESQL = CREATESQL & "  filesize2		varchar(150)  NULL,"
	CREATESQL = CREATESQL & "  filename3		varchar(150)  NULL,"
	CREATESQL = CREATESQL & "  filesize3		varchar(150)  NULL,"
	CREATESQL = CREATESQL & "  filename4		varchar(150)  NULL,"
	CREATESQL = CREATESQL & "  filesize4		varchar(150)  NULL,"
	CREATESQL = CREATESQL & "  down1			int NULL,"
	CREATESQL = CREATESQL & "  down2			int NULL,"
	CREATESQL = CREATESQL & "  down3			int NULL,"
	CREATESQL = CREATESQL & "  down4			int NULL,"
	CREATESQL = CREATESQL & "  visit			int NOT NULL,"
	CREATESQL = CREATESQL & "  reco				int NULL,"
	CREATESQL = CREATESQL & "  re				int NULL,"
	CREATESQL = CREATESQL & "  resame			int NULL,"
	CREATESQL = CREATESQL & "  reid				int NULL,"
	CREATESQL = CREATESQL & "  notice			int NULL,"
	CREATESQL = CREATESQL & "  tag				int NULL,"
	CREATESQL = CREATESQL & "  secret			int NULL,"
	CREATESQL = CREATESQL & "  reply_mail		int NULL,"
	CREATESQL = CREATESQL & "  mem_auth			int NULL,"
	CREATESQL = CREATESQL & "  i_width1			int NULL,"
	CREATESQL = CREATESQL & "  i_height1		int NULL,"
	CREATESQL = CREATESQL & "  i_width2			int NULL,"
	CREATESQL = CREATESQL & "  i_height2		int NULL,"
	CREATESQL = CREATESQL & "  i_width3			int NULL,"
	CREATESQL = CREATESQL & "  i_height3		int NULL,"
	CREATESQL = CREATESQL & "  i_width4			int NULL,"
	CREATESQL = CREATESQL & "  i_height4		int NULL,"
	CREATESQL = CREATESQL & "  content			ntext NULL )"

	db.Execute CREATESQL
	
	else
	
	tb = Request.Form("tb")
	
	SQL = "Update inno_admin set tb_name = '" & tb_name & "'"
	SQL = SQL & ", board_type = " & board_type & ""
	SQL = SQL & ", gallery_type = '" & gallery_type & "'"
	SQL = SQL & ", upload_type = '" & upload_type & "'"
	SQL = SQL & ", upload_form = " & upload_form & ""
	SQL = SQL & ", content_type = " & content_type & ""
	SQL = SQL & ", maxsize = " & maxsize & ""
	SQL = SQL & ", board_size = '" & board_size & "'"
	SQL = SQL & ", bgcolor = '" & bgcolor & "'"
	SQL = SQL & ", tb_bgcolor = '" & tb_bgcolor & "'"
	SQL = SQL & ", tr_chcolor = '" & tr_chcolor & "'"
	SQL = SQL & ", board_title = '" & board_title & "'"
	SQL = SQL & ", top_file = '" & top_file & "'"
	SQL = SQL & ", top_board = '" & top_board & "'"	
	SQL = SQL & ", bottom_board = '" & bottom_board & "'"
	SQL = SQL & ", down_file = '" & down_file & "'"
	SQL = SQL & ", use_smtp = " & use_smtp & ""
	SQL = SQL & ", use_reco = " & use_reco & ""
	SQL = SQL & ", use_cookies = " & use_cookies & ""
	SQL = SQL & ", pagesize = " & pagesize & ""
	SQL = SQL & ", block = " & block & ""
	SQL = SQL & ", len_title = " & len_title & ""
	SQL = SQL & ", new_title = " & new_title & ""
	SQL = SQL & ", nt_img = '" & nt_img & "'"
	SQL = SQL & ", nt_tr = " & nt_tr & ""
	SQL = SQL & ", nt_color = '" & nt_color & "'"
	SQL = SQL & ", view_reco = " & view_reco & ""
	SQL = SQL & ", view_upload = " & view_upload & ""
	SQL = SQL & ", relation = " & relation & ""
	SQL = SQL & ", view_ip = " & view_ip & ""
	SQL = SQL & ", view_img = " & view_img & ""
	SQL = SQL & ", view_multi = " & view_multi & ""
	SQL = SQL & ", use_comment = " & use_comment & ""
	SQL = SQL & ", l_level = " & l_level & ""
	SQL = SQL & ", r_level = " & r_level & ""
	SQL = SQL & ", w_level = " & w_level & ""
	SQL = SQL & ", cw_level = " & cw_level & ""
	SQL = SQL & ", nw_level = " & nw_level & ""
	SQL = SQL & ", rw_level = " & rw_level & ""
	SQL = SQL & " where tb = '"&tb&"'"
	db.Execute SQL
		
	end if
	
	if Request.QueryString("fromCP") = "Y" then 
	   dim id
	   id=Request.QueryString("agentId")
	   Response.Redirect("../../SystemAdmin/sad.aspx?id="& id & "&tb=" & tb )
	    
	end if 
	Response.Redirect "tb_list.asp?tb="&tb
	
%>