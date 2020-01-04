<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ManageOceanSED.aspx.cs" Inherits="ASPX_Misc_ManageOceanSED" %>

<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport" TagPrefix="cc1" %>
<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage AES</title>
    <script type="text/jscript">

        function aes_delete() {
            if (confirm("Click OK to delete the saved AES form?")) {
                return true;
            }
            return false;
        }

        function get_itn_from_aes_direct(aesNo) {
            var vURL = "/ASP/aes/tran_get_itn_no.asp?WindowName=AESDIRECT&AESID=" + aesNo;
            var vWinArg = "left=0,top=0,staus=0,titlebar=0,toolbar=0,menubar=0,scrollbars=1,resizable=1,location=0,width=650,height=450,hotkeys=0";

            var vWindow = window.open(vURL, "AESDIRECT", vWinArg);
            vWindow.focus();
            return;
        }

        function OpenAES(AESID) {
            window.open('./EditOceanAES.aspx?AESID=' + AESID, 'popUpWindow', 'menubar=0,toolbar=0,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
        }
    </script>
    <!--  #INCLUDE FILE="../include/common.htm" -->
    <link href="/IFF_MAIN/ASPX/CSS/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
    <center>
        <table cellpadding="0" cellspacing="0" border="0" style="width: 95%">
            <tr>
                <td class="pageheader" style="text-align: left">
                    AES Manager
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td style="text-align: left; vertical-align: bottom">
                    <asp:ImageButton ID="btnExcelExport" runat="server" ImageUrl="/ASP/images/button_exel.gif"
                        OnClick="btnExcelExport_Click" />
                </td>
                <td id="print" style="text-align: right">
                    <a href="javascript:OpenAES('');">
                        <img src="/ASP/images/icon_createhouse.gif" style="border: none 0px; margin-right: 10px"
                            alt="" />Create New AES</a>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding-top:2px;">
                 <asp:Label runat="server" ID="txtResultBox" Width="95%" Visible="false" />
        <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Width="95%" OnInitializeLayout="UltraWebGrid1_InitializeLayout"
            DataSourceID="SqlDataSource1" OnInitializeRow="UltraWebGrid1_InitializeRow">
            <Bands>
                <igtbl:UltraGridBand>
                    <FilterOptions EmptyString="" AllString="" NonEmptyString="">
                        <FilterDropDownStyle BorderWidth="1px" BorderColor="Silver" BorderStyle="Solid" BackColor="White"
                            Width="200px" CssClass="bodycopy" />
                        <FilterHighlightRowStyle ForeColor="White" BackColor="#151C55" CssClass="bodycopy" />
                    </FilterOptions>
                    <Columns>
                        <igtbl:TemplatedColumn Width="41" AllowGroupBy="No" SortIndicator="Disabled">
                            <HeaderStyle Cursor="Auto" />
                            <CellTemplate>
                                <asp:ImageButton ID="btnEdit" ImageUrl="/ASP/images/button_edit.gif" runat="server"
                                    OnClick="btnEdit_Click" CommandName="Edit" CommandArgument="<%#Container.Cell.Row.Index %>" />
                            </CellTemplate>
                        </igtbl:TemplatedColumn>
                        <igtbl:TemplatedColumn Width="53" AllowGroupBy="No" SortIndicator="Disabled">
                            <HeaderStyle Cursor="Auto" />
                            <CellTemplate>
                                <asp:ImageButton ID="btnDelete" ImageUrl="/ASP/images/button_delete.gif" runat="server"
                                    OnClientClick="return aes_delete();" OnClick="btnDelete_Click" CommandName="Delete"
                                    CommandArgument="<%#Container.Cell.Row.Index %>" />
                            </CellTemplate>
                        </igtbl:TemplatedColumn>
                    </Columns>
                </igtbl:UltraGridBand>
            </Bands>
            <DisplayLayout Name="UltraWebGrid1" BorderCollapseDefault="Separate" RowHeightDefault="20px"
                SelectTypeRowDefault="None" RowSizingDefault="Free" ViewType="OutlookGroupBy"
                SelectTypeCellDefault="None" SelectTypeColDefault="None" EnableInternalRowsManagement="True"
                AllowSortingDefault="Yes" HeaderClickActionDefault="SortSingle" RowSelectorsDefault="No"
                Version="4.00" TableLayout="Fixed" AllowColSizingDefault="Free" ScrollBarView="Horizontal">
                <FrameStyle BorderWidth="1px" BorderStyle="Solid" Width="95%" BorderColor="#6D8C80"
                    TextOverflow="Ellipsis">
                </FrameStyle>
                <GroupByBox>
                    <style bordercolor="Window" backcolor="#E0EDE8" cssclass="bodycopy"></style>
                </GroupByBox>
                <FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray" CssClass="bodycopy">
                    <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
                    </BorderDetails>
                </FooterStyleDefault>
                <RowStyleDefault Font-Names="Verdana,Arial,Helvetica,Sans-serif" Font-Size="9px"
                    BorderWidth="1px" BorderColor="#bcbcbc" BorderStyle="Solid" BackColor="Window"
                    TextOverflow="Ellipsis">
                    <BorderDetails ColorTop="Window" ColorLeft="Window"></BorderDetails>
                    <Padding Left="3px"></Padding>
                </RowStyleDefault>
                <FilterOptionsDefault EmptyString="(Empty)" AllString="(All)" NonEmptyString="(NonEmpty)">
                    <FilterDropDownStyle BorderWidth="1px" BorderColor="Silver" BorderStyle="Solid" BackColor="White"
                        Width="200px">
                    </FilterDropDownStyle>
                    <FilterHighlightRowStyle ForeColor="White" BackColor="#151C55">
                    </FilterHighlightRowStyle>
                </FilterOptionsDefault>
                <HeaderStyleDefault HorizontalAlign="Left" BorderStyle="Solid" BackColor="#BFD0C9"
                    ForeColor="Black" Height="19px" Cursor="Hand">
                </HeaderStyleDefault>
                <EditCellStyleDefault BorderWidth="0px" BorderStyle="None">
                </EditCellStyleDefault>
                <Pager AllowPaging="True" StyleMode="PrevNext" QuickPages="3" PageSize="50" Alignment="Center">
                    <style borderwidth="3px" borderstyle="Solid" backcolor="#E0EDE8" bordercolor="#E0EDE8"
                        cssclass="bodycopy" />
                </Pager>
            </DisplayLayout>
        </igtbl:UltraWebGrid>
                </td>
            </tr>
        </table>
       
    </center>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" OnInit="SqlDataSource1_Init">
    </asp:SqlDataSource>
    <cc1:UltraWebGridExcelExporter ID="UltraWebGridExcelExporter1" runat="server">
    </cc1:UltraWebGridExcelExporter>
    <br />
    <br />
    <br />
    </form>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
