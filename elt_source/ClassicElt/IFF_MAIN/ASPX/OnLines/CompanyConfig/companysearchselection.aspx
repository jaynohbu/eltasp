<%@ Register TagPrefix="igcmbo" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Page language="c#" Inherits="IFF_MAIN.ASPX.OnLines.CompanyConfig.CompanySearchSelection" trace="false" CodeFile="CompanySearchSelection.aspx.cs" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>Company Search</title>
		<META http-equiv="Content-Type" content="text/html; charset=ks_c_5601-1987">
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="../../CSS/AppStyle.css" type="text/css" rel="stylesheet">
		<script language="javascript">
function searchOption() {
	var strOption = document.CompanyCreate.drSearch.value;
	var strDBA = document.CompanyCreate.txtSearchKey.value; 	
	if(strDBA=="") { 
		alert('Please input the search text.');
		return true; 
	  }
	if  ( strOption == 'number') goDupChkWithNum(strDBA); 
	if  ( strOption == 'name') goDupChk(strDBA);
}

function goDupChk(strDBA) {
	if(strDBA =="" ) return true;	
	var WinWidth = 640;                                                                                     
	var WinHeight = 500;                                                                                    
	var x=screen.width/2-WinWidth/2;     
	var y=screen.height/2-WinHeight/2;
	var path='CompanyShowDialog2.aspx'; 
	path +='?BusinessName='+ strDBA ; 
	path +='&chk=2'; 

	winopen = window.open(path,'popup','left='+ x +',top='+ y +',width='+ WinWidth +', height='+ WinHeight +' , menubar=no, scrollbars=yes, staus=no, resizable=yes, titlebar=no, toolbar=no, hotkey=0,closeable=no');  
	winopen.focus();
	
}		

function goDupChkWithNum(strDBA) {
	var elt_account_numberNumber = strDBA;
	if(elt_account_numberNumber =="" ) return true;	
	var WinWidth = 660;                                                                                     
	var WinHeight = 500;                                                                                    
	var x=screen.width/2-WinWidth/2;     
	var y=screen.height/2-WinHeight/2;
	var path='CompanyShowDialog2.aspx'; 
	path +='?AcctNum='+ elt_account_numberNumber ; 
	path +='&chk=1'; 

	winopen = window.open(path,'popup','left='+ x +',top='+ y +',width='+ WinWidth +', height='+ WinHeight +' , menubar=no, scrollbars=yes, staus=no, resizable=yes, titlebar=no, toolbar=no, hotkey=0,closeable=no');  
	winopen.focus();	
}		

function resetSearch() {
document.CompanyCreate.txtSearchKey.value = "";
}
		</script>
<!--  #INCLUDE FILE="../../include/common.htm" -->
</HEAD>
	<BODY leftMargin="0" topMargin="0">
		<form id="CompanyCreate" method="post" runat="server">
			<!-- Edited by IG.Moon -->
			<TABLE id="Table3" cellSpacing="0" cellPadding="0" width="100%" border="0" style="height: 420px">
				<TR>
                    <td align="left" style="width: 20px" valign="top">
                    </td>
					<TD valign="top" align=left>
						<TABLE id="Table2" cellSpacing="0" cellPadding="0" width="100%">
							<TR>
								<TD></TD>
								<TD vAlign=top></TD>
								<TD></TD>
							</TR>
							<TR>
								<TD></TD>
								<TD><asp:label id="Label8" runat="server" Font-Size="Larger" Height="100%" Font-Bold="True" Font-Italic="False"
										ForeColor="#000040" DESIGNTIMEDRAGDROP="9087" Width="100%"> Company Search</asp:label></TD>
								<TD></TD>
							</TR>
							<TR>
								<TD></TD>
								<TD style="HEIGHT: 14px" vAlign="top" bgColor="#ccebed"></TD>
								<TD></TD>
							</TR>
							<TR>
								<TD style="HEIGHT: 85px"></TD>
								<TD style="HEIGHT: 85px">
									<TABLE id="Table1">
										<TR>
											<TD style="height: 13px"><asp:label id="Label9" runat="server" Font-Bold="True" Font-Italic="False" ForeColor="Navy"
													Width="261px" Font-Underline="True">Choose the Paging should be based on -</asp:label></TD>
                                            <td style="width: 10px; height: 13px">
                                            </td>
											<TD style="height: 13px"><asp:label id="Label2" runat="server" Font-Bold="True" Font-Italic="False" ForeColor="Navy"
													Width="100%" Font-Underline="True">Starting Character -</asp:label></TD>
                                            <td style="width: 10px; height: 13px">
                                            </td>
											<TD style="height: 13px"><asp:label id="Label7" runat="server" Font-Bold="True" Font-Italic="False" ForeColor="Navy"
													Width="121px" Font-Underline="True">Business Type -</asp:label></TD>
										</TR>
										<TR>
											<TD>
												<asp:radiobuttonlist id="RadioButtonList1" runat="server" Font-Size="10pt" Height="24px" ForeColor="DarkBlue"
													Width="100%" Font-Names="Verdana">
													<asp:ListItem Value="dba_name" Selected="True">Company Name</asp:ListItem>
													<asp:ListItem Value="business_state">State</asp:ListItem>
												</asp:radiobuttonlist></TD>
                                            <td style="width: 10px">
                                            </td>
											<TD><asp:dropdownlist id="Dropdownlist2" runat="server" Width="49px"></asp:dropdownlist><asp:textbox id="txtSearchKey" runat="server" Font-Bold="True" ForeColor="#0000C0" Width="179px"
													BorderColor="#0000C0" BackColor="White" BorderWidth="1px" BorderStyle="Solid"></asp:textbox></TD>
                                            <td style="width: 10px">
                                            </td>
											<TD><asp:dropdownlist id="DropDownList1" runat="server" Width="150px"></asp:dropdownlist></TD>
										</TR>
										<TR>
											<TD></TD>
                                            <td align="center" style="width: 10px">
                                            </td>
											<TD align=center>
												<asp:ImageButton id=ImageButton1 runat="server" ImageUrl="../../../images/button_go.gif"></asp:ImageButton></TD>
                                            <td style="width: 10px">
                                            </td>
											<TD></TD>
										</TR>
									</TABLE>
								</TD>
								<TD></TD>
							</TR>
							<TR>
								<TD></TD>
								<TD bgColor="#ccebed" style="height: 14px"><asp:radiobuttonlist id="Radiobuttonlist2" runat="server" Font-Size="10pt" Height="24px" ForeColor="DarkBlue"
										Width="100%" Font-Names="Verdana" BackColor="White">
										<asp:ListItem Value="multi" Selected="True">Normal search</asp:ListItem>
										<asp:ListItem Value="Single">Intelli search</asp:ListItem>
										<asp:ListItem Value="Intelli search with full record ( low performance )">Intelli search with full record ( low performance )</asp:ListItem>
									</asp:radiobuttonlist></TD>
								<TD></TD>
							</TR>
							<TR>
								<TD></TD>
								<TD></TD>
								<TD></TD>
							</TR>
							<TR>
								<TD style="HEIGHT: 338px"></TD>
								<TD vAlign=top align=left>
									<igtbl:ultrawebgrid id="UltraWebGrid1" runat="server" Height="400px" Width="100%" OnInitializeLayout="UltraWebGrid1_InitializeLayout1" OnInitializeRow="UltraWebGrid1_InitializeRow1" OnPageIndexChanged="UltraWebGrid1_PageIndexChanged1">
										<DisplayLayout RowHeightDefault="18px" Version="4.00" HeaderClickActionDefault="SortMulti" BorderCollapseDefault="Separate"
											AllowRowNumberingDefault="NotSet" Name="UltraWebGrid1" TableLayout="Fixed" ViewType="Hierarchical">
											<AddNewBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
												<Style BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

												</Style>
                                                <ButtonStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                                    Cursor="Hand">
                                                </ButtonStyle>
											</AddNewBox>
											<Pager Alignment="Center">
												<Style BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

												</Style>
											</Pager>
											<HeaderStyleDefault BorderStyle="Solid" HorizontalAlign="Left" ForeColor="Black" BackColor="#CBD6A6" BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt">
												<BorderDetails WidthLeft="1px" ColorLeft="White" ColorTop="White" WidthTop="1px"></BorderDetails>
                                                <Padding Left="5px" Right="5px" />
											</HeaderStyleDefault>
											<FrameStyle Width="100%" BorderWidth="1px" Font-Size="8pt" Font-Names="Tahoma"
												BorderStyle="Solid" Height="400px" BackColor="#FAFCF1" Cursor="Hand"></FrameStyle>
											<FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">
												<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
											</FooterStyleDefault>
											<EditCellStyleDefault BorderWidth="0px" BorderStyle="None" Font-Names="Tahoma" Font-Size="8pt" HorizontalAlign="Left" VerticalAlign="Middle"></EditCellStyleDefault>
											<RowStyleDefault BorderWidth="1px" BorderColor="#AAB883" BorderStyle="Solid" BackColor="White" Font-Names="Tahoma" Font-Size="8pt" ForeColor="#333333" HorizontalAlign="Left" VerticalAlign="Middle">
												<Padding Left="7px" Right="7px"></Padding>
												<BorderDetails WidthLeft="0px" WidthTop="0px"></BorderDetails>
											</RowStyleDefault>
                                            <GroupByBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                                                <BandLabelStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                                    Cursor="Default">
                                                </BandLabelStyle>
                                                <Style BackColor="DarkGray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"></Style>
                                            </GroupByBox>
                                            <GroupByRowStyleDefault BackColor="DarkGray" BorderColor="White" BorderStyle="Outset"
                                                BorderWidth="1px">
                                            </GroupByRowStyleDefault>
                                            <ActivationObject BorderColor="170, 184, 131">
                                            </ActivationObject>
                                            <RowExpAreaStyleDefault BackColor="WhiteSmoke">
                                            </RowExpAreaStyleDefault>
                                            <SelectedGroupByRowStyleDefault BackColor="#CF5F5B" BorderColor="White" BorderStyle="Outset"
                                                BorderWidth="1px" ForeColor="White">
                                            </SelectedGroupByRowStyleDefault>
                                            <ImageUrls CollapseImage="./ig_treeXPMinus.GIF" CurrentEditRowImage="./arrow_brown2_beveled.gif"
                                                CurrentRowImage="./arrow_brown2_beveled.gif" ExpandImage="./ig_treeXPPlus.GIF" />
                                            <RowSelectorStyleDefault BackColor="White" BorderStyle="None" BorderWidth="1px">
                                            </RowSelectorStyleDefault>
                                            <SelectedRowStyleDefault BackColor="#BECA98" ForeColor="White">
                                            </SelectedRowStyleDefault>
                                            <RowAlternateStyleDefault BackColor="#E0E0E0">
                                            </RowAlternateStyleDefault>
										</DisplayLayout>
										<Bands>
											<igtbl:UltraGridBand AddButtonCaption="Column0Column1Column2" Key="Column0Column1Column2">
                                                <AddNewRow View="NotSet" Visible="NotSet">
                                                </AddNewRow>
                                            </igtbl:UltraGridBand>
										</Bands>
									</igtbl:ultrawebgrid></TD>
								<TD style="HEIGHT: 338px"></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
			<P><!-- end --></P>
		</form>
	</BODY>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</HTML>
