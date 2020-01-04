<!--  #INCLUDE VIRTUAL="/ASP/include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE VIRTUAL="/ASP/include/connection.asp" -->

<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>

<%
DIM rs,SQL,org_acct_number,rNum,elt_acc
DIM aSB(),aDesc(),aSBUnit1(),aSBUnit2(),iCnt,sbIndex,tIndex,i,j,tmpDesc

'	On error Resume Next :
	org_acct_number = Request.QueryString("n")
	elt_acc = Request.Cookies("CurrentUserInfo")("elt_account_number")

	call get_data

	response.write " <option>Select One</option>"
	response.write " <option>Add New Schedule B Number</option>"
    for j=0 to sbIndex-1
		tmpDesc = Replace(aDesc(j)," ","^")
        response.write " <option value=" & aSB(j) & "-" & tmpDesc & "-" & aSBUnit1(j) & "-" & aSBUnit2(j) & ">" & aSB(j) & "-" & aDesc(j) & "</option>"
    next
%>

<%
Sub get_data

	iCnt = 0
	sbIndex = 0

	SQL= "select count(*) as iCnt from ig_schedule_b where elt_account_number = " & elt_acc & "AND org_account_number="& org_acct_number
	Set rs = eltConn.execute (SQL)

	if NOT rs.eof and NOT rs.bof then
		iCnt = rs("iCnt")
	else
		iCnt = 0
	end if
	rs.Close

	if iCnt > 0 then
		Redim aSB(iCnt),aDesc(iCnt),aSBUnit1(iCnt),aSBUnit2(iCnt)
		SQL= "select * from ig_schedule_b where elt_account_number = " & elt_acc & "AND org_account_number="& org_acct_number & " order by sb"
		rs.Open SQL, eltConn, , , adCmdText
		Do While Not rs.EOF
			aSB(sbIndex)=rs("sb")
			aDesc(sbIndex)=rs("description")
			aSBUnit1(sbIndex)=rs("sb_unit1")
			aSBUnit2(sbIndex)=rs("sb_unit2")
			sbIndex=sbIndex+1
			rs.MoveNext
		Loop
		rs.Close			
	else
		SQL= "select count(*)  as iCnt from scheduleb where elt_account_number = " & elt_acc
		Set rs = eltConn.execute (SQL)
		if NOT rs.eof and NOT rs.bof then
			iCnt = rs("iCnt")
		else
			iCnt = 0
		end if
		if iCnt > 0 then
			Redim aSB(iCnt),aDesc(iCnt),aSBUnit1(iCnt),aSBUnit2(iCnt)
			SQL= "select * from scheduleb where elt_account_number = " & elt_acc & " order by sb"
			Set rs = eltConn.execute (SQL)
			Do While Not rs.EOF
				aSB(sbIndex)=rs("sb")
				aDesc(sbIndex)=rs("description")
				aSBUnit1(sbIndex)=rs("sb_unit1")
				aSBUnit2(sbIndex)=rs("sb_unit2")
				sbIndex=sbIndex+1
				rs.MoveNext
			Loop
			rs.Close
		else
		end if
	end if
end sub
%>

