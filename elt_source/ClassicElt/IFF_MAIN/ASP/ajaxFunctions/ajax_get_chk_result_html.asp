<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/AspFunctions.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/gl_account_const.inc" -->
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>

<%
	if not check_url("IFF_MAIN") then 
		response.write "e"
		response.end
	end if
%>

<%
DIM elt_account_number,login_name,UserRight
Dim v_other_options,v_other_field,SQL_filter,v_chkEmpty
Dim PostBack,Action	
Dim i,TotalReturnCount
DIM code_str, code_type,code_list,default,Ret
DIM aPageArray,aOtherField,aOtherFieldText,recordCount,totalCount,SelArray,SelCnt,SortA,SortD,isFirst

	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
' On error Resume Next :

	call get_queryString
	if PostBack = "" then PostBack = true
	if not PostBack then
	else
		Action = Request.QueryString("Action")
		select case Action
			case "Search" 
				call get_chk_result
			case "bClear" 
				call clear_chk("Y")
			case "bUclear" 
				call clear_chk("")
			case "bVoid" 
				call void_chk("Y")
			case "bUvoid" 
				call void_chk("")
		end select		
	end if
%>

<%
function OTL( Tran_seq_num )
Tran_seq_num = replace(Tran_seq_num,"::",":")
Tran_seq_num = replace(Tran_seq_num,"::",":")
Tran_seq_num = replace(Tran_seq_num,"::",":")
Tran_seq_num = replace(Tran_seq_num,"::",":")
Tran_seq_num = replace(Tran_seq_num,"::",":")
Tran_seq_num = replace(Tran_seq_num,"::",":")
Tran_seq_num = "(" & replace(Tran_seq_num,":",",") & ")"

Tran_seq_num = replace(Tran_seq_num,"))",")")
Tran_seq_num = replace(Tran_seq_num,"))",")")
Tran_seq_num = replace(Tran_seq_num,"))",")")
Tran_seq_num = replace(Tran_seq_num,"))",")")
Tran_seq_num = replace(Tran_seq_num,"))",")")
Tran_seq_num = replace(Tran_seq_num,"))",")")

Tran_seq_num = replace(Tran_seq_num,"((","(")
Tran_seq_num = replace(Tran_seq_num,"((","(")
Tran_seq_num = replace(Tran_seq_num,"((","(")
Tran_seq_num = replace(Tran_seq_num,"((","(")
Tran_seq_num = replace(Tran_seq_num,"((","(")
Tran_seq_num = replace(Tran_seq_num,"((","(")

Tran_seq_num = replace(Tran_seq_num,",)",")")
Tran_seq_num = replace(Tran_seq_num,",)",")")
Tran_seq_num = replace(Tran_seq_num,",)",")")
Tran_seq_num = replace(Tran_seq_num,",)",")")
Tran_seq_num = replace(Tran_seq_num,",)",")")
Tran_seq_num = replace(Tran_seq_num,",)",")")
Tran_seq_num = replace(Tran_seq_num,",)",")")
Tran_seq_num = replace(Tran_seq_num,"(,","(")
Tran_seq_num = replace(Tran_seq_num,"(,","(")
Tran_seq_num = replace(Tran_seq_num,"(,","(")
Tran_seq_num = replace(Tran_seq_num,"(,","(")
Tran_seq_num = replace(Tran_seq_num,"(,","(")
Tran_seq_num = replace(Tran_seq_num,"(,","(")
Tran_seq_num = replace(Tran_seq_num,"(,","(")
Tran_seq_num = replace(Tran_seq_num,"(,","(")
OTL = Tran_seq_num
end function
%>

<%
sub void_chk(how)
DIM Tran_seq_num
DIM SQL
Tran_seq_num = Request("param")
if isnull(Tran_seq_num) then exit sub
Tran_seq_num = OTL(Tran_seq_num)
SQL = "UPDATE all_accounts_journal set chk_void = N'" & how & "' where elt_account_number="&elt_account_number&" and tran_seq_num in " & Tran_seq_num
eltConn.Execute(SQL)
call get_chk_result
end sub
%>

<%
sub clear_chk(how)
DIM Tran_seq_num
DIM SQL
Tran_seq_num = Request("param")
if isnull(Tran_seq_num) then exit sub
Tran_seq_num = OTL(Tran_seq_num)
SQL = "UPDATE all_accounts_journal set chk_complete = N'" & how & "' where elt_account_number="&elt_account_number&" and tran_seq_num in " & Tran_seq_num
eltConn.Execute(SQL)
call get_chk_result
end sub
%>

<%
sub get_queryString
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
	default = Request.QueryString("default")
	PostBack = Request.QueryString("PostBack")
	SortA = Request.QueryString("sortA")
	if isnull(SortA) then SortA = ""
	SortD = Request.QueryString("sortD")
	if isnull(SortD) then SortD = ""
	isFirst = Request.QueryString("isFirst")
	if isnull(isFirst) then isFirst = ""
end sub 
%>

<%
Function FormatAmount (argStrVal)
    Dim returnVal
	If Not IsNull(argStrVal) And Trim(argStrVal) <> "" Then
		argStrVal = Trim(argStrVal)
		If isnumeric(argStrVal) And Not isempty(argStrVal) Then
			If argStrVal <> "0" Then
				returnVal = FormatNumber(argStrVal,2)
			End If
		Else
			returnVal = argStrVal
		End If
	Else
		returnVal = ""
	End If
	FormatAmount = returnVal
End Function
%>

<%
sub get_chk_result
DIM rs,SQL,subSQL,CountSQL,ListSQL
DIM tmpTable

DIM startDate,endDate,Bank,Opt
Bank=Request("bank")
startDate = Request("startDate")
endDate = Request("endDate")
Opt = Request("Opt")
Set rs = Server.CreateObject("ADODB.Recordset")


subSQL = "   FROM  all_accounts_journal a, gl b" &_
         "   WHERE a.elt_account_number = b.elt_account_number and a.elt_account_number = " & elt_account_number &_
         " 	  AND a.gl_account_number = b.gl_account_number " &_
         "	  AND b.gl_account_type = N'" & CONST__BANK & "'"

		if Bank <> "0" and  Bank <> "" then
			subSQL = subSQL & "	  AND a.gl_account_number = N'" & Bank & "'"
		end if

		if Opt <> "" then
			if Opt = "Uncompleted" then
				subSQL = subSQL & "	  AND isnull(chk_complete,'') <> 'Y'"
			elseif Opt = "Completed" then
				subSQL = subSQL & "	  AND isnull(chk_complete,'') = 'Y'"
			elseif Opt = "Voided" then
				subSQL = subSQL & "	  AND isnull(chk_void,'') = 'Y'"
			end if
		end If
		
		SQL = SQL + "SELECT a.elt_account_number, tran_seq_num, tran_type as Type,convert(char(10),tran_date,101) as Date,"&_
		    "Check_No as Check_No,Memo as Memo,isnull(customer_name,'') as Description, isnull(print_check_as,'') as PrintCheckAs,"&_
		    " CASE WHEN isnull(chk_complete,'') <> '' THEN '*' "&_
		    "      ELSE '' END as Clear,"&_
		    "	CASE WHEN isnull(chk_void,'') <> '' THEN '*' "&_
		    "      ELSE '' END as Void,"&_
		    " CASE WHEN ( debit_amount + isnull(debit_memo,0) + credit_amount + isnull(credit_memo,0)) >= 0 THEN ( debit_amount + isnull(debit_memo,0) + credit_amount + isnull(credit_memo,0)) ELSE 0 END as Debit, "&_ 
		    " CASE WHEN ( debit_amount + isnull(debit_memo,0) + credit_amount + isnull(credit_memo,0)) < 0 THEN -( debit_amount + isnull(debit_memo,0) + credit_amount + isnull(credit_memo,0)) ELSE 0 END as Credit,"&_
		    " air_ocean, tran_num,"&_
		    " REPLACE(REPLACE(UPPER(gl_account_name),'CASH IN BANK-',''),'CASH IN BANK -','') as gl_account_name " & subSQL &_
		    " AND (tran_date >= '" & startDate & "' AND " &_
		    " tran_date < DATEADD(day, 1,'" & endDate & "')) 	and isnull(flag_close,'') <> 'Y' " &_
		    " AND ( tran_type = 'BP-CHK' or tran_type = 'CHK') and isnull(check_no,0) > 0 " 

        If Request("CheckNum") <> "" Then
            SQL = SQL & " AND check_no=" & Request("CheckNum")
        End If

		if SortA <> ""  then
			SQL = SQL &  " order by " & SortA
		elseif SortD <> "" then
			SQL = SQL & " order by " & SortD & " desc"
		else
			SQL = SQL &  " order by tran_date,Check_No"
		end if	
		
		rs.Open SQL, eltConn, adOpenStatic, adLockReadOnly, adCmdText
		TotalReturnCount = rs.RecordCount

		set code_list = Server.CreateObject("System.Collections.ArrayList")
		
		
	Do While Not rs.EOF AND code_list.count < 100
		Set tmpTable = Server.CreateObject("System.Collections.HashTable")
		tmpTable.Add "tran_seq_num",rs("tran_seq_num").value
		tmpTable.Add "tran_num",rs("tran_num").value
		tmpTable.Add "Date",rs("Date").value
		tmpTable.Add "gl_account_name",rs("gl_account_name").value
		tmpTable.Add "Check_No",rs("Check_No").value
		tmpTable.Add "Clear",rs("Clear").value
		tmpTable.Add "Void",rs("Void").value
		tmpTable.Add "Type",rs("Type").value
		if ( LEN(rs("Description").value) <= 18 ) then
			tmpTable.Add "Description",rs("Description").value
		else
			tmpTable.Add "Description", MID(rs("Description").value,1,18) & " ..."
		end if
		if ( LEN(rs("PrintCheckAs").value) <= 18 ) then
			tmpTable.Add "PrintCheckAs",rs("PrintCheckAs").value
		else
			tmpTable.Add "PrintCheckAs", MID(rs("PrintCheckAs").value,1,18) & " ..."
		end if
		if ( LEN(rs("Memo").value) <= 18 ) then
			tmpTable.Add "Memo",rs("Memo").value
		else
			tmpTable.Add "Memo", MID(rs("Memo").value,1,18) & " ..."
		end if

			tmpTable.Add "Debit", rs("Debit").value
			tmpTable.Add "Credit", rs("Credit").value
		code_list.Add tmpTable	
		rs.MoveNext
	Loop
	rs.Close
end sub
%>
				  <% if Not IsNull(code_list) And Not isEmpty(code_list) And code_list.count > 0 Then %>
				  <link href="/iff_main/ASP/css/elt_css.css" rel="stylesheet" type="text/css" />
				  <style type="text/css">
<!--
.style1 {color: #000000}
-->
                  </style>
				  
				<table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                <tr>
                    <td height="9" colspan="10" align="center"></td>
                    </tr>
                <tr>
                    <td width="22" align="center" class="bodyheader">&nbsp;</td>
                  <td width="84" align="left" valign="middle" class="bodyheader"><span class="bodyheader">
                    <input class="bodycopy" id="bRefresh" style="width: 80px; height:22px" type="button" value="Refresh" onClick="javascript:doBtn(this);">
                  </span></td>
                  <td width="26" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                  <td width="80" align="left" valign="middle" class="bodyheader"><span class="bodyheader">
                    <input class="bodycopy" id="bSelAll" style="width: 80px; height:22px" type="button" value="Select All" onClick="javascript:doBtn(this);">
                  </span></td>
                  <td width="25" align="left" valign="middle" class="bodycopy">&nbsp;</td>
<td width="80" align="left" valign="middle" class="bodyheader"><input class="bodycopy" id="bUselAll" style="width: 80px; height:22px" type="button" value="Unselect All" onClick="javascript:doBtn(this);"></td>				  
                  <td width="25" align="left" valign="middle" class="bodycopy">&nbsp;</td>				  
                  <td width="80" align="left" valign="middle" class="bodyheader"><span class="bodyheader">
                    <input class="bodycopy" id="bClear" style="width: 80px; height:22px" type="button" value="Complete" onClick="javascript:doBtn(this);">
                  </span></td>
                  <td width="28" align="left" valign="middle" class="bodycopy">&nbsp;</td>				  
<td width="762" align="left" valign="middle" class="bodyheader"><input class="bodycopy" id="bUclear" style="width: 80px; height:22px" type="button" value="Incomplete" onClick="javascript:doBtn(this);"></td>				  
                </tr>
                <tr>
                    <td height="6" colspan="10" align="center"></td>
                    </tr>
					<tr><td height="1" colspan="10" bgcolor="#89A979"></td>
					</tr>
			    <tr>
			        <td></td>
			        <td colspan="9">
			            <%=code_list.count %> of <%=TotalReturnCount %> Records
			        </td>
			    </tr>
              </table>
                  <table width="100%" border="0" cellpadding="1" cellspacing="1">
                      <tr class="bodyheader" style="color:White;background-color:DimGray;height:20px;">
                        <td height="18" align="center" bgcolor="#D5E8CB">&nbsp;</td>
                        <td align="left" bgcolor="#D5E8CB" id='Date' style="cursor:hand" onclick='javascript:result_sort(this);' value="<%
						if SortA = "Date" then 
							response.write ("A")
						elseif SortD = "Date" then 
							response.write ("D")
						end if
						%>"><span class="bodyheader">Date</span></td>
                        <td align="left" bgcolor="#D5E8CB" id='gl_account_name' style="cursor:hand" onclick='javascript:result_sort(this);' value="<%
						if SortA = "gl_account_name" then 
							response.write ("A")
						elseif SortD = "gl_account_name" then 
							response.write ("D")
						end if
						%>"><span class="bodyheader">Bank Account</span></td>
		                <td align="left" bgcolor="#D5E8CB" id='Check_No' style="cursor:hand" onclick='javascript:result_sort(this);' value="<%
						if SortA = "Check_No" then 
							response.write ("A")
						elseif SortD = "Check_No" then 
							response.write ("D")
						end if
						%>"><span class="bodyheader">Check</span></td>
		                <td align="left" bgcolor="#D5E8CB" id='Clear' style="cursor:hand" onclick='javascript:result_sort(this);' value="<%
						if SortA = "Clear" then 
							response.write ("A")
						elseif SortD = "Clear" then 
							response.write ("D")
						end if
						%>"><span class="bodyheader">Clear</span></td>
                        <td align="left" bgcolor="#D5E8CB" id='Void' style="cursor:hand" onclick='javascript:result_sort(this);' value="<%
						if SortA = "Void" then 
							response.write ("A")
						elseif SortD = "Void" then 
							response.write ("D")
						end if
						%>"><span class="bodyheader">Void</span></td>
                        <td align="left" bgcolor="#D5E8CB" id='Type' style="cursor:hand" onclick='javascript:result_sort(this);' value="<%
						if SortA = "Type" then 
							response.write ("A")
						elseif SortD = "Type" then 
							response.write ("D")
						end if
						%>"><span class="bodyheader">Type</span></td>
                        <td align="left" bgcolor="#D5E8CB" id='Description' style="cursor:hand" onclick='javascript:result_sort(this);' value="<%
						if SortA = "Description" then 
							response.write ("A")
						elseif SortD = "Description" then 
							response.write ("D")
						end if
						%>"><span class="bodyheader">Company Name</span></td>
                        <td align="left" bgcolor="#D5E8CB" id='PrintCheckAs' style="cursor:hand" onclick='javascript:result_sort(this);' value="<%
						if SortA = "PrintCheckAs" then 
							response.write ("A")
						elseif SortD = "PrintCheckAs" then 
							response.write ("D")
						end if
						%>"><span class="bodyheader">Pay to the Order of</span></td>
                        <td align="left" bgcolor="#D5E8CB" id='Memo' style="cursor:hand" onclick='javascript:result_sort(this);' value="<%
						if SortA = "Memo" then 
							response.write ("A")
						elseif SortD = "Memo" then 
							response.write ("D")
						end if
						%>"><span class="bodyheader">Memo</span></td>
                        <td align="left" bgcolor="#D5E8CB" id='Debit' style="cursor:hand" onclick='javascript:result_sort(this);' value="<%
						if SortA = "Debit" then 
							response.write ("A")
						elseif SortD = "Debit" then 
							response.write ("D")
						end if
						%>"><span class="bodyheader">Debit(+)</span></td>
                        <td align="left" bgcolor="#D5E8CB" id='Credit' style="cursor:hand" onclick='javascript:result_sort(this);' value="<%
						if SortA = "Credit" then 
							response.write ("A")
						elseif SortD = "Credit" then 
							response.write ("D")
						end if
						%>"><span class="bodyheader">Credit(-)</span></td>
                      </tr>
					  <% DIM selChk %>
                      <% for i=0 To code_list.count-1 %>
					  <% 
							selChk = false
							if SelCnt > 0 then
								selChk = selChkChange(code_list(i)("tran_seq_num"))
							end if
					  %>
						  <% if ( i mod 2 = 1 ) then%>
							<tr align="left" class="bodycopy"  style="background-color:#E0E0E0" >
						  <% else %>
							<tr align="left" class="bodycopy" style="background-color:White">
						  <% end if %>
                        <td style="width:10px;cursor:hand" onClick="DoChecking('<%=code_list(i)("tran_seq_num")%>');"><img border="0" align="absmiddle" src="../images/checkbox_<% if selChk then  response.write("o") else response.write("n") end if%>.gif" id='img<%=code_list(i)("tran_seq_num")%>' checkeditem="<% if selChk then  response.write("Y") else response.write("N") end if%>" onClick="ItemWasChecked(this);" WIDTH="10" HEIGHT="10"><input type="hidden" name="chk" id='chkimg<%=code_list(i)("tran_seq_num")%>' seq='<%=code_list(i)("tran_seq_num")%>'<% if selChk then response.write (" value='off'") %>></td>
                        <td style="width:20px;"><a href="javascrip:;" OnClick="goLink('<%=code_list(i)("Type")%>','<%=code_list(i)("tran_num")%>');return false;"><% response.write code_list(i)("Date") %></a></td>
						<td height="18" style="width:130px;"><a href="javascrip:;" OnClick="goLink('<%=code_list(i)("Type")%>','<%=code_list(i)("tran_num")%>');return false;"><% response.write code_list(i)("gl_account_name") %></a></td>
						<td style="width:20px;"><a href="javascrip:;" OnClick="goLink('<%=code_list(i)("Type")%>','<%=code_list(i)("tran_num")%>');return false;"><% response.write code_list(i)("Check_No") %></a></td>
                        <td align="center" valign="middle" style="width:10px;<% if code_list(i)("Clear") <> "" then response.write "background-color:#A3C54C"%>" ><a href="javascrip:;" OnClick="goLink('<%=code_list(i)("Type")%>','<%=code_list(i)("tran_num")%>');return false;"><% response.write code_list(i)("Clear") %></a></td>
                        <td align="center" valign="middle" style="width:10px;<% if code_list(i)("Void") <> "" then response.write "background-color:#CD1D06"%>"><a href="javascrip:;" OnClick="goLink('<%=code_list(i)("Type")%>','<%=code_list(i)("tran_num")%>');return false;"><% response.write code_list(i)("Void") %></a></td>
                        <td style="width:50px;"><a href="javascrip:;" OnClick="goLink('<%=code_list(i)("Type")%>','<%=code_list(i)("tran_num")%>');return false;"><% response.write code_list(i)("Type") %></a></td>
                        <td style="width:145px;"><a href="javascrip:;" OnClick="goLink('<%=code_list(i)("Type")%>','<%=code_list(i)("tran_num")%>');return false;"><% response.write code_list(i)("Description")%></a></td>
                        <td style="width:145px;"><a href="javascrip:;" OnClick="goLink('<%=code_list(i)("Type")%>','<%=code_list(i)("tran_num")%>');return false;"><% response.write code_list(i)("PrintCheckAs")%></a></td>
                        <td style="width:145px;"><a href="javascrip:;" OnClick="goLink('<%=code_list(i)("Type")%>','<%=code_list(i)("tran_num")%>');return false;"><% response.write code_list(i)("Memo") %></a></td>
                        <td style="width:70px;" align="right" ><a href="javascrip:;" OnClick="goLink('<%=code_list(i)("Type")%>','<%=code_list(i)("tran_num")%>');return false;"><%= FormatAmount(code_list(i)("Debit")) %></a></td>
                        <td style="width:70px;" align="right" ><a href="javascrip:;" OnClick="goLink('<%=code_list(i)("Type")%>','<%=code_list(i)("tran_num")%>');return false;"><%= FormatAmount(code_list(i)("Credit")) %></a></td>
                       </tr>
                      <% next %>
                </table>
                  <% else %>
	<span style="font-size: 10px;font-weight: bold;color: #000000" class="bodycopy">No data was found.</span><br><br><a href="javascript:" onclick="javascript:self.location='/iff_main/ASP/acct_tasks/manage_chk.asp?PostBack=false';return false;">Please click here to return.</a>
                  <% end if %>
