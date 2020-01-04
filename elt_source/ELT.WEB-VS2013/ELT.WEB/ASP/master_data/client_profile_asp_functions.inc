<%
sub get_dba_list_all( default )

DIM rs,SQL,secon_SQL,expr_SQL,readcnt_SQL
DIM tmpTable 

	if not PostBack and filter_string <> "" then
		SQL_filter = get_filter_string_from_org(filter_string)
	end if
'primary SQL
	SQL = "select org_account_number,isnull(dba_name,'') as dba_name, isnull(class_code,'') as class_code, CASE WHEN isnull(account_status,'') = 'A' THEN '' ELSE 'Deactivated' END as account_status,business_city,business_phone,( isnull(owner_fname,'')) as owner_name,owner_phone," &_
	"CASE WHEN isnull(is_consignee,'') = 'Y' THEN '*' ELSE '' END as is_consignee, " &_
	"CASE WHEN isnull(is_shipper,'') = 'Y' THEN '*' ELSE '' END as is_shipper, " &_
	"CASE WHEN isnull(is_agent,'') = 'Y' THEN '*' ELSE '' END as is_agent, " &_
	"CASE WHEN isnull(is_carrier,'') = 'Y' THEN '*' ELSE '' END as is_carrier, " &_
	"CASE WHEN isnull(z_is_trucker,'') = 'Y' THEN '*' ELSE '' END as z_is_trucker, " &_
	"CASE WHEN isnull(z_is_warehousing,'') = 'Y' THEN '*' ELSE '' END as z_is_warehousing, " &_
	"CASE WHEN isnull(z_is_cfs,'') = 'Y' THEN '*' ELSE '' END as z_is_cfs, " &_
	"CASE WHEN isnull(z_is_broker,'') = 'Y' THEN '*' ELSE '' END as z_is_broker, " &_
	"CASE WHEN isnull(z_is_govt,'') = 'Y' THEN '*' ELSE '' END as z_is_govt, " &_
	"CASE WHEN isnull(is_vendor,'') = 'Y' THEN '*' ELSE '' END as is_vendor, " &_
	"CASE WHEN isnull(z_is_special,'') = 'Y' THEN '*' ELSE '' END as z_is_special " &_
	" from organization where elt_account_number=" & elt_account_number 
	
'secondary SQL	
	secon_SQL = ""	
	if SQL_filter <> "" then
		secon_SQL = secon_SQL & SQL_filter
	end if
'////////////////////

	DIM tmpStr,tmpDbaName,expr
	recordCount = 0
	totalCount = 0
	readcnt_SQL = "select isnull(count(dba_name),0) as recCount from organization where elt_account_number=" & elt_account_number
	Set rs = eltConn.Execute(readcnt_SQL)
	totalCount = rs(0)

	readcnt_SQL = ""
	readcnt_SQL = "select isnull(count(dba_name),0) as recCount from organization where elt_account_number=" & elt_account_number & secon_SQL
	Set rs = eltConn.Execute(readcnt_SQL)
	recordCount = rs(0)
'////////////////////
	
	call set_page(secon_SQL,recordCount)
	set code_list = Server.CreateObject("System.Collections.ArrayList")

	expr_SQL = ""

'// set the current page to display	

	if Page_c <> "" then	
		if( Page_c = "?" ) then	
			expr = " dba_name < '0' "
		else
			expr = " dba_name LIKE N'"& Page_c & "%'"
		end if
		expr_SQL = expr_SQL & " and "&expr
	end if

	if SortA <> ""  then
		SQL = SQL & expr_SQL & secon_SQL & " order by " & SortA
	elseif SortD <> "" then
		SQL = SQL & expr_SQL & secon_SQL & " order by " & SortD & " desc"
	else
		SQL = SQL & expr_SQL & secon_SQL & " order by dba_name,class_code"
	end if	

	Set rs = eltConn.Execute(SQL)

	Do While Not rs.EOF
		Set tmpTable = Server.CreateObject("System.Collections.HashTable")
		tmpTable.Add "org_account_number",rs("org_account_number").value
		tmpTable.Add "dba_name",rs("dba_name").value
		tmpTable.Add "class_code",rs("class_code").value  
		tmpTable.Add "business_city",rs("business_city").value
'		tmpTable.Add "business_state",rs("business_state").value
		tmpTable.Add "business_phone",rs("business_phone").value
'		tmpTable.Add "business_fax",rs("business_fax").value
		tmpTable.Add "owner_name",rs("owner_name").value
		tmpTable.Add "owner_phone",rs("owner_phone").value
'		tmpTable.Add "owner_email",rs("owner_email").value
		tmpTable.Add "is_consignee",rs("is_consignee").value
		tmpTable.Add "is_shipper",rs("is_shipper").value
		tmpTable.Add "is_agent",rs("is_agent").value
		tmpTable.Add "is_carrier",rs("is_carrier").value
		tmpTable.Add "z_is_trucker",rs("z_is_trucker").value
		tmpTable.Add "z_is_warehousing",rs("z_is_warehousing").value
		tmpTable.Add "z_is_cfs",rs("z_is_cfs").value
		tmpTable.Add "z_is_broker",rs("z_is_broker").value
		tmpTable.Add "z_is_govt",rs("z_is_govt").value
		tmpTable.Add "is_vendor",rs("is_vendor").value
		tmpTable.Add "z_is_special",rs("z_is_special").value
		code_list.Add tmpTable	
		rs.MoveNext
	Loop
	rs.Close

	if isnull(default) then default = ""
	if code_list.count > 0 then
		if default = "" then default = code_list(0)("code")
	end if	

end sub
%>

<%
sub get_sel_string(selItems)
	SelArray = Split(selItems,"^")
	SelCnt = ubound(SelArray)
end sub
%>

<%
function selChkChange(org)
	DIM flag,ii
	if SelCnt > 0 then
		for ii=0 To SelCnt - 1
				if Trim(SelArray(ii)) <> "" then
					if cInt(SelArray(ii)) = cInt(org) then
						selChkChange = true
						exit function
					end if
				end if
		next 
	else
		selChkChange = false
	end if
end function
%>

<%
function get_filter_string_from_org(filter_string)
	DIM dVal,MyArray,iCnt,i,tmpStr
	MyArray = Split(filter_string,":")
	tmpStr = Join(MyArray,",")
	tmpStr = " AND org_account_number in (" & MID(tmpStr,1,len(tmpStr)-1) & ")"
	get_filter_string_from_org = tmpStr
end function
%>
<%
sub save_code( tmpCode )
DIM rs,SQL,org_num,done
tmpCode = Replace(tmpCode,"'","''")
	Set rs = Server.CreateObject("ADODB.Recordset")
	
	done = false	
	do while done = false
		org_num = get_new_org_num()
		SQL = "select * from organization where elt_account_number="& elt_account_number & " and org_account_number="&org_num
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		If rs.EOF Then
			rs.AddNew
			rs("elt_account_number")=elt_account_number		
			rs("org_account_number")=org_num		
			rs("dba_name")=tmpCode		
			rs("account_status")="A"
			rs.Update
			done = true
		end if
		rs.Close
	loop

	set rs = nothing
	default = tmpCode
end sub
%>
<%
function get_new_org_num
DIM rs,SQL,org_num
	SQL = "select isnull(max(org_account_number),0) as org_num from organization where elt_account_number="& elt_account_number 
	Set rs = eltConn.Execute(SQL)

	if not rs.eof then
		org_num = rs(0)
	else
		org_num = 0
	end if
	
	if isnull(org_num) then
		org_num = 1
	else
		org_num = cInt(org_num) + 1
	end if
	rs.close
	get_new_org_num = org_num
	
end function
%>
<% 
function fill_space( s, spaceLen )
DIM i,tL,tmpS
tL = spaceLen - LEN(s)
tmpS = ""

if tL <= 0 then
	fill_space = ""
	exit function
end if

For i = 0  to tL
	tmpS = tmpS & "&nbsp;"
Next

fill_space = tmpS
end function
%>
<%
sub set_other_field
	set aOtherField = Server.CreateObject("System.Collections.ArrayList")
	set aOtherFieldText = Server.CreateObject("System.Collections.ArrayList")

	call add_other_field_step("isFrequently","Checked as a frequently accessed")	
	call add_other_field_step("account_status","Checked as a deactivated client")	
	call add_other_field_step("known_shipper","Checked as a Known Shipper")	
	call add_other_field_step("comment","Remarks")	
	call add_other_field_step("owner_fname","First name of primary contact")	
	call add_other_field_step("owner_mname","Middle name of primary contact")	
	call add_other_field_step("owner_lname","Last name of primary contact")	
	call add_other_field_step("ower_title","Title of primary contact")	
	call add_other_field_step("owner_departm","Dept. of primary contact")	
	call add_other_field_step("business_phone","Primary phone#1")	
	call add_other_field_step("business_phone2","Primary phone#2")	
	call add_other_field_step("owner_phone","Cell Phone# Primary contact")	
	call add_other_field_step("business_fax","Primary Fax.")	
	call add_other_field_step("owner_email","Email Address of primary contac")	
	call add_other_field_step("business_url","Homepage URL")	
	call add_other_field_step("business_legal_name","Business legal name")	
	call add_other_field_step("business_address","Business Address line #1")	
	call add_other_field_step("business_address2","Business Address line #2")	
	call add_other_field_step("web_login_id","Login ID for Web Site")	
	call add_other_field_step("business_fed_taxid","Tax ID/USPPI")	

	call add_other_field_step("c2FirstName","First name of 2nd contact")	
	call add_other_field_step("c2MiddleName","Middle name of 2nd contact")	
	call add_other_field_step("c2LastName","Last name of 2nd contact")	
	call add_other_field_step("c2Title","Title/Dept. of 3rd contact")	
	call add_other_field_step("c2Phone","Phone# of 2nd contact")	
	call add_other_field_step("c2Cell","Cell Phone# of 2nd contact")	
	call add_other_field_step("c2Fax","Fax# of 2nd contact")	
	call add_other_field_step("c2Email","Email address of 2nd contact")	
	call add_other_field_step("c3FirstName","First name of 3rd contact")	
	call add_other_field_step("c3MiddleName","Middle name of 3rd contact")	
	call add_other_field_step("c3LastName","Last name of 3rd contact")	
	call add_other_field_step("c3Title","Title/Dept. of 3rd contact")	
	call add_other_field_step("c3Phone","Phone# of 3rd contact")	
	call add_other_field_step("c3Cell","Cell Phone# of 3rd contact")	
	call add_other_field_step("c3Fax","Fax# of 3rd contact")	
	call add_other_field_step("c3Email","Email address of 3rd contact")	

	call add_other_field_step("DefaultBroker","Default broker name")	
	call add_other_field_step("broker_info","Default broker info.")	
	call add_other_field_step("carrier_id","SCAC Code / Air line code")	
	call add_other_field_step("carrier_code","Prefix for Air line")	
	call add_other_field_step("z_chl_no","C.H.L Number")	
	call add_other_field_step("z_firm_code","Firms code")	

	call add_other_field_step("bill_term","I/V term")	
	call add_other_field_step("z_attn_txt","I/V Attn.")	
	call add_other_field_step("credit_amt","Credit amount")	
	call add_other_field_step("z_bank_name","Bank name")	
	call add_other_field_step("z_bank_account_no","Bank account No.")	
	call add_other_field_step("owner_mail_address","Billing Address line #1")	
	call add_other_field_step("owner_mail_address2","Billing Address line #2")	
	call add_other_field_step("owner_mail_city","City of billing address")	
	call add_other_field_step("owner_mail_state","State of billing address")	
	call add_other_field_step("owner_mail_zip","Zip# of billing address")	
	call add_other_field_step("owner_mail_country","Country of billing address")	
	call add_other_field_step("agent_elt_acct","Agent's System Account No.")	
	call add_other_field_step("refferedBy","Referred by")	
	call add_other_field_step("SalesPerson","Sales Rep.")	
	call add_other_field_step("colodee_elt_acct_name","Default Coloadee Name")	
	call add_other_field_step("is_colodee","Enable Coloading")	
	call add_other_field_step("edt","Enable EDT")	
	call add_other_field_step("date_opened","Date of creation")	
	call add_other_field_step("last_update","Date of last updated")	
end sub	
%>

<%
sub add_other_field_step(fieldVal,fieldText)
	aOtherField.Add 	fieldVal
	aOtherFieldText.Add fieldText
end sub
%>
<%
sub set_db_filter
DIM rs,SQL
DIM aFieldArray,tempTable,tmpField,strDeli
DIM tmpStr,nullString

		set aFieldArray = Server.CreateObject("System.Collections.ArrayList")

		SQL = "select TOP 1 * from organization"
		Set rs = eltConn.Execute(SQL)

		if not rs.EOF and not rs.bof then
				for each tmpField in rs.Fields 
					Set tempTable = Server.CreateObject("System.Collections.HashTable")
					tempTable.Add "field" ,tmpField.Name
				    tempTable.Add "type", tmpField.Type
					aFieldArray.add tempTable
				next
		end if

		SQL_filter = ""

		for i=0 to aFieldArray.count -1 
'//			On Error Resume Next:
			tmpStr = Request("txt_"& aFieldArray(i)("field"))
			tmpStr = Replace(tmpStr,"'","")
			
			
			if trim(tmpStr) <> "" then
				strDeli = get_deli(aFieldArray(i)("type"))
				nullString = get_null_string(aFieldArray(i)("type"))
                If strDeli = "" Then
                    SQL_filter = SQL_filter & " AND isnull(" & aFieldArray(i)("field") & nullString & " like N'%" & tmpStr & "%'"
                Else
                    SQL_filter = SQL_filter & " AND isnull(" & aFieldArray(i)("field") & nullString & " like N'%" & tmpStr & "%'"
				End If
			end if			
			tmpStr = Request("lst_"& aFieldArray(i)("field"))
			tmpStr = Replace(tmpStr,"'","''")
			if trim(tmpStr) <> "" then
'//				if aFieldArray(i)("field") = "business_country" then
'//				else
					strDeli = get_deli(aFieldArray(i)("type"))
					nullString = get_null_string(aFieldArray(i)("type"))
					
					If strDeli = "" Then
                        SQL_filter = SQL_filter & " AND isnull(" & aFieldArray(i)("field") & nullString & " like " & tmpStr & ""

                    Else
                        SQL_filter = SQL_filter & " AND isnull(" & aFieldArray(i)("field") & nullString & " like N'%" & tmpStr & "%'"

				    End If
'//				end if
			end if			
		next

		call set_chkbox_field( SQL_filter )
		
		v_other_field = Request("lst_other_options")
		if trim(v_other_field) <> "" then
			for i=0 to aFieldArray.count -1 
'			On Error Resume Next:		
				if lcase(aFieldArray(i)("field")) = lcase(v_other_field) then
					if aFieldArray(i)("field") = "account_status" then
						SQL_filter = SQL_filter & " AND isnull(" & aFieldArray(i)("field") & ",'')" & " <> 'A'"
						exit for
					end if
					strDeli = get_deli(aFieldArray(i)("type"))	
					nullString = get_null_string(aFieldArray(i)("type"))					
					v_chkEmpty = Request("chkEmpty")
					if v_chkEmpty = "Y" then
						if strDeli = "'" then
							SQL_filter = SQL_filter & " AND isnull(" & aFieldArray(i)("field") & nullString & " = " & strDeli & "" & strDeli									
						else
							SQL_filter = SQL_filter & aFieldArray(i)("field") & " = 0 "							
						end if
					else
						v_other_options = Request("txt_other_options")
						if v_other_options <> "" then
							if strDeli = "^"  then
								SQL_filter = SQL_filter & " AND isnull(" & aFieldArray(i)("field") & nullString & " = '" & v_other_options & "'" 														
							else
								SQL_filter = SQL_filter & " AND isnull(" & aFieldArray(i)("field") & nullString & " like N" & strDeli & "%" & v_other_options & "%" & strDeli
							end if	
						end if
					end if	
					exit for
				end if
			next
		end if
end sub
%>
<%
sub set_chkbox_field( SQL_filter )
	v_is_consignee = Request("chk_is_consignee")
	if v_is_consignee = "Y" then call add_chkbox_field_to_filter( SQL_filter, "is_consignee")
	
	v_is_shipper = Request("chk_is_shipper") 
	if v_is_shipper = "Y" then call add_chkbox_field_to_filter( SQL_filter, "is_shipper")	
	
	v_is_agent = Request("chk_is_agent")
	if v_is_agent = "Y" then call add_chkbox_field_to_filter( SQL_filter, "is_agent")
	
	v_is_carrier = Request("chk_is_carrier")
	if v_is_carrier = "Y" then call add_chkbox_field_to_filter( SQL_filter, "is_carrier")
	
	v_z_is_trucker = Request("chk_z_is_trucker")
	if v_z_is_trucker = "Y" then call add_chkbox_field_to_filter( SQL_filter, "z_is_trucker")
	
	v_z_is_warehousing = Request("chk_z_is_warehousing")
	if v_z_is_warehousing = "Y" then call add_chkbox_field_to_filter( SQL_filter, "z_is_warehousing")
	
	v_z_is_cfs = Request("chk_z_is_cfs")
	if v_z_is_cfs = "Y" then call add_chkbox_field_to_filter( SQL_filter, "z_is_cfs")
	
	v_z_is_broker = Request("chk_z_is_broker")
	if v_z_is_broker = "Y" then call add_chkbox_field_to_filter( SQL_filter, "z_is_broker")
	
	v_z_is_govt = Request("chk_z_is_govt")
	if v_z_is_govt = "Y" then call add_chkbox_field_to_filter( SQL_filter, "z_is_govt")
	
	v_is_vendor = Request("chk_is_vendor")
	if v_is_vendor = "Y" then call add_chkbox_field_to_filter( SQL_filter, "is_vendor")
	
	v_is_customer = Request("chk_is_customer")
	if v_is_customer = "Y" then call add_chkbox_field_to_filter( SQL_filter, "is_customer")
	
	v_z_is_special = Request("chk_z_is_special")
	if v_z_is_special = "Y" then call add_chkbox_field_to_filter( SQL_filter, "z_is_special")

	v_isFrequently = Request("isFrequently")
	if v_isFrequently = "Y" then call add_chkbox_field_to_filter( SQL_filter, "isFrequently")

	v_known_shipper = Request("known_shipper")
	if v_known_shipper = "Y" then call add_chkbox_field_to_filter( SQL_filter, "known_shipper")

end sub
%>
<%
sub add_chkbox_field_to_filter( SQL_filter, chkField )
SQL_filter = SQL_filter & " AND isnull("&chkField&",'') = 'Y' "
end sub
%>

<%
function get_deli(aField_type)
DIM strDeli
strDeli = ""
				select case aField_type
					case 2   	'smallint
					case 3   	'int
					case 4   	'real
					case 5   	'float
					case 6   	'money
					case 20   	'bigint
					case 128   	'binary
					case 11   	'bit
					case 131  	'decimal
					case 129  	'char
						strDeli = "'"
					case 200  	'varchar
						strDeli = "'"					
					case 202  	'nvarchar
						strDeli = "'"					
					case 203  	'ntext
					    strDeli = "'"
					case 130  	'nchar
					    strDeli = "'"
					case 135  	'date
						strDeli = "^"					
				end select					
get_deli = strDeli
end function
%>
<%
function get_null_string(aField_type)
DIM strNullstirng
strNullstirng = ",0) "
				select case aField_type
					case 2   	'smallint
					case 3   	'int
					case 4   	'real
					case 5   	'float
					case 6   	'money
					case 20   	'bigint
					case 128   	'binary
					case 11   	'bit
					case 131  	'decimal
					case 129  	'char
						strNullstirng = ",'') "
					case 200  	'varchar
						strNullstirng = ",'') "
					case 202  	'nvarchar
						strNullstirng = ",'') "
					case 203  	'ntext
					case 130  	'nchar
					case 135  	'date
						strNullstirng = ",'') "
				end select					
get_null_string = strNullstirng
end function
%>
<%
sub change_status(cStatus)
DIM SQL,dVal,MyArray,iCnt,i,tmpStr,rs
	dVal = Request("lst_code")
	if isnull(dVal) then exit sub
	MyArray = Split(dVal,",")
	tmpStr = Join(MyArray,"','")
	tmpStr = replace(tmpStr,"' ","'")
	SQL = "update organization set account_status = '"& cStatus &"' where elt_account_number="& elt_account_number & " and org_account_number in ('"& tmpStr & "')"
	eltConn.Execute(SQL)	
	SQL = "select isnull(dba_name,'') as dba_name from organization where elt_account_number=" & elt_account_number & " and org_account_number = "& MyArray(0)
	Set rs = eltConn.Execute(SQL)
	if Not rs.EOF then
		default = rs(0)
	end if
	Page_c = 	UCASE(mid(default,1,1))
end sub
%>
<%
sub get_dba_list( default )

if isnull(default) OR default="undefined"  then default = ""
if default <> "" then v_dba_name = default end if

DIM rs,SQL,secon_SQL,expr_SQL,readcnt_SQL
DIM tmpTable 

	if filter_string <> "" then
		SQL_filter = get_filter_string_from_org(filter_string)
	end if

'primary SQL
	SQL = "select org_account_number,isnull(dba_name,'') as dba_name, isnull(class_code,'') as class_code, CASE WHEN isnull(account_status,'') = 'A' THEN '' ELSE 'Deactivated' END as account_status from organization where elt_account_number=" & elt_account_number 
	
'secondary SQL	
	secon_SQL = ""	
	if SQL_filter <> "" then
		secon_SQL = secon_SQL & SQL_filter
	end if
'////////////////////
	DIM tmpStr,tmpDbaName,expr
	recordCount = 0
	totalCount = 0
	readcnt_SQL = "select isnull(count(dba_name),0) as recCount from organization where elt_account_number=" & elt_account_number
	Set rs = eltConn.Execute(readcnt_SQL)
	totalCount = rs(0)

	secon_SQL = replace(secon_SQL,",)",")") '/// 

	readcnt_SQL = ""
	readcnt_SQL = "select isnull(count(dba_name),0) as recCount from organization where elt_account_number=" & elt_account_number & secon_SQL
	Set rs = eltConn.Execute(readcnt_SQL)
	recordCount = rs(0)
'////////////////////
	
	call set_page(secon_SQL,recordCount)
	set code_list = Server.CreateObject("System.Collections.ArrayList")

	expr_SQL = ""

'// set the current page to display	
	if Page_c <> "" then	
			if( Page_c = "?" ) then	
				expr = " dba_name < '0' "
			else
				expr = " dba_name LIKE N'"& Page_c & "%'"
			end if
			expr_SQL = expr_SQL & " and "&expr
	end if

	SQL = SQL & expr_SQL & secon_SQL & " order by dba_name,class_code"

	Set rs = eltConn.Execute(SQL)

	Do While Not rs.EOF
		Set tmpTable = Server.CreateObject("System.Collections.HashTable")
		tmpTable.Add "code",rs("org_account_number").value
		tmpTable.Add "dba_name",rs("dba_name").value
		
		if rs("account_status").value = "" then
			tmpDbaName = rs("dba_name").value 
		else
			tmpDbaName = rs("dba_name").value & " (" & rs("account_status").value & ")"
		end if
		
		tmpStr = tmpDbaName & fill_space(tmpDbaName,60) & " " & rs("class_code").value
		tmpTable.Add "code_description", tmpStr
		tmpTable.Add "description",rs("class_code").value  
		code_list.Add tmpTable	
		rs.MoveNext
	Loop
	rs.Close

	if code_list.count > 0 then
		if default = "" then default = code_list(0)("code")
	end if	
	
end sub
%>