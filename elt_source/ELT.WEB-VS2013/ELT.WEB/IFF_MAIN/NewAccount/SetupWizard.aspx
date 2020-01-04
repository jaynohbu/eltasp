<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SetupWizard.aspx.cs" Inherits="Setup_SetupWizard" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>FreighEasy Setup Wizard</title>
    <link type="text/css" rel="stylesheet" href="/IFF_MAIN/ASPX/CSS/elt_css.css" />

    <style type="text/css">
    
        .NevigateText{
            font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 11px;
	        color: #000000;
	        text-decoration: none;
	        font-weight: bold;
        }
        
    </style>
    <script type="text/jscript">
        
        function fixProgressBar()
		{
			if(window.frames['dummyFrame'])
			{
				window.frames['dummyFrame'].document.write("");
				window.frames['dummyFrame'].document.close();
			}    
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
            if(document.getElementById("iframeSetup")!=null){
                //alert (y);
	            document.getElementById("iframeSetup").style.height=parseInt(y 
	                - document.getElementById("iframeSetup").offsetTop)+"px";
	        }
        }
        
        window.onresize=resize_table; 
        
        function load_iframe(){
            var vURL = document.getElementById("hPageURL").value;
            document.getElementById("iframeSetup").src = "/IFF_MAIN/" + vURL;
            
            if(document.getElementById("hSetupType").value == "Required"){
                document.getElementById("tblNextStep").style.visibility = "hidden";
            }
        }
        
        function update_setup_session(arg){
            try{
                document.getElementById("hIsNextPage").value = arg;
                document.form1.submit();
            }catch (ex){ alert(ex.message); }
        }
        
        function exit_setup_session(){
            window.top.location = "/IFF_MAIN/Main.aspx?Setup=N&T=";
        }
        
    </script>

</head>
<body onload="resize_table(); load_iframe();" style="margin: 0px 0px 0px 0px;" scroll="no">
    <form id="form1" runat="server">
        <asp:HiddenField ID="hSetupType" runat="server" />
        <asp:HiddenField ID="hPageID" runat="server" />
        <asp:HiddenField ID="hValidateURL" runat="server" />
        <asp:HiddenField ID="hPageURL" runat="server" />
        <asp:HiddenField ID="hIsNextPage" runat="server" Value="" />
        <table cellpadding="0" cellspacing="0" border="0" style="width: 100%; height: 120px">
            <tr>
                <td style="vertical-align: top; width: 231px;">
                    <img src="/ASP/images/logo_FE.gif" alt="" style="border: none 0px" />
                </td>
                <td style="vertical-align: top">
                    <table cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="height: 10px">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="labelTitle" runat="server" CssClass="pageheader" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="labelInstruction" runat="server" CssClass="bodyheader" Width="400px" />
                            </td>
                        </tr>
                    </table>
                </td>
                <td style="text-align: right">
                    <table id="tblNextStep" style="height:100px" cellpadding="2" cellspacing="0" border="0">
                        <tr>
                            <td colspan="4">
                                <a href="javascript:exit_setup_session();" class="NevigateText">Save & Exit Setup</a>&nbsp;
                            </td>
                            <td style="text-align:left">
                                <input type="image" src="/ASP/images/icon_additional_info_back.gif" onclick="exit_setup_session();" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <a href="javascript:update_setup_session('B');" class="NevigateText">Back Step</a>&nbsp;</td>
                            <td>
                                <input type="image" src="/ASP/images/icon_goto_left.gif" 
                                    value="Goto Next Step" onclick="update_setup_session('B')" /></td>
                            <td style="width:10px"></td>
                            <td>
                                <a href="javascript:update_setup_session('F');" class="NevigateText">Next Step</a>&nbsp;</td>
                            <td>
                                <input type="image" src="/ASP/images/icon_goto.gif"
                                    value="Goto Next Step" onclick="update_setup_session('F')" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="3" style="height: 10px; background-color: #cccccc">
                </td>
            </tr>
        </table>
        <iframe id="iframeSetup" width="100%" src="" scrolling="yes" frameborder="0" onload="fixProgressBar()">
        </iframe>
        <iframe id="dummyFrame" style="display: none; left: -500px; position: absolute; top: 0px"
            frameborder="0" scrolling="no"></iframe>
    </form>
</body>
</html>
