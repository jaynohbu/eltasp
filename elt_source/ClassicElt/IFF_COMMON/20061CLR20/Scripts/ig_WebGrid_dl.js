 /*
  * Infragistics WebGrid CSOM Script: ig_WebGrid_dl.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

// ig_WebGrid_dl.js
// Infragistics UltraWebGrid Script 
// Copyright (c) 2001-2006 Infragistics, Inc. All Rights Reserved.
function igtbl_doPostBack(controlID, args, clientFunc)
{
	if (clientFunc != undefined && clientFunc !='')
		eval(clientFunc+"();");
	__doPostBack(controlID, args);
}

function igtbl_updateRow(controlID, rowID, cellCount)
{
	var hiddenfld = "ChangedCells\01";
	for (var j=0; j<cellCount; j++)
	{
		var cellname = controlID+"Cell"+rowID+"_"+j;
		var cell=igtbl_getElementById(cellname);
		if(cell)
		{
			if(cell.type=="checkbox")
				hiddenfld += controlID+"_rc"+rowID+"_"+j + "\02" + cell.checked.toString();
			else
				hiddenfld += controlID+"_rc"+rowID+"_"+j + "\02" + cell.value;
			if (j!=cellCount-1)
				hiddenfld+="\03";
		}
	}
	var hf=igtbl_getElementById(controlID);
	if(hf)
		hf.value = hiddenfld;
	__doPostBack(controlID, "Update:"+rowID);
}

function igtbl_editRow(controlID, rowID)
{
	var hf=igtbl_getElementById(controlID);
	if(hf)
		hf.value = "ActiveRow\01"+controlID + "r"+rowID;
	__doPostBack(controlID, "Edit:"+rowID);
}

function igtbl_deleteRow(controlID, rowID)
{
	var hf=igtbl_getElementById(controlID);
	if(hf)
		hf.value = "DeletedRows\01"+controlID + "r"+rowID;
	__doPostBack(controlID, "");
}

function igtbl_addNew(controlID, rowID)
{
	var hf=igtbl_getElementById(controlID);
	if(hf)
	{
		hf.value = "AddedRows\01"+controlID + "r"+rowID;
		hf.value += "\04ActiveRow\01"+controlID + "r"+rowID;
	}
	__doPostBack(controlID, "");
}

function igtbl_expandRow(controlID, rowID, args)
{
	var hf=igtbl_getElementById(controlID);
	if(hf)
		hf.value="ExpandedRows\01"+controlID+"r"+rowID;
	__doPostBack(controlID, args);
}

function igtbl_collapseRow(controlID, rowID, args)
{
	var hf=igtbl_getElementById(controlID);
	if(hf)
		hf.value="CollapsedRows\01"+controlID+"r"+rowID;
	__doPostBack(controlID, args);
}

function igtbl_selectRow(controlID, rowID)
{
	__doPostBack(controlID, "SelectRow:"+rowID);
}

function igtbl_getElementById(tagId) {
	for (var i=0; i<document.forms.length; i++)
		if(document.forms[i].elements)
			for (var j=0; j<document.forms[i].elements.length; j++)
				if (document.forms[i].elements[j].name == tagId) 
					return document.forms[i].elements[j];
	return null;
}

function igtbl_btnClick(controlID,cellId)
{
	__doPostBack(controlID, "CellButtonClick:"+cellId);
}
