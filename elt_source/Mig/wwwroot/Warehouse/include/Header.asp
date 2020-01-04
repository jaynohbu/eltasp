<script language='javascript'>

function fixProgressBar()
{
	if(parent.frames['dummyFrame'])
	{
		parent.frames['dummyFrame'].document.write("");
		parent.frames['dummyFrame'].document.close();
	}    
}

function saveScrollPosition() {
		if (document.all.scrollPositionX) {
			document.all.scrollPositionX.value = window.document.body.scrollLeft;
		}
		if (document.all.scrollPositionY) {
			document.all.scrollPositionY.value = window.document.body.scrollTop;
		}
}

/*
if (document.all) {
	document.onkeydown = trapRefreshIE;
} else {
	document.captureEvent(Event.KEYDOWN)
	document.onkeydown = trapRefreshNS;
}
	
function trapRefreshNS(e) {
	if (e.keyCode == 116) 
	{
	e.cancelBubble = true;
	e.returnValue = false;
	document.location.reload();
	}
}

function trapRefreshIE() {
	if (event.keyCode == 116) 
	{
	event.keyCode = 0;
	event.cancelBubble = true;	
	event.returnValue = false;
	document.location.reload();
	}
}
*/

</script>

<script language="javascript"> 
/*
  window.onload = function() 
  { 
    status = document.body.scrollTop=document.body.clientHeight; 
  } 
  */
</script> 

<%

'	if Request.ServerVariables("HTTP_REFERER") = "" then
'		Response.Redirect("/IFF_MAIN/Main.aspx")
'	end if

'	DIM igReadOnly
'	'############ by IG // Makes screen readonly
'	igReadOnly=Request.QueryString("igR")

	Dim bReadOnly
	
	Dim strJavaPop
	strJavaPop = "','popup','menubar=no, scrollbars=yes, staus=no, resizable=yes, titlebar=no, toolbar=no, hotkey=0,closeable=no');"

'/////////////////// by iMoon 2/8/2007
	Dim mode_begin
	mode_begin = true
'/////////////////// 
	
	Dim elt_account_number,login_name,user_id,ClientOS,agent_is_dome,agent_is_intl
	Dim session_ip,session_IntIp,session_server_name,session_user_lname,redPage
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	user_id = Request.Cookies("CurrentUserInfo")("user_id")
	ClientOS = Request.Cookies("CurrentUserInfo")("ClientOS")
	session_ip = Request.Cookies("CurrentUserInfo")("IP")
	session_IntIp = Request.Cookies("CurrentUserInfo")("intIP")
	session_server_name = Request.Cookies("CurrentUserInfo")("Server_Name")
	session_user_lname = Request.Cookies("CurrentUserInfo")("lname")
	redPage = Request.Cookies("CurrentUserInfo")("ORIGINPAGE")

	If Trim(session_user_lname) = "" Then
		session_user_lname = login_name
	End if
%>

<%

	if  elt_account_number = "" then
		%><script language="javascript">
			alert('Your session was expired or disconnected!');
			self.close();
			<%  if redPage = "" then %>
				top.location.replace('/freighteasy/index.aspx');  
			<% else %>
				top.location.replace('<%=redPage%>');			
			<% end if %>
  		 </script>
		<%
		response.End()			
	end if
%>

<%
	Dim temp_path,StrWindow,windowName '////////////////////// 2006.6.14

	Dim UserRight,userEmail,awbPort,bolPort,sedPort,invoicePort,invoiceQueue,checkPort,User_country,wh,UserType
	DIM	awbQueue,bolQueue,sedQueue,checkQueue,shippinglabelPort,shippinglabelQueue
	DIM	awbPrn,bolPrn,sedPrn,invoicePrn,checkPrn,shippinglabelPrn
	DIM curPageName
	DIM isAdmin
	
	temp_path= UCase(Server.MapPath("../../temp"))
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")		
	UserType = Request.Cookies("CurrentUserInfo")("user_type")		

	isAdmin = LCase(login_name) = "admin" Or LCase(login_name) = "system" Or UserRight = 9

	CALL AUTH_CHECK
	CALL SESSION_VALID
	CALL MODULE_CHECK
	
'response.write "UserRight:" & UserRight & "<br>"
'response.write "userEmail:" & userEmail & "<br>"
'response.write "awbPort:" & awbPort & "<br>"
'response.write "bolPort:" & bolPort & "<br>"
'response.write "sedPort:" & sedPort & "<br>"
'response.write "invoicePort:" & invoicePort & "<br>"
'response.write "invoiceQueue:" & invoiceQueue & "<br>"
'response.write "checkPort:" & checkPort & "<br>"
'response.write "User_country:" & User_country & "<br>"
'response.write "wh:" & wh & "<br>"
'response.write "awbQueue:" & awbQueue & "<br>"
'response.write "bolQueue" & bolQueue & "<br>"
'response.write "sedQueue" & sedQueue & "<br>"
'response.write "checkQueue" & checkQueue & "<br>"
'response.write "shippinglabelPort" & shippinglabelPort & "<br>"
'response.write "shippinglabelQueue" & shippinglabelQueue & "<br>"

%>

<%
StrWindow = "toolbar=yes,menubar=yes,scrollbars=yes,resizable=yes,hotkeys=no,location=no,width=600,height=400"
%>

<%
DIM isPopWin
windowName=Request.QueryString("WindowName")
isPopWin = ( Request.ServerVariables("HTTP_REFERER")  = ""  or windowName = "popupNew" or windowName = "PopWin" or windowName = "popUpWindow" or windowName = "PopupAN" or windowName = "popupfavorite" or windowName = "PopupNew" or windowName = "popUpPDF")
'response.write WindowName

%>

<script language=javascript>
function jPopUpNormal(){
var argS = 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1';
 popUpWindow = window.open('','popUpWindow', argS);
 }

function jPopUpNormalforSED(){
var argS = 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1';
 popUpSED = window.open('','popUpSED', argS);
 }

function jPopUpPDF(){
var argS = 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1';
 popUpPDF = window.open('','popUpPDF', argS);
 return popUpPDF;
 }

function jPopUpPDFAuth(){
var argS = 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1';
 popUpPDF = window.open('','popUpPDFAuth', argS);
 }

function jPopUp(sHeight){
var argS = 'height=' + sHeight + ',width=500,hotkeys=0,scrollbars=1,resizable=1';
if (document.layers) {
var sinist = screen.width / 2 - outerWidth / 2;
var toppo = screen.height / 2 - outerHeight / 2;
} else {
var sinist = screen.width / 2 - document.body.offsetWidth / 2;
var toppo = -75 + screen.height / 2 - document.body.offsetHeight / 2;
}
 popUpWindow = window.open('','popUpWindow', argS);
 }


function viewPop(Url) {

	if ( Url.indexOf("pdf") >= 0 || Url.indexOf("agent_stmt.asp") >= 0 )
	{
		if(document.form1) {
			jPopUpPDF();
			document.form1.action=Url + '&WindowName=popUpPDF';
			document.form1.method="POST";
			document.form1.target="popUpPDF"
			document.form1.submit();
		}
	}
	else
	{

		var strJavaPop = "";
		strJavaPop = window.open(Url,'popupNew','staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=900,height=600,hotkeys=0');
		strJavaPop.focus();
	}
}

function viewPop2(WinName,Url) {
var strJavaPop = "";
window.open(Url,WinName,'staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=800,height=600,hotkeys=0');

}

function viewPop3(WinName,Url) {
var strJavaPop = "";
window.open(Url,WinName,'staus=0,titlebar=0,toolbar=0,menubar=0,scrollbars=1,resizable=1,location=0,width=800,height=600,hotkeys=0');

}

</script>

<%
Sub SESSION_VALID
Dim SQL_SESSION,rs_session,another_user,elt_User_id,another_ip

elt_User_id = elt_account_number & user_id

	SQL_SESSION = "SELECT * FROM view_login where elt_account_number="&elt_account_number&" AND ip='"&session_ip&"'"&" AND server_name='"&session_server_name&"'"
	Set rs_session = eltConn.execute (SQL_SESSION)

	if not (rs_session.eof or rs_session.bof) Then 
			SQL_SESSION = "SELECT * FROM view_login where elt_account_number="&elt_account_number&" AND user_id='"&elt_User_id&"'"
			rs_session.close
			Set rs_session = eltConn.execute (SQL_SESSION)
			if (rs_session.eof or rs_session.bof) Then  
			%><script language="javascript">
				alert("You can`t use different user ID in one Session." );
				self.close();
				top.location.replace('/freighteasy/index.aspx');
			 </script>
			<%
			Else

'///////////////////////////////////////////////////////////////////////////////////	
				UserRight = rs_session("user_right")
				userEmail = rs_session("user_email")
				awbPort = rs_session("awb_port")
				bolPort = rs_session("bol_port")
				sedPort = rs_session("sed_port")
				invoicePort = rs_session("invoice_port")
				invoiceQueue = rs_session("invoice_queue")
				checkPort = rs_session("check_port")
				User_country = rs_session("user_country")
				wh =  rs_session("default_warehouse")
				awbQueue =   rs_session("awb_queue")
				bolQueue =  rs_session("bol_queue")
				sedQueue =  rs_session("sed_queue")
				checkQueue =  rs_session("check_queue")
				shippinglabelPort =  rs_session("shipping_label_port")
				shippinglabelQueue =  rs_session("shipping_label_queue")

'/////////////////////////////////////////////////////////////////////// by iMoon 2/7/2007	( Printer Name )
				awbPrn =  rs_session("awb_prn_name")
				bolPrn =  rs_session("bol_prn_name")
				sedPrn =  rs_session("sed_prn_name")
				invoicePrn =  rs_session("invoice_prn_name")
				checkPrn =  rs_session("check_prn_name")
				shippinglabelPrn =  rs_session("shipping_label_prn_name")
'/////////////////////////////////////////////////////////////////////// 

				login_name = MID(login_name,1,16)

				Session("user_country")=User_country
'///////////////////////////////////////////////////////////////////////////////////	
				SQL_SESSION = "Update view_login Set alive = 1, u_time='"&now&"',requested_page='"&curPageName&"' where elt_account_number="&elt_account_number&" AND ip='"&session_ip&"'" 
				eltConn.Execute SQL_SESSION
			End if
	Else

		SQL_SESSION = "SELECT * FROM view_login where elt_account_number="&elt_account_number&" AND user_id='"&elt_User_id&"'"
		rs_session.close
		Set rs_session = eltConn.execute (SQL_SESSION)
		if (rs_session.eof or rs_session.bof) Then  
		%><script language="javascript">
			alert('Your session was expired or disconnected!');
			self.close();
			<%  if redPage = "" then %>
				top.location.replace('/freighteasy/index.aspx');  
			<% else %>
				top.location.replace('<%=redPage%>');			
			<% end if %>
  		 </script>
		<%
		response.End()			
		else
		another_user = rs_session("server_name")
		another_ip = rs_session("intIP")
		%><script language="javascript">
			alert("Your session was disconnected by another computer! \n ("+"<%=another_user%>"+":"+"<%=another_ip%>"+")" );
			self.close();
			<%  if redPage = "" then %>
				top.location.replace('/freighteasy/index.aspx');  
			<% else %>
				top.location.replace('<%=redPage%>');			
			<% end if %>
  		 </script>
		<%
		end if
		rs_session.close
		set rs_session = nothing
		response.End()			
	End If

	rs_session.close
	set rs_session = nothing
	
End SUB
%>

<%

SUB AUTH_CHECK
curPageName = getTitle( Request.ServerVariables("URL"))

	if ( isAdmin or UserRight = "9") then
		bReadOnly = "0"
		exit sub
	end If
bReadOnly = IsAuth( curPageName )

END SUB

Sub MODULE_CHECK

    Dim rsMod,SQLMod
	Set rsMod = Server.CreateObject("ADODB.Recordset")
	SQLMod = "SELECT is_dome, is_intl FROM agent where elt_account_number=" & elt_account_number

	rsMod.Open SQLMod, eltConn, , , adCmdText
	
	If NOT rsMod.EOF Then
		agent_is_dome = rsMod("is_dome").value
	    agent_is_intl = rsMod("is_intl").value
	End If
	
End Sub

Function IsAuth( strcurPageName )
DIM SqlAuth,rValule,rsAuth,AuthType
rValule = false
	
	Set rsAuth = Server.CreateObject("ADODB.Recordset")
	SqlAuth = "SELECT a.Authority_Id,b.Name, b.PhysicalPage FROM SE_User_Authority a, SE_Pages b WHERE a.Page_Id=b.Page_Id AND a.elt_account_number=" & elt_account_number & " AND UserID=" & user_id & " AND b.PhysicalPage like '%" & strcurPageName & "'"

	rsAuth.Open SqlAuth, eltConn, , , adCmdText
	
	IF NOT rsAuth.eof then
		AuthType = rsAuth("Authority_Id")
		if (AuthType = "1") then
			rValule = true		
		end if
	ELSE
'////////////////////// Check if page did not registered in Auth Master...
		rsAuth.Close
		SqlAuth = "SELECT PhysicalPage FROM SE_Pages WHERE PhysicalPage like '%" & strcurPageName & "'" 

		rsAuth.Open SqlAuth, eltConn, , , adCmdText
		IF rsAuth.eof then
			rValule = true	
		ELSE

		%><script language="javascript">
			alert("You don't have the privilege to access this page!");
//			history.go(-1);			
  		 </script>
		<%
		response.End()			
		END IF
		
	END IF
	
	rsAuth.Close
	Set rsAuth=Nothing
	IsAuth = rValule
	
End Function

Function GetValidName(url)
	DIM lastSlashIndex,strUrl

	 lastSlashIndex = InStrRev(url,"/")
	 strUrl = mid(url,lastSlashIndex+1)
	 GetValidName = strUrl
	Exit Function
End Function

Function getTitle(url)
	DIM tmpStr,lastSlashIndex,parentVirPath,strUrl1,strUrl2,qChar

	tmpStr = url
	lastSlashIndex = InStrRev(tmpStr,"/")
	if(lastSlashIndex <= 0) then
		getTitle = url
		Exit Function
	end if

	parentVirPath = Left(url,lastSlashIndex-1)

	strUrl1 = GetValidName(url)
	strUrl2 = GetValidName(parentVirPath)
	tmpStr = strUrl2 + "/" + strUrl1

	qChar = InStr(tmpStr,"?")
	if (qChar > 0) then
	 tmpStr = Left(tmpStr,qChar-1)
	end if

	getTitle = tmpStr
End Function


%>

<%
'////////////////////////////////////////////////////
'////////// Scroll position restore by moon
'////////////////////////////////////////////////////
SUB RESTORE_SCROLL_BAR
DIM scrollPositionX,scrollPositionY

On Error Resume Next
	scrollPositionX = Request("scrollPositionX")
	scrollPositionY = Request("scrollPositionY")

	IF NOT scrollPositionX = "" AND  NOT scrollPositionY = "" THEN
		%>
			<script language="javascript">
				window.scrollTo(<%= scrollPositionX %>, <%= scrollPositionY %> ); 
			</script>
		<%
	END IF
END SUB
'////////////////////////////////////////////////////
'////////////////////////////////////////////////////
'////////////////////////////////////////////////////
%>

<script language='javascript'>
function CHECK_INVOICE_STATUS_AJAX(dType,s)
{ 
	try
	{
		var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP") 
		var param = 'dType=' + dType + '&n=' + s + '&e=' + '<%=elt_account_number%>';
		xmlHTTP.open("get","/IFF_MAIN/asp/include/check_invoice_status.asp?" + param ,false); 
		
		xmlHTTP.send(); 
		var sourceCode = xmlHTTP.responseText;

		if (sourceCode) 
		{
			if (dType == 'MAWB')
			{
			alert ('Invoice No. ' + sourceCode + ' for MAWB#:' + s + ' was processed already.' + '\nPlease save the MAWB information on MAWB screen later.');
			}

			if (dType == 'Booking')
			{
			alert ('Invoice No. ' + sourceCode + ' for Booking#:' + s + ' was processed already.' + '\nPlease save the MBOL information on MBOL screen later.');
			}
		}
	}	
	catch(e) {}

}

function CHECK_ORGANIZATION_AJAX(s)
{ 
var os = s
	try
	{
		var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP") 
		while(s.indexOf("&") != -1) { s = s.replace('&','________');	}	
		while(s.indexOf("'") != -1) { s = s.replace("'","^^^^^^^^");	}	

		var param = 'n=' + s + '&e=' + '<%=elt_account_number%>';
		xmlHTTP.open("get","/IFF_MAIN/asp/include/check_organization.asp?" + param ,false); 
		
		xmlHTTP.send(); 
		var sourceCode = xmlHTTP.responseText;

		if (sourceCode) 
		{
			alert ("The client [" + os + "] already exists in your client master.");
			return false;
		}
		else
		{
			return true;
		}
	}	
	catch(e) {}

return true;

}

function setChangeFlag() {
	try
	{
		document.all.FlagChanged.value = true;
	}	
	catch(e) {}
	
}

</script>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/gl_account_const.inc" -->

