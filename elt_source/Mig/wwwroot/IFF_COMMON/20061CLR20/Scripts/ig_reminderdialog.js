/*
    Infragistics ReminderDialog Script
    Version 6.1.20061.28 
    Copyright (c) 2005 - 2006 Infragistics, Inc. All Rights Reserved.
*/
var reminderDialog  = null;
var reminderFieldValues = null;
var scheduleInfo = null;
var openerAccessDenied = false;

if(this.opener != null) 
{
	try
	{
		reminderFieldValues = this.opener.document.fieldValues;
		var reminders = reminderFieldValues.getValue("Reminders");
		reminderDialog = this.opener.document.__webDialog;
		scheduleInfo = reminderDialog._scheduleInfo;
		this.opener.document.__webDialog = null;
		var now = new Date();	
		for(var i = 0; i < reminders.length; i++) 
		{
			var reminder = reminders.getItem(i);
			var startDate = reminder.getStartDateTime();
			var subject = reminder.getSubject();
			if(subject!=null && subject.length>0)
			subject=subject.replace(/</g,"&lt;");
			var duration = reminder.getDuration();
			var duein = calcDueIn(reminder, now);				
			var row = addRow("MCL1", "<IMG src='./Images/calendar.bmp'>", subject, duein, reminder.getDataKey());
						
			if(row.id == selectedItem)
					setHeader(subject, startDate, reminder.getLocation(), row.childNodes[0].innerHTML);
		}
		document.getElementById("MCL1_m").clickEvent = "rowClicked";
		document.getElementById("MCL1_m").dblclickEvent = "openAppt";
		document.getElementById("MCL1_m").keyDownEvent = "keydown";
		
		var snoozeDropDown = document.getElementById("ddSnooze");
		var interval = convertTicksToString(scheduleInfo.getDefaultSnoozeInterval())
		var index = -1;
		for(var i = 0; i < snoozeDropDown.options.length && index == -1; i++){
			if(interval == snoozeDropDown.options[i].innerHTML)
				index = snoozeDropDown.options[i].index;
		}
		snoozeDropDown.selectedIndex = index;;
		reminderFieldValues["Dismissed"] = false;
	}
	catch(e)
	{
		this.window.close();
	}
	setTimeout(openerStatus, 200);
}

function openerStatus()
{
	try
	{
		this.opener.document;				
	}
	catch(e)
	{
		openerAccessDenied = true;
		this.window.close();
	}
	setTimeout(openerStatus, 200);	
}

function document_oncontextmenu() 
{
	return false;
}
		
function keydown(row,key)
{
	if(this.opener != null && reminderFieldValues != null) 
	{
		if(key == 38 || key == 40)
		{
			var reminders = reminderFieldValues.getValue("Reminders");	
			var reminder = reminders.getReminderFromKey(row.attributes["dataKey"].nodeValue);
			setHeader(reminder.getSubject(), reminder.getStartDateTime(), reminder.getLocation(), row.childNodes[0].innerHTML);
		}
		else if(key == 13) 
		{
			openAppt(row);
		}
	}			
}

function calcDueIn(reminder, now)
{
	var start = reminder.getStartDateTime()

	var returnString = "";					
	var overdue = true;
	var difference = now.getTime() - start.getTime();

	if(difference < 0){
		difference *= -1;
		overdue= false;
	}
	
	var daysTimeDiff = difference/86400000;
	var days = parseInt(daysTimeDiff);
	var hoursTimeDiff = (daysTimeDiff - days) * 24;
	var hours = parseInt( hoursTimeDiff);
	var minutesTimeDiff = (hoursTimeDiff - hours) * 60;
	var minutes = parseInt( minutesTimeDiff);
	
	if(!overdue){
		minutes+=1;
		var diff = (minutes/60) - parseInt(minutes/60);
		if(diff == 0)
			hours += 1;
	}
	if(days > 1)
		returnString += days + " days ";				
	else if(days == 1)
		returnString += days + " day ";				
	if(hours > 1)
		returnString += hours + " hours ";
	else if(hours == 1)
		returnString += hours + " hour ";
	if(minutes > 1)
		returnString += minutes + " minutes ";				
	else if(minutes == 1)
		returnString += minutes + " minute ";				
	if(overdue)
		returnString += "overdue";
	
	if(returnString == "overdue")
		returnString = "Now";	
				
	return returnString;		
}


function openAppt(row)
{
	if(this.opener != null && scheduleInfo != null) 
		scheduleInfo.showUpdateAppointmentDialog(row.attributes["dataKey"].nodeValue, scheduleInfo._clientId);				
}

function setHeader(subject, datetime, location, img)
{
	var subj = document.getElementById("Subject");
	if(subject == null || subject == "")
		subject = "(No Subject)";
	else
		subject = subject.replace("<","&lt;");
	subj.innerHTML = subject;
		
	var time = document.getElementById("Time");
	var dateTimeString = datetime.toLocaleString();
	time.innerHTML = dateTimeString;
	var image = document.getElementById("Image");
	
	image.innerHTML = img;
						
	var locationElem = document.getElementById("Location");
	if(location == null || location == "")
	{
		document.getElementById("LocationLabel").innerHTML = "&nbsp";
		locationElem.innerHTML = location;
	}
	else
	{
		document.getElementById("LocationLabel").innerHTML = "Location: &nbsp";
		locationElem.innerHTML = location.replace("<","&lt;");
	}		
}

function onOpenItemClicked() 
{
	if(selectedItem != null)
		openAppt(document.getElementById(selectedItem));
}

function rowClicked(row)
{
	if(this.opener != null && reminders != null) 
	{
		var dataKey = row.attributes["dataKey"].nodeValue;
		var reminder = reminders.getReminderFromKey(dataKey);
		if(reminder != null)
		{
			setHeader(reminder.getSubject(), reminder.getStartDateTime(), reminder.getLocation(), row.childNodes[0].innerHTML);
		}			
	}			
}

function onDismissClicked() 
{
	if(this.opener != null && reminders != null && reminderFieldValues != null && scheduleInfo != null) 
	{
		var row = document.getElementById(selectedItem);
		if(row == null)
			return;
						
		var dataKey = row.attributes["dataKey"].nodeValue;
		var reminder = reminders.getReminderFromKey(dataKey);
		if(reminder != null)
		{
			// Set status to Expired using a hidden property
			reminder._status = 3; 
			removeRow("MCL1", selectedItem);
			var stateItem = scheduleInfo.addStateItem("Reminder", "Process");
			scheduleInfo.updateStateItem(stateItem, "DataKey", dataKey);
			scheduleInfo.updateStateItem(stateItem, "Status", reminder._status);
			reminderFieldValues["Dismissed"] = true;
			if(getRowCount("MCL1") == 0)
			{
				this.window.close()
			}
		}	
	}					
}

function onDismissAllClicked() 
{
	if(this.opener != null && reminderFieldValues != null && scheduleInfo != null) 
	{	
		var row = document.getElementById(selectedItem);
		if(row == null)
			return;
		var reminders = reminderFieldValues.getValue("Reminders");
		for(var i = 0; i < reminders.length; i++) {
			var reminder = reminders.getItem(i);
			reminder._status = 3; 
			removeRow("MCL1", selectedItem);
			var stateItem = scheduleInfo.addStateItem("Reminder", "Process");
			scheduleInfo.updateStateItem(stateItem, "DataKey", reminder.getDataKey());
			scheduleInfo.updateStateItem(stateItem, "Status", reminder._status);
			reminderFieldValues["Dismissed"] = true;
		}		
		this.window.close();
	}		
}

function onSnoozeClicked() 
{
	if(this.opener != null && reminders != null &&  scheduleInfo != null) 
	{				
		var row = document.getElementById(selectedItem);			
		
		if(row == null)
			return;
		var reminder = reminders.getReminderFromKey(row.attributes["dataKey"].nodeValue);
		var ddSnooze = document.getElementById("ddSnooze");	
		var string = ddSnooze.options[ddSnooze.selectedIndex].innerHTML.split(" ");
		var interval = convertStringToTicks(string);
		reminder.setSnoozeInterval(interval);
		if(string.length <= 2)
		{
			var now = new Date();
			reminder.setSnoozeTimeStamp(now.getTime() * 10000);
		}
		else
			reminder.setSnoozeTimeStamp(0);
					
		var stateItem = scheduleInfo.addStateItem("Snooze", "Create");
		scheduleInfo.updateStateItem(stateItem, "ActivityKey", reminder.getDataKey());
		scheduleInfo.updateStateItem(stateItem, "SnoozeInterval", reminder.getSnoozeInterval());
		scheduleInfo.updateStateItem(stateItem, "SnoozeTimeStamp", reminder.getSnoozeTimeStamp());		
		
		removeRow("MCL1", selectedItem);
		if(getRowCount("MCL1") == 0)
		{
				this.window.close();
		}
	}
}
function convertTicksToString(ticks)
{
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
					
	return returnString;
}

function convertStringToTicks(string)
{			
	var interval = string[0];
	var units = string[1];
	var ticks = 0; 
	if(units.indexOf("day",0) != -1)
		ticks = interval * 24 * 60 * 60 * 10000000;
	else if(units.indexOf("hour",0) != -1)
		ticks = interval * 60 * 60 * 10000000;
	else if(units.indexOf("minute",0) != -1)
		ticks = interval * 60 * 10000000;
	if(ticks == 0)
		ticks = 1; 
	return ticks;	
}

function window_onunload() 
{	
	if(!openerAccessDenied && this.opener != null && reminderDialog != null && !reminderDialog._cancel && scheduleInfo != null) 
	{
		var activities = scheduleInfo.getActivities();
		for(var i = 0; i < activities.length; i++)
		{
			var activity = activities.getItem(i);
			if(reminders.getReminderFromKey(activity.getDataKey()) == null)
			{
				if(activity.getSnoozeInterval() != 0)
				{
					stateItem = scheduleInfo.addStateItem("Snooze", "Create");
					scheduleInfo.updateStateItem(stateItem, "ActivityKey", activity.getDataKey());
					scheduleInfo.updateStateItem(stateItem, "SnoozeInterval", activity.getSnoozeInterval());
					scheduleInfo.updateStateItem(stateItem, "SnoozeTimeStamp", activity.getSnoozeTimeStamp());
				}
			}
		}
		reminderDialog._dialogClosed(true);
		reminderDialog.closeDialog();
	}		
}
function onCloseClicked() 
{
	window.close();	
}
