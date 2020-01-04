 /*
  * Infragistics WebToolbar CSOM Script: ig_webtoolbar2_2.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

if(typeof(igtbr_state) != "object")
	var igtbr_state = new Object();
	
function igtbar_initialize(tbName)
{
	this.loading = true;
	igtbr_state[tbName] = this;
	var id = eval(tbName + "UniqueID");
	this.UniqueId = id;
	while(id.indexOf(":") > 0) id = id.replace(":", "_");
	this.clientId = id;
	id = "igtbar_" + tbName;
	var propArray = eval(id + "_Props");
	var itemsArray = eval(id + "_Items");
	this.ClientSideEvents = new igtbar_initEvents(eval(id + "_Events"));
	this.Id=tbName;
	this.Element=ig_csom.getElementById(tbName);
	this.OnTop=propArray[0];
	this.Enabled=propArray[1];
	this.PostBackButton=propArray[2];
	this.PostBackGroup=propArray[3];
	this.mouseAction=false;
	this.Items=new Array();
	this.Items.fromKey = function (key) {
		for(i=0; i<this.length; i++)
			if(this[i].Key == key)
				return this[i];
		return null;
	}
	ig.addEventListener(document,"mousedown",ig_mouseDown,true);
	this.addLsnr = function(e, item)
	{
		if(e == null) return;
		e.owner = item;
		ig_csom.addEventListener(e, "keyup", igtbar_evt);
		if(item.Type == 4){ig_csom.addEventListener(e, "change", igtbar_evt); return;}
		ig_csom.addEventListener(e, "keydown", igtbar_evt);
		ig_csom.addEventListener(e, "focus", igtbar_evt);
	}
	for(var i=0;i<itemsArray.length;i++)
	{
		var item=new igtbar_initItem(this,itemsArray[i],i);
		item.i = i;
		this.Items[i]=item;
		id = tbName+"_Item_"+i;
		var e = ig_csom.getElementById(id);
		if(e!=null) {
			item.Element=e;
			this.addLsnr(e, item);
		}
		item.Id=id;
	}
	this.update=function(item,p,v)
	{
		if(this.elemState==null)if((this.elemState=ig_csom.getElementById(this.Id+"_hidden"))==null)return;
		if(this.state==null)this.state=new ig_xmlNode();
		var c,i=-1,s="Selected",n=this.state.addNode("x",true);
		if(item!=null)
		{
			n=n.addNode("Items",true).addNode("i"+(item.IsGroupButton?item.Parent.i:item.i),true);
			if(item.IsGroupButton)
			{
				n=n.addNode("Buttons",true);c=n.childNodes;
				if(p==s)while(++i<c.length)if(c[i].getPropertyValue(s))c[i].setPropertyValue(s,"false");
				n=n.addNode("i"+item.i,true);
			}
		}
		n.setPropertyValue(p,""+v);
		this.elemState.value=this.state.getText().replace(/\+/g,"%2B");
	}
	this.loading = false;
	this.firedClick = false;
	ig.addEventListener(window,"unload",igtbar_onUnload,false);
	ig_fireEvent(this,this.ClientSideEvents.InitializeToolbar,new ig_EventObject());
	this.td=function()
	{
		var j,i,n=this.Items;
		for(i=n.length-1;i>=0;i--)
		{
			g=n[i].Items;
			if(!g||g.length<1){if(n[i].isVisible)return n[i].Element;}
			else for(j=g.length-1;j>=0;j--)if(g[j].isVisible)return g[j].Element;
		}
		return this.Element;
	}
	this.post=function(v)
	{
		try
		{
			var p=this.inp,e=document.createElement("input");
			if(!p)
			{
				if((p=this.td())==null)
					p=document.body;
				this.inp=p;
				e.style.position="absolute";
				e.style.top="-10000";
				e.style.left="-10000";
				p.appendChild(e);
			}
			e.parentNode.focus();
		}catch(ex){}
		try{window.setTimeout("try{__doPostBack('"+this.UniqueId+"','"+v+"');}catch(e){}",0);}catch(e){}
	}
}
function igtbar_onUnload(){ig_dispose(igtbr_state);}
function igtbar_initItem(tb,item,index)
{
	this.Toolbar=tb;
	this.Type=item[0];
	if(this.Type==0) // Button
	{
		this.Selected=item[1];
		this.Enabled=item[2];
		this.serverEnabled=item[2];
		this.ToggleButton=item[3];
		this.DefaultStyleClassName=item[4];
		this.HoverStyleClassName=item[5];
		this.SelectedStyleClassName=item[6];
		this.DefaultImage=item[7];
		this.HoverImage=item[8];
		this.SelectedImage=item[9];
		this.DisabledImage=item[10];
		this.AutoPostBack=item[11];
		this.Key=item[12];
		this.Tag=item[13];
		this.isVisible=item[14];
		this.IsGroupButton=false;
		this.getText=function(){
			var e = igtbar_getTextElem(this.Element);
			return (e == null) ? null : ig_csom.getText(e);
		}
		this.setText=function(text){
			var e = igtbar_getTextElem(this.Element);
			if(e!=null)
			{
				this.Toolbar.update(this, "Text", text);
				ig_csom.setText(e, text);
			}
		}
		this.setTargetUrl=function(targetUrl){if(this.isVisible){this.Element.setAttribute("igUrl", targetUrl);}}
		this.getTargetUrl=function(){return (this.isVisible)?this.Element.getAttribute("igUrl"):null;}
		this.setTargetFrame=function(targetFrame){if(this.isVisible){this.Element.setAttribute("igFrame", targetFrame);}}
		this.getTargetFrame=function(){return (this.isVisible)?this.Element.getAttribute("igFrame"):null;}
		this.setEnabled=function(v)
		{
			if(this.Enabled == v) return;
			this.Enabled = v;
			if(this.isVisible){
				this.Element.disabled = !v;
				if(v && this.ToggleButton && this.Selected)
					igtbar_SelectItem(this.Element);
				else
					igtbar_EnableItem(this.Element, v);
			}
			this.Toolbar.update(this, "Enabled", v ? "true" : "false");
		}
		this.getEnabled=function(){return this.Enabled;}
		this.setSelected=function(bSelected){
			if(bSelected!=this.Selected&&this.isVisible){
				if(this.IsGroupButton)
					igtbar_groupButtonDown(this.Element,null,true,this.Parent.Element.id,false);
				else if(this.ToggleButton)
					igtbar_toggleButtonState(this.Element,true);
			}
		}
		this.getSelected=function(){return this.Selected;}
		this.getVisible=function(){return this.isVisible;}
		this.getPropertyEx=function(nm){
			if(nm){
			  nm=nm.toLowerCase();
			  var fnd=false;
			  var i=14;
			  while(!fnd&&item.length>++i&&item[i]){
				var pn;
				try{pn=item[i].substr(1);}catch(ex){;}
				fnd=(pn==nm);
				++i;
			  }
			  if(fnd){return item[i];}
			} 
			return nm;
		}
		this.setPropertyEx=function(nm,newVal){
			if(nm){
			  nm=nm.toLowerCase();
			  var fnd=false;
			  var i=14;
			  while(!fnd&&item.length>++i&&item[i]){
				var pn;
				try{pn=item[i].substr(1);}catch(ex){;}
				fnd=(pn==nm);
				++i;
			  }
			  if(fnd){item[i]=newVal;}
			}
		}
	}
	else if(this.Type==1) // Button Group
	{
		this.Items=new Array();
		this.Items.fromKey = function (key) {
			for(i=0; i<this.length; i++) {
				if(this[i].Key == key)
					return this[i];
			}
			return null;
		}
		var i=0;
		for(i=1;i<item.length && item[i] && item[i].length && typeof(item[i])!="string";i++)
		{
			var oitem = new igtbar_initItem(tb,item[i],i);
			oitem.i = i - 1;
			this.Items[i-1]=oitem;
			var id=tb.Id+"_Group_"+index+"_"+(i-1).toString();
			oitem.Element=ig_csom.getElementById(id);
			tb.addLsnr(oitem.Element, oitem);
			oitem.Id=id;
			oitem.Parent=this;
			oitem.IsGroupButton=true;
		}
		var selButton=null;
		for(var j=0;j<this.Items.length && !selButton;j++)
			if(this.Items[j].Element&&this.Items[j].Element.id==item[i])
				selButton=this.Items[j];
		this.SelectedButton=selButton;
		this.Selected=item[++i];
		this.Key=item[++i];
		this.Tag=item[++i];
	}
	else
	{
		this.Key=item[1];
		this.Tag=item[2];
		if(this.Type==4) // Textbox
		{
			this.getText=function(){return this.Element.value;}
			this.setText=function(text){if(text != null) this.Element.value = text; this.Toolbar.update(this, "Text", this.Element.value);}
			this.setEnabled=function(v){this.Element.disabled = v != true; this.Toolbar.update(this, "Enabled", v ? "true" : "false");}
			this.getEnabled=function(){return this.Element.disabled != true;}
		}
	}
	this.setTag = function(v){this.Toolbar.update(this, "Tag", this.Tag = v);}
	this.setToolTip = function(v){if(this.Element != null) this.Toolbar.update(this, "ToolTip", this.Element.title = v);}
	this.getToolTip = function(){return (this.Element == null) ? "" : this.Element.title;}
	this.Index=index;
}
function igtbar_getTextElem(e) {
	if(e){
		c=e.childNodes.length;
		for(i=0;i<c;i++){
			var c1 = e.childNodes[i];
			if(c1.getAttribute!=null) {
				var txt = c1.getAttribute("igtxt");
				if(txt!=null && txt.length>0)
					return c1;
			}
		}
	}
	return null;
}
function igtbar_getImageElem(e) {
	if(e){
		c=e.childNodes.length;
		for(i=0;i<c;i++){
			var c1 = e.childNodes[i];
			if(c1.getAttribute!=null) {
				var txt = c1.getAttribute("igimg");
				if(txt!=null && txt.length>0)
					return c1;
			}
		}
	}
	return null;
}
function igtbar_initEvents(events)
{
	this.Click=events[0];
	this.InitializeToolbar=events[1];
	this.MouseOut=events[2];
	this.MouseOver=events[3];
	this.Move = events[4];
}
function igtbar_getItemById(id)
{
	var bName=id.split("_");
	var tb=igtbar_getToolbarById(bName[0]);
	if(tb == null || tb.loading)
		return null;
	for(var i=0;i<tb.Items.length;i++)
	{
		if(tb.Items[i].Element&&tb.Items[i].Element.id==id)
			return tb.Items[i];
		if(tb.Items[i].Items)
		{
			for(var j=0;j<tb.Items[i].Items.length;j++)
				if(tb.Items[i].Items[j].Element&&tb.Items[i].Items[j].Element.id==id)
					return tb.Items[i].Items[j];
		}
	}
	return null;
}
// public: get object from ClientID or UniqueID
function igtbar_getToolbarById(id)
{
	var o = igtbr_state[id];
	if(o != null) return o;
	for(var i in igtbr_state) if((o = igtbr_state[i]) != null) if(o.clientId == id || o.UniqueId == id) return o;
	return null;
}
// Function called when movable graphic image is first clicked.
function igtbar_pickUp(toolbarId, evt)
{
	var oMove = igtbr_state.o_move;
	if(oMove == null) igtbr_state.o_move = oMove = new Object();
	oMove.src = ig_csom.getElementById(toolbarId);
	if(oMove.src == null) return false;
	if(oMove.mouseHooked != true)
	{
		ig_csom.addEventListener(document, "mouseup", igtbar_drop, false);
		ig_csom.addEventListener(document, "mousemove", igtbar_moveMe, false);
		oMove.mouseHooked = true;
	}
	oMove.AllowMove = true;
	oMove.zIndex=oMove.src.style.zIndex;
	evt = window.event;
	if(evt)
	{
		oMove.CurrentX = (evt.clientX + document.body.scrollLeft);
		oMove.CurrentY = (evt.clientY + document.body.scrollTop);
	}
	return true;
}
// Indicates to drop the toolbar.
function igtbar_drop()
{
	var oMove = igtbr_state.o_move;
	if(oMove != null && oMove.AllowMove == true)
	{
		oMove.AllowMove = oMove.CurrentX = null;
		oMove.src.style.zIndex = oMove.zIndex;
	}
	return true;
}
// Occurs when mouse is moved and the mouse has been clicked on the movable graphic image
function igtbar_moveMe(e)
{
	var evt = e ? e : window.event;
	var oMove = igtbr_state.o_move;
	if(oMove == null || oMove.AllowMove == null || evt == null) return;
	// drop on mouse move
	if(window.event != null && evt.button != 1)
	{
		igtbar_drop();
		return;
	}
	var cx,cy,left,top;
	var tb=igtbar_getToolbarById(oMove.src.id);
	oMove.NewX = evt.pageX?evt.pageX:(document.body.scrollLeft+evt.clientX);
	oMove.NewY = evt.pageY?evt.pageY:(document.body.scrollTop+evt.clientY);
	var dX = oMove.CurrentX, dY = oMove.CurrentY;
	if(dX == null) dX = dY = 0;
	else{dX = oMove.NewX - dX; dY = oMove.NewY - dY;}
	oMove.CurrentX = oMove.NewX;
	oMove.CurrentY = oMove.NewY;
	oMove.src.style.zIndex=(tb.OnTop==true?1000:1);
	left=oMove.src.style.left;
	top=oMove.src.style.top;
	cx=(parseInt(left.length>0?left:0)+dX).toString();
	cy=(parseInt(top.length>0?top:0)+dY).toString();
	var eventObj = new ig_EventObject();
	eventObj.event = evt;
	ig_fireEvent(tb, tb.ClientSideEvents.Move, cx, cy, eventObj);
	if(eventObj.cancel) return;
	if(oMove.src.style.position != "absolute")
	{
		cx = cy = 0;
		e = oMove.src;
		while(e != null)
		{
			cx += e.offsetLeft;
			cy += e.offsetTop;
			e = e.offsetParent;
		}
		oMove.src.style.position = "absolute";
	}
	if(cx < 0) cx = 0; if(cy < 0) cy = 0;
	oMove.src.style.left=cx+"px";
	oMove.src.style.top=cy+"px";
	tb.update(null, "Position", cx + "i" + cy);
}
function igtbar_groupButtonDown(button,evnt,enabled,groupID,shouldToggle)
{
	var tbar=button.id.split("_");
	var tb=igtbar_getToolbarById(tbar[0]);
	var group=igtbar_getItemById(groupID);
	var b=igtbar_getItemById(button.id);
	if(!tb||tb.loading||!tb.Enabled||!enabled||!b||!b.Enabled)return;
	var selButton=null;
	if(group.SelectedButton)
		selButton=group.SelectedButton.Element;
	var eventObj=new ig_EventObject();
	eventObj.event=evnt;
	eventObj.needPostBack=tb.PostBackGroup && b.AutoPostBack;
	if(!tb.firedClick){
		tb.firedClick=true;
		ig_fireEvent(tb,tb.ClientSideEvents.Click,b,eventObj);
		tb.firedClick=false;
	}else eventObj.cancel=true;
	if(eventObj.cancel) return;
	if(!(selButton==button&&!shouldToggle))
	{
		if(selButton!=null)
		{
			group.SelectedButton.Selected=false;
			igtbar_EnableItem(selButton,true);
		}
		if(selButton==button)
			group.SelectedButton=null;
		else
		{
			group.SelectedButton=igtbar_getItemById(button.id);
			igtbar_mouseDown(button,evnt,true,group.SelectedButton.ToggleButton);
		}
	}
	var url = b.getTargetUrl();
	var frame = b.getTargetFrame();
	if(url!=null&&url.length>0)
		ig_csom.navigateUrl(url, frame);
	else if(eventObj.needPostBack)
		tb.post(button.id+":GROUP:"+((button==selButton)?"UP":"DOWN"));
}

function igtbar_mouseDown(src,evnt,enabled,toggle)
{
	var tbName=src.id.split("_");
	var tb=igtbar_getToolbarById(tbName[0]);
	if(tb == null || tb.loading || !tb.Enabled || !enabled) return;
	tb.mouseAction=true;
	igtbar_toggleButtonState(src,toggle);
	tb.mouseAction=false;
}

function igtbar_toggleButtonState(item,toggle)
{
	var b=igtbar_getItemById(item.id);
	if(b == null || b.Toolbar.loading) return;
	var tb=b.Toolbar;
	var isDown=b.Selected;
	if(!tb.Enabled) return;
	if(toggle){
		if(isDown==true)
		{
			igtbar_ButtonUp(item,true);
			tb.update(b, "Selected", "false");
		}
		else
		{
			igtbar_SelectItem(item);
			b.Selected=true;
			tb.update(b, "Selected", "true");
		}
		b.needPB = true;
	}
	else
	{
		if(isDown==true)
		{
			igtbar_ButtonUp(item,true);
			if (b.IsGroupButton==true)
			tb.update(b, "Selected", "false");
		}
		else
		{
			igtbar_SelectItem(item);
			b.Selected=true;
			if (b.IsGroupButton==true)
			tb.update(b, "Selected", "true");
		}
	}
}

function igtbar_mouseUp(src,evnt,enabled)
{
	var tbName=src.id.split("_");
	var tb=igtbar_getToolbarById(tbName[0]);
	var b=igtbar_getItemById(src.id);
	if(!tb||tb.loading||!enabled||!tb.Enabled||!b||!b.Enabled)return;
	var eventObj=new ig_EventObject();
	eventObj.event=evnt;
	eventObj.needPostBack=(b.Toolbar.PostBackButton && b.AutoPostBack);
	if(enabled)
		ig_fireEvent(b.Toolbar,b.Toolbar.ClientSideEvents.Click,b,eventObj);

	if(!b.ToggleButton){
		tb.mouseAction=true;
		if(eventObj.cancelPostBack)
			igtbar_ButtonUp(src,enabled,false);
		else
			igtbar_ButtonUp(src,enabled,eventObj.needPostBack);
		tb.mouseAction=false;
	}
	else
	{
		b.Toolbar.update(b, "Selected", b.Selected ? "true" : "false");
		if(b.needPB==true&&eventObj.needPostBack&&!eventObj.cancelPostBack)
			tb.post(b.Id+(b.Selected?":DOWN":":UP"));
		b.needPB=null;
	}
}

function igtbar_ButtonUp(src,enabled,forcePB)
{
	var b=igtbar_getItemById(src.id);
	if(!b||b.Toolbar.loading||!b.Toolbar.Enabled||!b.Enabled||!enabled)return;
	b.Selected=false;
	if(b.Toolbar.mouseAction)
		igtbar_HoverItem(src);
	else igtbar_EnableItem(src,true);
	var url=b.getTargetUrl(),frame=b.getTargetFrame();
	if(url!=null&&url.length>0)
		ig_csom.navigateUrl(url, frame);
	else if(!b.ToggleButton&&(forcePB==true||(forcePB==null&&b.Toolbar.PostBackButton)))
		b.Toolbar.post(src.id+":UP");
}

function igtbar_mouseOut(src,evnt,enabled,toggle)
{
	var tbName=src.id.split("_");
	var tb=igtbar_getToolbarById(tbName[0]);
	var b=igtbar_getItemById(src.id);
	if(!b||!tb||tb.loading||!tb.Enabled||!b.Enabled||!enabled||b.hasMouse==null)return;
	var target = evnt.toElement;
	if(target != null && (target.id == b.Element.id || target.parentNode == b.Element))
		return;
	b.hasMouse = null;
	var isDown=b.Selected;
	var buttonstring=src.id.split("_");
	var isGroupButton=(buttonstring[1]=="Group");	
	var eventObj=new ig_EventObject();
	eventObj.event=evnt;
	ig_fireEvent(b.Toolbar,b.Toolbar.ClientSideEvents.MouseOut,b,eventObj);
	if(eventObj.cancel) return;
	if(!isDown)
		igtbar_EnableItem(src,true);
	//Check if mouseOut occured before buttonUp.  In this case, a normal button's state
	//needs to be reset back to default.
	if(isDown&&!toggle&&!isGroupButton)
	{
		tb.mouseAction=true;
		igtbar_ButtonUp(src,true, false);
		tb.mouseAction=false;
		igtbar_EnableItem(src,true);
	}
	else if(toggle)
	{
		if(!isDown)
			igtbar_EnableItem(src,true);
		else
			igtbar_SelectItem(src);
	}
}
function igtbar_mouseOver(src,evnt, enabled)
{
	var tbName=src.id.split("_");
	var tb=igtbar_getToolbarById(tbName[0]);
	var b=igtbar_getItemById(src.id);
	if(!tb||tb.loading||!b||b.hasMouse||!b.Toolbar.Enabled||!b.Enabled||!enabled)return;
	b.hasMouse = true;
	if(b.Selected)return;
	var eventObj=new ig_EventObject();
	eventObj.event=evnt;
	ig_fireEvent(b.Toolbar,b.Toolbar.ClientSideEvents.MouseOver,b,eventObj);
	if(eventObj.cancel) return;
	igtbar_HoverItem(src);
}

function igtbar_setImage(id,img)
{
	var eItem;
	try{eItem=ig_csom.getElementById(id+"_img");}catch(x){;}
	if(eItem&&img&&img.length&&img.length>0)
		eItem.src=img;
}
function igtbar_SelectItem(item)
{
	var b=igtbar_getItemById(item.id);
	if(b == null) return;
	var style=b.SelectedStyleClassName;
	if(style)
		item.className=style;
	igtbar_setImage(item.id,b.SelectedImage);
}
function igtbar_HoverItem(item)
{
	var b=igtbar_getItemById(item.id);
	if(b == null) return;
	var hovOK=!b.Selected;
	try{hovOK=hovOK||(b.ToggleButton&&b.Enabled)}catch(ex){;}
	if(hovOK)
	{
		var style=b.HoverStyleClassName;
		if(style)
			item.className=style;
		igtbar_setImage(item.id,b.HoverImage);
	}
}
// process events
function igtbar_evt(evt)
{
	if(evt == null) if((evt = window.event) == null) return;
	var src = evt.srcElement;
	if(src == null) return;
	var but = src.owner;
	if(but == null) return;
	if(but.Type == 4){but.setText();return;}
	if(evt.type == "focus") but.ak = 0;
	var down = evt.type == "keydown";
	if(!(down || evt.type == "keyup")) return;
	var a = src.accessKey, k = evt.keyCode;
	if(down){if(but.ak == 1) return; else but.ak = 1;}
	else
	{
		if(but.ak == 2) return;
		if(ig_csom.notEmpty(a) && evt.altKey)
		{
			if(!(but.ak == 0 || a.charCodeAt(0) == k || (k == 186 && a == ";") || (k == 187 && a == "=") || (k == 188 && a == ",") || (k == 189 && a == "-") || (k == 191 && a == "/") || (k == 219 && a == "[") || (k == 221 && a == "]"))) return;
			k = 32;
			down = but.IsGroupButton || but.ToggleButton;
		}
		but.ak = 2;
	}
	if(k == 32)
	{
		if(but.IsGroupButton)
		{
			if(!down) return;
			igtbar_groupButtonDown(src, evt, true, but.Parent.Element.id, but.ToggleButton);
		}
		else
		{
			if(down) igtbar_mouseDown(src, evt, true, but.ToggleButton);
			if(!down || evt.type == "keyup")
			{
				igtbar_mouseUp(src, evt, true);
				if(!but.ToggleButton || !but.Selected) igtbar_EnableItem(src, true);
			}
		}
	}
	else if(down && but.IsGroupButton && (k == 37 || k == 39))
	{
		var i = but.i;
		while(true)
		{
			i += k - 38;
			if(i < 0 || i >= but.Parent.Items.length) return;
			if(but.Parent.Items[i].Enabled) break;
		}
		try{but.Parent.Items[i].Element.focus();}catch(e){}
	}
}
function igtbar_EnableItem(item,bEnabled)
{
	var b=igtbar_getItemById(item.id);
	if(b == null) return;
	var style=b.DefaultStyleClassName;
	if(style)
		item.className=style;
	igtbar_setImage(item.id,(bEnabled)?b.DefaultImage:b.DisabledImage);
}
// DEPRECATED
function igtbar_navigate(targetUrl, targetFrame){ig_csom.navigateUrl(targetUrl, targetFrame);}

function ig_mouseDown(e) 
{
	if(e == null) if((e = window.event) == null) return;
	if(e.preventDefault != null) e.preventDefault();
	e.returnValue = false;
	return false;
}
