<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OnlineApplyManager.aspx.cs"
    Inherits="SystemAdmin_OnlineApplyManager" CodePage="65001" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Setup Session Manager</title>
    <link href="../ASPX/css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/jscript">
        function confirm_rowcommand(arg){
            return confirm("Click OK to proceed: " + arg);
        }
    
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <br />
            <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource1" DataKeyNames="sid"
                AutoGenerateColumns="False" Font-Size="12px" CellPadding="2" OnRowCommand="GridView1_RowCommand">
                <Columns>
                    <asp:BoundField DataField="sid" HeaderText="SID" />
                    <asp:BoundField DataField="email" HeaderText="Email" />
                    <asp:BoundField DataField="password" HeaderText="Password" />
                    <asp:BoundField DataField="title" HeaderText="Current Page" />
                    <asp:BoundField DataField="created_date" HeaderText="Created" />
                    <asp:BoundField DataField="updated_date" HeaderText="Updated" />
                    <asp:BoundField DataField="elt_account_number" HeaderText="ELT #" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" runat="server" OnClientClick="return confirm_rowcommand('deleting session');"
                                Text="Delete" CommandName="Delete" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEmail" runat="server" OnClientClick="return confirm_rowcommand('email session');"
                                Text="Email" CommandName="Email" CommandArgument='<%#Eval("sid") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" OnInit="SqlDataSource1_Init" />
        </div>
    </form>
</body>
</html>
