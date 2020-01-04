 /*
  * Infragistics WebGrid CSOM Script: ig_WebGrid_cb.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */
 
// ig_WebGrid_cb.js
// Infragistics UltraWebGrid Script 
// Copyright (c) 2001-2006 Infragistics, Inc. All Rights Reserved.
function igtbl_editCell(evnt,gn,cell,key)
{
	var g=igtbl_getGridById(gn);
	if(g==null || !g.GridIsLoaded)
		return;
	g.event=evnt;
	if(g._editorCurrent!=null)
		igtbl_hideEdit(null,null,g);
	var cellObj=igtbl_getCellById(cell.id);
	var cElem=cellObj.getElement();
	if(cellObj==null)
		return;
	if(g._exitEditCancel||!cellObj.isEditable())
		return;
	if(cellObj!=g.oActiveCell)
		g.setActiveCell(cellObj);
	var col=cellObj.Column;
	if(col.ColumnType==3||col.ColumnType==7)
		return;
	if(igtbl_fireEvent(gn,g.Events.BeforeEnterEditMode,"(\""+gn+"\",\""+cell.id+"\")")==true)
		return;
	cellObj.scrollToView();
	var r=igtbl_getAbsBounds(cElem);
	var z=igtbl_getElementById(gn+"_main");
	if(z!=null)
		z=z.zIndex;
	z=(z!=null&&z!=""&&z>999)?z+1:9999;
	var offsWidth=cElem.offsetWidth;
	var offsHeight=cElem.offsetHeight;
	if(g.IsXHTML)
	{
		offsWidth=cElem.clientWidth;
		offsHeight=cElem.clientHeight;
	}
	
	var w=(g.DivElement.clientWidth&&g.DivElement.clientWidth<offsWidth?g.DivElement.clientWidth:offsWidth)-2,
		h=(g.DivElement.clientHeight&&g.DivElement.clientHeight<offsHeight?g.DivElement.clientHeight:offsHeight)-2,
		ch=cElem.clientHeight;
	if(ch==null||ch==0)
	{
		w--;
		h--;
	}
	if(w<5)
		w=5;
	if(h<5)
		h=18;
	r.w=w;
	r.h=h;
	r.z=z;
	if((z=ig_csom.AgentName.indexOf("netscape/7.0"))>0)
	{
		r.x++;
		r.y++;
	}
	
	var css=null,e=cell,i=0;
	while(++i<10&&(css==null||css==""))
		if((e=e.parentNode)!=null)
			css=e.getAttribute("bandNo");
	if(css!=null&&css!="")
		css=igtbl_getEditCellClass(gn,css);
	if(!css)css="";
	
	var v=(key!=null&&key>0)?"":cellObj.getValue();
	if(v==null)
		if((v=cell.getAttribute(igtbl_sUnmaskedValue))==null)
			v="";
	var href=-1,nn=cElem.childNodes;
	for(z=0;z<nn.length;z++)
		if(nn[z].tagName=="A")
			href=z;
	g._editorCustom=null;
	var elem=igtbl_editCust(g,(key!=null&&key>0)?"":v,r,col);
	if(!elem)
		elem=igtbl_editList(g,v=(cell.getAttribute(igtbl_sigDataValue)?cell.getAttribute(igtbl_sigDataValue):v.toString()),r,col);
	if(!elem)
		elem=igtbl_editDef(g,v=(cell.getAttribute(igtbl_sigDataValue)?cell.getAttribute(igtbl_sigDataValue):v.toString()),r,col,css,cell);
	if(!elem)
		return;
	cellObj._oldValue=v;
	if(href>=0)
		elem.setAttribute("hasHref",href);
	g._editorCurrent=elem;
	elem.setAttribute("gn",gn);
	elem.setAttribute("currentCell",cell.id);
	igtbl_fireEvent(gn,g.Events.AfterEnterEditMode,"(\""+gn+"\",\""+cell.id+"\");");
	if(typeof(Page_Validators)!="object")
		return;
	var i,j,id=null,colV=col.Validators,pgV=Page_Validators;
	if((e=col.editorControl)!=null)
		if((id=e.ID)==null)
			if((id=e.id)==null)
				id=e.Id;
	if(id==null)
		id=elem.id;
	else
		for(i=0;i<pgV.length;i++)
		{
			if(pgV[i]&&pgV[i].controltovalidate==id)
			{
				if(!colV)colV=col.Validators=new Array();
				for(j=colV.length-1;j>=0;j--)if(colV[j]==pgV[i].id)break;
				if(j<0)colV[colV.length]=pgV[i].id;
			}
		}
	for(i=0;i<colV.length;i++)
	{
		if((v=igtbl_getElementById(colV[i]))==null)
			continue;
		s=v.style;
		s.zIndex=9999;
		s.position="absolute";
		v.style.left=r.x+"px";
		v.style.top=(r.y+r.h+2)+"px";
		try
		{
			v.unselectable="on";
		}catch(ex){;}
		if(e!=null)
			continue;
		v.setAttribute("controltovalidate",id);
		ValidatorHookupControlID(id,v);
	}
	for(i=0;i<pgV.length;i++)
		if(pgV[i].controltovalidate==id)
			for(j=0;j<colV.length;j++)
				if(pgV[i].id==colV[j])
					pgV[i].enabled=pgV[i].isvalid=true;
}

function igtbl_editCust(g,v,r,col)
{
	var id=col.EditorControlID,editor=col.editorControl;
	if(editor==null && id!=null)
	{
		if((editor=igtbl_getElementById(id))!=null)
			editor=editor.Object;
	}
	if(editor==null)
		return null;
	col.editorControl=editor;
	var elem=editor.Element;
	g._ensureValidParent(editor);
	editor.setValue(v,false);
	elem.style.zIndex=r.z;
	editor.setVisible(true,r.x,r.y,r.w,r.h);
	editor.webGrid=g;
	editor.addEventListener("blur",igtbl_hideEdit,g);
	editor.addEventListener("keydown",igtbl_hideEdit,g);
	elem.setAttribute("editType",4);
	g._editorCustom=editor;
	return elem;
}

function igtbl_editDef(g,v,r,col,css,cell)
{
	var cElem=igtbl_getCellById(cell.id).getElement();
	var elem=g._editorInput,nn=cElem.childNodes;
	var area=(col.CellMultiline==1)?1:0;
	if(area==1)
		elem=g._editorArea;
	var w=cElem.offsetWidth,h=cElem.offsetHeight,ie=ig_csom.IsIE;
	var s,i=ie?0:nn.length;
	while(i-->0)
		if(nn[i].style)
			nn[i].style.display="none";
	else
	{
		if(g._oldElems==null)
			g._oldElems=new Array();
		g._oldElems[g._oldElems.length]=nn[i];
		cElem.removeChild(nn[i]);
	}
	if(!elem)
	{
		if(area==1)
			g._editorArea=elem=document.createElement("TEXTAREA")
		else
		{
			g._editorInput=elem=document.createElement("INPUT");
			elem.type="text";
		}
		if(ie)
			document.body.insertBefore(elem,document.body.firstChild);
		else
			cElem.appendChild(elem);
		ig_csom.addEventListener(elem,"keydown",igtbl_editEvt);
		ig_csom.addEventListener(elem,"keyup",igtbl_editEvt);
		ig_csom.addEventListener(elem,"blur",igtbl_editEvt);
		elem.setAttribute("editType",area);
		i=g.Id+((area==1)?"_ta":"_tb");
		elem.id=i;
	}
	else if(!ie)
		cElem.appendChild(elem);
	elem.value="";
	s=elem.style;
	s.zIndex=r.z;
	if(ie)
	{
		s.position="absolute";
		s.left=r.x+"px";
		s.top=r.y+"px";
		s.height=r.h+"px";
	}
	else
	{
		if(r.w>10)
			r.w-=6;
		s.height="";
	}
	s.width=r.w+"px";
	if(area==0)
	{
		i=col.FieldLength;
		elem.maxLength=(i!=null&&i>0)?i:2147483647;
	}
	if(area==1)
		s.overflow="auto";
	if(css.length>0)
		elem.className=css;
	s.borderWidth=ig_csom.isEmpty(elem.className)?"0":"";
	s.display="";
	if(!ie)
	{
		cell.style.height=h+"px";
		for(i=1;i<8;i++)
			if(cElem.offsetWidth>w)
				cell.style.width=(w-i)+"px";
		s.height=(r.h-1)+"px";
		if(cElem.offsetHeight>h)
			s.height=(r.h-2)+"px";
	}
	elem.value=v;
	try
	{
		elem.select();
		elem.focus();
	}catch(e){;}
	return elem;
}

function igtbl_editEvt(evt,gn,id)
{
	if(evt==null)
		if((evt=window.event)==null)
			return;
	var src=evt.srcElement;
	if(src==null)
		if((src=evt.target)==null)
			return;
	if(!gn||!gn.substring)
		gn=src.getAttribute("gn");
	var g=igtbl_getGridById(gn);
	if(g==null)
		return;
	g.event=evt;
	var b=g._editorButton;
	switch(evt.type)
	{
		case "focus":return;
		case "blur":
			if(!src.getAttribute("noOnBlur"))
			{
				igtbl_hideEdit(null,evt,g);
			}
			else
				ig_cancelEvent(evt);
			return;
		case "keydown":
			src.setAttribute("noOnBlur",true);
			window.setTimeout("igtbl_cancelNoOnBlurTB('"+gn+"','"+src.id+"')",100);
			if(!b && igtbl_fireEvent(gn,g.Events.EditKeyDown,"(\""+gn+"\",\""+src.getAttribute("currentCell")+"\","+evt.keyCode+")")==true)
			{
				ig_cancelEvent(evt);
				return;
			}
			g._mouseDown=0;
			var key=evt.keyCode;
			var et=src.getAttribute("editType");
			if(key==9 || key==27 || key==13 && et!=1 && et!=3 || key==113)
			{
			
				src.removeAttribute("noOnBlur");
				igtbl_hideEdit(null,evt,g);
			}				
			return;
		case "keyup":
			igtbl_fireEvent(gn,g.Events.EditKeyUp,"(\""+gn+"\",\""+src.getAttribute("currentCell")+"\","+evt.keyCode+")");
			return;
	}
	if(b && g.ActiveCell && !igtbl_isFocus(gn,b))
		igtbl_showColButton(gn,"hide",true);
}

function igtbl_editList(g,v,r,col)
{
	var list=col.ValueList;
	if(list==null||list.length<1)return null;
	var s,elem=g._editorList;
	if(elem==null)
	{
		g._editorList=elem=document.createElement("SELECT")
		document.body.insertBefore(elem,document.body.firstChild);
		ig_csom.addEventListener(elem,"keydown",igtbl_editEvt);
		ig_csom.addEventListener(elem,"keyup",igtbl_editEvt);
		ig_csom.addEventListener(elem,"blur",igtbl_editEvt);
		elem.style.position="absolute";elem.style.zIndex=r.z;
		elem.setAttribute("editType",3);
		elem.id=g.Id+"_vl";		
		ig_csom.addEventListener(elem,"change",igtbl_dropDownChange);
	}
	s=elem.style;
	var opt,css=col.ValueListClass;
	if(ig_csom.notEmpty(css))
		elem.className=css;
	else
		elem.style.fontSize=((r.h-=4)<15)?(((r.h<9)?9:r.h)+"px"):"";
	elem.value=v;
	var i=elem.options.length, prompt=col.ValueListPrompt;
	while(i-->0)
		elem.removeChild(elem.options[i]);
	if(ig_csom.notEmpty(prompt))
	{
		elem.appendChild(opt=document.createElement("OPTION"));
		opt.text=opt.value=prompt;
	}
	while(++i<list.length)if(list[i]!=null)
	{
		elem.appendChild(opt=document.createElement("OPTION"));
		opt.value=list[i][0];
		opt.text=list[i][1];
		if(v!=null&&(v==list[i][0]||v==list[i][1])){opt.selected=true;v=null;}
	}
	s.display="";
	s.left=r.x+"px";
	s.width=r.w+"px";
	s.height=r.h+"px";
	var so=igtbl_getStyleSheet(elem.className);
	if(so && so.verticalAlign=="top")
		s.top=r.y+"px";
	else if(so && so.verticalAlign=="bottom")
		s.top=r.y+r.h-elem.offsetHeight+"px";
	else
		s.top=r.y+r.h/2-elem.offsetHeight/2+"px";
	elem.focus();
	return elem;
}

function igtbl_activate(gn)
{
	var g=igtbl_getGridById(gn);
	if(g==null) 
		return;
	
	if(g._editorCurrent!=null)
	{
		try
		{
			g._editorCurrent.select();
			g._editorCurrent.focus();
			return;
		}
		catch(e){;}
	}
	var b=igtbl_initButton(g),elem=g._focusElem;
	if(elem==null)
		try
		{	
			elem=document.createElement("INPUT");
			document.body.insertBefore(elem,document.body.firstChild);
			elem.setAttribute("gn",gn);
			ig_csom.addEventListener(elem,"keydown",igtbl_inputEvt);
			ig_csom.addEventListener(elem,"keyup",igtbl_inputEvt);
			ig_csom.addEventListener(elem,"focus",igtbl_inputEvt);
			ig_csom.addEventListener(elem,"blur",igtbl_inputEvt);
			
			ig_csom.addEventListener(document.body,"mouseup",igtbl_globalMouseUp);
			g._focusElem=elem;
			var s=elem.style;
			s.zIndex=-1;
			s.position="absolute";
			s.fontSize="2px";
			s.padding=s.width=s.height=s.border="0px";
			if(elem.offsetWidth>2)
				s.width="1px";
			if(elem.offsetHeight>2)
				s.height="1px";
			elem.tabIndex=g.DivElement.getAttribute("tabIndexPage");
		}
		catch(ex){;}
	if(elem==null)
		return;
	g._lastKey=0;
	if(!igtbl_isOk(g))
		return;
	igtbl_showColButton(gn,"hide",true);
	var cell=g.oActiveCell;
	if(cell!=null)
		cell=cell.Element;
	if(cell==null)
		cell=g.Element;
	var r=igtbl_getAbsBounds(cell);
	elem.style.left=(r.x-3)+"px";
	elem.style.top=(r.y-3)+"px";
	if(g._focus0)
		return;
	if(g._mouseDown==1)
	{
		g._mouseDown=0;
		try
		{
			window.setTimeout("try{igtbl_isFocus('"+gn+"');}catch(ex){;}",0);
		}catch(ex){;}
	}
	else
		igtbl_isFocus(gn);
}

function igtbl_globalMouseUp(evt)
{
	var g=igtbl_getGridById(igtbl_lastActiveGrid);
	if(!g) return;
	var ar=g.getActiveRow();
	if(ar && !igtbl_inEditMode(g.Id) && !igtbl_isAChildOfB(igtbl_srcElement(evt),g.MainGrid))
	{
		if(ar.IsAddNewRow)
			ar.commit();
		else
		if(ar.processUpdateRow)
			ar.processUpdateRow();
	}
}

function igtbl_isOk(g)
{
	var vis=true,e=g.Element;
	while((e=e.parentNode)!=null)
		
		if(e.tagName!=(igtbl_isXHTML?"HTML":"BODY")&&e.style!=null&&e.style.display=="none")
			vis=false;
	if((e=g._focusElem)!=null)if((e.style.display=="none")==vis)e.style.display=vis?"":"none";
	return vis;
}
function igtbl_isFocus(gn,b)
{
	var g=igtbl_getGridById(gn);
	if(g==null)
		return false;
	if(b)
		return g.oActiveCell!=null&&g.oActiveCell.Element.id==b.getAttribute("srcElement");
	
	var ae=g.oActiveCell;
	if(!ae)
		ae=g.oActiveRow;
	var activeElement=null;
	try{
	activeElement=document.activeElement;
	}catch(e){;}
	var insideEl=(ae && activeElement && ig_isAChildOfB(activeElement,ae.Element));
	
	var templOpen=ae && ae.Band.RowTemplate && igtbl_getElementById(ae.Band.RowTemplate).style.display=="";
	
	if(g._editorCurrent==null && (!insideEl || !b) && !templOpen) 
		try
		{
			g._focusElem.focus();
		}
		catch(ex){;}
	return false;
}
function igtbl_initButton(g)
{
	var b=g._editorButton;
	if(!b)
		if((g._editorButton=b=igtbl_getElementById(g.Id+"_bt"))!=null)
		{
			b.unselectable="on";
			b.tabIndex=-1;
			b.hideFocus=true;
			b.style.zIndex=9999;
			b.setAttribute("gn",g.Id);
			g._mouseWait=0;
			ig_csom.addEventListener(b,"mouseout",igtbl_editEvt);
		}
	return b;
}
function igtbl_inputEvt(evt,gn)
{
	if(gn!=null)
	{
		var g=igtbl_getGridById(gn);
		if(g==null)
			return;
		if(evt==null)
		{
			g._focus=g._focus0;
			return;
		}
		if(!g._focus)
			return;
		var e=new Object();
		e.shiftKey=evt==1;
		e.ctrlKey=evt==2;
		e.keyCode=9;
		if(g.getActiveCell()==null && g.getActiveRow()==null)
		{
			if(g.Rows!=null)
				if((e=g.Rows.getRow(0))!=null)
					if((e=e.getCell(0))!=null)
						e.activate();
			return;
		}
		igtbl_onKeyDown(e,gn,true);
		return;
	}
	if(evt==null)
		if((evt=window.event)==null)
			return;
	var src=evt.srcElement;
	if(src==null)
		if((src=evt.target)==null)
			return;
	var g=igtbl_getGridById(gn=src.getAttribute("gn")),key=evt.keyCode;
	if(g==null)
		return;
	switch(evt.type)
	{
		case "focus":
			if(!igtbl_isOk(g))
			{
				ig_cancelEvent(evt);
				return;
			}
			g._focus0=g._focus=true;
			break;
		case "blur":
			g._focus0=false;
			try
			{
				window.setTimeout("try{igtbl_inputEvt(null,'"+gn+"');}catch(ex){;}",0);
			}
			catch(ex)
			{
				g._focus=false;
			}
			
			break;
		case "keydown":
			var click=false,ac=g.oActiveCell,b=g._editorButton;
			if(ac&&(key==32||key==13))
				click=b?igtbl_isFocus(gn,b):(ac.Column.ColumnType==7&&ac.Column.CellButtonDisplay==1);
			g._mouseDown=0;
			if(click)
				igtbl_colButtonClick(evt,gn,b,ac.Element);
			if(key==9)
				try
				{
					src.removeAttribute("noOnBlur");
					if(g.oActiveCell && g.oActiveCell.getNextTabCell(evt.shiftKey,true) || g.oActiveRow && g.oActiveRow.getNextTabRow(evt.shiftKey))
					{
						ig_cancelEvent(evt);
						window.setTimeout("try{igtbl_inputEvt("+(evt.shiftKey?"1":(evt.ctrlKey?"2":"0"))+",'"+gn+"');}catch(ex){;}",10);
						break;
					}
				}
				catch(ex){;}
			else if(key==13||key==27)
			{
				src.removeAttribute("noOnBlur");
				igtbl_hideEdit(null,evt,g);
			}
			igtbl_onKeyDown(evt,gn,true);
			break;
		case "keyup":
			igtbl_onKeyUp(evt,gn);
			break;
	}
}

function igtbl_hideEdit()
{
	var oEvent=null,g=null,i=arguments.length,gn=arguments[0];
	if(i==1 && (gn!=null&&gn.substring))
		g=igtbl_getGridById(gn);
	if(i>2)
	{
		oEvent=arguments[i-2];
		g=arguments[i-1];
	}
	if(g==null)
		return;
	var evt=oEvent,elem=g._editorCurrent,key=g._lastKey;
	if(i==1)
	{
		
		if (key==114) return;
		if(key==9)
			try
			{
				window.setTimeout("try{igtbl_activate('"+gn+"');}catch(ex){;}",10);
				return;
			}
			catch(ex){;}
		if(key==9||key==13||key==27)
		{
			igtbl_activate(gn);
			return;
		}
		evt=null;
	}
	if(elem==null || elem.getAttribute("noOnBlur")) 
		return;
	var oEditor=(i==1||gn==null)?g._editorCustom:gn;
	gn=g.Id;
	if(oEditor!=null&&evt!=null)
		evt=evt.event;
	key=-3;
	if(evt!=null && evt.type=="keydown")
		g._lastKey=key=evt.keyCode;
	if(evt!=null)
		if((key==13 && (evt.shiftKey || evt.ctrlKey)) || (key!=-3 && key!=9 && key!=13 && key!=27 && key!=113))
			return;
	var cell=igtbl_getElementById(elem.getAttribute("currentCell"));
	if(cell==null)
		return;
	var cellObj=igtbl_getCellById(cell.id);
	if(cellObj==null)
		return;
	var type=elem.getAttribute("editType"),v=(oEditor!=null)?oEditor.getValue():elem.value;
	var j,colV,pgV=null,valid=(typeof(Page_Validators)!="object");
	if(!valid)
	{
		valid=true;colV=cellObj.Column.Validators;pgV=Page_Validators;
		for(j=0;j<colV.length;j++)for(i=0;i<pgV.length;i++)if(pgV[i].id==colV[j])
		{
			ValidatorValidate(pgV[i]);
			if(!pgV[i].isvalid)valid=false;
		}
		if(!valid)
		{
			var de=g.getDivElement();
			de.setAttribute("noOnScroll","true");
			de.setAttribute("oldSL",de.scrollLeft.toString());
			de.setAttribute("oldST",de.scrollTop.toString());
		}
		else
			igtbl_cancelNoOnScroll(gn);
	}
		
	
	if (!valid && typeof(Page_Validators)!="undefined")
	{
		ValidatorUpdateIsValid();		
		if (typeof(Page_ValidationSummaries)!="undefined")
			ValidationSummaryOnSubmit();
	}
	
	elem.setAttribute("noOnBlur",true);
	if(!valid || g.fireEvent(g.Events.BeforeExitEditMode,[gn,cell.id,v])==true)
	{
		
		window.setTimeout("igtbl_clearNoOnBlurElem('"+elem.id+"')",100);
		if(!g._exitEditCancel&&!g._insideSetActive)
		{
			g._insideSetActive=true;
			igtbl_setActiveCell(gn,cell);
			g._insideSetActive=false;
		}
		g._exitEditCancel=true;
		return;
	}
	elem.removeAttribute("noOnBlur");
	if(pgV!=null)for(i=0;i<pgV.length;i++)for(j=0;j<colV.length;j++)
		if(pgV[i].id==colV[j]&&pgV[i].enabled)
			ValidatorEnable(pgV[i],false);
	elem.removeAttribute("currentCell");
	g._editorCustom=g._editorCurrent=null;
	var equalsPrompt=false;
	if(oEditor!=null)
	{
		oEditor.setVisible(false);
		oEditor.removeEventListener("blur",igtbl_hideEdit);
		oEditor.removeEventListener("keydown",igtbl_hideEdit);
	}
	else
	{
		elem.style.display="none";
		if(type==0||type==1)
		{
			if(elem.style.position!="absolute")
			{
				var p=elem.parentNode;
				p.removeChild(elem);
				var i,nn=p.childNodes;
				if(nn!=null)for(i=0;i<nn.length;i++)
					if(nn[i].style!=null)nn[i].style.display="";
				i=((nn=g._oldElems)==null)?0:nn.length;
				while(i-->0)cell.appendChild(nn[i]);
				cell.style.width=cell.style.height="";
			}
		}
		else if(type==3)
		{
			
			if(!(cellObj.Column.AllowNull && cellObj.Column.ValueListPrompt==cellObj.Column.getNullText() && cellObj.Column.ValueListPrompt==elem.options[elem.selectedIndex].value ||
					elem.options[elem.selectedIndex].value!=cellObj.Column.ValueListPrompt))
				equalsPrompt=true;
		}
	}
	g._oldElems=null;
	g._exitEditCancel=false;
	if(key!=27 && cellObj._oldValue!==v && !equalsPrompt)
		cellObj.setValue(v);
	igtbl_fireEvent(gn,g.Events.AfterExitEditMode,"(\""+gn+"\",\""+cell.id+"\");");
	if(g.NeedPostBack)
	{
		igtbl_doPostBack(gn);
		return;
	}
	var start=null;
	if(key==9||key==13)
		if(typeof igtbl_ActivateNextCell=="function")
		{
			var oldAc=g.oActiveCell;
			if(key==9 && evt.shiftKey)
				start=igtbl_ActivatePrevCell(gn);
			else
				start=igtbl_ActivateNextCell(gn);
			if(!start)
			{
				igtbl_blurTimeout(gn);
				if(oldAc && oldAc.Row.IsAddNewRow)
				{
					var nac=oldAc.Row.getCell(0);
					while(nac && !nac.Column.getVisible())
						nac=oldAc.Row.getCell(nac.Column.Index+1);
					if(nac)
					{
						nac.activate();
						nac.scrollToView();
					}
				}
				else
				{
					if(key==9 && evt.shiftKey)
						start=igtbl_ActivatePrevCell(gn);
					else
						start=igtbl_ActivateNextCell(gn);
				}
			}
			else if(oldAc && oldAc.Row!=g.oActiveCell.Row && oldAc.Row.IsAddNewRow && (oldAc.Row.Band.Index>0 && oldAc.Row.Band.AddNewRowView==2 || oldAc.Row.Band.AddNewRowView==1))
			{
				var nac=oldAc.Row.getCell(0);
				while(nac && !nac.Column.getVisible())
					nac=oldAc.Row.getCell(nac.Column.Index+1);
				if(nac)
				{
					nac.activate();
					nac.scrollToView();
				}
			}
			if(!start)
				delete g._lastKey;
			if(evt!=null)
				ig_cancelEvent(evt);
		}
	if(start&&key==9 && igtbl_getCellClickAction(gn,cellObj.Column.Band.Index)==1)
		try
		{
			window.setTimeout("try{igtbl_EnterEditMode('"+gn+"');}catch(ex){;}",100);
		}
		catch(ex)
		{
			igtbl_EnterEditMode(gn);
		}
	else
		igtbl_activate(gn);
}

function igtbl_getOffsetX(evnt,e)
{
	if(ig_csom.IsIE)
		return evnt.offsetX;
	else
		return evnt.clientX-igtbl_getLeftPos(e);
}
function igtbl_getOffsetY(evnt,e)
{
	if(ig_csom.IsIE)
		return evnt.offsetY;
	else
		return evnt.clientY-igtbl_getTopPos(e);
}
function igtbl_onResize(gn)
{
	if(!ig_csom.IsIE55Plus)return;
	var gs=igtbl_getGridById(gn);
	if(!gs)return;
	var div=gs.Element.parentNode;
	if(!div) return;
	var adjHeight=0;
	if(gs._scrElem)
	{
		div=gs._scrElem;
		if(gs.MainGrid&&!gs.MainGrid.style.height)
			adjHeight=div.scrollHeight-div.clientHeight;
	}
	var oldX=div.getAttribute("oldXSize");
	var oldY=div.getAttribute("oldYSize");
	var oldTop=div.getAttribute("oldTop");
	var oldLeft=div.getAttribute("oldLeft");
	var elTop=igtbl_getTopPos(gs.Element);
	var elLeft=igtbl_getLeftPos(gs.Element);
	if(oldX==null)
	{
		div.setAttribute("oldXSize",div.offsetWidth);
		div.setAttribute("oldYSize",div.offsetHeight);
		div.setAttribute("oldTop",elTop);
		div.setAttribute("oldLeft",elLeft);
		
		
		gs.alignStatMargins();
		return;
	}
	if(oldX==div.offsetWidth && oldY==div.offsetHeight+adjHeight && oldTop==elTop && oldLeft==elLeft)
		return;
	div.setAttribute("oldXSize",div.offsetWidth);
	div.setAttribute("oldYSize",div.offsetHeight);
	div.setAttribute("oldTop",elTop);
	div.setAttribute("oldLeft",elLeft);
	if(gs.Element.getAttribute("noOnResize"))return;
	igtbl_hideEdit(gn);
	gs.alignStatMargins();
	gs.alignDivs(0,true);
	gs.endEditTemplate();
}
function igtbl_isDisabled(elem)
{
	if(ig_csom.IsIE55Plus)
		return elem.disabled;
	return elem.getAttribute("disabled") && elem.getAttribute("disabled").toString()=="true";
}
function igtbl_setDisabled(elem,b)
{
	if(ig_csom.IsIE55Plus)
		elem.disabled=b;
	else
	{
		elem.setAttribute("disabled",b);
		if(b)
		{
			if(typeof(elem.getAttribute("oldColor"))!="string")
				elem.setAttribute("oldColor",elem.style.color);
			elem.style.color="graytext";
		}
		else
		{
			if(typeof(elem.getAttribute("oldColor"))=="string")
			{
				elem.style.color=elem.getAttribute("oldColor");
				elem.removeAttribute("oldColor");
			}
			else
				elem.style.color="";
		}
	}
}

function igtbl_button(gn,evnt)
{
	if(document.all)
	{
		if(evnt.button==1)return 0;
		else if(evnt.button==4)return 1;
		else if(evnt.button==2)return 2;
		return -1;
	}
	if(evnt.button==0 && gn)
	{
		if(evnt.detail!=0)return 0;
		var gs=igtbl_getGridById(gn);
		if(gs.Element.getAttribute("mouseDown"))return 0;
		else return -1;
	}
	else if(evnt.button==1)return 1;
	else if(evnt.button==2)return 2;
	return -1;
}

function igtbl_srcElement(evt)
{
	var e=evt.srcElement;
	if(!e)e=evt.target;
	while(e&&!e.tagName)e=e.parentNode;
	return e;
}

function igtbl_styleName(sn)
{
	var r=sn.toLowerCase();
	var sa=r.split("-");
	for(var i=1;i<sa.length;i++)
		sa[i]=sa[i].charAt(0).toUpperCase()+sa[i].substr(1);
	r=sa.join("");
	return r;
}

function igtbl_changeStyle(gn,se,style)
{
	if(document.all){igtbl_changeStyleIE(gn,se,style);return;}
	var rem=false,rules=null;
	if(style==null)
	{
		style=se.getAttribute("newClass");
		if(!style)
			return;
		rem=true;
	}
	rules=new Array();
	var styles=style.split(' ');
	for(var k=0;k<styles.length;k++)
		for(var i=0;i<document.styleSheets.length;i++)
			for(var j=0;j<document.styleSheets[i].cssRules.length;j++)
				if(document.styleSheets[i].cssRules[j].selectorText=="."+styles[k])
				{
					rules[k]=document.styleSheets[i].cssRules[j];
					break;
				}
	if(rules.length==0)
	{
		igtbl_dispose(rules);
		return;
	}
	if(!rem)se.setAttribute("newClass",style);
	else se.removeAttribute("newClass");
	var s="";
	for(var k=0;k<rules.length;k++)
		for(var i=0;i<rules[k].style.length;i++)
			if(rules[k].style.item(i)!="white-space")
			{
				if(!rem)
				{
					if(se.getAttribute(rules[k].style.item(i)))
						se.setAttribute(rules[k].style.item(i),se.style[rules[k].style.item(i)]);
					se.style[igtbl_styleName(rules[k].style.item(i))]=rules[k].style.getPropertyValue(rules[k].style.item(i));
				}
				else
				{
					se.style[igtbl_styleName(rules[k].style.item(i))]=se.getAttribute(rules[k].style.item(i));
					se.removeAttribute(rules[k].style.item(i))
				}
			}
	igtbl_dispose(rules);
}
function igtbl_initEvent(se){this.srcElement=this.target=se;}
function igtbl_adjustLeft(e){return document.all?igtbl_getLeftPos(e):0;}
function igtbl_adjustTop(e){return document.all?igtbl_getTopPos(e):0;}
function igtbl_clientWidth(e)
{
	var cw=e.clientWidth;
	if(!cw)
	{
		cw=e.offsetWidth;
		if(e.scrollWidth)if(e.scrollWidth>cw)cw-=13;
	}
	return (cw>0)?cw:0;
}
function igtbl_clientHeight(e)
{
	var ch=e.clientHeight;
	if(!ch)
	{
		ch=e.offsetHeight;
		if(e.scrollHeight)if(e.scrollHeight>ch)ch-=13;
	}
	return (ch>0)?ch:0;
}

function igtbl_getInnerText(elem)
{
	if(!elem)return "";
	var txt="",nn=elem.childNodes;
	if(ig_csom.IsIEWin)try{return elem.innerText;}catch(ex){;}
	if(elem.nodeName=="#text")txt=elem.nodeValue;
	else if(elem.nodeName=="BR")txt="\r\n";
	else if(nn)for(var i=0;i<nn.length;i++)txt+=igtbl_getInnerText(nn[i]);
	var sp=String.fromCharCode(160);
	while(txt.indexOf(sp)>=0)txt=txt.replace(sp," ");
	return txt;
}

function igtbl_setInnerText(elem,txt)
{
	if(!elem)return;
	txt=(txt&&txt!="")?txt.toString():" ";
	if(ig_csom.IsIEWin)try{elem.innerText=txt;return;}catch(ex){;}
	while(txt.indexOf("\r")>=0)txt=txt.replace("\r","");
	while(txt.indexOf(" ")>=0)txt=txt.replace(" ",String.fromCharCode(160));
	var te=null,ss=txt.split("\n"),nn=elem.childNodes;
	var j=-1,i=nn.length;
	while(i-->0)
	{
		if(!te&&nn[i]&&nn[i].nodeName=="#text"){te=nn[i];te.nodeValue=te.data=ss[++j];}
		if(nn[i]!=te)elem.removeChild(nn[i]);
	}
	while(++j<ss.length)
	{
		if(j>0)elem.appendChild(document.createElement("BR"));
		try{elem.appendChild(document.createTextNode(ss[j]));}catch(ex){;}
	}
}

function igtbl_showColButton(gn,se,active)
{
	var gs=igtbl_getGridById(gn);
	if(!gs||se==null)return;
	var b=igtbl_initButton(gs),cell=gs.oActiveCell;
	if(!b)return;
	if(se=="hide")
	{
		gs._mouseWait=0;
		gs._mouseIn=null;
		if(active&&cell&&!cell.Row.GroupByRow&&cell.Column.ColumnType==7&&cell.Column.CellButtonDisplay==0)
		{
			if(b.getAttribute("srcElement")==cell.Element.id)return;
			try{window.setTimeout("try{igtbl_showColButton('"+gn+"','act');}catch(e){}",20);}catch(e){;}
		}
		if(b.style.display=="")b.style.display="none";
		return;
	}
	if(se=="act")
	{
		if(!cell||b.style.display=="")return;
		se=cell.Element;
	}
	
		
	var bandNo=null;
	var pNode=se;
	while(bandNo===null && (pNode=pNode.parentNode)!=null)
	{
		bandNo = pNode.getAttribute("bandNo");
	}
	var columnNo=igtbl_getColumnNo(gn,se);
	var column=gs.Bands[bandNo].Columns[columnNo];
	if(ig_shared.IsIE)
	{
		var md;
		if(gs.UseFixedHeaders)
		{
			md=igtbl_getElementById(gn+"_divscr");
			b.style.left=igtbl_getLeftPos(se)-igtbl_getLeftPos(md);
			t=igtbl_getTopPos(se)-igtbl_getTopPos(md);
		}
		else
		{
			md=igtbl_getElementById(gn+"_div");
			
			                    
            if (gs.IsXHTML)
            {                
                b.style.left=se.offsetLeft;
                t=se.offsetTop;
            }
            else
            {
			    b.style.left=igtbl_getLeftPos(se) - igtbl_getLeftPos(gs.Element);
			    t=igtbl_getTopPos(se) - igtbl_getTopPos(gs.Element);
            }						    
		}
		var gb=md.parentNode.parentNode.previousSibling;
		if(gb && md && md.style.overflow!="auto")
			t+=gb.offsetHeight;
		b.style.top=t+"px";
	}
	else
	{
	
		var md;
		if(gs.UseFixedHeaders)
		{
			md=igtbl_getElementById(gn+"_divscr");
			b.style.left=igtbl_getLeftPos(se)-igtbl_getLeftPos(md);
			t=igtbl_getTopPos(se)-igtbl_getTopPos(md);
			var gb=md.parentNode.parentNode.previousSibling;
			if(gb && md && md.style.overflow!="auto")
				t+=gb.offsetHeight;
			b.style.top=t+"px";
		}
		else
		{
			igtbl_scrollToView(gn,se);
			b.style.left=igtbl_getLeftPos(se)+"px";
			b.style.top=igtbl_getTopPos(se)+"px";
		}
	}
	b.style.width=igtbl_clientWidth(se)+"px";
	b.style.height=igtbl_clientHeight(se)+"px";
	b.className=column.ButtonClass;
	if(se.innerHTML==igtbl_getNullText(gn,bandNo,columnNo))
		b.value=" ";
	else if(se.firstChild.tagName=="NOBR")
		b.value=igtbl_getInnerText(se.firstChild);
	else
		b.value=igtbl_getInnerText(se);
	b.setAttribute("srcElement",se.id);
	b.style.display="";
}

function igtbl_getDocumentElement(elemID)
{
	if(ig_shared.IsIE)
	{
		var obj;
		if(document.all)
			obj=document.all[elemID];
		else
			obj=document.getElementById(elemID);
		return obj;
	}
	else
	{
		var elem=document.getElementById(elemID);
		if(elem)
		{
			var elems=document.getElementsByTagName(elem.tagName);
			var els=[];
			for(var i=0;i<elems.length;i++)
			{
				if(elems[i].id==elemID)
					els[els.length]=elems[i];
			}
			return (els && els.length == 1) ? els[0] : els;
		}
		return null;
	}
}

function igtbl_onScroll(evnt,gn)
{
	var gs=igtbl_getGridById(gn);
	if(!gs) return;
	var de=gs.getDivElement();
	if(de.getAttribute("noOnScroll"))
	{
		if(de.getAttribute("oldSL"))
			igtbl_scrollLeft(de,parseInt(de.getAttribute("oldSL")));
		if(de.getAttribute("oldST"))
			igtbl_scrollTop(de,parseInt(de.getAttribute("oldST")));
		return igtbl_cancelEvent(evnt);
	}
	igtbl_hideEdit(gn);
	igtbl_showColButton(gn,"hide");
	gs.alignStatMargins();
	gs.endEditTemplate();
	var isVertScroll=(typeof(gs._oldScrollTop)!="undefined" && gs._oldScrollTop!=de.scrollTop || typeof(gs._oldScrollTop)=="undefined" && de.scrollTop>0);
	
	if( (gs.Node || ig_csom.IsNetscape6 && gs.LoadOnDemand==3)&& !gs.AllowPaging && (gs.RowsServerLength>gs.Rows.length
		&& gs.XmlLoadOnDemandType!=2 || gs.XmlLoadOnDemandType==2 && isVertScroll
	))
		igtbl_onScrollXml(evnt,gn);
	if(gs.UseFixedHeaders)
	{
		if(typeof(gs.fhOldScrollLeft)=="undefined" && typeof(gs.fhOldScrollTop)=="undefined" || gs.fhOldScrollLeft!=gs._scrElem.scrollLeft || gs.fhOldScrollTop!=gs._scrElem.scrollTop)
		{
			gs.fhOldScrollLeft=gs._scrElem.scrollLeft;
			gs.fhOldScrollTop=gs._scrElem.scrollTop;
			if(gs.FixedColumnScrollType==2)
			{
				if(gs.alignDivsTimeoutID)
					window.clearTimeout(gs.alignDivsTimeoutID);
				gs.alignDivsTimeoutID=window.setTimeout("igtbl_doAlignDivs('"+gn+"')",250);
			}
			else
				gs.alignDivs();
		}
	}
	else if(gs.XmlLoadOnDemandType==1 || gs.XmlLoadOnDemandType>2 || !isVertScroll)
	{
		gs.alignDivs();
	}
	gs._oldScrollLeft=de.scrollLeft;
	gs._oldScrollTop=de.scrollTop;
	gs._removeChange("ScrollLeft",gs);
	gs._recordChange("ScrollLeft",gs,de.scrollLeft);
	gs._removeChange("ScrollTop",gs);
	gs._recordChange("ScrollTop",gs,de.scrollTop);
}


function igtbl_changeStyleIE(gn,se,style)
{
	if(style==null)
	{
		se.runtimeStyle.cssText="";
		return;
	}
	var te=igtbl_getGridById(gn).Element;
	var rules=null;
	if(te.getAttribute(style))
		rules=te.getAttribute(style);
	else
	{
		rules=new Array();
		var styles=style.split(' ');
		for(var k=0;k<styles.length;k++)
			for(var i=0;i<document.styleSheets.length;i++)
			{
				var bFoundStyle = false;
				for(var j=0;j<document.styleSheets[i].rules.length;j++)
					if(document.styleSheets[i].rules[j].selectorText=="."+styles[k])
					{
						bFoundStyle=true;
						rules[rules.length]=document.styleSheets[i].rules[j];
						break;
					}
				for(var j=0;!bFoundStyle && j<document.styleSheets[i].imports.length;j++)
					for(var m=0;!bFoundStyle && m<document.styleSheets[i].imports[j].rules.length;m++)
					if(document.styleSheets[i].imports[j].rules[m].selectorText=="."+styles[k])
					{
						bFoundStyle=true;
						rules[rules.length]=document.styleSheets[i].imports[j].rules[m];
						break;
					}
			}
		if(rules.length==0)
		{
			igtbl_dispose(rules);
			return;
		}
		te.setAttribute(style,rules);
	}
	se.runtimeStyle.cssText="";
	for(var i=0;i<rules.length;i++)
		se.runtimeStyle.cssText+=(se.runtimeStyle.cssText?";":"")+rules[i].style.cssText;
}

function igtbl_doAlignDivs(gn,force)
{
	var gs=igtbl_getGridById(gn);
	gs.alignDivsTimeoutID=null;
	gs.alignDivs(0,force);
}
