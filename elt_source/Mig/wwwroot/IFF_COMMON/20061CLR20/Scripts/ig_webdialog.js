 /*
  * Infragistics WebSchedule CSOM Script: ig_webdialog.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

     

      
// WebDialog Enumerations
var igdlg_eRequestType = new Object();
	igdlg_eRequestType.None = 0;
	igdlg_eRequestType.DialogData = 1;
	igdlg_eRequestType.RefreshData = 2;
	
var _showReminderQueued = null;
var _showAppointmentsQueued = null;
        
// WebDialogActivator prototype and constructor
function ig_CreateWebDialogActivator(props)
{
    if(!ig_WebControl.prototype.isPrototypeOf(ig_WebDialogActivator.prototype))
    {
        ig_WebDialogActivator.prototype = new ig_WebControl();
        ig_WebDialogActivator.prototype.constructor = ig_WebDialogActivator;
        ig_WebDialogActivator.prototype.base=ig_WebControl.prototype;
        
        ig_WebDialogActivator.prototype.fireServerEvent = function(eventName, data) {__doPostBack(this.getUniqueID(), eventName + ":" + data);}
        ig_WebDialogActivator.prototype.init = function(props)
        {
            this._isInitializing=true;
            this._initControlProps(props);
            this.base.init.apply(this,[this.getClientID()]);
			this._fieldValues = new ig_Dictionary();
            this._isInitializing=false;
            this._window = null;
        }
        
        
		ig_WebDialogActivator.prototype.getFieldValues = function () {
			return this._fieldValues;
		}

        ig_WebDialogActivator.prototype.getContentUrl = function() {
           return this._props[2];
        }  
        ig_WebDialogActivator.prototype.setContentUrl = function(value) {
           this._props[2] = value;
           this.updateControlState("ContentUrl", value);
        }  
        
        ig_WebDialogActivator.prototype.getCaption = function() {
           return this._props[3];
        }  
        ig_WebDialogActivator.prototype.setCaption = function(value) {
           this._props[3] = value;
           this.updateControlState("Caption", value);
        }  
        
        ig_WebDialogActivator.prototype.getFormWidth = function() {
           return this._props[4];
        }  
        ig_WebDialogActivator.prototype.setFormWidth = function(value) {
           this._props[4] = value;
           this.updateControlState("FormWidth", value);
        }  
        
        ig_WebDialogActivator.prototype.getFormHeight = function() {
           return this._props[5];
        }  
        ig_WebDialogActivator.prototype.setFormHeight = function(value) {
           this._props[5] = value;
           this.updateControlState("FormHeight", value);
        }  
        
        ig_WebDialogActivator.prototype.getModality = function() {
           return this._props[6];
        }  
        ig_WebDialogActivator.prototype.setModality = function(value) {
           this._props[6] = value;
           this.updateControlState("Modality", value);
        }  
        
        ig_WebDialogActivator.prototype.onDialogLoading = function(evnt)
        {
        	this.fireEvent(this._clientEvents["DialogLoading"], evnt, null);
        }
        
        ig_WebDialogActivator.prototype.onDialogLoaded = function(evnt)
        {
        	this.fireEvent(this._clientEvents["DialogLoaded"], evnt, null);
        }
        
        ig_WebDialogActivator.prototype.onDialogValidating = function(evnt)
        {
        	this.fireEvent(this._clientEvents["DialogValidating"], evnt, null);
        }
        
        ig_WebDialogActivator.prototype.onDialogValidated = function(evnt)
        {
        	this.fireEvent(this._clientEvents["DialogValidated"], evnt, null);
        }
        
        ig_WebDialogActivator.prototype.onDialogClosing = function(evnt)
        {
        	this.fireEvent(this._clientEvents["DialogClosing"], evnt, null);
        }
        
        ig_WebDialogActivator.prototype.onDialogClosed = function(evnt)
        {
        	this.fireEvent(this._clientEvents["DialogClosed"], evnt, null);
        }
        
		ig_WebDialogActivator.prototype.showDialog = function(height, width)
		{
			if((this._executing == true && this.getModality() == "SingleInstanceModal"))
			{
				if(this._window && !this._window.closed)
					return;
			}
			
			this._executing = true;
			
			igdlg_showDialog(this, height, width);
		}
		
		ig_WebDialogActivator.prototype.getWindow = function()
		{	
			return this._window;
		}
		
		ig_WebDialogActivator.prototype.isOpen = function()
		{	
			return this._executing;
		}
		
		ig_WebDialogActivator.prototype.closeDialog = function()
		{
			if(this._window != null)
			{
				this._cancel = true;
				this._window.close();
			}
			this._executing = false;
		}
		
		ig_WebDialogActivator.prototype._dialogClosed = function(result) {
			document.body.disabled = false;
			this._executing = null;
			if(this._callbackFunction != null)
				this._callbackFunction(this, result)
			
		}
		
		ig_WebDialogActivator.prototype.getCallbackFunction = function () {
			return this._callbackFunction ;
		}
		
		ig_WebDialogActivator.prototype.setCallbackFunction = function (callback) {
			this._callbackFunction = eval(callback);
		}
        
    }
    
    return new ig_WebDialogActivator(props);
}
        
function ig_WebDialogActivator(props)
{
        if(arguments.length != 0)
            this.init(props);
           
        var remindersCheck = false;
        var appointmentsCheck = false;
        if(_showReminderQueued)
			remindersCheck = _showReminderQueued.showReminders();
		if(remindersCheck)
			_showReminderQueued = null;
		
		if(_showAppointmentsQueued)
			appointmentsCheck = _showAppointmentsQueued.scheduleInfo.showAddAppointmentDialog(_showAppointmentsQueued.appointment, _showAppointmentsQueued.id);
		if(appointmentsCheck)
			_showAppointmentsQueued = null;
	
}
		

// public: get object from ClientID or UniqueID
function ig_getWebDialogActivatorById(id)
{
	return ig_getWebControlById(id);
}        
    
function igdlg_showDialog(contextDlg, height, width)  // context is the WebDialog control making the OBC
{
	if(typeof(contextDlg) != "object")
		return;
	
	var style = "width = " + width +",height =" + height +  ", status=no,resizable=yes";
	contextDlg._window = window.open(contextDlg.getContentUrl(), contextDlg.getCaption(), style); 
	document.fieldValues = contextDlg.getFieldValues();
	document.__webDialog = contextDlg;		
}	
        
// WebDialogManager prototype and constructor
function ig_CreateWebDialogManager(props)
{
    if(!ig_WebControl.prototype.isPrototypeOf(ig_WebDialogManager.prototype))
    {
        ig_WebDialogManager.prototype = new ig_WebControl();
        ig_WebDialogManager.prototype.constructor = ig_WebDialogManager;
        ig_WebDialogManager.prototype.base=ig_WebControl.prototype;
        
        ig_WebDialogManager.prototype.fireServerEvent = function(eventName, data) {__doPostBack(getUniqueID(), eventName + ":" + data);}
        ig_WebDialogManager.prototype.init = function(props)
        {
            this._isInitializing=true;
            this._initControlProps(props);
            this.base.init.apply(this,[this.getClientID()]);
            this._isInitializing=false;
        }
        
        
        ig_WebDialogManager.prototype.getContentUrl = function() {
           return this._props[2];
        }  
        ig_WebDialogManager.prototype.setContentUrl = function(value) {
           this._props[2] = value;
           this.updateControlState("ContentUrl", value);
        }  
        
        ig_WebDialogManager.prototype.getCaption = function() {
           return this._props[3];
        }  
        ig_WebDialogManager.prototype.setCaption = function(value) {
           this._props[3] = value;
           this.updateControlState("Caption", value);
        }  
        
        ig_WebDialogManager.prototype.getFormWidth = function() {
           return this._props[4];
        }  
        ig_WebDialogManager.prototype.setFormWidth = function(value) {
           this._props[4] = value;
           this.updateControlState("FormWidth", value);
        }  
        
        ig_WebDialogManager.prototype.getFormHeight = function() {
           return this._props[5];
        }  
        ig_WebDialogManager.prototype.setFormHeight = function(value) {
           this._props[5] = value;
           this.updateControlState("FormHeight", value);
        }  
        
        ig_WebDialogManager.prototype.getModality = function() {
           return this._props[6];
        }  
        ig_WebDialogManager.prototype.setModality = function(value) {
           this._props[6] = value;
           this.updateControlState("Modality", value);
        }  
        
        ig_WebDialogManager.prototype.onDialogLoading = function(evnt)
        {
        	this.fireEvent(this._clientEvents["DialogLoading"], evnt, null);
        }
        
        ig_WebDialogManager.prototype.onDialogLoaded = function(evnt)
        {
        	this.fireEvent(this._clientEvents["DialogLoaded"], evnt, null);
        }
        
        ig_WebDialogManager.prototype.onDialogValidating = function(evnt)
        {
        	this.fireEvent(this._clientEvents["DialogValidating"], evnt, null);
        }
        
        ig_WebDialogManager.prototype.onDialogValidated = function(evnt)
        {
        	this.fireEvent(this._clientEvents["DialogValidated"], evnt, null);
        }
        
        ig_WebDialogManager.prototype.onDialogClosing = function(evnt)
        {
        	this.fireEvent(this._clientEvents["DialogClosing"], evnt, null);
        }
        
        ig_WebDialogManager.prototype.onDialogClosed = function(evnt)
        {
        	this.fireEvent(this._clientEvents["DialogClosed"], evnt, null);
        }
        
    }
    
    return new ig_WebDialogManager(props);
}
        
function ig_WebDialogManager(props)
{
        if(arguments.length != 0)
            this.init(props);
}

// public: get object from ClientID or UniqueID
function ig_getWebDialogManagerById(id)
{
	return ig_getWebControlById(id);
}        

function igdlg_onCancel() {
	var dlgManager = document.igdlg_WebDialogManager;
	if(dlgManager == null)
		return;
	dlgManager.closeDialog();
}

function igdlg_onOk() {
	var dlgManager = document.igdlg_WebFormHost;
	if(dlgManager == null)
		return;
	if(igdlg_onApply())
		dlgManager.closeDialog();
}

function igdlg_onApply() {
	var dlgManager = document.igdlg_WebFormHost;
	if(dlgManager == null)
		return;
	return true;
}

/// Javascript Dictionary 
function ig_Dictionary() {
	this.getValue = function(strKeyName) {
		return(this[strKeyName]);
	}

	this.contains = function(strKeyName) {
		return(this[strKeyName]!=null);
	}

	this.addValue = function(key, value) {
		this[key] = value;
	}
	
	this.addValues = function () {
		if(arguments.length%2 != 0)
			throw "Invalid argument count";
		for (c=0; c < arguments.length; c+=2) {
			this[arguments[c]] = arguments[c+1];
		}
	}

	this.remove = function (strKeyName) {
		for (c=0; c < arguments.length; c++) {
			if(this.contains(arguments[c]))
				this[arguments[c]] = null;
		}
	}
}

/// Out of Band Callback object

var igcall_eReadyState=new Object();
igcall_eReadyState.Ready=0;
igcall_eReadyState.Loading=1;

var igcall_eError=new Object();
igcall_eError.Ok=0;
igcall_eError.LoadFailed=1;
		
var _currentCall;
function ig_CallBackBase()
{
	ig_CallBackBase.prototype.getID = function () {
		return this._id ;
	}
	ig_CallBackBase.prototype.setID = function (id) {
		this._id = id;
	}
	
	ig_CallBackBase.prototype.getServerID = function () {
		return this._serverID ;
	}
	ig_CallBackBase.prototype.setServerID = function (id) {
		this._serverID = id;
	}
	
	ig_CallBackBase.prototype.getQueryString = function () {
		return this._queryString ;
	}
	ig_CallBackBase.prototype.setQueryString = function (queryString) {
		this._queryString = queryString;
	}
	
	ig_CallBackBase.prototype.getCallbackFunction = function () {
		return this._callbackFunction ;
	}
	ig_CallBackBase.prototype.setCallbackFunction = function (callback) {
		this._callbackFunction = eval(callback);
	}
	
	ig_CallBackBase.prototype.getUrl = function () {
		return this._url ;
	}
	ig_CallBackBase.prototype.setUrl = function (url) {
		this._url = url;
	}

	ig_CallBackBase.prototype.execute = function (type, context) {
		if(this._readyState!=igcall_eReadyState.Ready)
			return;
		this._reqType=type;
		this._readyState=igcall_eReadyState.Loading;
		
		_currentCall = this;
		_currentCall._context = context;
		if(ig_csom.IsIE)
		{
			this.XmlHttp.open("GET", this._url, false);
			this.XmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			this.XmlHttp.onreadystatechange=this._internalCallback;
			this.XmlHttp.send("__EVENTTARGET="+this._serverID+"&__EVENTARGUMENT=XmlHttpRequest&"+this._serverID+"="+this._queryString);
		}
		else
		{
			this.XmlHttp.open("POST",this._url,false);
			this.XmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			this.XmlHttp.ig_currentControl=this._id;
			this.XmlHttp.addEventListener("load",this._internalCallback,false);
			this.XmlHttp.send("__EVENTTARGET="+this._serverID+"&__EVENTARGUMENT=XmlHttpRequest&"+this._serverID+"="+this._queryString);
		}
	}
	
	ig_CallBackBase.prototype._internalCallback = function () {
		if(_currentCall == null)
			return;
		if(_currentCall.XmlHttp.readyState==4) {
			if(_currentCall._callbackFunction == null)
				return;
			_currentCall._callbackFunction(_currentCall._context)
		}
		_currentCall._readyState = igcall_eReadyState.Ready;
	}
}
ig_CallBack.prototype = new ig_CallBackBase();

function ig_CallBack() {
	this._readyState = igcall_eReadyState.Ready;
	if(ig_csom.IsIE)
	{
		this._url=document.URLUnencoded;
		this.XmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
		this.XmlResp=new ActiveXObject("Microsoft.XMLDOM");
	}
	else
	{
		this._url=document.URL;
		this.XmlHttp=new XMLHttpRequest();
		this.XmlResp=new DOMParser();
		//this.XmlHttp.open("GET",this.AddnlProps[11],false);
		//this.XmlHttp.send(null);
	}
}
