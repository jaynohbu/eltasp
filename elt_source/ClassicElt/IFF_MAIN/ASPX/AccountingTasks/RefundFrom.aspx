<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RefundFrom.aspx.cs" Inherits="ASPX_AccountingTasks_RefundFrom" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="Controls/PayableQueueControl.ascx" TagName="PayableQueueControl" TagPrefix="uc1" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Refund From Vendor</title>
    <link href="../CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../jScripts/JPED_NET.js"></script>
    <script type="text/javascript" src="../jScripts/datetimepicker.js"></script>
    <script type="text/javascript" src="../jScripts/WindowsManip.js"></script>
    <script type="text/javascript" language="javascript" src="../../ASP/ajaxFunctions/ajax.js"></script>
    <script type="text/javascript" src="../jScripts/ig_dropCalendar.js"></script>
    <script type="text/javascript" language="javascript">

    function validatePage(){                        
    if(document.getElementById("lstVendorName").value=="")
    {
         alert("Vendor is required!");
         return false;
    }           

    var ids=document.getElementById("PayableQueueControl1_hddlIDs").value;         
    var arrAmt=document.getElementById("PayableQueueControl1_hAmtIDs").value;         
    arrAmt=arrAmt.split("^^");
    ids=ids.split("^^");        
    for(i=0;i<ids.length-1;i++)
    {
        Amt=parseFloat(document.getElementById(arrAmt[i]).value);
        if (Amt!=0)
        {              
            if(document.getElementById(ids[i]).selectedIndex==0)
            {
                alert("Please select an item!");
                document.getElementById(ids[i]).focus();
                return false;
            }
         }
    }
    return true;
    }       

    function lstVendorNameChange(orgNum,orgName)
    {            
        var txtObj = document.getElementById("lstVendorName");
        var divObj = document.getElementById("lstVendorNameDiv") ;    

        txtObj.value = orgName;
        document.getElementById("hVendorAcct").value=orgNum;
        divObj.style.position = "absolute";
        divObj.style.visibility = "hidden"; 
        document.getElementById("hMainCommand").value="SEARCH";
        form1.method="POST";
        form1.submit();
    }

    function btnSearchClick()
    {
        var bill_number=0;

        try{
            bill_number=document.getElementById("txtSearch").value;
        }catch(e){
             bill_number=0;
        }
        if(bill_number!=0){
            document.getElementById("hBillNumber").value="";
            document.getElementById("hMainCommand").value="VIEW";
            form1.method="POST";
            form1.action="enter_bill.aspx";
            form1.submit();
        }else{
            alert("please enter a valid bill number!");
        }
    }

    function btnSaveClick(){
    

        if(document.getElementById("hVendorAcct").value=="")
        {
            alert("A vendor is required!"); return;
        }
        if(document.getElementById("lstVendorName")=="")
        {
            alert("A vendor is required!");return;
        }
        txtAmount=document.getElementById("txtAmount").value;
        //alert();
        if(parseFloat(txtAmount)=="0")
        {
            alert("No amount selected!");return;
        }
        if(document.getElementById("dDate").value=="")
        {
            alert("Invoice date is required");return;
        }

        document.getElementById("hMainCommand").value="SAVE";  
        form1.method="POST";           
        form1.submit();         

    }
    function clearSearch(obj){        
        obj.value = ''; 
        // obj.style.color='#000000';         
    }
    function resetSearch(obj){
        obj.value = 'Search Here'; 
          
    }
    </script>
  

    <link href="../../CSS/elt_css.css" rel="stylesheet" type="text/css" />
  
</head>
<body>
    <form id="form1" runat="server" target="_self">
    
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td width="30%" height="32" align="left" valign="middle" class="pageheader">
                Refund from Vendor&nbsp;</td>
			<td width="70%" align="right" valign="baseline"><span class="labelSearch"></span>&nbsp;<!-- Search -->
            </td>
		</tr>
	</table>
	<div class="selectarea" style=" width: 100%; margin-left: auto; margin-right:auto;">
		<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				<!-- use this when applicable-->
					<span class="select"><!--Select Booking No.--></span></td>
				<td width="55%" rowspan="2" align="right" valign="bottom">
					<div id="print">
						<a href="javascript:;" onClick="" style="cursor: pointer"></a>
					</div>
				</td>
			</tr>
			<tr>
				<!-- combo box here -->
				<td width="45%" valign="bottom"></td>
			</tr>
		</table>
	<asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
	</div>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89a979" class="border1px">
        <tr>
            <td height="24" align="center" valign="middle" bgcolor="#d5e8cb" style="border-bottom: 1px solid #89a979">
                                            <img src="../../ASP/Images/button_save_payment.gif" id="btnSaveUp" onclick="if(validatePage()){btnSaveClick()}" runat="server" />&nbsp;&nbsp;
                                            </td>
        </tr>
        <tr>
            <td align="center" bgcolor="#f3f3f3" style="border-bottom: 2px solid #89a979; padding:24px 0 24px 0">
                                <table border="0" cellpadding="0" cellspacing="0" height="28" width="60%">
                                    <tr>
                                        <td style="width: 519px">
                                            <span class="bodyheader"><strong><span style="font-size: 6pt">
                                                <asp:RadioButtonList ID="rdioDorC" runat="server" CssClass="bodyheader" RepeatDirection="Horizontal">
                                                    <asp:ListItem Selected="True" Value="D">Bill</asp:ListItem>
                                                    <asp:ListItem Value="C">CreditMemo</asp:ListItem>
                                                </asp:RadioButtonList></span></strong></span></td>
                                    </tr>
                                </table>
                                <table align="center" bgcolor="#d5e8cb" border="0" bordercolor="#89a979" cellpadding="2"
                                    cellspacing="0" class="border1px" style="font-size: 6pt" width="60%">
                                    <tr align="left" bgcolor="#e7f0e2" valign="middle">
                                        <td class="bodyheader" colspan="3">
                                            <strong><font color="#c16b42"><span style="color: #000000">Vendor</span></font></strong></td>
                                        <td style="color: #000000; width: 169px;">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr align="left" bgcolor="#e7f0e2" valign="middle">
                                        <td bgcolor="#ffffff" class="bodyheader" colspan="3" style="color: #c16b42">
                                            <!-- Start JPED -->
                                            <div id="lstVendorNameDiv">
                                            </div>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:TextBox ID="lstVendorName" runat="server" autocomplete="off" class="shorttextfield"
                                                            ForeColor="Black" name="lstVendorName" onfocus="initializeJPEDField(this);" onkeyup="organizationFill(this,'Vendor','lstVendorNameChange')"
                                                           Style="border-right: #7f9db9 0px solid;
                                                            border-top: #7f9db9 1px solid; border-left: #7f9db9 1px solid; width: 285px;
                                                            border-bottom: #7f9db9 1px solid; height: 12px" type="text" ></asp:TextBox></td>
                                                    <td>
                                                        <img id="IMG1" runat="server" alt="" onclick="organizationFillAll('lstVendorName','Vendor','lstVendorNameChange')"
                                                            src="/ig_common/Images/combobox_drop.gif" style="border-right: #7f9db9 1px solid;
                                                            border-top: #7f9db9 1px solid; border-left: #7f9db9 0px solid; cursor: hand;
                                                            border-bottom: #7f9db9 1px solid" /></td>
                                                    <td>
                                                        <img alt="" border="0" onclick="quickAddClient('hVendorAcct','lstVendorName','txtVendorInfo')"
                                                            src="/ig_common/Images/combobox_addnew.gif" style="cursor: hand" /></td>
                                                    <td>
                                                        <br />
                                                    </td>
                                                </tr>
                                            </table>
                                            <!-- End JPED -->
                                        </td>
                                        <td bgcolor="#ffffff" style="color: #c16b42; width: 169px;">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td bgcolor="#89a979" colspan="4" style="height: 1px">
                                        </td>
                                    </tr>
                                    <tr align="left" bgcolor="#ffffff" valign="middle">
                                        <td bgcolor="#f3f3f3" style="height: 24px" width="163">
                                            <strong class="bodyheader">Date</strong></td>
                                        <td bgcolor="#f3f3f3" class="bodyheader" style="height: 24px" width="171">
                                            Memo.</td>
                                        <td bgcolor="#f3f3f3" class="bodyheader" style="height: 24px">
                                            </td>
                                        <td bgcolor="#f3f3f3" class="bodyheader" style="width: 169px">
                                            <font color="#c16b42"><span style="color: #000000; background-color: #f3f3f3">Amount</span></font></td>
                                    </tr>
                                    <tr align="left" bgcolor="#ffffff" style="color: #000000; background-color: #f3f3f3"
                                        valign="middle">
                                        <td bgcolor="#ffffff">
                                            &nbsp;&nbsp;<igtxt:WebDateTimeEdit ID="dDate" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                                Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                                <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                </ButtonsAppearance>
                                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                            </igtxt:WebDateTimeEdit>
                                        </td>
                                        <td colspan="2">
                                            <font size="3"><b>&nbsp;<asp:TextBox ID="txtRefNo" runat="server" CssClass="shorttextfield" Width="220px" ForeColor="Black"></asp:TextBox></b></font>
                                            &nbsp;<a href="javascript:NewCal('txtDueDate','mmddyyyy')"></a>&nbsp;
                                        </td>
                                        <td style="width: 169px">
                                            <asp:TextBox ID="txtAmount" runat="server" CssClass="d_numberfield" ReadOnly="True">0</asp:TextBox></td>
                                    </tr>
                                    <tr align="left" bgcolor="#f3f3f3" valign="middle">
                                        <td class="bodyheader">
                                            A/P</td>
                                        <td>
                                            &nbsp;</td>
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td style="width: 169px">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr align="left" bgcolor="#ffffff" valign="middle">
                                        <td colspan="3" style="height: 26px">
                                            <b><font size="3"><b>&nbsp;<asp:DropDownList ID="lstAP" runat="server" CssClass="net_smallselect" >
                                            </asp:DropDownList></b></font></b></td>
                                        <td style="height: 26px; width: 169px;">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr align="left" bgcolor="#ffffff" valign="middle">
                                        <td colspan="4" style="height: 26px">
                                            <uc1:PayableQueueControl ID="PayableQueueControl1" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                                </td>
        </tr>
        <tr>
            <td height="18" bgcolor="#E7F0E2">&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;<asp:HiddenField ID="hVendorAcct" runat="server" Value="0" /><asp:HiddenField ID="hIsDisabled" runat="server" Value="0" />
                                <asp:HiddenField ID="hBillNumber" runat="server" Value="0" /><asp:HiddenField ID="hMainCommand" runat="server" Value="0" />
                                </td>
        </tr>
        
        <tr>
            <td height="24" align="center" valign="middle" bgcolor="#d5e8cb" style="border-top: 1px solid #89a979">
                <img src="../../ASP/Images/button_save_payment.gif" onclick="if(validatePage()){btnSaveClick()}" id="btnSaveDown" runat="server" /></td>
        </tr>
    </table>
    
    <div>
        &nbsp;<igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="180px">
            <Layout CellPadding="0" FooterFormat="" NextMonthText="&gt;&gt;" PrevMonthText="&lt;&lt;"
                ShowFooter="False" ShowMonthDropDown="False" ShowYearDropDown="False" TitleFormat="Month">
                <DayStyle BackColor="White" CssClass="CalDay" />
                <SelectedDayStyle BackColor="#C5D5FC" CssClass="CalSelectedDay" />
                <OtherMonthDayStyle ForeColor="Silver" />
                <NextPrevStyle CssClass="NextPrevStyle" />
                <CalendarStyle CssClass="CalStyle">
                </CalendarStyle>
                <TodayDayStyle CssClass="CalToday" />
                <DayHeaderStyle CssClass="CalDayHeader" Font-Bold="False">
                    <BorderDetails StyleBottom="None" />
                </DayHeaderStyle>
                <TitleStyle CssClass="TitleStyle" Font-Bold="True" />
            </Layout>
        </igsch:WebCalendar>
        &nbsp;</div>
    </form>
     <script type="text/javascript" language="javascript">
	ig_initDropCalendar("CustomDropDownCalendar dDate");
</script>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
