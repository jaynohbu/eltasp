 /*
  * Infragistics WebHtmlEditor CSOM Script: ig_htmleditor_upload.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */
var iged_obj=null;
var iged_update=false;
var iged_loadTime=0;
var iged_clrChange=false;
function iged_el(id,doc){return document.getElementById(id);}
function iged_loadImg(src)
{
	if(!src)
	{
		if((iged_obj=opener.iged_all._curImg)==null)return;
		iged_update=true;
	}
	else
	{
		iged_obj=document.createElement("IMG");
		if(src.charAt(0)!="/")src=opener.iged_prPath+src;
		src=opener.iged_replaceS(src,"//","/");
		iged_obj.src=src;
	}
	setTimeout("iged_showImg()",100);
}
function iged_showImg()
{
	if(!iged_obj)return;
	iged_loadTime+=100;
	if(iged_obj.complete||iged_loadTime>1000)
	{
		iged_writeStr(iged_imgStr());
		iged_imgFields();
	}
	else setTimeout("iged_showImg()",100);
}
function iged_imgStr()
{
	var img=iged_obj;
	if(!img)return null;
	var s="<IMG src='"+img.src+"'";
	var v=img.alt;if(v!=""&&v)s+=" alt='"+v+"'";
	v=img.height;if(v!=""&&v)s+=" height='"+v+"'";
	v=img.width;if(v!=""&&v)s+=" width='"+v+"'";
	v=img.border;if(v!=""&&v)s+=" border='"+v+"'";
	v=img.align;if(v!=""&&v)s+=" align='"+v+"'";
	return s+" />";
}
function iged_updateImg(noFrame)
{
	var v=iged_el("imageUrl").value;
	if(v=="")return null;
	var img=document.createElement("IMG");
	img.src=v;
	img.alt=iged_el("imageAltText").value;
	v=iged_el("imageHeight").value;if(v!="")img.height=v;
	v=iged_el("imageWidth").value;if(v!="")img.width=v;
	v=iged_el("imageBorder").value;if(v!="none")img.border=v;
	v=iged_el("imageAlign").value;if(v!="none")img.align=v;
	iged_obj=img;
	img=iged_imgStr();
	if(!noFrame)iged_writeStr(img);
	return img;
}
function iged_imgFields()
{
	var i,img=iged_obj;
	if(!img)return;
	iged_el("imageUrl").value=img.src;
	iged_el("imageHeight").value=img.height;
	iged_el("imageWidth").value=img.width;
	iged_el("imageAltText").value=img.alt;
	var o=iged_el("imageBorder").options;
	for(i=0;i<o.length;i++)if(o[i].value==img.border)o[i].selected=true;
	o=iged_el("imageAlign").options;
	for(i=0;i<o.length;i++)if(o[i].value==img.align)o[i].selected=true;
}
function iged_insImg()
{
	var txt=iged_updateImg(true);
	if(txt==""){window.close();return;}
	var img=iged_obj,o=opener.iged_all._cur;
	if(iged_update)
	{
		if(document.all)opener.iged_doImgUpdate(txt);
		else opener.iged_doImgUpdate(img);
	}
	else
	{
		if(document.all)opener.iged_insText(txt,false,false);
		else
		{
			if(opener.iged_replaceS(opener.iged_getEditTxt(),"\r\n","")=="<br>"&&o)o.setText("<p>");
			opener.iged_insNodeAtSel(img);
		}
	}
	window.close();
}
function iged_postUpload(arg)
{
	iged_saveXY();
	var f=document.forms[0];
	if(!f)return;
	if(f.FileAction)f.FileAction.value=arg;
	f.submit();   
}
function iged_saveXY()
{
	iged_el("iged_upload_left_field").value=this.screenLeft;
	iged_el("iged_upload_top_field").value=this.screenTop;
}
function iged_onBackClr()
{
	var e=iged_el("backgroundColor"),o=opener.iged_all._cur;
	if(o&&e){o._clrDrop(e,window.document);iged_clrChange=true;}
}
function iged_loadFlash(src)
{
	var v=iged_el("flashSource"),fl=document.createElement("EMBED");
	iged_clrChange=false;
	if(!src)src=v.value;
	fl.src=src;
	fl.type="application/x-shockwave-flash";
	v.value=src;
	v=iged_el("htmlAlign").value;if(v!=""&&v!="none")fl.align=v;
	v=iged_el("flashWidth").value;if(v!="")fl.width=v;
	v=iged_el("flashHeight").value;if(v!="")fl.height=v;
	v=iged_el("backgroundColor").value;if(v!="none")fl.bgColor=v;
	v=iged_el("flashAlign").value;if(v!=""&&v!="none")fl.salign=v;
	v=iged_el("flashQuality").value;if(v!="")fl.quality=v;
	v=document.forms[0].radLoop;
	if(v&&v[0])v=v[0].checked;else v=false;
	fl.loop=v;
	v=document.forms[0].radMenu;
	if(v&&v[0])v=v[0].checked;else v=false;
	fl.menu=v;
	fl.setAttribute("pluginspage", "http://www.macromedia.com/go/getflashplayer");
	iged_obj=fl;
	iged_writeStr(iged_flashStr());
}
function iged_insFlash()
{
	if(iged_clrChange)iged_loadFlash();
	if(iged_obj)
	{
		if(document.all)opener.iged_insText(iged_obj.outerHTML,false,false);
		else opener.iged_insNodeAtSel(iged_obj);
	}
	window.close();
}
function iged_flashStr()
{
	var fl=iged_obj;
	if(!fl)return "";
	var s="<EMBED pluginspage='http://www.macromedia.com/go/getflashplayer'";
	var v=fl.align;if(v!=""&&v)s+=" align='"+v+"'";
	v=fl.src;if(v!=""&&v)s+=" src='"+v+"'";
	v=fl.width;if(v!=""&&v)s+=" width='"+v+"'";
	v=fl.height;if(v!=""&&v)s+=" height='"+v+"'";
	s+=" type='application/x-shockwave-flash'";
	v=fl.menu;if(v!=""&&v)s+=" menu='"+v+"'";
	v=fl.loop;if(v!=""&&v)s+=" loop='"+v+"'";
	v=fl.quality;if(v!=""&&v)s+=" quality='"+v+"'";
	v=fl.salign;if(v!=""&&v)s+=" salign='"+v+"'";
	v=fl.bgcolor;if(v!=""&&v)s+=" bgcolor='"+v+"'";
	s+="/>";
	return s;
}
function iged_loadMedia(src)
{
	var v=iged_el("mediaSource"),md=document.createElement("EMBED");
	if(!src)src=v.value;
	md.src=src;
	md.type="application/x-mplayer2";
	v.value=src;
	v=iged_el("mediaAlign").value;if(v!=""&&v!="none")md.align=v;
	v=iged_el("mediaWidth").value;if(v!="")md.width=v;
	v=iged_el("mediaHeight").value;if(v!="")md.height=v;
	iged_obj=md;
	iged_writeStr(iged_mediaStr());
}
function iged_insMedia()
{
	if(iged_obj)
	{
		if(document.all)opener.iged_insText(iged_obj.outerHTML,false,false);
		else opener.iged_insNodeAtSel(iged_obj);
	}
	window.close();
}
function iged_mediaStr()
{
	var md=iged_obj;
	if(!md)return "";
	var s="<EMBED type='application/x-mplayer2'";
	var v=md.align;if(v!=""&&v)s+=" align='"+v+"'";
	v=md.src;if(v!=""&&v)s+=" src='"+v+"'";
	v=md.width;if(v!=""&&v)s+=" width='"+v+"'";
	v=md.height;if(v!=""&&v)s+=" height='"+v+"'";
	return s+" />";
}
function iged_writeStr(s)
{
	var d=null,e=iged_el("iged_preview");
	if(e)if((d=e.contentDocument)==null)if((e=e.contentWindow)!=null)d=e.document;
	if(!d)return;
	d.clear();d.open();d.write(s);d.close();
}
function iged_loadFile(src){var e=iged_el("iged_preview");if(e)e.src=src;}
