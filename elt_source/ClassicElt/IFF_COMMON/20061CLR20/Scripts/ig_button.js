 /*
  * Infragistics WebUI.Shared CSOM Script: ig_button.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

// js-version 5.05
//vs
function igbut_init(id,prop)
{
	if(!ig_WebControl.prototype.isPrototypeOf(ig_WebButton.prototype))ig_WebButton.prototype=new ig_WebControl();
	var o=new ig_WebButton(id,prop);
	o.fireEvt("init");
	o.fireEvt("paint");
}
var igbut_mouse=null,igbut_size=null;
function ig_WebButton(id,prop)
{
	this.constructor(id);
	this.valI=function(o,i){o=(o==null||o.length<=i)?null:o[i];return (o==null)?"":o;}
	this.intI=function(o,i){return ig_shared.isEmpty(o=this.valI(o,i))?-1:parseInt(o);}
	this._evts=["mousemove","mouseover","mouseout","mousedown","mouseup","click","keydown","keyup","focus","blur","select","selectstart"];
	var o,e,j,i=prop.length-1;
	var a=i+((i>6)?2:1);
	this._apps=new Array(a);
	this._last=new Object();
	while(a-->0)
	{
		this._apps[a]=new Object();
		if(a%6==3)continue;
		o=prop[i--].split(";");
		for(j=0;j<o.length-1;j+=2)
		{
			this._apps[a][o[j]]=e=o[j+1];
			if(i%5==2)this._apps[a+1][o[j]]=e;
			if(i%5==1)this._apps[a+2][o[j]]=e;
		}
	}
	if(igbut_mouse==null)
	{
		ig_shared.addEventListener(document.body,"mouseup",igbut_evt);
		ig_shared.addEventListener(window,"mouseup",igbut_evt);
		igbut_mouse=this;
	}
	if((e=ig_shared.getElementById(id)) == null)return;
	
	this._elems=new Array(11);
	this._elems[i=0]=e;
	while(++i<31)if((this._elems[i]=ig_shared.getElementById(id+"__"+i))==null&&i>10)break;
	this._uniqueID=e.name;
	this._clientID=this._id;
	this._txt=e.value;
	var props=prop[0].split(",");
	i=0;
	this._userEvents=new Object();
	o=this.valI(props,i++).split(";");
	for(j=0;j<o.length-1;j+=2)this._userEvents[o[j]]=o[j+1];
	this._autoSubmit=!ig_shared.isEmpty(props[i++]);
	this._display=ig_shared.isEmpty(props[i++])?"block":"inline";
	this._space=this.valI(props,i++);
	this._enter=this.valI(props,i++);
	this._wMax=this.intI(props,i++);
	this._hMax=this.intI(props,i++);
	this._wBdr=this.intI(props,i++);
	this._hBdr=this.intI(props,i++);
	this._validate=ig_shared.notEmpty(props[i++]);
	this._focusable=ig_shared.notEmpty(props[i++]);
	this._disTD=ig_shared.notEmpty(props[i++]);
	this.addLsnr=function(e)
	{
		if(e==null||e.nodeName=="#text"||e.setAttribute==null)return;
		var i=this._evts.length,x=e.tagName=="INPUT";
		
		while(i-->0)if(x==(i>4&&i<10))ig_shared.addEventListener(e,this._evts[i],igbut_evt);
		e.setAttribute("ig_b",this._id);if(x)return;
		e.unselectable="on";i=((x=e.childNodes)==null)?0:x.length;
		while(i-->0)this.addLsnr(x[i]);
	}
	if((e=this._elems[2])==null)e=this._elems[1];
	this._element=e;
	this.addLsnr(e);
	this._w=e.style.width;
	this._h=e.style.height;
	this.getState=function(){return this._state;}
	this.getAutoSubmit=function(){return this._autoSubmit;}
	this.getFocusable=function(){return this._focusable;}
	this.getDisplay=function(){return this._display;}
	this.hasFocus=function(){return this._fcs==true;}
	this.setFocus=function(){try{if(!this._fcs&&this._focusable)this._elems[0].focus();}catch(e){}}
	this.getEnabled=function(){return this._elems[0].disabled!=true;}
	this.setEnabled=function(v){if(this._disTD)this._elems[5].disabled=!v;if(!v)this._key=this._fcs=null;this.update("Enabled",!(this._elems[0].disabled=!v));this.paint(true);}
	this.getVisible=function(){return this._element.style.display!="none";}
	this.setVisible=function(v){this._element.style.display=v?this._display:"none";}
	this.getText=function(){return this._txt;}
	this.setText=function(v){if(ig_shared.setText(this._elems[3],v))this.update("Text",this._txt=v);}
	this.getImageAt=function(i){return this._apps[i]["img"];}
	this.setImageAt=function(v,i,c){this.update("Url",this._apps[i]["img"]=v,i,c);this.paint(true);}
	this.getBackColorAt=function(i){return this._apps[i]["bg"];}
	this.setBackColorAt=function(v,i,c){this.update("BackColor",this._apps[i]["bg"]=v,i,c);this.paint(true);}
	this.getForeColorAt=function(i){return this._apps[i]["clr"];}
	this.setForeColorAt=function(v,i,c){this.update("ForeColor",this._apps[i]["clr"]=v,i,c);this.paint(true);}
	this.getBorderColorAt=function(i){return this._apps[i]["bc"];}
	this.setBorderColorAt=function(v,i,c){this.update("BorderColor",this._apps[i]["bc"]=v,i,c);this.paint(true);}
	this.getRoundedImageAt=function(i){return this._apps[i]["bgi"];}
	this.setRoundedImageAt=function(v,i,c){this.update(null,this._apps[i]["bgi"]=v,i,c);this.paint(true);}
	this.getElementAt=function(i)
	{
		var e=this._elems[i];
		if(e==null&&i==10)try
		{
			e=document.createElement("INPUT");e.type="hidden";
			this._elems[0].form.appendChild(e);
			e.name=this._uniqueID+"__10";e.id=this._id+"__10";e.value="";
			this._elems[10]=e;
		}catch(ex){}
		return e;
	}
	this._checked=0;
	this._state=this._checked+(this.getEnabled()?0:5);
	this.paint=function(e)
	{
		
		var state=this.getEnabled()?0:5,ee=this._elems;
		if(e==false)this._key=this._mouseDown=null;
		if(state==0)state=ig_shared.notEmpty(this._key)?4:(this._mouseIn?(this._mouseDown?4:(this._fcs?3:1)):(this._fcs?2:0));
		if((state+=this._checked)==this._state&&!e)return;
		this._state=state;
		
		var s0=ee[1].style,s1=ee[3],s5=ee[5].style;
		s1=(s1==null)?s0:s1.style;
		var v,a=this._apps[state],a0=this._apps[0];
		for(var i in a0)
		{
			if((v=a[i])==null)v=a0[i];
			if(v==this._last[i])continue;
			this._last[i]=v;
			switch(i)
			{
				case "bg":s5.backgroundColor=v;break;
				case "clr":s1.color=v;break;
				case "bc":s0.borderColor=v;break;
				case "bs":s0.borderStyle=v;break;
				case "bw":s0.borderWidth=v;break;
				case "ff":s1.fontFamily=v;break;
				case "fs":s1.fontSize=v;break;
				case "fb":s1.fontWeight=ig_shared.isEmpty(v)?"":"bold";break;
				case "fi":s1.fontStyle=ig_shared.isEmpty(v)?"":"italic";break;
				case "td":s1.textDecoration=v;break;
				case "bgi":for(var j=5;j<9;j++)if((e=ee[j])!=null)e.style.backgroundImage="url("+v+")";break;
				case "img":if((e=ee[4])!=null)e.src=v;break;
				case "cn":ee[1].className=v;if((e=ee[3])!=null)e.className=v;if((e=ee[9])!=null)e.className=v;break;
				case "filter":s0.filter=v;break;
				case "ls":s1.letterSpacing=v;break;
				case "wm":s1.writingMode=v;break;
				case "pd":s5.padding=v;break;
				case "ibc":s5.borderColor=v;break;
				case "ibs":s5.borderStyle=v;break;
				case "ibw":s5.borderWidth=v;break;
				default:if(i.charAt(0)=="x")
				{ee[i=parseInt(i.substring(1))].bgColor=v;if(i==19||i==22||i==25||i==28)ee[i+1].bgColor=ee[i+2].bgColor=v;}break;
			}
		}
		this.fireEvt("paint");
	}
	this.doMouse=function(e,a,s)
	{
		
		var mi=true,e0=this._elems[2];if(e0==null)e0=this._elems[1];
		if(a==2)mi=ig_shared.isInside(e,e0,this._elems[1],(s.id==this._id+"__2")?50:0);
		if(a==4){s=igbut_fromElem(s);mi=s!=null&&s._id==this._id;}
		if(a<2&&this._mouseDown&&!this._mouseIn){if(e.button!=1)this._mouseDown=a==1;if(a==1)return;}
		
		if(this._mouseIn!=mi)this.fireEvt(mi?"mi":"mo",e);
		this._mouseIn=mi;
		if(a>=3){this._key=null;if(e.button>1)return;this._mouseDown=a==3;}
		if(a==3){igbut_mouse=this;this.setFocus();}
		if(a==4&&mi)this.click(e,a,"0");
	}
	this.doEvt=function(e,t,s)
	{
		
		var v,a=10;
		while(a-->0)if(this._evts[a]==t)break;
		if(a<4)ig_cancelEvent(e);if(a<0)return;
		if(a==5)this.click(e,a);
		else
		{
			var cancel=this.fireEvt(t,e,a);
			if(!this.getEnabled())return;
			if(a<5)this.doMouse(e,a,s);
			
			if(a==8){this._fcs=true;if(e.altKey&&!e.ctrlKey&&!this._mouseDown)this._key="3";}
			if(a==9){this._mouseDown=this._mouseIn;this._fcs=this._key=null;}
			if(a==6)
			{
				v=e.keyCode;this._key=null;
				if(v==13||v==32)
				{
					this._key=(v==13)?this._enter:this._space;
					if(this._key.length==0)cancel=true;
				}
				if(cancel)ig_cancelEvent(e);
			}
			if(a==7&&e.keyCode!=32)this._key=null;
		}
		this.paint();
	}
	this.fireEvt=function(id,evnt,a,v)
	{
		if(ig_shared.isEmpty(id=this._userEvents[id]))return false;
		var evt=new ig_EventObject();
		evt.event=evnt;evt.action=v;
		ig_fireEvent(this,id,evt);
		if(evt.cancel||(evt.cancelPostBack&&a==5)){ig_cancelEvent(evnt);return true;}
		if(evt.needPostBack&&!this.posted())if(this.doValid())
		{
			try{this._post=new Date();__doPostBack(this._uniqueID,"4");}catch(ex){}
			return true;
		}
		return false;
	}
	this.posted=function(){return this._post&&(new Date()).getTime()<this._post.getTime()+300;}
	this.click=function(e,a,v)
	{
		if(!this.getEnabled())return;
		if(a==5)v=(e.altKey||this._key==null)?(this._key="3"):this._key;
		if(window.setTimeout&&(v=="2"||v=="3")){igbut_mouse=this;window.setTimeout("try{igbut_mouse.paint(false);}catch(e){}",100);}
		else this._key=null;
		if(this.posted()||v===""){ig_cancelEvent(e);return;}
		if(v==null)v="0";
		if(this.fireEvt("c",e,a,v))return;
		if(this._autoSubmit)if(this.doValid((a==5)?e:null))
		{
			this.update(v);this._post=new Date();
			if(a!=5)try{__doPostBack(this._uniqueID,v);}catch(ex){}
		}
	}
	this.doValid=function(e)
	{
		if(this._validate&&(typeof Page_ClientValidate =="function"))
			try{var ret=Page_ClientValidate();Page_BlockSubmit=false;if(!ret&&e)ig_cancelEvent(e);return ret;}catch(ex){}
		return true;
	}
	this.update=function(p,v,i,client)
	{
		var e=this.getElementAt(10);
		if(e==null||client)return;
		if(v==null){e.value=":"+p+e.value;return;}
		if(this._vs==null)this._vs=new ig_xmlNode();
		var s="U",n=this._vs.addNode("x",true),ss=["","Hover","Focus","Hover","Pressed","Disabled"];
		if(i!=null)
		{
			if(v.indexOf(" ")>=0)return;
			ss=ss[i%6];
			if(p==null){p=ss+"ImageUrl";ss="RoundedCorners";}
			else{ss+="Appearance";s=p.charAt(0);}
			if(i>5)ss="Checked"+ss;
			n=n.addNode(ss);if(s!="U")n=n.addNode("Style");
		}
		n.setPropertyValue(p,""+v);
		e.value=this._vs.getText();
	}
	this.but_size=function()
	{
		var e=this._elems[1];var s=e.style,h=e.offsetHeight,s5=this._elems[5].style;
		if(this._h.length>0&&s.height!=this._h&&h<=this._hMax&&h>5)s.height=this._h;
		if(this._w.length>0&&s.width!=this._w&&e.offsetWidth<=this._wMax)s.width=this._w;
		if(this._wMax>0&&e.offsetWidth>this._wMax){if(s.tableLayout!="fixed")s.tableLayout="fixed";s.width=this._wMax;}
		if(this._hMax>0&&e.offsetHeight>this._hMax)s.height=this._hMax;
		if(this._wBdr>=0){s.width=e.offsetWidth;s5.width=e.offsetWidth-this._wBdr;this._wBdr=this._wMax=-1;}
		if(this._hBdr>=0&&(h=e.offsetHeight)>5){s.height=h;s5.height=e.offsetHeight-this._hBdr;this._hBdr=this._hMax=-1;}
	}
	if((this._wMax<=0||this._w.length<1)&&(this._hMax<=0||this._h.length<1))return;
	if((o=igbut_size)==null){igbut_size=o=new Array();ig_shared.addEventListener(window,"resize",igbut_evt);}
	while((e=e.parentNode)!=null)
	{
		if(e.ig_id!=null){e.ig_id="";break;}
		if((i=e.tagName)!="TABLE"&&i!="TD"&&i!="DIV")continue;
		ig_shared.addEventListener(e,"resize",igbut_evt);
		a=new Object();e.ig_id=id;a.e=e;o[o.length]=a;
	}
}
function igbut_fromElem(e)
{
	var id="",i=0;
	while(e!=null&&ig_shared.isEmpty(id))
	{
		try{if(e.getAttribute!=null)id=e.getAttribute("ig_b");}catch(ex){}
		if(++i>2)return null;
		e=e.parentNode;
	}
	return ig_getWebControlById(id);
}
function igbut_evt(e)
{
	if(e==null)if((e=window.event)==null)return;
	var t=e.type,o=igbut_mouse,r=igbut_size,s=e.srcElement;
	if(s==null)s=e.target;
	if(t=="mouseup"){if(o!=null&&o._mouseDown)o.doEvt(e,t,s);return;}
	if(t=="resize"||e==0)
	{
		var i=0,j=(e==0||r==null)?0:r.length;
		while(j-->0)
		{
			var w=r[j].e.offsetWidth,h=r[j].e.offsetHeight;
			if(r[j].w!=w||r[j].h!=h){i++;r[j].w=w;r[j].h=h;}
		}
		if(i>0){if(s!=null&&ig_shared.notEmpty(i=s.ig_id)){ig_all[i].but_size();return;}s=null;}
		if(s==null)for(i in ig_all)if(ig_all[i].but_size!=null)ig_all[i].but_size();
		return;
	}
	if((o=igbut_fromElem(s))==null)o=igbut_fromElem(this);
	if(o!=null&&o.doEvt!=null)o.doEvt(e,t,s);
}
