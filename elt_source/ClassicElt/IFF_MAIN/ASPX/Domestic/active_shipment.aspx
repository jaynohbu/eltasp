<%@ Page Language="C#" AutoEventWireup="true" CodeFile="active_shipment.aspx.cs"
    Inherits="ASPX_Domestic_active_shipment" %>
    <%@ Register Assembly="iMoon.WebControls.ComboBox" Namespace="iMoon.WebControls"
    TagPrefix="iMoon" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <style type="text/css">
    <!--
	    body {
		    margin-left: 0px;
		    margin-top: 0px;
		    margin-right: 0px;
		    margin-bottom: 0px;
	    }
	    .style15 {
		    color: #C6603E
	    }
	    
	    .AsOfCalendar{
            position:absolute; 
            top:0px; 
            left:20px; 
            background-color:#ffffff;
            z-index:2;
        }
    -->
    </style>

    <script type="text/javascript" src="../../ASP/include/simpletab.js"></script>
    
    <SCRIPT src="../jScripts/WebDateSet1.js" type=text/javascript></SCRIPT>
    
    <SCRIPT src="../jScripts/ig_dropCalendar.js" type=text/javascript></SCRIPT>
    
    <SCRIPT src="../jScripts/ig_editDrop1.js" type=text/javascript></SCRIPT>
    
    <script type="text/javascript" language="javascript" src="../../ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../../ASP/include/JPED.js"></script>

    <link href="../css/elt_css.css" rel="stylesheet" type="text/css">

    <script type="text/javascript">
    
        function lstCustomerNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hCustomerAcct");
            var txtObj = document.getElementById("lstCustomerName");
            var divObj = document.getElementById("lstCustomerNameDiv")
    
            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
        
        function lstCarrierChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hCarrierAcct");
            var txtObj = document.getElementById("lstCarrier");
            var divObj = document.getElementById("lstCarrierDiv");
                    
            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
		    divObj.innerHTML = "";
        }
        
        function sendmail()
        {
               var reload =document.getElementById("reload").value;
               var orgNum = document.getElementById("hCustomerAcct").value;
               if ( reload == "Y")
               {
               
                   if( orgNum != "" && orgNum != "0")
                   {
                        var url = "./Domestic_Email.aspx?Org_num=" + orgNum + "&type=AS";
                        window.open(url,'popUpWindow','width=1000,height=500,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=no');
                  }
                  document.getElementById("reload").value ="N";
              }
        }
        
        function showHAWB(arg)
        {
            var url;
            url = "/IFF_MAIN/ASP/domestic/new_edit_hawb.asp?WindowName=popUpWindow&mode=search&HAWB=" + arg
            window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
        }
        function EditClickName(org_No)		
	    {
	        var url;
            url ="/IFF_MAIN/ASP/master_data/client_profile.asp?Action=filter&n="+ org_No + "&WindowName=popUpWindow";
           window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
		}
        function EditClickMAWB(MAWB)
        {
                   url ="/IFF_MAIN/ASP/Domestic/new_edit_mawb.asp?Edit=yes&mawb=" + MAWB + "&WindowName=popUpWindow";
                   window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=0,width=900,height=600');
        }
        
    </script>
    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css">
</head>
<body link="336699" vlink="336699" topmargin="0" onLoad="self.focus(); sendmail();">

    <form runat="server" id="form1">
<input type="image" style="width:0px; height:0px" onclick="return false;" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" height="32" align="left" valign="middle" class="pageheader">
                    Active shipments
                </td>
                 <td width="50%" align="right" valign="bottom">
                    <!--<asp:image runat="server" ID="backimg" src="" onclick="sendmail()" style=" cursor: hand;"/>-->
                    <asp:ImageButton ID="imagb" runat="server" ImageUrl="../../Images/button_send_email.gif" OnClick="SENDMAIL" CssClass="marginleft"></asp:ImageButton>
                </td>
            </tr>
        </table>
        <div class="selectarea">
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132"
            bgcolor="#997132" class="border1px">
            <tr>
                <td>
                    <!--// -->
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr bgcolor="#F2DEBF">
                            <td height="8" align="center" valign="middle" bgcolor="#eec983" class="bodyheader">
                            </td>
                        </tr>
                        <tr>
                            <td height="1" colspan="9" bgcolor="#997132">
                            </td>
                        </tr>
                        <tr align="center">
                            <td valign="top" bgcolor="#f3f3f3" class="bodycopy" style="padding: 34px 34px 24px">
                                <table border="0" cellpadding="0" cellspacing="0" bordercolor="#997132"
                                    bgcolor="#FFFFFF" class="border1px" style="padding-left: 10px; width: 43%;">
                                    <tr class="bodyheader">
                                        <td width="28%" height="18" align="left" valign="middle" bgcolor="#f3d9a8">
                                            <span class="style15">Type of Shipment </span>
                                        </td>
                                        <td width="22%" align="left" valign="middle" bgcolor="#f3d9a8">
                                            Date as of
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#f3d9a8" style="width: 145px">&nbsp;
                                            </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="middle">
                                            <asp:DropDownList CssClass="bodycopy" Width="130px" runat="server" ID="lstShipmentType">
                                                <asp:ListItem Text="Inbound & Outbound"></asp:ListItem>
                                                <asp:ListItem Text="Inbound"></asp:ListItem>
                                                <asp:ListItem Text="Outbound"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td height="20" colspan="2" align="left" valign="middle">
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                     <igtxt:webdatetimeedit id=Webdatetimeedit1 accessKey=e runat="server" ForeColor="Black" Width="120px"
											            Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" " Height="17px">
											            <ButtonsAppearance CustomButtonDisplay="OnRight"></ButtonsAppearance>
											            <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
										            </igtxt:webdatetimeedit>
                                                    </td>
                                                    
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="2" colspan="3" bgcolor="#997132">
                                        </td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td height="18" align="left" valign="middle" bgcolor="#f3f3f3">
                                            <span class="style15">Customer/Agent</span></td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3">&nbsp;
                                            </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3" style="width: 145px">
                                            Sort by</td>
                                    </tr>
                                    <tr class="bodycopy">
                                        <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF">
                                            <!-- Start JPED -->
                                            <asp:HiddenField runat="Server" ID="hCustomerAcct" Value="" />
                                            <div id="lstCustomerNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <asp:TextBox runat="server" autocomplete="off" ID="lstCustomerName" name="lstCustomerName"
                                                            value="" class="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                            border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                            color: #000000" onKeyUp="organizationFill(this,'Customer','lstCustomerNameChange')"
                                                            onfocus="initializeJPEDField(this);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstCustomerName','Customer','lstCustomerNameChange')"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                   <!--  <td>
                                                       <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hCustomerAcct','lstCustomerName','txtCustomerInfo')" /></td>-->
                                                </tr>
                                            </table>
                                            <!-- End JPED -->
                                        </td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF" style="width: 145px">
                                            <asp:DropDownList runat="server" ID="lstSortBy" CssClass="bodycopy" Width="120px">
                                                <asp:ListItem Text="Customer" Value="Customer" Selected="True" />
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader">
                                            Carrier</td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader">&nbsp;
                                            </td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 145px">&nbsp;
                                            </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="left" class="bodycopy">
                                            <asp:HiddenField runat="Server" ID="hCarrierAcct" Value="" />
                                            <div id="lstCarrierDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <asp:TextBox runat="server" autocomplete="off" ID="lstCarrier" name="lstCarrier"
                                                            CssClass="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                            border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                            color: #000000" onKeyUp="organizationFill(this,'Carrier','lstCarrierChange')"
                                                            onfocus="initializeJPEDField(this);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstCarrier','Carrier','lstCarrierChange')"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td align="left" class="bodyheader" style="width: 145px">&nbsp;
                                            </td>
                                    </tr>
                                    <tr>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="height: 18px">
                                            Origin Port</td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader" style="height: 18px">&nbsp;
                                            </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader" style="width: 100px; height: 18px;">
                                            Destination Port</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="left" class="bodyheader" style="height: 18px">
                                            <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="OriginPortSelect">
                                                <asp:ListItem Text="Select One" Value="" />
                                            </asp:DropDownList>
                                        </td>
                                        <td align="left" valign="middle" class="bodyheader" style="width: 145px; height: 18px">
                                            <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="DestPortSelect">
                                                <asp:ListItem Text="Select One" Value="" />
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader">&nbsp;
                                            </td>
                                        <td align="center" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;
                                            </td>
                                        <td height="24" align="right" valign="middle" bgcolor="#f3f3f3" class="bodyheader"
                                            style="padding-right: 30px; width: 145px;">
                                            &nbsp; &nbsp;
                                            <asp:ImageButton runat="server" ImageUrl="../../Images/button_go.gif" ID="btnGo"
                                                OnClick="btnGo_Click" /></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr style="background-color:#f3f3f3; padding-left:10px"><td>
            <asp:ImageButton ID="ExcelPrintButton" runat="server" ImageUrl="../../Images/button_exel.gif"
                                    OnClick="ExcelPrintButton_Click"></asp:ImageButton>
            <asp:ImageButton ID="PDFPrintButton" runat="server" ImageUrl="../../Images/button_pdf.gif"
                                    OnClick="PDFPrintButton_Click" CssClass="marginleft"></asp:ImageButton>
            </td></tr>
            <tr>
                <td align="left" bgcolor="#f3f3f3">
                    <div style="width: 100%">
                        <asp:GridView ID="GridViewOutSort" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                            OnPageIndexChanging="GridViewOutSort_PageIndexChanging" Width="100%" BorderWidth="0px"
                            BorderStyle="None" CellPadding="0">
                            <PagerSettings Position="Top" />
                            <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                                BackColor="White" ForeColor="Black" />
                            <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                            <RowStyle BackColor="White" BorderStyle="None" />
                            <AlternatingRowStyle BorderStyle="None" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%"><tr><td>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td height="1" colspan="12" bgcolor="#997132">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="12" style="padding-left: 10px" bgcolor="#f3d9a8" height="24">
                                                    <span class="style15">OUTBOUND</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="1" colspan="12" bgcolor="#997132">
                                                </td>
                                            </tr>
                                            <tr class="bodyheader" bgcolor="#f3f3f3" align="left">
                                                <td height="20" width="10%" style="padding-left: 10px">House Airbill No.</td>
                                                <td width="10%">Shipper</td>
                                                <td width="8%">City</td>
                                                <td width="9%">Ready/Close</td>
                                                <td width="9%">Destination</td>
                                                <td width="5%">PCS</td>
                                                <td width="5%">WGT</td>
                                                <td width="10%">Carrier</td>
                                                <td width="10%">MAWB</td>
                                                <td width="10%">Delivery Instructions</td>
                                                <td width="9%">Driver</td>
                                                <td width="5%">Status</td>
                                            </tr>
                                            <tr>
                                                <td height="1" colspan="12" bgcolor="#997132">
                                                </td>
                                            </tr>
                                        </table>
                                        </td></tr></table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <div class="bodyheader" style="padding-left: 10px; padding-top: 6px; background: #ffffff">
                                            <%# Eval("sort_value") %>
                                        </div>
                                        <div>
                                            <asp:GridView ID="GridViewOutDetail" runat="server" AllowPaging="True" AutoGenerateColumns="False" OnPageIndexChanging="GridViewOutDetail_PageIndexChanging"
                                                Width="100%" BorderWidth="0px" BorderStyle="None" CellPadding="0">
                                                <PagerSettings Position="Top" />
                                                <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                                                    BackColor="White" ForeColor="Black" />
                                                <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                                                <RowStyle BackColor="White" BorderStyle="None" />
                                                <AlternatingRowStyle BackColor="#ffffff" />
                                                <Columns>
                                                    <asp:TemplateField>
                                                        <HeaderTemplate>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                                <tr align="left">
                                                                    <td height="16" class="searchList" width="10%" style="padding-left:10px"><a onclick="showHAWB('<%# Eval("hawb_num") %>')" href="javascript:;"><%# Eval("hawb_num") %></a>
                                                                    </td>
                                                                    <td class="bodycopy" width="10%"><a onclick="EditClickName('<%# Eval("shipper_account_number") %>')" href="javascript:;"><%# Eval("Shipper_Name") %>
                                                                    </td>
                                                                    <td class="bodycopy" width="8%"><%# Eval("B_city") %> - <%# Eval("B_state") %>
                                                                    </td>
                                                                    <td class="bodycopy" width="9%"><%# GetReadyCloseTime(Eval("ready_time"),Eval("close_time"),Eval("pickup_time")) %>
                                                                    </td>
                                                                    <td class="bodycopy" width="9%"><%# Eval("Dest_Airport") %>
                                                                    </td>
                                                                    <td class="bodycopy" width="5%"><%# Eval("Total_pieces") %>
                                                                    </td>
                                                                    <td class="bodycopy" width="5%"><%# System.Convert.ToInt32(Eval("Adjusted_Weight"))%>
                                                                    </td>
                                                                    <td class="bodycopy" width="10%"><a onclick="EditClickName('<%# Eval("Carrier_acct") %>')" href="javascript:;"><%# Eval("Carrier_Desc") %></a>
                                                                    </td>
                                                                    <td class="bodycopy" width="10%"><a onclick="EditClickMAWB('<%# Eval("mawb_num") %>')" href="javascript:;"><%# Eval("mawb_num") %></a>
                                                                    </td>
                                                                    <td class="bodycopy" width="10%"><%# Eval("Handling_Info") %>
                                                                    </td>
                                                                    <td class="bodycopy" width="9%"><%# Eval("driver_name")%>
                                                                    </td>
                                                                    <td class="bodycopy" width="5%"><%# Eval("ship_time_status") %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataRowStyle BorderStyle="None" />
                            <EditRowStyle BorderStyle="None" />
                        </asp:GridView>
                    </div>
                    <div>
                        <asp:GridView ID="GridViewInSort" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                            OnPageIndexChanging="GridViewInSort_PageIndexChanging" Width="100%" BorderWidth="0px"
                            BorderStyle="None" CellPadding="0">
                            <PagerSettings Position="Top" />
                            <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                                BackColor="White" ForeColor="Black" />
                            <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                            <RowStyle BackColor="White" BorderStyle="None" />
                            <AlternatingRowStyle BorderStyle="None" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%"><tr><td>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td height="1" colspan="12" bgcolor="#997132">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="12" style="padding-left: 10px" bgcolor="#f3d9a8" height="24">
                                                    <span class="style15">INBOUND</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="1" colspan="12" bgcolor="#997132">
                                                </td>
                                            </tr>
                                            <tr bgcolor="#f3f3f3" class="bodyheader" align="left">
                                                <td height="20" width="10%" style="padding-left:10px">
                                                    House Airbill No.</td>
                                                <td width="10%">
                                                    Origin</td>
                                                <td width="6%">
                                                    ETA</td>
                                                <td width="10%">
                                                    Carrier</td>
                                                <td width="10%">
                                                    MAWB</td>
                                                <td width="5%">
                                                    PCS</td>
                                                <td width="5%">
                                                    WGT</td>
                                                <td width="10%">
                                                    Consignee</td>
                                                <td width="9%">
                                                    City</td>
                                                <td width="10%">
                                                    Delivery Instructions</td>
                                                <td width="9%">
                                                    Driver</td>
                                                <td width="6%">
                                                    Status</td>
                                            </tr>
                                            <tr>
                                                <td height="1" colspan="12" bgcolor="#997132">
                                                </td>
                                            </tr>
                                        </table>
                                        </td></tr></table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <div class="bodyheader" style="padding-left: 10px; padding-top: 6px; background: #ffffff">
                                            <%# Eval("sort_value")%>
                                        </div>
                                        <div>
                                            <asp:GridView ID="GridViewInDetail" runat="server" AllowPaging="True" AutoGenerateColumns="False" OnPageIndexChanging ="GridViewInDetail_PageIndexChanging"
                                                Width="100%" BorderWidth="0px" BorderStyle="None" CellPadding="0">
                                                <PagerSettings Position="Top" />
                                                <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                                                    BackColor="White" ForeColor="Black" />
                                                <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                                                <RowStyle BackColor="White" BorderStyle="None" />
                                                <AlternatingRowStyle BackColor="#ffffff" />
                                                <Columns>
                                                    <asp:TemplateField>
                                                        <HeaderTemplate>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                                <tr align="left">
                                                                    <td height="16" class="searchList" width="10%" style="padding-left:10px" >
                                                                        <a onclick="showHAWB('<%# Eval("hawb_num") %>')" href="javascript:;">
                                                                            <%# Eval("hawb_num") %>
                                                                        </a>
                                                                    </td>
                                                                    <td class="bodycopy" width="10%">
                                                                        <%# Eval("Departure_Airport")%>
                                                                    </td>
                                                                    <td class="bodycopy" width="6%">
                                                                        <%# GetShortDate(Eval("ETA_DATE1")) %>
                                                                    </td>
                                                                    <td class="bodycopy" width="10%">
                                                                        <a onclick="EditClickName('<%# Eval("Carrier_acct") %>')" href="javascript:;"><%# Eval("Carrier_Desc") %></a>
                                                                    </td>
                                                                    <td class="bodycopy" width="10%">
                                                                        <a onclick="EditClickMAWB('<%# Eval("mawb_num") %>')" href="javascript:;"><%# Eval("mawb_num") %></a>
                                                                    </td>
                                                                    <td class="bodycopy" width="5%">
                                                                        <%# Eval("Total_pieces")%>
                                                                    </td>
                                                                    <td class="bodycopy" width="5%">
                                                                        <%# System.Convert.ToInt32(Eval("Adjusted_Weight"))%>
                                                                    </td>
                                                                    <td class="bodycopy" width="10%">
                                                                        <a onclick="EditClickName('<%# Eval("Consignee_acct_num") %>')" href="javascript:;"><%# Eval("Consignee_Name") %></a>
                                                                    </td>
                                                                    <td class="bodycopy" width="9%">
                                                                        <%# Eval("B_city") %> - <%# Eval("B_state") %>
                                                                    </td>
                                                                    <td class="bodycopy" width="10%">
                                                                        <%# Eval("Handling_Info") %>
                                                                    </td>
                                                                    <td class="bodycopy" width="9%">
                                                                        <%# Eval("driver_name")%>
                                                                    </td>
                                                                    <td class="bodycopy" width="6%">
                                                                        <%# Eval("ship_time_status") %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EditRowStyle BorderStyle="None" />
                        </asp:GridView>
                    </div>
                </td>
            </tr>
            <tr>
                <td height="1">
                </td>
            </tr>
            <tr>
                <td height="20" align="center" bgcolor="#eec983">&nbsp;
                    
                </td>
            </tr>
        </table>
        <asp:Label ID="sqlOutput" runat="server"></asp:Label>
         <asp:HiddenField ID="reload" runat=server Value="N"  />
        <br />
        
    <P><asp:button id=btnValidate runat="server" Text="for Validation" Visible="False"></asp:button><asp:linkbutton id=LinkButton1 runat="server" Visible="False">LinkButton</asp:linkbutton><asp:textbox id=txtNum runat="server" Height="1px" Width="1px"></asp:textbox><!-- end --></P>
		<igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="180px" Height="126px">
            <Layout CellPadding="0" FooterFormat="" NextMonthText="&gt;&gt;" PrevMonthText="&lt;&lt;"
                ShowFooter="False" ShowMonthDropDown="False" ShowYearDropDown="False" TitleFormat="Month">
                <DayStyle BackColor="White" CssClass="CalDay" />
                <SelectedDayStyle BackColor="#C5D5FC" CssClass="CalSelectedDay" />
                <OtherMonthDayStyle ForeColor="Silver" />
                <NextPrevStyle CssClass="NextPrevStyle" />
                <CalendarStyle CssClass="CalStyle" Height="126px" Width="180px">
                </CalendarStyle>
                <TodayDayStyle CssClass="CalToday" />
                <DayHeaderStyle CssClass="CalDayHeader" Font-Bold="False">
                    <BorderDetails StyleBottom="None" />
                </DayHeaderStyle>
                <TitleStyle CssClass="TitleStyle" Font-Bold="True" />
            </Layout>
        </igsch:WebCalendar></form>
					<SCRIPT type=text/javascript>

    			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1");            
  

		</SCRIPT>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
