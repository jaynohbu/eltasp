<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Main.aspx.cs" Inherits="Main" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Exporter Main</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type="text/jscript">
        
        function GetCookie (name) {  
            try{
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
            }catch(err){ alert(err.description); }
        }
        
        function myReload() {
            
            try{
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
            }catch(err){ alert(err.description); }
        }
        
        function logout() {
            try{
                window.location.href = "/EXP_MAIN/Main.aspx?mode=logout";
            }catch(err){ alert(err.description); }
        }
        
        function frameReload()
        {
            try
            {
                var f = document.getElementById('mainFrame');
                f.contentWindow.location.reload(true);
            }
            catch(err){}
        }
        
        function intervalCallMemo() {
            try{
                memoLoad(true);
                setInterval("memoLoad(false)", 10000); 
            }catch(err){ alert(err.description); }
        } 
        
        function memoLoad(z){
            try{
                if (window.ActiveXObject){
                    try{
                        xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
                    }catch(err){
                        try{
                            xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                        }catch(err){
                            return;
                        }
                    }
                }else if(window.XMLHttpRequest){
                    xmlHTTP = new XMLHttpRequest();
                }else{ 
                    return; 
                }
                 
                try {    
                    xmlHTTP.open("get","/EXP_MAIN/AJAX/session_validate.asp", false); 
                    xmlHTTP.send(); 
                    var sourceCode = xmlHTTP.responseText;
                    
                    var memoArrived;
                    var memoMsgDisplayedAlready;
	                if (sourceCode)
	                {
		                parent.frames['dummyFrame'].document.write(sourceCode);
	                }
                }catch(err){ }
            }catch(err){ alert(err.description); }
        }
        
        function resize_table()
        {
            try{
                var x,y,topFrameHeight,offsetTop;
                
                if (self.innerHeight) // all except Explorer
                {
	                x = self.innerWidth;
	                y = self.innerHeight;
                }
                else if (document.documentElement && document.documentElement.clientHeight)
	                // Explorer 6 Strict Mode
                {
	                x = document.documentElement.clientWidth;
	                y = document.documentElement.clientHeight;
                }
                else if (document.body) // other Explorers
                {
	                x = document.body.clientWidth;
	                y = document.body.clientHeight;
                }
                if(document.getElementById("mainFrame")!=null){
                    topFrameHeight = parseInt(document.getElementById("pTdSize").style.height);
                    offsetTop = parseInt(document.getElementById("mainFrame").offsetTop);
	                document.getElementById("mainFrame").style.height = parseInt(y - offsetTop - topFrameHeight) + "px";
	            }
	        }catch(err){ alert(err.description); }
        }
        
        window.onresize=resize_table; 
        
    </script>

</head>
<body style="margin: 0px 0px 0px 0px" scroll="no" onload="resize_table(); intervalCallMemo();">
    <form id="form1" runat="server">
        <div>
            <table id="Table2" style="height: 100%; width: 100%" cellspacing="0" cellpadding="0"
                border="0">
                <tr>
                    <td id="pTdSize" colspan="1" rowspan="1" style="height: 140px; width: 100%">
                        <iframe id="topFrame" frameborder="0" height="100%" scrolling="no" src="/EXP_MAIN/Tabs/tab_maker.asp?mode=land"
                            width="100%"></iframe>
                    </td>
                </tr>
                <tr>
                    <td id="fTd">
                        <table id="Table1" style="border-right: medium none; padding-right: 0px; border-top: medium none;
                            padding-left: 0px; padding-bottom: 0px; margin: 0px; border-left: medium none;
                            width: 100%; padding-top: 0px; border-bottom: medium none; height: 100%" cellspacing="0"
                            cellpadding="0" border="0">
                            <tr>
                                <td valign="top" align="right" colspan="0" style="width: 100%; height: 100%">
                                    <iframe id="mainFrame" frameborder="0" height="100%" width="100%" scrolling="yes"
                                        src="" style="padding-right: 0px; padding-left: 0px; padding-bottom: 0px; margin: 0px;
                                        padding-top: 0px"></iframe>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div style="position: absolute; top: 0px; left: 0px; visibility: hidden">
            <asp:Button ID="btnOut" runat="server" OnClick="btnOut_Click" Text="Logout" />
            <asp:TextBox ID="txtDefaultPage" runat="server" />
        </div>
        <iframe id="dummyFrame" style="visibility:hidden; position: absolute; top: 0px;
            left: 0px; width: 200px; height: 100px" frameborder="1" scrolling="yes"></iframe>
    </form>
</body>
</html>
