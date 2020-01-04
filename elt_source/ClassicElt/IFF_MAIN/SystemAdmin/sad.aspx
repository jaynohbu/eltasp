<%@ Page Language="C#" AutoEventWireup="true" CodeFile="sad.aspx.cs" Inherits="sad" CodePage="65001" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ELT SYSTEM CONTROL</title>

    <script type="text/jscript">
    
        function SessionTimeOuts() 
        { 
            self.setTimeout("RedirectToLogin();", '3000000'); 
        } 

        function RedirectToLogin() 
        {  
            alert('Your session has expired.'); 
            window.location.href = '../Authentication/login.aspx'; 
        }
    
        function cBoardAssign() {         
            var xmlHTTP = new ActiveXObject('Microsoft.XMLHTTP') 
            xmlHTTP.open('get','/IFF_MAIN/Board/member/login_ok_board.asp?h_url=/ / ',false);      
            xmlHTTP.send(); 
        }
        
        function resize_table()
        {
            var x,y;
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
            if(document.getElementById("iframeSAControl")!=null){
                //alert (y);
	            document.getElementById("iframeSAControl").style.height=parseInt(y 
	                - document.getElementById("iframeSAControl").offsetTop)+"px";
	        }
        }
        
        function load_iframe(){
            var vURL = document.getElementById("hPageURL").value;
            document.getElementById("iframeSAControl").src = "/IFF_MAIN/SystemAdmin/" + vURL;
        }

        window.onresize=resize_table; 
    </script>

</head>
<body onload="resize_table(); load_iframe();" style="margin: 0px 0px 0px 0px;"
    scroll="no">
    <form id="formCotrol" runat="server">
        <asp:HiddenField ID="hPageURL" runat="server" Value="NewAccount.aspx?mode=SysAdmin" />
        
        <div style="margin:10px 10px 10px 10px">
            FreightEasy System Administrator's Tasks&nbsp;&nbsp;
            <asp:DropDownList ID="lstTasks" runat="server" OnSelectedIndexChanged="lstTasks_SelectedIndexChanged"
                AutoPostBack="true">
                <asp:ListItem Text="Create New Account" Value="0"></asp:ListItem>
                <asp:ListItem Text="ELT Account Copy" Value="1"></asp:ListItem>
                <asp:ListItem Text="Module Manager" Value="2"></asp:ListItem>
                <asp:ListItem Text="Setup Master" Value="3"></asp:ListItem>
                <asp:ListItem Text="Setup Session Manager" Value="4"></asp:ListItem>
                <asp:ListItem Text="ELT Account Manager" Value="5"></asp:ListItem>
            </asp:DropDownList>
			&nbsp;&nbsp;
			<a href="/IFF_MAIN/Authentication/login.aspx">Logout</a>
			&nbsp;&nbsp;
			<a href="javascript:load_iframe();">Refresh</a>
        </div>
        <div style="background-color:#cccccc; height:10px"></div>
        <iframe id="iframeSAControl" width="100%" src="" scrolling="yes" frameborder="0"></iframe>
    </form>
</body>
</html>
