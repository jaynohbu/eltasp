 /*
  * Infragistics WebHtmlEditor CSOM Script: ig_htmleditor.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */
//js-version 1.5
//vs
if(typeof iged_all!="object")
	var iged_all=new Array();
function iged_getById(id)
{
	var a=iged_all;
	if(id)for(var i=0;i<a.length;i++)if(a[i].ID==id||a[i]._elem==id)return a[i];
	return null;
}
function iged_new(id,ta,tb,p1,p2,p3)
{
	this.ID=id;
	this._ta=ta;
	this._tb=tb;
	this._addLsnr=function(e,n,f)
	{
		try{if(e&&e.attachEvent){e.attachEvent("on"+n,f);return 1;}}catch(ex){}
		try{if(e&&e.addEventListener){e.addEventListener(n,f,false);return 1;}}catch(ex){}
		try
		{
		eval("var old=e.on"+n);
		var sF=f.toString();var i=sF.indexOf("(")+1;
		if((typeof old=="function")&&i>10)
		{
			old=old.toString();
			var args=old.substring(old.indexOf("(")+1,old.indexOf(")"));
			while(args.indexOf(" ")>0)args=args.replace(" ","");
			if(args.length>0)args=args.split(",");
			old=old.substring(old.indexOf("{")+1,old.lastIndexOf("}"));
			sF=sF.substring(9,i);
			if(old.indexOf(sF)>=0)return;
			var s="f=new Function(";
			for(i=0;i<args.length;i++){if(i>0)sF+=",";s+="\""+args[i]+"\",";sF+=args[i];}
			sF+=");"+old;
			eval(s+"sF)");
		}
		eval("e.on"+n+"=f");
		return 1;
		}catch(ex){}
		return 0;
	}
	var el=iged_el(id);
	this._addLsnr(el,"mousedown",iged_mainEvt);
	try
	{
		if(typeof __doPostBack=="function")
		{
			var txt=__doPostBack.toString(),v="iged_copy0();";
			var i0=txt.indexOf("{"),i1=txt.lastIndexOf("}");
			if(txt.indexOf(v)<0&&i0>0&&i1>i0)
				__doPostBack=new Function("eventTarget","eventArgument",v+txt.substr(i0+1,i1-i0-1));
		}
	}catch(er){}
	this._alert=function(s){if(!s)s="That feature is not supported by your browser";iged_closePop();window.alert(s);}
	this._prop=p1.split("|");//0-init,1-before,2-after,3-keydown,4-keypress,5-focus,6-blur,7-preview,8-fontStyle,9-urlType,10-htmlMode,11-palette,12-edit+P,13-rightMenu
	for(var i=9;i<this._prop.length;i++)this._prop[i]=parseInt(this._prop[i]);
	this._butS=p2.split("|");//button styles
	this._ddImgs=p3.split("|");//drop-down images
	if(!iged_all._clrNum)iged_all._clrNum=this._prop[11];
	this._addMenu=function()//not by this
	{
		if(this._prop[13]==0||iged_all._onMenu)return;
		iged_all._onMenu=true;
		this._addLsnr(this._doc(),"contextmenu",iged_mainEvt);
	}
	this._fire=function(id,act,p1,p2,p3,p4,p5)
	{
		var evt=this._evt;
		id=this._prop[id];
		if(evt==null)evt=this._evt=new Object();
		evt.key=null;
		evt.cancelPostBack=evt.needPostBack=evt.cancel=false;
		if(id&&id.length>0)try{eval(id+"(this,act,evt,p1,p2,p3,p4,p5)");}
		catch(ex){window.status="Can't eval "+id;}
		var p=evt.needPostBack?true:(this._post&&!evt.cancelPostBack&&!evt.cancel);
		this._post=false;
		if(p)if((p=this._ta.form)!=null)
		{
			iged_copy0();
			this._ta.value+="\03"+act+"\04";
			this._posted=true;
			p.submit();
			return true;
		}
		return evt.cancel==true;
	}
	this._swapS=function(s1,s2)
	{
		if(s1)s1=s1.style;if(s2)s2=s2.style;
		if(!s1||!s2)return;
		var bk=s1.backgroundColor,bc=s1.borderColor,c=s1.color,bs=s1.borderStyle;
		s1.backgroundColor=s2.backgroundColor;s1.borderColor=s2.borderColor;s1.color=s2.color;s1.borderStyle=s2.borderStyle;
		s2.backgroundColor=bk;s2.borderColor=bc;s2.color=c;s2.borderStyle=bs;
	}
	this._format=function(act,mod,restore,foc)
	{
		iged_closePop(act);
		this.focus();
		iged_all._noUndo=false;
		var e=this._elem,f=this._ie==true;
		try{
		if(f)
		{
			if(foc)e.setActive();
			if(restore&&iged_all._curRange)
				iged_all._curRange.select();
			e=e.document;
		}
		else
		{	
			if(foc)e.contentWindow.focus();
			e=e.contentDocument;
		}
		e.execCommand(act,f,(!mod||mod=="")?null:mod);
		}catch(ex){}
	}
	this.hasFocus=function(){return this._foc==true;}
	this.focus=function(){try{if(this._ie)this._elem.focus();else this._win().focus();}catch(ex){}}
	this.setText=function(txt)
	{
		var o=this,e=this._elem;
		if(o._ie)
		{
			if(!o._html)e.innerHTML=o._encode(txt);
			else e.innerText=o._decode(txt);
			return;
		}
		e=o._doc().body;
		if(!o._html)e.innerHTML=txt;
		else
		{
			e.innerHTML="";
			e.appendChild(document.createTextNode(txt));
		}
	}
	this._fixPath=function()
	{
		if(this._ie)this._fixSources(this._prop[9]);
	}
	this._onSelFont=function(e,act)
	{
		this._format(act,e.id,this._ie&&iged_all._curRange&&iged_all._curRange.boundingWidth!=0,true);
		this._syncBullets();
		this._afterSel(e);
	}
	this._afterSel=function(e)
	{
		iged_closePop(3);
		if(!this._ie)return;
		var elem=iged_el(e.name),t=e.innerText;
		if(elem&&t&&t!="")elem.firstChild.firstChild.firstChild.innerText=t;
	}
	this._onSubSup=function(s1,s2)
	{
		try
		{
			if(this._ie)
			{if(iged_all._curRange.queryCommandState(s2))this._format(s2,"",false,true);}
			else{if(this._elem.contentDocument.queryCommandState(s2))this._format(s2,"",false,true);}
			this._format(s1,"",false,true);
		}catch(ex){}
	}
	this._onToggleBdr=function(on)
	{
		if(!this._ie){this._alert();return;}
		this.focus();
		var toggleOn=(this._toggle===true)?false:true;
		toggleOn=((on == true)?on:toggleOn);
		var objTables=this._elem.getElementsByTagName("table");
		for(i=0;i<objTables.length;i++)
		{
			if(objTables[i].border == 0)
			{
				objTables[i].runtimeStyle.border=((toggleOn)?"#BCBCBC 1 dotted":"");
				objCells=objTables[i].cells;
				for(j=0;j<objCells.length;j++)
					objCells[j].runtimeStyle.border=((toggleOn)?"#BCBCBC 1 dotted":"");
			}
		}
		if(on)this._toggle=true;
		else this._toggle=this._toggle!==true;
	}
	this._onClr=function(clr)
	{
		iged_closePop("clr");
		if(!clr)clr="";
		var f=this._clrTarget;
		if(f)
		{
			try
			{
				f.value=clr;
				f.style.backgroundColor=(clr=="")?"#F0F0F0":clr;
			}catch(ex){}
			return;
		}
		f=this._popF==1;
		if(this._ie)this._format(f?"forecolor":"backcolor",clr,true,true);
		else this._format(f?"forecolor":"hilitecolor",clr,false,true);
		if(f)this._syncBullets();
	}
	this._fixPop=function(e,rc,skip)
	{
		if(!e||!e.getAttribute)return;
		var a=e.getAttribute("act");
		if(a&&a.length>0)this._choiceAct=a;
		a=e.getAttribute("sts");
		if(a&&a.length>0)this._itemStyle=a.split("?");
		a=e.getAttribute("igf");
		if(e.nodeName!="INPUT")e.unselectable="on";
		if(a&&a.length==1)
		{
			var f=this._itemStyle,s=e.style;
			if(a=="m"&&rc)
			{
				var cl=e.onclick,d="none";if(!cl)return;cl=iged_replaceS(cl.toString(),"\"","'");
				if(rc==3){if(cl.indexOf("Image'")>0)d="";}
				else if(rc==2){if(cl.indexOf("Image'")<0)d="";}
				else if(cl.indexOf("'Table")<1&&cl.indexOf("'Cell")<1&&cl.indexOf("Image'")<1)d="";
				s.display=d;
			}
			if(a=="c"||a=="m"||a=="l")
			{
				if(skip)return;
				s.cursor=(a=="m")?"pointer":"default";
				this._addLsnr(e,"mouseover",iged_choiceEvt);
				this._addLsnr(e,"mouseout",iged_choiceEvt);
				e._b=e._b2=s.backgroundColor;
				e._f=e._f2=s.color;
				if(a=="m"){if(f)e._b2=f[0];}
				else
				{
					e._b2="#316AC5";e._f2="white";
					this._addLsnr(e,"click",iged_choiceEvt);
					if(a=="l")
					{
						s.fontWeight="bold";
						s.fontFamily="verdana,tahoma";
						s.fontSize="12px";
						return;
					}
					e._act=this._choiceAct;
					e.noWrap=true;
					if((!s.fontFamily||s.fontFamily=="")&&f&&f[0]!="")s.fontFamily=f[0];
					if((!s.fontSize||s.fontSize=="")&&f&&f[1]!="")s.fontSize=f[1];
				}
			}
			else try{eval(this._prop[8]);}catch(ex){}
			return;
		}
		e=e.childNodes;
		if(e)for(var i=0;i<e.length;i++)this._fixPop(e[i],rc,skip);
	}
	this._fixMouse=function(e,p)
	{
		if(!e||!e.getAttribute)return;
		var i=-1,a=e.getAttribute("mm");
		e.unselectable="on";
		if(p||!a||a.length<1)
		{
			e=e.childNodes;
			if(e)while(++i<e.length)this._fixMouse(e[i],p);
			return;
		}
		var dd=a=="t";
		if(dd)e.mm="x";
		else
		{
			var m=a.split("|"),s=e.style,b=this._butS;
			if((i=b.length)>m.length){a=null;m=new Array();}
			while(i-->0)if(!a||m[i].length<2)
			{
				m[i]=b[i];
				if(i==0)s.backgroundColor=b[i];
				if(i==1)s.borderColor=b[i];
				if(i==2)s.borderStyle=b[i];
			}
			this._addLsnr(e,"mouseup",iged_mEvt);
			e.mm=m;
		}
		a=e.getAttribute("im2");
		if(a&&a.length>5)e.imgs=a.split("|");
		if(dd)for(i=1;i<4;i++)if(e.imgs[i]=="")e.imgs[i]=this._ddImgs[i-1];
		this._addLsnr(e,"mouseover",iged_mEvt);
		this._addLsnr(e,"mouseout",iged_mEvt);
		this._addLsnr(e,"mousedown",iged_mEvt);
		this._fixMouse(e,true);
	}
	this._clrDrop=function(e,doc)
	{
		if(!e)return;
		this._clrTarget=e;
		this._pos(e,this._clrInit0(iged_all._doc0=doc),8);
	}
	this._delay=function(){iged_all._canCloseCur=false;window.setTimeout("iged_all._canCloseCur=true",100);}
	this._pop=function(id,x,evt,flag,h,rc)
	{
		if(this._isKnown(id)&&this._doc().selection)iged_all._curRange=this._doc().selection.createRange();
		iged_closePop();
		var pan;
		this._clrTarget=null;
		if(id=="iged_0_clr"){pan=this._clrInit0();this._popF=x;x=null;}
		else pan=iged_el(id);
		if(!pan)return;
		this._choiceAct=this._itemStyle=null;
		if(!pan._igf||flag==3){this._fixPop(pan,rc,pan._igf);pan._igf=true;}
		var s=pan.style;
		if(x)
		{
			x=x.split("?");
			if(h!=null)x[7]=h;
			if(x[0])s.backgroundColor=x[0];if(x[1])s.borderColor=x[1];
			if(x[2])s.borderStyle=x[2];if(x[3])s.borderWidth=x[3];
			if(x[4])s.fontFamily=x[4];if(x[5])s.fontSize=x[5];if(x[6])s.color=x[6];
			if(x[7])s.height=x[7];if(x[8]){s.width=x[8];s.paddingLeft="2px";}
		}
		this._pos(evt,pan,flag);
		iged_all._pop=pan;
		iged_all._popID=this.ID;
		this._delay();
	}
	this._isKnown=function(id)
	{
		var i=id.length;
		return this._ie&&(id.indexOf("iged_0_")==0||id.indexOf("_iged_dlg")==i-9);
	}
	this._body=function(){return this._doc().body;}
	this._pan=function()
	{
		var e=iged_el("iged_0_div");
		if(!e)try
		{
			e=document.createElement("DIV");
			document.body.insertBefore(e,document.body.firstChild);
			e.id="iged_0_div";
		}catch(ex){}
		return e;
	}
	this._getSelImg=function()
	{
		if(!this._ie)return iged_all._curImg;
		if(this._doc().selection.type!="Control")return null;
		iged_all._curRange=this._doc().selection.createRange();
		if(iged_all._curRange.item(0).tagName=="IMG")return iged_all._curRange.item(0);
		return null;
	}
	this._fixListFormat=function()
	{
		if(!this._ie)return;
		iged_all._curRange=this._doc().selection.createRange();
		if(iged_all._curRange.htmlText.indexOf("<BR>") > -1)
		{
			
		}
	}
	this._cssFont=function(f)
	{
		try
		{
			if(f.length==1)f=parseInt(f,10);
			if(f==1)return "xx-small";if(f==2)return "x-small";if(f==3)return "small";
			if(f==4)return "medium";if(f==5)return "large";if(f==6)return "x-large";if(f>6)return "xx-large";
		}catch(e){return "";}
		return f;
	}
	this._syncBullets=function()
	{
		var lis=document.getElementsByTagName("li");
		for(var i=0;i<lis.length;i++)
		{
			var li=lis[i];
			if(li.children.length>0)
			{
				if(li.children[0].tagName.toLowerCase()=="font")
				{
					var e=li.children[0];
					if(e.size!="")li.style.fontSize=this._cssFont(e.size);
					li.style.fontFamily=e.face;
					li.style.color=e.color;
				}
			}
		}
		iged_all._needSync=false;
	}
	this._setOl=function()
	{
		var ol=null;
		if(this._ie)
		{
			iged_all._curRange=this._doc().selection.createRange();
			ol=iged_fromTag("ol",iged_all._curRange.parentElement());
		}
		else
		{
			var sel=this._elem.contentWindow.getSelection();
			ol=iged_fromTag("ol", sel.getRangeAt(0).startContainer);
		}
		if(!ol)return;
		var i=iged_nestCount(ol,"OL")%3;
		if(i==0)ol.type="i";
		if(i==1)ol.type="1";
		if(i==2)ol.type="a";
	}
	this._cleanWord=function(txt)
	{
		txt=txt.replace(/<(\/)?strong>/ig,"<$1B>");
		txt=txt.replace(/<(\/)?em>/ig,"<$1I>").replace(/<P class=[^>]*>/gi, "<P>").replace(/<LI class=[^>]*>/gi, "<LI>");
		txt=txt.replace(/<\\?\??xml[^>]>/gi,"").replace(/<\/?\w+:[^>]*>/gi,"").replace(/<SPAN[^>]*>/gi," ");
		txt=txt.replace(/<\/SPAN>/gi,"").replace(/\r\n/g,"").replace(/\n/g,"").replace(/\r/g,"");
		txt=txt.replace(/<P/gi,"\n<P").replace(/<H/gi,"\n<H").replace(/<\/H/gi,"<\/H");
		txt=txt.replace(/<P>\n/gi,"").replace(/<T/gi,"\n<T").replace(/<TD>\n/gi,"<TD>");
		txt=txt.replace(/<\/TR>/gi,"\n<\/TR>").replace(/<\/TR>\n/gi,"<\/TR>").replace(/<UL/gi,"\n<UL");
		txt=txt.replace(/<\/UL>/gi,"\n<\/UL>").replace(/<OL/gi,"\n<OL").replace(/<\/OL>/gi,"\n<\/OL>");
		txt=txt.replace(/<LI/gi,"\n<LI").replace(/<DL/gi,"\n<DL").replace(/<\/DL>/gi,"<\/DL>\n").replace(/<DD/gi,"\n<DD");
		
		txt=escape(txt);
		txt=iged_replaceS(txt,"%u2019","'");txt=iged_replaceS(txt,"%u201C","\"");txt=iged_replaceS(txt,"%u201D","\"");
		txt=iged_replaceS(txt,"%u2022","");txt=iged_replaceS(txt,"%u2026","...");
		return unescape(txt);
	} 
	this._toClr=function(c)
	{
		var a=Math.floor(c);
		c-=a;if(a>=15)c=a=15;
		if(c>0.8)c="F";else if(c>0.6)c="A";else if(c>0.3)c=5;else c=0;
		return ((a<10)?a:String.fromCharCode(55+a))+""+c;
	}
	this._clrInit=function()
	{
		var cols=iged_all._clrNum;
		if(!cols)cols=11;
		for(var i=0;i<cols;i++)for(var j=0;j<13;j++)
		{
			var e=iged_el("iged_clr_"+i+"_"+j);
			if(!e)continue;
			e.clr=e.style.backgroundColor=e.style.borderColor=iged_all._cur._clrGet(i,j,cols);
		}
	}
	this._clrGet=function(i,j,x)
	{
		var r,g,b,v=iged_all._clrRGB;
		if(v==null)v=iged_all._clrRGB=0;
		if(j--==0)r=g=b=(i==0)?0:(1+i*14.5/(x-1));
		else
		{
			var m=Math.floor(j/4),c=(x-1)/2;
			var z=[(i<=c)?0:15*(i-c+3)/(c+3),15-(j%4)*3,(i>c)?9:15*(c-i)/c];
			g=z[m%3];r=z[(m+1)%3];b=z[(m+2)%3];
		}
		if(v>0){r+=(15-r)*v;g+=(15-g)*v;b+=(15-b)*v;}
		if(v<0){v=-v;r/=v;g/=v;b/=v;}
		return "#"+this._toClr(r)+this._toClr(g)+this._toClr(b);
	}
	this._newE=function(doc,t,p){p.appendChild(t=doc.createElement(t));t.unselectable="on";return t;}
	this._clrInit0=function(doc)
	{
		var o=doc,clr=doc?doc.getElementById("iged_clr0_id"):iged_all._clr;
		if(clr)
		{
			try{iged_el("iged_c_c0").style.backgroundColor="";iged_el("iged_c_c1").value="";}catch(ex){}
			return clr;
		}
		if(!doc)doc=window.document;
		clr=doc.createElement("DIV");
		if(!o)iged_all._clr=clr;
		doc.body.insertBefore(clr,doc.body.firstChild);
		clr.id="iged_clr0_id";
		var s=clr.style;o=iged_all._cur;
		s.position="absolute";s.display="none";s.zIndex=100001;
		var sp,t0=doc.createElement("TABLE");
		clr.appendChild(t0);
		s=t0.style;s.backgroundColor="#E0E0E0";s.border="solid 1px #808080";
		t0.border=0;t0.cellSpacing=3;
		var tb0=doc.createElement("TBODY");
		t0.appendChild(tb0);
		var r=doc.createElement("TR");
		tb0.appendChild(r);
		var c0=o._newE(doc,"TD",r);
		c0.noWrap=true;c0.align="center";
		for(var i=0;i<9;i++)
		{
			sp=o._newE(doc,"SPAN",c0);
			var c=(i==4)?"&nbsp;0":((i<4)?("-"+(4-i)):("+"+(i-4)));
			sp.innerHTML=""+c;
			s=sp.style;
			s.border="solid 1px #90C0C0";s.cursor="pointer";s.fontSize="11px";s.fontFamily="courier new";
			r="Click to show ";
			if(i==4){iged_all._clrSelBut=sp;r+="Bright";}
			else r+=(i<4)?"Darker":"Lighter";
			sp.title=r+" colors";
			s.color=(i==4)?"red":"black";s.margin="1px";
			c=6+i*1.2;
			s.backgroundColor="#"+o._toClr(c)+o._toClr(c)+o._toClr(c);
			sp.id="iged_c_b"+i;
			sp.setAttribute("c","b"+i);
			o._addLsnr(sp,"mouseout",iged_clrEvt);
			o._addLsnr(sp,"mouseover",iged_clrEvt);
			o._addLsnr(sp,"click",iged_clrEvt);
		}
		r=doc.createElement("TR");
		tb0.appendChild(r);
		var c1=o._newE(doc,"TD",r);
		c1.style.border="solid blue 1px";
		r=doc.createElement("TR");
		tb0.appendChild(r);
		var c2=o._newE(doc,"TD",r);
		c2.noWrap=true;c2.align="center";
		sp=o._newE(doc,"SPAN",c2);
		s=sp.style;
		s.border="solid 1px black";s.fontSize="16px";s.fontFamily="courier new";s.cursor="default";
		sp.title="Output color";
		sp.innerHTML="&nbsp;&nbsp;";
		sp.id="iged_c_c0";
		sp=o._newE(doc,"SPAN",c2);
		sp.innerHTML="&nbsp;";
		var f=doc.createElement("INPUT");
		f.title="Enter color and press Enter key";
		c2.appendChild(f);
		o._addLsnr(f,"keydown",iged_clrEvt);
		o._addLsnr(f,"keyup",iged_clrEvt);
		s=f.style;s.fontSize="12px";s.width="130px";
		f.id="iged_c_c1";
		var t=doc.createElement("TABLE");
		c1.appendChild(t);
		t.cellSpacing=1;
		var i,j,tb=doc.createElement("TBODY");
		t.appendChild(tb);
		var cols=iged_all._clrNum,w=13;
		if(!cols)cols=11;if(cols!=11)w=(cols<11)?18:10;
		for(j=0;j<13;j++)
		{
			r=doc.createElement("TR");
			tb.appendChild(r);
			for(i=0;i<cols;i++)
			{
				var c=o._newE(doc,"TD",r);
				c.innerHTML="&nbsp;";
				c.id="iged_clr_"+i+"_"+j;
				c.title="Click to select";
				s=c.style;
				s.cursor="pointer";s.width=w+"px";s.height=(w+3)+"px";s.fontSize="5px";s.border="solid 1px blue";
				c.setAttribute("c","c");
				o._addLsnr(c,"mouseout",iged_clrEvt);
				o._addLsnr(c,"mouseover",iged_clrEvt);
				o._addLsnr(c,"click",iged_clrEvt);
			}
		}
		this._clrInit();
		return clr;
	}
	this._pos=function(evt,pan,flag)
	{
		var p={x:100,y:80};
		if(!evt)if((evt=window.event)==null)return p;
		var pe,f,z,x=0,y=0,x0=0,y0=0,e=(flag==8)?evt:evt.srcElement;
		if(!e)if((e=evt.target)==null)return p;
		var elem=e,doc=iged_all._doc0;if(!doc)doc=window.document;
		if(flag==2)
		{
			while((e=e.parentNode)!=null)if(e.nodeName=="TABLE")break;
			if(!e)e=elem;
		}
		var ed=e,elemW=e.offsetWidth,elemH=e.offsetHeight,body=doc.body;
		if(!elemH)elemH=20;
		var ieBug=false,s=null,bp=body.parentNode,panW=80,panH=80;
		if(pan)
		{
			var par=(flag==8)?elem.form:this._ta.form;
			pe=pan.parentNode;f=pe.tagName;
			if(f=="FORM"){par=null;if(pe.style)if((f=pe.style.position)!=null)if(f.toLowerCase()=="absolute")par=body;}
			else if(f=="BODY"||f=="HTML")par=null;
			if(par)if(!this._move(pan,par))if(par!=body)this._move(pan,body);
			if(pan.offsetHeight<5&&par&&par!=body)this._move(pan,body);
			s=pan.style;
			s.position="absolute";s.display="";s.visibility="visible";if(!s.zIndex)s.zIndex=99999;
			if(flag==3){x0=evt.clientX+body.scrollLeft+10;y0=evt.clientY+body.scrollTop;elemH=10;}
			panW=pan.offsetWidth;panH=pan.offsetHeight;
			ieBug=this._ie;
		}
		var ok=0,moz=0;pe=e;
		while(e!=null)
		{
			if(ok<1||e==body){if((z=e.offsetLeft)!=null)x+=z;if((z=e.offsetTop)!=null)y+=z;}
			if(e.nodeName=="HTML")
			{
				if(!this._ie&&e.parentNode.body==this._body()){moz=1;e=this._elem;x=y=0;}
				else body=e;
			}
			if(e==body)break;
			z=e.scrollLeft;if(z==null||z==0)z=pe.scrollLeft;if(z!=null&&z>0)x-=z;
			z=e.scrollTop;if(z==null||z==0)z=pe.scrollTop;if(z!=null&&z>0)y-=z;
			pe=e.parentNode;if((e=e.offsetParent)==null)e=pe;if(pe.tagName=="TR")pe=e;
			if(e==body&&pe.tagName=="DIV"){e=pe;ok++;}
		}
		if(x0!=0){x=x0+x*moz;y=y0+y*moz;}
		else if(pan&&doc.elementFromPoint)
		{
			x0=x;y0=y;ok=true;
			var i=1,xB=body.scrollLeft,yB=body.scrollTop;
			while(++i<16)
			{
				z=(i>2)?((i&2)-1)*(i&14)/2*5:2;
				e=doc.elementFromPoint(x+z-xB,y+z-yB);
				if(!e||e==ed||e==elem)break;
			}
			if(i>15||!e)ok=false;
			x+=z;y+=z;i=0;z=0;
			while(ok&&++i<22)
			{
				if(z==0)x--;else y--;
				e=doc.elementFromPoint(x-xB,y-yB);
				if(!e||i>20)ok=false;
				if(e!=ed&&e!=elem)if(z>0)break;else{i=z=1;x++;}
			}
			if(ok){x--;y--;}else{x=x0;y=y0;}
		}
		y+=elemH;
		z=body.clientHeight;
		if(z==null||z<20){z=pe.offsetHeight;f=body.offsetHeight;if(f>z)z=f;}
		else{if(bp&&(f=bp.offsetHeight)!=null)if(f>panH&&f<z)z=f-10;}
		if((f=body.scrollTop)==null)f=0;if(f==0&&bp)if((f=bp.scrollTop)==null)f=0;
		if(z<y-f+panH){if(y-f-3>panH+elemH)y-=panH+elemH;else y=z+f-panH;}
		if(y<f)y=f;
		z=body.clientWidth;
		if(z==null||z<20){z=pe.offsetWidth;f=body.offsetWidth;if(f>z)z=f;}
		else{if(bp&&(f=bp.offsetWidth)!=null)if(f>panW&&f<z)z=f-20;}
		if((f=body.scrollLeft)==null)f=0;if(f==0&&bp)if((f=bp.scrollLeft)==null)f=0;
		if(x+panW>z+f){x=z+f-panW;if(x<f)x=f;}
		if(x<f)x=f;
		p.x=x;p.y=y;
		if(s){s.left=x+"px";s.top=y+"px";}
		if(ieBug)this._ieBug(pan,x,y);
		return p;
	}
	this._move=function(e,par){try{e.parentNode.removeChild(e);par.insertBefore(e,par.firstChild);return true;}catch(ex){}return false;}
	this._cellProp=function()
	{
		var c=iged_all._curCell;
		if(!c)return;
		var alignH=iged_el("iged_cp_ha").value,alignV=iged_el("iged_cp_va").value;
		var w=iged_el("iged_cp_w").value,h=iged_el("iged_cp_h").value,noWrap=iged_el("iged_cp_nw").checked;
		var clrBk=iged_el("iged_cp_bk1").value,clrBd=iged_el("iged_cp_bd1").value;
		if(alignH&&alignH!="default")c.align=alignH;
		if(alignV&&alignV!="default")c.vAlign=alignV;
		if(w)c.width=w;
		if(h)c.height=h;
		if(noWrap)c.noWrap=noWrap;
		c.bgColor=clrBk;
		if(this._ie)c.borderColor=clrBd;
		else{c.setAttribute("bc",clrBd);if(clrBd!="")clrBd+=" solid 1px";c.style.border=clrBd;}
		iged_all._curCell=null;
		iged_closePop();
	}
	this._fixMouse(tb);
	if(!iged_all._submit)if(this._addLsnr(ta.form,"submit",iged_copy0)==1)iged_all._submit=true;
	var i=iged_all.length;
	if(!i&&i!==0)iged_all.length=i=0;
	iged_all._cur=iged_all[i]=this;
	if(i<=iged_all.length)iged_all.length=++i;
}
function iged_mainEvt(e)
{
	if(!e)if((e=window.event)==null)return;
	var o=null,src=e.srcElement;
	if(!src)if((src=e.target)==null)src=this;
	var ee=src,t=src.ownerDocument;
	var inElem=iged_getById(ee);
	if(t)t=t.id;if(!t)t=src.id;
	if(t&&t.indexOf("ig_d_")==0)o=iged_getById(t.substring(5));
	if(o){if(src.src&&src.src.length>1)iged_all._curImg=src;}
	else while((ee=ee.parentNode)!=null)try
	{
		if(iged_getById(ee))inElem=true;
		if(ee.getAttribute)if((o=ee.getAttribute("ig_id"))!=null)
		if((o=iged_getById(o))!=null)break;
	}
	catch(ex){}
	if(!o)return;
	switch(e.type)
	{
		case "keydown":t=3;break;
		case "keypress":t=4;break;
		case "focus":t=5;break;
		case "blur":t=6;break;
		case "contextmenu":t=7;break;
		case "mousedown":t=8;break;
		default:return;
	}
	if(t<7)
	{
		var k=e.keyCode;
		if(!k||k==0)k=e.which;
		ee=o._fire(t,k);
		if(t<5)
		{
			if(ee){if(!o._posted)iged_cancelEvt(e);}
			else
			{
				if((k=o._evt.key)!=null)e.keyCode=k;
				if(t==3&&o._onKey)o._onKey(e);
			}
			return;
		}
	}
	if(t==7)
	{
		if((t=o._prop[13])!=0)
		{
			iged_cancelEvt(e);
			if(t==2)iged_act("RightClick:pop","","",e,"r");
		}
		return;
	}
	if(t==6){o._foc=false;return;}
	if(o._ie)
	{
		iged_all._curRange=o._doc().selection.createRange();
		if(!o._2D)o._doc().execCommand("2D-Position",true,o._2D=true);
	}
	if(iged_all._canCloseCur)iged_closePop();
	iged_all._cur=o;
	if(t==5)o._foc=true;
	if(t==8&&!inElem&&!o._foc)window.setTimeout("iged_all._cur.focus()",0);
}
function iged_mEvt(e)
{
	if(!e)if((e=window.event)==null)return;
	var m=null,i=0,el=e.srcElement;
	if(!el)if((el=e.target)==null)el=this;
	while(++i<7&&el)try{if((m=el.mm)!=null)break;el=el.parentNode;}catch(ex){}
	if(!m)return;
	var i0=0,s=el.style,t=e.type.substring(5);
	var im=el.imgs;
	if(im)i=im.length;
	if(t=="over"){i0=3;i=(i<4)?1:3;}
	else if(t=="down"){i0=6;i=2;}
	else if(t=="up"){i0=9;i=(i<4)?1:3;}
	else i=1;
	if(m.length>9)try{eval("s.backgroundColor=m["+i0+"];s.borderColor=m["+(i0+1)+"];s.borderStyle=m["+(i0+2)+"];");}catch(ex){}
	if(im)if((e=iged_el(im[0]))!=null)e.src=im[i];
}
function iged_choiceEvt(e)
{
	if(!e)if((e=window.event)==null)return;
	var a,s=0,el=e.srcElement;
	if(!el)if((el=e.target)==null)el=this;
	while(++s<6&&el)try
	{
		a=el.getAttribute;if(a)a=el.getAttribute("igf");if(a=="c"||a=="m"||a=="l")break;
		el=el.parentNode;
	}catch(ex){}
	if(s>5)return;
	var p=el.innerHTML;s=el.style;
	switch(e.type)
	{
		case "mouseover":s.backgroundColor=el._b2;s.color=el._f2;return;
		case "mouseout":s.backgroundColor=el._b;s.color=el._f;return;
		case "click":if(a=="l"){iged_act("characterdialog",el,p,"select");return;}
			s=el._act;if(s&&s!="none")iged_act(s,el,p,"select");return;
	}
}
function iged_clrEvt(e)
{
	if(!e)if((e=window.event)==null)return;
	var el=e.srcElement,o=iged_all._cur;
	if(!el)if((el=e.target)==null)el=this;
	var a=el.getAttribute("c"),s=el.style;
	if(a=="c"||(a&&a.length<2))a=null;
	var c=a?"#90C0C0":el.clr,d=iged_el("iged_c_c0"),f=iged_el("iged_c_c1");
	if(o)try{switch(e.type)
	{
		case "click":if(!a){s.borderColor=c;o._onClr(c);}
			else
			{
				a=parseInt(a.substring(1))-4;
				if(a<0)a=(a*2-5.5)/7;if(a>0)a=(a*3+1)/15;
				iged_all._clrSelBut.style.color="black";
				s.color="red";iged_all._clrSelBut=el;
				iged_all._clrRGB=a;o._clrInit();
			}return;
		case "mouseout":s.borderColor=c;return;
		case "mouseover":
			if(!a)d.style.backgroundColor=f.value=c;
			s.borderColor="black";
			try{f.focus();}catch(ex){}
			return;
		case "keyup":try{d.style.backgroundColor=el.value;o._clrNew=el.value;}catch(er){};return;
		case "keydown":
			var k=e.keyCode;c=o._clrNew;
			if(!k||k==0)k=e.which;
			if(k==27)o._onClr("");
			if(k==13){o._onClr(c);iged_cancelEvt(e);}
			return;
	}}catch(ex){}
}
function iged_act(key,p1,p2,p3,p4,p5)
{
	var o=iged_all._cur,act=key.toLowerCase();
	if(!o)return;
	var i=act.indexOf(":");
	if(i>0){key=key.substring(0,i);act=act.substring(i+1);if(act=="_0"){act=key;o._post=true;}}
	if(o._fire(1,key,p1,p2,p3,p4,p5))return;
	switch(act)
	{
		case "fontname":case "fontsize":o._onSelFont(p1,act);break;
		case "fontformatting":o._onSelFont(p1,"formatblock");break;
		case "fontstyle":o._onApplyStyle(p1);break;
		case "insert":o._onInsert(p1);break;
		case "superscript":o._onSubSup(act,"subscript");break;
		case "subscript":o._onSubSup(act,"superscript");break;
		case "bold":case "italic":case "underline":case "strikethrough":
		case "justifyleft":case "justifycenter":case "justifyright":case "justifyfull":
		case "redo":
			o._format(act,"",false,true);break;
		case "print":o.print();break;
		case "undo":if(iged_all._noUndo)return;o._format(act,"",false,true);break;
		case "indent":o._format(act,"",false,true);o._setOl();break;
		case "outdent":o._format(act,"",false,true);o._setOl();break;
		case "removelink":o._format("unlink","",false,true);break;
		case "insertlink":o._onLink();break;
		case "togglepositioning":if(!o._ie){o._alert();return;}
			var sElem=o._getSelElem();
			if(!sElem){o._alert("You must select an image or text before toggling the absolute position of the element.");return;}
			sElem.style.position=(sElem.style.position=="absolute")?"static":"absolute";
			break;
		case "sendbackward":case "bringforward":
			if(!o._ie){o._alert();return;}
			var sElem=o._getSelElem();
			if(sElem)sElem.style.zIndex+=((act=="sendbackward")?1:-1);
			else{o._alert("You must select an image or text before changing the layer position.");return;}
			break;
		case "toggleborders":o._onToggleBdr();break;
		case "wordcount":
			var txt=iged_replaceS(iged_getEditTxt(),"<BR>"," ");
			txt=iged_replaceS(txt,"<P>","");txt=iged_replaceS(txt,"</P>"," ");
			txt=iged_stripTags(txt);
			txt=iged_replaceS(iged_replaceS(txt,"\n"," "),"\r","");
			txt=iged_replaceS(txt,"&nbsp;"," ");
			var words=0,chars=txt.length,clean=iged_replaceS(txt," ","").length;
			txt=iged_replaceS(txt,"  "," ");
			if(chars>0)
			{
				txt=txt.split(" ");
				for(var i=0;i<txt.length;i++)if(txt[i].length>0)words++;
			}
			var t="\t Word Count\r\n_______________________________\t\r\n\r\n";
			t+=" Words:\t\t\t"+words+"\r\n Characters:\t\t"+chars+"\r\n";
			t+=" Characters (no spaces):\t"+clean;
			o._alert(t);
			break;
		case "orderedlist":case "unorderedlist":
			o._fixListFormat();
			o._format("insert"+act,"",false,true);
			iged_all._needSync=true;
			break;
		case "copy":case "cut":case "paste":
			try
			{
				if(!o._ie)netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
				o._format(act,"",p1,!p1);
			}
			catch(e){o._alert();return;}
			break;
		case "preview":
			var win=window.open(o._prop[7],"_blank","width=800, height=600, location=no, menubar=no, status=no, toolbar=no, scrollbars=yes, resizable=yes",false);
			var doc=o._ie?o._elem:o._body();
			win.document.write("<html><head><title>Page Preview</title></head><body topmargin='0' leftmargin='0'>"+doc.innerHTML+"</body></html>");
			break;
		case "pastehtml":
			try
			{
				var cd=window.clipboardData;
				if(cd)
				{
					cd="<P>"+cd.getData("Text").toString()+"</P>";
					cd=o._cleanWord(cd);
					iged_insText(cd,false,true);
					break;
				}
			}catch(err){}
			o._alert();
			return;
		case "cleanword":
			if(o._ie)
			{
				o.setText(o._cleanWord((!o._html)?o._elem.innerHTML:o._elem.innerText));
				break;
			}
			var body=o._body();
			if(!o._html)
				body.innerHTML=o._cleanWord(body.innerHTML);
			else
			{
				var html=body.ownerDocument.createRange();
				html.selectNodeContents(body);
				html=document.createTextNode(o._cleanWord(html.toString()));
				body.innerHTML="";
				body.appendChild(html);
			}
			break;
		case "zoom25":case "zoom50":case "zoom75":case "zoom100":case "zoom200":case "zoom300":case "zoom400":case "zoom500":case "zoom600":
			if(o._ie)o._elem.style.zoom=act.substring(4)+"%";
			else {o._alert();return;}
			iged_closePop("Zoom");
			break;
		case "insertcolumnright":case "insertcolumnleft":o._insCol(act.substring(12));break;
		case "insertrowabove":case "insertrowbelow":o._insRow(act.substring(9));break;
		case "increasecolspan":case "decreasecolspan":o._colSpan(act.substring(0,8));break;
		case "increaserowspan":case "decreaserowspan":o._rowSpan(act.substring(0,8));break;
		case "deleterow":o._delRow();break;
		case "deletecolumn":o._delCol();break;
		case "insertimage":
			var img=o._getSelImg();
			if(img)iged_all._curImg=img;
		case "insertwindowsmedia":case "insertflash":case "upload":case "open":
			iged_closePop();
			iged_modal(p1,p2,p3,p4);break;
		case "findreplace":if(o._ie)return;
			if(!o._elem.contentWindow.nsFindInstData)o._elem.contentWindow.nsFindInstData=new Function();
			o._elem.contentWindow.find();
			break;
		case "pop":
			p6=null;
			if(p4=="r")
			{
				p1="iged_0_rcm";p4=3;p6=1;
				if((iged_all._curImg=o._getSelImg())!=null)p6=3;
				else if(o._inTbl())p6=2;
			}
			if(p4=="t")
			{
				var tbl=o._inTbl();
				p4=null;p1=tbl?"iged_0_itm":"iged_0_ito";
				if(o._ie)
				{
					o._elem.setActive();
					iged_all._curRange=o._doc().selection.createRange();
					iged_all._curMenuCell=iged_all._curMenuTable=iged_all._curMenuRow=null;
					if(tbl)
					{
						var par=iged_all._curRange.parentElement();
						var c=iged_fromTag("td",par);if(!c)c=iged_fromTag("th",par);
						iged_all._curMenuCell=c;
						iged_all._curMenuTable=iged_fromTag("table",par);
						iged_all._curMenuRow=iged_fromTag("tr",par);
					}
				}
			}
			if(p1&&p1.length>0)o._pop(p1,p2,p3,p4,p5,p6);
			break;
		case "popwin":o._popWin(p1,p2,p3,p4,p5);break;
		case "ruledialog":o._insRule(p1,p2,p3,p4,p5);break;
		case "bookmarkdialog":o._insBook(p1);break;
		case "characterdialog":iged_insText(p2,true,true);break;
		case "tabledialog":o._insTbl();break;
		case "celldialog":o._cellProp();break;
		case "finddialog":if(!o._find0)return;o._find0(1);break;
		case "replacedialog":if(!o._find0)return;o._find0(2);break;
		case "replacealldialog":if(!o._find0)return;o._find0(3);break;
		case "changeview":o._showHtml(p1);break;
		case "spellcheck":i=(typeof ig_getWebControlById=="function")?ig_getWebControlById(p1):null;
			if(i&&i.checkTextComponent)i.checkTextComponent(o.ID);
			else o._alert("SpellChecker with id '"+p1+"' was not found");
			break;
		default:return;
	}
	o._fire(2,key,p1,p2,p3,p4,p5);
}
function iged_getEditTxt()
{
	var o=iged_all._cur;
	if(!o)return "";
	if(!o._ie)return o._body().innerHTML;
	if(!o._html)
	{
		o._fixPath();
		return o._decode(o._elem.innerHTML);
	}
	return o._elem.innerText;
}
function iged_imgMouseAct(id,img){id=iged_el(id);if(id)id.src=img;}
function iged_changeSt(elem,clrBk,clrBd,stBd){var s=elem.style;s.backgroundColor=clrBk;s.borderColor=clrBd;s.borderStyle=stBd;}
function iged_closePop(s)
{
	var p=iged_all._clr;
	if(p&&p.style.display!="none")
	{
		if(p._ieBug){p._ieBug.display="none";p._ieBug=null;}
		p.style.display="none";
	}
	var doc=iged_all._doc0;
	if(doc)if((doc=doc.getElementById("iged_clr0_id"))!=null)doc.style.display="none";
	iged_all._doc0=null;
	if(s=="clr")return;
	p=iged_all._pop;
	if(!p||p.style.visibility=="hidden")return;
	var o=iged_getById(iged_all._popID);
	var foc=s!=null;if(s==3||!s)s="";
	if(o._fire(1,"ClosePopup",s))if(s)return;
	if(p._ieBug){p._ieBug.display="none";p._ieBug=null;}
	p.style.visibility="hidden";
	o._fire(2,"ClosePopup",s);
	iged_all._canCloseCur=false;
	if(foc)o.focus();
}
function iged_stripTags(html) 
{
   html=html.replace(/\n/g, ".$!$.")
   var aScript=html.split(/\/script>/i);
   for(i=0;i<aScript.length;i++)
      aScript[i]=aScript[i].replace(/\<script.+/i,"");
   html=aScript.join("");
   html=html.replace(/\<[^\>]+\>/g,"").replace(/\.\$\!\$\.\r\s*/g,"").replace(/\.\$\!\$\./g,"");
   return html.replace(/\r\ \r/g,"");
} 
function iged_nestCount(elem,tag)
{
	var i=0,id=iged_all._cur._elem.id;
	while(elem&&elem.id!=id)
	{
		if(elem.tagName==tag)i++;
		if(document.all)elem=elem.parentElement;
		else elem=elem.parentNode;
	}
	return i;
}
function iged_getSelRadio(id)
{
	id=iged_el(id);
	if(id)for(var i=0;i<id.length;i++)if(id[i].checked)return id[i].value;
	return null;
}
function iged_el(id){var d=iged_all._doc0;if(!d)d=window.document;return d.getElementById(id);}
function iged_replaceS(s1,s2,s3)
{ 
	while(s1.indexOf(s2)!=-1)s1=s1.replace(s2,s3);
	return s1;
}
function iged_cancelEvt(e)
{
	if(e==null)if((e=window.event)==null)return;
	if(e.stopPropagation)e.stopPropagation();
	if(e.preventDefault)e.preventDefault();
	e.cancelBubble=true;
	e.returnValue=false;
}
function iged_clearText()
{
	var o=iged_all._cur;if(!o)return;
	if(o._ie)o._elem.innerHTML="";
	else o._elem.contentDocument.clear();
}
function iged_fromTag(type,elem)
{
	var t=elem.tagName;if(t)t=t.toLowerCase();
	if(t&&type==t)return elem;
	if(elem.id==iged_all._cur._elem.id||t=="body")return null;
	return iged_fromTag(type,elem.parentNode);
}
function iged_loadCell()
{
	var c=iged_all._curCell,e=iged_el("iged_cp_ha");
	if(!c||!e)return;
	e=e.options;
	iged_el("iged_cp_w").value=c.width;
	iged_el("iged_cp_h").value=c.height;
	iged_el("iged_cp_nw").checked=c.noWrap;
	for(i=0;i<e.length;i++)if(e[i].value==c.align)e[i].selected=true;
	e=iged_el("iged_cp_va").options;
	for(i=0;i<e.length;i++)if(e[i].value==c.vAlign)e[i].selected=true;
	iged_updateClr(c.bgColor,"iged_cp_bk1");
	var bc=c.borderColor;if(!bc)bc=c.getAttribute("bc");
	iged_updateClr(bc?bc:c.getAttribute("bc"),"iged_cp_bd1");
}
function iged_loadTable()
{
	var t=iged_all._curTable,e=iged_el("iged_tp_rr");
	if(!t||!e)return;
	e.disabled=true;e.value=t.rows.length;
	e=iged_el("iged_tp_cc");
	e.disabled=true;e.value=t.rows[0]?t.rows[0].cells.length:0;
	e=iged_el("iged_tp_al").options;
	for(var i=0;i<e.length;i++)if(e[i].value==t.align)e[i].selected=true;
	iged_el("iged_tp_cp").value=t.cellPadding;
	iged_el("iged_tp_cs").value=t.cellSpacing;
	iged_el("iged_tp_w").value=t.width;
	iged_el("iged_tp_bds").value=t.border;
	iged_updateClr(t.bgColor,"iged_tp_bk1");
	var bc=t.borderColor;
	iged_updateClr(bc?bc:t.getAttribute("borderColor"),"iged_tp_bd1");
}
function iged_updateClr(c,id)
{
	if(!c)c="";
	id=iged_el(id);
	id.style.backgroundColor=(c=="")?"#F0F0F0":c;
	id.value=c;
}
function iged_dragEvt(e)
{
	if(!e)if((e=window.event)==null)return;
	var src=e.srcElement,o=iged_all._cur,p=iged_all._pop;
	if(p)p=p.style;else return;
	if(!src)if((src=e.target)==null)src=this;
	if(e.type=="mouseup"){iged_all._dragOn=false;return;}
	if(e.type=="mousemove")
	{
		if(!iged_all._dragOn)return;
		iged_cancelEvt(e);
		p.left=iged_all._dragX+e.clientX-iged_all._dragX0;
		p.top=iged_all._dragY+e.clientY-iged_all._dragY0;
		return;
	}
	if(!o||src.id!="titleBar")return;
	iged_all._dragX0=e.clientX;iged_all._dragY0=e.clientY;
	iged_all._dragX=parseInt(p.left);iged_all._dragY=parseInt(p.top);
	iged_all._dragOn=true;
	if(iged_all._dragE)return;
	iged_all._dragE=true;
	o._addLsnr(document,"mousemove",iged_dragEvt);
	o._addLsnr(document,"mouseup",iged_dragEvt);
}
