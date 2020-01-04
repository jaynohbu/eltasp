 /*
  * Infragistics WebListBar CSOM Script: ig_weblistbarASC.js
  * Version 6.1.20061.28
  * Copyright(c) 2001-2006 Infragistics, Inc. All Rights Reserved.
  */

var ig_ScrollInterval;
var ig_lbar;
var ig_delayTimer;
var startPostion;
var deltaY;
function iglbar_autoScroll(listbar){
	ig_lbar=listbar;
	ig_lbar.style.position="absolute";
	startPosition=iglbar_getStartPosition(listbar);
	ig_lbar.style.top=startPosition.y;
	if(!deltaY)deltaY=parseInt(startPosition.y);
	window.clearTimeout(ig_delayTimer);
	window.setTimeout("ig_startScrollInterval();",120);
}
function ig_startScrollInterval()
{
	window.clearInterval(ig_ScrollInterval);
	ig_ScrollInterval = window.setInterval('ig_adjustY();', 1);
}
function iglbar_getStartPosition(el){
	for (var lx=0,ly=0;el!=null;lx+=(el.offsetLeft-el.scrollLeft),ly+=(el.offsetTop-el.scrollTop),el=el.offsetParent);
	return {x:lx+(window.pageXOffset?window.pageXOffset:(document.body.scrollLeft?document.body.scrollLeft:0)),y:(ly+(window.pageYOffset?window.pageYOffset:(document.body.scrollTop?document.body.scrollTop:0)))}
}
function ig_adjustY()
{
	var scrollTop = parseInt(document.body.scrollTop)+deltaY;
	var controlTop = parseInt(ig_lbar.style.top);
	if(scrollTop == controlTop)
	{
		clearInterval(ig_ScrollInterval);
	}
	else if(controlTop < scrollTop)
	{
		if((scrollTop - controlTop) <= 5)
		{
			ig_lbar.style.top = controlTop + 1;
		}
		else
		{
			ig_lbar.style.top = parseInt(controlTop + ((scrollTop - controlTop) / 5));
		}
	}
	else
	{
		if((controlTop - scrollTop) <= 5)
		{
			ig_lbar.style.top = controlTop - 1;
		}
		else
		{
			ig_lbar.style.top = parseInt(controlTop - ((controlTop - scrollTop) / 5));
		}
	}
}
