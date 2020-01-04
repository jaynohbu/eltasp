<%@ Page Language="C#" AutoEventWireup="true" CodeFile="enter_bill.aspx.cs" Inherits="ASPX_AccountingTasks_enter_bill" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="Controls/PayableQueueControl.ascx" TagName="PayableQueueControl"
    TagPrefix="uc1" %>
    
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Payable Queue</title>
    <script type="text/javascript" src="../jScripts/JPED_NET.js"></script>
    <script type="text/javascript" src="../jScripts/datetimepicker.js"></script>
    <script type="text/javascript" src="../jScripts/WindowsManip.js"></script>
    <script type="text/javascript" language="javascript" src="../../ASP/ajaxFunctions/ajax.js"></script>
    <script type="text/javascript" src="../jScripts/ig_dropCalendar.js"></script>
     <SCRIPT src="../jScripts/stanley_J_function.js" type=text/javascript></SCRIPT>  
    <script type="text/javascript" language="javascript">
 function validatePage(){  
                              
            if(document.getElementById("lstVendorName").value=="")
            {
                 alert("Vendor is required!");
                 document.getElementById("lstVendorName").focus();
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
            form1.action="enter_bill.aspx";
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
            if(bill_number!=0 && bill_number != "Search Here"){
                document.getElementById("hBillNumber").value="";
                document.getElementById("hMainCommand").value="VIEW";
                form1.method="POST";
                form1.action="enter_bill.aspx";
		        form1.submit();
		    }else{
		        alert("Please enter a valid bill number!");
		        document.getElementById("txtSearch").focus();
		        
		    }
        }
        
        function btnSaveClick(){
       
            if(document.getElementById("hVendorAcct").value=="")
            {
                document.getElementById("lstVendorName").focus();
                alert("A vendor is required!"); return;
                
            }
            if(document.getElementById("lstVendorName")=="")
            {
                document.getElementById("lstVendorName").focus();
                alert("A vendor is required!");return;
            }
            txtAmount=document.getElementById("txtAmount").value;
            if(parseFloat(txtAmount)=="0")
            {
                alert("No amount selected!");return;
            }
            if(document.getElementById("dDate").value=="")
            {
                alert("Date is required");return;
            }
            if(document.getElementById("dDue").value=="")
            {
                 alert("Due date is required!");return;
            }
            document.getElementById("hMainCommand").value="SAVE";  
            form1.method="POST"; 
            form1.action="enter_bill.aspx";
            form1.submit();         
        }
        
        function btnDeleteClick()
        {
            document.getElementById("hMainCommand").value="DELETE";  
            form1.method="POST";
            form1.action="enter_bill.aspx";
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
<link href="../CSS/AppStyle.css" type="text/css" rel="stylesheet" />
<link href="../CSS/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server" target="_self">
        <input type="image" style="width:0px; height:0px" onclick="return false;" />
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td width="30%" height="32" align="left" valign="middle" class="pageheader">
                    Payables Queue
                </td>
			<td width="70%" align="right" valign="baseline"><span class="labelSearch">BILL NO.</span>
			<!-- Search -->
                                                <asp:TextBox ID="txtSearch" runat="server" CssClass="lookup"  value="Search Here" onKeyDown="javascript: if(event.keyCode == 13) { btnSearchClick(); }"  ForeColor="Black"
                                                    Height="12px"></asp:TextBox><asp:Image ID="btnSearch"  runat="server"  ImageUrl="../../asp/images/button_newsearch.gif"/>
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
                                            <img src="../../ASP/Images/button_save_payment.gif" id="btnSaveUp" onclick="if(validatePage()){btnSaveClick()}" runat="server" />&nbsp;
                                            <asp:Label ID="lblIfProcessed" runat="server" Width="300px"></asp:Label>
                                            <img id="btnDelete" runat="server" onclick="btnDeleteClick();" src="../../ASP/images/button_delete_medium.gif"
                                                style="cursor: hand" /></td>
        </tr>
        <tr>
            <td align="center" bgcolor="#f3f3f3" style="border-bottom: 2px solid #89a979; padding:24px 0 24px 0">
                         
                                  <table border="0" cellspacing="0" cellpadding="0" style="width: 62%; height: 11px">
                                    <tr>
                                      <td align="left" style="height: 39px; width: 530px;">
                                        <asp:RadioButtonList ID="rdioDorC" runat="server" CssClass="bodyheader" RepeatDirection="Horizontal" BackColor="White">
                                        <asp:ListItem Selected="True" Value="D">Bill</asp:ListItem>
                                        <asp:ListItem Value="C">CreditMemo</asp:ListItem>
                                        
                                        </asp:RadioButtonList>
                                        </td>
                                        <td height="28" align="right" >
                                            <span class="bodyheader">&nbsp;<img src="/iff_main/ASP/Images/required.gif" align="absbottom">Required field</span></td>
                                    </tr>
                                </table>
                                <table align="center" bgcolor="#d5e8cb" border="0" bordercolor="#89a979" cellpadding="0"
                                    cellspacing="0" class="border1px" style="padding-left:10px" width="62%">
                                    <tr align="left" bgcolor="#e7f0e2" valign="middle">
                                        <td height="20" colspan="2" bgcolor="#e7f0e2" class="bodyheader">
                                            <font color="#c16b42"><img src="/iff_main/ASP/Images/required.gif" align="absbottom">Vendor</font></td>
                                        <td class="bodyheader" style="width: 197px"><font color="#c16b42">Date</font></td>
                                    </tr>
                                    <tr align="left" bgcolor="#e7f0e2" valign="middle">
                                        <td bgcolor="#ffffff" colspan="2" style="color: #c16b42">
                                            <!-- Start JPED -->
                                            <div id="lstVendorNameDiv">                                            </div>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:TextBox ID="lstVendorName" runat="server" autocomplete="off" CssClass="bodycopy"
                                                            ForeColor="Black" name="lstVendorName" onfocus="initializeJPEDField(this);" 
															onkeyup="organizationFill(this,'Vendor','lstVendorNameChange')"
                                                            Style="border-right: #7f9db9 0px solid;
                                                            border-top: #7f9db9 1px solid; border-left: #7f9db9 1px solid; width: 285px;
                                                            border-bottom: #7f9db9 1px solid; height: 12px" type="text" ></asp:TextBox></td>
                                                    <td>
                                                        <img id="IMG1" runat="server" alt="" 
															onclick="organizationFillAll('lstVendorName','Vendor','lstVendorNameChange')"
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
                                        <td bgcolor="#ffffff" style="width: 197px"><igtxt:WebDateTimeEdit ID="dDate" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                                Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                            <ButtonsAppearance CustomButtonDisplay="OnRight"> </ButtonsAppearance>
                                            <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                        </igtxt:WebDateTimeEdit></td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td bgcolor="#89a979" colspan="3" style="height: 2px">                                        </td>
                                    </tr>
                                    <tr align="left" bgcolor="#ffffff" valign="middle">
                                        <td width="25%" height="18" bgcolor="#f3f3f3" class="bodyheader">Reference No.</td>
                                        <td width="38%" bgcolor="#f3f3f3" class="bodyheader">
                                            Due Date</td>
                                        <td bgcolor="#f3f3f3" class="bodyheader" style="width: 197px">
                                            <font color="#c16b42">Amount</font></td>
                                    </tr>
                                    <tr align="left" bgcolor="#ffffff"  valign="middle">
                                        <td><asp:TextBox ID="txtRefNo" runat="server" CssClass="shorttextfield" ForeColor="Black"></asp:TextBox></td>
                                        <td>
                                            <igtxt:WebDateTimeEdit ID="dDue" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                                Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                                <ButtonsAppearance CustomButtonDisplay="OnRight">                                                </ButtonsAppearance>
                                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                            </igtxt:WebDateTimeEdit>                                        </td>
                                        <td style="width: 197px">
                                            <asp:TextBox ID="txtAmount" runat="server" CssClass="d_numberfieldbold" ReadOnly="True" Width="80px">0.00</asp:TextBox></td>
                                    </tr>
                                    <tr align="left" bgcolor="#f3f3f3" valign="middle">
                                        <td height="18" bgcolor="#f3f3f3" class="bodyheader">
                                            A/P</td>
                                        <td>&nbsp;                                        </td>
                                        <td style="width: 197px">&nbsp;</td>
                                    </tr>
                                    <tr align="left" bgcolor="#ffffff" valign="middle">
                                        <td colspan="2"><asp:DropDownList ID="lstAP" runat="server" CssClass="net_smallselect" >
                                            </asp:DropDownList></td>
                                        <td style="width: 197px"></td>
                                    </tr>
                                    <tr align="left" bgcolor="#ffffff" valign="middle">
                                        <td colspan="3">                                        </td>
                                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td align="left" valign="top" bgcolor="#ffffff"><uc1:PayableQueueControl ID="PayableQueueControl1" runat="server" /></td>
        </tr>
        <tr>
            <td><asp:HiddenField ID="hVendorAcct" runat="server" Value="0" /><asp:HiddenField ID="hIsDisabled" runat="server" Value="0" />
                                <asp:HiddenField ID="hBillNumber" runat="server" Value="0" /><asp:HiddenField ID="hMainCommand" runat="server" Value="0" />
                                </td>
        </tr>
        
        <tr>
            <td height="24" align="center" valign="middle" bgcolor="#d5e8cb" style="border-top: 1px solid #89a979">
                <img src="../../ASP/Images/button_save_payment.gif" onclick="if(validatePage()){btnSaveClick()}" id="btnSaveDown" runat="server" /></td>
        </tr>
    </table>
    
    <div><igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="182px">
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
	ig_initDropCalendar("CustomDropDownCalendar dDate dDue");
</script>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
