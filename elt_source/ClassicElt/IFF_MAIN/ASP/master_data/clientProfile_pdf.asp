<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #include file="../include/PDFManager.inc" -->
<%


Dim rsOrg, rsContacts,SQL,PDF,r,tIndex,AC_N,AC_P,AC_F,zz
Set rsOrg = Server.CreateObject("ADODB.Recordset")
Dim ClientID
Dim DBA, Legal_Name, TaxID, Address, City, State, Zip, Country, Website
Dim BusinessTypes

Dim Primary_Contact, Phone, Fax, Cell, Email, BI_Address, BI_City, BI_State, BI_Zip, BI_Country, BI_Invoice_Term, BI_Attn

ClientID = request.QueryString("client")

'Response.Write("<script language='javascript'> alert('"&AgentID&"')</script>")

SQL= "select * from organization where elt_account_number = " & elt_account_number & " and org_account_number =" & ClientID

rsOrg.Open SQL, eltConn, , , adCmdText

DBA=rsOrg("dba_name")
If  isNull(DBA) Then DBA="" End if

Legal_Name=rsOrg("business_legal_name")
If  isNull(Legal_Name) Then Legal_Name="" End if

TaxID=rsOrg("business_fed_taxid")
If  isNull(TaxID) Then TaxID="" End if

Address=rsOrg("business_address")
If  isNull(Address) Then Address="" End if

City=rsOrg("business_city")
If  isNull(City) Then City="" End if

State=rsOrg("business_state")
If  isNull(State) Then State="" End if

Zip=rsOrg("business_zip")
If  isNull(Zip) Then Zip="" End if

Country=rsOrg("business_country")
If  isNull(Country) Then Country="" End if

Website=rsOrg("business_url")
If  isNull(Website) Then Website="" End if

If rsOrg("is_consignee")="Y" Then BusinessTypes = BusinessTypes&" "&"consignee" End if
If rsOrg("is_shipper")="Y" Then BusinessTypes = BusinessTypes&" "&"shipper" End if
If rsOrg("is_agent")="Y" Then BusinessTypes = BusinessTypes&" "&"agent" End if
If rsOrg("is_carrier")="Y" Then BusinessTypes = BusinessTypes&" "&"carrier" End if
If rsOrg("z_is_cfs")="Y" Then BusinessTypes = BusinessTypes&" "&"CFS" End if
If rsOrg("z_is_govt")="Y" Then BusinessTypes = BusinessTypes&" "&"Government" End if
If rsOrg("z_is_warehousing")="Y" Then BusinessTypes = BusinessTypes&" "&"warehouse" End if
If rsOrg("z_is_trucker")="Y" Then BusinessTypes = BusinessTypes&" "&"trucker" End if
If rsOrg("z_is_broker")="Y" Then BusinessTypes = BusinessTypes&" "&"CHB" End if


Dim Mname
Mname=rsOrg("owner_mname")
If Not Mname = "" Then
    Primary_Contact=rsOrg("owner_fname")&" "&rsOrg("owner_mname")&" "&rsOrg("owner_lname")
Else 
    Primary_Contact=rsOrg("owner_fname")&" "&rsOrg("owner_lname")
End IF

Phone=rsOrg("business_phone")
If  isNull(Phone) Then Phone="" End if

Fax=rsOrg("business_fax")
If  isNull(Fax) Then Fax="" End if

Cell=rsOrg("owner_phone")
If  isNull(Cell) Then Cell="" End if

Email=rsOrg("owner_email")
If  isNull(Email) Then Email="" End if

BI_Address=rsOrg("owner_mail_address")
If  isNull(BI_Address) Then BI_Address="" End if

BI_City=rsOrg("owner_mail_city")
If  isNull(BI_City) Then BI_City="" End if

BI_State=rsOrg("owner_mail_state")
If  isNull(BI_State) Then BI_State="" End if

BI_Zip=rsOrg("owner_mail_zip")
If  isNull(BI_Zip) Then BI_Zip="" End if

BI_Country=rsOrg("owner_mail_country")
If  isNull(BI_Country) Then BI_Country="" End if

BI_Invoice_Term=rsOrg("bill_term")
If  isNull(BI_Invoice_Term) Then BI_Invoice_Term="" End if

BI_Attn=rsOrg("z_attn_txt")
If  isNull(BI_Attn) Then BI_Attn="" End if





rsOrg.Close
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
response.buffer = True

DIM oFile
oFile = Server.MapPath("../template")

Set PDF =GetNewPDFObject()

r = PDF.OpenOutputFile("MEMORY")
r = PDF.OpenInputFile(oFile+"/client_profile.pdf")
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


PDF.SetFormFieldData "DBA",DBA,0
PDF.SetFormFieldData "Legal_Name", Legal_Name,0
PDF.SetFormFieldData "TaxID",TaxID,0
PDF.SetFormFieldData "Address",  Address,0
PDF.SetFormFieldData "City", City,0
PDF.SetFormFieldData "State", State,0
PDF.SetFormFieldData "Zip", Zip,0
PDF.SetFormFieldData "Country", Country,0
PDF.SetFormFieldData "Website", Website,0
PDF.SetFormFieldData "Primary_Contact", Primary_Contact,0

PDF.SetFormFieldData "Phone", Phone, 0
PDF.SetFormFieldData "Fax", Fax, 0
PDF.SetFormFieldData "Cell", Cell, 0
PDF.SetFormFieldData "Email", Email, 0
PDF.SetFormFieldData "BusinessTypes",BusinessTypes,0

PDF.SetFormFieldData "BI_Address", BI_Address, 0
PDF.SetFormFieldData "BI_City", BI_City,0
PDF.SetFormFieldData "BI_State", BI_State, 0
PDF.SetFormFieldData "BI_Zip", BI_Zip, 0
PDF.SetFormFieldData "BI_Country", BI_Country, 0
PDF.SetFormFieldData "BI_Invoice_Term", BI_Invoice_Term, 0
PDF.SetFormFieldData "BI_Attn", BI_Attn, 0

'Response.Write("<script language='javascript'> alert('"&BI_Attn&"')</script>")

 SQL =  "select * from ig_org_contact where elt_account_number="&elt_account_number& " and org_account_number =" &ClientID

Response.Write("<script language='javascript'> alert('"&ClientID&"')</script>")

Set rsContacts = Server.CreateObject("ADODB.Recordset")

rsContacts.Open SQL, eltConn, , , adCmdText

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
For tIndex=1 To 3
    AC_N ="AC_Name"&tIndex
    AC_P ="AC_Phone"&tIndex
    AC_F ="AC_Fax"&tIndex
    if Not rsContacts.EOF then 
       PDF.SetFormFieldData AC_N, rsContacts("name")&","&rsContacts("job_title"), 0 
       PDF.SetFormFieldData AC_P, rsContacts("phone"),0
       PDF.SetFormFieldData AC_F, rsContacts("fax"),0
       
       'Response.Write("<script language='javascript'> alert('"&AC_N&rsContacts("name")&"')</script>")
       
       rsContacts.MoveNext
       tIndex=tIndex+1       
     else       
       exit for 
    end if    
Next


rsContacts.Close

PDF.FlattenRemainingFormFields = True
R = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
R=PDF.CopyForm(0, 0)

PDF.ResetFormFields

PDF.CloseOutputFile



response.expires = 0
response.clear
response.ContentType = "application/pdf"
response.AddHeader "Content-Type", "application/pdf"
response.AddHeader "Content-Disposition", "attachment; filename=CP" & Session.SessionID & ".pdf"
WritePDFBinary(PDF)

set PDF=nothing
Set rsOrg=Nothing
response.end

%>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
