<% Option Explicit %>
<% response.buffer = true %>
<% Response.Expires=-1 %>

 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/joint.asp" -->



<%
	dim tb,tb_name,board_type,gallery_type,upload_type,upload_form,content_type,maxsize,board_size,bgcolor,tb_bgcolor,tr_chcolor,board_title,top_file,top_board,bottom_board,down_file,use_smtp,use_reco,use_cookies
	dim pagesize,block,len_title,new_title,nt_img,nt_tr,nt_color,view_reco,view_upload,view_img,view_multi
	dim relation,view_ip,use_comment
	dim l_level,r_level,w_level,cw_level,nw_level,rw_level
	dim sql,rs
	dim mode,num
	dim board_name	
	
	dim agentId
	
	mode = Request.QueryString("mode")		
	tb_name = Request.QueryString("board_name")	
	agentId = Request.QueryString("agentId")
	
	if mode = "edit" then
	   
		
		tb = Request.QueryString("tb")
	
		SQL = "Select * From inno_admin Where tb='"&tb&"'"
		Set rs = db.Execute(SQL)
	
		tb_name = rs("tb_name")
		board_type = "1"
		gallery_type = rs("gallery_type")
		upload_type = rs("upload_type")
		upload_form = rs("upload_form")
		content_type = rs("content_type")
		maxsize = rs("maxsize")
		board_size = rs("board_size")
		if right(board_size,1) = "%" then
			board_size = left(board_size,len(board_size)-1)
		end if		
		bgcolor = rs("bgcolor")
		tb_bgcolor = rs("tb_bgcolor")
		tr_chcolor = rs("tr_chcolor")
		board_title = rs("board_title")
		top_file = rs("top_file")
		top_board = rs("top_board")
		bottom_board = rs("bottom_board")
		down_file = rs("down_file")
		use_smtp = rs("use_smtp")
		use_reco = rs("use_reco")
		use_cookies = rs("use_cookies")
		pagesize = rs("pagesize")
		block = rs("block")
		len_title = rs("len_title")
		new_title = rs("new_title")
		nt_img = rs("nt_img")
		nt_tr = rs("nt_tr")
		nt_color = rs("nt_color")
		view_reco = rs("view_reco")
		view_upload = rs("view_upload")
		view_img = rs("view_img")
		view_multi = rs("view_multi")
	
		relation = rs("relation")
		view_ip = rs("view_ip")
		use_comment = rs("use_comment")

		l_level = rs("l_level")
		r_level = rs("r_level")
		w_level = rs("w_level")
		cw_level = rs("cw_level")
		nw_level = rs("nw_level")
		rw_level = rs("rw_level")
	
	end if
%>

<html>
<head>
<title>�� Admin Page ��</title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">
<script language="javascript">
<!--

function submit()
{

	if (document.inno.tb_name.value == "") {
		alert("�Խ��� �̸��� �Է��� �ּ���.");
		document.inno.tb_name.focus();
		return;
	}

	if ((document.inno.board_type[1].checked == true || document.inno.board_type[2].checked == true || document.inno.board_type[3].checked == true) && document.inno.board_size.value < 100) {
		alert("�ڷ��, �ַ��� �� ������ ���̾�� �Խ��� ����� %�� ������ �̿��� �� �����ϴ�.\n�Խ��� ����� 150 �̻��� ���� �����ּ���.");
		document.inno.board_size.focus();
		return;
	}
	
	if (document.inno.maxsize.value == "") {
		alert("���ε� �뷮 ����ũ�⸦ �Է��� �ּ���.");
		document.inno.maxsize.focus();
		return;
	}
	
	if (document.inno.board_size.value == "") {
		alert("�Խ��� ����� �Է��� �ּ���.");
		document.inno.board_size.focus();
		return;
	}
	
	if (document.inno.bgcolor.value == "") {
		alert("������ ������ �Է��� �ּ���.");
		document.inno.bgcolor.focus();
		return;
	}
	
	if (document.inno.tb_bgcolor.value == "") {
		alert("�Խ��� ������ �Է��� �ּ���.");
		document.inno.tb_bgcolor.focus();
		return;
	}
	
	if (document.inno.tr_chcolor.value == "") {
		alert("��Ͽ� ���콺Ŀ���� �÷������ ���ϴ� ������ �Է��� �ּ���.");
		document.inno.tr_chcolor.focus();
		return;
	}
	
	if (document.inno.pagesize.value == "") {
		alert(" �Է��� �ּ���.");
		document.inno.pagesize.focus();
		return;
	}
	
	if (document.inno.block.value == "") {
		alert(" �Է��� �ּ���.");
		document.inno.block.focus();
		return;
	}
	
	if (document.inno.len_title.value == "") {
		alert(" �Է��� �ּ���.");
		document.inno.len_title.focus();
		return;
	}
	
	if (document.inno.new_title.value == "") {
		alert(" �Է��� �ּ���.");
		document.inno.new_title.focus();
		return;
	}
	
	if (document.inno.nt_tr.checked == true) {
		if (document.inno.nt_color.value == "") {
			alert(" �Է��� �ּ���.");
			document.inno.nt_color.focus();
			return;
		}
	}
	
	document.inno.submit();

}


function numcheck()
{
	if ((event.keyCode<48) || (event.keyCode>57))
	event.returnValue=false;
}

function box_open()
{ 
	document.all.upload1.style.display = ""
	document.all.upload11.style.display = ""
	document.all.upload2.style.display = ""
	document.all.upload22.style.display = ""
	document.all.upload3.style.display = ""
	document.all.upload33.style.display = ""
	document.all.upload4.style.display = "none"
	document.all.upload44.style.display = "none"
}

function box_open1()
{ 
	document.all.upload1.style.display = ""
	document.all.upload11.style.display = ""
	document.all.upload2.style.display = ""
	document.all.upload22.style.display = ""
	document.all.upload3.style.display = ""
	document.all.upload33.style.display = ""
	document.all.upload4.style.display = ""
	document.all.upload44.style.display = ""
}


function box_close()
{ 
	document.all.upload1.style.display = "none"
	document.all.upload11.style.display = "none"
	document.all.upload2.style.display = "none"
	document.all.upload22.style.display = "none"
	document.all.upload3.style.display = "none"
	document.all.upload33.style.display = "none"
	document.all.upload4.style.display = "none"
	document.all.upload44.style.display = "none"
	
}

function box_1()
{ 
	document.all.box1.style.display = ""
	document.all.box2.style.display = "none"
	document.all.box3.style.display = "none"
	document.all.box4.style.display = "none"
	document.all.box_1_bg.bgColor="#333333"
	document.all.box_2_bg.bgColor="#999999"
	document.all.box_3_bg.bgColor="#999999"
	document.all.box_4_bg.bgColor="#999999"
}
function box_2()
{ 
	document.all.box1.style.display = "none"
	document.all.box2.style.display = ""
	document.all.box3.style.display = "none"
	document.all.box4.style.display = "none"
	document.all.box_1_bg.bgColor="#999999"
	document.all.box_2_bg.bgColor="#333333"
	document.all.box_3_bg.bgColor="#999999"
	document.all.box_4_bg.bgColor="#999999"
}
function box_3()
{ 
	document.all.box1.style.display = "none"
	document.all.box2.style.display = "none"
	document.all.box3.style.display = ""
	document.all.box4.style.display = "none"
	document.all.box_1_bg.bgColor="#999999"
	document.all.box_2_bg.bgColor="#999999"
	document.all.box_3_bg.bgColor="#333333"
	document.all.box_4_bg.bgColor="#999999"
}
function box_4()
{ 
	document.all.box1.style.display = "none"
	document.all.box2.style.display = "none"
	document.all.box3.style.display = "none"
	document.all.box4.style.display = ""
	document.all.box_1_bg.bgColor="#999999"
	document.all.box_2_bg.bgColor="#999999"
	document.all.box_3_bg.bgColor="#999999"
	document.all.box_4_bg.bgColor="#333333"
}

//-->
</script>
</head>

<body bgcolor="#ffffff" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" onLoad="javascript:submit();" >

<div align="center">
<br>
<br>
<table width="95%" border="0" cellpadding="0" cellspacing="0">

<form method="post" name="inno" action="tb_form_ok.asp?fromCP=Y&agentId=<%=agentId%>">
<tr>
	<td colspan="2">
	<table width="100%" height="25" border="0" cellpadding="0" cellspacing="0" ID="Table1">
	<tr align="center" bgcolor="#999999">
		    <td width="100%" id="box_1_bg" bgcolor="#333333"> <b><font color="#ffffff">Message 
              Board Setting </font></b></a></td>
		
		</tr>
	</table>
	</td>
</tr>

</table>

<div id="box1" >
    <table width="95%" border="0" cellpadding="0" cellspacing="0" ID="Table2">
      <tr> 
        <td colspan="2" height="20" class="font1" align="center" bgcolor="#333333"><font color="#ffffff">&nbsp;</font></td>
      </tr>
      <tr bgcolor="#F7F7F7" height="25"> 
        <td width="180" class="form_title" align="right"><b>Board Name &nbsp;</b></td>
        <td class="font1" valign="center"><input type="text" name="tb_name" size="30" maxlength="50" class="form_input" value="<%=tb_name%>"></td>
      </tr>
      <tr> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="#F7F7F7" height="25" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>�Խ��� Ÿ�� &nbsp;</b></td>
        <td class="font1" valign="center"><input type="radio" name="board_type" value="0" > 
          �ϹݰԽ��� &nbsp; &nbsp; 
		  <input type="radio" name="board_type" value="1" checked ID="Radio1"> 
          �ڷ�� &nbsp; &nbsp; <input type="radio" name="board_type" value="2" onClick="javascript:box_open1()"<% if board_type = 2 then %> checked<% end if %> ID="Radio2"> 
          �ַ��� &nbsp; &nbsp; <input type="radio" name="board_type" value="3" onClick="javascript:box_open()"<% if board_type = 3 then %> checked<% end if %> ID="Radio3"> 
          ������ ���̾</font></td>
      </tr>
      <tr id="upload44"> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="F7F7F7" height="25" > 
        <td align="right"  colspan="2"style="word-break:break-all;padding:5px;"><a href="javascript:submit();"><img src="../img/but_join_ok.gif" border="0"></a> <a href="javascript:history.go(-1);"><img src="../img/but_join_cancel.gif" border="0"></a></td>
      </tr>
      <tr bgcolor="F7F7F7" height="25" id="upload4" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>������ Ÿ�� &nbsp;</b></td>
        <td class="font1" valign="center"><input type="radio" name="gallery_type" value="a" <% if gallery_type = "a" or gallery_type="" then %>checked<% end if %>>
          A�� &nbsp; &nbsp; <input type="radio" name="gallery_type" value="b"<% if gallery_type = "b" then %> checked<% end if %>>
          B�� &nbsp; &nbsp; <input type="radio" name="gallery_type" value="c"<% if gallery_type = "c" then %> checked<% end if %>>
          C�� &nbsp; &nbsp; <input type="radio" name="gallery_type" value="d"<% if gallery_type = "d" then %> checked<% end if %>>
          D��</td>
      </tr>
      <tr> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="F7F7F7" height="25" id="upload1" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>���ε� ������Ʈ &nbsp;</b></td>
        <td class="font1" valign="center"><input type="radio" name="upload_type" value="abc" <% if upload_type = "abc" or mode="" then %>checked<% end if %>>
          ABC upload &nbsp; &nbsp; <input type="radio" name="upload_type" value="dext"<% if upload_type = "dext" then %> checked<% end if %>>
          DEXT upload</td>
      </tr>
      <tr id="upload11" style="display:<% if board_type = 0 then %>none<% end if%>"> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="F7F7F7" height="25" id="upload2" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>���ε� �� ���� &nbsp;</b></td>
        <td class="font1" valign="center"><select name="upload_form">
            <%	
		dim j,upload
		
		j=1
		do while j < 5
		upload = j
		
	%>
            <option value="<%=upload%>"<% if upload=upload_form or (mode="" and upload=1) then %> selected<% end if %>><%=upload%></option>
            <%
		j=j+1
		loop
	%>
          </select> ���� ���ε� ���� ����մϴ�.</td>
      </tr>
      <tr id="upload22" style="display:<% if board_type = 0 then %>none<% end if%>"> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="F7F7F7" height="25" id="upload3" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>���ε� �뷮���� &nbsp;</b></td>
        <td class="font1" valign="center"><table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
              <td width="50"><input type="text" name="maxsize" size="3" maxlength="7" class="form_input" value="<% if mode<>"edit" then %>200<% else %><%=maxsize%><% end if %>" onkeyPress="numcheck()"></td>
              <td>KByte (1M = 1000)&nbsp; ���ε� ������ �뷮����</td>
            </tr>
          </table></td>
      </tr>
      <tr id="upload33" style="display:<% if board_type = 0 then %>none<% end if%>"> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="#F7F7F7" height="25" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>�۾����� Ÿ�� &nbsp;</b></td>
        <td class="font1" valign="center"><input type="radio" name="content_type" value="0"<% if content_type = 0 or mode="" then %> checked<% end if %>> 
          �Ϲ�Ÿ�� &nbsp; &nbsp; <input type="radio" name="content_type" value="1"<% if content_type = 1 then %> checked<% end if %>> 
          ������ ������</font></td>
      </tr>
      <tr> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="#F7F7F7" height="25" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>�Խ��� ������ &nbsp;</b></td>
        <td class="font1" valign="center"><table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
              <td width="50"><input type="text" name="board_size" size="1" maxlength="3" class="form_input" value="<% if mode<>"edit" then %>800<% else %><%=board_size%><% end if %>" onkeyPress="numcheck()"></td>
              <td>�Խ��� ����ũ�� (100�����̸� %�� ����)</td>
            </tr>
          </table></td>
      </tr>
      <tr> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="#F7F7F7" height="25" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>���� &nbsp;</b></td>
        <td class="font1" valign="center"><table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
              <td width="65"><input type="text" name="bgcolor" size="5" maxlength="10" class="form_input" value="<% if mode<>"edit" then %>#FFFFFF<% else %><%=bgcolor%><% end if %>"></td>
              <td>������ ���� ����</td>
            </tr>
          </table></td>
      </tr>
      <tr> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="#F7F7F7" height="25" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>�Խ��� ���̺� ���� 
          &nbsp;</b></td>
        <td class="font1" valign="center"><table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
              <td width="65"><input type="text" name="tb_bgcolor" size="5" maxlength="10" class="form_input" value="<% if mode<>"edit" then %>#FFFFFF<% else %><%=tb_bgcolor%><% end if %>"></td>
              <td>�Խ��� ���� ����</td>
            </tr>
          </table></td>
      </tr>
      <tr> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="#F7F7F7" height="25" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>Onmouseover TR ���� 
          &nbsp;</b></td>
        <td class="font1" valign="center"><table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
              <td width="65"><input type="text" name="tr_chcolor" size="5" maxlength="10" class="form_input" value="<% if mode<>"edit" then %>#F4F4F4<% else %><%=tr_chcolor%><% end if %>"></td>
              <td>����� ���� ���콺�� �÷��������� ���ϴ� ����</td>
            </tr>
          </table></td>
      </tr>
      <tr> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="#F7F7F7" height="25" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>Ÿ��Ʋ ���� &nbsp;</b></td>
        <td class="font1" valign="center"><table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
              <td width="140"><input type="text" name="board_title" size="20" maxlength="240" class="form_input" value="<% if mode="edit" then %><%=board_title%><% end if %>"></td>
              <td>������ ����� Ÿ��Ʋ�� ���� </td>
            </tr>
          </table></td>
      </tr>
      <tr> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="F7F7F7" height="25" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>�Խ��� ��ܿ� �� 
          ���� &nbsp;</b></td>
        <td class="font1" valign="center"><table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
              <td width="65"><input type="text" name="top_file" size="30" maxlength="240" class="form_input" value="<%=top_file%>"></td>
              <td>&nbsp; ��) /innoboard/board/top.asp</td>
            </tr>
          </table></td>
      </tr>
      <tr> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="F7F7F7" height="25" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>�Խ��� ��ܿ� ����� 
          ���� &nbsp;</b></td>
        <td class="font1" valign="center"><textarea name="top_board" cols="72" rows="6" class="form_textarea"><% if mode<>"edit" then %><div align="center"><br><br><% else %><%=top_board%><% end if %></textarea></td>
      </tr>
      <tr> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="F7F7F7" height="25" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>�Խ��� �ϴܿ� ����� 
          ���� &nbsp;</b></td>
        <td class="font1" valign="center"><textarea name="bottom_board" cols="72" rows="6" class="form_textarea"><% if mode<>"edit" then %><div><% else %><%=bottom_board%><% end if %></textarea></td>
      </tr>
      <tr> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="F7F7F7" height="25" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>�Խ��� �ϴܿ� �� 
          ���� &nbsp;</b></td>
        <td class="font1" valign="center"><table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
              <td width="65"><input type="text" name="down_file" size="30" maxlength="240" class="form_input" value="<%=down_file%>"></td>
              <td>&nbsp; ��) /innoboard/board/top.asp</td>
            </tr>
          </table></td>
      </tr>
      <tr> 
        <td colspan="2" height="1"></td>
      </tr>
      <tr bgcolor="F7F7F7" height="25" style="display:none"> 
        <td width="180" class="form_title" align="right"><b>�߰���� &nbsp;</b></td>
        <td class="font1" valign="center"><input type="checkbox" name="use_smtp" value="1"<% if use_smtp=1 or mode="" then %> checked<% end if %>>
          SMTP ��� &nbsp; <input type="checkbox" name="use_reco" value="1"<% if use_reco=1 then %> checked<% end if %> ID="Checkbox3"> 
          ��õ��� ��� &nbsp; <input type="checkbox" name="use_cookies" value="" ID="Checkbox5" disabled="disabled"> 
          ��Ű ���<br> <input type="checkbox" name="view_upload" value="1"<% if view_upload=1 or mode="" then %> checked<% end if %>> 
          ���ε� ���¹� ǥ��(ABC & DEXT ��)</td>
      </tr>
      <tr> 
        <td colspan="2" height="1"></td>
      </tr>
    </table>
</div>
<% '####################################################### ��Ϻ��� ���� #######################################################%>
<div id="box2" style="display:none">
<table width="95%" border="0" cellpadding="0" cellspacing="0" ID="Table3">
<tr>
	<td colspan="2" height="20" class="font1" align="center" bgcolor="#333333"><font color="#ffffff"><b>��Ϻ��� ���ü���</b></font></td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td width="180" class="form_title" align="right"><b>��ϱ� �� &nbsp;</b></td>
	<td class="font1" valign="center"><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr><td width="50"><input type="text" name="pagesize" size="1" maxlength="3" class="form_input" value="<% if mode<>"edit" then %>10<% else %><%=pagesize%><% end if %>" onkeyPress="numcheck()"></td><td>���������� ��µ� ����� �� (1~999) </td></tr></table></td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td width="180" class="form_title" align="right"><b>������ �� &nbsp;</b></td>
	<td class="font1" valign="center"><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr><td width="50"><input type="text" name="block" size="1" maxlength="3" class="form_input" value="<% if mode<>"edit" then %>10<% else %><%=block%><% end if %>" onkeyPress="numcheck()"></td><td>����� �Ʒ��κп� ǥ�õ� �������� ���� (1~999)</td></tr></table></td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td width="180" class="form_title" align="right"><b>���� ¥���� &nbsp;</b></td>
	<td class="font1" valign="center"><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr><td width="50"><input type="text" name="len_title" size="1" maxlength="3" class="form_input" value="<% if mode<>"edit" then %>40<% else %><%=len_title%><% end if %>" onkeyPress="numcheck()"></td><td>������ ���� �̻��� ������� .. �� ������ ǥ�� </td></tr></table></td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td width="180" class="form_title" align="right"><b>���� ǥ�� �ϼ� &nbsp;</b></td>
	<td class="font1" valign="center"><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr><td width="50"><input type="text" name="new_title" size="1" maxlength="3" class="form_input" value="<% if mode<>"edit" then %>1<% else %><%=new_title%><% end if %>" onkeyPress="numcheck()"></td><td>���ο� ���ϰ�� Ư���ϰ� ǥ���ϴ� �ϼ� </td></tr></table></td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td width="180" class="form_title" align="right"><b>���� ǥ�� ��� &nbsp;</b></td>
	<td class="font1" valign="center"><input type="checkbox" name="nt_img" value="1"<% if nt_img = 1 or mode="" then %> checked<% end if %>>������ �� �̹��� �����̱� &nbsp; <input type="checkbox" name="nt_tr" value="1"<% if nt_tr = 1 or mode="" then %> checked<% end if %>>�࿡ ���ֱ�</td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td width="180" class="form_title" align="right"><b>���� ���� &nbsp;</b></td>
	<td class="font1" valign="center"><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr><td width="65"><input type="text" name="nt_color" size="5" maxlength="10" class="form_input" value="<% if mode<>"edit" then %>#F4F4F4<% else %><%=nt_color%><% end if %>"></td><td>���� ǥ�� ����� �࿡ ���ֱ� �ϰ�� ���� ����</td></tr></table></td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="#F7F7F7" height="25">
	<td width="180" class="form_title" align="right"><b>ǥ�� &nbsp;</b></td>
	<td class="font1" valign="center"><input type="checkbox" name="view_reco" value="1"<% if view_reco=1 then %> checked<% end if %>>��õ�� ǥ��(��õ��� ����)</td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
</table>
</div>
<% '####################################################### ���б� ���ü��� ####################################################### %>
<div id="box3" style="display:none">
<table width="95%" border="0" cellpadding="0" cellspacing="0" ID="Table4">

<tr>
	<td colspan="2" height="20" class="font1" align="center" bgcolor="#333333"><font color="#ffffff"><b>���б� ���ü���</b></font></td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="180" class="form_title" align="right"><b>���ñ� ���� &nbsp;</b></td>
	<td class="font1" valign="center"><input type="radio" name="relation" value="0"<% if relation=0 then %> checked<% end if %>>ǥ�þ��� &nbsp; &nbsp; <input type="radio" name="relation" value="1"<% if relation=1 or mode="" then %> checked<% end if %>>����,�����۸� ǥ��<br><input type="radio" name="relation" value="2"<% if relation=2 then %> checked<% end if %>>����,�����۰� ������� �亯���� ǥ�� &nbsp; &nbsp; <input type="radio" name="relation" value="3"<% if relation=3 then %> checked<% end if %>>��ü��� ǥ��</td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="180" class="form_title" align="right"><b>�߰���� &nbsp;</b></td>
	<td class="font1" valign="center"><input type="checkbox" name="use_comment" value="1"<% if use_comment=1 or mode="" then %> checked<% end if %>>�ڸ�Ʈ ��� &nbsp; <input type="checkbox" name="view_ip" value="1"<% if view_ip=1 then %> checked<% end if %> ID="Checkbox1">IP ǥ��</td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="180" class="form_title" align="right"><b>�̸����� &nbsp;</b></td>
	<td class="font1" valign="center"><input type="checkbox" name="view_img" value="1"<% if view_img=1 or mode="" then %> checked<% end if %> ID="Checkbox4">�̹��� ǥ�� &nbsp; <input type="checkbox" name="view_multi" value="1"<% if view_multi=1 or mode="" then %> checked<% end if %> ID="Checkbox2">��Ƽ�̵�� ǥ��(������,���� ��)</td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
</table>
</div>
<% '####################################################### ������ ���ü��� ####################################################### %>
<div id="box4" style="display:none">
<table width="95%" border="0" cellpadding="0" cellspacing="0" ID="Table5">
<tr>
	<td colspan="2" height="20" class="font1" align="center" bgcolor="#333333"><font color="#ffffff"><b>������ ����</b></font></td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="180" class="form_title" align="right"><b>��� ���� &nbsp;</b></td>
	<td class="font1" valign="center"><select name="l_level">
	<%	
		dim list_level1,list_level2
		
		j=10
		do while j > 0
		list_level1 = j & " Level"
		list_level2 = j
		
	%>
	<option value="<%=list_level2%>"<% if list_level2=l_level or (mode="" and list_level2=10) then %> selected<% end if %>><%=list_level1%></option>
	<%
		j=j-1
		loop
	%>
	</select>�̻��� ȸ���� ��� ���⸦ �� �� �ֽ��ϴ�.</td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="180" class="form_title" align="right"><b>���б� &nbsp;</b></td>
	<td class="font1" valign="center"><select name="r_level">
	<%	
		dim read_level1,read_level2
		
		j=10
		do while j > 0
		read_level1 = j & " Level"
		read_level2 = j
		
	%>
	<option value="<%=read_level2%>"<% if read_level2=r_level or (mode="" and read_level2=10) then %> selected<% end if %>><%=read_level1%></option>
	<%
		j=j-1
		loop
	%>
	</select>�̻��� ȸ���� ���б⸦ �� �� �ֽ��ϴ�.</td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="180" class="form_title" align="right"><b>�۾��� &nbsp;</b></td>
	<td class="font1" valign="center"><select name="w_level">
	<%	
		dim write_level1,write_level2
		
		j=10
		do while j > 0
		write_level1 = j & " Level"
		write_level2 = j
		
	%>
	<option value="<%=write_level2%>"<% if write_level2=w_level or (mode="" and write_level2=10) then %> selected<% end if %>><%=write_level1%></option>
	<%
		j=j-1
		loop
	%>
	</select>�̻��� ȸ���� �۾��⸦ �� �� �ֽ��ϴ�.</td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="180" class="form_title" align="right"><b>�亯 ���� &nbsp;</b></td>
	<td class="font1" valign="center"><select name="rw_level">
	<%	
		dim rwrite_level1,rwrite_level2
		
		j=10
		do while j > 0
		rwrite_level1 = j & " Level"
		rwrite_level2 = j
		
	%>
	<option value="<%=rwrite_level2%>"<% if rwrite_level2=rw_level or (mode="" and rwrite_level2=10) then %> selected<% end if %>><%=rwrite_level1%></option>
	<%
		j=j-1
		loop
	%>
	</select>�̻��� ȸ���� �亯 ���⸦ �� �� �ֽ��ϴ�.</td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="180" class="form_title" align="right"><b>�ڸ�Ʈ ���� &nbsp;</b></td>
	<td class="font1" valign="center"><select name="cw_level">
	<%	
		dim cwrite_level1,cwrite_level2
		
		j=10
		do while j > 0
		cwrite_level1 = j & " Level"
		cwrite_level2 = j
		
	%>
	<option value="<%=cwrite_level2%>"<% if cwrite_level2=cw_level or (mode="" and cwrite_level2=10) then %> selected<% end if %>><%=cwrite_level1%></option>
	<%
		j=j-1
		loop
	%>
	</select>�̻��� ȸ���� �ڸ�Ʈ ���⸦ �� �� �ֽ��ϴ�.</td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
<tr bgcolor="F7F7F7" height="25"> 
	<td width="180" class="form_title" align="right"><b>�������� ���� &nbsp;</b></td>
	<td class="font1" valign="center"><select name="nw_level">
	<%	
		dim nwrite_level1,nwrite_level2
		
		j=10
		do while j > 0
		nwrite_level1 = j & " Level"
		nwrite_level2 = j
		
	%>
	<option value="<%=nwrite_level2%>"<% if nwrite_level2=nw_level or (mode="" and nwrite_level2=1) then %> selected<% end if %>><%=nwrite_level1%></option>
	<%
		j=j-1
		loop
	%>
	</select>�̻��� ȸ���� �������� ���⸦ �� �� �ֽ��ϴ�.</td>
</tr>
<tr>
	<td colspan="2" height="1"></td>
</tr>
</table>
</div>

<% '######################################################## ������ ���� �� ######################################### %>

<table width="95%" border="0" cellpadding="0" cellspacing="0" ID="Table6">
<tr>
	<td colspan="2">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="1" bgcolor="#333333"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="4" bgcolor="#333333"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#ffffff"></td>
	</tr>
	<tr>
		<td height="1" bgcolor="#333333"></td>
	</tr>
	</table>
	</td>
</tr>
</table>
<table width="95%" border="0" cellpadding="0" cellspacing="0">
<tr>
	  <td align="right" style="word-break:break-all;padding:5px; display:none" ><a href="javascript:submit();"><img src="../img/but_join_ok.gif" border="0"></a> 
        <a href="javascript:history.go(-1);"><img src="../img/but_join_cancel.gif" border="0"></a></td>
    </tr>
<% If mode = "edit" Then %>
<input type="hidden" name="tb" value="<%=tb%>">
<input type="hidden" name="mode" value="<%=mode%>">
<% end if %>
</form>
</table>
<br><br>
</div>

</body>
</html>

<%
	If mode <> "" Then
	rs.close
	db.Close
	Set rs=nothing
	Set db=nothing

	end if
%>