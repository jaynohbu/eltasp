<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DomesticExportSelection.aspx.cs" Inherits="ASPX_Reports_Operation_DomesticExportSelection" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>AirExportOperationSelection</title>
		<META http-equiv=Content-Type content="text/html; charset=euc-kr">
		<meta content="Microsoft Visual Studio .NET 7.1" name=GENERATOR>
		<meta content=C# name=CODE_LANGUAGE>
		<meta content=JavaScript name=vs_defaultClientScript>
		<meta content=http://schemas.microsoft.com/intellisense/ie5 name=vs_targetSchema>
	
		<SCRIPT src="/IFF_MAIN/ASPX/jScripts/ig_editDrop1.js" type=text/javascript></SCRIPT>	
		<LINK href="/IFF_MAIN/ASPX/CSS/AppStyle.css" type=text/css rel=stylesheet>		
		<script language="javascript" type="text/javascript">
		
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
	    
	    function validateDate_Cat()
		{
		  
	      var cat=document.getElementById('selectCatagory');
	      if(cat.options.selectedIndex==0){
	        alert(' Please select the catagory!');
	        return false;
	      }
		  return true;			
		}
	    
	    
        </script>

         <script src="/Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery-ui-1.8.20.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery.plugin.period.js" type="text/javascript"></script>
     <link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css"
        rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        $(document).ready(function () {
            $("#Webdatetimeedit1").datepicker();
            $("#Webdatetimeedit2").datepicker();
            $("#ddlPeriod").PeriodList({ StartDateField: $("#Webdatetimeedit1").get(0), EndDateField: $("#Webdatetimeedit2").get(0) });
        });
    </script>
  <!--  #INCLUDE FILE="../../include/common.htm" -->
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style></HEAD>
	<BODY>
		<form id=form1 method=post runat="server">
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
      <td align="left"><asp:Label ID=Label4 runat="server" Width="100%" CssClass="pageheader">Operation Report</asp:Label></td>
  </tr>
</table>				
<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
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
                  <td width="2%" height="22" bgcolor="#f0f0dc">&nbsp;</td>
                  <td width="32%" height="22" bgcolor="#f0f0dc">
                      <asp:Label CssClass="bodyheader" ID=Label2 runat="server">Selection Period</asp:Label></td>
                  <td width="29%" height="22" bgcolor="#f0f0dc"><asp:Label CssClass="bodyheader" ID=Label6 runat="server">From</asp:Label></td>
                  <td width="37%" height="22" bgcolor="#f0f0dc"><asp:Label CssClass="bodyheader" ID=Label1 runat="server" designtimedragdrop="3572">To</asp:Label></td>
                  </tr>
                <tr align="left" >
                    <td height="22" bgcolor="#FFFFFF">&nbsp;</td>
                    <td height="22" bgcolor="#FFFFFF" class="bodyheader"><span class="bodycopy" style="text-align: left; width: 120px;">
                          <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="ddlPeriod" />

                    </span></td>
                    <td height="22" bgcolor="#FFFFFF"> <asp:TextBox runat="server" ID="Webdatetimeedit1"></asp:TextBox></td>
                    <td height="22" bgcolor="#FFFFFF"> <asp:TextBox runat="server" ID="Webdatetimeedit2"></asp:TextBox></td>
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
						<td height="22" align="center" valign="middle" bgcolor="#FFFFFF"><asp:ImageButton ID=iBtnGo runat="server" ImageUrl="../../../images/button_go.gif" OnClick="iBtnGo_Click"></asp:ImageButton></td>
						</tr>
              </table>
              <br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
              </td>
          </tr>          
		  <tr bgcolor="#939259"> 
            <td height="1" colspan="6" align="left" valign="middle"></td>
          </tr>
          <tr align="center" bgcolor="#cdcc9d"> 
            <td height="20" colspan="6" valign="middle">
                <input type="hidden" name="GRP" id="GRP" />
                <input type="hidden" name="ANL" id="ANL" value="Gross Wt." />
                </td>
          </tr>
          
        </table></td>
  </tr>
</table>		
			<asp:button id=btnValidate runat="server" Visible="False" Text="for Validation"></asp:button>
			<asp:LinkButton ID=LinkButton1 runat="server" Visible="False">LinkButton</asp:LinkButton>
			<!-- end -->
</form>
		
	</BODY>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</HTML>

