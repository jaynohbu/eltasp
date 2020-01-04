<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Send Mail</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <!--  #INCLUDE FILE="../include/connection.asp" -->
    <!--  #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
    <!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
    <!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
    <!--  #INCLUDE FILE="../include/SaveBinaryFile.asp" -->
    <!--  #INCLUDE FILE="../include/PDFManager.inc" -->
    <!--  #INCLUDE FILE="../include/MakeAgentPreAlertPDFFile.asp" -->
    <%
        Dim ColoDee
        Dim oMail, i, PDF, aMailResult, vRecOrgPDF, vOrgPDF, aRecAttachedFiles, vDBA
        
        eltConn.BeginTrans
        
        Set aMailResult = Server.CreateObject("System.Collections.ArrayList")
        vDBA = GetSQLResult("select dba_name from agent where elt_account_number=" & elt_account_number, "dba_name")
        
        '// Org has be checked in order to process 
        '// Emailing PDF
        '// online alerting by EDT
        
        For i=1 to Request.Form("chkOrg").Count
            Set oMail = Server.CreateObject("Persits.MailSender")
            Set aRecAttachedFiles = Server.CreateObject("System.Collections.ArrayList")
            vOrgPDF = ""
            vRecOrgPDF = ""
            
            Call OnlineAlertSub(i) 
            Call MakeEmailPDFSub(i)
            Call InitializeMail(i)
            Call AttachFilesToMail(i)
            Call FinalSendMail(i)
            Call RecordEmailHistory(i)
            
            Set oMail = Nothing
            Set aRecAttachedFiles = Nothing
        Next
        
        eltConn.CommitTrans
        
        Sub OnlineAlertSub(arg)
            Dim vOrgNo, vMAWB, vHAWB, SQL, feData, tmpTable, i, vOrgELT, vSEC, rs
            vOrgNo = Request.Form("chkOrg")(arg)
            vMAWB = Request.Form("hMAWB")
            Set rs = Server.CreateObject("ADODB.RecordSet")
            
            If checkBlank(Request.Form("chkOnlineAlert" & vOrgNo),"") <> "" Then
                For i=1 To Request.Form("chkHousePDF" & vOrgNo).Count
                    vHAWB = Request.Form("chkHousePDF" & vOrgNo)(i)
                    Set feData = new DataManager
                    
                    SQL = "SELECT " _
                        & "e.agent_elt_acct,edt,a.shipper_name,a.shipper_info,a.consignee_name,a.consignee_info,a.notify_acct_num,f.invoice_no,f.amount_charged" _
                        & ",a.pieces,a.unit_qty,a.gross_weight,a.total_weight_charge,a.weight_cp,a.scale " _
                        & ",d.carrier_desc,d.carrier_code,d.file_no,vsl_name,d.arrival_date,d.departure_date,d.origin_port_id,d.dest_port_id " _
                        & ",b.pieces AS sum_total_pieces,b.gross_weight AS sum_total_gross_weight,b.total_weight_charge AS sum_total_chargeable_weight,b.unit_qty AS sum_unit_qty " _
                        & "FROM hbol_master a LEFT OUTER JOIN mbol_master b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) " _
                        & "LEFT OUTER JOIN ocean_booking_number d ON (a.elt_account_number=d.elt_account_number AND a.booking_num=d.booking_num) " _
                        & "LEFT OUTER JOIN organization e ON (a.elt_account_number=e.elt_account_number AND a.agent_no=e.org_account_number) " _
                        & "LEFT OUTER JOIN invoice f ON (a.elt_account_number=f.elt_account_number AND a.hbol_num=f.hawb_num AND a.booking_num=f.mawb_num AND f.air_ocean='O') " _
                        & "WHERE a.elt_account_number=" & elt_account_number & " and a.hbol_num=N'" & vHAWB & "' AND a.booking_num=N'" & vMAWB & "'"
                    
                    feData.SetDataList(SQL)
                    Set tmpTable = feData.GetDataList()(0)
                    
                    vOrgELT = checkBlank(tmpTable("agent_elt_acct"),"0")
                    If vOrgELT <> "0" And checkBlank(tmpTable("edt"),"N") = "Y" Then
						
						SQL = "SELECT MAX(sec) AS sec,processed FROM import_mawb WHERE elt_account_number=" _
						    & vOrgELT & " AND agent_elt_acct=" & elt_account_number & " AND mawb_num=N'" _
						    & vMAWB & "' GROUP BY processed ORDER BY MAX(sec) DESC"
					    
					    rs.Open SQL, eltConn, , , adCmdText
					    
					    If rs.EOF Then
						    vSEC = 1
					    Else
						    If IsNull(rs("sec")) Then
							    vSEC = 1
						    Elseif rs("processed")="Y" then
							    vSEC = rs("sec") + 1
						    Else
							    vSEC = rs("sec")
						    End If
					    End If
					    rs.close
					    
					    SQL= "SELECT * FROM import_hawb WHERE elt_account_number=" & vOrgELT & " AND agent_elt_acct=" _
					        & elt_account_number & " and hawb_num=N'" & vHAWB & "' and sec=" & vSEC
						rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
						
						If rs.EOF Then
							rs.AddNew
							rs("elt_account_number") = vOrgELT
						    rs("agent_elt_acct") = elt_account_number
							rs("iType") = "O"
							rs("hawb_num") = vHAWB
							rs("sec") = vSEC
						End if
						
						rs("tran_dt") = Now()
						rs("mawb_num") = vMAWB
						rs("processed") = "N"
						rs("shipper_name") = tmpTable("shipper_name")
						rs("shipper_info") = tmpTable("shipper_info")
						rs("consignee_name") = tmpTable("consignee_name")
						rs("consignee_info") = tmpTable("consignee_info")
						rs("notify_name") = GetBusinessName(tmpTable("notify_acct_num"))
						rs("notify_info") = GetBusinessInfo(tmpTable("notify_acct_num"))
						rs("pieces") = tmpTable("pieces")
						rs("uom") = tmpTable("unit_qty")
						rs("gross_wt") = tmpTable("gross_weight")
						rs("chg_wt") = tmpTable("total_weight_charge")
						rs("scale1") = tmpTable("scale")
						rs("scale2") = tmpTable("scale")
						rs("prepaid_collect") = tmpTable("weight_cp")
						rs.update
						rs.close
						
						SQL= "SELECT * FROM import_mawb WHERE elt_account_number=" & vOrgELT & " AND agent_elt_acct=" _
						    & elt_account_number & " and MAWB_NUM=N'" & vMAWB & "' and sec=" & vSEC
				        rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				        If rs.EOF=true Then
					        rs.AddNew
							rs("elt_account_number") = vOrgELT
						    rs("agent_elt_acct") = elt_account_number
							rs("iType") = "O"
							rs("mawb_num") = vMAWB
							rs("sec") = vSEC
				        end if
				        rs("processed") = "N"
				        rs("export_agent_name") = vDBA
				        rs("tran_dt") = Now()
				        rs("carrier") = tmpTable("carrier_desc")
				        rs("file_no") = tmpTable("file_no")
				        rs("vessel_name") = tmpTable("vsl_name")
				        rs("etd") = tmpTable("departure_date")
				        rs("eta") = tmpTable("arrival_date")
				        rs("dep_code") = tmpTable("origin_port_id")
				        rs("arr_code") = tmpTable("dest_port_id")
				        rs("pieces") = tmpTable("sum_total_pieces")
				        rs("scale1") = tmpTable("sum_unit_qty")
				        rs("gross_wt") = tmpTable("sum_total_gross_weight")
				        rs("scale2") = "KG"
				        rs("chg_wt") = tmpTable("sum_total_chargeable_weight")
				        rs("scale3") = "KG"
				        rs("agent_debit_no") = tmpTable("invoice_no")
				        rs("agent_debit_amt") = tmpTable("amount_charged")
				        rs.update
				        rs.close
                    
                    End If
				
                    Set tmpTable = Nothing
                    Set feData = Nothing
			    Next
            End If
        End Sub
        
        Sub MakeEmailPDFSub(arg)
        
            Dim fso, f, r, AttachedFileName, vOrgNo, vMAWB, vMasterOrgNo,i
            
            Set PDF = GetNewPDFObject()
	        Set fso = Server.CreateObject("Scripting.FileSystemObject")
	        vOrgNo = Request.Form("chkOrg")(arg)
	        vMasterOrgNo = Request.Form("hMasterAgent")(arg)
	        vMAWB = Request.Form("hMAWB")
	        
	        If Not fso.FolderExists(temp_path) Then
                Set f = fso.CreateFolder(temp_path)
	        End If
	        If Not fso.FolderExists(temp_path & "\Eltdata") Then
		        Set f = fso.CreateFolder(temp_path & "\Eltdata")
	        End If
	        If Not fso.FolderExists(temp_path & "\Eltdata\" & elt_account_number) Then
		        Set f = fso.CreateFolder(temp_path & "\Eltdata\" & elt_account_number)
	        End If

            Call SetOutputPDFFile(vOrgNo)
            
			For i=1 To Request.Form("chkHousePDF" & vOrgNo).Count
			    Call InsertHBOLIntoPDF(Request.Form("chkHousePDF" & vOrgNo)(i))
			Next
			
			For i=1 To Request.Form("chkInvoicePDF" & vOrgNo).Count
			    Call InsertInvoiceIntoPDF(Request.Form("chkInvoicePDF" & vOrgNo)(i))
			Next

			If checkBlank(Request.Form("chkManifestPDF" & vOrgNo),"") <> "" Then
			    Call InsertOceanManifestIntoPDF(vMAWB, GetBusinessName(vOrgNo), vOrgNo, vMasterOrgNo, GetBusinessName(vMasterOrgNo), GetBusinessTelFax(vMasterOrgNo))
            End If
            
            PDF.CloseOutputFile
        End Sub
        
        Sub SetOutputPDFFile(vOrgNo)
            If vOrgPDF = "" Then
                vOrgPDF = temp_path & "\Eltdata\" & elt_account_number & "\agentmail" & vOrgNo & ".pdf"
                r = PDF.OpenOutputFile(vOrgPDF)
                vRecOrgPDF = "agentmail" & vOrgNo & ".pdf"
            End If
        End Sub
        
        Sub InitializeMail(arg)
            Dim vEmailBody

            oMail.Host = MailHost
            oMail.From = "preAlert@e-logitech.net"
            oMail.FromName = "Ocean Export Pre Alert"
            oMail.IsHTML = True
            oMail.Subject = Request.Form("txtEmailSubject")(arg)
            
            Call ADD_TO_MAIL(oMail, Request.Form("txtEmailTo")(arg))
            Call ADD_CC_MAIL(oMail, Request.Form("txtEmailCC")(arg))
            
            vEmailBody = "<html xmlns='http://www.w3.org/1999/xhtml><head><meta http-equiv='Content-Type' content='text/html; charset=ISO-88591' />" _
                & "<title>OCEAN EXPORT AGENT RE-ALERT</title><style type='text/css'><!--.text {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 0.85em;}--></style></head>" _
                & "<body><p class='text'><font color='#f39003'><strong>OCEAN EXPORT AGENT PRE-ALERT</strong></font></p><p class='text'>" & Server.HTMLEncode(Request.Form("txtMessage")(arg)) _
			    & "</p><br><br><br><p class='text'>This message was sent by E-LOGISTICS TECHNOLOGY on behalf of <a href='mailto:" & Request.Form("txtYourEmail") & "'>" & Server.HTMLEncode(Request.Form("txtYourName")) & "</a>.<br>" _
			    & "If you would like to reply to this message, please click on the following link:<br /><a href='mailto:" & Request.Form("txtYourEmail") & "'>" & Server.HTMLEncode(Request.Form("txtYourName")) & "</a>.</p>" _
			    & "<a href='http://e-logitech.net' target='_blank'><img src='http://www.e-logitech.net:8080/elt_email/images/powered_logo.gif' width='123' height='50' border='0' /></a></body></html>"
            oMail.Body = vEmailBody
            
        End Sub
        
        Sub AttachFilesToMail(arg)
        
            Dim fso, f, vOrgNo
            Dim SQL, rs, BinaryStream, vOrgFolder, i
            
            Set fso = Server.CreateObject("Scripting.FileSystemObject")
            vOrgNo = Request.Form("chkOrg")(arg)
        
            If vOrgPDF <> "" Then 
                oMail.AddAttachment vOrgPDF
	        End If

	        Set rs = Server.CreateObject("ADODB.RecordSet")
	        SQL = "SELECT [file_name],file_content FROM user_files WHERE elt_account_number=" & elt_account_number & " AND file_checked='Y' AND org_no=" & vOrgNo
	        rs.Open SQL, eltConn, , , adCmdText
	        Do While Not rs.EOF AND Not rs.BOF 
                
                vOrgFolder = temp_path & "\Eltdata\" & elt_account_number & "\" & vOrgNo
	            
	            If Not fso.FolderExists(temp_path) Then
                    Set f = fso.CreateFolder(temp_path)
	            End If
	            If Not fso.FolderExists(temp_path & "\Eltdata") Then
		            Set f = fso.CreateFolder(temp_path & "\Eltdata")
	            End If
	            If Not fso.FolderExists(temp_path & "\Eltdata\" & elt_account_number) Then
		            Set f = fso.CreateFolder(temp_path & "\Eltdata\" & elt_account_number)
	            End If
	            If Not fso.FolderExists(vOrgFolder) Then
		            Set f = fso.CreateFolder(vOrgFolder)
	            End If
	
	            Set BinaryStream = CreateObject("ADODB.Stream")
  		        BinaryStream.Type = adTypeBinary
  		        BinaryStream.Open
  		        BinaryStream.Write rs("file_content")
  		        BinaryStream.SaveToFile  vOrgFolder & "\" & rs("file_name"), adSaveCreateOverWrite
	            BinaryStream.Close
	            Set BinaryStream = Nothing
	            
	            oMail.AddAttachment vOrgFolder & "\" & rs("file_name")
	            aRecAttachedFiles.Add rs("file_name").value
	            rs.MoveNext
	        Loop
	        
	        rs.Close
	        Set rs = Nothing
	        Set fso = Nothing
	        
        End Sub
        
        Sub FinalSendMail(arg)
            Dim vReceipientName
            vReceipientName = Request.Form("txtEmailName")(arg)
            
            On Error Resume Next:
            '// oMail.CharSet = "UTF-8"
            oMail.Send()
            If Err.number = 0 Then
                aMailResult.Add "Emailing to " & vReceipientName & " was successful"
            Else
                aMailResult.Add "Emailing to " & vReceipientName & " failed with an error (Error: " & Err.number & ")"
            End If
            
        End Sub
        
        Sub RecordEmailHistory(arg)
            Dim SQL, rs, vOrgNo,i
            
            vOrgNo = Request.Form("chkOrg")(arg)
            Set rs = Server.CreateObject("ADODB.Recordset")
            SQL = "SELECT TOP 0 * FROM email_history"
            rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
            rs.AddNew
            
            rs("air_ocean").value = "O"
            rs("im_export").value = "E"
            rs("screen_name").value = "Pre-Alert"
            rs("email_id").value = Session.SessionID & "-" & elt_account_number & "-" & vOrgNo
            rs("elt_account_number").value = elt_account_number
            rs("user_id").value = user_id
            rs("to_org_id").value = vOrgNo
            rs("to_org_name").value = Request.Form("txtEmailName")(arg)
            rs("email_sender").value = Request.Form("txtYourName")
            rs("email_from").value = Request.Form("txtYourEmail")
            rs("email_to").value = Request.Form("txtEmailTo")(arg)
            rs("email_cc").value = Request.Form("txtEmailCC")(arg)
            rs("email_subject").value = Request.Form("txtEmailSubject")(arg)
            rs("email_content").value = Request.Form("txtMessage")(arg)
            rs("sent_date").value = Now()
            rs("master_num").value = Request.Form("hMAWB")
            rs("manifest_link").value = "MAWB=" & Request.Form("hMAWB") & "&Agent" = vOrgNo
            rs("attached_pdf").value = vRecOrgPDF
            rs("online_alert").value = checkBlank(Request.Form("chkOnlineAlert" & vOrgNo),"N")
            
            If oMail.IncludeErrorCode = 0 Then
                rs("sent_status").value = "Send"
            Else
                rs("sent_status").value = "Error:" & oMail.IncludeErrorCode
            End If

            For i=1 To Request.Form("chkHousePDF" & vOrgNo).Count
                rs("house_num").value = rs("house_num").value & Request.Form("chkHousePDF" & vOrgNo)(i) & chr(9)
			Next
            
            For i=1 To Request.Form("chkInvoicePDF" & vOrgNo).Count
                rs("invoice_num").value = rs("invoice_num").value & Request.Form("chkInvoicePDF" & vOrgNo)(i) & chr(9)
			Next
            
            For i=0 To aRecAttachedFiles.Count-1
                rs("attached_files").value = rs("attached_files").value & aRecAttachedFiles(i) & chr(9)
            Next
            
            rs.update
            rs.Close
            Set rs = Nothing
            
        End Sub
    %>
</head>
<body>
<br />
<% For i=0 To aMailResult.Count-1 %>
<div class="bodyheader"><%=aMailResult(i) %></div>
<% Next %>
<br />
<div class="bodyheader"><a href="javascript:window.close()">Close Window</a></div>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
