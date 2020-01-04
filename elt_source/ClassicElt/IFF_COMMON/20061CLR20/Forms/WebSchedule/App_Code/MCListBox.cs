using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.ComponentModel;
using System.Collections;
using System.Text;
namespace Forms
{
	/// <summary>
	/// Summary description for WebCustomControl1.
	/// </summary>
	[DefaultProperty("Rows"),
	ToolboxData("<{0}:MCListBox runat=server></{0}:MCListBox>")]
	public class MCListBox : System.Web.UI.WebControls.WebControl
	{
		private mcRows rows = new mcRows(); 
		private mcRow selectedrow = null;

		public mcRows Rows
		{
			get
			{
				return rows;
			}
			set
			{
				rows = value;
			}
		}

		public mcRow SelectedRow
		{
			get
			{
				return selectedrow; 
			}
			set
			{
				selectedrow = value; 
			}
		}
		

		protected override void OnPreRender(EventArgs e)
		{
			base.OnPreRender (e);

			Infragistics.WebUI.Shared.Util.ClientScript.RegisterCommonScriptResource(Page, Infragistics.WebUI.Shared.Util.ClientScript.JS_RootPath + "ig_shared.js");

			#region Render CSS Styles 
			StringBuilder sb = new StringBuilder();

			sb.Append("<style type='text/css'>\n");
			sb.Append(".MCLSelected\n");
			sb.Append("{\n");
			sb.Append("	background:#316AC5;\n");
			sb.Append("	color:white;\n");
			sb.Append("	cursor:default;\n");
			sb.Append("	Top:0;\n");
			sb.Append("	Height:1px;\n");
			sb.Append("	position:relative;\n");
			sb.Append(" OVERFLOW: hidden;\n");
			sb.Append("}\n\n");

			sb.Append(".MCLRowStyle\n");
			sb.Append("{\n");
			sb.Append("	background:white;\n");
			sb.Append("	color:black;\n");
			sb.Append("	cursor:default;\n");
			sb.Append("	Top:0;\n");
			sb.Append("	Height:1px;\n");
			sb.Append("	position:relative;\n");
			sb.Append(" OVERFLOW: hidden;\n");
			sb.Append("}\n\n");

			sb.Append(".HiddenInput\n");
			sb.Append("{\n");
			sb.Append("	Height:10px;\n");
			sb.Append("	width:0px;\n");
			sb.Append(" Z-index:-1;\n");
			sb.Append(" position:absolute;\n");	
			sb.Append(" font-size:2px;\n");
			sb.Append(" border:0px;\n");
			sb.Append("}\n\n");

			sb.Append("</style>\n");
			this.Page.RegisterClientScriptBlock("mc_styles", sb.ToString());
			#endregion

			#region Render JavaScript

			StringBuilder sbjs = new StringBuilder();

			sbjs.Append("<script language=javascript><!--\n");

			#region Global script

			sbjs.Append("window.onload=function(){windowload(\"" + this.ClientID +"\" )};\n");
			sbjs.Append("try{ig_shared.addEventListener(document, 'keydown', onkeyDown, true);}catch(e){}\n");

			sbjs.Append("var controlID = null;\n");
			sbjs.Append("function windowload(id){\n");
			sbjs.Append("   controlID = id;\n");
			sbjs.Append("}\n");

			if(rows.Count > 0)
				sbjs.Append("var selectedItem = '" + rows[0].ClientId + "';\n");
			else
				sbjs.Append("var selectedItem = null;\n");

			#endregion

			#region function rowSelected

			// Function RowSelected
			sbjs.Append("function rowSelected(newRowId){ \n");
			sbjs.Append("	if(newRowId != selectedItem){\n");
			sbjs.Append("		var newrow = document.getElementById(newRowId);\n");
			sbjs.Append("		var prev = document.getElementById(selectedItem);\n");
			sbjs.Append("		selectedItem = newRowId;\n");
			sbjs.Append("		newrow.className =\"MCLSelected\";\n");
			sbjs.Append("		prev.className='MCLRowStyle';\n");
			sbjs.Append("		if(newrow.parentNode.parentNode.clickEvent)\n");
			sbjs.Append("			eval(newrow.parentNode.parentNode.clickEvent + '('+ newRowId + ')');\n");
			sbjs.Append("	}\n");
			sbjs.Append("}\n");

			#endregion

			#region function rowDoubleClicked

			// Function rowDoubleClicked
			sbjs.Append("function rowDoubleClicked(newRowId){ \n");
			sbjs.Append("	var newrow = document.getElementById(newRowId);\n");
			sbjs.Append("if(newrow.parentNode.parentNode.dblclickEvent)\n");
			sbjs.Append("	eval(newrow.parentNode.parentNode.dblclickEvent + '('+ newRowId + ')');\n");
			sbjs.Append("}\n");

			#endregion

			#region function keyDown

			// Function KeyDown

			sbjs.Append("function onkeyDown(evnt){\n");
			sbjs.Append(" if(controlID != null){");
			sbjs.Append("	var tbody = document.getElementById(controlID+'_m').getElementsByTagName('tbody')[0];\n");
			sbjs.Append("	var rows = tbody.getElementsByTagName('tr');\n");	
			sbjs.Append("	if(selectedItem != null){	\n");
			sbjs.Append("	var input = document.getElementById('mc_Input');\n");
			sbjs.Append("	if(input == null){\n");
			sbjs.Append("		input = document.createElement('input');\n");
			sbjs.Append("		input.id = 'mc_Input';\n");
			sbjs.Append("		input.className = 'HiddenInput';\n");
			sbjs.Append("	}	\n");
			sbjs.Append("		var row = document.getElementById(selectedItem);\n");
			sbjs.Append("		var curIndex = row.rowIndex;\n");
			sbjs.Append("		if(evnt.keyCode == 38){ // up\n");
			sbjs.Append("			if(curIndex > 0){\n");
			sbjs.Append("				selectedItem = rows[curIndex-1].id;\n");
			sbjs.Append("				rows[curIndex-1].className = 'MCLSelected';\n");
			sbjs.Append("				rows[curIndex].className = 'MCLRowStyle';\n");
			sbjs.Append("				rows[curIndex-1].childNodes[2].appendChild(input);\n");
			sbjs.Append("				input.focus();\n");
			sbjs.Append("				rows[curIndex-1].childNodes[0].focus();\n");
			sbjs.Append("			if(rows[curIndex-1].parentNode.parentNode.keyDownEvent)\n");
			sbjs.Append("				eval(rows[curIndex-1].parentNode.parentNode.keyDownEvent + '('+ rows[curIndex-1].id + ',' + evnt.keyCode+ ')');\n");
			sbjs.Append("			}\n");
			sbjs.Append("		}									\n");
			sbjs.Append("		else if(evnt.keyCode == 40)	{ //down \n");
			sbjs.Append("			if(curIndex < rows.length-2){\n");
			sbjs.Append("				selectedItem = rows[curIndex+1].id;\n");
			sbjs.Append("				rows[curIndex+1].className = 'MCLSelected';\n");
			sbjs.Append("				rows[curIndex].className = 'MCLRowStyle';\n");
			sbjs.Append("				rows[curIndex+1].childNodes[2].appendChild(input);\n");
			sbjs.Append("				input.focus();\n");
			sbjs.Append("				rows[curIndex+1].childNodes[0].focus();\n");
			sbjs.Append("			if(rows[curIndex+1].parentNode.parentNode.keyDownEvent)\n");
			sbjs.Append("				eval(rows[curIndex+1].parentNode.parentNode.keyDownEvent + '('+ rows[curIndex+1].id + ',' + evnt.keyCode+ ')');\n");
			sbjs.Append("			}				\n");
			sbjs.Append("		} \n");
			sbjs.Append("		else \n");
			sbjs.Append("				eval(row.parentNode.parentNode.keyDownEvent + '('+ selectedItem + ',' + evnt.keyCode+ ')');\n");
			sbjs.Append("	}\n");
			sbjs.Append("	}\n");
			sbjs.Append("}\n");

			#endregion

			#region function getRowCount
			
			sbjs.Append("function getRowCount(controlID)	{ \n");
			sbjs.Append("	var mc_control = document.getElementById(controlID + '_m');\n");
			sbjs.Append("	var tbody = mc_control.getElementsByTagName('tbody')[0];\n");
			sbjs.Append("	var rows = tbody.getElementsByTagName('tr');\n");
			sbjs.Append("	return rows.length - 1;\n");
			sbjs.Append("}\n");

			#endregion

			#region function removeRow
			// Function Remove Row

			sbjs.Append("function removeRow(controlID, id)	{ \n");
			sbjs.Append("	if(id != null)	{\n");
			sbjs.Append("		var row = document.getElementById(id);\n");
			sbjs.Append("		var prevRowIndex = row.rowIndex; \n");
			sbjs.Append("		var input = document.getElementById('mc_Input');\n");
			sbjs.Append("		var mc_control = document.getElementById(controlID + '_m');\n");
			sbjs.Append("		if(input != null)\n");
			sbjs.Append("			mc_control.appendChild(input);\n");
			sbjs.Append("		row.parentNode.removeChild(row);\n");
			sbjs.Append("		if(selectedItem == id)	{\n");
			sbjs.Append("			var tbody = mc_control.getElementsByTagName('tbody')[0];\n");
			sbjs.Append("			var rows = tbody.getElementsByTagName('tr');\n");
			sbjs.Append("			var index = prevRowIndex-1;\n");
			sbjs.Append("			if(index == -1 & rows.length > 1)\n");
			sbjs.Append("				index = 0;\n");
			sbjs.Append("			if(index != -1)	{\n");
			sbjs.Append("				selectedItem = rows[index].id;\n");
			sbjs.Append("				rows[index].className='MCLSelected';\n");
			sbjs.Append("				if(input != null){\n");
			sbjs.Append("					rows[index].childNodes[2].appendChild(input);\n");
			sbjs.Append("					input.focus();\n");
			sbjs.Append("				}\n");
			sbjs.Append("			}\n");
			sbjs.Append("			else\n");
			sbjs.Append("				selectedItem = null;\n");
			sbjs.Append("		}\n");
			sbjs.Append("	}\n");
			sbjs.Append("}\n");

			#endregion

			#region selectStart()

			//selectStart()
			sbjs.Append("function selectStart(){ \n");
			sbjs.Append("	window.event.returnValue = false;\n");
			sbjs.Append("}\n");

			#endregion

			#region function addRow

			// Function Add Row
			sbjs.Append("function addRow(controlID, value1, value2, value3, dataKey){\n");
			sbjs.Append("		var tbody = document.getElementById(controlID + '_m').getElementsByTagName('tbody')[0];\n");
			sbjs.Append("		var rows = tbody.getElementsByTagName('tr');\n");
			sbjs.Append("		var remove = rows[rows.length -1];\n");
			sbjs.Append("		remove.parentNode.removeChild(remove);\n");
			sbjs.Append("		var newRow = document.createElement('tr');\n");
			sbjs.Append("		newRow.setAttribute('dataKey', dataKey);\n");
			sbjs.Append("		var cell1 = document.createElement('td');\n");
			sbjs.Append("		cell1.innerHTML = value1\n");
			sbjs.Append("		cell1.style.width = '0%';\n");
			sbjs.Append("		var cell2 = document.createElement('td');\n");
			sbjs.Append("		cell2.innerHTML = '&nbsp;&nbsp;' + value2;\n");
			sbjs.Append("		cell2.style.width = '50%';\n");
			sbjs.Append("		var cell3 = document.createElement('td');\n");
			sbjs.Append("		cell3.innerHTML = '&nbsp; &nbsp;' + value3;\n");
			sbjs.Append("		cell3.style.width = '50%';\n");
			sbjs.Append("		cell3.noWrap = 'true';\n");
			sbjs.Append("		newRow.appendChild(cell1);\n");
			sbjs.Append("		newRow.appendChild(cell2);\n");
			sbjs.Append("		newRow.appendChild(cell3);\n");
			sbjs.Append("		var index = 0;\n");
			sbjs.Append("		if(rows.length > 0)\n");
			sbjs.Append("			index = parseInt(rows[rows.length-1].id.replace('MCROW_','')) + 1;\n");
			sbjs.Append("		newRow.id= 'MCROW_' + index;\n");
			sbjs.Append("		newRow.className = 'MCLRowStyle';\n");
			sbjs.Append("		tbody.appendChild(newRow);\n");
			sbjs.Append("		newRow.onclick = function(){rowSelected(newRow.id)};\n");
			sbjs.Append("		newRow.ondblclick = function(){rowDoubleClicked(newRow.id)};\n");
			sbjs.Append("		newRow.onselectstart = function(){selectStart()}\n");
			sbjs.Append("		tbody.appendChild(document.createElement('tr'));\n");
			sbjs.Append("		if(index == 0){\n");
			sbjs.Append("			selectedItem = newRow.id;\n");
			sbjs.Append("			newRow.className = 'MCLSelected';\n");
			sbjs.Append("		}\n");
			sbjs.Append("		return newRow;\n");
			sbjs.Append(" }\n");				

			#endregion
				
			sbjs.Append("--></script>\n");

			Page.RegisterClientScriptBlock("mc_script",sbjs.ToString());

			#endregion		
		}

		protected override void Render(HtmlTextWriter output)
		{
			if(selectedrow == null && rows.Count > 0)
				selectedrow = rows[0];			

			output.WriteLine("<div style='overflow:auto; height:100%; background:white; width:100%' >");

			output.WriteLine("<table class='Fonts' cellSpacing=0 height=100% width=100% id='" + this.ClientID + "_m'>");
			for(int i = 0; i < rows.Count; i++)
			{
				mcRow row = rows[i];

				string cssClass; 

				if(row == selectedrow)
					cssClass = "MCLSelected";
				else
					cssClass = "MCLRowStyle";
				output.WriteLine("<tr class="+ cssClass + " id='"+ row.ClientId +"'onclick='rowSelected(\"" + row.ClientId  +  "\")'>");
				output.WriteLine("<td width=0%>");
				output.WriteLine(row.C1Text);
				output.WriteLine("</td>");

				output.WriteLine("<td width=50%>");
				output.WriteLine(row.C2Text.Replace("<","&lt;"));
				output.WriteLine("</td>");

				output.WriteLine("<td width=50%>");
				output.WriteLine(row.C3Text);
				output.WriteLine("</td>");
				output.WriteLine("</tr>");				
			}

			output.WriteLine("<tr height=100%></tr>");
			
			output.WriteLine("</table>");
			
			output.WriteLine("</div>");
		
		}
	}

	#region class mcRows

	public class mcRows : System.Collections.CollectionBase	
	{
		private ArrayList rows = new ArrayList();

		public mcRow Add(mcRow r)
		{
			rows.Add(r);

			return (mcRow)rows[rows.Count-1];
		}

		public mcRow this[int index]
		{
			get
			{
				return (mcRow)rows[index];
			}
		}

		public int Count
		{
			get
			{
				return rows.Count;
			}
		}
	}

	#endregion

	#region class mcRow

	public class mcRow 
	{
		private string c1text; 
		private string c2text; 
		private string c3text; 
		private int index; 

		public string ClientId
		{
			get
			{
				return "MCROW_"+index;
			}
		}

		public string C1Text
		{
			get
			{
				return c1text;
			}

			set
			{
				c1text = value;
			}
		}

		public string C2Text
		{
			get
			{
				return c2text;
			}

			set
			{
				c2text = value;
			}
		}

		public string C3Text
		{
			get
			{
				return c3text;
			}

			set
			{
				c3text = value;
			}
		}

		public int Index
		{
			get
			{
				return index; 
			}
			set
			{
				index = value; 
			}
		}

	}

}

#endregion


