<% @Language = "VBScript" %>
<% Option Explicit %>
<% response.buffer = true %>


 


<!-- #include file="../inc/dbinfo.asp" -->

<html>
<head>
<title>�� �����ȣ �˻� ��</title>

<LINK rel="stylesheet" type="text/css" href="../inc/style.css">

<script language="JavaScript">
<!--

function submit()
{

	if (document.inno_post.address.value == "") {
		alert("�������� �Է��� �ּ���.");
		document.inno_post.address.focus();
		return;
	}
	
	document.inno_post.submit();

}

function update_address(inno_post,i)
{
		if (document.inno_post.post_no.value == "") {
		alert("������ ������ �ּ���.");
		document.inno_post.post_no.focus();
		return;
		}
	
        if (inno_post.add2.value == "") {
            alert("�������� �Է��ϼ���.");
            inno_post.add2.focus();
        }else{
     
        var firstWin = window.opener ;	
		firstWin.inno.post1.value = inno_post.post_no[i].value.substring(0,3);
		firstWin.inno.post2.value = inno_post.post_no[i].value.substring(3,6);
		firstWin.inno.add1.value = inno_post.post_no[i].text;
		firstWin.inno.add2.value = inno_post.add2.value;
		
	    window.close(this);
	   }
}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">
<%
	dim address,sql,rs
	
	address=request("address")
	
	sql ="SELECT * FROM  zipall where  dong like '%" & address & "%' ORDER BY zipcode ASC "
	Set rs = db.Execute(sql)
%>

<img src="../img/zipcode_title.gif" border="0">

<% if rs.BOF or rs.EOF then %>
<script LANGUAGE="JavaScript" FOR="window" EVENT="onload()">
	document.inno_post.address.focus();
</script>
<table width="350" border="0" cellspacing="0" cellpadding="0">
<form method="post" name="inno_post" action="zipcode_ok.asp">
<tr>
	<td align="center">��ġ�ϴ� ������ �����ϴ�.<br><br>��/��/��, ���, �б� ���� �̸��� �Է��ϼ���.<br><br></td>
</tr>
<tr>
	<td align="center"><input type="text" name="address" size="15" class="form_input"> <a href="javascript:submit();"><img src="../img/but_join_search.gif" border="0"></a></td>
</tr>
</form>
</table>

<% else %>
<script LANGUAGE="JavaScript" FOR="window" EVENT="onload()">
	document.inno_post.add2.focus();
</script>
<table width="350" border="0" cellspacing="0" cellpadding="0">
<form method="post" name="inno_post">
<tr>
	<td align="center"><SELECT NAME="post_no" style="width=300">
					<option value=""><%=address%>(��)�� �˻��� �����Դϴ�. �������ּ���</option>
					<% while rs.EOF <> true %>
					      <OPTION VALUE="<%=rs(0)%>" align=left><%=rs(1)%>&nbsp;<%=rs(2)%>&nbsp;<%=rs(3)%><br>
					<% rs.MoveNext
						  wend %>
                	</SELECT></td>
</tr>
<tr>
	<td align="center"><br>������ �ּҸ� �Է��ϼ���. <input type=text name="add2" size="24" class="form_input"></td>
</tr>

<tr>
	<td align="center"><a href="javascript:update_address(document.inno_post,document.inno_post.post_no.selectedIndex)"><img src="../img/but_join_ok.gif" border="0"></a> <a href="zipcode.asp"><img src="../img/but_join_againsearch.gif" border="0"></a> <a href="javascript:self.close()"><img src="../img/but_join_cancel.gif" border="0"></a></td>
</tr>
</form>
</table>

<%
	end if
	rs.close
	db.Close
	Set rs=nothing
	Set db=nothing
%>

</body>
</html>

