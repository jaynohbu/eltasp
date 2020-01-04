<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>
<%

DIM MBNO,HBNO,SEC,iType
'------------------------Main-------------------------'
MBNO=Request.QueryString("MAWB")
HBNO=Request.QueryString("HAWB")
SEC=Request.QueryString("Sec")

if SEC="" then
    SEC="1"
end if

iType=Request.QueryString("iType")
dim elt_account_number 
    elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")  

SQL=""
Dim rs
Set rs=Server.CreateObject("ADODB.Recordset") 
    
    SQL="select * from import_hawb where elt_account_number=" & elt_account_number & " and iType=N'" & iType & "' and mawb_num=N'" & MBNO & "' and hawb_num=N'" & HBNO & "' and sec=N'" & SEC & "'"  
   
    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
   
    if rs.EOF then
         response.Write "False-"&""
        response.End
    else 
        response.Write "True-"&rs("invoice_no")
        response.End
    end if 
    
    rs.close
    Set rs=Nothing
 %>
