<%
'// use error_num to find the status of email transactions

Sub UpdateEmailHistory(vAirOcean,vShipType,vScreenName)
    Dim i,j,rs,sqlTxt
    Set rs = Server.CreateObject("ADODB.Recordset")
    sqlTxt = "SELECT TOP 0 * FROM email_history"
    rs.Open sqlTxt, eltConn, adOpenDynamic, adLockPessimistic, adCmdText	
    
    For i=0 To NoItem-1
        
'------------------------------------------------- Pre-Alert -----------------------------------------------        
        If vScreenName = "Pre-Alert" And aAgentCheck(i)="Y" Then
            rs.AddNew
            rs("air_ocean").value = vAirOcean
            rs("im_export").value = vShipType
            rs("screen_name").value = vScreenName
            rs("email_id").value = Session.SessionID & "-" & elt_account_number & "-" & aAgentNo(i)
            rs("elt_account_number").value = elt_account_number
            rs("user_id").value = user_id
            rs("to_org_id").value = aAgentNo(i)
            rs("to_org_name").value = aAgentName(i)
            rs("email_sender").value = vYourName
            rs("email_from").value = vYourEmail
            rs("email_to").value = aAgentEmail(i)
            rs("email_cc").value = aAgentCC(i)
            rs("email_subject").value = aAgentSubject(i)
            rs("email_content").value = aAgentMSG(i)
            rs("sent_date").value = Now
            rs("sent_status").value = aSendInfo(i)
            
            For j=0 To aAgentFileIndex(i)-1
                If aAgentFileCheck (i,j) = "Y" Then
                    rs("attached_files").value = rs("attached_files").value + aAgentFileName(i,j) + chr(9)
                End If
            Next
            
            rs("attached_pdf").value = aAgentPDFName(i)
            rs("master_num").value = vMAWB
            
            If Not IsNull(aHAWBIndex(i)) And Not IsEmpty(aHAWBIndex(i)) Then
                For j=0 To aHAWBIndex(i)
                    rs("house_num").value = rs("house_num").value + aHAWB(i,j) + chr(9)
                Next
            End If
            
            rs("invoice_num").value = aShipperInvoice(i)
            rs("manifest_link").value = aManifest(i)
            rs("online_alert").value = checkBlank(aOnlineAlertCheck(i),"N")
        End If

'----------------------------------------------- Shipping Notice --------------------------------------------           
        If vScreenName = "Shipping Notice" And aShipperCheck(i)="Y" Then
            rs.AddNew
            rs("air_ocean").value = vAirOcean
            rs("im_export").value = vShipType
            rs("screen_name").value = vScreenName
            rs("email_id").value = Session.SessionID & "-" & elt_account_number & "-" & aShipperNo(i)
            rs("elt_account_number").value = elt_account_number
            rs("user_id").value = user_id
            If Not IsNull(aShipperNo(i)) And aShipperNo(i) <> "" Then
                rs("to_org_id").value = aShipperNo(i)
            End If
            rs("to_org_name").value = aShipperName(i)
            rs("email_sender").value = vYourName
            rs("email_from").value = vYourEmail
            rs("email_to").value = aShipperEmail(i)
            rs("email_cc").value = aShipperCC(i)
            rs("email_subject").value = aShipperSubject(i)
            rs("email_content").value = aShipperMSG(i)
            rs("sent_date").value = Now
            rs("sent_status").value = aSendInfo(i)
            
            For j=0 To aShipperFileIndex(i)-1
                If aShipperFileCheck (i,j) = "Y" Then
                    rs("attached_files").value = rs("attached_files").value + aShipperFileName(i,j) + chr(9)
                End If
            Next
            
            rs("attached_pdf").value = aShipperPDFName(i)
            rs("master_num").value = vMAWB
            
            If Not IsNull(aShipperHAWBIndex(i)) And Not IsEmpty(aShipperHAWBIndex(i)) Then
                For j=0 To aShipperHAWBIndex(i)
                    rs("house_num").value = rs("house_num").value + aShipperHAWB(i,j) + chr(9)
                Next
            End If
            
            rs("invoice_num").value = aInvoice(i)
            rs("manifest_link").value = aManifest(i)
        End If

'----------------------------------------------- EArrival Notice ---------------------------------------------   
        If vScreenName = "EArrival Notice" And aConsigneeCheck(i)="Y" Then
            rs.AddNew
            rs("air_ocean").value = vAirOcean
            rs("im_export").value = vShipType
            rs("screen_name").value = vScreenName
            rs("email_id").value = Session.SessionID & "-" & elt_account_number & "-" & aConsigneeNo(i)
            rs("elt_account_number").value = elt_account_number
            rs("user_id").value = user_id
            rs("to_org_id").value = aConsigneeNo(i)
            rs("to_org_name").value = aConsigneeName(i)
            rs("email_sender").value = vYourName
            rs("email_from").value = vYourEmail
            rs("email_to").value = aConsigneeEmail(i)
            rs("email_cc").value = aConsigneeCC(i)
            rs("email_subject").value = aConsigneeSubject(i)
            rs("email_content").value = aConsigneeMSG(i)
            rs("sent_date").value = Now
            rs("sent_status").value = aSendInfo(i)
            
            For j=0 To aConsigneeFileIndex(i)-1
                If aConsigneeFileCheck (i,j) = "Y" Then
                    rs("attached_files").value = rs("attached_files").value + aConsigneeFileName(i,j) + chr(9)
                End If
            Next
            
            rs("attached_pdf").value = aConsigneePDFName(i)
            rs("master_num").value = vMAWB
            
            If Not IsNull(aConsigneeHAWBIndex(i)) And Not IsEmpty(aConsigneeHAWBIndex(i)) Then
                For j=0 To aConsigneeHAWBIndex(i)
                    rs("house_num").value = rs("house_num").value + aHAWB(i,j) + chr(9)
                    rs("invoice_num").value = rs("invoice_num").value + CStr(aInvoice(i,j))+ chr(9)
                Next
            End If
            rs("manifest_link").value = aManifest(i)
        End If
        
'--------------------------------------------- Proof of Delivery ---------------------------------------------   

        If vScreenName = "Proof of Delivery" And aAgentCheck(i)="Y" Then
            rs.AddNew
            rs("air_ocean").value = vAirOcean
            rs("im_export").value = vShipType
            rs("screen_name").value = vScreenName
            rs("email_id").value = Session.SessionID & "-" & elt_account_number & "-" & aAgentNo(i)
            rs("elt_account_number").value = elt_account_number
            rs("user_id").value = user_id
            rs("to_org_id").value = aAgentNo(i)
            rs("to_org_name").value = aAgentName(i)
            rs("email_sender").value = vYourName
            rs("email_from").value = vYourEmail
            rs("email_to").value = aAgentEmail(i)
            rs("email_cc").value = aAgentCC(i)
            rs("email_subject").value = aAgentSubject(i)
            rs("email_content").value = aAgentMSG(i)
            rs("sent_date").value = Now
            rs("sent_status").value = aSendInfo(i)
            
            For j=0 To aAgentFileIndex(i)-1
                If aAgentFileCheck (i,j) = "Y" Then
                    rs("attached_files").value = rs("attached_files").value + aAgentFileName(i,j) + chr(9)
                End If
            Next
            
            rs("attached_pdf").value = aAgentPDFName(i)
            rs("master_num").value = vMAWB
            
            If Not IsNull(aHAWBIndex(i)) And Not IsEmpty(aHAWBIndex(i)) Then
                For j=0 To aHAWBIndex(i)
                    rs("house_num").value = rs("house_num").value + CStr(aHAWB(i,j)) + chr(9)
                    rs("invoice_num").value = rs("invoice_num").value + CStr(aInvoice(i,j))+ chr(9)
                Next
            End If
            rs("manifest_link").value = aManifest(i)
        End If
        
    Next
    If Not rs.EOF And Not rs.BOF Then
        rs.Update
    End If
    rs.Close
End Sub
  
%>