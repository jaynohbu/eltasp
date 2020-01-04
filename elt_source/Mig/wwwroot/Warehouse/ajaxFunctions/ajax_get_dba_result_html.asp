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
DIM aPageArray,aOtherField,aOtherFieldText,recordCount,totalCount,filter_string,selItems,SelArray,SelCnt,SortA,SortD,isFirst

	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
' On error Resume Next :

	call get_queryString
	filter_string = Request("filter_string")
	if PostBack = "" then PostBack = true
	if not PostBack then
		get_dba_list_all(default)
	else
		Action = Request.QueryString("Action")
		call set_db_filter()
		select case Action
			case "Search" 
				 get_dba_list_all(default)					 
			case "Page" 
				 get_dba_list_all(default)	
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
	selItems =  Request.QueryString("sel")
	if isnull(selItems) then selItems = ""
	SelCnt = 0
	if selItems <> "" then get_sel_string(selItems)
	filter_string = ""
	SortA = Request.QueryString("sortA")
	if isnull(SortA) then SortA = ""
	SortD = Request.QueryString("sortD")
	if isnull(SortD) then SortD = ""
	isFirst = Request.QueryString("isFirst")
	if isnull(isFirst) then isFirst = ""
end sub 
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/master_data/client_profile_asp_functions.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/master_data/client_profile_set_page.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/master_data/client_profile_list_table.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/client_profile_page_tag.inc" -->
<!--// page break //-->
<% call page_tag %>
<!--// Filtered / Total //-->
<%
	response.write recordCount & "/" & totalCount	
%>
