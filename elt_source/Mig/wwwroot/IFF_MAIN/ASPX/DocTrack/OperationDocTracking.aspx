<%@ Page language="c#" Inherits="IFF_MAIN.ASPX.DocTrack.OperationDocTracking" trace="false" CodeFile="OperationDocTracking.aspx.cs" CodePage="65001" %>
<%@ Register TagPrefix="uc1" TagName="rdSelectDateControl1" Src="../Reports/SelectionControls/rdSelectDateControl1.ascx" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
<script language="javascript" type="text/javascript">

function turnOnLoading(){
 document.getElementById('txtLoading').style.visibility='Visible'
}

</script>
  <HEAD>

                                <title>Operation Document Tracking</title>

                                <META http-equiv=Content-Type content="text/html; charset=UTF-8">

                                <meta content="Microsoft Visual Studio .NET 7.1" name=GENERATOR>

                                <meta content=C# name=CODE_LANGUAGE>

                                <meta content=JavaScript name=vs_defaultClientScript>

                                <meta content=http://schemas.microsoft.com/intellisense/ie5 name=vs_targetSchema>

                                <SCRIPT src="../Reports/jScripts/ig_dropCalendar.js" type=text/javascript></SCRIPT>

                                <SCRIPT src="../Reports/jScripts/ig_editDrop1.js" type=text/javascript></SCRIPT>

                                <SCRIPT src="../Reports/jScripts/WebDateSet1.js" type=text/javascript></SCRIPT>

                                <SCRIPT src="../Reports/jScripts/WebDateSet2.js" type=text/javascript></SCRIPT>

                                <LINK href="../CSS/AppStyle.css" type=text/css rel=stylesheet>

                                

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

                     function CheckDate()

                                {

                                  var         Wedit1 = igedit_getById('Webdatetimeedit1')

          var    a=Wedit1.getValue();

          

                      if(!a)  {

                        alert(' Please input the period!');

                        return false;

                      }

                      

                      var     Wedit2 = igedit_getById('Webdatetimeedit2')

          var    a=Wedit2.getValue();

          

                      if(!a)  {

                        alert(' Please input the period!');

                        return false;

                      }

                      

                                  return true;                                            

                                }

                                </script>

  <!--  #INCLUDE FILE="../include/common.htm" -->

<style type="text/css">

<!--
a:visited {
	color: #7D5BA4;
}
a:hover {
	color: #C60000;
}
a {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	color: #034AA0;
	padding-top: 20px;
	padding-bottom: 20px;
	border-bottom-width: 1px;
	border-bottom-style: dotted;
	border-bottom-color: #999999;
}

-->

</style>
  </HEAD>

                <BODY topMargin=0>

                                <form id=form1 method=post runat="server">

                                <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">

    <tr>

        <td><asp:label CssClass="pageheader" id=Label4 runat="server" Height="1px" Width="100%" Font-Size="15px" ForeColor="Black"

                                                                                                                Font-Bold="True"> Operation Document Tracking</asp:label></td>

    </tr>

</table>

        <table id=Table2 width="95%" border="0" align="center" cellpadding="2" cellspacing="0" bordercolor="#6f8fb6" class="border1px">

            <tr bgcolor="#e8d9e6">

                <td height="8" colspan="6" align="left" valign="middle" bgcolor="#b5d0f1"></td>

            </tr>

            <tr>

                <td height="1" colspan="6" align="left" valign="middle" bgcolor="#6f8fb6"></td>

            </tr>

            <tr align="center" bgcolor="<h3>e8d9e6</h3>">

                <td colspan="6" valign="middle" bgcolor="#dee9f6"><br />

                        <table width="75%" border="0" cellpadding="2" cellspacing="0" bordercolor="#6f8fb6" class="border1px">

                            <tr align="left" valign="middle">

                                <td>&nbsp;</td>

                                <td class="bodyheader" style="width: 326px">Selection Period</td>

                                <td style="width: 344px"><span style="width: 100px;" class="bodycopy">

                                    <uc1:rdselectdatecontrol1 id=RdSelectDateControl11  runat="server"></uc1:rdselectdatecontrol1>

                                </span></td>

                                <td style="width: 365px"><asp:Label ID=Label6 runat="server" Height="12px" CssClass="bodycopy">From</asp:Label></td>

                                <td style="width: 316px"><igtxt:webdatetimeedit id=Webdatetimeedit1 accessKey=e runat="server" Width="167px" ForeColor="DarkCyan"

                                                                                                                                                                Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" ">

                                    <BUTTONSAPPEARANCE CustomButtonDisplay="OnRight"></BUTTONSAPPEARANCE>

                                    <SPINBUTTONS SpinOnReadOnly="True" Display="OnLeft"></SPINBUTTONS>

                                </igtxt:webdatetimeedit></td>

                                <td style="width: 108px"><asp:Label ID=Label1 runat="server" Height="14px" designtimedragdrop="3572" CssClass="bodycopy">To</asp:Label>

                                </td>

                                <td>&nbsp;<igtxt:webdatetimeedit id=Webdatetimeedit2 accessKey=e runat="server" Width="167px" ForeColor="DarkCyan"

                                                                                                                                                                DESIGNTIMEDRAGDROP="142" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" ">

                                        <BUTTONSAPPEARANCE CustomButtonDisplay="OnRight"></BUTTONSAPPEARANCE>

                                        <SPINBUTTONS SpinOnReadOnly="True" Display="OnLeft"></SPINBUTTONS>

                                    </igtxt:webdatetimeedit></td>

                            </tr>

                            <tr align="left" valign="middle">

                                <td height="1" colspan="7" bgcolor="#6f8fb6"></td>

                            </tr>

                            <tr align="left" valign="middle">

                                <td>&nbsp;</td>

                                <td style="width: 326px"><asp:Label ID="Label2" runat="server" Text="Reference No." CssClass="bodyheader"></asp:Label></td>

                                <td style="width: 344px"><span>

                                    <asp:TextBox ID="txtRefNo" runat="server" Width="100px"></asp:TextBox>

                                </span></td>

                                <td style="width: 365px"><span class="bodyheader">Reference Type</span></td>

                                <td style="width: 316px"><span>

                                    <asp:DropDownList ID="ddlRefType" runat="server" CssClass="bodycopy">

                                        <asp:ListItem>HAWB No.</asp:ListItem>

                                        <asp:ListItem>MAWB No.</asp:ListItem>

                                        <asp:ListItem>House B/L No.</asp:ListItem>

                                        <asp:ListItem>Master B/L No.</asp:ListItem>

                                    </asp:DropDownList>

                                </span></td>

                                <td style="width: 108px">&nbsp;</td>

                                <td width="261" align="center"><span>

                                    <asp:ImageButton ID=iBtnGo runat="server" ImageUrl="../../images/button_go.gif" OnClick="iBtnGo_Click

                                                                                                                                                " OnClientClick="turnOnLoading()"></asp:ImageButton>

                                </span></td>

                            </tr>

                    </table>

                <br /></td>

            </tr>

            <tr bgcolor="#6f8fb6">

                <td height="1" colspan="6" align="left" valign="middle"></td>

            </tr>

            <tr align="center" bgcolor="#cdcc9d">

                <td colspan="6" valign="middle" bgcolor="#b5d0f1" style="height: 20px">&nbsp;</td>

            </tr>
            <tr align="center" bgcolor="#cdcc9d">
                <td align="left" bgcolor="#b5d0f1" colspan="6" height="20" style="height: 0px; background-color: white"
                    valign="middle">
                    <asp:Panel ID="pnlResult" runat="server" Height="30px" Width="100%" Font-Size=Larger ForeColor=Red>
                        <div id="txtLoading" style="width: 320px; height: 18px; visibility: hidden;">
                            Loading......</div>
                    </asp:Panel>
                </td>
            </tr>

        </table>

        <asp:button id=btnValidate runat="server" Visible="False" Text="for Validation"></asp:button>

                                                <asp:linkbutton id=LinkButton1 runat="server" Visible="False">LinkButton</asp:linkbutton><!-- end -->

<igsch:WebCalendar id=CustomDropDownCalendar runat="server" Width="150px">

<Layout FooterFormat="Today: {0:d}" TitleFormat="Month" ShowYearDropDown="False" PrevMonthImageUrl="ig_cal_blueP0.gif" ShowMonthDropDown="False" NextMonthImageUrl="ig_cal_blueN0.gif">

 

<DayStyle BackColor="#7AA7E0">

</DayStyle>

 

<FooterStyle Height="16pt" Font-Size="8pt" ForeColor="#505080" BackgroundImage="ig_cal_blue2.gif">

 

<BorderDetails ColorTop="LightSteelBlue" WidthTop="1px" StyleTop="Solid">

</BorderDetails>

 

</FooterStyle>

 

<SelectedDayStyle BackColor="SteelBlue">

</SelectedDayStyle>

 

<OtherMonthDayStyle ForeColor="SlateGray">

</OtherMonthDayStyle>

 

<NextPrevStyle BackgroundImage="ig_cal_blue1.gif">

</NextPrevStyle>

 

<CalendarStyle Width="150px" BorderWidth="1px" Font-Size="9pt" Font-Names="Verdana" BorderColor="SteelBlue" BorderStyle="Solid" BackColor="#E0EEFF">

</CalendarStyle>

 

<TodayDayStyle BackColor="#97B0F0">

</TodayDayStyle>

 

<DayHeaderStyle Height="1pt" Font-Size="8pt" Font-Bold="True" ForeColor="#606090" BackColor="#7AA7E0">

 

<BorderDetails StyleBottom="Solid" ColorBottom="LightSteelBlue" WidthBottom="1px">

</BorderDetails>

 

</DayHeaderStyle>

 

<TitleStyle Height="18pt" Font-Size="10pt" Font-Bold="True" ForeColor="#505080" BackgroundImage="ig_cal_blue1.gif" BackColor="#CCDDFF">

</TitleStyle>

 

</Layout>

</igsch:WebCalendar></form>

                                <SCRIPT type="text/javascript" language="javascript">

                                                ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1 Webdatetimeedit2");
                                                

                                </SCRIPT>

</BODY>

<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->

</HTML>
