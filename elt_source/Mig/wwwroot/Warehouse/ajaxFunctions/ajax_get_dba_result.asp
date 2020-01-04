<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/AspFunctions.inc" -->
<!--  #INCLUDE FILE="../master_data/client_profile_declaration.inc" -->

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
Dim i,Page,Page_c,First_Page,Block,PageCount,End_Page,id_num
DIM code_str, code_type,code_list,default,Ret
DIM aPageArray,aOtherField,aOtherFieldText,recordCount,totalCount,filter_string

	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
' On error Resume Next :

	call get_queryString
	filter_string = Request("filter_string")
	if PostBack = "" then PostBack = true
	if not PostBack then
		get_dba_list(default)
	else
		Action = Request.QueryString("Action")
		call set_db_filter()
		select case Action
			case "Search" 
				 get_dba_list(default)					 
			case "Page" 
				 get_dba_list(default)	
			case "save" 
				 Ret = Request.QueryString("retVal")
				 call save_code(Ret)
 				 get_dba_list( Ret )			
			case "delete" 
				 call change_status("")
				 get_dba_list(default)			
			case "activate" 
				 call change_status("A")
				 get_dba_list(default)			
		end select		
	end if
%>
<%
sub get_queryString
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
	default = Request.QueryString("default")
	Page_c = Request.QueryString("Page")
	PostBack = Request.QueryString("PostBack")
	filter_string = ""
end sub 
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/master_data/client_profile_asp_functions.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/master_data/client_profile_set_page.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/client_profile_page_tag.inc" -->
<select class="smallselect" id="lst_code" name="lst_code" size="4" style="height: 300px; width: 485px; font-size: 11px; font-family: 'Courier New', Courier, monospace;" multiple="multiple" onChange="lst_code_on_change(this)" onDBLClick="javascript:doBtn(this.form.bOK);">
                  <% if Not IsNull(code_list) And Not isEmpty(code_list) Then %>
                  <% for i=0 To code_list.count-1 %>
                  <option <% 
						if code_list(i)("dba_name") = default then 
								response.write "selected " 
						end if	
						if instr(code_list(i)("code_description"),"Deactivated") > 0 then 
								response.write "style='color:#FF0000;font:bold'" 
						end if										
						%> value="<%=code_list(i)("code")%>"><%= code_list(i)("code_description") %></option>
                  <% next %>
                  <% end if %>
                </select>
<!--// page break //-->
<% call page_tag %>
<!--// Filtered / Total //-->
<%
	response.write recordCount & "/" & totalCount	
%>