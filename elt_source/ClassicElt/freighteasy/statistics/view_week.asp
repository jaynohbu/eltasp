
<table width="484" border="0" cellpadding="0" cellspacing="0" bgcolor="#333333" ID="Table3">
<tr>
	<td style="word-break:break-all;padding:5px;color:#ffffff;"><b><% if s_year <> "" then %><%=s_year%>
	<% if s_month<>"" then %>&nbsp;<%=s_month%>
	    <% end if %>
	    <% else %>
	All
	    <%end if %> 
	by Week </b></td>
</tr>
</table>
<br>
<table width="484" border="0" cellpadding="0" cellspacing="0" ID="Table4">
<tr align="center">
	<td width="50">
	<table width="48" border="1" cellspacing="0" cellpadding="0" bgcolor="#EEEEEE" bordercolorlight="gray" bordercolordark="#FFFFFF" ID="Table5">
	<tr>
	  <td width="48" style="font-family:Arial;font-size:8pt;color:gray" nowrap align="center"><b>Week</b></td>
	</tr>
	</table></td>
	<td width="364">
	<table width="362" border="1" cellspacing="0" cellpadding="0" bgcolor="#EEEEEE" bordercolorlight="gray" bordercolordark="#FFFFFF" ID="Table12">
	<tr>
	  <td width="362" style="font-family:Arial;font-size:8pt;color:gray" nowrap align="center"><b>%</b></td>
	</tr>
	</table></td>
	<td width="70">
	<table width="68" border="1" cellspacing="0" cellpadding="0" bgcolor="#EEEEEE" bordercolorlight="gray" bordercolordark="#FFFFFF" ID="Table7">
	<tr><td width="68" style="font-family:Arial;font-size:8pt;color:gray" nowrap align="center"><b>con</b></td>
	</tr>
	</table></td>
</tr>
<%
DIM ss_week_text
	for i=1 to 7
	
		select case i
			case 1 s_week_text = "Mon"  
					ss_week_text = "Monday" 
			case 2 s_week_text = "Tue" 
					ss_week_text = "Tuesday"
			case 3 s_week_text = "Wed" 
					ss_week_text = "Wednesday"
			case 4 s_week_text = "Thu" 
					ss_week_text = "Thursday"
			case 5 s_week_text = "Fri" 
					ss_week_text = "Friday"
			case 6 s_week_text = "Sat" 
					ss_week_text = "Saturday"
			case 7 s_week_text = "Sun" 
					ss_week_text = "Sunday"
		end select
		
		
		if s_year = "" then
			SQL="SELECT count(s_date) from IFF_statistics where s_week = '"&ss_week_text&"'"
		else		
			if s_month = "" then	
				SQL="SELECT count(s_date) from IFF_statistics where left(convert(varchar(20), s_date, 120),4) = '"&s_year&"' and s_week = '"&ss_week_text&"'"
			else	
				SQL="SELECT count(s_date) from IFF_statistics where left(convert(varchar(20), s_date, 120),7) = '"&s_cal&"' and s_week = '"&ss_week_text&"'"
			end if
		end if

		Set rs = db.Execute(SQL)
		
		if not(rs.eof or rs.bof) then
	
			s_count = rs(0)
					
			if s_count = 0 then
				s_per = 0
				s_width= 0
			else
				s_per = cint(s_count/total_count*100)
				s_width= cint(3.0*s_per)
			end if
			
		end if

%>
<tr align="center">
	<td width="50"><%=s_week_text%></td>
	<td width="364" align="left">
	<table border="0" width="100%" height="10" cellpadding="0" cellspacing="0" ID="Table1">
	<tr>
		<td width="10" bgcolor="#cccccc"></td>
		<td><table border="0" width="<%=s_width+60%>" height="10" cellpadding="0" cellspacing="0" ID="Table2"><tr><td width="<%=s_width%>" bgcolor="#cccccc"></td><td width="30" class="font" align="right">&nbsp;(<%=s_per%>%)</td><td width="30" align="right"><% if i = weekday(now) then %><span style="font-size:7pt;color:#ff0000">now~</span><% end if %></td></tr></table></td>
	</tr>
	</table>
	
	</td>
	<td width="70"><%=s_count%></td>
</tr>
<%		
		rs.close
		set rs = nothing
		
	next
%>

</table>
<table width=100% border=1 height="7" cellspacing=0 cellpadding=0 bgcolor=#EEEEEE bordercolorlight=gray bordercolordark=#FFFFFF ID="Table6">
<tr>
	<td style=font-family:Arial;font-size:1pt;color:gray nowrap>&nbsp;</td>
</tr>
</table>
<br><br><br>

