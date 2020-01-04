 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->

<%
	
	
	m_box = request("m_box")
	cart_num = Request.Form("cart").count
	if cart_num="" then	cart_num = 1
	
	i=1
	Do until i > cart_num
	
	m_num = Request.Form("cart")(i)
	
	'response.Write num&"<br>"
	updateSQL = "Update message set m_box=2 where elt_account_number="&elt_account_number&" AND m_box=m_box and r_id='"&session_uid&"' and m_num="&m_num
	db.execute updateSQL
	
	i=i+1
	loop
	
	response.Redirect "m_list.asp?m_box="&m_box


%>
