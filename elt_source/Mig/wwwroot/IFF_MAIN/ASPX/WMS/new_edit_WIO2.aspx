<%@ Page Language="C#" AutoEventWireup="true" CodeFile="new_edit_WIO2.aspx.cs" Inherits="ASPX_WMS_new_edit_WIO2" CodePage="65001" %>
<%@ Register Assembly="iMoon.WebControls.ComboBox" Namespace="iMoon.WebControls"
    TagPrefix="iMoon" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="uc1" TagName="rdSelectDateControl0" Src="../SelectionControls/rdSelectDateControl0.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Warehouse In & Out Report</title>
    <meta http-equiv="Content-Type" content="text/html; UTF-8" />
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
	        text-overflow:ellipsis;
	        overflow:hidden;
	        white-space:nowrap;
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
         function showHAWB(arg)
        {
            url ="/IFF_MAIN/ASP/domestic/new_edit_hawb.asp?WindowName=popUpWindow&mode=search&HAWB=" + encodeURIComponent(arg)+ "&WindowName=popUpWindow";
            window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=0,width=900,height=600');
        }
        function goCustomerScreen(cus_acct) 
        {
            url ="/IFF_MAIN/ASP/master_data/client_profile.asp?Action=filter&n=" + cus_acct + "&WindowName=popUpWindow";
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
            var url;
           url ="/IFF_MAIN/ASP/Domestic/new_edit_mawb.asp?Edit=yes&mawb=" + encodeURIComponent(MAWB) + "&WindowName=popUpWindow";
           window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=0,width=900,height=600');
        }
        
       function jPopUpNormal(){
            var argS = 'menubar=1,toolbar=1,height=400,width=780,hotkeys=0,scrollbars=1,resizable=1';
            popUpWindow = window.open('','popUpWindow', argS);
        }
        
			
      function goSOScreen(orgnum_g,orgname_g) {
               if(orgname_g != "")
               {
                   url ="/IFF_MAIN/ASP/WMS/shipout_detail.asp?mode=Reload&o=" + encodeURIComponent(orgname_g) + "&n=" + orgnum_g + "&op=OPEN&WindowName=popUpWindow";
                   window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
               }
			}	
        function goWRScreen(orgnum,orgname) {
               url ="/IFF_MAIN/ASP/WMS/warehouse_receipt.asp?o=" + encodeURIComponent(orgname_g) + "&n=" + orgnum + "&WindowName=popUpWindow";
               window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
			}
       function searchNumFill(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_warehouse_receipt.asp?mode=list&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            
            url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_warehouse_receipt.asp?mode=list";
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
       
       function searchNumFillAll2(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);

            url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_shipout.asp?mode=list2";
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
       function searchNumFill2(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_shipout.asp?mode=list&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
         function lstAccountOfChange2(ANum,AName){
            var AdivObj = document.getElementById("lstAccountOfNameDiv");
		    var AhiddenObj = document.getElementById("hAccountOfAcct");
		    var AtxtObj = document.getElementById("lstAccountOfName");

		    AhiddenObj.value = ANum;

		    AtxtObj.value = AName;
		    AdivObj.style.position = "absolute";
		    AdivObj.style.visibility = "hidden";
		    AdivObj.innerHTML = "";		
	    }
        function lstSearchNumChange(argV,argL){
            var divObj = document.getElementById("lstSearchNumDiv");
		    var hiddenObj = document.getElementById("hSearchNum");
		    var txtObj = document.getElementById("lstSearchNum");	
       
            hiddenObj.value = argV;
		    txtObj.value = argL;	    
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
        }
        
        function lstSearchNumChange2(argV,argL){
            var divObj = document.getElementById("lstShipOutDiv");
		    var hiddenObj = document.getElementById("hShipOut");
		    var txtObj = document.getElementById("lstShipOut");	
       

            hiddenObj.value = argV;
		    txtObj.value = argL;	    
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
        }
    </script>

    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
</head>
<body link="336699" vlink="336699" topmargin="0" onLoad="self.focus(); ">
    <form runat="server" id="form1" >
        <input type="image" style="position:absolute; visibility:hidden" onclick="return false;" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" height="32" align="left" valign="middle" class="pageheader">
                    In & Out Report
                </td>
                
            </tr>
        </table>
        <div class="selectarea">
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#9e816e"
            bgcolor="#9e816e" class="border1px">
            <tr>
                <td>
                    <!--// -->
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr bgcolor="#F2DEBF">
                            <td height="8" align="center" valign="middle" bgcolor="#e5cfbf" class="bodyheader">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="9" bgcolor="#9e816e" style="height: 1px">
                            </td>
                        </tr>
                        <tr align="center">
                            
                            <td valign="top" bgcolor="#f3f3f3" class="bodycopy" style="padding: 34px 34px 24px">
                            
                                <table width="54%" border="0" cellpadding="0" cellspacing="0" bordercolor="#9e816e"
                                    bgcolor="#FFFFFF" class="border1px" style="padding-left: 10px">

                                    <tr class="bodyheader">
                                      <td align="left" bgcolor="#f4e9e0" style="height: 18px; width: 147px;">
                                           Period</td>
                                        <td width="8%" align="left" bgcolor="#f4e9e0" style="height: 18px">From</td>
                                        <td width="12%" align="left"  bgcolor="#f4e9e0" style="height: 18px">
                                        <table>
                                        <tr class="bodyheader">
                                         <td width="9%"align="left" valign="middle" bgcolor="#f4e9e0" style="height: 18px"">
                                            To</td>
                                        <td width="11%" align="left" valign="middle" bgcolor="#f4e9e0" style="height: 18px"">
                                            </td>
                                            </tr>
                                        
                                        </table>
                                        </td>
                                        <td width="12%" align="left"  bgcolor="#f4e9e0" style="height: 18px"  >
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top" style="width: 147px" ><uc1:rdselectdatecontrol0 id=RdSelectDateControl11 runat="server"></uc1:rdselectdatecontrol0></td> 
                                                    <td style="height: 18px" align="left">
                                                        <igtxt:webdatetimeedit id=Webdatetimeedit1 accessKey=e runat="server" ForeColor="Black" Width="120px"
											                Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" " Height="17px">
											                <ButtonsAppearance CustomButtonDisplay="OnRight"></ButtonsAppearance>
											                <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
										                </igtxt:webdatetimeedit>
                                                    </td>
                                                    <td style="height: 18px" align="left">
                                                        <igtxt:webdatetimeedit id=Webdatetimeedit2 accessKey=e runat="server" ForeColor="Black" Width="120px" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" " Height="17px">
                                                            <ButtonsAppearance CustomButtonDisplay="OnRight">                                        </ButtonsAppearance>
                                                            <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                                        </igtxt:WebDateTimeEdit>
                                                    </td>
                                                    </tr>
                                  <tr>            
                            <td height="2" align="left" valign="middle" bgcolor="#9e816e" colspan="4"></td>
                        </tr>
                        <tr class="bodyheader">
                            <td height="18" colspan="2" align="left" bgcolor="#f3f3f3"> Customer</td>
                            <td align="left" bgcolor="#f3f3f3">Print Document Type</td>
                            <td align="left" bgcolor="#f3f3f3">&nbsp;</td>
                        </tr>
                        <tr>
                            <td height="24" colspan="2" align="left"><!-- Start JPED -->
                                    <asp:HiddenField ID="hAccountOfAcct" runat="server" Value="" />
                                    <div id="lstAccountOfNameDiv"> </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td style="height: 18px; width: 244px;"><!--<%=Request.Params.Get("orgName") %>-->
                                                    <input type="text" autocomplete="off" id="lstAccountOfName" name="lstAccountOfName"
                                                value="<%=Request.Form.Get("lstAccountOfName") %>" class="shorttextfield" style="width: 240px;
                                                border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9;
                                                border-right: 0px solid #7F9DB9; color: Black" onkeyup="organizationFill(this,'','lstAccountOfChange2')"
                                                onfocus="initializeJPEDField(this);" language="javascript" onclick="return lstAccountOfName_onclick()" /></td>
                                            <td style="height: 18px"><img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstAccountOfName','','lstAccountOfChange2')"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: pointer;" /></td>
                                
                                        </tr>
                                </table>
                                </td>
                                <td align="left">
                                <asp:dropdownlist ID="PDFPrint" runat=server CssClass="bodycopy" >
                                    <asp:ListItem Value="WRINOUT" Text="Warehouse In & Out" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="WRIN" Text="Warehouse In Only"></asp:ListItem>
                                    <asp:ListItem Value="WROUT" Text="Warehouse Out Only"></asp:ListItem>
                                    </asp:dropdownlist>
                                </td>
                        </tr>
                        <tr>
                            <td height="1" align="left" valign="middle" bgcolor="#9e816e" colspan="4"></td>
                        </tr>
                        <tr class="bodyheader">
                            <td height="18" align="left" bgcolor="#f3f3f3">Warehouse Receipt No.</td>
                            <td align="left" bgcolor="#f3f3f3" style="width: 147px">&nbsp;</td>
                            <td align="left" bgcolor="#f3f3f3" style="border-left: 1px solid #9e816e">Ship Out No. </td>
                            <td bgcolor="#f3f3f3">&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" class="bodycopy"><table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td><asp:HiddenField ID="hSearchNum" runat="server" Value="" />
                                                <!--<input type="hidden" id="hSearchNum" name="hSearchNum" />-->
                                                <div id="lstSearchNumDiv"> </div>
                                            <!--<input type="text"-->
                                                <asp:TextBox ID="lstSearchNum" runat="server" autocomplete="off" class="shorttextfield"
                                                style="width: 106px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: Black"
                                                onkeyup=" searchNumFill(this,'lstSearchNumChange','');" onfocus="initializeJPEDField(this);"></asp:TextBox></td>
                                        <td style="width: 16px"><img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                    </tr>
                            </table></td>
                            <td align="left" valign="top" class="bodycopy" style="width: 147px">&nbsp;</td>
                            <td colspan="2" align="left" class="bodycopy" style="border-left: 1px solid #9e816e"><table border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td ><asp:HiddenField ID="hShipOut" runat="server" Value="" />
                                                <div id="lstShipOutDiv"></div>
                                            <!--<input type="text"-->
                                                <asp:TextBox ID="lstShipOut" runat="server" autocomplete="off" class="shorttextfield"
                                                style="width: 106px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: Black"
                                                onkeyup=" searchNumFill2(this,'lstSearchNumChange2','');" onfocus="initializeJPEDField(this);"></asp:TextBox></td>
                                         <td style="width: 16px"><img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll2('lstShipOut','lstSearchNumChange2',200);"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: pointer;" /></td>
                                    </tr>
                            </table></td>
                        </tr>
                        <tr class="bodyheader">
                            <td height="18" align="left" bgcolor="#f3f3f3">Customer Reference No.</td>
                            <td align="left" bgcolor="#f3f3f3" style="width: 147px">P.O. No.</td>
                            <td align="left" valign="middle" style="border-left: 1px solid #9e816e">
                            <table>
                                <tr>
                                    <td align="left" bgcolor="#f3f3f3" style="width: 125px">Customer Reference No.</td>
                                    <td align="left" bgcolor="#f3f3f3" style="width: 130px">P.O. No. </td>
                                 </tr>
                            </table>
                            </td>
                        </tr>
                        <tr>
                            <td height="22" align="left" valign="middle"><asp:TextBox ID="txtCustomerRef" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                            <td align="left" valign="middle" style="padding-right:12px; width: 147px;" ><asp:TextBox ID="txtPO" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                            <td align="left" valign="middle" style="border-left: 1px solid #9e816e">
                            <table>
                                <tr>
                                    <td align="left" bgcolor="#f3f3f3" style="width: 130px"><asp:TextBox ID="txtCustomerRef2" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                                    <td align="left" valign="middle" style="padding-right:12px"><asp:TextBox ID="txtPO2" runat="server" CssClass="m_shorttextfield" style="width: 120px"></asp:TextBox></td>
                                </tr>
                            </table>
                            
                            </td>
                        </tr>
                                    <tr>
                                        <td bgcolor="#f3f3f3" style="height: 24px">
                                        </td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="height: 24px; width: 147px;">
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
            <tr style="background-color:#f3f3f3">
            <td>
            <table>
            <tr>
            <td style="width: 1010px">
            <asp:ImageButton ID="ExcelPrintButton" runat="server" ImageUrl="../../Images/button_exel.gif"
                                    OnClick="ExcelPrintButton_Click"></asp:ImageButton>
            <asp:ImageButton ID="PDFPrintButton" runat="server" ImageUrl="../../Images/button_pdf.gif"
                                    OnClick="PDFPrintButton_Click" CssClass="marginleft"></asp:ImageButton>
                                    <asp:TextBox ID="sortway" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                    <asp:TextBox ID="sortway2" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>                           
                                     <asp:TextBox ID="sortwayB" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                    <asp:TextBox ID="sortway2B" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>  
                </td>
                <td>
                    <span class="style15">Sort by</span>
                    <asp:DropDownList runat="server" ID="lstSortBy" CssClass="bodycopy" Width="120px" AutoPostBack="true" onSelectedIndexChanged="Page_change">
            
                        <asp:ListItem Text="W/R No" Value="WR" Selected="true"/>
                        <asp:ListItem Text="S/O No" Value="SO" />
                    </asp:DropDownList>
                </td>
                </tr>
                </table>
                </td>
            </tr>
            <tr>
                <td align="left" bgcolor="#f3f3f3">
                      <div>
                        <asp:GridView ID="GridViewSoSort" runat="server" AllowPaging="False" AutoGenerateColumns="False"
                            OnPageIndexChanging="GridViewSoSort_PageIndexChanging" Width="100%" BorderWidth="0px"
                            BorderStyle="None" CellPadding="0">
                            <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%"><tr><td>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="30" style="padding-left: 10px" bgcolor="#f4e9e0" height="24">
                                                    <span class="style15">SORT BY S/O No</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr class="bodyheader" bgcolor="#f3f3f3">
                                                <td width="12" rowspan="2" align="left" height="13"></td>
                                                <td width="8%" rowspan="2" align="left">Received Date <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="Date_Click" ID="WR_Sort1" /></td>
                                                <td width="8%" rowspan="2" align="left">W/R No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="WR2_Click" ID="WR_Sort3" /></td>
                                                <td width="19%" rowspan="2" align="left"> Customer</td>
                                                <td width="10%" rowspan="2" align="left"> Customer Ref No.</td>
                                                <td width="9%" rowspan="2" align="left"> P.O. No.</td>
                                                <td width="19%" rowspan="2" align="left"> Received From </td>
                                                <td width="19%" rowspan="2" align="left"> Descriptions</td>
                                                <td width="7%" align="center" style="border-left: 1px solid #9e816e"> NO. OF QTY</td>
                                            </tr>
                                            <tr class="bodyheader" bgcolor="#f3f3f3">
                                                <td width="7%" align="center" style="border-top: 1px solid #9e816e; border-left: 1px solid #9e816e"
                                                            height="13"><span class="style3">Received</span></td>
                                            </tr>
                                            <tr>
                                                <td height="1" align="left" valign="middle" bgcolor="#9e816e" colspan="9"></td>
                                            </tr>
                                        </table>
                                        </td></tr></table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <div class="bodyheader" style="padding-left: 14px; padding-top: 6px; background: #ffffff">
                                             <a href="javascript:;" onClick="goSOScreen('<%# Eval("auto_uid").ToString() %>','<%# Eval("sort_value").ToString() %>')"><%# Eval("sort_value").ToString()%></a>
                                        </div>
                                        <div>
                                            <asp:GridView ID="GridViewSoDetail" runat="server" AllowPaging="False" AutoGenerateColumns="False" OnPageIndexChanging="GridViewSoDetail_PageIndexChanging"
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
                                                            <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                                    <tr id='Row<%# Eval("auto_uid").ToString() %>'>
                                                                        <td width="12" align="left" height="20"><input type="hidden" name="hWRNum" value="<%# Eval("wr_num").ToString() %>" />
                                                                        <input type="hidden" name="hWRValue" value="<%# Eval("auto_uid").ToString() %>" /></td>
                                                                        <td width="8%" align="left" ><%# Eval("received_date","{0:d}").ToString() %> </td>
                                                                        <td width="8%" align="left" class="searchList"><a href="javascript:;" onClick="goWRScreen('<%# Eval("auto_uid").ToString() %>','<%# Eval("wr_num").ToString() %>')"><%# Eval("wr_num").ToString() %></a></td>
                                                                        <td width="19%" align="left" class="searchList"><a href="javascript:;" onClick="goCustomerScreen('<%# Eval("customer_acct").ToString() %>')"><%# Eval("customer_name").ToString() %></a> </td>
                                                                        <td width="10%" align="left"><%# Eval("customer_ref_no").ToString() %> </td>
                                                                        <td width="9%" align="left"><%# Eval("PO_NO").ToString() %> </td>
                                                                        <td width="19%" align="left" class="searchList"><a href="javascript:;" onClick="goCustomerScreen('<%# Eval("shipper_acct").ToString() %>')"><%# Eval("rec_name").ToString() %></a> </td>
                                                                        <td width="19%" align="left"><%# Eval("item_desc").ToString()%> </td>
                                                                        <td width="7%" align="right" style="padding-right: 10px" class="bodyheader"><%# Eval("item_piece_origin").ToString()%> </td>
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
                        <asp:GridView ID="GridViewSoSortCustomer" runat="server" AllowPaging="False" AutoGenerateColumns="False"
                            OnPageIndexChanging="GridViewSoSortCustomer_PageIndexChanging" Width="100%" BorderWidth="0px"
                            BorderStyle="None" CellPadding="0">
                            <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%"><tr><td>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="30" style="padding-left: 10px" bgcolor="#f4e9e0" height="24">
                                                    <span class="style15">Sort BY W/R No</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                            </tr>
                                          </table>
                                     <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr class="bodyheader" bgcolor="#f3f3f3">
                                                <td width="6" rowspan="2" align="left" height="13"></td>
                                                <td width="13%" rowspan="2" align="left">Received Date <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="Date_Click" ID="WR_Sort2" /></td>
                                                <td width="13%" rowspan="2" align="left">W/R No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="WR2_Click" ID="WR_Sort3" /></td>
                                                <td width="13%" rowspan="2" align="left"> Customer Ref No.</td>
                                                <td width="15%" rowspan="2" align="left"> P.O. No.</td>
                                                <td width="19%" rowspan="2" align="left"> Received From </td>
                                                <td width="15%" rowspan="2" align="left"> Descriptions</td>
                                                <td width="8%" align="center" style="border-left: 1px solid #9e816e"> NO. OF QTY</td>
                                            </tr>
                                            <tr class="bodyheader" bgcolor="#f3f3f3">
                                                <td width="7%" align="center" style="border-top: 1px solid #9e816e; border-left: 1px solid #9e816e"
                                                            height="13"><span class="style3">Received</span></td>
                                            </tr>
                                            <tr>
                                                <td height="1" align="left" valign="middle" bgcolor="#9e816e" colspan="9"></td>
                                            </tr>
                                            <tr>
                                                <td height="3" align="left" valign="middle" bgcolor="#ffffff" colspan="9"></td>
                                            </tr>
                                             <tr>
                                                
                                                <td height="3" align="left" style="padding-left: 8px" valign="middle" bgcolor="#ffffff" colspan="9"><a href="javascript:;" onClick="goCustomerScreen('<%# GetCustomerNo() %>')"><%# GetCustomer() %></a></td>
                                            </tr>
                                
                                        </table>
                                        </td></tr></table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <div class="bodyheader" style="padding-left: 14px; padding-top: 6px; background: #ffffff">
                                             <a href="javascript:;" onClick="goSOScreen('<%# Eval("auto_uid").ToString() %>','<%# Eval("sort_value").ToString() %>')"><%# Eval("sort_value").ToString()%></a>
                                        </div>
                                        <div>
                                            <asp:GridView ID="GridViewSoDetailCustomer" runat="server" AllowPaging="False" AutoGenerateColumns="False" OnPageIndexChanging="GridViewSoDetailCustomer_PageIndexChanging"
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
                                                             <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                                    <tr id='Row<%# Eval("auto_uid").ToString() %>'>
                                                                        <td width="6" align="left" height="20"><input type="hidden" name="hWRNum" value="<%# Eval("wr_num").ToString() %>" />
                                                                        <input type="hidden" name="hWRValue" value="<%# Eval("auto_uid").ToString() %>" /></td>
                                                                        <td width="13%" align="left" ><%# Eval("received_date","{0:d}").ToString() %> </td>
                                                                        <td width="13%" align="left" class="searchList"><a href="javascript:;" onClick="goWRScreen('<%# Eval("auto_uid").ToString() %>','<%# Eval("wr_num").ToString() %>')"><%# Eval("wr_num").ToString() %></a></td>
                                                                        <td width="13%" align="left"><%# Eval("customer_ref_no").ToString() %> </td>
                                                                        <td width="15%" align="left"><%# Eval("PO_NO").ToString() %> </td>
                                                                        <td width="19%" align="left" class="searchList"><a href="javascript:;" onClick="goCustomerScreen('<%# Eval("shipper_acct").ToString() %>')"><%# Eval("rec_name").ToString() %></a> </td>
                                                                        <td width="15%" align="left"><%# Eval("item_desc").ToString()%> </td>
                                                                        <td width="8%" align="right" style="padding-right: 10px" class="bodyheader"><%# Eval("item_piece_origin").ToString()%> </td>
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
                        <asp:GridView ID="GridViewWRSort" runat="server" AllowPaging="False" AutoGenerateColumns="False"
                            OnPageIndexChanging="GridViewWRSort_PageIndexChanging" Width="100%" BorderWidth="0px"
                            BorderStyle="None" CellPadding="0">
                            <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%"><tr><td>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="30" style="padding-left: 10px" bgcolor="#f4e9e0" height="24">
                                                    <span class="style15">Sort BY W/R No</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                            </tr>
                                          </table>
                                       <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr class="bodyheader" align="left" bgcolor="#f3f3f3">
                                            <td width="12" height="13" rowspan="2" align="left">
                                            </td>
                                            <td width="10%" rowspan="2" align="left">
                                                Ship Out Date <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="SODate_Click" ID="SO_Sort1" /></td>
                                            <td width="10%" rowspan="2" align="left">
                                                Ship Out No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="SO_Click" ID="SOSort1" /></td>
                                            <td width="21%" rowspan="2" align="left">
                                                Customer</td>
                                            <td width="12%" rowspan="2" align="left">
                                                Customer Ref No.</td>
                                            <td width="12%" rowspan="2" align="left">
                                                P.O NO.</td>														
                                            <td width="22%" rowspan="2" align="left">
                                                Descriptions</td>
                                            <td colspan="2" align="center" style="border-left: 1px solid #9e816e">
                                                NO. OF QTY
                                            </td>
                                        </tr>
                                        <tr class="bodyheader" align="left" bgcolor="#f3f3f3">
                                            <td width="6%" align="center" style="border-left: 1px solid #9e816e; border-top: 1px solid #9e816e">
                                                Ship Out
                                            </td>
                                            <td width="6%" align="center" style="border-left: 1px solid #9e816e; border-top: 1px solid #9e816e">
                                                <span class="style1">On-Hand </span>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td height="1" align="left" valign="middle" bgcolor="#9e816e" colspan="13">
                                            </td>
                                        </tr>
                                    </table>
                                        </td></tr></table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <div class="bodyheader" style="padding-left: 14px; padding-top: 6px; background: #ffffff">
                                             <a href="javascript:;" onClick="goWRScreen('<%# Eval("auto_uid").ToString() %>','<%# Eval("sort_value").ToString() %>')"><%# Eval("sort_value").ToString()%></a>
                                        </div>
                                        <div>
                                            <asp:GridView ID="GridViewWRDetail" runat="server" AllowPaging="False" AutoGenerateColumns="False" OnPageIndexChanging="GridViewWRDetail_PageIndexChanging"
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
                                                            <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">

                                                            <tr id='Row<%# Eval("auto_uid").ToString() %>'>
                                                                <td width="12" align="left" height="20">
                                                                    <input type="hidden" name="hWRNum" value="<%# Eval("wr_num").ToString() %>" />
                                                                    <input type="hidden" name="hWRValue" value="<%# Eval("auto_uid").ToString() %>" />
                                                                    <!-- Eval("item_piece_origin-item_shipout").ToString() %>  -->
                                                                </td>
                                                                <td width="10%" align="left" >
                                                                <%# Eval("shipout_date","{0:d}").ToString() %></td>
                                                                <td width="10%" align="left" class="searchList">
                                                                <a href="javascript:;" onClick="goSOScreen('<%# Eval("so_uid").ToString() %>','<%# Eval("so_no").ToString() %>')"><%#GetShipout( Eval("so_no").ToString()) %></a></td>
                                                                <td width="21%" align="left" class="searchList">
                                                                   <a href="javascript:;" onClick="goCustomerScreen('<%# Eval("customer_acct").ToString() %>')"><%# Eval("customer_name").ToString() %></a></td> 
                                                                <td width="12%" align="left">
                                                                    <%# Eval("customer_ref").ToString() %>
                                                                </td>
                                                                <td width="12%" align="left">
                                                                    <%# Eval("PONO").ToString() %>
                                                                </td>

                                                                <td width="20%" align="left">
                                                                    <%# Eval("item_desc").ToString()%>
                                                                </td>

                                                                <td width="7%" align="right" class="bodyheader" style="padding-right: 6px">
                                                                    <%# Eval("item_shipout").ToString() %>
                                                                </td>
                                                                <td width="7%" align="right" style="padding-right: 6px">
                                                                    <%# Eval("item_remain").ToString()%>
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
                        <asp:GridView ID="GridViewWRSortCustomer" runat="server" AllowPaging="False" AutoGenerateColumns="False"
                            OnPageIndexChanging="GridViewWRSortCustomer_PageIndexChanging" Width="100%" BorderWidth="0px"
                            BorderStyle="None" CellPadding="0">
                            <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%"><tr><td>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="30" style="padding-left: 10px" bgcolor="#f4e9e0" height="24">
                                                    <span class="style15">Sort BY W/R No</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                                <td height="1" colspan="13" bgcolor="#9e816e">
                                                </td>
                                            </tr>
                                          </table>
                                       <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr class="bodyheader" align="left" bgcolor="#f3f3f3">
                                            <td width="12" height="13" rowspan="2" align="left">
                                            </td>
                                            <td width="15%" rowspan="2" align="left">
                                                Ship Out Date<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="SODate_Click" ID="SO_Sort2" /></td>
                                            <td width="15%" rowspan="2" align="left">
                                                Ship Out No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="SO_Click" ID="SOSort2" /></td>
                                            <td width="17%" rowspan="2" align="left">
                                                Customer Ref No.</td>
                                            <td width="17%" rowspan="2" align="left">
                                                P.O NO.</td>														
                                            <td width="22%" rowspan="2" align="left">
                                                Descriptions</td>
                                            <td colspan="3" align="center" style="border-left: 1px solid #9e816e">
                                                NO. OF QTY
                                            </td>
                                        </tr>
                                        <tr class="bodyheader" align="left" bgcolor="#f3f3f3">
                                            <td width="6%" align="center" style="border-left: 1px solid #9e816e; border-top: 1px solid #9e816e">
                                                Ship Out
                                            </td>
                                            <td width="6%" align="center" style="border-left: 1px solid #9e816e; border-top: 1px solid #9e816e">
                                                <span class="style1">On-Hand </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="1" align="left" valign="middle" bgcolor="#9e816e" colspan="13">
                                            </td>
                                        </tr>
                                           <tr>
                                                <td height="2" align="left" style="padding-left: 8px" valign="middle" bgcolor="#ffffff" colspan="11">
                                                <a href="javascript:;" onClick="goCustomerScreen('<%# GetCustomerNo() %>')"><%# GetCustomer() %></a> </td>
                                            </tr>
                                    </table>
                                        </td></tr></table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <div class="bodyheader" style="padding-left: 14px; padding-top: 6px; background: #ffffff">
                                             <a href="javascript:;" onClick="goWRScreen('<%# Eval("auto_uid").ToString() %>','<%# Eval("sort_value").ToString() %>')"><%# Eval("sort_value").ToString()%></a>
                                        </div>
                                        <div>
                                            <asp:GridView ID="GridViewWRCustomerDetail" runat="server" AllowPaging="False" AutoGenerateColumns="False" OnPageIndexChanging="GridViewWRCustomerDetail_PageIndexChanging"
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
                                                            <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">

                                                            <tr id='Row<%# Eval("auto_uid").ToString() %>'>
                                                                <td width="12" align="left" height="20">
                                                                    <input type="hidden" name="hWRNum" value="<%# Eval("wr_num").ToString() %>" />
                                                                    <input type="hidden" name="hWRValue" value="<%# Eval("auto_uid").ToString() %>" />
                                                                    <!-- Eval("item_piece_origin-item_shipout").ToString() %>  -->
                                                                </td>
                                                                <td width="15%" align="left" >
                                                                <%# Eval("shipout_date","{0:d}").ToString() %></td>
                                                                <td width="15%" align="left" class="searchList">
                                                                <a href="javascript:;" onClick="goSOScreen('<%# Eval("so_uid").ToString() %>','<%# Eval("so_no").ToString() %>')"><%#GetShipout( Eval("so_no").ToString()) %></a></td>
                                                              
                                                                <td width="17%" align="left">
                                                                    <%# Eval("customer_ref").ToString() %>
                                                                </td>
                                                                <td width="17%" align="left">
                                                                    <%# Eval("PONO").ToString() %>
                                                                </td>

                                                                <td width="22%" align="left">
                                                                    <%# Eval("item_desc").ToString()%>
                                                                </td>

                                                                <td width="6%" align="right" class="bodyheader" style="padding-right: 6px">
                                                                    <%# Eval("item_shipout").ToString() %>
                                                                </td>
                                                                <td width="6%" align="right" style="padding-right: 6px">
                                                                    <%# Eval("item_remain").ToString()%>
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
                     <asp:GridView ID="GridView2" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                        OnPageIndexChanging="GridView2_PageIndexChanging" 
                        Width="100%" BorderWidth="0px" BorderStyle="None" CellPadding="0">
                    <PagerSettings Position="Top" />
                    <pagerstyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                            BackColor="White" ForeColor="Black" />                
                    <headerstyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />                
                    <RowStyle BackColor="White" BorderStyle="None" />
                    <AlternatingRowStyle BackColor="#F3F3F3" />
                    <columns>
                    <asp:TemplateField>
                        <headertemplate>
                            <!-- list header -->
                            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                <tr class="bodyheader" bgcolor="#f3f3f3">
                                    <td width="12" rowspan="2" align="left" height="13"></td>
                                    <td width="12%" rowspan="2" align="left">Not Shipout Warehouse</td>
                                    <td width="87%" rowspan="2" align="left"></td>
                                </tr>
                            </table>
                        </headertemplate>
                        <itemtemplate>
                            <!-- list item -->
                            <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                            <tr >
                                   <td width="12" align="left" height="20"><input type="hidden" name="hWRNum" value="<%# Eval("wr_num").ToString() %>" />
                                    <input type="hidden" name="hWRValue" value="<%# Eval("auto_uid").ToString() %>" /></td>
                                    <td width="8%" align="left" ><%# Eval("received_date","{0:d}").ToString() %> </td>
                                    <td width="8%" align="left" class="searchList"><a href="javascript:;" onClick="goWRScreen('<%# Eval("auto_uid").ToString() %>','<%# Eval("wr_num").ToString() %>')"><%# Eval("wr_num").ToString() %></a></td>
                                    <td width="19%" align="left" class="searchList"><a href="javascript:;" onClick="goCustomerScreen('<%# Eval("customer_acct").ToString() %>')"><%# Eval("customer_name").ToString() %></a> </td>
                                    <td width="10%" align="left"><%# Eval("customer_ref_no").ToString() %> </td>
                                    <td width="9%" align="left"><%# Eval("PO_NO").ToString() %> </td>
                                    <td width="19%" align="left" class="searchList"><a href="javascript:;" onClick="goCustomerScreen('<%# Eval("shipper_acct").ToString() %>')"><%# Eval("rec_name").ToString() %></a> </td>
                                    <td width="19%" align="left"><%# Eval("item_desc").ToString()%> </td>
                                    <td width="7%" align="right" style="padding-right: 10px" class="bodyheader"><%# Eval("item_piece_origin").ToString()%> </td>
                                </tr>
                            </table>
                        </itemtemplate>
                    </asp:TemplateField>
                    </columns>
                </asp:GridView>
                    </div>
                    <div>
                     <asp:GridView ID="GridView3" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                        OnPageIndexChanging="GridView3_PageIndexChanging" 
                        Width="100%" BorderWidth="0px" BorderStyle="None" CellPadding="0">
                    <PagerSettings Position="Top" />
                    <pagerstyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                            BackColor="White" ForeColor="Black" />                
                    <headerstyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />                
                    <RowStyle BackColor="White" BorderStyle="None" />
                    <AlternatingRowStyle BackColor="#F3F3F3" />
                    <columns>
                    <asp:TemplateField>
                        <headertemplate>
                            <!-- list header -->
                            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                <tr class="bodyheader" bgcolor="#f3f3f3">
                                    <td width="12" rowspan="2" align="left" height="13"></td>
                                    <td width="12%" rowspan="2" align="left">Not Shipout Warehouse</td>
                                    <td width="87%" rowspan="2" align="left"></td>
                                </tr>
                            </table>
                        </headertemplate>
                        <itemtemplate>
                            <!-- list item -->
                            <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                            <tr >
                                   <td width="6" align="left" height="20"><input type="hidden" name="hWRNum" value="<%# Eval("wr_num").ToString() %>" />
                                    <input type="hidden" name="hWRValue" value="<%# Eval("auto_uid").ToString() %>" /></td>
                                    <td width="13%" align="left" ><%# Eval("received_date","{0:d}").ToString() %> </td>
                                    <td width="13%" align="left" class="searchList"><a href="javascript:;" onClick="goWRScreen('<%# Eval("auto_uid").ToString() %>','<%# Eval("wr_num").ToString() %>')"><%# Eval("wr_num").ToString() %></a></td>
                                    <td width="13%" align="left"><%# Eval("customer_ref_no").ToString() %> </td>
                                    <td width="15%" align="left"><%# Eval("PO_NO").ToString() %> </td>
                                    <td width="19%" align="left" class="searchList"><a href="javascript:;" onClick="goCustomerScreen('<%# Eval("shipper_acct").ToString() %>')"><%# Eval("rec_name").ToString() %></a> </td>
                                    <td width="15%" align="left"><%# Eval("item_desc").ToString()%> </td>
                                    <td width="8%" align="right" style="padding-right: 10px" class="bodyheader"><%# Eval("item_piece_origin").ToString()%> </td>
                                </tr>
                            </table>
                        </itemtemplate>
                    </asp:TemplateField>
                    </columns>
                </asp:GridView>
                    </div>
                    
                </td>
            </tr>
            <tr bgColor="#FFFFFF">
             <td style="height: 22px">
             <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
             <tr class="bodyheader" align="left">
            <td width="12" align="left" height="20"></td>
             <td width="61%" align="left" height="20"></td>
             <td width="21%" align="Right"></td>
             <td width="5%" align="right" height="20"><p><asp:Label id="label1" runat="server" /></p></td>
             <td width="6%" align="right" style="padding-right:6px"> <p><asp:Label id="label2" runat="server" /></p></td>
             <td width="7%" align="right" style="padding-right:10px"><p><asp:Label id="label3" runat="server" /></p></td>
             </tr>
             </table>
             </td>
             
             </tr>      
            <tr>
                <td height="1">
                <asp:Label id="label4" runat="server" />
                </td>
            </tr>
            <tr>
                <td height="20" align="center" bgcolor="#e5cfbf">
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
