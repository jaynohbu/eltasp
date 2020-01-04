 /*
  * Infragistics WebSchedule CSOM Script: ig_webmonthview.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */


// WebMonthView prototype and constructor
function ig_CreateWebMonthView(props)
{
    if(!ig_WebControl.prototype.isPrototypeOf(ig_WebMonthView.prototype))
    {
        ig_WebMonthView.prototype = new ig_WebControl();
        ig_WebMonthView.prototype.constructor = ig_WebMonthView;
        ig_WebMonthView.prototype.base=ig_WebControl.prototype;
        
        ig_WebMonthView.prototype.init = function(props)
        {
			this._isInitializing=true;
			this._initControlProps(props);
			this.base.init.apply(this,[this._clientID]);
			this._element = ig_shared.getElementById(this._clientID+"_main");
			ig_shared.addEventListener(this._element.parentNode, "mousedown", ig_handleEvent);
			ig_shared.addEventListener(this._element.parentNode, "mouseup", ig_handleEvent);
			ig_shared.addEventListener(this._element.parentNode, "click", ig_handleEvent);
			ig_shared.addEventListener(this._element.parentNode, "dblclick", ig_handleEvent);
			ig_shared.addEventListener(this._element.parentNode, "select", ig_cancelEvent);
			ig_shared.addEventListener(this._element.parentNode, "selectstart", ig_cancelEvent);
			this._setActiveDay = function(info, evnt, activeDay, id)
			{
				var me = this._event._object;
				if(!me || !activeDay )
					return;
				
				if( me._clientID != id)
				{
					var dayHeader = me._daysOfMonth[activeDay.getFullYear() + "," + activeDay.getMonth() + "," + activeDay.getDate()];
					if(dayHeader != null)
					{
						var day = me._getDayFromHeader(dayHeader);
						me._selectDay(dayHeader, day);	
					}
					else
					{
						var fvd = me.getFirstVisibleDay();
						var lvd = new Date();
						lvd.setTime(fvd.getTime());
						lvd.setDate(fvd.getDate() + 41);
						var currentMonth = new Date();
						currentMonth.setTime(me.getCurrentMonth().getTime());
						var lastCurrentMonth = currentMonth.getMonth();
						currentMonth.setDate(1);
						
						if(activeDay.getTime() < fvd.getTime())
						{
							currentMonth.setMonth(currentMonth.getMonth() - (currentMonth.getMonth() - activeDay.getMonth()));
							currentMonth.setFullYear(activeDay.getFullYear());
						}
						else if(activeDay.getTime() > lvd.getTime())
						{
							currentMonth.setMonth(currentMonth.getMonth() + (activeDay.getMonth() - currentMonth.getMonth()));
							currentMonth.setFullYear(activeDay.getFullYear());
						}
						
						if(currentMonth.getMonth() != lastCurrentMonth)
							me.getWebScheduleInfo().setPreviousMonth(me.getCurrentMonth());
						
						me.setCurrentMonth(currentMonth);
						
						evnt.needPostBack = true;
					}		
				}
			}
			
			this._navigate = function(info, evnt, years, months, days, id)
			{
				var me = this._event._object;
				if(me._clientID != id)
				{
					var info = me.getWebScheduleInfo();
					var prevActiveDay = info.getActiveDay();				 
					var newActiveDay = new Date();
					newActiveDay.setTime(prevActiveDay.getTime());
					if(days == 0)
						newActiveDay.setDate(1);
						
					newActiveDay.setFullYear(newActiveDay.getFullYear() + years, newActiveDay.getMonth() + months, newActiveDay.getDate() + days);
					if(days == 0)
					{
						var month = newActiveDay.getMonth();
						var date = prevActiveDay.getDate();
						newActiveDay.setDate(date);	
						while(newActiveDay.getMonth() != month)
						{
							newActiveDay.setMonth(month);
							newActiveDay.setDate(date);	
							date--;
						}
					}
					
					var fvd = me.getFirstVisibleDay();
					var lvd = new Date();
					lvd.setTime(fvd.getTime());
					lvd.setDate(fvd.getDate() + 41);
					var currentMonth = new Date();
					currentMonth.setTime(me.getCurrentMonth().getTime());
					var lastCurrentMonth = currentMonth.getMonth();
					currentMonth.setDate(1);
					
					if(newActiveDay.getTime() < fvd.getTime())
					{
						currentMonth.setMonth(currentMonth.getMonth() - (currentMonth.getMonth() - newActiveDay.getMonth()));
						currentMonth.setFullYear(newActiveDay.getFullYear());
					}
					else if(newActiveDay.getTime() > lvd.getTime())
					{
						currentMonth.setMonth(currentMonth.getMonth() + (newActiveDay.getMonth() - currentMonth.getMonth()));
						currentMonth.setFullYear(newActiveDay.getFullYear());
					}
					
					if(currentMonth.getMonth() != lastCurrentMonth)
						info.setPreviousMonth(me.getCurrentMonth());
					
					me.setCurrentMonth(currentMonth);
				}
			}
			this.getWebScheduleInfo().addEventListener("InternalSetActiveDay", this._setActiveDay, this, false);
			this.getWebScheduleInfo().addEventListener("InternalNavigate", this._navigate, this, false);
			this._selectedAppt = new Object();
			this._selectedHeader = new Object();
			this._selectedDay = new Object();
			var activeDay = document.getElementById(this._clientID + "_ActiveDay");
			if(activeDay != null)
			{
				this._selectedHeader.elem = activeDay;
				var classes = this.getActiveDayHeaderStyle().split(" ");
				var oldClass = activeDay.className;
				for(var i = 0; i < classes.length; i++)
					oldClass = oldClass.replace(classes[i], "");
				this._selectedHeader.oldClass = oldClass;
								
				this._selectedDay.elem = this._getDayFromHeader(activeDay);
				classes = this.getActiveDayStyle().split(" ");
				oldClass = this._selectedDay.elem.className;
				for(var i = 0; i < classes.length; i++)
					oldClass = oldClass.replace(classes[i], "");
				this._selectedDay.oldClass =  oldClass;
			} 
			this._isInitializing=false;
			this.fireEvent("initialize");
		}
		
		ig_WebMonthView.prototype._getDayFromHeader = function(header)
		{
			var index = header.cellIndex;
			if(this.getWeekNumbersVisible() && header.getAttribute("uie") == "DAYHEADER")
				index--;
			return header.parentNode.nextSibling.cells[index];
		}
		
		ig_WebMonthView.prototype._getHeaderFromDay = function(day)
		{
			var index = day.cellIndex;
			if(this.getWeekNumbersVisible() && day.getAttribute("uie") == "DAY")
				index++;
			return day.parentNode.previousSibling.cells[index];
		}

		ig_WebMonthView.prototype._onLoad = function(src, evt) 
		{
			if(this.getWebScheduleInfo().getActiveDayClientSynchronization() == 0)
			{
				this._daysOfMonth = new Object();
				var week = document.getElementById(this._clientID + "_FirstWeek");
				while(week.getAttribute("uie") == "DAYHEADERS")
				{
					for(var i = 0; i < week.cells.length; i++)
					{
						if(week.cells[i].getAttribute("uie") == "DAYHEADER" || week.cells[i].getAttribute("uie") == "COMPDAYHEADER" )
						{
							var date = week.cells[i].getAttribute("date");
							this._daysOfMonth[date] =  week.cells[i];
						}
					}
					do
					{
						week = week.nextSibling;
					}
					while(week.attributes == null || (week.getAttribute("uie") != "DAYHEADERS" && week.nextSibling != null));
						
				}

			}
		}
        
		ig_WebMonthView.prototype._onMouseup = function(src, evt) 
		{
			this.fireEvent(evt.type, evt, src);
		}

		ig_WebMonthView.prototype._onClick = function(src, evt) 
		{
			if(this.fireEvent(evt.type, evt, src))
				return;
			var info = this.getWebScheduleInfo();
			src = ig_findElemWithAttr(src, "uie");
			var attr = (info && src) ? src.getAttribute("uie") : null;
			var incrementYear = false;
			
			if(attr == "NEXT" || attr == "PREV")
			{
				if(!this.fireEvent((attr == "NEXT") ? "navigatenext" : "navigateprevious", evt, (attr=="NEXT") ? 1: -1))	
				{
					var fvd = new Date();
					var activeDay = info.getActiveDay();
					fvd = this.getFirstVisibleDay();
					var fvdDayofWeek = fvd.getDay();
					var activeDayofWeek = activeDay.getDay();
					var newMonth;
								
					if(attr == "NEXT")
						newMonth = fvd.getMonth() + 2;
					else if(attr == "PREV")
						newMonth = fvd.getMonth();
						
					if(newMonth > 11)
					{
						newMonth = newMonth - 12;
						incrementYear = true;
					}
						
					//Calculate the First Visible Day for the Next Month
					var newFvd = new Date();
					newFvd.setTime(fvd.getTime());
					newFvd.setDate(1);
					newFvd.setMonth(newMonth);
					if(incrementYear)
						newFvd.setFullYear(newFvd.getFullYear() + 1);
					newFvd.setDate(newFvd.getDate()-10);
					while(newFvd.getDay() != fvdDayofWeek)
						newFvd.setDate(newFvd.getDate() + 1);
					
					// Find the Amount of days difference between last Month's FVD and ActiveDay
					var daysToAdd = (activeDay.getTime() - fvd.getTime())/1000/60/60/24;
					
					// Calculate the newActiveDay
					var newActiveDay = new Date();
					newActiveDay.setTime(newFvd);
					newActiveDay.setDate(newActiveDay.getDate() + daysToAdd);
					
					var daysToMove = (newActiveDay.getTime() - activeDay.getTime())/1000/60/60/24;
					daysToMove = parseInt(daysToMove.toString());
					
					// Test the newActiveDay and Make sure that its 
					var testDate = new Date();
					testDate.setTime(activeDay.getTime());
					testDate.setDate(testDate.getDate() + daysToMove);
					
					if(testDate.getDay() > activeDayofWeek && activeDayofWeek != 0)
						daysToMove--;
					else if(testDate.getDay() < activeDayofWeek || (activeDayofWeek == 0 && testDate.getDay() != activeDayofWeek))
						daysToMove++;
					
					var currentMonth = new Date();
					currentMonth.setTime(this.getCurrentMonth().getTime());
					var lastCurrentMonth = currentMonth.getMonth();
					var currentYear = currentMonth.getFullYear();
					currentMonth.setMonth(newMonth);
					if(currentYear < currentMonth.getFullYear())
						currentMonth.setFullYear(currentMonth.getFullYear() - 1);
					else if(currentYear > currentMonth.getFullYear())
						currentMonth.setFullYear(currentMonth.getFullYear() + 1);
						
					if(newMonth == 11 && lastCurrentMonth == 0)
						currentMonth.setFullYear(currentMonth.getFullYear() - 1);
					else if(newMonth == 0 && lastCurrentMonth == 11 )
						currentMonth.setFullYear(currentMonth.getFullYear() + 1);
					
					if(currentMonth.getMonth() != lastCurrentMonth)
						info.setPreviousMonth(this.getCurrentMonth());
					
					this.setCurrentMonth(currentMonth);
					
					info.navigate(0,0,daysToMove, this._clientID);
				}
			}
		}

		ig_WebMonthView.prototype._onMousedown = function(src, evt) 
		{
			if(this.fireEvent(evt.type, evt, src))
				return;
			var scheduleInfo = this.getWebScheduleInfo();
			if(!scheduleInfo) return;
			if(src.tagName == "IMG")
				src = src.parentNode;
			var uie = src.getAttribute("uie");	
			if(uie == "Appt")
			{	
				var srcDay = src.parentNode;
				while(srcDay.getAttribute("uie") != "DAY" && srcDay.getAttribute("uie") != "COMPDAY" )
					srcDay = srcDay.parentNode;
					
				var srcheader = this._getHeaderFromDay(srcDay);
				this._selectDay(srcheader, srcDay);		
				
				if(srcheader == this._selectedHeader.elem)
				{
					if(this._selectedAppt.elem != null)
						this._selectedAppt.elem.className = this._selectedAppt.oldClass;
					this._selectedAppt.elem = src;
					this._selectedAppt.key = src.getAttribute("ig_key");
					this._selectedAppt.oldClass = src.className;
					src.className +=  " " +  this.getSelectedAppointmentStyle();
				}
			}	
						
			if(uie == "DAYHEADER" || uie == "COMPDAYHEADER")
			{
				var srcday = this._getDayFromHeader(src);
				this._selectDay(src, srcday);
			}
			if(uie == "DAY" || uie == "COMPDAY")
			{
				var srcHeader = this._getHeaderFromDay(src);
				this._selectDay(srcHeader, src);
			}
			
			if(uie == "APPTAREA")
			{
				var srcDay = src.parentNode;
				while(srcDay.getAttribute("uie") != "DAY" && srcDay.getAttribute("uie") != "COMPDAY" )
					srcDay = srcDay.parentNode;
				var srcHeader = this._getHeaderFromDay(srcDay);
				this._selectDay(srcHeader, srcDay);
			}
		}
		ig_WebMonthView.prototype._selectDay = function(srcHeader, srcDay)
		{
			var scheduleInfo = this.getWebScheduleInfo();
			if(!scheduleInfo) return;
			if(this._selectedHeader.elem != srcHeader)
			{
				var date = srcHeader.getAttribute("date");
				if(ig_shared.isEmpty(date)) return;
				date = date.split(",");
				var dateTime = new Date();
				dateTime.setFullYear(date[0], date[1], date[2]);
				dateTime.setHours(0,0,0);
				var	setDay = scheduleInfo.setActiveDay(dateTime, false, this._clientID);	
			
				if(setDay)
				{
					if(this._selectedHeader.elem != null)
					{
						this._selectedHeader.elem.className = this._selectedHeader.oldClass;
						if(this._selectedHeader.elem != srcHeader && this._selectedAppt.elem != null)
						{
							this._selectedAppt.elem.className = this._selectedAppt.oldClass;
							this._selectedAppt.elem = null;									
						}
					}
					this._selectedHeader.elem = srcHeader;
					this._selectedHeader.oldClass = srcHeader.className;
					srcHeader.className +=  " " + this.getActiveDayHeaderStyle();	
					
					if(this._selectedDay.elem != null)
						this._selectedDay.elem.className = this._selectedDay.oldClass;
					this._selectedDay.elem = srcDay;
					this._selectedDay.oldClass = srcDay.className;
					srcDay.className += " " + this.getActiveDayStyle();		
				}
			}
			if(this._selectedAppt.elem != null)
			{
				this._selectedAppt.elem.className = this._selectedAppt.oldClass;
			}
		}
		ig_WebMonthView.prototype._onDblclick = function(src, evt)
		{
			if(this.fireEvent(evt.type, evt, src))
				return;
			var scheduleInfo = this.getWebScheduleInfo();
			if(!scheduleInfo) return;
			if(this.getEnableAutoActivityDialog())
			{
				if(src.tagName == "IMG")
					src = src.parentNode;
				var uie = src.getAttribute("uie");	
				if(uie == "Appt")
				{
					scheduleInfo.showUpdateAppointmentDialog(src.getAttribute("ig_key"), this._clientID);
				}
				else if(uie == "DAYHEADER" || uie == "COMPDAYHEADER")
				{
					this._openApptDialog(src);
				}
				else if(uie == "DAY" || uie=="COMPDAY")
				{
					var srcHeader = this._getHeaderFromDay(src);
					this._openApptDialog(srcHeader);
				}
				else if(uie == "APPTAREA")
				{
					var srcDay = src.parentNode;
					while(srcDay.getAttribute("uie") != "DAY" && srcDay.getAttribute("uie") != "COMPDAY" )
						srcDay = srcDay.parentNode;
					var srcHeader = this._getHeaderFromDay(srcDay);
					this._openApptDialog(srcHeader);
				}
			}
		}
		
		ig_WebMonthView.prototype._openApptDialog = function(srcHeader)
		{
			var scheduleInfo = this.getWebScheduleInfo();
			var date = srcHeader.getAttribute("date");
			if(ig_shared.isEmpty(date)) return;
			date = date.split(",");
			var dateTime = new Date();
			dateTime.setFullYear(date[0], date[1], date[2]);
			var appointment = scheduleInfo.getActivities().createActivity();
			var minutes = dateTime.getMinutes();
			if(minutes < 30)
				dateTime.setMinutes(30);
			else if(minutes > 30)
				dateTime.setHours(dateTime.getHours()+1,0);
			appointment.setStartDateTime(dateTime);
			scheduleInfo.showAddAppointmentDialog(appointment, this._clientID);	
		}
        ig_WebMonthView.prototype.getSelectedActivity = function()
		{
			if(this._selectedAppt == null || this._selectedAppt.elem == null)
				return null;
			else
			{
				var activities = this.getWebScheduleInfo().getActivities();
				return activities.getItemFromKey(this._selectedAppt.key);
			}
		}
        ig_WebMonthView.prototype.getCaptionHeaderVisible = function() {
           return this._props[5];
        }  
        ig_WebMonthView.prototype.getEnableAutoActivityDialog = function() {
           return this._props[6];
        } 
        ig_WebMonthView.prototype.getWebScheduleInfoID = function() {
           return this._props[7];
        }
		ig_WebMonthView.prototype.getWebScheduleInfo = function()
		{
			return ig_getWebControlById(this._props[7]);
		}
		ig_WebMonthView.prototype.getFirstVisibleDay = function() {
           return this._props[8];
        }
        ig_WebMonthView.prototype.getCurrentMonth = function() {
           return this._props[9];
        }
		ig_WebMonthView.prototype.setCurrentMonth = function(value)
		{
			this._props[9] = value; 
			var date =  value.getFullYear() + ":" + (value.getMonth() + 1) + ":" + value.getDate();
			this.updateControlState("CurrentMonth", date);
		}
		ig_WebMonthView.prototype.getWeekNumbersVisible = function() {
           return this._props[10];
        }   
        ig_WebMonthView.prototype.getMonthDayOfWeekHeaderStyle = function() {
           return this._props[11];
        }   
        ig_WebMonthView.prototype.getCaptionHeaderStyle = function() {
           return this._props[12];
        }   
        ig_WebMonthView.prototype.getMonthStyle = function() {
           return this._props[13];
        }   
        ig_WebMonthView.prototype.getOtherMonthDayHeaderStyle = function() {
           return this._props[14];
        }    
        ig_WebMonthView.prototype.getOtherMonthDayStyle = function() {
           return this._props[15];
        }
        ig_WebMonthView.prototype.getCompressedDayStyle = function() {
           return this._props[16];
        }
        ig_WebMonthView.prototype.getOtherCompressedDayStyle = function() {
           return this._props[17];
        }
        ig_WebMonthView.prototype.getActiveDayHeaderStyle = function() {
           return this._props[18];
        }
        ig_WebMonthView.prototype.getActiveDayStyle = function() {
           return this._props[19];
        } 
        ig_WebMonthView.prototype.getAllDayEventStyle = function() {
           return this._props[20];
        } 
        ig_WebMonthView.prototype.getAppointmentStyle = function() {
           return this._props[21];
        } 
        ig_WebMonthView.prototype.getSelectedAppointmentStyle = function() {
           return this._props[22];           
        }     
        ig_WebMonthView.prototype.getDayHeaderStyle = function() {
           return this._props[23];           
        }
        ig_WebMonthView.prototype.getDayStyle = function() {
           return this._props[24];           
        }
        ig_WebMonthView.prototype.getTodayHeaderStyle = function() {
           return this._props[25];
        }
        ig_WebMonthView.prototype.getTodayStyle = function() {
           return this._props[26];
        }
	}
	return new ig_WebMonthView(props);
}

function ig_WebMonthView(props)
{
	if(arguments.length != 0)
		this.init(props);
}

// public: get object from ClientID or UniqueID
function ig_getWebMonthViewById(id)
{
	return ig_getWebControlById(id);
}
