<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmailHistory.aspx.cs" CodePage="65001"
    Inherits="ASPX_Misc_EmailHistory" %>


<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Email History</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="/IFF_MAIN/ASPX/CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <script src="/IFF_MAIN/ASPX/jScripts/ig_editDrop1.js" type="text/jscript"></script>
    <script type="text/jscript">    
    function call_win(arg) {
        POP = window.open(arg, "mainFrame","menubar=1,toolbar=1,location=0,directory=0,status=1,scrollbars=1,resizable=1,width=900,height=600");
	    POP.focus(); 
	}
	
	function call_win_blank(arg) {
        POP = window.open(arg, "_blank","menubar=1,toolbar=1,location=0,directory=0,status=1,scrollbars=1,resizable=1,width=900,height=600");
	    POP.focus(); 
	}
	
    </script>

    <style type="text/css">
    .fromCalendar{
        position:absolute; 
        
        top:92px; 
        left:446px; 

        background-color:#ffffff;
        z-index:2;
    }
    .toCalendar{
        position:absolute; 
        
        top:115px; 
        left:446px; 

        background-color:#ffffff;
        z-index:2;
    }
    </style>
    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
     <script src="/Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery-ui-1.8.20.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery.plugin.period.js" type="text/javascript"></script>
     <link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css"
        rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        $(document).ready(function () {
            $("#Webdatetimeedit1").datepicker();
            $("#Webdatetimeedit2").datepicker();
           
        });
    </script>
</head>
<body>
    <div class="pageheader">
        Email History</div>
    <form id="form1" runat="server" class="bodycopy">
        <table cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td colspan="1" class="bodyheader">
                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                        <tr>
                            <td valign="top">
                                <table cellpadding="2" cellspacing="0" border="0" width="350px">
                                    <tr>
                                        <td colspan="5" style="background-color: #E0E0E0; height: 14px">
                                            &nbsp;Filter
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:DropDownList ID="DropDownList1" runat="server" CssClass="bodycopy">
                                                <asp:ListItem Text="All Email" Value=""></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td style="width: 10px">
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="DropDownList2" runat="server" CssClass="bodycopy">
                                                <asp:ListItem Text="Air & Ocean" Value=""></asp:ListItem>
                                                <asp:ListItem Text="Air" Value="A"></asp:ListItem>
                                                <asp:ListItem Text="Ocean" Value="O"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td style="width: 10px">
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="DropDownList3" runat="server" CssClass="bodycopy">
                                                <asp:ListItem Text="Import & Export" Value=""></asp:ListItem>
                                                <asp:ListItem Text="Import" Value="I"></asp:ListItem>
                                                <asp:ListItem Text="Export" Value="E"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </table>
                                <table cellpadding="2" cellspacing="0" border="0" width="350px">
                                    <tr>
                                        <td colspan="5" style="background-color: #E0E0E0; height: 14px">
                                            &nbsp;Search
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 96px">
                                            <asp:DropDownList runat="server" ID="DropDownList4" CssClass="bodycopy">
                                                <asp:ListItem Value="house" Text="House No."></asp:ListItem>
                                                <asp:ListItem Value="master" Text="Master No."></asp:ListItem>
                                                <asp:ListItem Value="invoice" Text="Invoice No."></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="TextBox3" runat="server" CssClass="m_shorttextfield" Height="13px"
                                                Width="140px"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" align="right">
                                <table cellpadding="2" cellspacing="0" border="0">
                                    <tr>
                                        <td colspan="5" style="background-color: #E0E0E0; height: 14px">
                                            Period&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            From:&nbsp;</td>
                                        <td valign="bottom">
                                            <asp:TextBox runat="server" ID="Webdatetimeedit1"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            To:&nbsp;</td>
                                        <td valign="bottom">
                                             <asp:TextBox runat="server" ID="Webdatetimeedit2"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <table cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td>
                                <a href="EmailHistory.aspx">
                                    <img src="../../images/button_clear.gif" border="0" /></a>
                            </td>
                            <td style="width: 20px">
                            </td>
                            <td valign="top">
                                <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="../../Images/button_go.gif"
                                    OnClick="ImageButton1_Click" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="3" height="4px">
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                        OnPageIndexChanging="GridView1_PageIndexChanging" OnRowCommand="GridView1_RowCommand">
                        <PagerSettings Position="Bottom" />
                        <PagerStyle Font-Size="9pt" Font-Bold="true" HorizontalAlign="Center" BorderStyle="None"
                            BackColor="DimGray" ForeColor="White" />
                        <HeaderStyle ForeColor="White" Height="20px" BackColor="DimGray" />
                        <RowStyle BackColor="#E0E0E0" />
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td align="left" width="10">
                                            </td>
                                            <td align="left" width="160">
                                                Recipient Company
                                            </td>
                                            <td align="left" width="100">
                                                Email Title
                                            </td>
                                            <td align="left" width="60">
                                                Shipment
                                            </td>
                                            <td align="left" width="60">
                                                Air/Ocean
                                            </td>
                                            <td align="left" width="80">
                                                Sent Date
                                            </td>
                                            <td align="left" width="30">
                                                PDF
                                            </td>
                                            <td align="left" width="40">
                                                Status
                                            </td>
                                            <td align="left" width="20">
                                            </td>
                                        </tr>
                                    </table>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr id='Row<%# Eval("auto_uid").ToString() %>'>
                                            <td width="10">
                                            </td>
                                            <td width="160">
                                                <%# ShortenText(Eval("to_org_name").ToString(),18)%>
                                            </td>
                                            <td width="100">
                                                <%# ShortenText(Eval("screen_name").ToString(),18) %>
                                            </td>
                                            <td align="left" width="60">
                                                <%# ImportExport(Eval("im_export").ToString()) %>
                                            </td>
                                            <td align="left" width="60">
                                                <%# AirOcean(Eval("air_ocean").ToString()) %>
                                            </td>
                                            <td align="left" width="80">
                                                <%# string.Format("{0:d}", Eval("sent_date")) %>
                                            </td>
                                            <td align="left" width="30">
                                                <%# PDFLocation(Eval("attached_pdf").ToString())%>
                                            </td>
                                            <td align="left" width="40">
                                                <%# SentStatus(Eval("sent_status").ToString()) %>
                                            </td>
                                            <td align="left" width="20">
                                                <asp:ImageButton runat="server" CommandName="Detail" CommandArgument='<%# Eval("auto_uid").ToString() + "-" + Eval("row_index").ToString() %>'
                                                    ImageUrl="../../images/file.gif" Height="14px" />
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </td>
                <td style="width: 10px;">
                </td>
                <td valign="top">
                    <asp:DetailsView runat="server" ID="DetailsView1" Height="50px" Width="125px" AutoGenerateRows="false"
                        BackColor="#EFEFEF">
                        <HeaderTemplate>
                            <table style="height: 20px; width: 100%; background: #eeffcc;">
                                <tr>
                                    <td>
                                        <strong>Additional Information</strong>
                                    </td>
                                </tr>
                            </table>
                        </HeaderTemplate>
                        <Fields>
                            <asp:TemplateField>
                                <HeaderStyle BorderWidth="0px" Width="0px" />
                                <ItemStyle BorderWidth="0px" Width="25px" />
                                <ItemTemplate>
                                    <table style="width: 270px;" cellpadding="2" cellspacing="0" border="0">
                                        <tr>
                                            <td width="70" valign="top">
                                                From:
                                            </td>
                                            <td width="200">
                                                <%# Eval("email_from").ToString() %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                To:
                                            </td>
                                            <td>
                                                <%# Eval("email_to").ToString() %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                cc:
                                            </td>
                                            <td>
                                                <%# Eval("email_cc").ToString() %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                Subject:
                                            </td>
                                            <td>
                                                <%# Eval("email_subject").ToString() %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                Content:
                                            </td>
                                            <td>
                                                <%# ShortenText(Eval("email_content").ToString(),200) %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                Status:
                                            </td>
                                            <td>
                                                <%# Eval("sent_status").ToString() %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                Date/Time:
                                            </td>
                                            <td>
                                                <%# Eval("sent_date").ToString() %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                House:
                                            </td>
                                            <td>
                                                <%# GetHouses(Eval("house_num").ToString(), Eval("air_ocean").ToString(), 
                                        Eval("im_export").ToString(), Eval("master_num").ToString()) %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                Master:
                                            </td>
                                            <td>
                                                <%# GetMaster(Eval("master_num").ToString(), 
                                        Eval("air_ocean").ToString(),Eval("im_export").ToString()) %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                Invoice:
                                            </td>
                                            <td>
                                                <%# GetInvoices(Eval("invoice_num").ToString()) %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                Online Alert:
                                            </td>
                                            <td>
                                                <%# Eval("online_alert").ToString() %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                Files:
                                            </td>
                                            <td>
                                                <%# GetAttachedFiles(Eval("attached_files").ToString(),Eval("to_org_id").ToString()) %>
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Fields>
                    </asp:DetailsView>
                </td>
            </tr>
        </table>
        <br />
        <br />
        <!--<asp:Button ID="btnValidate" runat="server" Text="for Validation" Visible="False"></asp:Button><asp:LinkButton
            ID="LinkButton3" runat="server" Visible="False">LinkButton</asp:LinkButton><asp:TextBox
                ID="txtNum" runat="server" Height="1px" Width="1px"></asp:TextBox>-->
        
    </form>

  

</body>
</html>
