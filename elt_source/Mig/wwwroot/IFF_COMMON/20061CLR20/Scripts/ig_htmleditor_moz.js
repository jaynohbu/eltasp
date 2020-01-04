 /*
  * Infragistics WebHtmlEditor CSOM Script: ig_htmleditor_moz.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */
//js-version 1.4
//vs
function iged_init(ids,p1,p2,p3)
{
	ids=ids.split("|");
	var id=ids[0];
	var elem=iged_el(ids[1]),ta=iged_el(ids[2]),tb=iged_el(ids[3]);
	var o=new iged_new(id,ta,tb,p1,p2,p3);
	o._ids=[ids[4]+"_d",ids[4]+"_h"];
	o._elem=elem;
	o._cDoc=function(){return this._elem.contentDocument;}
	var doc=o._cDoc();
	var edit=o._prop[12];
	if(edit>0)doc.designMode="On";
	doc.open();
	var v=iged_replaceS(ta.value,"%3C","<");
	ta.value=iged_replaceS(v,"%3E",">");
	doc.write(ta.value);
	doc.close();
	o.getText=function()
	{
		var body=this._body();
		if(!this._html)return body.innerHTML;
		var html=body.ownerDocument.createRange();
		html.selectNodeContents(body);
		return html.toString();
	}
	o._win=function(){return this._elem.contentWindow;}
	o._doc=function(){return this._win().document;}
	o._sel=function(){return this._win().getSelection();}
	o.print=function(){this._win().print();}
	o._onLink=function()
	{
		var s=prompt("Create link for selected text.\nNote: text must be selected before invoking this dialog.\nEnter URL:", "http://");
		if(s&&s!="")this._format("CreateLink",s,false);
	}
	o._inTbl=function()
	{
		var range=this._sel().getRangeAt(0);
		return(iged_fromTag("td",range.startContainer)||iged_fromTag("th",range.startContainer));
	}
	o._insBook=function(n)
	{
		var b=this._doc().createElement("A");
		b.setAttribute("name",n);
		iged_insNodeAtSel(b);
	}
	o._insRule=function(align,w,clr,size,noShad)
	{
		var t=this._doc().createElement("HR");
		if(align&&align!="")t.setAttribute("align",align);
		if(w&&w!="")t.setAttribute("width",w);
		if(clr&&clr!="")t.setAttribute("color",clr);
		if(size&&size!="")t.setAttribute("size",size);
		iged_insNodeAtSel(t);
	}
	o._onInsert=function(e)
	{
		var n=document.createElement("SPAN");
		n.innerHTML=e.id;
		iged_insNodeAtSel(n);
		this._afterSel(e);
	}
	o._onApplyStyle=function(e)
	{
		var str=e.id,sel=this._sel();
		var range=sel.getRangeAt(0);
		var txt=iged_stripTags(range.toString());
		var n=document.createElement("SPAN");
		n.innerHTML=txt;
		if(str.indexOf(":")>1)n.setAttribute("style", str);
		else if(str.length>1)n.className=str;
		iged_insNodeAtSel(n);
		this._afterSel(e);
	}
	o._popWin=function(cap,x,img,imgX,evt)
	{
		x=x.split("?");
		var sel,id=x[0],h=x[12],w=x[13],flag=x[14];
		if(id.length<1)return;
		if(flag=="c")
		{
			if((sel=this._sel())==null)return;
			if((sel=sel.getRangeAt(0))==null)return;
			var c=iged_fromTag("td",sel.startContainer);
			if(!c)if((c=iged_fromTag("th",sel.startContainer))==null)return;
			iged_all._curCell=c;
		}
		if(flag=="t")
		{
			if((sel=this._sel())==null)return;
			if((sel=sel.getRangeAt(0))==null)return;
			if((iged_all._curTable=iged_fromTag("table",sel.startContainer))==null)return;
		}
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
		tbl.insertRow(0);tbl.insertRow(0);
		if(w)tbl.style.width=w;
		var r0=tbl.rows[0];
		r0.insertCell(0);tbl.rows[1].insertCell(0);
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
		pan.innerHTML=iged_getOuterHtml(tbl);
		iged_all._pop=pan;
		iged_all._popID=this.ID;
		this._pos(evt,pan);
		this._delay();
		if(flag=="c")iged_loadCell();
		if(flag=="t")iged_loadTable();
		if(!pan._mde){this._addLsnr(pan,"mousedown",iged_dragEvt);pan._mde=true;}
	}
	o._showHtml=function(html)
	{
		var o=this;
		if(html!==true&&html!==false)html=o._html!=true;
		if(html==(o._html==true))return;
		var i,tb=o._tb,body=o._doc().body;
		o._swapS(iged_el(o._ids[html?0:1]),iged_el(o._ids[html?1:0]));
		if(html)
		{
			if(tb)
			{
				var elems=tb.getElementsByTagName("img");
				for(i=0;i<elems.length;i++)elems[i].style.visibility="hidden";
				elems=tb.getElementsByTagName("table");
				for(i=0;i<elems.length;i++)elems[i].style.visibility="hidden";
			}
			o._html=true;
			var html=document.createTextNode(body.innerHTML);
			body.innerHTML="";
			body.appendChild(html); 
			o.focus();
			return;
		}
		if(tb)
		{
			var elems=tb.getElementsByTagName("img");
			for(i=0;i<elems.length;i++)elems[i].style.visibility="visible";
			elems=tb.getElementsByTagName("table");
			for(i=0;i<elems.length;i++)elems[i].style.visibility="visible";
		}
		o._html=false;
		var html=body.ownerDocument.createRange();
		html.selectNodeContents(body);
		body.innerHTML=html.toString(); 
		o.focus();
	}
	o._cont=function(){var s=this._sel();if(s)s=s.getRangeAt(0);return s?s.startContainer:null;}
	o._getSelElem=function()
	{
		var cont=this._cont();
		return (cont.nodeType==1)?cont:null;
	}
	o._insTbl=function()
	{
		var iRows=iged_el("iged_tp_rr").value,iCols=iged_el("iged_tp_cc").value;
		var align=iged_el("iged_tp_al").value,cellPd=iged_el("iged_tp_cp").value;
		var cellSp=iged_el("iged_tp_cs").value,bdSize=iged_el("iged_tp_bds").value;
		var clrBg=iged_el("iged_tp_bk1").value,clrBd=iged_el("iged_tp_bd1").value,w=iged_el("iged_tp_w").value;
		var t,t0=iged_all._curTable;
		if(t0)t=t0;
		else
		{
			t=this._doc().createElement("TABLE");
			var i,tbody=this._doc().createElement("TBODY");
			t.appendChild(tbody);
			for(i=0;i<iRows;i++)
			{
				var r2=this._doc().createElement("TR");
				for(j=0;j<iCols;j++)
				{
					var c2=this._doc().createElement("TD");
					var br=this._doc().createElement("BR");
					c2.appendChild(br);
					r2.appendChild(c2);
				}
				tbody.appendChild(r2);
			}
		}
		if(align!="default")t.setAttribute("align",align);
		t.setAttribute("border",bdSize);
		t.setAttribute("cellpadding",cellPd);
		t.setAttribute("cellspacing",cellSp);
		t.setAttribute("bgcolor",clrBg);
		t.setAttribute("bordercolor",clrBd);
		t.setAttribute("width",w);
		iged_all._curTable=null;
		iged_closePop();
		iged_insNodeAtSel(t);
	}
	o._delCol=function()
	{
		var cont=this._cont();
		var i,c=iged_fromTag("td",cont),t=iged_fromTag("table",cont);
		if(!c)c=iged_fromTag("th",cont);
		if(t&&c)for(i=0;i<t.rows.length;i++)t.rows[i].deleteCell(c.cellIndex);
		iged_closePop();
	}
	o._delRow=function()
	{
		var cont=this._cont();
		var r=iged_fromTag("tr",cont),t=iged_fromTag("table",cont);
		if(t&&r)t.deleteRow(r.rowIndex);
		iged_closePop();
	}
	o._insRow=function(act)
	{
		var cont=this._cont();
		var r=iged_fromTag("tr",cont),t=iged_fromTag("table",cont);
		iged_closePop();
		if(!t||!r)return;
		var i,r2=t.insertRow(r.rowIndex+((act=="below")?1:0));
		for(i=0;i<r.cells.length;i++)
		{
			var c2=r2.insertCell(i);
			if(c2)c2.appendChild(this._doc().createElement("BR"));
		}
	}
	o._insCol=function(act)
	{
		var cont=this._cont();
		var c=iged_fromTag("td",cont),t=iged_fromTag("table",cont);
		if(!c)c=iged_fromTag("th",cont);
		iged_closePop();
		if(!t||!c)return;
		var i,ii=c.cellIndex+((act=="right")?1:0);
		for(i=0;i<t.rows.length;i++)
		{
			var c2=t.rows[i].insertCell(ii);
			if(c2)c2.appendChild(this._doc().createElement("BR"));
		}
	}
	o._colSpan=function(act)
	{
		var cont=this._cont();
		var c=iged_fromTag("td",cont),t=iged_fromTag("table",cont),r=iged_fromTag("tr",cont);
		if(!c)c=iged_fromTag("th",cont);
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
			var c2=r.insertCell(c.cellIndex);
			if(c2)c2.appendChild(this._doc().createElement("BR"));
		}
	}
	o._rowSpan=function(act)
	{
		var r2=null,cont=this._cont();
		var c=iged_fromTag("td",cont),t=iged_fromTag("table",cont),r=iged_fromTag("tr",cont);
		if(!c)c=iged_fromTag("th",cont);
		iged_closePop();
		if(!c||!r)return;
		if(t.rows.length>r.rowIndex)r2=t.rows[r.rowIndex+c.rowSpan];
		if(act=="increase")
		{
			if(!r2)return;
			c.rowSpan+=1;
			r2.deleteCell(c.cellIndex);
		}
		else
		{
			if(c.rowSpan==1)return;
			c.rowSpan-=1;
			r2=t.rows[r.rowIndex+c.rowSpan];
			var c2=r2.insertCell(c.cellIndex);
			if(c2)c2.appendChild(this._doc().createElement("BR"));
		}
	}
	var d=o._doc();
	o._addLsnr(d,"mousedown",iged_mainEvt);
	o._addLsnr(d,"focus",iged_mainEvt);
	o._addLsnr(d,"blur",iged_mainEvt);
	if(edit>0)
	{
		o._addLsnr(d,"keydown",iged_mainEvt);
		o._addLsnr(d,"keypress",iged_mainEvt);
	}
	o._addMenu();
	d.id="ig_d_"+id;
	if(o._prop[10]==1)o._showHtml(true);
	else if((edit&4)!=0)o.focus();
	o._fire(0);
}
function iged_insNodeAtSel(insertNode)
{
   iged_closePop(3);
   var sel=iged_all._cur._sel();
   var range=sel.getRangeAt(0);
   sel.removeAllRanges();
   range.deleteContents();
   var cont=range.startContainer;
   var pos=range.startOffset;
   range=document.createRange();
   if(cont.nodeType==3&&insertNode.nodeType==3) 
   {
      cont.insertData(pos,insertNode.nodeValue);
      range.setEnd(cont,pos+insertNode.length);
      range.setStart(cont,pos+insertNode.length);
   } 
   else 
   {
      var afterNode;
      if(cont.nodeType==3) 
      {
         var textNode=cont;
         cont=textNode.parentNode;
         var text=textNode.nodeValue;
         var textBefore=text.substr(0,pos);
         var textAfter=text.substr(pos);
         var beforeNode=document.createTextNode(textBefore);
         var afterNode=document.createTextNode(textAfter);
         cont.insertBefore(afterNode, textNode);
         cont.insertBefore(insertNode, afterNode);
         cont.insertBefore(beforeNode, insertNode);
         cont.removeChild(textNode);
      } 
      else 
      {
         afterNode=cont.childNodes[pos];
         cont.insertBefore(insertNode,afterNode);
      }
      range.setEnd(afterNode,0);
      range.setStart(afterNode,0);
   }
   sel.addRange(range);
}
function iged_insText(txt,strip)
{
	iged_closePop("InsertText");
	if(strip)txt=iged_stripTags(txt);
	var o=iged_all._cur;
	var sel=o._sel();
	var range=sel.getRangeAt(sel.rangeCount-1).cloneRange();
	var n=o._cDoc().createTextNode(txt);
	range.insertNode(n);
}
function iged_doImgUpdate(img)
{
   var sel=iged_all._cur._sel();
   var range=sel.getRangeAt(0);
   range.extractContents();
   iged_insNodeAtSel(img);
   iged_all._curImg=null;
}
function iged_modal(url,h,w,evt)
{
	url=iged_replaceS(url,"&amp;","&");
	var str="";
	if(h&&h!="")str+="Height="+h+",";
	if(w&&w!="")str+="Width="+w+",";
	str+="scrollbars=no";
	url+=((url.indexOf("?")>-1)?"&num=":"?num=")+Math.round(Math.random()*100000000);
	url+="&parentId="+iged_all._cur._elem.id;
	window.open(url,window,str);
}
function iged_getOuterHtml(n) 
{
	var i,html="";
	if(n.nodeType==Node.ELEMENT_NODE)
	{
		html+="<";
		html+= n.nodeName;
		if(n.nodeName!="TEXTAREA") 
		{
			for(i=0;i<n.attributes.length;i++)
				html+=" "+n.attributes[i].nodeName.toUpperCase()+"=\""+n.attributes[i].nodeValue+"\">";
			var s=n.nodeName;
			if(s!="HR"&&s!="BR"&&s!="IMG"&&s!="INPUT")
				html+=n.innerHTML+"<\/"+s+">";
		}
		else
		{
			var txt="";
			for(i=0;i<n.attributes.length;i++)
			{
				if(n.attributes[i].nodeName.toLowerCase()!="value")
					html+=" "+n.attributes[i].nodeName.toUpperCase()+"=\""+ n.attributes[i].nodeValue+"\"";
				else txt=n.attributes[i].nodeValue;
			}
			html+=">"+txt+"<\/"+n.nodeName+">";
		}
	}
	else if(n.nodeType==Node.TEXT_NODE)html+=n.nodeValue;
	else if(n.nodeType==Node.COMMENT_NODE)html+="<!--"+n.nodeValue+"-->";
	return html;
}
function iged_copy0()
{
	for(var i=0;i<iged_all.length;i++)
	{
		var o=iged_all[i];var v=o.getText();
		v=iged_replaceS(v,"<","%3C");o._ta.value=iged_replaceS(v,">","%3E");
	}
}
