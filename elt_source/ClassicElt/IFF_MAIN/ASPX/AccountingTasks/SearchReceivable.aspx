<%@ Page Language="c#" Inherits="IFF_MAIN.ASPX.Reports.Accounting.SearchReceivable"
    Trace="false" CodeFile="SearchReceivable.aspx.cs" %>

<%@ Register TagPrefix="uc1" TagName="rdSelectDateControl1" Src="../SelectionControls/rdSelectDateControl1.ascx" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
<HEAD>
    <title>Invoice Queue</title>
    <META http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">

    <SCRIPT src="../jScripts/WebDateSet1.js" type="text/javascript"></SCRIPT>

    <SCRIPT src="../jScripts/ig_dropCalendar.js" type="text/javascript"></SCRIPT>

    <SCRIPT src="../jScripts/ig_editDrop1.js" type="text/javascript"></SCRIPT>

    <script type="text/javascript" src="../jScripts/JPED_NET.js"></script>

    <script type="text/javascript" src="../jScripts/WindowsManip.js"></script>

    <script type="text/javascript" language="javascript" src="../../ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" language="javascript">
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
           // document.form1.hCommand.value="GET_IT";
           // form1.submit();
            
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

    <link href="../CSS/elt_css.css" rel="stylesheet" type="text/css">
    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css">
</HEAD>
<BODY>
    <form id="form1" method="post" runat="server">
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td width="30%" height="32" align="left" valign="middle" class="pageheader">
                    SEARCH Payment
                </td>
                <td width="70%" align="right" valign="baseline">
                    <span class="labelSearch"></span>&nbsp;<!-- Search -->
                </td>
            </tr>
        </table>
        <div class="selectarea" style="width: 100%; margin-left: auto; margin-right: auto;">
            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <!-- use this when applicable-->
                        <span class="select">
                            <!--Select Booking No.-->
                        </span>
                    </td>
                    <td width="55%" rowspan="2" align="right" valign="bottom">
                        <div id="print">
                        </div>
                    </td>
                </tr>
                <tr>
                    <!-- combo box here -->
                    <td width="45%" valign="bottom">
                    </td>
                </tr>
            </table>
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89a979"
            class="border1px">
            <tr>
                <td height="10" align="center" valign="middle" bgcolor="#d5e8cb">
                </td>
            </tr>
            <tr>
                <td align="center" bgcolor="#f3f3f3" style="border-bottom: 2px solid #89a979; border-top: 1px solid #89a979">
                    <br>
                    <br>
                    <table width="60%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89A979"
                        class="border1px" style="padding-left: 10px" id="Table2">
                        <tr align="left" valign="middle" bgcolor="#E7F0E2">
                            <td width="26%" height="18" align="left" bgcolor="#E7F0E2">
                                <asp:Label ID="Label2" runat="server" designtimedragdrop="43" Width="100%" CssClass="bodyheader">Processed Date</asp:Label></td>
                            <td width="19%" align="left" bgcolor="#E7F0E2" class="bodyheader">
                                From</td>
                            <td width="20%" class="bodyheader">
                                &nbsp;</td>
                            <td width="35%">
                                <asp:Label ID="Label1" runat="server" designtimedragdrop="3572" Height="0px" CssClass="bodyheader">To</asp:Label>
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#FFFFFF">
                            <td height="22" align="left">
                                <uc1:rdSelectDateControl1 ID="RdSelectDateControl11" runat="server"></uc1:rdSelectDateControl1>
                            </td>
                            <td colspan="2">
                                <igtxt:WebDateTimeEdit ID="Webdatetimeedit1" AccessKey="e" runat="server" ForeColor="Black"
                                    Width="180px" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" ">
                                    <ButtonsAppearance CustomButtonDisplay="OnRight">
                                    </ButtonsAppearance>
                                    <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
                                </igtxt:WebDateTimeEdit>
                            </td>
                            <td>
                                <igtxt:WebDateTimeEdit ID="Webdatetimeedit2" AccessKey="e" runat="server" DESIGNTIMEDRAGDROP="142"
                                    ForeColor="Black" Width="180px" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" ">
                                    <ButtonsAppearance CustomButtonDisplay="OnRight">
                                    </ButtonsAppearance>
                                    <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
                                </igtxt:WebDateTimeEdit>
                            </td>
                        </tr>
                        <tr bgcolor="#f3f3f3">
                            <td height="2" colspan="6" align="left" bgcolor="#89a979" class="bodyheader style1">
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#f3f3f3">
                            <td height="18" colspan="3">
                                <asp:Label ID="Label8" runat="server" Width="100%" CssClass="bodyheader">Customer</asp:Label>
                            </td>
                            <td>
                                <span class="bodyheader">Invoice No.</span></td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#ffffff">
                            <td colspan="3">
                                <!-- Start JPED -->
                                <input type="hidden" id="hCustomerAcct" runat="server" name="hCustomerAcct" value="0" />
                                <div id="lstCustomerNameDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <input type="text" autocomplete="off" id="lstCustomerName" name="lstCustomerName"
                                                value="" class="shorttextfield" style="width: 240px; border-top: 1px solid #7F9DB9;
                                                border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                onKeyUp="organizationFill(this,'Customer','lstCustomerNameChange')" onfocus="initializeJPEDField(this);"
                                                runat="server" /></td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstCustomerName','Customer','lstCustomerNameChange')"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                onclick="quickAddClient('hCustomerAcct','lstCustomerName','txtCustomerInfo')" /></td>
                                        <td>
                                            <input type="hidden" id="txtCustomerInfo" name="txtCustomerInfo"></input></td>
                                    </tr>
                                </table>
                                <!-- End JPED -->
                            </td>
                            <td>
                                <asp:TextBox ID="txtInvoiceNo" runat="server" CssClass="shorttextfield" Width="90px"></asp:TextBox></td>
                        </tr>
                        <tr align="left" bgcolor="#f3f3f3" valign="middle">
                            <td bgcolor="#f3f3f3" class="bodyheader" style="height: 18px">
                                Payment Method</td>
                            <td bgcolor="#f3f3f3" class="bodyheader" style="height: 18px">
                                Payment Amt</td>
                            <td style="height: 18px">
                                <span class="bodyheader" style="background-color: #f3f3f3">Deposit Account</span></td>
                            <td class="bodyheader" style="height: 18px">
                                Reference No.</td>
                        </tr>
                        <tr align="left" bgcolor="#ffffff" valign="middle">
                            <td>
                                <asp:DropDownList ID="ddlPaymethod" runat="server" CssClass="smallselect" Height="18px"
                                    Width="100px">
                                    <asp:ListItem>Check</asp:ListItem>
                                    <asp:ListItem>Cash</asp:ListItem>
                                    <asp:ListItem>Credit Card</asp:ListItem>
                                    <asp:ListItem>Bank to Bank</asp:ListItem>
                                </asp:DropDownList></td>
                            <td>
                                &nbsp;<asp:TextBox ID="txtAmount" runat="server" CssClass="shorttextfield" Width="90px"></asp:TextBox></td>
                            <td>
                                <asp:DropDownList ID="ddlBankAcct" runat="server" CssClass="smallselect" Height="18px"
                                    Width="180px">
                                </asp:DropDownList></td>
                            <td>
                                <asp:TextBox ID="txtRefNo" runat="server" CssClass="shorttextfield" Width="90px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#ffffff" valign="middle">
                            <td height="22" colspan="4" align="center" bgcolor="#f3f3f3">
                                <asp:Image ID="btnGo" runat="server" ImageUrl="../../images/button_go.gif" /></td>
                        </tr>
                        <tr align="left" bgcolor="#f3f3f3" valign="middle">
                            <td colspan="4" style="text-align: right">
                            </td>
                        </tr>
                    </table>
                    <br>
                    <br>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:GridView ID="GridView1" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                        Width="100%" AllowPaging="True" OnPageIndexChanging="GridView1_PageIndexChanging"
                        Height="100%" BorderStyle="None" BorderWidth="0px">
                        <Columns>
                            <asp:TemplateField Visible="False">
                                <ItemTemplate>
                                    &nbsp;
                                    <asp:Image ID="btnCheck" runat="server" ImageUrl="~/ASPX/AccountingTasks/images/mark_o.gif" />
                                    <asp:HiddenField ID="hCheck" runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="payment_date" HeaderText="Date">
                                <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="payment_no" HeaderText="Receivement ID">
                                <HeaderStyle CssClass="bodycopy" />
                            </asp:BoundField>
                            <asp:BoundField DataField="customer_name" HeaderText="Customer">
                                <HeaderStyle CssClass="bodyheader" Width="150px" HorizontalAlign="Left" />
                                <ItemStyle Width="250px" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Reference/Memo" DataField="ref_no">
                                <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
                                <ItemStyle Width="70px" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="payment" HeaderText="Amount">
                                <HeaderStyle CssClass="bodyheader" />
                            </asp:BoundField>
                            <asp:TemplateField Visible="False">
                                <ItemTemplate>
                                    <asp:ImageButton ID="btnDelete" runat="server" CommandName="Delete" CommandArgument='<%#DataBinder.Eval(Container,"RowIndex")%>'
                                        ImageUrl="~/ASP/Images/button_cancel.gif" OnCommand="Delete" />
                                    &nbsp;
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField Visible="False">
                                <ItemTemplate>
                                    <asp:ImageButton ID="btnCreditBack" runat="server" CommandName="CreditBack" CommandArgument='<%#DataBinder.Eval(Container,"RowIndex")%>'
                                        OnCommand="CreditBack" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="CheckBox" HeaderText="Select" HtmlEncode="False" Visible="False">
                                <HeaderStyle CssClass="bodyheader" />
                            </asp:BoundField>
                            <asp:HyperLinkField DataNavigateUrlFields="url" HeaderText="Link" Target="popUpWindow"
                                Text="View" DataTextFormatString="viewPop('{0}');">
                                <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
                                <ItemStyle Width="75px" />
                            </asp:HyperLinkField>
                        </Columns>
                        <EditRowStyle BackColor="White" />
                        <AlternatingRowStyle BackColor="#F3F3F3" />
                        <RowStyle BackColor="White" />
                        <HeaderStyle BackColor="#E7F0E2" Height="18px" HorizontalAlign="Left" />
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td align="center" valign="middle" bgcolor="#d5e8cb" height="22" style="border-top: 1px solid #89a979">
                </td>
            </tr>
        </table>
        <P>
            <asp:Button ID="btnValidate" runat="server" Text="for Validation" Visible="False"></asp:Button>
            <asp:HiddenField ID="hCommand" runat="server" />
            <asp:LinkButton ID="LinkButton1" runat="server" Visible="False">LinkButton</asp:LinkButton><asp:TextBox
                ID="txtNum" runat="server" Height="1px" Width="1px"></asp:TextBox>
            <igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="180px">
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
            <!-- end -->
        </P>
    </form>

    <SCRIPT type="text/javascript">
			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1 Webdatetimeedit2");
    </SCRIPT>

</BODY>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</HTML>
