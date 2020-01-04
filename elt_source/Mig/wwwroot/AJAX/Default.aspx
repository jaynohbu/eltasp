
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div id="DragPanelDiv" ondrop="PlaceDiv()">
            <ajaxToolkit:DragPanelExtender ID="DragPanelExtender1" runat="server" TargetControlID="PanelContainer" DragHandleID="PanelHeader">
            </ajaxToolkit:DragPanelExtender>
            <ajaxToolkit:ResizableControlExtender runat="server" TargetControlID="PanelContainer" HandleCssClass="handle">
            </ajaxToolkit:ResizableControlExtender>
            <asp:Panel ID="PanelContainer" runat="server" BackColor="#ffffff">
                <asp:Panel ID="PanelHeader" runat="server" style="width:300px; background-color:#ddffee;">
                    Click & Drag
                </asp:Panel>
                <asp:Panel ID="PanelBody" runat="server" style="width:300px; height:160px; background-color:#ccddaa;">
                    <br /><input type="text" id="TextField1" value="input here" /><br />
                    <textarea cols="25" rows="4">test textarea</textarea>
                </asp:Panel>
              </asp:Panel>
           </div>
           
           
           <table>
           <tr><td width="300" height="200" bgcolor="#eeddee"></td><td width="300" height="200" bgcolor="#eeeeee"></td></tr>
           <tr><td width="300" height="200" bgcolor="#eeeeee"></td><td width="300" height="200" bgcolor="#eeddee"></td></tr>
           <tr><td width="300" height="200" bgcolor="#eeddee"></td><td width="300" height="200" bgcolor="#eeeeee"></td></tr>
           </table>
    </form>
    <script type="text/javascript">
    
        function PlaceDiv(){
        
            var divObj = document.getElementById("PanelBody");
            var dragDivObj = document.getElementById("DragPanelDiv");
            var targetObj = GetObjectByClientXY(event,document);

            if(targetObj!=null && targetObj.innerHTML != null){
                targetObj.innerHTML = divObj.innerHTML;
                dragDivObj.style.visibility = "hidden";
            }
        }
        
        function GetObjectByClientXY(evtObj,docObj){
            var returnObj = null;
            
            for(var i=0;i<docObj.all.length; i++){
                
                var top = parseInt(docObj.all[i].offsetTop);
                var height = parseInt(docObj.all[i].height);
                var left = parseInt(docObj.all[i].offsetLeft);
                var width = parseInt(docObj.all[i].width);
                var cY = parseInt(evtObj.clientY);
                var cX = parseInt(evtObj.clientX);
                
                if(top < cY && cY < (top + height) && left < cX && cX < (left + width))
                {
                    if(docObj.all[i].tagName == "TD" || docObj.all[i].tagName == "DIV"){
                        returnObj = docObj.all[i];
                    }
                }
            }
            return returnObj;
        }

    </script>   
    
</body>
</html>