<style>
.JPED{
back-ground-color:red;
}
</style>

<script type="text/javascript">
  // fix for deprecated method in Chrome 37
  if (!window.showModalDialog) {
     window.showModalDialog = function (arg1, arg2, arg3) {

        var w;
        var h;
        var resizable = "no";
        var scroll = "no";
        var status = "no";

        // get the modal specs
        var mdattrs = arg3.split(";");
        for (i = 0; i < mdattrs.length; i++) {
           var mdattr = mdattrs[i].split(":");

           var n = mdattr[0];
           var v = mdattr[1];
           if (n) { n = n.trim().toLowerCase(); }
           if (v) { v = v.trim().toLowerCase(); }

           if (n == "dialogheight") {
              h = v.replace("px", "");
           } else if (n == "dialogwidth") {
              w = v.replace("px", "");
           } else if (n == "resizable") {
              resizable = v;
           } else if (n == "scroll") {
              scroll = v;
           } else if (n == "status") {
              status = v;
           }
        }

        var left = window.screenX + (window.outerWidth / 2) - (w / 2);
        var top = window.screenY + (window.outerHeight / 2) - (h / 2);
        var targetWin = window.open(arg1, arg1, 'toolbar=no, location=no, directories=no, status=' + status + ', menubar=no, scrollbars=' + scroll + ', resizable=' + resizable + ', copyhistory=no, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        targetWin.focus();
     };
  }
</script>    

<%

    Response.Expires = 0  
    Response.AddHeader "Pragma","no-cache"  
    Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
    
	Dim bReadOnly
	Dim strJavaPop
	strJavaPop = "','popup','menubar=no, scrollbars=yes, staus=no, resizable=yes, titlebar=no, toolbar=no, hotkey=0,closeable=no');"

'/////////////////// by iMoon 2/8/2007
	Dim mode_begin
	mode_begin = true
'/////////////////// 
	
	Dim elt_account_number,login_name,user_id,ClientOS,agent_is_dome,agent_is_intl,agent_is_cartage,agent_status
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


	if  elt_account_number = "" then
  
    
%>

<script type="text/jscript">
			alert('No Acct. Cookie!');			
</script>

<%
		response.End()			
	end if

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
	'CALL SESSION_VALID
	CALL MODULE_CHECK

    StrWindow = "toolbar=yes,menubar=yes,scrollbars=yes,resizable=yes,hotkeys=no,location=no,width=600,height=400"


    DIM isPopWin
    windowName=Request.QueryString("WindowName")
    isPopWin = ( Request.ServerVariables("HTTP_REFERER")  = ""  or windowName = "popupNew" or windowName = "PopWin" or windowName = "popUpWindow" or windowName = "PopupAN" or windowName = "popupfavorite" or windowName = "PopupNew" or windowName = "popUpPDF")
%>

<script type="text/jscript">
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
        } 
        else {
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
			    document.form1.action = encodeURI(Url) + '&WindowName=popUpPDF';
			    document.form1.method = "POST";
			    document.form1.target = "popUpPDF"
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


SUB AUTH_CHECK
curPageName = getTitle( Request.ServerVariables("URL"))
	if ( isAdmin or UserRight = "9") then
		bReadOnly = "0"
		exit sub
	end If
END SUB

Sub MODULE_CHECK

    Dim rsMod,SQLMod
	Set rsMod = Server.CreateObject("ADODB.Recordset")
	SQLMod = "SELECT account_statue,is_dome, is_intl, is_cartage FROM agent where elt_account_number=" & elt_account_number
    On Error Resume Next
  
	rsMod.Open SQLMod, eltConn, , , adCmdText
    If err = 0 Then
    If NOT rsMod.EOF Then
		agent_is_dome = rsMod("is_dome").value
	    agent_is_intl = rsMod("is_intl").value
	    agent_is_cartage = rsMod("is_cartage").value
	    agent_status = rsMod("account_statue").value
	End If
    Else
    Response.Write "Error Occurred<br>" & err.Description
    End If	
End Sub

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

'////////////////////////////////////////////////////
'////////// Scroll position restore by moon
'////////////////////////////////////////////////////
SUB RESTORE_SCROLL_BAR
DIM scrollPositionX,scrollPositionY

On Error Resume Next
	scrollPositionX = Request.QueryString.Item("scrollPositionX")
	scrollPositionY = Request.QueryString.Item("scrollPositionY")

	IF NOT scrollPositionX = "" AND  NOT scrollPositionY = "" THEN
%>

<script type="text/jscript">
				window.scrollTo(<%= scrollPositionX %>, <%= scrollPositionY %> ); 
</script>

<%
	END IF
END SUB
'////////////////////////////////////////////////////
'////////////////////////////////////////////////////
'////////////////////////////////////////////////////
%>

<script type="text/jscript">
    function CHECK_INVOICE_STATUS_AJAX(dType,s)
    { 
	    try
	    {
	        var xmlHTTP = new XMLHttpRequest();
		    var param = 'dType=' + encodeURIComponent(dType) + '&n=' + encodeURIComponent(s) 
		        + '&e=' + '<%=elt_account_number%>';
		    xmlHTTP.open("get","/ASP/include/check_invoice_status.asp?" + param ,false); 
    		
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
		        var xmlHTTP = new XMLHttpRequest(); 
		        while(s.indexOf("&") != -1) { s = s.replace('&','________');	}	
		        while(s.indexOf("'") != -1) { s = s.replace("'","^^^^^^^^");	}	

		        var param = 'n=' + encodeURIComponent(s) + '&e=' + '<%=elt_account_number%>';
		        xmlHTTP.open("get","/ASP/include/check_organization.asp?" + param ,false); 
        		
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

    function setChangeFlag(){
	    try
	    {
		    document.all.FlagChanged.value = true;
	    }	
	    catch(e) {}
    }

    function showJPModal(targetURL, sourceURL, vWidth, vHeight, vWindow){
        // parent window
        var returnVal = null;
        if (window.name == "" && window.opener == null){
            returnVal = showModalDialog(targetURL + "&WindowName=" + vWindow, "", 
                "dialogWidth:" + vWidth + "px; dialogHeight:" + vHeight + 
                "px; help:0; status:1; scroll:1; center:1; resizable:1;");

            // after modal closed with return value

            if(returnVal){
                // option 1 - close modal redirect parent to target URL
                // option 2 - close modal open new modal with target URL
                return showJPModal(returnVal, sourceURL, vWidth, vHeight, vWindow);
            }
            // after modal closed without return value
            else{
                if(sourceURL != ""){
                    window.location.href = sourceURL;
                }
                else{
                    return false;
                }
            }
        }
        // opened by window open
        else if(window.opener != null){
            window.location.href = targetURL;
        }
        // opened by showmodal
        else{
            window.returnValue = targetURL;
            window.close();
        }
        return true;
    }
    
    window.name="<%=windowName %>";
    
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

    function IsNull(what) { return what == null }
    function CheckBlank(arg1, arg2) { //converted from vbscript
        var result;
        if (IsNull(arg1))
            result = arg2;
        else {
            if (arg1 == "")
                result = arg2;
            else
                result = arg1;
        }
        return result;
    }
    function replaceAll(find, replace, str) {
        return str.replace(new RegExp(find, 'g'), replace);
    }

    function Space(num) {   //new
        return new Array(num + 1).join(" ");
    }
    function IsNumeric(n) { // added new
        if (n == 0)
            return true;

        if (!(n != '' &&  n != 'undefined'))
            return false;
        
        n = n.toString();
        if (n.indexOf(",") >= 0)
            n= n.replace(",", "");
        return !isNaN(parseFloat(n)) && isFinite(n);
    }
    function IsEmpty(n) { // added new
        return !(n != '' && n != null && n != undefined && n != 'undefined');
    }
    function CheckNullToZero(FormValue) {
        if (IsEmpty(FormValue))
            return 0;

        return FormValue;

    }
    function IsDate(dateStr) {

        var datePat = /^(\d{1,2})(\/|-)(\d{1,2})(\/|-)(\d{4})$/;
        var matchArray = dateStr.match(datePat); // is the format ok?

        if (matchArray == null) {
            alert("Please enter date as either mm/dd/yyyy or mm-dd-yyyy.");
            return false;
        }

        month = matchArray[1]; // p@rse date into variables
        day = matchArray[3];
        year = matchArray[5];

        if (month < 1 || month > 12) { // check month range
            alert("Month must be between 1 and 12.");
            return false;
        }

        if (day < 1 || day > 31) {
            alert("Day must be between 1 and 31.");
            return false;
        }

        if ((month == 4 || month == 6 || month == 9 || month == 11) && day == 31) {
            alert("Month " + month + " doesn`t have 31 days!")
            return false;
        }

        if (month == 2) { // check for february 29th
            var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
            if (day > 29 || (day == 29 && !isleap)) {
                alert("February " + year + " doesn`t have " + day + " days!");
                return false;
            }
        }
        return true; // date is valid
    }

    function FormatCurrency(number) {
        var number = number.toString(),
    dollars = number.split('.')[0],
    cents = (number.split('.')[1] || '') + '00';
        dollars = dollars.split('').reverse().join('')
        .replace(/(\d{3}(?!$))/g, '$1,')
        .split('').reverse().join('');
        return '$' + dollars + '.' + cents.slice(0, 2);
    }
    function cDate(str) {
        var comp = str.split('/');
        var m = parseInt(comp[0], 10);
        var d = parseInt(comp[1], 10);
        var y = parseInt(comp[2], 10);
        var date = new Date(y, m - 1, d);
        return date.toDateString();
    }
    var autocompleteMMDDYYYYDateFormat = function (str) {
        str = str.trim();
        var matches, year,
                looksLike_MM_slash_DD = /^(\d\d\/)?\d\d$/,
                looksLike_MM_slash_D_slash = /^(\d\d\/)?(\d\/)$/,
                looksLike_MM_slash_DD_slash_DD = /^(\d\d\/\d\d\/)(\d\d)$/;

        if (looksLike_MM_slash_DD.test(str)) {
            str += "/";
        } else if (looksLike_MM_slash_D_slash.test(str)) {
            str = str.replace(looksLike_MM_slash_D_slash, "$10$2");
        } else if (looksLike_MM_slash_DD_slash_DD.test(str)) {
            matches = str.match(looksLike_MM_slash_DD_slash_DD);
            year = Number(matches[2]) < 20 ? "20" : "19";
            str = String(matches[1]) + year + String(matches[2]);
        }
        return str;
    };
   
</script>

<!--  #INCLUDE VIRTUAL="/ASP/include/gl_account_const.inc" -->