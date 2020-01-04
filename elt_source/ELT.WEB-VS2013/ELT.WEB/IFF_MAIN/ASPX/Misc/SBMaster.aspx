<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SBMaster.aspx.cs" Inherits="SiteAdmin_SBMaster" %>

<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Schedule B</title>
    <link href="/ASP/css/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
  // fix for deprecated method in Chrome 37
  if (!window.showModalDialog) {
     window.showModalDialog = function (arg1, arg2, arg3) {

        var w;
        var h;
        var resizable = "no";
        var scroll = "no";
        var status = "no";

        // get the modal specs
        var mdattrs = arg3.split(";");
        for (i = 0; i < mdattrs.length; i++) {
           var mdattr = mdattrs[i].split(":");

           var n = mdattr[0];
           var v = mdattr[1];
           if (n) { n = n.trim().toLowerCase(); }
           if (v) { v = v.trim().toLowerCase(); }

           if (n == "dialogheight") {
              h = v.replace("px", "");
           } else if (n == "dialogwidth") {
              w = v.replace("px", "");
           } else if (n == "resizable") {
              resizable = v;
           } else if (n == "scroll") {
              scroll = v;
           } else if (n == "status") {
              status = v;
           }
        }

        var left = window.screenX + (window.outerWidth / 2) - (w / 2);
        var top = window.screenY + (window.outerHeight / 2) - (h / 2);
        var targetWin = window.open(arg1, arg1, 'toolbar=no, location=no, directories=no, status=' + status + ', menubar=no, scrollbars=' + scroll + ', resizable=' + resizable + ', copyhistory=no, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        targetWin.focus();
     };
  }
</script>  
    <script type="text/jscript"> 
        function confirm_delete()
        {
            if(confirm("Click OK to delete the schedule B item"))
            {
                return true;
            }
            return false;
        }
        
        function go_scheduleB(vSBID)
        {
            var vURL = "./EditSB.aspx?SBID=" + vSBID;
            var vWinArg = "dialogWidth:460px; dialogHeight:315px; help:no; status:no; scroll:no; center:yes";

            var prevReturnValue = window.returnValue;
            var vReturn = showModalDialog(vURL, "popWindow", vWinArg);
            if (vReturn == undefined) // We don't know here if undefined is the real result...
            {
                // So we take no chance, in case this is the Google Chrome bug
                vReturn = window.returnValue;
            }
            window.returnValue = prevReturnValue;

            if(vReturn != null && vReturn != undefined){
                window.location.reload();
            }
        }
        
    </script>
    <!--  #INCLUDE FILE="../include/common.htm" -->
    
</head>
<body>
    <center>
        <table cellpadding="0" cellspacing="0" border="0" style="width: 95%">
            <tr>
                <td class="pageheader" style="text-align: left">
                    Schedule B
                </td>
                <td id="print" style="text-align: right">
                    <a href="javascript:;" onclick="javascript:go_scheduleB('')">
                        <img src="/ASP/images/icon_createhouse.gif" style="border: none 0px; margin-right: 10px"
                            alt="" />Add New Item</a><img src="/ASP/images/button_devider.gif" alt="" /><a href="http://www.census.gov/foreign-trade/schedules/b/"
                                target="_blank">Schedule B Codes</a>
                </td>
            </tr>
        </table>
        <form id="form1" runat="server">
            <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Height="400px" Width="95%"
                OnInitializeLayout="UltraWebGrid1_InitializeLayout" DataSourceID="SqlDataSource1"
                OnInitializeRow="UltraWebGrid1_InitializeRow">
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
                            </igtbl:TemplatedColumn>
                            <igtbl:TemplatedColumn Width="53" AllowGroupBy="No" SortIndicator="Disabled">
                                <HeaderStyle Cursor="Auto" />
                                <CellTemplate>
                                    <asp:ImageButton ID="btnDelete" ImageUrl="/ASP/images/button_delete.gif" runat="server"
                                        OnClientClick="return confirm_delete();" OnClick="btnDelete_Click" CommandName="Delete"
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
                    Version="4.00" TableLayout="Fixed" AllowColSizingDefault="Free">
                    <FrameStyle BorderWidth="1px" BorderStyle="Solid" Width="95%" BorderColor="#73beb6">
                    </FrameStyle>
                    <GroupByBox>
                        <Style BorderColor="Window" BackColor="#ecf7f8" CssClass="bodycopy"></Style>
                    </GroupByBox>
                    <FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray" CssClass="bodycopy">
                        <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
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
                    <HeaderStyleDefault HorizontalAlign="Left" BorderStyle="Solid" BackColor="#ccebed"
                        ForeColor="Black" Height="19px" Cursor="Hand">
                    </HeaderStyleDefault>
                    <Pager AllowPaging="True" StyleMode="PrevNext" QuickPages="3" PageSize="50" Alignment="Center">
                        <Style BorderWidth="3px" BorderStyle="Solid" BackColor="#ecf7f8" BorderColor="#ecf7f8"
                            CssClass="bodycopy" />
                    </Pager>
                </DisplayLayout>
            </igtbl:UltraWebGrid>
            <br />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" OnInit="SqlDataSource1_Init"></asp:SqlDataSource>
        </form>
    </center>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
