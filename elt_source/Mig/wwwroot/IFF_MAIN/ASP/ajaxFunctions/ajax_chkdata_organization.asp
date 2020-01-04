<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->

<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>

<%
DIM dba_name,org_num,elt_acc,cType,prefix
'	On error Resume Next :
	elt_acc = Request.Cookies("CurrentUserInfo")("elt_account_number")
	if(elt_acc = "") then
		response.write "error#9"
		response.end
	end if

'// U : Update, C : Create
	cType = Request.QueryString("t")
	if isnull(cType) then cType = ""
	if trim(cType) = "" then
		response.write "error#0"
		response.end
	end if
	if cType = "U" then
		org_num = Request.QueryString("o")
		if isnull(org_num) then org_num = ""
		if trim(org_num) = "" then
			response.write "error#1"
			response.end
		end if
	else
		org_num = "-1"
	end if

'// dba_name check
	dba_name = Request.QueryString("s")
	if isnull(dba_name) then dba_name = ""
	if trim(dba_name) = "" then
		response.write "error#2"
		response.end
	end if

	call check_dba_dup ( cType, elt_acc, org_num, dba_name )

'// air line prefix
	prefix = Request.QueryString("pre")
	if isnull(prefix) then prefix = ""
	if trim(prefix) = "" then
	else
		call check_air_prefix ( cType, elt_acc, org_num, prefix  )
	end if

	response.write "ok"

%>
<% 
sub check_air_prefix( cType, elt_acc, rNum, prefix )
	DIM rs,SQL,tmpDba
	SQL = "select TOP 1 dba_name,org_account_number as num from organization where elt_account_number =" & elt_acc &_
		  " and org_account_number <> " & rNum &_
		  " and is_carrier = 'Y' and carrier_code=N'"&  prefix &  "'"		
	Set rs = eltConn.execute (SQL)

	if NOT rs.eof and NOT rs.bof then
		rNum = rs("num")
		tmpDba = rs("dba_name")
				response.write "error#4:" & tmpDba
				rs.Close
				response.end
	end if
	rs.Close
end sub
%>
<% 
sub check_dba_dup( cType, elt_acc, rNum, dba_name )
	
	DIM rs,SQL,first_chr,tmpDba,err_arr,j,tmpASC
	set err_arr = Server.CreateObject("System.Collections.ArrayList")

	first_chr = replace(make_q_text(dba_name),"'","''")


On Error Resume Next:
	SQL = "select dba_name,class_code, org_account_number from organization where elt_account_number =" & elt_acc &_
		  " and org_account_number <> " & rNum &_
		  " and LTRIM(UPPER(dba_name)) like N'"& first_chr & "%' order by dba_name"	
	Set rs = eltConn.execute (SQL)


	tmpDba = filter_alpha(dba_name)
	Do While Not rs.EOF
		if ( dup_test ( rs(0),tmpDba ) ) then
			err_arr.Add  rs(0).value
		end if	
		rs.MoveNext
	Loop
	rs.Close

	if Not IsNull(err_arr) And Not isEmpty(err_arr) And err_arr.count > 0 Then
			response.write "error#3:"
			for j=0 To err_arr.count-1 
				response.write err_arr(j) & chr(13)
			next
			response.end
	end if	
end sub
%>
<%
function make_q_text(dba_name)
	make_q_text = UCase(MID(TRIM(dba_name),1,1))
end function
%>

<%
function dup_test(o_dba_name, tmpDba)
	DIM alpha_string1,alpha_string2,q_dba_name,tmpStr,ChkLen

	q_dba_name = filter_alpha(o_dba_name)

	if tmpDba = q_dba_name then
		dup_test = true
		exit function
	end if

	tmpStr = chk_dupe_inteli(tmpDba,q_dba_name)
	

	ChkLen = ROUND(len(o_dba_name) * 0.2)  '20%


	if LEN(tmpStr) < ChkLen then
		dup_test = true
		exit function
	end if
	dup_test = false	
end function
%>

<%
function chk_dupe_inteli(dba1,dba2)
 DIM tmpChr,tmpStr,j,str1,str2
 
 if LEN(dba1) > LEN(dba2) then
	str1 = dba1
	str2 = dba2
 else
	str2 = dba1
	str1 = dba2	
 end if
 for j = 1 to LEN(str2)
	tmpChr = MID(str2,j,2)
	str1 = replace(str1,tmpChr,"")
 next
 
 chk_dupe_inteli = 	str1

end function
%>

<%
function filter_alpha(text)
DIM j,sLen,tmpChr,tmpStr,tmpASC
 sLen = LEN(TRIM(text))

 if sLen = 0 then
		filter_alpha = text
		exit function
 end if

 tmpStr = ""
 for j = 1 to sLen	
	tmpChr = UCase(MID(text,j,1))
	tmpASC = ASC(tmpChr)
	if( tmpASC >= 65 and tmpASC <= 90 ) then
		tmpStr = tmpStr & tmpChr
	end if
 next
 filter_alpha = tmpStr
end function
%>
