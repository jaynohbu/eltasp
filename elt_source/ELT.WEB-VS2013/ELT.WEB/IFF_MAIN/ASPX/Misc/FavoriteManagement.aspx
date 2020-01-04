<%@ Register TagPrefix="ignav" Namespace="Infragistics.WebUI.UltraWebNavigator" Assembly="Infragistics.WebUI.UltraWebNavigator, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Page AutoEventWireup="true" CodeFile="FavoriteManagement.aspx.cs" Inherits="IFF_MAIN.ASPX.Misc.FavoriteManagement"
    Language="c#" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>FavoriteManagement</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
				<SCRIPT type="text/javascript">

		function displayError() {
		    alert('Your favorite menu has not beed saved yet.\nPlease save default favorite menu or make a new one.');
		}
		
		function refreshMain() {
		    
		    try
		    {
		    if( window.opener )
		    {
		        window.opener.ReloadMenu();
		        return;
		    }
		    if( window.parent ) {
		        window.parent.ReloadMenu();
		    }
		    }
		    catch(e) {}
		}
                </SCRIPT>

      <script language="javascript">
      
function NodeChecked(treeName, id, bChecked) 
{		
		var node = igtree_getNodeById(id);
		var tree = igtree_getTreeById(treeName);
		
        if(node.getChildNodes().length > 0) 
        {
            var h = node.getChecked(); 
	        var nodeCount=0;          
            childNode = node.getChildNodes();
        
            for(i=0; i<childNode.length; i++) 
            {
                childNode[i].setChecked(h);
            }
        }
}

      </script>

      <LINK href="../CSS/AppStyle.css" type=text/css rel=stylesheet>
  <!--  #INCLUDE FILE="../include/common.htm" -->
		
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.maincopy {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 9px;
	color: #000000;
}
-->
</style>
  </HEAD>
	<body MS_POSITIONING="FlowLayout">
		<form id="form1" method="post" runat="server">
		<input type="image" style="width:0px; height:0px" onclick="return false;" />
		<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td class="pageheader"><asp:Label ID="Label8" runat="server" CssClass="pageheader">Favorite Manager</asp:Label></td>
    </tr>
</table>

		
			<table id="Table3" width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#9190A5" class="border1px">
                <tr>
                    <td height="24" align="center" valign="middle" bgcolor="#C7C6E1"><asp:ImageButton ID="btnSave1" runat="server" designtimedragdrop="74" ImageUrl="../../images/button_save_medium.gif"
                                        OnClick="btnSave_Click1" /></td>
                </tr>
				          <tr>
            <td height="1" align="left" valign="top" bgcolor="#9190A5" class="bodyheader"></td>
          </tr>
                <tr>
                    <td bgcolor="#f3f3f3"><br>
                        <br>
                        <table width="55%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="87%"><asp:Label ID="lblError" runat="server" designtimedragdrop="9515" Font-Bold="True"
                                        Font-Italic="True" Font-Underline="False" ForeColor="Red" Width="100%"></asp:Label></td>
                            <td width="13%" align="right" valign="middle"><asp:ImageButton ID="btnStReload1" runat="server" ImageUrl="../../images/button_refresh.gif"
                                        OnClick="btnStReload_Click1" /></td>
                        </tr>
                    </table>
                        <br>
                        <table width="55%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#9190A5" bgcolor="#FFFFFF" class="border1px" id="Table6"> 
                        <tr>
                            <td width="6" height="8"></td>
                            <td width="2284" colspan="2"></td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td colspan="2"><ignav:UltraWebTree ID="wtFavorite" runat="server" CheckBoxes="True" Cursor="Hand" Font-Names="Verdana" Font-Size="9px" class="maincopy">
                                        <ClientSideEvents NodeChecked="NodeChecked" />
                            </ignav:UltraWebTree></td>
                        </tr>
						<tr>
                            <td height="8"></td>
                            <td colspan="2"></td>
                    </tr
                    ></table>
                        <br>
                        <table width="55%" border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="87%">&nbsp;</td>
                                <td width="13%" align="right" valign="middle"><asp:ImageButton ID=btnStReload runat="server" ImageUrl="../../images/button_refresh.gif" OnClick="btnStReload_Click1"></asp:ImageButton></td>
                            </tr>
                        </table>
                    <br></td>
                </tr>
                
                
                <tr>
                    <td></td>
                </tr>
				          <tr>
            <td height="1" align="left" valign="top" bgcolor="#9190A5" class="bodyheader"></td>
          </tr>
                <tr>
                    <td height="24" align="center" valign="middle" bgcolor="#C7C6E1"><asp:ImageButton ID=btnSave runat="server" designtimedragdrop="74" ImageUrl="../../images/button_save_medium.gif" OnClick="btnSave_Click1"></asp:ImageButton></td>
                </tr>
            </table>
			<br>
		</form>
	</body>
</HTML>
