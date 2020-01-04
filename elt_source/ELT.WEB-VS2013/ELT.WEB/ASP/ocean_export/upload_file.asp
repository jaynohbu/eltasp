<!--  #INCLUDE FILE="../include/transaction.txt" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>File Upload</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <!--  #INCLUDE FILE="../include/connection.asp" -->
    <!--  #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
    <!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
    <!--  #INCLUDE FILE="../include/SaveBinaryFile.asp" -->
    <!--  #INCLUDE FILE="../include/clsUpload.asp"-->
    <%
    Dim vOrgNo, vOrgName, SQL, uploadObj, vMode, vFileName, feData, aUserFiles, i, rs, vFileSizeLimit
    
    vFileSizeLimit = 2500000 '// (2.5 MB limit)
    vOrgNo = checkBlank(Request.QueryString("OrgNo"),-1)
    vMode = checkBlank(Request.QueryString("mode"),"")
    vFileName = checkBlank(Request.QueryString("file"),"")
    
    eltConn.BeginTrans
    
    SQL = "SELECT dba_name FROM organization WHERE elt_account_number=" & elt_account_number & " AND org_account_number=" & vOrgNo
    vOrgName = GetSQLResult(SQL,"dba_name")
    Set aUserFiles = Server.CreateObject("System.Collections.ArrayList")
    
    If vMode = "upload" Then
        Set objUpload = new clsUpload
        
        If objUpload.Fields("filePath").Length < vFileSizeLimit Then
            SQL= "select * from user_files where elt_account_number =" _
                & elt_account_number & " and org_no=" & vOrgNo & " and file_name=N'" & vFileName & "'"
		    Set rs = Server.CreateObject("ADODB.RecordSet")
		    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		    If rs.EOF=true Then
			    rs.AddNew
			    rs("elt_account_number") = elt_account_number
			    rs("org_no") = vOrgNo
			    rs("file_name") = vFileName
		    end if
		    rs("file_size") = objUpload.Fields("filePath").Length
		    rs("file_type") = objUpload.Fields("filePath").ContentType
		    rs("file_content").AppendChunk objUpload("filePath").BLOB & ChrB(0)
		    rs("file_checked")="N"
		    rs("in_dt") = Now
		    rs.Update
		    rs.Close
		Else
		    Response.Write("<script>alert('Uploading file has a size larger than " & vFileSizeLimit/1000000 & " MB.');</script>")
		End If
	Elseif vMode = "delete" Then
	    SQL = "DELETE FROM user_files WHERE elt_account_number=" _
	        & elt_account_number & " AND org_no=" & vOrgNo & " AND file_name=N'" & vFileName & "'"
        Set rs = Server.CreateObject("ADODB.RecordSet")
        Set rs = eltConn.execute(SQL)

    Elseif vMode = "attach" Then
        SQL = "UPDATE user_files SET file_checked='N' WHERE elt_account_number=" _
	        & elt_account_number & " AND org_no=" & vOrgNo
        Set rs = Server.CreateObject("ADODB.RecordSet")
        Set rs = eltConn.execute(SQL)
        
        For i = 1 To Request.Form("chkAttach").Count
            SQL = "UPDATE user_files SET file_checked='Y' WHERE elt_account_number=" _
	        & elt_account_number & " AND org_no=" & vOrgNo & " AND file_name=N'" & Request.Form("chkAttach")(i) & "'"
            Set rs = Server.CreateObject("ADODB.RecordSet")
            Set rs = eltConn.execute(SQL)
        Next
    Else
    
    End If
    
    Set feData = new DataManager
    SQL = "select * from user_files where elt_account_number=" & elt_account_number & " and org_no=" & vOrgNo
    feData.SetDataList(SQL)
    Set aUserFiles = feData.getDataList
    
    Set rs = Nothing
    
    eltConn.CommitTrans
    
    %>

    <script type="text/jscript">
    
        function UpLoadClick(){
            var filePath = document.getElementById("filePath").value;
            var fileName = document.getElementById("txtFileName").value;
            
            if(filePath == "" ||  fileName == ""){
                alert("Please, enter the file path and name!");
                return false;
            }
            else{
                document.form1.action = "upload_file.asp?WindowName=" + window.name + "&OrgNo=<%=vOrgNo %>&mode=upload&file=" + encodeURIComponent(fileName);
                document.form1.method = "POST";
                document.form1.encoding = "multipart/form-data";
                document.form1.target = window.name;
                document.form1.submit();
            }
        }
        
        function DeleteFile(arg){
            document.form1.action = "upload_file.asp?WindowName=" + window.name + "&OrgNo=<%=vOrgNo %>&mode=delete&file=" + encodeURIComponent(arg);
            document.form1.method = "POST";
            document.form1.encoding = "application/x-www-form-urlencoded";
            document.form1.target = window.name;
            document.form1.submit();
        }
        
        function AttachClick(){
            
            document.form1.action = "upload_file.asp?WindowName=" + window.name + "&OrgNo=<%=vOrgNo %>&mode=attach&";
            document.form1.method = "POST";
            document.form1.encoding = "application/x-www-form-urlencoded";
            document.form1.target = window.name;
            document.form1.submit();
        }
        
        function LoadPage(){
            <% If vMode = "attach" Then %>
                UnloadPage();
            <% End If %>
        }
        
        function UnloadPage(){
            var attachObj = document.getElementsByName("chkAttach");
            var fileArray = new Array();
            var k = 0;
            for(var i=0;i<attachObj.length;i++)
            {
                if(attachObj[i].checked){
                    fileArray[k++] = attachObj[i].value;
                }
            }
            window.opener.receiveAttachedFile(fileArray);
            window.returnValue = fileArray;
            window.close();
        }
        function FileSelected(obj){
            var file_name=  obj.value.replace(/^.*[\\\/]/, '');
            document.getElementById("txtFileName").value=file_name;
        }
    </script>

</head>
<body onload="LoadPage()" onunload="">
    <form id="form1" name="form1">
        <center>
            <table style="width: 90%" cellpadding="1" cellspacing="0" border="0" class="bodycopy">
                <tr>
                    <td class="pageheader" colspan="2">
                        File Upload</td>
                </tr>
                <tr>
                    <td class="bodyheader" colspan="2">
                        DBA:
                        <%=vOrgName %>
                    </td>
                </tr>
                <tr>
                    <td class="bodyheader" style="width: 60px">
                        File Path</td>
                    <td align="left" valign="middle" class="bodycopy">
                        <input id="filePath" name="filePath" type="File" class="bodycopy" size="50" onkeydown="return false" onchange="FileSelected(this)"/>
                    </td>
                </tr>
                <tr>
                    <td class="bodyheader" style="width: 60px">
                        File Name</td>
                    <td>
                        <input type="text" id="txtFileName" name="txtFileName" class="bodycopy" size="50" style="ime-mode:disabled" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="right">
                        <img src="/asp/images/button_upload.gif" onclick="UpLoadClick()" style="cursor: hand"
                            alt="" />
                    </td>
                </tr>
            </table>
            <table style="width: 90%" cellpadding="1" cellspacing="0" border="0" class="bodycopy">
                <tr>
                    <td colspan="5" style="color:Red">Check box(es) to attach file(s)</td>
                </tr>
                <tr style="background-color: #dddddd">
                    <td>
                    </td>
                    <td>
                        Name</td>
                    <td>
                        Size</td>
                    <td>
                        Date</td>
                    <td>
                    </td>
                </tr>
                <% For i = 0 To aUserFiles.Count-1 %>
                <tr>
                    <td>
                        <input type="checkbox" id="chkAttach<%=i %>" name="chkAttach" value="<%=aUserFiles(i)("file_name") %>"
                            <% If aUserFiles(i)("file_checked") = "Y" Then Response.Write("checked=checked") %> /></td>
                    <td>
                        <%=aUserFiles(i)("file_name") %>
                    </td>
                    <td>
                        <%=aUserFiles(i)("file_size") %>
                        Bytes</td>
                    <td>
                        <%=aUserFiles(i)("in_dt") %>
                    </td>
                    <td>
                        <img src="../images/button_delete.gif" onclick="DeleteFile('<%=aUserFiles(i)("file_name") %>');"
                            style="cursor: hand" alt="" />
                    </td>
                </tr>
                <% Next %>
                <tr>
                    <td colspan="5" align="right">
                        <img src="../images/button_attach.gif" onclick="AttachClick()" style="cursor: hand"
                            alt="" />
                    </td>
                </tr>
            </table>
        </center>
    </form>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
