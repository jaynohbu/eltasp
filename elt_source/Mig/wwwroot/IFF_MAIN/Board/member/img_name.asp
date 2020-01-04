
 

<html>
<head>
<title><%=board_title%></title>
<script LANGUAGE="VBScript">
Sub allfile1_onFocus
	Dim fso, str
		fso=imgname.allfile1.value
		str=Replace(fso,"\", "/")
		str=Replace(str," ", "%20")
		str = "file:///" + str
	if str<>"file:///" then
		imgname.preview.src= str
	end if
End Sub
</script>


<script language="javascript">
<!--
function submit1()
{
	document.imgname.submit();
}

function box1()
{ 

	   if (document.all.img.style.display != "none"){
           document.all.img.style.display = "none"
           }
           else {
           document.all.img.style.display = ""
           }
           
}
//-->
</script>

</head>
<body bgcolor="#FFFFFF" marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">
<table width="100%">
<form name="imgname" method="post" action="<% if up_com = 1 then %>dext<% else %>abc<% end if %>_img_name_ok.asp?mode=write" enctype="multipart/form-data">
<tr>
	<td><% if name_img=1 then %><img src="../files/img_name/<%=id%>.gif" name="preview" border="0"> <a href="javascript:box1()" style="text-align:center"><img src="../img/but_imgname_edit.gif" border="0"></a> <a href="<% if up_com = 1 then %>dext<% else %>abc<% end if %>_img_name_ok.asp?mode=del&tb=<%=tb%>&id=<%=id%>"><img src="../img/but_imgname_del.gif" border="0"></a> <% else %><img src="img/no_image.gif" name="preview" border="0"> &nbsp; size : 80 * 18<% end if %></td>
</tr>

<tr id="img" style="display:<% if name_img=1 then %>none<% end if %>">
	<td><input type="file" size="20" name="allfile1" class="form_input"><input type="hidden" name="tb" value="<%=tb%>"><input type="hidden" name="id" value="<%=id%>">
	<input type="button" onclick="javascript:submit1();" value="Àú  Àå" class="but"></td>
</tr>

</form>
</table>


</body>
</html>