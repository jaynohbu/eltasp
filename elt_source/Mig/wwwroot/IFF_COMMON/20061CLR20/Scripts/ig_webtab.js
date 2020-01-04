 /*
  * Infragistics WebTab CSOM Script: ig_webtab.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

//js-version 5.14
//vs
if(typeof igtab_all!="object")
	var igtab_all=new Object();
function igtab_getTabById(id)
{
	var o=igtab_all[id];
	if(o!=null)return o;
	for(var i in igtab_all)if((o=igtab_all[i])!=null)if(o.ID==id||o.ID_==id||o.uniqueId==id)return o;
	return null;
}
function igtab_getElementById(id,owner)
{
	if(owner==null)owner=window.document;
	var e=null,ids=(id.charAt==null)?id:id.split(" ");
	if(ids.length==1&&owner.forms!=null)e=ig_csom.getElementById(id);
	else
	{
		var nodes=owner.childNodes;
		var i=nodes.length;
		while(i-->0)
		{
			e=nodes[i];
			var i0=0,j=ids.length;
			if((id=e.id)!=null)if(id.length>0)
			{
				while(j-->0)
				{
					if(ids[j].length<1)continue;
					if((i0=id.indexOf(ids[j],i0))<0)break;
					if(i0>0)if(id.charAt(i0-1)!='_')break;
					i0+=ids[j].length;
					if(i0<id.length)if(id.charAt(i0)!='_')break;
				}
				if(j<0&&i0==id.length)i=0;
			}
			if((e=igtab_getElementById(ids,e))!=null)i=0;
		}
	}
	return e;
}
function igtab_init(id,index,seps,prop,evts)
{
	var o;
	if(id==null)
	{
		for(id in igtab_all)if((o=igtab_all[id])!=null){o.scrolInit();o.ensureVisible();}
		ig_csom.addEventListener(window,"resize",igtab_event);
		return;
	}
	if(!ig_csom._tab_load){ig_csom.addEventListener(window,"load",igtab_event);ig_csom.addEventListener(window,"unload",igtab_event);ig_csom._tab_load=true;}
	if((o=igtab_getElementById("igtab"+id))==null)return;
	ig_csom._postTab=false;
	igtab_all[id]=o=new igtab_new(o,id,seps,prop,evts);
	igtab_selectTab(o,index);
	o.fireEvt(o,o.Events.initializeTabs,null);
	o._new=true;
}
function igtab_event(e)
{
	if(!e)e=window.event;if(!e||ig_csom._postTab)return;
	var z=igtab_all,o=e.srcElement,type=0;//mouseout
	if(e.type=="load"){for(o in z)if(z[o])z[o]._load();return;}
	if(e.type=="unload"){for(o in z)if(!ig_csom.getElementById(o))z[o]=null;ig_dispose(igtab_all);return;}
	if(o==null)if((o=e.target)==null)o=this;
	if(e.type=="focus"){if((o=o.indexOwner)!=null)o.setState(2,e);return;}
	if(e.type=="keydown")
	{
		z=e.keyCode;
		if(z==null||z==0)z=e.which;
		if((o=o.indexOwner)==null)return;
		o=o.owner;
		if(o.tabIndex<0||!o.enabled)return;
		var i=o.selected,iL=o.Tabs.length-1;
		switch(z)
		{
			case 36:i=0;type=iL;break;
			case 35:i=iL;break;
			case 37:i--;break;
			case 39:i++;type=iL;break;
			default:return;
		}
		while(true)
		{
			if(i<0||i>iL)return;
			z=o.Tabs[i];
			if(z.visible&&z.enabled)break;
			if(i==type)return;
			if(i<type)i++;else i--;
		}
		z.setState(2,e);
		return;
	}
	o=igtab_getTabFromElement(o);
	if(e.type=="resize")
	{
		if(o)o.scrolInit(e);
		else for(o in z)if(z[o]&&z[o].scrolInit)z[o].scrolInit(e);
		return;
	}
	if(o==null)return;
	var eX=e.clientX,eY=e.clientY,oo=z=o.owner;
	if(z)if((z=z._fe)==null&&(!ig_csom.IsIE||document.readyState=="complete"))try
	{
		oo.elemState.form.appendChild(z=oo._fe=document.createElement("INPUT"));
		z=z.style;z.position="absolute";z.zIndex=-1;z.padding=z.width=z.height=z.border="0px";
	}catch(ex){oo._fe=z=2;}
	var ee=(z==2)?null:z;
	if(e.type=="mouseover"||e.type=="mousemove")type=1;
	if(e.type=="mousedown")type=2;
	if(o.text!=null&&o.index!=oo.selected&&ee)try
	{
		if(type==1){ee.style.left=(eX+document.body.scrollLeft+20)+"px";ee.style.top=(eY+document.body.scrollTop+5)+"px";}
		if(type==2)ee.focus();
	}catch(ex){}
	if(type==2&&o.text!=null)return;
	if(e.type=="click"){type=2;oo.fireEvt(o,oo.Events.click,e);try{if(ee)ee.blur();}catch(ex){}}
	if(e.type=="mouseup")type=4;
	if(type==2&&(e.button>1||e.ctrlKey||e.shiftKey||e.altKey))return;
	if(oo==null)return;
	if(type==1)if(oo.scrolInit(""))return;
	if(!oo.enabled)return;
	// not tab
	if(o.text==null){oo.doBut(type,e,o);return;}
	if(type>0){o.setState(type,e);return;}
	z=o.element;
	var w=o.rect(z),h=o.rect(z,1),x=o.rect(z,2),y=o.rect(z,3);
	if(o.elemLeft!=null)
	{
		if((z=o.rect(o.elemLeft,2))<x){w+=(x-z);x=z;}
		if((z=o.rect(o.elemLeft,3))<y){h+=(y-z);y=z;}
	}
	if(o.elemRight!=null)
	{
		if(o.rect(o.elemRight,2)>x)w+=o.rect(o.elemRight);
		if(o.rect(o.elemRight,3)>y)h+=o.rect(o.elemRight,1);
	}
	z=o.element;
	while((z=z.offsetParent)!=null){x+=o.rect(z,2);y+=o.rect(z,3);}
	if(eX<x+3||eY<y+3||eX+3>x+w||eY+3>y+h)o.setState(0,e);
}
function igtab_new(elem,id,seps,prop,evts)
{
	if(ig_csom.isEmpty(prop))return;
	this.sep1=(seps.length>0)?seps.substring(0,1):"\01";
	this.sep2=(seps.length>1)?seps.substring(1,2):"\02";
	this.val=function(o,i){return (o==null||o.length<=i)?"":o[i];}
	this.vis=function(e,v){if(e!=null){e.style.display=(v==null)?"none":v;e.style.visibility=(v==null)?"hidden":"visible";}}
	this.addLsnr=function(e,s)
	{
		if(e==null)return;
		ig_csom.addEventListener(e,"select",ig_cancelEvent);
		ig_csom.addEventListener(e,"selectstart",ig_cancelEvent);
		if(s)return;
		ig_csom.addEventListener(e,"mouseout",igtab_event);
		ig_csom.addEventListener(e,"mouseover",igtab_event);
		ig_csom.addEventListener(e,"mousemove",igtab_event);
		ig_csom.addEventListener(e,"click",igtab_event);
		ig_csom.addEventListener(e,"mousedown",igtab_event);
		if(this.tabIndex<0)e.unselectable="on";
	}
	var prop0=prop[0].split(this.sep1);
	this.ID=id;
	this.elemState=igtab_getElementById(id);
	if(id.indexOf("x_")==0)this.ID_=id.substring(1);
	this.element=elem;
	this.elemEmpty=igtab_getElementById(id+"_empty");
	this.selected=-2;
	ig_csom.addEventListener(elem,"resize",igtab_event);
	elem.setAttribute("tabID",id);
	var j,i=-1;
	while(++i<30)
	{
		if((elem=igtab_getElementById(id+"_r"+i))==null)break;
		if(this.rows==null)this.rows=new Array();
		this.rows[i]=elem;
	}
	if(prop0.length<6)return;
	this.uniqueId=prop0[0];
	this.enabled=ig_csom.notEmpty(prop0[1]);
	if(!this.enabled)this.element.disabled=true;
	this.autoPost=ig_csom.notEmpty(prop0[2]);
	this.doPost=this.autoPost;
	this.loadAllUrls=ig_csom.notEmpty(prop0[3]);
	this.noHov=ig_csom.notEmpty(prop0[6]);
	var css,round=0;
	if(ig_csom.notEmpty(prop0[5]))
	{
		round=parseInt(prop0[5]);
		if((round&1)!=0)
		{
			this.leftImg=[id+"DefTL",id+"HovTL",id+"SelTL",id+(((round&4)!=0)?"DisTL":"DefTL")];
			if(this.noHov)this.leftImg[1]=this.leftImg[0];
		}
		if((round&2)!=0)
		{
			this.rightImg=[id+"DefTR",id+"HovTR",id+"SelTR",id+(((round&4)!=0)?"DisTR":"DefTR")];
			if(this.noHov)this.rightImg[1]=this.rightImg[0];
		}
	}
	this.doCss=function(prop)
	{
		var j=-1,cs=new Array();
		prop=ig_csom.notEmpty(prop)?prop.split("+"):null;
		if(ig_csom.notEmpty(prop))while(++j<4)
			if(ig_csom.isEmpty(cs[j]=this.val(prop,j)))cs[j]=cs[0];
		return cs;
	}
	this.dummy=this.val(prop0,7);
	this.tabIndex=this.val(prop0,8);
	if(prop0.length<12){this.top=this.val(prop0,9)==0;this.back=this.val(prop0,10);}
	else
	{
		this.butP=-1;this.butL=1;this.buttons=new Array(4);
		for(j=2;j<4;j++)if((e=ig_csom.getElementById(id+"more"+j))!=null)
		{
			ig_csom.addEventListener(e,"mousedown",igtab_event);
			e.unselectable="on";this.addLsnr(e,true);
			e.setAttribute("tabID",id+",100"+j);
			e.owner=this;this.buttons[j]=e;
		}
		j=parseInt(this.val(prop0,9));
		this.delay=parseInt(this.val(prop0,10));
		this.scrolHide=ig_csom.notEmpty(prop0[11]);
		this.scrolToLast=ig_csom.notEmpty(prop0[12]);
		this.css=this.doCss(this.val(prop,13));
		for(i=0;i<4;i++)
		{
			if((o=this.css[i])==null)o="";
			css=(j<1)?"":(id+"But"+(((j&(1<<i))!=0)?i:0));
			if(css.length>0&&o.length>0)css+=" ";
			if((this.css[i]=css+o)=="")this.css[i]=this.css[0];
		}
		for(j=0;j<2;j++)if((e=ig_csom.getElementById(id+"_b"+j))!=null)
		{
			ig_csom.addEventListener(e,"mousedown",igtab_event);
			ig_csom.addEventListener(e,"mouseup",igtab_event);
			ig_csom.addEventListener(e,"mousemove",igtab_event);
			ig_csom.addEventListener(e,"mouseout",igtab_event);
			e.unselectable="on";
			e.setAttribute("tabID",id+",100"+j);
			o=new Object();o.i=j;o.elem=e;o.img=new Array(4);
			css=this.val(prop0,14+j).split(";");
			for(i=0;i<4;i++)if((o.img[i]=this.val(css,i))=="")o.img[i]=o.img[0];
			o.state=0;o.owner=this;
			this.buttons[j]=o;
		}
	}
	css=this.doCss(prop0[4]);
	this.getUniqueId=function(){return this.uniqueId;}
	this.getEnabled=function(){return this.enabled;}
	this.setEnabled=function(v){this.setEnabled0(this,v);}
	this.setEnabled0=function(o,v)
	{
		if(o.enabled==(v==true))return;
		o.enabled=(v==true);
		var x=-1,owner=o.owner;
		if(owner==null)owner=o;else x=o.index;
		owner.update(x,"Enabled",v);
		if(++x>0){o.setState(o.enabled?0:3);o.fixSel();return;}
		while(x<o.Tabs.length)o.Tabs[x++].doState(-1);
		o.element.disabled=v!=true;
		o.scrolW_All=null;
		o.scrolInit();
	}
	this.getAutoPostBack=function(){return this.autoPost;}
	this.setAutoPostBack=function(v){this.autoPost=(v==true);}
	this.getSelectedIndex=function(){return this.selected;}
	this.setSelectedIndex=function(v){igtab_selectTab(this,v);}
	this.getSelectedTab=function(){return (this.selected<0)?null:this.Tabs[this.selected];}
	this.setSelectedTab=function(v){igtab_selectTab(this,(v==null)?-1:v.index);}
	prop0=ig_csom.notEmpty(evts)?evts.split(this.sep1):null;
	evts=new Object();
	evts.afterSelectedTabChange=this.val(prop0,0);
	evts.beforeSelectedTabChange=this.val(prop0,1);
	evts.initializeTabs=this.val(prop0,2);
	evts.mouseOut=this.val(prop0,3);
	evts.mouseOver=this.val(prop0,4);
	evts.click=this.val(prop0,5);
	this.Events=evts;
	this.Tabs=new Array();
	this.addLsnr(igtab_getElementById(id+"_tbl"),true);
	i=-1;
	while(++i<prop.length-1)
	{
		if((elem=igtab_getElementById(id+"td"+i))==null)continue;
		elem.setAttribute("tabID",id+","+i);
		var tab=new igtab_newT(id,prop[i+1].split(this.sep1),i,css,this);
		tab.element=elem;
		tab.tooltip=elem.title;
		while(tab.text.indexOf(this.sep2)>0)
			tab.text=tab.text.replace(this.sep2,"\"");
		this.addLsnr(elem,false);
		if(this.tabIndex!=-1)for(j=0;j<6;j++)
		{
			if(elem.tabIndex==-3){ig_csom.addEventListener(elem,"keydown",igtab_event);j=10;}
			if(ig_csom.notEmpty(elem.accessKey)){ig_csom.addEventListener(elem,"focus",igtab_event);j=10;}
			if(j==10){elem.indexOwner=tab;tab.elemIndex=elem;}
			if((elem=elem.parentNode)==null)break;
			if(ig_csom.notEmpty(elem.id))break;
		}
		this.Tabs[i]=tab;
		if(ig_csom.notEmpty(tab.Key)&&isNaN(tab.Key))this.Tabs[tab.Key]=tab;
		if((round&1)!=0)if((elem=igtab_getElementById(id+"td"+i+"L"))!=null)
		{
			elem.setAttribute("tabID",id+","+i);
			tab.elemLeft=elem;
			this.addLsnr(elem,false);
		}
		if((round&2)!=0)if((elem=igtab_getElementById(id+"td"+i+"R"))!=null)
		{
			elem.setAttribute("tabID",id+","+i);
			tab.elemRight=elem;
			this.addLsnr(elem,false);
		}
	}
	this.tabFromKey=function(key){for(var i=0;i<this.Tabs.length;i++)if(this.Tabs[i].Key==key)return this.Tabs[i];return null;}
	this.findControl=function(id){var c,i=-1;while(this.Tabs[++i]!=null)if((c=this.Tabs[i].findControl(id))!=null)return c;}
	this._load=function()
	{
		var v=unescape(this.elemState.value);
		var i=v.indexOf("SelectedTab=\"");if(i<0)return;
		v=v.substring(i+13);
		if((i=v.indexOf("\""))>0)igtab_selectTab(this,parseInt(v.substring(0,i)));
	}
	this.update=function(i,pr,v,post)
	{
		var e=this.elemState;
		if(!e||!this._new)return;
		if(!this.viewState)this.viewState=new ig_xmlNode();
		var n=this.viewState.addNode("x",true);
		if(i>=0)n=n.addNode("Tabs",true).addNode("i"+i,true);
		//10000-server-postBack
		n.setPropertyValue(pr,""+((post==1)?(v+10000):v));
		e.value=this.viewState.getText();
		if(post!=1)return;
		ig_csom._postTab=true;
		if((e=this.getSelectedTab())!=null)if((e=e.getTargetUrlDocument())!=null)try
		{
			if((e=e.forms)!=null)for(i=0;i<e.length;i++)
				if(ig_csom.IsIE)e[i].fireEvent("onsubmit");else e[i].submit();
		}catch(ex){}
		try{if((e=document.activeElement)!=null)if(e.tagName=="INPUT")e.fireEvent("onblur");}catch(ex){}
		try{__doPostBack(this.uniqueId,v);}catch(ex){}
	}
	this.fireEvt=function(o,evtName,e)
	{
		var owner=o.owner;
		if(owner==null)owner=o;
		if(ig_csom.isEmpty(evtName))return false;
		var evt=owner.Event;
		if(evt==null)evt=owner.Event=new ig_EventObject();
		evt.reset();
		if((evt.event=e)==null)ig_fireEvent(owner,evtName);
		else ig_fireEvent(owner,evtName,o,evt);
		owner.doPost=(evt.needPostBack==true)||(owner.autoPost&&evt.cancelPostBack==false);
		return evt.cancel;
	}
	//swap 0-i rows
	this.moveRow=function(i)
	{
		var e1=this.rows[i],e0=this.rows[0];
		var t1=e1.firstChild,t0=e0.firstChild;
		if(t1==null||t0==null)return;
		e0.removeChild(t0);e1.removeChild(t1);
		this.fixTD(t1,"",true);
		this.fixTD(t0,"0px",i+1<this.rows.length);
		e1.appendChild(t0);e0.appendChild(t1);
	}
	this.fixTD=function(e,v,c)
	{
		if(ig_csom.notEmpty(e.nodeName)&&e.nodeName.toUpperCase()=="TD")
		{
			var s=e.style;
			if(e.id!=null&&s!=null)
			{
				if(this.top)s.borderBottomWidth=v;else s.borderTopWidth=v;
				if(e.id!="edge")s.backgroundColor=c?this.back:"";
			}
		}
		if((e=e.childNodes)!=null)for(var i=0;i<e.length;i++)this.fixTD(e[i],v,c);
	}
	this.butState=function(b,s)
	{
		var e,i=-1,bb=this.buttons;
		if(bb!=null)bb=bb[b];
		if(s<0)if(bb.state<3)return;else s=0;
		if(bb==null||bb.state==s)return;
		var timer=(s==2)?2:((bb.state==2)?1:0);
		bb.state=s;
		if(ig_csom.notEmpty(e=this.val(this.css,s)))if(bb.elem.className!=e)bb.elem.className=e;
		if(ig_csom.isEmpty(s=bb.img[s]))s=bb.img[0];
		if(ig_csom.notEmpty(s))for(i=0;i<bb.elem.childNodes.length;i++)
		{
			e=bb.elem.childNodes[i];
			b=e.nodeName.toUpperCase();
			if(b=="IMG")if(e.src!=s)e.src=s;
		}
		if(timer>0)this.timer(this,timer==1);
	}
	//0-out,1-move,2-down,4-up
	this.doBut=function(type,e,b)
	{
		ig_cancelEvent(e);
		if(this.hover!=null&&this.hover.state==1)this.hover.setState(0,e);
		var but=4;
		while(but-->0)if(this.buttons[but]==b)break;
		if(but<0)return;
		//more button
		if(but>1){this.scroll(but==2);return;}
		if(type==4)this.butP=-1;
		else if(type!=2&&e.button!=0&&this.butP<0)return;
		if(!this.getEnabled()||b.state==3)return;
		if(type==0&&this.butL==0)this.butP=-1;
		b=this.butP;
		if(type==2)
		{
			if(b>=0)this.butState(b,0);
			this.butP=-2;
			if(e.button<2){this.butP=but;this.butL=e.button;this.butState(but,2);}
			return;
		}
		if(e.button==0&&b<-1)b=this.butP=-1;
		if(b>=0&&e.button!=this.butL&&type==1){b=this.butP=-1;this.butState(but,1);return;}
		if(b<-1||(b>=0&&b!=but))return;
		this.butState(but,(type==0)?0:((b>=0)?2:1));
	}
	this.scrolInit=function(e)
	{
		var w=-1,j=-1,i=this.Tabs.length;
		if(i<1||this.butP==null||(e!=null&&this.butP>=0))return false;
		var t=this.Tabs[0];
		if(e=="")if(this.scrolW_Vis==t.rect(this.scrolDiv))return false;
		e=t.element;
		//find scroll elems
		var div,tbl,tds=null;
		while(j++<15&&w<=0)
		{
			if(w<0)
			{
				//table inside div
				if(e.tagName=="TABLE")tbl=e;
				if(e.tagName=="TR")tds=e.childNodes;
				if(e.tagName=="DIV")
				{
					//NS6
					if(t.rect(e,1)!=(w=t.rect(tbl,1)))e.style.height=w;
					w=t.rect(this.scrolDiv=div=e);
				}
			}
			//IE-Mac
			else if((w=t.rect(e))>0){div.style.width=w;if(t.rect(div,1)!=(j=t.rect(tbl,1)))div.style.height=j;}
			if((e=e.parentNode)==null)return false;
		}
		if(tds==null||(this.scrolW_Vis==w&&this.scrolW_All!=null))return false;
		var my,tail,last=true,iTD=tds.length,i0=0,b=this.buttons[3];
		while(iTD-->1){e=tds[iTD];if(e.tagName=="TD"){this.scrolEnd=e;break;}}
		if(b!=null)for(j=-1;j>-3;j--)if(tds[iTD+j]==b){this.vis(b);iTD+=j;break;}
		if(iTD>1&&(b=this.buttons[2])!=null)for(i0=3;i0>0;i0--)if(tds[i0-1]==b){this.vis(b);break;}
		if(iTD-i0<1)return false;
		this.vis(e);
		var old0=this.scrol0;
		//show hidden tabs
		for(j=i;j>0;)this.show(this.Tabs[--j],true);
		if(this.scrolW_All==null)old0=-1;
		this.scrolW_Vis=w;this.scrolW_All=t.rect(tbl);
		w=0;t=null;
		while(iTD-->i0)
		{
			if(t==null&&i>0)
			{
				while(i-->0){if(old0<0)this.scrol0=i;t=this.Tabs[i];t.scrolW=0;t.scrolX=-1;if(t.visible)break;}
				if(i<0)break;
				j=0;tail=true;t.scrolTDs=new Array();
			}
			e=tds[iTD];
			if(e.tagName!="TD")continue;
			if(my=t.isMy(e))tail=false;
			//go to next tab
			else if(!tail&&i>0){last=false;t=null;iTD++;continue;}
			if(my||tail||i==0)
			{
				if(t.scrolX<0)t.scrolX=e.offsetLeft;
				j=e.offsetWidth;
				//elem to scroll (hide/show)
				t.scrolTDs[t.scrolTDs.length]=e;t.scrolW+=j;w+=j;
				//width from left of t to the last tab
				t.scrolW_Right=last?0:(this.scrolToLast?9999:w);
			}
		}
		for(i=j=0;j<this.Tabs.length;j++)
		{
			t=this.Tabs[j];
			if(t.scrolW>0)
			{
				if(old0>0&&j<old0)this.show(t,false);
				//index within visible tabs
				t.scrolI=i++;
			}
		}
		this.vis(this.scrolEnd,"");
		this.scrolFix();
		return true;
	}
	this.timer=function(tab,end)
	{
		if(tab!=null&&tab.Tabs!=null)
		{
			if(ig_csom.tab_f!=null)window.clearInterval(ig_csom.tab_f);
			ig_csom.tab_f=end?(tab=null):window.setInterval(tab.timer,this.delay);
			ig_csom.tab_o=tab;
		}
		else tab=ig_csom.tab_o;
		if(tab!=null)tab.scroll();
	}
	this.ensureVisible=function()
	{
		var i0=this.selected,i=this.Tabs.length;
		if(this.scrol0==null||i0<0)return;
		while(this.scrol0>i0&&i-->0)this.scroll(true);
		if(this.scrol0>=i0)return;
		var t=this.Tabs[i0];
		var iR=t.scrolX+t.scrolW-this.scrolW_Vis;
		while(this.scrol0<i0&&i-->0)
			if(iR>this.Tabs[this.scrol0].scrolX||t.scrolHidden==true)this.scroll(false);
			else break;
	}
	this.scroll=function(left)
	{
		if(left==null)left=this.butP==0;
		if(this.scrolW_All==null)if(!this.scrolInit())return;
		var ii=this.Tabs.length-1,j=0,i=this.scrol0;
		var t=this.Tabs[i];
		while(true)
		{
			i+=left?-1:1;
			if(i<0||i>ii)return;
			if(this.Tabs[i].scrolW>0)break;
		}
		this.scrol0=i;
		this.show(left?this.Tabs[i]:t,left);
		this.scrolFix();
	}
	this.show=function(t,vis)
	{
		if(t.scrolW<1||vis==(t.scrolHidden!=true))return;
		for(var i=0;i<t.scrolTDs.length;i++)this.vis(t.scrolTDs[i],vis?"":null);
		t.scrolHidden=!vis;
	}
	//show/hide/enable buttons,hide right tabs
	this.scrolFix=function()
	{
		var t=this.Tabs[this.scrol0];
		if(t==null)return;
		var e,w0=0,w=0,i=t.index,more=t.scrolI>0;
		this.vis(e=this.buttons[2],more?"":null);
		if(more)w+=(w0=t.rect(e));
		this.butState(0,(more&&this.enabled)?-1:3);
		more=t.scrolW_Right+w0>this.scrolW_Vis;
		this.butState(1,(more&&this.enabled)?-1:3);
		e=this.buttons[3];
		var vis=more&&this.scrolHide;
		if(vis)w+=t.rect(e);
		more=true;//not 1st
		if(this.scrolHide)while(i<this.Tabs.length)
		{
			t=this.Tabs[i++];
			if((w0=t.scrolW)<1)continue;
			w+=w0;
			this.show(t,more||w<=this.scrolW_Vis);
			more=false;
		}
		if(vis)for(i=this.Tabs.length;--i>0;)if(this.Tabs[i].scrolW>0)
		{if(this.Tabs[i].scrolHidden!=true)vis=false;break;}
		this.vis(e,vis?"":null);
	}
}
function igtab_newT(id,prop,i,css0,own)
{
	this.owner=own;
	var o=igtab_getElementById(id+"_div"+i);
	this.elemDiv=(o==null)?own.elemEmpty:o;
	this.elemIframe=igtab_getElementById(id+"_frame"+i);
	this.index=i;
	this.visible=ig_csom.notEmpty(own.val(prop,0));
	this.enabled=ig_csom.notEmpty(own.val(prop,1));
	this.state=this.enabled?0:3;
	//2-style flags:0..15 (1-defStyle,2-hovStyle,4-selStyle,8-disStyle)
	//3-customCss:none or "defCss+hovCss+selCss+disCss"
	o=own.val(prop,2);
	var st=ig_csom.notEmpty(o)?parseInt(o):0;
	var cssT=own.doCss(own.val(prop,3));
	var defCss=id+"DefT";
	if((st&1)!=0)defCss+=i;
	if(ig_csom.notEmpty(o=own.val(cssT,0)))defCss+=" "+o;
	else if(ig_csom.notEmpty(o=own.val(css0,0)))defCss+=" "+o;
	var hovCss=id+"HovT";
	if((st&2)!=0)hovCss+=i;
	else{if(own.noHov)hovCss=id+"DefT";if((st&1)!=0)hovCss+=i;}
	if(ig_csom.notEmpty(o=own.val(cssT,1)))hovCss+=" "+o;
	else if(ig_csom.notEmpty(o=own.val(css0,1)))hovCss+=" "+o;
	var selCss=id+"SelT";
	if((st&4)!=0)selCss+=i;
	if(ig_csom.notEmpty(o=own.val(cssT,2)))selCss+=" "+o;
	else if(ig_csom.notEmpty(o=own.val(css0,2)))selCss+=" "+o;
	var disCss=id+"DisT";
	if((st&8)!=0)disCss+=i;
	if(ig_csom.notEmpty(o=own.val(cssT,3)))disCss+=" "+o;
	else if(ig_csom.notEmpty(o=own.val(css0,3)))disCss+=" "+o;
	this.css=[defCss,hovCss,selCss,disCss];
	this.targetUrl=own.val(prop,4);
	o=own.val(prop,5).split(";");
	this.img=[own.val(o,0),own.val(o,1),own.val(o,2),own.val(o,3)];
	if(ig_csom.isEmpty(this.img[3]))this.img[3]=this.img[0];
	this.text=own.val(prop,6);
	this.selColor=own.val(prop,7);
	this.Key=own.val(prop,8);
	this.imgAlign=own.val(prop,9);
	this.getIndex=function(){return this.index;}
	this.getElement=function(){return this.element;}
	this.getOwner=function(){return this.owner;}
	this.getTargetUrlDocument=function()
	{
		var d,f=this.elemIframe;
		if(f==null)return null;
		try{if((d=f.contentWindow)!=null)if((d=d.document)!=null)return d;}catch(ex){}
		try{if((d=f.contentDocument)!=null)return d;}catch(ex){}
		return null;
	}
	this.getVisible=function(){return this.visible;}
	this.setVisible=function(v)
	{
		if(this.visible==(v==true))return;
		this.visible=(v==true);
		this.owner.vis(this.element,this.visible?"":null);
		this.owner.vis(this.elemLeft,this.visible?"":null);
		this.owner.vis(this.elemRight,this.visible?"":null);
		this.fixSel();
		this.owner.update(this.index,"Visible",v);
	}
	this.getEnabled=function(){return this.enabled;}
	this.setEnabled=function(v){this.owner.setEnabled0(this,v);}
	this.getText=function(){return this.text;}
	this.setText=function(v)
	{
		if(this.text==v||!ig_csom.isArray(v))return;
		var t=this.text=v;
		var e=this.element,n=e.childNodes;
		var i=(n==null)?0:n.length;
		while(i-->0)
		{
			if(t==v&&n[i].nodeName=="#text"){n[i].nodeValue=v;t=null;}
			else if(n[i].nodeName!="IMG")e.removeChild(n[i]);
		}
		if(t==v)e.innerHTML=" "+v+" ";
		this.fixImg(-1);
		this.owner.update(this.index,"Text",v);
	}
	this.getTooltip=function(){return this.tooltip;}
	this.setTooltip=function(v)
	{
		if(ig_csom.isArray(v))this.element.title=this.tooltip=v;
		this.owner.update(this.index,"Tooltip",v);
	}
	this.getTargetUrl=function(){return this.targetUrl;}
	this.setTargetUrl=function(v)
	{
		if(v==null||v==this.owner.dummy)v="";
		if(this.targetUrl==v||this.elemIframe==null)return;
		this.targetUrl=v;
		this.elemIframe.src=(v.length==0)?this.owner.dummy:v;
		if(this.state==2)if((v.length==0)!=(this.elemIframe.style.display=="none"))
		{
			this.owner.vis(this.elemDiv,(v.length==0)?"block":null);
			this.owner.vis(this.elemIframe,(v.length>0)?"block":null);
		}
		this.owner.update(this.index,"TargetUrl",v);
	}
	this.getDefaultImage=function(){return this.img[0];}
	this.setDefaultImage=function(v){this.doImg(v,0,"Default");}
	this.getHoverImage=function(){return this.img[1];}
	this.setHoverImage=function(v){this.doImg(v,1,"Hover");}
	this.getSelectedImage=function(){return this.img[2];}
	this.setSelectedImage=function(v){this.doImg(v,2,"Selected");}
	this.getDisabledImage=function(){return this.img[3];}
	this.setDisabledImage=function(v){this.doImg(v,3,"Disabled");}
	this.doImg=function(v,st,p)
	{
		if(v==null)v="";if(this.img[st]==v)return;
		this.img[st]=v;
		if(this.state==st)this.fixImg(-2);
		this.owner.update(this.index,p+"Image",v);
	}
	this.fixImg=function(st)
	{
		if(this.state==st||(st>=-1&&ig_csom.isEmpty(this.img[0]+this.img[1]+this.img[2]+this.img[3])))return;
		var c=this.element;
		var im,imgC=null,nodes=c.childNodes;
		if(nodes==null)return;
		var i=nodes.length;
		while(i-->0){im=nodes[i].tagName;if(im=="IMG"||im=="img"){imgC=nodes[i];break;}}
		if(st<0||st>3)st=this.state;
		if(ig_csom.isEmpty(im=this.img[st]))im=this.img[0];
		if(ig_csom.notEmpty(im))
		{
			if(imgC==null)
			{
				if((imgC=document.createElement("IMG"))!=null)
				{
					if((i=c.lastChild)!=null)c.removeChild(i);
					imgC=c.appendChild(imgC);
					if(i!=null)c.appendChild(i);
				}
				if(imgC!=null){imgC.border=0;if(ig_csom.notEmpty(this.imgAlign))imgC.align=this.imgAlign;}
			}
			if(imgC!=null)imgC.src=im;
		}
		else if(imgC!=null)c.removeChild(imgC);
	}
	this.fixSel=function()
	{
		if(this.visible&&this.enabled)return;
		if(this.owner.selected!=this.index)return;
		if(!this.visible){this.owner.vis(this.elemDiv);this.owner.vis(this.elemIframe);}
		var o,i=this.index;
		while(i-->0)
		{
			o=this.owner.Tabs[i];
			if(o.visible&&o.enabled){igtab_selectTab(o.owner,o.index,1);return;}
		}
		i=this.index;
		while(++i<this.owner.Tabs.length)
		{
			o=this.owner.Tabs[i];
			if(o.visible&&o.enabled){igtab_selectTab(o.owner,o.index,1);return;}
		}
		igtab_selectTab(this.owner,-1,1);
	}
	this.rect=function(o,s)
	{
		if(o==null)s=0;else if(s==1)s=o.offsetHeight;
		else if(s==2)s=o.offsetLeft;else if(s==3)s=o.offsetTop;
		else s=o.offsetWidth;
		return (s==null)?0:s;
	}
	this.focus=function(){if(this.elemIndex!=null)try{this.elemIndex.focus();}catch(ex){};}
	this.setState=function(st,e)
	{
		if(st<0||st>3||st==this.state){if(st==2)this.focus();return;}
		var o=this.owner;
		if(e!=null)
		{
			if(st==1)
			{
				if(o.hover==this)return;
				if(o.hover!=null&&o.hover.state==1)o.hover.setState(0,e);
			}
			o.hover=(st==1||st==2)?this:null;
			if(this.state==3||!o.enabled)return;
		}
		if(st==2)
		{
			if(e!=null)
			{
				o.doPost=o.autoPost;
				if(o.fireEvt(this,o.Events.beforeSelectedTabChange,e))return;
				if(o.doPost){o.update(-1,"SelectedTab",this.index,1);return;}
			}
			igtab_selectTab(o,this.index);
			if(e!=null){o.fireEvt(this,o.Events.afterSelectedTabChange,e);this.focus();}
			return;
		}
		if(e!=null&&st<2)
		{
			o.fireEvt(this,(st==0)?o.Events.mouseOut:o.Events.mouseOver,e);
			if(o.selected==this.index)return;
		}
		this.doState(st);
		this.state=st;
	}
	this.doState=function(st)
	{
		if(st<0)st=(this.owner.enabled||this.state==2)?this.state:3;
		this.fixImg(st);
		if(this.element.className!=this.css[st])this.element.className=this.css[st];
		if(this.elemLeft!=null&&this.elemLeft.className!=this.owner.leftImg[st])this.elemLeft.className=this.owner.leftImg[st];
		if(this.elemRight!=null&&this.elemRight.className!=this.owner.rightImg[st])this.elemRight.className=this.owner.rightImg[st];
	}
	this.findControl=function(id)
	{
		var c=ig_csom.findControl(this.elemDiv,id);
		if(c==null)if((c=this.getTargetUrlDocument())!=null)c=ig_csom.findControl(c,id);
		return c;
	}
	this.isMy=function(n)
	{
		var e=this.element;
		if(e==n||this.elemLeft==n||this.elemRight==n)return true;
		for(var i=0;i<6;i++)
		{
			if((e=e.parentNode)==null)break;
			if(e==n)return true;
		}
		return false;
	}
}
function igtab_selectTab(owner,index,fix)
{
	if(owner==null)return;
	var o,e,i=owner.selected;
	if(i==null)
	{
		if((owner=igtab_getTabById(owner))==null)return;
		if((i=owner.selected)==null)return;
	}
	if(index==i||index<-1||owner.Tabs.length<=index)return;
	//old
	var obj=owner.elemEmpty;
	if(i>=0)
	{
		o=owner.Tabs[i];
		owner.vis(o.elemDiv);
		if((e=o.elemIframe)!=null){owner.vis(e);if(!owner.loadAllUrls)e.src=owner.dummy;}
		o.setState(o.enabled?0:3);
		if((e=o.elemIndex)!=null)e.tabIndex=-1;
	}
	else owner.vis(obj);
	//new
	if(index>=0)if((obj=owner.Tabs[index])==null)index=-1;
	if(fix!=1)owner.previousSelectedTab=owner.Tabs[(owner.selected==-2)?index:owner.selected];
	owner.selected=index;
	owner.update(-1,"SelectedTab",index);
	if(index<0){owner.vis(obj,"block");return;}
	if(!obj.enabled)obj.setEnabled(true);
	if(!obj.visible)obj.setVisible(true);
	obj.fixImg(2);
	obj.element.className=obj.css[2];
	if((e=obj.elemLeft)!=null)e.className=owner.leftImg[2];
	if((e=obj.elemRight)!=null)e.className=owner.rightImg[2];
	obj.state=2;
	if((e=obj.elemIndex)!=null)e.tabIndex=owner.tabIndex;
	if(owner.rows!=null)
	{
		e=obj.element;
		i=owner.rows.length;
		while(true)
		{
			if((e=e.parentNode)==null)break;
			if((o=e.nodeName)!=null)if(o.toUpperCase()=="TD"&&ig_csom.notEmpty(e.id))
			{
				while(--i>0)if(e==owner.rows[i]){owner.moveRow(i);break;}
				break;
			}
		}
	}
	o=obj.targetUrl;
	if(o.length>2&&(e=obj.elemIframe)!=null){if(e.src!=o)e.src=o;owner.vis(e,"block");}
	else owner.vis(obj.elemDiv,"block");
	if((o=igtab_getElementById(owner.ID+"_cp"))!=null)
	{
		i=obj.element.className.indexOf(" ");
		o.className=(i>2)?obj.element.className.substring(i+1):"";
		o.bgColor=obj.selColor;
		if(o.style!=null)o.style.backgroundColor=obj.selColor;
	}
	owner.ensureVisible();
}
function igtab_getTabFromElement(e)
{
	var ids=null,i=0;
	while(true)
	{
		if(e==null)return null;
		try{if(e.getAttribute!=null)ids=e.getAttribute("tabID");}catch(ex){}
		if(ig_csom.notEmpty(ids))break;
		if(++i>1)return null;
		e=e.parentNode;
	}
	ids=ids.split(",");
	var t=igtab_getTabById(ids[0]);
	if(t!=null&&ids.length>1)
	{
		if((i=parseInt(ids[1]))<1000)t=ig_csom.notEmpty(t.Tabs)?t.Tabs[i]:null;
		else t=t.buttons[i-1000];
	}
	return t;
}
