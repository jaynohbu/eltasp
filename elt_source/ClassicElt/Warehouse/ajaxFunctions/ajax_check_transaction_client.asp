<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/AspFunctions.inc" -->
<!--  #INCLUDE FILE="boardConnection.inc" -->

<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
Response.CharSet = "utf-8"
%>

<%
	if not check_url("IFF_MAIN") then 
		response.write "e"
		response.end
	end if
%>

<%
DIM elt_account_number,source,login_name,UserRight

source = Request.QueryString("src")
if isnull(source) then source = ""

if source = "" then
	response.write "e"
	response.end
end if

' On error Resume Next :
elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
login_name = Request.Cookies("CurrentUserInfo")("login_name")
UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
call chk_tran_by_org( elt_account_number, source )
%>
<% 
sub exist_message(msg, cnt )
if isnull(cnt) then cnt = ""
cnt = trim(cnt)
if cnt = "0" or cnt = "" then
	exit sub
end if

if cnt = "1" then
	response.write "(1) record was found in "&msg&"." & chr(13)
	exit sub
end if

response.write "("&cnt&") records were found in "&msg&"." & chr(13)

end sub
%>
<%
Sub chk_tran_by_org(elt_account_number, source )
DIM SQL,rs

SQL =  " select count(*) from users where elt_account_number = "&elt_account_number&" and isnull(org_acct,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("User Master Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from all_rate_table where elt_account_number = "&elt_account_number&" and isnull(customer_no,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Rate Master Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from cargo_tracking where elt_account_number = "&elt_account_number&" and (isnull(shipper_acct,0) = "&source&" or isnull(consignee_acct,0)="&source&")"
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Cargo Tranking Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from certificate_origin_air where elt_account_number = "&elt_account_number&" and ( isnull(shipper_acct_num,0) = "&source& " or isnull(consignee_acct_num,0) = "&source&" or isnull(agent_acct_num,0)="&source&" or isnull(notify_acct_num,0)="&source&")"
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("C/O of Air Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from certificate_origin_ocean where elt_account_number = "&elt_account_number&" and ( isnull(shipper_acct_num,0) = "&source& " or isnull(consignee_acct_num,0) = "&source&" or isnull(agent_acct_num,0)="&source&" or isnull(notify_acct_num,0)="&source&")"
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("C/O of Ocean Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from colo where colodee_elt_acct = "&elt_account_number&" and isnull(colodee_org_num,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Coload Master Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from delivery_order where elt_account_number = "&elt_account_number&" and ( isnull(shipper_acct,0) = "&source& " or isnull(consignee_acct,0) = "&source&")"
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Delivery Order Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from email_history where elt_account_number = "&elt_account_number&" and isnull(to_org_id,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Email history Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from MAWB_MASTER where elt_account_number = "&elt_account_number&" and ( isnull(airline_vendor_num,0) = "&source& " or isnull(master_agent,0) = "&source&" or isnull(Shipper_account_number,0)="&source&" or isnull(Consignee_acct_num,0)="&source&" or isnull(Notify_no,0)="&source&")"
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("MAWB Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from MAWB_Other_Charge where elt_account_number = "&elt_account_number&" and isnull(vendor_num,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("MAWB Other Charge Data",rs(0))
		 end if
	   end if	


SQL =  " select count(*) from hawb_master where elt_account_number = "&elt_account_number&" and ( isnull(airline_vendor_num,0) = "&source& " or isnull(Agent_No,0) = "&source&" or isnull(Shipper_account_number,0)="&source&" or isnull(Consignee_acct_num,0)="&source&" or isnull(Notify_no,'0')='"&source&"')"
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("HAWB Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from mbol_master where elt_account_number = "&elt_account_number&" and ( isnull(agent_acct_num,0) = "&source& " or isnull(Shipper_acct_num,0) = "&source&" or isnull(Consignee_acct_num,0)="&source&" or isnull(Notify_acct_num,0)="&source&")"
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Master B/L Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from mbol_other_charge where elt_account_number = "&elt_account_number&" and isnull(vendor_num,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Master B/L Other Charge Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from hbol_master where elt_account_number = "&elt_account_number&" and ( isnull(Agent_No,0) = "&source& " or isnull(forward_agent_acct_num,0) = "&source&" or isnull(Shipper_acct_num,0)="&source&" or isnull(Consignee_acct_num,0)="&source&" or isnull(Notify_acct_num,0)="&source&")"
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("House B/L Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from sed_master where elt_account_number = "&elt_account_number&" and isnull(shipper_acct,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Air SED Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from ocean_sed_master where elt_account_number = "&elt_account_number&" and isnull(shipper_acct,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Ocean SED Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from pickup_order where elt_account_number = "&elt_account_number&" and ( isnull(pickup_account_number,0) = "&source& " or isnull(pickup_account_number,0) = "&source&")"
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Pickup Order Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from import_mawb where elt_account_number = "&elt_account_number&" and isnull(agent_org_acct,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Import Deconsolidation Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from mb_cost_item where elt_account_number = "&elt_account_number&" and isnull(vendor_no,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Agent Debit Note(import) Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from import_hawb where elt_account_number = "&elt_account_number&" and ( isnull(agent_org_acct,0) = "&source& " or isnull(shipper_acct,0) = "&source&" or isnull(consignee_acct,0)="&source&" or isnull(notify_acct,0)="&source&" or isnull(broker_acct,0)="&source&")"
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Arrival Notice Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from invoice where elt_account_number = "&elt_account_number&" and isnull(Customer_Number,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Invoice Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from invoice_cost_item where elt_account_number = "&elt_account_number&" and isnull(vendor_no,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Invoice Cost Item Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from invoice_detail where elt_account_number = "&elt_account_number&" and isnull(vendor_no,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Invoice Detail Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from account_payable_journal where elt_account_number = "&elt_account_number&" and isnull(customer_number,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("A/P Data",rs(0))
		 end if
	   end if	
	  
SQL =  " select count(*) from account_receivable_journal where elt_account_number = "&elt_account_number&" and isnull(customer_number,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("A/R Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from all_accounts_journal where elt_account_number = "&elt_account_number&" and isnull(customer_number,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Account Journal Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from bill where elt_account_number = "&elt_account_number&" and isnull(vendor_number,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Bill Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from bill_detail where elt_account_number = "&elt_account_number&" and isnull(vendor_number,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Payable Queue Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from check_queue where elt_account_number = "&elt_account_number&" and isnull(vendor_number,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Check Queue Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from general_journal_entry where elt_account_number = "&elt_account_number&" and isnull(org_acct,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("General Journal Entry Data",rs(0))
		 end if
	   end if	
SQL =  " select count(*) from customer_balance where elt_account_number = "&elt_account_number&" and isnull(customer_acct,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Customer Balance Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from customer_credits where elt_account_number = "&elt_account_number&" and isnull(customer_no,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Customer Credit Data",rs(0))
		 end if
	   end if	

SQL =  " select count(*) from customer_payment where elt_account_number = "&elt_account_number&" and isnull(customer_number,0) = "&source
  	   Set rs = eltConn.execute (SQL)
	   if not rs.eof and not rs.bof then
		 if rs(0) <> "0" then
			call exist_message("Customer Payment Data",rs(0))
		 end if
	   end if	

end sub
%>
