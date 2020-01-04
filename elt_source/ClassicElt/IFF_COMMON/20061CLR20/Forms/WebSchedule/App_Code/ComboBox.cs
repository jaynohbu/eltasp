using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.ComponentModel;
using System.Collections;
using System.Text;
namespace Forms
{
	/// <summary>
	/// Summary description for ComboBox.
	/// </summary>
	[ToolboxData("<{0}:ComboBox runat=server></{0}:ComboBox>")]
	public class ComboBox : System.Web.UI.WebControls.WebControl
	{

		protected override void OnPreRender(EventArgs e)
		{
			base.OnPreRender (e);

			Infragistics.WebUI.Shared.Util.ClientScript.RegisterCommonScriptResource(Page, "/ig_common/"+Infragistics.WebUI.Shared.AssemblyVersion.Build+"/scripts/ig_shared.js");

			#region Render JavaScript

			#region Global script
			StringBuilder sbgjs = new StringBuilder();
			sbgjs.Append("<script language=javascript><!--\n");
			sbgjs.Append("ig_shared.addEventListener(window, 'load', windowload, true);\n");
			sbgjs.Append("function windowload(){\n");
			sbgjs.Append("	var iframe = document.createElement('iframe');\n");
			sbgjs.Append("	iframe.height = '0px';\n");
			sbgjs.Append("	iframe.width = '0px';\n");
			sbgjs.Append("	iframe.src = 'javascript:new String(\"<html></html>\")';\n");
			sbgjs.Append("	iframe.style.visibility = 'hidden';\n");
			sbgjs.Append("	iframe.style.position = 'absolute';\n");
			sbgjs.Append("	iframe.id = '" + this.ClientID +"_comboFrame';		\n");
			sbgjs.Append("	iframe.style.zIndex = '10000';		\n");
			sbgjs.Append("	document.body.appendChild(iframe);\n");
			sbgjs.Append("	iframe.contentWindow.document.onselectstart = function(){return false;}\n");
			sbgjs.Append("}\n");
			sbgjs.Append("--></script>\n");
            	
			Page.RegisterClientScriptBlock(this.ClientID+"_Globaljavascript",sbgjs.ToString());
			#endregion
			StringBuilder sbjs = new StringBuilder();
			sbjs.Append("<script language=javascript><!--\n");
			sbjs.Append("ig_shared.addEventListener(document, 'mousedown', closeDropDown, true);\n");
			sbjs.Append("ig_shared.addEventListener(document, 'mouseup', closeDropDown, true);\n");
			sbjs.Append("var webComobFirstTime = true;\n");

			#region closeDropDown(evnt, id)

			sbjs.Append("function closeDropDown(evnt, id){\n");
			sbjs.Append("	mouseDown = false;\n");
			sbjs.Append("	if(id == null){\n");
			sbjs.Append(		"var iframes = document.getElementsByTagName('IFRAME');\n");
			sbjs.Append("		for(var i = 0; i < iframes.length; i++){\n");
			sbjs.Append("			var iframeid = iframes[i].id.split('_');\n");
			sbjs.Append("			if(iframeid[iframeid.length-1] == 'comboFrame'){\n");
			sbjs.Append("				id = iframes[i].id.replace('_comboFrame', '');\n");
			sbjs.Append("				var iframe = iframes[i];\n");
			sbjs.Append("				iframe.height = '0px';\n");
			sbjs.Append("				iframe.width = '0px';\n");
			sbjs.Append("				if(iframe.style.visibility == 'visible'){\n");
			sbjs.Append("					iframe.style.visibility = 'hidden';\n");
			sbjs.Append("					var div = iframe.contentWindow.document.getElementById(id+'_parentDiv');\n");
			sbjs.Append("					iframe.contentWindow.document.body.removeChild(div);\n");
			sbjs.Append("				}\n");
			sbjs.Append("			}\n");
			sbjs.Append("		}\n");
			sbjs.Append("	}\n");
			sbjs.Append("	else\n{");
			sbjs.Append("		var iframe = document.getElementById(id +'_comboFrame');\n");
			sbjs.Append("		if(iframe.style.visibility == 'visible'){\n");
			sbjs.Append("			iframe.style.visibility = 'hidden';\n");
			sbjs.Append("			var div = iframe.contentWindow.document.getElementById(id+'_parentDiv');\n");
			sbjs.Append("			iframe.contentWindow.document.body.removeChild(div);\n");
			sbjs.Append("		}\n");
			sbjs.Append("	}\n");
			
			sbjs.Append("}\n");

			#endregion

			#region ShowCombo(id)

			sbjs.Append("function ShowCombo(id){\n");
            sbjs.Append("var iframe = document.getElementById(id+'_comboFrame');\n");
			sbjs.Append("	var link = iframe.contentWindow.document.createElement('link');\n");
			sbjs.Append("	var fileName = document.location.href.split('/');\n");				
			sbjs.Append("	var path = document.location.href.replace(fileName[fileName.length-1],'');\n");
			sbjs.Append("	link.href = path + './Styles/AppointmentDialog.css';\n");
			sbjs.Append("	link.type = 'text/css';\n");
			sbjs.Append("	link.rel = 'stylesheet';\n");
			sbjs.Append("	var head = iframe.contentWindow.document.childNodes[0];\n");
			sbjs.Append("	while(head.tagName != 'HTML') head = head.nextSibling;\n");
			sbjs.Append("	head = head.childNodes[0];\n");
			sbjs.Append("	while(head.tagName != 'HEAD') head = head.nextSibling;\n");
			sbjs.Append("	head.appendChild(link);\n");
			sbjs.Append("if(iframe.style.visibility == 'hidden'){\n");
			sbjs.Append("	var pdiv = iframe.contentWindow.document.createElement('div');\n");
			sbjs.Append("	pdiv.id = id+'_parentDiv';\n");
			sbjs.Append("	pdiv.style.position = 'absolute';");
			sbjs.Append("	pdiv.style.top = 0;\n");
			sbjs.Append("	pdiv.style.left = 0;\n");
			sbjs.Append("	pdiv.className = 'Fonts';\n");
			sbjs.Append("	iframe.contentWindow.document.body.style.backgroundColor = 'white';\n");
			sbjs.Append("	iframe.contentWindow.document.body.appendChild(pdiv);\n");
			sbjs.Append("	ig_shared.addEventListener(pdiv, 'mousedown', itemSelectStart, true);\n");
			sbjs.Append("	ig_shared.addEventListener(pdiv, 'mouseup', itemSelected, true);\n");
			sbjs.Append("	ig_shared.addEventListener(pdiv, 'mouseover', itemHover, true);\n");
			sbjs.Append("	var control = document.getElementById(id + '_control');\n");
			sbjs.Append("	var inputbox = document.getElementById(id + '_inputbox');\n");
			sbjs.Append("   var returnVal =	eval(document.getElementById(id+'_control').dropDownEvent + '()');\n");
			sbjs.Append("   if(returnVal)\n");
			sbjs.Append("		return;\n");
			sbjs.Append("	var tempControl = inputbox\n");
			sbjs.Append("	var top = inputbox.offsetHeight;\n");
			sbjs.Append("	while(tempControl != null){\n");
			sbjs.Append("		top += tempControl.offsetTop;\n");
			sbjs.Append("		if(tempControl.tagName == 'BODY');\n");
			sbjs.Append("			top -= tempControl.scrollTop;\n");
            sbjs.Append("		tempControl = tempControl.offsetParent;\n");
			sbjs.Append("	}\n");
			sbjs.Append("	iframe.style.top = top;\n");
			sbjs.Append("	tempControl = control\n");
            sbjs.Append("	var left = 0;\n");
			sbjs.Append("	if(inputbox.clientLeft)\n");
			sbjs.Append("		left = inputbox.clientLeft;\n");
			sbjs.Append("	while(tempControl.tagName != 'BODY'){\n");
			sbjs.Append("		left += tempControl.offsetLeft;\n");
			sbjs.Append("		tempControl = tempControl.offsetParent;\n");
			sbjs.Append("	}\n");
			sbjs.Append("	iframe.style.left = left;\n");
			sbjs.Append("	iframe.height = '200px';\n");
			sbjs.Append("	iframe.width = '100px';\n");
			sbjs.Append("	iframe.style.visibility = 'visible';\n");
			sbjs.Append("}\n");
			sbjs.Append("}\n");

			#endregion

			#region comboBox_addItems(id, array)

			sbjs.Append("function comboBox_addItems(id, array){\n");
			sbjs.Append("var iframe = document.getElementById(id+'_comboFrame');\n");
			sbjs.Append("var pdiv = iframe.contentWindow.document.getElementById(id+'_parentDiv');\n");
			sbjs.Append("for(var i =0 ; i < array.length; i++)	{\n");
			sbjs.Append("	var cdiv = iframe.contentWindow.document.createElement('div');\n");
			sbjs.Append("	cdiv.innerHTML = array[i];\n");
			sbjs.Append("	cdiv.className = 'Fonts';\n");
			sbjs.Append("	cdiv.style.cursor = 'pointer';\n");
			sbjs.Append("	cdiv.style.width = '78px';\n");
			sbjs.Append("	pdiv.appendChild(cdiv);	\n");
			sbjs.Append("}\n");
			sbjs.Append("}\n");

			#endregion

			#region comboBox_getValue(id)

			sbjs.Append("function comboBox_getValue(id){\n");
			sbjs.Append("return document.getElementById(id+'_inputbox').value;\n");
			sbjs.Append("}\n");

			#endregion

			#region comboBox_setValue(id, value, updatePrev)

			sbjs.Append("function comboBox_setValue(id, value, updatePrev){\n");
			sbjs.Append("var combo = document.getElementById(id+'_inputbox');\n");
			sbjs.Append("if(updatePrev || updatePrev == null){\n");
			sbjs.Append("	if(combo.value == '')\n");
			sbjs.Append("		combo.prevValue = value;\n");
			sbjs.Append("	else\n");
			sbjs.Append("		combo.prevValue = combo.value;\n");
			sbjs.Append("}\n");
			sbjs.Append("combo.value = value;\n");
			sbjs.Append("}\n");

			#endregion

			#region comboBox_scrollItemIntoView(id, selectedElem)

			sbjs.Append("var tempId = null;\n");
			sbjs.Append("var tempSelectedElement = null;\n");
			sbjs.Append("function comboBox_scrollItemIntoView(id, selectedElement){\n");
			sbjs.Append("	var iframe = document.getElementById(id+'_comboFrame');\n");
			sbjs.Append("	var parent = iframe.contentWindow.document.getElementById(id+'_parentDiv');\n");
			sbjs.Append("	var parentElem = iframe.contentWindow.document.body;\n");
			sbjs.Append("	var childElem = selectedElement;\n");
			sbjs.Append("	var parentTop = parentElem.offsetTop;\n");
			sbjs.Append("	var childTop = childElem.offsetTop;\n");
			sbjs.Append("	if(parentElem.scrollTop == 0){\n");
			sbjs.Append("		tempId = id;\n");
			sbjs.Append("		tempSelectedElement = selectedElement;	\n");
			sbjs.Append("		setTimeout('comboBox_scrollItemIntoView(tempId,tempSelectedElement)', 30);\n");
			sbjs.Append("	}\n");
			sbjs.Append("	parentElem.scrollTop = childTop;\n");
			sbjs.Append("}\n");	
			
			#endregion scrollintoview

			#region MouseDown MouseUp MouseOver

			sbjs.Append("var lastSelected = null;\n");
			sbjs.Append("var mouseDown = false;\n");
			sbjs.Append("function itemSelectStart(evnt){\n");
			sbjs.Append("	var src;\n");
			sbjs.Append("	if(evnt.target) \n");
			sbjs.Append("		src = evnt.target;\n");
			sbjs.Append("	else \n");
			sbjs.Append("		src = evnt.srcElement;\n");
			sbjs.Append("	if(src.tagName == 'DIV'){\n");
			sbjs.Append("		var id = src.parentNode.id.replace('_parentDiv', '');\n");
			sbjs.Append("		if(lastSelected != null){\n");
			sbjs.Append("			lastSelected.style.background = 'white';\n");
			sbjs.Append("			lastSelected.style.color = 'black';\n");
			sbjs.Append("		}\n");
			sbjs.Append("		lastSelected = src;\n");
			sbjs.Append("		src.style.background = 'navy';\n");
			sbjs.Append("		src.style.color = 'white';\n");			
			sbjs.Append("		eval(document.getElementById(id + '_control').itemSelect + \"( id,  '\"+  src.innerHTML + \"' )\" );\n");
			sbjs.Append("		mouseDown = true;\n");
			sbjs.Append("	}\n");
			sbjs.Append("	var iframe = document.getElementById(id+'_comboFrame');\n");
			sbjs.Append("}\n");

			sbjs.Append("function itemSelected(evnt){\n");
			sbjs.Append("	mouseDown = false;\n");
			sbjs.Append("	var src;\n");
			sbjs.Append("	if(evnt.target) \n");
			sbjs.Append("		src = evnt.target;\n");
			sbjs.Append("	else\n"); 
			sbjs.Append("		src = evnt.srcElement;\n");
			sbjs.Append("	if(src.tagName == 'DIV'){\n");
			sbjs.Append("		var id = src.parentNode.id.replace('_parentDiv', '');\n");
			sbjs.Append("		closeDropDown(null, id);\n");
			sbjs.Append("		document.getElementById(id + '_inputbox').onblur();\n");
			sbjs.Append("	}\n");
			sbjs.Append("	else\n");
			sbjs.Append("		closeDropDown();\n");
			sbjs.Append("}\n");

			sbjs.Append("function itemHover(evnt){\n");
			sbjs.Append("	var src;\n");
			sbjs.Append("	if(evnt.target) \n");
			sbjs.Append("		src = evnt.target;\n");
			sbjs.Append("	else \n");
			sbjs.Append("		src = evnt.srcElement;\n");
			sbjs.Append("	if(src.tagName == 'DIV'){\n");
			sbjs.Append("		var id = src.parentNode.id.replace('_parentDiv', '');\n");
			sbjs.Append("		if(mouseDown == true){\n");
			sbjs.Append("			if(lastSelected != null){\n");
			sbjs.Append("				lastSelected.style.background = 'white';\n");
			sbjs.Append("				lastSelected.style.color = 'black';\n");
			sbjs.Append("			}\n");
			sbjs.Append("			lastSelected = src;\n");
			sbjs.Append("			src.style.background = 'navy';\n");
			sbjs.Append("			src.style.color = 'white';\n");
			sbjs.Append("		eval(document.getElementById(id + '_control').itemSelect + \"( id,  '\"+  src.innerHTML + \"' )\" );\n");
			sbjs.Append("		}\n");
			sbjs.Append("	}\n");
			sbjs.Append("}\n");
				
			#endregion

			sbjs.Append("--></script>\n");
			Page.RegisterClientScriptBlock("cb_script",sbjs.ToString());
			

			#endregion		
		}

		protected override void Render(HtmlTextWriter output)
		{
			output.AddAttribute(System.Web.UI.HtmlTextWriterAttribute.Cellpadding, "0");
			output.AddAttribute(System.Web.UI.HtmlTextWriterAttribute.Cellspacing, "0");
			output.AddAttribute(System.Web.UI.HtmlTextWriterAttribute.Id, this.ClientID + "_control");
			output.RenderBeginTag(System.Web.UI.HtmlTextWriterTag.Table);
			output.RenderBeginTag(System.Web.UI.HtmlTextWriterTag.Tr);
			output.RenderBeginTag(System.Web.UI.HtmlTextWriterTag.Td);
			output.AddAttribute(System.Web.UI.HtmlTextWriterAttribute.Id, this.ClientID + "_inputbox");
			output.AddAttribute(System.Web.UI.HtmlTextWriterAttribute.Class, "Fonts");
			output.AddAttribute(System.Web.UI.HtmlTextWriterAttribute.Tabindex, this.TabIndex.ToString());
			output.RenderBeginTag(System.Web.UI.HtmlTextWriterTag.Input);
			output.RenderEndTag();			// Input
			output.RenderEndTag();			// Td
			output.RenderBeginTag(System.Web.UI.HtmlTextWriterTag.Td);
			output.WriteLine("<BUTTON style='WIDTH: 15px; HEIGHT: 20px' onfocus='blur()' onclick='ShowCombo(\""+this.ClientID+"\")'  type='button' ID='Button1'>");
			output.Write("<img src = './Images/downarrow.gif'>");
			output.WriteLine("</BUTTON>");
			output.RenderEndTag();			// TD
			output.RenderEndTag();			// Tr
			output.RenderEndTag();			// Table
		
		}
	}



}