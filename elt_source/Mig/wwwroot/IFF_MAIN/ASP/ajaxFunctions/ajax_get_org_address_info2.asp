
<!--  #INCLUDE FILE="../include/transaction.txt" -->


<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"


%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/AspFunctions.inc" -->
<!-- #include file="../include/JSON_2.0.4.asp" -->
<!-- #include file="../include/JSON_UTIL_0.1.1.asp" -->
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  


%>



<%
DIM elt_account_number,org,arrival_notice

org = Request.QueryString("org")
if isnull(org) then org = ""
if org = ""  then
	response.end
end If

elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")


 Call get_org_info(org)

%>


<%
Sub get_org_info( org )

    Dim rs, SQL    
	Dim AddressInfo,cAcct,cCity,cState,cZip,cCountry,cPhone,cAddress,cName
	
    set rs=Server.CreateObject("ADODB.Recordset")

    if org = "" then Exit sub


SQL= "select DBA_NAME,business_fed_taxid,org_account_number,isnull(business_address,'') as business_address,isnull(business_address2,'') as "&_
	 "business_address2,isnull(business_city,'') as business_city,isnull(business_State,'') as business_State,isnull(business_zip,'') as business_zip,isnull(business_country,'') as business_country,b_country_code,business_state,"&_
	 "isnull(owner_mail_address,'') as owner_mail_address,isnull(owner_mail_address2,'') as owner_mail_address2,"&_
	 "owner_mail_city,isnull(owner_mail_state,'') as owner_mail_state,isnull(owner_mail_zip,'') as owner_mail_zip,isnull(owner_mail_country,'') as owner_mail_country,isnull(business_phone,'') as business_phone,isnull(business_fax,'') as business_fax,isnull(z_attn_txt,'') as z_attn_txt ,isnull(owner_lname,'') as owner_lname,isnull(owner_fname,'') as owner_fname,isnull(owner_mname,'') as owner_mname from organization where elt_account_number = "&_ 
	 elt_account_number & " and org_account_number ="&org

	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
    
    Dim  jsa,col


         	
        Set jsa = jsArray()
        While Not (rs.EOF Or rs.BOF)
            
                Set jsa(Null) = jsObject()

                For Each col In rs.Fields
                    jsa(Null)(col.Name) = col.Value
                Next
        rs.MoveNext
        Wend



	    rs.close
		set rs=nothing 
    jsa.Flush
End sub

'// Added by Joon on Mar/05/2007
'///////////////////////////////////////////////////////////////////////////////////





%>