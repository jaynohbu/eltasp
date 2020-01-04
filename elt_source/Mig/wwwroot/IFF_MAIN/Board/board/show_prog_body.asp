<%@ EnableSessionState=False%> 
<% 
Set m_objMon = Server.CreateObject("DEXT.FileUploadMonitor") 
m_objMon.ShowMonitor 
Set m_objMon = Nothing 
%> 