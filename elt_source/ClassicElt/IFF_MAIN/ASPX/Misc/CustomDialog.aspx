<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomDialog.aspx.cs" Inherits="WebSpellChecker_WebSpellCheckerCustomDialog_CustomDialog" %>
<%@ Register TagPrefix="ig_spell" Namespace="Infragistics.WebUI.WebSpellChecker" Assembly="Infragistics.WebUI.WebSpellChecker, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Custom SpellChecker Title</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio 7.0">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body style="PADDING-RIGHT:0px; PADDING-LEFT:0px; PADDING-BOTTOM:0px; MARGIN:0px; PADDING-TOP:0px">
		<form id="CustomDialog" method="post" runat="server" style="PADDING-RIGHT:0px; PADDING-LEFT:0px; PADDING-BOTTOM:0px; MARGIN:0px; PADDING-TOP:0px">
			<ig_spell:WebSpellCheckerDialog id="WebSpellCheckerDialog1" runat="server" StyleSheetDirectory="./" StyleSheetFileName="CustomStyle.css">
				<Template>
					<DIV class="igspell_Wrapper" id="wrapper" runat="server">
						<DIV class="igspell_documentTextPanel" id="documentTextPanel" runat="server"></DIV>
						<br />
						<h3 align="center" style="color:darkgray;font-weight:bold;font-family:verdana;">Custom 
							Spell Checker</h3>
						<SPAN class="igspell_label igspell_changeToLabel" id="changeToLabel" runat="server">
							Change To:</SPAN> <INPUT class="igspell_changeToBox" id="changeToBox" type="text" runat="server" NAME="changeToBox"></INPUT>
						</INPUT></INPUT></INPUT></INPUT><SELECT class="igspell_suggestions" id="suggestions" size="6" runat="server" NAME="suggestions"></SELECT>
						<SPAN class="igspell_label igspell_suggestionsLabel" id="suggestionsLabel" runat="server">
							Suggestions:</SPAN> <a href="#"><BUTTON class="igspell_button igspell_ignoreButton" id="ignoreButton" type="button" runat="server">
								Ignore</BUTTON> </a><a href="#"><BUTTON class="igspell_button igspell_ignoreAllButton" id="ignoreAllButton" type="button" runat="server">
								Ignore All</BUTTON> </a><a href="#"><BUTTON class="igspell_button igspell_addButton" id="addButton" type="button" runat="server">
								Add</BUTTON> </a><a href="#"><BUTTON class="igspell_button igspell_changeButton" id="changeButton" type="button" runat="server">
								Change</BUTTON> </a><a href="#"><BUTTON class="igspell_button igspell_changeAllButton" id="changeAllButton" type="button" runat="server">
								Change All</BUTTON> </a><a href="#"><BUTTON class="igspell_button igspell_finishButton" id="finishButton" type="button" runat="server">
								Finish</BUTTON> </a>
					</DIV>
				</Template>
			</ig_spell:WebSpellCheckerDialog>
		</form>
	</body>
</HTML>

