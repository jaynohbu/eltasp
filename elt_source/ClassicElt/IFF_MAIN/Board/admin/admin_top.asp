<Script Language="javascript">
<!--


function OpenWindow(url,intWidth,intHeight) { 
      window.open(url, "_blank", "width="+intWidth+",height="+intHeight+",resizable=0,scrollbars=1");
}
//-->
</Script>
<%
	dim u_info1
	
	u_info1 = right(u_info,len(u_info) - InStrRev(u_info, "/"))
		
%>
<table border="0" width="770" height="23" cellpadding="1" cellspacing="0" ID="Table4" bgcolor="#ffffff">
<tr align="center" bgcolor="#efefef">
	<td width="128"<% if u_info1="index.asp" then %> bgcolor="#bbbbbb"<% else %> onmouseover="this.style.background='#bbbbbb'" onmouseout="this.style.background='#efefef'"<% end if %>><b><a href="../admin/index.asp">���뼳��</a></b></td>
	<td width="128"<% if u_info1="tb_list.asp" or u_info1="tb_form.asp" then %> bgcolor="#bbbbbb"<% else %> onmouseover="this.style.background='#bbbbbb'" onmouseout="this.style.background='#efefef'"<% end if %>><b><a href="../admin/tb_list.asp">�Խ��ǰ���</a></b></td>
	<td width="128"<% if u_info1="user_list.asp" then %> bgcolor="#bbbbbb"<% else %> onmouseover="this.style.background='#bbbbbb'" onmouseout="this.style.background='#efefef'"<% end if %>><b><a href="../member/user_list.asp">ȸ������</a></b></td>
	<td width="128"<% if u_info1="institute.asp" then %> bgcolor="#bbbbbb"<% else %> onmouseover="this.style.background='#bbbbbb'" onmouseout="this.style.background='#efefef'"<% end if %>><b><a href="../member/institute.asp">ȸ�������� ����</a></b></td>
	<td width="128"<% if u_info1="point.asp" then %> bgcolor="#bbbbbb"<% else %> onmouseover="this.style.background='#bbbbbb'" onmouseout="this.style.background='#efefef'"<% end if %>><b><a href="../admin/point.asp">ȸ������Ʈ ����</a></b></td>
	<td width="128" onmouseover="this.style.background='#bbbbbb'" onmouseout="this.style.background='#efefef'"><b><a href="javascript:OpenWindow('../statistics/statistics.asp','500','540')">�������</a></b></td>			
</tr>
</table>