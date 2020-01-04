// This file contains java script used by the DropDownCalendar.aspx form.
//
// reference to drop-down calendar
var dropDownCalendar;
// it is called when drop-down calendar is initialized
// Note: that name should match with the ClientSideEvents.InitializeCalendar property
//  which is set in aspx for WebCalendar
function initCalendarEvent(oCalendar)
{
	// ensure absolute position
	// Note: it can be skipped if style in aspx has that
	oCalendar.element.style.position = "absolute";
	// assume that calendar on start is visible
	// create boolean member variable, which simplifies visibility test
	oCalendar.isDisplayed = true;
	dropDownCalendar = oCalendar;
	// hide drop-down calendar
	showDropDown(oCalendar, null, false);
	// add listener to mouse click events for page
	ig_csom.addEventListener(window.document, "mousedown", globalMouseDown);
}
// it is called by date click events of WebCalendar
// Note: that name should match with the ClientSideEvents.DateClicked property
//  which is set in aspx for WebCalendar
function calendarDateClickedEvent(oCalendar, oDate, oEvent)
{
	// update editor with latest date and hide calendar
	showDropDown(oCalendar, oDate, false, true);
}
// it is called by custom-button click event of WebDateTimeEdit
// Note: that name should match with the ClientSideEvents.CustomButtonPress property
//  which is set in aspx for WebDateTimeEdit
function openCustomDropDownCalendar(oEdit, text, oEvent)
{
	openDropDown(oEdit, dropDownCalendar);
}
// it is called by spin and focus events of WebDateTimeEdit
// Note: that name should match with the ClientSideEvents.KeyDown/Spin/Focus/etc. properties
//  which are set in aspx for WebDateTimeEdit
function closeDropDownEvent(oEdit, text, oEvent)
{
	// hide calendar
	showDropDown(oEdit.oCalendar, null, false);
}
// open calendar and attach it to WebDateTimeEdit
// oEdit - reference to the owner of calendar (WebDateTimeEdit)
// oCalendar - the WebCalendar which should be dropped and attached to oEdit
function openDropDown(oEdit, oCalendar)
{
	if(oCalendar == null) return;
	// set reference of calendar to editor:
	// create member variable, which points to drop-down calendar
	oEdit.oCalendar = oCalendar;
	// if it belongs to another oEdit, then close oCalendar
	if(oCalendar.oEdit != oEdit)
	{
		showDropDown(oCalendar, null, false);
		// set reference in oCalendar to this oEdit
		// create member variable, which points to the owner oEdit
		oCalendar.oEdit = oEdit;
	}
	// show calendar with date from editor
	// if calendar is already opened, then hide calendar (last param)
	showDropDown(oCalendar, oEdit.getDate(), true, true, true);
}
// synchronize dates in DateEdit and calendar, and show/close calendar
function showDropDown(oCalendar, date, show, update, toggle)
{
	if(oCalendar == null) return;
	if(toggle == true && oCalendar.isDisplayed == true)
		show = update = false;
	// update editor with latest date
	if(update == true)
	{
		if(oCalendar.isDisplayed)
			oCalendar.oEdit.setDate(date);
		else
			oCalendar.setSelectedDate(oCalendar.oEdit.getDate());
	}
	// check current state of calendar
	if(oCalendar.isDisplayed == show)
		return;
	// show/hide calendar
	oCalendar.element.style.display = show ? "block" : "none";
	oCalendar.element.style.visibility = show ? "visible" : "hidden";
	oCalendar.isDisplayed = show;
	if(show)
		positionCalendar(oCalendar);
}
// set position of calendar below DateEdit
function positionCalendar(oCalendar)
{
	var elem = oCalendar.oEdit.Element;
	// left and top position of calendar
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
	// check if calendar fits below editor
	// if not, then move it above editor
	elem = oCalendar.element;
	if(y > h + oCalendar.oEdit.Element.offsetHeight + window.document.body.scrollTop - y)
		y -= (elem.offsetHeight + oCalendar.oEdit.Element.offsetHeight);
	// check if calendar fits on the right from editor
	// if not, then move it to the left
	if(x + elem.offsetWidth + 20 > w + window.document.body.scrollLeft)
		x = w - elem.offsetWidth - 20 + window.document.body.scrollLeft;
	oCalendar.element.style.left = x + "px";
	oCalendar.element.style.top = y + "px";
}
// process mouse click events for page: close drop-down
function globalMouseDown(evt)
{
	if(!dropDownCalendar.isDisplayed)
		return;
	// find source element
	if(evt == null) evt = window.event;
	if(evt != null)
	{
		var elem = evt.srcElement;
		if(elem == null) if((elem = evt.target) == null) o = this;
		while(elem != null)
		{
			// ignore events that belong to calendar
			if(elem == dropDownCalendar.element) return;
			elem = elem.offsetParent;
		}
	}
	// close calendar
	showDropDown(dropDownCalendar, null, false, false);
}
