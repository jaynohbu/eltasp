// This file allows to link drop-down WebCalendar with WebDateTimeEdit
//
// reference to drop-down calendar
var ig_calToDrop;
// reference to transparent iframe used to get around bugs in IE related to <select>
var ig_frameUnderCal;
// event fired by WebDateTimeEdit on CustomButton
function ig_openCalEvent(oEdit)
{
	// if it belongs to another oEdit, then close ig_calToDrop
	if(ig_calToDrop.oEdit != oEdit)
	{
		ig_showHideCal(null, false);
		// set reference in ig_calToDrop to this oEdit
		ig_calToDrop.oEdit = oEdit;
	}
	// show calendar with date from editor
	ig_showHideCal(oEdit.getDate(), true, true, true);
}
// synchronize dates in DateEdit and calendar, and show/close calendar
function ig_showHideCal(date, show, update, toggle)
{
	if(update != true) update = false;
	var oEdit = ig_calToDrop.oEdit;
	if(toggle == true && ig_calToDrop.isDisplayed == true)
		show = update = false;
	// update editor with latest date
	if(update && oEdit != null)
	{
		if(ig_calToDrop.isDisplayed) oEdit.setDate(date);
		else ig_calToDrop.setSelectedDate(oEdit.getDate());
	}
	// check current state of calendar
	if(ig_calToDrop.isDisplayed == show)
		return;
	// show/hide calendar
	ig_calToDrop.element.style.display = show ? "block" : "none";
	ig_calToDrop.element.style.visibility = show ? "visible" : "hidden";
	ig_calToDrop.isDisplayed = show;
	if(show)
		ig_setCalPosition();
	else
	{
		if(ig_frameUnderCal != null)
			ig_frameUnderCal.hide();
		ig_calToDrop.oEdit = null;
	}
}
// set position of calendar below DateEdit
function ig_setCalPosition()
{
	var edit = ig_calToDrop.oEdit.Element;
	var pan = ig_calToDrop.element;
	pan.style.visibility = "visible";
	pan.style.display = "";
	if(ig_frameUnderCal == null && ig_csom.IsIEWin)
	{	
		ig_frameUnderCal = ig_csom.createTransparentPanel();
		if(ig_frameUnderCal != null)
			ig_frameUnderCal.Element.style.zIndex = 10001;
	}
	var editH = edit.offsetHeight, editW = edit.offsetWidth;
	if(editH == null) editH = 0;
	var z, x = 0, y = editH, elem = edit, body = window.document.body;
	while(elem != null)
	{
		if(elem.offsetLeft != null) x += elem.offsetLeft;
		if(elem.offsetTop != null) y += elem.offsetTop;
		if(elem.nodeName == "HTML" && elem.clientHeight > body.clientHeight)
			body = elem;
		elem = elem.offsetParent;
	}
	var panH = pan.offsetHeight, panW = pan.offsetWidth;
	if((y - body.scrollTop) * 2 > body.clientHeight + editH)
		y -= (panH + editH);
	z = body.scrollLeft;
	if(x < z) x = z;
	else if(x + panW > (z += body.clientWidth)) x = z - panW;
	pan.style.left = x;
	pan.style.top = y;
	if(ig_frameUnderCal != null)
	{
		ig_frameUnderCal.setPosition(y - 1, x - 1, panW + 2, panH + 2);
		ig_frameUnderCal.show();
	}
}
// process mouse click events for page: close drop-down
function ig_globalMouseDown(evt)
{
	// find source element
	if(evt == null) evt = window.event;
	if(evt != null)
	{
		var elem = evt.srcElement;
		if(elem == null) if((elem = evt.target) == null) elem = this;
		while(elem != null)
		{
			// ignore events that belong to calendar
			if(elem == ig_calToDrop.element) return;
			elem = elem.offsetParent;
		}
	}
	// close calendar
	ig_showHideCal(null, false, false);
}
function ig_closeCalEvent(oEdit){ig_showHideCal(null, false);}
function ig_initDropCalendar(calendarAndDates)
{
	var ids = calendarAndDates.split(" ");
	ig_frameUnderCal = null;
	ig_calToDrop = igcal_getCalendarById(ids[0]);
	if(ig_calToDrop == null)
	{
		alert("WebCalendar with id=" + ids[0] + " was not found");
		return;
	}
	ig_calToDrop.element.style.zIndex = 10002;
	ig_calToDrop.element.style.position = "absolute";
	ig_calToDrop.isDisplayed = true;
	// hide drop-down calendar
	ig_showHideCal(null, false);
	// it is called by date click events of WebCalendar
	// Note: that name should match with the ClientSideEvents.DateClicked property
	//  which is set in aspx for WebCalendar
	ig_calToDrop.onValueChanged = function(cal, date)
	{
		// update editor with latest date and hide calendar
		ig_showHideCal(date, false, true);
	}
	// add listener to mouse click events for page
	ig_csom.addEventListener(window.document, "mousedown", ig_globalMouseDown);
	for(var i = 1; i < ids.length; i++)
	{
		var edit = igedit_getById(ids[i]);
		if(edit == null)
		{
			alert("WebDateTimeEdit with id=" + ids[i] + " was not found");
			continue;
		}
		edit.addEventListener("focus", ig_closeCalEvent, edit);
		edit.addEventListener("spin", ig_closeCalEvent, edit);
		edit.addEventListener("keydown", ig_closeCalEvent, edit);
		edit.addEventListener("custombutton", ig_openCalEvent, edit);
	}
}