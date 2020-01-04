// This file contains java script used by the DropDownGrid.aspx form.
//
// flag to avoid multiple listeners to same mouse-down event
var globalListenerWasCreated = false;
// references to drop-down grids
var dropDownGrids = new Array();
// it is called when drop-down grid is initialized
function initGridEvent(gridName)
{
	var oGrid = igtbl_getGridById(gridName);
	if(oGrid == null)
	{
		alert("Error: \"" + gridName + "\" was not found.");
		return;
	}
	oGrid.mainElement = ig_csom.getElementById(gridName + "_main");
	if(oGrid.mainElement == null)
	{
		alert("Error: \"" + gridName + "_main\" was not found.");
		return;
	}
	// ensure absolute position
	// Note: it can be skipped if style in aspx has that
	oGrid.mainElement.style.position = "absolute";
	// assume that grid on start is visible
	// create boolean member variable, which simplifies visibility test
	oGrid.isDisplayed = true;
	// global cash of grid-reference
	dropDownGrids[dropDownGrids.length] = oGrid;
	// hide drop-down grid
	showDropDown(oGrid, null, false);
}
// it is called by date click events of UltraWebGrid
// Note: that name should match with the ClientSideEvents.CellClickHandler property
//  which is set in aspx for UltraWebGrid
function cellClickEvent(gridName, cellId, button)
{
	var oGrid = igtbl_getGridById(gridName);
	var oCell = igtbl_getCellById(cellId);
	if(oGrid == null || oCell == null)
	{
		alert("Error: \"" + gridName + "\" was not found.");
		return;
	}
	// update editor with latest text and hide grid
	showDropDown(oGrid, oCell.getValue(), false, true);
}
// it is called by custom-button click event of WebTextEdit
// Note: that name should match with the ClientSideEvents.CustomButtonPress property
//  which is set in aspx for WebTextEdit
function openDropDownEvent(oEdit, text, oEvent)
{
	// open drop-down grid
	openDropDown(oEdit, dropDownGrids[0]);
}
// it is called by spin and focus events of WebTextEdit
// Note: that name should match with the ClientSideEvents.KeyDown/Spin/Focus/etc. properties
//  which are set in aspx for WebTextEdit
function closeDropDownEvent(oEdit, text, oEvent)
{
	// hide grid
	showDropDown(oEdit.oGrid, null, false);
}
// open grid and attach it to WebTextEdit
// oEdit - reference to the owner of grid (WebTextEdit)
// oGrid - the UltraWebGrid which should be dropped and attached to oEdit
function openDropDown(oEdit, oGrid)
{
	if(oGrid == null) return;
	// add listener to mouse click events for page
	if(!globalListenerWasCreated)
		ig_csom.addEventListener(window.document, "mousedown", globalMouseDown, false);
	globalListenerWasCreated = true;
	// set reference of grid to editor:
	// create member variable, which points to drop-down grid
	oEdit.oGrid = oGrid;
	// if it belongs to another oEdit, then close oGrid
	if(oGrid.oEdit != oEdit)
	{
		showDropDown(oGrid, null, false);
		// set reference in oGrid to this oEdit
		// create member variable, which points to the owner oEdit
		oGrid.oEdit = oEdit;
	}
	// show grid with text from editor
	// if grid is already opened, then hide grid (last param)
	showDropDown(oGrid, oEdit.getText(), true, true, true);
}
// synchronize text in TextEdit with selected cell in grid
// and show/close grid
function showDropDown(oGrid, text, show, update, toggle)
{
	if(oGrid == null) return;
	if(toggle == true && oGrid.isDisplayed == true)
		show = update = false;
	// update editor with latest text
	if(update == true)
	{
		if(oGrid.isDisplayed)
			oGrid.oEdit.setText(text);
		else
		{
			// find cell in grid and select it
			var r = null, c = null;
			for(var row = 0; row < 1000; row++)
			{
				if((r = oGrid.Rows.getRow(row)) == null) break;
				var iColCount = r.Band.Columns.length;
				for(var col = 0; col < iColCount; col++)				
				//for(var col = 0; col < 100; col++)
				{
					if((c = r.getCell(col)) == null) break;
					if(c.getValue() == text){row = 1000; break;}
				}
			}
			if(c != null)
			{
				c.setSelected(true);
				c.activate();
			}
			else
			{
				oGrid.clearSelectionAll();
				oGrid.setActiveCell(null);
			}
		}
	}
	// check current state of grid
	if(oGrid.isDisplayed == show)
		return;
	// show/hide grid
	oGrid.mainElement.style.display = show ? "block" : "none";
	oGrid.mainElement.style.visibility = show ? "visible" : "hidden";
	oGrid.isDisplayed = show;
	if(show)
		positionGrid(oGrid);
}
// set position of grid below/above TextEdit
function positionGrid(oGrid)
{
	var elem = oGrid.oEdit.Element;
	// left and top position of grid
	var x = 0, y = elem.offsetHeight;
	if(y == null) y = 0;
	// width and height of super parent (document)
	var w = 0, h = 0;
	while(elem != null)
	{
		if(elem.offsetLeft != null) x += elem.offsetLeft;
		if(elem.offsetTop != null) y += elem.offsetTop;
		h = elem.offsetHeight;
		w = elem.offsetWidth;
		elem = elem.offsetParent;
	}
	// check if grid fits below editor
	// if not, then move it above editor
	elem = oGrid.mainElement;
	if(y > h + oGrid.oEdit.Element.offsetHeight + window.document.body.scrollTop - y)
		y -= (elem.offsetHeight + oGrid.oEdit.Element.offsetHeight);
	// check if grid fits on the right from editor
	// if not, then move it to the left
	// 20 - extra shift for possible vertical scrollbar in browser
	if(x + elem.offsetWidth + 20 > w + window.document.body.scrollLeft)
		x = w - elem.offsetWidth - 20 + window.document.body.scrollLeft;
	oGrid.mainElement.style.left = x + "px";
	oGrid.mainElement.style.top = y + "px";
}
// process mouse click events for page: close drop-down
function globalMouseDown(evt)
{
	// reference to visible dropped-down grid
	var oGrid = null;
	var i = dropDownGrids.length;
	for(var i = 0; i < dropDownGrids.length; i++) if(dropDownGrids[i].isDisplayed)
	{
		oGrid = dropDownGrids[i];
		break;
	}
	// check if opened grid was found
	if(oGrid == null)
		return;
	// find source element
	if(evt == null) evt = window.event;
	if(evt != null)
	{
		var elem = evt.srcElement;
		if(elem == null) if((elem = evt.target) == null) o = this;
		while(elem != null)
		{
			// ignore events that belong to grid
			if(elem == oGrid.mainElement) return;
			elem = elem.offsetParent;
		}
	}
	// close grid
	showDropDown(oGrid, null, false, false);
}
