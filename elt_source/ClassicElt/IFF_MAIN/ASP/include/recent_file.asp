
<%
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	user_id = Request.Cookies("CurrentUserInfo")("user_id")
	DIM sURL,sQuery,tmpSoTitle

	sURL	= request.ServerVariables("URL")
	sQuery	= request.ServerVariables("QUERY_STRING")

	sURL = getTitle(sURL)
	tmpSoTitle = getSoTotle(sURL)
	call SelectTransaction (sURL, tmpSoTitle)

%>

<%

Sub Register_new_edit_hawb( strSoTitle )
	if	Save="yes" then
		sURL = 	"/IFF_MAIN/ASP/air_export/new_edit_hawb.asp?Edit=YES&HAWB=" & vHAWB
		call recentRegisterDB (sURL,vHAWB,"Save HAWB", strSoTitle)
	end if

End Sub

Sub Register_new_edit_mawb( strSoTitle )
	if	Save="yes" then
		sURL = 	"/IFF_MAIN/ASP/air_export/new_edit_mawb.asp?Edit=YES&MAWB=" & vMAWB
		call recentRegisterDB (sURL,vMAWB,"Save MAWB", strSoTitle)
	end if

End Sub

Sub Register_new_edit_hbol( strSoTitle )
	if	Save="yes" then
		sURL = 	"/IFF_MAIN/ASP/ocean_export/new_edit_hbol.asp?Edit=YES&HBOL=" & vHBOL
		call recentRegisterDB (sURL, vHBOL,"", strSoTitle)
	end if

End Sub

Sub Register_new_edit_mbol( strSoTitle )
	if	Save="yes" then
		sURL = 	"/IFF_MAIN/ASP/ocean_export/new_edit_mbol.asp?Edit=YES&BookingNum=" & vBookingNum
		call recentRegisterDB (sURL, vBookingNum,"", strSoTitle)
	end if

End Sub

Sub Register_new_edit_invoice( strSoTitle )
	if	Save="yes" then
		sURL = 	"/IFF_MAIN/ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" & InvoiceNo
		call recentRegisterDB (sURL, InvoiceNo,"", strSoTitle)
	end if

End Sub

Sub Register_air_import2( strSoTitle )
	if	Save="yes" then
		sURL = 	"/IFF_MAIN/ASP/air_import/air_import2.asp?iType=" & iType & "&Edit=yes&MAWB=" & vMAWB & "&Sec=" & vSec & "&AgentOrgAcct=" & vAgentOrgAcct
		call recentRegisterDB (sURL, vMAWB,"", strSoTitle)
	end if

End Sub

Sub Register_ocean_import2( strSoTitle )
	if	Save="yes" then
		sURL = 	"/IFF_MAIN/ASP/ocean_import/ocean_import2.asp?iType=" & iType & "&Edit=yes&MAWB=" & vMAWB & "&Sec=" & vSec & "&AgentOrgAcct=" & vAgentOrgAcct
		call recentRegisterDB (sURL, vMAWB,"", strSoTitle)
	end if

End Sub

Sub Register_new_edit_air_book( strSoTitle )
	if	Save="yes" then
		sURL = 	"/IFF_MAIN/ASP/air_export/booking.asp?Edit=yes&MAWB=" & vMAWB
		call recentRegisterDB (sURL, vMAWB,"", strSoTitle)
	end if

End Sub

Sub Register_new_edit_ocean_book( strSoTitle )
	if	Save="yes" then
		sURL = 	"/IFF_MAIN/ASP/ocean_export/booking.asp?Edit=yes&lstBookingNum=" & vBookingNum
		call recentRegisterDB (sURL, vMAWB,"", strSoTitle)
	end if

End Sub


Sub Register_new_air_pre_alert( strSoTitle )
	if	Send="yes" then
		sURL = 	"/IFF_MAIN/ASP/air_export/pre_alert.asp?rEdit=yes&rMAWB=" & vMAWB
		call recentRegisterDB (sURL, vMAWB,"", strSoTitle)
	end if
End Sub

Sub Register_new_ocean_pre_alert( strSoTitle )
	if	Send="yes" then
		sURL = 	"/IFF_MAIN/ASP/ocean_export/pre_alert.asp?rEdit=yes&rMAWB=" & vMAWB
		call recentRegisterDB (sURL, vMAWB,"", strSoTitle)
	end if
End Sub

Sub Register_new_air_shipping_notice( strSoTitle )
	if	Send="yes" then
		sURL = 	"/IFF_MAIN/ASP/air_export/shipping_notice.asp?rEdit=yes&rMAWB=" & vMAWB
		call recentRegisterDB (sURL, vMAWB,"", strSoTitle)
	end if
End Sub

Sub Register_new_ocean_shipping_notice( strSoTitle )
	if	Send="yes" then
		sURL = 	"/IFF_MAIN/ASP/ocean_export/shipping_notice.asp?rEdit=yes&rMAWB=" & vMAWB
		call recentRegisterDB (sURL, vMAWB,"", strSoTitle)
	end if
End Sub

Sub Register_air_import_proof_delivery( strSoTitle )
	if	Send="yes" then
		sURL = 	"/IFF_MAIN/ASP/air_import/proof_delivery.asp?rEdit=yes&rMAWB=" & vMAWB
		call recentRegisterDB (sURL, vMAWB,"", strSoTitle)
	end if
End Sub

Sub Register_air_import_proof_delivery( strSoTitle )
	if	Send="yes" then
		sURL = 	"/IFF_MAIN/ASP/air_import/proof_delivery.asp?rEdit=yes&rMAWB=" & vMAWB
		call recentRegisterDB (sURL, vMAWB,"", strSoTitle)
	end if
End Sub

Sub Register_ocean_import_proof_delivery( strSoTitle )
	if	Send="yes" then
		sURL = 	"/IFF_MAIN/ASP/ocean_import/proof_delivery.asp?rEdit=yes&rMAWB=" & vMAWB
		call recentRegisterDB (sURL, vMAWB,"", strSoTitle)
	end if
End Sub


Sub Register_ocean_import_earrival_notice( strSoTitle )
	if	Send="yes" then
		sURL = 	"/IFF_MAIN/ASP/ocean_import/earrival_notice.asp?rEdit=yes&rMAWB=" & vMAWB
		call recentRegisterDB (sURL, vMAWB,"", strSoTitle)
	end if
End Sub

Sub Register_air_import_earrival_notice( strSoTitle )
	if	Send="yes" then
		sURL = 	"/IFF_MAIN/ASP/air_import/earrival_notice.asp?rEdit=yes&rMAWB=" & vMAWB
		call recentRegisterDB (sURL, vMAWB,"", strSoTitle)
	end if
End Sub

Sub Register_edit_User( strSoTitle )
	if	UpdateUser="yes" then
		sURL = 	"/IFF_MAIN/ASP/site_admin/edit_user.asp?EditUser=yes&UserID="&UserID
		call recentRegisterDB (sURL, UserID,"Update user info. for " & varr_LoginID, strSoTitle)
	end If
	if	DeleteUser="yes" then
		sURL = 	"/IFF_MAIN/ASP/site_admin/edit_user.asp"
		call recentRegisterDB (sURL, UserID,"Delete user info. for " & varr_LoginID, strSoTitle)
	end if
	
End Sub


Sub Register_co_config( strSoTitle )
	if	Save="yes" then
		sURL = 	"/IFF_MAIN/ASP/site_admin/co_config.asp"
		call recentRegisterDB (sURL, "","Update company info.", strSoTitle)
	end if
End Sub

Sub Register_edit_port( strSoTitle )
Dim strDesc,strCode

	sURL = 	"/IFF_MAIN/ASP/master_data/edit_port.asp"

	if	delete="yes" Then
		strDesc = "Delete port code.:" & dPortCode
		strCode = dPortCode
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	ElseIf add="yes" then
		strDesc = "Add port code.:" & vPortCode
		strCode = vPortCode
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	ElseIf update="yes" then
		strDesc = "Update port code.:" & vPortCode
		strCode = vPortCode
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	end if	


End Sub

Sub Register_edit_Freight( strSoTitle )
Dim strDesc,strCode

	sURL = 	"/IFF_MAIN/ASP/master_data/edit_freight.asp"

	if	delete="yes" Then
		strDesc = "Delete freight code.:" & dFirmCode
		strCode = dFirmCode
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	ElseIf add="yes" then
		strDesc = "Add freight code.:" & vFirmCode
		strCode = vFirmCode
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	ElseIf update="yes" then
		strDesc = "Update freight code.:" & vFirmCode
		strCode = vFirmCode
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	end if	


End Sub

Sub Register_edit_sche_b( strSoTitle )
Dim strDesc,strCode

	sURL = 	"/IFF_MAIN/ASP/master_data/edit_sche_b.asp"

	if	delete="yes" Then
		strDesc = "Delete Schedule B :" & dSB
		strCode = dSB
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	ElseIf add="yes" then
		strDesc = "Add Schedule B :" & vSB
		strCode = vSB
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	ElseIf update="yes" then
		strDesc = "Update Schedule B :" & vSB
		strCode = vSB
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	end if	


End Sub

Sub Register_MAWB_NO( strSoTitle )
Dim strDesc,strCode

	sURL = 	"/IFF_MAIN/ASP/master_data/new_edit_mawb.asp"
	if	Go="yes" Then
		strDesc = "Create MAWB No.:" & vStartNo & "~" & vEndNo
		strCode = vStartNo & "~" & vEndNo
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	end if	


End Sub


Sub Register_receiv_pay( strSoTitle )
Dim strDesc,strCode

	sURL = 	"/IFF_MAIN/ASP/acct_tasks/receiv_pay.asp?PaymentNo="&recentPaymentNo
	if	DeletePMT="yes" Then
		strDesc = "Delete Payment : " & recentPaymentNo
		strCode = recentPaymentNo
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	elseif	UpdatePMT="yes" Then
		strDesc = "Update Payment : " & recentPaymentNo
		strCode = recentPaymentNo
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	elseif	save="yes" Then
		strDesc = "Create Payment : " & recentPaymentNo
		strCode = recentPaymentNo
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	End if


End Sub

Sub Register_enter_bill( strSoTitle )
Dim strDesc,strCode

	sURL = 	"/IFF_MAIN/ASP/acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" & BillNo
	if	DeleteBill="yes" Then
		strDesc = "Delete Bill : " & BillNo
		strCode = BillNo
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	elseif	Save="yes" Then
		strDesc = "Create or Update Bill : " & BillNo
		strCode = BillNo
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	End if


End Sub


Sub Register_pay_bills( strSoTitle )
Dim strDesc,strCode

	sURL = 	"/IFF_MAIN/ASP/acct_tasks/pay_bills.asp?EditCheck=yes&CheckQueueID="&PrintID
	if	DeleteCheck="yes" Then
		strDesc = "Del. P.Bill (Print ID): " & PrintID
		strCode = PrintID
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	elseif	Save="yes" Then
		strDesc = "Upd. Pay Bill (Print ID): " & PrintID
		strCode = PrintID
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	End if


End Sub

Sub Register_write_chk( strSoTitle )
Dim strDesc,strCode

'	sURL = 	"/IFF_MAIN/ASP/acct_tasks/write_chk.asp?EditCheck=yes&CheckQueueID=" & PrintID & "&VendorNo=" & VendorNo & "&Bank=" & Bank 
	sURL = 	"/IFF_MAIN/ASP/acct_tasks/write_chk.asp" 
	if	Save="yes" Then
		strDesc = "Save or Print Check (Print ID): " & PrintID
		strCode = PrintID
		call recentRegisterDB (sURL,strCode,strDesc, strSoTitle)
	End if


End Sub

'////////////////////////////////////////////////////////////////////////////////////
'/////////////////// Register into Recent Work List
'////////////////////////////////////////////////////////////////////////////////////

Sub SelectTransaction(sURL, strSoTitle)
	Select Case sURL
		case "site_admin/edit_user.asp" call Register_edit_User( strSoTitle )
		case "site_admin/co_config.asp" call Register_co_config( strSoTitle )
		case "Board/List.aspx"
		case "Misc/FavoriteManagement.aspx"
		case "CompanyConfig/CompanyConfigCreate.aspx"
		case "Rate/RateManagement.aspx"
		case "master_data/edit_port.asp" call Register_edit_port( strSoTitle )
		case "master_data/edit_freight.asp" call Register_edit_Freight( strSoTitle )
		case "master_data/edit_sche_b.asp" call Register_edit_sche_b( strSoTitle )
		case "master_data/booking_number_ok.asp" call Register_MAWB_NO( strSoTitle )
		case "air_export/booking.asp" call Register_new_edit_air_book( strSoTitle )
		case "air_export/new_edit_hawb.asp" call Register_new_edit_hawb( strSoTitle )
		case "air_export/new_edit_mawb.asp" call Register_new_edit_mawb( strSoTitle )
		case "air_export/sed.asp"
		case "air_export/pre_alert.asp" call Register_new_air_pre_alert( strSoTitle )
		case "air_export/shipping_notice.asp" call Register_new_air_shipping_notice( strSoTitle )
		case "air_export/print_label.asp"
		case "air_export/ae_search.asp"
		case "ocean_export/shipp_request.asp"
		case "ocean_export/booking.asp" call Register_new_edit_ocean_book( strSoTitle )
		case "ocean_export/new_edit_hbol.asp" call Register_new_edit_hbol( strSoTitle )
		case "ocean_export/new_edit_mbol.asp" call Register_new_edit_mbol( strSoTitle )
		case "ocean_export/sed.asp"
		case "ocean_export/pre_alert.asp" call Register_new_ocean_pre_alert( strSoTitle )
		case "ocean_export/shipping_notice.asp" call Register_new_ocean_shipping_notice( strSoTitle )
		case "ocean_export/print_label.asp"
		case "ocean_export/oe_search.asp"
		case "air_import/air_import1.asp"
		case "air_import/air_import2.asp" call Register_air_import2( strSoTitle )
		case "air_import/proof_delivery.asp" call Register_air_import_proof_delivery( strSoTitle )
		case "air_import/ai_search.asp"
		case "air_import/earrival_notice.asp" call Register_air_import_earrival_notice( strSoTitle )
		case "ocean_import/ocean_import1.asp"
		case "ocean_import/ocean_import2.asp" call Register_ocean_import2( strSoTitle )
		case "ocean_import/proof_delivery.asp" call Register_ocean_import_proof_delivery( strSoTitle )
		case "ocean_import/oi_search.asp"
		case "ocean_import/earrival_notice.asp" call Register_ocean_import_earrival_notice( strSoTitle )
		case "acct_tasks/create_invoi.asp"
		case "acct_tasks/edit_invoice.asp" call Register_new_edit_invoice( strSoTitle )
		case "Accounting/SearchInvoiceSelection.aspx"
		case "acct_tasks/receiv_pay.asp" call Register_receiv_pay( strSoTitle )
		case "acct_tasks/enter_bill.asp" call Register_enter_bill( strSoTitle )
		case "acct_tasks/pay_bills.asp" call Register_pay_bills( strSoTitle )
		case "acct_tasks/write_chk.asp" call Register_write_chk( strSoTitle )
		case "acct_tasks/print_chk.asp"
		case "acct_tasks/chart_acct.asp"
		case "acct_tasks/edit_co_items.asp"
		case "acct_tasks/edit_ch_items.asp"
		case "acct_tasks/gj_entry.asp"
		case "acct_reports/sales.asp"
		case "Accounting/ARAgingSelection.aspx"
		case "acct_reports/ar_aging_det.asp"
		case "acct_reports/ar_summ.asp"
		case "acct_reports/ar_detail.asp"
		case "acct_reports/expenses.asp"
		case "Accounting/APAgingSelection.aspx"
		case "acct_reports/ap_aging_det.asp"
		case "acct_reports/ap_summary.asp"
		case "acct_reports/ap_detail.asp"
		case "acct_reports/trial_balance.asp"
		case "acct_reports/balance_sheet.asp"
		case "acct_reports/income_state.asp"
		case "acct_reports/gen_ledger.asp"
		case "acct_reports/check_register.asp"
		case "AirExportBooking/AirExportBookingReportSelection.aspx"
		case "AirExportHAWB/AirExportOperationSelectionHAWB.aspx"
		case "AirExportMAWB/AirExportOperationSelectionMAWB.aspx"
		case "OceanExportBooking/OceanExportBookingReportSelection.aspx"
		case "OceanExportHBOL/OceanExportOperationSelectionHBOL.aspx"
		case "OceanExportMBOL/OceanExportOperationSelectionMBOL.aspx"
		case "Import/AirImportReportSelection.aspx"
		case "Import/OceanImportReportSelection.aspx"
		case "CompanyConfig/CompanySearchSelection.aspx"
		case "AMS/AMS_EDI_Ocean.aspx"
	End Select

End Sub

Function getSoTotle(sURL)
DIM strSoTitle
	Select Case sURL
                case "site_admin/edit_user.asp"	 strSoTitle = "SA->User Admin"
                case "site_admin/co_config.asp"	 strSoTitle = "SA->Config."
                case "Board/List.aspx"	 strSoTitle = "SA->MSG Board"
                case "Misc/FavoriteManagement.aspx"	 strSoTitle = "SA->Fav.Man"
                case "CompanyConfig/CompanyConfigCreate.aspx"	 strSoTitle = "MD->Cli.Profile"
                case "Rate/RateManagement.aspx"	 strSoTitle = "MD->AE Rate"
                case "master_data/edit_port.asp"	 strSoTitle = "MD->Port"
                case "master_data/edit_freight.asp"	 strSoTitle = "MD->F.Location"
                case "master_data/edit_sche_b.asp"	 strSoTitle = "MD->Sched.B"
                case "master_data/booking_number_ok.asp"	 strSoTitle = "MD->MAWB.No"
                case "air_export/booking.asp"	 strSoTitle = "AE->Booking"
                case "air_export/new_edit_hawb.asp"	 strSoTitle = "AE->HAWB"
                case "air_export/new_edit_mawb.asp"	 strSoTitle = "AE->MAWB"
                case "air_export/sed.asp"	 strSoTitle = "AE->SED"
                case "air_export/pre_alert.asp"	 strSoTitle = "AE->Agent Pre-Alert"
                case "air_export/shipping_notice.asp"	 strSoTitle = "AE->Shipping Notice"
                case "air_export/print_label.asp"	 strSoTitle = "AE->Ship.Label"
                case "air_export/ae_search.asp"	 strSoTitle = "AE->AE Search"
                case "ocean_export/shipp_request.asp"	 strSoTitle = "OE->S/R"
                case "ocean_export/booking.asp"	 strSoTitle = "OE->Booking"
                case "ocean_export/new_edit_hbol.asp"	 strSoTitle = "OE->HBOL"
                case "ocean_export/new_edit_mbol.asp"	 strSoTitle = "OE->MBOL"
                case "ocean_export/sed.asp"	 strSoTitle = "OE->SED"
                case "ocean_export/pre_alert.asp"	 strSoTitle = "OE->Agent Pre-Alert"
                case "ocean_export/shipping_notice.asp"	 strSoTitle = "OE->Shipping Notice"
                case "ocean_export/print_label.asp"	 strSoTitle = "OE->Ship.Label"
                case "ocean_export/oe_search.asp"	 strSoTitle = "OE->OE Search"
                case "air_import/air_import1.asp"	 strSoTitle = "AI->New Decon.Sch."
                case "air_import/air_import2.asp"	 strSoTitle = "AI->Edit Decon.Sch."
                case "air_import/proof_delivery.asp"	 strSoTitle = "AI->POD"
                case "air_import/ai_search.asp"	 strSoTitle = "AI->AI Search"
                case "air_import/earrival_notice.asp"	 strSoTitle = "AI->eArrival Notice"
                case "ocean_import/ocean_import1.asp"	 strSoTitle = "OI->New Decon.Sch."
                case "ocean_import/ocean_import2.asp"	 strSoTitle = "OI->Edit Decon.Sch."
                case "ocean_import/proof_delivery.asp"	 strSoTitle = "OI->POD"
                case "ocean_import/oi_search.asp"	 strSoTitle = "OI->OI Search"
                case "ocean_import/earrival_notice.asp"	 strSoTitle = "OI->e.NTC"
                case "acct_tasks/create_invoi.asp"	 strSoTitle = "Acct.T->Create IVC"
                case "acct_tasks/edit_invoice.asp"	 strSoTitle = "Acct.T->Add IVC"
                case "Accounting/SearchInvoiceSelection.aspx"	 strSoTitle = "Acct.T->Search IVC"
                case "acct_tasks/receiv_pay.asp"	 strSoTitle = "Acct.T->R.Payments"
                case "acct_tasks/enter_bill.asp"	 strSoTitle = "Acct.T->Ent.Bills"
                case "acct_tasks/pay_bills.asp"	 strSoTitle = "Acct.T->Pay Bills"
                case "acct_tasks/write_chk.asp"	 strSoTitle = "Acct.T->Write Checks"
                case "acct_tasks/print_chk.asp"	 strSoTitle = "Acct.T->Print Checks"
                case "acct_tasks/chart_acct.asp"	 strSoTitle = "Acct.T->COA"
                case "acct_tasks/edit_co_items.asp"	 strSoTitle = "Acct.T->Cost Items"
                case "acct_tasks/edit_ch_items.asp"	 strSoTitle = "Acct.T->Chg. Items"
                case "acct_tasks/gj_entry.asp"	 strSoTitle = "Acct.T->GJE"
                case "acct_reports/sales.asp"	 strSoTitle = "Acct.R->Sales"
                case "Accounting/ARAgingSelection.aspx"	 strSoTitle = "Acct.R->A/R A.Sum."
                case "acct_reports/ar_aging_det.asp"	 strSoTitle = "Acct.R->A/R A.Detail"
                case "acct_reports/ar_summ.asp"	 strSoTitle = "Acct.R->A/R Sum."
                case "acct_reports/ar_detail.asp"	 strSoTitle = "Acct.R->A/R Detail"
                case "acct_reports/expenses.asp"	 strSoTitle = "Acct.R->Expenses"
                case "Accounting/APAgingSelection.aspx"	 strSoTitle = "Acct.R->A/P A.Sum."
                case "acct_reports/ap_aging_det.asp"	 strSoTitle = "Acct.R->A/P A.Detail"
                case "acct_reports/ap_summary.asp"	 strSoTitle = "Acct.R->A/P Sum."
                case "acct_reports/ap_detail.asp"	 strSoTitle = "Acct.R->A/P Detail"
                case "acct_reports/trial_balance.asp"	 strSoTitle = "Acct.R->Tri.Bal"
                case "acct_reports/balance_sheet.asp"	 strSoTitle = "Acct.R->Bal.Sheet"
                case "acct_reports/income_state.asp"	 strSoTitle = "Acct.R->Income"
                case "acct_reports/gen_ledger.asp"	 strSoTitle = "Acct.R->GL"
                case "acct_reports/check_register.asp"	 strSoTitle = "Acct.R->Check R"
                case "AirExportBooking/AirExportBookingReportSelection.aspx"	 strSoTitle = "Reports/AE Book"
                case "AirExportHAWB/AirExportOperationSelectionHAWB.aspx"	 strSoTitle = "Reports/AE HAWB"
                case "AirExportMAWB/AirExportOperationSelectionMAWB.aspx"	 strSoTitle = "Reports/AE MAWB"
                case "OceanExportBooking/OceanExportBookingReportSelection.aspx"	 strSoTitle = "Reports/OE Book"
                case "OceanExportHBOL/OceanExportOperationSelectionHBOL.aspx"	 strSoTitle = "Reports/OE HBOL"
                case "OceanExportMBOL/OceanExportOperationSelectionMBOL.aspx"	 strSoTitle = "Reports/OE MBOL"
                case "Import/AirImportReportSelection.aspx"	 strSoTitle = "Reports/Air Import"
                case "Import/OceanImportReportSelection.aspx"	 strSoTitle = "Reports/Ocean Import"
                case "CompanyConfig/CompanySearchSelection.aspx"	 strSoTitle = "Reports/Co.Search"
                case "AMS/AMS_EDI_Ocean.aspx"	 strSoTitle = "Reports/AMS EDI"

	End Select
	getSoTotle = strSoTitle
End Function

Sub recentRegister(sUrl,DocNum)
DIM iCnt,myArr(51),newArr(51)
	iCnt = 51
	filename = temp_path + "\" + elt_account_number + user_id + ".txt"

	Set fs = Server.CreateObject("Scripting.FileSystemObject")

		if not fs.FileExists(filename) then
			Set objFile = fs.CreateTextFile(filename,true,false)
			objFile.close
		end if

			Set objFile = fs.OpenTextfile(filename,1)

		i=0

		Do While objFile.AtEndOfStream <> True AND i < iCnt
			myArr(i) = objFile.readLine
			i = i+1
		loop
		objFile.close

		for i=0 to (iCnt-1)
			newArr(i+1) = myArr(i)
		next

		newArr(0) =  now & "^" & DocNum & "^" & sURL

		Set objFile = fs.CreateTextFile(filename,true)

		for i=0 to (iCnt-1)
			objFile.writeLine(newArr(i))
		next
		objFile.close
		Set fs=Nothing
		
End Sub

Sub recentRegisterDB(sUrl,DocNum,WorkDetail, strSoTitle)
		SQL= "insert INTO Recent_Work (elt_account_number, user_id, workdate, title, docnum, surl, workdetail,remark,status ) "
		SQL= SQL & " VALUES (" & elt_account_number & ",N'" & user_id & "',N'" & getDateTime() & "',N'" & strSoTitle & "',N'"& DocNum & "',N'" & sUrl & "',N'" & WorkDetail & "','','')" 
		eltConn.Execute SQL
End Sub

Function getTodaySQL()
dim strDate
	strDate = Year(Now) 
	If len(Month(Now))=1 Then
		strDate = strDate & 	"0" & Month(Now) 
	Else
		strDate = strDate &  Month(Now) 
	End If
	If len(Day(Now))=1 Then
		strDate = strDate & 	"0" & Day(Now) 
	Else
		strDate = strDate & Day(Now) 
	End If

	getTodaySQL = strDate
End Function


Function getTimeSQL()
dim strTime

	If len(hour(Now))=1 Then
		strTime = strTime & 	"0" & hour(Now)
	Else
		strTime = strTime &  hour(Now)
	End If

	If len(minute(Now))=1 Then
		strTime = strTime & 	"0" & minute(Now)
	Else
		strTime = strTime &  minute(Now) 
	End If
	If len(second(Now))=1 Then
		strTime = strTime & 	"0" & second(Now)
	Else
		strTime = strTime & second(Now) 
	End If

	getTimeSQL = strTime
End Function


Function getDateTime()
dim strDateTime

	strDateTime = mid(getTodaySQL(), 5,2) & "/" & mid(getTodaySQL(), 7,2) & "/" & mid(getTodaySQL(), 1,4)
	strDateTime = strDateTime & " " & mid(getTimeSQL(), 1,2) & ":" & mid(getTimeSQL(), 3,2) & ":" & mid(getTimeSQL(), 5,2) 
 
	getDateTime = strDateTime
End Function

%>