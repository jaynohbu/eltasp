 /*
  * Infragistics WebCalendar CSOM Script: ig_webdropdown.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

//js version 5.35
function igdrp_getUniqueId(comboName)
{
	var combo=igdrp_getComboById(comboName);
	return (combo==null)?null:combo.UniqueId;
}
function igdrp_getElementById(id){return ig_csom.getElementById(id);}
function igdrp_getComboById(id,e)
{
	var o=null,i=0;
	while(e!=null&&ig_csom.isEmpty(id))
	{
		try{if(e.getAttribute!=null)id=e.getAttribute("ig_drp");}catch(ex){}
		if(++i>6)return null;
		e=e.parentNode;
	}
	if(!ig_csom.isEmpty(id))if((e=igdrp_all)!=null)if((o=e[igdrp_comboIdById(id)])==null)
		for(i in e){if((o=e[i])!=null)if(o.Id==id||o.ClientUniqueId==id||o.UniqueId==id)break;else o=null;}
	return o;
}
function igdrp_getComboByItem(item){return igdrp_all[igdrp_comboIdById(item.id)];}
function igdrp_comboIdById(itemId){return itemId.split("_")[0];}
function igdrp_fireEvent(oCombo,eventName,param)
{
	var oEvent=new ig_EventObject();
	ig_fireEvent(oCombo,eventName,param,oEvent);
	return oEvent;
}
if(typeof igdrp_all!="object")
	var igdrp_all=new Object();
function igdrp_evt(e)
{
	if(e==null)if((e=window.event)==null)return;
	var o,t=e.type,src=e.srcElement;
	if(t=="unload"){for(o in igdrp_all)if(!ig_csom.getElementById(o))igdrp_all[o]=null;ig_dispose(igdrp_all);return;}
	if(src==null)if((src=e.target)==null)src=this;
	if((o=igdrp_getComboById(null,src))!=null)if(o.doEvt)o.doEvt(e,t,src);
}
function igdrp_combo(elem,props,ce)
{
	this.Id=elem.id;
	igdrp_all[this.Id]=this;
	this.Element=elem;
	elem.setAttribute("ig_drp",this.Id);
	ig_csom.addEventListener(elem,"mousedown",igdrp_evt);
	ig_csom.addEventListener(elem,"mouseup",igdrp_evt);
	ig_csom.addEventListener(elem,"mouseout",igdrp_evt);
	ig_csom.addEventListener(elem,"mouseover",igdrp_evt);
	if(!ig_csom._dc_load)
	{
		ig_csom.addEventListener(window,"unload",igdrp_evt);
		ig_csom.addEventListener(document,"mousedown",igdrp_mouseDown);
		if(document.captureEvent)document.captureEvent(Event.MOUSEDOWN);
		ig_csom._dc_load=true;
	}
	this.Element.Object=this;
	this.UniqueId=props[0];
	var o=new Object(),p=props[1];
	o.ImageUrl1=p[0];o.ImageUrl2=p[1];o.DefaultStyleClassName=p[2];o.HoverStyleClassName=p[3];
	this.DropButton=o;
	this.EditStyleClassName=props[3];
	this.DropDownStyleClassName=props[4];
	this.HideDropDowns=props[5];
	this.editable=props[6];
	this.readOnly=props[7]
	this.dropDownAlignment=props[8];
	this.getDropDownAlignment=function(){return this.dropDownAlignment;}
	this.setDropDownAlignment=function(v){this.update("DropDownAlignment",this.dropDownAlignment=v);}
	this.autoCloseUp=props[9];
	this.Dropped=props[10];
	this.getAutoCloseUp=function(){return this.autoCloseUp;}
	this.setAutoCloseUp=function(v){this.update("AutoCloseUp",this.autoCloseUp=v);}
	this.isEnabled=function(){return !this.inputBox.disabled;}
	this.setEnabled=function(v){this.inputBox.disabled=!v;this.update("Enabled",v);}
	this.ClientUniqueId=this.UniqueId.replace(/:/gi,"x").replace(/_/gi,"x");
	var box=this.inputBox=igdrp_getElementById(this.ClientUniqueId+"_input");
	var h=box.offsetHeight;
	if(h<8)if((h=box.parentNode.offsetHeight)>7)box.style.height=h+"px";
	this.DropButton.Image=igdrp_getElementById(this.ClientUniqueId+"_img");
	this.postField=igdrp_getElementById(this.UniqueId+"_hidden");
	this.elemCal=this.container=igdrp_getElementById(this.ClientUniqueId+"_container");
	this.ForeColor=box.style.color;
	this.BackColor=box.style.backgroundColor;
	this.Events=o=new Object();
	o.InitializeDateChooser=o.InitializeCombo=ce[0];o.BeforeDropDown=ce[1];o.AfterDropDown=ce[2];o.BeforeCloseUp=ce[3];o.AfterCloseUp=ce[4];
	o.EditKeyDown=ce[5];o.EditKeyUp=ce[6];o.ValueChanged=ce[7];o.TextChanged=ce[8];o.OnBlur=ce[9];o.InvalidDateEntered=ce[10];
	this.Loaded=false;
	this.focus=function(){try{this.inputBox.focus();}catch(e){}}
	this.hasFocus=function(){return this.editor.foc;}
	this.isEditable=function(){return this.editable;}
	this.setEditable=function(v)
	{
		this.editable=(v=(v==true));
		this.inputBox.readOnly=v?this.isReadOnly():v;
		this.update("Editable",v);
	}
	this.isReadOnly=function(){return this.readOnly;}
	this.setReadOnly=function(v)
	{
		this.readOnly=(v=(v==true));
		this.inputBox.readOnly=v?v:!this.isEditable();
		this.update("ReadOnly",v);
	}
	this.getText=function(){return this.inputBox.value;}
	this.update=function(p,v,ee)
	{
		if(!this.postField)return;
		if(!this.viewState)this.viewState=new ig_xmlNode();
		var n=this.viewState.addNode("DateChooser",true);
		if(ee)n=n.addNode("ExpandEffects",true);
		if(v==null)v="";
		else if(v.getFullYear)v=v.getFullYear()+'x'+(v.getMonth()+1)+'x'+v.getDate();
		n.setPropertyValue(p,v);
		this.postField.value=this.viewState.getText();
	}
	this.isDropDownVisible=function(){return this.Dropped&&igdrp_all._droped==this;}
	this.move=function(e,par){try{ig_csom._skipNew=true;e.parentNode.removeChild(e);par.appendChild(e);ig_csom._skipNew=false;return true;}catch(ex){}return false;}
	this.setDropDownVisible=function(bDrop)
	{
		var evt,tPan=this.transPanel,pan=this.container,edit=this.Element;
		if(pan==null||this.isReadOnly()||this.Dropped==bDrop)return;
		if(bDrop)
		{
			evt=igdrp_fireEvent(this,this.Events.BeforeDropDown[0],pan);
			if(evt.cancel){delete evt;return;}
			this.focus();
			if(this.Calendar)this.Calendar.setSelectedDate(this.getValue());
			var editH=edit.offsetHeight,editW=edit.offsetWidth,e=edit,x=pan.parentNode,body=window.document.body;
			if(editH==null)editH=20;
			var f=x.tagName,bp=body.parentNode,par=this.inputBox.form;
			if(f=="FORM"){par=null;if(x.style)if((f=x.style.position)!=null)if(f.toLowerCase()=="absolute")par=body;}
			else if(f=="BODY"||f=="HTML")par=null;
			if(par)if(!this.move(pan,par))if(par!=body)this.move(pan,body);
			this.ExpandEffects.applyFilter();
			pan.style.visibility="visible";pan.style.display="";
			if(pan.offsetHeight<5&&par&&par!=body)this.move(pan,body);
			var panH=pan.offsetHeight,panW=pan.offsetWidth,z=this.elemCal;
			x=z.offsetHeight;if(panH<x||panH>x+8)pan.style.height=(panH=x)+"px";
			x=z.offsetWidth;if(panW<x||panW>x+8)pan.style.width=(panW=x)+"px";
			if(tPan==null&&this.HideDropDowns&&ig_csom.IsIEWin)
			{	
				this.transPanel=tPan=ig_csom.createTransparentPanel();
				if(tPan){tPan.Element.style.zIndex=10002;}
			}
			pan.style.zIndex=10003;
			var ok=0,pe=e,y=0;x=0;
			while(e!=null)
			{
				if(ok<1||e==body){if((z=e.offsetLeft)!=null)x+=z;if((z=e.offsetTop)!=null)y+=z;}
				if(e.nodeName=="HTML")body=e;if(e==body)break;
				z=e.scrollLeft;if(z==null||z==0)z=pe.scrollLeft;if(z!=null&&z>0)x-=z;
				z=e.scrollTop;if(z==null||z==0)z=pe.scrollTop;if(z!=null&&z>0)y-=z;
				pe=e.parentNode;e=e.offsetParent;if(pe.tagName=="TR")pe=e;
				if(e==body&&pe.tagName=="DIV"){e=pe;ok++;}
			}
			if(document.elementFromPoint)
			{
				var xOld=x,yOld=y;ok=true;
				var i=1,x0=body.scrollLeft,y0=body.scrollTop,ed=this.inputBox;
				while(++i<16)
				{
					z=(i>2)?((i&2)-1)*(i&14)/2*5:2;
					e=document.elementFromPoint(x+z-x0,y+z-y0);
					if(!e||e==ed||e==edit)break;
				}
				if(i>15||!e)ok=false;
				x+=z;y+=z;i=0;z=0;
				while(ok&&++i<22)
				{
					if(z==0)x--;else y--;
					e=document.elementFromPoint(x-x0,y-y0);
					if(!e||i>20)ok=false;
					if(e!=ed&&e!=edit)if(z>0)break;else{i=z=1;x++;}
				}
				if(ok){x--;y--;}else{x=xOld;y=yOld;}
			}
			y+=editH;
			if((z=this.dropDownAlignment)==1)x-=(panW-editW)/2;
			else if(z==2)x-=panW-editW;
			z=body.clientHeight;
			if(z==null||z<20){z=pe.offsetHeight;f=body.offsetHeight;if(f>z)z=f;}
			else{if(bp&&(f=bp.offsetHeight)!=null)if(f>panH&&f<z)z=f-10;}
			if((f=body.scrollTop)==null)f=0;if(f==0&&bp)if((f=bp.scrollTop)==null)f=0;
			if(z<y-f+panH){if(y-f-3>panH+editH)y-=panH+editH;else y=z+f-panH;}if(y<f)y=f;
			z=body.clientWidth;
			if(z==null||z<20){z=pe.offsetWidth;f=body.offsetWidth;if(f>z)z=f;}
			else{if(bp&&(f=bp.offsetWidth)!=null)if(f>panW&&f<z)z=f-20;}
			if((f=body.scrollLeft)==null)f=0;if(f==0&&bp)if((f=bp.scrollLeft)==null)f=0;
			if(x+panW>z+f)x=z+f-panW;if(x<f)x=f;
			if(ig_csom.IsMac&&(ig_csom.IsIE||ig_csom.IsSafari)){x+=ig_csom.IsIE?5:-5;y+=ig_csom.IsIE?11:-7;}
			pan.style.left=x+"px";
			pan.style.top=y+"px";
			this.ExpandEffects.applyFilter(true);
			if(tPan!=null){tPan.setPosition(y-1,x-1,panW+2,panH+2);tPan.show();}
			this.Dropped=true;
			igdrp_all._droped=this;
			igdrp_fireEvent(this,this.Events.AfterDropDown[0],pan);
			if(this.Calendar)this.Calendar._focus();
		}
		else 
		{
			if((evt=this.editor)!=null)if((evt=evt.elem.Validators)!=null)
				for(var i=0;i<evt.length;i++)try{ValidatorValidate(evt[i]);}catch(ex){}
			evt=igdrp_fireEvent(this,this.Events.BeforeCloseUp[0],pan);
			if(evt.cancel){delete evt;return;}
			pan.style.visibility="hidden";
			pan.style.display="none";
			if(tPan!=null)tPan.hide();
			this.Dropped=false;
			igdrp_all._droped=null;
			igdrp_fireEvent(this,this.Events.AfterCloseUp[0],pan);
			evt=null;
			if(this.changed){this.changed=false;this.updateValue();}
		}
		this.update("ShowDropDown",bDrop);
	}
	this.getVisible=function(){return (this.Element.style.display!="none"&&this.Element.style.visibility!="hidden");}
	this.setVisible=function(show,left,top,width,height)
	{
		var w=width,h=height,bdr=-1,e=this.Element,im=this.DropButton.Image,edit=this.inputBox;
		var s=e.style,t=edit.value;
		if(show)edit.value="";else this.setDropDownVisible(false);
		s.display=show?"":"none";
		s.visibility=show?"visible":"hidden";
		if(show)
		{
			if(top){s.position="absolute";s.top=top+"px";s.left=left+"px";}
			if(e.clientWidth)bdr=e.offsetWidth-e.clientWidth;
			if(!(bdr>=0&&bdr<7))bdr=s.borderWidth*2;if(!(bdr>=0&&bdr<7))bdr=0;
			var iw=im.offsetWidth;if(ig_csom.isEmpty(im.style.width))this.imW=im.style.width=iw+"px";
			if(h){if((h-=bdr)<1)h=1;if(ig_csom.isEmpty(im.style.height))this.imH=im.style.height=h+"px";edit.style.height=h+"px";s.height=height+"px";}
			if(w){if((w-=iw+bdr)<1)w=1;edit.style.width=w+"px";s.width=width+"px";if(edit.runtimeStyle)edit.runtimeStyle.width=w+"px";}
			this.focus();
			this.inputBox.value=t;
			this.setFocusTop();
		}
		else if(this.imH)im.style.height="";
	}
	this.setFocusTop=function(){this.inputBox.select();this.focus();}
	this.updateValue=function(noFire)
	{
		var v=this.editor?this.editor.getDate():null;
		if(this.old===v)return;
		this.old=v;
		this.update("Value",v);
		if(noFire)return;
		var evt=igdrp_fireEvent(this,this.Events.ValueChanged[0],this.getValue());
		if((evt.needPostBack||this.Events.ValueChanged[1])&&!evt.cancelPostBack)
		{
			if(this.getAutoCloseUp())this.setDropDownVisible(false);
			if(this.post&&(new Date()).getTime()<this.post.getTime()+300)return;
			try{this.post=new Date();__doPostBack(this.UniqueId,"ValueChanged:"+this.editor.text);}catch(e){}
		}
		delete evt;
	}
	this.ExpandEffects=new igdrp_expandEffects(this,props[2]);
	this.onImgKeyDown=function(e)
	{
		var me=igdrp_getComboById(e.srcElement.parentElement.parentElement.parentElement.parentElement.id);
		if(!me||!me.Loaded)return;
		var keyCode=(e.keyCode);
		var bOpening=false;
		if(keyCode==40||(!me.Dropped&&(keyCode==32||keyCode==13)))
			bOpening=true;
		else if(keyCode==27||(me.Dropped&&(keyCode==32||keyCode==13)))
			bOpening=false;
		else return;
		if(bOpening)me.setDropDownVisible(true);
		else
		{
			me.setDropDownVisible(false);
			me.updateValue();
		}
	}
	this.onKeyDown=function(oEditor,value,oEvent)
	{
		var me=oEditor.parent,evnt=oEvent.event;
		if(!me.Loaded)return;
		var keyCode=evnt.keyCode;
		switch(keyCode)
		{
			case 40://DownArrow
				if(evnt.altKey){me.setDropDownVisible(true);return false;}break;
			case 27:case 13:me.setDropDownVisible(false);me.updateValue();break;
		}
    	ig_fireEvent(me,me.Events.EditKeyDown[0],keyCode,oEvent);
 		me.fireMulticastEvent("keydown",oEvent);
    	if(oEvent.cancel)ig_cancelEvent(evnt);
	}
	this.onKeyUp=function(oEditor,value,oEvent)
	{
		var me=oEditor.parent;
		if(me.Loaded)ig_fireEvent(me,me.Events.EditKeyUp[0],oEvent.event.keyCode,oEvent);
	}
	this.onBlur=function(oEditor,value,oEvent)
	{
		var me=oEditor.parent;
		if(!me.Loaded)return;		
		if(oEditor.changed)if(me.Dropped)me.changed=true;else me.updateValue();
		if(!me.Dropped)
		{
			if(me.endEditCell!=null)me.endEditCell();
			ig_fireEvent(me,me.Events.OnBlur[0],me,oEvent);
			me.fireMulticastEvent("blur",oEvent);
		}
	}
	if(this.Dropped)try{window.setTimeout("try{igdrp_all[\""+this.Id+"\"].setDropDownVisible(true);}catch(ex){}",100);}catch(ex){}
	this.Dropped=false;
	this.handlers=new Array();
	this.removeEventListener=function(name,fref)
	{
		name=name.toLowerCase();
		if(this.handlers==null)return;
		if(this.handlers[name]==null||!(this.handlers[name].length))return;
		for(i=0;i<this.handlers[name].length;i++)
		{
			var listener=this.handlers[name][i];
			if(listener!=null)if(listener.handler==fref)this.handlers[name][i]=null;
		}
	}
	this.addEventListener=function(name,fref,obj)
	{
		var a=this.handlers[name=name.toLowerCase()];
		if(a==null)this.handlers[name]=a=new Array();
		var eh=a[a.length]=new Object();eh.handler=fref;eh.obj=obj;
	}
	this.fireMulticastEvent=function(name,evt)
	{
		var list=this.handlers[name.toLowerCase()];
		if(ig_csom.notEmpty(list))for(var i=0;i<list.length;i++)
			if(list[i]!=null)list[i].handler(this,evt,list[i].obj);
	}
	this.swapImage=function(imageNo){this.DropButton.Image.src=(imageNo==1?this.DropButton.ImageUrl1:this.DropButton.ImageUrl2);}
	this.doMousedown=function(evt,src)
	{
		var hide=igdrp_all._droped!=null,foc=igdrp_all._droped===this;
		if(hide)igdrp_all._droped.setDropDownVisible(false);
		if(foc){try{igdrp_all._old=this;window.setTimeout("try{igdrp_all._old.setFocusTop();}catch(e){}",10);}catch(e){}}
		else if(src.id==this.Id+"_img"||!this.isEditable()){this.swapImage(2);this.setDropDownVisible(true);}
		if(src!=this.inputBox)ig_cancelEvent(evt);
	}
	this.doEvt=function(evt,type,src)
	{
		if(type=="resize")this.inputBox.style.width="100%";
		else if(this.isEnabled()&&this.Loaded&&!this.isReadOnly())switch(type)
		{
			case "mousedown":this.doMousedown(evt,src);return;
			case "mouseup":this.swapImage(1);return;
			case "mouseout":this.DropButton.Image.className=this.DropButton.DefaultStyleClassName;if(this.Dropped)this.swapImage(1);return;
			case "mouseover":this.DropButton.Image.className=this.DropButton.HoverStyleClassName;return;
		}
	}
}
function igdrp_expandEffects(owner,props)
{
	this.owner=owner;
	this.Element=owner.container;
	this.duration=props[0];
	this.opacity=props[1];
	this.type=props[2];
	this.color=props[3];
	this.shadow=props[4];
	this.delay=props[5];
	this.getDuration=function(){return this.duration;}
	this.getOpacity=function(){return this.opacity;}
	this.getType=function(){return this.type;}
	this.getShadowColor=function(){return this.color;}
	this.getShadowWidth=function(){return this.shadow;}
	this.getDelay=function(){return this.delay;}
	this.setDuration=function(v){this.owner.update("Duration",this.duration=v,true);}
	this.setOpacity=function(v){this.owner.update("Opacity",this.opacity=v,true);}
	this.setType=function(v){this.owner.update("Type",this.type=v,true);}
	this.setShadowColor=function(v){this.owner.update("ShadowColor",this.color=v,true);}
	this.setShadowWidth=function(v){this.owner.update("ShadowWidth",this.shadow=v,true);}
	this.setDelay=function(v){this.owner.update("Delay",this.delay=v,true);}
	this.applyFilter=function(p)
	{
		var e=this.Element;
		if(!e||!ig_csom.IsIEWin||ig_csom.AgentName.indexOf("win98")>0||ig_csom.AgentName.indexOf("windows 98")>0)return;
		var s=e.style,ms="progid:DXImageTransform.Microsoft.";
		if(!p&&this.type!="NotSet")s.filter=ms+this.type+"(duration="+(this.duration/1000)+")";
		if(!p&&this.shadow>0)s.filter+=" "+ms+"Shadow(Direction=135,Strength="+this.shadow+",color='"+this.color+"')";
		if(!p)
		{
			var pe=e,o=this.opacity;if(o>100)o=100;
			while(o<0&&(pe=pe.parentNode)!=null)if(pe.filters)o=100;
			if(o>=0)s.filter+=" "+"Alpha(Opacity="+o+")";
		}
		if(e.filters[0])try{if(p)e.filters[0].play();else e.filters[0].apply();}catch(ex){}
	}
}
function igdrp_mouseDown(evnt)
{
	if(!evnt)evnt=window.event;
	if(!evnt||igdrp_all._droped==null)return;
	var e=evnt.srcElement,container=igdrp_all._droped.ClientUniqueId+"_container";
	if(e==null)if((e=evnt.target)==null)e=this;
	while(e!=null){if(e.id==container)return;e=e.parentNode;}
	igdrp_all._droped.setDropDownVisible(false);
}
function igdc_dateChooser(elem,prop,df,ce,calID)
{
	var me=new igdrp_combo(elem,prop,ce);
	var info=new Object();
	info.DayNames=df[0];info.AbbreviatedDayNames=df[1];info.MonthNames=df[2];info.AbbreviatedMonthNames=df[3];
	info.ShortDatePattern=df[4];info.LongDatePattern=df[5];info.DateSeparator=df[6];info.MonthDayPattern=df[7];info.YearMonthPattern=df[8];
	df=prop[11];
	var box=me.inputBox,date=ig_csom.isEmpty(df)?null:new Date(df[0],df[1]-1,df[2]);
	var editor=new igmask_date(box,info,date,prop[15]!=0,prop[14],prop[16]);
	if(!ig_csom.isEmpty(df=prop[12]))editor.min=new Date(df[0],df[1]-1,df[2]);
	if(!ig_csom.isEmpty(df=prop[13]))editor.max=new Date(df[0],df[1]-1,df[2]);
	editor.parent=me;
	var tab=prop[17];
	if(tab&&tab>-1)editor.elem.tabIndex=me.DropButton.Image.tabIndex=tab;
	editor.addEventHandler("keydown",me.onKeyDown);
	editor.addEventHandler("keyup",me.onKeyUp);
	editor.addEventHandler("blur",me.onBlur);
	if(document.all!=null)ig_csom.addEventListener(me.Element,"resize",igdrp_evt);
	ig_csom.addEventListener(me.DropButton.Image,'keypress',me.onImgKeyDown);
	me.getAllowNull=function(){return this.editor.allowNull;}
	me.setAllowNull=function(bAllowNull){this.editor.allowNull=bAllowNull;}
	me.onInvalidValue=function(o,val,oEvent,oEventArgs){if((o=o.parent)!=null)ig_fireEvent(o,o.Events.InvalidDateEntered[0],oEventArgs,oEvent);}
	editor.addEventHandler("invalidvalue",me.onInvalidValue);
	me.onTextChange=function(o,val,oEvent){if((o=o.parent)!=null)ig_fireEvent(o,o.Events.TextChanged[0],val,oEvent);}
	editor.addEventHandler("x",me.onTextChange);
	me.editor=editor;
	me.setMaxDate=function(d)
	{
		if(this.Calendar)this.Calendar.MaxDate=d;
		this.update("MaxDate",this.editor.max=d);
	}
	me.getMaxDate=function(){return this.editor.max;}
	me.setMinDate=function(d)
	{
		if(this.Calendar)this.Calendar.MinDate=d;
		this.update("MinDate",this.editor.min=d);
	}
	me.getMinDate=function(){return this.editor.min;}
	me.getNullDateLabel=function(){return this.editor.nullText;}
	me.setNullDateLabel=function(v){this.update("NullDateLabel",this.editor.nullText=v);}
	me.showCalendar=function(){this.setDropDownVisible(true);}
	me.hideCalendar=function(){this.setDropDownVisible(false);}
	me.onDateSelected=function(cal,date)
	{
		var me=cal.ownerDC;
		if(!me.Dropped)return;
		me.setValue(date,true);
		if(me.getAutoCloseUp())me.setDropDownVisible(false,true);
		if(!me.isEditable()|| me.getAutoCloseUp())me.setFocusTop();
	}
	me.setValue=function(d,fire){this.editor.setDate(d);this.updateValue(!fire);}
	me.setText=function(v,fire){this.editor.setText(v);this.updateValue(!fire);}
	me.getValue=function(){return this.editor.getDate();}
	me.getRenderedValue=function(v){return this.editor.staticText(v,true);}
	try{var v=document.createElement("INPUT");v.type="hidden";me._msV=v;if(date)v.value=me.getRenderedValue(date);box.parentNode.insertBefore(v,box);}catch(e){}
	var cal=me.Calendar=ig_csom.isEmpty(calID)?null:igcal_getCalendarById(calID);
	if(cal!=null){cal.ownerDC=me;cal.onValueChanged=me.onDateSelected;me.elemCal=cal.element;editor.yearFix=cal.yearFix;}
	ig_fireEvent(me,me.Events.InitializeDateChooser[0],me,me.Id);
	me.Loaded=true;
	return me;
}
function igdc_initDateChooser(id,p,df,ce,calID){return igdc_dateChooser(ig_csom.getElementById(id),p,df,ce,calID);}
//<INPUT>,info,date,longFormat
function igmask_date(e,di,v,lf,nullTxt,nullable)
{
	if(e==null)return;
	this.changed=false;
	this.extra=new Object();
	this.nullText=nullTxt;
	this.allowNull=nullable;
	this.repaint0=function(fire)
	{
		if((this.k0==null)||(this.changed&&this.elem.value==this.text))return;
		this.elem.value=this.text;
		if(!fire)return;
		this.changed=true;
		this.fireEvt(10,null);
	}
	var id=e.id;
	ig_csom.addEventListener(e,"keydown",igmask_event,false);
	ig_csom.addEventListener(e,"keypress",igmask_event,false);
	ig_csom.addEventListener(e,"keyup",igmask_event,false);
	ig_csom.addEventListener(e,"focus",igmask_event,false);
	ig_csom.addEventListener(e,"blur",igmask_event,false);
	this.id=id;
	e.setAttribute("maskID",id);
	this.elem=e;
	if(e.createTextRange!=null)this.tr=e.createTextRange();
	this.k1=0;
	this.fixKey=this.yearFix=0;//not gregorian
	this.useLastGoodValue=true;
	this.delta=1;
	this.doKey=function(e,a)
	{
		if(a==1&&(e.ctrlKey||e.altKey))return;
		var k=e.keyCode;
		if(k==0||k==null)if((k=e.which)==null)return;
		if(k<32&&k!=8)return;
		if(a==1)this.k1=k;
		var t0=this.text,t1=this.elem.value;
		var i=t1.length;
		if(a==2)
		{
			this.k1=0;
			if(this.k0<32)return;
			if(t0!=t1)
			{
				this.changed=true;
				if(this.fixKey>0||i==1)this.afterKey(k,this.fixKey++==1);
				else if(this.fixKey==0)if(i--==0){this.fixKey=2;return;}
			}
			this.k0=-2;
			return;
		}
		switch(k)
		{
			//end//right//home//left
			case 35:case 39:case 36:case 37:if(this.k1==k)return;break;
			//back//del
			case 8:case 46:if(this.k1==k)return;break;
			//up//down
			case 38:case 40:
				if(a==1&&this.delta!=0&&!e.shiftKey)this.spin((k==38)?this.delta:-this.delta);
				if(this.k1==k)return;break;
		}
		if(a==1)
		{
			t0=this.getSelectedText();
			if(t0.length>0||this.sel0<i)this.fixKey=0;
			else if(this.fixKey==0&&this.sel0==i)this.fixKey=1;
			return;
		}
		if(this.k0>0)//fast typing!
		{
			if(t0!=t1)this.changed=true;
			if(this.fixKey>0)this.afterKey(this.k0,this.fixKey>0);
		}
		var newK=this.filterKey(k,this.fixKey>0);
		if(newK!=k&&this.tr==null)newK=0;
		if(newK==0)ig_cancelEvent(e);
		else if(newK!=k&&this.tr!=null)e.keyCode=newK;
		this.k0=newK;
	}
	this.stoi=function(s)
	{
		switch(s.toLowerCase())
		{
			case "keypress":return 0;
			case "keydown":return 1;
			case "keyup":return 2;
			case "focus":return 8;
			case "blur":return 9;
			case "invalidvalue":return 11;
		}
		return 10;//valuechanged
	}
	this.doEvtM=function(e)
	{
		if(e==null||this.elem.disabled)return;
		var v=!this.elem.readOnly,a=this.stoi(e.type);
		if(a<8)this.fireEvt(a,e);
		if(a<3&&v)this.doKey(e,a);
		if(a>=8)
		{
			if((a==8)==this.foc)return;
			this.isOk();
			this.foc=(a==8);
			if(a==9&&v)
			{
				if(!this.changed)this.changed=this.text!=this.elem.value;
				if(this.changed)this.text=this.elem.value;
			}
			if(a==8&&v)
			{
				if(this.useLastGoodValue)this.setGood();
				if((v=this.elem.value)!=this.text){this.paste(v);return;}
			}
			this.repaint(a==9&&this.changed);
			this.fireEvt(a,e);
			if(this.foc){this.changed=false;this.select();}
			return;
		}
		if((v=this.elem.value)!=this.text&&(this.k1==0||a<4))
		{
			this.changed=true;
			if(a>3&&this.k1==0)this.paste(v);
			else this.text=v;
			this.fireEvt(10,e);
		}
	}
	this.events=new Array(11);
	this.evtH=function(n,f,add)
	{
		n=this.stoi(n);
		var e=this.events[n];
		if(e==null){if(add)e=this.events[n]=new Array();else return;}
		n=e.length;
		while(n-->0)if(e[n]==f){if(!add)e[n]=null;return;}
		if(add)e[e.length]=f;
	}
	this.removeEventHandler=function(name,fref){this.evtH(name,fref,false);}
	this.addEventHandler=function(name,fref){this.evtH(name,fref,true);}
	this.fireEvt=function(id,e)
	{
		var evts=this.events[id];
		var i=(evts==null)?0:evts.length;
		if(i==0)return false;
		var evt=this.Event;
		if(evt==null)evt=this.Event=new ig_EventObject();
		var cancel=false;
		while(i-->0)
		{
			if(evts[i]==null)continue;
			evt.reset();
			evt.event=e;
			evts[i](this,this.elem.value,evt,this.extra);
			if(evt.cancel)cancel=true;
		}
		return cancel;
	}
	this.select=function(s0,s1)
	{
		var i=this.elem.value.length;
		if(s1==null)if((s1=s0)==null){s0=0;s1=i;}
		if(s1>=i)s1=i;
		else if(s1<s0)s1=s0;
		if(s0>s1)s0=s1;
		if(this.elem.selectionStart!=null)
		{
			this.elem.selectionStart=this.sel0=s0;
			this.elem.selectionEnd=this.sel1=s1;
			this.tr=null;
		}
		if(this.tr==null)return;
		this.sel0=s0;this.sel1=s1;
		s1-=s0;
		this.tr.move("textedit",-1);
		this.tr.move("character",s0);
		if(s1>0)this.tr.moveEnd("character",s1);
		this.tr.select();
	}
	this.getSelectedText=function()
	{
		var r="";
		this.sel0=this.sel1=-1;
		if(this.elem.selectionStart!=null)
		{
			if((this.sel0=this.elem.selectionStart)<(this.sel1=this.elem.selectionEnd))
				r=this.elem.value.substring(this.sel0,this.sel1);
			this.tr=null;
		}
		if(this.tr==null)return r;
		var sel=document.selection.createRange();
		r=sel.duplicate();
		r.move("textedit",-1);
		this.sel0=0;
		try{while(r.compareEndPoints("StartToStart",sel)<0)
		{
			if(this.sel0++>1000)break;
			r.moveStart("character",1);
		}}catch(ex){}
		r=sel.text;
		this.sel1=this.sel0+r.length;
		return r;
	}
	//date:1-d,2-m,3-y
	//00007-1st,00070-2nd,00700-3rd,01000-dd,02000-mm,04000-yyyy
	this.order=7370;//2|(1<<3)|(3<<6)|(1<<10)|(1<<11)|(1<<12)
	this.sepCh="/";
	this.sep=47;
	this.autoCentury=true;
	this.setDateInfo=function(v)
	{
		this.info=v;
		var sep0=null;
		if(v!=null)
		{
			v=this.info.ShortDatePattern;
			if(ig_csom.isEmpty(sep0=this.info.DateSeparator))sep0=null;
		}
		if(v==null||v.length<3)v="MM/dd/yyyy";
		var ii=v.length;
		var y=0,m=0,d=0,sep=0,i=-1,o=0;
		while(++i<ii)
		{
			var ch=v.charAt(i);
			if(ch=='d'){if(d++>0){o|=1024;continue;}o|=1<<(sep++*3);}
			else if(ch=='m'||ch=='M'){if(m++>0){o|=2048;continue;}o|=2<<(sep++*3);}
			else if(ch=='y'){if(y++>0){if(y>2)o|=4096;continue;}o|=3<<(sep++*3);}
			else if(sep==1&&sep0==null)sep0=ch;
		}
		if(sep0!=null){this.sepCh=sep0;this.sep=sep0.charCodeAt(0);}
		if(m==0)o|=1<<(sep++*3);
		if(d==0)o|=2<<(sep++*3);
		if(y==0)o|=3<<(sep++*3);
		this.order=o;
		this.mask=v;
	}
	this.setGood=function()
	{
		var d=this.date;
		if(d==null)
		{
			if(this.elem.value.length>0)d=this.toDate();
			if(d==null&&!this.allowNull)d=new Date();
			this.date=d;
		}
		this.good=d;
	}
	this.focusText=function()
	{
		var v,i=-1,t="",d=this.date;
		if(d==null){if(this.allowNull)return t;this.date=d=new Date();}
		while(++i<3)
		{
			if((v=(this.order>>i*3)&3)==0)break;
			if(i>0)t+=this.sepCh;
			switch(v)
			{
				case 1:v=d.getDate();if(v<10&&(this.order&1024)!=0)t+=0;break;
				case 2:v=d.getMonth()+1;if(v<10&&(this.order&2048)!=0)t+=0;break;
				case 3:v=d.getFullYear()+this.yearFix;if((this.order&4096)==0)v%=100;if(v<10)t+=0;break;
			}
			t+=v;
		}
		return t;
	}
	this.setText=function(v){this.setDate(this.toDate(v));}
	this.toDate=function(t,inv)
	{
		if(t==null){if(this.elem.readOnly||this.k0==null)return this.date;t=this.elem.value;}
		var ii=t.length;
		if(ii>12)return this.date;
		if(ii==0&&this.allowNull)return null;
		var y=-1,m=-1,d=-1,sep=0,i=-1,f=0;
		while(++i<=ii)
		{
			var ch=(i<ii)?t.charCodeAt(i):this.sep;
			if(ch==this.sep)
			{
				if(i+1==ii)break;
				switch((this.order>>sep*3)&3)
				{
					case 1:d=f;break;
					case 2:m=f;break;
					case 3:y=f;break;
				}
				sep++;
			}
			ch-=48;
			if(ch>=0&&ch<=9)f=f*10+ch;
			else f=0;
		}
		f=null;i=0;
		if(y>99&&y>this.yearFix)y-=this.yearFix;
		this.extra.year=y;this.extra.month=m;this.extra.day=d;this.extra.reason=(ii>0)?2:1;
		if(sep!=3)i++;
		else
		{
			if(d<1||d>31||m<1||m>12||y<0||y>9999)i++;
			else
			{
				if(m==2&&d>29)i=d=29;
				if(this.autoCentury){if(y<37)y+=2000;else if(y<100)y+=1900;}
				f=new Date(y,m-1,d);
				if(y<100&&f.setFullYear!=null)f.setFullYear(y);
				if(f.getDate()!=d)
				{
					f=new Date(i=y,m-1,d-1);
					if(y<100&&f.setFullYear!=null)f.setFullYear(y);
				}
				d=f.getTime();
				if((m=this.max)!=null)if(d>m.getTime()){f=m;if(i++==0)this.extra.reason=0;}
				if((m=this.min)!=null)if(d<m.getTime()){f=m;if(i++==0)this.extra.reason=0;}
			}
		}
		this.extra.date=f;
		if(inv&&i>0)if(this.fireEvt(11,null))f=this.date;
		return f;
	}
	this.spin=function(v)
	{
		var d=this.toDate();
		if(d==null)d=new Date();
		this.setDate(new Date(d.getFullYear(),d.getMonth(),d.getDate()+v));
	}
	this.isValid=function(){return this.toDate()!=null;}
	this.repaint=function(fire)
	{
		var t=null,ev=null;
		if(!this.elem.readOnly&&!this.elem.disabled)
		{
			if(this.foc)t=this.focusText();
			else if(this.changed)
			{
				var d=this.toDate(null,true);
				if(d!=null||this.allowNull)this.date=d;
				ev=this.parent._msV;
			}
		}
		this.text=(t==null)?this.staticText():t;
		if(ev&&ev.onchange)
		{
			t=this.date?this.text:"";ev.value=t;
			t=this.elem.value;this.elem.value="";
			ev.onchange();this.elem.value=t;
		}
		this.repaint0(fire);
	}
	this.staticText=function(d,x)
	{
		if(!x)if((d=this.date)==null)
		{
			if(this.useLastGoodValue&&this.good!=null&&this.text.length>0)d=this.date=this.good;
			else{if(this.allowNull)return this.nullText;d=this.date=new Date();}
		}
		if(!d)if(this.allowNull)return this.nullText;else d=new Date();
		var t=this.info;
		if(t!=null)t=this.longFormat?t.LongDatePattern:t.ShortDatePattern;
		else if(this.longFormat&&d.toLocaleDateString!=null)return d.toLocaleDateString();
		if(t==null||t.length<2)t=this.mask;
		var f="yyyy",v=d.getFullYear()+this.yearFix;
		if(t.indexOf(f)<0){if(t.indexOf(f="yy")<0)v=-1;else if((v%=100)<10)v="0"+v;}
		if(v!=-1)t=t.replace(f,v);
		f="MMM";
		v=d.getMonth()+1;
		var mm=null,dd=null;
		if(t.indexOf(f)<0)
		{
			if(t.indexOf(f="MM")<0){if(t.indexOf(f="M")<0)v=-1;}
			else if(v<10)v="0"+v;
			if(v!=-1)t=t.replace(f,v);
		}
		else
		{
			if(t.indexOf("MMMM")>=0)f="MMMM";
			if(this.info!=null)mm=(f.length==4)?this.info.MonthNames:this.info.AbbreviatedMonthNames;
			if(mm!=null)mm=(mm.length>=v)?mm[v-1]:null;
			t=t.replace(f,(mm==null)?(""+v):"[]");
		}
		f="ddd";
		v="";
		if(t.indexOf(f)>=0)
		{
			if(t.indexOf("dddd")>=0)f="dddd";
			if(this.info!=null)dd=(f.length==4)?this.info.DayNames:this.info.AbbreviatedDayNames;
			v+=d.getDay();
			if(dd!=null)dd=(dd.length>=v)?dd[v]:null;
			t=t.replace(f,(dd==null)?v:"()");
		}
		f="dd";
		v=d.getDate();
		if(t.indexOf(f)<0){if(t.indexOf(f="d")<0)v=-1;}
		else if(v<10)v="0"+v;
		if(v!=-1)t=t.replace(f,v);
		if(mm!=null)t=t.replace("[]",mm);
		if(dd!=null)t=t.replace("()",dd);
		return t;
	}
	this.isOk=function()
	{
		var d=this.parent.old;if(this._ok||this.foc||d||d===this.date)return;
		d=unescape(this.parent.postField.value);
		var i=d.indexOf("Value=\"");if(i<1)return;
		d=d.substring(i+7);i=d.indexOf("\"");if(i<0)return;
		d=d.substring(0,i).split("x");
		this.date=this.parent.old=(d.length<3)?null:new Date(d[0],d[1]-1,d[2]);
		this.text=this.elem.value;this._ok=true;
	}
	this.getDate=function(){this.isOk();return this.foc?this.toDate():this.date;}
	this.setDate=function(v)
	{
		if(v!=null&&v.length!=null)v=(v.length<3)?null:this.toDate(v);
		if(v==null&&!this.allowNull)if((v=this.date)==null)v=new Date();
		if(v!=null)
		{
			var m,d=v.getTime();
			if((m=this.max)!=null)if(d>m.getTime())v=m;
			if((m=this.min)!=null)if(d<m.getTime())v=m;
		}
		else this.good=null;
		var fire=this.date!=v;
		this.date=v;
		this.text=this.foc?this.focusText():this.staticText();
		this.repaint0(fire);
	}
	//return char that can be added or -1
	this.canAdd=function(k,t)
	{
		var ii=t.length-1;
		if(ii<0)return (k==this.sep)?-1:k;
		if(t.charCodeAt(ii)==this.sep)return (k==this.sep)?-1:k;
		var ch,f=0,sep=0,i=-1,n=0;
		while(++i<=ii)
		{
			if((ch=t.charCodeAt(i))==this.sep){if(sep++>1)return -1;n=f=0;continue;}
			n++;f=f*10+ch-48;
		}
		if(sep>1&&k==this.sep)return -1;
		i=(this.order>>sep*3)&3;
		if(i==1){if(n>1||f*10+k-48>31)n=4;}
		if(i==2){if(n>1||f*10+k-48>12)n=4;}
		return (n<4)?k:((sep>1)?-1:this.sep);
	}
	this.afterKey=function(k,fix)
	{
		var f=0,t=this.elem.value;
		if(fix)
		{
			var sep=0,i=-1,i0=0,ii=t.length,tt="";
			while(++i<=ii)
			{
				var ch=(i<ii)?t.charCodeAt(i):this.sep;
				if(ch==this.sep)
				{
					switch((this.order>>sep*3)& 3)
					{
						case 1:if(f>31){while(f>31)f=Math.floor(f/10);}else f=-1;break;
						case 2:if(f>12){while(f>12)f=Math.floor(f/10);}else f=-1;break;
						case 3:if(f<=9999)f=-1;else while(f>9999)f=Math.floor(f/10);break;
					}
					if(f<0)tt+=t.substring(i0,i);else tt+=f;
					if(i<ii)tt+=this.sepCh;
					sep++;i0=i+1;
				}
				ch-=48;
				if(ch>=0&&ch<=9)f=f*10+ch;else f=0;
			}
			t=tt;
		}
		if(this.k0>(f=0))if(this.canAdd(48,t)==this.sep){t+=this.sepCh;f++;}
		this.elem.value=t;
		if(f>0)this.select(100,100);
	}
	this.filterKey=function(k,fix)
	{
		if(k!=this.sep&&(k<48||k>57))if(this.tr!=null&&this.isSep(k))k=this.sep;else return 0;
		if(k==this.sep&&this.sel0==0)return 0;
		if(fix&&this.canAdd(k,this.elem.value)!=k)k=0;
		return k;
	}
	this.isSep=function(k){return k==this.sep||k==45||k==92||k==95||k==47||k==32||k==46||k==44||k==58||k==59;}
	this.paste=function(old)
	{
		var ch,sep=true,v="",f=0;
		for(var i=0;i<old.length;i++)
		{
			ch=old.charCodeAt(i);
			if(ch>=48&&ch<=57)sep=false;
			else{if(!this.isSep(ch))continue;if(f>1)break;if(sep)continue;sep=true;f++;}
			v+=sep?this.sepCh:old.charAt(i);
		}
		this.text="";
		this.setText(v);
	}
	this.longFormat=lf;
	this.setDateInfo(di);
	this.setDate(v);
	this.init0=function()
	{
		this.k0=-2;
		var e=this.parent.Element,img=this.parent.DropButton.Image;
		var w=e.offsetWidth,w0=e.style.width;
		if(w0.length>0)if(w0.indexOf("%")>0)return;else try{w0=parseInt(w0);}catch(ex){w0=0;}
		try{if(isNaN(w0))w0=0;}catch(ex){w0=0;}
		if(w0==w)return;
		var b=e.clientWidth;b=(b==null)?-1:w-b;if(b<0||b>4)b=2;
		if(w0<=0){w0=(w>50&&w<300)?w:120;e.style.width=w0+"px";}
		w=img.style.width;
		if(w==null||w.length==null||w.length<1)w=img.offsetWidth;
		else try{w=parseInt(w);}catch(ex){w=17;}
		if(w==null||w<2)w=17;
		if((w=w0-w-b)<2)w=2;
		e=this.elem;e.style.width=w+"px";
		if(e.runtimeStyle)e.runtimeStyle.width=w+"px";
	}
	igdrp_all[id]=this;
}
function igmask_event(e)
{
	var o,c=null,id=null,i=0;
	if(e==0){for(id in igdrp_all)if((o=igdrp_all[id])!=null)if(o.init0!=null)o.init0();return;}
	if(e==null)if((e=window.event)==null)return;
	if((o=e.srcElement)==null)if((o=e.target)==null)o=this;
	while(true)
	{
		if(o==null||i++>2)return;
		try{if(o.getAttribute!=null)id=o.getAttribute("maskID");}catch(ex){}
		if(!ig_csom.isEmpty(id)){c=igdrp_all[id];break;}
		if((c=o.parentNode)!=null)o=c;
		else o=o.parentElement;
	}
	if(c!=null&&c.doEvtM!=null)c.doEvtM(e);
}
