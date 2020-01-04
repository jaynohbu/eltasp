<% 
		id = "aaa"	
		name = "bbb"	
		pin = "ccc"
		num = 9
		SQL = "INSERT INTO member (num,elt_account_number,id,pin,name,email,url,jumin,nickname,msg_tool,msg_id,birthday,zipcode,address,tel,phone,hobby,job,introduce,mailling,info_open,join_day,term_day,authority,user_level,o_email,o_url,o_nickname,o_msg,o_birthday,o_address,o_tel,o_phone,o_hobby,o_job,o_introduce,po_write,po_comment,point,name_img,b_admin) Select " & num 
		SQL = SQL & ","&elt_account_number&",id,pin,name,email,url,jumin,nickname,msg_tool,msg_id,birthday,zipcode,address,tel,phone,hobby,job,introduce,mailling,info_open,join_day,term_day,authority,user_level,o_email,o_url,o_nickname,o_msg,o_birthday,o_address,o_tel,o_phone,o_hobby,o_job,o_introduce,po_write,po_comment,point,name_img,b_admin "

		SQL = SQL & " from member where id = 'template'"

		response.write SQL
%> 

