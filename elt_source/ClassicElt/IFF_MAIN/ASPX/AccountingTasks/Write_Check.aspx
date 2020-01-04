<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Write_Check.aspx.cs" Inherits="ASPX_AccountingTasks_Write_Check" %>

<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>

<%@ Register Src="Controls/CheckItemControl.ascx" TagName="CheckItemControl" TagPrefix="uc3" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<script language=CS runat=server></script>
    <link href="../CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../jScripts/ig_dropCalendar.js"></script>
    <script type="text/javascript" src="../jScripts/JPED_NET.js"></script>
     <SCRIPT src="../jScripts/stanley_J_function.js" type=text/javascript></SCRIPT> 
    <script type="text/javascript" src="../jScripts/datetimepicker.js"></script>
		<script type="text/javascript" src="../jScripts/WindowsManip.js"></script>
        <script type="text/javascript" language="javascript" src="../../ASP/ajaxFunctions/ajax.js"></script>
        <script type="text/javascript" language="javascript">
        
//        function checkNoChange(ddl){
//            acct=ddl.value;        
//            document.getElementById("txtAcctBalance").value=getBalance("Bank",acct);
//            document.getElementById("txtCheckNo").value=getCheckNumber(acct);
//        }

function bankChange(ddl,ddl2)
{ 
    methodChange(ddl2,ddl);
    checkNoChange(ddl);
}  

function checkNoChange(ddl){
    acct=ddl.value;   
    document.getElementById("txtCheckNo").value=getCheckNumber(acct);
}
  
function methodChange(ddl,ddl2)
{
    var checkNo=document.getElementById("hCheckNo").value;
    checkNo=checkNo.split("^^");          
    if(ddl.value=="Check")
    {                
        document.getElementById("pnlToBe").style.visibility="visible";        
        if(checkNo[ddl2.selectedIndex]==0)
        {
            alert("Please select a checking account!");                   
            for(i=0; i<ddl2.options.length;i++)
            {           
                if(checkNo[i]!="0")
                {
                    ddl2.selectedIndex=i;
                    acct=  ddl2.value;           
                   
                    bankBalance=getBalance("Bank",acct);         
                    document.getElementById("txtAcctBalance").value=bankBalance;
                    return;
                }        
            }
        }           
    }
    else
    {  
     document.getElementById("pnlToBe").style.visibility="hidden";    
    } 
    acct=  ddl2.value;
    bankBalance=getBalance("Bank",acct);         
    document.getElementById("txtAcctBalance").value=bankBalance;
}

function getEnglish(money)
{
    var url="../../ASPX/AccountingTasks/Ajax/getEnglish.aspx?money="+ money;
    var req = new ActiveXObject("Microsoft.XMLHTTP");
    req.open("get",url,false);
    req.send();
    var result =req.responseText;
    return result;
} 
        
function getBalance(type,acct)
{
    var url="Ajax/getBalance.aspx?type="+ type+"&acct="+acct;
    var req = new ActiveXObject("Microsoft.XMLHTTP");
    req.open("get",url,false);
    req.send();
    var result =req.responseText;
    return result;
}

 
function getCheckNumber(acct)
{
    var url="Ajax/getCheckNo.aspx?acct="+acct;
    var req = new ActiveXObject("Microsoft.XMLHTTP");
    req.open("get",url,false);
    req.send();
    var result =req.responseText;
    return result;
}


function doPrint(obj){        
    if(!obj.checked){
        ddl=document.getElementById("ddlBankAcct");
        checkNoChange(ddl);
    }else{
     document.getElementById("txtCheckNo").value="";
    }
}


function Command(command,hCommand){
    
     document.getElementById(hCommand).value=command;
     form1.submit();
     return;
}

function SaveClick(){

    //alert(document.getElementById("hPrint_id").value);
    var hVendor_id = document.getElementById("hVendorAcct").value;
    var Amt_value = document.getElementById("txtAmount").value;
    var P_Check = document.getElementById("cToBePrint");
    if(hVendor_id != 0 && hVendor_id !="")
    { 
        if(Amt_value > 0 || P_Check.checked == true)
        { 
        
            if(document.form1.cToBePrint.checked)
            {
               document.getElementById("hMainCommand").value="printLater";
            }
            else
            {
              document.getElementById("hMainCommand").value="printNow";
              
              if(document.getElementById("ddlPaymethod").value=="Check"&&document.getElementById("txtCheckNo").value!="")
              {
                  checkPDF();
                  
                  if(document.getElementById("hPrintContinue").value=="Y")
                  {
                    form1.submit();
                  }else
                  {
                   return;
                  }                
                  
              }
             
            }
             form1.submit();
  }
         else
         {
            alert("Please at least one item!");
         }
    }
    else
    {
        alert("Please select a Vendor!");
        document.getElementById("lstVendorName").focus();
    }
            
  
}

function lstVendorNameChange(orgNum,orgName)
{            
    var txtObj = document.getElementById("lstVendorName");
    var divObj = document.getElementById("lstVendorNameDiv");
    txtObj.value = orgName;
    document.getElementById("txtAddress").value=getOrganizationInfo(orgNum);
    document.getElementById("hVendorAcct").value=orgNum;
    document.getElementById("txt_print_check_as").value=orgName;
    document.getElementById("hMainCommand").value="Load";
    divObj.style.position = "absolute";
    divObj.style.visibility = "hidden";
    //form1.submit();
}

    function getOrganizationInfo(orgNum)
    {
        if (window.ActiveXObject) {
            try {
                xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
            } catch(error) {
                try {
                    xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(error) { return ""; }
            }
        } 
        else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
        } 
        else { return ""; }

        var url="../../ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=B&org="+ orgNum;

        xmlHTTP.open("GET",url,false); 
        xmlHTTP.send(); 

        return xmlHTTP.responseText; 
    }
        </script>
<script language="vbscript" type="text/vbscript">

sub checkPDF()
    CheckNo=document.getElementById("txtCheckNo").value
    
    tmpCheckNo = inputbox("Please confirm the Check No.","Check No. Confirm",CheckNo)
    
		if tmpCheckNo = "" then
		        document.getElementById("hPrintContinue").value="N"
			exit sub
		else
			document.getElementById("txtCheckNo").value=tmpCheckNo
		end if		
    DIM wOptions			
    iCnt=1	
    prevCheckNo= CheckNo
    CheckNo=document.getElementById("txtCheckNo").value
    wOptions = "dialogWidth:700px; dialogHeight:600px; help:no; status:no; scroll:no;center:yes"
    popUpCheck = showModalDialog("../../ASP/acct_tasks/check_Dialog_frame2.asp?PostBack=false&cType=one&aItem="&iCnt ,self, wOptions)
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    nextAction = checkPrintStopSingle( CheckNo )
    
    if NOT nextAction = 0 then
        document.getElementById("hPrintContinue").value="N"
        document.getElementById("txtCheckNo").value=prevCheckNo
        exit sub
    else
        document.getElementById("hPrintContinue").value="Y"
    end if
end sub 

Function checkPrintStopSingle( CheckNo )
Dim qS,tmpUrl
tmpUrl = "../../ASP/acct_tasks/print_single_check_OK.asp?CheckNo=" & CheckNo
qS = showModalDialog("../../ASP/acct_tasks/print_check_dialog.asp?"&tmpUrl ,,"dialogWidth:700px; dialogHeight:230px; help:no; status:no; scroll:no;center:yes")
if qS = "" then qS = -1
checkPrintStopSingle = cLng(qS)
End Function
</script>


<link href="../CSS/elt_css.css" rel="stylesheet" type="text/css" />
<link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
.style1 {color: #cc6600}
-->
</style>
    <link href="../../CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <link href="../../CSS/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <input type="image" style="width:0px; height:0px" onclick="return false;" />
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td width="30%" height="32" align="left" valign="middle" class="pageheader">
                    <asp:Label ID="lblTitle" runat="server" Text="Make Payment"></asp:Label></td>
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
            <td align="center" valign="middle" bgcolor="#d5e8cb" style="border-bottom: 1px solid #89a979; height: 24px;">
                                            <asp:Image ID="btnSaveUp" runat="server" ImageUrl="../../ASP/Images/button_smallsave.gif" /></td>
        </tr>
        <tr>
            <td align="center" bgcolor="#f3f3f3" style="border-bottom: 2px solid #89a979; padding:24px 0 24px 0">
                                            <table border="0" cellspacing="0" cellpadding="0" style="width: 55%; height: 23px">
                                    <tr>
                                        <td align="right" style="width: 973px; height: 28px" >
                                            <span class="bodyheader">&nbsp;<img src="/iff_main/ASP/Images/required.gif" align="absbottom">Required field</span></td>
                                    </tr>
                                </table>
                <table align="center" bgcolor="#d5e8cb" border="0" bordercolor="#89a979" cellpadding="0"
                    cellspacing="0" class="border1px" width="648">
                    <tr align="left" bgcolor="#e7f0e2" valign="middle">
                        <td class="bodycopy">
                            &nbsp;
                        </td>
                        <td bgcolor="#e7f0e2" class="bodyheader" height="20" valign="middle">
                            Payment Method</td>
                        <td bgcolor="#e7f0e2" class="bodyheader" valign="middle" width="44%">
                            Bank Account</td>
                        <td bgcolor="#e7f0e2" class="bodyheader" valign="middle">
                            Balance</td>
                    </tr>
                    <tr align="left" bgcolor="#e7f0e2" style="font-weight: bold" valign="middle">
                        <td bgcolor="#ffffff" class="bodycopy" style="height: 18px">
                            &nbsp;
                        </td>
                        <td bgcolor="#ffffff" class="bodyheader" valign="top" width="26%" style="height: 18px">
                            <asp:DropDownList ID="ddlPaymethod" runat="server" CssClass="smallselect" Height="18px"
                                Width="120px">
                                <asp:ListItem>Check</asp:ListItem>
                                <asp:ListItem Value="CSH">Cash</asp:ListItem>
                                <asp:ListItem Value="CRC">Credit Card</asp:ListItem>
                                <asp:ListItem Value="BTB">Bank to Bank</asp:ListItem>
                            </asp:DropDownList></td>
                        <td bgcolor="#ffffff" valign="top" style="height: 18px">
                            <asp:DropDownList ID="ddlBankAcct" runat="server" CssClass="smallselect" Height="18px"
                                Width="240px">
                            </asp:DropDownList></td>
                        <td bgcolor="#ffffff" valign="top" style="height: 18px">
                            <asp:TextBox ID="txtAcctBalance" onKeyPress="checkNum()" runat="server" CssClass="readonlyboldright">0.0</asp:TextBox></td>
                    </tr>
                    <tr align="left" bgcolor="#e7f0e2" valign="middle">
                        <td bgcolor="#f3f3f3" class="bodycopy">
                            &nbsp;
                        </td>
                        <td bgcolor="#f3f3f3" class="bodyheader style1" height="18" valign="middle">
                                            <img src="/iff_main/ASP/Images/required.gif" align="absbottom">Vendor</td>
                        <td bgcolor="#f3f3f3" class="bodyheader" valign="middle">
                            &nbsp;
                        </td>
                        <td bgcolor="#f3f3f3" class="bodyheader style1" valign="middle">
                            Date</td>
                    </tr>
                    <tr align="left" bgcolor="#e7f0e2" valign="middle">
                        <td bgcolor="#ffffff" class="bodycopy">
                            &nbsp;
                        </td>
                        <td bgcolor="#ffffff" class="bodyheader" colspan="2" valign="top">
                                            <!-- Start JPED -->
                            <div id="lstVendorNameDiv">
                            </div>
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <asp:TextBox ID="lstVendorName" runat="server" autocomplete="off" class="shorttextfield"
                                            ForeColor="Black" name="lstVendorName" onfocus="initializeJPEDField(this);" onkeyup="organizationFill(this,'Vendor','lstVendorNameChange')"
                                            Style="border-right: #7f9db9 0px solid; border-top: #7f9db9 1px solid; border-left: #7f9db9 1px solid;
                                            width: 285px; border-bottom: #7f9db9 1px solid; height: 12px" type="text"></asp:TextBox></td>
                                    <td>
                                        <img id="IMG1" runat="server" alt="" onclick="organizationFillAll('lstVendorName','Vendor','lstVendorNameChange')"
                                            src="/ig_common/Images/combobox_drop.gif" style="border-right: #7f9db9 1px solid;
                                            border-top: #7f9db9 1px solid; border-left: #7f9db9 0px solid; cursor: hand;
                                            border-bottom: #7f9db9 1px solid" /></td>
                                    <td style="width: 18px">
                                        <img alt="" border="0" onclick="quickAddClient('hVendorAcct','lstVendorName','txtVendorInfo')"
                                            src="/ig_common/Images/combobox_addnew.gif" style="cursor: hand" /></td>
                                    <td>
                                        <br />
                                    </td>
                                </tr>
                            </table>
                                        <!-- End JPED -->                                        
                        </td>
                        <td align="left" bgcolor="#ffffff" style="width: 187px" valign="top">
                            <igtxt:WebDateTimeEdit ID="dDate" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                <ButtonsAppearance CustomButtonDisplay="OnRight">
                                </ButtonsAppearance>
                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                            </igtxt:WebDateTimeEdit>
                        </td>
                    </tr>
                    <tr align="left" bgcolor="#e7f0e2" valign="middle">
                        <td bgcolor="#f3f3f3" class="bodycopy">
                            &nbsp;</td>
                        <td bgcolor="#f3f3f3" class="bodyheader" colspan="2" height="18" valign="middle">
                            A/P</td>
                        <td bgcolor="#f3f3f3" style="width: 187px" valign="top">
                            &nbsp;</td>
                    </tr>
                    <tr align="left" bgcolor="#e7f0e2" valign="middle">
                        <td bgcolor="#ffffff" class="bodycopy">
                            &nbsp;</td>
                        <td bgcolor="#ffffff" class="bodyheader" colspan="2" valign="middle">
                            <span style="width: 187px">
                                <asp:DropDownList ID="ddlAPAcct" runat="server" CssClass="smallselect" Height="18px"
                                    Width="120px">
                                </asp:DropDownList>
                            </span>
                        </td>
                        <td bgcolor="#ffffff" style="width: 187px" valign="top">
                            &nbsp;</td>
                    </tr>
                </table>
                                <br />
                                <table align="center" 
                                    border="0" bordercolor="#89a979" cellpadding="0" cellspacing="0" height="261"
                                    width="648" id="TblCheck" runat="server">
                                    <tr align="left" valign="top">
                                        <td height="34" valign="bottom" width="556">                                        </td>
                                        <td valign="bottom" width="90" style="text-align: center">
                                            <asp:TextBox ID="txtCheckNo" runat="server" CssClass="shorttextfield" Width="70px" ForeColor="Black"></asp:TextBox></td>
                                    </tr>
                                    <tr align="left" valign="top">
                                        <td valign="bottom" style="height: 31px; text-align: right;" colspan="2">                                        
                                            <asp:TextBox ID="txtDate" runat="server" CssClass="d_shorttextfield" ForeColor="Black"
                                                Width="70px"></asp:TextBox>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr align="left" valign="top">
                                        <td colspan="2" style="height: 29px">
                                            <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
                                                <tr>
                                                    <td align="left" valign="bottom" width="13%" style="height: 29px">&nbsp;&nbsp;&nbsp;                                                    </td>
                                                    <td align="left" valign="bottom" width="61%" style="height: 29px">
                                                        <asp:TextBox ID="txt_print_check_as" runat="server" CssClass="shorttextfield" Font-Size="XX-Small"
                                                            ForeColor="Black" Width="90%"></asp:TextBox></td>
                                                    <td align="left" valign="bottom" width="4%" style="height: 29px">&nbsp;                                                    </td>
                                                    <td align="left" valign="bottom" width="22%" style="height: 29px">
                                                        <asp:TextBox ID="txtAmount" onKeyPress="checkNum()" runat="server" ReadOnly="true" CssClass="readonlyboldright">0.00</asp:TextBox></td>
                                                </tr>
                                            </table>                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td align="left" colspan="2" height="39" valign="top">
                                            <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
                                                <tr>
                                                    <td align="right" valign="bottom" width="6%" style="height: 40px">&nbsp;                                                    </td>
                                                    <td align="left" valign="bottom" width="94%" style="height: 40px">
                                                        <span class="bodyheader"><b>
                                                            <asp:TextBox ID="txtMoneyEnglish" runat="server" CssClass="readonly" ReadOnly="true"
                                                                Width="80%"></asp:TextBox>&nbsp;
                                                        </b></span>                                                    </td>
                                                </tr>
                                            </table>                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td colspan="2" height="75" valign="top">
                                            <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
                                                <tr>
                                                    <td align="left" height="20" valign="top" width="6%">                                                    </td>
                                                    <td align="left" valign="top" width="94%">                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="top" style="height: 50px">&nbsp;                                                    </td>
                                                    <td align="left" valign="top" style="height: 50px">
                                                        <asp:TextBox ID="txtAddress" runat="server" Height="50px" TextMode="MultiLine" Width="250px"></asp:TextBox></td>
                                                </tr>
                                            </table>                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td colspan="2" height="40" valign="top">
                                            <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
                                                <tr>
                                                    <td align="left" height="26" valign="bottom" width="6%">&nbsp;                                                    </td>
                                                    <td align="left" valign="middle" width="94%">
                                                        <input class="shorttextfield" maxlength="35" name="txtMemo" size="47" id="txtMemo" runat="server"  /></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="bottom">                                                    </td>
                                                    <td align="left" valign="bottom">                                                    </td>
                                                </tr>
                                            </table>                                        </td>
                                    </tr>
                                </table>            </td>
        </tr>
        
        <tr>
            <td>&nbsp;<asp:Panel ID="pnlToBe" runat="server" Height="50px" Width="200px">
                    <input id="cToBePrint" type="checkbox" onclick="doPrint(this)" checked="CHECKED" /><input id="sToBePrint" class="bodyheader" name="sToBePrint" style="border-right: medium none;
                                    border-top: medium none; border-left: medium none; border-bottom: medium none"
                                    type="text" value="To Be Printed Later" /></asp:Panel>
            </td>
        </tr>
        <tr>
            <td height="18" bgcolor="#f3f3f3" style="text-align: center">&nbsp;<uc3:CheckItemControl ID="CheckItemControl1" runat="server" />                                </td>
        </tr>
        <tr>
            <td>&nbsp;<asp:HiddenField ID="hVendorAcct" runat="server" Value="0" /><asp:HiddenField ID="hCheckNo" runat="server" Value="0" /><asp:HiddenField ID="hMainCommand" runat="server" Value="0" /><asp:HiddenField ID="hBankBalance" runat="server" Value="0" />                            <asp:HiddenField ID="hPrintContinue" runat="server" Value="0" />
                <asp:HiddenField ID="hPrint_id" runat="server" Value="0" />
            </td>
        </tr>
        
        <tr>
            <td height="24" align="center" valign="middle" bgcolor="#d5e8cb" style="border-top: 1px solid #89a979">
                                            <asp:Image ID="btnSaveDown" runat="server" ImageUrl="../../ASP/Images/button_smallsave.gif" /></td>
        </tr>
    </table>
        <igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="182px">
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
       
    </form>
     <script type="text/javascript" language="javascript">
	ig_initDropCalendar("CustomDropDownCalendar dDate");
</script>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
