 



<!-- #include file="../inc/dbinfo.asp" -->
<!-- #include file="../inc/info_tb.asp" -->
<!-- #include file="../inc/joint.asp" -->

<%
	
	m_box = request("m_box")
	m_num = request("m_num")
	mode = request("mode")
	
	sub m_del_ok_process
		if m_box<>2 then 
			updateSQL = "Update message set m_box=2 where elt_account_number="&elt_account_number&" AND m_box=m_box and r_id='"&session_uid&"' and m_num="&m_num
		else
			updateSQL = "DELETE FROM message where elt_account_number="&elt_account_number&" AND m_box=2 and r_id='"&session_uid&"' and m_num="&m_num
		end if
		db.execute updateSQL
	end sub
	
	if m_box<>3 then	'### 일반쪽지함에서 삭제할때
	
		cart_num = Request.Form("cart").count
		
		if mode<>"check_del" then
			call m_del_ok_process
		else
			cart_num = Request.Form("cart").count
						
			i=1
			Do until i > cart_num
			
			m_num = Request.Form("cart")(i)
			
			call m_del_ok_process
						
			i=i+1
			loop
		
		end if
		
	else	'### 지운편지함에서 쪽지함 비우기를 할때
	
		SQL2 = "DELETE FROM message where elt_account_number="&elt_account_number&" AND m_box=2 and r_id='"&session_uid&"'"
		db.Execute SQL2
		
		m_box=2
	
	end if
	
	response.Redirect "m_list.asp?m_box="&m_box

%>
