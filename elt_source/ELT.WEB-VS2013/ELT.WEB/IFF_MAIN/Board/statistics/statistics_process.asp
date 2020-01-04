
<%
	'#### 14일(2주)이 지나면 자동으로 삭제한다.
	'dim m_writeday,u_time
	
	'SQL="DELETE FROM message where m_read=1 and (("&datediff("y",m_writeday,now)&" >= 14) or (m_box=2))"	'메세지 테이블에서 읽은 메세지(m_read=1)를 불러와서 14일이 경과했는지 본다.
	'db.Execute SQL
	
	'### 위의 두줄이 안된다면.. 풀어서라도 해야지... ㅡㅡ;; 흠.. access 버젼에서는 잘 먹히던데... sql 에서는 어찌 잘 안먹히는지 몰라.. 중얼중얼.. 중얼..
	
	dim msg_del_sql,msg_del_rs
	
	msg_del_sql = "SELECT m_read,m_writeday,s_id FROM message"
	Set msg_del_rs = db.execute(msg_del_sql)
		
	if msg_del_rs.eof or msg_del_rs.bof then
		
	else

		dim sql_msg_del
	
		do until msg_del_rs.eof
			
			if datediff("d",msg_del_rs("m_writeday"),now) >= 14 then	'### 14일이 지난것만 골라서 실행
				SQL_msg_del = "DELETE FROM message where (m_read=1 or m_box=2) AND s_id = '"&msg_del_rs("s_id")&"'"	
				db.execute(SQL_msg_del)
			end if
			
			if datediff("m",msg_del_rs("m_writeday"),now) >= 2 then	'### 2달이 지난것만 골라서 실행
				SQL_msg_del = "DELETE FROM message where s_id = '"&msg_del_rs("s_id")&"'"	'### 읽지 않은 쪽지라도 2달후엔 삭제
				db.execute(SQL_msg_del)
			end if
			
		msg_del_rs.movenext
		loop
		
	end if
	
	msg_del_rs.close
	set msg_del_rs = nothing
	
	'### 끝~~~
%>

