
<%
	'#### 14��(2��)�� ������ �ڵ����� �����Ѵ�.
	'dim m_writeday,u_time
	
	'SQL="DELETE FROM message where m_read=1 and (("&datediff("y",m_writeday,now)&" >= 14) or (m_box=2))"	'�޼��� ���̺��� ���� �޼���(m_read=1)�� �ҷ��ͼ� 14���� ����ߴ��� ����.
	'db.Execute SQL
	
	'### ���� ������ �ȵȴٸ�.. Ǯ��� �ؾ���... �Ѥ�;; ��.. access ���������� �� ��������... sql ������ ���� �� �ȸ������� ����.. �߾��߾�.. �߾�..
	
	dim msg_del_sql,msg_del_rs
	
	msg_del_sql = "SELECT m_read,m_writeday,s_id FROM message"
	Set msg_del_rs = db.execute(msg_del_sql)
		
	if msg_del_rs.eof or msg_del_rs.bof then
		
	else

		dim sql_msg_del
	
		do until msg_del_rs.eof
			
			if datediff("d",msg_del_rs("m_writeday"),now) >= 14 then	'### 14���� �����͸� ��� ����
				SQL_msg_del = "DELETE FROM message where (m_read=1 or m_box=2) AND s_id = '"&msg_del_rs("s_id")&"'"	
				db.execute(SQL_msg_del)
			end if
			
			if datediff("m",msg_del_rs("m_writeday"),now) >= 2 then	'### 2���� �����͸� ��� ����
				SQL_msg_del = "DELETE FROM message where s_id = '"&msg_del_rs("s_id")&"'"	'### ���� ���� ������ 2���Ŀ� ����
				db.execute(SQL_msg_del)
			end if
			
		msg_del_rs.movenext
		loop
		
	end if
	
	msg_del_rs.close
	set msg_del_rs = nothing
	
	'### ��~~~
%>

