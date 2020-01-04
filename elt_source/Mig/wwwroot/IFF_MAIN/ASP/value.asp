<%=Request.ServerVariables("HTTP_X_FORWARDED_FOR")%>
<table border=1>
<% for each key in request.servervariables %>
<tr><td><font color=red><%=key%> : </font></td>
<td><%=request.servervariables(key)%> </td>
</tr>
<% next %>
</table>
