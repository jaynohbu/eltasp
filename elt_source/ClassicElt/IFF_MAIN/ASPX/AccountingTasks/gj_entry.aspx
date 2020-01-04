<%@ Page Language="C#" AutoEventWireup="true" CodeFile="gj_entry.aspx.cs" Inherits="ASPX_AccountingTasks_gj_entry" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="Controls/GJEItemControl.ascx" TagName="GJEItemControl" TagPrefix="uc1" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<script type="text/javascript" src="../jScripts/ig_dropCalendar.js"></script> 
<script type="text/javascript" src="../jScripts/datetimepicker.js"></script>
<script type="text/javascript" language="javascript">

 function changeCounterPart(obj,sibling,counterpart,counterpart_sibling){
    counterpart.value=obj.value;
    sibling.value="0.00";
    counterpart_sibling.value="0.00";
    
 }
 
 function checkBalance(){          
        var debit_amounts=document.getElementById("GJEItemControl1_hDebits").value.split("^^");   
          
        var credit_amounts=document.getElementById("GJEItemControl1_hCredits").value.split("^^");
      
        var total_credit_amount=0;  
        var total_debit_amount=0;  
        try{     
            for(i=0;i<debit_amounts.length-1;i++){  
             
               total_debit_amount+=parseFloat(document.getElementById(debit_amounts[i]).value.replace(",",""));  
                 
            } 
            
            for(j=0;j<credit_amounts.length-1;j++){  
              
               total_credit_amount+=parseFloat(document.getElementById(credit_amounts[j]).value.replace(",","")); 
                    
            }
        }catch(e){
        
        }
        if(total_debit_amount!=total_credit_amount)
        {
            alert("Total amount for debit and credit must be equal");
            return false;        
        }
        return true;   
    }
    
    
 function command(cmd){ 
    document.getElementById("hCommand").value=cmd;
    form1.submit();
 }
 
 function SaveClick(){  
     if(checkBalance())
     {
        if(document.form1.hEntryNo.value!=""){
            document.getElementById("hCommand").value="UPDATE";
        }else{
            document.getElementById("hCommand").value="SAVE";
        }
        form1.submit();
     }
 }
 
 function DeleteClick(){ 
 
    if(document.form1.hEntryNo.value!="")
    {
        document.getElementById("hCommand").value="DELETE";
        form1.submit();
    }
    
 }
    
  function clearSearch(obj){        
           obj.value = ''; 
          // obj.style.color='#000000';         
        }  
    
</script>
<link href="../CSS/elt_css.css" type="text/css" rel="stylesheet"/>
<link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
.style1 {color: #cc6600}
.style2 {color: #FF0000}
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
    </style>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../../CSS/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td width="52%" align="left" valign="middle" class="pageheader">
                    General Journal Entry            </td>
			<td width="48%" align="right" valign="baseline"><span class="labelSearch">ENTRY NO.</span>
                <asp:TextBox value="Search Here" class="lookup" ID="txtSearch" runat="server" CssClass="shorttextfield" ForeColor="Black"
                                    Height="12px"></asp:TextBox><asp:Image ID="btnSearch" runat="server" ImageUrl="../../asp/images/icon_search.gif" ImageAlign="AbsBottom" /><!-- Search -->
			</td>
		</tr>
	</table>
	<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89a979" class="border1px">
        <tr>
            <td height="24" align="center" valign="middle" bgcolor="#d5e8cb" style="border-bottom: 1px solid #89a979">
                <span style=" width: 100%; margin-left: auto; margin-right:auto;">&nbsp;</span><asp:Image ID="btnSaveUpper" runat="server" ImageUrl="~/ASP/Images/button_save_medium.gif" />
            <img name="bDelete" src="../../ASP/Images/button_delete_medium.gif" style="cursor: hand" id="btnDelete" runat="server" /></td>
        </tr>
        <tr>
            <td align="center" bgcolor="#f3f3f3" style="border-bottom: 1px solid #89a979; padding:24px 0 24px 0">
                <table width="72%" border="0" cellpadding="0" cellspacing="0" bordercolor="#89a979" bgcolor="#FFFFFF" 
					class="border1px">
					<tr bgcolor="#E7F0E2">
						<td width="33%" align="left" bgcolor="#E7F0E2" class="bodyheader style1" style="padding-left:10px">Entry No. </td>
						<td width="67%" height="18" align="left" bgcolor="#E7F0E2">
                            <strong>Date</strong></td>
					</tr>
					<tr>
						<td height="22" align="left" valign="middle" style="padding-left: 10px"><input name="textfield" type="text" class="readonlybold" size="16" readonly="true" />
						    <span class="style2">added</span></td>
						<td align="left"><igtxt:WebDateTimeEdit ID="dDate" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                <ButtonsAppearance CustomButtonDisplay="OnRight">                                </ButtonsAppearance>
                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                        </igtxt:WebDateTimeEdit>                        </td>
					</tr>
					<tr align="left" valign="middle">
						<td bgcolor="#89a979" colspan="3" style="height: 2px">						</td>
                    </tr>
					<tr bgcolor="#ffffff">
						<td height="18" colspan="2">
                                <uc1:GJEItemControl ID="GJEItemControl1" runat="server" />                        </td>
					</tr>
            	</table>			
                <span style="width: 80px">
                <asp:HiddenField ID="hCommand" runat="server" />
                <asp:HiddenField ID="hEntryNo" runat="server" />
&nbsp;&nbsp;                </span></td>
        </tr>
        <tr>
            <td height="24" align="center" valign="middle" bgcolor="#d5e8cb">
                                <asp:Image ID="btnSaveDown" runat="server" ImageUrl="~/ASP/Images/button_save_medium.gif" /></td>
        </tr>
    </table>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td width="55%" align="right" valign="bottom" style="height: 23px"><div id="Div1"> 
                <asp:ScriptManager ID="ScriptManager1" runat="server"> </asp:ScriptManager>
                &nbsp;<a href="javascript:;" onclick="" style="cursor: pointer"></a>&nbsp;</div></td>
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
        &nbsp;&nbsp;</div>
    </form>
    <script type="text/javascript" language="javascript">
	ig_initDropCalendar("CustomDropDownCalendar dDate");
</script>
   
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
