
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<%
Set Mail = Server.CreateObject("Persits.MailSender")
Mail.Host = "localhost" ' Specify a valid SMTP server
Mail.From = "sender@e-logitech.net" ' Specify sender's address
Mail.FromName = "test" ' Specify sender's name

'Mail.AddAddress "skim@e-logitech.net" ' WORKING
Mail.AddAddress "suhyunkim@GMAIL.COM" ' NOT WORKING
Mail.AddReplyTo "skim@e-logitech.net"
'Mail.AddAttachment "c:\images\cakes.gif"

Mail.Subject = "Thanks for ordering our hot cakes!"
Mail.Body = "Dear Sir:Thank you for your business."

On Error Resume Next
Mail.Send
If Err <> 0 Then
     Response.Write "Error encountered: " & Err.Description
End If
%> 