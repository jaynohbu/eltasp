<!--  #INCLUDE FILE="transaction.txt" -->
<%
    Option Explicit
    Response.Charset = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="connection.asp" -->

<%  
    Response.Expires = 0  
    Response.AddHeader "Pragma","no-cache"  
    Response.AddHeader "Cache-Control","no-cache,must-revalidate"  

    DIM rs,SQL,dba_name, rNum,elt_acc,tmpDba
    
	On error Resume Next :
	dba_name = Request.QueryString("n")
	dba_name = Replace(dba_name,"________","&")

	elt_acc = Request.Cookies("CurrentUserInfo")("elt_account_number")
	tmpDba = Replace(dba_name,"'","''")

	SQL = "select TOP 1 org_account_number as num from organization where elt_account_number =" _
	    & elt_acc & " and dba_name=N'"& tmpDba & "'"		

	Set rs = eltConn.execute (SQL)

	if NOT rs.eof and NOT rs.bof then
		rNum = rs("num")
		response.write rNum
	else
		response.write ""
	end if

	rs.Close
	eltConn.Close
	Set rs = Nothing
	Set eltConn = Nothing
%>
