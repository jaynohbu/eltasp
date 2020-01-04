<% @Language = "VBScript" %>
<% Option Explicit %>
<% response.buffer = true %>

 


<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->

<% if session_login_name <> "admin" then Response.Redirect "../inc/error.asp?no=1" %>

<% dim w_point,r_point,rw_point,c_point,level_1,level_2,level_3,level_4,level_5,level_6,level_7,level_8,level_select %>

<%
	w_point = Request.Form("w_point")
	r_point = Request.Form("r_point")
	rw_point = Request.Form("rw_point")
	c_point = Request.Form("c_point")
	
	level_1 = Request.Form("level_1")
	level_2 = Request.Form("level_2")
	level_3 = Request.Form("level_3")
	level_4 = Request.Form("level_4")
	level_5 = Request.Form("level_5")
	level_6 = Request.Form("level_6")
	level_7 = Request.Form("level_7")
	level_8 = Request.Form("level_8")
	level_select = Request.Form("level_select")

	SQL = "Update f_member set w_point = "& w_point &""
	SQL = SQL & ", r_point = "& r_point &""
	SQL = SQL & ", rw_point = "& rw_point &""
	SQL = SQL & ", c_point = "& c_point &""
	SQL = SQL & ", level_1 = "& level_1 &""
    SQL = SQL & ", level_2 = "& level_2 &""
	SQL = SQL & ", level_3 = "& level_3 &""
	SQL = SQL & ", level_4 = "& level_4 &""
	SQL = SQL & ", level_5 = "& level_5 &""
	SQL = SQL & ", level_6 = "& level_6 &""
	SQL = SQL & ", level_7 = "& level_7 &""
	SQL = SQL & ", level_8 = "& level_8 &""
	SQL = SQL & ", level_select = "& level_select
	db.execute SQL

	db.Close
	Set db=nothing

%>

<script language="JavaScript">
	alert("변경되었습니다.");
	location.href="../admin/point.asp";
</script>

