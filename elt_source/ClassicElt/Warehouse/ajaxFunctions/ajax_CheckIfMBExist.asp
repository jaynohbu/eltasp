<!--  #INCLUDE FILE="../include/transaction.txt" -->
<!--  #INCLUDE FILE="../include/connection.asp" -->

<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>

<%

DIM MBNO,iType
'------------------------Main-------------------------'
MBNO=Request.QueryString("MAWB")

iType=Request.QueryString("iType")

dim elt_account_number 
elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")

SQL=""
Dim rs
Set rs=Server.CreateObject("ADODB.Recordset") 
    
    SQL="select * from import_mawb where elt_account_number=" & elt_account_number & " and iType='"&iType&"' and mawb_num='" & MBNO & "'" 
   
    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText

    if rs.EOF then
         response.Write "False-"&""
'        response.Write SQL
        response.End
    else 
        response.Write "True-"&rs("mawb_num")
'       response.Write SQL
        response.End
    end if 
    
    rs.close
    Set rs=Nothing
 %>
