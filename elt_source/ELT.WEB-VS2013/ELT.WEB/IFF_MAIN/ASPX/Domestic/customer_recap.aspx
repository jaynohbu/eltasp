<%@ Page Language="C#" AutoEventWireup="true" CodeFile="customer_recap.aspx.cs" Inherits="ASPX_Domestic_customer_recap" %>
<%@ Register Assembly="iMoon.WebControls.ComboBox" Namespace="iMoon.WebControls"
    TagPrefix="iMoon" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="uc1" TagName="rdSelectDateControl1" Src="../SelectionControls/rdSelectDateControl1.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <style type="text/css">
	    body {
		    margin-left: 0px;
		    margin-top: 0px;
		    margin-right: 0px;
		    margin-bottom: 0px;
	    }
	    .style15 {
		    color: #C6603E
	    }
	    
	    .FromCalendar{
            position:absolute; 
            top:0px; 
            left:20px; 
            background-color:#ffffff;
            z-index:2;
        }
        
        .ToCalendar{
            position:absolute; 
            top:0px; 
            left:20px;
            background-color:#ffffff;
            z-index:2;
        }
        .gridViewTable {
	        table-layout:fixed;
	        border-collapse: collapse;
	     }
	     
        .gridViewTable td {
	        padding: 1px 1px 1px 1px;
	         table-layout:fixed;

	        overflow:hidden;
	        white-space:nowrap;
         } 

    </style>

    <script type="text/javascript" src="/ASP/include/simpletab.js"></script>
	<SCRIPT src="/IFF_MAIN/ASPX/jScripts/WebDateSet1.js" type=text/javascript></SCRIPT>
	<SCRIPT src="/IFF_MAIN/ASPX/jScripts/ig_dropCalendar.js" type=text/javascript></SCRIPT>
    <SCRIPT src="/IFF_MAIN/ASPX/jScripts/ig_editDrop1.js" type=text/javascript></SCRIPT>
    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="/ASP/include/JPED.js"></script>

    <link href="/IFF_MAIN/ASPX/CSS/elt_css.css" rel="stylesheet" type="text/css">

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
         function showHAWB(arg)
        {
            url ="/ASP/domestic/new_edit_hawb.asp?WindowName=popUpWindow&mode=search&HAWB=" + arg + "&WindowName=popUpWindow";
            window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=0,width=900,height=600');
        }
        
        function sendmail()
        {
               var reload =document.getElementById("reload").value;
               var orgNum = document.getElementById("hCustomerAcct").value;
               if ( reload == "Y")
               {
                   if( orgNum != "" && orgNum != "0")
                   {
                        var url = "./Domestic_Email.aspx?Org_num=" + orgNum + "&type=CD";
                        window.open(url,'popUpWindow','width=1000,height=500,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=no');
                  }
                  document.getElementById("reload").value ="N";
               }
        }
       function EditClickName(org_No)		
	    {
	        var url;
            url ="/ASP/master_data/client_profile.asp?Action=filter&n="+ org_No + "&WindowName=popUpWindow";
           window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
		}
        function EditClickMAWB(MAWB)
        {
            var url;
           url ="/ASP/Domestic/new_edit_mawb.asp?Edit=yes&mawb=" + MAWB + "&WindowName=popUpWindow";
           window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=0,width=900,height=600');
        }
    </script>

    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css">
</head>
<body link="336699" vlink="336699" topmargin="0" onLoad="self.focus(); sendmail();">
    <form runat="server" id="form1" >
        <input type="image" style="width:0px; height:0px" onclick="return false;" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" height="32" align="left" valign="middle" class="pageheader">
                    Customer Daily Recap
                </td>
                <td width="50%" align="right" valign="bottom">
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
                            <td colspan="9" bgcolor="#997132" style="height: 1px">
                            </td>
                        </tr>
                        <tr align="center">
                            
                            <td valign="top" bgcolor="#f3f3f3" class="bodycopy" style="padding: 34px 34px 24px">
                            
                                <table width="54%" border="0" cellpadding="0" cellspacing="0" bordercolor="#997132"
                                    bgcolor="#FFFFFF" class="border1px" style="padding-left: 10px">

                                    <tr class="bodyheader">
                                    
                                    
                                        <td width="8%" align="left" bgcolor="#f3d9a8" style="height: 18px">
                                            <span class="style15">Type of Shipment</span>
                                        </td>
                                      <td width="6%" align="left" bgcolor="#f3d9a8" style="height: 18px">
                                           Period</td>
                                        

                                        
                                        <td width="12%" align="left"  bgcolor="#f3d9a8" style="height: 18px"  >
                                        <table>
                                        <tr class="bodyheader">
                                         <td width="9%"align="left" valign="middle" bgcolor="#f3d9a8" style="height: 18px"">
                                            From</td>
                                        <td width="11%" align="left" valign="middle" bgcolor="#f3d9a8" style="height: 18px"">
                                            To</td>
                                            </tr>
                                        
                                        </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top" style="height: 30px">
                                            <asp:DropDownList CssClass="bodycopy" Width="130px" runat="server" ID="lstShipmentType">
                                                <asp:ListItem Text="Inbound & Outbound"></asp:ListItem>
                                                <asp:ListItem Text="Inbound"></asp:ListItem>
                                                <asp:ListItem Text="Outbound"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td align="left" valign="top" ><uc1:rdselectdatecontrol1 id=RdSelectDateControl11 runat="server"></uc1:rdselectdatecontrol1></td>
                                        <td align="left">
                                        <table>
                                        <tr class="bodyheader">
                                        <td align="left" valign="top" style="width: 100px; height: 30px;">
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td style="height: 18px">
                                                        <igtxt:webdatetimeedit id=Webdatetimeedit1 accessKey=e runat="server" ForeColor="Black" Width="120px"
											                Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" " Height="17px">
											                <ButtonsAppearance CustomButtonDisplay="OnRight"></ButtonsAppearance>
											                <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
										                </igtxt:webdatetimeedit>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td align="left" valign="top" style="height: 30px">
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <igtxt:webdatetimeedit id=Webdatetimeedit2 accessKey=e runat="server" ForeColor="Black" Width="120px" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" " Height="17px">
                                                            <ButtonsAppearance CustomButtonDisplay="OnRight">                                        </ButtonsAppearance>
                                                            <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                                        </igtxt:WebDateTimeEdit>
                                                    </td>
                                                </tr>
                                            </table>
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
                                        <td height="18" colspan="2" align="left" bgcolor="#f3f3f3">
                                            <span class="style15">Customer/Agent</span>
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3" style="padding-left: 10px; width: 137px;">
                                            Sort by</td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td height="20" colspan="2" align="left" bgcolor="#FFFFFF">
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
                                                            onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstCustomerName','Customer','lstCustomerNameChange')"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                <!--    <td>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hCustomerAcct','lstCustomerName','txtCustomerInfo')" /></td>-->
                                                </tr>
                                            </table>
                                            <!-- End JPED -->
                                        </td>
                                        <td align="left" valign="top" bgcolor="#FFFFFF" style="width: 137px">
                                            <asp:DropDownList runat="server" ID="lstSortBy" CssClass="bodycopy" Width="120px">
                                                <asp:ListItem Text="Customer" Value="Customer" Selected="true" />
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader">
                                            Carrier</td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader">
                                            &nbsp;</td>
                                        <td align="left" bgcolor="#f3f3f3" style="width: 137px">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="left">
                                            <asp:HiddenField runat="Server" ID="hCarrierAcct" Value="" />
                                            <div id="lstCarrierDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td style="height: 18px">
                                                        <asp:TextBox runat="server" autocomplete="off" ID="lstCarrier" name="lstCarrier"
                                                            CssClass="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                            border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                            color: #000000" onKeyUp="organizationFill(this,'Carrier','lstCarrierChange')"
                                                            onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td style="height: 18px">
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstCarrier','Carrier','lstCarrierChange')"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td style="height: 18px">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td align="left" style="width: 137px">
                                            &nbsp;</td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td height="18" align="left" bgcolor="#f3f3f3">
                                            Origin Port</td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader">
                                            &nbsp;</td>
                                        <td align="left" bgcolor="#f3f3f3" style="width: 137px">
                                            Destination Port</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="left">
                                            <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="OriginPortSelect">
                                                <asp:ListItem Text="Select One" Value="" />
                                            </asp:DropDownList>
                                        </td>
                                        <td align="left" style="width: 137px">
                                            <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="DestPortSelect">
                                                <asp:ListItem Text="Select One" Value="" />
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#f3f3f3" style="height: 24px">
                                        </td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="height: 24px">
                                            &nbsp;&nbsp;</td>
                                        <td align="right" valign="middle" bgcolor="#f3f3f3" style="padding-right: 30px; width: 137px; height: 24px;">
                                            <asp:ImageButton runat="server" ImageUrl="../../Images/button_go.gif" ID="btnGo"
                                                OnClick="btnGo_Click" />
                                            
                                        </td>
                                    </tr>
        
                                </table>
                            </td>
                            
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="background-color:#f3f3f3"><td>
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
                                                <td colspan="20" style="padding-left: 10px" bgcolor="#f3d9a8" height="24">
                                                    <span class="style15">OUTBOUND</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="1" colspan="12" bgcolor="#997132">
                                                </td>
                                            </tr>
                                            <tr bgcolor="#f3f3f3" class="bodyheader">
                                                <td height="20" style="padding-left: 10px" width="8%">
                                                    House Airbill No.</td>
                                                <td width="9%">
                                                    Shipper</td>
                                                <td width="7%">
                                                    City</td>
                                                <td width="7%">
                                                    Destination</td>
                                                <td width="9%">
                                                    Carrier</td>
                                                <td width="6%">
                                                    Master AWB</td>
                                                <td width="6%" align="right">
                                                    PCS</td>
                                                <td width="7%" align="right" style="padding-right: 28PX">
                                                    WGT</td>
                                                <td width="7%" align="right" style="padding-right: 28PX">
                                                    Charges</td>
                                                <td width="8%">
                                                    Driver</td>    
                                                <td width="10%">
                                                    Delivery Instructions</td>
                                            </tr>
                                        </table>
                                        </td></tr></table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <div class="bodyheader" style="padding-left: 10px; padding-top: 6px; background: #ffffff">
                                            <%# Eval("sort_value") %>
                                        </div>
                                        <div>
                                            <asp:GridView ID="GridViewOutDetail" runat="server" AllowPaging="False" AutoGenerateColumns="False" OnPageIndexChanging="GridViewOutDetail_PageIndexChanging"
                                                Width="100%" BorderWidth="0px" BorderStyle="None" CellPadding="0">
                                                <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                                                <RowStyle BackColor="White" BorderStyle="None" />
                                                <AlternatingRowStyle BackColor="#F3F3F3" />
                                                <Columns>
                                                    <asp:TemplateField>
                                                        <HeaderTemplate>
                                                            <!-- list header -->
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <!-- list item -->
                                                            <table cellpadding="0" cellspacing="0" border="0" style="width: 100%" class="gridViewTable">
                                                                <tr>
                                                                    <td height="20" style="padding-left: 10px" width="8%" class="searchList">
                                                                        <a onclick="showHAWB('<%# Eval("hawb_num") %>')" href="javascript:;">
                                                                            <%# Eval("hawb_num") %>
                                                                        </a>
                                                                    </td>
                                                                    <td width="9%">
                                                                    <a onclick="EditClickName('<%# Eval("shipper_account_number") %>')" href="javascript:;">
                                                                        <%# Eval("Shipper_Name") %>
                                                                        </a>
                                                                    </td>
                                                                    <td width="7%">
                                                                        <%# Eval("B_city") %> - <%# Eval("B_state") %>
                                                                    </td>
                                                                    <td width="7%">
                                                                        <%# Eval("Dest_Port_Location") %>
                                                                    </td>
                                                                    <td width="9%">
                                                                        <a onclick="EditClickName('<%# Eval("Carrier_acct") %>')" href="javascript:;">
                                                                            <%# Eval("Carrier_Desc") %>
                                                                         </a>
                                                                    </td>
                                                                    <td width="6%">
                                                                        <a onclick="EditClickMAWB('<%# Eval("mawb_num") %>')" href="javascript:;">
                                                                        <%# Eval("mawb_num")%>
                                                                        </a>
                                                                    </td>
                                                                    <td width="6%" align="right">
                                                                        <%# Eval("Total_Pieces") %>
                                                                    </td>
                                                                    <td width="7%" align="right" style="padding-right: 28PX">
                                                                        <%#  System.Convert.ToInt32(Eval("Adjusted_Weight"))%>
                                                                    </td>
                                                                    <td width="7%" align="right" style="padding-right: 28PX">
                                                                        <%# Eval("WillCharge")%>
                                                                    </td>
                                                                    <td width="8%">
                                                                        <%# Eval("drive_name") %>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <%# Eval("Handling_Info") %>
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
                        </asp:GridView>
                    </div>
                    <div>
                        <asp:GridView ID="GridViewInSort" runat="server" AllowPaging="False" AutoGenerateColumns="False"
                            OnPageIndexChanging="GridViewInSort_PageIndexChanging" Width="100%" BorderWidth="0px"
                            BorderStyle="None" CellPadding="0">
                            <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%"><tr><td>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td height="1" colspan="13" bgcolor="#997132">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="20" style="padding-left: 10px" bgcolor="#f3d9a8" height="24">
                                                    <span class="style15">INBOUND</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="1" colspan="13" bgcolor="#997132">
                                                </td>
                                            </tr>
                                            <tr bgcolor="#f3f3f3" class="bodyheader">
                                                <td height="20" style="padding-left: 10px" width="7%">
                                                    House Airbill No.</td>
                                                <td width="7%">
                                                    Consignee</td>
                                                <td width="7%">
                                                    City</td>
                                                <td width="9%">
                                                    Signature</td>
                                                <td width="4%">
                                                    Time</td>
                                                <td align="right" width="6%">
                                                    PCS</td>
                                                <td align="right" style="padding-right: 28PX" width="7%">
                                                    WGT</td>
                                                <td width="7%">
                                                    Origin</td>
                                                <td width="9%">
                                                    Carrier</td>
                                                <td width="6%">
                                                    MAWB</td>
                                                <td align="right" style="padding-right: 28PX" width="7%">
                                                    Charges</td>
                                                <td width="9%">
                                                    Driver
                                                </td>
                                                <td width="11%">
                                                    Delivery Instructions
                                                </td>
                                            </tr>
                                            <tr>
                                        </table>
                                        </td></tr></table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <div class="bodyheader" style="padding-left: 10px; padding-top: 6px; background: #ffffff">
                                            <%# Eval("sort_value") %>
                                        </div>
                                        <div>
                                            <asp:GridView ID="GridViewInDetail" runat="server" AllowPaging="False" AutoGenerateColumns="False" OnPageIndexChanging="GridViewInDetail_PageIndexChanging"
                                                Width="100%" BorderWidth="0px" BorderStyle="None" CellPadding="0">
                                                <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                                                <RowStyle BackColor="White" BorderStyle="None" />
                                                <AlternatingRowStyle BackColor="#F3F3F3" />
                                                <Columns>
                                                    <asp:TemplateField>
                                                        <HeaderTemplate>
                                                            <!-- list header -->
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <!-- list item -->
                                                            <table cellpadding="0" cellspacing="0" border="0" style="width: 100%" class="gridViewTable">
                                                                <tr>
                                                                    <td height="20" style="padding-left: 10px" width="7%" class="searchList">
                                                                        <a onclick="showHAWB('<%# Eval("hawb_num") %>')" href="javascript:;">
                                                                            <%# Eval("hawb_num") %>
                                                                        </a>
                                                                    </td>
                                                                    <td width="7%">
                                                                        <a onclick="EditClickName('<%# Eval("Consignee_acct_num") %>')" href="javascript:;">
                                                                        <%# Eval("Consignee_Name") %>
                                                                        </a>
                                                                    </td>
                                                                    <td width="7%">
                                                                        <%# Eval("B_city") %> - <%# Eval("B_state") %>
                                                                    </td>
                                                                    <td width="9%">
                                                                        <%# Eval("POD_signer")%>
                                                                    </td>
                                                                    <td width="4%">
                                                                        <%# Eval("POD_time")%>
                                                                    </td>
                                                                    <td align="right" width="6%">
                                                                        <%# Eval("Total_Pieces") %>
                                                                    </td>
                                                                    <td align="right" style="padding-right: 28PX" width="7%">
                                                                        <%# System.Convert.ToInt32( Eval("Adjusted_Weight")) %>
                                                                    </td>
                                                                    <td width="7%">
                                                                        <%# Eval("Origin_Port_Location")%>
                                                                    </td>
                                                                    <td width="9%">
                                                                        <a onclick="EditClickName('<%# Eval("Carrier_acct") %>')" href="javascript:;">
                                                                            <%# Eval("Carrier_Desc") %>
                                                                            </a>
                                                                    </td>
                                                                    <td width="6%">
                                                                        <a onclick="EditClickMAWB('<%# Eval("mawb_num") %>')" href="javascript:;">
                                                                            <%# Eval("mawb_num")%>
                                                                        </a>
                                                                    </td>
                                                                    <td align="right" style="padding-right: 28PX" width="7%">
                                                                        <%# Eval("WillCharge")%>
                                                                    </td>
                                                                    <td width="9%">
                                                                        <%# Eval("drive_name")%>
                                                                    </td>
                                                                    <td width="11%">
                                                                        <%# Eval("Handling_Info") %>
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
                        </asp:GridView>
                    </div>
                </td>
            </tr>
            <tr>
                <td height="1">
                </td>
            </tr>
            <tr>
                <td height="20" align="center" bgcolor="#eec983">
                    &nbsp;
                </td>
            </tr>
        </table>
        <asp:Label ID="sqlOutput" runat="server"></asp:Label>
        <asp:HiddenField ID="reload" runat=server Value="N" />
        <br />
        <br />
					<P><asp:button id=btnValidate runat="server" Text="for Validation" Visible="False"></asp:button><asp:linkbutton id=LinkButton3 runat="server" Visible="False">LinkButton</asp:linkbutton><asp:textbox id=txtNum runat="server" Height="1px" Width="1px"></asp:textbox><!-- end --></P>
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
        </igsch:WebCalendar>
    </form>
    		<SCRIPT type=text/javascript>
            if(document.getElementById('Webdatetimeedit2')) {
    			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1 Webdatetimeedit2");
            }
            else
            {
    			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1");            
            }

		</SCRIPT>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
