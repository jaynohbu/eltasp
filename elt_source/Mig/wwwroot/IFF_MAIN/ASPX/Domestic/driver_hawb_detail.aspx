<%@ Page Language="C#" AutoEventWireup="true" CodeFile="driver_hawb_detail.aspx.cs"
    Inherits="ASPX_Domestic_driver_hawb_detail" %>

<%@ Register TagPrefix="mobile" Namespace="System.Web.UI.MobileControls" Assembly="System.Web.Mobile" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<body>
    <mobile:Form ID="Form1" Runat="server" BackColor="#ccffff"><mobile:Command ID="Command1"
        Runat="server" OnClick="Command1_Click">Go to list</mobile:Command> <mobile:Command ID="Command2" Runat="server" OnClick="Command2_Click">Go to milestone</mobile:Command><mobile:Command
            ID="Command3" Runat="server" OnClick="Command3_Click">Save Modification</mobile:Command> <br />HAWB #: <mobile:Label ID="labelHAWB" Runat="server">
        </mobile:Label><br />Quantity: <mobile:TextBox ID="TextBoxPiece" Runat="server" Size="5">
        </mobile:TextBox><br />Weight: <mobile:TextBox ID="TextBoxWeight" Runat="server"
            Size="10">
        </mobile:TextBox><br />Cost Desc: <mobile:Label ID="TextBoxCostDesc" Runat="server">
        </mobile:Label><br />Paid Amount: <mobile:TextBox ID="TextBoxCostAmt" Runat="server"
            Size="10">
        </mobile:TextBox><br />Remark: <mobile:TextBox ID="TextBoxRemark" Runat="server">
        </mobile:TextBox> Milestones: <mobile:SelectionList ID="ListMilestones" Runat="server">
        </mobile:SelectionList></mobile:Form>
</body>
</html>
