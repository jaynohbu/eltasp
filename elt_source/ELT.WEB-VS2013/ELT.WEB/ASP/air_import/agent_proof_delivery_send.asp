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
    <%
        Dim ColoDee
        Dim oMail, i, PDF, aMailResult, vRecOrgPDF, vOrgPDF, aRecAttachedFiles, vDBA, aHAWB
                
        eltConn.BeginTrans
        
        Set aMailResult = Server.CreateObject("System.Collections.ArrayList")
        Set aHAWB = Server.CreateObject("System.Collections.ArrayList")
        
        vDBA = GetSQLResult("select dba_name from agent where elt_account_number=" & elt_account_number, "dba_name")
        
        For i=1 to Request.Form("chkOrg").Count
            Set oMail = Server.CreateObject("Persits.MailSender")
            Set aRecAttachedFiles = Server.CreateObject("System.Collections.ArrayList")
            vRecOrgPDF = ""
            vOrgPDF = ""
            
            Call InitializeMail(i)
            Call AttachFilesToMail(i)
            Call FinalSendMail(i)
            Call RecordEmailHistory(i)
            
            Set oMail = Nothing
            Set aRecAttachedFiles = Nothing
        Next
        
        eltConn.CommitTrans
        
        Sub InitializeMail(arg)
            Dim vEmailBody,vBillInfoTable

            oMail.Host = MailHost
            oMail.From = "proofOfDelivery@e-logitech.net"
            oMail.FromName = "Air Import Proof of Delivery"
            oMail.IsHTML = True
            oMail.Subject = Request.Form("txtEmailSubject")(arg)
            
            Call ADD_TO_MAIL(oMail, Request.Form("txtEmailTo")(arg))
            Call ADD_CC_MAIL(oMail, Request.Form("txtEmailCC")(arg))

            vBillInfoTable = GetBillInfoTable(Request.Form("hMAWB"))
            vEmailBody = "<html xmlns='http://www.w3.org/1999/xhtml'><head><meta http-equiv='Content-Type' content='text/html; charset=ISO-88591' />" _
                & "<title>AIR IMPORT PROOF OF DELIVERY</title><style type='text/css'><!--.text {font-family: Verdana, Arial, Helvetica, sans-serif;	font-size: 0.85em;}--></style></head>" _
                & "<body><p class='text'><font color='#f39003'><strong>AIR IMPORT PROOF OF DELIVERY</strong></font></p>" & vBillInfoTable & "<p class='text'>" & Server.HTMLEncode(Request.Form("txtMessage")(arg)) _
                & "</p><br><br><br><P class='text'>This message was sent by E-LOGISTICS TECHNOLOGY on behalf of <a href='mailto:" & Request.Form("txtYourEmail") & "'>" & Server.HTMLEncode(Request.Form("txtYourName")) & "</a>.<br>" _
                & "If you would like to reply to this message, please click on the following link:<br /><a href='mailto:"& Request.Form("txtYourEmail") &"'>" & Server.HTMLEncode(Request.Form("txtYourName")) & "</a>.</P>" _
                & "<a href='http://e-logitech.net' target='_blank'><img src='http://www.e-logitech.net:8080/elt_email/images/powered_logo.gif' width='123' height='50' border='0' /></a></body></html>"
                
            oMail.Body = vEmailBody
            
        End Sub
        
        Function GetBillInfoTable(vMAWB)
            Dim feData, SQL, i, aAllData, resStr
            
            resStr = ""
            SQL = "SELECT a.mawb_num,b.hawb_num,d.owner_email,e.MsgTxt,d.org_account_number as agent_no,d.dba_name as agent_name,b.pieces,b.gross_wt,b.freight_collect+b.oc_collect as col_amt,b.pickup_date " _
                & "FROM import_mawb a LEFT OUTER JOIN import_hawb b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num AND a.sec=b.sec AND a.iType=b.iType) " _
                & "LEFT OUTER JOIN invoice c ON (a.elt_account_number=c.elt_account_number AND a.mawb_num=c.mawb_num AND b.hawb_num=c.hawb_num AND a.iType=c.air_ocean) " _
                & "LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND a.agent_org_acct=d.org_account_number) " _
                & "LEFT OUTER JOIN greetMessage e ON (a.elt_account_number=e.AgentID AND e.MsgType='AI/Proof Of Delivery') " _
                & "WHERE a.elt_account_number=" & elt_account_number & " AND a.mawb_num=N'" & vMAWB & "' AND a.iType='A' AND ISNULL(b.mawb_num,'')<>'' AND c.import_export='I'"
            
            Set feData = new DataManager
            feData.SetDataList(SQL)
            Set aAllData = feData.getDataList
            
            resStr = "<table class='text' cellspacing='0' cellpadding='4' border='0'><tr style='background-color:#dddddd'><td><b>Master AWB No.</b></td></tr><tr><td>" & Server.HTMLEncode(vMAWB) & "</td></tr>" _
                & "<tr style='background-color:#dddddd'><td><b>House AWB No.</b></td><td><b>Units</b></td><td><b>Weight</b></td><td><b>Collect Amount</b></td><td><b>Pickup Date</b></td></tr>"
                    
            For i=0 To aAllData.Count-1
                resStr = resStr & "<tr><td>" & Server.HTMLEncode(checkBlank(aAllData(i)("hawb_num"),"Blank")) & "</td>" _
                    & "<td>" & aAllData(i)("pieces") & "</td>" _
                    & "<td>" & aAllData(i)("gross_wt") & "</td>" _
                    & "<td>" & aAllData(i)("col_amt") & "</td>" _
                    & "<td>" & aAllData(i)("pickup_date") & "</td></tr>"
                aHAWB.Add aAllData(i)("hawb_num")
            Next
            
            resStr = resStr + "</table>"
            
            GetBillInfoTable = resStr
            
        End Function
        
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
            
            rs("air_ocean").value = "A"
            rs("im_export").value = "I"
            rs("screen_name").value = "Proof of Delivery"
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
            rs("manifest_link").value = ""
            rs("attached_pdf").value = vRecOrgPDF
            rs("online_alert").value = "N"
            
            If oMail.IncludeErrorCode = 0 Then
                rs("sent_status").value = "Send"
            Else
                rs("sent_status").value = "Error:" & oMail.IncludeErrorCode
            End If

            For i=0 To aRecAttachedFiles.Count-1
                rs("attached_files").value = rs("attached_files").value & aRecAttachedFiles(i) & chr(9)
            Next
            
            For i=0 To aHAWB.Count-1
                rs("house_num").value = rs("house_num").value & aHAWB(i) & chr(9)
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
    <div class="bodyheader">
        <%=aMailResult(i) %>
    </div>
    <% Next %>
    <br />
    <div class="bodyheader">
        <a href="javascript:window.close()">Close Window</a></div>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
