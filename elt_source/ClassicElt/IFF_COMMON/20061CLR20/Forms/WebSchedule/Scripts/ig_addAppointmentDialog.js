/*
    Infragistics AddAppointmentDialog Script
    Version 6.1.20061.28 
    Copyright (c) 2005 - 2006 Infragistics, Inc. All Rights Reserved.
*/			
var startTimeId = "UltraWebTab1__ctl0__ctl0_ddStartTime";
var endTimeId = "UltraWebTab1__ctl0__ctl0_ddEndTime";
var startTimeElement = document.getElementById(startTimeId + "_inputbox")
if(startTimeElement == null)
{
	startTimeId = "UltraWebTab1__ctl0_ctl00_ddStartTime";
	endTimeId = "UltraWebTab1__ctl0_ctl00_ddEndTime";
	startTimeElement = document.getElementById(startTimeId + "_inputbox"); 
}
var endTimeElement = document.getElementById(endTimeId + "_inputbox");
var startTimeControl = document.getElementById(startTimeId + "_control");
var endTimeControl = document.getElementById(endTimeId + "_control");

var  startDateId = "UltraWebTab1:_ctl0:_ctl0:wdcStartTime";
var endDateId =  "UltraWebTab1:_ctl0:_ctl0:wdcEndTime";

if(igdrp_getComboById(startDateId) == null)
{
	startDateId = "UltraWebTab1$xctl0$ctl00$wdcStartTime";
	endDateId = "UltraWebTab1$xctl0$ctl00$wdcEndTime";
}

if(navigator.userAgent.toLowerCase().indexOf("mozilla")>=0)
{
	if(navigator.userAgent.toLowerCase().indexOf("firefox")>=0)
	{
		if(navigator.userAgent.indexOf("1.5") >= 0)
		{
			var parentstartDateElem = document.getElementById("UltraWebTab1xxctl0xxctl0xwdcStartTime_input").parentNode;
			parentstartDateElem.style.width="0px";
			parentstartDateElem = parentstartDateElem.parentNode.parentNode.parentNode;
			parentstartDateElem.style.width="0px";
			var parentEndDateElem = document.getElementById("UltraWebTab1xxctl0xxctl0xwdcEndTime_input").parentNode;
			parentEndDateElem.style.width="0px";
			parentEndDateElem = parentEndDateElem.parentNode.parentNode.parentNode;
			parentEndDateElem.style.width="0px";
		}
	}
}

startTimeElement.onblur = startTime_onBlur;
startTimeElement.onfocus = startTime_onFocus;
endTimeElement.onblur = endTime_onBlur;
startTimeControl.dropDownEvent = "startTimeDropDown";
endTimeControl.dropDownEvent = "endTimeDropDown";
startTimeControl.itemSelect = "startTime_itemSelect";
endTimeControl.itemSelect = "endTime_itemSelect";
var MilitaryTime = false;
var AM = "AM";
var PM = "PM";
var COLON = ":";
if(MilitaryTime)
{
	AM = "";
	PM = "";
}

if(this.opener != null) 
{
	var appointmentFieldValues = this.opener.document.fieldValues;
	var appointmentDialog = this.opener.document.__webDialog;
	var scheduleInfo = appointmentDialog._scheduleInfo;
	this.opener.document.__webDialog = null;
	
	var val = appointmentFieldValues.getValue("TimeDisplayFormat");
	if(val == 0)
		MilitaryTime = false;
	else if(val == 1)
		MilitaryTime = true;
		
	var startDate = igdrp_getComboById(startDateId);//UltraWebTab1$xctl0$ctl00$wdcStartTime");
	var date = appointmentFieldValues.getValue("StartDate");
	if(date != null) 
		startDate.setValue(date);
	
	var endDate = igdrp_getComboById(endDateId);
	date = appointmentFieldValues.getValue("EndDate");
	if(date != null) 
		endDate.setValue(date);
	
	val = appointmentFieldValues.getValue("StartTime");
	if(val != null)
		comboBox_setValue(startTimeId, convertDateTimeToString(val));
	
	val = appointmentFieldValues.getValue("EndTime");
	if(val  != null)
		comboBox_setValue(endTimeId, convertDateTimeToString(val));
	
	var subject = document.getElementById("tbSubject");
	val = appointmentFieldValues.getValue("Subject");
	if(val && val.length > 0)
		subject.value = val;
	subject.focus();
	
	var loc = document.getElementById("tbLocation");
	val = appointmentFieldValues.getValue("Location");
	if(val && val.length > 0)
		loc.value = val;
	
	var description = document.getElementById("txtMsgBody");
	val = appointmentFieldValues.getValue("Description");
	if(val && val.length > 0)
		description.value = val;
	
	var alldayEvent = document.getElementById("cbAllDayEvent");
	val = appointmentFieldValues.getValue("AllDayEvent");
	alldayEvent.checked = val;
	cbAllDayEvent_Clicked();
		
	val = appointmentFieldValues.getValue("AllowAllDayEvents");
	if(!val)
	{
		alldayEvent.checked = false;
		alldayEvent.style.display = "none"; 
		document.getElementById("AllDayEventLabel").style.display = "none";
		cbAllDayEvent_Clicked();
	}
		
	var enableReminder = document.getElementById("cbReminder");
	val = appointmentFieldValues.getValue("EnableReminder");
	enableReminder.checked = val;
	cbReminder_Clicked();

	var displayInterval = document.getElementById("ddReminder");	
	val = appointmentFieldValues.getValue("ReminderInterval");
	var interval = convertTicksToString(val);
	var index = -1;
	for(var i = 0; i < displayInterval.options.length && index == -1; i++){
		if(interval == displayInterval.options[i].innerHTML)
			index = displayInterval.options[i].index;
	}
	if(index != -1)
		displayInterval.selectedIndex = index;
	else
	{
		var option = document.createElement("OPTION");
		displayInterval.appendChild(option);
		option.innerHTML = interval;
		option.value = "Test";
		displayInterval.value = "Test";
		window.setTimeout("document.getElementById('ddReminder').selectedIndex = document.getElementById('ddReminder').options.length -1;",1);
	}
	var showtimeas = document.getElementById("ddShowTimeAs");
	val = appointmentFieldValues.getValue("ShowTimeAs");
	if(val != null)
		showtimeas.selectedIndex = val;
		
	var importance = igtbar_getToolbarById("UltraWebToolbar2");
	val = appointmentFieldValues.getValue("Importance");
	if(val != null)
	{
		if(val == "0")
			importance.Items[4].Items[1].setSelected(true);
		else if(val == "2")
			importance.Items[4].Items[0].setSelected(true);
	}
	
	var dataKey = appointmentFieldValues.getValue("DataKey");
	if(dataKey == null)
	{	
		var deleteButton = document.getElementById("UltraWebToolbar2_Item_2");
		var node = deleteButton;
		while(node.tagName != "TABLE")
			node = node.parentNode;
		for(var i = 0; i < node.childNodes.length; i++)
		{
			if(node.childNodes[i].tagName == "COLGROUP")
			{
				node.childNodes[i].childNodes[4].style.display = "none";
				node.childNodes[i].childNodes[4].style.visibility = "hidden";
				if(!ig_shared.IsIE)
				{
					deleteButton.style.display = "none";
					deleteButton.style.visibility = "hidden";
				}
				break;								   
			}				
		}
	}
	
	var calDifference =  igdrp_getComboById(startDateId).getValue().getTime() - igdrp_getComboById(endDateId).getValue().getTime();
}

function startTimeDropDown()
{
	startTime_onFocus();
	var times = new Array();
	
	if(!MilitaryTime)
	{
		times.push("12"+COLON+"00 " + AM);
		times.push("12"+COLON+"30 " + AM);
		for(var i = 1; i < 12; i++)
		{
			times.push(i.toString() + COLON + "00 " + AM);
			times.push(i.toString() + COLON + "30 " + AM);
		}
		times.push("12"+COLON+"00 " + PM);
		times.push("12"+COLON+"30 " + PM);
		for(var i = 1; i < 12; i++)
		{
			times.push(i.toString() + COLON + "00 " + PM);
			times.push(i.toString() + COLON + "30 " + PM);
		}
	}
	else
	{
		for(var i = 0; i < 24; i++)
		{
			times.push(i.toString() + COLON + "00");
			times.push(i.toString() + COLON + "30");
		}
	}
	comboBox_addItems(startTimeId, times); 
	var value = comboBox_getValue(startTimeId);
	var selectedElement = comboBox_selectValue(startTimeId, value);
	comboBox_scrollItemIntoView(startTimeId, selectedElement);
}

function endTimeDropDown()
{
	var times = new Array();
	var startvalue = comboBox_getValue(startTimeId);
	var startIndex = startvalue.indexOf(COLON,0);
	var zeromin = parseInt(startvalue.substring(startIndex+1, startIndex +3));
	var zerohour = parseInt(startvalue.substring(0, startIndex));
	var thirtymin = zeromin + 30;
	var thirtyhour = zerohour;
	var indexTT = startvalue.indexOf("AM");
	var startTT = " " + AM;
	var endTT = " " + PM;
	if(indexTT == -1)
	{
		startTT = " " + PM;
		endTT = " " + AM;
	}
	var startTT2 = startTT;
	var endTT2 = endTT;
	
	if(thirtymin >= 60)
	{
		thirtymin -= 60;
		thirtyhour++;
	}
	if(!MilitaryTime)
	{
		if(thirtyhour > 12)
			thirtyhour -= 12;
	
		if(thirtyhour == 12 && thirtymin <30)
		{
			var temptt = startTT2;
			startTT2 = endTT2;
			endTT2 = temptt;
		}
	}
	else
	{
		if(zerohour == 23 && zeromin >= 30)
			thirtyhour = 0;
	}
		
	if(thirtymin < 10)
		thirtymin = "0" + thirtymin;
	if(zeromin < 10)
		zeromin = "0" + zeromin;
	times.push(startvalue);
	times.push(thirtyhour + COLON + thirtymin + startTT2);
	for(var i = 0; i < 23; i++)
	{
		zerohour++;
		thirtyhour++;
		if(!MilitaryTime)
		{
			if(zerohour > 12)
				zerohour -= 12;
			if(zerohour == 12 )
			{
				var temptt = startTT;
				startTT = endTT;
				endTT = temptt;
			}
			if(thirtyhour > 12)
				thirtyhour -=12;
			if(thirtyhour == 12)
			{
				var temptt = startTT2;
				startTT2 = endTT2;
				endTT2 = temptt;
			}
		}
		else
		{
			if(zerohour == 24)
				zerohour = 0;
			if(thirtyhour == 24)
				thirtyhour = 0;
		}
	
		times.push(zerohour + COLON + zeromin + startTT);
		times.push(thirtyhour + COLON + thirtymin + startTT2);
	}
	
	comboBox_addItems(endTimeId, times);
	var value = comboBox_getValue(endTimeId);
	var selectedElement = comboBox_selectValue(endTimeId, value);
	comboBox_scrollItemIntoView(endTimeId, selectedElement);
}

function startTime_itemSelect(id, value)
{	
	comboBox_setValue(id, value);
	startTime_onBlur();
}

function endTime_itemSelect(id, value)
{
	comboBox_setValue(id, value);
	var calEnd = igdrp_getComboById(endDateId)
	var enddate = calEnd.getValue();
	var calStart = igdrp_getComboById(startDateId)
	var startDate = calStart.getValue();
	var time = convertStringToDateTime(value);
	var startTime = convertStringToDateTime(comboBox_getValue(startTimeId));
	startDate.setHours(startTime.getHours(), startTime.getMinutes());
	if(startDate.getDate() == enddate.getDate())
	{
		if(startTime.getHours() > time.getHours() || (startTime.getHours() == time.getHours() && startTime.getMinutes() > time.getMinutes()))
			enddate.setFullYear(enddate.getFullYear(),enddate.getMonth(), enddate.getDate() + 1);
	}
	else if(startDate.getDate()+1 == enddate.getDate())
	{
		if(startTime.getHours() <= time.getHours())
			enddate.setFullYear(enddate.getFullYear(),enddate.getMonth(), enddate.getDate() - 1);			
	}
	enddate.setHours(time.getHours(), time.getMinutes());
	calEnd.setValue(enddate);
}

function comboBox_selectValue(id, value)
{
	var iframe = document.getElementById(id+"_comboFrame");
	var pdiv = iframe.contentWindow.document.getElementById(id+"_parentDiv");
	var valueTime = convertStringToDateTime(value);
	for(var i =0; i < pdiv.childNodes.length; i++)
	{
		var itemTime = convertStringToDateTime(pdiv.childNodes[i].innerHTML);
		var	diff = valueTime.getTime() - itemTime.getTime();
		diff = (diff/1000)/60;
		if(diff < 0)
			diff *= -1;
		if(diff < 30 && diff >= 0 && valueTime.getHours() == itemTime.getHours())
		{
			if(lastSelected != null)
			{
				lastSelected.style.background = "white";
				lastSelected.style.color = "black";
			}
			lastSelected = pdiv.childNodes[i];
			lastSelected.style.background = "navy";
			lastSelected.style.color = "white";
		}
	}
	
	return lastSelected;
}

function startTime_onBlur()
{
	var returnVal = Time_onBlur(startTimeId);
	if(returnVal)
		return
	var startValue = comboBox_getValue(startTimeId);
	
	var startTime = convertStringToDateTime(startValue);
	var calStart = igdrp_getComboById(startDateId)
	var startDateTime = calStart.getValue();
	startDateTime.setHours(startTime.getHours(),startTime.getMinutes());
	
	var calEnd = igdrp_getComboById(endDateId)
	var endDateTime = calEnd.getValue();
	endDateTime.setTime(startDateTime.getTime() + difference);
	calEnd.setValue(endDateTime);			
	
	var endTT = "";	
	var endhours = endDateTime.getHours();
	if(!MilitaryTime)
	{
		var endTT = " " +  AM;
		if(endhours > 11)
			endTT = " " +  PM;
		if(endhours >12)
			endhours -=12;
		if(endhours == 0)
			endhours = 12;
	}	
	var endMinutes = endDateTime.getMinutes();
	if(endMinutes < 10)
		endMinutes = "0" + endMinutes;
	
	comboBox_setValue(endTimeId, endhours+ COLON + endMinutes + endTT);									
	
}	
var difference = null;
function startTime_onFocus()
{
	var startValue = comboBox_getValue(startTimeId);
	var endValue = comboBox_getValue(endTimeId);
	
	var startTime = convertStringToDateTime(startValue);
	var endTime = convertStringToDateTime(endValue);
	
	var calStart = igdrp_getComboById(startDateId)
	var startDateTime = calStart.getValue();
	startDateTime.setHours(startTime.getHours(),startTime.getMinutes());
	var calEnd = igdrp_getComboById(endDateId)
	var endDateTime = calEnd.getValue();
	endDateTime.setHours(endTime.getHours(),endTime.getMinutes());
	difference = endDateTime.getTime() - startDateTime.getTime();
}
	
function endTime_onBlur()
{
	var returnVal = Time_onBlur(endTimeId);
	if(!returnVal)
		endTime_itemSelect(endTimeId, comboBox_getValue(endTimeId));
}

function Time_onBlur(id)
{
	var value = comboBox_getValue(id);
	var tt = null;
	var firstTime;
	var zeroFound;
	while(value.indexOf("0",0 ) == 0){
		value = value.substring(1, value.length );
		zeroFound = true;
	}
	if(MilitaryTime && zeroFound)
		value = "0" + value;
				
	if(value == "" || parseInt(value.substring(0,1)).toString() == "NaN" )
	{
		alert("You Must Specify a Valid Time!");
		comboBox_setValue(id, document.getElementById(id+"_inputbox").prevValue, false);
		Time_onBlur(id);
		return true;
	}
	else
		firstTime = value.substring(0,1);
	
	if(parseInt(value.substring(1,2)).toString() != "NaN" )
		firstTime += value.substring(1,2);
		
	if(parseInt(firstTime) >= 24)
		firstTime = firstTime.substring(0,1);
	else
	{
		if(!MilitaryTime)
		{
			var timeTest = parseInt(firstTime);
			if(timeTest > 12)
			{
				firstTime = (timeTest - 12).toString();
				tt = " " + PM;
			}
		}
	}
	firstTime += COLON;
	
	var colon = value.indexOf(COLON, 0);
	if(colon == firstTime.length-1)
	{
		var firstNumber = parseInt(value.substring(colon+1,colon+2));
		var secondNumber = parseInt(value.substring(colon+2,colon+3));
		if(firstNumber.toString() != "NaN" )
		{
			if(firstNumber > 5)
				firstTime += "0" + firstNumber.toString();
			else if(secondNumber.toString() != "NaN" )
				firstTime += firstNumber.toString() + secondNumber.toString();
			else
				firstTime += "0" + firstNumber.toString();
		}	
		else
			firstTime += "00";		
	}	
	else
		firstTime += "00";		
	if(tt == null)
	{
		var p = value.indexOf(PM.substring(0,1).toLowerCase(), 0);
		var P = value.indexOf(PM.substring(0,1).toUpperCase(), 0);
		var a = value.indexOf(AM.substring(0,1).toLowerCase(), 0);
		var A = value.indexOf(AM.substring(0,1).toUpperCase(), 0);
		
		if(p != -1 || P != -1 || a != -1 || A != -1)
		{
			if(a == -1)
				a = 999;
			if(A == -1)
				A = 999;				
			if(((p < a || p < A) && p != -1) ||(( P < a || P < A) && P != -1))
				tt = " " + PM;
			else
				tt = " " + AM;			
		}
		else
			tt = " " + AM;
	}		
			
	if(!MilitaryTime)
		firstTime += tt;
	comboBox_setValue(id, firstTime);
}

function OKClicked(oToolbar, oButton, oEvent) 
{
	if(oButton.Key != "High" && oButton.Key != "Low")
	{
		if(oButton.Index == 0 || oButton.Index == 2)	// Save and Close and Delete
		{
			var alldayEvent = document.getElementById("cbAllDayEvent");
			if(alldayEvent.checked)
			{
				var time = new Date();
				time.setHours(0,0,0,0);
				comboBox_setValue(startTimeId, convertDateTimeToString(time));
				time.setHours(23,59,0,0);
				comboBox_setValue(endTimeId, convertDateTimeToString(time));
			}
			
			var startDateObj = igdrp_getComboById(startDateId);
			var startDateValue = startDateObj.getValue();
			var startTime = convertStringToDateTime(comboBox_getValue(startTimeId));
			
			var endDateObj = igdrp_getComboById(endDateId);
			var endDateValue = endDateObj.getValue();
			var endTime = convertStringToDateTime(comboBox_getValue(endTimeId));
			
			var startDateTime = new Date();
			startDateTime.setTime(startDateValue.getTime());
			startDateTime.setHours(startTime.getHours(), startTime.getMinutes());
			
			
			var endDateTime = new Date();
			endDateTime.setTime(endDateValue.getTime());
			endDateTime.setHours(endTime.getHours(), endTime.getMinutes());
			
			var duration = (endDateTime.getTime() - startDateTime.getTime())/60000;
			var intduration = parseInt(duration.toString());
			if((duration - intduration) > 0)
				duration += 1;
			
			var subject = document.getElementById("tbSubject");
			var loc = document.getElementById("tbLocation");
			var description = document.getElementById("txtMsgBody");			
			var enableReminder = document.getElementById("cbReminder");
			
			var displayInterval = document.getElementById("ddReminder");	
			var interval = convertStringToTicks(displayInterval.options[displayInterval.selectedIndex].innerHTML.split(" "));
			
			var showtimeas = document.getElementById("ddShowTimeAs");									
			
			var importance = igtbar_getToolbarById("UltraWebToolbar2");
			var highItem = importance.Items[4].Items[0];
			var lowItem = importance.Items[4].Items[1];
			var importanceValue = "1";
			if(highItem.getSelected())
				importanceValue = "2";
			else if(lowItem.getSelected())
				importanceValue = "0";
			
		var activityEditProps = {StartDate:		 {	Element: startDateObj.Element, 
													Object : startDateObj,
													Value  : startDateValue},
									StartTime:		 {	Element: startTimeElement,
													Value  : startTime},
									EndDate:		 {	Element: endDateObj.Element, 
													Object : endDateObj,
													Value  : endDateValue},
									EndTime:		 {	Element: endTimeElement,
													Value  : endTime},
									AllDayEvent:	 {	Element: alldayEvent, 
													Value  : alldayEvent.checked},
									Subject:		 {	Element: subject, 
													Value  : subject.value},
									Location:		 {	Element: loc, 
													Value  : loc.value}, 
									Description:	 {	Element: description, 
													Value  : description.value},
									EnableReminder: {	Element: enableReminder, 
													Value  : enableReminder.checked},
									DisplayInterval:{	Element: displayInterval, 
													Value  : interval}, 
									ShowTimeAs:	 {	Element: showtimeas, 
													Value  : showtimeas.options[showtimeas.selectedIndex].innerHTML},
									Importance:	 {	ToolBar: importance, 
													HighItem: highItem,
													LowItem: lowItem, 
													Value  : importanceValue},
									Duration:		 {  Value  : duration},
									document:		 document,
									window:		 window
								}	
								
			if(!scheduleInfo._onActivityDialogEdit(activityEditProps))		
			{
				if(oButton.Index == 0 && dataKey != null)
					appointmentFieldValues["Operation"] = "Update";
				else if(oButton.Index == 0 && dataKey == null)
					appointmentFieldValues["Operation"] = "Add";
				else if(oButton.Index == 2)	
					appointmentFieldValues["Operation"] = "Delete";
				
				appointmentFieldValues["AllDayEvent"] = alldayEvent.checked;
				appointmentFieldValues["StartDateTime"] = startDateTime;	
				appointmentFieldValues["Duration"] = duration;					
				appointmentFieldValues["Subject"] = subject.value;
				appointmentFieldValues["Location"] = loc.value;
				appointmentFieldValues["Description"] = description.value;
				appointmentFieldValues["EnableReminder"] = enableReminder.checked;
				appointmentFieldValues["ReminderInterval"] = interval;
				appointmentFieldValues["ShowTimeAs"] =  showtimeas.selectedIndex;
				appointmentFieldValues["Importance"] = importanceValue; 
				
				appointmentDialog._dialogClosed(true);
				appointmentDialog.closeDialog();
			}
		}
		else if(oButton.Index == 1) // Print
		{
			var ActiveResourceName = scheduleInfo.getActiveResourceName();

			var frame = document.getElementById("printFrame");
			frame.style.position = 'absolute';
			frame.style.zIndex = -1;
			frame.style.height = 1;
			frame.style.width = 1;
			frame.style.visibility = "visible";

			var frameDocument = frame.contentWindow.document;
			
			frameDocument.getElementById("ResourceLabel").innerHTML = ActiveResourceName;
			frameDocument.getElementById("SubjectLabel").innerHTML =  document.getElementById("SubjectLabel").innerHTML;
			frameDocument.getElementById("tbSubject").innerHTML = document.getElementById("tbSubject").value;
			frameDocument.getElementById("LocationLabel").innerHTML =  document.getElementById("LocationLabel").innerHTML;
			frameDocument.getElementById("tbLocation").innerHTML = document.getElementById("tbLocation").value;
			frameDocument.getElementById("StartTimeLabel").innerHTML = document.getElementById("StartTimeLabel").innerHTML;
			frameDocument.getElementById("EndTimeLabel").innerHTML = document.getElementById("EndTimeLabel").innerHTML;
			frameDocument.getElementById("cbAllDayEvent").checked = document.getElementById("cbAllDayEvent").checked;
			if(frameDocument.getElementById("cbAllDayEvent").checked)
			{
				frameDocument.getElementById("ddStartTime").style.display = "none";
				frameDocument.getElementById("ddEndTime").style.display = "none";
			}
			else
			{
				frameDocument.getElementById("ddStartTime").innerHTML = comboBox_getValue(startTimeId);
				frameDocument.getElementById("ddEndTime").innerHTML = comboBox_getValue(endTimeId);
			}
			frameDocument.getElementById("AllDayEventLabel").innerHTML = document.getElementById("AllDayEventLabel").innerHTML;
			frameDocument.getElementById("cbReminder").checked = document.getElementById("cbReminder").checked;
			frameDocument.getElementById("cbReminderLabel").innerHTML = document.getElementById("ReminderLabel").innerHTML;
			var ddShowTimeAs = document.getElementById("ddShowTimeAs");
			frameDocument.getElementById("ddShowTimeAs").innerHTML = ddShowTimeAs.options[ddShowTimeAs.selectedIndex].innerHTML;
			var ddReminder = document.getElementById("ddReminder");
			frameDocument.getElementById("ddReminder").innerHTML = ddReminder.options[ddReminder.selectedIndex].innerHTML;
			frameDocument.getElementById("txtMsgBody").value = document.getElementById("txtMsgBody").value;
			frameDocument.getElementById("wdcStartTime").innerHTML = igdrp_getComboById(startDateId).getText();
			frameDocument.getElementById("wdcEndTime").innerHTML = igdrp_getComboById(endDateId).getText();
		
			frame.contentWindow.document.parentWindow.focus();
			frame.contentWindow.document.parentWindow.print();
			
			frame.style.visibility = "hidden";
		}		
	}
}

function window_onunload() 
{
	if(this.opener != null)
		appointmentDialog.closeDialog();		
}

function convertTicksToString(ticks){
	var seconds = ticks / 10000000;
	var minutes = seconds / 60;
	var hours = minutes / 60; 
	var days = hours / 24;
	var weeks = days / 7;
	var returnString; 
	
	if(weeks == 1)
		returnString = "1 week";
	else if(weeks > 1)
		returnString = weeks + " weeks";
	else if(days == 1)
		returnString = "1 day";
	else if (days > 1)
		returnString = days + " days";		
	else if(hours == 1)
		returnString = "1 hour";
	else if (hours > 1)
		returnString = hours + " hours";
	else if(minutes == 1)
		returnString = "1 minute";
	else if (minutes > 1 || minutes == 0)
		returnString = minutes + " minutes";
		
	if(returnString == "12 hours")
		returnString = "0.5 days";
					
	return returnString;
}
function convertStringToTicks(string){
	var interval = string[0];
	var units = string[1];
	var ticks = 0; 
	if(units.indexOf("day",0) != -1)
		ticks = interval * 24 * 60 * 60 * 10000000;
	else if(units.indexOf("hour",0) != -1)
		ticks = interval * 60 * 60 * 10000000;
	else if(units.indexOf("minute",0) != -1)
		ticks = interval * 60 * 10000000;
	return ticks;	
}

function convertStringToDateTime(value)
{
	var time = new Date();
	var startIndex = value.indexOf(COLON, 0);
	var minutes = parseInt(value.substring(startIndex+1, startIndex+3));
	var hours = parseInt(value.substring(0,startIndex));
	if(!MilitaryTime)
	{
		var ttindex = value.indexOf("AM");
		if(ttindex == -1 && hours !=12)
			hours -=12;
		else if(ttindex != -1 && hours == 12)
			hours = 0;
	}				
	time.setHours(hours,minutes,0,0);
	return time;		
}

function convertDateTimeToString(dateTime)
{
	var hours = dateTime.getHours();
	var minutes = dateTime.getMinutes();
	var tt = "";
	
	if(!MilitaryTime)
	{
		tt = " "+ AM;
		if(hours > 12)
		{
			hours = hours - 12;
			tt = " " + PM;
		}
		else if(hours == 0)
			hours = 12;
		else if(hours == 12)
			tt = " " + PM;
	}
	if(minutes < 10)
			minutes = "0" + minutes;	
	return hours + COLON + minutes + tt;	
}



function cbAllDayEvent_Clicked()
{
	var cb = document.getElementById("cbAllDayEvent");
	var start = startTimeControl;
	var end = endTimeControl;
	var td1 = document.getElementById("startTime");
	var td2 = document.getElementById("endTime");

	if(cb.checked)
	{
		start.style.visibility = "hidden"; 
		start.style.display = "none";
		end.style.visibility = "hidden"; 
		end.style.display = "none";
		td1.style.display = "none";
		td1.style.visibility = "hidden";
		td2.style.display = "none";
		td2.style.visibility = "hidden";
	}
	else
	{
		start.style.visibility = ""; 
		start.style.display = "";
		end.style.visibility = ""; 
		end.style.display = "";
		td1.style.display = "";
		td1.style.visibility = "";
		td2.style.display = "";
		td2.style.visibility = "";
	}	
}

function DropDown_Cal1()
{
	var cal = igdrp_getComboById(startDateId)
	if(!cal.isDropDownVisible())
		cal.setDropDownVisible(true);
}

function DropDown_Cal2()
{
	var cal = igdrp_getComboById(endDateId)
	if(!cal.isDropDownVisible())
		cal.setDropDownVisible(true);
}

function wdcEndTime_ValueChanged(oDropDown, newValue, oEvent)
{
	var cal = igdrp_getComboById(startDateId)
	if(cal != null)
	{
		var date = new Date();
		if(newValue.getTime() < cal.getValue().getTime())
		{
			date.setTime(newValue.getTime());
			cal.setValue(date);
		}	
		calDifference = cal.getValue().getTime() - newValue.getTime();
		
	}
}

function wdcStartTime_ValueChanged(oDropDown, newValue, oEvent)
{
	var cal = igdrp_getComboById(endDateId)
	if(cal != null)
	{
		var date = new Date();
		date.setTime(newValue.getTime() - calDifference);
		cal.setValue(date);
		calDifference = newValue.getTime() - cal.getValue().getTime();
	}			
}

function cbReminder_Clicked()
{
	var reminder = document.getElementById("cbReminder");
	var ddreminder = document.getElementById("ddReminder");
	ddreminder.disabled = !reminder.checked;
}


