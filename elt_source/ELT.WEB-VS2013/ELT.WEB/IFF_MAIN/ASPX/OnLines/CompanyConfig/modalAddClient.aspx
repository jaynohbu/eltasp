<%@ Page Language="C#" AutoEventWireup="true" CodeFile="modalAddClient.aspx.cs" Inherits="ASPX_modalAddClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <script language="javascript" type="text/javascript" src="/IFF_MAIN/ASPX/jScripts/div_align.js"> </script>
  
    
</head>
<body onload="divOverlap('upper','bottom','0','0')">
    <form id="form1" runat="server">
        
        <div id="bottom" style="left: 0px; width: 400px; position: absolute; top: 200px; height: 76px">
            <asp:Panel ID="pnlNext" runat="server" Height="76px" Width="400px"  Visible="false">
                <table style="width: 400px">
                    <tr>
                        <td colspan="4">
                        </td>
                    </tr>
                    <tr>
                        <td align="right" colspan="3" style="height: 26px">
                            <asp:Label ID="lblError" runat="server" Width="340px" Font-Size="Smaller" ForeColor="Red"></asp:Label></td>
                        <td align="right" style="height: 26px">
                           <asp:Button ID="btnResume" runat="server" Text="Resume" OnClick="btnResume_Click" Font-Size="Smaller"  /></td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
           
        <div id="upper" style="left: 0px; width: 400px; position: absolute; top: 0px; height: 96px"> 
        <asp:Panel ID="pnlInit" runat="server" Height="96px" Width="400px" >
            <table style="width: 400px">
                <tr>
                    <td align="left" style="width: 80px"  >
                      <asp:Label ID="lblDBA" runat="server" Text="DBA Name" Width="70px" Font-Size="Smaller"></asp:Label></td>    
                      <td align="left"   >
                      <asp:TextBox ID="txtDbaName" runat="server" Width="250px" ></asp:TextBox></td> 
					  <td align="right" width="70">
                        <asp:Button ID="btnQuickAdd" runat="server" Text="Quick Add" OnClick="btnQuickAdd_Click" Font-Size="Smaller" />
					</td>                 
                </tr>
				<tr>			
				</tr>
                <tr>
                    <td colspan="2" >
                        <asp:Button ID="btnFullInfo" runat="server" Text="Add Full Information" Width="183px" OnClick="btnFullInfo_Click" Font-Size="Smaller" />
                        
                    </td>
                    <td align="right" >
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" Font-Size="Smaller" /></td>
                </tr>
            </table>
            </asp:Panel>          
        </div>
      
      
    </form>
</body>
</html>
