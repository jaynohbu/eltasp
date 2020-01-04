
<%@ Page Language="c#" Inherits="IFF_MAIN.Main" CodeFile="Main.aspx.cs" CodePage="65001" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Main</title>
    <meta content="C#" name="CODE_LANGUAGE" />
    <meta http-equiv="X-UA-Compatible" content="IE=6" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="Refresh" content="0; URL=javascript:myReload();" />
    <style type="text/css">
		#igMyMenu { 
			Z-INDEX: 99999; 
			FILTER: alpha(opacity=100); 
			TOP: 83px; 
		}
		#igMyMenu A { 
			TEXT-DECORATION: none; 
		}
		#igMyMenu A:hover { 
			FILTER: alpha(opacity=100); 
			COLOR: red;
		}
	    body {
			margin: 0;
			padding: 0;
		}
        .style2 {
			color: #336699;
		}
        .style5 {
			font-size: 9px;
			font-family: Verdana, Arial, Helvetica, sans-serif;
			font-weight: bold;
			color: #1b4d89;
		}
		.style7 {
			font-family: Verdana, Arial, Helvetica, sans-serif;
			font-size: 9px;
		}
        .style8 {
			color: #1b4d89;
		}
    </style>
   
    <script type="text/jscript" src="./ASP/ajaxFunctions/lib/dhtmlHistory.js"></script>
     <script src="Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
       <%=Neodynamic.SDK.Web.WebClientPrint.CreateScript()%>
    <script type="text/javascript">
          function SetPrintLabelText(str) {
              //document.write (sid+"_"+str);
                var sid = '<%=Session.SessionID%>';
                PageMethods.SetPrintCommand(sid+"_"+str, onSucess, onError);  

    
        }
        function onSucess(result) {
            $("[id$='labelPrintBtn']").click();
        }

        function onError(result) {
            alert(result.responseText);
        }

    </script>
    <script type="text/jscript">
       
        function ask_setup_wizard(){
            var vURL = "/IFF_MAIN/NewAccount/SetupWizard.aspx";
            var vPopURL = "./NewAccount/SetupAsk.aspx";
            var vAnswer = showModalDialog(vPopURL,"", "dialogWidth:400px; dialogHeight:200px; help:0; status:0; scroll:0; center:1; resizable:0;");
            if(vAnswer == "Y"){
                top.location.replace("/IFF_MAIN/NewAccount/SetupWizard.aspx");
            }
        }
        
        function MM_swapImgRestore() { //v3.0
          var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
        }

        function MM_preloadImages() { //v3.0
          var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
            var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
            if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
        }

        function MM_findObj(n, d) { //v4.01
          var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
            d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
          if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
          for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
          if(!x && d.getElementById) x=d.getElementById(n); return x;
        }

        function MM_swapImage() { //v3.0
          var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
           if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
        }

        function viewPrivateBoard() {
            var sUrl = './Board/CompanyBoard.aspx';
            var favorite = "";
            favorite = window.open(sUrl,'popupfavorite','staus=0,titlebar=0,toolbar=0,menubar=0,scrollbars=0,resizable=1,location=0,width=900,height=600,hotkeys=0');
            favorite.focus();

        }
        function viewPublicBoard() {
            var sUrl = './Board/PublicBoard.aspx';
            var favorite = "";
            favorite = window.open(sUrl,'popupfavorite','staus=0,titlebar=0,toolbar=0,menubar=0,scrollbars=0,resizable=1,location=0,width=900,height=600,hotkeys=0');
            favorite.focus();

        }
        function viewCustomPage(sUrl) {
            document.frames['mainFrame'].location = sUrl;
        }

        function makeLocalOrg() {

            var sURL = "./ASP/master_data/downloadOrgM.asp";
            var argS = 'height=90,width=390,hotkeys=0,scrollbars=0,resizable=0,menubar=0';
            window.open(sURL,'okw', argS);
        }

        function makeMenu(obj,nest){
            nest=(!nest) ? '':'document.'+nest+'.'
            this.css=(n) ? eval(nest+'document.'+obj):eval(obj+'.style')                                                
            this.state=1;
            this.go=0;
            this.width=n?this.css.document.width:eval(obj+'.offsetWidth');
            this.left=b_getleft;
            this.obj = obj + "Object";         
            eval(this.obj + "=this");  
        }

        function b_getleft(){
                var gleft=(n) ? eval(this.css.left):eval(this.css.pixelLeft);
                return gleft;
        }

        function moveOut(){

            if (oMenu.state) {
                clearTimeout(tim);
                mOut();
                document.form1.moveImg.src = "images/button_close.gif";
             }        
        }

        function moveIn(){
            if (window.event.clientX > ( oMenu.width ) && !oMenu.state) {
                clearTimeout(tim);
                mIn();  
		        document.form1.moveImg.src = "images/button_open.gif";
            }        
        }

        function moveMenu(){
            if(!oMenu.state){
                clearTimeout(tim);
                mIn();
                document.form1.moveImg.src = "images/button_open.gif";
            }
            else{
                clearTimeout(tim);
                mOut();
                document.form1.moveImg.src = "images/button_close.gif";
            }
        }

        function moveMenuIn(){
            clearTimeout(tim);
            mOut();
        }

        function moveMenuOut(){
            clearTimeout(tim);
            mIn();
        }

        function moveFrame(vIfrRef,vDivRef) {
            var	IfrRef = document.getElementById(vIfrRef);
            var	DivRef = document.getElementById(vDivRef);

            IfrRef.style.left = DivRef.offsetLeft;
            IfrRef.style.top = DivRef.offsetTop;
            IfrRef.style.width = DivRef.offsetWidth-2;
            IfrRef.style.height = DivRef.offsetHeight-1;
            IfrRef.style.display = "block";
            IfrRef.style.backgroundColor = "black";
            IfrRef.style.zIndex = DivRef.style.zIndex - 1;
        }
        
        function mIn(){
            if(oMenu.left()>-oMenu.width+lshow){
                oMenu.go=1;
                oMenu.css.left=oMenu.left()-move;
		        moveFrame('igMyMenuFrm','igMyMenu');
                tim=setTimeout("mIn()",menuSpeed);
            }else{
                oMenu.go=0;
                oMenu.state=1;
            }
        }
        
        function mOut(){

            if(oMenu.left()<-1){
                oMenu.go=1;
                oMenu.css.left=oMenu.left()+move;
                moveFrame('igMyMenuFrm','igMyMenu');
                tim=setTimeout("mOut()",menuSpeed);
            }else{
                oMenu.go=0
                oMenu.state=0
            }  
        }

        function fixProgressBar()
        {
            if(parent.frames['dummyFrame'])
            {
	            parent.frames['dummyFrame'].document.write("");
	            parent.frames['dummyFrame'].document.close();
            }    
        }

        /********************************************************************************
        Inits the page, makes the menu object, moves it to the right place, 
        show it
        ********************************************************************************/

        ie = document.all?1:0;
        n = document.layers?1:0;
        lshow = 14;
        var move = 30;
        menuSpeed = 10;
        var moveOnScroll = true;
        var tim;
        var ltop;

        function menuInit(){
            if (document.body.clientHeight < 400 )
            {
                window.moveTo(0,0);
                window.resizeTo(screen.availWidth,screen.availHeight);
            }
try{
            var igTree = document.getElementById('TreeHolder');
           
            var igTreeHeight = document.body.clientHeight - ( 342 ); 
            igTree.height = igTreeHeight.toString() + 'px';
            }catch(e){}

            oMenu=new makeMenu('igMyMenu')
            scrolled=n?"window.pageYOffset":"document.body.scrollTop"
            oMenu.css.left=-oMenu.width+lshow
            ltop=(n)?oMenu.css.top:oMenu.css.pixelTop;
    		
            oMenu.css.visibility='visible';

            if(moveOnScroll) ie? window.onscroll=checkScrolled:checkScrolled();
            
            myLoad();
            fixProgressBar();
            MM_preloadImages('/iff_main/Images/icon_help_over.gif','/iff_main/Images/icon_support_over.gif','/iff_main/Images/icon_down_over.gif','/iff_main/Images/icon_clientsearch_over.gif','/iff_main/Images/icon_recentwork_over.gif','/iff_main/Images/icon_favorites_over.gif','/iff_main/Images/icon_companyboard_over.gif','/iff_main/Images/icon_readmessage_over.gif','/iff_main/Images/message_ani_off.gif');        
            intervalCallMemo();        
        }

        function ReloadMenu() {
            __doPostBack("btnReload", "");   		
        }

        /********************************************************************************
        Checking if the page is scrolled, if it is move the menu after
        ********************************************************************************/
        function checkScrolled(){

            if(!oMenu.go) 
            { 
                oMenu.css.top=eval(scrolled)+ltop;
                var	IfrRef = document.getElementById('igMyMenuFrm');
	            IfrRef.style.top = oMenu.css.top;       
                var	DivRef = document.getElementById('igMyMenu');
                IfrRef.style.left = DivRef.offsetLeft;
                IfrRef.style.top = DivRef.offsetTop;
                IfrRef.style.width = DivRef.offsetWidth-2;
                IfrRef.style.height = DivRef.offsetHeight-1;
                IfrRef.style.display = "none";
                IfrRef.style.display = "block";
                IfrRef.style.backgroundColor = "black";
                IfrRef.style.zIndex = DivRef.style.zIndex - 1;  	    
            }
            if(n) setTimeout('checkScrolled()',30)
        }

        function logout() {
            cookVal = "x";
            //var cName = "<%=Session.SessionID%>"+"<%=elt_account_number%>"+"<%=user_id%>"+"tabLocation";
            //document.cookie = cName+"="+cookVal;
            //__doPostBack("btnOut", "");   
$("#btnOut").trigger("click");		
        }

        function createOrgProfile(vHAWB) {
            var path = "/IFF_MAIN/ASPX/OnLines/CompanyConfig/CompanyConfigCreate.aspx?R=R&AutoCreate=yes&HAWB_NUM=" + vHAWB;
            winopen = window.open(path,"popup","", "menubar=no, scrollbars=yes, staus=no, resizable=yes, titlebar=no, toolbar=no, hotkey=0,closeable=no");  
        }

        function chkIsAuthenticated() {
            __doPostBack("btnChkIsAuthenticated", ""); 
        }

        function getCookieVal (offset) {  
            var endstr = document.cookie.indexOf (";", offset);  
            if (endstr == -1) endstr = document.cookie.length;  
            return unescape(document.cookie.substring(offset, endstr));
        }

        function GetCookie (name) {  
            var arg = name + "=";  
            var alen = arg.length;  
            var clen = document.cookie.length;  
            var i = 0;  
            while (i < clen) {    
                var j = i + alen;    
                if (document.cookie.substring(i, j) == arg) return getCookieVal (j);    
                i = document.cookie.indexOf(" ", i) + 1;    
                if (i == 0) break;   
            }  
            return null;
        }

        function frameReload()
        {
            try
            {
                var f = document.getElementById('mainFrame');
                f.contentWindow.location.reload(true);
            }
            catch(e){}
        }

        function myReload() {

            var cName = "<%=Session.SessionID%>"+"<%=elt_account_number%>"+"<%=user_id%>"+"tabLocation";
            var iUrl = GetCookie(cName);

            if(!iUrl) return;

            var strLoc = new Array();
            var strUrl;
            strLoc = iUrl.split('^');
            var bExp = new Date(strLoc[strLoc.length-1]);  
            var nExp = new Date();  
            var dExp = nExp - bExp;
            if(dExp > 3000) return;	
            
            document.frames['mainFrame'].location = strLoc[0];
            document.frames['topFrame'].location = strLoc[1];

        }

        function myLoad() {
            var dp = document.getElementById('txtDefaultPage').value;

            if (dp && dp != "" ) {
                document.frames['mainFrame'].location = "/IFF_MAIN/" + dp;
                document.getElementById('txtDefaultPage').value = "";
            }
        }

        function myUnload() {
            var strLoc = "";
	        var cookVal = "";
	        strLoc = window.frames['mainFrame'].location;

	        if(strLoc.toString().indexOf('rMAWB') >= 0) {

		        var tmpStr = strLoc.toString();
		        var indx1= tmpStr.indexOf('?');
		        var indx2 = tmpStr.indexOf('&rMAWB');
    		
		        if(indx2 > 0) 	{
		        strLoc = tmpStr.substring(0,indx1+1) + 'r' +  tmpStr.substring(indx1+1);
		        }
		        else {
		        strLoc = tmpStr.substring(0,indx1+1) + 'rEdit=yes&' +  tmpStr.substring(indx1+1);			
		        }
            }

	        if(strLoc.toString().indexOf('edit_invoice.asp?save=yes') >= 0) {

		        var tmpStr = strLoc.toString();
		        var indx1= tmpStr.indexOf('save');
		        var indx2 = tmpStr.indexOf('&PrintINV');
    		
		        strLoc = tmpStr.substring(0,indx1) + 'edit' +  tmpStr.substring(indx1+4);
		        strLoc = strLoc.substring(0,indx2+1);
                // alert(strLoc)
            }

	        if(strLoc.toString().indexOf('save=yes') >= 0) {
		        var tmpStr = strLoc.toString();
		        var indx1= tmpStr.indexOf('save');
		        strLoc = tmpStr.substring(0,indx1) + 'edit' +  tmpStr.substring(indx1+4);
            }
	        if(strLoc.toString().indexOf('Save=yes') >= 0) {
		        var tmpStr = strLoc.toString();
		        var indx1= tmpStr.indexOf('Save');
		        strLoc = tmpStr.substring(0,indx1) + 'Edit' +  tmpStr.substring(indx1+4);
            }

	        cookVal += strLoc+'^';
	        strLoc = window.frames['topFrame'].location;
	        cookVal += strLoc+'^';
        		
            var cName = "<%=Session.SessionID%>"+"<%=elt_account_number%>"+"<%=user_id%>"+"tabLocation";
	        var exp = new Date();  
		        cookVal += exp;
            document.cookie = cName+"="+cookVal; 
            
            return true;
            
        }

        function PopWindowURL(sUrl,width,height) {
            var popWindow = window.open(sUrl,'popupfavorite','staus=0,titlebar=0,toolbar=0,menubar=0,scrollbars=1,resizable=1,location=0,width=' + width + ',height=' + height + ',hotkeys=0');
            popWindow.focus();
        }

        function go_favorite(sUrl,topModule) {

            PopWindowURL(sUrl,800,600);
            return false;
        }

        function cBoardAssign() { 
            try{
                 var xmlHTTP = new ActiveXObject('Microsoft.XMLHTTP') 
                 xmlHTTP.open('get','/IFF_MAIN/Board/member/login_ok_board.asp?h_url=/ / ',false); 
                 xmlHTTP.send(); 
            }
            catch (e) {}
        }


        function intervalCallMemo() { 
            memoLoad(true);
            setInterval("memoLoad(false)", 10000); 
        } 

        function OpenWindow(url,intWidth,intHeight) { 
            window.open(url, "msg", "left=10,top=10,width="+intWidth+",height="+intHeight+",resizable=0,scrollbars=1");
        }

        function memoLoad(z) { 

              if (window.ActiveXObject) {
	               try {
		            xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	               } catch(e) {
                        try {
                         xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch(e1) {
                         return;
                        }
                  }
              } else if (window.XMLHttpRequest) {
                    xmlHTTP = new XMLHttpRequest();
              } else {return;}
             
            try {    
                xmlHTTP.open("get","/iff_main/board/message/top_check_memo.asp",false); 
                xmlHTTP.send();

                var sourceCode = xmlHTTP.responseText;
                //alert(sourceCode);
                var memoArrived;
                var memoMsgDisplayedAlready;
	            if (sourceCode)
	            {
		            if(sourceCode.indexOf("session was expired") >= 0 || sourceCode.indexOf("disconnected") >= 0)
		            {
           	            parent.frames['dummyFrame'].document.write(sourceCode)
		            }

		            if(sourceCode.indexOf("img_memo_on") >= 0) 
		            {
			            memoArrived = true;
		            }
		            else
		            {
			            memoArrived = false;
		            }

		            var obj = document.getElementById('img_memo_on');
		            if(obj) {
			            memoMsgDisplayedAlready = true;
		            }
		            else
		            {
			            memoMsgDisplayedAlready = false;
		            }

		            if(!z)
		            {
		                if(memoArrived != memoMsgDisplayedAlready) z = true;
		            }
		            if(z)
		            {
                        document.getElementById('memoFrame').innerHTML = sourceCode;
		            }
	            }
            }   catch(e) {}
        }

        //Initing menu on pageload
        onload = menuInit;
        
        /*
        window.onbeforeunload=iFrameinit;
        function iFrameinit(){
        window.frames['topFrame'].location.reload(true);
        window.frames['mainFrame'].location.reload(true);
        window.location.reload(false);
        } 
        */

    </script>

</head>
<body onunload="return myUnload();" style="margin-top: 0px" scroll="no">
    <form id="form1" method="post" runat="server">
 <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <!-- added for client logo holder -->
        <div id="clientLogo" style="height: 65px; width: 250px; position: absolute; top: 5px;
            left: 30px; background: white">
            <img src="<%=logoUrl %>" alt="" />
        </div>
        <table id="Table2" style="height: 100%" cellspacing="0" cellpadding="0" width="100%"
            border="0">
            <tr>
                <td id="pTdSize" colspan="1" rowspan="1" style="height: 150px; width: 100%">
                    <iframe id="topFrame" name="topFrame" frameborder="0" height="100%" scrolling="no"
                        src="/ASP/tabs/tab_maker.asp?mode=land" width="100%"></iframe>
                </td>
            </tr>
            <tr>
                <td id="fTd">
                    <table id="Table1" style="border-right: medium none; padding-right: 0px; border-top: medium none;
                        padding-left: 0px; padding-bottom: 0px; margin: 0px; border-left: medium none;
                        width: 100%; padding-top: 0px; border-bottom: medium none; height: 100%" height="699"
                        cellspacing="0" cellpadding="0" border="0">
                        <tr>
                            <td valign="top" align="right" colspan="0" height="100%" style="width: 100%">
                                <iframe id="mainFrame" name="mainFrame" frameborder="0" height="100%" scrolling="yes"
                                    src="" style="padding-right: 0px; padding-left: 0px; padding-bottom: 0px; margin: 0px;
                                    padding-top: 0px" width="100%"></iframe>
                                <asp:Button ID="btnOut" runat="server" OnClick="btnOut_Click" Text="." />
                                <asp:LinkButton ID="LinkButton1" runat="server"></asp:LinkButton><asp:Button ID="btnReload"
                                    runat="server" OnClick="btnReload_Click" Text="Button" Visible="False" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <asp:TextBox ID="txtDefaultPage" runat="server" Width="0px"></asp:TextBox>
        <!-- Start of Fav. -->
        <div id="igMyMenu" style="z-index: 99999; visibility: visible; width: 253px; cursor: hand;
            position: absolute; top: 0px; left: -500px" onclick="javascript:moveOut();" onmouseout="javascript:moveIn();">
            <table width="251" border="0" cellpadding="0" cellspacing="0" bgcolor="fcfcfc" id="tmpFavTable">
                <tr>
                    <td style="height: 14px; background-image: url('Images/back_main_top.gif')" colspan="3"
                        align="left" valign="top">
                    </td>
                    <td rowspan="14" align="left" valign="top" onclick="javascript:moveMenu();" style="width: 13px;
                        background-image: url('/iff_main/Images/main_back.gif'); background-color: #fcfcfc">
                        <img src="images/button_open.gif" name="moveImg" width="13" height="150" id="moveImg"
                            onclick="javascript:moveMenu();" alt="" /></td>
                </tr>
                <tr>
                    <td align="left" valign="top" bgcolor="b5d0f1" style="width: 16px">
                        <img src="/iff_main/Images/spacer.gif" width="16" height="1" alt="" /></td>
                    <td width="206" align="left" valign="top" bgcolor="b5d0f1" class="bodyheader">
                        <span style="width: 206px"><span class="style5">Welcome
                            <%Response.Write(login_lname);%>
                        </span></span>
                        <img src="/iff_main/Images/spacer.gif" width="8" height="1"></td>
                    <td align="left" valign="top" bgcolor="b5d0f1" style="width: 16px">
                        <img src="/iff_main/Images/spacer.gif" width="16" height="1"></td>
                </tr>
                <tr>
                    <td bgcolor="b5d0f1" style="height: 8px">
                    </td>
                    <td align="left" valign="top" bgcolor="b5d0f1" class="bodycopy" style="height: 8px">
                    </td>
                    <td bgcolor="b5d0f1" style="width: 16px; height: 8px;">
                    </td>
                </tr>
                <tr>
                    <td align="left" valign="top" bgcolor="b5d0f1" class="bodycopy style2" style="height: 31px">
                    </td>
                    <td height='31' align="left" valign="top" bgcolor="b5d0f1" id="msgGrText">
                        <span class="style5">
                            <asp:Label ID="lblGreeting" runat="server" Height="31px" Width="100%" Text=""></asp:Label></span></td>
                    <td bgcolor="b5d0f1">
                    </td>
                </tr>
                <tr>
                    <td colspan="3" bgcolor="b5d0f1" style="height: 8px">
                    </td>
                </tr>
                <tr>
                    <td height="10" colspan="3" background="Images/back_main_bottom.gif">
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <img src="/iff_main/Images/icon_tool.gif" name="tool" width="238" height="31" id="tool"
                            alt="" /></td>
                </tr>
                <tr>
                    <td colspan="3">
                        <img src="/iff_main/Images/icon_support.gif" name="support" width="238" height="31"
                            onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('support','','/iff_main/Images/icon_support_over.gif',1)"
                            onclick="javascript:PopWindowURL('./ASPX/Misc/Support_Main.aspx',400,300)" alt="" /></td>
                </tr>
                <tr>
                    <td colspan="3">
                        <img src="/iff_main/Images/icon_clientsearch.gif" name="clientserarch" width="238"
                            height="31" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('clientserarch','','/iff_main/Images/icon_clientsearch_over.gif',1)"
                            onclick="javascript:PopWindowURL('./aspx/onlines/companyconfig/companysearch.aspx',800,600)"
                            alt="" /></td>
                </tr>
                <tr>
                    <td colspan="3">
                        <img src="/iff_main/Images/icon_help.gif" name="help" width="238" height="31" border="0"
                            onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('help','','/iff_main/Images/icon_help_over.gif',1)"
                            onclick="javascript:PopWindowURL('./ASPX/Doctrack/operationdoctracking.aspx',800,600)"
                            alt="" /></td>
                </tr>
                <tr>
                    <td colspan="3" style="height: 31px">
                        <img src="/iff_main/Images/icon_recentwork.gif" name="recentworks" width="238" height="31"
                            onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('recentworks','','/iff_main/Images/icon_recentwork_over.gif',1)"
                            id="recentworks" onclick="javascript:PopWindowURL('./ASPX/MISC/RecentWork2.aspx',800,600)"
                            alt="" /></td>
                </tr>
                <tr>
                    <td colspan="3">
                        <img src="/iff_main/Images/icon_favorites.gif" name="favorite" width="238" height="31"
                            id="favorite" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('favorite','','/iff_main/Images/icon_favorites_over.gif',1)"
                            onclick="javascript:PopWindowURL('./ASP/site_admin/favorite_manager.asp',800,600)"
                            alt="" /></td>
                </tr>
                <tr>
                    <td colspan="3" align="left" valign="top" style="height: 131px">
                        <table width="238" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td height="6" style="width: 16px">
                                    <img src="/iff_main/Images/spacer.gif" width="16" height="1" alt="" /></td>
                                <td style="width: 222px">
                                    <img src="/iff_main/Images/spacer.gif" width="222" height="1" alt="" /></td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                                <td id="TreeHolder" align="left" valign="top" style="width: 222px">
                                    <div style="overflow: auto; width: 222px;">
                                        <asp:TreeView ID="TreeView1" runat="server" ImageSet="Custom" Font-Names="Verdana, Arial, Helvetica, sans-serif"
                                            Font-Size="9px">
                                            <LevelStyles>
                                                <asp:TreeNodeStyle HorizontalPadding="1px" />
                                                <asp:TreeNodeStyle HorizontalPadding="1px" />
                                                <asp:TreeNodeStyle HorizontalPadding="1px" />
                                            </LevelStyles>
                                        </asp:TreeView>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <table border="0" cellpadding="0" cellspacing="0" height="64px" valign='top'>
                <tr valign='top'>
                    <td style="width: 238px; height: 32px;" valign='top'>
                        <img onclick="javascript:viewPrivateBoard();" src="/iff_main/Images/icon_companyboard.gif"
                            name="companyboard" width="238" height="32" onmouseout="MM_swapImgRestore()"
                            onmouseover="MM_swapImage('companyboard','','/iff_main/Images/icon_companyboard_over.gif',1)"
                            alt="" /></td>
                    <td rowspan="2" valign="top" background="/iff_main/Images/main_back.gif" style="width: 13px;
                        height: 64px" align="left">
                        <img src="/iff_main/Images/spacer.gif" height="64" width="13" /></td>
                </tr>
                <tr valign='top'>
                    <td align="left" valign="top" style="height: 31px; width: 238px;" id='memoFrame'>
                    </td>
                </tr>
            </table>
        </div>
        <!-- End of Fav. -->
  <asp:TextBox ID="tbZebraText" runat="server"></asp:TextBox>
     <%-- <asp:TextBox ID="tbZebraText" runat="server">AAA</asp:TextBox>--%>
    <input type="hidden" id="h_elt_acct" value="<%=elt_account_number%>"/>
         <a href="#" id="labelPrintBtn" onclick="jsWebClientPrint.print('sid=<%=Session.SessionID%>');"/>

        <iframe id="igMyMenuFrm" style="display: none; left: -500px; position: absolute;
            top: 0px" frameborder="0" scrolling="no"></iframe>
        <iframe id="dummyFrame" style="display: none; left: -500px; position: absolute; top: 0px"
            frameborder="0" scrolling="no"></iframe>
        <asp:TextBox ID="txtIP" runat="server" Width="0px" Height="0px"></asp:TextBox>
	
        <script type="text/javascript">
            $(document).ready(function () { 


});
           
        </script>
    </form>
</body>
</html>
