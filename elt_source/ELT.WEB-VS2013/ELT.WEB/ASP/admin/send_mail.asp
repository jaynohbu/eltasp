
    <!--  #INCLUDE FILE="../include/SaveBinaryFile.asp" -->
  
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"     
    Dim oMail      
    Set oMail = Server.CreateObject("Persits.MailSender")          
    oMail.Host = "localhost"            
    oMail.From = Request("From")     
    Call ADD_TO_MAIL(oMail,Request("To"))
    if not IsNull(Request("Cc")) then
    Call ADD_CC_MAIL(oMail, Request("Cc"))
    end if 
    oMail.FromName = Request("FromName")
    oMail.IsHTML = True
    oMail.Subject = Request("Subject")         
    oMail.Body =  Request("Body")
    oMail.Send() 
    Response.Write("Success")
    
 %>
