<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ELTAccountManager.aspx.cs"
    Inherits="SystemAdmin_ELTAccountManager" CodePage="65001" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ELT Account Manager</title>
    <script type="text/javascript">
        function confirm_rowcommand(arg){
            return confirm("Click OK to proceed: " + arg);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
           <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource1" DataKeyNames="elt_account_number"
                AutoGenerateColumns="False" Font-Size="12px" CellPadding="2" OnRowCommand="GridView1_RowCommand">
                <Columns>
                    <asp:BoundField DataField="elt_account_number" HeaderText="ELT No." />
                    <asp:BoundField DataField="dba_name" HeaderText="DBA Name" />
                    <asp:BoundField DataField="status" HeaderText="Type" />
                    <asp:BoundField DataField="board_name" HeaderText="Board Name" />
                    <asp:BoundField DataField="business_phone" HeaderText="Phone" />
                    <asp:BoundField DataField="air_export" HeaderText="AE" />
                    <asp:BoundField DataField="ocean_export" HeaderText="OE" />
                    <asp:BoundField DataField="air_import" HeaderText="AI" />
                    <asp:BoundField DataField="ocean_import" HeaderText="OI" />
                    <asp:BoundField DataField="clients" HeaderText="CL" />
                    <asp:BoundField DataField="invoice" HeaderText="INV" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" runat="server" OnClientClick="return confirm_rowcommand('deleting agent');"
                                Text='<%# Eval("delete_text") %>' CommandName="Delete" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" OnInit="SqlDataSource1_Init" />
        </div>
    </form>
</body>
</html>
