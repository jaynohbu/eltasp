 /*
  * Infragistics WebSchedule CSOM Script: ig_webscheduleinfo.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

     

        
// WebScheduleInfo prototype and constructor
function ig_CreateWebScheduleInfo(props)
{
    if(!ig_WebControl.prototype.isPrototypeOf(ig_WebScheduleInfo.prototype))
    {
        ig_WebScheduleInfo.prototype = new ig_WebControl();
        ig_WebScheduleInfo.prototype.constructor = ig_WebScheduleInfo;
        ig_WebScheduleInfo.prototype.base=ig_WebControl.prototype;
        
        ig_WebScheduleInfo.prototype.init = function(props)
        {
            this._isInitializing = true;
            this._initControlProps(props);
            this.base.init.apply(this,[this.getClientID()]);
            this._isInitializing = false;
			this._ig_WebScheduleClientState = new ig_xmlNodeStatic();
			this.clientState = this._ig_WebScheduleClientState.createRootNode();	
			this.rootNode = this._ig_WebScheduleClientState.addNode(this.clientState, "XMLRootNode");
        }
        
        ig_WebScheduleInfo.prototype.updateControlState = function(propName, propValue) {
			if(this.controlState == null)
				this.controlState = this._ig_WebScheduleClientState.addNode(this.rootNode, "ControlState");
				
			this._ig_WebScheduleClientState.setPropertyValue(this.controlState, propName, propValue);
			if(this.postField != null)
				this.postField.value = this._ig_WebScheduleClientState.getText(this.clientState);	
		}

		ig_WebScheduleInfo.prototype.addStateItem  = function(name, value) {
			if(this.stateItems == null)
				this.stateItems = this._ig_WebScheduleClientState.addNode(this.rootNode, "StateItems");
			var stateItem = this._ig_WebScheduleClientState.addNode(this.stateItems, "StateItem");
			this.updateStateItem(stateItem, name, value);
			return stateItem;
		}

		ig_WebScheduleInfo.prototype.updateStateItem = function(stateItem, propName, propValue) {
			this._ig_WebScheduleClientState.setPropertyValue(stateItem, propName, propValue);
			if(this.postField != null)
				this.postField.value = this._ig_WebScheduleClientState.getText(this.clientState);	
		}
       
        ig_WebScheduleInfo.prototype.getAllowAllDayEvents = function() {
           return this._props[3];
        }  
        ig_WebScheduleInfo.prototype.getActiveDay = function() {
           return this._props[4];
        }  
        this._updatingActiveDay = false;
        ig_WebScheduleInfo.prototype.setActiveDay = function(value, post, id) 
        {
			var oldDate = new Date();
			oldDate.setTime(this._props[4].getTime());
			value.setHours(oldDate.getHours(), oldDate.getMinutes(), oldDate.getSeconds());
			if(!this._updatingActiveDay && !this._onActiveDayChanging(oldDate, value))
			{	
				if(this.getActiveDayClientSynchronization() ==  0)
				{	
					this._updatingActiveDay = true;
					this.fireEvent("InternalSetActiveDay", null, value, id);					
				}
				this._ActiveDayChangedValue = value;
				
				if(this._postRequest == 1 || post)
					setTimeout("__doPostBack('','')", 500);
				else
					this._updatingActiveDay = false;	
				
				var date =  value.getFullYear() + ":" + (value.getMonth() + 1) + ":" + value.getDate() + ":" + value.getHours() + ":" + value.getMinutes() + ":" + value.getSeconds();
				this.updateControlState("ActiveDay", date);
				this._onActiveDayChanged(this._props[4], value, false);
				this._props[4] = value;    
				return true;
			}
			else if(this._updatingActiveDay)
				return true;
				
			return false;
        }
        ig_WebScheduleInfo.prototype.getWorkDayStartTime = function() {
           return this._props[6];
        }  
        ig_WebScheduleInfo.prototype.getWorkDayEndTime = function() {
           return this._props[7];
        }  
        ig_WebScheduleInfo.prototype.getActiveResourceName = function() {
           return this._props[9];
        }  
        ig_WebScheduleInfo.prototype.getActiveResourceDataKey = function() {
           return this._props[10];
        }  

        ig_WebScheduleInfo.prototype.getAppointmentDialogID = function() {
           return this._props[11];
        }  
        ig_WebScheduleInfo.prototype.getReminderDialogID = function() {
           return this._props[12];
        }
        ig_WebScheduleInfo.prototype.getDefaultReminderInterval = function() {
           return this._props[13];
        }  
        ig_WebScheduleInfo.prototype.getDefaultSnoozeInterval = function() {
           return this._props[14];
        }
        ig_WebScheduleInfo.prototype.getTimeDisplayFormat = function() {
           return this._props[15];
        }      
        ig_WebScheduleInfo.prototype.getAllowAllDayEvents = function() {
           return this._props[16];
        }
        ig_WebScheduleInfo.prototype.getActiveDayClientSynchronization = function() {
           return this._props[17];
        }
        ig_WebScheduleInfo.prototype.getPreviousMonth = function() {
           return this._props[18];
        }
        ig_WebScheduleInfo.prototype.setPreviousMonth = function(value) {
			
			var date =  value.getFullYear() + ":" + (value.getMonth() + 1) + ":" + value.getDate();
			this.updateControlState("PreviousMonth", date);
        }
        ig_WebScheduleInfo.prototype._onActiveDayChanging = function(oldDate, newDate)
        {
        	return this.fireEvent("ActiveDayChanging", null, oldDate, newDate);
        }
        this._activeDayStateItem  = null;
        ig_WebScheduleInfo.prototype._onActiveDayChanged = function(oldDate, newDate, post)
        {
			if(this._activeDayStateItem== null)
			this._activeDayStateItem = this.addStateItem("ActiveDay", "Changed");	
			this.updateStateItem(this._activeDayStateItem, "OldDate", oldDate.getFullYear() + "-" + (oldDate.getMonth() + 1) + "-" + oldDate.getDate() + "-" + oldDate.getHours() + "-" + oldDate.getMinutes() + "-" + oldDate.getSeconds());
			this.updateStateItem(this._activeDayStateItem, "NewDate", newDate.getFullYear() + "-" + (newDate.getMonth() + 1) + "-" + newDate.getDate() + "-" + newDate.getHours() + "-" + newDate.getMinutes() + "-" + newDate.getSeconds());
        	this.fireEvent("ActiveDayChanged", null, newDate);
        	if(post || this._postRequest == 1)
        		this.fireServerEvent("");
        }
        
        ig_WebScheduleInfo.prototype._onActivityAdding = function(activity, id)
        {
			return this.fireEvent("ActivityAdding", null, activity, id);
        }
        
        ig_WebScheduleInfo.prototype._onActivityDialogEdit = function(activityEditProps)
        {
        	return this.fireEvent("ActivityDialogEdit", null, activityEditProps);
        }
        
        ig_WebScheduleInfo.prototype._onActivityUpdating = function(activityUpdate, activity, id)
        {
        	return this.fireEvent("ActivityUpdating", null, activityUpdate, activity,  id);
        }
        
        ig_WebScheduleInfo.prototype._onActivityDeleting = function(activity, id)
        {
        	return this.fireEvent("ActivityDeleting", null, activity,  id);
        }
        ig_WebScheduleInfo.prototype._onActivityDialogOpening = function(src, evnt)
        {
        	return this.fireEvent("ActivityDialogOpening", evnt);
        }
        ig_WebScheduleInfo.prototype._onReminderDialogOpening = function(src, evnt)
        {
        	return this.fireEvent("ReminderDialogOpening", evnt);
        }
        
		ig_WebScheduleInfo.prototype.getActivities = function ()
		{
			if(this._collections[0] == null)
				return null;
			if(this._activities == null)
				this._activities = new ig_ActivityCollection(this._collections[0], this);
			return this._activities;
		} 
        
		ig_WebScheduleInfo.prototype.getReminders = function ()
		{
			if(this._collections[1] == null)
				return null;
			if(this._activityReminders == null)
				this._activityReminders = new ig_ReminderCollection(this._collections[1]);
			return this._activityReminders;
		} 

		ig_WebScheduleInfo.prototype.addActivity = function (activity, id)
		{
			if(!this._onActivityAdding(activity, id))
			{
				var stateItem = this.addStateItem("Appointment", "Add");
				this.updateActivityStateItem(stateItem, id, activity)
				this.fireServerEvent("Add", "Appointment");	
			}
		}
		
		ig_WebScheduleInfo.prototype.updateActivity = function (activityUpdate, activity, id)
		{
			if(!this._onActivityUpdating(activityUpdate, activity, id))
			{
				if(activityUpdate.StartDateTime != null)
					activity.setStartDateTime(activityUpdate.StartDateTime);
				if(activityUpdate.Duration != null)
					activity.setDuration(activityUpdate.Duration);
				if(activityUpdate.Subject != null)
					activity.setSubject(activityUpdate.Subject);
				if(activityUpdate.Location != null)
					activity.setLocation(activityUpdate.Location);
				if(activityUpdate.Description != null)
					activity.setDescription(activityUpdate.Description);
				if(activityUpdate.AllDayEvent != null)
					activity.setAllDayEvent(activityUpdate.AllDayEvent);
				if(activityUpdate.EnableReminder != null)
					activity.setEnableReminder(activityUpdate.EnableReminder);
				if(activityUpdate.ShowTimeAs != null)
					activity.setShowTimeAs(activityUpdate.ShowTimeAs);
				if(activityUpdate.Importance != null)
					activity.setImportance(activityUpdate.Importance);
				if(activityUpdate.ReminderInterval != null)
					activity.setReminderInterval(activityUpdate.ReminderInterval);
			
				var stateItem = this.addStateItem("Appointment", "Update");
				this.updateActivityStateItem(stateItem, id, activity)
				this.fireServerEvent("Update","Appointment");
				return true;
			}
			return false; 
		}
		
		ig_WebScheduleInfo.prototype.deleteActivity = function (activity, id)
		{
			if(!this._onActivityDeleting(activity, id))
			{
				var stateItem = this.addStateItem("Appointment", "Delete");	
				this.updateActivityStateItem(stateItem, id, activity)
				this.fireServerEvent("Delete", "Appointment");
			}
		}
		
		ig_WebScheduleInfo.prototype.updateActivityStateItem = function (stateItem, id, activity)
		{
			if(activity.getStartDateTime() != null)
			{
				this.updateStateItem(stateItem, "StartDate",		activity.getStartDateTime().getFullYear() + "-" + (activity.getStartDateTime().getMonth() + 1) + "-" + activity.getStartDateTime().getDate());
				this.updateStateItem(stateItem, "StartTime",		activity.getStartDateTime().getHours() + "-" + activity.getStartDateTime().getMinutes());
			}
			this.updateStateItem(stateItem, "Duration",			activity.getDuration());
			this.updateStateItem(stateItem,	"ID",				id);
			this.updateStateItem(stateItem,	"DataKey",			activity.getDataKey());
			this.updateStateItem(stateItem, "AllDayEvent",		activity.getAllDayEvent());
			this.updateStateItem(stateItem, "EnableReminder",	activity.getEnableReminder());	
			this.updateStateItem(stateItem, "Subject",			activity.getSubject().replace(/\+/g,"%2B"));
			this.updateStateItem(stateItem, "Location",			activity.getLocation().replace(/\+/g,"%2B"));
			this.updateStateItem(stateItem, "Description",		activity.getDescription().replace(/\+/g,"%2B"));
			this.updateStateItem(stateItem, "ShowTimeAs",		activity.getShowTimeAs());
			this.updateStateItem(stateItem, "Importance",		activity.getImportance());
			this.updateStateItem(stateItem, "ReminderInterval", activity.getReminderInterval());		
			this.updateStateItem(stateItem,	"ResourceName",		this.getActiveResourceName());
			this.updateStateItem(stateItem,	"ResourceDataKey",	this.getActiveResourceDataKey());
			this.updateStateItem(stateItem, "Timestamp",		activity.getTimestamp());
		}
		ig_WebScheduleInfo.prototype.showAddAppointmentDialog = function (appointment, id) 
		{
			var oDlg = ig_getWebDialogActivatorById(this.getAppointmentDialogID());
			if(oDlg != null) 
			{
				if(!this._updatingActiveDay && !this._onActivityDialogOpening())
				{
					var endDate = new Date();
					var startDate = new Date();
					var fieldValues = oDlg.getFieldValues();
					oDlg.setCallbackFunction("dialogClosed");
					oDlg._scheduleInfo = this;
					fieldValues.addValues("ActiveResourceName", this._activeResourceName);
					fieldValues.addValues("ID", id);
					fieldValues.addValue("Subject", appointment.getSubject());
					fieldValues.addValue("Location", appointment.getLocation());
					fieldValues.addValue("Description", appointment.getDescription());	
					fieldValues.addValue("AllDayEvent", appointment.getAllDayEvent());
					fieldValues.addValue("DataKey", appointment.getDataKey());
					fieldValues.addValue("EnableReminder", appointment.getEnableReminder());
					
					startDate.setTime(appointment.getStartDateTime().getTime());
					fieldValues.addValue("StartDate", startDate);
					fieldValues.addValue("StartTime", startDate);
					endDate.setTime(startDate.getTime());
					endDate.setMinutes(endDate.getMinutes() +  parseInt(appointment.getDuration()));
					fieldValues.addValue("EndTime",	  endDate);
					fieldValues.addValue("EndDate", endDate);
					fieldValues.addValue("ReminderInterval", appointment.getReminderInterval());
					fieldValues.addValue("Importance", appointment.getImportance());
					fieldValues.addValue("ShowTimeAs", appointment.getShowTimeAs());
					fieldValues.addValue("TimeDisplayFormat", this.getTimeDisplayFormat());
					fieldValues.addValue("AllowAllDayEvents", this.getAllowAllDayEvents());
					return oDlg.showDialog(700, 800);		
				}
				else if(this._updatingActiveDay)
				{
					var startDateTime = appointment.getStartDateTime();
					var dataKey = (appointment.getDataKey() != null)? appointment.getDataKey(): -1;
					var dateTime = startDateTime.getFullYear() + ":" + (startDateTime.getMonth()+1) + ":" + startDateTime.getDate() + ":" + startDateTime.getHours() + ":" + startDateTime.getMinutes();
					this.updateControlState("ShowApptDialog", dataKey + "," + id + "," + dateTime );
				}
			}
			else
				{
					_showAppointmentsQueued = new Object();
					_showAppointmentsQueued.scheduleInfo = this;
					_showAppointmentsQueued.appointment = appointment;
					_showAppointmentsQueued.id = id;
					return false;
				}
			
		}
		ig_WebScheduleInfo.prototype.createNewAppointment = function(dateTime)
		{
			var appointment = this.getActivities().createActivity();
			appointment.setStartDateTime(dateTime);
			return appointment;
		}
		ig_WebScheduleInfo.prototype.showUpdateAppointmentDialog = function (datakey, id) 
		{
			var appointment = this.getReminders().getReminderFromKey(datakey);
			if(appointment == null)
				appointment = this.getActivities().getItemFromKey(datakey);
			if(appointment == null)
				return false; 
			return this.showAddAppointmentDialog(appointment, id);
		}
		ig_WebScheduleInfo.prototype.showReminders = function () 
		{
			var oDlg = ig_getWebDialogActivatorById(this.getReminderDialogID());
			if(oDlg != null) 
			{
				if(!this._onReminderDialogOpening())
				{
					var fieldValues = oDlg.getFieldValues();
					var reminders = this.getReminders();
					oDlg.setCallbackFunction("reminderDialogClosed");
					oDlg._scheduleInfo = this;
					fieldValues.addValues(
						"ActiveResourceName", this._activeResourceName,
						"Reminders", reminders);
					if(reminders.length > 0)
					{
						var result = oDlg.showDialog(400, 600);
						return true;
					}
					return false; 
				}
			}
			else
			{
				_showReminderQueued = this;
				return false;
			}
		}
		var _defaultActivityDuration = 30;
		ig_WebScheduleInfo.prototype.getDefaultActivityDuration = function () 
		{
			return _defaultActivityDuration;
		}
		ig_WebScheduleInfo.prototype.setDefaultActivityDuration = function (val) 
		{
			_defaultActivityDuration = val;
		}
		ig_WebScheduleInfo.prototype.navigate = function (years, months, days, id)
		{
			this._updatingActiveDay = true;
			this.fireEvent("InternalNavigate", null, years, months, days, id);
		
			var stateItem = this.addStateItem("ActiveDay", "Navigate");	
			this.updateStateItem(stateItem, "Years", years);
			this.updateStateItem(stateItem, "Months", months);
			this.updateStateItem(stateItem, "Days", days);
			this.updateStateItem(stateItem, "ID", id);
			this.fireServerEvent("Navigate", "ActiveDay");
		}
		ig_WebScheduleInfo.prototype._onUnload = function()
		{
			var dialog = ig_getWebDialogActivatorById(this._clientID+"ReminderDialog");
			if(dialog && dialog.isOpen())
			{
				dialog._dialogClosed(true);
				dialog.closeDialog();
			}
			dialog = ig_getWebDialogActivatorById(this._clientID+"AppointmentDialog");
			if(dialog && dialog.isOpen())
			{
				dialog.closeDialog();
			}
		}
		ig_WebScheduleInfo.prototype._onLoad = function()
		{
			var old = this.getActiveDay();
			if(!old || !this.postField) return;
			var str = unescape(unescape(this.postField.value));
			var i = str.indexOf("ActiveDay=\"");
			if(i < 1) return;
			str = str.substring(i + 11);
			i = str.indexOf("\"");
			if(i < 8) return;
			str = str.substring(0, i).split(":");
			if(old.getFullYear() != parseInt(str[0]) || old.getMonth() + 1 != parseInt(str[1]) || old.getDate() != parseInt(str[2]))
				window.setTimeout("try{__doPostBack('','');}catch(e){}", 0);
		}
	}
	return new ig_WebScheduleInfo(props);
}
        
function ig_WebScheduleInfo(props)
{
   if(arguments.length != 0)
       this.init(props);
}

// public: get object from ClientID or UniqueID
function ig_getWebScheduleInfoById(id)
{
	return ig_getWebControlById(id);
}  

function dialogClosed(oDlg, result) {
	if(result == true) {
		if(oDlg._scheduleInfo == null)
			throw new Exception("Invalid method call - dialogClosed");
		var scheduleInfo = oDlg._scheduleInfo;	
		var fieldValues = oDlg.getFieldValues();
		var operation = fieldValues["Operation"];
		var id = fieldValues["ID"];
		var appointment = null;
		var dataKey = fieldValues["DataKey"];
		if(dataKey != null)
		{
			appointment = scheduleInfo.getReminders().getReminderFromKey(dataKey);
			if(appointment == null)
				appointment = scheduleInfo.getActivities().getItemFromKey(dataKey);
		}
		else
			appointment = scheduleInfo.getActivities().createActivity();
			
		var startDateTime = new Date();
		startDateTime.setTime(fieldValues["StartDateTime"].getTime());
		
		if(operation == "Update")
		{
			var appointmentDynamicObject = {StartDateTime: startDateTime,
									    Duration: fieldValues["Duration"],
									    Subject: fieldValues["Subject"],
									    Location: fieldValues["Location"],
										Description: fieldValues["Description"],
										AllDayEvent: fieldValues["AllDayEvent"],
										EnableReminder: fieldValues["EnableReminder"],
										ShowTimeAs: fieldValues["ShowTimeAs"],
										Importance: fieldValues["Importance"],
										ReminderInterval: fieldValues["ReminderInterval"]
										};
			scheduleInfo.updateActivity(appointmentDynamicObject, appointment, id);
		}
		else
		{
			appointment.setStartDateTime(startDateTime);
			appointment.setDuration(fieldValues["Duration"]);
			appointment.setSubject(fieldValues["Subject"]);
			appointment.setLocation(fieldValues["Location"]);
			appointment.setDescription(fieldValues["Description"]);
			appointment.setAllDayEvent(fieldValues["AllDayEvent"]);
			appointment.setEnableReminder(fieldValues["EnableReminder"]);
			appointment.setShowTimeAs(fieldValues["ShowTimeAs"]);
			appointment.setImportance(fieldValues["Importance"]);
			appointment.setReminderInterval(fieldValues["ReminderInterval"]);
			
			if(operation == "Delete")
				scheduleInfo.deleteActivity(appointment, id );
			else if(operation == "Add")
				scheduleInfo.addActivity(appointment, id);
		}
	}
}      

function reminderDialogClosed(oDlg, result) {
	if(result == true) {
		if(oDlg._scheduleInfo == null)
			throw new Exception("Invalid method call - reminderDialogClosed");
		var scheduleInfo = oDlg._scheduleInfo;	
		var fieldValues = oDlg.getFieldValues();
		var postBack = fieldValues.getValue("Dismissed");
		
		if(postBack == true)
			scheduleInfo.fireServerEvent("Process", "Reminder");
	}
}     

function ig_CreateActivity(props)
{
	if(!ig_Activity.prototype.isPrototypeOf(this.prototype))
    {
		ig_Activity.prototype.getStartDateTime = function() {
			return(this._props[0]);
		}
		ig_Activity.prototype.setStartDateTime = function(value) {
			this._props[0] = value;
		}
		ig_Activity.prototype.getDuration = function() {
			return(this._props[1]);
		}
		ig_Activity.prototype.setDuration = function(value) {
			this._props[1] = value;
		}
		ig_Activity.prototype.getDataKey = function() {
			return(this._props[2]);
		}
		ig_Activity.prototype.getAllDayEvent = function() {
			return(this._props[3]);
		}
		ig_Activity.prototype.setAllDayEvent = function(value) {
			this._props[3] = value;
		}
		ig_Activity.prototype.getStatus = function() {
			return(this._props[4]);
		}
		ig_Activity.prototype.getEnableReminder = function() {
			return(this._props[5]);
		}
		ig_Activity.prototype.setEnableReminder = function(value) {
			this._props[5] = value;
		}
		ig_Activity.prototype.getReminderInterval = function() {
			return(this._props[6]);
		}
		ig_Activity.prototype.setReminderInterval = function(value) {
			this._props[6] = value;
		}
		ig_Activity.prototype.getImportance = function() {
			return(this._props[7]);
		}
		ig_Activity.prototype.setImportance = function(value) {
			this._props[7] = value;
		}		
		ig_Activity.prototype.getShowTimeAs = function() {
			return(this._props[8]);
		}
		ig_Activity.prototype.setShowTimeAs = function(value) {
			this._props[8] = value;
		}		
		ig_Activity.prototype.getSnoozeTimeStamp = function() {
			return(this._props[9]);
		}
		ig_Activity.prototype.setSnoozeTimeStamp = function(value) {
			this._props[9] = value;
		}		
		ig_Activity.prototype.getSnoozeInterval = function() {
			return(this._props[10]);
		}
		ig_Activity.prototype.setSnoozeInterval = function(value) {
			this._props[10] = value;
		}		
		ig_Activity.prototype.getSubject = function() {
			return(this._props[11]);
		}
		ig_Activity.prototype.setSubject = function(value) {
			this._props[11] = value;
		}
		ig_Activity.prototype.getLocation = function() {
			return(this._props[12]);
		}
		ig_Activity.prototype.setLocation = function(value) {
			this._props[12] = value;
		}
		ig_Activity.prototype.getDescription = function() {
			return(this._props[13]);
		}
		ig_Activity.prototype.setDescription = function(value) {
			this._props[13] = value;
		}
		ig_Activity.prototype.getTimestamp = function() {
			return(this._props[14]);
		}
		ig_Activity.prototype.setTimestamp = function(value) {
			this._props[14] = value;
		}			
	}
    return new ig_Activity(props);
}   
   
function ig_Activity(props)
{
	this._props = props;
}        
   
function ig_ActivityCollection(props, scheduleInfo) {
	this._props = props;
	this.length = props.length;
	this._scheduleInfo = scheduleInfo;
	
	this.getItem = function(index) {
		if(index < 0 || index > this._props.length)
			throw new Exception("Index Out of Bounds for ActivityCollection");
			
		if(this[index] == null)
			this[index] = ig_CreateActivity(this._props[index])
			
		return(this[index]);
	}
	
	this.getItemFromKey = function(dataKey)
	{
		for(var i = 0; i < this.length; i++)
		{
			if(this.getItem(i).getDataKey() == dataKey)
				return this[i];
		}		
		return null;	
	}
	this.createActivity = function()
	{
		var props = [
					new Date(), 										// StartDateTime
					this._scheduleInfo.getDefaultActivityDuration(),	// Duration
					null,												// DataKey
					false,												// AllDayEvent
					0,													// Status
					true,												// EnableReminder
					this._scheduleInfo.getDefaultReminderInterval(),	// ReminderInterval
					1,													// Importance
					3,													// ShowTimeAs
					0,													// SnoozeTimeStamp
					this._scheduleInfo.getDefaultSnoozeInterval(),		// SnoozeInterval
					"",													// Subject
					"",													// Location
					"",													// Description
					"0"													// Timestamp
					];
		return new ig_CreateActivity(props);
	}
}     

function ig_CreateReminder(props)
{
	if(!ig_Activity.prototype.isPrototypeOf(ig_Reminder.prototype))
	{
		ig_Reminder.prototype = new ig_CreateActivity(props);
		ig_Reminder.prototype.constructor = ig_Reminder;
		ig_Reminder.prototype.base = ig_Activity.prototype;
	}
    
	return new ig_Reminder(props);

}

function ig_Reminder(props)
{
	this._props = props;		
}

function ig_ReminderCollection(props)
{
	this._props = props;
	this.length = props.length;
	
	this.getItem = function(index) {
		if(index < 0 || index > this._props.length)
			throw new Exception("Index Out of Bounds for ActivityCollection");
			
		if(this[index] == null)
			this[index] = ig_CreateReminder(this._props[index])
			
		return(this[index]);
	}
	
	this.getReminderFromKey = function(dataKey)
	{		
		for(var i = 0; i < this.length; i++)
		{
			if(this.getItem(i).getDataKey() == dataKey)
				return this[i];
		}		
		return null;	
	}
}
