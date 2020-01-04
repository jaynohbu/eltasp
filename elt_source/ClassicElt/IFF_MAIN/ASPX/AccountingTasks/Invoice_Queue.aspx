<%@ Page language="c#" Inherits="IFF_MAIN.ASPX.Reports.Accounting.SearchInvoiceSelection" trace="false" CodeFile="Invoice_Queue.aspx.cs" %>
<%@ Register TagPrefix="uc1" TagName="rdSelectDateControl1" Src="../SelectionControls/rdselectdatecontrol1.ascx" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML >
  <HEAD>
		<title>Invoice Queue</title>
		<META http-equiv=Content-Type content="text/html; charset=euc-kr">
		<meta content="Microsoft Visual Studio .NET 7.1" name=GENERATOR>
		<meta content=C# name=CODE_LANGUAGE>
		<meta content=JavaScript name=vs_defaultClientScript>
		<meta content=http://schemas.microsoft.com/intellisense/ie5 name=vs_targetSchema>
		<SCRIPT src="../jScripts/WebDateSet1.js" type=text/javascript></SCRIPT>
		 <script type="text/javascript" src="../jScripts/datetimepicker.js"></script>
		<SCRIPT src="../jScripts/ig_dropCalendar.js" type=text/javascript></SCRIPT>
		<SCRIPT src="../jScripts/ig_editDrop1.js" type=text/javascript></SCRIPT>
		<script type="text/javascript" src="../jScripts/JPED_NET.js"></script>
		<script type="text/javascript" src="../jScripts/WindowsManip.js"></script>
        <script type="text/javascript" language="javascript" src="../../ASP/ajaxFunctions/ajax.js"></script>
        <script type="text/javascript"  language="javascript">
        function noPostBack(sNewFormAction)
        {
            document.forms[0].action = sNewFormAction;
            document.forms[0].__VIEWSTATE.name = 'NOVIEWSTATE';
        }
        </script>
        <script type="text/javascript" language="javascript">

        function checkClicked(checkbox,hCheck)
        {      
       
            var temp=checkbox.src.split("/");
            check=temp[temp.length-1];
            if(check=="mark_o.gif"){               
                checkbox.src="images/mark_x.gif"; 
                hCheck.value="images/mark_x.gif";                                              
            }
            else
            {      
                checkbox.src="images/mark_o.gif";
                hCheck.value="images/mark_o.gif"; 
            }       

        }  
        </script>
        <!--  #INCLUDE FILE="../include/common.htm" -->
        <style type="text/css">
        <!--
        body {
        margin: 0;
		padding: 0;
        }
        -->
        </style>
        <script language="javascript" type="text/javascript">
        // Start of list change effect //////////////////////////////////////////////////////////////////
        function lstCustomerNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hCustomerAcct");
            var infoObj = document.getElementById("txtCustomerInfo");
            var txtObj = document.getElementById("lstCustomerName");
            var divObj = document.getElementById("lstCustomerNameDiv")

            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            document.form1.hCommand.value="GET_IT";
            form1.submit();

        }

        function goNow()
        {
            document.form1.hCommand.value="GO";
            form1.submit();
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

            var url="../ajaxFunctions/ajax_get_org_address_info.asp?type=B&org="+ orgNum;

            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send(); 

            return xmlHTTP.responseText; 
        }
        <!--

        function isNum(a) {

        if(a.value == "") return true;

        var number=parseInt(a.value,10);

            if( number.toString()=="NaN") {
                alert('Please input a valid I/V No.');
                return false;
            }
            else 
            {
                return true;
            }
        }


        function MM_swapImgRestore() { //v3.0
        var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
        }

        function MM_preloadImages() { //v3.0
        var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
        var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
        if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
        }

        function MM_findObj(n, d) { //v4.01
        var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
        if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
        for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
        if(!x && d.getElementById) x=d.getElementById(n); return x;
        }

        function MM_swapImage() { //v3.0

        var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
        if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
        }

        function MM_goToURL() { //v3.0
        var i, args=MM_goToURL.arguments; document.MM_returnValue = false;
        for (i=0; i<(args.length-1); i+=2) eval(args[i]+".location='"+args[i+1]+"'");
        }
        //-->
        </script>
        <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css">
  </HEAD>
	<BODY topMargin=0 onLoad="MM_preloadImages('/iff_main/ASP/Images/acc_ta_ci_overi.gif','/iff_main/ASP/Images/acc_ta_ai_over.gif','/iff_main/ASP/Images/acc_ta_si_over.gif','/iff_main/ASP/Images/acc_ta_rp_over.gif','/iff_main/ASP/Images/acc_ta_eb_over.gif','/iff_main/ASP/Images/acc_ta_pb_over.gif','/iff_main/ASP/Images/acc_ta_wc_over.gif','/iff_main/ASP/Images/acc_ta_pc_over.gif','/iff_main/ASP/Images/acc_ta_mc_over.gif','/iff_main/ASP/Images/acc_ta_ca_over.gif','/iff_main/ASP/Images/acc_ta_ei_over.gif','/iff_main/ASP/Images/acc_ta_eci_over.gif','/iff_main/ASP/Images/acc_ta_gje_over.gif','/iff_main/ASP/Images/acc_ta_fc_over.gif','/iff_main/ASP/Images/acc_ta_ci_over.gif','/iff_main/ASP/Images/acc_ta_si.gif')">
		<form id=form1 method=post runat="server">	
		
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td width="30%" height="32" align="left" valign="middle" class="pageheader">
                        Invoice Queue
            </td>
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
	</div>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89a979" class="border1px">
        <tr bgcolor="#d5e8cb">
            <td height="10" align="center" valign="middle"></td>
        </tr>
		<tr>
            <td height="1" align="center" valign="middle" bgcolor="#89a979"></td>
        </tr>
        <tr>
            <td align="center" bgcolor="#f3f3f3"><br>
                <br>
                <table width="56%" border="0" align="center" cellpadding="2" cellspacing="0" bordercolor="#89A979" bgcolor="#FFFFFF" class="border1px" id="Table2">
                <tr align="left" valign="middle" bgcolor="#E7F0E2">
                    <td width="10" class="bodyheader"></td>
                                                    <td width="181" height="20" align="left" bgcolor="#E7F0E2">
                                                        <asp:Label ID=Label2 runat="server" designtimedragdrop="43" Width="100%" CssClass="bodyheader">
                                                            Shipment Date</asp:Label>                                                </td>
                                                    <td width="200" style="width: 204px"><span class="bodyheader" style="width: 57px">From</span></td>
                                                    <td width="219"><span class="bodycopy" style="width: 40px">
                                                        <asp:Label ID=Label1 runat="server" designtimedragdrop="3572" Height="0px" CssClass="bodyheader">To</asp:Label>
                                                        </span></td>
                    </tr>
                <tr align="left" valign="middle">
                    <td class="bodyheader" style="height: 22px"></td>
                                                    <td align="left" style="height: 22px">
                                                        
                                                        <uc1:rdselectdatecontrol1 id=RdSelectDateControl11 runat="server"></uc1:rdselectdatecontrol1></td>
                                                    <td style="height: 22px"><igtxt:webdatetimeedit id=Webdatetimeedit1 accessKey=e runat="server" ForeColor="Black" Width="180px"
											Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" ">
                                                        <ButtonsAppearance CustomButtonDisplay="OnRight"></ButtonsAppearance>
                                                        <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
                                                        </igtxt:webdatetimeedit></td>
                                                    <td style="height: 22px"><igtxt:webdatetimeedit id=Webdatetimeedit2 accessKey=e runat="server" DESIGNTIMEDRAGDROP="142" ForeColor="Black"
											Width="180px" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" ">
                                                        <ButtonsAppearance CustomButtonDisplay="OnRight"></ButtonsAppearance>
                                                        <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
                                                        </igtxt:webdatetimeedit></td>
                    </tr>
                <tr align="left" valign="middle">
                    <td height="2" colspan="4" bgcolor="#89A979"></td>
			        </tr>
                <tr align="left" valign="middle" bgcolor="#f3f3f3">
                    <td>&nbsp;</td>
                                                    <td height="18" colspan="3"><span style="width: 94px"><span>
                                                        <asp:Label ID=Label8 runat="server" Width="100%" CssClass="bodyheader">Bill To</asp:Label>
                                                        </span></span></td>
                    </tr>
                <tr align="left" valign="middle" bgcolor="#ffffff">
                    <td>&nbsp;</td>
                                                    <td colspan="3">
                                                        <!-- Start JPED -->
                                                        <input type="hidden" id="hCustomerAcct" runat="server" name="hCustomerAcct" value="0" />
                                                        <div id="lstCustomerNameDiv">                                                        </div>
                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                <tr>
                                                                    <td>
                                                                        <input type="text" autocomplete="off" id="lstCustomerName" name="lstCustomerName" value=""
                                                                        class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Customer','lstCustomerNameChange')"
                                                                        onfocus="initializeJPEDField(this);" runat="server" /></td>
                                                                    <td>
                                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstCustomerName','Customer','lstCustomerNameChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                    <td>
                                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hCustomerAcct','lstCustomerName','txtCustomerInfo')" /></td>
                                                                            
                                                                        <td><input type="hidden" id="txtCustomerInfo" name="txtCustomerInfo"></input></td>
                                                                </tr>
                                                        </table>
                                                            
                                                        <!-- End JPED -->                                                </td>
                    </tr>
                <tr align="left" bgcolor="#f3f3f3" valign="middle">
                    <td>&nbsp;</td>
                                                    <td height="18" colspan="3" valign="middle">
                                                        <asp:Label ID="Label3" runat="server" CssClass="bodyheader">Sort by</asp:Label>                                                </td>
                    </tr>
                <tr align="left" bgcolor="#ffffff" valign="middle">
                    <td>&nbsp;</td>
                                                    <td colspan="3" style="height: 22px">
                                                        <asp:DropDownList ID="ddlSortBy" runat="server" AutoPostBack="True" CssClass="smallselect"
                                                        OnSelectedIndexChanged="ddlSortBy_SelectedIndexChanged">
                                                            <asp:ListItem>MAWB/MBOL</asp:ListItem>
                                                            <asp:ListItem>HAWB/HBOL</asp:ListItem>
                                                            <asp:ListItem>Bill To</asp:ListItem>
                                                            <asp:ListItem>Agent</asp:ListItem>
                                                            <asp:ListItem>Air/Ocean</asp:ListItem>
                                                        </asp:DropDownList></td>
                    </tr>
                </table>                         
            <br /><br />            </td></tr>
		<tr>
			<td height="24" align="right" valign="middle" bgcolor="#f3f3f3" style="padding-right:10px">
				* Indicates Air(A) Ocean(O) and Domestic(D)			</td>
		</tr>
		<tr>
            <td height="2" align="center" valign="middle" bgcolor="#89a979"></td>
        </tr>
		<tr>
			<td height="20" align="center" valign="middle" bgcolor="#d5e8cb">
			    <asp:Image ID="btnGo" runat="server" ImageUrl="../../images/button_createInvoice.gif" />                
			</td>
		</tr>
		<tr>
            <td height="1" align="center" valign="middle" bgcolor="#89a979"></td>
        </tr>
        <tr>
            <td height="20" align="left" valign="top" bgcolor="#E7F0E2">
			<asp:GridView ID="GridView1" runat="server" AllowSorting="True" AutoGenerateColumns="False" Width="100%" AllowPaging="True" OnPageIndexChanging="GridView1_PageIndexChanging" Height="100%" BorderStyle="None" BorderWidth="0px" CellPadding="0" PageSize="20" ShowFooter="True"  >
                <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Image ID="btnCheck" runat="server" ImageUrl="~/ASPX/AccountingTasks/images/mark_o.gif" />                
                        <asp:HiddenField ID="hCheck" runat="server" />
                    </ItemTemplate>
                    <HeaderStyle BackColor="#E4E2C2" />
                </asp:TemplateField>
                <asp:HyperLinkField DataNavigateUrlFields="url_mawb" DataTextField="mawb_num" HeaderText="MAWB/MBOL" Target="_blank">
                    <HeaderStyle CssClass="bodyheader" BackColor="#E4E2C2" />            
                    <ItemStyle Width="12%" CssClass="bodycopy" />                </asp:HyperLinkField>
                <asp:HyperLinkField DataNavigateUrlFields="url_hawb" HeaderText="HAWB/HBOL" Target="_blank" DataTextField="hawb_num">
                    <HeaderStyle CssClass="bodyheader" BackColor="#E4E2C2" />            
                    <ItemStyle Width="12%" CssClass="bodycopy" />                </asp:HyperLinkField>
                <asp:BoundField DataField="bill_to" HeaderText="Bill To" >
                    <HeaderStyle CssClass="bodyheader" BackColor="#E4E2C2" />            
                    <ItemStyle Width="24%" CssClass="bodycopy" />                </asp:BoundField>
                <asp:BoundField DataField="agent_name" HeaderText="Agent" >
                    <HeaderStyle CssClass="bodyheader" Width="150px" BackColor="#E4E2C2" />            
                    <ItemStyle Width="24%" CssClass="bodycopy" />                </asp:BoundField>
                <asp:BoundField HeaderText="Master Agent" DataField="master_agent">
                    <HeaderStyle CssClass="bodyheader" HorizontalAlign="Center" BackColor="#E4E2C2" />            
                    <ItemStyle Width="10%" HorizontalAlign="Center" CssClass="bodycopy" />                </asp:BoundField>
                <asp:BoundField HeaderText="Type*" DataField="air_ocean" >
                    <HeaderStyle CssClass="bodyheader" HorizontalAlign="Center" BackColor="#E4E2C2" />            
                    <ItemStyle Width="10%" HorizontalAlign="Center" CssClass="bodycopy" />                </asp:BoundField>
                <asp:BoundField DataField="CheckBox" HeaderText="Select" HtmlEncode="False" Visible="False">
                    <HeaderStyle CssClass="bodyheader" BackColor="#E4E2C2" />                </asp:BoundField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:ImageButton ID="btnDelete" runat="server" CommandName="Delete"  CommandArgument='<%#DataBinder.Eval(Container,"RowIndex")%>' ImageUrl="~/ASP/Images/button_delete.gif" OnCommand="Delete" />                    </ItemTemplate>
                    <HeaderStyle BackColor="#E4E2C2" />
                </asp:TemplateField>
                </Columns>
                <EditRowStyle BackColor="White" />
                <AlternatingRowStyle BackColor="#F3F3F3" />
                <RowStyle BackColor="White" />
                <FooterStyle BorderStyle="None" BorderWidth="0px" />
                <HeaderStyle HorizontalAlign="Left" />
                <PagerStyle HorizontalAlign="Center" VerticalAlign="Middle" />
            </asp:GridView></td>
        </tr>   
    </table>
            
            

			<P><asp:button id=btnValidate runat="server" Text="for Validation" Visible="False"></asp:button>
                <asp:HiddenField ID="hCommand" runat="server" />
                <asp:linkbutton id=LinkButton1 runat="server" Visible="False">LinkButton</asp:linkbutton><asp:textbox id=txtNum runat="server" Height="1px" Width="1px"></asp:textbox><!-- end --></P>
			<igsch:WebCalendar id=CustomDropDownCalendar runat="server" Width="180px">
				<Layout TitleFormat="Month" ShowYearDropDown="False"
					ShowMonthDropDown="False" CellPadding="0" NextMonthText="&gt;&gt;" PrevMonthText="&lt;&lt;" FooterFormat="" ShowFooter="False">
					<DayStyle BackColor="White" CssClass="CalDay">
                    </DayStyle>					
					<SelectedDayStyle CssClass="CalSelectedDay" BackColor="#C5D5FC"></SelectedDayStyle>
					<OtherMonthDayStyle ForeColor="Silver"></OtherMonthDayStyle>
					<NextPrevStyle CssClass="NextPrevStyle"></NextPrevStyle>
					<CalendarStyle CssClass="CalStyle">
                    </CalendarStyle>
					<TodayDayStyle CssClass="CalToday"></TodayDayStyle>
					<DayHeaderStyle Font-Bold="False" CssClass="CalDayHeader">
						<BorderDetails StyleBottom="None"></BorderDetails>
					</DayHeaderStyle>
					<TitleStyle Font-Bold="True" CssClass="TitleStyle"></TitleStyle>
				</Layout>
			</igsch:WebCalendar></form>
		<SCRIPT type=text/javascript>
			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1 Webdatetimeedit2");
		</SCRIPT>
		
		


</BODY>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</HTML>
