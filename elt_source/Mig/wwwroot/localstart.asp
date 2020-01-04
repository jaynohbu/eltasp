<% @Language = "VBScript" %>
<% Response.buffer = true %>

<html>

<%
Dim oFS,oFSPath
Dim servername,serverinst, path
Dim oDefSite,sDefDoc,sSitePath,sDocName
Dim aDefDoc
Dim success
Dim infoobj, administ
Dim bind,binditems,port,adminURL

adminURL = ""
success = false

Set infoobj=GetObject("IIS://localhost/w3svc/info")
Set administ= GetObject("IIS://localhost/w3svc/" & infoobj.AdminServer)	
bind = administ.ServerBindings(0)(0)
binditems = split(bind,":")
port= binditems(1)
adminURL = "http://localhost:" & port & "/"


Set oFS=CreateObject("Scripting.FileSystemObject")

servername=Request.ServerVariables("SERVER_NAME")
serverinst=Request.ServerVariables("INSTANCE_ID")

path = "IIS://" & servername & "/W3SVC/" & serverinst
Set oDefSite = GetObject(path)

thisURL = oDefSite.ADsPath & "/Root" & Request.ServerVariables("URL")
if instr(thisURL,"localstart.asp") > 0 then
	thisURL =  Mid(thisURL,1,instr(thisURL,"localstart.asp")-2)
end if
Set oDefSiteRoot = GetObject(thisURL)
'Get the default document for this site...
sDefDoc = oDefSite.DefaultDoc
sSitePath = oDefSiteRoot.Path

'parse through the default document string
aDefDocs = split(sDefDoc,",")

'and make sure at least one of them is valid
for each sDocName in aDefDocs
	if oFS.FileExists(sSitePath & "\" & sDocName) then
		if InStr(sDocName,"iisstart") = 0 then
			success = True
			exit for
		end if
	end if
next
%>





<head>
<title>Welcome to Windows 2000 Internet Services</title>
<style>
	ul{margin-left: 15px;}
	.clsHeading {font-family: verdana; color: black; font-size: 11; font-weight: 800; width:210;}	
	.clsEntryText {font-family: verdana; color: black; font-size: 11; font-weight: 400; background-color:#FFFFFF;}		
	.clsWarningText {font-family: verdana; color: #B80A2D; font-size: 11; font-weight: 600; width:550;  background-color:#EFE7EA;}	
	.clsCopy {font-family: verdana; color: black; font-size: 11; font-weight: 400;  background-color:#FFFFFF;}	
	
</style>
</head>

<body TOPMARGIN="3" LEFTMARGIN="3" MARGINHEIGHT="0" MARGINWIDTH="0" BGCOLOR="#FFFFFF"
LINK="#000066" VLINK="#000000" ALINK="#0000FF" TEXT="#000000">
<!-- BEGIN MAIN DOCUMENT BODY --->

<img src="win2000.gif" vspace="0" hspace="0"> 
<table WIDTH="500" CELLPADDING="5" CELLSPACING="3" BORDER="0">
<% if not success and err = 0 then %>
  <tr>
    <td CLASS="clsWarningText" colspan="2">

	<img SRC="warning.gif" WIDTH="40" HEIGHT="40"
    BORDER="0" ALIGN="LEFT" vspace="0" hspace="0"> <strong>You do not currently have a default document set for your
    users. Any users attempting to connect to this site are currently receiving an <a
    href="<%= "iisstart.asp?uc=1" %>">"Under Construction page"</a>.</strong>

	</td>
  </tr>
<% end if %>
  <tr>
	<td>
	<table CELLPADDING="3" CELLSPACING="3" border=0 >
	<tr>
		<td valign="top" rowspan=3>
			<IMG SRC="web.gif">
		</td>	
		<td valign="top" rowspan=3>
	<span CLASS="clsHeading">
	Welcome to IIS 5.0</span><br>
    	<span CLASS="clsEntryText">		
	Internet Information Services (IIS) for 
	Microsoft Windows 2000 brings the power of Web computing to Windows. 
	With IIS, you can easily share files and printers and create 
	applications to securely publish information to improve 
	the way your organization works. IIS is a secure platform for building and deploying eCommerce solutions. IIS also makes it easy to bring mission-critical business applications to the Web.
	<P>
	Windows 2000 with IIS scales to meet your needs. You can:</span>
	<p>
	<ul class="clsEntryText">
	<li>Set up a personal Web server.
	<li>Share information within your team.
	<li>Access databases.
	<li>Create an enterprise intranet.
	</ul>
	<p>
	<span CLASS="clsEntryText">
	IIS integrates proven Internet standards with Windows, so that using the Web does 
	not mean having to start over and learn new ways to publish, manage, or develop. 
	<P>
	Windows 2000 with Internet Information Services is the easiest way to 
	share information and run powerful applications on the Web.
	</span>
	</td>

		<td valign="top">
			<IMG SRC="mmc.gif">
		</td>
		<td valign="top">
			<span CLASS="clsHeading">Integrated Management</span>
			<br>
			<span CLASS="clsEntryText">
				You can manage IIS through the Windows 2000 Computer Management <a href="javascript:activate();">console</a>, or by using scripting. If you have installed Windows 2000 Server or Windows 2000 Advanced Server, the   
			<% if port <> "" then %><A HREF="<%=adminURL%>">Administration Web site</A><% else %>Administration Web site<% end if %> can also be used to manage IIS.  
			<p>
			You can also right-click on a directory, 
			and you can share its contents via the Web, as well as configure the most common IIS settings. 
			</span>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<IMG SRC="help.gif">
		</td>
		<td valign="top">
			<span CLASS="clsHeading"><a href="javascript:loadHelpFront();">Online Documentation</a></span>
			<br>
			<span CLASS="clsEntryText">The award-winning IIS online documentation includes an index,
 			   full-text search, and printing by node or by individual topic. You can:<p>
			</span>
			<ul class="clsEntryText">
 		 		<li>Get help with tasks.
 				<li>Learn about server operation.
				<li>Consult reference material.
		 		<li>View code samples.
			</ul>

		</td>
	</tr>
<%

		Dim WshShell, ver
		Set WshShell = Server.CreateObject("Wscript.Shell")
		On Error Resume Next
		ver = 0
		ver = WshShell.RegRead("HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\DisableWebPrinting")
		
%>

<% If ver <> 1 or err <> 0 Then %>
	<tr>
		<td valign="top">
			<IMG SRC="print.gif">
		</td>
		<td valign="top">
			<span CLASS="clsHeading">Web Printing</span>
			<br>
			<span CLASS="clsEntryText">Windows 2000 dynamically lists all the printers on your
 			   server on an easily accessible <a HREF="/printers" target="_new">Web site</a>. You can browse this site
 			   to monitor printers and their jobs. You can also connect to the printers via this site
 			   from any Windows computer.
			</span>
		</td>
	</tr>
<% end if %>
<% err.clear %> 
	</table>
</td>
</tr>
</table>

<P align=center><EM><A href="/iishelp/common/colegal.htm">© 
1997-1999 Microsoft Corporation. All rights 
reserved.</A></EM></P></FONT></BODY>

<script LANGUAGE="javascript">
	var gWinheight
	var gDialogsize
	var ghelpwin;
	//launch help
	window.moveTo(5,5);
	gWinheight= 480;
	gDialogsize= "width=640,height=480,left=300,top=50,"
	if (window.screen.height > 600)
	{
<% if not success and err = 0 then %>
		gWinheight= 700;
<% else %>
		gWinheight= 700;
<% end if %>
		gDialogsize= "width=640,height=480,left=500,top=50"
	}
	
	window.resizeTo(600,gWinheight)
	loadHelpFront();

function loadHelpFront(){
	ghelpwin = window.open("http://localhost/iishelp/","Help","status=yes,toolbar=yes,menubar=yes,location=yes,resizable=yes,"+gDialogsize,true);	
}

function activate(){
	window.open("http://localhost/iishelp/iis/htm/core/iisnapin.htm", "SnapIn", 'toolbar=no, left=200, top=200, scrollbars=no, resizeable=no,  width=350, height=350');
}
</script>

</html>

