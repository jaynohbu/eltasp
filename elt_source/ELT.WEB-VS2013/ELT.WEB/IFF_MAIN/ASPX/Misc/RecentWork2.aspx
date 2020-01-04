<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RecentWork2.aspx.cs" Inherits="ASPX_Misc_RecentWork2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Recent Work</title>
    <link href="../CSS/AppStyle.css" type="text/css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table class="bodycopy" cellpadding="0" cellspacing="0" border="0">
                <tr><td style="height:10px"></td></tr>
                <tr>
                    <td>
                        <asp:Button ID="Button1" runat="server" Text="Save" OnClick="Button1_Click" />
                    </td>
                </tr>
                <tr><td style="height:10px"></td></tr>
                <tr>
                    <td>
                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnRowCommand="GridView1_RowCommand"
                            CellPadding="2">
                            <Columns>
                                <asp:ButtonField ButtonType="Image" CommandName="select" ImageUrl="../../Images/mark_n.GIF">
                                    <HeaderStyle BackColor="DimGray" />
                                    <ItemStyle VerticalAlign="Top" HorizontalAlign="Center" Width="20px" />
                                </asp:ButtonField>
                                <asp:TemplateField>
                                <HeaderStyle HorizontalAlign="Left" BackColor="DimGray"/>
                                <HeaderTemplate>
                                <table style="height:20px" class="bodycopy" cellpadding="2" cellspacing="0" border="0">
                                <tr><td style="width: 10px"></td>
                                <td style="color:White"><strong>Date</strong></td></tr>
                                </table>
                                </HeaderTemplate>
                                    <ItemStyle VerticalAlign="Top" HorizontalAlign="Left" Width="720px" />
                                    <ItemTemplate>
                                        <table class="bodycopy" cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td style="width: 10px">
                                                </td>
                                                <td>
                                                    <asp:Label ID="Date" runat="server" Text='<%# Eval("Date") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 7px">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 10px">
                                                </td>
                                                <td>
                                                    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="false" Visible="false">
                                                        <Columns>
                                                            <asp:BoundField DataField="TIME" HeaderText="Time">
                                                                <ItemStyle Width="65px" />
                                                            </asp:BoundField>
                                                            <asp:HyperLinkField DataNavigateUrlFields="surl" DataTextField="TITLE" 
                                                                Target="mainFrame" HeaderText="Title">
                                                                <ItemStyle Width="120px" />
                                                            </asp:HyperLinkField>
                                                            <asp:BoundField DataField="DOC_NUM" HeaderText="Doc No.">
                                                                <ItemStyle Width="140px" />
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="DETAIL" HeaderText="Detail">
                                                                <ItemStyle Width="320px" />
                                                            </asp:BoundField>
                                                            <asp:TemplateField HeaderText="Remark">
                                                                <ItemStyle Width="240px" HorizontalAlign="Center" />
                                                                <ItemTemplate>
                                                                    <asp:HiddenField ID="WorkID" runat="server" Value='<%# Eval("workid") %>' />
                                                                    <asp:TextBox ID="Remark" Style="width: 220px" runat="server" BorderStyle="Solid"
                                                                        BorderColor="#aaaaaa" Text='<%# Eval("REMARKS") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 5px">
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <AlternatingRowStyle BackColor="#E0E0E0" />
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
