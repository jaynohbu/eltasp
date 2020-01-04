<% Option Explicit %>
<% response.buffer = true %>
<% Response.Expires=-1 %>

<!-- #include file="dbinfo.asp" -->

<%
	dim s_year,s_month,s_cal
	dim sql1,rs1
	dim sql,rs
	dim db_year,i,j,total,total_count
	dim s_count,s_per,s_width,totalday,s_week_text
	dim total_year

	s_Year = request("s_year")
	s_Month = request("s_month")
	
	
	if s_year = "" then
		s_year = year(now)
	elseif s_year = "00" then
		s_month="00"
	end if 
	
	if s_month = "" then
		s_month = month(now)
		if len(s_month) = 1 then
			s_month= "0"&s_month
		end if		
	end if
	
	
	s_cal = s_year&"-"&s_month
%>


<html>
<head>
<title>Statistics</title>
<LINK rel="stylesheet" type="text/css" href="../../IFF_MAIN/Board/inc/style.css">
<script language="javascript">
function GoCurr() {
	var sURL = "currentConn.asp";
	window.open(sURL);
}
</script>

<script language="javascript">
<!-- //

function box_1()
{ 
	document.all.box1.style.display = ""
	document.all.box2.style.display = "none"
	document.all.box3.style.display = "none"
	document.all.box4.style.display = "none"
	<% if s_year="00" then %>
		document.all.box6.style.display = "none"
		document.all.box_6_bg.bgColor="#efefef"
	<% end if %>
	document.all.box_1_bg.bgColor="#cfcfcf"
	document.all.box_2_bg.bgColor="#efefef"
	document.all.box_3_bg.bgColor="#efefef"
	document.all.box_4_bg.bgColor="#efefef"
	document.all.box_5_bg.bgColor="#efefef"
}
function box_2()
{ 
	document.all.box1.style.display = "none"
	document.all.box2.style.display = ""
	document.all.box3.style.display = "none"
	document.all.box4.style.display = "none"
	<% if s_year="00" then %>
		document.all.box6.style.display = "none"
		document.all.box_6_bg.bgColor="#efefef"
	<% end if %>
	document.all.box_1_bg.bgColor="#efefef"
	document.all.box_2_bg.bgColor="#cfcfcf"
	document.all.box_3_bg.bgColor="#efefef"
	document.all.box_4_bg.bgColor="#efefef"
	document.all.box_5_bg.bgColor="#efefef"
}
function box_3()
{ 
	document.all.box1.style.display = "none"
	document.all.box2.style.display = "none"
	document.all.box3.style.display = ""
	document.all.box4.style.display = "none"
	<% if s_year="00" then %>
		document.all.box6.style.display = "none"
		document.all.box_6_bg.bgColor="#efefef"
	<% end if %>
	document.all.box_1_bg.bgColor="#efefef"
	document.all.box_2_bg.bgColor="#efefef"
	document.all.box_3_bg.bgColor="#cfcfcf"
	document.all.box_4_bg.bgColor="#efefef"
	document.all.box_5_bg.bgColor="#efefef"
}
function box_4()
{ 
	document.all.box1.style.display = "none"
	document.all.box2.style.display = "none"
	document.all.box3.style.display = "none"
	document.all.box4.style.display = ""
	<% if s_year="00" then %>
		document.all.box6.style.display = "none"
		document.all.box_6_bg.bgColor="#efefef"
	<% end if %>
	document.all.box_1_bg.bgColor="#efefef"
	document.all.box_2_bg.bgColor="#efefef"
	document.all.box_3_bg.bgColor="#efefef"
	document.all.box_4_bg.bgColor="#cfcfcf"
	document.all.box_5_bg.bgColor="#efefef"
	
}
function box_5()
{ 
	document.all.box1.style.display = ""
	document.all.box2.style.display = ""
	document.all.box3.style.display = ""
	document.all.box4.style.display = ""
	<% if s_year="00" then %>
		document.all.box6.style.display = ""
		document.all.box_6_bg.bgColor="#efefef"
	<% end if %>
	document.all.box_1_bg.bgColor="#efefef"
	document.all.box_2_bg.bgColor="#efefef"
	document.all.box_3_bg.bgColor="#efefef"
	document.all.box_4_bg.bgColor="#efefef"
	document.all.box_5_bg.bgColor="#cfcfcf"
	
}

function box_6()
{ 
	document.all.box1.style.display = "none"
	document.all.box2.style.display = "none"
	document.all.box3.style.display = "none"
	document.all.box4.style.display = "none"
	<% if s_year="00" then %>
		document.all.box6.style.display = ""
		document.all.box_6_bg.bgColor="#cfcfcf"
	<% end if %>
	document.all.box_1_bg.bgColor="#efefef"
	document.all.box_2_bg.bgColor="#efefef"
	document.all.box_3_bg.bgColor="#efefef"
	document.all.box_4_bg.bgColor="#efefef"
	document.all.box_5_bg.bgColor="#efefef"
	
}
//-->
</script>

<%
'	if session("c_count")<>"ok" then	
'		
'		SQL = "INSERT INTO IFF_statistics (s_date,s_week,s_user_agent,s_referer) VALUES "
'		SQL = SQL & "(getdate()"
'		SQL = SQL & ",'" & weekday(now) & "'"
'		SQL = SQL & ",'" & Request.ServerVariables("HTTP_USER_AGENT") & "'"
'		SQL = SQL & ",'" & Request.ServerVariables("HTTP_REFERER") & "')"
'
'		db.Execute SQL
'		
'		session("c_count")="ok"
'		
'	end if

%></head>
<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">



<table width="654" border="0" cellpadding="0" cellspacing="0" bgcolor="#efefef" ID="Table3">
<tr>
	<td colspan="<% if s_year="00" then %>7<% else %>6<% end if %>">&nbsp;</td>
</tr>
<form method="post" name="inno_cal" ID="form1">
<tr>
	<td width="484" style="word-break:break-all;padding:5px;" align="center"><b>
	  <select name="s_year" class="form" style="background:#FFFFFF;color:333333;font-weight:bold;text-align:center;" onChange="inno_cal.submit()" ID="Select1">
<option value="00"<% if s_year = "00" then %> selected<% end if %>>All </option>
<%

	SQL="SELECT left(convert(varchar(20), s_date, 120),4) from IFF_statistics group by left(convert(varchar(20), s_date, 120),4) order by left(convert(varchar(20), s_date, 120),4) asc"
	set rs = db.execute(sql)
	
	if not(rs.eof or rs.bof) then
	
	do until rs.eof
	
	db_year=rs(0)
%>
<option value="<%=db_year%>"<% if cint(db_year) = cint(s_year) then %> selected<% end if %>><%=db_year%></option>
<%
	rs.movenext
	loop
	
	end if
	
	rs.close
	set rs = nothing
%>
</select>
	  <% if s_year<>"00" then %>
&nbsp; <select name="s_month" class="form" style="background:#FFFFFF;color:333333;font-weight:bold;text-align:center;" onChange="inno_cal.submit()" ID="Select2">
<option value="00"<% if s_month = "00" then %> selected<% end if %>>All </option>
<%
	For i = 1 To 12
	
		if len(i)=1 then
			j = "0"&i
		else
			j = i
		end if
%>
<option value="<%=j%>"<% if cint(j) = cint(s_month) then %> selected<% end if %>><%=i%></option>
<% Next%></select>
	</b></td>
    <% else %>
<input type="hidden" name="s_month" value="00">
<% end if %>
<td width="30" align="center" id="box_5_bg" onClick="javascript:box_5();" bgcolor="#cfcfcf" style="cursor:hand"><b>&nbsp;All&nbsp;</b></td>
<% if s_year="00" and s_month="00" then %>
<td width="21" align="center" id="box_6_bg" onClick="javascript:box_6();" style="cursor:hand">&nbsp;</td>
<% end if %>
<% if s_month="00" then %>
<td width="29" align="center" id="box_1_bg" onClick="javascript:box_1();" style="cursor:hand"><b>Year</b></td>
<% end if %>
<td width="42" align="center" id="box_2_bg" onClick="javascript:box_2();" style="cursor:hand"><strong>Date</strong></td>
<td width="39" align="center" id="box_3_bg" onClick="javascript:box_3();" style="cursor:hand"><strong>Day</strong></td>
<td width="45" align="center" id="box_4_bg" onClick="javascript:box_4();" style="cursor:hand"><strong>Hour</strong></td>
<% if s_month<>"00" then %><td width="25" align="center" id="box_1_bg">&nbsp;</td>
<% end if %>
</tr>

</form>
</table>
<b><font size="2">
<input name="btnCountry" type="button" class="formbody" value="View Current connection>>"  onClick="javascript:GoCurr();">
</font></b><br>
<br>
<%
	if s_year="00" then
		s_year=""
		s_month=""
	end if
	
	if s_month="00" then
		s_month=""
	end if
%>



<%
	SQL="SELECT count(s_date) from IFF_statistics"
	Set rs = db.Execute(SQL)
	
	if s_year <> "" then
		total = FormatNumber(rs(0),0)
		
	rs.close
	set rs = nothing
		
		
		
		SQL="SELECT count(s_date) from IFF_statistics where left(convert(varchar(20), s_date, 120),4) = '"&s_year&"'"
		Set rs = db.Execute(SQL)
		
		if s_month <> "" then
			total_year = FormatNumber(rs(0),0)
			
			rs.close
			set rs = nothing
			
			SQL="SELECT count(s_date) from IFF_statistics where left(convert(varchar(20), s_date, 120),7) = '"&s_cal&"'"
			Set rs = db.Execute(SQL)
		end if
	end if
	
	total_count = FormatNumber(rs(0),0)
	
	rs.close
	set rs = nothing	
	
	
%>


<div class="font1" align="right"><b><% if s_year<>"" then %>
Total : <%=total%>&nbsp;&nbsp;<br>
<% end if %><% if s_year <> "" then %>
-
<% end if %>
Total Visit : 
<% if s_month = "" then %><%=total_count%>
<% else %><%=total_year%>&nbsp;&nbsp;&nbsp;(<%=s_month%>)Total : <%=total_count%><% end if %> &nbsp; </b></div>
<% if s_year="" and s_month="" then %>
<span class="font1"><b><%=s_year%></b></span>
<div id="box6" style="display:">
<!-- #include file="../statistics/view_year.asp" -->
</div>
<% end if %>

<div id="box1" style="display:">
<!-- #include file="../statistics/view_month.asp" -->
</div>

<div id="box2" style="display:">
<!-- #include file="../statistics/view_day.asp" -->
</div>

<div id="box3" style="display:">
<!-- #include file="../statistics/view_week.asp" -->
</div>

<div id="box4" style="display:">
<!-- #include file="../statistics/view_time.asp" -->
</div>

</body>
</html>