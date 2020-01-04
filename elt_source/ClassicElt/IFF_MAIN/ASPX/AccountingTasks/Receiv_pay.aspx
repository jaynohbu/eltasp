<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Receiv_pay.aspx.cs" Inherits="ASPX_AccountingTasks_Receiv_pay" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="Controls/ARControl.ascx" TagName="ARControl" TagPrefix="uc2" %>
<%@ Register Src="Controls/BillListControl.ascx" TagName="BillListControl" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server" >
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <script type="text/javascript" src="../jScripts/JPED_NET.js"></script>
    <script type="text/javascript" src="../jScripts/WindowsManip.js"></script>
    <script type="text/javascript" language="javascript" src="../../ASP/ajaxFunctions/ajax.js"></script>
    <script type="text/javascript" src="../jScripts/datetimepicker.js"></script>
    <script type="text/javascript" src="../jScripts/ig_dropCalendar.js"></script> 
    <script type="text/javascript" language="javascript">
<!--
function SearchClick()
    {
        document.getElementById("hMainCommand").value="SEARCH";  
        form1.submit();      
    }
    
    function formatNumber(name)
    {    
       
        try
        {
            check=parseFloat(name.value);
            name.value=check.toFixed(2);
        }catch(e)
        {
            return false;
        }
            return true;
        
    }
    
    function SaveClick()
    {
        document.getElementById("hMainCommand").value="SAVE";  
        form1.submit();         
    }
    
    function CancelClick()
    {
        document.getElementById("hMainCommand").value="CANCEL";  
        form1.submit();         
    }
    
     function clearSearch(obj){        
           obj.value = ''; 
          // obj.style.color='#000000';         
        }
    function lstVendorNameChange(orgNum,orgName)
    {            
        var txtObj = document.getElementById("lstVendorName");
        var divObj = document.getElementById("lstVendorNameDiv") ;              
        txtObj.value = orgName;      
        document.getElementById("hVendorAcct").value=orgNum;    
        divObj.style.position = "absolute";
        divObj.style.visibility = "hidden";    
        document.getElementById("hMainCommand").value="VENDOR_CHANGE";  
		        
        form1.submit();
    }
    function bankChange(ddl)
    {           
        var bannkBalance=document.getElementById("hBankBalance").value;
        bannkBalance=bannkBalance.split("^^");          
        document.getElementById("txtAcctBalance").value=parseFloat(bannkBalance[ddl.selectedIndex]);
    }
        
    function check_clicked(checkbox)
    {   
    
        if(document.form1.hPaymentNo.value=="0"){
            var temp=checkbox.src.split("/");
            check=temp[temp.length-1];

            if(check=="mark_o.gif"){
                if(parseFloat(document.getElementById("txtAmtAnapplied").value)>0){
                    checkbox.src="images/mark_x.gif"; 
                             //-----------------------------Save last values and ids-----------------------
                    document.getElementById("hLastSelectedCheckBoxID").value=checkbox.id;   
                }
                else
                {
                    alert("Insufficient Amount!");
                    return;
                }   
                                              
            }else
            {      
                checkbox.src="images/mark_o.gif";
            }         
            amountReceivingChange();  
        }          
    }
    
 function resetAllAmounts(){
 
    checkbox=document.getElementById(document.getElementById("hLastSelectedCheckBoxID").value);    
    checkBoxIDs=document.getElementById("ARControl1_hCheckBoxIDs").value.split("^^");
    dueIDs=document.getElementById("ARControl1_hAmountDueIDs").value.split("^^");
    paymentIDs=document.getElementById("ARControl1_hAmountPaymentIDs").value.split("^^");

    var hDTnPT=document.getElementById("ARControl1_hDTnPT").value.split("^^"); 
    TotalDue=document.getElementById(hDTnPT[0]);
    TotalPayment=document.getElementById(hDTnPT[1]);

    var last_selectedIndex=-1;
    var DueAmtTotal=0;
    var PaymentAmtTotal=0;          

    for(i=0 ;i<dueIDs.length-1&&unapp>0 ;i++){ 
        var temp=document.getElementById(checkBoxIDs[i]).src.split("/");
        check=temp[temp.length-1]; 
        
        if(check=="mark_x.gif")
        {   
          
            if(checkBoxIDs[i] == checkbox.id)
            {
                last_selectedIndex=i;            
            }
            else
            {                    
                document.getElementById(paymentIDs[i]).value=document.getElementById(dueIDs[i]).value;                              
                unapp-=parseFloat(document.getElementById(paymentIDs[i]).value);
            } 
         }
         else
         {
             document.getElementById(paymentIDs[i]).value=0;
         }
    }
    
    if(last_selectedIndex!=-1&&unapp>0)
    {  
        var temp=document.getElementById(checkBoxIDs[last_selectedIndex]).src.split("/");
        check=temp[temp.length-1];   
        if(check=="mark_x.gif")
        {
            if(parseFloat(document.getElementById(dueIDs[last_selectedIndex]).value)-unapp>0)
            {
                ajust=parseFloat(document.getElementById(dueIDs[last_selectedIndex]).value)-unapp;
                document.getElementById(paymentIDs[last_selectedIndex]).value=parseFloat(document.getElementById(dueIDs[last_selectedIndex]).value)-ajust;
                unapp=0;
            }
            else
            {
                document.getElementById(paymentIDs[last_selectedIndex]).value=document.getElementById(dueIDs[last_selectedIndex]).value;
                unapp-=parseFloat(document.getElementById(paymentIDs[last_selectedIndex]).value);            
            }
               
        }
        else
         {
             document.getElementById(paymentIDs[last_selectedIndex]).value=0;
         }
    }
    for(i=0; i<paymentIDs.length-1;i++)
    {
        PaymentAmtTotal+=parseFloat(document.getElementById(paymentIDs[i]).value); 
    }
    
    TotalPayment.value=PaymentAmtTotal; 
    document.getElementById("txtAmtToPayNow").value= PaymentAmtTotal;          
    document.getElementById("txtAmtAnapplied").value= unapp;  
 }
    
function amountReceivingChange()
{
    obj=document.getElementById('cApplyCredit');    
    if(obj.checked){
    unapp=parseFloat(document.getElementById("txtCreditRemain").value)
    +parseFloat(document.getElementById("txtAmtReceiving").value) ;            
    }
    else
    {
    unapp=parseFloat(document.getElementById("txtAmtReceiving").value);
    }
  resetAllAmounts();
}
    
function applyCredit(obj)
{
   if(obj.checked){
       unapp=parseFloat(document.getElementById("txtCreditRemain").value)
        +parseFloat(document.getElementById("txtAmtReceiving").value);            
    }
   else
    {
        unapp=parseFloat(document.getElementById("txtAmtReceiving").value);
       
   }   
    document.getElementById("txtAmtAnapplied").value= unapp;
    resetAllAmounts();
}

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
//-->
</script>
    
<script language="VBScript">

Function makeMsgBox(tit,mess,icon,buts,defs,mode)
   butVal = icon + buts + defs + mode
   makeMsgBox = MsgBox(mess,butVal,tit)
End Function

Function CofirmCustomerCreditBack()
    RET=makeMsgBox("","Would you like to give the customer credit back?",48,4,0,4096)
    if RET = 6 THEN form1.hCreditBack.Value="Y"  end if
End Function

</script>
<style type="text/css">
<!--
body {
	margin: 0;
	padding: 0;
}
-->
</style>
<link href="../CSS/elt_css.css" rel="stylesheet" type="text/css">
<link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css">
</head>
<body>
    <form id="form1"  runat="server">
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="51%" align="left" valign="middle" class="pageheader"> Receive Payment </td>
                <td width="49%" align="right" valign="baseline"><span style="visibility:hidden"><asp:TextBox ID="txtSearch" runat="server" CssClass="lookup" value="Search Here" ForeColor="Black" >
					</asp:TextBox>
					<asp:Image ID="btnSearch" runat="server" ImageUrl="../../asp/images/button_newsearch.gif" /></span><span class="bodyheader"> <a onclick="MM_openBrWindow('/iff_main/ASPX/AccountingTasks/Offset.html','Offset','status=yes,scrollbars=yes,resizable=yes,width=820,height=750')">A/R & A/P Offset</a></span></td>
            </tr>
        </table>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89a979" class="border1px">
        <tr>
            <td height="24" align="center" valign="middle" bgcolor="#d5e8cb" style="border-bottom: 1px solid #89a979">
                <asp:Image ID="btnSaveUpper" runat="server" ImageUrl="../../ASP/Images/button_smallsave.gif" />
                                            <img id="btnCancel" runat="server" name="bDelete"
                                                style="cursor: hand" src="../../ASP/Images/button_cancel.gif" visible=false /></td>
        </tr>
        <tr>
			<td align="center" bgcolor="#f3f3f3" style="border-bottom: 2px solid #89a979; padding:24px 0 24px 0">
				<table align="center" border="0" bordercolor="#89a979" cellpadding="0"
					cellspacing="0" class="border1px" width="66%" style="padding-left: 10px">
					<tr align="left" valign="middle" bgcolor="#E7F0E2">
						<td height="20" colspan="2" valign="middle" bgcolor="#E7F0E2" class="bodyheader">Company Name</td>
						<td width="17%" valign="middle" bgcolor="#E7F0E2" class="bodyheader">Date</td>
						<td width="16%" valign="middle" bgcolor="#E7F0E2">&nbsp;</td>
						<td width="17%" valign="middle" bgcolor="#E7F0E2">&nbsp;</td>
					</tr>
					<tr align="left"  valign="middle" bgcolor="ffffff">
						<td class="bodycopy" valign="middle" colspan="2">
							<div id="lstVendorNameDiv"></div>
							<table border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td>
										<asp:TextBox ID="lstVendorName" runat="server" autocomplete="off" class="shorttextfield"
											ForeColor="Black" name="lstVendorName" onfocus="initializeJPEDField(this);" onkeyup="organizationFill(this,'Vendor','lstVendorNameChange')"
										   Style="border-right: #7f9db9 0px solid;
											border-top: #7f9db9 1px solid; border-left: #7f9db9 1px solid; width: 240px;
											border-bottom: #7f9db9 1px solid; height: 12px" type="text" AutoPostBack="false" ></asp:TextBox></td>
									<td>
										<img id="IMG1" runat="server" alt="" onclick="organizationFillAll('lstVendorName','Vendor','lstVendorNameChange')"
											src="/ig_common/Images/combobox_drop.gif" style="border-right: #7f9db9 1px solid;
											border-top: #7f9db9 1px solid; border-left: #7f9db9 0px solid; cursor: hand;
											border-bottom: #7f9db9 1px solid" /></td>
									<td>
										<img alt="" border="0" onclick="quickAddClient('hVendorAcct','lstVendorName','txtVendorInfo')"
											src="/ig_common/Images/combobox_addnew.gif" style="cursor: hand" /></td>
									<td>
										<br />                                                    </td>
								</tr>
							</table>
							<!-- End JPED -->                                        </td>
						<td colspan="3" valign="top">
							<igtxt:WebDateTimeEdit ID="dDate" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
								Fields="" ForeColor="Black" PromptChar=" " Width="180px">
								<ButtonsAppearance CustomButtonDisplay="OnRight"></ButtonsAppearance>
								<SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
							</igtxt:WebDateTimeEdit></td>
					</tr>
					<tr bgcolor="#f3f3f3">
						<td height="2" colspan="5" align="left" bgcolor="#89a979" class="bodyheader style1"></td>
					</tr>
					<tr align="left" bgcolor="#f3f3f3" valign="middle">
						<td height="18" valign="middle" class="bodyheader">Payment &nbsp;Method</td>
						<td width="24%" valign="middle" class="bodyheader">Reference No.</td>
						<td valign="middle" class="bodyheader">Deposit to</td>
						<td>&nbsp;</td>
						<td><span class="bodyheader">Account Balance</span></td>
					</tr>
					<tr align="left" bgcolor="#ffffff" valign="middle">
						<td valign="middle"><asp:DropDownList ID="ddlPaymethod" runat="server" CssClass="smallselect" Width="100px" Height="18px">
							<asp:ListItem>Check</asp:ListItem>
							<asp:ListItem>Cash</asp:ListItem>
							<asp:ListItem>Credit Card</asp:ListItem>
							<asp:ListItem>Bank to Bank</asp:ListItem>
						</asp:DropDownList></td>
						<td valign="middle"><asp:TextBox ID="txtRefCheck" runat="server" CssClass="shorttextfield" Width="100px" ForeColor="Black"></asp:TextBox></td>
						<td colspan="2" valign="middle"><asp:DropDownList ID="ddlBankAcct" runat="server"
								CssClass="smallselect" Width="180px" Height="18px"> </asp:DropDownList></td>
						<td valign="middle"><asp:TextBox ID="txtAcctBalance" runat="server" CssClass="d_numberfield" Width="70px">0.0</asp:TextBox></td>
					</tr>
					<tr align="left" bgcolor="#ffffff" valign="middle">
						<td height="2" colspan="5" valign="middle">&nbsp;</td>
					</tr>
					<tr>
						<td height="1" colspan="5" align="left" bgcolor="#89a979"></td>
					</tr>
					<tr>
						<td height="1" colspan="5" align="left" bgcolor="#ffffff"></td>
					</tr>
					<tr>
						<td height="1" colspan="5" align="left" bgcolor="#89a979"></td>
					</tr>
					<tr align="left" bgcolor="#f3f3f3" valign="middle">
						<td valign="middle">&nbsp;</td>
						<td align="right" valign="middle" style="padding-right:5px"><span class="bodyheader">
							<asp:Label ID="lblAmountReceiving" runat="server" Text="Amount Receiving" ForeColor="#CC6600"></asp:Label>
						</span></td>
						<td colspan="2"><asp:TextBox ID="txtAmtReceiving" runat="server" CssClass="numberalignbold" Width="70px" ForeColor="Black">0.00</asp:TextBox></td>
						<td>&nbsp;</td>
					</tr>
					<tr align="left" bgcolor="#e7f0e2" valign="middle">
						<td bgcolor="#ffffff"  valign="middle">&nbsp;</td>
						<td align="right" valign="middle" bgcolor="#ffffff" style="padding-right:5px"><asp:Label ID="lblCreditRemaining" CssClass="bodyheader" runat="server" Text="Credit Remaining"></asp:Label></td>
						<td bgcolor="#ffffff"><asp:TextBox ID="txtCreditRemain" runat="server" CssClass="readonlyboldright" Width="70px" ForeColor="Black" ReadOnly="True">0.0</asp:TextBox></td>
						<td colspan="2" bgcolor="#ffffff"><asp:CheckBox ID="cApplyCredit" runat="server" />                                                                                
						<input id="sToBePrint" name="sToBePrint" type="text" 
								value="Use this credit" runat="server" style="border:none" /></td>
					</tr>
					
					<tr align="left" bgcolor="#f3f3f3" valign="middle">
						<td class="bodyheader" valign="middle" width="26%">                                        </td>
						<td align="right" valign="middle" style="padding-right:5px"><asp:Label ID="lblAmountToPayNow" runat="server" CssClass="bodyheader" Text=" Amount to Pay Now"></asp:Label>                                            &nbsp;</td>
						<td colspan="2">
							<asp:TextBox ID="txtAmtToPayNow" runat="server" CssClass="readonlyboldright" Width="70px" ForeColor="Black"
								ReadOnly="True">0.00</asp:TextBox></td>
						<td>&nbsp;</td>
					</tr>
					<tr align="left" bgcolor="#e7f0e2" valign="middle">
						<td bgcolor="#ffffff" class="bodyheader" valign="middle">                                        </td>
						<td align="right" valign="middle" bgcolor="#ffffff" style="padding-right:5px">
							<asp:Label ID="lblUnappliedAmount" CssClass="bodyheader" runat="server" Text="Unapplied Amount"></asp:Label>                                        </td>
						<td colspan="2" bgcolor="#ffffff">
							<asp:TextBox ID="txtAmtAnapplied" runat="server" CssClass="readonlyright" Width="70px" ForeColor="Black"
								ReadOnly="True">0.00</asp:TextBox></td>
						<td bgcolor="#ffffff">&nbsp;</td>
					</tr>
				</table>
			</td>
        </tr>
        <tr>
            <td align="left" valign="top"><uc2:ARControl ID="ARControl1" runat="server" /></td>
        </tr>
        <tr>
            <td>&nbsp;<asp:HiddenField ID="hPaymentNo" runat="server" Value="0" />
                                <asp:HiddenField ID="hLastID" runat="server" Value="0" /><asp:HiddenField ID="hAmountDueIDs" runat="server" Value="0" /><asp:HiddenField ID="hAmountPaymentIDs" runat="server" Value="0" />
                                <asp:HiddenField ID="hVendorAcct" runat="server" Value="0" /><asp:HiddenField ID="hCreditRemainedOriginal" runat="server" Value="0" />
                                <asp:HiddenField ID="hBankBalance" runat="server" Value="0" /><asp:HiddenField ID="hAmtDueID" runat="server" Value="0" /><asp:HiddenField ID="hCreditAmtSaved" runat="server" Value="0" /><asp:HiddenField ID="hLastSelectedCheckBoxID" runat="server" Value="0" />
                                <asp:HiddenField ID="hMainCommand" runat="server" Value="0" />
                &nbsp;
                <asp:HiddenField ID="hCreditBack" runat="server" Value="0" />
            </td>
        </tr>
        
        <tr>
            <td height="24" align="center" valign="middle" bgcolor="#d5e8cb" style="border-top: 1px solid #89a979">
                <asp:Image ID="btnSaveDown" runat="server" ImageUrl="../../ASP/Images/button_smallsave.gif" /></td>
        </tr>
    </table>
    <div>
        &nbsp;<igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="182px">
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
