<%@ Control Language="c#" Inherits="IFF_MAIN.ASPX.Reports.SelectionControls.rdSelectDateControl0" CodeFile="rdSelectDateControl0.ascx.cs" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<asp:dropdownlist id="rdDateSet1" Width="110px" runat="server" BackColor="#FFFFC0" ForeColor="#000040" Font-Names="Verdana" Font-Size="9px">
<asp:ListItem Value="Select" Selected="true">Select</asp:ListItem>
<asp:ListItem Value="Today">Today</asp:ListItem>
<asp:ListItem Value="Month to Date">Month to Date</asp:ListItem>
<asp:ListItem Value="Quarter to Date">Quarter to Date</asp:ListItem>
<asp:ListItem Value="Year to Date">Year to Date</asp:ListItem>
<asp:ListItem Value="This Month">This Month</asp:ListItem>
<asp:ListItem Value="This Quarter">This Quarter</asp:ListItem>
<asp:ListItem Value="This Year">This Year</asp:ListItem>
<asp:ListItem Value="Last Month">Last Month</asp:ListItem>
<asp:ListItem Value="Last Quarter">Last Quarter</asp:ListItem>
<asp:ListItem Value="Last Year">Last Year</asp:ListItem>
<asp:ListItem Value="All Time">All Time</asp:ListItem>
</asp:dropdownlist>

  <!--  <igtxt:webdatetimeedit id=Webdatetimeedit4 accessKey=e runat="server" ForeColor="Black" Width="120px"
            Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" "  OnValueChange="period_change_back"  Height="17px">
            <ButtonsAppearance CustomButtonDisplay="OnRight"></ButtonsAppearance>
            <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
        </igtxt:webdatetimeedit>
          <igtxt:webdatetimeedit id=Webdatetimeedit3 accessKey=e runat="server" ForeColor="Black" Width="120px" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" " Height="17px">
            <ButtonsAppearance CustomButtonDisplay="OnRight">                                        </ButtonsAppearance>
            <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
        </igtxt:WebDateTimeEdit>-->
        
        

        
    <script type="text/javascript">
         function datetextboxchange2()
        {
        	document.getElementById("Webdatetimeedit4").style.background="#FFFFFF";
        	document.getElementById("Webdatetimeedit2").style.background="#FFFFFF";
         }
         
         
   </script>
