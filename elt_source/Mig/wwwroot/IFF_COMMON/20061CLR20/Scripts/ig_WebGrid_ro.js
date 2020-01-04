 /*
  * Infragistics WebGrid CSOM Script: ig_WebGrid_ro.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

// ig_WebGrid_ro.js
// Infragistics UltraWebGrid Script 
// Copyright (c) 2001-2006 Infragistics, Inc. All Rights Reserved.

var igtbl_isXHTML=document.compatMode=="CSS1Compat";
function igtbl_getElementById(tagId)
{
	var obj;
	if(document.all)
		obj=document.all[tagId];
	else
		obj=document.getElementById(tagId);
	if(obj && obj.length && obj[0].id==tagId)
		obj=obj[0];
	return obj;
}

function igtbl_srcElement(evnt)
{
	var se=null;
	if(evnt.srcElement)
		se=evnt.srcElement;
	else if(evnt.target)
		se=evnt.target;
	while(se && !se.tagName)
		se=se.parentNode;
	return se;
}

function igtblro_button(evnt)
{
	if(evnt.srcElement)
	{
		if(evnt.button==1)
			return 0;
		else if(evnt.button==4)
			return 1;
		else if(evnt.button==2)
			return 2;
	}
	else
		return evnt.button;
	return -1;
}

function igtbl_getLeftPos(e,cc) 
{
    var x = e.offsetLeft;
    if(e.clientLeft && cc!=false)
	    x += e.clientLeft;
    var tmpE = e.offsetParent;
    while (tmpE != null) 
    {
        x += tmpE.offsetLeft;
        if((tmpE.tagName=="DIV" || tmpE.tagName=="TD") && tmpE.style.borderLeftWidth)
	        x += parseInt(tmpE.style.borderLeftWidth);
        if(tmpE.tagName!=(igtbl_isXHTML?"HTML":"BODY") && tmpE.scrollLeft)
			x-=tmpE.scrollLeft;
		if(tmpE.clientLeft && cc!=false)
			x += tmpE.clientLeft;
        tmpE = tmpE.offsetParent;
    }
    return x;
}

function igtbl_getOffsetX(evnt,e)
{
	if(evnt.offsetX)
		return evnt.offsetX;
	return evnt.clientX-igtbl_getLeftPos(e);
}

function igtblro_toggleRow(gn,srcRow,expImg,colImg,expand)
{
	var sr = igtbl_getElementById(srcRow);
	var hr = sr.nextSibling;
	if(hr.getAttribute("hiddenRow"))
	{
		if(hr.style.display == "none" && expand!=false)
		{
			hr.style.display = "";
			sr.childNodes[0].childNodes[0].src=colImg;
		}
		else if(expand!=true)
		{
			hr.style.display = "none";
			sr.childNodes[0].childNodes[0].src=expImg;
		}
	}
}

var igtbl_resizeColumnId="";
function igtblro_headerClickDown(evnt)
{
	var se=igtbl_srcElement(evnt);
	while(se && se.tagName!="TH")
		se=se.parentNode;
	if(!se || !se.id || se.id=="")
		return;
	if(igtbl_getOffsetX(evnt,se)>(se.clientWidth?se.clientWidth:se.offsetWidth)-4 && se.getAttribute("resizable"))
	{
		igtbl_resizeColumnId=se.id;
		if(se.parentNode.parentNode.getAttribute("stationary"))
			igtblro_prepareColumnResize(se);
		else
		{
			var cg=se.parentNode.parentNode.previousSibling;
			if(cg)
			{
				for(var i=0;i<cg.childNodes.length;i++)
					if(!cg.childNodes[i].width)
						cg.childNodes[i].oldWidth=cg.childNodes[i].offsetWidth;
				cg.parentNode.style.width="";
				for(var i=0;i<cg.childNodes.length;i++)
				{
					if(cg.childNodes[i].oldWidth)
					{
						cg.childNodes[i].style.width="";
						cg.childNodes[i].width=cg.childNodes[i].oldWidth;
					}
				}
	}
		}
		return;
	}
}

function igtblro_headerClickUp(evnt,gn)
{
	var se=igtbl_srcElement(evnt);
	while(se && se.tagName!="TH")
		se=se.parentNode;
	if(!se || !se.id || se.id=="")
		return;
	if(igtbl_resizeColumnId!="")
	{
		igtbl_resizeColumnId="";
		var cursorName = se.getAttribute("oldCursor");
		if(cursorName != null)
		{
			se.style.cursor=cursorName;
			se.removeAttribute("oldCursor");
		}
	}
	else if(se.getAttribute("sortable"))
		__doPostBack(gn,"Sort:"+se.getAttribute("sortable")+":"+evnt.shiftKey);
	return true;
}

function igtblro_headerMouseMove(evnt)
{
	var se=igtbl_srcElement(evnt);
	while(se && se.tagName!="TH")
		se=se.parentNode;
	if(!se || !se.id || se.id=="")
		return;
	var btn=igtblro_button(evnt);
	if(igtbl_resizeColumnId!="" && btn==0)
	{
		var column = igtbl_getElementById(igtbl_resizeColumnId);
		if(!column)
			return;
		var resCol=column;
		var cg=se.parentNode.parentNode.previousSibling;
		var co=resCol;
		if(cg)
			co=cg.childNodes[column.cellIndex];
		var c1w=co.offsetWidth+(evnt.clientX-(igtbl_getLeftPos(resCol)+co.offsetWidth));
		igtblro_resizeColumn(resCol.id,c1w);
		var cursorName = se.getAttribute("oldCursor");
		if(cursorName == null)
			se.setAttribute("oldCursor", se.style.cursor);
		se.style.cursor="w-resize";
	}
	else 
	{
		if(igtbl_getOffsetX(evnt,se)>(se.clientWidth?se.clientWidth:se.offsetWidth)-4 && se.getAttribute("resizable"))
		{
			var cursorName = se.getAttribute("oldCursor");
			if(cursorName == null)
				se.setAttribute("oldCursor", se.style.cursor);
			se.style.cursor="w-resize";
		}
		else
		{
			var cursorName = se.getAttribute("oldCursor");
			if(cursorName != null)
			{
				se.style.cursor=cursorName;
				se.removeAttribute("oldCursor");
			}
		}
	}
	return true;
}

function igtblro_tableMouseMove(evnt,gn)
{
	var se=igtbl_srcElement(evnt);
	if(!se)
		return false;
	var te=igtbl_getElementById("G_"+gn);
	if(igtblro_button(evnt)==0 && igtbl_resizeColumnId!="")
	{
		if((se.id==gn+"_div" || se.id==gn+"_hdiv" || se.tagName=="TABLE" && se.parentNode.parentNode.getAttribute("hiddenRow") || se.tagName=="TD" && se.parentNode.getAttribute("hiddenRow")))
		{
			if(typeof(te.parentNode.oldCursor)!="string")
			{
				te.parentNode.oldCursor=te.parentNode.style.cursor;
				te.parentNode.style.cursor="w-resize";
			}
			var column=igtbl_resizeColumnId;
			var resCol=igtbl_getElementById(column);
			var cg=se.childNodes[0];
			if(se.id==gn+"_div" || se.tagName=="TD")
				cg=cg.childNodes[0];
			else if(se.id==gn+"_hdiv")
				cg=cg.childNodes[0].childNodes[0];
			if(!cg)
				return false;
			var co=cg.childNodes[resCol.cellIndex];
			var c1w=evnt.clientX-igtbl_getLeftPos(resCol);
			igtblro_resizeColumn(resCol.id,c1w);
			if(evnt.cancelBubble)
				evnt.cancelBubble=true;
			if(evnt.returnValue)
				evnt.returnValue=false;
			return false;
		}
	}
	else if(typeof(te.parentNode.oldCursor)=="string")
	{
		te.parentNode.style.cursor=te.parentNode.oldCursor;
		te.parentNode.oldCursor=null;
	}
}

function igtblro_tableMouseUp(evnt,gn)
{
	var se=igtbl_srcElement(evnt);
	if(se.id==gn+"_div" && igtbl_resizeColumnId!="")
		igtbl_resizeColumnId="";
}

function igtblro_resizeColumn(colId,width)
{
	var res=false;
	var colObj=igtbl_getElementById(colId);
	if(!colObj)
		return res;
	var c1w=width;
	if(c1w>0)
	{
		var columns=null;
		if(document.all)
			columns=document.all[colObj.id];
		else
			columns=document.getElementById(colObj.id);
		if(columns.length)
			for(var i=0;i<columns.length;i++)
			{
				var cg=columns[i].parentNode.parentNode.previousSibling;
				if(cg)
					cg.childNodes[colObj.cellIndex].width=c1w;
				else
					columns[i].style.width=c1w;
			}
		else
		{
			var cg=colObj.parentNode.parentNode.previousSibling;
			if(cg)
				cg.childNodes[colObj.cellIndex].width=c1w;
			else
				colObj.width=c1w;
		}
	}
	return res;
}
