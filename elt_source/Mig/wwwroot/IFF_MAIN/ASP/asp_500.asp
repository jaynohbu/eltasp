<%@  transaction="supported" language="vbscript" codepage="65001" %>
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
    '//On Error Resume Next 
    
    Response.Expires = 0  
    Response.AddHeader "Pragma","no-cache"  
    Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
    Response.Clear()
%>
<!--  #INCLUDE FILE="./include/connection.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>ASP 500 Error</title>
    <style type="text/css">
        .pageheader {
	        font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 13px;
	        font-weight: bold;
	        text-transform: uppercase;
	        color: #000000;
	        padding-top: 20px;
	        padding-bottom: 14px;
        }
        
        .bodycopy {
	        font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 9px;
	        color: #000000;
	        text-transform: none;
        }
        
        .button {
	        font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 12px;
	        color: #000000;
	        text-transform: none;
        }
    
        .m_shorttextfield { 
	        behavior: url(/IFF_MAIN/ASP/include/mask_js.htc);
	        font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 9px;
	        color: #000000;
	        height: 16px;
	        border-top-color: #666666;
	        border-right-color: #CCCCCC;
	        border-bottom-color: #CCCCCC;
	        border-left-color: #666666;
	        border-top-style: solid;
	        border-right-style: solid;
	        border-bottom-style: solid;
	        border-left-style: solid;
	        border-top-width: 1px;
	        border-right-width: 1px;
	        border-bottom-width: 1px;
	        border-left-width: 1px;
        }
        
        .multilinetextfield {
	        font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 9px;
	        border-top-style: solid;
	        border-right-style: solid;
	        border-bottom-style: solid;
	        border-left-style: solid;
	        border-top-color: #666666;
	        border-right-color: #999999;
	        border-bottom-color: #999999;
	        border-left-color: #666666;
	        border-top-width: 1px;
	        border-right-width: 1px;
	        border-bottom-width: 1px;
	        border-left-width: 1px;
        }
    </style>
    <%
        Dim objError
    
        If Request.QueryString("mode") = "save" Then
            SaveBugSub()
            Response.Write("<script>parent.window.location.href='/IFF_MAIN/Main.aspx?T=';</script>")
            Response.End()
        Else
            Set objError = Server.GetLastError()
        End If
        
        Sub SaveBugSub
            
	        Dim SQL, rs
            Set rs = Server.CreateObject("ADODB.RecordSet")
            SQL = "SELECT TOP 0 * FROM bug_master"
            rs.Open SQL,eltConn,adOpenStatic,adLockPessimistic,adCmdText
            
            rs.AddNew
            rs("asp_code") = Request.Form("txtAspCode")
            rs("err_number") = Request.Form("txtNumber")
            rs("source") = Request.Form("txtSource")
            rs("source_file") = Request.Form("txtFile")
            rs("err_line") = Request.Form("txtLine")
            rs("err_desc") = Request.Form("txtDesc")
            rs("err_asp_desc") = Request.Form("txtAspDesc")
            rs("last_sql") = Request.Form("txtSQL")
            rs("err_date") = Now()
            rs("elt_account_number") = Request.Form("txtELTNumber")
            rs("user_id") = Request.Form("txtUserId")
            rs.update
            rs.close
        End Sub
    %>
</head>
<body>
    <div style="width: 100%; text-align: center">
        <div class="pageheader">
            An error occurred processing the page you requested.<br />
            Below information will be sent to us for a review.<br />
        </div>
        <form id="form1" action="/IFF_MAIN/ASP/asp_500.asp?mode=save" method="post">
        <table cellpadding="4" cellspacing="0" border="0" class="bodycopy">
            <% If Len(CStr(objError.ASPCode)) > 0 Then %>
            <tr>
                <td>
                    <strong>IIS Error Number</strong></td>
                <td>
                    <input type="text" id="txtAspCode" name="txtAspCode" class="m_shorttextfield" size="40"
                        value="<%=objError.ASPCode %>" readonly="readonly" /></td>
            </tr>
            <% End If %>
            <% If Len(CStr(objError.Number)) > 0 Then %>
            <tr>
                <td>
                    <strong>COM Error Number</strong></td>
                <td>
                    <input type="text" id="txtNumber" name="txtNumber" class="m_shorttextfield" size="40"
                        value="<%=objError.Number %><%=" (0x" & Hex(objError.Number) & ")" %>" readonly="readonly" />
                </td>
            </tr>
            <% End If %>
            <% If Len(CStr(objError.Source)) > 0 Then %>
            <tr>
                <td>
                    <strong>Error Source</strong></td>
                <td>
                    <input type="text" id="txtSource" name="txtSource" class="m_shorttextfield" size="70"
                        value="<%=objError.Source %>" readonly="readonly" /></td>
            </tr>
            <% End If %>
            <% If Len(CStr(objError.File)) > 0 Then %>
            <tr>
                <td>
                    <strong>File Name</strong></td>
                <td>
                    <input type="text" id="txtFile" name="txtFile" class="m_shorttextfield" size="70"
                        value="<%=objError.File %>" readonly="readonly" /></td>
            </tr>
            <% End If %>
            <% If Len(CStr(objError.Line)) > 0 Then %>
            <tr>
                <td>
                    <strong>Line Number</strong></td>
                <td>
                    <input type="text" id="txtLine" name="txtLine" class="m_shorttextfield" size="20"
                        value="<%=objError.Line %>" readonly="readonly" /></td>
            </tr>
            <% End If %>
            <% If Len(CStr(objError.Description)) > 0 Then %>
            <tr>
                <td>
                    <strong>Brief Description</strong></td>
                <td>
                    <input type="text" id="txtDesc" name="txtDesc" class="m_shorttextfield" size="80"
                        value="<%=objError.Description %>" readonly="readonly" /></td>
            </tr>
            <% End If %>
            <% If Len(CStr(objError.ASPDescription)) > 0 Then %>
            <tr>
                <td>
                    <strong>Full Description</strong></td>
                <td>
                    <textarea id="txtAspDesc" name="txtAspDesc" class="multilinetextfield" 
                        cols="70" rows="4"><%=Trim(objError.ASPDescription) %></textarea>
                    </td>
            </tr>
            <% End If %>
            <tr>
                <td>
                    <strong>Date & Time</strong>
                </td>
                <td>
                    <input type="text" id="txtDate" name="txtDate" class="m_shorttextfield" size="25"
                        value="<%=now() %>" readonly="readonly" /></td>
            </tr>
            <tr>
                <td>
                    <strong>ELT Account</strong>
                </td>
                <td>
                    <input type="text" id="txtELTNumber" name="txtELTNumber" class="m_shorttextfield" size="25"
                        value="<%=Request.Cookies("CurrentUserInfo")("elt_account_number") %>" readonly="readonly" /></td>
            </tr>
            <tr>
                <td>
                    <strong>User ID</strong>
                </td>
                <td>
                    <input type="text" id="txtUserId" name="txtUserId" class="m_shorttextfield" size="25"
                        value="<%=Request.Cookies("CurrentUserInfo")("user_id") %>" readonly="readonly" /></td>
            </tr>
            <tr>
            <td colspan="2" style="text-align:center">
                <input type="submit" name="submit" class="button" value="Click here to report this error" />
            </td></tr>
        </table>
        </form>
    </div>
</body>
</html>
