<%@ Page language="c#" Inherits="IFF_MAIN.ASPX.Reports.Operation.OceanExportOperationSelection" trace="false" 
CodeFile="OceanexportOperationSelection.aspx.cs" CodePage="65001" %>
<%@ Register TagPrefix="uc1" TagName="rdSelectDateControl1" Src="../SelectionControls/rdSelectDateControl1.ascx" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>AirExportOperationSelection</title>
		<META http-equiv=Content-Type content="text/html; charset=UTF-8">
		<meta content="Microsoft Visual Studio .NET 7.1" name=GENERATOR>
		<meta content=C# name=CODE_LANGUAGE>
		<meta content=JavaScript name=vs_defaultClientScript>
		<meta content=http://schemas.microsoft.com/intellisense/ie5 name=vs_targetSchema>
		<SCRIPT src="../jScripts/ig_dropCalendar.js" type=text/javascript></SCRIPT>
		<SCRIPT src="../jScripts/ig_editDrop1.js" type=text/javascript></SCRIPT>
		<SCRIPT src="../jScripts/WebDateSet1.js" type=text/javascript></SCRIPT>
		<SCRIPT src="../jScripts/WebDateSet2.js" type=text/javascript></SCRIPT>
		<LINK href="../../CSS/AppStyle.css" type=text/css rel=stylesheet>
		
		<script language="javascript" type="text/javascript">
		 function validateDate_Cat()
		{
		  var	Wedit1 = igedit_getById('Webdatetimeedit1')
          var    a=Wedit1.getValue();
          
	      if(!a)  {
	        alert(' Please input the period!');
	        return false;
	      }
	      
	      var	Wedit2 = igedit_getById('Webdatetimeedit2')
          var    a=Wedit2.getValue();
          
	      if(!a)  {
	        alert(' Please input the period!');
	        return false;
	      }
	       var cat=document.getElementById('selectCatagory');
	      if(cat.options.selectedIndex==0){
	        alert(' Please select the catagory!');
	        return false;
	      }
		  return true;			
		}
		function checkAnalOn(obj){
		    
		    var chks=new Array("chkGW","chkCW","chkQT","chkFC");
		   
		    for(var i=0;i<4;i++){
		    
		      if(chks[i]!=obj.id){
		      document.getElementById(chks[i]).checked=false;      
		        
		      }
		    }
		    document.getElementById("ANL").value=document.getElementById(obj.id).value;
		    //alert(document.getElementById("GRP").value);
		}
		
		function selectCatagoryChange(obj){	
		//alert(document.getElementById(obj.id).options[document.getElementById(obj.id).selectedIndex].value);	    
		    
		   document.getElementById("GRP").value=document.getElementById(obj.id).options[document.getElementById(obj.id).selectedIndex].value;
		   
		}
		function checkIfCatagorySelected(){		
		    if(document.getElementById("selectCatagory").value=="None"){
		        return false;
		    }
		    else{ 
		        return true;
		    }
	    }
		</script>
  <!--  #INCLUDE FILE="../../include/common.htm" -->
</HEAD>
	<BODY leftMargin=0 topMargin=0>
		<form id=form1 method=post runat="server">

<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
      <td align="left"><asp:Label ID=Label4 runat="server" Width="100%" CssClass="pageheader">Ocean  Export Operation Report (HOUSE B/L)</asp:Label></td>
  </tr>
</table>				
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
    <td align="left" valign="middle"><table width="100%" border="0" cellpadding="2" cellspacing="0" bordercolor="#939259" class="border1px">
          <tr bgcolor="#e8d9e6"> 
            <td height="8" colspan="6" align="left" valign="middle" bgcolor="#cdcc9d"></td>
          </tr>
		            <tr> 
            <td height="1" colspan="6" align="left" valign="middle" bgcolor="#939259"></td>
          </tr>
		  
          <tr align="center" bgcolor="e8d9e6"> 
            <td colspan="6" valign="middle" bgcolor="#f3f3f3"><br> 
                <table width="60%" border="0" cellpadding="2" cellspacing="0" bordercolor="#939259" class="border1px">
                <tr align="left" valign="middle">
                    <td width="1%" height="22" bgcolor="#f0f0dc">&nbsp;</td>
                    <td width="28%" height="22" bgcolor="#f0f0dc" class="bodyheader"><asp:Label CssClass="bodyheader" ID=Label2 runat="server">Selection Period</asp:Label></td>
                    <td width="31%" height="22" bgcolor="#f0f0dc"><asp:Label CssClass="bodyheader" ID=Label6 runat="server">From</asp:Label></td>
                    <td height="22" bgcolor="#f0f0dc"><asp:Label CssClass="bodyheader" ID=Label1 runat="server" designtimedragdrop="3572">To</asp:Label></td>
                    </tr>
                <tr align="left" valign="middle">
                  <td height="22" bgcolor="#FFFFFF">&nbsp;</td>
                  <td height="22" bgcolor="#FFFFFF" class="bodyheader"><span class="bodycopy" style="text-align: left; width: 120px;">
                      <uc1:rdselectdatecontrol1 id=RdSelectDateControl11  runat="server"></uc1:rdselectdatecontrol1>
                  </span></td>
                  <td height="22" bgcolor="#FFFFFF"><igtxt:webdatetimeedit id=Webdatetimeedit1 accessKey=e runat="server" Width="150px" ForeColor="black"
										Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" ">
                      <BUTTONSAPPEARANCE CustomButtonDisplay="OnRight"></BUTTONSAPPEARANCE>
                      <SPINBUTTONS SpinOnReadOnly="True" Display="OnLeft"></SPINBUTTONS>
                  </igtxt:webdatetimeedit></td>
                  <td height="22" bgcolor="#FFFFFF"><igtxt:webdatetimeedit id=Webdatetimeedit2 accessKey=e runat="server" Width="150px" ForeColor="BLACK"
										DESIGNTIMEDRAGDROP="142" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" ">
                      <BUTTONSAPPEARANCE CustomButtonDisplay="OnRight"></BUTTONSAPPEARANCE>
                      <SPINBUTTONS SpinOnReadOnly="True" Display="OnLeft"></SPINBUTTONS>
                  </igtxt:webdatetimeedit></td>
                  </tr>
                <tr align="left" valign="middle">
                  <td height="2" colspan="4" bgcolor="#939259"></td>
                </tr>
                <tr align="left" valign="middle">
                    <td bgcolor="#f3f3f3" style="height: 22px">&nbsp;</td>
                    <td bgcolor="#f3f3f3" style="height: 22px"><asp:Label CssClass="bodyheader" ID="Label5" runat="server" >Analysis on</asp:Label></td>
                    <td colspan="2" bgcolor="#f3f3f3" class="bodycopy" style="height: 22px">&nbsp;</td>
                </tr>
                <tr align="left" valign="middle"> 
                  <td bgcolor="#FFFFFF" style="height: 22px">&nbsp;</td>
                  <td colspan="3" bgcolor="#FFFFFF" class="bodycopy" style="height: 22px">
                      <input id="chkGW" type="checkbox" name="chkGW" value="Gross Wt."  onClick="checkAnalOn(this)" checked="CHECKED" />
                      Gross Weight &nbsp;&nbsp;
                      <input id="chkCW" type="checkbox" name="chkCW" value="Chargeable Wt." onClick="checkAnalOn(this)"/>
                      Chargeable Weight &nbsp;&nbsp;
                      <input id="chkQT" type="checkbox" name="chkQT" value="Quantity" onClick="checkAnalOn(this)"/>
                      Quantity &nbsp;&nbsp;
                      <input id="chkFC" type="checkbox" name="chkFC" value="Freight Charge" onClick="checkAnalOn(this)"/>
                      Freight Charge &nbsp;&nbsp;
                      <input id="chkFreq" type="checkbox" name="chkFreq" value="Frequency" onClick="checkAnalOn(this)"/>
                      Frequency &nbsp;&nbsp;</td>
                  </tr>
                <tr align="left" valign="middle" bgcolor="f3f3f3">
                    <td height="22">&nbsp;</td>
                    <td height="22"><asp:Label CssClass="bodyheader" ID="Label3" runat="server">Catagorized by</asp:Label></td>
                    <td height="22"><span class="bodyheader">Weight Scale</span></td>
                    <td height="22">&nbsp;</td>
                    </tr>
                <tr align="left" valign="middle" bgcolor="f3f3f3">
                    <td height="22" bgcolor="#FFFFFF">&nbsp;</td>
                    <td height="22" bgcolor="#FFFFFF"><select class="bodycopy"id="selectCatagory" name="selectCatagory" onChange="selectCatagoryChange(this)">
                        <option class="smallselect" selected="selected" value="None">Select</option>
                        <option value="Agent">Agents</option>
                        <option value="Shipper">Shipper</option>
                        <option value="Consignee">Consignee</option>
                        <option value="Origin">Port of Departure</option>
                        <option value="Destination">Port of Destination </option>
                        <option value="Sales Rep.">Sales Persons </option>
                    </select></td>
                    <td height="22" bgcolor="#FFFFFF"><select id="sltWtScale" class="smallselect" name="sltWtScale">
                        <option selected="selected" value="LB">LB</option>
                        <option value="KG">KG</option>
                    </select></td>
						<td width="40%" height="22" align="center" bgcolor="#FFFFFF"><asp:ImageButton ID=iBtnGo runat="server" ImageUrl="../../../images/button_go.gif" OnClick="iBtnGo_Click
									"></asp:ImageButton></td>
						</tr>
              </table>
              <br></td>
          </tr>          
		  <tr bgcolor="#939259"> 
            <td height="1" colspan="6" align="left" valign="middle"></td>
          </tr>
          <tr align="center" bgcolor="#cdcc9d"> 
            <td height="20" colspan="6" valign="middle"><span style="WIDTH: 1px; HEIGHT: 22px">
                <span style="HEIGHT: 22px; width: 898px;">
                <input type="hidden" name="GRP" id="GRP" />
                </span>
                <input type="hidden" name="ANL" id="ANL" value="Gross Wt." />
            </span></td>
          </tr>
          
        </table></td>
  </tr>
</table>		
		
		    <asp:button id=btnValidate runat="server" Visible="False" Text="for Validation"></asp:button>
			<asp:linkbutton id=LinkButton1 runat="server" Visible="False">LinkButton</asp:linkbutton><!-- end -->
<igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="87px" Height="89px">
            <Layout CellPadding="0" FooterFormat="" NextMonthText="&gt;&gt;" PrevMonthText="&lt;&lt;"
                ShowFooter="False" ShowMonthDropDown="False" ShowYearDropDown="False" TitleFormat="Month">
                <DayStyle BackColor="White" CssClass="CalDay" />
                <SelectedDayStyle BackColor="#C5D5FC" CssClass="CalSelectedDay" />
                <OtherMonthDayStyle ForeColor="Silver" />
                <NextPrevStyle CssClass="NextPrevStyle" />
                <CalendarStyle CssClass="CalStyle" Height="89px" Width="87px">
                </CalendarStyle>
                <TodayDayStyle CssClass="CalToday" />
                <DayHeaderStyle CssClass="CalDayHeader" Font-Bold="False">
                    <BorderDetails StyleBottom="None" />
                </DayHeaderStyle>
                <TitleStyle CssClass="TitleStyle" Font-Bold="True" />
            </Layout>
        </igsch:WebCalendar></form>
		<SCRIPT type=text/javascript>
			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1 Webdatetimeedit2");
		</SCRIPT>
	</BODY>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</HTML>
