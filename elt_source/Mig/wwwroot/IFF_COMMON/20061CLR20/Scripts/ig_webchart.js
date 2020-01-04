 /*
  * Infragistics WebChart CSOM Script: ig_webchart.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */


// Global array to relate Elements with Objects.
var ID2OBJECT = new Array();

// IGBrowser class implements the basic browser independent functionality
function IGBrowser() 
{
	// Public Properties
	this.ScriptVersion		="6.1.20061.28"; 
	this.AgentName			=navigator.userAgent.toLowerCase();
	this.IsFirefox          =this.AgentName.indexOf("firefox") != -1
	this.MajorVersionNumber =parseInt(navigator.appVersion);
	this.IsDom				=(document.getElementById)?true:false;
	this.IsSafari			=this.AgentName.indexOf("safari")!=-1;
	this.IsNetscape			=(document.layers?true:false);
	this.IsNetscape4Plus	=(this.IsNetscape && this.MajorVersionNumber >=4)?true:false;
	this.IsNetscape6		=!this.IsSafari&&(this.IsDom&&navigator.appName=="Netscape");
	this.IsOpera			=this.AgentName.indexOf('opera')!=-1;
	this.IsMac				=(this.AgentName.indexOf("mac")!=-1);
	this.IsIE				=(document.all?true:false);
	this.IsIE4				=(document.all&&!this.IsDom)?true:false;
	this.IsIE4Plus			=(this.IsIE && this.MajorVersionNumber >= 4)?true:false;
	this.IsIE5				=(document.all&&this.IsDom)?true:false;
	this.IsWin				=((this.AgentName.indexOf("win")!=-1) || (this.AgentName.indexOf("16bit")!=-1));
	this.ID					="IGB";

	//Emulate 'apply' if it doesn't exist.
	if ((typeof Function != 'undefined')&&(typeof Function.prototype != 'undefined')&&(typeof Function.apply != 'function'))
	{
	    Function.prototype.apply = function(obj, args)
	    {
			var result, fn = 'ig_apply';
			while(typeof obj[fn] != 'undefined') fn += fn;
			obj[fn] = this;
			var length=(((ig_csom.isArray(args))&&(typeof args == 'object'))?args.length:0);
			switch(length)
			{
				case 0:
					result = obj[fn]();
					break;
				default:
					for(var item=0, params=''; item<args.length;item++)
					{
						if(item!=0) params += ',';
						params += 'args[' + item +']';
					}
					result = eval('obj.'+fn+'('+params+');');
					break;
			}
			this.Dispose(obj[fn]);
			return result;
		}
	}
	this.Dispose = function(obj)
	{
		if (this.IsIE && this.IsWin)	
			for(var item in obj)
			{
				if(typeof(obj[item])!="undefined" && obj[item]!=null && !obj[item].tagName && !obj[item].disposing && typeof(obj[item])!="string")
				{
					try 
					{
						obj[item].disposing=true;
						ig_dispose(obj[item]);
					} 
					catch(e1) {;}
			}
			try{delete obj[item];}catch(e2){;}
		}
	}

	this.GetObject = function(id, doc) 
	{
		var i,x;  
		if (!doc) doc=document; 
		if (!(x=doc[id])&&doc.all) x=doc.all[id]; 
		if (!x && document.getElementById) x=document.getElementById(id); 
		return x;
	}

	this.GetHeight = function(obj) 
	{ 
		var h=0; 
		if (this.IsNetscape) 
		{ 
			h=(obj.height)? obj.height:obj.clip.height; 
			return h; 
		} 
		h=(this.IsOpera)? obj.style.pixelHeight:obj.offsetHeight; 
		return h; 
	}

	this.SetHeight = function(obj,h) 
	{ 
		if (this.IsFirefox && document.documentElement) h += "px";
		if (this.IsNetscape) 
		{
			if (obj.clip) obj.clip.bottom=h; 
		} else if (this.IsOpera) obj.style.pixelHeight=h;
		else obj.style.height=h; 
	}

	this.GetWidth = function(obj) 
	{ 
		var w=0; 
		if (this.IsNetscape) 
		{ 
			w=(obj.width)? obj.width:obj.clip.width; 
			return w; 
		} 
		w=(this.IsOpera)? obj.style.pixelWidth:obj.offsetWidth; 
		return w; 
	}

	this.SetWidth = function(obj,w) 
	{ 
		if (this.IsFirefox && document.documentElement) w += "px";
		if (this.IsNetscape) 
		{
			if (obj.clip) obj.clip.right=w;
		}else if (this.IsOpera)obj.style.pixelWidth=w;
		else obj.style.width=w; 
	}

	this.GetX = function(obj) 
	{ 
		var x=(this.IsNetscape)? obj.left:(this.IsOpera)? obj.style.pixelLeft:obj.offsetLeft; 
		return x;
	}

	this.SetX = function(obj, x) 
	{ 
		if (this.IsFirefox && document.documentElement) x += "px";
		(this.IsNetscape)? obj.left=x:(this.IsOpera)? obj.style.pixelLeft=x:obj.style.left=x; 
	}

	this.GetY = function(obj) 
	{  
		var y=(this.IsNetscape)? obj.top:(this.IsOpera)? obj.style.pixelTop:obj.offsetTop; 
		return y;
	}

	this.SetY = function(obj, y) 
	{ 
		if (this.IsFirefox && document.documentElement) y += "px";
		(this.IsIE||this.IsDom)? obj.style.top=y:(this.IsNetscape)? obj.top=y:obj.style.pixelTop=y; 
	}

	this.GetPageX = function(obj) 
	{ 

		if (this.IsNetscape) 
		{ 
			var x=(obj.pageX)? obj.pageX:obj.x; return x; 
		} else if (this.IsOpera) 
		{  
			var x=0; 
			while(eval(obj)) 
			{ 
				x+=obj.style.pixelLeft; 
				obj=obj.offsetParent; 
			} 
			return x; 
		} 
		else 
		{ 
			var x=0; 
			var relativePos = -1;
			while(eval(obj)) 
			{ 
				if (this.IsNetscape6)
				{
					if (obj.style.position=="relative")
					{
						relativePos = x;
					}
					else if (obj.style.position=="absolute")
					{
						relativePos = -1;
					}
				}
				x+=obj.offsetLeft; 
				obj=obj.offsetParent; 
			} 
			if (this.IsNetscape6&&relativePos!=-1)
			{
				return relativePos;
			}
			return x; 
		} 
	}

	this.GetPageY = function(obj) 
	{ 
		if (this.IsNetscape) 
		{ 
			var y=(obj.pageY)? obj.pageY:obj.y; 
			return y; 
		} 
		else if (this.IsOpera) 
		{  
			var y=0; 
			while(eval(obj)) 
			{ 
				y+=obj.style.pixelTop; 
				obj=obj.offsetParent; 
				
			} 
			return y; 
		}
		else 
		{ 
			var y=0; 
			while(eval(obj)) 
			{ 
				if (this.IsNetscape6)
				{
					if (obj.style.position=="relative")
					{
						relativePos = y;
					}
					else if (obj.style.position=="absolute")
					{
						relativePos = -1;
					}
				}
				y+=obj.offsetTop; 
				obj=obj.offsetParent; 
			} 
			if (this.IsNetscape6&&relativePos!=-1)
			{
				return relativePos;
			}
			return y; 
		} 
	}

	this.SetPos = function(obj,x,y) 
	{ 
		this.SetX(obj,parseInt(x));
		this.SetY(obj,parseInt(y)); 
	}
	
	this.SetPosRelative = function(obj,x,y) 
	{ 
		this.SetX(obj,parseInt(this.GetPageX(obj))+parseInt(x));
		this.SetY(obj,parseInt(this.GetPageY(obj))+parseInt(y)); 
	}

	this.SetZValue = function(obj,z) 
	{ 
		if (this.IsNetscape)obj.zIndex=z;
		else obj.style.zIndex=z; 
	}
	

	this.ShowObject = function(obj,disp) 
	{ 
		(this.IsNetscape)? '':(!disp)? obj.style.display="inline":obj.style.display=disp;
		(this.IsNetscape)? obj.visibility='show':obj.style.visibility='visible';  
	}

	this.HideObject = function(obj,disp) 
	{ 
		(this.IsNetscape)? '':(arguments.length!=2)? obj.style.display="none":obj.style.display=disp;
		(this.IsNetscape)? obj.visibility='hide':obj.style.visibility='hidden';  
	}

	this.SetStyle = function(obj,s,v) 
	{ 
		if (this.IsIE5||this.IsDom) eval("obj.style."+s+" = '" + v +"'"); 
	}

	this.GetStyle = function(obj,s) 
	{ 
		if (this.IsIE5||this.IsDom) return eval("obj.style."+s); 
	}

	this.AddEventListener = function (o,e,f,c)
	{ 
		if(o.addEventListener)o.addEventListener(e,f,c);
		else if(o.attachEvent)o.attachEvent("on"+e,f);else eval("o.on"+e+"="+f)
	}
	
	this.AddEventListener = function(obj,eventName,callbackFunction,flag)
	{ 
		
		if (obj.addEventListener) 
		{
			obj.addEventListener(eventName,callbackFunction,flag);
		}
		else if (obj.attachEvent) 
		{
			obj.attachEvent("on"+eventName,callbackFunction);
		}
		else 
		{
			eval("obj.on"+eventName+"="+callbackFunction);
		}
	}
	
	this.WriteHTML = function(obj,html) 
	{
		
		if (this.IsNetscape)
		{
			var doc=obj.document;
			doc.write(html);
			doc.close();
			return false;
		}
		if (obj.innerHTML) obj.innerHTML=html; 
	}

	this.SetXClientOverflowSafe=function(obj, x)
	{
		var objW = IGB.GetWidth(obj);
		var objR = objW + x;
		var clientW = IGB.GetClientWidth();
		if ( (clientW - objR ) > (x-objW-5) )
			this.SetX(obj, x);
		else
			this.SetXScrollContainerSafe(obj, x - objW - 5);
	}
	this.SetXOverflowSafe=function(obj, x, container)
	{
		var objR = IGB.GetWidth(obj) + x;
		var containerW = IGB.GetWidth(container);
		if (objR <= containerW)
			this.SetXScrollContainerSafe(obj, x);
		else
			this.SetXScrollContainerSafe(obj, x - (objR - containerW));
	}
	
	this.SetYClientOverflowSafe=function(obj, y)
	{
		var objH = IGB.GetHeight(obj);
		var objT = objH + y + 23; // plus 23, as 20 offset was already added to y
		var clientH = IGB.GetClientHeight();
		if ( (clientH - objT ) > (y-objH-25) )
			this.SetYScrollContainerSafe(obj, y);
		else
			this.SetYScrollContainerSafe(obj, y - objH - 25 );
	}
	this.SetYOverflowSafe=function(obj, y, container)
	{
		var objT = IGB.GetHeight(obj) + y;
		var containerH = IGB.GetHeight(container);
		if (objT <= containerH)
			this.SetYScrollContainerSafe(obj, y);
		else
			this.SetYScrollContainerSafe(obj, y - (objT - containerH));
	}

	this.GetClientWidth = function()
	{
		var w=(this.IsIE)? window.document.body.clientWidth:window.innerWidth;
		return w;
	}
	this.GetClientHeight = function()
	{
		var w=(this.IsIE)? window.document.body.clientHeight:window.innerHeight;
		return w;
	}
	
	this.SetXScrollContainerSafe = function(obj, x)
	{
		var hSC = this.GetHScrolledContainer(obj);
		if (hSC != null)
			this.SetXScrollContainerAdjusted(obj, x, hSC);
		else
			this.SetX(obj, x);
	}
	this.SetYScrollContainerSafe = function(obj, y)
	{
		var vSC = this.GetVScrolledContainer(obj);
		if (vSC != null)
			this.SetYScrollContainerAdjusted(obj, y, vSC);
		else
			this.SetY(obj, y);
	}
	this.GetVScrolledContainer = function(obj)
	{
		if (obj.scrollTop > 0 && obj.tagName != 'BODY')
			return obj;
		else if (obj.offsetParent != null)
			return this.GetVScrolledContainer(obj.offsetParent);
		else
			return null;
	}
	this.GetHScrolledContainer = function(obj)
	{
		if (obj.scrollLeft > 0 && obj.tagName != 'BODY')
			return obj;
		else if (obj.offsetParent != null)
			return this.GetHScrolledContainer(obj.offsetParent);
		else
			return null;
	}
	this.SetXScrollContainerAdjusted = function(obj, x, container)
	{
		this.SetX(obj, x + container.scrollLeft);
	}
	this.SetYScrollContainerAdjusted = function(obj, y, container)
	{
		this.SetY(obj, y + container.scrollTop);
	}

	this.InsertHTML = function(obj,html,where) 
	{
		
		if (this.IsOpera) return;
		if (obj.insertAdjacentHTML) 
		{ 
			obj.insertAdjacentHTML(where,html);
			return;
		}
		if (this.IsNetscape) 
		{
			this.WriteHTML(obj,html);
			return;
		}
		
		// Mozilla
		var ref = obj.ownerDocument.createRange();
		ref.setStartBefore(obj);
		
		var fragment = ref.createContextualFragment(html);
		
		this.DOMInsertObj(obj,where,fragment);	
	}

	this.DOMInsertObj  = function(obj, where, node) 
	{
		
		switch (where)
		{
			case 'beforeBegin':
				obj.parentNode.insertBefore(node,obj)
				break;
			case 'afterBegin':
				obj.insertBefore(node,obj.firstChild);
				break;
			case 'beforeEnd':
				obj.appendChild(node);
				break;
			case 'afterEnd':
				if (obj.nextSibling)
				{
					obj.parentNode.insertBefore(node,obj.nextSibling);
				} 
				else 
				{
					obj.parentNode.appendChild(node)
				}
				break;
		}
	}

	ID2OBJECT["IGB"] = this;

	this.Listener	  = new Array();
	this.AddListener  = function(type, function_ref) 
	{
		this.Listener[type] = function_ref;
	}

	this.CurrentX = 0;
	this.CurrentY = 0;

	this.GlobalHandleMouseMove = function(evt)
	{
		if (this.IsNetscape4Plus)
		{
			this.CurrentX=evt.pageX;
			this.CurrentY=evt.pageY;
		}
		else if (this.IsNetscape6)
		{
			this.CurrentX=evt.clientX;
			this.CurrentY=evt.clientY;
		}
		else if (this.IsIE5)
		{
			this.CurrentX=event.clientX;
			this.CurrentY=event.clientY;
		}

		IGProcessEventsObjects("onmousemove", this);

		return false;
	}

	// Gets the function name from the function reference.
	this.FunctionName = function(f)
	{

		if (f==null)
		{
			return "annonymous";
		}
		var s=f.toString().match(/function (\w*)/)[1];
		if((s==null)|| (s.length==0)) return "annonymous";
		return s;
	}

	// DecodeArguments, spilt and url-decode it.
	// string is split at "&" and url decoded, all the items are put in an array.
	this.DecodeArguments=function(inputString) 
	{
		var splitArray = inputString.split('&');
		for (i=0; i<splitArray.length; i++) splitArray[i] = unescape(splitArray[i]);
		return splitArray;
	}
}

// Util objects
function IGRectangle(x, y, width, height)
{
	this.X=x;
	this.Y=y;
	this.Width=width;
	this.Height=height;

	this.Inside = function(x,y)
	{
		return (x >=this.X && y >= this.Y && x <=(this.X+this.Width) && y <=(this.Y+this.Height));
	}
}

function IGPoint(x, y) 
{
	this.X = x;
	this.Y = y;
} 

var IGB = new IGBrowser();

function IGProcessEventsObjects(type, sender_object)
{
	if (eval("sender_object.Listener")) 
	{
		var function_ref = sender_object.Listener[type];
		if (function_ref != null) 
		{
			function_ref(type, null, sender_object);
		}
	}
}

function IGProcessEvents(type, sender_element)
{
	var sender_object = ID2OBJECT[sender_element.id];
	IGBubbleEvent(type, sender_element, sender_object);

	if (eval("sender_object.Listener")) 
	{
		var function_ref = sender_object.Listener[type];
		if (function_ref != null) 
		{
			function_ref(type, sender_element, sender_object);
		}
	}
}
function IGBubbleEvent(type, sender_element, sender_object)
{
	if (eval("sender_object."+type)) 
	{
		if (eval("sender_object."+type+"(sender_element, sender_object)"))
		{
			var parent_ref = sender_object.Parent;
			if (parent_ref != null) 
			{
				IGBubbleEvent(type, sender_element, parent_ref);
			}
		}
	}
}

// Repeating infrastructure related. This used to implement repeating functionality in controls such as scrollbar and fader.
// Please note that this repeating logic can only handle one repeating at a time. Call to Cancel repeating will cancel any
// other repeating in progress. This logic can be extended to handle more than one repeating but since chart uses are limited
// not implemented. -KV
var RepeatingDelegate=null;
var DelegateParameter=null;
var DelegateeObject=null;
var TimerId= null;

// Linear decay repeating
//    ^
//    |   unit: msec
// 70 +
//    | \
//    |   \
//  5 +     \____
//    +-----+---->
//    0     552 

function GetDelay(nextTimeOut)
{
	if (nextTimeOut == -1)
	{
		nextTimeOut = 70;
	}
	else
	{
		nextTimeOut-=5;
		if (nextTimeOut<5) nextTimeOut = 5;
	}
	return nextTimeOut;
}

// Repeating handler, called upon each timeout
function RepeatingHandler(nextTimeOut) 
{
	nextTimeOut = GetDelay(nextTimeOut);

	TimerId=setTimeout("RepeatingHandler("+nextTimeOut+")", nextTimeOut);

	if (RepeatingDelegate!=null) 
	{
		RepeatingDelegate.apply(DelegateeObject, DelegateParameter);
	}
}

// setup start and stop repeating
function Repeating(trueToStartfalseToEnd, delegate, parameters, ThisObject) 
{
	if (trueToStartfalseToEnd == true) 
	{
		RepeatingDelegate = delegate;
		DelegateParameter = parameters;
		DelegateeObject   = ThisObject;
		RepeatingHandler(-1); 
	}
	else 
	{
		if (TimerId)
		{
			clearTimeout(TimerId);
			TimerId = null;
		}

		RepeatingDelegate = null;
		DelegateParameter = null;
	}
}

// Fader class is used to create fading effect on given element. 
// This animates the Opacity Style in given interval.
// Very Generic Object can be used on pretty much any element ref.
function Fader()
{
	ID2OBJECT[this.ID]= this; // save id's ref.
	this.Parent		  = null; // for parent child relationship
	this.Listener	  = new Array();
	this.AddListener  = function(type, function_ref) 
	{
		// nothing supported yet
	}

	this.FaderOpacity = 0; 

	this.FaderStep=function(id_ref, min, max, delta)
	{
		if( (this.FaderOpacity<=max) && (this.FaderOpacity>=min) )
		{
			this.FaderOpacity += delta;
			if (IGB.IsIE4 || IGB.IsIE5) id_ref.style.filter="alpha(opacity="+this.FaderOpacity+")";
			if (IGB.IsNetscape6) id_ref.style.MozOpacity=this.FaderOpacity/100;
		} 
		else
		{
			Repeating(false);
		}
	}

	// Starts the fader
	// animates the opacity of an element from [min..max] with delta.
	// make sure delta is not equal to zero other wise it will never stop repeating
	this.Start=function(id_ref, min, max, delta)
	{
		this.FaderOpacity = min;
		Repeating(true, this.FaderStep, [id_ref, min, max, delta], this);
	}

	this.End=function()
	{
		Repeating(false);
	}
}


/// Bounce event to right object.
function Bounce(evt, id, func_name, paramArray) 
{
	var this_ref = ID2OBJECT[id];  
	var fn = func_name;
	if (this_ref)
	{
		if (fn)
		{
			fn = func_name;
		}
		else
		{
			fn = "on"+evt.type;
		}

		eval("this_ref."+fn+"(evt, id, paramArray)");
	}
}


// Infragistics Web Chart window viewer Script 
 
function IGWindowViewer(id, imageId, vuid, srcBounds, destBounds) 
{
	this.SourceBounds = srcBounds;
	this.DestBounds	= destBounds;
	this.ImageId	= imageId;
	this.VUId		= vuid;

	ID2OBJECT[this.ID]= this; // save id's ref.
	this.Parent		  = null; // for parent child relationship
	this.HTML		  = "";   // debugging purposes
	this.Listener	  = new Array();
	this.AddListener  = function(type, function_ref) 
	{
		// does nothing
	}

	this.MoveBy=function(x,y)
	{
		this.SourceBounds.X += x;
		this.SourceBounds.Y += y;
		this.Render();
	}

	this.Render=function()
	{
		var imgref = IGB.GetObject(this.ImageId);
		var vuwref = IGB.GetObject(this.VUId);
		
		// Viewing transform (scaling=1)
		//  1) Translate (-x, -y); img
		//  3) Translate (x1, y1); vu

		IGB.SetX(imgref, - this.SourceBounds.X);
		IGB.SetY(imgref, - this.SourceBounds.Y);

		var w = this.SourceBounds.Width;
		var h = this.SourceBounds.Height;
	
		if (IGB.IsFirefox && document.documentElement)
		{
			w += "px";
			h += "px";
		}
		
		IGB.SetStyle(vuwref, "clip", "rect(0," + w +"," + h +", 0)");		IGB.SetStyle(vuwref, "clip", "rect(0,"+this.SourceBounds.Width+","+this.SourceBounds.Height+", 0)");

		IGB.SetX(vuwref, this.DestBounds.X);
		IGB.SetY(vuwref, this.DestBounds.Y);
	}
}

// Infragistics Web Chart cross hair Script 

function IGCrossHair(id, toggleOnClick)
{
	this.ID					= id;
	this.ToggleOnClick		= toggleOnClick;
	this.Visible			= false;

	// must set properties
	this.SpanImageObject	= null;
	this.HairHorizontal		= null;
	this.HairVertical		= null;

	ID2OBJECT[this.ID]= this; // save id's ref.
	this.Parent		  = null; // for parent child relationship
	this.HTML		  = "";   // debugging purposes
	this.Listener	  = new Array();
	this.AddListener  = function(type, function_ref) 
	{
		// no events supported yet.
	}

	this.Render=function(b)
	{
		IGB.SetX(this.HairHorizontal, b.X);
		IGB.SetY(this.HairVertical, b.Y);
		IGB.SetWidth(this.HairHorizontal, b.Width);
		IGB.SetHeight(this.HairHorizontal, 1);
		IGB.SetHeight(this.HairVertical, b.Height);
		IGB.SetWidth(this.HairVertical, 1);
	}

	this.Update=function(x, y)
	{
		if(this.Visible==true)
		{
			IGB.ShowObject(this.HairHorizontal);
			IGB.ShowObject(this.HairVertical);
		}
		else 
		{
			IGB.HideObject(this.HairHorizontal);
			IGB.HideObject(this.HairVertical);
		}

		if (x && y)
		{
			IGB.SetX(this.HairVertical, x);
			IGB.SetY(this.HairHorizontal, y);
		}
	}
}

// Infragistics Web Chart Scrollbar Script 
 
function IGScrollBar(id, width, height, scrollerLength, url, orientation) 
{
	this.Orientation = orientation==null?'horizontal':orientation;
	this.ID			 = id;
	this.ImageURL	 = url;
	this.Width		 = width;
	this.Height		 = height;
	this.ScrollerLen = scrollerLength;
	
	// [KV 12/3/2004, 10:37 AM] BR01044 Scrollbar images do not appear when 
	// chart is on a user control. Since every scrollbar has unique id, and 
	// it uses images from that id. Following provides an alternative way to
	// to use the images.
	this.UseImageFromId = this.ID

	this.Location	 = new IGPoint(0,0);

	this.Minimum	 = 0;
	this.Maximum	 = 100;
	this.Value		 = 0;
	this.SmallChange  = 5;
	this.LargeChange  = 15;

	ID2OBJECT[this.ID]= this; // save id's ref.
	this.Parent		  = null; // for parent child relationship
	this.HTML		  = "";   // debugging purposes
	this.Listener	  = new Array();
	this.AddListener  = function(type, function_ref) 
	{
		this.Listener[type] = function_ref; // save listener into array.
	}

	this.Render = function(where) 
	{
		var where_ref = IGB.GetObject(where); 
		if (where_ref == null) return;

		if (this.Location)
		{
			IGB.SetX(where_ref, this.Location.X);
			IGB.SetY(where_ref, this.Location.Y);
		}
		

		if ((this.Orientation != null)&&(this.Orientation=='vertical'))
		{
			var scrl = this.Height - 2 * this.Width - this.ScrollerLen;

			this.HTML ="<table OnMouseWheel=ScrollbarMouseWheel('"+this.ID+"') id='"+this.ID+"' width="+this.Width+" height="+this.Height+" border=0 cellpadding=0 cellspacing=0 style='table-layout:fixed'>";
			this.HTML += "<tr>";
			this.HTML += "<td valign=top>";
			this.HTML += "<img						width="+this.Width+"px height="+this.Width+"px			src='"+this.ImageURL+"/"+this.UseImageFromId+"_top_.jpg'		OnMouseOver=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_top_over.jpg';\"		OnMouseOut=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_top_.jpg';\"		OnMouseDown=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_top_down.jpg'; ScrollItV('"+this.ID+"', -"+this.SmallChange+"); Repeating(true, ScrollItV, ['"+this.ID+"', -"+this.SmallChange+"]); \"	OnMouseUp=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_top_.jpg';\" ><br>";
			this.HTML += "<img id='"+this.ID+"_1'	width="+this.Width+"px height=1px						src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_v_.jpg'		OnMouseOver=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_v_over.jpg';\"	OnMouseOut=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_v_.jpg';\"	OnMouseDown=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_v_down.jpg'; ScrollItV('"+this.ID+"', -"+this.LargeChange+"); Repeating(true, ScrollItV, ['"+this.ID+"', -"+this.LargeChange+"]);\"	OnMouseUp=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_v_.jpg';\" ><br>";
			this.HTML += "<img						width="+this.Width+"px height="+this.ScrollerLen+"px	src='"+this.ImageURL+"/"+this.UseImageFromId+"_scroll_v_.jpg'	OnMouseOver=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_scroll_v_over.jpg';\"	OnMouseOut=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_scroll_v_.jpg';\"	OnMouseDown=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_scroll_v_down.jpg'; EngageObject('"+this.ID+"');\"																						OnMouseUp=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_scroll_v_.jpg';\" ><br>";
			this.HTML += "<img id='"+this.ID+"_3'	width="+this.Width+"px height="+scrl+"px				src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_v_.jpg'		OnMouseOver=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_v_over.jpg';\"	OnMouseOut=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_v_.jpg';\"	OnMouseDown=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_v_down.jpg'; ScrollItV('"+this.ID+"', "+this.LargeChange+"); Repeating(true, ScrollItV, ['"+this.ID+"', "+this.LargeChange+"]); \"	OnMouseUp=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_v_.jpg';\" ><br>";
			this.HTML += "<img						width="+this.Width+"px height="+this.Width+"px			src='"+this.ImageURL+"/"+this.UseImageFromId+"_bottom_.jpg'		OnMouseOver=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_bottom_over.jpg';\"	OnMouseOut=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_bottom_.jpg';\"	OnMouseDown=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_bottom_down.jpg'; ScrollItV('"+this.ID+"', "+this.SmallChange+"); Repeating(true, ScrollItV, ['"+this.ID+"', "+this.SmallChange+"]); \"	OnMouseUp=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_bottom_.jpg';\" >";
			this.HTML += "</td></tr>";
			this.HTML += "</table>";	
		}
		else 
		{
			var scrl = this.Width - 2 * this.Height - this.ScrollerLen;

			this.HTML ="<table OnMouseWheel=ScrollbarMouseWheel('"+this.ID+"') id='"+this.ID+"' width="+this.Width+" height="+this.Height+" border=0 cellpadding=0 cellspacing=0 style='table-layout:fixed'>";
			this.HTML += "<tr>";
			this.HTML += "<td  width="+this.Height+"px		height="+this.Height+"px>";
			this.HTML += "<img width="+this.Height+"px		height="+this.Height+"px						src='"+this.ImageURL+"/"+this.UseImageFromId+"_left_.jpg'		OnMouseOver=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_left_over.jpg';\"		OnMouseOut=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_left_.jpg';\"		OnMouseUp=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_left_.jpg';\"		OnMouseDown=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_left_down.jpg'; ScrollItH('"+this.ID+"', -"+this.SmallChange+");		Repeating(true, ScrollItH, ['"+this.ID+"', -"+this.SmallChange+"]); \" ></td>";
			this.HTML += "<td  width=1px					height="+this.Height+"px id='"+this.ID+"_1'>"; 
			this.HTML += "<img width=1px					height="+this.Height+"px id='"+this.ID+"_2'		src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_h_.jpg'		OnMouseOver=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_h_over.jpg';\"	OnMouseOut=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_h_.jpg';\"	OnMouseUp=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_h_.jpg';\"		OnMouseDown=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_h_down.jpg'; ScrollItH('"+this.ID+"', -"+this.LargeChange+");	Repeating(true, ScrollItH, ['"+this.ID+"', -"+this.LargeChange+"]);\" ></td>";
			this.HTML += "<td  width="+this.ScrollerLen+"px height="+this.Height+"px>";
			this.HTML += "<img width="+this.ScrollerLen+"px height="+this.Height+"px id='"+this.ID+"_engagable' src='"+this.ImageURL+"/"+this.UseImageFromId+"_scroll_h_.jpg'	OnMouseOver=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_scroll_h_over.jpg';\" OnMouseOut=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_scroll_h_.jpg';\"  OnMouseUp=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_scroll_h_.jpg';\"	OnMouseDown=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_scroll_h_down.jpg'; EngageObject('"+this.ID+"');\"   ></td>";
			this.HTML += "<td  width="+scrl+"px				height="+this.Height+"px id='"+this.ID+"_3'>";
			this.HTML += "<img width="+scrl+"px				height="+this.Height+"px id='"+this.ID+"_4'		src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_h_.jpg'		OnMouseOver=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_h_over.jpg';\"	OnMouseOut=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_h_.jpg';\"	OnMouseUp=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_h_.jpg';\"		OnMouseDown=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_back_h_down.jpg'; ScrollItH('"+this.ID+"', "+this.LargeChange+");		Repeating(true, ScrollItH, ['"+this.ID+"', "+this.LargeChange+"]); \" ></td>";
			this.HTML += "<td  width="+this.Height+"px		height="+this.Height+"px>";
			this.HTML += "<img width="+this.Height+"px		height="+this.Height+"px						src='"+this.ImageURL+"/"+this.UseImageFromId+"_right_.jpg'		OnMouseOver=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_right_over.jpg';\"	OnMouseOut=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_right_.jpg';\"		OnMouseUp=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_right_.jpg';\"		OnMouseDown=\"this.src='"+this.ImageURL+"/"+this.UseImageFromId+"_right_down.jpg'; ScrollItH('"+this.ID+"', "+this.SmallChange+");		Repeating(true, ScrollItH, ['"+this.ID+"', "+this.SmallChange+"]); \" ></td>";
			this.HTML += "</tr>";
			this.HTML += "</table>";

		}
		if (where_ref.style != null)
		{
			where_ref.style.height = this.Height;
			where_ref.style.width = this.Width;
		}
		IGB.InsertHTML(where_ref, this.HTML, "afterBegin");
		this.SetValue(this.Value);
	}

	this.SetValue = function(val)
	{
		this.Value = val;
		var id = this.ID;

		var id1 = IGB.GetObject(id+"_1");
		var id2 = IGB.GetObject(id+"_2");
		var id3 = IGB.GetObject(id+"_3");
		var id4 = IGB.GetObject(id+"_4");

		var cwid1 = 0;
		var cwid3 = 0;

		if ((this.Orientation != null)&&(this.Orientation=='vertical'))
		{
			cwid1 = IGB.GetHeight(id1);
			cwid3 = IGB.GetHeight(id3);
		}
		else 
		{
			cwid1 = IGB.GetWidth(id1);
			cwid3 = IGB.GetWidth(id3);
		}

		var totwid = cwid1 + cwid3 -1;

		if (this.Maximum != this.Minimum)
		{
			nuwid1 = (val - this.Minimum) * (totwid-1) / (this.Maximum - this.Minimum) + 1 ;
		}
		else 
		{
			nuwid1 = totwid
		}

		if (nuwid1 > totwid) nuwid1 = totwid;
		if (nuwid1 < 1) nuwid1 = 1;

		var nuwid3 = totwid - nuwid1;
		if (nuwid3 > totwid) nuwid3 = totwid;
		if (nuwid3 < 1) nuwid3 = 1;


		if ((this.Orientation != null)&&(this.Orientation=='vertical'))
		{
			IGB.SetHeight(id1, nuwid1);
			IGB.SetHeight(id3, nuwid3);
		}
		else 
		{
			IGB.SetWidth(id1, nuwid1);
			IGB.SetWidth(id2, nuwid1);

			IGB.SetWidth(id3, nuwid3);
			IGB.SetWidth(id4, nuwid3);
		}
	}
}

function ScrollItH(id, scroll) 
{
	var id1 = IGB.GetObject(id+"_1");
	var id2 = IGB.GetObject(id+"_2");
	var id3 = IGB.GetObject(id+"_3");
	var id4 = IGB.GetObject(id+"_4");

	var cwid1 = IGB.GetWidth(id1);
	var cwid3 = IGB.GetWidth(id3);

	var totwid = cwid1 + cwid3 -1;

	var nuwid1 = cwid1 + scroll;
	if (nuwid1 > totwid) nuwid1 = totwid;
	if (nuwid1 < 1) nuwid1 = 1;

	var nuwid3 = cwid3 - scroll;
	if (nuwid3 > totwid) nuwid3 = totwid;
	if (nuwid3 < 1) nuwid3 = 1;

	// repeating sanity
	if (nuwid1==1 || nuwid3 == 1)
	{
		Repeating(false); // clear timer
	}

	IGB.SetWidth(id1, nuwid1);
	IGB.SetWidth(id2, nuwid1);

	IGB.SetWidth(id3, nuwid3);
	IGB.SetWidth(id4, nuwid3);

	// update the value
	var obj = ID2OBJECT[id];
	obj.Value = obj.Minimum + ((nuwid1-1)/(totwid-1))*(obj.Maximum - obj.Minimum);
	
	// Fire events.
	var listener = obj.Listener["scroll"];
	if (listener)
	{
		listener.apply(this, ["scroll", IGB.GetObject(id), obj]);
	}
}

function ScrollItV(id, scroll) 
{
	var id1 = IGB.GetObject(id+"_1");
	var id3 = IGB.GetObject(id+"_3");

	var cwid1 = IGB.GetHeight(id1);
	var cwid3 = IGB.GetHeight(id3);

	var totwid = cwid1 + cwid3 -1;

	var nuwid1 = cwid1 + scroll;
	if (nuwid1 > totwid) nuwid1 = totwid;
	if (nuwid1 < 1) nuwid1 = 1;

	var nuwid3 = cwid3 - scroll;
	if (nuwid3 > totwid) nuwid3 = totwid;
	if (nuwid3 < 1) nuwid3 = 1;

	// repeating sanity
	if (nuwid1==1 || nuwid3 == 1)
	{
		Repeating(false); // clear timer
	}

	IGB.SetHeight(id1, nuwid1);
	IGB.SetHeight(id3, nuwid3);

	// update the value
	var obj = ID2OBJECT[id];
	obj.Value = obj.Minimum + ((nuwid1-1)/(totwid-1))*(obj.Maximum - obj.Minimum);

	// Fire events.
	var listener = obj.Listener["scroll"];
	if (listener)
	{
		listener.apply(this, ["scroll", IGB.GetObject(id), obj]);
	}
}

var EngagedObject=null;
var OldMouseDown;
var OldMouseMove;
var OldMouseUp;
var MouseDownX, MouseDownY;

function EngageObject(which) 
{
	EngagedObject = ID2OBJECT[which]; 
}
function ReleaseObject() 
{
	EngagedObject = null;
}

function NewMouseDown(evt) 
{
	if (OldMouseDown) OldMouseDown(evt);
	if (IGB.IsNetscape6) 
	{
		MouseDownX = evt.pageX;
		MouseDownY = evt.pageY;

		if (evt && evt.target && evt.target.id && (evt.target.id.indexOf('engagable')>-1))
		{
			return false;	
		}
	} else {
		MouseDownX = window.event.clientX;
		MouseDownY = window.event.clientY;
	}
	return true;
}
function NewMouseMove(evt) 
{
	if (OldMouseMove) OldMouseMove(evt);
	if( EngagedObject!=null) 
	{
		var scroll = 0;
		if ((EngagedObject.Orientation != null)&&(EngagedObject.Orientation=='vertical')) 
		{
			if (IGB.IsNetscape6) 
			{
                scroll = (evt.pageY - MouseDownY);
				MouseDownY = evt.pageY;
            } 
			else 
			{
                scroll = (window.event.clientY - MouseDownY);
				MouseDownY = window.event.clientY;
            }
			ScrollItV(EngagedObject.ID, scroll);
		}
		else 
		{
			if (IGB.IsNetscape6) 
			{
                scroll = (evt.pageX - MouseDownX);
				MouseDownX = evt.pageX;
            } 
			else 
			{
                scroll = (window.event.clientX - MouseDownX);
				MouseDownX = window.event.clientX;
            }
			ScrollItH(EngagedObject.ID, scroll);
		}
		return false;
	}
	return true;
}
function NewMouseUp(evt) 
{
	Repeating(false); // clear timer
	if (OldMouseUp) OldMouseUp(evt);
	ReleaseObject();
	return true;
}

function ScrollbarMouseWheel(id)
{
	var obj = ID2OBJECT[id];
	var scroll = 0;
	if		(event.wheelDelta >=  120) { scroll = -10;  }
    else if (event.wheelDelta <= -120) { scroll = +10;  }
	if ((obj.Orientation != null)&&(obj.Orientation=='vertical'))
	{
		ScrollItV(id, scroll);
	}
	else
	{
		ScrollItH(id, scroll);
	}	
	return false;
}

function InitilizeScrollbar() 
{
	if( OldMouseDown==null && IGB.FunctionName(document.OnMouseDown)!="NewMouseDown" && IGB.FunctionName(document.onmousedown)!="NewMouseDown")
	{
		OldMouseDown=document.onmousedown;
	}
	if( OldMouseUp==null && IGB.FunctionName(document.OnMouseUp)!="NewMouseUp" && IGB.FunctionName(document.onmouseup) != "NewMouseUp")
	{
		OldMouseUp=document.onmouseup;
	}
	if( OldMouseMove==null && IGB.FunctionName(document.OnMouseMove)!="NewMouseMove" && IGB.FunctionName(document.onmousemove) != "NewMouseMove")
	{
		OldMouseMove=document.onmousemove;
	}

	document.onmousedown = NewMouseDown;
	document.onmouseup   = NewMouseUp;
	document.onmousemove = NewMouseMove;

	if (IGB.IsNetscape6) 
	{
        document.captureEvents(Event.MOUSEDOWN | Event.MOUSEMOVE | Event.MOUSEUP)
    }
}
 
// UltraChart CSOM object.
// param id: chart id
// param imageUrl: Url to pickup scrollbar images from.
function IGUltraChart(id, imageUrl)
{
	// public properties assined with constructor
	this.ID			= id;
	this.ImageUrl	= imageUrl;
	
	// must be assigned public properties
	this.EnableTooltipFading = false;
	this.EventData	= null;
	this.TooltipData= null;
	this.RowCount = 0;
	this.ColumnCount = 0;
	this.TooltipDisplay = 0; // Never
	this.EnableCrossHair = false;
	this.EnableServerEvent = false;
	this.Section508Compliant = false;
	this.UniqueID = null;

	ID2OBJECT[this.ID]= this; // save id's ref.
	this.Parent		  = null; // for parent child relationship
	this.HTML		  = "";   // debugging purposes
	this.Listener	  = new Array();
	this.DEBUG		  = false;
	this.AddListener  = function(type, function_ref) 
	{
		this.Listener[type] = function_ref; // save listener into array.
		// In all these listeners "this" refers to calling IGUltraChart object
		// UltraChart fires following CSOM Events.
		// mousemove(object []arg)
		// mouseout(object []arg)
		// mouseclick(object []arg)
		// showtooltip(string text, object tooltip_ref)
		// hidetooltip(string text, object tooltip_ref)
		// crosshairmove(int x, int y)
		// hidecrosshair(int x, int y)
		// showcrosshair(int x, int y)
		// scroll(IGScrollBar sb)
		
	}

	// private variables
	this.payloadHandler = null;
	this.SB1 = null;
	this.SB2 = null;
	this.igWindowVuer = null;
	this.iGCrossHair = null;
	this.XhairBounds = null;
	this.TooltipFader = null;
	this.TooltipVisible = false;

	// Called by UltraWebChart when it runs at Server.
	this.CreateComponents=function(vals)
	{
		// Create instance
		this.SB1				= new IGScrollBar(this.ID+"_SB1", vals[2], vals[3],  30, this.ImageUrl);
		this.SB2				= new IGScrollBar(this.ID+"_SB2", vals[9], vals[10], 30, this.ImageUrl, "vertical");
		this.igWindowVuer		= new IGWindowViewer(this.ID+"_igWindowVuer", this.ID+"_ScrollImage", this.ID+"_igWindowVuer");
		this.iGCrossHair		= new IGCrossHair(this.ID+"_iGCrossHair");
		this.TooltipFader		= new Fader();

		// Set parents for object containment hierarchy.	
		this.SB1.Parent = this;
		this.SB2.Parent = this;
		this.igWindowVuer.Parent = this;
		this.iGCrossHair.Parent = this;

		// cross hair settings
		this.iGCrossHair.SpanImageObject	= IGB.GetObject(this.ID+"_BaseImage");
		this.iGCrossHair.HairHorizontal		= IGB.GetObject(this.ID+"_HairHorizontal");
		this.iGCrossHair.HairVertical		= IGB.GetObject(this.ID+"_HairVertical");
		this.iGCrossHair.Visible			= this.EnableCrossHair;

		if (IGB.IsNetscape6)
		{
			var table = IGB.GetObject(this.ID+"_table");
			var oL = table.offsetLeft;
			var oT = table.offsetTop;
			if (vals[1])
			{
				vals[1].X += oL;
				vals[1].Y += oT;
			}
			if (vals[0])
			{
				vals[0].X += oL;
				vals[0].Y += oT;
			}
		}
		
		// View settings
		this.igWindowVuer.SourceBounds		= vals[4]; 
		this.igWindowVuer.DestBounds		= vals[5]; 
		this.XhairBounds					= vals[0]; 
		
		
		// Scrollbar settings
		this.SB1.Location = vals[1];
		this.SB1.AddListener("scroll", this.SB1_Scroll);
		this.SB1.Minimum = vals[6];
		this.SB1.Maximum = vals[7];
		this.SB1.Value	 = vals[6];

		this.SB2.Location = vals[8];
		this.SB2.AddListener("scroll", this.SB2_Scroll);
		this.SB2.Minimum = vals[11];
		this.SB2.Maximum = vals[12];
		this.SB2.Value	 = vals[11]
	}

	// Called by UltraWebChart when it runs at Client.
	this.Render=function(vals) 
	{
		if (IGB.IsNetscape6 && vals[5])
		{
			var table = IGB.GetObject(this.ID+"_table");
			var oL = table.offsetLeft;
			var oT = table.offsetTop;
			vals[5].X += oL;
			vals[5].Y += oT;
		}
	
		if (vals[0]) this.SB1.Render(this.ID+"_SB1_Location");
		if (vals[1]) this.SB2.Render(this.ID+"_SB2_Location");
		if (vals[2]) this.igWindowVuer.Render();
		if (vals[3])this.iGCrossHair.Render(vals[5]);
		
		// Show image after rendering is done
		if (vals[4]) IGB.ShowObject(IGB.GetObject(this.ID+"_ScrollImage"));
	}

	// This handles the Horizontal Scroll functionlity of chart.
	this.SB1_Scroll=function(evt, sender_element, sender_object) 
	{
		sender_object.Parent.igWindowVuer.SourceBounds.X = parseInt(sender_object.Value);
		sender_object.Parent.igWindowVuer.Render();
		var function_ref = sender_object.Parent.Listener[evt];
		if (function_ref != null) 
		{
			function_ref.apply(sender_object.Parent, [sender_object]);
		}
	}

	// This handles the Vertical Scroll functionlity of chart.
	this.SB2_Scroll=function(evt, sender_element, sender_object) 
	{
		sender_object.Parent.igWindowVuer.SourceBounds.Y = parseInt(sender_object.Value);
		sender_object.Parent.igWindowVuer.Render();
		var function_ref = sender_object.Parent.Listener[evt];
		if (function_ref != null) 
		{
			function_ref.apply(sender_object.Parent, [sender_object]);
		}
	}

	// This handles the Horizontal Scrolling on mouse wheel functionlity of chart.
	this.onmousewheel=function(evt, id)
	{
		// works only horizontally.
		if		(evt.wheelDelta >=  120) { this.igWindowVuer.MoveBy(-10,0);  }
		else if (evt.wheelDelta <= -120) { this.igWindowVuer.MoveBy(+10,0);  }

		this.SB1.SetValue(this.igWindowVuer.SourceBounds.X);
	}

	// This handles the On Mouse Move functionlity of chart.
	this.onmousemove=function(evt, id)
	{
		var baseImageRef;
		var x,y;
		var oldState = this.iGCrossHair.Visible;
		baseImageRef = IGB.GetObject(this.ID+"_BaseImage");
		if (IGB.IsNetscape6) 
		{	
			x = evt.pageX - IGB.GetPageX(baseImageRef)+8;
			y = evt.pageY - IGB.GetPageY(baseImageRef)+5;
		} 
		else 
		{
			x = window.event.clientX - IGB.GetPageX(baseImageRef) + document.body.scrollLeft;
			y = window.event.clientY - IGB.GetPageY(baseImageRef) + document.body.scrollTop;

			if (IGB.IsMac && IGB.IsIE)
			{
				x-=10;
				y-=15;
			}
		}

		if (this.EnableCrossHair)
		{
			this.iGCrossHair.Visible = this.XhairBounds.Inside(x,y);
			this.iGCrossHair.Update(x-5, y-5);
			if (this.iGCrossHair.Visible)
			{
				var function_ref = this.Listener["crosshairmove"];
				if (function_ref != null) 
				{
					function_ref.apply(this, [x-5, y-5]);
				}
			}
		}

		if (oldState != this.iGCrossHair.Visible)
		{
			if (oldState)
			{
				var function_ref = this.Listener["hidecrosshair"];
				if (function_ref != null) 
				{
					function_ref.apply(this, [x-5, y-5]);
				}
			}
			else
			{
				var function_ref = this.Listener["showcrosshair"];
				if (function_ref != null) 
				{
					function_ref.apply(this, [x-5, y-5]);
				}
			}
		}

		x+=15;
		y+=20;

		var tooltip_ref = IGB.GetObject(this.ID+"_IGTooltip");
		if (tooltip_ref.style.visibility != "hidden")
		{
			switch (tooltip_ref.getAttribute("igTtOf"))
			{
				case "None":
					IGB.SetXScrollContainerSafe(IGB.GetObject(this.ID+"_IGTooltip"),x);
					IGB.SetYScrollContainerSafe(IGB.GetObject(this.ID+"_IGTooltip"),y);
					break;
				case "ClientArea":
					IGB.SetXClientOverflowSafe(IGB.GetObject(this.ID+"_IGTooltip"), x);
					IGB.SetYClientOverflowSafe(IGB.GetObject(this.ID+"_IGTooltip"), y);
					break;
				case "ChartArea":
					IGB.SetXOverflowSafe(IGB.GetObject(this.ID+"_IGTooltip"), x, baseImageRef);
					IGB.SetYOverflowSafe(IGB.GetObject(this.ID+"_IGTooltip"), y, baseImageRef);
					break;
			}
		}
	}

	// This handles the Tooltips functionlity of chart.
	this.ShowTooltip=function(evt, id, args)
	{
		var tooltip_ref = IGB.GetObject(this.ID+"_IGTooltip");
		
		var text = "";
		var data_id = args[4]+"_"+args[1]+"_"+args[2];
		
		if (this.DEBUG)
		{
			window.status = data_id;
		}

		if (this.TooltipData!=null)
		{
			text = this.TooltipData[data_id];
		}
				
		IGB.WriteHTML(tooltip_ref, "<nobr>"+text+"</nobr>");
		IGB.ShowObject(tooltip_ref);
		this.TooltipVisible = true;

		if (this.EnableTooltipFading)
		{
			this.TooltipFader.End();
			this.TooltipFader.Start(tooltip_ref, 0, 100, 20);
		}
		var function_ref = this.Listener["showtooltip"];
		if (function_ref != null) 
		{
			function_ref.apply(this, [text, tooltip_ref]);
		}
	}

	// This handles the Tooltips functionlity of chart.
	this.HideTooltip=function(evt, id, args)
	{
		// Don't do this until the tooltip was really visible
		if (!this.TooltipVisible) return;
		
		var tooltip_ref = IGB.GetObject(this.ID+"_IGTooltip");
		
		var text = "";
		var data_id = args[4]+"_"+args[1]+"_"+args[2];

		if (this.TooltipData!=null)
		{
			text = this.TooltipData[data_id];
		}

		this.TooltipFader.End();
		tooltip_ref.style.visibility = 'hidden';
		
		var function_ref = this.Listener["hidetooltip"];
		if (function_ref != null) 
		{
			function_ref.apply(this, [text, tooltip_ref]);
		}
	}

	// This handles the functionality of the chart related to all other events. This acts as main dispatcher of client events and Glue between Version 1/3 javascript code.
	this.onallevent=function(evt, id, args)
	{

		// args = [this_ref, row, column, event_name, layer_id]
		
		var function_ref = this.Listener[evt.type];
		if (function_ref != null) 
		{
			var v = IGB.DecodeArguments( this.EventData[args[4]+"_"+args[1]+"_"+args[2]] );
			function_ref.apply(this, [this, v[0], v[1], v[2], v[3], v[4], evt.type, args[4] ] );
		}
		
		if (evt.type == "mouseover" && this.TooltipDisplay == 1)
		{
			this.ShowTooltip(evt, id, args);
		}
		if (evt.type == "mousemove" && (IGB.IsNetscape6 || IGB.IsMac))
		{
			this.onmousemove(evt);
		}
		else if (evt.type == "click" && this.TooltipDisplay == 2)
		{
			this.ShowTooltip(evt, id, args);
		}
		else if (evt.type == "mouseout" )
		{
			this.HideTooltip(evt, id, args);
		}

		if (((evt.type=="click")||(evt.type=='dblclick')) && (this.EnableServerEvent))
		{
			var data = this.EventData[args[4]+"_"+args[1]+"_"+args[2]];
			data+='&'+evt.type;
			if (this.DEBUG) window.status = "RawData="+data;
			__doPostBack(this.UniqueID, data);
		}
	}
}
