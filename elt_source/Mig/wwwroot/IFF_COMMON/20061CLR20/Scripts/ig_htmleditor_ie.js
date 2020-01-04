 /*
  * Infragistics WebHtmlEditor CSOM Script: ig_htmleditor_ie.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */
//js-version 1.3
//vs
function iged_init(ids,p1,p2,p3)
{
	ids=ids.split("|");
	var id=ids[0];
	var elem=iged_el(ids[1]),ta=iged_el(ids[2]),tb=iged_el(ids[3]);
	iged_prFile=document.URL.toLowerCase();//hack: remove on next build
	var o=new iged_new(id,ta,tb,p1,p2,p3);
	o._ids=[ids[4]+"_d",ids[4]+"_h"];
	o._elem=elem;
	o._ie=true;
	o._doc=function(){return this._elem.document;}
	o._sel=function(){return this._doc().selection;}
	o.getText=function(){return this._html?this._elem.innerText:this._elem.innerHTML;}
	o._onLink=function()
	{
		var img=this._getSelImg();
		if(img)img.border=0;
		this._fixPath();
		this._format("createlink","",true);
	}
	o.print=function()
	{
		var s=this._elem.outerHTML;
		var i=s.indexOf(" style=");
		if(i>3)
		{
			var s0=s.substring(i+7,i+8);
			s=s.substring(i+8);
			s=s.substring(0,s.indexOf(s0));
		}
		var win=window.open("","","width=10,height=10");
		win.document.write("<html><body style='"+s+"'>"+this._elem.innerHTML+"</body></html>");
		win.document.close();
		win.print();
		win.close();
	}
	o._inTbl=function()
	{
		var cr=iged_all._curRange;
		if(!cr||this._sel().type=="Control")return false;
		return (iged_fromTag("td",cr.parentElement())||iged_fromTag("th",cr.parentElement()));
	}
	o._insBook=function(n){iged_insText("<a name='"+n+"' />",false,true,true);}
	o._insRule=function(align,w,clr,size,noShad)
	{
		var t="<hr";
		if(align&&align!="")t+=" align='"+align+"'";
		if(w&&w!="")t+=" width='"+w+"'";
		if(clr&&clr!="")t+=" color='"+clr+"'";
		if(size&&size!="")t+=" size='"+size+"'";
		if(noShad)t+=" NOSHADE";
		t+=" />";
		iged_insText(t,false,true,true);
	}
	o._onInsert=function(e)
	{
		iged_insText(e.id,false,true);
		this._afterSel(e);
	}
	o._onApplyStyle=function(e)
	{
		var str=e.id,cr=iged_all._curRange;
		if(!cr)return;
		var txt=cr.htmlText;
		if(txt.indexOf("hidden")>0)txt="";
		if(txt=="")
		{
			cr.expand("word");
			txt=cr.htmlText;
		}
		if(txt.indexOf("hidden")>-1)txt="";
		if(str.indexOf(":")>1)str="<font style='"+str+"'>"+txt+"</font>";
		else if(str.length>1)str="<font class='"+str+"'>"+txt+"</font>"
		cr.select();
		this._doc().execCommand("removeFormat");
		if(str.length>1)iged_insText(str,false,true);
		this._afterSel(e);
	}
	o._popWin=function(cap,x,img,imgX,evt)
	{
		x=x.split("?");
		var id=x[0],h=x[12],w=x[13],flag=x[14];
		if(id.length<1)return;
		if(flag=="t")if((iged_all._curTable=this._getCurTable())==null)return;
		if(flag=="c")if((iged_all._curCell=this._getCurCell())==null)return;
		if(this._isKnown(id))iged_all._curRange=this._sel().createRange();
		iged_closePop();
		var elem=iged_el(id),pan=this._pan();
		if(!elem||!pan)return;
		this._choiceAct=this._itemStyle=null;
		if(!elem._igf){elem._igf=true;this._fixPop(elem);}
		var s=pan.style;
		if(x[1])s.backgroundColor=x[1];if(x[2])s.borderColor=x[2];
		if(x[3])s.borderStyle=x[3];if(x[4])s.borderWidth=x[4];
		if(x[5])s.fontFamily=x[5];if(x[6])s.fontSize=x[6];if(x[7])s.color=x[7];
		if(h)s.height=h;if(w)s.width=w;
		var tbl=document.createElement("TABLE");
		tbl.border=tbl.cellpadding=tbl.cellspacing=0;
		tbl.insertRow();tbl.insertRow();
		if(w)tbl.style.width=w;
		var r0=tbl.rows[0];
		r0.insertCell();
		tbl.rows[1].insertCell();
		var c0=r0.cells[0];var s0=c0.style;
		s0.width="100%";s0.cursor="pointer";
		c0.id="titleBar";
		if(x[8])s0.backgroundColor=x[8]; 
		var txt="<table border='0' cellpadding='0' cellspacing='0' width='100%'><tr><td id='titleBar' width='100%'>";
		if(img!="")txt+="<img id='titleBar' align='absmiddle' src='"+img+"'></img>";
		txt+="&nbsp;<b id='titleBar' style='";
		if(x[9])txt+="font-family:"+x[9]+";";
		if(x[10])txt+="font-size:"+x[10]+";";
		if(x[11])txt+="color:"+x[11]+";";
		txt+="'>"+cap+"</b></td><td>";
		if(imgX!="")txt+="<img onclick='iged_closePop(3)' align='absmiddle' src='"+imgX+"'></img>";
		txt+="</td></tr></table>";
		c0.innerHTML=txt;
		tbl.rows[1].cells[0].innerHTML=elem.innerHTML;
		pan.innerHTML=tbl.outerHTML;
		iged_all._pop=pan;
		iged_all._popID=this.ID;
		this._pos(evt,pan);
		this._delay();
		if(flag=="c")iged_loadCell();
		if(flag=="t")iged_loadTable();
		if(!pan._mde){this._addLsnr(pan,"mousedown",iged_dragEvt);pan._mde=true;}
	}
	o._decode=function(t){return t.replace(/<!--###@@@/gi, "<").replace(/@@@###-->/gi, ">");}
	o._encode=function(txt)
	{
		var exp=/<form(.*?)>/i;
		do{txt=txt.replace(exp,"@@@&&&###").replace(/@@@&&&###/,"<!--###@@@form"+RegExp.$1+"@@@###-->");}
		while(exp.test(txt));
		txt=txt.replace(/<\/form>/gi,"<!--###@@@/form@@@###-->");
		if(txt.indexOf("<!--###@@@")==0)txt="&nbsp;"+txt;
		return txt;
	}
	o._showHtml=function(html)
	{
		var o=this;
		if(html!==true&&html!==false)html=o._html!=true;
		if(html==(o._html==true))return;
		var i,ta=o._ta,tb=o._tb;
		o._swapS(iged_el(o._ids[html?0:1]),iged_el(o._ids[html?1:0]));
		if(html)
		{
			iged_all._noUndo=true;
			if(tb)for(i=0;i<tb.all.length;i++)tb.all[i].style.visibility="hidden";
			o._html=true;
			o._fixPath();
			ta.value=o._elem.innerHTML;
			o.setText(ta.value);
			o.focus();
			return;
		}
		if(tb)for(i=0;i<tb.all.length;i++)tb.all[i].style.visibility="visible";
		o._html=false;
		ta.value=o._elem.innerText;
		o.setText(ta.value);
		o.focus();
		o._syncBullets();
	}
	o._find0=function(x)
	{
		var txt1=iged_el("iged_f_fw").value,txt2=iged_el("iged_f_rw").value;
		if(!txt2)txt2="";if(!txt1||txt1=="")return;
		var fc=iged_el("iged_f_mc").checked?4:0,fw=iged_el("iged_f_mw").checked?2:0;
		var flag=fw^fc;
		if(x==1){this._find(txt1,flag);return;}
		this._findOld=null;
		this._findNum=0;
		while(this._find(txt1,flag,txt2))if(x==2)return;
	}
	o._find=function(txt,flag,txt2)
	{
		this._delay();
		var s,old=this._findOld==txt,fr=this._findRange;
		if(txt2!=null&&fr)fr.text=txt2;
		this._findOld=txt;
		if(!fr)
		{
			fr=this._findRange=this._body().createTextRange();
			fr.moveToElementText(this._elem);
			this._findLen=fr.text.length;
		}
		else fr.collapse(false);
		if(fr.findText(txt,this._findLen,flag))try{fr.select();this._findNum++;return true;}catch(e){}
		if(!old){s="Can not find \""+txt+"\"";this._findOld=null;}
		else if(txt2==null)s="No more occurrences of \""+txt+"\" found";
		else s=this._findNum+" occurrences replaced";
		alert(s);
		fr.collapse(false);
		this._findRange=null;
		return false;
	}
	o._fixSources=function(x)
	{
		var i,src,imgs=this._elem.getElementsByTagName("img"),ans=this._elem.getElementsByTagName("a");
 		for(i=0;i<imgs.length;i++)if(imgs[i].src.indexOf(iged_prServer)==0)
 		{
			src=imgs[i].src.toLowerCase();
			switch(x)
			{
				case "0":src=src.replace(iged_prUrl,iged_baseUrl);break;//abs
				case "1":src=iged_getRelPath(src);break;//docRelative
				case "2"://rootRelative
					src=src.replace(iged_prFile+"#", "#").replace(iged_prServer,"/").replace(iged_prPath,iged_basePath);
					break;
			}
			imgs[i].src=src;
		}
		for(i=0;i<ans.length;i++)if(ans[i].href.indexOf(iged_prServer)==0)
		{
			src=ans[i].href.toLowerCase();
			switch(x)
			{
				case "0":src=src.replace(iged_prUrl,iged_baseUrl);break;
				case "1":src=iged_getRelPath(src);break;
				case "2":
					src=src.replace(iged_prFile+"#","#").replace(iged_prServer,"/").replace(iged_prPath, iged_basePath);
					break;
			}
			ans[i].href=src;
		}
	}
	o._getSelElem=function()
	{
		if(this._sel().type=="Control")
			return this._sel().createRange().item(0);
		iged_all._curRange=this._sel().createRange();
		if(iged_all._curRange.boundingWidth>0)
		{
			var txt=iged_all._curRange.text;
			var id="pwCurrentlySelectedText";
			txt="<span id='"+id+"'>"+txt+"</span>";
			iged_all._curRange.pasteHTML(txt);
			var obj=this._doc().getElementById(id);
			obj.id="";
			return obj;
		}
		return null;
	}
	o._getCurCell=function()
	{
		var c=iged_all._curMenuCell,o=iged_all._curRange.parentElement();
		if(!c)c=iged_fromTag("td",o);
		return c?c:iged_fromTag("th",o);
	}
	o._getCurTable=function()
	{
		return iged_all._curMenuTable?iged_all._curMenuTable:iged_fromTag("table",iged_all._curRange.parentElement());
	}
	o._getCurRow=function()
	{
		return iged_all._curMenuRow?iged_all._curMenuRow:iged_fromTag("tr",iged_all._curRange.parentElement());
	}
	o._insTbl=function()
	{
		var o=this;
		var iRows=iged_el("iged_tp_rr").value,iCols=iged_el("iged_tp_cc").value;
		var align=iged_el("iged_tp_al").value,cellPd=iged_el("iged_tp_cp").value;
		var cellSp=iged_el("iged_tp_cs").value,bdSize=iged_el("iged_tp_bds").value;
		var clrBg=iged_el("iged_tp_bk1").value,clrBd=iged_el("iged_tp_bd1").value,w=iged_el("iged_tp_w").value;
		var i,t,t0=iged_all._curTable;
		if(t0)t=t0;
		else
		{
			t=o._doc().createElement("TABLE");
			for(i=0;i<iRows;i++)
			{
				var r=t.insertRow();
				for(j=0;j<iCols;j++)r.insertCell();
			}
		}
		if(align!="default")t.align=align;
		t.border=bdSize;
		t.cellPadding=cellPd;
		t.cellSpacing=cellSp;
		if(clrBg&&clrBg!="")t.bgColor=clrBg;
		if(clrBd&&clrBd!="")t.borderColor=clrBd;
		t.width=w;
		if(t0)t0.outerHTML=t.outerHTML;
		else iged_insText(t.outerHTML,false,true,true);
		iged_all._curTable=null;
		iged_closePop();
		if(o._toggle!==false)o._onToggleBdr(true);
	}
	o._delCol=function()
	{
		var c=this._getCurCell(),t=this._getCurTable();
		var i,ii=c.cellIndex;
		if(t&&c)for(i=0;i<t.rows.length;i++)if(t.rows[i].cells.length>ii)
			t.rows[i].deleteCell(ii);
		iged_closePop();
	}
	o._delRow=function()
	{
		var r=this._getCurRow(),t=this._getCurTable();
		if(t&&r)t.deleteRow(r.rowIndex);
		iged_closePop();
	}
	o._insRow=function(act)
	{
		var r=this._getCurRow(),t=this._getCurTable();
		iged_closePop();
		if(!t||!r)return;
		var i,r2=t.insertRow(r.rowIndex+((act=="below")?1:0));
		for(i=0;i<r.cells.length;i++)r2.insertCell(i);
	}
	o._insCol=function(act)
	{
		var c=this._getCurCell(),t=this._getCurTable();
		iged_closePop();
		if(!t||!c)return;
		var i,t2=t.cloneNode(true);
		for(i=0;i<t2.rows.length;i++)
			t2.rows[i].insertCell(c.cellIndex+((act=="right")?1:0));
		t.outerHTML=t2.outerHTML;
	}
	o._colSpan=function(act)
	{
		var c=this._getCurCell(),r=this._getCurRow();
		iged_closePop();
		if(!c||!r)return;
		if(act=="increase")
		{
			if(r.cells[c.cellIndex+1])
			{
				c.colSpan+=1;
				r.deleteCell(c.cellIndex+1);
			}
		}
		else if(c.colSpan>1) 
		{
			c.colSpan-=1;
			r.insertCell(c.cellIndex);
		}
	}
	o._rowSpan=function(act)
	{
		var c=this._getCurCell(),r=this._getCurRow(),t=this._getCurTable();
		iged_closePop();
		if(!c||!r)return;
		var nextRow=null;
		if(t.rows.length>r.rowIndex)nextRow=t.rows[r.rowIndex+c.rowSpan];
		if(act=="increase")
		{
			if(!nextRow)return;
			c.rowSpan+=1;
			nextRow.deleteCell(c.cellIndex);
		}
		else
		{
			if(c.rowSpan==1)return;
			c.rowSpan-=1;
			nextRow=t.rows[r.rowIndex+c.rowSpan];
			nextRow.insertCell(c.cellIndex);
		}
	}
	o._onKey=function(e)
	{
		var k=e.keyCode,p=(this._prop[12]&2)!=0;
		if(p&&e.shiftKey&&k==13)
		{
			iged_insText("<P />", false, false);
			iged_cancelEvt(e);
			return;
		}
		if(k==13&&iged_all._needSync)window.setTimeout("iged_all._cur._syncBullets()", 100);
		if(k>=37&&k<=40)iged_all._curRange=this._body().createTextRange();
		if(!p)return;
		if(k==13)
		{
			this._syncBullets();
			var range=this._sel().createRange();
			if(range.queryCommandState("insertorderedlist")||range.queryCommandState("insertunorderedlist"))
			{
				if(!iged_all._terminateList)iged_all._terminateList=true;
				else
				{
					e.keyCode=8;
					iged_all._terminateList=false;
				}
				return;
			}
			if(!iged_all._insertPTag)iged_all._insertPTag=true;
			else
			{
				iged_insText("<P />",false,false);
				iged_all._insertPTag=false;
				iged_cancelEvt(e);
				return;
			}
			iged_insText("<BR />",false,false)
			iged_cancelEvt(e);
			range.select();
			range.collapse(false);
			range.select();
		}
		else iged_all._terminateList=iged_all._insertPTag=false;
	}
	o._ieBug=function(pan,x,y)
	{
		var s,d=this._doc(),f=this._clrTarget?this._ieBug1:this._ieBug0;
		if(!f)
		{
			f=d.createElement("IFRAME");f.style.display="none";
			d.body.insertBefore(f,d.body.firstChild);f.frameBorder=f.scrolling="no";f.src="javascript:false";
		}
		var s=f.style;
		s.zIndex=pan.style.zIndex-1;s.position="absolute";s.left=x+"px";s.top=y+"px";
		s.width=pan.offsetWidth+"px";s.height=pan.offsetHeight+"px";
		s.filter="progid:DXImageTransform.Microsoft.Alpha(Opacity=0);";s.display="";
		pan._ieBug=s;
		if(this._clrTarget)this._ieBug1=f;else this._ieBug0=f;
	}
	o.setText(ta.value);
	o._addLsnr(elem,"focus",iged_mainEvt);
	o._addLsnr(elem,"blur",iged_mainEvt);
	var edit=o._prop[12];
	if(edit>0)
	{
		elem.contentEditable=true;
		elem.style.layout="layout-grid: both fixed 12px 12px";
		o._addLsnr(elem,"keydown",iged_mainEvt);
		o._addLsnr(elem,"keypress",iged_mainEvt);
	}
	o._addMenu();
	elem.content=false;
	if(o._prop[10]==1)o._showHtml(true);
	else if((edit&4)!=0)o.focus();
	o._fire(0);
}
function iged_fixValids()
{
	for(var i=0;i<document.all.length;i++)
	{
		var e=document.all[i];
		if(e.href&&e.href.indexOf("Page_ClientValidate()")>-1)
			e.href="javascript:iged_copy0(1); "+e.href;
		if(e.onclick&&e.onclick.toString().indexOf("Page_ClientValidate()")>-1)
		{
			var v=e.onclick.toString().replace("function anonymous()","").replace("{","").replace("}","");
			v=iged_replaceS(v,"\r","");
			iged_all._validFunc=iged_replaceS(v,"\n","");
			e.onclick=iged_doValidsSubmit;
		}
	}
}
function iged_doValidsSubmit(){iged_copy0(1);try{eval(iged_all._validFunc);}catch(e){}}
function iged_insText(txt,strip,restore,sel)
{
	var o=iged_all._cur,cr=iged_all._curRange;
	if(!o||!cr)return;
	if(!(cr.offsetLeft==12&&cr.offsetTop==17))if(restore)
	{
		if(cr.boundingWidth > 0||sel)cr.select();
		if(cr.boundingWidth==null)cr.select();
	}
	if(o._sel().type=="Control")o._sel().clear();
	iged_closePop("InsertText");
	o._elem.setActive();
	if(strip)txt=iged_stripTags(txt);
	try{o._sel().createRange().pasteHTML(txt);}catch(ex){}
}
function iged_doImgUpdate(txt)
{
	var o=iged_all._cur;
	if(o&&iged_all._curRange)try
	{
		iged_all._curRange.select();
		o._sel().clear();
		iged_insText(txt,false,false);
		iged_all._curImg=null;
	}catch(er){}
}
function iged_modal(url,h,w,evt)
{
	var p=iged_all._cur._pos(evt),str="";
	url=iged_replaceS(url,"&amp;","&");
	if(h&&h!="")str+="dialogHeight:"+h+";";
	if(w&&w!=""&&w!="500px")str+="dialogWidth:"+w+";";
	str+="dialogLeft:"+p.x+";dialogTop:"+p.y+";";
	str+="scroll:no;status:no;help:no;center:no;";
	//unique?? url to send the request again
	url+=((url.indexOf("?")>-1)?"&num=":"?num=")+Math.round(Math.random()*100000000);
	url+="&parentId="+iged_all._cur._elem.id;
	window.showModalDialog(url,window,str);
}
function iged_copy0(x)
{
	if(x!=1){if(iged_all._copy0)return;iged_all._copy0=true;}
	for(var i=0;i<iged_all.length;i++)
	{
		var o=iged_all._cur=iged_all[i];
		o._fixPath();
		var v=o._decode(o.getText());
		v=iged_replaceS(v,"<","%3C");
		o._ta.value=iged_replaceS(v,">","%3E");
   }
}
function iged_getRelPath(src)
{
	if(src.indexOf(iged_prFile+"#")==0)
	{
		src=src.replace(iged_prFile+"#","#");
		return src;
	}
	src=src.replace(iged_prServer,iged_baseServer).replace(iged_prPath,iged_basePath);	
	var urls=iged_getParts(src,true),projs=iged_getParts(iged_prUrl,false);
	var i,prLen=projs.length,count=0;
	try{for(i=0;i<prLen;i++)if(urls[i]==projs[i])count++;}catch(er){}
	count=prLen-count;
	src=src.replace(iged_baseUrl,"").replace(iged_baseServer,"").replace(iged_basePath,"");
	for(i=0;i<count;i++)src="../"+src;
	return src;
}
function iged_getParts(str,isFile)
{
	var parts=new Array(),count=0,subtract=(isFile)?1:0;
	var pp=str.split("/");
	if(pp.length>1)
	{
		parts[count++]=pp[0].toLowerCase()+"//"+pp[2].toLowerCase();
		for(var i=3;i<pp.length-subtract;i++)
			if(pp[i]!="")parts[count++]=pp[i].toLowerCase();
	}
	return parts;
}
