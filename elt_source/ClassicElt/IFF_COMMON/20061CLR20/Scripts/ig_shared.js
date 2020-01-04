 /*
  * Infragistics WebUI.Shared CSOM Script: ig_shared.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

function ig_WebControl(id)
{
	if(arguments.length > 0){
		this.init(id);
	}
}
ig_WebControl.prototype.init=function(id){
	this._id=id;
	ig_all[id]=this;
	this._posted = this._postRequest = 0;
		// clientViewState
	this.postField = ig_csom.getElementById(this.getClientID() + "_Data");	
	this.clientState = ig_ClientState.createRootNode();	
	this.rootNode = ig_ClientState.addNode(this.clientState, "XMLRootNode");
}

ig_WebControl.prototype.constructor=ig_WebControl;
ig_WebControl.prototype.getElement=function(){return this._element;}
ig_WebControl.prototype.getID=function(){return this._id;}
ig_WebControl.prototype.getUniqueID=function(){return this._uniqueID;}
ig_WebControl.prototype.getClientID=function(){return this._clientID;}


ig_WebControl.prototype.updateControlState = function(propName, propValue) {
	if(this.controlState == null)
		this.controlState = ig_ClientState.addNode(this.rootNode, "ControlState");
		
	ig_ClientState.setPropertyValue(this.controlState, propName, propValue);
	if(this.postField != null)
		this.postField.value = ig_ClientState.getText(this.clientState);	
}

ig_WebControl.prototype.addStateItem  = function(name, value) {
	if(this.stateItems == null)
		this.stateItems = ig_ClientState.addNode(this.rootNode, "StateItems");
	var stateItem = ig_ClientState.addNode(this.stateItems, "StateItem");
	this.updateStateItem(stateItem, name, value);
	return stateItem;
}

ig_WebControl.prototype.updateStateItem = function(stateItem, propName, propValue) {
	ig_ClientState.setPropertyValue(stateItem, propName, propValue);
	if(this.postField != null)
		this.postField.value = ig_ClientState.getText(this.clientState);	
}

ig_WebControl.prototype.fireServerEvent = function(eventName, data)
{
	if(ig_shared._isPosted)
		return;
	if(this._postRequest == -1)
	{
		this._postRequest = 0;
		return;
	}
	this._postRequest = 0;
	try
	{
		ig_shared._isPosted = true;
		__doPostBack(this._uniqueID, eventName + ":" + data);
	}
	catch(e){}
}

ig_WebControl.prototype.removeEventListener = function(name, handler)
{
	var i, evts = this._clientEvents ? this._clientEvents[name] : null;
	if(evts != null) for(i = 0; i < evts.length; i++)
		if(evts[i] != null && evts[i]._handler == handler)
	{
		delete evts[i];
		evts[i] = null;
		return;
	}
}

ig_WebControl.prototype.addEventListener = function(name, handler, obj, post)
{
	if(typeof handler != "function")
		return;
	if(!this._clientEvents) this._clientEvents = new Object();
	var i, evts = this._clientEvents[name];
	if(evts == null)
		evts = this._clientEvents[name] = new Array();
	var i0 = evts.length;
	for(i = 0; i < evts.length; i++)
	{
		if(evts[i] == null)
			i0 = i;
		else if(evts[i]._handler == handler)
			return;
	}
	var evt = new ig_EventObject();
	evt._object = obj;
	evts[i0] = {_webcontrol:this, _eventName:name, _handler:handler, _autoPostBack:(post==true), _event:evt};
}

ig_WebControl.prototype.fireEvent = function(name, evnt)
{
	if(!name || this._isInitializing || !this._clientEvents)
		return false;
	this._postRequest = 0;
	var evt, evts = this._clientEvents[name];
	var cancel = false, post = 0, i = (evts == null) ? 0 : evts.length;
	if(i == 0)
		return false;
	if(evnt == "check")
		return true;
	var args = this.fireEvent.arguments;
	while(i-- > 0)
	{
		if(evts[i] == null)
			continue;
		evt = evts[i]._event;
		evt.reset();
		evt.event=evnt;
		evt.needPostBack=evts[i]._autoPostBack;
		try
		{
			evts[i]._handler(this, evt, args[2], args[3], args[4], args[5], args[6]);
		}catch(ex){continue;}
		if(evt.cancelPostBack)
			post = -1;
		else if(post == 0 && evt.needPostBack)
			post = 1;
		if(evt.cancel)
			cancel = true;
		evt.event = null;
	}
	if(!cancel || post < 0)
		this._postRequest = post;
	return cancel;
}
ig_WebControl.prototype._decodeProps	= function(props)
{
	for(var i = 0; i < props.length; i++)
	{
		if(props[i] != null)
		{
			if(props[i].push != null)
				this._decodeProps(props[i]);
			if(typeof props[i]=="string")
			{
					
					props[i] = decodeURI(props[i]);
					props[i] = unescape(props[i]).replace(/\+/g," ");
					props[i] = unescape(props[i]);
			}
		}
	}
}
ig_WebControl.prototype._initControlProps	= function(props)
{	
	this._decodeProps(props);
	this._props = props[0];
	this._uniqueID	= this._props[0];
	this._clientID = this._props[1];
	var i = props[1] ? props[1].length : 0;
	while(i-- > 0) try
	{
		this.addEventListener(props[1][i][0], eval(props[1][i][1]), null, props[1][i][2]);
	}catch(e)
	{window.status = "Can't find " + props[1][i][1];}
	this._objects = props[2];
	this._collections = props[3];
}	

//ig_initShared implements browser independent functionality
function ig_initShared()
{
	// Public Properties
	this.ScriptVersion="5.3.20053.14";
	try{this.AgentName=navigator.userAgent.toLowerCase();}catch(e){this.AgentName="";}
	this.MajorVersionNumber =parseInt(navigator.appVersion);
	//this.AgentName=navigator.userAgent.toLowerCase();
	//this.MajorVersionNumber=parseInt(navigator.appVersion);
	this.IsDom=typeof document.getElementById=="function";
	this.IsNetscape62=this.AgentName.indexOf("netscape6")>=0;
	var i=this.AgentName.indexOf("netscape/7.");
	this.Netscape7=(i>0)?this.AgentName.charCodeAt(i+11)-48:-1;
	this.IsNetscape=document.layers!=null;
	this.IsNetscape6=(this.IsDom&&navigator.appName=="Netscape");
	this.IsSafari=this.AgentName.indexOf("safari")>=0;
	this.IsFireFox=this.AgentName.indexOf("firefox")>=0;
	this.IsOpera=this.AgentName.indexOf("opera")>=0;
	this.IsMac=this.AgentName.indexOf("mac")>=0;
	this.IsIE=document.all!=null&&!this.IsOpera&&!this.IsSafari;
	this.IsIE4=this.IsIE&&!this.IsDom;
	this.IsIE4Plus=this.IsIE&&this.MajorVersionNumber>=4;
	this.IsIE5=this.IsIE&&this.IsDom;
	this.IsIE50=this.IsIE5&&this.AgentName.indexOf("msie 5.0")>0;
	this.IsWin=this.AgentName.indexOf("win")>=0;
	this.IsIEWin=this.IsIE&&this.IsWin;
	this.IsIE55=this.IsIEWin&&this.AgentName.indexOf("msie 5.5")>0;
	this.IsIE6=this.IsIEWin&&this.AgentName.indexOf("msie 6.0")>0;
	this.IsIE55Plus=this.IsIE55||this.IsIE6;
	this.attrID = "ig_mark";
	this._isPosted = false;
	this.isFormPosted = function(){return this._isPosted;}
	// Obtains an element object based on its Id
	this.getElementById = function (tagName)
	{
		if(this.IsIE)
			return document.all[tagName];
		else
			return document.getElementById(tagName);
	}

	this.isArray = function(a) {
		return a!=null && a.length!=null;
	}
	
	this.isEmpty = function(o) {
		return !(this.isArray(o) && o.length>0);
	}
	
	this.notEmpty = function(o) {
		return (this.isArray(o) && o.length>0);
	}

	// Adds an event listener to an html element.
	this.addEventListener=function(elem,evtName,fn,flag)
	{ 
		try{if(elem.attachEvent){elem.attachEvent("on"+evtName,fn); return;}}catch(ex){}
		try{if(elem.addEventListener){elem.addEventListener(evtName,fn,flag); return;}}catch(ex){}
		eval("var old=elem.on"+evtName);
		var sF=fn.toString();
		var i=sF.indexOf("(")+1;
		try
		{
		if((typeof old =="function") && i>10)
		{
			old=old.toString();
			
			var args=old.substring(old.indexOf("(")+1,old.indexOf(")"));
			while(args.indexOf(" ")>0) args=args.replace(" ","");
			if(args.length>0) args=args.split(",");
			
			old=old.substring(old.indexOf("{")+1,old.lastIndexOf("}"));
			
			sF=sF.substring(9,i);
			if(old.indexOf(sF)>=0)return;
			var s="fn=new Function(";
			for(i=0;i<args.length;i++)
			{
				if(i>0)sF+=",";
				s+="\""+args[i]+"\",";
				sF+=args[i];
			}
			sF+=");"+old;
			eval(s+"sF)");
		}
		eval("elem.on"+evtName+"=fn");
		}catch(ex){}
	}
	
	// Obtains the proper source element in relation to an event
	this.getSourceElement = function (evnt, o)
	{
		if(evnt.target) // This does not appear to be working for Netscape
			return evnt.target;
		else 
		if(evnt.srcElement)
			return evnt.srcElement;
		else
			return o;
	}
	
	this.getText = function (e){
		if(e==null)return "";
		var i,v=null,ii=(e.childNodes==null)?0:e.childNodes.length;
		for(i=-1;i<ii;i++)
		{
			var ei=(i<0)?e:e.childNodes[i];
			if(ei.nodeName=="#text")v=(v==null)?ei.nodeValue:v+" "+ei.nodeValue;
		}
		if(v!=null)return v;
		if((v=e.text)!=null)return v;
		try{return e.innerText;}catch(ex){}
		try{return e.innerHTML;}catch(ex){}
		return "";
	}
	
	this.setText = function (e, text)
	{
		if(e==null)return false;
		if(text==null)text="";
		var i,ii=(e.childNodes==null)?0:e.childNodes.length;
		for(i=-1;i<ii;i++)
		{
			var ei=(i<0)?e:e.childNodes[i];
			if(ei.nodeName=="#text")
			{
				if(text!=null){ei.nodeValue=text; text=null;}
				else ei.nodeValue="";
			}
		}
		if(text!=null)try
		{
			if(e.text!=null)e.text=text;
			else if(e.innerText!=null)e.innerText=text;
			else e.innerHTML=text;
			text=null;
		}catch(ex){}
		return text==null;
	}
	this.setEnabled = function (e, bEnabled)
	{
		if(this.IsIE)
			e.disabled = !bEnabled;
	}
	this.getEnabled = function (e){
		if(this.IsIE)
			return !e.disabled;
	}

	this.navigateUrl =	function (targetUrl, targetFrame)
	{
		if(targetUrl == null || targetUrl.length == 0)
			return;
		var newUrl=targetUrl.toLowerCase();
		if(newUrl.indexOf("javascript:") == 0)
			eval(targetUrl);
		else 
		if(targetFrame != null && targetFrame!="")	{
			if(ig_shared.getElementById(targetFrame) != null) 
				ig_shared.getElementById(targetFrame).src = targetUrl;
			else {
				var oFrame = ig_searchFrames(top, targetFrame);
				if(oFrame != null)
					oFrame.location=targetUrl;
				else 
				if(targetFrame == "_self" 
					|| targetFrame == "_parent"
					|| targetFrame == "_media"
					|| targetFrame == "_top"
					|| targetFrame == "_blank"
					|| targetFrame == "_search")
					window.open(targetUrl, targetFrame);
				else
					window.open(targetUrl);
			}
		}
		else {
			try {
				location.href = targetUrl;
			}
			catch (x) {
			}
		}
	}
	
	function ig_searchFrames(frame, targetFrame) {
		if(frame.frames[targetFrame] != null)
			return frame.frames[targetFrame];
		var i;
		for(i=0; i<frame.frames.length; i++) {
			var subFrame = ig_searchFrames(frame.frames[i], targetFrame);
			if(subFrame != null)
				return subFrame; 
		}
		return null;
	}
	
	this.findControl=function(startElement,idList,closestMatch){
		var item;
		var searchString="";
		var i=0;
		var partialId=idList.split(":");
		while(partialId[i+1]!=null&&partialId[i+1].length>0){
			searchString+=partialId[i]+".*";
			i++;
		}
		searchString+=partialId[i]+"$";
		var searchExp=new RegExp(searchString);
		var curElement;
		if(startElement != null)
			curElement=startElement.firstChild;
		else
			curElement = window.document.firstChild;
		while(curElement!=null){
			if(curElement.id!=null&&(curElement.id.search(searchExp))!=-1){
				ig_dispose(searchExp);
				return curElement;
			}
			item=this.findControl(curElement,idList);
			if(item!=null){
				ig_dispose(searchExp);
				return item;
			}
			curElement=curElement.nextSibling;		
		}
		ig_dispose(searchExp);
		if(closestMatch)
			return findClosestMatch(startElement,partialId);
		else return null;
	}
	this.createTransparentPanel=function (){
		if(!this.IsIE)return null;
		var transLayer=document.createElement("IFRAME");
		transLayer.style.zIndex=1000;
		transLayer.frameBorder="no";
		transLayer.scrolling="no";
		transLayer.style.filter="progid:DXImageTransform.Microsoft.Alpha(Opacity=0);";
		transLayer.style.visibility='hidden';
		transLayer.style.display='none';
		transLayer.style.position="absolute";
		transLayer.src='javascript:new String("<html></html>")';
		var e = document.body.firstChild;
		document.body.insertBefore(transLayer, e);
		return new ig_TransparentPanel(transLayer);
	}
	
	
	
	
	
	this.isInside=function(evt,container,elem,shift)
	{
		var to=evt.toElement;
		if(to==null)to=evt.relatedTarget;
		if(to!=null && shift!=-1)
		{
			while(to!=null)
			{
				if(to==container)return true;
				to=to.parentNode;
			}
			return false;
		}
		if(elem==null)elem=container; if(shift==null)shift=0;
		var z,x=-evt.clientX,y=-evt.clientY;
		var w=elem.offsetWidth,h=elem.offsetHeight;
		while(elem!=null)
		{
			if((z=elem.offsetLeft)!=null){x+=z; y+=elem.offsetTop;}
			elem=elem.offsetParent;
		}
		return x<-1 && y<-1 && 1<x+w && 2+shift<y+h;
	}
	this.createHoverBehavior= function(objectToCallBackWith,element,mouseOverHandler,mouseOutHandler){
		element.__callBackObject=objectToCallBackWith;
		element.__isEventReady=true;
		objectToCallBackWith.__onFilteredMouseOver=mouseOverHandler;
		objectToCallBackWith.__onFilteredMouseOut=mouseOutHandler;
		this.addEventListener(element,"mouseover",ig_filterMouseOverEvents,false);
		this.addEventListener(element,"mouseout",ig_filterMouseOutEvents,false);
	}
	this.onUnload=function(){
		ig_dispose(ig_all);
	}
	this.addEventListener(window,"unload",this.onUnload,false);
}
function ig_delete(o){ig_dispose(o);}

function ig_filterMouseOverEvents(evt){
	var element=ig_shared.getSourceElement(evt);
	if(!element.__isEventReady){
		while(element!=null && !element.__isEventReady && element.tagName!="BODY")element=element.parentNode;
	}
	if(element.__isEventReady && (element._hasMouse||!ig_isMouseOverSourceAChild(evt,element))) 
	{
		element._hasMouse=true;
		element.__callBackObject.__onFilteredMouseOver(evt);
	}	
}
function ig_filterMouseOutEvents(evt){
	var element=ig_shared.getSourceElement(evt);
	if(!element.__isEventReady){
		while(element!=null && !element.__isEventReady && element.tagName!="BODY")element=element.parentNode;
	}
	if(element&&element.__isEventReady&&!ig_isMouseOutSourceAChild(evt,element)) 
	{
		element._hasMouse=false;
		element.__callBackObject.__onFilteredMouseOut(evt);
	}	
}

function ig_isMouseOverSourceAChild(evt,element){
	var evnt=evt?evt:window.event;
	if(evnt==null)return false;
	var from=evnt.fromElement&&typeof evnt.fromElement!="undefined"?evnt.fromElement:evnt.relatedTarget;
	if(from==element)return true;
	if(from==null)return false;
	return ig_isAChildOfB(from,element);
}
function ig_isMouseOutSourceAChild(evt,element){
	var evnt=window.event?window.event:evt;
	if(!evnt)return false;
	var to=evnt.toElement&&typeof evnt.toElement!="undefined"?evnt.toElement:evnt.relatedTarget;
	if(to==element)return true;
	if(to==null)return false;
	return ig_isAChildOfB(to,element);	
}
function ig_isAChildOfB(a,b){
	if(a==null||b==null)return false;
	while(a!=null){
		a=a.parentNode;
		if(a==b)return true;
	}
	return false;
}
function ig_getWebControlById(id)
{
	var i,o=null;
	if(!ig_shared.isEmpty(id))if((o=ig_all[id])==null)for(i in ig_all)
	{
		if((o=ig_all[i])!=null)if(o._id==id || o._clientID==id || o._uniqueID==id)
			return o;
		o=null;
	}
	return o;
}
if(typeof ig_all !="object")
	var ig_all=new Object();
// cancel response of browser on event
function ig_cancelEvent(e)
{
	if(e == null) if((e = window.event) == null) return;
	if(e.stopPropagation != null) e.stopPropagation();
	if(e.preventDefault != null) e.preventDefault();
	e.cancelBubble = true;
	e.returnValue = false;
}
function ig_TransparentPanel(transLayer){
	this.Element=transLayer;
	this.show=function(){
		this.Element.style.visibility="visible";
		this.Element.style.display="";
	}
	this.hide=function(){
		this.Element.style.visibility="hidden";
		this.Element.style.display="none";
	}
	this.setPosition=function(top,left,width,height){
		this.Element.style.top=top;
		this.Element.style.left=left;
		this.Element.style.width=width;
		this.Element.style.height=height;
	}
}
if(typeof ig_shared !="object")
	var ig_shared=new ig_initShared();
var ig_csom=ig_shared,ig=ig_shared;

//Emulate 'apply' if it doesn't exist.
if ((typeof Function != 'undefined')&&
    (typeof Function.prototype != 'undefined')&&
    (typeof Function.apply != 'function')) {
    Function.prototype.apply = function(obj, args){
        var result, fn = 'ig_apply'
        while(typeof obj[fn] != 'undefined') fn += fn;
        obj[fn] = this;
        var length=(((ig_shared.isArray(args))&&(typeof args == 'object'))?args.length:0);
		switch(length){
		case 0:
			result = obj[fn]();
			break;
		default:
			for(var item=0, params=''; item<args.length;item++){
			if(item!=0) params += ',';
			params += 'args[' + item +']';
			}
			result = eval('obj.'+fn+'('+params+');');
			break;
		}
        ig_dispose(obj[fn]);
        return result;
    };
}

function findClosestMatch(startElement,partialId){
	var item;
	var searchString="";
	var i=0;
	while(partialId[i+1]!=null&&partialId[i+1].length>0){
		searchString+="("+partialId[i]+")?";
		i++;
	}
	searchString+=partialId[i]+"$";
	var searchExp=new RegExp(searchString);
	var curElement=startElement.firstChild;
	while(curElement!=null){
		if(curElement.id!=null&&(curElement.id.search(searchExp))!=-1){
			return curElement;
		}
		item=findClosestMatch(curElement,partialId);
		if(item!=null)return item;
		curElement=curElement.nextSibling;		
	}
	return null;
}

function ig_EventObject(){
	this.event=null;
	this.cancel=false;
	this.cancelPostBack=false;
	this.needPostBack=false;
	this.reset=function()
	{
		this.event=null;
		this.needPostBack=false;
		this.cancel=false;
		this.cancelPostBack=false;
	}
}

function ig_fireEvent(oControl,eventName)
{
	if(!eventName||oControl==null) return false;

	var sEventArgs = eventName + "(oControl";
	
	for (i = 2; i < ig_fireEvent.arguments.length; i++)
		sEventArgs += ", ig_fireEvent.arguments[" + i + "]";
	sEventArgs += ");";
	try{eval(sEventArgs);}
	catch(ex){window.status = "Can't eval " + sEventArgs; return false;}
	return true;

}

function ig_dispose(obj)
{
	if(ig_shared.IsIE&&ig_shared.IsWin)	
		for(var item in obj)
		{
			if(typeof(obj[item])!="undefined" && obj[item]!=null && !obj[item].tagName && !obj[item].disposing && typeof(obj[item])!="string")
			{
				try {
					obj[item].disposing=true;
					ig_dispose(obj[item]);
				} catch(e1) {;}
			}
			try{delete obj[item];}catch(e2){;}
		}
}

function ig_initClientState(){
	this.XmlDoc=document;
	this.createRootNode=function(){
		if(!ig_shared.IsIE){
			var str ='<?xml version="1.0"?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> <html xmlns="http://www.w3.org/1999/xhtml"><ClientState id="vs"></ClientState></html>';
			var p = new DOMParser();
			var doc = p.parseFromString(str,"text/xml");
			this.XmlDoc=doc;
			return doc.getElementById("vs");
		}
		if(ig_shared.IsIE50)this.XmlDoc=new ActiveXObject("Microsoft.XMLDOM");
		return this.createNode("ClientState");
	}
	this.setPropertyValue=function(element,name,value){
		if(element!=null)element.setAttribute(name,escape(value));
	}
	this.getPropertyValue=function(element,name){
		if(element==null)return "";
		return unescape(element.getAttribute(name));
	}
	this.addNode=function(element,nodeName){
		var newNode=this.createNode(nodeName);
		if(element!=null)element.appendChild(newNode);
		return newNode;
	}
	this.removeNode=function(element,nodeName){
		var nodeToRemove=this.findNode(element,nodeName);
		if(element!=null)
			return element.removeChild(nodeToRemove);
		return null;
	}
	this.createNode=function(nodeName){
		return this.XmlDoc.createElement(nodeName);
	}
	this.findNode=function(element,node){
		if(element==null)return null;
		var curElement=element.firstChild;
		while(curElement!=null){
			if(curElement.nodeName==node || curElement==node){
				return curElement;
			}
			var item=this.findNode(curElement,node);
			if(item!=null)return item;
			curElement=curElement.nextSibling;		
		}
		return null;
	}
	this.getText=function(element){
		if(element==null)return "";
		if(ig_shared.IsIE55Plus)return escape(element.innerHTML);
		return escape(this.XmlToString(element));
	}
	this.XmlToString=function(startElem){
		var str="";
		if(!startElem)return "";
		var curElement=startElem.firstChild;
		while(curElement!=null){
			str+="<"+curElement.tagName+" ";

			for(var i=0; i<curElement.attributes.length;i++)
			{
				var attrib=curElement.attributes[i];
				str+=attrib.nodeName+"=\""+attrib.nodeValue+"\" ";
			}

			str+=">";
			str+=this.XmlToString(curElement);
			str+="</"+curElement.tagName+">";
			curElement=curElement.nextSibling;		
		}
		return str;
	}
}
//
function ig_xmlNode(name)
{
	this.lastChild = null;
	this.name = name;	
	this.getText = function(){return escape(this.toString());}
	this.childNodes = new Array();
	this.toString = function()
	{
		var i, s = (this.name == null) ? "" : "<" + this.name;
		if(this.props != null) for(i = 0; i < this.props.length; i++)
			s += " " + this.props[i].name + "=\"" + this.props[i].value + "\"";
		if(this.name != null) s += ">";
		for(i = 0; i < this.childNodes.length; i++)
			s += this.childNodes[i].toString();
		if(this.name != null) s += "</" + this.name + ">";
		return s;
	}
	this.addNode = function(node, unique)
	{
		if(node == null) return null;
		if(unique == true) if((unique = this.findNode(node)) != null) return unique;		
		if(node.name == null) node = new ig_xmlNode(node);
		node.parentNode = this;
		this.lastChild = node;
		return this.childNodes[this.childNodes.length] = node;
	}
	this.appendChild = this.addNode;
	this.setAttribute = function(name, value)
	{
		if(name == null) return;
		if(this.props == null) this.props = new Array();
		var prop, i = this.props.length;
		value = (value == null) ? "" : value;
		while(i-- > 0)
		{
			prop = this.props[i];
			if(prop.name == name){prop.value = value; return;}
		}
		prop = new Object();
		prop.name = name;
		prop.value = value;
		this.props[this.props.length] = prop;
	}
	this.setPropertyValue = function(name, value){this.setAttribute(name, (value == null) ? value : escape(value));}
	this.findNode = function(node, descendants)
	{
		if(node != null) for(var i = 0; i < this.childNodes.length; i++)
		{
			var n = this.childNodes[i];
			if(n != null)
			{
				if(n.name == node || n == node)
				{
					n.index = i;
					return n;
				}
				if(descendants == true && (n = n.findNode(node)) != null) return n;
			}
		}
		return null;
	}
	this.removeNode=function(n)
	{
		if((n=this.findNode(n))==null)return n;
		var i=-1,j=0,a=new Array(),a0=n.parentNode.childNodes;
		while(++i<a0.length)if(i!=n.index)a[j++]=a0[i];
		n.parentNode.childNodes=a;
		this.lastChild = a.length <= 0 ? null : a[a.length-1] ;
		return n;
	}
	this.getPropertyValue = function(name)
	{
		var i = (this.props == null) ? 0 : this.props.length;
		while(i-- > 0)
			if(this.props[i].name == name)
				return unescape(this.props[i].value);
		return null;
	}
}
function ig_xmlNodeStatic()
{
	this.createRootNode = function(){return new ig_xmlNode("Temp");}
	this.addNode = function(e, n){return (e == null) ? (new ig_xmlNode(n)) : e.addNode(n);}
	this.removeNode = function(e, n){return (e == null) ? e : e.removeNode(n);}
	this.findNode = function(e, n){return (e == null) ? e : e.findNode(n);}
	this.setPropertyValue = function(e, n, v){if(e != null)e.setPropertyValue(n, v);}
	this.getPropertyValue = function(e, n){return (e == null) ? "" : e.getPropertyValue(n);}
	this.getText = function(e)
	{
		var s = "", i = (e == null) ? 0 : e.childNodes.length;
		for(var j = 0; j < i; j++) s += e.childNodes[j].getText();
		return s;
	}
}

try{ig_shared.addEventListener(window, "load", ig_handleEvent);}catch(ex){}
try{ig_shared.addEventListener(window, "unload", ig_handleEvent);}catch(ex){}
try{ig_shared.addEventListener(window, "resize", ig_handleEvent);}catch(ex){}
function ig_findElemWithAttr(elem, attr)
{
	while(elem != null)
	{
		try
		{
			if(elem.getAttribute != null && !ig_shared.isEmpty(elem.getAttribute(attr)))
				return elem;
		}catch(ex){}
		elem = elem.parentNode;
	}
	return null;
}
function ig_handleEvent(evt)
{
	if(evt == null) if((evt = window.event) == null) return;
	var obj, attr = ig_shared.attrID, src = evt.srcElement, type = evt.type;
	if(ig_shared.isEmpty(type)) return;
	var fn = "obj._on" + type.substring(0, 1).toUpperCase() + type.substring(1);
	if(src == null)
		src = evt.target;
	if(type == "load" || type == "unload" || type == "resize" || !src)
	{
		for(obj in ig_all)
		{
			if((obj = ig_all[obj]) == null)
				continue;
			eval("if(" + fn + "!=null){" + fn + "(src,evt); obj=null;}");
			if(obj != null && obj._onHandleEvent != null)
            obj._onHandleEvent(src, evt);
		}
		if(type == "unload")
			ig_dispose(ig_all);
		return;
	}
	var elem = ig_findElemWithAttr(src, attr);
	if(elem == null)
		elem = ig_findElemWithAttr(this, attr);
	if(elem != null && (obj = ig_getWebControlById(elem.getAttribute(attr))) != null)
	{
		eval("if(" + fn + "!=null){" + fn + "(src,evt); obj=null;}");
		if(obj != null && obj._onHandleEvent != null)
			obj._onHandleEvent(src, evt);
	}
}
function ig_handleTimer(obj)
{
	var i, all = ig_shared._timers, fn = ig_shared._timerFn;
	if(obj)
	{
		if(!obj._onTimer) return;
		if(!all) ig_shared._timers = all = new Array();
		i = all.length;
		while(i-- > 0) if(all[i] == obj) break;
		if(i < 0) all[all.length] = obj;
		if(!fn) ig_shared._timerFn = fn = window.setInterval(ig_handleTimer, 200);
		return;
	}
	if(!fn) return;
	for(i = 0; i < all.length; i++) if(all[i] && all[i]._onTimer) if(!all[i]._onTimer())
		obj = true;
	if(obj) return;
	window.clearInterval(fn);
	delete ig_shared._timerFn;
}

var ig_ClientState=null;
if(!ig_shared.IsIE55Plus||!ig_shared.IsWin) ig_ClientState = new ig_xmlNodeStatic();
else ig_ClientState=new ig_initClientState();
