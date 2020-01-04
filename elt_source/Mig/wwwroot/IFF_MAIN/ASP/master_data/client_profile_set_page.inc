<%
sub set_page( secon_SQL, recordCount)
DIM rs,SQL
DIM j
	block=50
	
	if recordCount < 100 then exit sub
	set aPageArray = Server.CreateObject("System.Collections.ArrayList")

'SQL = "sele'ct distinct substring(ltrim(isnull(dba_name,'')),1,1) as page from organization where elt_account_number =" & elt_account_number & " group by dba_name order by page"
SQL = "select distinct CASE WHEN ASCII(UPPER(substring(ltrim(isnull(dba_name,'')),1,1))) >= 48 and ASCII(UPPER(substring(ltrim(isnull(dba_name,'')),1,1))) <= 57 THEN 	substring(ltrim(isnull(dba_name,'')),1,1) WHEN ASCII(UPPER(substring(ltrim(isnull(dba_name,'')),1,1))) >= 65 and ASCII(UPPER(substring(ltrim(isnull(dba_name,'')),1,1))) <= 90 THEN	substring(ltrim(isnull(dba_name,'')),1,1) ELSE	'?' END as page from organization where elt_account_number ="&elt_account_number & " " & secon_SQL & " group by dba_name order by page"
	Set rs = eltConn.Execute(SQL)

	Do While Not rs.EOF
		aPageArray.Add rs(0).value
		rs.MoveNext
	Loop
	rs.Close	

	PageCount = aPageArray.count-1
	
	Page = 0
	
	if PageCount < 0 then exit sub

	if Page_c = "" then 
		if default <> "" then
			Page_c = mid(default,1,1)
		else
			Page_c = aPageArray(0)
		end if
	end if	
	
	if ( Asc(Page_c) >= 48 and Asc(Page_c) <= 57 ) or ( Asc(UCASE(Page_c)) >= 65 and Asc(UCASE(Page_c)) <= 90 ) then
	else
		Page_c = "?"
	end if

    for j=0 To aPageArray.count-1 
		if Page_c = aPageArray(j) then
			Page = j
		end if
	next 

end sub
%>
