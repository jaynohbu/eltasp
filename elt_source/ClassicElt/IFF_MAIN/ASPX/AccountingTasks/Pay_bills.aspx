<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Pay_bills.aspx.cs" Inherits="ASPX_AccountingTasks_Pay_bills" %>

<%@ Register Src="Controls/PayableQueueControl.ascx" TagName="PayableQueueControl"
    TagPrefix="uc2" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>

<%@ Register Src="Controls/BillListControl.ascx" TagName="BillListControl" TagPrefix="uc1" %>


<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<script language=CS runat=server></script>
    <link href="../CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../jScripts/JPED_NET.js"></script>
    <script type="text/javascript" src="../jScripts/datetimepicker.js"></script>
    <script src="../jScripts/stanley_J_function.js" type=text/javascript></script> 
    <script type="text/javascript" src="../jScripts/ig_dropCalendar.js"></script> 
		<script type="text/javascript" src="../jScripts/WindowsManip.js"></script>
        <script type="text/javascript" language="javascript" src="../../ASP/ajaxFunctions/ajax.js"></script>
<script type="text/javascript" language="javascript">

function validateNumber(name)
{    
    var check=name.value.replace(".","");
    if(!check.match(/^\d+$/)){
        alert("Number format invalid!");
        name.value="0.00";
    }else
    {
    check=parseFloat(check);
    name.value=check.toFixed(2);
    }   
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
                    form1.submit(); 
                }
                else
                {
                    document.getElementById("hMainCommand").value="printNow";
                    if(document.getElementById("ddlPaymethod").value=="Check"&&document.getElementById("txtChekNo").value!="")
                    {
                      checkPDF();
                     
                      if(document.getElementById("hPrintContinue").value=="Y")
                      {
                        form1.submit();
                      }       
                      
                    }
                }
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


function IDTypeChecked(check1, check2)
{
    if(!check1.checked)
    {
    check1.checked=false;
    check2.checked=true;
    }else
    {
    check1.checked=true;
    check2.checked=false;
    }
}


function doPrint(obj){        
    if(!obj.checked){
        ddl=document.getElementById("ddlBankAcct");
        checkNoChange(ddl);
    }else{
     document.getElementById("txtChekNo").value="";
    }
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
function Command(command,hCommand){
    document.getElementById(hCommand).value=command;           
    form1.submit();            
}        
function searchPayment(type)
{   var tempSearchNo =document.getElementById("txtSearch").value;
    if( tempSearchNo != "" && tempSearchNo != "Search Here")
    {
        document.getElementById("hMainCommand").value="SEARCH";
        form1.submit();
    }
    else
    {
        alert("Please enter Search No first!"); 
        return false;
     }
}

function bankChange(ddl,ddl2)
{ 
    methodChange(ddl2,ddl);
    checkNoChange(ddl);
}  

function checkNoChange(ddl){
    acct=ddl.value;   
    document.getElementById("txtChekNo").value=getCheckNumber(acct);
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
    form1.submit();
}
 function clearSearch(obj){        
           obj.value = ''; 
          // obj.style.color='#000000';         
        }
        
function getOrganizationInfo(orgNum)
{
    if (window.ActiveXObject) 
    {
        try 
        {
            xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
        } catch(error)
        {
            try 
            {
                xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
            } catch(error) { return ""; }
        }
    } 
    else if (window.XMLHttpRequest)
    {
        xmlHTTP = new XMLHttpRequest();
    } 
    else { return ""; }

    var url="../../ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=B&org="+ orgNum;
    xmlHTTP.open("GET",url,false); 
    xmlHTTP.send(); 

    return xmlHTTP.responseText; 
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

function check_clicked(checkbox,amt_due,amt_clear,hIsChecked)
{
    print_id=parseInt(document.getElementById("hPrint_id").value);
    
    if(print_id==0){
        var temp=checkbox.src.split("/");
        check=temp[temp.length-1];             
        if(check=="mark_o.gif")
        {               
              checkbox.src="images/mark_x.gif";  
              hIsChecked.value= "images/mark_x.gif";                         
              amt_clear.value=amt_due.value;
        }
        else
        {      
            checkbox.src="images/mark_o.gif"; 
             hIsChecked.value="images/mark_o.gif";          
            amt_clear.value=0;
        }         
        amountReceivingChange();
    }
}

var previous_val;
    
function clear_changed(checkbox,amt_due,amt_clear,hIsChecked)
{
    var temp=checkbox.src.split("/");
    check=temp[temp.length-1];
    if(parseFloat(amt_due.value)>=parseFloat(amt_clear.value)){
        if(check=="mark_x.gif")
        {               
             checkbox.src="images/mark_x.gif"; 
               hIsChecked.value= "images/mark_x.gif";    
        }
        else
        {
            if(parseFloat(amt_clear.value)==0)
            {
               alert("please input amount!");
            }else
            {
                checkbox.src="images/mark_x.gif";
                hIsChecked.value= "images/mark_x.gif";   
            }
        }     
        amountReceivingChange();
    }else
    {
     alert("Clear amount cannot be bigger than the due amount!");
     amt_clear.value=previous_val;
    }
}    

function save_prev(amt_clear)
{
    previous_val=amt_clear.value; 
}

function amountReceivingChange()
{
    txtTotalAmount=document.getElementById("txtAmount");            
    txtTotalClear=document.getElementById(document.getElementById("BillListControl1_hTotalClear").value);        
    var clears=document.getElementById("BillListControl1_hClearIDs").value.split("^^");         
    var totalClear=0;
    for(i=0; i<clears.length-1;i++)
    {         
    totalClear+=parseFloat(document.getElementById(clears[i]).value.replace(",","")); 
    }
    txtTotalAmount.value=totalClear.toFixed(2);         
    txtTotalClear.value=totalClear.toFixed(2); 
    Money=getEnglish(txtTotalClear.value)	            
    document.form1.txtMoneyEnglish.value=Money 
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

</script>
<script language="vbscript" type="text/vbscript">

sub checkPDF()
    CheckNo=document.getElementById("txtChekNo").value
    
    tmpCheckNo = inputbox("Please confirm the Check No.","Check No. Confirm",CheckNo)
    
		if tmpCheckNo = "" then
		        document.getElementById("hPrintContinue").value="N"
			exit sub
		else
			document.getElementById("txtChekNo").value=tmpCheckNo
		end if		
    DIM wOptions			
    iCnt=1	
    prevCheckNo= CheckNo
    CheckNo=document.getElementById("txtChekNo").value
    
    wOptions = "dialogWidth:700px; dialogHeight:600px; help:no; status:no; scroll:no;center:yes"
    popUpCheck = showModalDialog("../../ASP/acct_tasks/check_Dialog_frame2.asp?PostBack=false&cType=one&aItem="&iCnt ,self, wOptions)
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    nextAction = checkPrintStopSingle( CheckNo )
    
    if NOT nextAction = 0 then
        document.getElementById("hPrintContinue").value="N"
        document.getElementById("txtChekNo").value=prevCheckNo
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
</head>
<body>
    <form id="form1" runat="server">
    
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td width="30%" height="32" align="left" valign="middle" class="pageheader">
                    Bill PAy </td>
			<td width="70%" align="right" valign="baseline"><span class="labelSearch"></span>Check Number<asp:TextBox ID="txtSearch" runat="server" onKeyPress="checkNum()" onKeyDown="javascript: if(event.keyCode == 13) { searchPayment(); return false;}" CssClass="lookup" value="Search Here" ForeColor="Black"
                                                    Height="12px"></asp:TextBox><asp:Image ID="btnSearch" runat="server" ImageUrl="../../asp/images/button_newsearch.gif"  /><!-- Search -->
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
            <td height="24" align="center" valign="middle" bgcolor="#d5e8cb" style="border-bottom: 1px solid #89a979">
                <asp:Image ID="btnSaveUpper" runat="server" ImageUrl="../../ASP/Images/button_smallsave.gif" />
                                            <asp:Image ID="imgCancel" runat="server" Visible="False" ImageUrl="~/ASP/Images/button_cancel.gif" /></td>
        </tr>
        <tr>
            <td align="center" bgcolor="#f3f3f3" style="border-bottom: 2px solid #89a979; padding:24px 0 24px 0">
                                <table align="center" bgcolor="#d5e8cb" border="0" bordercolor="#89a979" cellpadding="0"
                                    cellspacing="0" class="border1px" width="648">
                                    <tr align="left" bgcolor="#e7f0e2" valign="middle">
                                        <td class="bodycopy">&nbsp;                                        </td>
                                        <td bgcolor="#e7f0e2" class="bodyheader" height="20" valign="middle">
                                            Payment Method</td>
                                        <td width="44%" valign="middle" bgcolor="#e7f0e2" class="bodyheader">Bank Account</td>
                                        <td valign="middle" bgcolor="#e7f0e2" class="bodyheader">Balance</td>
                                    </tr>
                                    <tr align="left" bgcolor="#e7f0e2" style="font-weight: bold" valign="middle">
                                        <td bgcolor="#ffffff" class="bodycopy">&nbsp;                                        </td>
                                        <td bgcolor="#ffffff" class="bodyheader" valign="top" width="26%">
                                            <asp:DropDownList id="ddlPaymethod" runat="server" CssClass="smallselect" Width="120px" Height="18px">
                                                <asp:ListItem>Check</asp:ListItem>
                                                <asp:ListItem>Cash</asp:ListItem>
                                                <asp:ListItem>Credit Card</asp:ListItem>
                                                <asp:ListItem>Bank to Bank</asp:ListItem>
                                            </asp:DropDownList></td>
                                        <td bgcolor="#ffffff" valign="top">
                                            <asp:DropDownList id="ddlBankAcct" runat="server" CssClass="smallselect" Width="240px" Height="18px"></asp:DropDownList></td>
                                        <td valign="top" bgcolor="#ffffff"><asp:TextBox ID="txtAcctBalance" onKeyPress="checkNum()" runat="server" ReadOnly="true" CssClass="readonlyboldright">0.0</asp:TextBox></td>
                                    </tr>
                                    <tr align="left" bgcolor="#e7f0e2" valign="middle">
                                        <td bgcolor="#f3f3f3" class="bodycopy">&nbsp;                                        </td>
                                        <td height="18" valign="middle" bgcolor="#f3f3f3" class="bodyheader style1">
                                            Vendor</td>
                                        <td bgcolor="#f3f3f3" class="bodyheader" valign="middle">&nbsp;                                        </td>
                                        <td valign="middle" bgcolor="#f3f3f3" class="bodyheader style1">Date</td>
                                    </tr>
                                    <tr align="left" bgcolor="#e7f0e2" valign="middle">
                                        <td bgcolor="#ffffff" class="bodycopy">&nbsp;                                        </td>
                                        <td bgcolor="#ffffff" class="bodyheader" colspan="2" valign="top">
                                            <!-- Start JPED -->
                                            <div id="lstVendorNameDiv">                                            </div>
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
                                                    <td style="width: 18px">
                                                        <img alt="" border="0" onclick="quickAddClient('hVendorAcct','lstVendorName','txtVendorInfo')"
                                                            src="/ig_common/Images/combobox_addnew.gif" style="cursor: hand" /></td>
                                                    <td>
                                                        <br />                                                    </td>
                                                </tr>
                                            </table>
                                            <!-- End JPED -->                                        </td>
                                        <td align="left" valign="top" bgcolor="#ffffff" style="width: 187px">
                                            <igtxt:WebDateTimeEdit ID="dDate" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                                Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                                <ButtonsAppearance CustomButtonDisplay="OnRight"> </ButtonsAppearance>
                                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                        </igtxt:WebDateTimeEdit>                                          </td>
                                    </tr>
                                    <tr align="left" bgcolor="#e7f0e2" valign="middle">
                                        <td bgcolor="#f3f3f3" class="bodycopy">&nbsp;</td>
                                        <td height="18" colspan="2" valign="middle" bgcolor="#f3f3f3" class="bodyheader">A/P</td>
                                        <td bgcolor="#f3f3f3" valign="top" style="width: 187px">&nbsp;</td>
                                    </tr>
                                    <tr align="left" bgcolor="#e7f0e2" valign="middle">
                                        <td bgcolor="#ffffff" class="bodycopy">&nbsp;</td>
                                        <td bgcolor="#ffffff" class="bodyheader" colspan="2" valign="middle"><span style="width: 187px">
                                            <asp:DropDownList ID="ddlAPAcct" runat="server" CssClass="smallselect" Width="120px" Height="18px"> </asp:DropDownList>
                                        </span></td>
                                        <td bgcolor="#ffffff" valign="top" style="width: 187px">&nbsp;</td>
                                    </tr>
                </table>
                                <br />
                                <table align="center" 
                                    border="0" bordercolor="#89a979" cellpadding="0" cellspacing="0" height="261"
                                    width="648" id="TblCheck" runat="server">
                                    <tr align="left" valign="top">
                                        <td height="34" valign="bottom" width="556">                                        </td>
                                        <td valign="bottom" width="90" style="text-align: center">
                                            <asp:TextBox ID="txtChekNo" runat="server" CssClass="shorttextfield" Width="70px" ForeColor="Black" ReadOnly="True"></asp:TextBox></td>
                                    </tr>
                                    <tr align="left" valign="top">
                                        <td valign="bottom" style="height: 31px; text-align: right;" colspan="2">
                                            <asp:TextBox ID="txtDate" runat="server" CssClass="d_shorttextfield" ForeColor="Black"
                                                ReadOnly="True" Width="70px"></asp:TextBox>
                                            &nbsp;&nbsp;</td>
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
                                                        <asp:TextBox ID="txtAmount" onKeyPress="checkNum()" ReadOnly="true" runat="server" CssClass="readonlyboldright">0.0</asp:TextBox></td>
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
                                                            <asp:TextBox ID="txtMoneyEnglish" runat="server" CssClass="readonly" ReadOnly="True"
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
                                                    <td align="left" valign="bottom" width="6%" style="height: 37px">&nbsp;                                                    </td>
                                                    <td align="left" valign="middle" width="94%" style="height: 37px">
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
            <td style="text-align: left; height: 45px;">
                &nbsp;<div id="pnlToBe" style="width: 100%; height: 2%">
               
                                    <input id="cToBePrint" type="checkbox"  onclick="doPrint(this)" checked="CHECKED" /><input id="sToBePrint" class="bodyheader" name="sToBePrint" style="border-right: medium none;
                                    border-top: medium none; border-left: medium none; border-bottom: medium none"
                                    type="text" value="To Be Printed Later" runat="server" /></div>
            </td>
        </tr>
        <tr>
            <td style="text-align: center">
                <uc1:BillListControl ID="BillListControl1" runat="server" />            </td>
        </tr>
        <tr>
            <td>&nbsp;<asp:HiddenField ID="hVendorAcct" runat="server" Value="0" /><asp:HiddenField ID="hCheckNo" runat="server" Value="0" /><asp:HiddenField ID="hMainCommand" runat="server" Value="0" />
                                <asp:HiddenField ID="hBankBalance" runat="server" Value="0" /><asp:HiddenField ID="hPrint_id" runat="server" Value="0" />                                
                <asp:HiddenField ID="hPrintContinue" runat="server" Value="0" />
            </td>
        </tr>
        <tr>
            <td>            </td>
        </tr>
        
        <tr>
            <td align="center" valign="middle" bgcolor="#d5e8cb" style="border-top: 1px solid #89a979; height: 19px;">
                <asp:Image ID="btnSaveDown" runat="server" ImageUrl="../../ASP/Images/button_smallsave.gif" /></td>
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
       </div>
    </form>
    
    <script type="text/javascript" language="javascript">
	ig_initDropCalendar("CustomDropDownCalendar dDate");
</script>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
